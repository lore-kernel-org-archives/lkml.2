Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab0DYUpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 16:45:09 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:53558 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754035Ab0DYUpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 16:45:07 -0400
Message-ID: <4BD4A9B4.1010200@bluewatersys.com>
Date: Mon, 26 Apr 2010 08:44:36 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Mike Rapoport <mike@compulab.co.il>
CC: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org,
       Yulia Vilensky <vilensky@compulab.co.il>
Subject: Re: [PATCH] ds2782_battery: add support for ds2786 battery gas gauge
References: <20100422071437.GA32489@oksana.dev.rtsoft.ru> <1271921723-18289-1-git-send-email-mike@compulab.co.il> <4BD0BE97.6010007@bluewatersys.com> <4BD460D3.1020609@compulab.co.il>
In-Reply-To: <4BD460D3.1020609@compulab.co.il>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Rapoport wrote:
> Hi Ryan,
> 
> Ryan Mallon wrote:
>> Mike Rapoport wrote:
>>> From: Yulia Vilensky <vilensky@compulab.co.il>
>>
>> Thanks for this, some comments below.
>>
>>> Signed-off-by: Yulia Vilensky <vilensky@compulab.co.il>
>>> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
>>> ---
>>>  drivers/power/Kconfig          |    4 +-
>>>  drivers/power/ds2782_battery.c |  217
>>> +++++++++++++++++++++++++++++++--------
>>>  include/linux/ds2782_battery.h |    8 ++
>>>  3 files changed, 182 insertions(+), 47 deletions(-)
>>>  create mode 100644 include/linux/ds2782_battery.h
>>>
>>> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
>>> index faaa9b4..d8b8a19 100644
>>> --- a/drivers/power/Kconfig
>>> +++ b/drivers/power/Kconfig
>>> @@ -65,10 +65,10 @@ config BATTERY_DS2760
>>>        Say Y here to enable support for batteries with ds2760 chip.
>>>  
>>>  config BATTERY_DS2782
>>> -    tristate "DS2782 standalone gas-gauge"
>>> +    tristate "DS2782/DS2786 standalone gas-gauge"
>>>      depends on I2C
>>>      help
>>> -      Say Y here to enable support for the DS2782 standalone battery
>>> +      Say Y here to enable support for the DS2782/DS2786 standalone
>>> battery
>>
>> I have only used the DS2782 chip. Can we just change this to DS278x? May
>> as well change to CONFIG_BATTERY_DS278x while we are here.
>>
> 
> Shall we move ds2782_battery.c to ds278x_battery.c at the same time?
> Changing Kconfig invites the .c file move as well :)

Yes. Are there other gas-gauges in the same family?

