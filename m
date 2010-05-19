Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab0ESJuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:50:17 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:63686 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0ESJuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:50:12 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [PATCH] POWER (BAT) of DA9052 Linux device drivers (4/9)
Date: Wed, 19 May 2010 10:50:02 +0100
Message-ID: <3495EC08FA53E94AAA00CC4743D5BA7E010C20F4@pandora.diasemi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] POWER (BAT) of DA9052 Linux device drivers (4/9)
Thread-Index: Acr3OKa3YtgFSPNXQSumW0ctgnh54Q==
From: "David Dajun Chen" <Dajun.Chen@diasemi.com>
To: <linux-kernel@vger.kernel.org>
Cc: <cbou@mail.ru>, <astarikovskiy@suse.de>
X-OriginalArrivalTime: 19 May 2010 09:50:05.0534 (UTC) FILETIME=[A8C73FE0:01CAF738]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4J9oYaS008131

Dear sir/madam,

The attached is the POWER (Battery Charger) part of the device drivers newly developed for DA9052 Power Management IC from Dialog Semiconductor.

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
Mobile:¬†¬†¬†¬†¬†¬†¬†¬† (+44) 07917015477
Fax:¬†¬†¬†¬†¬†¬†¬†¬†¬†¬†¬†¬†¬†¬† (+44) 01793-758000
===========================================================================

diff -Naur linux-2.6.33.2_bk/drivers/mfd/Kconfig linux-2.6.33.2_patch/drivers/mfd/Kconfig
--- linux-2.6.33.2_bk/drivers/mfd/Kconfig	2010-05-18 17:54:30.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/mfd/Kconfig	2010-05-18 18:20:23.000000000 +0500
@@ -377,6 +377,14 @@
 	help
 	  Say Y  to enable the ADC driver for the DA9052 chip
 
