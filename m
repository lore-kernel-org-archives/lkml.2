Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab1HaGk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 02:40:26 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:4813 "EHLO
	VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab1HaGkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 02:40:24 -0400
X-SpamScore: 10
X-BigFish: VPS10(zzc8kzz1202h10d2nzz8275bhz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [PATCH v2 07/11] Watchdog: DA9052 watchdog support
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: <wim@iguana.be>
CC: <linux-kernel@vger.kernel.org>, Dajun <dajun.chen@diasemi.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 12:08:21 +0530
Message-ID: <1314772701.3220.20.camel@L-0761.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.37]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds support for the watchdog functionality provided by the Dialog
Semiconductor DA9052 PMIC chip.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
(Re-submitting this patch as there were no comments )

Changes since V2:
- Code restructured for simplicty.
- Add watchdog documentation.
- Remove Auto strobing feature.
- Remove strobe filtering flag.
---
 Documentation/watchdog/watchdog-parameters.txt |    5 +
 drivers/watchdog/Kconfig                       |    6 +
 drivers/watchdog/Makefile                      |    1 +
 drivers/watchdog/da9052_wdt.c                  |  338 ++++++++++++++++++++++++
 4 files changed, 350 insertions(+), 0 deletions(-)
 create mode 100755 drivers/watchdog/da9052_wdt.c
diff --git a/Documentation/watchdog/watchdog-parameters.txt b/Documentation/watchdog/watchdog-parameters.txt
index 17ddd82..04fddba 100644
--- a/Documentation/watchdog/watchdog-parameters.txt
+++ b/Documentation/watchdog/watchdog-parameters.txt
@@ -78,6 +78,11 @@ wd0_timeout: Default watchdog0 timeout in 1/10secs
 wd1_timeout: Default watchdog1 timeout in 1/10secs
 wd2_timeout: Default watchdog2 timeout in 1/10secs
 -------------------------------------------------
+da9052wdt:
+timeout: Watchdog timeout in seconds. 2<= timeout <=131, default=2.048s
+nowayout: Watchdog cannot be stopped once started
+       (default=kernel config parameter)
+-------------------------------------------------
 davinci_wdt:
 heartbeat: Watchdog heartbeat period in seconds from 1 to 600, default 60
 -------------------------------------------------
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 86b0735..9ffa6d7 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -63,6 +63,12 @@ config SOFT_WATCHDOG
          To compile this driver as a module, choose M here: the
          module will be called softdog.
 
+config DA9052_WATCHDOG
+       tristate "Dialog DA9052 Watchdog"
+       depends on PMIC_DA9052
+       help
+         Support for the watchdog in the DA9052 PMIC.
+
 config WM831X_WATCHDOG
        tristate "WM831x watchdog"
        depends on MFD_WM831X
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 55bd574..b047722 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -166,4 +166,5 @@ obj-$(CONFIG_XEN_WDT) += xen_wdt.o
 obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
 obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
 obj-$(CONFIG_MAX63XX_WATCHDOG) += max63xx_wdt.o
+obj-$(CONFIG_DA9052_WATCHDOG) += da9052_wdt.o
 obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
