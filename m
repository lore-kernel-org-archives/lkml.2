Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab2IMNcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:32:07 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:49562 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751888Ab2IMNcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:32:05 -0400
Message-ID: <5051E02B.5040703@stericsson.com>
Date: Thu, 13 Sep 2012 19:01:23 +0530
From: Rajanikanth HV <rajanikanth.hv@stericsson.com>
Organization: st.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rajanikanth HV <rajanikanth.hv@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>
Subject: Re: Implement devicetree support for AB8500 Btemp
References: <CAB4BAktQz5MY_AHHWUAhRp7HtEzC3v8uFbP0enx1b7ibJLoZ4Q@mail.gmail.com> <201209111122.08713.arnd@arndb.de> <50509D1C.9060206@stericsson.com> <201209121536.56346.arnd@arndb.de>
In-Reply-To: <201209121536.56346.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wednesday 12 September 2012 09:06 PM, Arnd Bergmann wrote:
> On Wednesday 12 September 2012, Rajanikanth HV wrote:
>> On Tuesday 11 September 2012 04:52 PM, Arnd Bergmann wrote:
>>> On Tuesday 11 September 2012, Rajanikanth HV wrote:
> 
>> Consider: USB charging:
>>             ______________________
>>            |                      |
>> --(Vbus)-->|   USB Charger with   |
>>            |  Charger FSM (h/w)   |
>>            |______________________|
>>                 |    |
>>                 |    |(Vbat and other signals)
>>                 |  __|_____
>>         to      | |        |(GaugeSense
>>      Charger FSM| | LION   | Signal)     _____________
>>                 | |Battery |----------->|FuelGauge blk|
>>                 | |________|            |{Coulomb Ctr}|
>>                 |       |                -------------
>>                 |   <Thermistor>
>>                 |       |
>>                 |       | (BatCtrl Signal)
>>                 |_______|---------->[Btemp blk]
>>                         |               |
>>                       [ADC]             |__Btemp_Low
>>                                         |__Btemp_Med
>>                                         |__Btemp_High
>>
>> Note: Charging algorithm is a logical entity.
> Ok, thanks for the explanation, this is starting to make a lot more
> sense. So the three blocks (fb, btemp, charger) are all separate
> mfd cells, each with their own register set in ab8500 and a separate
> driver in drivers/power, right?
Correct, You can have a look at ab8500 spec:
www.stericsson.com/developers/CD00291561_UM1031_AB8500_user_manual-rev5_CTDS_public.pdf
> 
> Then there is the ab8500-charalg driver which I guess is implementing
> the Charger FSM you mention above,
ab8500-charalg does not implements charger FSM, Charger FSM is a
hardware block for which any functional info is not available in the
spec. However, ab8500-charalg implements state m/c depicted in the
figure (9) of spec, implementation can be found in the code:
abx500_chargalg.c: centered around abx500_chargalg_algorithm(..)

Let me brief out what 'charger(Wall/USB)' and 'chargalg' driver does:

(a) Charger driver implements:
	- events specific to Wall(a/c) and USB Charger
	- power supply attributes handling and notification
	  to power_supply core. Ref: enum power_supply_property
	  linux/power_supply.h
	  Note: subset of power_supply_property are handled	
	- turn on/off charging led, AC and USB charging
	- Regulating Voltage and Current values for charging
	- voltage threshold check
	- Charging regulation based on btemp
all this functionality has register dependency

(b) Charging algorithm:
	- Starts by collecting power_supply properties across power
          class devices which are 'bm' devices
	- Maintains the different charging states across ac and usb
	  charging process pertaining to 'Vbus, main or Vbat', thermal,
	  btemp etc.,	
	- Implements subset of power_suppply_class properties	
Note: Do not have direct register interface

 but it doesn't have any registers
yes, but make use of power supply properties updated by other bm devs
while managing charging states.
> in the ab8500 but rather ties the other drivers together.
> 
> If this is true, I don't understand what makes the 'supplied-to'
> properties you list in the device tree binding board specific. Are
> they not always done the same way? If so, you could just leave them
> out.
Precisely 'supplied-to' is not board specific, it was maintained as
platform_data which i migrated to dt-node. It is meant to establish
dependency across bm drivers based on power_supply property and
runtime battery attributes.
Basically, 'supplied-to' provides a way of exporting change in
power_supply_property and runtime batter characteristics so that other
bm devs shall make use or refer the updated values.
Ref: external_power_changed(...) call back api.
Note: all the bm drivers handles subset of power_supply property and
      battery attributes,
      ref: include/linux/power_supply.h and get_property(...) call back
      api across bm drivers.
> 
> What does indeed seem to be needed is a place to identify the battery
> type, but it's not clear if the btemp device is the best place for
> that (maybe it is). 
I am not clear whether you are trying to correlate battery-type with
supplied-to. however, battery type is identified based on the
resistance value measured at batctrl pin which is expected to be in the
allowable limit of ab8500 device. This resistance limit varies across
battery types. This happens in btemp driver.

For this, I would suggest you give a list of
> possible batteries and require a property such as
> 
>  st-ericsson,battery-type: A string identifier for the type of battery,
> 			   which impacts how an operating system interpret
> 			   the sensor readings. Possible values include:
> 	* "none"	-- no battery connected
> 	* "li-ion-9100" -- Type 9100 Li-ION battery
> 	* <add any others that apply here>
Can do this, not precisely as "st-ericsson,battery-type", it will be as
battery-type = [unknown|NiMH|LION|...|]], reason being
allowable battery type is based on technology, as you can see the
possible types as:
POWER_SUPPLY_TECHNOLOGY_UNKNOWN = 0,
        POWER_SUPPLY_TECHNOLOGY_NiMH,
        POWER_SUPPLY_TECHNOLOGY_LION,
        POWER_SUPPLY_TECHNOLOGY_LIPO,
        POWER_SUPPLY_TECHNOLOGY_LiFe,
        POWER_SUPPLY_TECHNOLOGY_NiCd,
        POWER_SUPPLY_TECHNOLOGY_LiMn
Ref: include/linux/power_supply.h
Note: doing this will impact my of_probe(...), may slightly bloat the
code.
> 
> 	Arnd
> 
