Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab0DYPe5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 11:34:57 -0400
Received: from compulab.co.il ([67.18.134.219]:47925 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab0DYPe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 11:34:56 -0400
Message-ID: <4BD460D3.1020609@compulab.co.il>
Date: Sun, 25 Apr 2010 18:33:39 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: Ryan Mallon <ryan@bluewatersys.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org,
       Yulia Vilensky <vilensky@compulab.co.il>,
       Mike Rapoport <mike@compulab.co.il>
Subject: Re: [PATCH] ds2782_battery: add support for ds2786 battery gas gauge
References: <20100422071437.GA32489@oksana.dev.rtsoft.ru> <1271921723-18289-1-git-send-email-mike@compulab.co.il> <4BD0BE97.6010007@bluewatersys.com>
In-Reply-To: <4BD0BE97.6010007@bluewatersys.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

Ryan Mallon wrote:
> Mike Rapoport wrote:
>> From: Yulia Vilensky <vilensky@compulab.co.il>
> 
> Thanks for this, some comments below.
> 
>> Signed-off-by: Yulia Vilensky <vilensky@compulab.co.il>
>> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
>> ---
>>  drivers/power/Kconfig          |    4 +-
>>  drivers/power/ds2782_battery.c |  217 +++++++++++++++++++++++++++++++--------
>>  include/linux/ds2782_battery.h |    8 ++
>>  3 files changed, 182 insertions(+), 47 deletions(-)
>>  create mode 100644 include/linux/ds2782_battery.h
>>
>> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
>> index faaa9b4..d8b8a19 100644
>> --- a/drivers/power/Kconfig
>> +++ b/drivers/power/Kconfig
>> @@ -65,10 +65,10 @@ config BATTERY_DS2760
>>  	  Say Y here to enable support for batteries with ds2760 chip.
>>  
>>  config BATTERY_DS2782
>> -	tristate "DS2782 standalone gas-gauge"
>> +	tristate "DS2782/DS2786 standalone gas-gauge"
>>  	depends on I2C
>>  	help
>> -	  Say Y here to enable support for the DS2782 standalone battery
>> +	  Say Y here to enable support for the DS2782/DS2786 standalone battery
> 
> I have only used the DS2782 chip. Can we just change this to DS278x? May
> as well change to CONFIG_BATTERY_DS278x while we are here.
> 

Shall we move ds2782_battery.c to ds278x_battery.c at the same time? 
Changing Kconfig invites the .c file move as well :)

>>  	  gas-gauge.
>>  
>>  config BATTERY_PMU
>> diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
>> index 99c8997..0df49b4 100644
>> --- a/drivers/power/ds2782_battery.c
>> +++ b/drivers/power/ds2782_battery.c
>> @@ -5,6 +5,8 @@
>>   *
>>   * Author: Ryan Mallon <ryan@bluewatersys.com>
>>   *
>> + * DS278 added by Yulia Vilensky <vilensky@compulab.co.il>
>> + *
>>   * This program is free software; you can redistribute it and/or modify
>>   * it under the terms of the GNU General Public License version 2 as
>>   * published by the Free Software Foundation.
>> @@ -20,6 +22,7 @@
>>  #include <linux/idr.h>
>>  #include <linux/power_supply.h>
>>  #include <linux/slab.h>
>> +#include <linux/ds2782_battery.h>
>>  
>>  #define DS2782_REG_RARC		0x06	/* Remaining active relative capacity */
>>  
>> @@ -33,18 +36,39 @@
>>  /* Current unit measurement in uA for a 1 milli-ohm sense resistor */
>>  #define DS2782_CURRENT_UNITS	1563
>>  
>> -#define to_ds2782_info(x) container_of(x, struct ds2782_info, battery)
>> +#define DS2786_REG_RARC		0x02	/* Remaining active relative capacity */
>> +
>> +#define DS2786_REG_VOLT_MSB	0x0c
>> +#define DS2786_REG_TEMP_MSB	0x0a
>> +#define DS2786_REG_CURRENT_MSB	0x0e
> 
> #define DS278x_REG_CURRENT_MSB		0x0e
> 
> Its the same register on both chips, no need for two #defines. Same of
> the other registers, except for RARC.

Ok.

>> +
>> +#define DS2786_CURRENT_UNITS	25
> 
> If we make this a member of the info structure, we can easily use it in
> calculations for both chips, ie
> 
>  	current_uA = raw * (info->current_units / sense_res);

not quite, see comments below.
  	
