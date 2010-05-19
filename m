Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab0ESLEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:04:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53604 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab0ESLEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=KOk0kQAYikIcTBG3sRlBkz6W7g72WPleHyrn2FDxPMC4iFqW1q+H4AZbZ9mabQvjoj
         OCOzaBudbeuEvjsCuoBLgEoPnaPSvWwQdnoM3XbEmC4LK2xNUbqsIehRcSQSz0ZeIxjC
         A/mjJli8ChKF6UcqeCI4Llq/IOCMQ8buK0y90=
Date: Wed, 19 May 2010 15:04:46 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: David Dajun Chen <Dajun.Chen@diasemi.com>
Cc: linux-kernel@vger.kernel.org, astarikovskiy@suse.de
Subject: Re: [PATCH] POWER (BAT) of DA9052 Linux device drivers (4/9)
Message-ID: <20100519110446.GA23573@oksana.dev.rtsoft.ru>
References: <3495EC08FA53E94AAA00CC4743D5BA7E010C20F4@pandora.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3495EC08FA53E94AAA00CC4743D5BA7E010C20F4@pandora.diasemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 19, 2010 at 10:50:02AM +0100, David Dajun Chen wrote:
> Dear sir/madam,
> 
> The attached is the POWER (Battery Charger) part of the device drivers newly developed for DA9052 Power Management IC from Dialog Semiconductor.
> 
> Should you have any queries or comments please feel free to contact me.
> 
> Regards

Thanks for the driver. Few comments below.

[...]
> diff -Naur linux-2.6.33.2_bk/drivers/mfd/Kconfig linux-2.6.33.2_patch/drivers/mfd/Kconfig
> --- linux-2.6.33.2_bk/drivers/mfd/Kconfig	2010-05-18 17:54:30.000000000 +0500
> +++ linux-2.6.33.2_patch/drivers/mfd/Kconfig	2010-05-18 18:20:23.000000000 +0500
> @@ -377,6 +377,14 @@
>  	help
>  	  Say Y  to enable the ADC driver for the DA9052 chip
>  
> +config DA9052_BAT_ENABLE
> +	bool "Dialog Semiconductor DA9052 Battery Driver"
> +	depends on MFD_DA9052
> +	select DA9052_ADC_ENABLE
> +	help
> +	  Depends on DA9052 ADC driver
> +	  Say Y  to enable the BAT driver for the DA9052 chip
> +
>  endmenu

That's somewhat unusual placement. You need at least
'depends POWER_SUPPLY'. Or better, place it into drivers/power/,
like the rest of the drivers.

>  menu "Multimedia Capabilities Port drivers"
> diff -Naur linux-2.6.33.2_bk/drivers/power/da9052_bat.c linux-2.6.33.2_patch/drivers/power/da9052_bat.c
> --- linux-2.6.33.2_bk/drivers/power/da9052_bat.c	1970-01-01 05:00:00.000000000 +0500
> +++ linux-2.6.33.2_patch/drivers/power/da9052_bat.c	2010-05-18 18:20:23.000000000 +0500
> @@ -0,0 +1,2633 @@
> +/*
> + * Copyright(c) 2009 Dialog Semiconductor Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * da9052_bat.c: BAT driver file for DA9052
> + *
> + * Authors:
> + *
> + * History:
> + *
> + * (08/05/2009):	Draft version 
> + * (19/05/2009):	Unit tested code version
> + *
> + * (27/04/2010): 	Created initial draft for Linux community release
> + *
> + * Best Viewed with TabSize=8 and ColumnWidth=80
> + */
> +
> +/*--------------------------------------------------------------------------*/
> +/* System wide include files                                                */
> +/*--------------------------------------------------------------------------*/
[...]
> +/*--------------------------------------------------------------------------*/
> +/* Module specific include files                                            */
> +/*--------------------------------------------------------------------------*/
[...]
> +/*--------------------------------------------------------------------------*/
> +/* Local Type Definitions                                                   */
> +/*--------------------------------------------------------------------------*/
[...]
> +/*--------------------------------------------------------------------------*/
> +/* Local Constant Definitions                                               */
> +/*--------------------------------------------------------------------------*/
[...]
> +/*--------------------------------------------------------------------------*/
> +/* Local Macro Definitions                                                  */
> +/*--------------------------------------------------------------------------*/
[...]
> +/*--------------------------------------------------------------------------*/
> +/* Global Variables                                                         */
> +/*--------------------------------------------------------------------------*/

