Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151Ab2ILPhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:37:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63037 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab2ILPhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:37:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rajanikanth HV <rajanikanth.hv@stericsson.com>
Subject: Re: Implement devicetree support for AB8500 Btemp
Date: Wed, 12 Sep 2012 15:36:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Rajanikanth HV <rajanikanth.hv@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "STEricsson_nomadik_linux" <STEricsson_nomadik_linux@list.st.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>
References: <CAB4BAktQz5MY_AHHWUAhRp7HtEzC3v8uFbP0enx1b7ibJLoZ4Q@mail.gmail.com> <201209111122.08713.arnd@arndb.de> <50509D1C.9060206@stericsson.com>
In-Reply-To: <50509D1C.9060206@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201209121536.56346.arnd@arndb.de>
X-Provags-ID: V02:K0:RHdbgwsi2FTidNCeq7rP13U5nmh61Lfn3gvndluOqgB
 Kj5u06137sKp8fuMVj1j2mBlTyJhAHzZamhA/8u/MplgBnUVez
 nhXk/fSbP5INi0pTQTUvwXTLoKiO8yo8EfiRxBwWajs46NzrzC
 y1NqroudRz0rdQGmuFWqI16H8EsLf42/8GzWrGWtmdRJl24oEY
 eAAjcleZPwY+2sCqC8nbPWFYjIyvGLFKpw9m48zbC1fuCgRkU4
 XjpFMzx97I2V+CPgAn+/MeNsurzTM+NnanNmjaKoroNwWb7QSN
 rk0CTXLnkg4GsIpNWdk9RhMg4MRsRz2zCzPvv/RcUe4W58s2NI
 F1RUWU98Vldc6OhevoL8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2012, Rajanikanth HV wrote:
> On Tuesday 11 September 2012 04:52 PM, Arnd Bergmann wrote:
> > On Tuesday 11 September 2012, Rajanikanth HV wrote:

> Consider: USB charging:
>             ______________________
>            |                      |
> --(Vbus)-->|   USB Charger with   |
>            |  Charger FSM (h/w)   |
>            |______________________|
>                 |    |
>                 |    |(Vbat and other signals)
>                 |  __|_____
>         to      | |        |(GaugeSense
>      Charger FSM| | LION   | Signal)     _____________
>                 | |Battery |----------->|FuelGauge blk|
>                 | |________|            |{Coulomb Ctr}|
>                 |       |                -------------
>                 |   <Thermistor>
>                 |       |
>                 |       | (BatCtrl Signal)
>                 |_______|---------->[Btemp blk]
>                         |               |
>                       [ADC]             |__Btemp_Low
>                                         |__Btemp_Med
>                                         |__Btemp_High
> 
> Note: Charging algorithm is a logical entity.
> 
>  and what their purpose is?
> a) Coulomb counter comprises '12bit adc' and an 'N sample
> average/accumulation' logic helps to measure battery capacity
> Note: The charge and the discharge current of the battery is
>         converted to voltage by an external resistor connected
>         between GaugeSenseP and GaugeSenseN pins.
> 
> b) Battery temperature monitoring comprises a comparator which is
>    enabled only by HW (charger state machine) helps to measure
>    the thermal threshold
> Note: The accuracy of the battery temperature measurement depends
>         of the accuracy of the thermistor used.
> 
> c) Charger provides 'Constant Current Constant Voltage' USB and
>    Main(Wall) Charging support, it embeds: voltage detection,
>    thermal protection, Constant voltage charging with programmable level,
>    clock dithering and battery voltage monitoring
> 
> e.g. Correlation between charger and Btemp
> - if the battery temperature is higher than “MaxTemp °C,
>   the charger does not start, but is enabled
> 
> - if the battery temperature is between 0°C and “MaxTemp” °C
>   charging is done in AB8500 Hardware control mode
> 
> - charging is done in DB8500 Software control mode, if the battery:
>   has a voltage higher than the “BattOK Threshold
> 
> - If the battery temperature is between -10°C and 0°C:
>   charging is done in AB8500 Hardware control mode
> 
> - If the battery temperature is below -10°C, charging is
>   done in AB8500 Hardware control mode


Ok, thanks for the explanation, this is starting to make a lot more
sense. So the three blocks (fb, btemp, charger) are all separate
mfd cells, each with their own register set in ab8500 and a separate
driver in drivers/power, right?

Then there is the ab8500-charalg driver which I guess is implementing
the Charger FSM you mention above, but it doesn't have any registers
in the ab8500 but rather ties the other drivers together.

If this is true, I don't understand what makes the 'supplied-to'
properties you list in the device tree binding board specific. Are
they not always done the same way? If so, you could just leave them
out.

What does indeed seem to be needed is a place to identify the battery
type, but it's not clear if the btemp device is the best place for
that (maybe it is). For this, I would suggest you give a list of
possible batteries and require a property such as

 st-ericsson,battery-type: A string identifier for the type of battery,
			   which impacts how an operating system interpret
			   the sensor readings. Possible values include:
	* "none"	-- no battery connected
	* "li-ion-9100" -- Type 9100 Li-ION battery
	* <add any others that apply here>

	Arnd