>>>        gas-gauge.
>>>  
>>>  config BATTERY_PMU
>>> diff --git a/drivers/power/ds2782_battery.c
>>> b/drivers/power/ds2782_battery.c
>>> index 99c8997..0df49b4 100644
>>> --- a/drivers/power/ds2782_battery.c
>>> +++ b/drivers/power/ds2782_battery.c
>>> @@ -5,6 +5,8 @@
>>>   *
>>>   * Author: Ryan Mallon <ryan@bluewatersys.com>
>>>   *
>>> + * DS278 added by Yulia Vilensky <vilensky@compulab.co.il>
>>> + *
>>>   * This program is free software; you can redistribute it and/or modify
>>>   * it under the terms of the GNU General Public License version 2 as
>>>   * published by the Free Software Foundation.
>>> @@ -20,6 +22,7 @@
>>>  #include <linux/idr.h>
>>>  #include <linux/power_supply.h>
>>>  #include <linux/slab.h>
>>> +#include <linux/ds2782_battery.h>
>>>  
>>>  #define DS2782_REG_RARC        0x06    /* Remaining active relative
>>> capacity */
>>>  
>>> @@ -33,18 +36,39 @@
>>>  /* Current unit measurement in uA for a 1 milli-ohm sense resistor */
>>>  #define DS2782_CURRENT_UNITS    1563
>>>  
>>> -#define to_ds2782_info(x) container_of(x, struct ds2782_info, battery)
>>> +#define DS2786_REG_RARC        0x02    /* Remaining active relative
>>> capacity */
>>> +
>>> +#define DS2786_REG_VOLT_MSB    0x0c
>>> +#define DS2786_REG_TEMP_MSB    0x0a
>>> +#define DS2786_REG_CURRENT_MSB    0x0e
>>
>> #define DS278x_REG_CURRENT_MSB        0x0e
>>
>> Its the same register on both chips, no need for two #defines. Same of
>> the other registers, except for RARC.
> 
> Ok.
> 
>>> +
>>> +#define DS2786_CURRENT_UNITS    25
>>
>> If we make this a member of the info structure, we can easily use it in
>> calculations for both chips, ie
>>
>>      current_uA = raw * (info->current_units / sense_res);
> 
> not quite, see comments below.
>     
>>> +#define DS278X_SIGN_BIT_MASK16  0x8000
>>> +
>>> +struct ds278x_info;
>>>  
>>> -struct ds2782_info {
>>> +struct ds278x_battery_ops {
>>> +    int    (*get_temp)(struct ds278x_info *info, int *temp);
>>> +    int    (*get_current)(struct ds278x_info *info, int *current_uA);
>>> +    int    (*get_voltage)(struct ds278x_info *info, int *voltage_uA);
>>> +    int    (*get_capacity)(struct ds278x_info *info, int *capacity_uA);
>>> +};
>>> +
> 
> [ snip ]
> 
>>>  
>>> -static int ds2782_get_status(struct ds2782_info *info, int *status)
>>> +static int ds2786_get_temp(struct ds278x_info *info, int *temp)
>>> +{
>>> +    s16 raw;
>>> +    int err;
>>> +
>>> +    /*
>>> +     * Temperature is measured in units of 0.125 degrees celcius, the
>>> +     * power_supply class measures temperature in tenths of degrees
>>> +     * celsius. The temperature value is stored as a 10 bit number,
>>> plus
>>> +     * sign in the upper bits of a 16 bit register.
>>> +     */
>>> +    err = ds278x_read_reg16(info, DS2786_REG_TEMP_MSB, &raw);
>>> +    if (err)
>>> +        return err;
>>> +
>>> +    if (raw &  DS278X_SIGN_BIT_MASK16)
>>> +        *temp = -(((~raw >> 5)+1) * 125)/100;
>>> +    else
>>> +        *temp = ((raw >> 5) * 125)/100;
>>> +
>>> +    return 0;
>>> +}
>>
>> This is basically the same as the ds2782 version. See Jean's comments on
>> my original patch about the sign math:
>> http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg01220.html
> 
> Ok, we'll fix the math
> 
>>> +static int ds2786_get_current(struct ds278x_info *info, int
>>> *current_uA)
>>> +{
>>> +    int err;
>>> +    s16 raw;
>>> +
>>> +    err = ds278x_read_reg16(info, DS2786_REG_CURRENT_MSB, &raw);
>>> +    if (err)
>>> +        return err;
>>> +
>>> +    if (raw &  DS278X_SIGN_BIT_MASK16)
>>> +        *current_uA = -(((~raw >> 4)+1) *
>>> +                   (DS2786_CURRENT_UNITS / info->rsns));
>>> +    else
>>> +        *current_uA = (raw >> 4) *
>>> +                  (DS2786_CURRENT_UNITS / info->rsns);
>>> +    return 0;
>>
>> Can we combine the implementations of the get_current function? Both
>> have get rsns (though in different ways) and eventually divide the
>> current register by the rsns value? Possibly move the get_rsns into
>> separate battery ops and attempt to coalesce these?
> 
> It's possible to have get_rsns and coalesce _get_current for both chips.
> However, ds2872 and ds2786 need slightly different formula for current
> calculations. Part of these calculations can be wrapped into
> ds2786_get_rsns, but it makes the later really not clear to follow.

Fair enough. I just didn't want to have two versions of each function,
that were doing almost the same thing. If you think it is
cleaner/clearer to have separate functions, then stick with that.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
