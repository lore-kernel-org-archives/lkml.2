Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab0FXQ2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 12:28:06 -0400
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:49331 "EHLO
	smtp.towertech.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab0FXQ2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 12:28:04 -0400
Date: Thu, 24 Jun 2010 18:27:44 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: dd.diasemi@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/11] device driver for DA9052
Message-ID: <20100624182744.22839a43@linux.lan.towertech.it>
In-Reply-To: <1277393953.6703.20.camel@sw-eng-lt-dc-vm2>
References: <1277393953.6703.20.camel@sw-eng-lt-dc-vm2>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010 17:39:13 +0200
dd diasemi <dd.diasemi@gmail.com> wrote:

> Initial submission of RTC control module of the device driver for DA9052
> power  management device from Dialog Semiconductor.
> 
> Linux Kernel Version: 2.6.34
> 
> Signed-off-by: D. Chen <dchen@diasemi.com>

 Hi.

  please read the checklist at http://groups.google.com/group/rtc-linux/web/checklist

 you code has wrong style, formatting, an excess of printk,
 unuseful comments and the author email is missing from MODULE_AUTHOR.

 rtc-lib has some functions that could help you too.


> diff -Naur linux-2.6.34/drivers/mfd/da9052-core.c
> linux-2.6.34_test/drivers/mfd/da9052-core.c
> --- linux-2.6.34/drivers/mfd/da9052-core.c	2010-06-23 19:35:06.000000000
> +0500
> +++ linux-2.6.34_test/drivers/mfd/da9052-core.c	2010-06-23
> 19:48:10.000000000 +0500
> @@ -566,6 +566,9 @@
>  	if (ret)
>  		return -EIO;
>  
> +	/* Add the DA9052 modules */
> +	da9052_add_subdevice(da9052, "da9052-rtc");
> +
>  	/* Initialize ssc cache */
>  	da9052_init_ssc_cache();
>  
> diff -Naur linux-2.6.34/drivers/rtc/Kconfig
> linux-2.6.34_test/drivers/rtc/Kconfig
> --- linux-2.6.34/drivers/rtc/Kconfig	2010-05-17 02:17:36.000000000 +0500
> +++ linux-2.6.34_test/drivers/rtc/Kconfig	2010-06-23 19:46:25.000000000
> +0500
> @@ -888,4 +888,10 @@
>  	  This driver can also be built as a module. If so, the module
>  	  will be called rtc-mpc5121.
>  
> +config RTC_DRV_DA9052
> +	tristate "Support RTC on Dialog Semiconductor DA9052 PMIC"
> +	depends on PMIC_DA9052
> +	help
> +	  Say y here to support the RTC found on
> +	  Dialog Semiconductor DA9052 PMIC.
>  endif # RTC_CLASS
> diff -Naur linux-2.6.34/drivers/rtc/Makefile
> linux-2.6.34_test/drivers/rtc/Makefile
> --- linux-2.6.34/drivers/rtc/Makefile	2010-05-17 02:17:36.000000000
> +0500
> +++ linux-2.6.34_test/drivers/rtc/Makefile	2010-06-23 19:46:15.000000000
> +0500
> @@ -92,3 +92,4 @@
>  obj-$(CONFIG_RTC_DRV_WM831X)	+= rtc-wm831x.o
>  obj-$(CONFIG_RTC_DRV_WM8350)	+= rtc-wm8350.o
>  obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
> +obj-$(CONFIG_RTC_DRV_DA9052)	+= rtc-da9052.o
> diff -Naur linux-2.6.34/drivers/rtc/rtc-da9052.c
> linux-2.6.34_test/drivers/rtc/rtc-da9052.c
> --- linux-2.6.34/drivers/rtc/rtc-da9052.c	1970-01-01 05:00:00.000000000
> +0500
> +++ linux-2.6.34_test/drivers/rtc/rtc-da9052.c	2010-06-23
> 19:46:39.000000000 +0500
> @@ -0,0 +1,733 @@
> +/*
> + * Copyright(c) 2009 Dialog Semiconductor Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * rtc-da9052.c: RTC driver for DA9052
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/rtc.h>
> +#include <linux/mfd/da9052/da9052.h>
> +#include <linux/mfd/da9052/reg.h>
> +#include <linux/mfd/da9052/rtc.h>
> +
> +#define DRIVER_NAME "da9052-rtc"
> +#define ENABLE		1
> +#define DISABLE		0
> +
> +struct da9052_rtc {
> +	struct rtc_device *rtc;
> +	struct da9052 *da9052;
> +	struct da9052_eh_nb eh_data;
> +	unsigned char is_min_alarm; /* Set 1min =1/ 1sec =0 Tick Alarm */
> +	unsigned char enable_tick_alarm; /* Tick Alarm enable/disable */
> +	unsigned char enable_clk_buffer; /* Clock Buffer enable/disable  */
> +	unsigned char set_osc_trim_freq; /* Set Oscillator Trim Frequency */
> +};
> +
> +/*
> +* This is needed for doing SSC communication in alarm handler
> +* as we get alarm event notification from DA9052 MFD core
> +*/
> +static struct da9052_rtc *rtc1;
> +
> +void da9052_rtc_alarm_handler(unsigned int event)
> +{
> +	struct da9052_ssc_msg msg;
> +	unsigned int ret;
> +
> +	printk(KERN_INFO "In RTC Event: %d\n", event);
> +	/* Alarm event has occured */
> +	/* Check the alarm type - TIMER or TICK */
> +	msg.addr = DA9052_ALARMMI_REG;
> +
> +	da9052_lock(rtc1->da9052);
> +	ret = rtc1->da9052->read(rtc1->da9052, &msg);
> +	if (ret)
> +		return;
> +	da9052_unlock(rtc1->da9052);
> +
> +	if (msg.data & DA9052_ALARMMI_ALARMTYPE)
> +		printk(KERN_INFO "RTC: TIMER ALARM\n");
> +	else
> +		printk(KERN_INFO "RTC: TICK ALARM\n");
> +}
> +
> +static int da9052_rtc_validate_parameters(struct rtc_time *rtc_tm)
> +{
> +	/* Input validation for limits */
> +
> +	/*Check for Seconds */
> +	if (rtc_tm->tm_sec > DA9052_RTC_SECONDS_LIMIT)
> +		return DA9052_RTC_INVALID_SECONDS;
> +	/*Check for Minutes */
> +	if (rtc_tm->tm_min > DA9052_RTC_MINUTES_LIMIT)
> +		return DA9052_RTC_INVALID_MINUTES;
> +	/* Check for Hours */
> +	if (rtc_tm->tm_hour > DA9052_RTC_HOURS_LIMIT)
> +		return DA9052_RTC_INVALID_HOURS;
> +	/*Check for Days */
> +	if (rtc_tm->tm_mday == 0)
> +		return DA9052_RTC_INVALID_DAYS;
> +	/*Check for MOnths */
> +	if ((rtc_tm->tm_mon > DA9052_RTC_MONTHS_LIMIT) ||
> +	(rtc_tm->tm_mon == 0))
> +		return DA9052_RTC_INVALID_MONTHS;
> +	/*Check for Years */
> +	if (rtc_tm->tm_year > DA9052_RTC_YEARS_LIMIT)
> +		return DA9052_RTC_INVALID_YEARS;
> +
> +	if ((rtc_tm->tm_mon == FEBRUARY)) {
> +		/* Check for the leap year */
> +		if (((rtc_tm->tm_year % 4 == 0) &&
> +			(rtc_tm->tm_year % 100 != 0)) ||
> +			(rtc_tm->tm_year % 400 == 0)) {
> +			/* Condition satisfying leap year */
> +			if (rtc_tm->tm_mday > 29)
> +				return DA9052_RTC_INVALID_DAYS;
> +		} else if (rtc_tm->tm_mday > 28) {
> +			/* Non leap Year Condition */
> +			return DA9052_RTC_INVALID_DAYS;
> +		}
> +	}
> +	/* Check for the the months having 30 days */
> +	if (((rtc_tm->tm_mon == APRIL) || (rtc_tm->tm_mon == JUNE) ||
> +		(rtc_tm->tm_mon == SEPTEMBER) || (rtc_tm->tm_mon == NOVEMBER))
> +		&& (rtc_tm->tm_mday == 31))
> +		return DA9052_RTC_INVALID_DAYS;
> +
> +	return 0;
> +}
> +
> +static int da9052_rtc_settime(struct da9052 *da9052, struct rtc_time
> *rtc_tm)
> +{
> +
> +	/* SSC data variable for multiple write */
> +	struct da9052_ssc_msg msg_arr[6];
> +	/* return value of validate param function */
> +	int validate_param = 0;
> +	/* SSC loop index */
> +	unsigned char loop_index = 0;
> +	int ret = 0;
> +
> +	/* Validate Input Parameters */
> +	validate_param = da9052_rtc_validate_parameters(rtc_tm);
> +	if (validate_param)
> +		return validate_param;
> +
> +	/* Set Monitor bit to 1 and seconds value */
> +	msg_arr[loop_index].addr = DA9052_COUNTS_REG;
> +	msg_arr[loop_index++].data = DA9052_COUNTS_MONITOR | rtc_tm->tm_sec;
> +
> +	/* Set the Minutes value */
> +	msg_arr[loop_index].addr = DA9052_COUNTMI_REG;
> +	msg_arr[loop_index].data = 0;
> +	msg_arr[loop_index++].data = rtc_tm->tm_min;
> +
> +	/* Form the Hour register value */
> +	msg_arr[loop_index].addr = DA9052_COUNTH_REG;
> +	msg_arr[loop_index].data = 0;
> +	msg_arr[loop_index++].data = rtc_tm->tm_hour;
> +
> +	/* Form the Days register value */
> +	msg_arr[loop_index].addr = DA9052_COUNTD_REG;
> +	msg_arr[loop_index].data = 0;
> +	msg_arr[loop_index++].data = rtc_tm->tm_mday;
> +
> +	/* Form the Months register value */
> +	msg_arr[loop_index].addr = DA9052_COUNTMO_REG;
> +	msg_arr[loop_index].data = 0;
> +	msg_arr[loop_index++].data = rtc_tm->tm_mon;
> +
> +	/* Assign to SSC multi write variable */
> +	msg_arr[loop_index].addr = DA9052_COUNTY_REG;
> +	msg_arr[loop_index].data = 0;
> +	msg_arr[loop_index++].data = rtc_tm->tm_year;
> +
> +
> +	/*Perform Multi write Operation */
> +	ret = da9052->write_many(da9052, msg_arr, loop_index);
> +	if (ret) {
> +		printk(KERN_INFO "RTC: SET TIME SSC WRITE FAILED\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int da9052_rtc_gettime(struct da9052 *da9052, struct rtc_time
> *rtc_tm)
> +{
> +
> +	/* SSC data variable */
> +	struct da9052_ssc_msg msg[6];
> +	/* SSC array index */
> +	unsigned char loop_index = 0;
> +
> +	/* Read Seconds value */
> +	msg[loop_index].data = 0;
> +	msg[loop_index++].addr = DA9052_COUNTS_REG;
> +	/* Read Minutes value */
> +	msg[loop_index].data = 0;
> +	msg[loop_index++].addr = DA9052_COUNTMI_REG;
> +	/* Read Hours value */
> +	msg[loop_index].data = 0;
> +	msg[loop_index++].addr = DA9052_COUNTH_REG;
> +	/* Read Days value */
> +	msg[loop_index].data = 0;
> +	msg[loop_index++].addr = DA9052_COUNTD_REG;
> +	/* Read Months value */
> +	msg[loop_index].data = 0;
> +	msg[loop_index++].addr = DA9052_COUNTMO_REG;
> +	/* Read Years value */
> +	msg[loop_index].data = 0;
> +	msg[loop_index++].addr = DA9052_COUNTY_REG;
> +
> +	/* use SSC multi read functionality */
> +	if (da9052->read_many(da9052, msg, loop_index))
> +		return -EIO;
> +
> +	/*Assign Read values */
> +	/*Assign Year value */
> +	rtc_tm->tm_year = msg[--loop_index].data & DA9052_COUNTY_COUNTYEAR;
> +	/*Assign Month value */
> +	rtc_tm->tm_mon = msg[--loop_index].data & DA9052_COUNTMO_COUNTMONTH;
> +	/*Assign Days value */
> +	rtc_tm->tm_mday = msg[--loop_index].data & DA9052_COUNTD_COUNTDAY;
> +	/*Assign Hours value */
> +	rtc_tm->tm_hour = msg[--loop_index].data & DA9052_COUNTH_COUNTHOUR;
> +	/*Assign Minutes value */
> +	rtc_tm->tm_min = msg[--loop_index].data & DA9052_COUNTMI_COUNTMIN;
> +	/*Assign Seconds value */
> +	rtc_tm->tm_sec = msg[--loop_index].data & DA9052_COUNTS_COUNTSEC;
> +
> +	return 0;
> +}
> +
> +static int da9052_alarm_gettime(struct da9052 *da9052, struct rtc_time
> *rtc_tm)
> +{
> +	struct da9052_ssc_msg msg[5];
> +	unsigned char loop_index = 0;
> +	int ret = 0;
> +
> +	/* Read Minutes value */
> +	msg[loop_index].data = 0;
> +	msg[loop_index++].addr = DA9052_ALARMMI_REG;
> +	/* Read Hours value */
> +	msg[loop_index].data = 0;
> +	msg[loop_index++].addr = DA9052_ALARMH_REG;
> +	/* Read Days value */
> +	msg[loop_index].data = 0;
> +	msg[loop_index++].addr = DA9052_ALARMD_REG;
> +	/* Read Months value */
> +	msg[loop_index].data = 0;
> +	msg[loop_index++].addr = DA9052_ALARMMO_REG;
> +	/* Read Years value */
> +	msg[loop_index].data = 0;
> +	msg[loop_index++].addr = DA9052_ALARMY_REG;
> +
> +	/* use SSC multi read functionality */
> +	ret = da9052->read_many(da9052, msg, loop_index);
> +	if (ret)
> +		return -EIO;
> +
> +	/*Assign Read values */
> +	/*Assign Year value */
> +	rtc_tm->tm_year = msg[--loop_index].data & DA9052_ALARMY_ALARMYEAR;
> +	/*Assign Month value */
> +	rtc_tm->tm_mon = msg[--loop_index].data & DA9052_ALARMMO_ALARMMONTH;
> +	/*Assign Days value */
> +	rtc_tm->tm_mday = msg[--loop_index].data & DA9052_ALARMD_ALARMDAY;
> +	/*Assign Hours value */
> +	rtc_tm->tm_hour = msg[--loop_index].data & DA9052_ALARMH_ALARMHOUR;
> +	/*Assign Minutes value */
> +	rtc_tm->tm_min = msg[--loop_index].data & DA9052_ALARMMI_ALARMMIN;
> +
> +	return 0;
> +}
> +
> +static int da9052_alarm_settime(struct da9052 *da9052, struct rtc_time
> *rtc_tm)
> +{
> +	/* SSC data variable for multiple write */
> +	struct da9052_ssc_msg msg_arr[5];
> +	/* SSC data variable for single read */
> +	struct da9052_ssc_msg msg;
> +	/* return value of validate param function */
> +	int validate_param = 0;
> +	/* SSC loop index */
> +	unsigned char loop_index = 0;
> +	int ret = 0;
> +
> +	/* As DA9052 does not support the Seconds Alarm */
> +	rtc_tm->tm_sec = 0;
> +
> +	/* Validate Input Parameters */
> +	validate_param = da9052_rtc_validate_parameters(rtc_tm);
> +	if (validate_param)
> +		return validate_param;
> +
> +	/* Set the Minutes value */
> +	/*Read the current register */
> +	/* Modify only minute bits */
> +	msg.addr = DA9052_ALARMMI_REG;
> +	msg.data = 0;
> +	ret = da9052->read(da9052, &msg);
> +	if (ret)
> +		return -EIO;
> +
> +	msg.data = msg.data & ~(DA9052_ALARMMI_ALARMMIN);
> +	msg.data |= rtc_tm->tm_min;
> +	/* Assign the read & updated minutes value to write register arary */
> +	msg_arr[loop_index].addr = DA9052_ALARMMI_REG;
> +	msg_arr[loop_index].data = 0;
> +	msg_arr[loop_index++].data = msg.data;
> +
> +	/* Form the Hour register value */
> +	msg_arr[loop_index].addr = DA9052_ALARMH_REG;
> +	msg_arr[loop_index].data = 0;
> +	msg_arr[loop_index++].data = rtc_tm->tm_hour;
> +
> +	/* Form the Days register value */
> +	msg_arr[loop_index].addr = DA9052_ALARMD_REG;
> +	msg_arr[loop_index].data = 0;
> +	msg_arr[loop_index++].data = rtc_tm->tm_mday;
> +
> +	/* Form the Months register value */
> +	msg_arr[loop_index].addr = DA9052_ALARMMO_REG;
> +	msg_arr[loop_index].data = 0;
> +	msg_arr[loop_index++].data = rtc_tm->tm_mon;
> +
> +	/* Form the Year register value */
> +	msg.addr = DA9052_ALARMY_REG;
> +	msg.data = 0;
> +	ret = da9052->read(da9052, &msg);
> +	if (ret)
> +		return -EIO;
> +
> +	msg.data = msg.data & ~(DA9052_ALARMY_ALARMYEAR);
> +
> +
> +	msg.data |= rtc_tm->tm_year;
> +	/* Assign to SSC multi write variable */
> +	msg_arr[loop_index].addr = DA9052_ALARMY_REG;
> +	msg_arr[loop_index].data = 0;
> +	msg_arr[loop_index++].data = msg.data;
> +
> +
> +	/* Perform Multi write Operation */
> +	ret = da9052->write_many(da9052, msg_arr, loop_index);
> +	if (ret)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +static int da9052_rtc_enable_alarm(struct da9052 *da9052, unsigned char
> flag)
> +{
> +	struct da9052_ssc_msg msg;
> +	int ret = 0;
> +
> +	/* Read ALARM YEAR register */
> +	msg.addr = DA9052_ALARMY_REG;
> +	da9052_lock(da9052);
> +	ret = da9052->read(da9052, &msg);
> +	if (ret)
> +		return -EIO;
> +	da9052_unlock(da9052);
> +
> +	if (ENABLE == flag)
> +		/* Enable ALARM */
> +		msg.data = msg.data | DA9052_ALARMY_ALARMON;
> +
> +	else if (DISABLE == flag)
> +		/* Disable ALARM */
> +		msg.data = msg.data & ~(DA9052_ALARMY_ALARMON);
> +
> +	da9052_lock(da9052);
> +	ret = da9052->write(da9052, &msg);
> +	if (ret)
> +		return -EIO;
> +	da9052_unlock(da9052);
> +
> +	return 0;
> +}
> +
> +
> +static ssize_t da9052_rtc_mask_irq(struct da9052 *da9052)
> + {
> +	unsigned char data = 0;
> +	ssize_t ret = 0;
> +	struct da9052_ssc_msg ssc_msg;
> +
> +	/* Populate the SSC message structure */
> +	/* range checks on this data shall be performed by SSC */
> +	ssc_msg.addr = DA9052_IRQMASKA_REG;
> +	ssc_msg.data = 0;
> +
> +	da9052_lock(da9052);
> +	ret = da9052->read(da9052, &ssc_msg);
> +	if (ret) {
> +		printk(KERN_INFO "DA9052_RTC:da9052_rtc_mask_irq: \
> +		SSC Read failed. \n");
> +		da9052_unlock(da9052);
> +		return ret;
> +	}
> +	da9052_unlock(da9052);
> +
> +	/*Get the latest IRQ configuration*/
> +	data = ret;
> +
> +	/* Mask the RTC Alarm interrupt event */
> +	ssc_msg.data = data |= DA9052_IRQMASKA_MALRAM;
> +	/* Populate the SSC message structure */
> +	/* range checks on this data shall be performed by SSC */
> +
> +	da9052_lock(da9052);
> +	ret = da9052->write(da9052, &ssc_msg);
> +	da9052_unlock(da9052);
> +
> +	if (ret) {
> +		printk(KERN_INFO "DA9052_RTC:da9052_rtc_mask_irq: SSC Write
> failed.\n");
> +		da9052_unlock(da9052);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +
> +static ssize_t da9052_rtc_unmask_irq(struct da9052 *da9052)
> +{
> +	unsigned char data = 0;
> +	ssize_t ret = 0;
> +	struct da9052_ssc_msg ssc_msg;
> +
> +	/* Populate the SSC message structure */
> +	/* range checks on this data shall be performed by SSC */
> +	ssc_msg.addr =  DA9052_IRQMASKA_REG;
> +	ssc_msg.data =  0;
> +
> +	da9052_lock(da9052);
> +	ret = da9052->read(da9052, &ssc_msg);
> +	if (ret) {
> +		printk(KERN_INFO "DA9052_RTC:da9052_rtc_unmask_irq:\
> +				SSC Read failed. \n");
> +		da9052_unlock(da9052);
> +		return ret;
> +	}
> +	da9052_unlock(da9052);
> +
> +	/*Get the latest IRQ configuration*/
> +	data = ret;
> +
> +	/* UnMask the RTC Alarm interrupt event */
> +	ssc_msg.data = data &= ~DA9052_IRQMASKA_MALRAM;
> +
> +	da9052_lock(da9052);
> +	ret = da9052->write(da9052, &ssc_msg);
> +	da9052_unlock(da9052);
> +
> +	if (ret) {
> +		printk(KERN_INFO "DA9052_RTC:da9052_rtc_unmask_irq: \
> +				SSC Write failed. \n");
> +		da9052_unlock(da9052);
> +		return ret;
> +	}
> +
> +	return 0;
> +
> +}
> +
> +static int da9052_rtc_class_ops_gettime(struct device *dev, struct
> rtc_time *tm)
> +{
> +	int ret;
> +	struct da9052_rtc *priv = dev_get_drvdata(dev);
> +	ret = da9052_rtc_gettime(priv->da9052, tm);
> +	if (ret) {
> +		printk(KERN_INFO "RTC Get time operation failed.\n");
> +		return -EIO;
> +	}
> +	return 0;
> +}
> +
> +
> +static int da9052_rtc_class_ops_settime(struct device *dev, struct
> rtc_time *tm)
> +{
> +	int ret;
> +	struct da9052_rtc *priv = dev_get_drvdata(dev);
> +
> +	ret = da9052_rtc_settime(priv->da9052, tm);
> +
> +	return ret;
> +}
> +
> +static int da9052_rtc_readalarm(struct device *dev, struct rtc_wkalrm
> *alrm)
> +{
> +	int ret;
> +	struct rtc_time *tm = &alrm->time;
> +	struct da9052_rtc *priv = dev_get_drvdata(dev);
> +
> +	ret = da9052_alarm_gettime(priv->da9052, tm);
> +	if (ret) {
> +		printk(KERN_INFO "RTC Read alarm operation failed.\n");
> +		return -EIO;
> +	}
> +	return 0;
> +
> +}
> +
> +static int da9052_rtc_setalarm(struct device *dev, struct rtc_wkalrm
> *alrm)
> +{
> +	int ret;
> +	struct rtc_time *tm = &alrm->time;
> +	struct da9052_rtc *priv = dev_get_drvdata(dev);
> +
> +	ret = da9052_alarm_settime(priv->da9052, tm);
> +	if (ret)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +static int da9052_rtc_update_irq_enable(struct device *dev,
> +		unsigned int enabled)
> +{
> +	struct da9052_rtc *priv = dev_get_drvdata(dev);
> +	int ret = -ENODATA;
> +
> +	da9052_lock(priv->da9052);
> +
> +	ret = (enabled ? da9052_rtc_unmask_irq : da9052_rtc_mask_irq)
> +						(priv->da9052);
> +
> +	da9052_unlock(priv->da9052);
> +
> +	return ret;
> +}
> +
> +static int da9052_rtc_alarm_irq_enable(struct device *dev,
> +				       unsigned int enabled)
> +{
> +	struct da9052_rtc *priv = dev_get_drvdata(dev);
> +
> +	if (enabled)
> +		return da9052_rtc_enable_alarm(priv->da9052, enabled);
> +	else
> +		return da9052_rtc_enable_alarm(priv->da9052, enabled);
> +}
> +
> +static const struct rtc_class_ops da9052_rtc_ops = {
> +	.read_time	= da9052_rtc_class_ops_gettime,
> +	.set_time	= da9052_rtc_class_ops_settime,
> +	.read_alarm	= da9052_rtc_readalarm,
> +	.set_alarm	= da9052_rtc_setalarm,
> +	.update_irq_enable = da9052_rtc_update_irq_enable,
> +	.alarm_irq_enable = da9052_rtc_alarm_irq_enable,
> +};
> +
> +
> +static int __devinit da9052_rtc_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct da9052_rtc *priv;
> +	struct da9052_ssc_msg ssc_msg;
> +
> +	printk(KERN_INFO " DA9052 RTC Driver Probe.\n");
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->da9052 = dev_get_drvdata(pdev->dev.parent);
> +	rtc1 = priv;
> +	platform_set_drvdata(pdev, priv);
> +
> +	/* Set the EH structure */
> +	priv->eh_data.eve_type = ALARM_EVE;
> +	priv->eh_data.call_back = &da9052_rtc_alarm_handler;
> +	ret = priv->da9052->register_event_notifier(priv->da9052,
> +		&priv->eh_data);
> +	if (ret) {
> +		printk(KERN_INFO "DA9052 RTC Probe: Error in registering alarm
> event.\n");
> +		goto err_register_alarm;
> +	}
> +
> +	/* Enable Timer alarm by default. */
> +	priv->is_min_alarm = 1;
> +	priv->enable_tick_alarm = 1;
> +	priv->enable_clk_buffer = 1;
> +	priv->set_osc_trim_freq = 0;
> +
> +	/* Register the events with the DA9052 core to receive the events */
> +
> +	/* Enable/Disable TICK Alarm */
> +	/* Read ALARM YEAR register */
> +	ssc_msg.addr = DA9052_ALARMY_REG;
> +	ssc_msg.data = 0;
> +
> +	da9052_lock(priv->da9052);
> +	ret = priv->da9052->read(priv->da9052, &ssc_msg);
> +	if (ret) {
> +		printk(KERN_INFO "DA9052 RTC Probe: Error in reading SSC register
> \n");
> +		da9052_unlock(priv->da9052);
> +		goto err_ssc_comm;
> +	}
> +	da9052_unlock(priv->da9052);
> +
> +	if (priv->enable_tick_alarm)
> +		ssc_msg.data = (ssc_msg.data | DA9052_ALARMY_TICKON);
> +	else
> +		ssc_msg.data =
> +		((ssc_msg.data & ~(DA9052_ALARMY_TICKON)));
> +
> +	da9052_lock(priv->da9052);
> +	ret = priv->da9052->write(priv->da9052, &ssc_msg);
> +	if (ret) {
> +		printk(KERN_INFO "DA9052 RTC Probe: Error in writing to SSC register
> \n");
> +		da9052_unlock(priv->da9052);
> +		goto err_ssc_comm;
> +	}
> +	da9052_unlock(priv->da9052);
> +
> +	/* Set TICK Alarm to 1 minute or 1 sec */
> +	/* Read ALARM MINUTES register */
> +	ssc_msg.addr = DA9052_ALARMMI_REG;
> +	ssc_msg.data = 0;
> +
> +	da9052_lock(priv->da9052);
> +	ret = priv->da9052->read(priv->da9052, &ssc_msg);
> +	if (ret) {
> +		printk(KERN_INFO "DA9052 RTC Probe: Error in reading SSC register
> \n");
> +		da9052_unlock(priv->da9052);
> +		goto err_ssc_comm;
> +	}
> +	da9052_unlock(priv->da9052);
> +
> +	if (priv->is_min_alarm)
> +		/* Set 1 minute tick type */
> +		ssc_msg.data = (ssc_msg.data | DA9052_ALARMMI_TICKTYPE);
> +	else
> +		/* Set 1 sec tick type */
> +		ssc_msg.data = (ssc_msg.data & ~(DA9052_ALARMMI_TICKTYPE));
> +
> +	da9052_lock(priv->da9052);
> +	ret = priv->da9052->write(priv->da9052, &ssc_msg);
> +	if (ret) {
> +		printk(KERN_INFO "DA9052 RTC Probe: Error in writing to SSC register
> \n");
> +		da9052_unlock(priv->da9052);
> +		goto err_ssc_comm;
> +	}
> +	da9052_unlock(priv->da9052);
> +
> +
> +	/* Enable/Disable Clock buffer in Power Down Mode */
> +	ssc_msg.addr = DA9052_PDDIS_REG;
> +	ssc_msg.data = 0;
> +
> +	da9052_lock(priv->da9052);
> +	ret = priv->da9052->read(priv->da9052, &ssc_msg);
> +	if (ret) {
> +		printk(KERN_INFO "DA9052 RTC Probe: Error in reading SSC register
> \n");
> +		da9052_unlock(priv->da9052);
> +		goto err_ssc_comm;
> +	}
> +	da9052_unlock(priv->da9052);
> +
> +	if (priv->enable_clk_buffer)
> +		ssc_msg.data = (ssc_msg.data | DA9052_PDDIS_OUT32KPD);
> +	else
> +		ssc_msg.data = (ssc_msg.data & ~(DA9052_PDDIS_OUT32KPD));
> +
> +	da9052_lock(priv->da9052);
> +	ret = priv->da9052->write(priv->da9052, &ssc_msg);
> +	if (ret) {
> +		printk(KERN_INFO "DA9052 RTC Probe: Error in writing to SSC register
> \n");
> +		da9052_unlock(priv->da9052);
> +		goto err_ssc_comm;
> +	}
> +	da9052_unlock(priv->da9052);
> +
> +
> +	/* Set clock trim frequency value */
> +	ssc_msg.addr = DA9052_OSCTRIM_REG;
> +	ssc_msg.data = priv->set_osc_trim_freq;
> +
> +	da9052_lock(priv->da9052);
> +	ret = priv->da9052->write(priv->da9052, &ssc_msg);
> +	if (ret) {
> +		printk(KERN_INFO "DA9052 RTC Probe: Error in writing to SSC register
> \n");
> +		da9052_unlock(priv->da9052);
> +		goto err_ssc_comm;
> +	}
> +	da9052_unlock(priv->da9052);
> +
> +
> +	priv->rtc = rtc_device_register(pdev->name,
> +			&pdev->dev, &da9052_rtc_ops, THIS_MODULE);
> +	if (IS_ERR(priv->rtc)) {
> +		ret = PTR_ERR(priv->rtc);
> +		goto err_ssc_comm;
> +	}
> +
> +
> +err_ssc_comm:
> +		priv->da9052->unregister_event_notifier
> +			(priv->da9052, &priv->eh_data);
> +err_register_alarm:
> +		platform_set_drvdata(pdev, NULL);
> +		kfree(priv);
> +
> +
> +	return ret;
> +}
> +
> +static int __devexit da9052_rtc_remove(struct platform_device *pdev)
> +{
> +	struct da9052_rtc *priv = platform_get_drvdata(pdev);
> +
> +	rtc_device_unregister(priv->rtc);
> +
> +	da9052_lock(priv->da9052);
> +
> +	priv->da9052->unregister_event_notifier(priv->da9052, &priv->eh_data);
> +
> +	da9052_unlock(priv->da9052);
> +
> +	platform_set_drvdata(pdev, NULL);
> +
> +	kfree(priv);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver da9052_rtc_driver = {
> +	.probe = da9052_rtc_probe,
> +	.remove = __devexit_p(da9052_rtc_remove),
> +	.driver = {
> +		.name = DRIVER_NAME,
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +
> +static int __init da9052_rtc_init(void)
> +{
> +	return platform_driver_probe(&da9052_rtc_driver, &da9052_rtc_probe);
> +}
> +module_init(da9052_rtc_init);
> +
> +static void __exit da9052_rtc_exit(void)
> +{
> +	platform_driver_unregister(&da9052_rtc_driver);
> +}
> +module_exit(da9052_rtc_exit);
> +
> +MODULE_AUTHOR("Dialog Semiconductor Ltd");
> +MODULE_DESCRIPTION("RTC driver for Dialog DA9052 PMIC");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:" DRIVER_NAME);
> diff -Naur linux-2.6.34/include/linux/mfd/da9052/rtc.h
> linux-2.6.34_test/include/linux/mfd/da9052/rtc.h
> --- linux-2.6.34/include/linux/mfd/da9052/rtc.h	1970-01-01
> 05:00:00.000000000 +0500
> +++ linux-2.6.34_test/include/linux/mfd/da9052/rtc.h	2010-06-23
> 19:48:18.000000000 +0500
> @@ -0,0 +1,313 @@
> +/*
> + * Copyright(c) 2009 Dialog Semiconductor Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * rtc.h: RTC driver file for DA9052
> +*/
> +
> +
> +#ifndef _RTC_H
> +#define _RTC_H
> +
> +
> +#define DA9052_RTC_DEVICE_NAME				"da9052_rtc"
> +
> +/*  Limit values */
> +#define DA9052_RTC_SECONDS_LIMIT			(59)
> +#define DA9052_RTC_MINUTES_LIMIT			(59)
> +#define DA9052_RTC_HOURS_LIMIT				(23)
> +#define DA9052_RTC_DAYS_LIMIT				(31)
> +#define DA9052_RTC_MONTHS_LIMIT				(12)
> +#define DA9052_RTC_YEARS_LIMIT				(63)
> +
> +/* Months */
> +#define FEBRUARY					(2)
> +#define APRIL						(4)
> +#define JUNE						(6)
> +#define	SEPTEMBER					(9)
> +#define NOVEMBER					(11)
> +
> +/* BYTE shifts */
> +#define DA9052_RTC_FOURTH_BYTE				(24)
> +#define DA9052_RTC_THIRD_BYTE				(16)
> +#define DA9052_RTC_SECOND_BYTE				(8)
> +#define DA9052_RTC_FIRST_BYTE				(0)
> +
> +/* Oscillator trim values */
> +#define DA9052_RTC_OSC_FRQ_0_0ppm			(0)
> +#define DA9052_RTC_OSC_FRQ_1_9ppm			(1)
> +#define DA9052_RTC_OSC_FRQ_3_8ppm			(2)
> +#define DA9052_RTC_OSC_FRQ_5_7ppm			(3)
> +#define DA9052_RTC_OSC_FRQ_7_6ppm			(4)
> +#define DA9052_RTC_OSC_FRQ_9_5ppm			(5)
> +#define DA9052_RTC_OSC_FRQ_11_4ppm			(6)
> +#define DA9052_RTC_OSC_FRQ_13_3ppm			(7)
> +#define DA9052_RTC_OSC_FRQ_15_2ppm			(8)
> +#define DA9052_RTC_OSC_FRQ_17_1ppm			(9)
> +#define DA9052_RTC_OSC_FRQ_19_0ppm			(10)
> +#define DA9052_RTC_OSC_FRQ_20_9ppm			(11)
> +#define DA9052_RTC_OSC_FRQ_22_8ppm			(12)
> +#define DA9052_RTC_OSC_FRQ_24_7ppm			(13)
> +#define DA9052_RTC_OSC_FRQ_26_7ppm			(14)
> +#define DA9052_RTC_OSC_FRQ_28_6ppm			(15)
> +#define DA9052_RTC_OSC_FRQ_30_5ppm			(16)
> +#define DA9052_RTC_OSC_FRQ_32_4ppm			(17)
> +#define DA9052_RTC_OSC_FRQ_34_3ppm			(18)
> +#define DA9052_RTC_OSC_FRQ_36_2ppm			(19)
> +#define DA9052_RTC_OSC_FRQ_38_1ppm			(20)
> +#define DA9052_RTC_OSC_FRQ_40_0ppm			(21)
> +#define DA9052_RTC_OSC_FRQ_41_9ppm			(22)
> +#define DA9052_RTC_OSC_FRQ_43_8ppm			(23)
> +#define DA9052_RTC_OSC_FRQ_45_7ppm			(24)
> +#define DA9052_RTC_OSC_FRQ_47_6ppm			(25)
> +#define DA9052_RTC_OSC_FRQ_49_5ppm			(26)
> +#define DA9052_RTC_OSC_FRQ_51_4ppm			(27)
> +#define DA9052_RTC_OSC_FRQ_53_4ppm			(28)
> +#define DA9052_RTC_OSC_FRQ_55_3ppm			(29)
> +#define DA9052_RTC_OSC_FRQ_57_2ppm			(30)
> +#define DA9052_RTC_OSC_FRQ_59_1ppm			(31)
> +#define DA9052_RTC_OSC_FRQ_61_0ppm			(32)
> +#define DA9052_RTC_OSC_FRQ_62_9ppm			(33)
> +#define DA9052_RTC_OSC_FRQ_64_8ppm			(34)
> +#define DA9052_RTC_OSC_FRQ_66_7ppm			(35)
> +#define DA9052_RTC_OSC_FRQ_68_6ppm			(36)
> +#define DA9052_RTC_OSC_FRQ_70_5ppm			(37)
> +#define DA9052_RTC_OSC_FRQ_72_4ppm			(38)
> +#define DA9052_RTC_OSC_FRQ_74_3ppm			(39)
> +#define DA9052_RTC_OSC_FRQ_76_2ppm			(40)
> +#define DA9052_RTC_OSC_FRQ_78_2ppm			(41)
> +#define DA9052_RTC_OSC_FRQ_80_1ppm			(42)
> +#define DA9052_RTC_OSC_FRQ_82_0ppm			(43)
> +#define DA9052_RTC_OSC_FRQ_83_9ppm			(44)
> +#define DA9052_RTC_OSC_FRQ_85_8ppm			(45)
> +#define DA9052_RTC_OSC_FRQ_87_7ppm			(46)
> +#define DA9052_RTC_OSC_FRQ_89_6ppm			(47)
> +#define DA9052_RTC_OSC_FRQ_91_5ppm			(48)
> +#define DA9052_RTC_OSC_FRQ_93_4ppm			(49)
> +#define DA9052_RTC_OSC_FRQ_95_3ppm			(50)
> +#define DA9052_RTC_OSC_FRQ_97_2ppm			(51)
> +#define DA9052_RTC_OSC_FRQ_99_1ppm			(52)
> +#define DA9052_RTC_OSC_FRQ_101_0ppm			(53)
> +#define DA9052_RTC_OSC_FRQ_102_9ppm			(54)
> +#define DA9052_RTC_OSC_FRQ_104_9ppm			(55)
> +#define DA9052_RTC_OSC_FRQ_106_8ppm			(56)
> +#define DA9052_RTC_OSC_FRQ_108_7ppm			(57)
> +#define DA9052_RTC_OSC_FRQ_110_6ppm			(58)
> +#define DA9052_RTC_OSC_FRQ_112_5ppm			(59)
> +#define DA9052_RTC_OSC_FRQ_114_4ppm			(60)
> +#define DA9052_RTC_OSC_FRQ_116_3ppm			(61)
> +#define DA9052_RTC_OSC_FRQ_118_2ppm			(62)
> +#define DA9052_RTC_OSC_FRQ_120_1ppm			(63)
> +#define DA9052_RTC_OSC_FRQ_122_0ppm			(64)
> +#define DA9052_RTC_OSC_FRQ_123_9ppm			(65)
> +#define DA9052_RTC_OSC_FRQ_125_8ppm			(66)
> +#define DA9052_RTC_OSC_FRQ_127_7ppm			(67)
> +#define DA9052_RTC_OSC_FRQ_129_6ppm			(68)
> +#define DA9052_RTC_OSC_FRQ_131_6ppm			(69)
> +#define DA9052_RTC_OSC_FRQ_133_5ppm			(70)
> +#define DA9052_RTC_OSC_FRQ_135_4ppm			(71)
> +#define DA9052_RTC_OSC_FRQ_137_3ppm			(72)
> +#define DA9052_RTC_OSC_FRQ_139_2ppm			(73)
> +#define DA9052_RTC_OSC_FRQ_141_1ppm			(74)
> +#define DA9052_RTC_OSC_FRQ_143_0ppm			(75)
> +#define DA9052_RTC_OSC_FRQ_144_9ppm			(76)
> +#define DA9052_RTC_OSC_FRQ_146_8ppm			(77)
> +#define DA9052_RTC_OSC_FRQ_148_7ppm			(78)
> +#define DA9052_RTC_OSC_FRQ_150_6ppm			(79)
> +#define DA9052_RTC_OSC_FRQ_152_5ppm			(80)
> +#define DA9052_RTC_OSC_FRQ_154_4ppm			(81)
> +#define DA9052_RTC_OSC_FRQ_156_4ppm			(82)
> +#define DA9052_RTC_OSC_FRQ_158_3ppm			(83)
> +#define DA9052_RTC_OSC_FRQ_160_2ppm			(84)
> +#define DA9052_RTC_OSC_FRQ_162_1ppm			(85)
> +#define DA9052_RTC_OSC_FRQ_164_0ppm			(86)
> +#define DA9052_RTC_OSC_FRQ_165_9ppm			(87)
> +#define DA9052_RTC_OSC_FRQ_167_8ppm			(88)
> +#define DA9052_RTC_OSC_FRQ_169_7ppm			(89)
> +#define DA9052_RTC_OSC_FRQ_171_6ppm			(90)
> +#define DA9052_RTC_OSC_FRQ_173_5ppm			(91)
> +#define DA9052_RTC_OSC_FRQ_175_4ppm			(92)
> +#define DA9052_RTC_OSC_FRQ_177_3ppm			(93)
> +#define DA9052_RTC_OSC_FRQ_179_2ppm			(94)
> +#define DA9052_RTC_OSC_FRQ_181_1ppm			(95)
> +#define DA9052_RTC_OSC_FRQ_183_1ppm			(96)
> +#define DA9052_RTC_OSC_FRQ_185_0ppm			(97)
> +#define DA9052_RTC_OSC_FRQ_186_9ppm			(98)
> +#define DA9052_RTC_OSC_FRQ_188_8ppm			(99)
> +#define DA9052_RTC_OSC_FRQ_190_7ppm			(100)
> +#define DA9052_RTC_OSC_FRQ_192_6ppm			(101)
> +#define DA9052_RTC_OSC_FRQ_194_5ppm			(102)
> +#define DA9052_RTC_OSC_FRQ_196_4ppm			(103)
> +#define DA9052_RTC_OSC_FRQ_198_3ppm			(104)
> +#define DA9052_RTC_OSC_FRQ_200_2ppm			(105)
> +#define DA9052_RTC_OSC_FRQ_202_1ppm			(106)
> +#define DA9052_RTC_OSC_FRQ_204_0ppm			(107)
> +#define DA9052_RTC_OSC_FRQ_205_9ppm			(108)
> +#define DA9052_RTC_OSC_FRQ_207_9ppm			(109)
> +#define DA9052_RTC_OSC_FRQ_209_8ppm			(110)
> +#define DA9052_RTC_OSC_FRQ_211_7ppm			(111)
> +#define DA9052_RTC_OSC_FRQ_213_6ppm			(112)
> +#define DA9052_RTC_OSC_FRQ_215_5ppm			(113)
> +#define DA9052_RTC_OSC_FRQ_217_4ppm			(114)
> +#define DA9052_RTC_OSC_FRQ_219_3ppm			(115)
> +#define DA9052_RTC_OSC_FRQ_221_2ppm			(116)
> +#define DA9052_RTC_OSC_FRQ_223_1ppm			(117)
> +#define DA9052_RTC_OSC_FRQ_225_0ppm			(118)
> +#define DA9052_RTC_OSC_FRQ_226_9ppm			(119)
> +#define DA9052_RTC_OSC_FRQ_228_8ppm			(120)
> +#define DA9052_RTC_OSC_FRQ_230_7ppm			(121)
> +#define DA9052_RTC_OSC_FRQ_232_6ppm			(122)
> +#define DA9052_RTC_OSC_FRQ_234_6ppm			(123)
> +#define DA9052_RTC_OSC_FRQ_236_5ppm			(124)
> +#define DA9052_RTC_OSC_FRQ_238_4ppm			(125)
> +#define DA9052_RTC_OSC_FRQ_240_3ppm			(126)
> +#define DA9052_RTC_OSC_FRQ_242_2ppm			(127)
> +#define DA9052_RTC_OSC_FRQ_MINUS_244_1ppm		(128)
> +#define DA9052_RTC_OSC_FRQ_MINUS_242_2ppm		(129)
> +#define DA9052_RTC_OSC_FRQ_MINUS_240_3ppm		(130)
> +#define DA9052_RTC_OSC_FRQ_MINUS_238_4ppm		(131)
> +#define DA9052_RTC_OSC_FRQ_MINUS_236_5ppm		(132)
> +#define DA9052_RTC_OSC_FRQ_MINUS_234_6ppm		(133)
> +#define DA9052_RTC_OSC_FRQ_MINUS_232_6ppm		(134)
> +#define DA9052_RTC_OSC_FRQ_MINUS_230_7ppm		(135)
> +#define DA9052_RTC_OSC_FRQ_MINUS_228_8ppm		(136)
> +#define DA9052_RTC_OSC_FRQ_MINUS_226_9ppm		(137)
> +#define DA9052_RTC_OSC_FRQ_MINUS_225_0ppm		(138)
> +#define DA9052_RTC_OSC_FRQ_MINUS_223_1ppm		(139)
> +#define DA9052_RTC_OSC_FRQ_MINUS_221_2ppm		(140)
> +#define DA9052_RTC_OSC_FRQ_MINUS_219_3ppm		(141)
> +#define DA9052_RTC_OSC_FRQ_MINUS_217_4ppm		(142)
> +#define DA9052_RTC_OSC_FRQ_MINUS_215_5ppm		(143)
> +#define DA9052_RTC_OSC_FRQ_MINUS_213_6ppm		(144)
> +#define DA9052_RTC_OSC_FRQ_MINUS_211_7ppm		(145)
> +#define DA9052_RTC_OSC_FRQ_MINUS_209_8ppm		(146)
> +#define DA9052_RTC_OSC_FRQ_MINUS_207_9ppm		(147)
> +#define DA9052_RTC_OSC_FRQ_MINUS_205_9ppm		(148)
> +#define DA9052_RTC_OSC_FRQ_MINUS_204_0ppm		(149)
> +#define DA9052_RTC_OSC_FRQ_MINUS_202_1ppm		(150)
> +#define DA9052_RTC_OSC_FRQ_MINUS_200_2ppm		(151)
> +#define DA9052_RTC_OSC_FRQ_MINUS_198_3ppm		(152)
> +#define DA9052_RTC_OSC_FRQ_MINUS_196_4ppm		(153)
> +#define DA9052_RTC_OSC_FRQ_MINUS_194_5ppm		(154)
> +#define DA9052_RTC_OSC_FRQ_MINUS_192_6ppm		(155)
> +#define DA9052_RTC_OSC_FRQ_MINUS_190_7ppm		(156)
> +#define DA9052_RTC_OSC_FRQ_MINUS_188_8ppm		(157)
> +#define DA9052_RTC_OSC_FRQ_MINUS_186_9ppm		(158)
> +#define DA9052_RTC_OSC_FRQ_MINUS_185_0ppm		(159)
> +#define DA9052_RTC_OSC_FRQ_MINUS_183_1ppm		(160)
> +#define DA9052_RTC_OSC_FRQ_MINUS_181_1ppm		(161)
> +#define DA9052_RTC_OSC_FRQ_MINUS_179_2ppm		(162)
> +#define DA9052_RTC_OSC_FRQ_MINUS_177_3ppm		(163)
> +#define DA9052_RTC_OSC_FRQ_MINUS_175_4ppm		(164)
> +#define DA9052_RTC_OSC_FRQ_MINUS_173_5ppm		(165)
> +#define DA9052_RTC_OSC_FRQ_MINUS_171_6ppm		(166)
> +#define DA9052_RTC_OSC_FRQ_MINUS_169_7ppm		(167)
> +#define DA9052_RTC_OSC_FRQ_MINUS_167_8ppm		(168)
> +#define DA9052_RTC_OSC_FRQ_MINUS_165_9ppm		(169)
> +#define DA9052_RTC_OSC_FRQ_MINUS_164_0ppm		(170)
> +#define DA9052_RTC_OSC_FRQ_MINUS_162_1ppm		(171)
> +#define DA9052_RTC_OSC_FRQ_MINUS_160_2ppm		(172)
> +#define DA9052_RTC_OSC_FRQ_MINUS_158_3ppm		(173)
> +#define DA9052_RTC_OSC_FRQ_MINUS_156_4ppm		(174)
> +#define DA9052_RTC_OSC_FRQ_MINUS_154_4ppm		(175)
> +#define DA9052_RTC_OSC_FRQ_MINUS_152_5ppm		(176)
> +#define DA9052_RTC_OSC_FRQ_MINUS_150_6ppm		(177)
> +#define DA9052_RTC_OSC_FRQ_MINUS_148_7ppm		(178)
> +#define DA9052_RTC_OSC_FRQ_MINUS_146_8ppm		(179)
> +#define DA9052_RTC_OSC_FRQ_MINUS_144_9ppm		(180)
> +#define DA9052_RTC_OSC_FRQ_MINUS_143_0ppm		(181)
> +#define DA9052_RTC_OSC_FRQ_MINUS_141_1ppm		(182)
> +#define DA9052_RTC_OSC_FRQ_MINUS_139_2ppm		(183)
> +#define DA9052_RTC_OSC_FRQ_MINUS_137_3ppm		(184)
> +#define DA9052_RTC_OSC_FRQ_MINUS_135_4ppm		(185)
> +#define DA9052_RTC_OSC_FRQ_MINUS_133_5ppm		(186)
> +#define DA9052_RTC_OSC_FRQ_MINUS_131_6ppm		(187)
> +#define DA9052_RTC_OSC_FRQ_MINUS_129_6ppm		(188)
> +#define DA9052_RTC_OSC_FRQ_MINUS_127_7ppm		(189)
> +#define DA9052_RTC_OSC_FRQ_MINUS_125_8ppm		(190)
> +#define DA9052_RTC_OSC_FRQ_MINUS_123_9ppm		(191)
> +#define DA9052_RTC_OSC_FRQ_MINUS_122_0ppm		(192)
> +#define DA9052_RTC_OSC_FRQ_MINUS_120_1ppm		(193)
> +#define DA9052_RTC_OSC_FRQ_MINUS_118_2ppm		(194)
> +#define DA9052_RTC_OSC_FRQ_MINUS_116_3ppm		(195)
> +#define DA9052_RTC_OSC_FRQ_MINUS_114_4ppm		(196)
> +#define DA9052_RTC_OSC_FRQ_MINUS_112_5ppm		(197)
> +#define DA9052_RTC_OSC_FRQ_MINUS_110_6ppm		(198)
> +#define DA9052_RTC_OSC_FRQ_MINUS_108_7ppm		(199)
> +#define DA9052_RTC_OSC_FRQ_MINUS_106_8ppm		(200)
> +#define DA9052_RTC_OSC_FRQ_MINUS_104_9ppm		(201)
> +#define DA9052_RTC_OSC_FRQ_MINUS_102_9ppm		(202)
> +#define DA9052_RTC_OSC_FRQ_MINUS_101_0ppm		(203)
> +#define DA9052_RTC_OSC_FRQ_MINUS_99_1ppm		(204)
> +#define DA9052_RTC_OSC_FRQ_MINUS_97_2ppm		(205)
> +#define DA9052_RTC_OSC_FRQ_MINUS_95_3ppm		(206)
> +#define DA9052_RTC_OSC_FRQ_MINUS_93_4ppm		(207)
> +#define DA9052_RTC_OSC_FRQ_MINUS_91_5ppm		(208)
> +#define DA9052_RTC_OSC_FRQ_MINUS_89_6ppm		(209)
> +#define DA9052_RTC_OSC_FRQ_MINUS_87_7ppm		(210)
> +#define DA9052_RTC_OSC_FRQ_MINUS_85_8ppm		(211)
> +#define DA9052_RTC_OSC_FRQ_MINUS_83_9ppm		(212)
> +#define DA9052_RTC_OSC_FRQ_MINUS_82_0ppm		(213)
> +#define DA9052_RTC_OSC_FRQ_MINUS_80_1ppm		(214)
> +#define DA9052_RTC_OSC_FRQ_MINUS_78_2ppm		(215)
> +#define DA9052_RTC_OSC_FRQ_MINUS_76_2ppm		(216)
> +#define DA9052_RTC_OSC_FRQ_MINUS_74_3ppm		(217)
> +#define DA9052_RTC_OSC_FRQ_MINUS_72_4ppm		(218)
> +#define DA9052_RTC_OSC_FRQ_MINUS_70_5ppm		(219)
> +#define DA9052_RTC_OSC_FRQ_MINUS_68_6ppm		(220)
> +#define DA9052_RTC_OSC_FRQ_MINUS_66_7ppm		(221)
> +#define DA9052_RTC_OSC_FRQ_MINUS_64_8ppm		(222)
> +#define DA9052_RTC_OSC_FRQ_MINUS_62_9ppm		(223)
> +#define DA9052_RTC_OSC_FRQ_MINUS_61_0ppm		(224)
> +#define DA9052_RTC_OSC_FRQ_MINUS_59_1ppm		(225)
> +#define DA9052_RTC_OSC_FRQ_MINUS_57_2ppm		(226)
> +#define DA9052_RTC_OSC_FRQ_MINUS_55_3ppm		(227)
> +#define DA9052_RTC_OSC_FRQ_MINUS_53_4ppm		(228)
> +#define DA9052_RTC_OSC_FRQ_MINUS_51_4ppm		(229)
> +#define DA9052_RTC_OSC_FRQ_MINUS_49_5ppm		(230)
> +#define DA9052_RTC_OSC_FRQ_MINUS_47_6ppm		(231)
> +#define DA9052_RTC_OSC_FRQ_MINUS_45_7ppm		(232)
> +#define DA9052_RTC_OSC_FRQ_MINUS_43_8ppm		(233)
> +#define DA9052_RTC_OSC_FRQ_MINUS_41_9ppm		(234)
> +#define DA9052_RTC_OSC_FRQ_MINUS_40_0ppm		(235)
> +#define DA9052_RTC_OSC_FRQ_MINUS_38_1ppm		(236)
> +#define DA9052_RTC_OSC_FRQ_MINUS_36_2ppm		(237)
> +#define DA9052_RTC_OSC_FRQ_MINUS_34_3ppm		(238)
> +#define DA9052_RTC_OSC_FRQ_MINUS_32_4ppm		(239)
> +#define DA9052_RTC_OSC_FRQ_MINUS_30_5ppm		(240)
> +#define DA9052_RTC_OSC_FRQ_MINUS_28_6ppm		(241)
> +#define DA9052_RTC_OSC_FRQ_MINUS_26_7ppm		(242)
> +#define DA9052_RTC_OSC_FRQ_MINUS_24_7ppm		(243)
> +#define DA9052_RTC_OSC_FRQ_MINUS_22_8ppm		(244)
> +#define DA9052_RTC_OSC_FRQ_MINUS_20_9ppm		(245)
> +#define DA9052_RTC_OSC_FRQ_MINUS_19_0ppm		(246)
> +#define DA9052_RTC_OSC_FRQ_MINUS_17_1ppm		(247)
> +#define DA9052_RTC_OSC_FRQ_MINUS_15_2ppm		(248)
> +#define DA9052_RTC_OSC_FRQ_MINUS_13_3ppm		(249)
> +#define DA9052_RTC_OSC_FRQ_MINUS_11_4ppm		(250)
> +#define DA9052_RTC_OSC_FRQ_MINUS_9_5ppm			(251)
> +#define DA9052_RTC_OSC_FRQ_MINUS_7_6ppm			(252)
> +#define DA9052_RTC_OSC_FRQ_MINUS_5_7ppm			(253)
> +#define DA9052_RTC_OSC_FRQ_MINUS_3_8ppm			(254)
> +#define DA9052_RTC_OSC_FRQ_MINUS_1_9ppm			(255)
> +
> +/* RTC error codes */
> +#define DA9052_RTC_INVALID_SECONDS			(3)
> +#define DA9052_RTC_INVALID_MINUTES			(4)
> +#define DA9052_RTC_INVALID_HOURS			(5)
> +#define DA9052_RTC_INVALID_DAYS				(6)
> +#define DA9052_RTC_INVALID_MONTHS			(7)
> +#define DA9052_RTC_INVALID_YEARS			(8)
> +#define DA9052_RTC_INVALID_EVENT			(9)
> +#define DA9052_RTC_INVALID_IOCTL			(10)
> +#define DA9052_RTC_INVALID_SETTING			(11)
> +#define DA9052_RTC_EVENT_ALREADY_REGISTERED		(12)
> +#define DA9052_RTC_EVENT_UNREGISTERED			(13)
> +#define DA9052_RTC_EVENT_REGISTRATION_FAILED		(14)
> +#define DA9052_RTC_EVENT_UNREGISTRATION_FAILED		(15)
> +
> +#endif /* _RTC_H */


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

