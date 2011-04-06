Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab1DFMdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:33:33 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.186]:27683
	"EHLO CH1EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755674Ab1DFMdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:33:31 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cK936eKc8kzz1202hzz8275bh84d07hz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.kpit.com;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Wim Van Sebroeck <wim@iguana.be>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen2@diasemi.com>
Date: Wed, 6 Apr 2011 18:03:13 +0530
Subject: [PATCHv1 7/11] WATCHDOG: Watchdog module of DA9052 device driver
Thread-Topic: [PATCHv1 7/11] WATCHDOG: Watchdog module of DA9052 device
 driver
Thread-Index: Acv0VsuP1DK0bNqqQVKfC9uYqsS5Xg==
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B451EB1@KCINPUNHJCMS01.kpit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p36CXkjb000735

Hi,

Watchdog Driver for Dialog Semiconductor DA9052 PMICs.

Changes made since last submission:
. read and write operation moved to MFD


Linux Kernel Version: 2.6.37

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -Naur orig_linux-2.6.37/drivers/watchdog/da9052_wdt.c linux-2.6.37/drivers/watchdog/da9052_wdt.c
--- orig_linux-2.6.37/drivers/watchdog/da9052_wdt.c     1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.37/drivers/watchdog/da9052_wdt.c  2011-03-31 21:02:59.000000000 +0500
@@ -0,0 +1,463 @@
+/*
+ * da9052-wdt.c: system monitoring driver for DA9052
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ *Author: Dajun Chen <dchen@diasemi.com>
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
+
+#define        DA9052_STROBING_FILTER_ENABLE           1
+#define        DA9052_STROBING_FILTER_DISABLE  2
+
+void start_strobing(struct work_struct *work);
+
+struct da9052_wdt {
+       struct platform_device *pdev;
+       struct da9052_wdt_platform_data *pwdt;
+       struct da9052 *da9052;
+       struct work_struct wdt_strobe;
+       unsigned long data;
+};
+
+
+/* Create a handler for the scheduling start_strobing function */
+
+static u8 sm_str_req = DA9052_DISABLE;
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
+       return platform_get_drvdata
+                       (to_platform_device(da9052_wdt_miscdev.parent));
+}
+
+void start_strobing(struct work_struct *work)
+{
+       int ret;
+       struct da9052_wdt *wdt = get_wdt_da9052();
+
+       if (NULL == wdt) {
+               mod_timer(&monitoring_timer,
+                       jiffies + wdt->pwdt->sm_mon_interval);
+               return;
+       }
+
+       ret = da9052_set_bits(wdt->da9052, DA9052_CONTROLD_REG,
+                               DA9052_CONTROLD_WATCHDOG);
+       if (ret < 0) {
+               dev_err(wdt->da9052->dev, "Failed to set controld reg, %d\n", ret);
+               return;
+       }
+
+       sm_str_req = DA9052_DISABLE;
+
+       mod_timer(&monitoring_timer, jiffies + wdt->pwdt->sm_mon_interval);
+       return;
+}
+
+
+void timer_callback(unsigned long *data)
+{
+       struct da9052_wdt *pwdt = (struct da9052_wdt *)
+               container_of(data, struct da9052_wdt, data);
+
+       if (((sm_str_req) &&
+               (strobe_mode == DA9052_STROBE_MANUAL)) ||
+               (strobe_mode == DA9052_STROBE_AUTO))
+                       chedule_work(&pwdt->wdt_strobe);
+       else {
+               if (strobe_mode == DA9052_STROBE_MANUAL)
+                       mod_timer(&monitoring_timer, jiffies +
+                       strobe_interval);
+       }
+}
+
+static int da9052_sm_hw_init(struct da9052_wdt *wdt)
+{
+       init_timer(&monitoring_timer);
+       monitoring_timer.expires = jiffies + wdt->pwdt->sm_mon_interval;
+       monitoring_timer.function = (void *)&timer_callback;
+       monitoring_timer.data = wdt->data;
+
+       wdt->pwdt->sm_strobe_filter_flag = DA9052_SM_STROBE_CONF;
+       wdt->pwdt->sm_strobe_mode_flag = DA9052_STROBE_MANUAL;
+
+       return 0;
+}
+
+static int da9052_sm_hw_deinit(struct da9052_wdt *wdt)
+{
+
+       int ret;
+
+       del_timer(&monitoring_timer);
+
+       ret = da9052_clear_bits(wdt->da9052, DA9052_CONTROLD_REG,
+                               DA9052_CONTROLD_TWDSCALE);
+       if (ret < 0)
+               dev_err(wdt->da9052->dev, "Failed to clear controld reg, %d\n", ret);
+       return ret;
+}
+
+s32 da9052_sm_set_strobing_filter(struct da9052_wdt *wdt,
+                               u8 strobing_filter_state)
+{
+       int ret = 0;
+
+       ret = da9052_reg_read(wdt->da9052, DA9052_CONTROLD_REG);
+       if (ret < 0) {
+               dev_err(wdt->da9052->dev, "Failed to read controld reg, %d\n", ret);
+               return ret;
+       }
+
+       ret = (ret & DA9052_CONTROLD_TWDSCALE);
+
+       if (strobing_filter_state == DA9052_ENABLE) {
+               wdt->pwdt->sm_strobe_filter_flag = DA9052_ENABLE;
+               if (DA9052_WDT_DISABLE == ret) {
+                       sm_str_req = DA9052_DISABLE;
+                       del_timer(&monitoring_timer);
+                       return 0;
+               }
+               if (DA9052_SCALE_64X == ret)
+                       wdt->pwdt->sm_mon_interval =
+                               msecs_to_jiffies(DA9052_X64_WINDOW);
+               else if (DA9052_SCALE_32X == ret)
+                       wdt->pwdt->sm_mon_interval =
+                                       msecs_to_jiffies(DA9052_X32_WINDOW);
+               else if (DA9052_SCALE_16X == ret)
+                       wdt->pwdt->sm_mon_interval =
+                                       msecs_to_jiffies(DA9052_X16_WINDOW);
+               else if (DA9052_SCALE_8X == ret)
+                       wdt->pwdt->sm_mon_interval =
+                                       msecs_to_jiffies(DA9052_X8_WINDOW);
+               else if (DA9052_SCALE_4X == ret)
+                       wdt->pwdt->sm_mon_interval =
+                                       msecs_to_jiffies(DA9052_X4_WINDOW);
+               else if (DA9052_SCALE_2X == ret)
+                       wdt->pwdt->sm_mon_interval =
+                                       msecs_to_jiffies(DA9052_X2_WINDOW);
+               else
+                       wdt->pwdt->sm_mon_interval =
+                               msecs_to_jiffies(DA9052_X1_WINDOW);
+       } else if (strobing_filter_state == DA9052_DISABLE) {
+               wdt->pwdt->sm_strobe_filter_flag = DA9052_DISABLE;
+               wdt->pwdt->sm_mon_interval =
+                               msecs_to_jiffies(DA9052_ADC_TWDMIN_TIME);
+               if (DA9052_WDT_DISABLE == ret) {
+                       sm_str_req = DA9052_DISABLE;
+                       del_timer(&monitoring_timer);
+                       return 0;
+               }
+       } else
+               return -EINVAL;
+
+       mod_timer(&monitoring_timer, jiffies + wdt->pwdt->sm_mon_interval);
+
+       return 0;
+
+}
+
+int da9052_sm_strobe_wdt(void)
+{
+       sm_str_req = DA9052_ENABLE;
+       return 0;
+}
+
+s32 da9052_sm_set_wdt(struct da9052_wdt *wdt, u8 wdt_scaling)
+{
+
+       int ret = 0;
+
+
+       if (wdt_scaling > DA9052_SCALE_64X)
+               return -EINVAL;
+
+       ret = da9052_reg_read(wdt->da9052, DA9052_CONTROLD_REG);
+       if (ret < 0) {
+               dev_err(wdt->da9052->dev, "Failed to read controld reg, %d\n", ret);
+               return ret;
+       }
+
+       if (!((DA9052_WDT_DISABLE == (ret & DA9052_CONTROLD_TWDSCALE)) &&
+           (DA9052_WDT_DISABLE == wdt_scaling))) {
+               ret = (ret & ~(DA9052_CONTROLD_TWDSCALE));
+
+               ret = da9052_reg_write(wdt->da9052, DA9052_CONTROLD_REG, ret);
+               if (ret) {
+                       dev_err(wdt->da9052->dev, "Failed to write controld reg, %d\n",
+                                       ret);
+                       return ret;
+               }
+
+               msleep(1);
+
+               ret = da9052_set_bits(wdt->da9052, DA9052_CONTROLD_REG,
+                                       wdt_scaling);
+               if (ret) {
+                       dev_err(wdt->da9052->dev, "da9052_sm_set_wdt -> \
+                                       da9052_set_bits, Error: %d\n",
+                                       ret);
+                       return ret;
+               }
+
+               sm_str_req = DA9052_DISABLE;
+               if (DA9052_WDT_DISABLE == wdt_scaling) {
+                       del_timer(&monitoring_timer);
+                       return 0;
+               }
+               if (wdt->pwdt->sm_strobe_filter_flag == DA9052_ENABLE) {
+                       if (DA9052_SCALE_64X == wdt_scaling) {
+                               wdt->pwdt->sm_mon_interval =
+                                       msecs_to_jiffies(DA9052_X64_WINDOW);
+                       } else if (DA9052_SCALE_32X == wdt_scaling) {
+                               wdt->pwdt->sm_mon_interval =
+                                       msecs_to_jiffies(DA9052_X32_WINDOW);
+                       } else if (DA9052_SCALE_16X == wdt_scaling) {
+                               wdt->pwdt->sm_mon_interval =
+                                       msecs_to_jiffies(DA9052_X16_WINDOW);
+                       } else if (DA9052_SCALE_8X == wdt_scaling) {
+                               wdt->pwdt->sm_mon_interval =
+                                       msecs_to_jiffies(DA9052_X8_WINDOW);
+                       } else if (DA9052_SCALE_4X == wdt_scaling) {
+                               wdt->pwdt->sm_mon_interval =
+                                       msecs_to_jiffies(DA9052_X4_WINDOW);
+                       } else if (DA9052_SCALE_2X == wdt_scaling) {
+                               wdt->pwdt->sm_mon_interval =
+                                       msecs_to_jiffies(DA9052_X2_WINDOW);
+                       } else {
+                               wdt->pwdt->sm_mon_interval =
+                                       msecs_to_jiffies(DA9052_X1_WINDOW);
+                       }
+               } else {
+                       wdt->pwdt->sm_mon_interval = msecs_to_jiffies(
+                                               DA9052_ADC_TWDMIN_TIME);
+               }
+               mod_timer(&monitoring_timer,
+                                       jiffies + wdt->pwdt->sm_mon_interval);
+       }
+
+       return ret;
+}
+
+static int da9052_wdt_open(struct inode *inode, struct file *file)
+{
+       struct da9052_wdt *wdt = get_wdt_da9052();
+       int ret;
+
+       if (!wdt)
+               return -ENODEV;
+
+
+       if (test_and_set_bit(0, &da9052_wdt_users))
+               return -EBUSY;
+
+       ret = da9052_sm_hw_init(wdt);
+       if (ret != 0)
+               return ret;
+
+       return nonseekable_open(inode, file);
+}
+
+static int da9052_wdt_release(struct inode *inode, struct file *file)
+{
+       struct da9052_wdt *wdt = get_wdt_da9052();
+
+       if (da9052_wdt_expect_close == 42)
+               da9052_sm_hw_deinit(wdt);
+       else
+               da9052_sm_strobe_wdt();
+       da9052_wdt_expect_close = 0;
+       clear_bit(0, &da9052_wdt_users);
+       return 0;
+}
+
+static ssize_t da9052_wdt_write(struct file *file,
+                               const char __user *data, size_t count,
+                               loff_t *ppos)
+{
+       size_t i;
+
+       if (count) {
+               if (!nowayout) {
+                       da9052_wdt_expect_close = 0;
+                       for (i = 0; i != count; i++) {
+                               char c;
+                               if (get_user(c, data + i))
+                                       return -EFAULT;
+                               if (c == 'V')
+                                       da9052_wdt_expect_close = 42;
+                       }
+               }
+               da9052_sm_strobe_wdt();
+       }
+       return count;
+}
+
+static struct watchdog_info da9052_wdt_info = {
+       .options        = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+       .identity       = "DA9052_SM Watchdog",
+};
+
+static long da9052_wdt_ioctl(struct file *file, unsigned int cmd,
+                               unsigned long arg)
+{
+       struct da9052_wdt *wdt = get_wdt_da9052();
+       void __user *argp = (void __user *)arg;
+       int __user *p = argp;
+       unsigned char new_value;
+
+       switch (cmd) {
+
+       case WDIOC_GETSUPPORT:
+               return copy_to_user(argp, &da9052_wdt_info,
+                       sizeof(da9052_wdt_info)) ? -EFAULT : 0;
+       case WDIOC_GETSTATUS:
+       case WDIOC_GETBOOTSTATUS:
+               return put_user(0, p);
+       case WDIOC_SETOPTIONS:
+               if (get_user(new_value, p))
+                       return -EFAULT;
+               if (new_value ==  DA9052_STROBING_FILTER_ENABLE ||
+                       new_value == DA9052_STROBING_FILTER_DISABLE)
+                               da9052_sm_set_strobing_filter(wdt, new_value);
+               else
+                       wdt->pwdt->sm_strobe_mode_flag = new_value;
+               return 0;
+       case WDIOC_KEEPALIVE:
+               if (da9052_sm_strobe_wdt())
+                       return -EFAULT;
+               else
+                       return 0;
+       case WDIOC_SETTIMEOUT:
+               if (get_user(new_value, p))
+                       return -EFAULT;
+               wdt->pwdt->sm_scale = new_value;
+               if (da9052_sm_set_wdt(wdt, wdt->pwdt->sm_scale))
+                       return -EFAULT;
+       case WDIOC_GETTIMEOUT:
+               return put_user(wdt->pwdt->sm_mon_interval, p);
+       default:
+               return -ENOTTY;
+       }
+       return 0;
+}
+
+static const struct file_operations da9052_wdt_fops = {
+       .owner          = THIS_MODULE,
+       .llseek         = no_llseek,
+       .unlocked_ioctl = da9052_wdt_ioctl,
+       .write          = da9052_wdt_write,
+       .open           = da9052_wdt_open,
+       .release        = da9052_wdt_release,
+};
+
+static struct miscdevice da9052_wdt_miscdev = {
+       .minor          = 255,
+       .name           = "da9052-wdt",
+       .fops           = &da9052_wdt_fops,
+};
+
+static int __devinit da9052_sm_probe(struct platform_device *pdev)
+{
+       int ret;
+       struct da9052_wdt *wdt;
+       struct da9052_pdata *pdata = pdev->dev.platform_data;
+       struct da9052_wdt_platform_data *pwdt = (pdata->pwdt);
+
+       wdt = kzalloc(sizeof(*wdt), GFP_KERNEL);
+       if (!wdt)
+               return -ENOMEM;
+
+       wdt->da9052 = dev_get_drvdata(pdev->dev.parent);
+       platform_set_drvdata(pdev, wdt);
+       wdt->pwdt = pwdt;
+
+       INIT_WORK(&wdt->wdt_strobe, start_strobing);
+
+       strobe_interval = pwdt->sm_mon_interval;
+       strobe_mode = pwdt->sm_strobe_mode_flag;
+
+       ret = da9052_clear_bits(wdt->da9052, DA9052_CONTROLD_REG,
+                               DA9052_CONTROLD_TWDSCALE);
+       if (ret < 0) {
+               dev_err(&pdev->dev, "Failed to clear controld reg, %d\n", ret);
+               goto err_mem;
+       }
+
+       da9052_wdt_miscdev.parent = &pdev->dev;
+
+       ret = misc_register(&da9052_wdt_miscdev);
+       if (ret != 0)
+               goto err_mem;
+
+       return 0;
+err_mem:
+       platform_set_drvdata(pdev, NULL);
+       kfree(wdt);
+       return ret;
+}
+
+static int __devexit da9052_sm_remove(struct platform_device *dev)
+{
+       misc_deregister(&da9052_wdt_miscdev);
+       strobe_interval = 0;
+       strobe_mode = 0;
+       return 0;
+}
+
+static struct platform_driver da9052_sm_driver = {
+       .driver.name    = "da9052-wdt",
+       .driver.owner   = THIS_MODULE,
+       .probe                  = da9052_sm_probe,
+       .remove                 = __devexit_p(da9052_sm_remove),
+};
+
+static int __init da9052_sm_init(void)
+{
+       return platform_driver_register(&da9052_sm_driver);
+}
+module_init(da9052_sm_init);
+
+static void __exit da9052_sm_exit(void)
+{
+       platform_driver_unregister(&da9052_sm_driver);
+}
+module_exit(da9052_sm_exit);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>")
+MODULE_DESCRIPTION("DA9052 SM Device Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:da9052-wdt");
diff -Naur orig_linux-2.6.37/include/linux/mfd/da9052/wdt.h linux-2.6.37/include/linux/mfd/da9052/wdt.h
--- orig_linux-2.6.37/include/linux/mfd/da9052/wdt.h    1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.37/include/linux/mfd/da9052/wdt.h 2011-03-31 21:02:25.000000000 +0500
@@ -0,0 +1,67 @@
+/*
+ * include/linux/mfd/da9052/wdt.h -- WDT for DA9052
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * Author: Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __LINUX_MFD_DA9052_WDT_H
+#define __LINUX_MFD_DA9052_WDT_H
+
+#include <linux/platform_device.h>
+
+
+#define DA9052_ENABLE                          1
+#define DA9052_DISABLE                         0
+
+
+/* Watchdog time scaling TWDMAX scaling macros */
+#define DA9052_WDT_DISABLE                     0
+#define DA9052_SCALE_1X                        1
+#define DA9052_SCALE_2X                        2
+#define DA9052_SCALE_4X                        3
+#define DA9052_SCALE_8X                        4
+#define DA9052_SCALE_16X                       5
+#define DA9052_SCALE_32X                       6
+#define DA9052_SCALE_64X                       7
+
+#define DA9052_STROBE_WIN_FILTER_PER   80
+#define DA9052_X1_WINDOW       ((1 * 2048 * DA9052_STROBE_WIN_FILTER_PER)/100)
+#define DA9052_X2_WINDOW       ((2 * 2048 * DA9052_STROBE_WIN_FILTER_PER)/100)
+#define DA9052_X4_WINDOW       ((4 * 2048 * DA9052_STROBE_WIN_FILTER_PER)/100)
+#define DA9052_X8_WINDOW       ((8 * 2048 * DA9052_STROBE_WIN_FILTER_PER)/100)
+#define DA9052_X16_WINDOW      ((16 * 2048 * DA9052_STROBE_WIN_FILTER_PER)/100)
+#define DA9052_X32_WINDOW      ((32 * 2048 * DA9052_STROBE_WIN_FILTER_PER)/100)
+#define DA9052_X64_WINDOW      ((64 * 2048 * DA9052_STROBE_WIN_FILTER_PER)/100)
+
+#define DA9052_STROBE_AUTO                     1
+#define DA9052_SM_STROBE_CONF          0
+#define DA9052_ADC_TWDMIN_TIME         500
+
+struct da9052_wdt_platform_data {
+       u8 sm_strobe_filter_flag;
+       u8 sm_strobe_mode_flag;
+       u32 sm_mon_interval;
+       u8 sm_scale;
+};
+
+void start_strobing(struct work_struct *work);
+/* Create a handler for the scheduling start_strobing function */
+#endif

Regards,
Ashish


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
