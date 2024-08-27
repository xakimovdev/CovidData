--CREATE DATABASE PortfolioPorject
--USE PortfolioPorject

SELECT *
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM dbo.CovidVaccinations
--ORDER BY 3,4

SELECT [Location], [date], total_cases, new_cases, total_deaths, [population]
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at Total Cases and Total Deaths

SELECT [Location], [date], total_cases, total_deaths, 
       (CAST(total_deaths as float)/CAST(total_cases as float))*100 as DeathPercentage
FROM dbo.CovidDeaths
WHERE location = 'Uzbekistan'
AND continent IS NOT NULL
ORDER BY 1,2


-- Looking at Total Cases vs Populations
-- Show what percentage of the population got Covid

SELECT [Location], [date], population, total_cases,  
       (CAST(total_cases as float)/population)*100 as PercentPopulationInfected
FROM dbo.CovidDeaths
WHERE location = 'Uzbekistan'
AND continent IS NOT NULL
ORDER BY 1,2


-- Looking at Countries with the highest infection rate compared to the population

SELECT [Location]
      ,population
      ,MAX(CAST(total_cases AS INT)) as HighestInfectionCount
      ,MAX((CAST(total_cases AS FLOAT)/population))*100 as PercentPopulationInfected
FROM dbo.CovidDeaths
--WHERE location = 'Uzbekistan'
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationInfected desc


-- Showing Countries with the Highest Death Count per Population

SELECT [Location]
      ,MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM dbo.CovidDeaths
--WHERE location = 'Uzbekistan'
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY TotalDeathCount desc


-- Break things down by continent

-- Showing continents with the highest death count per population

SELECT continent
      ,MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM dbo.CovidDeaths
--WHERE location = 'Uzbekistan'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount desc



-- Looking at the Total Population and Vaccinations

SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
FROM dbo.CovidDeaths d
JOIN dbo.CovidVaccinations v
ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY 2,3



-- Using CTE

;WITH popvsvac as(
		   SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
			  ,SUM(CONVERT(bigint, v.new_vaccinations)) OVER (PARTITION BY d.Location ORDER BY d.location, d.date) 
			       as RollingPeopleVaccinated
		   FROM dbo.CovidDeaths d
		   JOIN dbo.CovidVaccinations v
		   ON d.location = v.location AND d.date = v.date
		   WHERE d.continent IS NOT NULL
		   --ORDER BY 2,3
                 )
SELECT *, (RollingPeopleVaccinated/population)*100
FROM popvsvac


