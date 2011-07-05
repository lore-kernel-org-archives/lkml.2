Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab1GENW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:22:29 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:33885
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932186Ab1GENW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:22:28 -0400
X-SpamScore: 10
X-BigFish: VPS10(zzc8kzz1202h10d2nzz8275bhz32i2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:203.197.93.240;KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.Kpit.com;EFVD:NLI
Subject: [PATCH 07/11] Watchdog: DA9052 watchdog support v1
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: <wim@iguana.be>
CC: <linux-kernel@vger.kernel.org>, Dajun <dajun.chen@diasemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 5 Jul 2011 18:51:42 +0530
Message-ID: <1309872103.960.79.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds support for the watchdog functionality provided by the Dialog
Semiconductor DA9052 PMIC chip.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/watchdog/Kconfig      |    6 +
 drivers/watchdog/Makefile     |    1 +
 drivers/watchdog/da9052_wdt.c |  472 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 479 insertions(+), 0 deletions(-)
 create mode 100755 drivers/watchdog/da9052_wdt.c
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 022f9eb..6689061 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -45,6 +45,12 @@ comment "Watchdog Device Drivers"
 
 # Architecture Independent
 
+config DA9052_WATCHDOG
+        tristate "Dialog DA9052 Watchdog"
+        depends on PMIC_DA9052
+        help
+          Support for the watchdog in the DA9052 PMIC.
+
 config SOFT_WATCHDOG
 	tristate "Software watchdog"
 	help
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index ed26f70..85f3c42 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -158,4 +158,5 @@ obj-$(CONFIG_XEN_WDT) += xen_wdt.o
 obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
 obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
 obj-$(CONFIG_MAX63XX_WATCHDOG) += max63xx_wdt.o
+obj-$(CONFIG_DA9052_WATCHDOG) += da9052_wdt.o
 obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
diff --git a/drivers/watchdog/da9052_wdt.c b/drivers/watchdog/da9052_wdt.c
new file mode 100755
index 0000000..7390c5b
--- /dev/null
+++ b/drivers/watchdog/da9052_wdt.c
@@ -0,0 +1,472 @@
+/*
+ * System monitoring driver for DA9052 PMICs.
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+ *
+ * Author: Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
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
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/pdata.h>
+#include <linux/mfd/da9052/wdt.h>
+
+struct da9052_wdt {
+	struct platform_device *pdev;
+	struct da9052_wdt_platform_data *pwdt;
+	struct da9052 *da9052;
+	struct work_struct wdt_strobe;
+	unsigned long data;
+};
+
+static struct da9052_wdt *wdt;
+
+/* Create a handler for the scheduling start_strobing function */
+static unsigned char sm_str_req = DA9052_DISABLE;
+static int nowayout = WATCHDOG_NOWAYOUT;
+static uint strobe_interval;
+static uint strobe_mode;
+static struct timer_list monitoring_timer;
+static struct miscdevice da9052_wdt_miscdev;
+static unsigned long da9052_wdt_users;
+static int da9052_wdt_expect_close;
+
+static struct da9052_wdt *get_wdt_da9052(void)
+{
+	return platform_get_drvdata
+			(to_platform_device(da9052_wdt_miscdev.parent));
+}
+
+void start_strobing(struct work_struct *work)
+{
+	int ret;
+	struct da9052_wdt *wdt = get_wdt_da9052();
+
+	if (NULL == wdt) {
+		mod_timer(&monitoring_timer,
+			  jiffies + wdt->pwdt->sm_mon_interval);
+		return;
+	}
+
+	ret = da9052_set_bits(wdt->da9052, DA9052_CONTROLD_REG,
+			      DA9052_CONTROLD_WATCHDOG);
+	if (ret < 0) {
+		dev_err(wdt->da9052->dev, "Failed to set controld reg, %d\n",
+			ret);
+		return;
+	}
+
+	sm_str_req = DA9052_DISABLE;
+
+	mod_timer(&monitoring_timer, jiffies + wdt->pwdt->sm_mon_interval);
+
+	return;
+}
+
+void timer_callback(unsigned long *data)
+{
+	struct da9052_wdt *pwdt = (struct da9052_wdt *)
+				   container_of(data, struct da9052_wdt,
+				   data);
+
+	if (((sm_str_req) && (strobe_mode == DA9052_STROBE_MANUAL)) ||
+	      (strobe_mode == DA9052_STROBE_AUTO))
+		schedule_work(&pwdt->wdt_strobe);
+	else {
+		if (strobe_mode == DA9052_STROBE_MANUAL)
+			mod_timer(&monitoring_timer, jiffies + strobe_interval);
+	}
+}
+
+static int da9052_sm_hw_init(struct da9052_wdt *wdt)
+{
+	init_timer(&monitoring_timer);
+	monitoring_timer.expires = jiffies + wdt->pwdt->sm_mon_interval;
+	monitoring_timer.function = (void *)&timer_callback;
+	monitoring_timer.data = wdt->data;
+
+	wdt->pwdt->sm_strobe_filter_flag = DA9052_SM_STROBE_CONF;
+	wdt->pwdt->sm_strobe_mode_flag = DA9052_STROBE_MANUAL;
+
+	return 0;
+}
+
+static int da9052_sm_hw_deinit(struct da9052_wdt *wdt)
+{
+	int ret;
+
+	del_timer(&monitoring_timer);
+
+	ret = da9052_clear_bits(wdt->da9052, DA9052_CONTROLD_REG,
+				DA9052_CONTROLD_TWDSCALE);
+	if (ret < 0)
+		dev_err(wdt->da9052->dev, "Failed to clear controld reg, %d\n",
+			ret);
+	return ret;
+}
+
+int da9052_sm_set_strobing_filter(struct da9052_wdt *wdt,
+				   unsigned char strobing_filter_state)
+{
+	int ret;
+
+	ret = da9052_reg_read(wdt->da9052, DA9052_CONTROLD_REG);
+	if (ret < 0) {
+		dev_err(wdt->da9052->dev, "Failed to read controld reg, %d\n",
+			ret);
+		return ret;
+	}
+
+	ret = (ret & DA9052_CONTROLD_TWDSCALE);
+
+	if (strobing_filter_state == DA9052_ENABLE) {
+		wdt->pwdt->sm_strobe_filter_flag = DA9052_ENABLE;
+		if (DA9052_WDT_DISABLE == ret) {
+			sm_str_req = DA9052_DISABLE;
+			del_timer(&monitoring_timer);
+			return 0;
+		}
+		switch (ret) {
+		case DA9052_SCALE_64X:
+			wdt->pwdt->sm_mon_interval =
+					msecs_to_jiffies(DA9052_X64_WINDOW);
+			break;
+		case DA9052_SCALE_32X:
+			wdt->pwdt->sm_mon_interval =
+					msecs_to_jiffies(DA9052_X32_WINDOW);
+			break;
+		case DA9052_SCALE_16X:
+			wdt->pwdt->sm_mon_interval =
+					msecs_to_jiffies(DA9052_X16_WINDOW);
+			break;
+		case DA9052_SCALE_8X:
+			wdt->pwdt->sm_mon_interval =
+					msecs_to_jiffies(DA9052_X8_WINDOW);
+			break;
+		case DA9052_SCALE_4X:
+			wdt->pwdt->sm_mon_interval =
+					msecs_to_jiffies(DA9052_X4_WINDOW);
+			break;
+		case DA9052_SCALE_2X:
+			wdt->pwdt->sm_mon_interval =
+					msecs_to_jiffies(DA9052_X2_WINDOW);
+			break;
+		default:
+			wdt->pwdt->sm_mon_interval =
+					msecs_to_jiffies(DA9052_X1_WINDOW);
+		}
+	} else if (strobing_filter_state == DA9052_DISABLE) {
+		wdt->pwdt->sm_strobe_filter_flag = DA9052_DISABLE;
+		wdt->pwdt->sm_mon_interval =
+				msecs_to_jiffies(DA9052_ADC_TWDMIN_TIME);
+		if (DA9052_WDT_DISABLE == ret) {
+			sm_str_req = DA9052_DISABLE;
+			del_timer(&monitoring_timer);
+			return 0;
+		}
+	} else
+		return -EINVAL;
+
+	mod_timer(&monitoring_timer, jiffies + wdt->pwdt->sm_mon_interval);
+
+	return 0;
+}
+
+int da9052_sm_strobe_wdt(void)
+{
+	sm_str_req = DA9052_ENABLE;
+
+	return 0;
+}
+
+int da9052_sm_set_wdt(struct da9052_wdt *wdt, unsigned char wdt_scaling)
+{
+	int ret;
+
+	if (wdt_scaling > DA9052_SCALE_64X)
+		return -EINVAL;
+
+	ret = da9052_reg_read(wdt->da9052, DA9052_CONTROLD_REG);
+	if (ret < 0) {
+		dev_err(wdt->da9052->dev, "Failed to read controld reg, %d\n",
+			ret);
+		return ret;
+	}
+
+	if (!((DA9052_WDT_DISABLE == (ret & DA9052_CONTROLD_TWDSCALE)) &&
+	      (DA9052_WDT_DISABLE == wdt_scaling))) {
+		ret = (ret & ~(DA9052_CONTROLD_TWDSCALE));
+
+		ret = da9052_reg_write(wdt->da9052, DA9052_CONTROLD_REG, ret);
+		if (ret) {
+			dev_err(wdt->da9052->dev,
+				"Failed to write controld reg, %d\n", ret);
+			return ret;
+		}
+
+		msleep(1);
+
+		ret = da9052_set_bits(wdt->da9052, DA9052_CONTROLD_REG,
+				      wdt_scaling);
+		if (ret) {
+			dev_err(wdt->da9052->dev,
+				"da9052_sm_set_wdt ->da9052_set_bits, Error: %d\n",
+				ret);
+			return ret;
+		}
+
+		sm_str_req = DA9052_DISABLE;
+		if (DA9052_WDT_DISABLE == wdt_scaling) {
+			del_timer(&monitoring_timer);
+			return 0;
+		}
+		if (wdt->pwdt->sm_strobe_filter_flag == DA9052_ENABLE) {
+			switch (wdt_scaling) {
+			case DA9052_SCALE_64X:
+				wdt->pwdt->sm_mon_interval =
+					msecs_to_jiffies(DA9052_X64_WINDOW);
+				break;
+			case DA9052_SCALE_32X:
+				wdt->pwdt->sm_mon_interval =
+					msecs_to_jiffies(DA9052_X32_WINDOW);
+				break;
+			case DA9052_SCALE_16X:
+				wdt->pwdt->sm_mon_interval =
+					msecs_to_jiffies(DA9052_X16_WINDOW);
+				break;
+			case DA9052_SCALE_8X:
+				wdt->pwdt->sm_mon_interval =
+					msecs_to_jiffies(DA9052_X8_WINDOW);
+				break;
+			case DA9052_SCALE_4X:
+				wdt->pwdt->sm_mon_interval =
+					msecs_to_jiffies(DA9052_X4_WINDOW);
+				break;
+			case DA9052_SCALE_2X:
+				wdt->pwdt->sm_mon_interval =
+					msecs_to_jiffies(DA9052_X2_WINDOW);
+				break;
+			default:
+				wdt->pwdt->sm_mon_interval =
+					msecs_to_jiffies(DA9052_X1_WINDOW);
+			}
+		} else {
+			wdt->pwdt->sm_mon_interval = msecs_to_jiffies(
+						     DA9052_ADC_TWDMIN_TIME);
+		}
+		mod_timer(&monitoring_timer,
+			  jiffies + wdt->pwdt->sm_mon_interval);
+	}
+
+	return ret;
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
+	if (ret)
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
+
+	da9052_wdt_expect_close = 0;
+	clear_bit(0, &da9052_wdt_users);
+	return 0;
+}
+
+static ssize_t da9052_wdt_write(struct file *file,
+				 const char __user *data, size_t count,
+				 loff_t *ppos)
+{
+	size_t i;
+
+	if (count) {
+		if (!nowayout) {
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
+
+	return count;
+}
+
+static struct watchdog_info da9052_wdt_info = {
+	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity	= "DA9052_SM Watchdog",
+};
+
+static long da9052_wdt_ioctl(struct file *file, uint cmd, unsigned long arg)
+{
+	struct da9052_wdt *wdt = get_wdt_da9052();
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	unsigned char new_value;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &da9052_wdt_info,
+				    sizeof(da9052_wdt_info)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_value, p))
+			return -EFAULT;
+		if (new_value == DA9052_ENABLE || new_value == DA9052_DISABLE)
+			da9052_sm_set_strobing_filter(wdt, new_value);
+		else
+			wdt->pwdt->sm_strobe_mode_flag = new_value;
+		return 0;
+	case WDIOC_KEEPALIVE:
+		if (da9052_sm_strobe_wdt())
+			return -EFAULT;
+		else
+			return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_value, p))
+			return -EFAULT;
+		wdt->pwdt->sm_scale = new_value;
+		if (da9052_sm_set_wdt(wdt, wdt->pwdt->sm_scale))
+			return -EFAULT;
+	case WDIOC_GETTIMEOUT:
+		return put_user(wdt->pwdt->sm_mon_interval, p);
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
+static const struct file_operations da9052_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.unlocked_ioctl	= da9052_wdt_ioctl,
+	.write		= da9052_wdt_write,
+	.open		= da9052_wdt_open,
+	.release	= da9052_wdt_release,
+};
+
+static struct miscdevice da9052_wdt_miscdev = {
+	.minor		= 255,
+	.name		= "da9052-wdt",
+	.fops		= &da9052_wdt_fops,
+};
+
+static int __devinit da9052_sm_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct da9052_pdata *pdata = pdev->dev.platform_data;
+	struct da9052_wdt_platform_data *pwdt = (pdata->pwdt);
+
+	wdt = kzalloc(sizeof(*wdt), GFP_KERNEL);
+	if (!wdt)
+		return -ENOMEM;
+
+	wdt->da9052 = dev_get_drvdata(pdev->dev.parent);
+	platform_set_drvdata(pdev, wdt);
+	wdt->pwdt = pwdt;
+
+	INIT_WORK(&wdt->wdt_strobe, start_strobing);
+
+	strobe_interval = pwdt->sm_mon_interval;
+	strobe_mode = pwdt->sm_strobe_mode_flag;
+
+	ret = da9052_clear_bits(wdt->da9052, DA9052_CONTROLD_REG,
+				DA9052_CONTROLD_TWDSCALE);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to clear controld reg, %d\n", ret);
+		goto err_mem;
+	}
+
+	da9052_wdt_miscdev.parent = &pdev->dev;
+
+	ret = misc_register(&da9052_wdt_miscdev);
+	if (ret)
+		goto err_mem;
+
+	return 0;
+err_mem:
+	platform_set_drvdata(pdev, NULL);
+	kfree(wdt);
+	return ret;
+}
+
+static int __devexit da9052_sm_remove(struct platform_device *dev)
+{
+	misc_deregister(&da9052_wdt_miscdev);
+	kfree(wdt);
+
+	return 0;
+}
+
+static struct platform_driver da9052_sm_driver = {
+	.probe = da9052_sm_probe,
+	.remove = __devexit_p(da9052_sm_remove),
+	.driver = {
+		.name	= "da9052-wdt",
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
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("DA9052 SM Device Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:da9052-wdt");


