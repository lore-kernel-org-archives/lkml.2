Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab0GBJKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:10:44 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:35266 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab0GBJKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:10:41 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv2 7/11] WATCHDOG: Re-organization of the SM driver as per the standard WDT available in Linux kernel
Date: Fri, 2 Jul 2010 10:10:36 +0100
Message-ID: <3495EC08FA53E94AAA00CC4743D5BA7E013FA8DD@pandora.diasemi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv2 7/11] WATCHDOG: Re-organization of the SM driver as per the standard WDT available in Linux kernel
Thread-Index: AcsZxm7lv2vu0qE7S5WlzNsOyv3J+Q==
From: "David Dajun Chen" <Dajun.Chen@diasemi.com>
To: <wim@iguana.be>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Jul 2010 09:10:39.0480 (UTC) FILETIME=[70AD0F80:01CB19C6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Watchdog module of the device driver for DA9052 PMIC device from Dialog
Semiconductor.

Changes made since last submission:
. code has been reorganised as per the standard linux kernel driver
framework
. removal of redundant printk and comments
. removal of test framework

Linux Kernel Version: 2.6.34

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -urpN linux-2.6.34/drivers/watchdog/da9052_wdt.c
linux-2.6.34_test/drivers/watchdog/da9052_wdt.c
--- linux-2.6.34/drivers/watchdog/da9052_wdt.c	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/drivers/watchdog/da9052_wdt.c	2010-07-01
18:09:47.000000000 +0500
@@ -0,0 +1,523 @@
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/uaccess.h>
+#include <linux/jiffies.h>
+#include <linux/platform_device.h>
+#include <linux/time.h>
+#include <linux/watchdog.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+
+
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/wdt.h>
+
+#define DRIVER_NAME "da9052-wdt"
+
+#define	DA9052_STROBING_FILTER_ENABLE		0x0001
+#define	DA9052_STROBING_FILTER_DISABLE		0x0002
+#define	DA9052_SET_STROBING_MODE_MANUAL		0x0004
+#define	DA9052_SET_STROBING_MODE_AUTO		0x0008
+
+#define KERNEL_MODULE				0
+#define ENABLE					1
+#define DISABLE					0
+
+static u8 sm_strobe_filter_flag = DISABLE;
+static u8 sm_strobe_mode_flag = DA9052_STROBE_MANUAL;
+static u32 sm_mon_interval = DA9052_ADC_TWDMIN_TIME;
+static u8 sm_str_req = DISABLE;
+static u8 da9052_sm_scale = DA9052_WDT_DISABLE;
+module_param(sm_strobe_filter_flag,  byte, 0);
+MODULE_PARM_DESC(sm_strobe_filter_flag,
+		"DA9052 SM driver strobe filter flag default =
DISABLE");
+
+module_param(sm_strobe_mode_flag, byte, 0);
+MODULE_PARM_DESC(sm_strobe_mode_flag,
+		"DA9052 SM driver watchdog strobing mode default\
+		= DA9052_STROBE_MANUAL");
+
+module_param(da9052_sm_scale, byte, 0);
+MODULE_PARM_DESC(da9052_sm_scale,
+		"DA9052 SM driver scaling value used to calculate the\
+		time for the strobing  filter default = 0");
+
+module_param(sm_str_req, byte, 0);
+MODULE_PARM_DESC(sm_str_req,
+		"DA9052 SM driver strobe request flag default =
DISABLE");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static struct timer_list *monitoring_timer;
+
+struct da9052_wdt {
+	struct platform_device *pdev;
+	struct da9052 *da9052;
+};
+static struct miscdevice da9052_wdt_miscdev;
+static unsigned long da9052_wdt_users;
+static int da9052_wdt_expect_close;
+
+static struct da9052_wdt *get_wdt_da9052(void)
+{
+	return dev_get_drvdata(da9052_wdt_miscdev.parent);
+}
+
+void start_strobing(struct work_struct *work)
+{
+	struct da9052_ssc_msg msg;
+	int ret;
+	struct da9052_wdt *wdt = get_wdt_da9052();
+
+	msg.addr = DA9052_CONTROLD_REG;
+	msg.data = 0;
+	da9052_lock(wdt->da9052);
+	ret = wdt->da9052->read(wdt->da9052, &msg);
+	if (ret) {
+		da9052_unlock(wdt->da9052);
+		return;
+	}
+
+	msg.data = (msg.data | DA9052_CONTROLD_WATCHDOG);
+	da9052_lock(wdt->da9052);
+	ret = wdt->da9052->write(wdt->da9052, &msg);
+	if (ret) {
+		da9052_unlock(wdt->da9052);
+		return;
+	}
+	da9052_unlock(wdt->da9052);
+
+	sm_str_req = DISABLE;
+
+	mod_timer(monitoring_timer, jiffies + sm_mon_interval);
+
+	return;
+}
+
+
+void timer_callback(void)
+{
+	if (((sm_strobe_mode_flag) &&
+	     (sm_strobe_mode_flag == DA9052_STROBE_MANUAL)) ||
+	       (sm_strobe_mode_flag == DA9052_STROBE_AUTO)) {
+		schedule_work(&strobing_action);
+	} else {
+		if (sm_strobe_mode_flag == DA9052_STROBE_MANUAL) {
+			mod_timer(monitoring_timer, jiffies +
+				sm_mon_interval);
+		}
+	}
+}
+
+static int da9052_sm_hw_init(struct da9052_wdt *wdt)
+{
+	/* Create timer structure */
+	monitoring_timer = kzalloc(sizeof(struct timer_list),
GFP_KERNEL);
+	if (!monitoring_timer)
+		return -ENOMEM;
+
+	init_timer(monitoring_timer);
+	monitoring_timer->expires = jiffies + sm_mon_interval;
+	monitoring_timer->function = (void *)&timer_callback;
+
+	sm_strobe_filter_flag = DA9052_SM_STROBE_CONF;
+	sm_strobe_mode_flag = DA9052_STROBE_MANUAL;
+
+	return 0;
+}
+
+static int da9052_sm_hw_deinit(struct da9052_wdt *wdt)
+{
+	struct da9052_ssc_msg msg;
+	int ret;
+
+	if (monitoring_timer != NULL)
+		del_timer(monitoring_timer);
+	kfree(monitoring_timer);
+
+	msg.addr = DA9052_CONTROLD_REG;
+	msg.data = 0;
+
+	da9052_lock(wdt->da9052);
+	ret = wdt->da9052->read(wdt->da9052, &msg);
+	if (ret)
+		goto ssc_err;
+	da9052_unlock(wdt->da9052);
+
+	msg.data = (msg.data & ~(DA9052_CONTROLD_TWDSCALE));
+	da9052_lock(wdt->da9052);
+	ret = wdt->da9052->write(wdt->da9052, &msg);
+	if (ret)
+		goto ssc_err;
+	da9052_unlock(wdt->da9052);
+
+	return 0;
+ssc_err:
+	da9052_unlock(wdt->da9052);
+	return -EIO;
+}
+
+ s32 da9052_sm_set_strobing_filter(struct da9052_wdt *wdt,
+				u8 strobing_filter_state)
+ {
+	struct da9052_ssc_msg msg;
+	int ret = 0;
+
+	msg.addr = DA9052_CONTROLD_REG;
+	msg.data = 0;
+	da9052_lock(wdt->da9052);
+	ret = wdt->da9052->read(wdt->da9052, &msg);
+	if (ret)
+		goto ssc_err;
+	da9052_unlock(wdt->da9052);
+
+	msg.data = (msg.data & DA9052_CONTROLD_TWDSCALE);
+
+	if (strobing_filter_state == ENABLE) {
+		sm_strobe_filter_flag = ENABLE;
+		if (DA9052_WDT_DISABLE == msg.data) {
+			sm_str_req = DISABLE;
+			del_timer(monitoring_timer);
+			return 0;
+		}
+		if (DA9052_SCALE_64X == msg.data)
+			sm_mon_interval =
msecs_to_jiffies(DA9052_X64_WINDOW);
+		else if (DA9052_SCALE_32X == msg.data)
+			sm_mon_interval =
msecs_to_jiffies(DA9052_X32_WINDOW);
+		else if (DA9052_SCALE_16X == msg.data)
+			sm_mon_interval =
msecs_to_jiffies(DA9052_X16_WINDOW);
+		else if (DA9052_SCALE_8X == msg.data)
+			sm_mon_interval =
msecs_to_jiffies(DA9052_X8_WINDOW);
+		else if (DA9052_SCALE_4X == msg.data)
+			sm_mon_interval =
msecs_to_jiffies(DA9052_X4_WINDOW);
+		else if (DA9052_SCALE_2X == msg.data)
+			sm_mon_interval =
msecs_to_jiffies(DA9052_X2_WINDOW);
+		else
+			sm_mon_interval =
msecs_to_jiffies(DA9052_X1_WINDOW);
+
+	} else if (strobing_filter_state == DISABLE) {
+		sm_strobe_filter_flag = DISABLE;
+		sm_mon_interval =
msecs_to_jiffies(DA9052_ADC_TWDMIN_TIME);
+		if (DA9052_WDT_DISABLE == msg.data) {
+			sm_str_req = DISABLE;
+			del_timer(monitoring_timer);
+			return 0;
+		}
+	} else {
+		return STROBING_FILTER_ERROR;
+	}
+	mod_timer(monitoring_timer, jiffies + sm_mon_interval);
+
+	return 0;
+ssc_err:
+	da9052_unlock(wdt->da9052);
+	return -EIO;
+}
+
+int da9052_sm_set_strobing_mode(u8 strobing_mode_state)
+{
+	if (strobing_mode_state == DA9052_STROBE_AUTO)
+		sm_strobe_mode_flag = DA9052_STROBE_AUTO;
+	else if (strobing_mode_state == DA9052_STROBE_MANUAL)
+		sm_strobe_mode_flag = DA9052_STROBE_MANUAL;
+	else
+		return STROBING_MODE_ERROR;
+
+		return 0;
+}
+
+int da9052_sm_strobe_wdt(void)
+{
+	sm_str_req = ENABLE;
+	return 0;
+}
+
+ s32 da9052_sm_set_wdt(struct da9052_wdt *wdt, u8 wdt_scaling)
+{
+	struct da9052_ssc_msg msg;
+	int ret = 0;
+
+	if (wdt_scaling > DA9052_SCALE_64X)
+		return INVALID_SCALING_VALUE;
+
+	msg.addr = DA9052_CONTROLD_REG;
+	msg.data = 0;
+	da9052_lock(wdt->da9052);
+	ret = wdt->da9052->read(wdt->da9052, &msg);
+	if (ret)
+		goto ssc_err;
+	da9052_unlock(wdt->da9052);
+
+	if (!((DA9052_WDT_DISABLE == (msg.data &
DA9052_CONTROLD_TWDSCALE)) &&
+	    (DA9052_WDT_DISABLE == wdt_scaling))) {
+		msg.data = (msg.data & ~(DA9052_CONTROLD_TWDSCALE));
+		msg.addr = DA9052_CONTROLD_REG;
+		da9052_lock(wdt->da9052);
+		ret = wdt->da9052->write(wdt->da9052, &msg);
+		if (ret)
+			goto ssc_err;
+		da9052_unlock(wdt->da9052);
+
+		msleep(1);
+		da9052_lock(wdt->da9052);
+		ret = wdt->da9052->read(wdt->da9052, &msg);
+		if (ret)
+			goto ssc_err;
+		da9052_unlock(wdt->da9052);
+
+		msg.data |= wdt_scaling;
+
+		da9052_lock(wdt->da9052);
+		ret = wdt->da9052->write(wdt->da9052, &msg);
+		if (ret)
+			goto ssc_err;
+		da9052_unlock(wdt->da9052);
+
+		sm_str_req = DISABLE;
+		if (DA9052_WDT_DISABLE == wdt_scaling) {
+			del_timer(monitoring_timer);
+			return 0;
+		}
+		if (sm_strobe_filter_flag == ENABLE) {
+			if (DA9052_SCALE_64X == wdt_scaling) {
+				sm_mon_interval =
+
msecs_to_jiffies(DA9052_X64_WINDOW);
+			} else if (DA9052_SCALE_32X == wdt_scaling) {
+				sm_mon_interval =
+
msecs_to_jiffies(DA9052_X32_WINDOW);
+			} else if (DA9052_SCALE_16X == wdt_scaling) {
+				sm_mon_interval =
+
msecs_to_jiffies(DA9052_X16_WINDOW);
+			} else if (DA9052_SCALE_8X == wdt_scaling) {
+				sm_mon_interval =
+
msecs_to_jiffies(DA9052_X8_WINDOW);
+			} else if (DA9052_SCALE_4X == wdt_scaling) {
+				sm_mon_interval =
+
msecs_to_jiffies(DA9052_X4_WINDOW);
+			} else if (DA9052_SCALE_2X == wdt_scaling) {
+				sm_mon_interval =
+
msecs_to_jiffies(DA9052_X2_WINDOW);
+			} else {
+				sm_mon_interval =
+
msecs_to_jiffies(DA9052_X1_WINDOW);
+			}
+		} else {
+			sm_mon_interval = msecs_to_jiffies(
+						DA9052_ADC_TWDMIN_TIME);
+		}
+		mod_timer(monitoring_timer, jiffies + sm_mon_interval);
+	}
+
+	return 0;
+ssc_err:
+	da9052_unlock(wdt->da9052);
+	return -EIO;
+}
+
+static int da9052_wdt_open(struct inode *inode, struct file *file)
+{
+	struct da9052_wdt *wdt = get_wdt_da9052();
+	int ret;
+
+	if (!wdt)
+		return -ENODEV;
+
+	if (test_and_set_bit(0, &da9052_wdt_users))
+		return -EBUSY;
+
+	ret = da9052_sm_hw_init(wdt);
+	if (ret != 0)
+		return ret;
+
+	return nonseekable_open(inode, file);
+}
+
+static int da9052_wdt_release(struct inode *inode, struct file *file)
+{
+	struct da9052_wdt *wdt = get_wdt_da9052();
+
+	if (da9052_wdt_expect_close == 42)
+		da9052_sm_hw_deinit(wdt);
+	else
+		da9052_sm_strobe_wdt();
+	da9052_wdt_expect_close = 0;
+	clear_bit(0, &da9052_wdt_users);
+	return 0;
+}
+
+static ssize_t da9052_wdt_write(struct file *file,
+				const char __user *data, size_t count,
+				loff_t *ppos)
+{
+	size_t i;
+
+	if (count) {
+		if (!nowayout) {
+			/* In case it was set long ago */
+			da9052_wdt_expect_close = 0;
+			for (i = 0; i != count; i++) {
+				char c;
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					da9052_wdt_expect_close = 42;
+			}
+		}
+		da9052_sm_strobe_wdt();
+	}
+	return count;
+}
+
+static struct watchdog_info da9052_wdt_info = {
+	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity	= "DA9052_SM Watchdog",
+};
+
+static long da9052_wdt_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
+{
+	struct da9052_wdt *wdt = get_wdt_da9052();
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	unsigned char new_value;
+
+	switch (cmd) {
+
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &da9052_wdt_info,
+			sizeof(da9052_wdt_info)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_value, p))
+			return -EFAULT;
+		if (new_value & DA9052_STROBING_FILTER_ENABLE)
+			da9052_sm_set_strobing_filter(wdt, ENABLE);
+		if (new_value & DA9052_STROBING_FILTER_DISABLE)
+			da9052_sm_set_strobing_filter(wdt, DISABLE);
+		if (new_value & DA9052_SET_STROBING_MODE_MANUAL)
+
da9052_sm_set_strobing_mode(DA9052_STROBE_MANUAL);
+		if (new_value & DA9052_SET_STROBING_MODE_AUTO)
+			da9052_sm_set_strobing_mode(DA9052_STROBE_AUTO);
+		return 0;
+	case WDIOC_KEEPALIVE:
+		if (da9052_sm_strobe_wdt())
+			return -EFAULT;
+		else
+			return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_value, p))
+			return -EFAULT;
+		da9052_sm_scale = new_value;
+		if (da9052_sm_set_wdt(wdt, da9052_sm_scale))
+			return -EFAULT;
+		/* Return current value */
+		return put_user(sm_mon_interval, p);
+	case WDIOC_GETTIMEOUT:
+		return put_user(sm_mon_interval, p);
+	default:
+		return -ENOTTY;
+	}
+	return 0;
+}
+
+static const struct file_operations da9052_wdt_fops = {
+	.owner          = THIS_MODULE,
+	.llseek		= no_llseek,
+	.unlocked_ioctl	= da9052_wdt_ioctl,
+	.write		= da9052_wdt_write,
+	.open           = da9052_wdt_open,
+	.release        = da9052_wdt_release,
+};
+
+static struct miscdevice da9052_wdt_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "da9052-wdt",
+	.fops		= &da9052_wdt_fops,
+};
+
+static int __devinit da9052_sm_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct da9052_wdt *wdt;
+	struct da9052_ssc_msg msg;
+
+	wdt = kzalloc(sizeof(*wdt), GFP_KERNEL);
+	if (!wdt)
+		return -ENOMEM;
+
+	wdt->da9052 = dev_get_drvdata(pdev->dev.parent);
+	platform_set_drvdata(pdev, wdt);
+
+	msg.addr = DA9052_CONTROLD_REG;
+	msg.data = 0;
+
+	da9052_lock(wdt->da9052);
+	ret = wdt->da9052->read(wdt->da9052, &msg);
+	if (ret) {
+		da9052_unlock(wdt->da9052);
+		goto err_ssc_comm;
+	}
+
+	msg.data = (msg.data & ~(DA9052_CONTROLD_TWDSCALE));
+	ret = wdt->da9052->write(wdt->da9052, &msg);
+	if (ret) {
+		da9052_unlock(wdt->da9052);
+		goto err_ssc_comm;
+	}
+	da9052_unlock(wdt->da9052);
+
+	da9052_wdt_miscdev.parent = &pdev->dev;
+
+	ret = misc_register(&da9052_wdt_miscdev);
+	if (ret)
+		return -EFAULT;
+	return 0;
+err_ssc_comm:
+	platform_set_drvdata(pdev, NULL);
+	kfree(wdt);
+	return -EIO;
+}
+
+static int __devexit da9052_sm_remove(struct platform_device *dev)
+{
+	misc_deregister(&da9052_wdt_miscdev);
+
+	return 0;
+}
+
+static struct platform_driver da9052_sm_driver = {
+	.probe		= da9052_sm_probe,
+	.remove		= __devexit_p(da9052_sm_remove),
+	.driver		= {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init da9052_sm_init(void)
+{
+	return platform_driver_register(&da9052_sm_driver);
+}
+module_init(da9052_sm_init);
+
+static void __exit da9052_sm_exit(void)
+{
+	platform_driver_unregister(&da9052_sm_driver);
+}
+module_exit(da9052_sm_exit);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>")
+MODULE_DESCRIPTION("DA9052 SM Device Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRIVER_NAME);
diff -urpN linux-2.6.34/drivers/watchdog/Kconfig
linux-2.6.34_test/drivers/watchdog/Kconfig
--- linux-2.6.34/drivers/watchdog/Kconfig	2010-05-17
02:17:36.000000000 +0500
+++ linux-2.6.34_test/drivers/watchdog/Kconfig	2010-07-01
18:09:55.000000000 +0500
@@ -62,6 +62,12 @@ config WM831X_WATCHDOG
 	  Support for the watchdog in the WM831x AudioPlus PMICs.  When
 	  the watchdog triggers the system will be reset.
 
+config DA9052_WATCHDOG
+	tristate "DA9052 Watchdog"
+	depends on PMIC_DA9052
+	help
+	  Support for the watchdog in the DA9052 PMIC.
+
 config WM8350_WATCHDOG
 	tristate "WM8350 watchdog"
 	depends on MFD_WM8350
diff -urpN linux-2.6.34/drivers/watchdog/Makefile
linux-2.6.34_test/drivers/watchdog/Makefile
--- linux-2.6.34/drivers/watchdog/Makefile	2010-05-17
02:17:36.000000000 +0500
+++ linux-2.6.34_test/drivers/watchdog/Makefile	2010-07-01
18:10:05.000000000 +0500
@@ -143,5 +143,6 @@ obj-$(CONFIG_WATCHDOG_CP1XXX)		+=
cpwd.o
 # Architecture Independant
 obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
 obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
+obj-$(CONFIG_DA9052_WATCHDOG) += da9052_wdt.o
 obj-$(CONFIG_MAX63XX_WATCHDOG) += max63xx_wdt.o
 obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
diff -urpN linux-2.6.34/include/linux/mfd/da9052/wdt.h
linux-2.6.34_test/include/linux/mfd/da9052/wdt.h
--- linux-2.6.34/include/linux/mfd/da9052/wdt.h	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/include/linux/mfd/da9052/wdt.h	2010-07-01
18:11:05.000000000 +0500
@@ -0,0 +1,73 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#ifndef DA9052_WDT_H
+#define DA9052_WDT_H
+
+#include <linux/platform_device.h>
+
+/* To enable debug output for your module, set this to 1 */
+#define	DA9052_SM_DEBUG				0
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
+#define DA9052_WDT_DISABLE			0
+#define DA9052_SCALE_1X				1
+#define DA9052_SCALE_2X				2
+#define DA9052_SCALE_4X				3
+#define DA9052_SCALE_8X				4
+#define DA9052_SCALE_16X			5
+#define DA9052_SCALE_32X			6
+#define DA9052_SCALE_64X			7
+
+
+#define DA9052_STROBE_WIN_FILTER_PER			80
+#define DA9052_X1_WINDOW	((1 * 2048 *
DA9052_STROBE_WIN_FILTER_PER)/100)
+#define DA9052_X2_WINDOW	((2 * 2048 *
DA9052_STROBE_WIN_FILTER_PER)/100)
+#define DA9052_X4_WINDOW	((4 * 2048 *
DA9052_STROBE_WIN_FILTER_PER)/100)
+#define DA9052_X8_WINDOW	((8 * 2048 *
DA9052_STROBE_WIN_FILTER_PER)/100)
+#define DA9052_X16_WINDOW	((16 * 2048 *
DA9052_STROBE_WIN_FILTER_PER)/100)
+#define DA9052_X32_WINDOW	((32 * 2048 *
DA9052_STROBE_WIN_FILTER_PER)/100)
+#define DA9052_X64_WINDOW	((64 * 2048 *
DA9052_STROBE_WIN_FILTER_PER)/100)
+
+#define DA9052_STROBE_AUTO				1
+#define DA9052_STROBE_MANUAL				0
+
+#define DA9052_SM_STROBE_CONF			DISABLE
+
+#define DA9052_ADC_TWDMIN_TIME				500
+
+void start_strobing(struct work_struct *work);
+/* Create a handler for the scheduling start_strobing function */
+DECLARE_WORK(strobing_action, start_strobing);
+
+#endif /* _DA9052_SM_H */
Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.
