Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab0ESKBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 06:01:13 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:24148 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab0ESKBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 06:01:11 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] WATCHDOG of DA9052 Linux device drivers (7/9)
Date: Wed, 19 May 2010 11:01:05 +0100
Message-ID: <3495EC08FA53E94AAA00CC4743D5BA7E010C20F8@pandora.diasemi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] WATCHDOG of DA9052 Linux device drivers (7/9)
Thread-Index: Acr3OjJrL27IIF6GT4u1E2H0CnufiA==
From: "David Dajun Chen" <Dajun.Chen@diasemi.com>
To: <linux-kernel@vger.kernel.org>
Cc: <wim@iguana.be>
X-OriginalArrivalTime: 19 May 2010 10:01:08.0135 (UTC) FILETIME=[33B82370:01CAF73A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear sir/madam,

The attached is the WATCHDOG part of the device drivers newly developed for DA9052 Power Management IC from Dialog Semiconductor.

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
===========================================================================

diff -Naur linux-2.6.33.2_bk/drivers/mfd/Kconfig linux-2.6.33.2_patch/drivers/mfd/Kconfig
--- linux-2.6.33.2_bk/drivers/mfd/Kconfig	2010-05-18 17:54:30.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/mfd/Kconfig	2010-05-18 18:25:12.000000000 +0500
@@ -377,6 +377,12 @@
 	help
 	  Say Y  to enable the ADC driver for the DA9052 chip
 
+config DA9052_SM_ENABLE
+	bool "Dialog Semiconductor DA9052 SM Driver"
+	depends on MFD_DA9052
+	help
+	  Say Y  to enable the Watch-dog driver for the DA9052 chip
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff -Naur linux-2.6.33.2_bk/drivers/watchdog/da9052_sm.c linux-2.6.33.2_patch/drivers/watchdog/da9052_sm.c
--- linux-2.6.33.2_bk/drivers/watchdog/da9052_sm.c	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/watchdog/da9052_sm.c	2010-05-18 18:25:12.000000000 +0500
@@ -0,0 +1,858 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_sm.c: System Monitor driver Source file for DA9052
+ *
+ *  (05/08/2009):	Initial version
+ *
+ * (27/04/2010): 	Created initial draft for Linux community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+/*--------------------------------------------------------------------------*/
+/* System wide include files                                                */
+/*--------------------------------------------------------------------------*/
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <asm/uaccess.h>
+#include <linux/jiffies.h>
+#include <linux/platform_device.h>
+#include <linux/time.h>
+#include <linux/watchdog.h>
+
+#ifndef CONFIG_ARCH_S3C64XX
+#include <linux/workqueue.h>
+#endif
+
+/*--------------------------------------------------------------------------*/
+/* Module specific include files                                            */
+/*--------------------------------------------------------------------------*/
+#include <linux/mfd/da9052/da9052_reg.h>
+#include <linux/mfd/da9052/da9052_lib.h>
+#include <linux/mfd/da9052/da9052_sm.h>
+
+/*--------------------------------------------------------------------------*/
+/* Local Type Definitions                                                   */
+/*--------------------------------------------------------------------------*/
+
+/*--------------------------------------------------------------------------*/
+/* Local Constant Definitions                                               */
+/*--------------------------------------------------------------------------*/
+static u8 banner[] __initdata = "DA9052 SM Driver, v1.0\n";
+
+/*--------------------------------------------------------------------------*/
+/* Local Macro Definitions                                                  */
+/*--------------------------------------------------------------------------*/
+#define	DA9052_STROBING_FILTER_ENABLE		0x0001	/* Enable strobing filter */
+#define	DA9052_STROBING_FILTER_DISABLE		0x0002	/* Disable strobing filter */
+#define	DA9052_SET_STROBING_MODE_MANUAL		0x0004	/* Set strobing mode to manual */
+#define	DA9052_SET_STROBING_MODE_AUTO		0x0008	/* Set strobing mode to auto */
+
+#define KERNEL_MODULE 			0
+
+/*--------------------------------------------------------------------------*/
+/* Local Structure Definitions                                              */
+/*--------------------------------------------------------------------------*/
+ 
+/*--------------------------------------------------------------------------*/
+/* Local function Defination                                                */
+/*--------------------------------------------------------------------------*/
+
+void start_strobing(struct work_struct *work);
+/*--------------------------------------------------------------------------*/
+/* Global Variables                                                         */
+/*--------------------------------------------------------------------------*/
+/* Variable used to store device open status */
+static u8 da0952_sm_device_open = FALSE;
+static s32 da9052_sm_major_number;
+static struct platform_device *da9052_sm_platform_device;
+static struct timer_list *monitoring_timer;
+/* Variable to store the time value, for timer used for strobe filter */
+static u32 da9052_sm_mon_interval = ADC_TWDMIN_TIME;
+
+static u8 da9052_sm_strobe_filter_flag = DISABLE;
+static u8 da9052_sm_strobe_mode_flag = STROBE_MANUAL;
+/* Strobe request flag */
+static u8 da9052_sm_str_req = DISABLE;
+/* Watchdog timer scaling */
+static u8 da9052_wdt_scale = WDT_DISABLE;
+
+module_param(da9052_sm_strobe_filter_flag,  byte, 0);
+MODULE_PARM_DESC(da9052_sm_strobe_filter_flag, 
+                "DA9052 SM driver strobe filter flag default = DISABLE");
+				
+module_param(da9052_sm_strobe_mode_flag, byte, 0);
+MODULE_PARM_DESC(da9052_sm_strobe_filter_flag, 
+                "DA9052 SM driver watchdog strobing mode default = STROBE_MANUAL");
+				
+module_param(da9052_wdt_scale, byte, 0);
+MODULE_PARM_DESC(da9052_wdt_scale, 
+                "DA9052 SM driver scaling value used to calculate the time for the strobing  filter default = 0");
+				
+module_param(da9052_sm_str_req, byte, 0);
+MODULE_PARM_DESC(da9052_sm_str_req, 
+                "DA9052 SM driver strobe request flag default = DISABLE");
+
+/* Create a handler for the scheduling start_strobing function */
+DECLARE_WORK(strobing_action,start_strobing);
+/*--------------------------------------------------------------------------*/
+/* Local Functions                                                          */
+/*--------------------------------------------------------------------------*/
+/**
+ * timer_callback: This function is called when the timer expires
+ * 
+ * @param void
+ * @return void
+ */
+void timer_callback(void)
+{
+	if (((da9052_sm_str_req) && 
+	     (da9052_sm_strobe_mode_flag == STROBE_MANUAL)) || 
+	       (da9052_sm_strobe_mode_flag == STROBE_AUTO)) {
+		schedule_work(&strobing_action);
+	} else {
+		if (da9052_sm_strobe_mode_flag == STROBE_MANUAL){
+			mod_timer(monitoring_timer,jiffies + 
+							da9052_sm_mon_interval);
+		}
+	}
+}
+
+/*
+ * start_strobing: Function that strobes the system monitor in DA9052. This 
+ *		   function is called by work queue (which in turn is scheduled 
+ *		   after timer expiry).
+ * 
+ * @param struct work_struct *work
+ * @return void
+ */
+void start_strobing(struct work_struct *work)
+{
+	da9052_ssc_msg msg;
+
+	/* Send Strobing command */
+	msg.addr = DA9052_CONTROLD_REG;
+	/* Read the previous contents in the register */
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return;
+
+	/* Set "WATCHDOG" bit */
+	msg.data = set_bits(msg.data,DA9052_CONTROLD_WATCHDOG);
+	/* Write the data */
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return;
+	DA9052_DEBUG("%s : Strobe...\n",__FUNCTION__);
+	/* Clear the strobe req flag */
+	da9052_sm_str_req = DISABLE;
+
+	/* Start timer */
+	mod_timer(monitoring_timer,jiffies + da9052_sm_mon_interval);
+/* When this macro is enabled FAULTLOG register will be read and printed (for 
+   debuging purpose) */
+#if (DA9052_SM_DEBUG)
+	msg.addr = DA9052_FAULTLOG_REG;
+	/* Read the contents in the register */
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return;
+	DA9052_DEBUG("%s: FAULT_LOG (0) = 0x%X\n",__FUNCTION__,msg.data);
+	DA9052_DEBUG("time : %d \n",jiffies_to_msecs(jiffies));
+	
+#endif
+	return;
+}
+
+/**
+ * da9052_sm_hw_init: This function initializes the hardware.
+ * 
+ * @param void
+ * @return s32 error code
+ */
+static s32 da9052_sm_hw_init(void)
+{
+#if (DA9052_SM_DEBUG)
+	da9052_ssc_msg msg;
+	u8 result;
+#endif
+
+	/* Create timer structure */
+	monitoring_timer = (struct timer_list *) kmalloc(
+				sizeof(struct timer_list),GFP_KERNEL);
+	if(!monitoring_timer) {
+		DA9052_DEBUG("%s : failed\n",__FUNCTION__);
+		return (-ENOMEM);
+	}
+
+	/* Timer for strobe filtering */
+	init_timer(monitoring_timer);
+	monitoring_timer->expires = jiffies + da9052_sm_mon_interval;
+	monitoring_timer->function = (void*)&timer_callback;
+
+	/* Clear the strobe flag */
+	da9052_sm_strobe_filter_flag = DA9052_SM_STROBE_CONF;
+	da9052_sm_strobe_mode_flag = STROBE_MANUAL;
+/* When this macro is enabled TWDERROR bit in FAULTLOG register will be cleared 
+  at the time of initialization for testing puropse only */
+#if (DA9052_SM_DEBUG)
+	msg.addr = DA9052_FAULTLOG_REG;
+	/* Read the previous contents in the register */
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return(BUS_ERR);
+
+	/* Check the Watchdog violation bit */
+	DA9052_DEBUG("%s: Clear the fault log\n",__FUNCTION__);
+	result = msg.data;
+	if (result &= DA9052_FAULTLOG_TWDERROR) {
+		/* If TWDERROR bit is set clear it */
+		msg.data = set_bits(msg.data,DA9052_FAULTLOG_TWDERROR);
+		if (SUCCESS != da9052_ssc_write(&msg))
+			return(BUS_ERR);
+	}
+#endif
+	return (SUCCESS);
+}
+
+/**
+ * da9052_sm_hw_deinit: 
+ * 
+ * @param void
+ * @return s32 Error code
+ */
+static s32 da9052_sm_hw_deinit(void)
+{
+	da9052_ssc_msg msg;
+
+	/* stop and delete monitoring timer */
+	if(monitoring_timer != NULL) {
+		del_timer(monitoring_timer);
+	}
+	kfree(monitoring_timer);
+
+	/* Turn off the watchdog timer on initialization */
+	msg.addr = DA9052_CONTROLD_REG;
+	/* Read the previous contents in the register */
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (BUS_ERR);
+
+	/* Mask the TWDSCALE bits to '000' to disable WDT */
+	msg.data = clear_bits(msg.data,DA9052_CONTROLD_TWDSCALE);
+	/* Write the data */
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return (BUS_ERR);
+
+	return (SUCCESS);
+}
+
+
+/*--------------------------------------------------------------------------*/
+/* Global Functions                                                         */
+/*--------------------------------------------------------------------------*/
+/**
+ * d9052_sm_strobe_wdt : This function is used to initiate strobe request to 
+ *                       DA9052. This function only sets a strobe request flag,
+ *			 which is later checked on expiry ot the timer used for 
+ * 			 strobing filter.
+ * 
+ * @param void
+ * @return s32   Error Code, zero: SUCCESS
+ */
+ s32 d9052_sm_strobe_wdt(void)
+ {
+#if (DA9052_SM_DEBUG)
+	da9052_ssc_msg msg;
+#endif
+	/* Set strobing flag */
+	da9052_sm_str_req = ENABLE;
+
+/* When this macro is enabled FAULTLOG register will be read and printed (for 
+   debuging purpose) */
+#if (DA9052_SM_DEBUG)
+	msg.addr = DA9052_FAULTLOG_REG;
+	/* Read the contents in the register */
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return(BUS_ERR);
+	DA9052_DEBUG("%s :FAULT_LOG (1) = 0x%X\n",__FUNCTION__, msg.data);
+	DA9052_DEBUG("time : %d \n",jiffies_to_msecs(jiffies));
+#endif
+	return (SUCCESS);
+ }
+ 
+ /**
+ * da9052_sm_set_wdt : This function enable/disable the watchdog timer. This 
+ *		    function also sets the watchdog timer period. 
+ * 
+ * @param u8 wdt_scaling - Watchdog timer scaling.
+ * @return s32   Error Code, zero: SUCCESS
+ */
+ s32 da9052_sm_set_wdt(u8 wdt_scaling)
+ {
+	da9052_ssc_msg msg;
+
+	/* Check the validity of the wdt_scaling parameter */
+	if (wdt_scaling > SCALE_64X)
+		return (INVALID_SCALING_VALUE);
+
+	msg.addr = DA9052_CONTROLD_REG;
+	/* Read the previous contents in the register */
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (BUS_ERR);
+	/* For condition other then WDT disabled earlier and current command 
+	   is to disable WDT */
+	if (!((WDT_DISABLE == (msg.data & DA9052_CONTROLD_TWDSCALE)) &&
+	    (WDT_DISABLE == wdt_scaling))) {
+		/* Disable the Watchdog timer for 150us before changing the 
+		   scaling value */
+		/* Mask the TWDSCALE bits to '000' to disable */
+		msg.data = clear_bits(msg.data,DA9052_CONTROLD_TWDSCALE);
+		/* Write the data */
+		msg.addr = DA9052_CONTROLD_REG;
+		if (SUCCESS != da9052_ssc_write(&msg))
+			return (BUS_ERR);
+
+		/* Wait for some time (required by hardware 150us disable) */
+		msleep (1);
+		/* Read the previous contents in the register */
+		if (SUCCESS != da9052_ssc_read(&msg))
+			return (BUS_ERR);
+		/* Copy the TWDSCALE data */
+		msg.data |= wdt_scaling;
+		/* Write the data */
+		if (SUCCESS != da9052_ssc_write(&msg))
+			return (BUS_ERR);
+
+		/* Clear the strobing request flag, if already request is 
+		   pending */
+		da9052_sm_str_req = DISABLE;
+		/* If disable wdt req disable the timer used for filter */
+		if (WDT_DISABLE == wdt_scaling) {
+			del_timer(monitoring_timer);
+			return (SUCCESS);
+		}
+		/* Set the strobing filter timer's time */
+		if (da9052_sm_strobe_filter_flag == ENABLE){
+			if (SCALE_64X == wdt_scaling) {
+				da9052_sm_mon_interval = 
+						msecs_to_jiffies(X64_WINDOW);
+			} else if (SCALE_32X == wdt_scaling) {
+				da9052_sm_mon_interval = 
+						msecs_to_jiffies(X32_WINDOW);
+			} else if (SCALE_16X == wdt_scaling) {
+				da9052_sm_mon_interval = 
+						msecs_to_jiffies(X16_WINDOW);
+			} else if (SCALE_8X == wdt_scaling) {
+				da9052_sm_mon_interval = 
+						msecs_to_jiffies(X8_WINDOW);
+			} else if (SCALE_4X == wdt_scaling) {
+				da9052_sm_mon_interval = 
+						msecs_to_jiffies(X4_WINDOW);
+			} else if (SCALE_2X == wdt_scaling) {
+				da9052_sm_mon_interval = 
+						msecs_to_jiffies(X2_WINDOW);
+			} else {
+				da9052_sm_mon_interval = 
+						msecs_to_jiffies(X1_WINDOW);
+			}
+		} else {
+			/* If filtering is disabled, follow 256ms Tmin time for 
+			   WDT */
+			da9052_sm_mon_interval = msecs_to_jiffies(
+							ADC_TWDMIN_TIME);
+		}
+		/* Start timer (modify), requierd for window filtering */
+		mod_timer(monitoring_timer,jiffies + da9052_sm_mon_interval);
+	}
+	
+	return (SUCCESS);
+ }
+
+ /**
+ * da9052_sm_set_strobing_filter : This function enable/disable the watchdog 
+ *	timer strobing filter. Whenever the strobe filter functionality is 
+ *	altered the timer used for filtering is restarted. So it is recommended 
+ *	that user first configures the strobing filter and then start the 
+ *	watchdog timer. If watchdog timer is started first and then strobing 
+ *	filter is enabled/disabled, strobing is not guarantied because of delay 
+ *	in restarting of timer.
+ * 
+ * @param u8 strobing_filter_state - strobing filter enable/disable state.
+ * @return s32   Error Code, zero: SUCCESS
+ */
+ s32 da9052_sm_set_strobing_filter(u8 strobing_filter_state)
+ {
+	da9052_ssc_msg msg;
+		
+	/* Read CONTROLD register contents first */
+	msg.addr = DA9052_CONTROLD_REG;
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (BUS_ERR);
+	/* Clear bits other then TWD_SCALE, for reading the WDT 
+	setting */
+	msg.data = msg.data & DA9052_CONTROLD_TWDSCALE;
+
+	if (strobing_filter_state == ENABLE) {
+		/* Enable filter flag */
+		da9052_sm_strobe_filter_flag = ENABLE;
+		/* Change the strobing time */
+		/* If WDT is disabled */
+		if (WDT_DISABLE == msg.data) {
+			/* Clear the strobing flag if watchdog is disabled */
+			da9052_sm_str_req = DISABLE;
+			/* Stop timer */
+			del_timer(monitoring_timer);
+			return (SUCCESS);
+		}
+		/* If WDT value other then 0 */
+		if (SCALE_64X == msg.data) {
+			da9052_sm_mon_interval = msecs_to_jiffies(X64_WINDOW);
+		} else if (SCALE_32X == msg.data) {
+			da9052_sm_mon_interval = msecs_to_jiffies(X32_WINDOW);
+		} else if (SCALE_16X == msg.data) {
+			da9052_sm_mon_interval = msecs_to_jiffies(X16_WINDOW);
+		} else if (SCALE_8X == msg.data) {
+			da9052_sm_mon_interval = msecs_to_jiffies(X8_WINDOW);
+		} else if (SCALE_4X == msg.data) {
+			da9052_sm_mon_interval = msecs_to_jiffies(X4_WINDOW);
+		} else if (SCALE_2X == msg.data) {
+			da9052_sm_mon_interval = msecs_to_jiffies(X2_WINDOW);
+		} else {
+			da9052_sm_mon_interval = msecs_to_jiffies(X1_WINDOW);
+		}
+	} else if (strobing_filter_state == DISABLE) {
+		/* Disable filter flag */
+		da9052_sm_strobe_filter_flag = DISABLE;
+		/* If filtering is disabled, follow 256ms Tmin time for WDT */
+		da9052_sm_mon_interval = msecs_to_jiffies(ADC_TWDMIN_TIME);
+		/* If WDT is disabled */
+		if (WDT_DISABLE == msg.data) {
+			/* Clear the strobing flag if watchdog is disabled */
+			da9052_sm_str_req = DISABLE;
+			/* Stop timer */
+			del_timer(monitoring_timer);
+			return (SUCCESS);
+		}
+	} else {
+		return (STROBING_FILTER_ERROR);
+	}
+	/* Modify the timer after changing the time value */
+	mod_timer(monitoring_timer,jiffies + da9052_sm_mon_interval);
+
+	return (SUCCESS);
+ }
+
+  /**
+ * da9052_sm_set_strobing_mode : This function selects the watchdog strobing 
+ *				  mode. The default mode is initialized to 
+ *				  MANUAL mode in da9052_sm_hw_init().
+ * 
+ * @param u8 strobing_mode_state - strobing state AUTO/MANUAL.
+ * @return s32   Error Code, zero: SUCCESS
+ */
+ s32 da9052_sm_set_strobing_mode(u8 strobing_mode_state)
+ {
+	s32 error = SUCCESS;
+
+	if (strobing_mode_state == STROBE_AUTO) {
+		/* Enable filter flag */
+		da9052_sm_strobe_mode_flag = STROBE_AUTO;
+	} else if (strobing_mode_state == STROBE_MANUAL) {
+		/* Disable filter flag */
+		da9052_sm_strobe_mode_flag = STROBE_MANUAL;
+	} else {
+		error = STROBING_MODE_ERROR;
+	}
+
+	return (error);
+ }
+
+/*--------------------------------------------------------------------------*/
+/* Infrastructure Functions                                                 */
+/*--------------------------------------------------------------------------*/
+/**
+ * da9052_sm_open: 
+ * 
+ * @param *inode pointer to device inode
+ * @param *file  file pointer
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_sm_open(struct inode *inode, struct file *file)
+{
+	/* Check if device is already open */
+	if(da0952_sm_device_open) {
+		DA9052_DEBUG("DA9052: SM device already open.\n");
+		return (-EBUSY);
+	} else {
+		da0952_sm_device_open++;
+		return (SUCCESS);
+	}
+}
+
+/**
+ * da9052_sm_release: 
+ * 
+ * @param *inode pointer to device inode
+ * @param *file  file pointer
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_sm_release(struct inode *inode, struct file *file)
+{
+	da0952_sm_device_open--;
+	DA9052_DEBUG("DA9052: SM device closed.\n");
+	return (SUCCESS);
+}
+
+/**
+ * static struct file_operations da9052_wdt_info  
+ * @identity: DA9052 SM driver
+ * @options : Functionalities supported by the driver
+ *
+ */
+static struct watchdog_info da9052_wdt_info = {
+	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity =		"DA9052_SM Watchdog",
+};
+
+/**
+ * da9052_wdt_ioctl: 
+ * 
+ * @param *file   file pointer
+ * @param cmd   command to be executed
+ * @param arg   argument to command
+ * @return int   Error Code, zero: no error
+ */
+static long da9052_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	u8 new_value;
+		
+	switch (cmd) {
+
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &da9052_wdt_info,
+							sizeof(da9052_wdt_info)) ? -EFAULT : 0;
+		
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_value, p))
+			return -EFAULT;
+		printk(KERN_CRIT "Value passed to the SETOPTIONS of DA9052 SM is %d: \n", new_value);
+		if (new_value & DA9052_STROBING_FILTER_ENABLE)
+			da9052_sm_set_strobing_filter(ENABLE);
+		if (new_value & DA9052_STROBING_FILTER_DISABLE)
+			da9052_sm_set_strobing_filter(DISABLE);
+		if (new_value & DA9052_SET_STROBING_MODE_MANUAL)
+			da9052_sm_set_strobing_mode(STROBE_MANUAL);
+		if (new_value & DA9052_SET_STROBING_MODE_AUTO)
+			da9052_sm_set_strobing_mode(STROBE_AUTO);
+		return 0;
+
+	case WDIOC_KEEPALIVE:
+		if (d9052_sm_strobe_wdt())
+			return -EFAULT;
+		else
+			return 0;
+			
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_value, p))
+			return -EFAULT;
+		da9052_wdt_scale = new_value;
+		printk(KERN_CRIT "Scale factor passed to the DA9052 SM is %d: \n", da9052_wdt_scale);
+		if (da9052_sm_set_wdt(da9052_wdt_scale))
+			return -EFAULT;
+		/* Return current value */
+		return put_user(da9052_sm_mon_interval, p);
+		
+	case WDIOC_GETTIMEOUT:
+		return put_user(da9052_sm_mon_interval, p);
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+/**
+ * da9052_sm_ioctl: 
+ * 
+ * @param *inode   pointer to device inode
+ * @param *file   file pointer
+ * @param cmd   command to be executed
+ * @param arg   argument to command
+ * @return int   Error Code, zero: no error
+ */
+s32 da9052_sm_ioctl(struct inode *inode, struct file *file, 
+					unsigned int cmd, unsigned long arg)
+{
+	s32 error = SUCCESS;
+	da9052_sm_data_t usr_param, *ptr;
+	ptr = (da9052_sm_data_t *) arg;
+	/* Switch according to the command received */
+	switch(cmd) {
+	case DA9052_SM_IOCTL_STROBE_WDT:
+		error = d9052_sm_strobe_wdt();
+		break;
+	case DA9052_SM_IOCTL_SET_WDT:
+		if (copy_from_user(&usr_param, ptr, sizeof(da9052_sm_data_t)))
+			return (FAILURE);
+		error = da9052_sm_set_wdt(usr_param.wdt_scaling);
+		break;
+	case DA9052_SM_IOCTL_SET_STROBING_FILTER:
+		if (copy_from_user(&usr_param, ptr, sizeof(da9052_sm_data_t)))
+			return (FAILURE);
+		error = da9052_sm_set_strobing_filter(
+					     usr_param.strobing_filter_state);
+		break;
+	case DA9052_SM_IOCTL_SET_STROBING_MODE:
+		if (copy_from_user(&usr_param, ptr, sizeof(da9052_sm_data_t)))
+			return (FAILURE);
+		error = da9052_sm_set_strobing_mode(
+					     usr_param.strobing_mode);
+		break;
+	default:
+		DA9052_DEBUG("%s :Invalid ioctl command\n",__FUNCTION__);
+		return (NO_IOCTL_CMD);
+	}
+	return (error);
+}
+
+/**
+ * static struct file_operations da9052_wdt_fops -  
+ * @owner: member description
+ * @llseek : member description
+ * @unlocked_ioctl: IOCTLS supported by DA9052 SM driver. The IOCTL's are defined
+ *					by the Linux kernel watchdog infrastructure
+ * @open: DA90452 SM open
+ * @da9052_sm_release: DA90452 SM release
+ *
+ */
+static const struct file_operations da9052_wdt_fops = {
+        .owner          = THIS_MODULE,
+		.llseek			= no_llseek,
+		.unlocked_ioctl	= da9052_wdt_ioctl,
+        .open           = da9052_sm_open,
+        .release        = da9052_sm_release,
+};
+
+/**
+ * static struct miscdevice da9052wdt_miscdev -  
+ * @minor: Minor name of the DA9052 SM driver
+ * @name : Name of the DA9052 driver in kernel space
+ * @fops: File operations supported by the DA9052 SM driver
+ *
+ */
+static struct miscdevice da9052wdt_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "da9052-SM",
+	.fops		= &da9052_wdt_fops,
+};
+
+/**
+ * static struct file_operations da9052_sm_fops -  
+ * @owner: member description
+ * @open : DA90452 SM open
+ * @release: DA90452 SM release
+ * @ioctl: IOCTLS supported by DA9052 SM driver; as per the DA9052 hardware
+ */
+static const struct file_operations da9052_sm_fops = {
+        .owner          = THIS_MODULE,
+	    .open           = da9052_sm_open,
+        .release        = da9052_sm_release,
+        .ioctl          = da9052_sm_ioctl,
+};
+
+/**
+ * da9052_sm_probe: Called when a device gets attached to driver 
+ * @param *dev   pointer to platform device
+ * @return int   Error Code, zero: no error
+ */
+static s32 __devinit da9052_sm_probe(struct platform_device *dev)
+{
+	s32 ret;
+
+	/* Register the device as a char driver */
+	ret = register_chrdev(da9052_sm_major_number,
+				DA9052_SM_DEVICE_NAME, &da9052_sm_fops);
+	if (ret < 0) {
+		DA9052_DEBUG( "Unable to register %s\n", DA9052_SM_DEVICE_NAME);
+		return (-EFAULT);
+	} else {
+		da9052_sm_major_number = ret;
+
+		printk(KERN_INFO "%s: Major number is: %d \n",
+				DA9052_SM_DEVICE_NAME, da9052_sm_major_number);
+
+		if (da9052_sm_hw_init()) {
+			/* Error in hw initialization */
+			unregister_chrdev(da9052_sm_major_number,   \
+							DA9052_SM_DEVICE_NAME);
+			return (-EFAULT);
+		}
+		else{
+			return (SUCCESS);
+		}
+	}	
+	
+	/* Register the device as a misc driver */
+	ret = misc_register(&da9052wdt_miscdev);
+	if (ret) {
+		DA9052_DEBUG("cannot register miscdev on minor=%d \n", WATCHDOG_MINOR);
+		return (-EFAULT);
+	} else {
+		return (SUCCESS);
+	}
+
+}
+
+/**
+ * da9052_sm_remove: Called when ditaching device from driver
+ * @param void
+ * @return int
+ */
+static int __devexit da9052_sm_remove(struct platform_device *dev)
+{
+	DA9052_DEBUG("Removing %s \n", DA9052_SM_DEVICE_NAME);
+	return (SUCCESS);
+}
+
+#ifdef CONFIG_PM
+/**
+ * da9052_sm_suspend: Power Management support function
+ * 
+ * @param *dev   pointer to platform device
+ * @param state  pm state
+ * @return s32 status of suspend operation
+ */
+static s32 da9052_sm_suspend(struct platform_device *dev, pm_message_t state)
+{
+     /* Put your suspend related operations here */
+     printk(KERN_INFO "%s: called\n", __FUNCTION__);
+     return (0);
+}
+
+/**
+ * da9052_sm_resume: Power Management support function
+ * 
+ * @param *dev   pointer to platform device
+ * @return s32 status of resume operation
+ */
+static s32 da9052_sm_resume(struct platform_device *dev)
+{
+     /* Put your resume related operations here */
+     printk(KERN_INFO "%s: called\n", __FUNCTION__);
+     return (0);
+}
+#else
+#define da9052_sm_suspend NULL
+#define da9052_sm_resume	NULL
+#endif
+
+/**
+ * static struct platform_driver da9052_sm_driver -
+ * This structure definition has to be defined here as an exception.
+ * @probe: Probe function for this device. 
+ * @remove: Function to be called when removing this device from platform
+ * @driver: Contains glue logic to bind platform device and plarform driver
+ */
+static struct platform_driver da9052_sm_driver = {
+	.probe		= da9052_sm_probe,
+	.remove		= __devexit_p(da9052_sm_remove),
+	.suspend	= da9052_sm_suspend,
+	.resume		= da9052_sm_resume,
+	.driver		= {
+		.name	= DA9052_SM_DEVICE_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+/**
+ * da9052_sm_init: Initiales the driver
+ * 
+ * @param void
+ * @return int   Error Code, zero: no error
+ */
+ /* CHECK Platform_Device */
+static s32 __init da9052_sm_init(void)
+{
+	s32 retval;
+	da9052_ssc_msg msg;
+
+	printk("%s",banner);
+
+	da9052_sm_platform_device = platform_device_alloc("da9052_sm", 0);
+	if (!da9052_sm_platform_device)
+		return (-ENOMEM);
+
+	retval = platform_device_add(da9052_sm_platform_device);
+	if (retval < 0) {
+		platform_device_put(da9052_sm_platform_device);
+		return (retval);
+	}
+
+	retval = platform_driver_register(&da9052_sm_driver);
+	if (retval < 0)
+		platform_device_unregister(da9052_sm_platform_device);
+
+	/* Turn off the watchdog timer on initialization */
+	msg.addr = DA9052_CONTROLD_REG;
+	msg.data = 0;
+	/* Read the previous contents in the register */
+	if (SUCCESS != da9052_ssc_read(&msg))
+		return (BUS_ERR);
+
+	/* Mask the TWDSCALE bits to '000' to disable WDT */
+	msg.data = clear_bits(msg.data,DA9052_CONTROLD_TWDSCALE);
+	/* Write the data */
+	if (SUCCESS != da9052_ssc_write(&msg))
+		return (BUS_ERR);
+
+	return (retval);
+}
+/**
+ * da9052_sm_exit: 
+ * 
+ * @param void
+ * @return void
+ */
+static void __exit da9052_sm_exit(void)
+{
+	da9052_sm_hw_deinit();
+	DA9052_DEBUG("DA9052: Unregistering SM device.\n");
+
+	unregister_chrdev(da9052_sm_major_number, DA9052_SM_DEVICE_NAME);
+	
+	misc_deregister(&da9052wdt_miscdev);
+
+	/* Platform_Device */
+	platform_driver_unregister(&da9052_sm_driver);
+	platform_device_unregister(da9052_sm_platform_device);
+}
+
+
+module_init(da9052_sm_init);
+module_exit(da9052_sm_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd");
+MODULE_DESCRIPTION("DA9052 SM Device Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:da9052_sm");
+
+/*--------------------------------------------------------------------------*/
+/* Exports                                                                  */
+/*--------------------------------------------------------------------------*/
+EXPORT_SYMBOL(d9052_sm_strobe_wdt);
+EXPORT_SYMBOL(da9052_sm_set_wdt);
+EXPORT_SYMBOL(da9052_sm_set_strobing_filter);
+EXPORT_SYMBOL(da9052_sm_set_strobing_mode);
diff -Naur linux-2.6.33.2_bk/drivers/watchdog/Makefile linux-2.6.33.2_patch/drivers/watchdog/Makefile
--- linux-2.6.33.2_bk/drivers/watchdog/Makefile	2010-04-02 04:02:33.000000000 +0500
+++ linux-2.6.33.2_patch/drivers/watchdog/Makefile	2010-05-18 18:25:12.000000000 +0500
@@ -143,3 +143,4 @@
 obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
 obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
 obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
+obj-$(CONFIG_DA9052_SM_ENABLE) += da9052_sm.o
diff -Naur linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_sm.h linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_sm.h
--- linux-2.6.33.2_bk/include/linux/mfd/da9052/da9052_sm.h	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.33.2_patch/include/linux/mfd/da9052/da9052_sm.h	2010-05-18 18:25:12.000000000 +0500
@@ -0,0 +1,152 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_sm.h: System Monitor driver Header file for DA9052
+ *
+ * History:
+ *
+ *  (05/08/2009):	Initial version
+ *  (25/06/2009):	Unit tested version
+ *
+ * (27/04/2010):	Updated for Linux Community release
+ *
+ * Best Viewed with TabSize=8 and ColumnWidth=80
+ */
+
+#ifndef _DA9052_SM_H
+#define _DA9052_SM_H
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
+#define DA9052_SM_DEVICE_NAME			"da9052_sm"
+
+/* To enable debug output for your module, set this to 1 */
+#define	DA9052_SM_DEBUG				0
+
+#undef DA9052_DEBUG
+#if DA9052_SM_DEBUG
+#define DA9052_DEBUG( fmt, args... ) printk( KERN_CRIT "" fmt, ##args )
+#else
+#define DA9052_DEBUG( fmt, args... )
+#endif
+
+/* Error codes */
+#define BUS_ERR					2
+#define INIT_FAIL				3
+#define SM_OPEN_FAIL				4
+#define NO_IOCTL_CMD				5
+#define INVALID_SCALING_VALUE			6
+#define STROBING_FILTER_ERROR			7
+#define TIMER_DELETE_ERR			8
+#define STROBING_MODE_ERROR			9
+
+/* IOCTL Switch */
+/* For strobe watchdog function */
+#define DA9052_SM_IOCTL_STROBE_WDT		1
+
+/* For setting watchdog timer time */
+#define DA9052_SM_IOCTL_SET_WDT			2
+
+/* For enabling/disabling strobing filter */
+#define DA9052_SM_IOCTL_SET_STROBING_FILTER	3
+
+/* For enabling/disabling strobing filter */
+#define DA9052_SM_IOCTL_SET_STROBING_MODE	4
+
+/* Watchdog time scaling TWDMAX scaling macros */
+#define WDT_DISABLE				0
+#define SCALE_1X				1
+#define SCALE_2X				2
+#define SCALE_4X				3
+#define SCALE_8X				4
+#define SCALE_16X				5
+#define SCALE_32X				6
+#define SCALE_64X				7
+
+/* Window filter macros */
+#define STROBE_WIN_FILTER_PER			80
+/* Macro for setting for 1x i.e. 2048 ms WDT time */
+#define X1_WINDOW		(( 1 * 2048 * STROBE_WIN_FILTER_PER)/100)
+/* Macro for setting for 2x i.e. 4096 ms WDT time */
+#define X2_WINDOW		(( 2 * 2048 * STROBE_WIN_FILTER_PER)/100)
+/* Macro for setting for 4x i.e. 8192 ms WDT time */
+#define X4_WINDOW		(( 4 * 2048 * STROBE_WIN_FILTER_PER)/100)
+/* Macro for setting for 8x i.e. 16384 ms WDT time */
+#define X8_WINDOW		(( 8 * 2048 * STROBE_WIN_FILTER_PER)/100)
+/* Macro for setting for 16x i.e. 32768 ms WDT time */
+#define X16_WINDOW		((16 * 2048 * STROBE_WIN_FILTER_PER)/100)
+/* Macro for setting for 32x i.e. 65536 ms WDT time */
+#define X32_WINDOW		((32 * 2048 * STROBE_WIN_FILTER_PER)/100)
+/* Macro for setting for 64x i.e. 131072 ms WDT time */
+#define X64_WINDOW		((64 * 2048 * STROBE_WIN_FILTER_PER)/100)
+
+/* Strobing mode */
+#define STROBE_AUTO				1
+#define STROBE_MANUAL				0
+
+/* Macro to statically configure the default state of strobe filter */
+#define DA9052_SM_STROBE_CONF			DISABLE
+
+/* When watchdog filter is disabled, then manual strobing has to be done in 
+   order to reset the DA9052's watchdog timer to 0. DA9052 has a time window 
+   within which strobing should be done. Maximum time period before which 
+   strobing is to be done is variable from 2048 ms to 131072 ms. But the 
+   minimum time period after which a strobe signal has to be applied is 256 ms. 
+   The following macro is used in the code to provide this (TWDMIN) time 
+   period */
+#define ADC_TWDMIN_TIME				500
+
+/*--------------------------------------------------------------------------*/
+/* Structure Definitions                                                    */
+/*--------------------------------------------------------------------------*/
+/**
+ * struct da9052_sm_data_t -  
+ *			Struct for passing watchdog parameters
+ * @wdt_scaling: Watchdog timer scaling
+ * @strobing_filter_state: Strobing filter enable/disable state
+ *
+ */
+ typedef struct {
+	u8 wdt_scaling;
+	u8 strobing_filter_state;
+	u8 strobing_mode;
+}da9052_sm_data_t;
+
+
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
+ 
+#endif /* _DA9052_SM_H */
Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.
