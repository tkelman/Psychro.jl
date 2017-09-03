#=
This file actually implements the user interface of the Psychro library.
=#



function volume(::Type{DryAir}, Tk, P)
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"
    volumeair(Tk, P)
end


function molarvolume(::Type{DryAir}, Tk, P)
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"
    molarvolumeair(Tk, P)
end
    
   
function density(::Type{DryAir}, Tk, P)
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"
    1.0/volumeair(Tk, P)
end

function enthalpy(::Type{DryAir}, Tk, P)
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"
    enthalpyair(Tk, P)
end

function molarenthalpy(::Type{DryAir}, Tk, P)
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"
    molarenthalpyair(Tk, P)
end

function entropy(::Type{DryAir}, Tk, P)
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"
    entropyair(Tk, P)
end

function molarentropy(::Type{DryAir}, Tk, P)
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"
    molarentropyair(Tk, P)
end

function compressfactor(::Type{DryAir}, Tk, P)
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"
    P*molarvolumeair(Tk, P) / (R*Tk)
end

function volume(::Type{Vapor}, Tk)
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    volumevapor(Tk)
end
    
function molarvolume(::Type{Vapor}, Tk)
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    molarvolvapor(Tk)
end

function density(::Type{Vapor}, Tk)
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    1/volumevapor(Tk)
end

function enthalpy(::Type{Vapor}, Tk)
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    enthalpyvapor(Tk)
end

function molarenthalpy(::Type{Vapor}, Tk)
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    enthalpyvapor(Tk)*Mv
end

function molarentropy(::Type{Vapor}, Tk)
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    molarentropyvapor(Tk)
end

function entropy(::Type{Vapor}, Tk)
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    entropyvapor(Tk)
end

function compressfactor(::Type{Vapor}, Tk)
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    Zvapor(Tk)
end



"""
    molarfrac(Tk, HumidityType, x, P)

Calculates the molarfraction of water vapor given a humidity parameter.
The humidity parameter can be one of the following:

 * `MolarFrac` - Identity function basically...
 * `RelHum` - Relative humidity in decimal notation (not percentage!)
 * `DewPoint`- Dew point temperature in K
 * `HumRat` - Humidity ration, kg of vapor / kg of dry air
 * `MassFrac` - Mass fraction of water vapor = mv / (mv + ma)
 * `WetBulb` - Wet bulb temperature in K- estimated by the adiabatic saturation temperature.
 
As usual all calculations are performed using plain SI units. 
The parameters used by this function are:

 * `Tk` - Temperature in K
 * Humidity type - a type listed above that characterizes the humidity
 * The value of the humidity parameter. 
 * P - Pressure in Pa
"""
function molarfrac(Tk, ::Type{MolarFrac}, xv, P)
    xv
end

function molarfrac(Tk, ::Type{HumRat}, w, P)
    w  / (Mv/Ma + w)
end

function molarfrac(Tk, ::Type{MassFrac}, r, P)
    r * Ma / (Mv + r*(Ma - Mv))
end

function molarfrac(Tk, ::Type{RelHum}, rel, P)
    xv = rel * efactor(Tk, P) * Pws(Tk) / P
end

function molarfrac(Tk, ::Type{DewPoint}, D, P)
    xv = efactor(D,P) * Pws(D) / P
end

function molarfrac(Tk, ::Type{WetBulb}, B, P)
    w = calc_W_from_B(Tk, B, P)
    w / (Mv/Ma + w)
end

function volume(::Type{MoistAir}, Tk, ::Type{T}, y, P) where {T<:PsychroProperty}
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15! K"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"

    xv = molarfrac(Tk, T, y, P)
    volumemoist(Tk, P, xv)
end

function molarvolume(::Type{MoistAir}, Tk, ::Type{T}, y, P) where {T<:PsychroProperty}
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15! K"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"

    xv = molarfrac(Tk, T, y, P)
    molarvolumemoist(Tk, P, xv)
end

function density(::Type{MoistAir}, Tk, ::Type{T}, y, P) where {T<:PsychroProperty}
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"

    xv = molarfrac(Tk, T, y, P)
    M = xv*Mv + (1-xv)*Ma
    vm = molarvolumemoist(Tk, P, xv)
    return M/vm
