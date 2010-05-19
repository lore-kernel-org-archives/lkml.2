Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab0ESJ50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:57:26 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:23295 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531Ab0ESJ5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:57:24 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] RTC of DA9052 Linux device drivers (6/9)
Date: Wed, 19 May 2010 10:57:18 +0100
Message-ID: <3495EC08FA53E94AAA00CC4743D5BA7E010C20F6@pandora.diasemi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] RTC of DA9052 Linux device drivers (6/9)
Thread-Index: Acr3OasHH8/uTpB/RZahN3gRHD82QA==
From: "David Dajun Chen" <Dajun.Chen@diasemi.com>
To: <linux-kernel@vger.kernel.org>
Cc: <a.zummo@towertech.it>
X-OriginalArrivalTime: 19 May 2010 09:57:21.0513 (UTC) FILETIME=[ACA45D90:01CAF739]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear sir/madam,

The attached is the RTC part of the device drivers newly developed for DA9052 Power Management IC from Dialog Semiconductor.

Should you have any queries or comments please feel free to contact me.

Regards


Dr. David Dajun Chen
Dialog Semiconductor Ltd.
Delta 200, Welton Road
Delta Business Park
Swindon
Wiltshire SN5 7XB
UK
Telephone: (+44) 01793-757714
Mobile:         (+44) 07917015477
Fax:               (+44) 01793-758000
=========================================================================

diff -Naur linux-2.6.33.2_bk/drivers/mfd/Kconfig linux-2.6.33.2_patch/drivers/mfd/Kconfig
--- linux-2.6.33.2_bk/drivers/mfd/Kconfig	2010-05-18 17:54:30.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/mfd/Kconfig	2010-05-18 18:23:03.000000000 +0500
@@ -377,6 +377,13 @@
 	help
 	  Say Y  to enable the ADC driver for the DA9052 chip
 