+config DA9052_BAT_ENABLE
+	bool "Dialog Semiconductor DA9052 Battery Driver"
+	depends on MFD_DA9052
+	select DA9052_ADC_ENABLE
+	help
+	  Depends on DA9052 ADC driver
+	  Say Y  to enable the BAT driver for the DA9052 chip
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff -Naur linux-2.6.33.2_bk/drivers/power/da9052_bat.c linux-2.6.33.2_patch/drivers/power/da9052_bat.c
--- linux-2.6.33.2_bk/drivers/power/da9052_bat.c	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/power/da9052_bat.c	2010-05-18 18:20:23.000000000 +0500
@@ -0,0 +1,2633 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_bat.c: BAT driver file for DA9052
+ *
+ * Authors:
+ *
+ * History:
+ *
+ * (08/05/2009):	Draft version 
+ * (19/05/2009):	Unit tested code version
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
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/uaccess.h>
+#include <linux/jiffies.h>
+#include <linux/power_supply.h>
+#include <linux/platform_device.h>
+#include <linux/freezer.h>
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+#include <linux/mfd/da9052/da9052_reg.h>
+#include <linux/mfd/da9052/da9052_lib.h>
+#include <linux/mfd/da9052/da9052_eh.h>
+#include <linux/mfd/da9052/da9052_bat.h>
+
+//void start_monitoring(struct work_struct *);
+/*--------------------------------------------------------------------------*/
+/* Local Type Definitions                                                   */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Local Constant Definitions                                               */
+/*--------------------------------------------------------------------------*/
+static const char  __initdata banner[] = KERN_INFO "DA9052 BAT, (c) \
+2009 Dialog semiconductor Ltd.\n";
+/*--------------------------------------------------------------------------*/
+/* Local Macro Definitions                                                  */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*Power Supply and Power supply info instance */
+struct power_supply psy;
+struct power_supply_info battery_info;
+
+/**
+* da9052_bat_get_property : 	Called by power supply to get the status of 
+*				the battery. It get the property of the battery
+*				defined by the da902_bat_props array.
+*/
+static int da9052_bat_get_property(struct power_supply *psy,
+                                 enum power_supply_property psp,
+                                 union power_supply_propval *val);
+
+/**
+ * da902_bat_props -	Array that define the power supply properties supported
+			by DA9052_BAT Driver
+ */				 
+static enum power_supply_property da902_bat_props[] = {
+        POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_ONLINE,
+        POWER_SUPPLY_PROP_PRESENT,
+        POWER_SUPPLY_PROP_HEALTH,
+        POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_AVG,
+        POWER_SUPPLY_PROP_CURRENT_AVG,
+        POWER_SUPPLY_PROP_CAPACITY,
+	/* Not supported by Linux version 2.6.28
+        POWER_SUPPLY_PROP_CAPACITY_LEVEL,
+	*/
+        POWER_SUPPLY_PROP_TEMP,
+        POWER_SUPPLY_PROP_MANUFACTURER,
+};
+
+static u8 bat_device_open = 0;
+static s32 bat_major_number = 0;
+static struct platform_device *da9052_bat_platform_device;
+static struct fasync_struct *bat_fasync_queue;
+
+/* Create structure used throughout the BAT */
+static da9052_charger_device *chg_device;
+static da9052_bat_device bat_info;
+static da9052_bat_status bat_status;
+static da9052_bat_hysteresis bat_hysteresis;
+
+/* Create a handler for the scheduling start_monitoring function */
+s32 monitoring_thread_pid = 0;
+u8 monitoring_thread_state = ACTIVE;
+struct completion monitoring_thread_notifier;
+
+/* Lookup table for the battery capacity for all battery temperature  */
+static u16 array_hys_batvoltage[2];
+static u16 bat_volt_arr[3];
+static u8 hys_flag = FALSE;
+
+/* Global varaiable to store the bat event and event notifier*/
+u8 user_space_chg_det_dcin;
+u8 user_space_chg_rem_dcin;
+u8 user_space_chg_det_vbus;
+u8 user_space_chg_rem_vbus;
+u8 user_space_chg_chgend;
+u8 montoring_func_reg;
+u32 bat_event;
+da9052_bat_event_regestration event_status;
+da9052_eh_nb vddlow_eh_data;
+da9052_eh_nb tbat_eh_data;
+da9052_eh_nb chgend_eh_data;
+da9052_eh_nb chgdet_dcin_eh_data;
+da9052_eh_nb chgrem_dcin_eh_data;
+da9052_eh_nb chgdet_vbus_eh_data;
+da9052_eh_nb chgrem_vbus_eh_data;
+
+u8 tbat_event_occur;
+/* Lock for battery event notifier to library */
+struct semaphore event_lock;
+
+/* instance to store the monitoring status */
+static monitoring_state monitoring_status;
+
+/* Workqueue for the charger update function. */
+void da9052_chager_status_update(void);
+/*--------------------------------------------------------------------------*/
+/* Local Functions                                                          */
+/*--------------------------------------------------------------------------*/
+
+/**
+ * da9052_battery_setup_psy : 	Called by init function. It initialise the 
+ *				power supply instance for DA9052_BAT.
+ *
+ * @param : void
+ * @return void
+ */
+static void da9052_battery_setup_psy(void)
+{
+	battery_info.name = DA9052_BAT_DEVICE_NAME;
+	battery_info.technology = BAT_TYPE;
+	battery_info.voltage_max_design = (chg_device->bat_target_voltage * 1000);
+	battery_info.voltage_min_design = (BAT_VOLT_CUTOFF * 1000);
+	battery_info.energy_full_design = BAT_CAPACITY_FULL;
+	battery_info.energy_empty_design = BAT_CAPACITY_LIMIT_LOW;
+	battery_info.use_for_apm = 1;
+	
+	psy.name = DA9052_BAT_DEVICE_NAME;
+	psy.use_for_apm = 1;
+	psy.type = POWER_SUPPLY_TYPE_BATTERY;
+	psy.get_property = da9052_bat_get_property;
+
+	psy.properties = da902_bat_props;
+	psy.num_properties = ARRAY_SIZE(da902_bat_props);
+	
+	DA9052_DEBUG("Array_Size = %d\n",psy.num_properties);
+};
+
+/**
+ * da9052_bat_get_property : 	Called by power supply to get the status of 
+ *				the battery. It get the property of the battery
+ *				defined by the da902_bat_props array.
+ *
+ * @param : psy			power supply structure pointer
+ * @param : psp			power supply properties requested
+ * @param : val			pointer to power_supply_propval in which 
+ *				requested property need to be returned
+ * @return int	Error status 0:SUCCESS, Non Zero: Error
+ */
+static int da9052_bat_get_property(struct power_supply *psy,
+                                 enum power_supply_property psp,
+                                 union power_supply_propval *val)
+{
+        int ret = 0;
+	
+	DA9052_DEBUG("In BAT driver =%d \n",psp);
+        switch (psp) {
+        case POWER_SUPPLY_PROP_STATUS:
+                if (bat_status.status == CHARGING)
+			val->intval = POWER_SUPPLY_STATUS_CHARGING;
+			
+                else if (bat_status.status == DISCHARGING_WITH_CHARGER)
+			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
+			
+                else if (bat_status.status == DISCHARGING_WITHOUT_CHARGER)
+			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+			
+                else if (bat_status.status == CHARGEEND)
+			val->intval = POWER_SUPPLY_STATUS_FULL;
+			
+		break;
+        case POWER_SUPPLY_PROP_ONLINE:
+                if (bat_status.charger_type == NOCHARGER)
+			val->intval = FALSE;
+		else 
+			val->intval = TRUE;
+                break;		
+        case POWER_SUPPLY_PROP_PRESENT:
+                if (bat_status.illegalbattery)
+			val->intval = FALSE;
+		else 
+			val->intval = TRUE;
+                break;
+	case POWER_SUPPLY_PROP_HEALTH:
+		if(bat_status.health != POWER_SUPPLY_HEALTH_OVERHEAT) {
+			if(bat_status.illegalbattery)
+				bat_status.health = POWER_SUPPLY_HEALTH_UNKNOWN;
+			
+			else if (bat_status.cal_capacity < BAT_CAPACITY_LIMIT_LOW)
+				bat_status.health = POWER_SUPPLY_HEALTH_DEAD;
+			
+			else
+				bat_status.health = POWER_SUPPLY_HEALTH_GOOD;
+		}
+		val->intval = bat_status.health;
+                break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+                val->intval = (chg_device->bat_target_voltage * 1000);
+                break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+                val->intval = ( BAT_VOLT_CUTOFF * 1000 );
+                break;
+	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+                val->intval = (bat_info.bat_voltage * 1000);
+                break;
+	case POWER_SUPPLY_PROP_CURRENT_AVG:
+                val->intval = (bat_info.chg_current * 1000);
+                break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+                val->intval = bat_status.cal_capacity;
+                break;
+	/* Not supported by Linux version 2.6.28
+	case POWER_SUPPLY_PROP_CAPACITY_LEVEL:
+                if(bat_status.illegalbattery)
+			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_UNKNOWN;
+			
+		else if (bat_status.cal_capacity < BAT_CAPACITY_LIMIT_LOW)
+			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_CRITICAL;
+		
+		else if(bat_status.cal_capacity < BAT_CAPACITY_LIMIT_HIGH)
+			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_NORMAL;
+		
+		else if(bat_status.cal_capacity == BAT_CAPACITY_FULL)
+			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_FULL;
+		
+		else if(bat_status.cal_capacity > BAT_CAPACITY_LIMIT_HIGH)
+			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_HIGH;			
+
+		else
+			val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
+                break;
+	*/
+	case POWER_SUPPLY_PROP_TEMP:
+                val->intval = bat_temp_reg_to_C(bat_info.bat_temp);
+                break;
+	case POWER_SUPPLY_PROP_MANUFACTURER:
+                val->strval = BAT_MANUFACTURER;
+                break;
+	case POWER_SUPPLY_PROP_TECHNOLOGY:
+	        val->intval = BAT_TYPE;
+                break;	
+	 default:
+                ret = (-EINVAL);
+                break;
+        }
+	DA9052_DEBUG("Return Value = %d\n",val->intval);
+        return ret;
+}
+
+
+#if (DA9052_ILLEGAL_BATTERY_DETECT)
+/**
+* detect_illegal_battery : 	Called by Battery Driver PDD  init function to
+*				detect whether battery connected to the DA9052
+*				is legal. Here legal battery represent battery
+*				with NTC resisitor.
+*
+* @param : void
+* @return s32	Error status 0:SUCCESS, Non Zero: Error
+*/
+static s32 detect_illegal_battery(void)
+{
+	u16 buffer = 0;
+	s32  ret = 0;
+
+	//Measure battery temeperature
+	ret = da9052_bat_get_battery_temperature(&buffer);
+	if(ret) {
+		DA9052_DEBUG("%s: Battery temperature measurement failed \n",__FUNCTION__);
+		return (ret);
+	}
+
+	if(buffer > BAT_WITH_NO_RESISTOR) {
+		bat_status.illegalbattery = TRUE;
+	}
+	else
+	{
+		bat_status.illegalbattery = FALSE;
+	}
+	
+	/* suspend charging of battery if illegal battey is detected */
+	if(bat_status.illegalbattery) {		
+		da9052_bat_suspend_charging();
+	}
+	
+	return (SUCCESS);
+}
+#endif
+
+/*
+ * da9052_bat_current_lim: Set the ICHG_BAT and ISET_BUCK Current limit
+ *
+ * @param u8 bat_cur_lim  	current limit in mA
+ * @return s32			Error status 0:SUCCESS, Non Zero: Error
+ */
+ s32 da9052_bat_current_lim(u16 bat_cur_lim)
+{
+	da9052_ssc_msg msg;
+
+	msg.addr = DA9052_BATCHG_REG;
+
+	/* Read BAT_CHG register */
+	if(da9052_ssc_read(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+
+
+	/* write value of the battery current limit */
+	msg.data = clear_bits(msg.data,DA9052_BATCHG_ICHGBAT);
+	msg.data = set_bits(msg.data,(bat_cur_lim/20));
+
+	/* Write BAT_CHG register */
+	if(da9052_ssc_write(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+
+	msg.addr = DA9052_CHGBUCK_REG;
+
+	/* Read CHGBUCK register */
+	if(da9052_ssc_read(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+
+	/* write value of the buck current limit */
+	msg.data = clear_bits(msg.data,DA9052_CHGBUCK_ISETBUCK);
+	if(iset_mA_to_reg(bat_cur_lim)) {
+		msg.data = set_bits(msg.data,iset_mA_to_reg(bat_cur_lim));
+	}
+
+	/* Write CHGBUCK register */
+	if(da9052_ssc_write(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+
+	return (SUCCESS);
+}
+
+
+/*
+ * da9052_charger_detect_irq: detect the charger type and decide current limit
+ *
+ * @param void		
+ * @return void
+ */
+ void da9052_chager_status_update(void)
+{
+	da9052_ssc_msg msg;
+	u16 current_value = 0;
+	u8 regvalue=0;
+	
+	DA9052_DEBUG("FUNCTION = %s \n",__FUNCTION__);
+
+	// Read STATUS_A register
+	msg.addr = DA9052_STATUSA_REG;
+	/* Read STATUS_B  register */
+	if(da9052_ssc_read(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return;
+	}
+	regvalue = msg.data;
+
+	// Read STATUS_B register
+	msg.addr = DA9052_STATUSB_REG;
+	/* Read STATUS_B  register */
+	if(da9052_ssc_read(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return;
+	}
+	
+	/* If DCINDET and DCINSEL are set then connected charger is
+						WALL Charger unit */
+	if( (regvalue & DA9052_STATUSA_DCINSEL) 
+				&& (regvalue & DA9052_STATUSA_DCINDET) ) {
+		
+		/* if Charging end flag is set and Charging current is greater
+			than charging end limit then battery is charging */
+		if ((msg.data & DA9052_STATUSB_CHGEND) != 0)  {
+			
+			if(da9052_bat_get_chg_current(&current_value)) {
+				return;
+			}
+			
+			if( current_value >= chg_device->chg_end_current ) {
+				bat_status.status = CHARGING;
+				bat_status.charger_type = WALL_CHARGER;
+			}
+			else {
+				bat_status.charger_type = WALL_CHARGER;
+				bat_status.status = DISCHARGING_WITH_CHARGER;
+			}
+		}
+		/* if Charging end flag is clered then battery is charging */
+		else {
+			bat_status.status = CHARGING;
+			bat_status.charger_type = WALL_CHARGER;
+		}		
+	}
+	/* If VBUS_DET and VBUSEL are set then connected charger is
+						USB Type */
+	else if((regvalue & DA9052_STATUSA_VBUSSEL) 
+				&& (regvalue & DA9052_STATUSA_VBUSDET)) {
+
+		if (regvalue & DA9052_STATUSA_VDATDET) {
+			bat_status.charger_type = USB_CHARGER;
+		}
+		else {
+			/* Else it has to be USB Host charger */
+			bat_status.charger_type = USB_HUB;			
+		}
+
+		/* if Charging end flag is set and Charging current is greater
+			than charging end limit then battery is charging */		
+		if ((msg.data & DA9052_STATUSB_CHGEND) != 0) {
+			
+			if(da9052_bat_get_chg_current(&current_value)) {
+				return;
+			}
+			
+			if (current_value >= chg_device->chg_end_current) {
+				bat_status.status = CHARGING;
+			}
+			else {
+				bat_status.status = DISCHARGING_WITH_CHARGER;
+			}
+			
+		}
+		/* if Charging end flag is clered then battery is charging */
+		else {
+			bat_status.status = CHARGING;
+		}
+	}
+	else if(regvalue & DA9052_STATUSA_DCINDET)
+	{
+		bat_status.charger_type = WALL_CHARGER;
+		bat_status.status = DISCHARGING_WITH_CHARGER;
+	}
+	else if(regvalue & DA9052_STATUSA_VBUSDET)
+	{
+		if(regvalue & DA9052_STATUSA_VDATDET) {
+			bat_status.charger_type = USB_CHARGER;
+			bat_status.status = DISCHARGING_WITH_CHARGER;
+		}
+		else {
+			bat_status.charger_type = USB_HUB;
+			bat_status.status = DISCHARGING_WITH_CHARGER;
+		}
+	}
+	else
+	{
+		bat_status.charger_type = NOCHARGER;
+		bat_status.status = DISCHARGING_WITHOUT_CHARGER;
+	}
+	return;
+}
+
+/**
+ * da9052_bat_signal_to_user;
+ * 	This function signal to the lib which call the call back function.
+ *
+ * @param event
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_bat_signal_to_user(u32 event)
+{
+	if (down_interruptible(&event_lock))
+		return (FAILURE);
+	bat_event = set_bits(bat_event,event);
+	up(&event_lock);
+	
+	DA9052_DEBUG("%s: event : %d \n", __FUNCTION__, event);
+	kill_fasync (&bat_fasync_queue, SIGIO, POLL_IN);
+
+	return(SUCCESS);
+}
+
+/**
+ * da9052_charger_dcin_detect_handler : DCIN charger detect event callback
+ *				function
+ *
+ * @param u8 event	event status
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+ void da9052_charger_dcin_detect_handler(u32 event)
+{
+
+	/* Signal to the library for the charger detection event */
+	if(user_space_chg_det_dcin)
+	{
+		da9052_bat_signal_to_user(CHDET_DCIN);
+	}
+}
+
+/**
+ * da9052_charger_vbus_detect_handler : VBUS charger detect event callback
+ *					function
+ *
+ * @param u8 event	event status
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+ void da9052_charger_vbus_detect_handler(u32 event)
+{
+	/* Signal to the library for the charger detection event */
+	if(user_space_chg_det_vbus) {
+		da9052_bat_signal_to_user(CHDET_VBUS);
+	}
+}
+
+/**
+ * da9052_charger_dcin_removal_handler : DCIN charger removal event callback
+ *					function
+ *
+ * @param u8 event	event status
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+ void da9052_charger_dcin_removal_handler(u32 event)
+{
+	
+	/* Signal to the library for the charger removal event */
+	if(user_space_chg_rem_dcin) {
+		da9052_bat_signal_to_user(CHREM_DCIN);
+	}
+}
+
+/**
+ * da9052_charger_vbus_removal_handler : VBUS charger removal event callback
+ *					function
+ *
+ * @param u8 event	event status
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+ void da9052_charger_vbus_removal_handler(u32 event)
+{
+	
+	/* Signal to the library for the charger removal event */
+	if(user_space_chg_rem_vbus) {
+		da9052_bat_signal_to_user(CHREM_VBUS);
+	}
+}
+
+
+/**
+ * da9052_bat_vddlow_handler : VDDOUT LOW event callback function
+ *
+ * @param u8 event	event status
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+void da9052_bat_vddlow_handler(u32 event)
+{	u16 buffer =0;
+	if(!monitoring_status.vddout_status) {		
+		// Measure VDDOUT to update the Monitoring status
+		monitoring_status.vddout_status = TRUE;
+		if(da9052_bat_get_charger_vddout(&buffer)){
+			DA9052_DEBUG("%s : VDDOUT Measurement Fails.\n",__FUNCTION__);
+		}
+		monitoring_status.vddout_value = buffer;
+
+		/* Signal to the library for the VDDLOW event */
+		da9052_bat_signal_to_user(VDDLOW);
+	}
+}
+
+/**
+ * da9052_bat_tbat_handler : TABT event callback function
+ *
+ * @param u8 event	event status
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+void da9052_bat_tbat_handler(u32 event)
+{
+	if(!tbat_event_occur) {	
+		bat_status.health = POWER_SUPPLY_HEALTH_OVERHEAT;
+		tbat_event_occur = TRUE;
+		// update the TBAt value
+		monitoring_status.bat_temp_status = TRUE;
+		monitoring_status.bat_temp_value = bat_info.bat_temp;
+
+		/* Signal to the library for the VDDLOW event */
+		da9052_bat_signal_to_user(TBAT);	
+	}
+}
+
+/**
+ * da9052_charging_end_handler : charging end event callback function
+ *
+ * @param u8 event	event status
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+ void da9052_charging_end_handler(u32 event)
+{
+
+	/* Signal to the library for the Charging End event */
+	if(user_space_chg_chgend) {
+		da9052_bat_signal_to_user(CHGEND);
+	}
+	
+	power_supply_changed(&psy);
+}
+
+
+/*
+ * charger_buck: Enable/Disable the charger buck
+ *
+ * @param u8 flag  	should be a enable/disable
+ * @return s32		Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 charger_buck(u8 flag)
+{
+	da9052_ssc_msg msg;
+
+	/* Read Charger buck register */
+	msg.addr = DA9052_CHGBUCK_REG;
+	if(da9052_ssc_read(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+
+	msg.data = flag ?
+			set_bits(msg.data,DA9052_CHGBUCK_CHGBUCKEN):
+			clear_bits(msg.data,DA9052_CHGBUCK_CHGBUCKEN);
+
+	/* Write charger buck register*/
+	if(da9052_ssc_write(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+
+	return (SUCCESS);
+}
+
+
+
+/*
+ * monitor_current: Monitor the surge in charging current
+ *
+ * @param void
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+ static s32 monitor_current(void)
+{
+	static u8 flag1 =FALSE;
+	u8 count = 0;
+	u16 current_value=0;
+	u16 tempvalue=0;
+	u16 avg_value=0;
+
+	/* Read the charger current value from the current measurement function */
+	if(da9052_bat_get_chg_current(&current_value)){
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (CHG_MEASUREMENT_FAIL);
+	}
+
+	/* If montoring function is called first time then set the window */
+	if(flag1 == FALSE){
+		for(count=0;count<NUMBER_OF_STORE_CURENT_READING;count++) {
+			bat_info.chg_current_raw[count] = 0;
+		}
+
+		tempvalue= (CURRENT_MONITORING_WINDOW *current_value)/100;
+		chg_device->threshold.ichg_av_thr_min = current_value-tempvalue;
+		chg_device->threshold.ichg_av_thr_max = current_value+tempvalue;
+		flag1=TRUE;
+	}
+
+	for(count=(NUMBER_OF_STORE_CURENT_READING-1);count > 0 ;count--)
+		bat_info.chg_current_raw[count] =
+				bat_info.chg_current_raw[count-1];
+	bat_info.chg_current_raw[0] = current_value;
+
+	/* Form last stored value of the charger current get the
+							average value */
+	for(count=0;count<NUMBER_OF_STORE_CURENT_READING;count++) {
+		if(bat_info.chg_current_raw[count] == 0)
+			break;
+		avg_value=avg_value + bat_info.chg_current_raw[count];
+	}
+	if(count != 0)
+		avg_value = avg_value/count;
+	else
+		avg_value = current_value;
+
+	// DA9052_DEBUG("Average_Current = %d\n",avg_value);
+	/* Window is reallign with 10% of the average measur1e value*/
+	tempvalue= (CURRENT_MONITORING_WINDOW *avg_value)/100;
+	
+	/* Check measured value with surge window */
+	if(((current_value < chg_device->threshold.ichg_av_thr_min)
+		|| (current_value > chg_device->threshold.ichg_av_thr_max))) {
+
+		monitoring_status.current_status = TRUE;
+		monitoring_status.current_value = current_value;
+
+#if DA9052_BAT_FILTER_HYS
+		printk( KERN_CRIT "\nBAT_LOG: Current Monitoring Failed = %d mA\n",
+				current_value);
+#endif
+		
+		/* If there is a surge then signal to the user */
+		if(montoring_func_reg) {
+			da9052_bat_signal_to_user(MONITORING);
+		}
+		
+		// if average value read is less than window lower limit re-arrange
+		// the window to lower value
+		chg_device->threshold.ichg_av_thr_min = avg_value - tempvalue;
+		chg_device->threshold.ichg_av_thr_max = avg_value + tempvalue;	
+		return (CHG_MONITORING_FAIL);
+	}
+	else {
+		monitoring_status.current_status = FALSE;
+		monitoring_status.current_value = current_value;
+	}
+
+	// if average value read is less than window lower limit re-arrange
+	// the window to lower value
+	chg_device->threshold.ichg_av_thr_min = avg_value - tempvalue;
+	chg_device->threshold.ichg_av_thr_max = avg_value + tempvalue;
+	return (SUCCESS);
+
+}
+
+
+/*
+ * monitor_bat_temperature: Monitor battery temperature threshold limit
+ *
+ * @param void
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+static s32 monitor_bat_temperature(void)
+{
+	u16 buffer;
+	u8 ret =0;
+
+	/* Measure the BAT temperature using BAT internal function */
+	ret=da9052_bat_get_battery_temperature(&buffer);
+	if(ret)
+		return (ret);
+
+	if(buffer > chg_device->threshold.tbat_thr_limit) {
+		/* If software monitoring is enabled then suspend charging */
+		if(chg_device->sw_temp_cntr ==1)
+			da9052_bat_suspend_charging();
+
+		monitoring_status.bat_temp_status = TRUE;
+		monitoring_status.bat_temp_value = buffer;
+
+		/* If User has registered the monitoring event, signal to
+						the user for the event */
+		if(montoring_func_reg) {
+			da9052_bat_signal_to_user(MONITORING);
+		}
+		return (CHG_MONITORING_FAIL);
+	}
+	else {
+		monitoring_status.bat_temp_status = FALSE;
+		monitoring_status.bat_temp_value = buffer;
+	}
+
+	return (SUCCESS);
+}
+
+/*
+ * monitor_junc_temperature: Monitor the junction temperature
+ *
+ * @param void
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+static s32 monitor_junc_temperature(void)
+{
+	u16 buffer;
+	u8 ret =0;
+
+	/* Measure the Junction temperature using BAT internal function */
+	ret=da9052_bat_get_chg_junc_temperature(&buffer);
+	if(ret)
+		return (ret);
+
+	if(buffer > chg_device->threshold.tjunc_thr_limit) {
+		/* If software monitoring is enabled then suspend charging */
+		if(chg_device->sw_temp_cntr ==1)
+			da9052_bat_suspend_charging();
+
+		monitoring_status.junc_temp_status = TRUE;
+		monitoring_status.junc_temp_value = buffer;
+
+		/* If User has registered the monitoring event, signal to
+						the user for the event */
+		if(montoring_func_reg) {
+			da9052_bat_signal_to_user(MONITORING);
+		}
+		return (CHG_MONITORING_FAIL);
+	}
+	else {
+		monitoring_status.junc_temp_status = FALSE;
+		monitoring_status.junc_temp_value = buffer;
+	}
+	return (SUCCESS);
+}
+
+/*
+ * interpolated: 	Find the battery level for the bat_voltage, given
+ *			Voltage and time at 2 other place using the piecewise
+ *			interpolation method
+ *
+ * @param  u32 vbat_upper
+ * @param  u32 vbat_lower
+ * @param  u32 level_upper
+ * @param  u32 level_lower
+ * @param  u32 bat_voltage
+ * @return u32 time at bat_voltage
+ */
+u32 interpolated( u32 vbat_lower, u32  vbat_upper, u32  level_lower,
+				u32  level_upper, u32 bat_voltage)
+{
+	s32 temp;
+
+	/*apply formula y= yk + (x ?xk) * (yk+1 ?yk)/(xk+1 Êùßk) */
+	temp = ((level_upper - level_lower) * 1000)/(vbat_upper - vbat_lower);
+	temp = level_lower + (((bat_voltage -vbat_lower) * temp)/1000);
+
+	return (temp);
+}
+
+/*
+ * capture_first_correct_vbat_sample:	When hysteresis function is called
+ *			first time, this function helps to get first correct 
+ *			value of battery voltage
+ *
+ * @param  battery_voltage : captured sample of battery voltage
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 capture_first_correct_vbat_sample( u16* battery_voltage)
+{
+	static u8 count = 0;
+	s32 ret =0;	
+	u32 temp_data = 0;
+	
+	ret =da9052_bat_get_battery_voltage(&bat_volt_arr[count]);
+	if(ret)
+		return (ret);
+	count++;
+	//DA9052_DEBUG("Count = %d\n",count);
+	if(count < VBAT_FIRST_VALID_DETECT_ITERATION ) 
+		return (FAILURE);
+	for (count =0; count < (VBAT_FIRST_VALID_DETECT_ITERATION - 1) ; count++) {
+		temp_data = ( bat_volt_arr[count] * 
+					HYSTERESIS_WINDOW_SIZE)/100;
+		bat_hysteresis.upper_limit = bat_volt_arr[count] + temp_data;
+		bat_hysteresis.lower_limit = bat_volt_arr[count] - temp_data;
+		
+		if( (bat_volt_arr[count + 1] < bat_hysteresis.upper_limit ) &&
+			(bat_volt_arr[count + 1] > bat_hysteresis.lower_limit )){
+			
+			*battery_voltage = (bat_volt_arr[count] + 
+							bat_volt_arr[count+1])/ 2;
+			hys_flag = TRUE;
+			return (SUCCESS);
+		}
+	}
+	
+	for(count=0;count < (VBAT_FIRST_VALID_DETECT_ITERATION - 1);count++)
+		bat_volt_arr[count] = bat_volt_arr[count + 1];
+	
+	return (FAILURE);	
+}
+/*
+ * check_hystersis:	Check the hystersis effect for the measured
+ *			bat_voltage value
+ *
+ * @param  u16 *bat_voltage    :bat voltage value to be returned
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 check_hystersis( u16 *bat_voltage)
+{
+	u8 ret=0;
+	u32 offset=0;
+
+	/* Measure battery voltage using BAT internal function*/
+	if(hys_flag == FALSE) {		
+		ret = capture_first_correct_vbat_sample(&array_hys_batvoltage[0]);
+		if(ret)
+			return (ret);
+	}
+
+	ret =da9052_bat_get_battery_voltage(&array_hys_batvoltage[1]);
+	if(ret)
+		return (ret);
+	*bat_voltage = array_hys_batvoltage[1];
+	
+#if DA9052_BAT_FILTER_HYS
+	printk( KERN_CRIT "\nBAT_LOG: Previous Battery Voltage = %d mV\n",
+				array_hys_batvoltage[0]);
+	printk( KERN_CRIT "\nBAT_LOG:Battery Voltage Before Filter = %d mV\n",
+				array_hys_batvoltage[1]);
+#endif
+	/* Check if measured battery voltage value is within the hysteresis
+		window limit using measured battey votlage value */
+	if((bat_hysteresis.upper_limit < *bat_voltage) ||
+			(bat_hysteresis.lower_limit > *bat_voltage)) {
+
+		bat_hysteresis.index++;
+
+		if(bat_hysteresis.index == HYSTERESIS_NO_OF_READING) {
+			/* Hysteresis Window is set to +- of HYSTERESIS_WINDOW_SIZE
+			   percentage of current VBAT */
+			bat_hysteresis.index =0;
+			offset = ((*bat_voltage) * HYSTERESIS_WINDOW_SIZE)/100;
+			bat_hysteresis.upper_limit = (*bat_voltage) + offset;
+			bat_hysteresis.lower_limit = (*bat_voltage) - offset;
+
+		}
+		else
+		{
+#if DA9052_BAT_FILTER_HYS
+			printk( KERN_CRIT "CheckHystersis: Failed\n");
+#endif
+			return (CHG_HYSTERSIS_CHECK_FAILED);
+		}
+	}
+	else {
+
+		/* Hysteresis Window is set to +- of HYSTERESIS_WINDOW_SIZE
+		   percentage of current VBAT */
+		bat_hysteresis.index =0;
+		offset = ((*bat_voltage) * HYSTERESIS_WINDOW_SIZE)/100;
+		bat_hysteresis.upper_limit = (*bat_voltage) + offset;
+		bat_hysteresis.lower_limit = (*bat_voltage) - offset;
+	}
+
+
+	/* Digital C Filter, formula Yn = k Yn-1 + (1-k) Xn */
+	*bat_voltage = ((CHG_HYSTERESIS_CONST * array_hys_batvoltage[0])/100) +
+			(((100 - CHG_HYSTERESIS_CONST) * array_hys_batvoltage[1])/100);
+	
+	if( (bat_status.status == DISCHARGING_WITHOUT_CHARGER) &&
+				(*bat_voltage > array_hys_batvoltage[0]) ) {
+		*bat_voltage = array_hys_batvoltage[0];
+	}
+	
+	//DA9052_DEBUG("Voltage Final =%d \n",*bat_voltage);
+	array_hys_batvoltage[0] = *bat_voltage;
+
+#if DA9052_BAT_FILTER_HYS
+	printk( KERN_CRIT "\nBAT_LOG:Battery Voltage After Filter = %d mV\n",*bat_voltage);
+#endif
+	return (SUCCESS);
+}
+
+/*
+* Function Name : select_temperature()
+*
+* Description : Function select the temperature index btween 2 conscutive
+				temperature
+*
+* Arguments :
+* temp_index : index of the temperature in the temperature lookup table
+* bat_temperature : Current temperature of the battery
+*
+* Return :	The lookup table index which need to be consider for the battey level
+			detemination.
+*/
+u8 select_temperature(u8 temp_index,u16 bat_temperature)
+{
+	u16 temp_temperature = 0;
+	temp_temperature = (temperature_lookup_ref[temp_index] +
+				temperature_lookup_ref[temp_index+1]) / 2;
+
+	if(bat_temperature >= temp_temperature)
+		return (temp_index+1);
+	else
+		return (temp_index);
+}
+
+/*
+ * da9052_get_bat_level: Measure the battery level in terms of %
+ *
+ * @param  void
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_get_bat_level(void)
+{
+	u16 bat_temperature;
+	u16 bat_voltage;
+	u32 vbat_lower, vbat_upper, level_upper, level_lower,level;
+	u8 access_index=0;
+	u8 index=0,ret;
+	u8 flag =FALSE;
+
+	ret = 0;
+	vbat_lower =0;
+	vbat_upper =0;
+	level_upper=0;
+	level_lower=0;
+	
+	//DA9052_DEBUG("STEP 0 \n");
+	/* Function call the hysteresis function. Function measure battery
+					voltage and check for hysteresis */
+	ret = check_hystersis(&bat_voltage);	
+	if(ret)
+		return (ret);
+
+	//DA9052_DEBUG("STEP 1 \n");
+	/* measure battery temperature using BAT function */
+	ret= da9052_bat_get_battery_temperature(&bat_temperature);
+	if(ret)
+		return (ret);
+	/* According to the read battery temperature choose corresponding
+								lookup table */
+	//DA9052_DEBUG("STEP 2 \n");								
+	for (index=0;index<(NO_OF_LOOKUP_TABLE-1);index++) {
+		if(bat_temperature <= temperature_lookup_ref[0]) {
+			access_index=0;
+			break;
+		}
+		else if(bat_temperature >
+				temperature_lookup_ref[NO_OF_LOOKUP_TABLE]){
+			access_index=NO_OF_LOOKUP_TABLE -1;
+			break;
+		}
+		else if((bat_temperature >= temperature_lookup_ref[index])
+			&& (bat_temperature >= temperature_lookup_ref[index+1])){
+			access_index = select_temperature(index,bat_temperature);
+			break;
+		}
+	}
+	//DA9052_DEBUG("STEP 3 = %d \n",bat_voltage);
+	//DA9052_DEBUG("Access Index = %d \n",access_index);
+	/* Base on lookup table selected and measured battery voltage value read
+	* dwVbatLower = lookup table VBAT value immediately lower than
+	*				measured VBAT value
+	* dwVbatUpper = lookup table VBAT value immediately upper than
+	*				measured VBAT value s
+	* dwLevelLower = lookup table level for dwVbatLower value
+	* dwLevelUpper = lookup table level for dwVbatUpper value
+	*/
+	if(bat_voltage >= vbat_vs_capacity_look_up[access_index][0][0]) {
+		bat_status.cal_capacity =100;
+		//DA9052_DEBUG("V100 = %d \n",vbat_vs_capacity_look_up[access_index][0][0]);
+			return(SUCCESS);
+	}
+	if(bat_voltage <=
+		vbat_vs_capacity_look_up[access_index][LOOK_UP_TABLE_SIZE-1][0]){
+		//DA9052_DEBUG("V0 = %d \n",vbat_vs_capacity_look_up[access_index][LOOK_UP_TABLE_SIZE-1][0]);
+		bat_status.cal_capacity =0;
+			return(SUCCESS);
+	}
+
+	flag=FALSE;
+
+	for (index=0;index<(LOOK_UP_TABLE_SIZE-1);index++) {
+		if((bat_voltage <= vbat_vs_capacity_look_up[access_index][index][0]) &&
+			(bat_voltage >= vbat_vs_capacity_look_up[access_index][index+1][0])) {
+			
+			//DA9052_DEBUG("Vaa = %d \n",vbat_vs_capacity_look_up[access_index][index][0]);
+			//DA9052_DEBUG("Vbb = %d \n",vbat_vs_capacity_look_up[access_index][index+1][0]);
+			
+			vbat_upper = vbat_vs_capacity_look_up[access_index][index][0];
+			vbat_lower = vbat_vs_capacity_look_up[access_index][index+1][0];
+			level_upper = vbat_vs_capacity_look_up[access_index][index][1];
+			level_lower = vbat_vs_capacity_look_up[access_index][index+1][1];
+			flag =TRUE;
+			break;
+		}
+	}
+	//DA9052_DEBUG("STEP 4 \n");
+	if(!flag)
+		return (INVALID_VBAT_VALUE);
+
+	// Call interpolation function to get time at  bat_voltage value */
+	level = interpolated(vbat_lower,vbat_upper,level_lower,
+						level_upper,bat_voltage);
+	bat_status.cal_capacity = level;
+	DA9052_DEBUG(" TOTAl_BAT_CAPACITY : %d\n", bat_status.cal_capacity);
+	return (SUCCESS);
+}
+
+/**
+ * eh_thread:
+ * @param data pointer to device specific data
+ * @return int status
+ */
+static s32 monitoring_thread(void* data){
+	u8 mon_count = 0;
+	s32 ret = 0;
+#if DA9052_BAT_PROFILE
+	u8 mon_times = 0;
+	u32 jiffies_count = 0;
+	u32 msec_time_bat_Level = 0;
+#endif
+	//DA9052_DEBUG("Starting BAT Thread...\n");
+	
+	set_freezable();
+	
+	while(monitoring_thread_state == ACTIVE){
+	
+		/* Make this thread friendly to system suspend and resume */
+		try_to_freeze();
+		
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(chg_device->monitoring_interval);
+#if DA9052_BAT_PROFILE
+		jiffies_count = jiffies;
+#endif		
+		da9052_chager_status_update();
+		/**
+		* Each parameter monitoring is schdule in sequence. "mon_count" decide
+		*   the sequence of operation.
+		*   Current Sequence is
+		*   --charger current
+		*   --junction temperature
+		*   --BAT capacity
+		*   --BAT temperature
+		*/
+
+		/* check if battery is in charging mode */
+		if(bat_status.status==CHARGING) {
+			/*  If battery is in charging mode then only call charger
+			    current and bat temperature monitoring  */
+			if(mon_count == 0){
+				if(CHG_MONITORING_FAIL == monitor_current()){
+					DA9052_DEBUG("charging Current Monitoring failed, %d\n",mon_count);
+				}
+			}
+
+			/* call junction temperature monitoring */
+			else if(mon_count == 1){
+				if(CHG_MONITORING_FAIL == monitor_junc_temperature()){
+					DA9052_DEBUG("Charger Junction Temperature Monitoring failed\n");
+				}
+			}
+		}
+
+		if(mon_count == 2){
+			ret = da9052_get_bat_level();			
+			if(!ret) {
+				// BAT Capacity is low then update the monitoring status
+				if(bat_status.cal_capacity < BAT_CAPACITY_LIMIT_LOW)	{
+					monitoring_status.bat_level_status = TRUE;
+					monitoring_status.bat_level = bat_status.cal_capacity;
+				}
+				else {
+					monitoring_status.bat_level_status = 0;
+					monitoring_status.bat_level = bat_status.cal_capacity;
+				}
+			}
+			else {
+				DA9052_DEBUG("Battery Measurement Fails = %d\n",ret);
+			}
+		}
+
+		if(mon_count == 3){
+			if(CHG_MONITORING_FAIL == monitor_bat_temperature()){
+				DA9052_DEBUG("BAT Temperature Monitoring failed\n");
+			}
+		}
+
+#if DA9052_BAT_PROFILE	
+		jiffies_count =  jiffies - jiffies_count;
+		
+		if(mon_count ==2) {
+			mon_times++;		
+			msec_time_bat_Level = msec_time_bat_Level + 
+						jiffies_to_msecs(jiffies_count);
+			
+			if(mon_times == 5) {
+				printk( KERN_CRIT "\n\nBAT_LOG:5 BAT Level Monitoring cycle time = %d msec\n", 
+							msec_time_bat_Level);
+				printk( KERN_CRIT "BAT_LOG:BAT Level Value: %d percent\n",monitoring_status.bat_level);
+				mon_times = 0;
+				msec_time_bat_Level = 0;
+			}
+		}
+#endif		
+		mon_count++;
+		if(mon_count == 4){
+			mon_count = 0;		
+		}
+		 
+		/* modify and reschedule timer with same time interval */
+		//DA9052_DEBUG("Monitoring interval = %d\n",chg_device->monitoring_interval);
+	}
+
+	complete_and_exit(&monitoring_thread_notifier, 0);
+
+	return (SUCCESS);
+}
+
+/*
+ * filter_sample: Perform the average filtering
+ *
+ * @param u16 *buffer  Parameter buffer pointer
+ * @return u16		Filtered value
+ */
+ u16 filter_sample(u16 *buffer)
+{
+	u8 count;
+	u16 tempvalue=0;
+
+	if(buffer == NULL)
+		return(FAILURE);
+
+	for(count=0;count<FILTER_SIZE;count++){
+		tempvalue=tempvalue + *(buffer + count);
+	}
+
+	return (tempvalue/FILTER_SIZE);
+}
+
+/*--------------------------------------------------------------------------*/
+/* Global Functions                                                         */
+/*--------------------------------------------------------------------------*/
+
+
+/*
+ * da9052_remaining_charging_time: Read charging time and convert it
+ *				in terms of minutes
+ *
+ * @param u8 *buffer  (buffer pointer)
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_bat_get_remaining_charging_time(u16 *buffer)
+{
+	da9052_ssc_msg msg;
+
+	msg.addr = DA9052_CHGTIME_REG;
+	/* Read charging time register */
+	if(da9052_ssc_read(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+
+	/* Convert register value in terms of minutes*/
+	*buffer = msg.data * 2;
+	return (SUCCESS);
+}
+
+
+/*
+ * da9052_bat_get_chg_current: 	Measure the charger current and convert
+ *				raw current value in terms of mA
+ *
+ * @param u16 *buffer (buffer pointer)
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32  da9052_bat_get_chg_current(u16 *buffer)
+{
+
+	if(bat_status.status == DISCHARGING_WITHOUT_CHARGER)
+		return (BAT_NOT_CHARGING);
+
+	/* Measure the Charger current using ADC function */
+	if(da9052_adc_read_ich(buffer)){
+		return (CHG_MEASUREMENT_FAIL);
+	}
+
+	/* Convert the raw value in terms of mA */
+	bat_info.chg_current = ichg_reg_to_mA(*buffer);
+	*buffer=bat_info.chg_current;
+
+	return (SUCCESS);
+}
+
+/*
+ * da9052_bat_get_chg_junc_temperature: Measure the junction temperature and
+ *					convert value in terms of C
+ *
+ * @param u16 *buffer (buffer pointer)
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32  da9052_bat_get_chg_junc_temperature(u16 *buffer)
+{
+	u8 count;
+	u16 filterqueue[FILTER_SIZE];
+
+	if(bat_status.status != CHARGING)
+		return (BAT_NOT_CHARGING);
+
+	/* Measure the junciton temperature using ADC function. Number
+					of read equal to average filter size*/
+	for(count=0;count<FILTER_SIZE;count++){
+		if(da9052_adc_read_tjunc(&filterqueue[count])){
+			return (CHG_MEASUREMENT_FAIL);
+		}
+	}
+
+	/* Apply average filter */
+	filterqueue[0]=filter_sample(filterqueue);
+
+	/* Convert the junction temperature raw value in terms of C */
+	bat_info.chg_junc_temp = (((1708 *
+						filterqueue[0])/1000) - 106);
+	*buffer=bat_info.chg_junc_temp;
+
+	return (SUCCESS);
+}
+
+/*
+ * da9052_bat_get_battery_voltage:	Measure the battery voltage and convert
+ *				value in terms of mV
+ *
+ * @param u16 *buffer (buffer pointer)
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32  da9052_bat_get_battery_voltage(u16 *buffer)
+{
+	u8 count;
+	u16 filterqueue[FILTER_SIZE];
+
+	/* Measure the battery voltage using ADC function. Number
+					of read equal to average filter size*/
+	for(count=0;count<FILTER_SIZE;count++){
+		if(da9052_adc_read_vbat(&filterqueue[count])){
+			return (CHG_MEASUREMENT_FAIL);
+		}
+	}
+	/* Apply average filter */
+	filterqueue[0]=filter_sample(filterqueue);
+
+	/* Convert battery voltage raw value in terms of mV */
+	bat_info.bat_voltage = volt_reg_to_mV(filterqueue[0]);
+	*buffer=bat_info.bat_voltage;
+	return (SUCCESS);
+}
+
+/*
+ * da9052_bat_get_backup_battery_voltage:	Measure the backup battery voltage and
+ *					convert value in terms of mV
+ *
+ * @param u16 *buffer (buffer pointer)
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32  da9052_bat_get_backup_battery_voltage(u16 *buffer)
+{
+	u8 count;
+	u16 filterqueue[FILTER_SIZE];
+
+	/* Measure the backup battery voltage using ADC function. Number
+					of read equal to average filter size*/
+	for(count=0;count<FILTER_SIZE;count++){
+		if(da9052_adc_read_vbbat(&filterqueue[count])){
+			return (CHG_MEASUREMENT_FAIL);
+		}
+	}
+
+	/* Apply average filter */
+	filterqueue[0]=filter_sample(filterqueue);
+
+	/* Convert backup battey voltage raw value in terms of mV */
+	bat_info.backup_bat_voltage =
+					volt_reg_to_mV(filterqueue[0]);
+	*buffer=bat_info.backup_bat_voltage;
+
+	return (SUCCESS);
+}
+
+/*
+ * da9052_bat_get_battery_temperature:	Measure the bat temperature and
+ *					return raw value
+ *
+ * @param u16 *buffer (buffer pointer)
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32  da9052_bat_get_battery_temperature(u16 *buffer)
+{
+	u8 count;
+	u16 filterqueue[FILTER_SIZE];
+
+	/* Measure the battery temperature using ADC function. Number
+				of read equal to average filter size*/
+	for(count=0;count<FILTER_SIZE;count++){
+		if(da9052_adc_read_tbat(&filterqueue[count])){
+			return (CHG_MEASUREMENT_FAIL);
+		}
+	}
+
+	/* Apply Average filter */
+	filterqueue[0]=filter_sample(filterqueue);
+
+	bat_info.bat_temp = filterqueue[0];
+	*buffer=bat_info.bat_temp;
+
+	return (SUCCESS);
+}
+
+/*
+ * da9052_bat_get_charger_vddout:	Measure the charger output voltage and
+ *				convert it in mV
+ *
+ * @param u16 *buffer (buffer pointer)
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32  da9052_bat_get_charger_vddout(u16 *buffer)
+{
+	u8 count;
+	u16 filterqueue[FILTER_SIZE];
+
+	if(bat_status.status != CHARGING)
+	return (BAT_NOT_CHARGING);
+
+	/* Measure the charger voltage using ADC function. Number
+					of read equal to average filter size*/
+	for(count=0;count<FILTER_SIZE;count++){
+		if(da9052_adc_read_vddout(&filterqueue[count])){
+			return (CHG_MEASUREMENT_FAIL);
+		}
+	}
+
+	/*Apply average filter */
+	filterqueue[0]=filter_sample(filterqueue);
+
+	/* Convert the charger voltage in terms of mV */
+	bat_info.vddout = vddout_reg_to_mV(filterqueue[0]);
+	*buffer=bat_info.vddout;
+
+	return (SUCCESS);
+}
+
+
+/*
+ * da9052_get_bat_status: Function check the status of the battery
+ *
+ * @param  da9052_bat_status *buffer:	function will put status in this buffer
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_get_bat_status( da9052_bat_status *status_buffer)
+{
+	da9052_ssc_msg msg;
+	u16 buffer;
+
+	/* If battery is in discharging mode then set charging
+							mode and return */
+	if(bat_status.status == DISCHARGING_WITHOUT_CHARGER){
+		bat_status.charging_mode=NONE;
+	}
+
+	if(bat_status.status == DISCHARGING_WITH_CHARGER){
+		bat_status.charging_mode=NONE;
+	}
+	else
+	{
+		msg.addr = DA9052_STATUSB_REG;
+		/* Read STATUS_B register */
+		if(da9052_ssc_read(&msg))
+			return (SSC_FAIL);
+
+		/* Check if the battery is in Pre-charging mode */
+		if(msg.data & DA9052_STATUSB_CHGPRE) {
+			/* If battery is in Pre-charging mode. set Pre-charging
+			   status and return */
+			bat_status.charging_mode=PRECHARGING;
+			bat_status.status=CHARGING;
+		}
+		else {
+		/* Measure battery voltag. if battery voltage is less than
+			(VCHG_BAT - VCHG_DROP) battery is in linear
+								charging mode*/
+			if(da9052_bat_get_battery_voltage(&buffer)) {
+				DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+				return (CHG_MEASUREMENT_FAIL);
+			}
+			if((buffer < (chg_device->bat_target_voltage -
+					chg_device->charger_voltage_drop)) &&
+						(buffer > BAT_VOLT_CUTOFF)){
+				/* Set linear charging status and return */
+				bat_status.charging_mode=LINEARCHARGING;
+			}
+			/* Else battey is in charge termintation mode. Set Charge end
+									status and return */
+			else if(buffer > (chg_device->bat_target_voltage -
+					chg_device->charger_voltage_drop)){
+				bat_status.charging_mode=CHARGEEND;
+			}
+		}
+	}
+
+	status_buffer->cal_capacity = bat_status.cal_capacity;
+	status_buffer->charging_mode = bat_status.charging_mode;
+	status_buffer->charger_type = bat_status.charger_type;
+	status_buffer->status = bat_status.status;
+	status_buffer->illegalbattery = bat_status.illegalbattery;
+
+	return (SUCCESS);
+}
+
+
+
+/*
+ * da9052_bat_suspend_charging: Suspend the charging for the battery
+ *
+ * @param void
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_bat_suspend_charging()
+{
+	da9052_ssc_msg msg;
+
+	if( (bat_status.status == DISCHARGING_WITHOUT_CHARGER) ||
+		(bat_status.status == DISCHARGING_WITH_CHARGER) )
+		return (SUCCESS);
+
+	msg.addr = DA9052_INPUTCONT_REG;
+	/* Read Input condition register */
+	if(da9052_ssc_read(&msg))
+		return (SSC_FAIL);
+
+	/* set both Wall charger and USB charger suspend bit */
+	msg.data = set_bits(msg.data,DA9052_INPUTCONT_DCINSUSP);
+	msg.data = set_bits(msg.data,DA9052_INPUTCONT_VBUSSUSP);
+
+	/* Write to Input control register */
+	if(da9052_ssc_write(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+	
+	power_supply_changed(&psy);
+
+	DA9052_DEBUG("%s : Sucess\n",__FUNCTION__);
+	return (SUCCESS);
+}
+
+/*
+ * da9052_bat_resume_charging: Resume the charging for the battery
+ *
+ * @param void
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_bat_resume_charging()
+{
+	da9052_ssc_msg msg;
+
+	if( bat_status.illegalbattery)
+		return (FAILURE);
+	
+	if( (bat_status.status == CHARGING) )
+		return (SUCCESS);
+
+	msg.addr = DA9052_INPUTCONT_REG;
+	/* Read Input condition register */
+	if(da9052_ssc_read(&msg))
+		return (SSC_FAIL);
+
+	/* Reset both Wall charger and USB charger suspend bit */
+	msg.data = clear_bits(msg.data,DA9052_INPUTCONT_DCINSUSP);
+	msg.data = clear_bits(msg.data,DA9052_INPUTCONT_VBUSSUSP);
+
+	/* Write to Input control register */
+	if(da9052_ssc_write(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+	
+	 power_supply_changed(&psy);
+
+	DA9052_DEBUG("%s : Sucess\n",__FUNCTION__);
+	return (SUCCESS);
+}
+
+/*
+ * da9052_bat_configure_thresholds: configure the threshold for the battery
+ *
+ * @param da9052_bat_threshold thresholds
+ *				(structure containing threshold settings)
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_bat_configure_thresholds(da9052_bat_threshold thresholds)
+{
+	da9052_ssc_msg msg;
+
+	/* check VDDOUTLOW range */
+	if((VDDOUT_MON_LOWER > thresholds.vddout_mon) &&
+				(VDDOUT_MON_UPPER < thresholds.vddout_mon)){
+		return (INVALID_VDDOUT_MON_VALUE);
+	}
+
+	/* Convert user configuration in term of bit field value */
+	msg.data = vddout_mon_mV_to_reg(thresholds.vddout_mon);
+
+	/* Write to VDDMON register */
+	msg.addr = DA9052_VDDMON_REG;
+	if(da9052_ssc_write(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+
+
+	/* Check th cahrger current threshold range */
+	if(ICHG_THRESHOLD_UPPER < thresholds.ichg_thr){
+		return (INVALID_ICHG_THRESHOLD_VALUE);
+	}
+
+	/* Convert the charger curent in term of bit field value */
+	msg.data = ichg_mA_to_reg(thresholds.ichg_thr);
+
+	/* Write to ICHGTHD register */
+	msg.addr = DA9052_ICHGTHD_REG;
+	if(da9052_ssc_write(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+
+	/* Check the TBAT max theshold range */
+	if(TBAT_MAX_THRESHOLD_LIMIT < thresholds.tbat_thr_max){
+		return (INVALID_BAT_TEMP_HIGH);
+	}
+
+	msg.data = thresholds.tbat_thr_max;
+
+	/* Write to the TBATHIGHP register*/
+	msg.addr = DA9052_TBATHIGHP_REG;
+	if(da9052_ssc_write(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+
+	/* Check the TBAT min theshold range */
+	if(TBAT_MIN_THRESHOLD_LIMIT < thresholds.tbat_thr_min){
+		return (INVALID_BAT_TEMP_LOW);
+	}
+
+	msg.data = thresholds.tbat_thr_min;
+
+	/* Write to the TBATLOW register*/
+	msg.addr = DA9052_TBATLOW_REG;
+	if(da9052_ssc_write(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+
+	/* Check the TBAT charging resume value range */
+	if(TBAT_HIGHNS_THRESHOLD_LIMIT < thresholds.tbat_thr_highns){
+		return (INVALID_BAT_TEMP_HIGHN);
+	}
+
+	msg.data = thresholds.tbat_thr_highns;
+
+	/* Write to TBATHIGHIN register */
+	msg.addr = DA9052_TBATHIGHIN_REG;
+	if(da9052_ssc_write(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+	chg_device->threshold = thresholds;
+	return (SUCCESS);
+}
+/*
+ * da9052_bat_configure_charger: 	Configure the battery charger according to
+ *				user configuration
+ *
+ * @param da9052_charger_device charger
+  * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_bat_configure_charger(da9052_charger_device charger)
+{
+	da9052_ssc_msg msg;
+
+	/* Configure buck_low_power, chg_usb_ilim and chg_temp_cntr */
+	DA9052_DEBUG("FUNCTION: %s\n",__FUNCTION__);
+
+	/* charger BAT_CHG register */
+	msg.addr = DA9052_CHGBUCK_REG;
+	if(da9052_ssc_read(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+	msg.data = charger.chager_buck_lp ?
+				set_bits(msg.data,DA9052_CHGBUCK_CHGBUCKLP):
+				clear_bits(msg.data,DA9052_CHGBUCK_CHGBUCKLP);
+
+	msg.data = charger.usb_charger_det ?
+				set_bits(msg.data,DA9052_CHGBUCK_CHGUSBILIM):
+				clear_bits(msg.data,DA9052_CHGBUCK_CHGUSBILIM);
+
+	msg.data = charger.auto_temp_cntr ?
+				set_bits(msg.data,DA9052_CHGBUCK_CHGTEMP):
+				clear_bits(msg.data,DA9052_CHGBUCK_CHGTEMP);
+
+	if(da9052_ssc_write(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+
+	/* Configure ISET_VBUS and ISET_DCIN */
+	msg.data = 0x0;
+
+	if( (ISET_LOW > charger.dcin_current) &&
+				(charger.dcin_current > ISET_HIGH)) {
+		return (INVALID_DCIN_CURRENT_LIMIT_VALUE);
+	}
+
+	if( (ISET_LOW > charger.vbus_current) &&
+				(charger.vbus_current > ISET_HIGH)) {
+		return (INVALID_VBUS_CURRENT_LIMIT_VALUE);
+	}
+	if( (ISET_LOW > charger.usb_charger_current) &&
+				(charger.usb_charger_current > ISET_HIGH)) {
+		return (INVALID_USB_CHARGER_CURRENT_LIMIT_VALUE);
+	}
+	chg_device->dcin_current = charger.dcin_current;
+	chg_device->vbus_current = charger.vbus_current;
+	chg_device->usb_charger_current = charger.usb_charger_current;
+
+	if((iset_mA_to_reg(charger.vbus_current) &&
+				iset_mA_to_reg(charger.dcin_current)) == 0)
+		return (FAILURE);
+	msg.data = iset_mA_to_reg(charger.vbus_current) |
+			(iset_mA_to_reg(charger.dcin_current) << 4);
+
+	msg.addr = DA9052_ISET_REG;
+	if(da9052_ssc_write(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+	/* Configure Precharing current limit */
+	/* charger BAT_CHG register */
+	msg.addr = DA9052_BATCHG_REG;
+	if(da9052_ssc_read(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+	if( (PRE_CHARGE_0MA != charger.precharging_current) &&
+			(PRE_CHARGE_20MA != charger.precharging_current) &&
+			(PRE_CHARGE_40MA != charger.precharging_current) &&
+			(PRE_CHARGE_60MA != charger.precharging_current)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (INVALID_PRECHARGE_CURRENT_VALUE);
+	}
+
+	msg.data = clear_bits(msg.data,DA9052_BATCHG_ICHGPRE);
+	msg.data = set_bits(msg.data,
+			precharge_mA_to_reg(charger.precharging_current));
+
+	if(da9052_ssc_write(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+	/* Configure charging_time, battery_target_volt and charger_volt_drop */
+	msg.data = 0;
+
+	if(charger.charging_time > MAX_BAT_CHARGING_TIME) {
+		return (INVALID_CHARGING_TIME);
+	}
+
+	if((BAT_TARGET_VOLTAGE_LOWER_LIMIT > charger.bat_target_voltage) &&
+				(charger.bat_target_voltage > BAT_TARGET_VOLTAGE_UPPER_LIMIT) ){
+		return (INVALID_CHG_BAT_VOLTAGE);
+	}
+
+	if((CHARGER_VOLTAGE_DROP_LOWER_LIMIT > charger.charger_voltage_drop) &&
+		(charger.charger_voltage_drop > CHARGER_VOLTAGE_DROP_UPPER_LIMIT)) {
+		return (INVALID_CHG_VOLTAGE_DROP);
+	}
+	msg.data = (charger.charging_time/CHARGING_TIME_INTERVAL) |
+				bat_mV_to_reg(charger.bat_target_voltage) |
+				bat_drop_mV_to_reg(charger.charger_voltage_drop);
+	msg.addr = DA9052_CHGCONT_REG;
+	if(da9052_ssc_write(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+
+	/* Configure chg_volt_thr, ichg_low and timermode */
+	msg.data = 0;
+
+	if((BAT_VOLTAGE_THRESHOLD_LOWER_LIMIT > charger.voltage_threshold) &&
+		(charger.voltage_threshold > BAT_VOLTAGE_THRESHOLD_UPPER_LIMIT) ){
+		return (INVALID_CHG_VOLTAGE_THRESHOLD);
+	}
+
+	msg.data = vch_thr_mV_to_reg(charger.voltage_threshold) |
+			(charger.ichg_low_cntr ? DA9052_INPUTCONT_ICHGLOW : 0) |
+			(charger.timer_mode ? DA9052_INPUTCONT_TCTRMODE : 0);
+
+	msg.addr = DA9052_INPUTCONT_REG;
+	if(da9052_ssc_write(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+	/* configure charger charging end current */
+
+	msg.data =0;
+	msg.data = (charger.chg_end_current / 4);
+
+	msg.addr = DA9052_ICHGEND_REG;
+	if(da9052_ssc_write(&msg)) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (SSC_FAIL);
+	}
+
+	/* Configure charger monitoring frequency and temperature_soft_cntr */
+	chg_device->sw_temp_cntr = charger.sw_temp_cntr;
+	chg_device->monitoring_interval=
+			msecs_to_jiffies(charger.monitoring_interval);
+	
+	power_supply_changed(&psy);
+	
+	DA9052_DEBUG("FINISHED FUNCTION: %s\n",__FUNCTION__);
+	return (SUCCESS);
+}
+
+/**
+ * da9052_bat_register_event : register the event
+ *
+ * @param u8 event_type	event type
+ * @param u8 flag	call from user space or kernel space
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_bat_register_event(u8 event_type,u8 flag)
+{
+
+	/* check the event type and according set the event status and
+						callback function pointer*/
+	switch(event_type) {
+	case VDD_LOW_EVE:
+		if (event_status.da9052_event_vddlow == FALSE) {
+			vddlow_eh_data.eve_type = event_type;
+			vddlow_eh_data.call_back =da9052_bat_vddlow_handler;
+			DA9052_DEBUG("events = %d\n",event_type);
+			if(da9052_eh_register_nb(&vddlow_eh_data))
+				return (IRQ_REGISTER_FAILED);
+			event_status.da9052_event_vddlow =TRUE;
+		}
+		break;
+	case TBAT_EVE:
+		if (event_status.da9052_event_tbat == FALSE) {
+			tbat_eh_data.eve_type = event_type;
+			tbat_eh_data.call_back =da9052_bat_tbat_handler;
+			DA9052_DEBUG("events = %d\n",event_type);
+			if(da9052_eh_register_nb(&tbat_eh_data))
+				return (IRQ_REGISTER_FAILED);
+			event_status.da9052_event_tbat =TRUE;
+		}
+		break;
+	case CHG_END_EVE:
+		if(flag) {
+			if (event_status.da9052_event_chgend == FALSE) {
+				chgend_eh_data.eve_type = event_type;
+				chgend_eh_data.call_back =da9052_charging_end_handler;
+				if(da9052_eh_register_nb(&chgend_eh_data))
+					return (IRQ_REGISTER_FAILED);
+				event_status.da9052_event_chgend =TRUE;
+			}
+		}
+		else
+		{
+			user_space_chg_chgend = TRUE;
+		}
+	break;
+	case VBUS_DET_EVE:
+		if(flag){
+			if (event_status.da9052_event_chdet_vbus == FALSE){
+				chgdet_vbus_eh_data.eve_type = event_type;
+				chgdet_vbus_eh_data.call_back =
+					da9052_charger_vbus_detect_handler;
+				if(da9052_eh_register_nb(&chgdet_vbus_eh_data))
+					return (IRQ_REGISTER_FAILED);
+				event_status.da9052_event_chdet_vbus=TRUE;
+			}
+		}
+		else
+		{
+			DA9052_DEBUG("VBUS_DETECT\n");
+			user_space_chg_det_vbus =TRUE;
+		}
+		break;
+	case VBUS_REM_EVE:
+		if(flag) {
+			if (event_status.da9052_event_chrem_vbus == FALSE){
+				chgrem_vbus_eh_data.eve_type = event_type;
+				chgrem_vbus_eh_data.call_back =
+					da9052_charger_vbus_removal_handler;
+				if(da9052_eh_register_nb(&chgrem_vbus_eh_data))
+					return (IRQ_REGISTER_FAILED);
+				event_status.da9052_event_chrem_vbus=TRUE;
+			}
+		}
+		else {
+			user_space_chg_rem_vbus =TRUE;
+		}
+		break;
+	case DCIN_DET_EVE:
+		if(flag){
+			if (event_status.da9052_event_chdet_dcin == FALSE){
+				chgdet_dcin_eh_data.eve_type = event_type;
+				chgdet_dcin_eh_data.call_back =
+					da9052_charger_dcin_detect_handler;
+				if(da9052_eh_register_nb(&chgdet_dcin_eh_data))
+					return (IRQ_REGISTER_FAILED);
+				event_status.da9052_event_chdet_dcin=TRUE;
+			}
+		}
+		else
+		{
+			user_space_chg_det_dcin =TRUE;
+		}
+		break;
+	case DCIN_REM_EVE:
+		if(flag) {
+			if (event_status.da9052_event_chrem_dcin == FALSE){
+				chgrem_dcin_eh_data.eve_type = event_type;
+				chgrem_dcin_eh_data.call_back =
+					da9052_charger_dcin_removal_handler;
+				if(da9052_eh_register_nb(&chgrem_dcin_eh_data))
+					return (IRQ_REGISTER_FAILED);
+				event_status.da9052_event_chrem_dcin=TRUE;
+			}
+		}
+		else {
+			user_space_chg_rem_dcin =TRUE;
+		}
+		break;
+	case DA9030_EVENT_MONITORING_FAIL:
+		montoring_func_reg = TRUE;
+		break;
+	default:
+		return(BAT_INVALID_EVENT);
+	}
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_bat_unregister_event : register the event
+ *
+ * @param u8 event_type	event type
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_bat_unregister_event(u8 event_type,u8 flag)
+{
+	/* check the event type and according clear the event status and set
+						callback function pointer*/
+	DA9052_DEBUG("EVENT = %d\n",event_type);
+	switch(event_type) {
+	case VDD_LOW_EVE:
+		if (event_status.da9052_event_vddlow) {
+			if(da9052_eh_unregister_nb(&vddlow_eh_data))
+				return (IRQ_UNREGISTER_FAILED);
+			event_status.da9052_event_vddlow =FALSE;
+		}
+		break;
+	case TBAT_EVE:
+		if (event_status.da9052_event_tbat) {
+			if(da9052_eh_unregister_nb(&tbat_eh_data))
+				return (IRQ_UNREGISTER_FAILED);
+			event_status.da9052_event_tbat =FALSE;
+		}
+		break;
+	case CHG_END_EVE:
+		if(flag) {
+			if (event_status.da9052_event_chgend) {
+				if(da9052_eh_unregister_nb(&chgend_eh_data))
+					return (IRQ_UNREGISTER_FAILED);
+				event_status.da9052_event_chgend =FALSE;
+			}
+		}
+		else
+		{
+			user_space_chg_chgend = FALSE;
+		}
+	break;
+	case VBUS_DET_EVE:
+		if(flag) {
+			if (event_status.da9052_event_chdet_vbus){
+				if(da9052_eh_unregister_nb(
+						&chgdet_vbus_eh_data))
+					return (IRQ_UNREGISTER_FAILED);
+				event_status.da9052_event_chdet_vbus=FALSE;
+			}
+		}
+		else {
+			user_space_chg_det_vbus =FALSE;
+		}
+		break;
+	case VBUS_REM_EVE:
+		if(flag) {
+			if (event_status.da9052_event_chrem_vbus){
+				if(da9052_eh_unregister_nb(
+						&chgrem_vbus_eh_data))
+					return (IRQ_UNREGISTER_FAILED);
+				event_status.da9052_event_chrem_vbus=FALSE;
+			}
+		}
+		else {
+			user_space_chg_rem_vbus =FALSE;
+		}
+		break;
+	case DCIN_DET_EVE:
+		if(flag) {
+			if (event_status.da9052_event_chdet_dcin){
+				if(da9052_eh_unregister_nb(
+							&chgdet_dcin_eh_data))
+					return (IRQ_UNREGISTER_FAILED);
+				event_status.da9052_event_chdet_dcin=FALSE;
+			}
+		}
+		else {
+			user_space_chg_det_dcin =FALSE;
+		}
+		break;
+	case DCIN_REM_EVE:
+		if(flag) {
+			if (event_status.da9052_event_chrem_dcin){
+				if(da9052_eh_unregister_nb(
+						&chgrem_dcin_eh_data))
+					return (IRQ_UNREGISTER_FAILED);
+				event_status.da9052_event_chrem_dcin=FALSE;
+			}
+		}
+		else {
+			user_space_chg_rem_dcin =FALSE;
+		}
+		break;
+	case DA9030_EVENT_MONITORING_FAIL:
+		montoring_func_reg = FALSE;
+		break;
+	default:
+		return(BAT_INVALID_EVENT);
+	}
+	
+	
+
+	return (SUCCESS);
+}
+
+/*--------------------------------------------------------------------------*/
+/* Infrastructure Functions                                                 */
+/*--------------------------------------------------------------------------*/
+
+/*
+ * da9052_bat_sw_init: Allocate memory and Initialise global sturcture
+ *
+ * @param dev	platofrm device structure
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+s32 da9052_bat_sw_init(struct platform_device *pdev)
+{
+	da9052_ssc_msg msg;
+	
+	DA9052_DEBUG(" FUNCTION : %s\n",__FUNCTION__);
+
+	chg_device = (da9052_charger_device*) kmalloc(
+				sizeof(da9052_charger_device),GFP_KERNEL);
+	if(chg_device == NULL) {
+		DA9052_DEBUG("Memory Allocation Failed for chg_device \
+					structure in %s\n",__FUNCTION__);
+		return (ENOMEM);
+	}
+
+	/* Global Varaiable initialization */
+	bat_hysteresis.upper_limit = 0;
+	bat_hysteresis.lower_limit = 0;
+
+	event_status.da9052_event_vddlow = FALSE;
+	event_status.da9052_event_tbat = FALSE;
+	event_status.da9052_event_chgend = FALSE;
+	event_status.da9052_event_chdet_dcin = FALSE;
+	event_status.da9052_event_chrem_dcin = FALSE;
+	event_status.da9052_event_chdet_vbus = FALSE;
+	event_status.da9052_event_chrem_vbus = FALSE;
+	user_space_chg_det_dcin = FALSE;
+	user_space_chg_rem_dcin = FALSE;
+	user_space_chg_det_vbus = FALSE;
+	user_space_chg_rem_vbus = FALSE;
+	user_space_chg_chgend = FALSE;
+
+	/*Static configuration for the Battery charger*/
+	chg_device->monitoring_interval = msecs_to_jiffies(MONITORING_INTERVAL);
+	chg_device->sw_temp_cntr = SW_TEMP_CONTROL_EN;
+	chg_device->usb_charger_current = 0;
+	
+	bat_status.charger_type = NOCHARGER;
+	bat_status.status = CHARGING;
+	bat_status.charging_mode = NONE;
+	tbat_event_occur =FALSE;
+
+	/* Read and store the Target battery voltage and voltage drop reading 
+	   from DA9052. This configuration are set from OTP and used in 
+	   BAT driver.*/
+	msg.addr = DA9052_CHGCONT_REG;
+	/* Read Input condition register */
+	if(da9052_ssc_read(&msg))
+		return (SSC_FAIL);
+		
+	chg_device->charger_voltage_drop = 
+			bat_drop_reg_to_mV(msg.data && DA9052_CHGCONT_VCHGDROP);
+	chg_device->bat_target_voltage =
+			bat_reg_to_mV(msg.data && DA9052_CHGCONT_VCHGBAT);
+	
+	/* Read and store the Charging_end current reading from DA9052. 
+	   This configuration are set from OTP and used in BAT driver.*/
+	msg.addr = DA9052_ICHGEND_REG;
+	/* Read Input condition register */
+	if(da9052_ssc_read(&msg))
+		return (SSC_FAIL);
+		
+	chg_device->chg_end_current = ichg_reg_to_mA(msg.data);
+
+	/* Threshold Static configuration */
+	/* All TBAT value are raw values from ADC and not in terms of Celicus.
+	Coversion from raw value to Celicus depends upon the temperature sensor
+	attached in battery. Hence conversion is not consider in driver */
+	chg_device->threshold.tbat_thr_limit = SW_BAT_TEMP_THRESHOLD;
+	chg_device->threshold.tjunc_thr_limit = SW_JUNC_TEMP_THRESHOLD;
+
+	/* Battery Info configuration */
+	sprintf(bat_info.manufacture,BAT_MANUFACTURER);
+	bat_status.illegalbattery = FALSE;
+	
+#if (DA9052_ILLEGAL_BATTERY_DETECT)
+	// Detect illegal Battery
+	detect_illegal_battery();		
+#endif
+
+	// Look at the charger status and update status of the battery charger
+	da9052_chager_status_update();
+
+	/* Initialize TSI FIFO lock */
+	init_MUTEX(&event_lock);
+
+	/* Registration for charger detect and charger removal interrupt */
+	da9052_bat_register_event(VBUS_DET_EVE,TRUE);
+	da9052_bat_register_event(VBUS_REM_EVE,TRUE);
+	da9052_bat_register_event(DCIN_DET_EVE,TRUE);
+	da9052_bat_register_event(DCIN_REM_EVE,TRUE);
+	da9052_bat_register_event(CHG_END_EVE,TRUE);
+
+	/* Initialise the power supply DA9052 instance */
+	da9052_battery_setup_psy();
+	
+	/* Register the power supply structure to OS. */
+	 if (power_supply_register(&pdev->dev, &psy))
+		return FAILURE;
+	
+	/* Initialize Monitoring timer*/
+	monitoring_thread_state = ACTIVE;
+	init_completion(&monitoring_thread_notifier);
+	monitoring_thread_pid = kernel_thread(monitoring_thread, NULL, CLONE_KERNEL | SIGCHLD);
+
+	if(monitoring_thread_pid > 0 ){
+		printk(KERN_ERR "Monitoring thread is successfully started, pid = %d\n", monitoring_thread_pid);
+	}
+
+	return (SUCCESS);
+}
+
+/*
+ * da9052_bat_sw_deinit: Deallocate the memory assign during init.
+ *			unregistered the register event to the EH,
+ *			stop montoring timer and disable charger buck.
+ *
+ * @param void
+ * @return s32	Error status 0:SUCCESS, Non Zero: Error
+ */
+static s32 da9052_bat_sw_deinit(void)
+{
+	DA9052_DEBUG(" FUNCTION : %s\n",__FUNCTION__);
+
+	/* Unregister power Supply to OS */
+	power_supply_unregister(&psy);
+	
+	/* Disable charger buck */
+	//charger_buck(FALSE);
+
+	/* stop and delete monitoring timer */
+	monitoring_thread_state = INACTIVE;
+	wait_for_completion(&monitoring_thread_notifier);
+
+	/* unregistered any registered event to the EH */
+	if (event_status.da9052_event_vddlow) {
+		da9052_eh_unregister_nb(&vddlow_eh_data);
+		event_status.da9052_event_vddlow =FALSE;
+	}
+	if (event_status.da9052_event_tbat) {
+		da9052_eh_unregister_nb(&tbat_eh_data);
+		event_status.da9052_event_tbat =FALSE;
+	}
+	if (event_status.da9052_event_chgend) {
+		da9052_eh_unregister_nb(&chgend_eh_data);
+		event_status.da9052_event_chgend =FALSE;
+	}
+	if (event_status.da9052_event_chdet_dcin){
+		da9052_eh_unregister_nb(&chgdet_dcin_eh_data);
+		event_status.da9052_event_chdet_dcin=FALSE;
+	}
+	if (event_status.da9052_event_chrem_dcin){
+		da9052_eh_unregister_nb(&chgrem_dcin_eh_data);
+		event_status.da9052_event_chrem_dcin=FALSE;
+	}
+	if (event_status.da9052_event_chdet_vbus){
+		da9052_eh_unregister_nb(&chgdet_vbus_eh_data);
+		event_status.da9052_event_chdet_vbus=FALSE;
+	}
+	if (event_status.da9052_event_chrem_vbus){
+		da9052_eh_unregister_nb(&chgrem_vbus_eh_data);
+		event_status.da9052_event_chrem_vbus=FALSE;
+	}
+
+	/* Free Memory for the assigned strcuture */
+	kfree(chg_device);
+
+	return (SUCCESS);
+}
+
+/**
+ * da9052_bat_open:
+ *
+ * @param *inode pointer to device inode
+ * @param *file  file pointer
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_bat_open(struct inode *inode, struct file *file)
+{
+	/* Check if device is already open */
+	if(bat_device_open) {
+		printk( KERN_INFO "DA9052: BAT device already open.\n");
+		return (-EBUSY);
+	} else {
+		printk( KERN_INFO "DA9052: BAT device open.\n");
+		bat_device_open++;
+		return (SUCCESS);
+	}
+}
+
+/**
+ * da9052_bat_release:
+ *
+ * @param *inode pointer to device inode
+ * @param *file  file pointer
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_bat_release(struct inode *inode, struct file *file)
+{
+	bat_device_open--;
+	printk( KERN_INFO "DA9052: BAT device closed.\n");
+	return (SUCCESS);
+}
+
+/**
+ * da9052_bat_suspend: Power Management support function
+ *
+ * @param *dev   pointer to platform device
+ * @param state  pm state
+ * @return s32 status of suspend operation
+ */
+static s32 da9052_bat_suspend(struct platform_device *dev, pm_message_t state)
+{
+	printk(KERN_INFO "%s: called\n", __FUNCTION__);
+
+	bat_status.status = POWER_SUPPLY_STATUS_UNKNOWN;
+	
+	/* Put your suspend related operations here */
+
+	return (0);
+}
+
+/**
+ * da9052_bat_resume: Power Management support function
+ *
+ * @param *dev   pointer to platform device
+ * @return s32 status of resume operation
+ */
+static s32 da9052_bat_resume(struct platform_device *dev)
+{
+	printk(KERN_INFO "%s: called\n", __FUNCTION__);
+
+	bat_status.status = POWER_SUPPLY_STATUS_UNKNOWN;
+	power_supply_changed(&psy);
+	
+	/* Put your resume related operations here */
+	return (0);
+}
+
+/**
+ * da9052_bat_ioctl:
+ *
+ * @param *inode <Direction> <Description>
+ * @param *file  <Direction> <Description>
+ * @return int   <Description>
+ */
+s32 da9052_bat_ioctl(struct inode *inode, struct file *file,
+					unsigned int cmd, unsigned long arg)
+{
+	da9052_charger_device usr_param;
+	da9052_bat_threshold usr_param_threshold_res;
+	u32 buffer_32;
+	u16 buffer;
+	u8 buffer1;
+	da9052_bat_status usr_bat_status;
+	u8 ret=0;
+
+	DA9052_DEBUG("BAT IOCTLI function\n");
+
+	switch(cmd) {
+	case DA9052_BAT_IOCTL_GET_CHG_CURRENT:
+		if( (bat_status.status == DISCHARGING_WITHOUT_CHARGER) ||
+			(bat_status.status == DISCHARGING_WITH_CHARGER) )
+			return (BAT_NOT_CHARGING);
+
+		if(copy_to_user((u16 *)arg,(void *)&(bat_info.chg_current),
+								sizeof(buffer)))
+			return (COPY_TO_USER_FAIL);
+		break;
+	case DA9052_BAT_IOCTL_GET_CHG_JUNC_TEMPERATURE:
+		if( (bat_status.status == DISCHARGING_WITHOUT_CHARGER) ||
+			(bat_status.status == DISCHARGING_WITH_CHARGER) )
+			return (BAT_NOT_CHARGING);
+
+		if(copy_to_user((u16 *)arg,(void *)&(bat_info.chg_junc_temp),
+								sizeof(buffer)))
+			return (COPY_TO_USER_FAIL);
+		break;
+	case DA9052_BAT_IOCTL_GET_BAT_VOLTAGE:
+		if(copy_to_user((u16 *)arg,(void *)&(bat_info.bat_voltage),
+								sizeof(buffer)))
+			return (COPY_TO_USER_FAIL);
+		break;
+	case DA9052_BAT_IOCTL_GET_BACKUP_BAT_VOLTAGE:
+		ret=da9052_bat_get_backup_battery_voltage(&buffer);
+		if(ret)
+			return (ret);
+		if(copy_to_user((u16 *)arg,(void *)&buffer,sizeof(buffer)))
+			return (COPY_TO_USER_FAIL);
+		break;
+	case DA9052_BAT_IOCTL_GET_BAT_TEMPERATURE:
+		if(copy_to_user((u16 *)arg,(void *)&(bat_info.bat_temp),
+								sizeof(buffer)))
+			return (COPY_TO_USER_FAIL);
+		break;
+	case DA9052_BAT_IOCTL_GET_CHG_VDDOUT:
+		ret=da9052_bat_get_charger_vddout(&buffer);
+		if(ret)
+			return (ret);
+		if(copy_to_user((u16 *)arg,(void *)&buffer,sizeof(buffer)))
+			return (COPY_TO_USER_FAIL);
+		break;
+	case DA9052_BAT_IOCTL_REMAINING_CHARGING_TIME:
+		if(bat_status.status == DISCHARGING_WITHOUT_CHARGER )
+			return (BAT_NOT_CHARGING);
+		ret=da9052_bat_get_remaining_charging_time(&buffer);
+		if(ret)
+			return (ret);
+		if(copy_to_user((u16 *)arg,(void *)&buffer,sizeof(buffer)))
+			return (COPY_TO_USER_FAIL);
+		break;
+	case DA9052_BAT_IOCTL_CONFIGURE_CHARGER:
+		if (copy_from_user(&usr_param, (da9052_charger_device *)arg,
+					sizeof(da9052_charger_device)))
+			return (COPY_FROM_USER_FAIL);
+		ret=da9052_bat_configure_charger(usr_param);
+		if(ret)
+			return (ret);
+		break;
+	case DA9052_BAT_IOCTL_CONFIGURE_THRESHOLDS:
+		if (copy_from_user(&usr_param_threshold_res,
+				(da9052_bat_threshold *)arg,
+					sizeof(da9052_bat_threshold)))
+			return (COPY_FROM_USER_FAIL);
+		ret=da9052_bat_configure_thresholds(usr_param_threshold_res);
+		if(ret)
+			return (ret);
+		break;
+	case DA9052_BAT_IOCTL_GET_MONITORING_STATUS:
+		if(copy_to_user((monitoring_state *)arg,(void *)&monitoring_status,
+						sizeof(monitoring_state)))
+			return (COPY_TO_USER_FAIL);
+
+		break;
+	case DA9052_BAT_IOCTL_GET_BAT_STATUS:
+		ret=da9052_get_bat_status(&usr_bat_status);
+		if(ret)
+			return (ret);
+		if(copy_to_user((da9052_bat_status *)arg,(void *)&usr_bat_status,
+						sizeof(da9052_bat_status)))
+			return (COPY_TO_USER_FAIL);
+		break;
+	case DA9052_BAT_IOCTL_SUSPEND_CHARGING:
+		ret=da9052_bat_suspend_charging();
+		if(ret)
+			return (ret);
+		break;
+	case DA9052_BAT_IOCTL_RESUME_CHARGING:
+		ret=da9052_bat_resume_charging();
+		if(ret)
+			return (ret);
+		break;
+	case DA9052_BAT_IOCTL_GET_EVENT:
+		if (down_interruptible(&event_lock))
+			return (FAILURE);
+		buffer_32 = bat_event;
+		bat_event = 0;
+		up(&event_lock);
+
+		if(copy_to_user((u32 *)arg, &buffer_32, sizeof(u32)))
+			return (COPY_TO_USER_FAIL);
+		
+		if(monitoring_status.vddout_status) {
+			monitoring_status.vddout_status = FALSE;
+		}			
+		if(tbat_event_occur) {
+			tbat_event_occur =FALSE;
+		}			
+		break;
+	case DA9052_BAT_IOCTL_SET_USB_POWER_NEGOTIATED_VALUE:
+		if( (bat_status.status == DISCHARGING_WITHOUT_CHARGER) ||
+			(bat_status.status == DISCHARGING_WITH_CHARGER) )
+			return (BAT_NOT_CHARGING);
+
+		if (copy_from_user(&buffer, (u16 *)arg, sizeof(u16)))
+			return (COPY_FROM_USER_FAIL);
+		ret = da9052_bat_current_lim(buffer);
+		if(ret)
+			return (ret);
+		break;
+	case DA9052_BAT_IOCTL_REGISTER_EVENT:
+		if (copy_from_user(&buffer1, (u8 *)arg, sizeof(u8)))
+			return (COPY_FROM_USER_FAIL);
+		ret=da9052_bat_register_event(buffer1,FALSE);
+		if(ret)
+			return (ret);
+		break;
+	case DA9052_BAT_IOCTL_UNREGISTER_EVENT:
+		if (copy_from_user(&buffer1, (u8 *)arg, sizeof(u8)))
+			return (COPY_FROM_USER_FAIL);
+		ret=da9052_bat_unregister_event(buffer1,FALSE);
+		if(ret)
+			return (ret);
+		break;
+	default:
+		DA9052_DEBUG("Invalid ioctl command\n");
+		return (INVALID_BAT_IOCTL_CMD);
+	}
+	return (SUCCESS);
+}
+
+/**
+ * da9052_bat_fasync: register file descriptor asynchronous notification for events
+ *
+ * @param void 	 <Direction> <Description>
+ * @return int   <Description>
+ */
+s32 da9052_bat_fasync (s32 fd, struct file *filp, s32 on)
+{
+  DA9052_DEBUG ("In %s: %s\n",__FILE__, __FUNCTION__);
+  return(fasync_helper(fd, filp, on, &bat_fasync_queue));
+}
+/**
+ * static struct file_operations da9052_bat_fops -
+ * This structure definition has to be defined here as an exception.
+ * @owner: member description
+ * @open : member description
+ * @release: member description
+ * @ioctl: member description
+ *
+ */
+static const struct file_operations da9052_bat_fops = {
+	.owner		= THIS_MODULE,
+	.open		= da9052_bat_open,
+	.release	= da9052_bat_release,
+	.ioctl		= da9052_bat_ioctl,
+	.fasync		= da9052_bat_fasync
+};
+
+
+/**
+ * da9052_bat_probe: Called when a device gets attached to driver
+ * @param struct platform_device *dev: platform device instance
+ * @return int   Error Code, zero: no error
+ */
+static s32 __devinit da9052_bat_probe(struct platform_device *dev)
+{
+	s32 ret;
+
+	/* Register the device */
+	ret = register_chrdev(bat_major_number,
+				DA9052_BAT_DEVICE_NAME, &da9052_bat_fops);
+	if (ret < 0) {
+		printk(KERN_ERR "Unable to register %s\n",
+						DA9052_BAT_DEVICE_NAME);
+		return (-EFAULT);
+	} else {
+		bat_major_number = ret;	
+		printk(KERN_INFO "%s: Major number is: %d.\n",
+				DA9052_BAT_DEVICE_NAME, bat_major_number);
+
+		if (da9052_bat_sw_init(dev)) {
+			/* Error in hw initialization */
+			unregister_chrdev(bat_major_number,
+						DA9052_BAT_DEVICE_NAME);
+			return (-EFAULT);
+		}
+		else{
+			return (SUCCESS);
+		}
+	}
+}
+
+/**
+ * da9052_bat_remove: Called when ditaching device from driver
+ * @param void
+ * @return void
+ */
+static int __devexit da9052_bat_remove(struct platform_device *dev)
+{
+	DA9052_DEBUG("Removing %s \n", DA9052_BAT_DEVICE_NAME);
+	return (SUCCESS);
+}
+
+/**
+ * static struct platform_driver da9052_bat_driver -
+ * This structure definition has to be defined here as an exception.
+ * @probe: Probe function for this device.
+ * @remove: Function to be called when removing this device from platform
+ * @driver: Contains glue logic to bind platform device and plarform driver
+ */
+static struct platform_driver da9052_bat_driver = {
+	.probe		= da9052_bat_probe,
+	.remove		= __devexit_p(da9052_bat_remove),
+	.suspend	= da9052_bat_suspend,
+	.resume		= da9052_bat_resume,
+	.driver		= {
+		.name	= DA9052_BAT_DEVICE_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+/**
+ * da9052_bat_init: Initiales the driver
+ *
+ * @param void
+ * @return int   Error Code, zero: no error
+ */
+static s32 __init da9052_bat_init(void)
+{
+	int retval;
+	printk(banner);
+
+	da9052_bat_platform_device = platform_device_alloc("da9052_bat", 0);
+	if (!da9052_bat_platform_device)
+		return (-ENOMEM);
+
+	retval = platform_device_add(da9052_bat_platform_device);
+	if (retval < 0) {
+		platform_device_put(da9052_bat_platform_device);
+		return (retval);
+	}
+
+	retval = platform_driver_register(&da9052_bat_driver);
+	if (retval < 0)
+		platform_device_unregister(da9052_bat_platform_device);
+
+	return (retval);
+}
+/**
+ * da9052_bat_exit:
+ *
+ * @param void	 <Direction> <Description>
+ * @return void  <Description>
+ */
+static void __exit da9052_bat_exit(void)
+{
+	da9052_bat_sw_deinit();
+	printk("DA9052: Unregistering BAT device.\n");
+	unregister_chrdev(bat_major_number, DA9052_BAT_DEVICE_NAME);
+	platform_driver_unregister(&da9052_bat_driver);
+	platform_device_unregister(da9052_bat_platform_device);
+}
+
+
+module_init(da9052_bat_init);
+module_exit(da9052_bat_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd");
+MODULE_DESCRIPTION("DA9052 BAT Device Driver");
+MODULE_LICENSE("GPL");
+
+/*--------------------------------------------------------------------------*/
+/* Exports                                                                  */
+/*--------------------------------------------------------------------------*/
+
+/* AC - Put here all functions that you want to be accessible from other drivers */
+EXPORT_SYMBOL(da9052_bat_get_chg_current);
+EXPORT_SYMBOL(da9052_bat_get_chg_junc_temperature );
+EXPORT_SYMBOL(da9052_bat_get_battery_voltage);
+EXPORT_SYMBOL(da9052_bat_get_backup_battery_voltage);
+EXPORT_SYMBOL(da9052_bat_get_battery_temperature);
+EXPORT_SYMBOL(da9052_bat_get_charger_vddout);
+EXPORT_SYMBOL(da9052_bat_get_remaining_charging_time);
+EXPORT_SYMBOL(da9052_bat_configure_charger);
+EXPORT_SYMBOL(da9052_bat_configure_thresholds);
+EXPORT_SYMBOL(da9052_get_bat_status);
+EXPORT_SYMBOL(da9052_bat_suspend_charging);
+EXPORT_SYMBOL(da9052_bat_resume_charging);
+
diff -Naur linux-2.6.33.2_bk/drivers/power/Makefile linux-2.6.33.2_patch/drivers/power/Makefile
--- linux-2.6.33.2_bk/drivers/power/Makefile	2010-04-02 04:02:33.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/power/Makefile	2010-05-18 18:20:23.000000000 +0500
@@ -31,3 +31,4 @@
 obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
 obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
 obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
+obj-$(CONFIG_DA9052_BAT_ENABLE) += da9052_bat.o
diff -Naur linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_bat.h linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_bat.h
--- linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_bat.h	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_bat.h	2010-05-18 18:20:23.000000000 +0500
@@ -0,0 +1,950 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_bat.h: BAT driver header file
+ *
+ * Authors:
+ *
+ * History:
+ *
+ * (08/05/2009):	First release version
+ * (19/05/2009):	Unit tested code version
+ *
+ * (27/04/2010):	Updated for Linux Community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+
+#ifndef _DA9052_BAT_H
+#define _DA9052_BAT_H
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
+/* BAT Device name and static Major number macros */
+#define DA9052_BAT_DEVICE_NAME			"da9052_bat"
+
+/* BAT related Event Number */
+#define DA9030_EVENT_MONITORING_FAIL		100
+
+/*--------------------------------------------------------------------------*/
+/* BAT Device Error Codes                                                  */
+/*--------------------------------------------------------------------------*/
+
+/* SSC Read or Write Error */
+#define SSC_FAIL				150
+
+/* Battery Charger parameter like Battery Voltage Mesurement  Error */
+#define CHG_MEASUREMENT_FAIL			154
+
+/* Invalid VDDOUT threshold Value */
+#define INVALID_VDDOUT_MON_VALUE		155
+
+/* Invalid Charging Current Limit threshold Value */
+#define INVALID_ICHG_THRESHOLD_VALUE		156
+
+/* Invalid battery Temperature Threshold maximum upper limit */
+#define INVALID_BAT_TEMP_HIGH			157
+
+/* Invalid battery Temperature Threshold maximum Lower limit */
+#define INVALID_BAT_TEMP_LOW			158
+
+/* Invalid battery Temperature Threshold where charging resumes */
+#define INVALID_BAT_TEMP_HIGHN			159
+
+/* Invalid Precharging current limit */
+#define INVALID_PRECHARGE_CURRENT_VALUE		160
+
+/* Invalid battery Charging time configuration */
+#define INVALID_CHARGING_TIME			161
+
+/* Invalid battery charger target voltage configuration */
+#define INVALID_CHG_BAT_VOLTAGE			162
+
+/* Invalid battery charger voltage drop configuration */
+#define INVALID_CHG_VOLTAGE_DROP		163
+
+/* Invalid battery charger voltage threshold configuration */
+#define INVALID_CHG_VOLTAGE_THRESHOLD		164
+
+/* Invalid battery charger end current configuration */
+#define INVALID_CHG_CURRENT_END_VALUE		165
+
+/* Invalid Wall charger charging current limit */
+#define INVALID_DCIN_CURRENT_LIMIT_VALUE	166
+
+/* Invalid USB Hub/Host charging current limit */
+#define INVALID_VBUS_CURRENT_LIMIT_VALUE	167
+
+/* Invalid USB Charger Charging Current limit */
+#define INVALID_USB_CHARGER_CURRENT_LIMIT_VALUE	176
+
+/* Battery charger Monitoring Failure */
+#define CHG_MONITORING_FAIL			169
+
+/* BAT Driver open Error */
+#define BAT_OPEN_FAIL				170
+
+/* Invalid BAT Driver IOCTL call  */
+#define INVALID_BAT_IOCTL_CMD			171
+
+/* Error in copying data from user user space to kernel space */
+#define COPY_FROM_USER_FAIL			172
+
+/* Error in copying data from user kernel space to user space */
+#define COPY_TO_USER_FAIL			173
+
+/* BAT driver registration Fails */
+#define BAT_REGISTER_FAIL			174
+
+/* BAT Driver initialization Fails */
+#define INIT_FAIL				175
+
+/* BAT Charger hystersis check Fails */
+#define CHG_HYSTERSIS_CHECK_FAILED		177
+
+/* BAT Event IRQ unregistration Fails */
+#define IRQ_UNREGISTER_FAILED			178
+
+/* BAT Event IRQ registration Fails */
+#define IRQ_REGISTER_FAILED			179
+
+/* BAT IRQ registration Invalid Event */
+#define BAT_INVALID_EVENT			180
+
+/* Battery voltage is not present in the Battery capacity lookup table */
+#define INVALID_VBAT_VALUE			181
+
+/* FIFO Empty Error */
+#define FIFO_EMPTY				182
+
+/* BAT is not charging hence parameter measurement Fails */
+#define BAT_NOT_CHARGING			183
+
+/*--------------------------------------------------------------------------*/
+/* STATIC CONFIGURATION                                                    */
+/*--------------------------------------------------------------------------*/
+
+/**
+ * Disable charging hence Software temperature contol Fails
+ * IF 1 BAT Driver will suspend charging if temperature is outside the 
+ *	software limit configure by user
+ * IF 0 BAT Driver will not suspend charging if temperature is outside the 
+ *	software limit configure by user
+ */
+#define SW_TEMP_CONTROL_EN			0
+
+/**
+ * Monitoring interval in milliseconds
+ * Battery charger monitoring will be perfomed periodic at this interval
+ */
+#define MONITORING_INTERVAL			500
+
+/**
+ * Thid decide if Battery charger automatic USB Detection is to enabled.
+ * IF 1 AUTO_USB DETECT is enabled
+ * IF 0 AUTO_USB DETECT is disabled
+ */
+#define USB_CH_DET				1
+
+/**
+ * Threshold upper limit for the battery temperature
+ */
+#define SW_BAT_TEMP_THRESHOLD			60
+
+/**
+ * Threshold upper limit for the junction temperature in C
+ */
+#define SW_JUNC_TEMP_THRESHOLD			120
+
+/**
+ * Battery Manufacturer name
+ */
+#define BAT_MANUFACTURER			"Samsung"
+
+/**
+ * Battery technology type
+ */
+#define BAT_TYPE				POWER_SUPPLY_TECHNOLOGY_LION
+
+/**
+ * VBAT v/s BAT Level Lookup table Size. This Define the number of VBAT & BAT 
+ * Level pair entires for every Temperature lookup table.
+ */
+#define LOOK_UP_TABLE_SIZE			68
+
+/**
+ * Number of lookup table for BAT Capacity at different battery temperature.
+ * This define the number of different temperature at which battery capacity 
+ * lookup table need to be defined
+ */
+#define NO_OF_LOOKUP_TABLE			3
+
+/**
+ * Battery Voltage Hysteresis Window Filter Size in term of battery voltage 
+ * percentage
+ */
+#define HYSTERESIS_WINDOW_SIZE			1
+
+/**
+ * Battery Charging Current monitoring Window Filter Size in term of 
+ * Charging current percentage.
+ * Filter is used to catch the surge in charging curren. Hence the Window size 
+ * should be large enough to ignore the small oscillation in charging current 
+ */
+#define CURRENT_MONITORING_WINDOW		10
+
+/**
+ * Battery Temperature reading from DA9052 when external temperature sensor 
+ * (RTC resistor ) is not connected. This is used to detect the illegal Battery
+ * Illegal battery means battery connected without temperature sensor.
+ */
+#define BAT_WITH_NO_RESISTOR			62
+
+/**
+ * Battery Level to define that BAttery capacity is very low.
+ */
+#define BAT_CAPACITY_LIMIT_LOW			4
+
+/**
+ * Battery Level to define that Battery capacity is full.
+ */
+#define BAT_CAPACITY_FULL			100
+
+/**
+ * Battery Level to define that Battery Capacity is very high.
+ */
+#define BAT_CAPACITY_LIMIT_HIGH			70
+
+/**
+ * Battery voltage hystersis constant. 
+ * Charging Mode: 
+ *         	YN = K * YN-1 + (1 ?K) * XN
+ * Discharging Mode:
+ * 		YN = K * YN-1 + (1 ?K) * XN
+ *		If (YN > YN-1)
+ *			{YN = YN-1}
+ * k - hystersis constant
+ * The constant is to be chosen that the filter response time (Tt) is about 
+ * 10 second. For a system with sample frequency of 2 s/s, X0 = 0, Y0 = 0 
+ * and X1 = XN = 1, constant is to be chosen that:
+ * Y20 = 90% * XN.
+ */
+#define CHG_HYSTERESIS_CONST			89
+
+/** 
+ * HYSTERESIS_READING_INTERVAL. Time delay between consecutive hysteresis 
+ * check if hysteresis fails. Note interval should be configured in msec.
+ */
+#define HYSTERESIS_READING_INTERVAL		1000
+
+/** 
+ * HYSTERESIS_NO_OF_READING. 
+ * Note:- Each interval step is of HYSTERESIS_READING_INTERVAL 
+ */
+#define HYSTERESIS_NO_OF_READING		10
+
+/**
+ * Size for Average Filter 
+ */
+#define FILTER_SIZE				4
+
+/**
+ * Define number of previous charging current reading to be store to 
+ * correct define the window Filter Limit during the charging current 
+ * monitoring
+ */
+#define NUMBER_OF_STORE_CURENT_READING		4
+
+/**
+ * Minimum Battery voltage value require to run the system being used
+ */
+#define BAT_VOLT_CUTOFF				2800
+
+/**
+ * Battery voltage first valid value detect number of iteration
+ */
+#define VBAT_FIRST_VALID_DETECT_ITERATION	3
+
+/**
+ * Illegal Battery Detection Enabled. 
+ * To enable the Illegal Battery Detection set  1 to the macr 
+ */
+#define DA9052_ILLEGAL_BATTERY_DETECT		1
+
+/**
+ * Battery profiling Enable.  
+ */
+#define DA9052_BAT_PROFILE			0
+
+/**
+ * Battery Hysteresis Filter Analaysis Data Collection Enable.  
+ */
+#define DA9052_BAT_FILTER_HYS			0
+
+/**
+ * BAT Debug Macro. To enable the Debug set 1 to the macro 
+ */
+#define DA9052_BAT_DEBUG 			0
+
+#undef DA9052_DEBUG
+#if DA9052_BAT_DEBUG
+	#define DA9052_DEBUG( fmt, args... ) printk( KERN_CRIT "" fmt, ##args )
+#else
+	#define DA9052_DEBUG( fmt, args... )
+#endif
+
+/*--------------------------------------------------------------------------*/
+/* Battery Charger range Validation macros                                 */
+/*--------------------------------------------------------------------------*/
+#define VDDOUT_MON_LOWER			2500
+#define VDDOUT_MON_UPPER			4500
+#define ICHG_THRESHOLD_UPPER			1000
+#define TBAT_MAX_THRESHOLD_LIMIT		255
+#define TBAT_MIN_THRESHOLD_LIMIT		255
+#define TBAT_HIGHNS_THRESHOLD_LIMIT		255
+#define ISET_LOW				70
+#define ISET_HIGH				1300
+#define MAX_BAT_CHARGING_TIME			450
+#define BAT_TARGET_VOLTAGE_LOWER_LIMIT		4100
+#define BAT_TARGET_VOLTAGE_UPPER_LIMIT		4400
+#define CHARGER_VOLTAGE_DROP_LOWER_LIMIT	100
+#define CHARGER_VOLTAGE_DROP_UPPER_LIMIT	400
+#define CHARGING_TIME_INTERVAL			30
+#define BAT_VOLTAGE_THRESHOLD_LOWER_LIMIT	3700
+#define BAT_VOLTAGE_THRESHOLD_UPPER_LIMIT	4400
+
+/*--------------------------------------------------------------------------*/
+/* Constant Definitions                                                     */
+/*--------------------------------------------------------------------------*/
+
+/**
+ * Array to hold temperature entry for which lookup table is filled.
+ * Number of entry should be equal to NO_OF_LOOKUP_TABLE
+ */
+static const u16 temperature_lookup_ref[NO_OF_LOOKUP_TABLE]={10,25,40};
+
+/**
+ * BAT capacity lookup table is a 2 dimensional array. Each entry cotains 2
+ * data, first data need to be battery voltage and other data should be
+ * BAT Level at that battery voltage. 
+ * Detail description about filling the lookup table will be documented 
+ * seperately.
+ */
+static u32 const vbat_vs_capacity_look_up[NO_OF_LOOKUP_TABLE][LOOK_UP_TABLE_SIZE][2]=
+{
+	/* For temperature 10 degree celisus*/
+	{
+		{4082,100},{4036,98},
+		{4020,96},{4008,95},
+		{3997,93},{3983,91},
+		{3964,90},{3943,88},
+		{3926,87},{3912,85},
+		{3900,84},{3890,82},
+		{3881,80},{3873,79},
+		{3865,77},{3857,76},
+		{3848,74},{3839,73},
+		{3829,71},{3820,70},
+		{3811,68},{3802,67},
+		{3794,65},{3785,64},
+		{3778,62},{3770,61},
+		{3763,59},{3756,58},
+		{3750,56},{3744,55},
+		{3738,53},{3732,52},
+		{3727,50},{3722,49},
+		{3717,47},{3712,46},
+		{3708,44},{3703,43},
+		{3700,41},{3696,40},
+		{3693,38},{3691,37},
+		{3688,35},{3686,34},
+		{3683,32},{3681,31},
+		{3678,29},{3675,28},
+		{3672,26},{3669,25},
+		{3665,23},{3661,22},
+		{3656,21},{3651,19},
+		{3645,18},{3639,16},
+		{3631,15},{3622,13},
+		{3611,12},{3600,10},
+		{3587,9},{3572,7},
+		{3548,6},{3503,5},
+		{3420,3},{3268,2},
+		{2992,1},{2746,0}
+	},
+
+	/* For temperature 25 degree celisus */
+	{
+		{4102,100},{4065,98},
+		{4048,96},{4034,95},
+		{4021,93},{4011,92},
+		{4001,90},{3986,88},
+		{3968,87},{3952,85},
+		{3938,84},{3926,82},
+		{3916,81},{3908,79},
+		{3900,77},{3892,76},
+		{3883,74},{3874,73},
+		{3864,71},{3855,70},
+		{3846,68},{3836,67},
+		{3827,65},{3819,64},
+		{3810,62},{3801,61},
+		{3793,59},{3786,58},
+		{3778,56},{3772,55},
+		{3765,53},{3759,52},
+		{3754,50},{3748,49},
+		{3743,47},{3738,46},
+		{3733,44},{3728,43},
+		{3724,41},{3720,40},
+		{3716,38},{3712,37},
+		{3709,35},{3706,34},
+		{3703,33},{3701,31},
+		{3698,30},{3696,28},
+		{3693,27},{3690,25},
+		{3687,24},{3683,22},
+		{3680,21},{3675,19},
+		{3671,18},{3666,17},
+		{3660,15},{3654,14},
+		{3647,12},{3639,11},
+		{3630,9},{3621,8},
+		{3613,6},{3606,5},
+		{3597,4},{3582,2},
+		{3546,1},{2747,0}
+	},
+
+	/* For temperature 40 degree celisus*/
+	{
+		{4114,100},{4081,98},
+		{4065,96},{4050,95},
+		{4036,93},{4024,92},
+		{4013,90},{4002,88},
+		{3990,87},{3976,85},
+		{3962,84},{3950,82},
+		{3939,81},{3930,79},
+		{3921,77},{3912,76},
+		{3902,74},{3893,73},
+		{3883,71},{3874,70},
+		{3865,68},{3856,67},
+		{3847,65},{3838,64},
+		{3829,62},{3820,61},
+		{3812,59},{3803,58},
+		{3795,56},{3787,55},
+		{3780,53},{3773,52},
+		{3767,50},{3761,49},
+		{3756,47},{3751,46},
+		{3746,44},{3741,43},
+		{3736,41},{3732,40},
+		{3728,38},{3724,37},
+		{3720,35},{3716,34},
+		{3713,33},{3710,31},
+		{3707,30},{3704,28},
+		{3701,27},{3698,25},
+		{3695,24},{3691,22},
+		{3686,21},{3681,19},
+		{3676,18},{3671,17},
+		{3666,15},{3661,14},
+		{3655,12},{3648,11},
+		{3640,9},{3632,8},
+		{3622,6},{3616,5},
+		{3611,4},{3604,2},
+		{3594,1},{2747,0}
+	}
+};
+
+/* Enum definitions */
+/**
+ * charge_status_enum -	Enum to represent the charger status
+ *
+ * @NONE: 			Default state = 0
+ * @CHARGING: 			BAT in charging mode = 1
+ * @DISCHARGING_WITH_CHARGER: 	BAT in discharing mode with charger connected = 2
+ * @DISCHARGING_WITHOUT_CHARGER:BAT in discharing mode without charger= 3
+ * @PRECHARGING: 		BAT is in Pre charging mode = 4
+ * @LINEARCHARGING: 		BAT is in linear charging mode = 5
+ * @CHARGEEND:	 		BAT is in charge end Mode = 6
+ */
+enum charge_status_enum {
+	NONE=1,
+	CHARGING,
+	DISCHARGING_WITH_CHARGER,
+	DISCHARGING_WITHOUT_CHARGER,
+	PRECHARGING,
+	LINEARCHARGING,
+	CHARGEEND};
+
+/**
+ * charger_type_enum -	Enum to represent the charger type
+ *
+ * @NOCHARGER: 		Charger is not connected = 0
+ * @USB_HUB: 		Charger is of USB Host type = 1
+ * @USB_CHARGER: 	Charger is of USB Charger type = 2
+ * @WALL_CHARGER: 	Charger is of Wall charger type = 3
+ */
+enum charger_type_enum {
+	NOCHARGER=1,
+	USB_HUB,
+	USB_CHARGER,
+	WALL_CHARGER};
+
+/**
+ * precharge_enum -	Enum to represent the precharging current
+ *
+ * @PRE_CHARGE_0MA: 	Precharging disabled
+ * @PRE_CHARGE_20MA: 	Precharging current limit set to 20 mA
+ * @PRE_CHARGE_40MA: 	Precharging current limit set to 40 mA
+ * @PRE_CHARGE_60MA: 	Precharging current limit set to 60 mA
+ */
+enum precharge_enum {
+	PRE_CHARGE_0MA=0,
+	PRE_CHARGE_20MA=20,
+	PRE_CHARGE_40MA=40,
+	PRE_CHARGE_60MA=60};
+
+/**
+ * event_enum -	Enum to represent the the index in 32 bit varaiable.
+ * This 32 bit varaiable is passed to library when event occur. library parse
+ * the varaiable using this enum to get the event that have occur.
+ *
+ * @VDDLOW: 		VDDLOW Event index
+ * @TBAT: 		TBAT Event index
+ * @CHGEND: 		CHGEND Event index
+ * @CHDET_DCIN: 	CHDET_DCIN Event index
+ * @CHREM_DCIN: 	CHREM_DCIN Event index
+ * @CHDET_VBUS: 	CHDET_VBUS Event index
+ * @CHREM_VBUS: 	CHREM_VBUS Event index
+ * @MONITORING:		MONITORING Event index
+ */	
+enum event_enum {	
+	VDDLOW = (1<<0),
+	TBAT = (1<<1),
+	CHGEND = (1<<2),
+	CHDET_DCIN = (1<<3),
+	CHREM_DCIN = (1<<4),
+	CHDET_VBUS = (1<<5),
+	CHREM_VBUS = (1<<6),
+	MONITORING = (1<<7)};
+
+/*--------------------------------------------------------------------------*/
+/* Structure Definitions                                                    */
+/*--------------------------------------------------------------------------*/
+
+/**
+ * struct da9052_bat_event_regestration -
+ *			Struct to battery event registration status
+ *
+ * @da9052_event_vddlow:	VDDLOW event registered or unregistered
+ * @da9052_event_tbat: 		TBAT event registered or unregistered
+ * @da9052_event_chgend:	CHGEND event registered or unregistered
+ * @da9052_event_chdet_dcin:	Wall charger detection event registered or unregistered
+ * @da9052_event_chdet_vbus:	USB detection event registered or unregistered
+ * @da9052_event_chrem_dcin:	Wall charger removal event registered or unregistered
+ * @da9052_event_chrem_vbus:	USB removal event registered or unregistered
+ * @da9052_event_chdet: 	CHGDT event Registered or unregistered
+ */
+typedef struct {
+	u8 	da9052_event_vddlow:1;
+	u8 	da9052_event_tbat:1;
+	u8 	da9052_event_chgend:1;
+	u8 	da9052_event_chdet_dcin:1;
+	u8 	da9052_event_chrem_dcin:1;
+	u8 	da9052_event_chdet_vbus:1;
+	u8 	da9052_event_chrem_vbus:1;
+}da9052_bat_event_regestration;
+
+/**
+ * struct hysteresis -
+ *			Struct to hysteresis data
+ *
+ * @upper_limit: 	Hysteresis Window upper limit
+ * @lower_limit: 	Hysteresis Window lower limit
+ * @index: 		Hysteresis check count
+ */
+typedef struct {
+	u16		upper_limit;
+	u16 		lower_limit;
+	u8 		index;
+} da9052_bat_hysteresis;
+
+/**
+ * struct da9052_bat_status -
+ *			Struct to hold battery status
+ *
+ * @cal_capacity: 	battery Level status
+ * @charging_mode: 	Battery Charging mode like linear charging, Deep charging
+ * @charger_type: 	Connected Charger type
+ * @status: 		Battery staus like battery is chargign/discharging
+ * @illegalbattery:	Illegal battery detection status
+ */
+typedef struct {
+	u8		cal_capacity;
+	u8 		charging_mode;
+	u8 		charger_type;
+	u8 		health;
+	u8 		status;
+	u8 		illegalbattery;
+}da9052_bat_status;
+
+/**
+ * struct MONITORING_STATE -
+ *			Struct to hold monitoring status
+ *
+ * @vddout_value: 	Charger output voltage value
+ * @bat_temp_value: 	Battery temperature value
+ * @current_value: 	Charging Current value
+ * @junc_temp_value: 	Junction temperature  value
+ * @bat_level: 		Battery level value
+ * @vddout_status: 	Charger output voltage Monitoring status
+ * @bat_temp_status: 	battery temperature Monitoring status
+ * @junc_temp_status: 	Junction temperature Monitoring status
+ * @current_status: 	Charging current Monitoring status
+ * @bat_level_status: 	battery level Monitoring status
+ */
+typedef struct {
+	u16		vddout_value;
+	u16		bat_temp_value;
+	u16		current_value;
+	u16		junc_temp_value;
+	u8		bat_level;
+	u8		vddout_status:1;
+	u8		bat_temp_status:1;
+	u8		junc_temp_status:1;
+	u8		current_status:1;
+	u8		bat_level_status:1;
+}monitoring_state;
+
+/**
+ * struct da9052_bat_device -
+ *			Struct to hold battery device info
+ *
+ * @manufacture: 		Battery manufacturer
+ * @chg_current_raw: 		Charger current raw value buffer
+ * @chg_current: 		Measured Charger current in uA
+ * @chg_junc_temp: 		Measured Charger junction temperature in C
+ * @bat_voltage: 		Measured battery voltage in mV
+ * @backup_bat_voltage:		Measure backup battery voltage in mV
+ * @bat_temp:			Measured battery temperature
+ * @vddout: 			Measure charger output voltage in mV
+ */
+typedef struct {
+	char 		manufacture[32];
+	u16		chg_current_raw[NUMBER_OF_STORE_CURENT_READING];
+	u16		chg_current;
+	u16		chg_junc_temp;
+	u16		bat_voltage;
+	u16		backup_bat_voltage;
+	u16		bat_temp;
+	u16		vddout;
+}da9052_bat_device;
+
+
+/**
+ * struct threshold_res -
+ *			Struct to hold threshold value
+ *
+ * @vddout_mon:		VDDOUT Threshold voltage limit
+ * @ichg_thr:		charging current threshold limit
+ * @tbat_thr_min:	battery temperature minimum threshold limit
+ * @tbat_thr_max:	battery temperature maximum threshold limit
+ * @tbat_thr_highns:	battery high temperature resume charging limit
+ * @tbat_thr_limit:	software control battery temperature threshold limit
+ * @tjunc_thr_limit:	software control junction temperature threshold limit
+ * @ichg_av_thr_min:	ICHG_AV minimum threshold limit
+ * @ichg_av_thr_max: 	ICHG_AV maximum threshold limit
+ */
+typedef struct {
+	u16 		vddout_mon;
+	u16 		ichg_thr;
+	u16 		tbat_thr_min;
+	u16 		tbat_thr_max;
+	u16 		tbat_thr_highns;
+	u16		tbat_thr_limit;
+	u16		tjunc_thr_limit;
+	u16		ichg_av_thr_min;
+	u16		ichg_av_thr_max;
+} da9052_bat_threshold;
+
+/**
+ * struct da9052_charger_device -
+ *			Struct to hold entire charger configuration
+ *
+ * @threshold:			Threshold structure instance
+ * @bat_info:			da9052_bat_device instance
+ * @charger_type:		type of charger connected
+ * @monitoring_interval:	Monitoring interval in msec
+ * @charger_voltage_drop:	charger voltage drop in  mV
+ * @bat_target_voltage:		target battery voltage in mV
+ * @voltage_threshold:		battery voltage threshold in mV
+ * @dcin_current: 		Wall charger default current limit in mA
+ * @vbus_current: 		USB Host default current limit in mA
+ * @usb_charger_current: 	USB Charger current limit in mA
+ * @chg_end_current: 		charger end current in mA
+ * @precharging_current: 	Precharging current in mA
+ * @charging_time: 		Charging time in minutes
+ * @timer_mode: 		Timer mode (1/0)
+ * @chager_buck_lp: 		Enable Charger buck Power down mode (1/0)
+ * @usb_charger_det: 		Enable Auto USB detection (1/0)
+ * @ichg_low_cntr:	 	Enable charger low current mode (1/0)
+ * @sw_temp_cntr: 		Enable Software temperature control (1/0)
+ * @auto_temp_cntr: 		Enable Auto Hardware temperature control (1/0)
+ * @montoring_func_reg: 	Monitoring function registeration status
+ */
+typedef struct {
+	da9052_bat_threshold threshold;
+	u16			monitoring_interval;
+	u16			charger_voltage_drop;
+	u16			bat_target_voltage;
+	u16			voltage_threshold;
+	u16			dcin_current;
+	u16			vbus_current;
+	u16			usb_charger_current;
+	u16			chg_end_current;
+	u16			precharging_current;
+	u16			charging_time;
+	u8			timer_mode:1;
+	u8			chager_buck_lp:1;
+	u8			usb_charger_det:1;
+	u8			ichg_low_cntr:1;
+	u8			sw_temp_cntr:1;
+	u8			auto_temp_cntr:1;
+}da9052_charger_device;
+
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+
+/*
+ * IOCTL calls that are permitted to the /dev/da9052_pm interface
+*/
+
+/* Measure charger current. This IOCTL is applicable only in charging mode */
+#define DA9052_BAT_IOCTL_GET_CHG_CURRENT		0
+
+/* Measure charger junction temperature. This IOCTL is applicable only in 
+   charging mode */
+#define DA9052_BAT_IOCTL_GET_CHG_JUNC_TEMPERATURE	1
+
+/* Measure battery voltage */
+#define DA9052_BAT_IOCTL_GET_BAT_VOLTAGE		2
+
+/* Measure backup battery voltage */
+#define DA9052_BAT_IOCTL_GET_BACKUP_BAT_VOLTAGE		3
+
+/* Measure battery temperature */
+#define DA9052_BAT_IOCTL_GET_BAT_TEMPERATURE		4
+
+/* Measure charger output voltage.This IOCTL is applicable only in 
+   charging mode  */
+#define DA9052_BAT_IOCTL_GET_CHG_VDDOUT			5
+
+/* Measure remaining charging time */
+#define DA9052_BAT_IOCTL_REMAINING_CHARGING_TIME	6
+
+/* Configure battery charger */
+#define DA9052_BAT_IOCTL_CONFIGURE_CHARGER		7
+
+/* Configure battery charger threshold */
+#define DA9052_BAT_IOCTL_CONFIGURE_THRESHOLDS		8
+
+/**
+ * Set the Power Negotiated current Limit Value
+ * Should be used when, user negotiation is done and battery need to be charge 
+ * with new current limit
+ * This IOCTL is applicable only in charging mode
+ */
+#define DA9052_BAT_IOCTL_SET_USB_POWER_NEGOTIATED_VALUE	9
+
+/* Get complete battery status */
+#define DA9052_BAT_IOCTL_GET_BAT_STATUS			10
+
+/* Suspend charging of the battery */
+#define DA9052_BAT_IOCTL_SUSPEND_CHARGING		11
+
+/* Resume charging for the battery */
+#define DA9052_BAT_IOCTL_RESUME_CHARGING		12
+
+/* Get active event list */
+#define DA9052_BAT_IOCTL_GET_EVENT			13
+
+/* Register battery event */
+#define DA9052_BAT_IOCTL_UNREGISTER_EVENT		14
+
+/* Unregister battery event */
+#define DA9052_BAT_IOCTL_REGISTER_EVENT			15
+
+/* Get the monitoring status structure */
+#define DA9052_BAT_IOCTL_GET_MONITORING_STATUS		16
+
+/*--------------------------------------------------------------------------*/
+/* Inline Functions                                                         */
+/*--------------------------------------------------------------------------*/
+
+/**
+ * bat_temp_reg_to_C:	Convert battery temperature to degree Celicus
+ *			Since the Battery temperature sensor is external to 
+ *			DA9052 the formula to covert the register value to 
+ *			Degree Celicus need to be update by system intregrator
+ *			
+ *			Note: NTC register should be connected to TBAT pin(here
+ *			50uA current source is connected) and GND pin. Value read
+ *			from DA9052 is equivalent to voltage drop across the NTC 
+ *			resistor. 
+ *			
+ *			Below formula is for locally available NTC Resistor which
+ *			has temperture range from 0-50 C
+ *
+ * @param u16 value:	Temperature value read from DA9052.
+ * @return u8:		Converted temperature value in terms of Degree Celicus
+ */
+static inline  u8 bat_temp_reg_to_C(u16 value) { return (55 - value); }
+
+
+/**
+ * bat_mV_to_reg:	Convert battery voltage  to reg value
+ *
+ * @param u16 value:	voltage value.
+ * @return u8:		voltage bit field value
+ */
+static inline  u8 bat_mV_to_reg(u16 value) { return (((value-4100)/100)<<4); }
+
+/**
+ * bat_drop_mV_to_reg:	Convert battery voltage drop to reg value
+ *
+ * @param u16 value:	voltage value.
+ * @return u8:		voltage bit field value
+ */
+static inline  u8 bat_drop_mV_to_reg(u16 value) {
+					return (((value-100)/100)<<6); }
+
+/**
+ * bat_reg_to_mV:	Convert battery voltage register value to mV value
+ *
+ * @param u8 value:	voltage bit field value.
+ * @return u16:		voltage value in mV
+ */
+static inline  u16 bat_reg_to_mV(u8 value) { return ((value *100) + 4100); }
+
+/**
+ * bat_drop_reg_to_mV:	Convert battery voltage drop register value to mV value
+ *
+ * @param u8 value:	voltage bit field value.
+ * @return u16:		voltage drop value in mV
+ */
+static inline  u16 bat_drop_reg_to_mV(u8 value) { return ((value*100)+100); }
+
+/**
+ * vch_thr_mV_to_reg:	Convert battery voltage threshold to reg value
+ *
+ * @param u16 value:	voltage value.
+ * @return u8:		voltage bit field value
+ */
+static inline  u8 vch_thr_mV_to_reg(u16 value) { return ((value-3700)/100); }
+
+/**
+ * precharge_mA_to_reg:	Convert precharging current  to reg value
+ *
+ * @param u16 value:	voltage value.
+ * @return u8:		voltage bit field value
+ */
+static inline  u8 precharge_mA_to_reg(u8 value) { return ((value/20)<<6); }
+
+/**
+ * vddout_mon_mV_to_reg:	Convert Charger voltage threshold to reg value
+ *
+ * @param u16 value:	voltage value.
+ * @return u8:		voltage bit field value
+ */
+static inline  u8 vddout_mon_mV_to_reg(u16 value) {
+					return ((((value-2500) *128)/1000)); }
+
+/**
+ * vddout_reg_to_mV:	Convert Charger voltage to reg value
+ *
+ * @param u16 value:	voltage value.
+ * @return u8:		voltage bit field value
+ */
+static inline  u16 vddout_reg_to_mV(u8 value) {
+					return (((value * 1000)/128)+2500); }
+
+/**
+ * volt_reg_to_mV:	Convert measured voltage to mV
+ *
+ * @param u16 value:	voltage value.
+ * @return u8:		voltage bit field value
+ */
+static inline  u16 volt_reg_to_mV(u16 value) {
+					return (((value * 1000)/512)+2500); }
+
+/**
+ * ichg_mA_to_reg:	Convert measured charger current to mA
+ *
+ * @param u16 value:	voltage value.
+ * @return u8:		voltage bit field value
+ */
+static inline  u8 ichg_mA_to_reg(u16 value) { return (value/4); }
+
+/**
+ * ichg_reg_to_mA:	Convert charger current reg value to mA
+ *
+ * @param u16 value:	voltage value.
+ * @return u8:		voltage bit field value
+ */
+static inline  u16 ichg_reg_to_mA(u8 value) { return ((value * 3900)/1000); }
+
+/**
+ * iset_mA_to_reg:	Convert cahrger current limit to ISET_BUCK value
+ *
+ * @param u16 value:	voltage value.
+ * @return u8:		voltage bit field value
+ */
+static inline u8 iset_mA_to_reg(u16 iset_value) { \
+			if((70 <=iset_value) && (iset_value <=120)) \
+				return ((iset_value -70)/10); \
+			else if((400 <=iset_value) && (iset_value <=700)) \
+				return(((iset_value -400)/50)+6); \
+			else if((900 <=iset_value) && (iset_value <=1300)) \
+				return(((iset_value -900)/200)+13); \
+			else return(0);}
+
+/*--------------------------------------------------------------------------*/
+/* External Functions                                                       */
+/*--------------------------------------------------------------------------*/
+
+/* Measurement function from ADC Driver */
+extern s32 da9052_adc_read_vbbat(u16*);
+extern s32 da9052_adc_read_tjunc(u16*);
+extern s32 da9052_adc_read_vbat(u16*);
+extern s32 da9052_adc_read_tbat(u16*);
+extern s32 da9052_adc_read_vddout(u16*);
+extern s32 da9052_adc_read_ich(u16*);
+
+/*--------------------------------------------------------------------------*/
+/* Other Functions                                                          */
+/*--------------------------------------------------------------------------*/
+
+s32 da9052_bat_get_chg_current(u16 *);
+s32 da9052_bat_get_chg_junc_temperature(u16 *);
+s32 da9052_bat_get_battery_voltage(u16 *);
+s32 da9052_bat_get_backup_battery_voltage(u16 *);
+s32 da9052_bat_get_battery_temperature(u16 *);
+s32 da9052_bat_get_charger_vddout(u16 *);
+s32 da9052_bat_get_remaining_charging_time(u16 *);
+s32 da9052_get_bat_status(da9052_bat_status *);
+s32 da9052_bat_suspend_charging(void);
+s32 da9052_bat_resume_charging(void);
+s32 da9052_bat_configure_charger(da9052_charger_device);
+s32 da9052_bat_configure_thresholds(da9052_bat_threshold);
+
+#endif /* _DA9052_BAT_H */
+

Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