Personally, I think that these comments is just a noise, and makes
driver harder to read.

If you want to keep them, at least could you make them less
noticeable? "/* global variables */", i.e. without the
screaming acsii art? :-)

> +//void start_monitoring(struct work_struct *);

Please avoid dead code. I.e. just remove it.

> +/*Power Supply and Power supply info instance */
> +struct power_supply psy;
> +struct power_supply_info battery_info;

The driver assumes that there's just one DA9052 device in the
system... while this might be a common setup, but it is still
possible that there are several DS9052 devices...

I'm not saying that this must be fixed before merging, but
it what you might to consider fixing.

See drivers/power/ds2760_battery.c and its sister driver
drivers/w1/slaves/w1_ds2760.c, it can handle any amount
of ds2760 batteries in the system.

(Basically you avoid global variables by placing all device's
state information into the device's private structure, and
store it in the drvdata, i.e. platform_set_drvdata() and
platform_get_drvdata()).

> +
> +/**
> +* da9052_bat_get_property : 	Called by power supply to get the status of 
> +*				the battery. It get the property of the battery
> +*				defined by the da902_bat_props array.
> +*/
[...]
> +/**
> + * da902_bat_props -	Array that define the power supply properties supported
> +			by DA9052_BAT Driver
> + */				

Really, there's no need for documentation like this, i.e. it is
unneeded for symbols, purpose of which is obvious. This just makes
the driver look bigger.

We do appreciate documentation for functions, purpose (or behaviour)
of which is not that obvious.

> +static enum power_supply_property da902_bat_props[] = {
> +        POWER_SUPPLY_PROP_STATUS,
> +	POWER_SUPPLY_PROP_ONLINE,
> +        POWER_SUPPLY_PROP_PRESENT,
> +        POWER_SUPPLY_PROP_HEALTH,
> +        POWER_SUPPLY_PROP_TECHNOLOGY,
> +	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
> +	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
> +	POWER_SUPPLY_PROP_VOLTAGE_AVG,
> +        POWER_SUPPLY_PROP_CURRENT_AVG,
> +        POWER_SUPPLY_PROP_CAPACITY,
> +	/* Not supported by Linux version 2.6.28
> +        POWER_SUPPLY_PROP_CAPACITY_LEVEL,
> +	*/

Yeah... but we do support this again since 2.6.32. ;-)

Also note that as of this commit:
http://git.infradead.org/battery-2.6.git/commitdiff/0011d2d4a5f7bb5666dcfb9f9b3dbdb084ab98f1

We support writiable properties (so you might want to get
rid of ioctl stuff in this driver).

See http://git.infradead.org/battery-2.6.git/commitdiff/bd52ca555ef36bf5b790178cfe8b7d42b5c16ca6
as an example of usage.

[...]

> +/**
> + * da9052_battery_setup_psy : 	Called by init function. It initialise the 
> + *				power supply instance for DA9052_BAT.
> + *
> + * @param : void
> + * @return void
> + */
> +static void da9052_battery_setup_psy(void)
> +{
> +	battery_info.name = DA9052_BAT_DEVICE_NAME;
> +	battery_info.technology = BAT_TYPE;
> +	battery_info.voltage_max_design = (chg_device->bat_target_voltage * 1000);
> +	battery_info.voltage_min_design = (BAT_VOLT_CUTOFF * 1000);
> +	battery_info.energy_full_design = BAT_CAPACITY_FULL;
> +	battery_info.energy_empty_design = BAT_CAPACITY_LIMIT_LOW;
> +	battery_info.use_for_apm = 1;
> +	
> +	psy.name = DA9052_BAT_DEVICE_NAME;
> +	psy.use_for_apm = 1;
> +	psy.type = POWER_SUPPLY_TYPE_BATTERY;
> +	psy.get_property = da9052_bat_get_property;
> +
> +	psy.properties = da902_bat_props;
> +	psy.num_properties = ARRAY_SIZE(da902_bat_props);
> +	
> +	DA9052_DEBUG("Array_Size = %d\n",psy.num_properties);

Please use pr_debug() instead of your own DA9052_DEBUG().
It's defined in include/linux/kernel.h, and has several advantages:

- It's standard way to handle debug printks (btw, there's also
  dev_dbg() as defined in include/linux/device.h, use that if
  you have a device).
- It has dynamic debug capability.