end


function enthalpy(::Type{MoistAir}, Tk, ::Type{T}, y, P) where {T<:PsychroProperty}
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"

    xv = molarfrac(Tk, T, y, P)
    enthalpymoist(Tk, P, xv)
end

function molarenthalpy(::Type{MoistAir}, Tk, ::Type{T}, y, P) where {T<:PsychroProperty}
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"

    xv = molarfrac(Tk, T, y, P)
    molarenthalpymoist(Tk, P, xv)
end

function entropy(::Type{MoistAir}, Tk, ::Type{T}, y, P) where {T<:PsychroProperty}
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"

    xv = molarfrac(Tk, T, y, P)
    entropymoist(Tk, P, xv)
end

function molarentropy(::Type{MoistAir}, Tk, ::Type{T}, y, P) where {T<:PsychroProperty}
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"

    xv = molarfrac(Tk, T, y, P)
    molarentropymoist(Tk, P, xv)
end

function compressfactor(::Type{MoistAir}, Tk, ::Type{T}, y, P) where {T<:PsychroProperty}
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"

    xv = molarfrac(Tk, T, y, P)
    Zmoist(Tk, P, xv)
end

function calcdewpoint(Tk, P, xv, EPS=1e-9, MAXITER=100)
    # Use Ideal Gas to 
    D = Tws(xv*P)
    Dnew = D

    for i = 1:MAXITER
        f = efactor(D, P)
        Dnew = Tws(xv*P/f)
        if abs(D-Dnew) < EPS
            return Dnew
        end
        D = Dnew
    end
    return Dnew
end

function dewpoint(::Type{MoistAir}, Tk, ::Type{T}, y, P) where {T<:PsychroProperty}
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"

    if T==DewPoint
        return y
    end
    
    xv = molarfrac(Tk, T, y, P)
    D = calcdewpoint(Tk, P, xv)
    return D
end


function relhum(::Type{MoistAir}, Tk, ::Type{T}, y, P) where {T<:PsychroProperty}
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"

    if T==RelHum
        return y
    end
    
    xv = molarfrac(Tk, T, y, P)
    xv * P / (efactor(Tk, P) * Pws(Tk))
end



function calcwetbulb(Tk, P, xv, EPS=1e-8, MAXITER=200)

    w = humrat(xv)

    B = Tk - 1.0 # Initial guess
    h = 1e-7
    for i = 1:MAXITER
        f = aux_WB(w, Tk, B, P)
        df = (aux_WB(w, Tk, B + h, P) - f) / h
        dB = -f/df
        B = B + dB

        if abs(dB) < EPS
            return B
        end
    end

    return B  # Later on I will have to check covergence.
      
end


function wetbulb(::Type{MoistAir}, Tk, ::Type{T}, y, P) where {T<:PsychroProperty}
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"

    if T==WetBulb
        return y
    end
    xv = molarfrac(Tk, T, y, P)

    B = calcwetbulb(Tk, P, xv)
    return B
    
end



humrat(xv) = xv / (1-xv) * (Mv/Ma)
function humrat(::Type{MoistAir}, Tk, ::Type{T}, y, P) where {T<:PsychroProperty}
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"

    if T==HumRat
        return y
    end
    
    xv = molarfrac(Tk, T, y, P)
    return humrat(xv)
end

function molarfrac(::Type{MoistAir}, Tk, ::Type{T}, y, P) where {T<:PsychroProperty}
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"

    if T==MolarFrac
        return y
    end
    
    xv = molarfrac(Tk, T, y, P)
    return xv
end


function massfrac(::Type{MoistAir}, Tk, ::Type{T}, y, P) where {T<:PsychroProperty}
    @assert 173.1 < Tk < 473.2 "Out of range error: Temperature should be between 173.15 K and 473.15 K!"
    @assert 0 <= P < 5e6 "Out of range error: Pressure should be below 5×10⁶ Pa"

    if T==MassFrac
        return y
    end
    xv = molarfrac(Tk, T, y, P)
    return xv*Mv / ( (1-xv)*Ma + xv*Mv )
    
end