diff --git a/drivers/watchdog/da9052_wdt.c b/drivers/watchdog/da9052_wdt.c
new file mode 100755
index 0000000..546f0d2
--- /dev/null
+++ b/drivers/watchdog/da9052_wdt.c
@@ -0,0 +1,338 @@
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
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/uaccess.h>
+#include <linux/platform_device.h>
+#include <linux/time.h>
+#include <linux/watchdog.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/da9052.h>
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+static int wdt_state = WDIOS_DISABLECARD;
+static struct miscdevice da9052_wdt_miscdev;
+static unsigned long da9052_wdt_users;
+static int da9052_wdt_expect_close;
+struct da9052 *da9052;
+static DEFINE_MUTEX(wdt_mutex);
+
+static struct {
+       u8 reg_val;
+       int time;  /* Seconds */
+} da9052_wdt_maps[] = {
+       { 1, 2 },
+       { 2, 4 },
+       { 3, 8 },
+       { 4, 16 },
+       { 5, 32 },
+       { 5, 33 },  /* Actual time  32.768s so included both 32s and 33s */
+       { 6, 65 },
+       { 6, 66 },  /* Actual time 65.536s so include both, 65s and 66s */
+       { 7, 131 },
+};
+
+static int da9052_wdt_set_timeout(struct da9052 *da9052, unsigned char timeout)
+{
+       int ret;
+
+       /* Disable the Watchdog timer for 150us before changing the
+       *  time out value
+       */
+       ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
+                               DA9052_CONTROLD_TWDSCALE, 0);
+       if (ret < 0) {
+               dev_err(da9052->dev, "Failed to disable watchdog bit, %d\n",
+                       ret);
+               return ret;
+       }
+
+       udelay(150);
+
+       /* Set the desired timeout */
+       ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
+                               DA9052_CONTROLD_TWDSCALE, timeout);
+       if (ret < 0) {
+               dev_err(da9052->dev, "Failed to update timescale bit, %d\n",
+                       ret);
+               return ret;
+       }
+
+       return 0;
+}
+
+static int da9052_wdt_start(struct da9052 *da9052)
+{
+       int ret = 0;
+
+       mutex_lock(&wdt_mutex);
+
+       if (wdt_state == WDIOS_DISABLECARD) {
+               /* Default 2.048s */
+               ret = da9052_wdt_set_timeout(da9052, 1);
+               if (ret <= 0)
+                       goto err;
+
+               wdt_state = WDIOS_ENABLECARD;
+       }
+
+err:
+       mutex_unlock(&wdt_mutex);
+       return ret;
+}
+
+static int da9052_wdt_stop(struct da9052 *da9052)
+{
+       int ret = 0;
+
+       mutex_lock(&wdt_mutex);
+
+       if (wdt_state == WDIOS_ENABLECARD) {
+               ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
+                                       DA9052_CONTROLD_TWDSCALE, 0);
+               if (ret < 0) {
+                       dev_err(da9052->dev,
+                               "Failed to disable watchdog bit strobe bit, %d\n",
+                               ret);
+                       goto err;
+               }
+
+               wdt_state = WDIOS_DISABLECARD;
+       }
+
+err:
+       mutex_unlock(&wdt_mutex);
+       return ret;
+}
+
+static void da9052_wdt_strobe(struct da9052 *da9052)
+{
+       int ret;
+
+       if (wdt_state == WDIOS_ENABLECARD) {
+               ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
+                                       DA9052_CONTROLD_WATCHDOG, 1 << 7);
+               if (ret < 0) {
+                       dev_err(da9052->dev,
+                               "Failed to update watchdog strobe bit, %d\n",
+                               ret);
+                       return;
+               }
+       }
+}
+
+static int da9052_wdt_open(struct inode *inode, struct file *file)
+{
+       int ret;
+
+       if (test_and_set_bit(0, &da9052_wdt_users))
+               return -EBUSY;
+
+       ret = da9052_wdt_start(da9052);
+       if (ret < 0)
+               return ret;
+
+       return nonseekable_open(inode, file);
+}
+
+static int da9052_wdt_release(struct inode *inode, struct file *file)
+{
+       int ret = 0;
+
+       if (da9052_wdt_expect_close == 42)
+               ret = da9052_wdt_stop(da9052);
+       else
+               da9052_wdt_strobe(da9052);
+
+       da9052_wdt_expect_close = 0;
+       clear_bit(0, &da9052_wdt_users);
+
+       return ret;
+}
+
+static struct watchdog_info da9052_wdt_info = {
+       .options        = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+       .identity       = "DA9052 Watchdog",
+};
+
+static long da9052_wdt_ioctl(struct file *file, uint cmd, unsigned long arg)
+{
+       void __user *argp = (void __user *)arg;
+       int ret = 0, timeout, i, __user *p = argp;
+
+       switch (cmd) {
+       case WDIOC_GETSUPPORT:
+               ret = copy_to_user(argp, &da9052_wdt_info,
+                                  sizeof(da9052_wdt_info)) ? -EFAULT : 0;
+               break;
+       case WDIOC_GETSTATUS:
+       case WDIOC_GETBOOTSTATUS:
+               ret = put_user(0, p);
+               break;
+       case WDIOC_SETOPTIONS:
+       {
+               int options;
+               ret = get_user(options, p);
+               if (ret)
+                       break;
+
+               if (options == WDIOS_ENABLECARD)
+                       ret = da9052_wdt_start(da9052);
+
+               if (options == WDIOS_DISABLECARD)
+                       ret = da9052_wdt_stop(da9052);
+
+               break;
+       }
+       case WDIOC_KEEPALIVE:
+               da9052_wdt_strobe(da9052);
+               break;
+       case WDIOC_SETTIMEOUT:
+               ret = get_user(timeout, p);
+               if (ret)
+                       break;
+
+               for (i = 0; i < ARRAY_SIZE(da9052_wdt_maps); i++)
+                       if (da9052_wdt_maps[i].time == timeout)
+                               break;
+               if (i == ARRAY_SIZE(da9052_wdt_maps))
+                       ret = -EINVAL;
+               else
+                       ret = da9052_wdt_set_timeout(da9052,
+                                                    da9052_wdt_maps[i].reg_val);
+
+               break;
+       case WDIOC_GETTIMEOUT:
+               ret = da9052_reg_read(da9052, DA9052_CONTROL_D_REG);
+               if (ret < 0)
+                       break;
+
+               ret &= DA9052_CONTROLD_TWDSCALE;
+               for (i = 0; i < ARRAY_SIZE(da9052_wdt_maps); i++)
+                       if (da9052_wdt_maps[i].reg_val == ret)
+                               break;
+               if (i == ARRAY_SIZE(da9052_wdt_maps))
+                       ret = -EINVAL;
+               else
+                       ret = put_user(da9052_wdt_maps[i].time, p);
+
+               break;
+       default:
+               return -ENOTTY;
+       }
+
+       return ret;
+}
+
+static ssize_t da9052_wdt_write(struct file *file,
+                                const char __user *data, size_t count,
+                                loff_t *ppos)
+{
+       size_t i;
+
+       /* Check the magic character 'V' and reload the timer */
+       if (count) {
+               if (!nowayout) {
+                       da9052_wdt_expect_close = 0;
+
+                       /* scan for magic character */
+                       for (i = 0; i != count; i++) {
+                               char c;
+                               if (get_user(c, data + i))
+                                       return -EFAULT;
+                               if (c == 'V')
+                                       da9052_wdt_expect_close = 42;
+                       }
+               /* someone wrote to us, we should reload the timer */
+               da9052_wdt_strobe(da9052);
+               }
+       }
+       return count;
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
+       .minor          = WATCHDOG_MINOR,
+       .name           = "da9052-wdt",
+       .fops           = &da9052_wdt_fops,
+};
+
+static int __devinit da9052_wdt_probe(struct platform_device *pdev)
+{
+       int ret;
+       struct da9052 *da9052;
+
+       da9052 = dev_get_drvdata(pdev->dev.parent);
+
+       ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
+                               DA9052_CONTROLD_TWDSCALE, 0);
+       if (ret < 0) {
+               dev_err(&pdev->dev, "Failed to disable watchdog bits, %d\n",
+                       ret);
+               return ret;
+       }
+
+       da9052_wdt_miscdev.parent = &pdev->dev;
+
+       ret = misc_register(&da9052_wdt_miscdev);
+
+       return ret;
+}
+
+static int __devexit da9052_wdt_remove(struct platform_device *dev)
+{
+       misc_deregister(&da9052_wdt_miscdev);
+
+       return 0;
+}
+
+static struct platform_driver da9052_wdt_driver = {
+       .probe = da9052_wdt_probe,
+       .remove = __devexit_p(da9052_wdt_remove),
+       .driver = {
+               .name   = "da9052-wdt",
+               .owner  = THIS_MODULE,
+       },
+};
+
+static int __init da9052_wdt_init(void)
+{
+       return platform_driver_register(&da9052_wdt_driver);
+}
+module_init(da9052_wdt_init);
+
+static void __exit da9052_wdt_exit(void)
+{
+       platform_driver_unregister(&da9052_wdt_driver);
+}
+module_exit(da9052_wdt_exit);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("DA9052 SM Device Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:ret-wdt");