[...]
> +#if (DA9052_ILLEGAL_BATTERY_DETECT)
> +/**
> +* detect_illegal_battery : 	Called by Battery Driver PDD  init function to
> +*				detect whether battery connected to the DA9052
> +*				is legal. Here legal battery represent battery
> +*				with NTC resisitor.

FWIW, this is an example of an useful documentation.

[...]
> +/*
> + * da9052_bat_current_lim: Set the ICHG_BAT and ISET_BUCK Current limit
> + *
> + * @param u8 bat_cur_lim  	current limit in mA
> + * @return s32			Error status 0:SUCCESS, Non Zero: Error
> + */
> + s32 da9052_bat_current_lim(u16 bat_cur_lim)
> +{
> +	da9052_ssc_msg msg;
> +
> +	msg.addr = DA9052_BATCHG_REG;
> +
> +	/* Read BAT_CHG register */
> +	if(da9052_ssc_read(&msg)) {
> +		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
> +		return (SSC_FAIL);

No need for parenthesis. Also, is there any real need for
your own error codes? Why not just return 0 on success, and
something like -EIO on error?

[...]
> +			if( current_value >= chg_device->chg_end_current ) {
> +				bat_status.status = CHARGING;
> +				bat_status.charger_type = WALL_CHARGER;
> +			}
> +			else {

Please adhere to Linux coding style. This should be

if () {
	...
} else {
	...
}

[...]
> +	else if(regvalue & DA9052_STATUSA_VBUSDET)
> +	{
> +		if(regvalue & DA9052_STATUSA_VDATDET) {
> +			bat_status.charger_type = USB_CHARGER;
> +			bat_status.status = DISCHARGING_WITH_CHARGER;
> +		}
> +		else {
> +			bat_status.charger_type = USB_HUB;
> +			bat_status.status = DISCHARGING_WITH_CHARGER;
> +		}
> +	}
> +	else
> +	{
> +		bat_status.charger_type = NOCHARGER;
> +		bat_status.status = DISCHARGING_WITHOUT_CHARGER;
> +	}
> +	return;
> +}

This return statement is unneeded.

> +/**
> + * da9052_charger_dcin_detect_handler : DCIN charger detect event callback
> + *				function
> + *
> + * @param u8 event	event status
> + * @return s32	Error status 0:SUCCESS, Non Zero: Error
> + */

Oh.. all this "documentation" makes the driver completely unreadable.

> + void da9052_charger_dcin_detect_handler(u32 event)
> +{
> +
> +	/* Signal to the library for the charger detection event */
> +	if(user_space_chg_det_dcin)
> +	{
> +		da9052_bat_signal_to_user(CHDET_DCIN);
> +	}
> +}
[...]
> +void da9052_bat_tbat_handler(u32 event)
> +{
> +	if(!tbat_event_occur) {	

General advice to make code less indented:

if (tbat_event_occur)
	return;

<the rest of the code>

> +		bat_status.health = POWER_SUPPLY_HEALTH_OVERHEAT;
> +		tbat_event_occur = TRUE;
> +		// update the TBAt value
> +		monitoring_status.bat_temp_status = TRUE;
> +		monitoring_status.bat_temp_value = bat_info.bat_temp;
> +
> +		/* Signal to the library for the VDDLOW event */
> +		da9052_bat_signal_to_user(TBAT);	
> +	}
> +}

[...]
> +/*
> + * interpolated: 	Find the battery level for the bat_voltage, given
> + *			Voltage and time at 2 other place using the piecewise
> + *			interpolation method
> + *

Cool!

> + * @param  u32 vbat_upper
> + * @param  u32 vbat_lower
> + * @param  u32 level_upper
> + * @param  u32 level_lower
> + * @param  u32 bat_voltage
> + * @return u32 time at bat_voltage
> + */
> +u32 interpolated( u32 vbat_lower, u32  vbat_upper, u32  level_lower,
> +				u32  level_upper, u32 bat_voltage)
> +{
> +	s32 temp;
> +
> +	/*apply formula y= yk + (x ?xk) * (yk+1 ?yk)/(xk+1 杧k) */
> +	temp = ((level_upper - level_lower) * 1000)/(vbat_upper - vbat_lower);
> +	temp = level_lower + (((bat_voltage -vbat_lower) * temp)/1000);
> +
> +	return (temp);
> +}

[...]
> +/**
> + * da9052_bat_ioctl:
> + *
> + * @param *inode <Direction> <Description>
> + * @param *file  <Direction> <Description>
> + * @return int   <Description>
> + */
> +s32 da9052_bat_ioctl(struct inode *inode, struct file *file,
> +					unsigned int cmd, unsigned long arg)

I don't like this ioctl stuff at all.

> +{
> +	da9052_charger_device usr_param;
> +	da9052_bat_threshold usr_param_threshold_res;
> +	u32 buffer_32;
> +	u16 buffer;
> +	u8 buffer1;
> +	da9052_bat_status usr_bat_status;
> +	u8 ret=0;
> +
> +	DA9052_DEBUG("BAT IOCTLI function\n");
> +
> +	switch(cmd) {
> +	case DA9052_BAT_IOCTL_GET_CHG_CURRENT:
> +		if( (bat_status.status == DISCHARGING_WITHOUT_CHARGER) ||
> +			(bat_status.status == DISCHARGING_WITH_CHARGER) )
> +			return (BAT_NOT_CHARGING);
> +
> +		if(copy_to_user((u16 *)arg,(void *)&(bat_info.chg_current),
> +								sizeof(buffer)))
> +			return (COPY_TO_USER_FAIL);
> +		break;

This is duplication of power supply class properties.

> +	case DA9052_BAT_IOCTL_GET_CHG_JUNC_TEMPERATURE:
> +		if( (bat_status.status == DISCHARGING_WITHOUT_CHARGER) ||
> +			(bat_status.status == DISCHARGING_WITH_CHARGER) )
> +			return (BAT_NOT_CHARGING);
> +
> +		if(copy_to_user((u16 *)arg,(void *)&(bat_info.chg_junc_temp),
> +								sizeof(buffer)))
> +			return (COPY_TO_USER_FAIL);
> +		break;

Ditto, why not just use some property?

> +	case DA9052_BAT_IOCTL_GET_BAT_VOLTAGE:
> +		if(copy_to_user((u16 *)arg,(void *)&(bat_info.bat_voltage),
> +								sizeof(buffer)))
> +			return (COPY_TO_USER_FAIL);
> +		break;

Ditto.

[... skip skip ...]
> +	case DA9052_BAT_IOCTL_SUSPEND_CHARGING:
> +		ret=da9052_bat_suspend_charging();
> +		if(ret)
> +			return (ret);
> +		break;

OK, for this you can use the new writeable properties.

[...]
> +	case DA9052_BAT_IOCTL_REGISTER_EVENT:
> +		if (copy_from_user(&buffer1, (u8 *)arg, sizeof(u8)))
> +			return (COPY_FROM_USER_FAIL);
> +		ret=da9052_bat_register_event(buffer1,FALSE);
> +		if(ret)
> +			return (ret);

Why do you need to register events dynamically via userspace?

I'd just remove the whole chrdev and ioctl stuff, or at least place
it into a separate patch, so we can review it independently.

[...]
> +/**
> + * da9052_bat_init: Initiales the driver
> + *
> + * @param void
> + * @return int   Error Code, zero: no error
> + */
> +static s32 __init da9052_bat_init(void)
> +{
> +	int retval;
> +	printk(banner);
> +
> +	da9052_bat_platform_device = platform_device_alloc("da9052_bat", 0);
> +	if (!da9052_bat_platform_device)
> +		return (-ENOMEM);
> +
> +	retval = platform_device_add(da9052_bat_platform_device);

You're abusing device-driver model. The MFD driver should
register battery device. And this (battery) driver should
only provide the driver part, it should not allocate or
register any devices.

> +	if (retval < 0) {
> +		platform_device_put(da9052_bat_platform_device);
> +		return (retval);
> +	}
> +
> +	retval = platform_driver_register(&da9052_bat_driver);
> +	if (retval < 0)
> +		platform_device_unregister(da9052_bat_platform_device);
> +
> +	return (retval);
> +}
> +/**
> + * da9052_bat_exit:
> + *
> + * @param void	 <Direction> <Description>
> + * @return void  <Description>
> + */
> +static void __exit da9052_bat_exit(void)
> +{
> +	da9052_bat_sw_deinit();
> +	printk("DA9052: Unregistering BAT device.\n");
> +	unregister_chrdev(bat_major_number, DA9052_BAT_DEVICE_NAME);
> +	platform_driver_unregister(&da9052_bat_driver);
> +	platform_device_unregister(da9052_bat_platform_device);
> +}
> +
> +
> +module_init(da9052_bat_init);
> +module_exit(da9052_bat_exit);
> +
> +MODULE_AUTHOR("Dialog Semiconductor Ltd");
> +MODULE_DESCRIPTION("DA9052 BAT Device Driver");
> +MODULE_LICENSE("GPL");
> +
> +/*--------------------------------------------------------------------------*/
> +/* Exports                                                                  */
> +/*--------------------------------------------------------------------------*/
> +
> +/* AC - Put here all functions that you want to be accessible from other drivers */

Does somebody actually use them outside of this driver?
If not, please remove the exports, and make them static.

> +EXPORT_SYMBOL(da9052_bat_get_chg_current);

FYI, the preferred way is to place EXPORT_SYMBOL() just after the
function. I.e.

void foo(void)
{
}
EXPORT_SYMBOL(foo);

void bar(void)
{
}
EXPORT_SYMBOL(bar);

> +EXPORT_SYMBOL(da9052_bat_get_chg_junc_temperature );
> +EXPORT_SYMBOL(da9052_bat_get_battery_voltage);
> +EXPORT_SYMBOL(da9052_bat_get_backup_battery_voltage);
> +EXPORT_SYMBOL(da9052_bat_get_battery_temperature);
> +EXPORT_SYMBOL(da9052_bat_get_charger_vddout);
> +EXPORT_SYMBOL(da9052_bat_get_remaining_charging_time);
> +EXPORT_SYMBOL(da9052_bat_configure_charger);
> +EXPORT_SYMBOL(da9052_bat_configure_thresholds);
> +EXPORT_SYMBOL(da9052_get_bat_status);
> +EXPORT_SYMBOL(da9052_bat_suspend_charging);
> +EXPORT_SYMBOL(da9052_bat_resume_charging);
> +
> diff -Naur linux-2.6.33.2_bk/drivers/power/Makefile linux-2.6.33.2_patch/drivers/power/Makefile
> --- linux-2.6.33.2_bk/drivers/power/Makefile	2010-04-02 04:02:33.000000000 +0500
> +++ linux-2.6.33.2_patch/drivers/power/Makefile	2010-05-18 18:20:23.000000000 +0500
> @@ -31,3 +31,4 @@
>  obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
>  obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
>  obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
> +obj-$(CONFIG_DA9052_BAT_ENABLE) += da9052_bat.o
> diff -Naur linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_bat.h linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_bat.h
> --- linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_bat.h	1970-01-01 05:00:00.000000000 +0500
> +++ linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_bat.h	2010-05-18 18:20:23.000000000 +0500
> @@ -0,0 +1,950 @@
> +/*
> + * Copyright(c) 2009 Dialog Semiconductor Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * da9052_bat.h: BAT driver header file
> + *
> + * Authors:
> + *
> + * History:
> + *
> + * (08/05/2009):	First release version
> + * (19/05/2009):	Unit tested code version
> + *
> + * (27/04/2010):	Updated for Linux Community release
> + *
> + * Best Viewed with TabSize=8 and ColumnWidth=80
> + */
> +
> +
> +#ifndef _DA9052_BAT_H
> +#define _DA9052_BAT_H
> +
> +/*--------------------------------------------------------------------------*/
> +/* System wide include files                                                */
> +/*--------------------------------------------------------------------------*/
> +
> +/*--------------------------------------------------------------------------*/
> +/* Module specific include files                                            */
> +/*--------------------------------------------------------------------------*/
> +
> +/*--------------------------------------------------------------------------*/
> +/* Type Definitions                                                         */
> +/*--------------------------------------------------------------------------*/

Not useful comments.

[...]
> +/*--------------------------------------------------------------------------*/
> +/* Other Functions                                                          */
> +/*--------------------------------------------------------------------------*/
> +
> +s32 da9052_bat_get_chg_current(u16 *);
> +s32 da9052_bat_get_chg_junc_temperature(u16 *);
> +s32 da9052_bat_get_battery_voltage(u16 *);
> +s32 da9052_bat_get_backup_battery_voltage(u16 *);
> +s32 da9052_bat_get_battery_temperature(u16 *);
> +s32 da9052_bat_get_charger_vddout(u16 *);
> +s32 da9052_bat_get_remaining_charging_time(u16 *);
> +s32 da9052_get_bat_status(da9052_bat_status *);
> +s32 da9052_bat_suspend_charging(void);
> +s32 da9052_bat_resume_charging(void);
> +s32 da9052_bat_configure_charger(da9052_charger_device);
> +s32 da9052_bat_configure_thresholds(da9052_bat_threshold);

Do these need to be exported? Please make them static.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