>> +#define DS278X_SIGN_BIT_MASK16  0x8000
>> +
>> +struct ds278x_info;
>>  
>> -struct ds2782_info {
>> +struct ds278x_battery_ops {
>> +	int	(*get_temp)(struct ds278x_info *info, int *temp);
>> +	int	(*get_current)(struct ds278x_info *info, int *current_uA);
>> +	int	(*get_voltage)(struct ds278x_info *info, int *voltage_uA);
>> +	int	(*get_capacity)(struct ds278x_info *info, int *capacity_uA);
>> +};
>> +

[ snip ]

>>  
>> -static int ds2782_get_status(struct ds2782_info *info, int *status)
>> +static int ds2786_get_temp(struct ds278x_info *info, int *temp)
>> +{
>> +	s16 raw;
>> +	int err;
>> +
>> +	/*
>> +	 * Temperature is measured in units of 0.125 degrees celcius, the
>> +	 * power_supply class measures temperature in tenths of degrees
>> +	 * celsius. The temperature value is stored as a 10 bit number, plus
>> +	 * sign in the upper bits of a 16 bit register.
>> +	 */
>> +	err = ds278x_read_reg16(info, DS2786_REG_TEMP_MSB, &raw);
>> +	if (err)
>> +		return err;
>> +
>> +	if (raw &  DS278X_SIGN_BIT_MASK16)
>> +		*temp = -(((~raw >> 5)+1) * 125)/100;
>> +	else
>> +		*temp = ((raw >> 5) * 125)/100;
>> +
>> +	return 0;
>> +}
> 
> This is basically the same as the ds2782 version. See Jean's comments on
> my original patch about the sign math:
> http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg01220.html

Ok, we'll fix the math

>> +static int ds2786_get_current(struct ds278x_info *info, int *current_uA)
>> +{
>> +	int err;
>> +	s16 raw;
>> +
>> +	err = ds278x_read_reg16(info, DS2786_REG_CURRENT_MSB, &raw);
>> +	if (err)
>> +		return err;
>> +
>> +	if (raw &  DS278X_SIGN_BIT_MASK16)
>> +		*current_uA = -(((~raw >> 4)+1) *
>> +			       (DS2786_CURRENT_UNITS / info->rsns));
>> +	else
>> +		*current_uA = (raw >> 4) *
>> +			      (DS2786_CURRENT_UNITS / info->rsns);
>> +	return 0;
> 
> Can we combine the implementations of the get_current function? Both
> have get rsns (though in different ways) and eventually divide the
> current register by the rsns value? Possibly move the get_rsns into
> separate battery ops and attempt to coalesce these?

It's possible to have get_rsns and coalesce _get_current for both chips. 
However, ds2872 and ds2786 need slightly different formula for current 
calculations. Part of these calculations can be wrapped into 
ds2786_get_rsns, but it makes the later really not clear to follow.

>> +}
>> +
>> +static int ds2786_get_voltage(struct ds278x_info *info, int *voltage_uA)
>> +{
>> +	s16 raw;
>> +	int err;
>> +
>> +	/*
>> +	 * Voltage is measured in units of 1.22mV. The voltage is stored as
>> +	 * a 10-bit number plus sign, in the upper bits of a 16-bit register
>> +	 */
>> +	err = ds278x_read_reg16(info, DS2786_REG_VOLT_MSB, &raw);
>> +	if (err)
>> +		return err;
>> +
>> +	if (raw &  DS278X_SIGN_BIT_MASK16)
>> +		*voltage_uA = -(((~raw >> 3)+1) * 1220);
>> +	else
>> +		*voltage_uA = (raw >> 3) * 1220;
>> +	return 0;
>> +}
> 
> Again, if we move the multiplier value (1220 for ds2786 and 4800 for
> ds2782) to the info structure then we can use the same code to get the
> voltage for both chips.

We need to the divider to the info structure as well.

>> +static int ds2786_get_capacity(struct ds278x_info *info, int *capacity)
>> +{
>> +	int err;
>> +	u8 raw;
>> +
>> +	err = ds278x_read_reg(info, DS2786_REG_RARC, &raw);
>> +	if (err)
>> +		return err;
>> +	/* Relative capacity is displayed with resolution 0.5 % */
>> +	*capacity = raw/2 ;
>> +	return 0;
>> +}
> 
> Same here, move the divider to the info structure (will be 1 for ds2782)
> and combine the functions.

Here again we need to add the divider and RARC register to the info 
structure.

>> +
>> +static int ds278x_get_status(struct ds278x_info *info, int *status)
>>  {

[ snip ]

>>  
>> -static int ds2782_battery_probe(struct i2c_client *client,
>> +static struct ds278x_battery_ops ds278x_ops[] = {
>> +	[0] = {
>> +		.get_temp     = ds2782_get_temp,
>> +		.get_current  = ds2782_get_current,
>> +		.get_voltage  = ds2782_get_voltage,
>> +		.get_capacity = ds2782_get_capacity,
>> +	},
>> +	[1] = {
>> +		.get_temp     = ds2786_get_temp,
>> +		.get_current  = ds2786_get_current,
>> +		.get_voltage  = ds2786_get_voltage,
>> +		.get_capacity = ds2786_get_capacity,
>> +	}
>> +};
>> +
>> +static int ds278x_battery_probe(struct i2c_client *client,
>>  				const struct i2c_device_id *id)
>>  {
>> -	struct ds2782_info *info;
>> +	struct ds278x_platform_data *pdata = client->dev.platform_data;
>> +	struct ds278x_info *info;
>>  	int ret;
>>  	int num;
>>  
>> +	/*
>> +	 * ds2786 should have the sense resistor value set
>> +	 * in the platform data .
>> +	 */
>> +	if (id->driver_data == 1 && pdata == 0) {
>> +		dev_err(&client->dev, "missing platform data for ds2786\n");
>> +		return -EINVAL;
>> +	}
>> +
>>  	/* Get an ID for this battery */
>>  	ret = idr_pre_get(&battery_id, GFP_KERNEL);
>>  	if (ret == 0) {
>> @@ -269,7 +392,7 @@ static int ds2782_battery_probe(struct i2c_client *client,
>>  		goto fail_info;
>>  	}
>>  
>> -	info->battery.name = kasprintf(GFP_KERNEL, "ds2782-%d", num);
>> +	info->battery.name = kasprintf(GFP_KERNEL, "%s-%d", client->name, num);
>>  	if (!info->battery.name) {
>>  		ret = -ENOMEM;
>>  		goto fail_name;
>> @@ -277,7 +400,10 @@ static int ds2782_battery_probe(struct i2c_client *client,
>>  
>>  	i2c_set_clientdata(client, info);
>>  	info->client = client;
>> -	ds2782_power_supply_init(&info->battery);
>> +	info->id = num;
>> +	info->ops  = &ds278x_ops[id->driver_data];

Summarizing all the parameters that should be added to the info 
structure we'd get here switch with lots of 'param = value' for each 
case which seems to me less elegant and efficient than simple info->ops 
assignment. I think keeping different functions for ds2782 and ds2786 
keeps the code more readable and easier to follow.

>> +	info->rsns = pdata->rsns;
>> +	ds278x_power_supply_init(&info->battery);
>>  
>>  	ret = power_supply_register(&client->dev, &info->battery);
>>  	if (ret) {
>> @@ -300,31 +426,32 @@ fail_id:
>>  	return ret;
>>  }
>>  
>> -static const struct i2c_device_id ds2782_id[] = {
>> +static const struct i2c_device_id ds278x_id[] = {
>>  	{"ds2782", 0},
>> +	{"ds2786", 1},
>>  	{},
>>  };
>>  
>> -static struct i2c_driver ds2782_battery_driver = {
>> +static struct i2c_driver ds278x_battery_driver = {
>>  	.driver 	= {
>>  		.name	= "ds2782-battery",
>>  	},
>> -	.probe		= ds2782_battery_probe,
>> -	.remove		= ds2782_battery_remove,
>> -	.id_table	= ds2782_id,
>> +	.probe		= ds278x_battery_probe,
>> +	.remove		= ds278x_battery_remove,
>> +	.id_table	= ds278x_id,
>>  };
>>  
>> -static int __init ds2782_init(void)
>> +static int __init ds278x_init(void)
>>  {
>> -	return i2c_add_driver(&ds2782_battery_driver);
>> +	return i2c_add_driver(&ds278x_battery_driver);
>>  }
>> -module_init(ds2782_init);
>> +module_init(ds278x_init);
>>  
>> -static void __exit ds2782_exit(void)
>> +static void __exit ds278x_exit(void)
>>  {
>> -	i2c_del_driver(&ds2782_battery_driver);
>> +	i2c_del_driver(&ds278x_battery_driver);
>>  }
>> -module_exit(ds2782_exit);
>> +module_exit(ds278x_exit);
>>  
>>  MODULE_AUTHOR("Ryan Mallon <ryan@bluewatersys.com>");
>>  MODULE_DESCRIPTION("Maxim/Dallas DS2782 Stand-Alone Fuel Gauage IC driver");
>> diff --git a/include/linux/ds2782_battery.h b/include/linux/ds2782_battery.h
>> new file mode 100644
>> index 0000000..b4e281f
>> --- /dev/null
>> +++ b/include/linux/ds2782_battery.h
>> @@ -0,0 +1,8 @@
>> +#ifndef __LINUX_DS2782_BATTERY_H
>> +#define __LINUX_DS2782_BATTERY_H
>> +
>> +struct ds278x_platform_data {
>> +	int rsns;
>> +};
>> +
>> +#endif
> 
> 


-- 
Sincerely yours,
Mike.