+config DA9052_RTC_ENABLE
+	bool "Dialog Semiconductor DA9052 RTC Driver"
+	depends on MFD_DA9052
+	select RTC_CLASS
+	help
+	  Say Y  to enable the RTC driver for the DA9052 chip
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff -Naur linux-2.6.33.2_bk/drivers/rtc/da9052_rtc.c linux-2.6.33.2_patch/drivers/rtc/da9052_rtc.c
--- linux-2.6.33.2_bk/drivers/rtc/da9052_rtc.c	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/rtc/da9052_rtc.c	2010-05-18 18:23:03.000000000 +0500
@@ -0,0 +1,1229 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_rtc.c: Driver for RTC peripheral on DA9052 chip.
+ *
+ * History:
+ *
+ * (21/04/2009):	Created first draft
+ *
+ * (27/04/2010): 	Created initial draft for Linux community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+/*--------------------------------------------------------------------------*/
+/* System wide include files                                                */
+/*--------------------------------------------------------------------------*/
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <asm/uaccess.h>
+#include <linux/rtc.h>
+#include <asm/delay.h>
+#include <linux/platform_device.h>
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+#include <linux/mfd/da9052/da9052_reg.h>
+#include <linux/mfd/da9052/da9052_lib.h>
+#include <linux/mfd/da9052/da9052_eh.h>
+#include <linux/mfd/da9052/da9052_rtc.h>
+
+#ifndef CONFIG_ARCH_S3C64XX
+#include <linux/syscalls.h>
+#endif
+
+/*--------------------------------------------------------------------------*/
+/* Local Type Definitions                                                   */
+/*--------------------------------------------------------------------------*/
+s32 da9052_rtc_hw_init(void);
+static void da9052_rtc_hw_exit(void);
+s32 da9052_rtc_signal_to_user(u8 event);
+void da9052_rtc_alarm_handler(u32 event);
+s32 da9052_rtc_validate_parameters (da9052_rtc_data_t *rtc_tm);
+/*--------------------------------------------------------------------------*/
+/* Local Constant Definitions                                               */
+/*--------------------------------------------------------------------------*/
+static u8 banner[] __initdata = "DA9052 RTC Driver, v1.0\n";
+
+/*--------------------------------------------------------------------------*/
+/* Local Macro Definitions                                                  */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+static u8 rtc_device_open = 0;
+static s32 major_number = 0;
+static struct fasync_struct *rtc_fasync_queue;
+static struct platform_device *da9052_rtc_platform_device;
+static struct rtc_device *rtc;
+/* Stores last occured event */
+static u8 rtc_event;
+
+/* States whether ALARM event is registered with EH */
+static u8 is_eh_registered = CLEAR;
+
+/* States whether a user has registered for TIMER or TICK ALARM */
+static u8 is_timer_registered = CLEAR;
+static u8 is_tick_registered = CLEAR;
+
+/* EH structure for all possible events */
+da9052_eh_nb eh_data;
+
+/*--------------------------------------------------------------------------*/
+/* Local Functions                                                          */
+/*--------------------------------------------------------------------------*/
+
+/**
+ * da9052_rtc_hw_init: Initializes hardware with default settings
+ * 
+ * @param void
+ * @return s32   Error Code, zero: no error
+ */
+s32 da9052_rtc_hw_init(void)
+{
+	DA9052_DEBUG("I am in function: %s\n", __FUNCTION__);
+
+	/* While initializing set EH registration flag to 0 */
+	is_eh_registered = CLEAR;
+	
+	/* Set the flags to indicate, that user has not yet registered */
+	is_timer_registered = CLEAR;
+	is_tick_registered = CLEAR;
+	
+	return (SUCCESS);
+}
+
+/**
+ * da9052_rtc_hw_exit: Un-register events with EH
+ * 
+ * @param void
+ * @return void
+ */
+static void da9052_rtc_hw_exit(void)
+{
+	DA9052_DEBUG("I am in function: %s\n", __FUNCTION__);
+
+	/* Before exiting - unregister events with EH */
+	if (is_eh_registered) {
+		/* Un-register from the EH for the requested event */
+		da9052_eh_unregister_nb(&eh_data);
+	}
+
+	/* While exiting set EH registration flag to 0 */
+	is_eh_registered = CLEAR;
+}
+
+/**
+ * da9052_rtc_signal_to_user:	This function signal to the library to call 
+ *				the callback function for the event.
+ * 
+ * @param event			event for which library need to be signalled
+ * @return int			Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_rtc_signal_to_user(u8 event)
+{
+	rtc_event = event;
+	DA9052_DEBUG("%s: event status: %d \n", __FUNCTION__, event);
+	kill_fasync(&rtc_fasync_queue, SIGIO, POLL_IN);
+
+	return(SUCCESS);
+}
+
+/**
+ * da9052_rtc_alarm_handler : EH callback function for alarm event
+ * 
+ * @param u32 event	complete event status
+ * @return void
+ */
+void da9052_rtc_alarm_handler(u32 event)
+{
+	da9052_ssc_msg msg; 
+	DA9052_DEBUG("In RTC Event: %d\n",event);
+	/* Alarm event has occured */
+	/* Check the alarm type - TIMER or TICK */
+	msg.addr = DA9052_ALARMMI_REG;
+	if (da9052_ssc_read(&msg))
+		return ;
+	if (msg.data & DA9052_ALARMMI_ALARMTYPE) {
+		if (SET == is_timer_registered){
+			DA9052_DEBUG("RTC: TIMER ALARM\n");
+			da9052_rtc_signal_to_user(TIMER_ALARM);
+		}
+	} else {
+		if (SET == is_tick_registered){
+			DA9052_DEBUG("RTC: TICK ALARM\n");
+			da9052_rtc_signal_to_user(TICK_ALARM);
+		}
+	}
+}
+
+/**
+ * da9052_rtc_validate_parameters : Validate Parametrs function for input 
+ * variables
+ * 
+ * @param u32 event	complete event status
+ * @return int			Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_rtc_validate_parameters (da9052_rtc_data_t *rtc_tm)
+{
+	/* Input validation for limits */
+	
+	/*Check for Seconds */
+	if (rtc_tm->tm_sec > DA9052_RTC_SECONDS_LIMIT) {
+		DA9052_DEBUG("Invalid seconds value: %d\n",
+							rtc_tm->tm_sec);
+		return (DA9052_RTC_INVALID_SECONDS);
+	}
+	/*Check for Minutes */
+	if (rtc_tm->tm_min > DA9052_RTC_MINUTES_LIMIT) {
+		DA9052_DEBUG("Invalid minutes value: %d\n",
+							rtc_tm->tm_min);
+		return (DA9052_RTC_INVALID_MINUTES);
+	}
+	/*Check for Hours */
+	if (rtc_tm->tm_hour > DA9052_RTC_HOURS_LIMIT) {
+		DA9052_DEBUG("Invalid hours value: %d\n",
+							rtc_tm->tm_hour);
+		return (DA9052_RTC_INVALID_HOURS);
+	}
+	/*Check for Days */
+	if (rtc_tm->tm_mday == 0) {
+		DA9052_DEBUG("Invalid days value %d \n",
+							rtc_tm->tm_mday);
+		return (DA9052_RTC_INVALID_DAYS);
+	}
+	/*Check for MOnths */
+	if ((rtc_tm->tm_mon > DA9052_RTC_MONTHS_LIMIT) || (rtc_tm->tm_mon == 0)) {
+		DA9052_DEBUG("Invalid months value %d\n",
+							rtc_tm->tm_mon);
+		return (DA9052_RTC_INVALID_MONTHS);
+	}
+	/*Check for Years */
+	if (rtc_tm->tm_year > DA9052_RTC_YEARS_LIMIT) {
+		DA9052_DEBUG("Invalid years value %d\n",
+							rtc_tm->tm_year);
+		return (DA9052_RTC_INVALID_YEARS);
+	}
+	
+	if ((rtc_tm->tm_mon == FEBRUARY) ) {
+		/* Check for the leap year */
+		if (((rtc_tm->tm_year % 4 == 0) && (rtc_tm->tm_year % 100 != 0)) || 
+			(rtc_tm->tm_year % 400 == 0)) {
+			/* Condition satisfying leap year */
+			if (rtc_tm->tm_mday > 29)
+				return (DA9052_RTC_INVALID_DAYS);
+		}
+		else if (rtc_tm->tm_mday > 28)	{
+			/* Non leap Year Condition */
+			return (DA9052_RTC_INVALID_DAYS);
+		}
+	}
+	/* Check for the the months having 30 days */
+	if (((rtc_tm->tm_mon == APRIL )||(rtc_tm->tm_mon == JUNE ) || 
+		(rtc_tm->tm_mon == SEPTEMBER) || (rtc_tm->tm_mon == NOVEMBER)) && 
+		(rtc_tm->tm_mday == 31)) 
+		return (DA9052_RTC_INVALID_DAYS);
+	
+	return (SUCCESS);
+}
+
+/*--------------------------------------------------------------------------*/
+/* Global Functions                                                         */
+/*--------------------------------------------------------------------------*/
+/**
+ * da9052_set_rtc_time: Set the RTC time using the given input
+ * 
+ * @param rtc_tm   RTC time values
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_rtc_settime(da9052_rtc_data_t *rtc_tm)
+{
+
+	/* SSC data variable for multiple write */
+	da9052_ssc_msg msg_arr[6];
+	/* return value of validate param function */
+	s32 validate_param = 0;
+	/* SSC loop index */
+	u8 loop_index = 0;
+	/* Validate Input Parameters */ 
+	validate_param = da9052_rtc_validate_parameters(rtc_tm);
+	if (SUCCESS != validate_param)
+		return (validate_param);
+
+	/* Set Monitor bit to 1 and seconds value */
+	msg_arr[loop_index].addr = DA9052_COUNTS_REG;
+	msg_arr[loop_index++].data = DA9052_COUNTS_MONITOR | rtc_tm->tm_sec;
+		
+	/* Set the Minutes value */
+	msg_arr[loop_index].addr = DA9052_COUNTMI_REG;
+	msg_arr[loop_index].data = 0;
+	msg_arr[loop_index++].data = rtc_tm->tm_min;
+	
+	/* Form the Hour register value */
+	msg_arr[loop_index].addr = DA9052_COUNTH_REG;
+	msg_arr[loop_index].data = 0;
+	msg_arr[loop_index++].data = rtc_tm->tm_hour;
+	
+	/* Form the Days register value */
+	msg_arr[loop_index].addr = DA9052_COUNTD_REG;
+	msg_arr[loop_index].data = 0;
+	msg_arr[loop_index++].data = rtc_tm->tm_mday;
+	
+	/* Form the Months register value */
+	msg_arr[loop_index].addr = DA9052_COUNTMO_REG;
+	msg_arr[loop_index].data = 0;
+	msg_arr[loop_index++].data = rtc_tm->tm_mon;
+	
+	/* Assign to SSC multi write variable */
+	msg_arr[loop_index].addr = DA9052_COUNTY_REG;
+	msg_arr[loop_index].data = 0;
+	msg_arr[loop_index++].data = rtc_tm->tm_year;
+	
+	
+	/*Perform Multi write Operation */
+	if (SUCCESS !=  da9052_ssc_write_many(msg_arr,loop_index))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+/**
+ * da9052_get_rtc_time: Read the RTC time and set it to out parameter
+ * 
+ * @param rtc_tm   Out parameter, represents the RTC time value
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_rtc_gettime(da9052_rtc_data_t *rtc_tm)
+{
+
+	/* SSC data variable */
+	da9052_ssc_msg msg[6];
+	/* SSC array index */
+	u8 loop_index = 0;
+	
+	/* Read Seconds value */
+	msg[loop_index].data = 0;
+	msg[loop_index++].addr = DA9052_COUNTS_REG;
+	/* Read Minutes value */
+	msg[loop_index].data = 0;
+	msg[loop_index++].addr = DA9052_COUNTMI_REG;
+	/* Read Hours value */
+	msg[loop_index].data = 0;
+	msg[loop_index++].addr = DA9052_COUNTH_REG;
+	/* Read Days value */
+	msg[loop_index].data = 0;
+	msg[loop_index++].addr = DA9052_COUNTD_REG;
+	/* Read Months value */
+	msg[loop_index].data = 0;
+	msg[loop_index++].addr = DA9052_COUNTMO_REG;
+	/* Read Years value */
+	msg[loop_index].data = 0;
+	msg[loop_index++].addr = DA9052_COUNTY_REG;
+	
+	/* use SSC multi read functionality */
+	if (da9052_ssc_read_many(msg, loop_index))
+		return (FAILURE);
+	
+	/*Assign Read values */
+	/*Assign Year value */
+	rtc_tm->tm_year = msg[--loop_index].data & DA9052_COUNTY_COUNTYEAR;
+	/*Assign Month value */
+	rtc_tm->tm_mon = msg[--loop_index].data & DA9052_COUNTMO_COUNTMONTH;
+	/*Assign Days value */
+	rtc_tm->tm_mday = msg[--loop_index].data & DA9052_COUNTD_COUNTDAY; 
+	/*Assign Hours value */
+	rtc_tm->tm_hour = msg[--loop_index].data & DA9052_COUNTH_COUNTHOUR;
+	/*Assign Minutes value */
+	rtc_tm->tm_min = msg[--loop_index].data & DA9052_COUNTMI_COUNTMIN;
+	/*Assign Seconds value */
+	rtc_tm->tm_sec = msg[--loop_index].data & DA9052_COUNTS_COUNTSEC;
+	
+	return (SUCCESS);
+}
+
+/**
+ * da9052_set_alarm_time: Set alarm time
+ * 
+ * @param rtc_tm   Alarm time value
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_alarm_settime(da9052_rtc_data_t *rtc_tm)
+{
+	/* SSC data variable for multiple write */
+	da9052_ssc_msg msg_arr[5];
+	/* SSC data variable for single read */
+	da9052_ssc_msg msg;
+	/* return value of validate param function */
+	s32 validate_param = 0;
+	/* SSC loop index */
+	u8 loop_index = 0;
+	
+	
+	/* As DA9052 does not support the Seconds Alarm */ 
+	rtc_tm->tm_sec = 0;
+	
+	/* Validate Input Parameters */ 
+	validate_param = da9052_rtc_validate_parameters(rtc_tm);
+	if (SUCCESS != validate_param)
+		return (validate_param);
+
+	/* Set the Minutes value */
+	/*Read the current register */
+	/* Modify only minute bits */
+	msg.addr = DA9052_ALARMMI_REG;
+	msg.data = 0;
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+	msg.data = clear_bits (msg.data, DA9052_ALARMMI_ALARMMIN);
+	msg.data |= rtc_tm->tm_min;
+	/* Assign the read & updated minutes value to write register arary */
+	msg_arr[loop_index].addr = DA9052_ALARMMI_REG;
+	msg_arr[loop_index].data = 0;
+	msg_arr[loop_index++].data = msg.data;	
+	
+	/* Form the Hour register value */
+	msg_arr[loop_index].addr = DA9052_ALARMH_REG;
+	msg_arr[loop_index].data = 0;
+	msg_arr[loop_index++].data = rtc_tm->tm_hour;
+	
+	/* Form the Days register value */
+	msg_arr[loop_index].addr = DA9052_ALARMD_REG;
+	msg_arr[loop_index].data = 0;
+	msg_arr[loop_index++].data = rtc_tm->tm_mday;
+	
+	/* Form the Months register value */
+	msg_arr[loop_index].addr = DA9052_ALARMMO_REG;
+	msg_arr[loop_index].data = 0;
+	msg_arr[loop_index++].data = rtc_tm->tm_mon;
+	
+	/* Form the Year register value */
+	msg.addr = DA9052_ALARMY_REG;
+	msg.data = 0;
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+	msg.data = clear_bits (msg.data, DA9052_ALARMY_ALARMYEAR);
+	msg.data |= rtc_tm->tm_year;
+	/* Assign to SSC multi write variable */
+	msg_arr[loop_index].addr = DA9052_ALARMY_REG;
+	msg_arr[loop_index].data = 0;
+	msg_arr[loop_index++].data = msg.data;
+	
+	
+	/*Perform Multi write Operation */
+	if (SUCCESS !=  da9052_ssc_write_many(msg_arr, loop_index))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_alarm_gettime: Read the alarm time and set it to out parameter
+ * 
+ * @param da9052_alarm_gettime   Out parameter, represents the RTC time value
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_alarm_gettime(da9052_rtc_data_t *rtc_tm)
+{
+	/* SSC data variable */
+	da9052_ssc_msg msg[5];
+	/* SSC array index */
+	u8 loop_index = 0;
+		
+	/* Read Minutes value */
+	msg[loop_index].data = 0;
+	msg[loop_index++].addr = DA9052_ALARMMI_REG;
+	/* Read Hours value */
+	msg[loop_index].data = 0;
+	msg[loop_index++].addr = DA9052_ALARMH_REG;
+	/* Read Days value */
+	msg[loop_index].data = 0;
+	msg[loop_index++].addr = DA9052_ALARMD_REG;
+	/* Read Months value */
+	msg[loop_index].data = 0;
+	msg[loop_index++].addr = DA9052_ALARMMO_REG;
+	/* Read Years value */
+	msg[loop_index].data = 0;
+	msg[loop_index++].addr = DA9052_ALARMY_REG;
+	
+	/* use SSC multi read functionality */
+	if (da9052_ssc_read_many (msg, loop_index))
+		return (FAILURE);
+	
+	/*Assign Read values */
+	/*Assign Year value */
+	rtc_tm->tm_year = msg[--loop_index].data & DA9052_ALARMY_ALARMYEAR;
+	/*Assign Month value */
+	rtc_tm->tm_mon = msg[--loop_index].data & DA9052_ALARMMO_ALARMMONTH;
+	/*Assign Days value */
+	rtc_tm->tm_mday = msg[--loop_index].data & DA9052_ALARMD_ALARMDAY; 
+	/*Assign Hours value */
+	rtc_tm->tm_hour = msg[--loop_index].data & DA9052_ALARMH_ALARMHOUR;
+	/*Assign Minutes value */
+	rtc_tm->tm_min = msg[--loop_index].data & DA9052_ALARMMI_ALARMMIN;
+	
+	return (SUCCESS);
+}
+
+/**
+ * da9052_rtc_getelapsedtime: Read elapsed time after power on reset
+ * 
+ * @param elapsed_time   Out parameter, represents the elapsed time value
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_rtc_getelapsedtime(u32 *elapsed_time)
+{
+	/* SSC many data structure */
+	da9052_ssc_msg ssc_msg[4];
+	s32 seconds = 0;	/* Final seconds value */
+	u8 index = 0;	/* Count fro number of registers to be read */
+	
+	/* Lower Byte of Lower Word: Register A */
+	ssc_msg[index++].addr = DA9052_SECONDA_REG;
+	
+	/* Upper Byte of Lower Word: Register B */
+	ssc_msg[index++].addr = DA9052_SECONDB_REG;
+	
+	/* Lower Byte of Upper Word: Register C */
+	ssc_msg[index++].addr = DA9052_SECONDC_REG;
+	
+	/* Upper Byte of Upper Word: Register D */
+	ssc_msg[index++].addr = DA9052_SECONDD_REG;
+	
+	/* Call the SSC Multiple Read */
+	if (SUCCESS != da9052_ssc_read_many(ssc_msg,index))
+		return (FAILURE);
+	
+	/* Assign the values to the various registers */
+	/* Get the value of Upper Byte of Upper Word */
+	seconds |= (ssc_msg[--index].data << DA9052_RTC_FOURTH_BYTE);  
+	/* Get the value of Lower Byte of Upper Word */
+	seconds |= (ssc_msg[--index].data << DA9052_RTC_THIRD_BYTE);
+	/* Get the value of Upper Byte of Lower Word */
+	seconds |= (ssc_msg[--index].data << DA9052_RTC_SECOND_BYTE);
+	/* Get the value of Lower Byte of Lower Word */
+	seconds |= (ssc_msg[--index].data << DA9052_RTC_FIRST_BYTE);
+		
+	/* Assign value to the user space variable */
+	*elapsed_time = seconds;
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_rtc_enablealarm: Enable/Disable Alarm
+ * 
+ * @param flag   1 = Enable Alarm, 0 = Disable Alarm
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_rtc_enablealarm(u8 flag)
+{
+	da9052_ssc_msg msg;
+
+	/* Read ALARM YEAR register */
+	msg.addr = DA9052_ALARMY_REG;
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+	if (ENABLE == flag)
+		/* Enable ALARM */
+		msg.data = set_bits(msg.data, DA9052_ALARMY_ALARMON);
+	else if (DISABLE == flag)
+		/* Disable ALARM */
+		msg.data = clear_bits(msg.data, DA9052_ALARMY_ALARMON);
+	else
+		return (DA9052_RTC_INVALID_SETTING);
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_rtc_enabletick: Enable/Disable TICK Alarm
+ * 
+ * @param flag   1 = Enable Alarm, 0 = Disable Alarm
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_rtc_enabletick(u8 flag)
+{
+	da9052_ssc_msg msg;
+
+	/* Read ALARM YEAR register */
+	msg.addr = DA9052_ALARMY_REG;
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+	if(ENABLE == flag)
+		/* Enable TICK ALARM */
+		msg.data = set_bits(msg.data, DA9052_ALARMY_TICKON);
+	else if (DISABLE == flag)
+		/* Disable TICK ALARM */
+		msg.data = clear_bits(msg.data, DA9052_ALARMY_TICKON);
+	else
+		return (DA9052_RTC_INVALID_SETTING);
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_rtc_setticktype: Set TICK Alarm to 1 minute or 1 sec
+ * 
+ * @param flag   1 = 1 minute, 0 = 1 second
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_rtc_setticktype(u8 flag)
+{
+	da9052_ssc_msg msg;
+
+	/* Read ALARM MINUTES register */
+	msg.addr = DA9052_ALARMMI_REG;
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+	if(ENABLE == flag)
+		/* Enable 1 min TICK ALARM */
+		msg.data = set_bits(msg.data, DA9052_ALARMMI_TICKTYPE);
+	else if (DISABLE == flag)
+		/* Enable 1 sec TICK ALARM */
+		msg.data = clear_bits(msg.data, DA9052_ALARMMI_TICKTYPE);
+	else
+		return (DA9052_RTC_INVALID_SETTING);
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_rtc_setbuffer: Enable/Disable Clock buffer in Power Down Mode
+ * 
+ * @param flag   1 = Enable, 0 = Disable
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_rtc_setbuffer(u8 flag)
+{
+	da9052_ssc_msg msg;
+
+	/* Read Power Down disable register */
+	msg.addr = DA9052_PDDIS_REG;
+	if (da9052_ssc_read(&msg))
+		return (FAILURE);
+
+	/* For DA9052, bit value = 0 => buffer enabled 
+		bit value = 1 => buffer disabled */
+	if ( DISABLE == flag)
+		/* Enable Buffer */
+		msg.data = set_bits(msg.data, DA9052_PDDIS_OUT32KPD);
+	else if (ENABLE == flag)
+		/* Disable Buffer */
+		msg.data = clear_bits(msg.data, DA9052_PDDIS_OUT32KPD);
+	else 
+		return (DA9052_RTC_INVALID_SETTING);
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_rtc_setclktrimfreq: Set clock trim frequency value
+ * 
+ * @param value  Trim frequency value
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_rtc_setclktrimfreq(u8 value)
+{
+	/* Form SSC Write Data structure */
+	da9052_ssc_msg msg;
+	msg.addr = DA9052_OSCTRIM_REG;
+	msg.data = value;
+
+	/* Write trim frequency */
+	if (da9052_ssc_write(&msg))
+		return (FAILURE);
+	return (SUCCESS);
+}
+
+/**
+ * da9052_rtc_register_event : Register RTC event with EH
+ * 
+ * @param u8 event_type	Alarm Event Type
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_rtc_register_event(u8 event_type)
+{
+	DA9052_DEBUG("I am in function: %s \n", __FUNCTION__);
+
+	/* Check event type */
+	switch (event_type) {
+	case TIMER_ALARM:
+		/* Flag - timer alaram is registered by the user */
+		is_timer_registered = SET;
+		break;
+	case TICK_ALARM:
+		/* Flag - tick alaram is registered by the user */
+		is_tick_registered = SET;
+		break;
+	default:
+		return (DA9052_RTC_INVALID_EVENT);
+	}
+	/* Check if event is already registered */
+	if (CLEAR == is_eh_registered) {
+		/* Set the EH data structure to register the ALARM event */
+		eh_data.eve_type = ALARM_EVE;
+		eh_data.call_back = &da9052_rtc_alarm_handler;
+
+		/* Register to the EH for the requested event */
+		if (SUCCESS == da9052_eh_register_nb(&eh_data)) {
+			/* Set flag that event is registered with EH */
+			is_eh_registered = 1;
+
+			DA9052_DEBUG("\nEvent is registered\n");
+		} else {
+			/* Set flag that event is not registered with EH */
+			is_eh_registered = CLEAR;
+			/* Registration failed */
+			is_timer_registered = CLEAR;
+			is_tick_registered = CLEAR;
+			
+			return (DA9052_RTC_EVENT_REGISTRATION_FAILED);
+		}
+	}
+    else
+    {
+        return (DA9052_RTC_EVENT_ALREADY_REGISTERED);
+    }
+	return (SUCCESS);
+}
+
+/**
+ * da9052_rtc_unregister_event : Un-register RTC event with EH
+ * 
+ * @param u8 event_type	Event Number
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_rtc_unregister_event(u8 event_type)
+{
+	/* Check event type */
+	switch (event_type) {
+	case TIMER_ALARM:
+		/* Flag - timer alaram is unregistered by the user */
+		is_timer_registered = CLEAR;
+		break;
+	case TICK_ALARM:
+		/* Flag - tick alaram is unregistered by the user */
+		is_tick_registered = CLEAR;
+		break;
+	default:
+		return (DA9052_RTC_INVALID_EVENT);
+	}
+
+	DA9052_DEBUG("I am in function: %s \n", __FUNCTION__);
+
+	/* Check if timer or tick alram is still registerd */
+	/* If yes, do not unregister with EH */
+	if ((!(is_timer_registered | is_tick_registered)) && is_eh_registered) {
+		/* Un-register to the EH for the requested event */
+		if (SUCCESS == da9052_eh_unregister_nb(&eh_data)) {
+			/* Set flag that event is not registered with EH */
+			is_eh_registered = 0;
+		} else {
+			/* Unregistration failed */
+			return (DA9052_RTC_EVENT_UNREGISTRATION_FAILED);
+		}
+	}
+    else
+    {
+        // Unregistering the Unregistered Event
+        return (DA9052_RTC_EVENT_UNREGISTERED);
+    }
+	return (SUCCESS);
+}
+
+/*--------------------------------------------------------------------------*/
+/* Infrastructure Functions						    */
+/*--------------------------------------------------------------------------*/
+/**
+ * da9052_rtc_open: Open the device
+ * 
+ * @param *inode pointer to device inode
+ * @param *file  file pointer
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_rtc_open(struct inode *inode, struct file *file)
+{
+	/* Check if device is already open */
+	if(rtc_device_open == OPEN) {
+		DA9052_DEBUG("DA9052: RTC device already open.\n");
+		return (-EBUSY);
+	} else {
+		rtc_device_open++;
+		return (SUCCESS);
+	}
+}
+
+/**
+ * da9052_rtc_release: Release the device
+ * 
+ * @param *inode pointer to device inode
+ * @param *file  file pointer
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_rtc_release(struct inode *inode, struct file *file)
+{
+	rtc_device_open--;
+	DA9052_DEBUG("DA9052: RTC device closed.\n");
+	return (SUCCESS);
+}
+
+/**
+ * da9052_rtc_suspend: Power Management support function
+ * 
+ * @param *dev   pointer to platform device
+ * @param state  pm state
+ * @return 0
+ */
+static s32 da9052_rtc_suspend(struct platform_device *dev, pm_message_t state)
+{
+	/* Put your suspend related operations here */
+	printk(KERN_INFO "%s: called\n", __FUNCTION__);
+    return (0);
+}
+
+/**
+ * da9052_rtc_resume: Power Management support function
+ * 
+ * @param *dev   pointer to platform device
+ * @return 0
+ */
+static s32 da9052_rtc_resume(struct platform_device *dev)
+{
+	/* Put your resume related operations here */
+    printk(KERN_INFO "%s: called\n", __FUNCTION__);
+    return (0);
+}
+
+/**
+ * da9052_rtc_ioctl: Provides the IOCTL interface
+ * 
+ * @param *inode   pointer to device inode
+ * @param *file   file pointer
+ * @param cmd   command to be executed
+ * @param arg   argument to command
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_rtc_ioctl(struct inode *inode, struct file *file,
+        unsigned int cmd, unsigned long arg)
+{
+	da9052_rtc_data_t usr_param, *ptr;
+	s32 return_value;
+	u32 elapsed_time;
+	u8 input;
+	ptr = (da9052_rtc_data_t *) arg;
+
+	/* Check the IOCTL command */
+	switch(cmd) {
+	case DA9052_RTC_IOCTL_SET_TIME:
+	/* Input Parameter - da9052_rtc_data_t* */
+		DA9052_DEBUG("%s():DA9052_RTC_IOCTL_SET_TIME called\n",
+								__FUNCTION__);
+		/* Copy parameters from user space */
+		if (copy_from_user(&usr_param, ptr, sizeof(da9052_rtc_data_t)))
+			return (FAILURE);
+		return (da9052_rtc_settime(&usr_param));
+		break;
+	case DA9052_RTC_IOCTL_GET_TIME:
+	/* Out Parameter - da9052_rtc_data_t* */
+		DA9052_DEBUG("%s():DA9052_RTC_IOCTL_GET_TIME called\n",
+								__FUNCTION__);
+		return_value = da9052_rtc_gettime(&usr_param);
+		if (return_value != SUCCESS)
+			return(return_value);
+
+			/* Copy parameters to user space */
+		if (copy_to_user(ptr, &usr_param, sizeof(da9052_rtc_data_t)))
+			return (FAILURE);
+		break;
+	case DA9052_RTC_IOCTL_SET_ALARM:
+	/* Input Parameter - da9052_rtc_data_t* */
+		DA9052_DEBUG("%s():DA9052_RTC_IOCTL_SET_ALARM called\n",
+								__FUNCTION__);
+		/* Copy parameters from user space */
+		if (copy_from_user(&usr_param, ptr, sizeof(da9052_rtc_data_t)))
+			return (FAILURE);
+
+		return (da9052_alarm_settime(&usr_param));
+		break;
+	case DA9052_RTC_IOCTL_GET_ALARM:
+	/* Out Parameter - da9052_rtc_data_t* */
+		DA9052_DEBUG("%s():DA9052_RTC_IOCTL_GET_ALARM called\n",
+								__FUNCTION__);
+		return_value = da9052_alarm_gettime(&usr_param);
+		if (return_value != SUCCESS)
+			return (return_value);
+		/* Copy parameters to user space */
+		if (copy_to_user(ptr, &usr_param, sizeof(da9052_rtc_data_t)))
+			return (FAILURE);
+		break;
+	case DA9052_RTC_IOCTL_GET_TIMEELAPSED:
+	/* Out Parameter - da9052_rtc_data_t* */
+		DA9052_DEBUG("%s():DA9052_RTC_IOCTL_GET_TIMEELAPSED called\n",
+								__FUNCTION__);
+		return_value = da9052_rtc_getelapsedtime(&elapsed_time);
+		if (return_value != SUCCESS)
+			return (return_value);
+		/* Copy parameters to user space */
+		if (copy_to_user((u32*)arg, &elapsed_time, sizeof(u32)))
+			return (FAILURE);
+		break;
+	case DA9052_RTC_IOCTL_ENABLEALARM:
+	/* Input Parameter - unsigned char */
+		DA9052_DEBUG("%s():DA9052_RTC_IOCTL_ENABLEALARM called\n",
+								__FUNCTION__);
+		/* Copy parameters from user space */
+		if (copy_from_user(&input, (u8*)arg, sizeof(u8)))
+			return (FAILURE);
+		return (da9052_rtc_enablealarm(input));
+		break;
+	case DA9052_RTC_IOCTL_ENABLETICK:
+	/* Input Parameter - unsigned char */
+		DA9052_DEBUG("%s():DA9052_RTC_IOCTL_ENABLETICK called\n",
+								__FUNCTION__);
+		/* Copy parameters from user space */
+		if (copy_from_user(&input, (u8*)arg, sizeof(u8)))
+			return (FAILURE);
+		return (da9052_rtc_enabletick(input));
+		break;
+	case DA9052_RTC_IOCTL_SET_TICKTYPE:
+	/* Input Parameter - unsigned char */
+		DA9052_DEBUG("%s():DA9052_RTC_IOCTL_SET_TICKTYPE called\n",
+								__FUNCTION__);
+		/* Copy parameters from user space */
+		if (copy_from_user(&input, (u8*)arg, sizeof(u8)))
+			return (FAILURE);
+		return (da9052_rtc_setticktype(input));
+		break;
+	case DA9052_RTC_IOCTL_SET_CLKBUFFER:
+	/* Input Parameter - unsigned char */
+		DA9052_DEBUG("%s():DA9052_RTC_IOCTL_SET_CLKBUFFER called\n",
+								__FUNCTION__);
+		/* Copy parameters from user space */
+		if (copy_from_user(&input, (u8*)arg, sizeof(u8)))
+			return (FAILURE);
+		return (da9052_rtc_setbuffer(input));
+		break;
+	case DA9052_RTC_IOCTL_SET_TRIMFREQ:
+	/* Input Parameter - unsigned char */
+		DA9052_DEBUG("%s():DA9052_RTC_IOCTL_SET_TRIMFREQ called\n",
+								__FUNCTION__);
+		/* Copy parameters from user space */
+		if (copy_from_user(&input, (u8*)arg, sizeof(u8)))
+			return (FAILURE);
+		return (da9052_rtc_setclktrimfreq(input));
+		break;
+	case DA9052_RTC_IOCTL_GET_EVENT:
+	/* Out Parameter - unsigned char* */
+		if(copy_to_user((u8 *)arg, &rtc_event, sizeof(u8)))
+			return (FAILURE);
+		break;
+	case DA9052_RTC_IOCTL_REGISTER_EVENT:
+	/* Input Parameter - unsigned char* */
+		if (copy_from_user(&input, (u8*) arg, sizeof(input)))
+			return (FAILURE);
+		return (da9052_rtc_register_event(input));
+		break;
+	case DA9052_RTC_IOCTL_UNREGISTER_EVENT:
+	/* Input Parameter - unsigned char* */
+		if (copy_from_user(&input, (u8*) arg, sizeof(input)))
+			return (FAILURE);
+		return (da9052_rtc_unregister_event(input));
+		break;
+	default:
+		DA9052_DEBUG("Invalid ioctl command\n");
+		return (DA9052_RTC_INVALID_IOCTL);
+	}
+	return (SUCCESS);
+}
+
+/**
+ * da9052_rtc_class_ops_gettime: Provides the RTC get time functionality
+ * 
+ * @param *dev   pointer to rtc device
+ * @param *tm   rtc data structure pointer
+ * @return s32   Error Code, zero: no error
+ */
+static s32 da9052_rtc_class_ops_gettime (struct device *dev, struct rtc_time *tm)
+{
+	s32 ret;
+	da9052_rtc_data_t rtc_tm;
+	ret = da9052_rtc_gettime(&rtc_tm);
+	if (SUCCESS != da9052_rtc_gettime(&rtc_tm))
+		return (FAILURE);
+	tm->tm_sec	= rtc_tm.tm_sec;
+	tm->tm_min	= rtc_tm.tm_min;
+	tm->tm_hour	= rtc_tm.tm_hour;
+	tm->tm_mday	= rtc_tm.tm_mday;
+	tm->tm_mon	= rtc_tm.tm_mon;
+	tm->tm_hour	= rtc_tm.tm_hour;
+	return (SUCCESS);
+}
+
+/**
+ * da9052_rtc_class_ops_settime: Provides the RTC get time functionality
+ * 
+ * @param *dev   pointer to rtc device
+ * @param *tm   rtc data structure pointer
+ * @return s32   Error Code, zero: no error
+ */
+static s32 da9052_rtc_class_ops_settime (struct device *dev, struct rtc_time *tm)
+{
+	s32 ret;
+	da9052_rtc_data_t rtc_tm;
+	rtc_tm.tm_sec	= tm->tm_sec;
+	rtc_tm.tm_min	= tm->tm_min;
+	rtc_tm.tm_hour	= tm->tm_hour;
+	rtc_tm.tm_mday	= tm->tm_mday;
+	rtc_tm.tm_mon	= tm->tm_mon;
+	rtc_tm.tm_hour	= tm->tm_hour;
+	ret = da9052_rtc_settime(&rtc_tm);
+	return (ret);
+}
+
+/**
+ * da9052_rtc_class_ops_ioctl: Provides the RTC IOCTL functionality
+ * 
+ * @param *dev   pointer to rtc device
+ * @param cmd   rtc command to be executed
+ * @param arg   rtc arguments
+ * @return s32   Error Code, zero: no error
+ */
+static s32 da9052_rtc_class_ops_ioctl (struct device *dev, unsigned int cmd,\
+				unsigned long arg)
+{
+	s32 ret;
+	struct inode *inode	= NULL;
+	struct file *file	= NULL;
+	printk (KERN_CRIT "IN IOCTL\n\n");
+	switch (cmd ){
+		/* Set RTC time */
+		case RTC_SET_TIME:
+		ret = da9052_rtc_ioctl(inode,file,DA9052_RTC_IOCTL_SET_TIME, arg);
+		break;
+		/* Read RTC time */
+		case RTC_RD_TIME:
+		ret = da9052_rtc_ioctl(inode,file,DA9052_RTC_IOCTL_GET_TIME, arg);
+		break;
+		/* Set Alarm Time */
+		case RTC_ALM_SET:
+		ret = da9052_rtc_ioctl(inode, file, DA9052_RTC_IOCTL_SET_ALARM, arg);
+		break;
+		/* Read Alarm Time */
+		case RTC_ALM_READ:
+		ret = da9052_rtc_ioctl(inode, file, DA9052_RTC_IOCTL_GET_ALARM, arg);
+		break;
+		/* Set Alarm Rate 1min or 1Sec */
+		case RTC_IRQP_SET:
+		ret = da9052_rtc_ioctl(inode, file, DA9052_RTC_IOCTL_GET_ALARM, arg);
+		break;
+		default:
+		return (-ENOIOCTLCMD);
+	}
+	return (ret);
+}
+
+/**
+ * da9052_rtc_ops: Provides the RTC operations
+ * 
+ * @param *read_time   pointer to rtc read time function
+ * @param *set_time    pointer to rtc set time function
+ * @param *ioctl       rtc ioctl interface
+ */
+static const struct rtc_class_ops da9052_rtc_ops = {
+	.read_time	= da9052_rtc_class_ops_gettime,
+	.set_time	= da9052_rtc_class_ops_settime,
+	.ioctl		= da9052_rtc_class_ops_ioctl,
+};
+
+/**
+ * da9052_rtc_fasync:	Register file descriptor asynchronous notification 
+ *			for events
+ *
+ * @param s32 fd		File descriptor
+ * @param strcut file *filp 	File structure
+ * @param s32 on		fasync state
+ * @return s32			Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_rtc_fasync(s32 fd, struct file *filp, s32 on)
+{
+	s32 ret;
+	DA9052_DEBUG("__%s__\n", __FUNCTION__);
+	DA9052_DEBUG ("In %s: %s\n",__FILE__, __FUNCTION__);
+	ret = fasync_helper(fd, filp, on, &rtc_fasync_queue);
+	DA9052_DEBUG("Ret from fasync_helper = %d \n", ret);
+	return (ret);
+}
+
+/**
+ * static struct file_operations da9052_rtc_fops -
+ * This structure definition has to be defined here as an exception.
+ * @owner: member description
+ * @open : member description
+ * @release: member description
+ * @ioctl: member description
+ *
+ */
+static const struct file_operations da9052_rtc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= da9052_rtc_open,
+	.release	= da9052_rtc_release,
+	.ioctl		= da9052_rtc_ioctl,
+	.fasync		= da9052_rtc_fasync
+};
+
+/**
+ * da9052_rtc_probe: Called when a device gets attached to driver
+ * 
+ * @param *dev   pointer to platform device
+ * @return int   Error Code, zero: no error
+ */
+static int __devinit da9052_rtc_probe(struct platform_device *dev)
+{
+	s32 ret;
+	
+	/* Register the device */
+	ret = register_chrdev(major_number, DA9052_RTC_DEVICE_NAME,
+							&da9052_rtc_fops);
+	if(ret < 0) {
+		printk("DA9052: Unable to get major number.\n");
+		return (-EFAULT);	
+	} else {
+		major_number = ret;
+		printk(KERN_INFO "%s: Major number is: %d.\n",
+				DA9052_RTC_DEVICE_NAME, major_number);
+		rtc	= rtc_device_register("da9052-rtc", &dev->dev,
+					  &da9052_rtc_ops, THIS_MODULE);
+		if (IS_ERR(rtc))
+		{
+			printk (KERN_CRIT "\n \nError \n");
+			return PTR_ERR(rtc);
+		}
+		if (da9052_rtc_hw_init()) {
+			printk(KERN_INFO"DA9052: Failed to initialize \
+							DA9052 Device.\n");
+			unregister_chrdev(major_number, DA9052_RTC_DEVICE_NAME);
+			return (-EFAULT);
+		} else {
+			return (SUCCESS);
+		}
+	}
+}
+
+/**
+ * da9052_rtc_remove: Called when detaching device from driver
+ * @param *dev   pointer to platform device
+ * @return int   Error Code, zero: no error
+ */
+static int __devexit da9052_rtc_remove(struct platform_device *dev)
+{
+	DA9052_DEBUG("Removing %s \n", DA9052_RTC_DEVICE_NAME);
+	rtc_device_unregister (rtc);
+	return (SUCCESS);
+}
+
+/**
+ * static struct platform_driver da9052_rtc_driver -
+ * This structure definition has to be defined here as an exception.
+ * @probe: Probe function for this device.
+ * @remove: Function to be called when removing this device from platform
+ * @suspend: Function to be called in suspend mode
+ * @resume: Function to be called in resume mode
+ * @driver: Contains glue logic to bind platform device and plarform driver
+ */
+static struct platform_driver da9052_rtc_driver = {
+	.probe		= da9052_rtc_probe,
+	.remove		= __devexit_p(da9052_rtc_remove),
+	.suspend	= da9052_rtc_suspend,
+	.resume		= da9052_rtc_resume,
+	.driver		= {
+		.name	= DA9052_RTC_DEVICE_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+/**
+ * da9052_rtc_init: Initiates the driver
+ * 
+ * @param int
+ * @return int   Error Code, zero: no error
+ */
+static int __init da9052_rtc_init(void)
+{
+	int retval;
+	printk(banner);
+
+	/* Create a platform device object */
+	da9052_rtc_platform_device =
+			platform_device_alloc(DA9052_RTC_DEVICE_NAME, 0);
+	if (!da9052_rtc_platform_device)
+		return (-ENOMEM);
+
+	/* Add platform device to device hierarchy */
+	retval = platform_device_add(da9052_rtc_platform_device);
+	if (retval < 0) {
+		/* Free all memory associated with a platform device */
+		platform_device_put(da9052_rtc_platform_device);
+		return (retval);
+	}
+
+	retval = platform_driver_register(&da9052_rtc_driver);
+	if (retval < 0)
+		/* Unregister the platform level device */
+		platform_device_unregister(da9052_rtc_platform_device);
+	return (retval);
+}
+
+/**
+ * da9052_rtc_exit: Closes the driver
+ * 
+ * @param void
+ * @return void
+ */
+static void __exit da9052_rtc_exit(void)
+{
+	printk("DA9052: Unregistering RTC device.\n");
+
+	/* De-initializes */
+	da9052_rtc_hw_exit();
+
+	/* Unregister the driver */
+	unregister_chrdev(major_number, DA9052_RTC_DEVICE_NAME);
+
+	platform_driver_unregister(&da9052_rtc_driver);
+	/* Unregister the platform level device */
+	platform_device_unregister(da9052_rtc_platform_device);
+}
+
+module_init(da9052_rtc_init);
+module_exit(da9052_rtc_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd");
+MODULE_DESCRIPTION("DA9052 RTC Device Driver");
+MODULE_LICENSE("GPL");
+/*--------------------------------------------------------------------------*/
+/* Exports                                                                  */
+/*--------------------------------------------------------------------------*/
+
+/* All functions accessible from other drivers */
+EXPORT_SYMBOL(da9052_rtc_settime);
+EXPORT_SYMBOL(da9052_rtc_gettime);
+EXPORT_SYMBOL(da9052_alarm_settime);
+EXPORT_SYMBOL(da9052_alarm_gettime);
+EXPORT_SYMBOL(da9052_rtc_getelapsedtime);
+EXPORT_SYMBOL(da9052_rtc_enablealarm);
+EXPORT_SYMBOL(da9052_rtc_enabletick);
+EXPORT_SYMBOL(da9052_rtc_setticktype);
+EXPORT_SYMBOL(da9052_rtc_setbuffer);
+EXPORT_SYMBOL(da9052_rtc_setclktrimfreq);
+/* END OF FILE */
diff -Naur linux-2.6.33.2_bk/drivers/rtc/Makefile linux-2.6.33.2_patch/drivers/rtc/Makefile
--- linux-2.6.33.2_bk/drivers/rtc/Makefile	2010-04-02 04:02:33.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/rtc/Makefile	2010-05-18 18:23:03.000000000 +0500
@@ -90,3 +90,4 @@
 obj-$(CONFIG_RTC_DRV_WM831X)	+= rtc-wm831x.o
 obj-$(CONFIG_RTC_DRV_WM8350)	+= rtc-wm8350.o
 obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
+obj-$(CONFIG_DA9052_RTC_ENABLE)	+= da9052_rtc.o
diff -Naur linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_rtc.h linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_rtc.h
--- linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_rtc.h	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_rtc.h	2010-05-18 18:23:03.000000000 +0500
@@ -0,0 +1,453 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_rtc.h: RTC driver file for DA9052
+ *
+ * History:
+ *
+ * (21/04/2009)	Created first draft
+ *
+ * (27/04/2010):	Updated for Linux Community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+
+#ifndef _DA9052_RTC_H
+#define _DA9052_RTC_H
+
+/*--------------------------------------------------------------------------*/
+/* System wide include files                                                */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Type Definitions                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Constant Definitions                                                     */
+/*--------------------------------------------------------------------------*/
+
+#define DA9052_RTC_DEVICE_NAME				"da9052_rtc"
+
+/*  Limit values */
+#define DA9052_RTC_SECONDS_LIMIT			(59)
+#define DA9052_RTC_MINUTES_LIMIT			(59)
+#define DA9052_RTC_HOURS_LIMIT				(23)
+#define DA9052_RTC_DAYS_LIMIT				(31)
+#define DA9052_RTC_MONTHS_LIMIT				(12)
+#define DA9052_RTC_YEARS_LIMIT				(63)
+
+/* Months */
+#define FEBRUARY					(2)
+#define APRIL						(4)
+#define JUNE						(6)
+#define	SEPTEMBER					(9)
+#define NOVEMBER					(11)
+
+/* BYTE shifts */
+#define DA9052_RTC_FOURTH_BYTE				(24)	
+#define DA9052_RTC_THIRD_BYTE				(16)
+#define DA9052_RTC_SECOND_BYTE				(8)
+#define DA9052_RTC_FIRST_BYTE				(0)
+
+/* Oscillator trim values */
+#define DA9052_RTC_OSC_FRQ_0_0ppm			(0)
+#define DA9052_RTC_OSC_FRQ_1_9ppm			(1)
+#define DA9052_RTC_OSC_FRQ_3_8ppm			(2)
+#define DA9052_RTC_OSC_FRQ_5_7ppm			(3)
+#define DA9052_RTC_OSC_FRQ_7_6ppm			(4)
+#define DA9052_RTC_OSC_FRQ_9_5ppm			(5)
+#define DA9052_RTC_OSC_FRQ_11_4ppm			(6)
+#define DA9052_RTC_OSC_FRQ_13_3ppm			(7)
+#define DA9052_RTC_OSC_FRQ_15_2ppm			(8)
+#define DA9052_RTC_OSC_FRQ_17_1ppm			(9)
+#define DA9052_RTC_OSC_FRQ_19_0ppm			(10)
+#define DA9052_RTC_OSC_FRQ_20_9ppm			(11)
+#define DA9052_RTC_OSC_FRQ_22_8ppm			(12)
+#define DA9052_RTC_OSC_FRQ_24_7ppm			(13)
+#define DA9052_RTC_OSC_FRQ_26_7ppm			(14)
+#define DA9052_RTC_OSC_FRQ_28_6ppm			(15)
+#define DA9052_RTC_OSC_FRQ_30_5ppm			(16)
+#define DA9052_RTC_OSC_FRQ_32_4ppm			(17)
+#define DA9052_RTC_OSC_FRQ_34_3ppm			(18)
+#define DA9052_RTC_OSC_FRQ_36_2ppm			(19)
+#define DA9052_RTC_OSC_FRQ_38_1ppm			(20)
+#define DA9052_RTC_OSC_FRQ_40_0ppm			(21)
+#define DA9052_RTC_OSC_FRQ_41_9ppm			(22)
+#define DA9052_RTC_OSC_FRQ_43_8ppm			(23)
+#define DA9052_RTC_OSC_FRQ_45_7ppm			(24)
+#define DA9052_RTC_OSC_FRQ_47_6ppm			(25)
+#define DA9052_RTC_OSC_FRQ_49_5ppm			(26)
+#define DA9052_RTC_OSC_FRQ_51_4ppm			(27)
+#define DA9052_RTC_OSC_FRQ_53_4ppm			(28)
+#define DA9052_RTC_OSC_FRQ_55_3ppm			(29)
+#define DA9052_RTC_OSC_FRQ_57_2ppm			(30)
+#define DA9052_RTC_OSC_FRQ_59_1ppm			(31)
+#define DA9052_RTC_OSC_FRQ_61_0ppm			(32)
+#define DA9052_RTC_OSC_FRQ_62_9ppm			(33)
+#define DA9052_RTC_OSC_FRQ_64_8ppm			(34)
+#define DA9052_RTC_OSC_FRQ_66_7ppm			(35)
+#define DA9052_RTC_OSC_FRQ_68_6ppm			(36)
+#define DA9052_RTC_OSC_FRQ_70_5ppm			(37)
+#define DA9052_RTC_OSC_FRQ_72_4ppm			(38)
+#define DA9052_RTC_OSC_FRQ_74_3ppm			(39)
+#define DA9052_RTC_OSC_FRQ_76_2ppm			(40)
+#define DA9052_RTC_OSC_FRQ_78_2ppm			(41)
+#define DA9052_RTC_OSC_FRQ_80_1ppm			(42)
+#define DA9052_RTC_OSC_FRQ_82_0ppm			(43)
+#define DA9052_RTC_OSC_FRQ_83_9ppm			(44)
+#define DA9052_RTC_OSC_FRQ_85_8ppm			(45)
+#define DA9052_RTC_OSC_FRQ_87_7ppm			(46)
+#define DA9052_RTC_OSC_FRQ_89_6ppm			(47)
+#define DA9052_RTC_OSC_FRQ_91_5ppm			(48)
+#define DA9052_RTC_OSC_FRQ_93_4ppm			(49)
+#define DA9052_RTC_OSC_FRQ_95_3ppm			(50)
+#define DA9052_RTC_OSC_FRQ_97_2ppm			(51)
+#define DA9052_RTC_OSC_FRQ_99_1ppm			(52)
+#define DA9052_RTC_OSC_FRQ_101_0ppm			(53)
+#define DA9052_RTC_OSC_FRQ_102_9ppm			(54)
+#define DA9052_RTC_OSC_FRQ_104_9ppm			(55)
+#define DA9052_RTC_OSC_FRQ_106_8ppm			(56)
+#define DA9052_RTC_OSC_FRQ_108_7ppm			(57)
+#define DA9052_RTC_OSC_FRQ_110_6ppm			(58)
+#define DA9052_RTC_OSC_FRQ_112_5ppm			(59)
+#define DA9052_RTC_OSC_FRQ_114_4ppm			(60)
+#define DA9052_RTC_OSC_FRQ_116_3ppm			(61)
+#define DA9052_RTC_OSC_FRQ_118_2ppm			(62)
+#define DA9052_RTC_OSC_FRQ_120_1ppm			(63)
+#define DA9052_RTC_OSC_FRQ_122_0ppm			(64)
+#define DA9052_RTC_OSC_FRQ_123_9ppm			(65)
+#define DA9052_RTC_OSC_FRQ_125_8ppm			(66)
+#define DA9052_RTC_OSC_FRQ_127_7ppm			(67)
+#define DA9052_RTC_OSC_FRQ_129_6ppm			(68)
+#define DA9052_RTC_OSC_FRQ_131_6ppm			(69)
+#define DA9052_RTC_OSC_FRQ_133_5ppm			(70)
+#define DA9052_RTC_OSC_FRQ_135_4ppm			(71)
+#define DA9052_RTC_OSC_FRQ_137_3ppm			(72)
+#define DA9052_RTC_OSC_FRQ_139_2ppm			(73)
+#define DA9052_RTC_OSC_FRQ_141_1ppm			(74)
+#define DA9052_RTC_OSC_FRQ_143_0ppm			(75)
+#define DA9052_RTC_OSC_FRQ_144_9ppm			(76)
+#define DA9052_RTC_OSC_FRQ_146_8ppm			(77)
+#define DA9052_RTC_OSC_FRQ_148_7ppm			(78)
+#define DA9052_RTC_OSC_FRQ_150_6ppm			(79)
+#define DA9052_RTC_OSC_FRQ_152_5ppm			(80)
+#define DA9052_RTC_OSC_FRQ_154_4ppm			(81)
+#define DA9052_RTC_OSC_FRQ_156_4ppm			(82)
+#define DA9052_RTC_OSC_FRQ_158_3ppm			(83)
+#define DA9052_RTC_OSC_FRQ_160_2ppm			(84)
+#define DA9052_RTC_OSC_FRQ_162_1ppm			(85)
+#define DA9052_RTC_OSC_FRQ_164_0ppm			(86)
+#define DA9052_RTC_OSC_FRQ_165_9ppm			(87)
+#define DA9052_RTC_OSC_FRQ_167_8ppm			(88)
+#define DA9052_RTC_OSC_FRQ_169_7ppm			(89)
+#define DA9052_RTC_OSC_FRQ_171_6ppm			(90)
+#define DA9052_RTC_OSC_FRQ_173_5ppm			(91)
+#define DA9052_RTC_OSC_FRQ_175_4ppm			(92)
+#define DA9052_RTC_OSC_FRQ_177_3ppm			(93)
+#define DA9052_RTC_OSC_FRQ_179_2ppm			(94)
+#define DA9052_RTC_OSC_FRQ_181_1ppm			(95)
+#define DA9052_RTC_OSC_FRQ_183_1ppm			(96)
+#define DA9052_RTC_OSC_FRQ_185_0ppm			(97)
+#define DA9052_RTC_OSC_FRQ_186_9ppm			(98)
+#define DA9052_RTC_OSC_FRQ_188_8ppm			(99)
+#define DA9052_RTC_OSC_FRQ_190_7ppm			(100)
+#define DA9052_RTC_OSC_FRQ_192_6ppm			(101)
+#define DA9052_RTC_OSC_FRQ_194_5ppm			(102)
+#define DA9052_RTC_OSC_FRQ_196_4ppm			(103)
+#define DA9052_RTC_OSC_FRQ_198_3ppm			(104)
+#define DA9052_RTC_OSC_FRQ_200_2ppm			(105)
+#define DA9052_RTC_OSC_FRQ_202_1ppm			(106)
+#define DA9052_RTC_OSC_FRQ_204_0ppm			(107)
+#define DA9052_RTC_OSC_FRQ_205_9ppm			(108)
+#define DA9052_RTC_OSC_FRQ_207_9ppm			(109)
+#define DA9052_RTC_OSC_FRQ_209_8ppm			(110)
+#define DA9052_RTC_OSC_FRQ_211_7ppm			(111)
+#define DA9052_RTC_OSC_FRQ_213_6ppm			(112)
+#define DA9052_RTC_OSC_FRQ_215_5ppm			(113)
+#define DA9052_RTC_OSC_FRQ_217_4ppm			(114)
+#define DA9052_RTC_OSC_FRQ_219_3ppm			(115)
+#define DA9052_RTC_OSC_FRQ_221_2ppm			(116)
+#define DA9052_RTC_OSC_FRQ_223_1ppm			(117)
+#define DA9052_RTC_OSC_FRQ_225_0ppm			(118)
+#define DA9052_RTC_OSC_FRQ_226_9ppm			(119)
+#define DA9052_RTC_OSC_FRQ_228_8ppm			(120)
+#define DA9052_RTC_OSC_FRQ_230_7ppm			(121)
+#define DA9052_RTC_OSC_FRQ_232_6ppm			(122)
+#define DA9052_RTC_OSC_FRQ_234_6ppm			(123)
+#define DA9052_RTC_OSC_FRQ_236_5ppm			(124)
+#define DA9052_RTC_OSC_FRQ_238_4ppm			(125)
+#define DA9052_RTC_OSC_FRQ_240_3ppm			(126)
+#define DA9052_RTC_OSC_FRQ_242_2ppm			(127)
+#define DA9052_RTC_OSC_FRQ_MINUS_244_1ppm		(128)
+#define DA9052_RTC_OSC_FRQ_MINUS_242_2ppm		(129)
+#define DA9052_RTC_OSC_FRQ_MINUS_240_3ppm		(130)
+#define DA9052_RTC_OSC_FRQ_MINUS_238_4ppm		(131)
+#define DA9052_RTC_OSC_FRQ_MINUS_236_5ppm		(132)
+#define DA9052_RTC_OSC_FRQ_MINUS_234_6ppm		(133)
+#define DA9052_RTC_OSC_FRQ_MINUS_232_6ppm		(134)
+#define DA9052_RTC_OSC_FRQ_MINUS_230_7ppm		(135)
+#define DA9052_RTC_OSC_FRQ_MINUS_228_8ppm		(136)
+#define DA9052_RTC_OSC_FRQ_MINUS_226_9ppm		(137)
+#define DA9052_RTC_OSC_FRQ_MINUS_225_0ppm		(138)
+#define DA9052_RTC_OSC_FRQ_MINUS_223_1ppm		(139)
+#define DA9052_RTC_OSC_FRQ_MINUS_221_2ppm		(140)
+#define DA9052_RTC_OSC_FRQ_MINUS_219_3ppm		(141)
+#define DA9052_RTC_OSC_FRQ_MINUS_217_4ppm		(142)
+#define DA9052_RTC_OSC_FRQ_MINUS_215_5ppm		(143)
+#define DA9052_RTC_OSC_FRQ_MINUS_213_6ppm		(144)
+#define DA9052_RTC_OSC_FRQ_MINUS_211_7ppm		(145)
+#define DA9052_RTC_OSC_FRQ_MINUS_209_8ppm		(146)
+#define DA9052_RTC_OSC_FRQ_MINUS_207_9ppm		(147)
+#define DA9052_RTC_OSC_FRQ_MINUS_205_9ppm		(148)
+#define DA9052_RTC_OSC_FRQ_MINUS_204_0ppm		(149)
+#define DA9052_RTC_OSC_FRQ_MINUS_202_1ppm		(150)
+#define DA9052_RTC_OSC_FRQ_MINUS_200_2ppm		(151)
+#define DA9052_RTC_OSC_FRQ_MINUS_198_3ppm		(152)
+#define DA9052_RTC_OSC_FRQ_MINUS_196_4ppm		(153)
+#define DA9052_RTC_OSC_FRQ_MINUS_194_5ppm		(154)
+#define DA9052_RTC_OSC_FRQ_MINUS_192_6ppm		(155)
+#define DA9052_RTC_OSC_FRQ_MINUS_190_7ppm		(156)
+#define DA9052_RTC_OSC_FRQ_MINUS_188_8ppm		(157)
+#define DA9052_RTC_OSC_FRQ_MINUS_186_9ppm		(158)
+#define DA9052_RTC_OSC_FRQ_MINUS_185_0ppm		(159)
+#define DA9052_RTC_OSC_FRQ_MINUS_183_1ppm		(160)
+#define DA9052_RTC_OSC_FRQ_MINUS_181_1ppm		(161)
+#define DA9052_RTC_OSC_FRQ_MINUS_179_2ppm		(162)
+#define DA9052_RTC_OSC_FRQ_MINUS_177_3ppm		(163)
+#define DA9052_RTC_OSC_FRQ_MINUS_175_4ppm		(164)
+#define DA9052_RTC_OSC_FRQ_MINUS_173_5ppm		(165)
+#define DA9052_RTC_OSC_FRQ_MINUS_171_6ppm		(166)
+#define DA9052_RTC_OSC_FRQ_MINUS_169_7ppm		(167)
+#define DA9052_RTC_OSC_FRQ_MINUS_167_8ppm		(168)
+#define DA9052_RTC_OSC_FRQ_MINUS_165_9ppm		(169)
+#define DA9052_RTC_OSC_FRQ_MINUS_164_0ppm		(170)
+#define DA9052_RTC_OSC_FRQ_MINUS_162_1ppm		(171)
+#define DA9052_RTC_OSC_FRQ_MINUS_160_2ppm		(172)
+#define DA9052_RTC_OSC_FRQ_MINUS_158_3ppm		(173)
+#define DA9052_RTC_OSC_FRQ_MINUS_156_4ppm		(174)
+#define DA9052_RTC_OSC_FRQ_MINUS_154_4ppm		(175)
+#define DA9052_RTC_OSC_FRQ_MINUS_152_5ppm		(176)
+#define DA9052_RTC_OSC_FRQ_MINUS_150_6ppm		(177)
+#define DA9052_RTC_OSC_FRQ_MINUS_148_7ppm		(178)
+#define DA9052_RTC_OSC_FRQ_MINUS_146_8ppm		(179)
+#define DA9052_RTC_OSC_FRQ_MINUS_144_9ppm		(180)
+#define DA9052_RTC_OSC_FRQ_MINUS_143_0ppm		(181)
+#define DA9052_RTC_OSC_FRQ_MINUS_141_1ppm		(182)
+#define DA9052_RTC_OSC_FRQ_MINUS_139_2ppm		(183)
+#define DA9052_RTC_OSC_FRQ_MINUS_137_3ppm		(184)
+#define DA9052_RTC_OSC_FRQ_MINUS_135_4ppm		(185)
+#define DA9052_RTC_OSC_FRQ_MINUS_133_5ppm		(186)
+#define DA9052_RTC_OSC_FRQ_MINUS_131_6ppm		(187)
+#define DA9052_RTC_OSC_FRQ_MINUS_129_6ppm		(188)
+#define DA9052_RTC_OSC_FRQ_MINUS_127_7ppm		(189)
+#define DA9052_RTC_OSC_FRQ_MINUS_125_8ppm		(190)
+#define DA9052_RTC_OSC_FRQ_MINUS_123_9ppm		(191)
+#define DA9052_RTC_OSC_FRQ_MINUS_122_0ppm		(192)
+#define DA9052_RTC_OSC_FRQ_MINUS_120_1ppm		(193)
+#define DA9052_RTC_OSC_FRQ_MINUS_118_2ppm		(194)
+#define DA9052_RTC_OSC_FRQ_MINUS_116_3ppm		(195)
+#define DA9052_RTC_OSC_FRQ_MINUS_114_4ppm		(196)
+#define DA9052_RTC_OSC_FRQ_MINUS_112_5ppm		(197)
+#define DA9052_RTC_OSC_FRQ_MINUS_110_6ppm		(198)
+#define DA9052_RTC_OSC_FRQ_MINUS_108_7ppm		(199)
+#define DA9052_RTC_OSC_FRQ_MINUS_106_8ppm		(200)
+#define DA9052_RTC_OSC_FRQ_MINUS_104_9ppm		(201)
+#define DA9052_RTC_OSC_FRQ_MINUS_102_9ppm		(202)
+#define DA9052_RTC_OSC_FRQ_MINUS_101_0ppm		(203)
+#define DA9052_RTC_OSC_FRQ_MINUS_99_1ppm		(204)
+#define DA9052_RTC_OSC_FRQ_MINUS_97_2ppm		(205)
+#define DA9052_RTC_OSC_FRQ_MINUS_95_3ppm		(206)
+#define DA9052_RTC_OSC_FRQ_MINUS_93_4ppm		(207)
+#define DA9052_RTC_OSC_FRQ_MINUS_91_5ppm		(208)
+#define DA9052_RTC_OSC_FRQ_MINUS_89_6ppm		(209)
+#define DA9052_RTC_OSC_FRQ_MINUS_87_7ppm		(210)
+#define DA9052_RTC_OSC_FRQ_MINUS_85_8ppm		(211)
+#define DA9052_RTC_OSC_FRQ_MINUS_83_9ppm		(212)
+#define DA9052_RTC_OSC_FRQ_MINUS_82_0ppm		(213)
+#define DA9052_RTC_OSC_FRQ_MINUS_80_1ppm		(214)
+#define DA9052_RTC_OSC_FRQ_MINUS_78_2ppm		(215)
+#define DA9052_RTC_OSC_FRQ_MINUS_76_2ppm		(216)
+#define DA9052_RTC_OSC_FRQ_MINUS_74_3ppm		(217)
+#define DA9052_RTC_OSC_FRQ_MINUS_72_4ppm		(218)
+#define DA9052_RTC_OSC_FRQ_MINUS_70_5ppm		(219)
+#define DA9052_RTC_OSC_FRQ_MINUS_68_6ppm		(220)
+#define DA9052_RTC_OSC_FRQ_MINUS_66_7ppm		(221)
+#define DA9052_RTC_OSC_FRQ_MINUS_64_8ppm		(222)
+#define DA9052_RTC_OSC_FRQ_MINUS_62_9ppm		(223)
+#define DA9052_RTC_OSC_FRQ_MINUS_61_0ppm		(224)
+#define DA9052_RTC_OSC_FRQ_MINUS_59_1ppm		(225)
+#define DA9052_RTC_OSC_FRQ_MINUS_57_2ppm		(226)
+#define DA9052_RTC_OSC_FRQ_MINUS_55_3ppm		(227)
+#define DA9052_RTC_OSC_FRQ_MINUS_53_4ppm		(228)
+#define DA9052_RTC_OSC_FRQ_MINUS_51_4ppm		(229)
+#define DA9052_RTC_OSC_FRQ_MINUS_49_5ppm		(230)
+#define DA9052_RTC_OSC_FRQ_MINUS_47_6ppm		(231)
+#define DA9052_RTC_OSC_FRQ_MINUS_45_7ppm		(232)
+#define DA9052_RTC_OSC_FRQ_MINUS_43_8ppm		(233)
+#define DA9052_RTC_OSC_FRQ_MINUS_41_9ppm		(234)
+#define DA9052_RTC_OSC_FRQ_MINUS_40_0ppm		(235)
+#define DA9052_RTC_OSC_FRQ_MINUS_38_1ppm		(236)
+#define DA9052_RTC_OSC_FRQ_MINUS_36_2ppm		(237)
+#define DA9052_RTC_OSC_FRQ_MINUS_34_3ppm		(238)
+#define DA9052_RTC_OSC_FRQ_MINUS_32_4ppm		(239)
+#define DA9052_RTC_OSC_FRQ_MINUS_30_5ppm		(240)
+#define DA9052_RTC_OSC_FRQ_MINUS_28_6ppm		(241)
+#define DA9052_RTC_OSC_FRQ_MINUS_26_7ppm		(242)
+#define DA9052_RTC_OSC_FRQ_MINUS_24_7ppm		(243)
+#define DA9052_RTC_OSC_FRQ_MINUS_22_8ppm		(244)
+#define DA9052_RTC_OSC_FRQ_MINUS_20_9ppm		(245)
+#define DA9052_RTC_OSC_FRQ_MINUS_19_0ppm		(246)
+#define DA9052_RTC_OSC_FRQ_MINUS_17_1ppm		(247)
+#define DA9052_RTC_OSC_FRQ_MINUS_15_2ppm		(248)
+#define DA9052_RTC_OSC_FRQ_MINUS_13_3ppm		(249)
+#define DA9052_RTC_OSC_FRQ_MINUS_11_4ppm		(250)
+#define DA9052_RTC_OSC_FRQ_MINUS_9_5ppm			(251)
+#define DA9052_RTC_OSC_FRQ_MINUS_7_6ppm			(252)
+#define DA9052_RTC_OSC_FRQ_MINUS_5_7ppm			(253)
+#define DA9052_RTC_OSC_FRQ_MINUS_3_8ppm			(254)
+#define DA9052_RTC_OSC_FRQ_MINUS_1_9ppm			(255)
+
+/* RTC error codes */
+#define DA9052_RTC_INVALID_SECONDS		    	(3)
+#define DA9052_RTC_INVALID_MINUTES			    (4)
+#define DA9052_RTC_INVALID_HOURS			    (5)
+#define DA9052_RTC_INVALID_DAYS				    (6)
+#define DA9052_RTC_INVALID_MONTHS			    (7)
+#define DA9052_RTC_INVALID_YEARS			    (8)
+#define DA9052_RTC_INVALID_EVENT		    	(9)
+#define DA9052_RTC_INVALID_IOCTL			    (10)
+#define DA9052_RTC_INVALID_SETTING			    (11)
+#define DA9052_RTC_EVENT_ALREADY_REGISTERED		(12)
+#define DA9052_RTC_EVENT_UNREGISTERED			(13)
+#define DA9052_RTC_EVENT_REGISTRATION_FAILED    (14)
+#define DA9052_RTC_EVENT_UNREGISTRATION_FAILED  (15)
+/**
+* IOCTL calls that are permitted to the /dev/da9052_rtc interface, if
+ * any of the RTC drivers are enabled.
+ */
+
+/* Set RTC time */
+#define DA9052_RTC_IOCTL_SET_TIME			(1)
+
+/* Read RTC time */
+#define DA9052_RTC_IOCTL_GET_TIME			(2)
+
+/* Set RTC Alarm time */
+#define DA9052_RTC_IOCTL_SET_ALARM			(3)
+
+/* Read RTC Alarm time */
+#define DA9052_RTC_IOCTL_GET_ALARM			(4)
+
+/* Read time elapsed after Power-Down Reset */
+#define DA9052_RTC_IOCTL_GET_TIMEELAPSED		(5)
+
+/* Enable/disable timer alarm */
+#define DA9052_RTC_IOCTL_ENABLEALARM			(6)
+
+/* Enable/disable tick alarm */
+#define DA9052_RTC_IOCTL_ENABLETICK			(7)
+
+/* Set tick type */
+#define DA9052_RTC_IOCTL_SET_TICKTYPE			(8)
+
+/* Enable/disable clock buffer */
+#define DA9052_RTC_IOCTL_SET_CLKBUFFER			(9)
+
+/* Set trim frequency */
+#define DA9052_RTC_IOCTL_SET_TRIMFREQ			(10)
+
+/* Get last event occured */
+#define DA9052_RTC_IOCTL_GET_EVENT			(11)
+
+/* Register for an event */
+#define DA9052_RTC_IOCTL_REGISTER_EVENT			(12)
+
+/* Unregister for an event */
+#define DA9052_RTC_IOCTL_UNREGISTER_EVENT		(13)
+
+/**
+ * enum alarm_event_type_enum -	Enum to represent the Alarm Type
+ *
+ * @TIMER_ALARM: 		Timer Alarm = 51
+ * @TICK_ALARM: 		Tick Alarm = 52
+ */
+enum alarm_event_type_enum {
+	TIMER_ALARM = 51,
+	TICK_ALARM,
+};
+
+/* To enable debug output, set this to 1 */
+#define	DA9052_RTC_DEBUG				(0)
+
+#undef DA9052_DEBUG
+#if DA9052_RTC_DEBUG
+#define DA9052_DEBUG( fmt, args... ) printk( KERN_CRIT "" fmt, ##args )
+#else
+#define DA9052_DEBUG( fmt, args... )
+#endif
+
+ 
+/*--------------------------------------------------------------------------*/
+/* Structure Definitions                                                    */
+/*--------------------------------------------------------------------------*/
+ 
+/**
+ * struct da9052_rtc_data_t - Structure description
+ *  @tm_sec: value of seconds
+ * @tm_min: value of minutes
+ * @tm_hour: value of hour
+ * @tm_mday: value of day in month
+ * @tm_mon: value of month
+ * @tm_year: value of year
+ * This is a timer structure, used to input time to DA9052 
+ * and to receive the time from DA9052
+ */
+typedef struct {
+	u8 tm_sec:6;
+	u8 tm_min:6;
+	u8 tm_hour:5;
+	u8 tm_mday:5;
+	u8 tm_mon:4;
+	u8 tm_year:6;
+} da9052_rtc_data_t;
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Inline Functions                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* External Functions                                                       */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Other Functions                                                          */
+/*--------------------------------------------------------------------------*/
+s32 da9052_rtc_settime(da9052_rtc_data_t *rtc_tm);
+s32 da9052_rtc_gettime(da9052_rtc_data_t *rtc_tm);
+s32 da9052_alarm_settime(da9052_rtc_data_t *rtc_tm);
+s32 da9052_alarm_gettime(da9052_rtc_data_t *rtc_tm);
+s32 da9052_rtc_getelapsedtime(u32 *elapsed_time);
+s32 da9052_rtc_enablealarm(u8 flag);
+s32 da9052_rtc_enabletick(u8 flag);
+s32 da9052_rtc_setticktype(u8 flag);
+s32 da9052_rtc_setbuffer(u8 flag);
+s32 da9052_rtc_setclktrimfreq(u8 value);
+s32 da9052_rtc_register_event(u8 event_type);
+s32 da9052_rtc_unregister_event(u8 event_type);
+
+#endif /* _DA9052_RTC_H */
Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.
