Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab0KYQJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:09:44 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48277 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab0KYQJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:09:43 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: [PATCH] watchdog: add support for the Synopsys DesignWare WDT
Date: Thu, 25 Nov 2010 16:09:29 +0000
Message-Id: <1290701369-20317-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Synopsys DesignWare watchdog is found in several ARM based systems
and provides a choice of 16 timeout periods depending on the clock
input. The watchdog cannot be disabled once started.

Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/watchdog/Kconfig  |    9 ++
 drivers/watchdog/Makefile |    1 +
 drivers/watchdog/dw_wdt.c |  290 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 300 insertions(+), 0 deletions(-)
 create mode 100644 drivers/watchdog/dw_wdt.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 4a29104..19a056c 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -331,6 +331,15 @@ config IMX2_WDT
 	  To compile this driver as a module, choose M here: the
 	  module will be called imx2_wdt.
 
+config DW_WATCHDOG
+	tristate "Synopsys DesignWare watchdog"
+        select WATCHDOG_NOWAYOUT
+	help
+	  Say Y here if to include support for the Synopsys DesignWare
+	  watchdog timer found in many ARM chips.
+	  To compile this driver as a module, choose M here: the
+	  module will be called dw_wdt.
+
 # AVR32 Architecture
 
 config AT32AP700X_WDT
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 4b0ef38..3b3da4a 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_NUC900_WATCHDOG) += nuc900_wdt.o
 obj-$(CONFIG_ADX_WATCHDOG) += adx_wdt.o
 obj-$(CONFIG_TS72XX_WATCHDOG) += ts72xx_wdt.o
 obj-$(CONFIG_IMX2_WDT) += imx2_wdt.o
+obj-$(CONFIG_DW_WATCHDOG) += dw_wdt.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
new file mode 100644
index 0000000..180840a
--- /dev/null
+++ b/drivers/watchdog/dw_wdt.c
@@ -0,0 +1,290 @@
+/*
+ * Copyright 2010 Picochip Ltd., Jamie Iles
+ * http://www.picochip.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * This file implements a driver for the Synopsys DesignWare watchdog device
+ * in the many ARM subsystems. The watchdog has 16 different timeout periods
+ * and these are a function of the input clock frequency.
+ */
+#define pr_fmt(fmt) "dw_wdt: " fmt
+
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/pm.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/uaccess.h>
+#include <linux/watchdog.h>
+
+#define WDOG_CONTROL_REG_OFFSET             0x00
+#define WDOG_TIMEOUT_RANGE_REG_OFFSET       0x04
+#define WDOG_CURRENT_COUNT_REG_OFFSET       0x08
+#define WDOG_COUNTER_RESTART_REG_OFFSET     0x0c
+
+/* The maximum TOP (timeout period) value that can be set in the watchdog. */
+#define DW_WDT_MAX_TOP		15
+
+static struct {
+	spinlock_t		lock;
+	void __iomem		*regs;
+	struct clk		*clk;
+} dw_wdt;
+
+static inline int dw_wdt_is_enabled(void)
+{
+#define WDOG_CONTROL_REG_WDT_EN_MASK		0x01
+	return readl(dw_wdt.regs + WDOG_CONTROL_REG_OFFSET) &
+		WDOG_CONTROL_REG_WDT_EN_MASK;
+}
+
+static inline int dw_wdt_top_in_seconds(unsigned top)
+{
+	/*
+	 * There are 16 possible timeout values in 0..15 where the number of
+	 * cycles is 2 ^ (16 + i) and the watchdog counts down.
+	 */
+	return (1 << (16 + top)) / clk_get_rate(dw_wdt.clk);
+}
+
+static int dw_wdt_set_top(unsigned top_s)
+{
+	int i, top_val = -1;
+
+	/*
+	 * Iterate over the timeout values until we find the closest match. We
+	 * always look for >=.
+	 */
+	for (i = 0; i <= DW_WDT_MAX_TOP; ++i)
+		if (dw_wdt_top_in_seconds(i) >= top_s) {
+			top_val = i;
+			break;
+		}
+
+	/*
+	 * If we didn't find a suitable value, it must have been too large. Go
+	 * with the biggest that we can.
+	 */
+	if (top_val < 0)
+		top_val = DW_WDT_MAX_TOP;
+
+	/* Set the new value in the watchdog. */
+	writel(top_val, dw_wdt.regs + WDOG_TIMEOUT_RANGE_REG_OFFSET);
+
+	return dw_wdt_top_in_seconds(top_val);
+}
+
+static int dw_wdt_get_top(void)
+{
+	int top = readl(dw_wdt.regs + WDOG_TIMEOUT_RANGE_REG_OFFSET) & 0xF;
+
+	return dw_wdt_top_in_seconds(top);
+}
+
+static void dw_wdt_keepalive(void)
+{
+#define WDOG_COUNTER_RESTART_KICK_VALUE	    0x76
+	writel(WDOG_COUNTER_RESTART_KICK_VALUE, dw_wdt.regs +
+	       WDOG_COUNTER_RESTART_REG_OFFSET);
+}
+
+static int dw_wdt_open(struct inode *inode, struct file *filp)
+{
+	/* Make sure we don't get unloaded. */
+	__module_get(THIS_MODULE);
+
+	spin_lock(&dw_wdt.lock);
+	if (!dw_wdt_is_enabled()) {
+		/*
+		 * The watchdog is not currently enabled. Set the timeout to
+		 * the maximum and then start it.
+		 */
+		dw_wdt_set_top(DW_WDT_MAX_TOP);
+		writel(WDOG_CONTROL_REG_WDT_EN_MASK,
+		       dw_wdt.regs + WDOG_CONTROL_REG_OFFSET);
+	}
+	spin_unlock(&dw_wdt.lock);
+
+	return nonseekable_open(inode, filp);
+}
+
+ssize_t dw_wdt_write(struct file * filp, const char __user *buf, size_t len,
+		     loff_t *offset)
+{
+	dw_wdt_keepalive();
+
+	return len;
+}
+
+static u32 dw_wdt_time_left(void)
+{
+	return readl(dw_wdt.regs + WDOG_CURRENT_COUNT_REG_OFFSET) /
+		clk_get_rate(dw_wdt.clk);
+}
+
+static const struct watchdog_info dw_wdt_ident = {
+	.options	= WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT,
+	.identity	= "Synopsys DesignWare Watchdog",
+};
+
+static long dw_wdt_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	unsigned long val;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user((struct watchdog_info *)arg, &dw_wdt_ident,
+				    sizeof(dw_wdt_ident)) ? -EFAULT : 0;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, (int *)arg);
+
+	case WDIOC_KEEPALIVE:
+		dw_wdt_keepalive();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(val, (int __user *)arg))
+			return -EFAULT;
+		return put_user(dw_wdt_set_top(val), (int __user *)arg);
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(dw_wdt_get_top(), (int __user *)arg);
+
+	case WDIOC_GETTIMELEFT:
+		/* Get the time left until expiry. */
+		if (get_user(val, (int __user *)arg))
+			return -EFAULT;
+		return put_user(dw_wdt_time_left(), (int __user *)arg);
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+static int dw_wdt_release(struct inode *inode, struct file *filp)
+{
+	pr_crit("WATCHDOG: device closed - timer will not stop\n");
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int dw_wdt_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	clk_disable(dw_wdt.clk);
+
+	return 0;
+}
+
+static int dw_wdt_resume(struct platform_device *pdev)
+{
+	int err = clk_enable(dw_wdt.clk);
+
+	if (err)
+		return err;
+
+	dw_wdt_keepalive();
+
+	return 0;
+}
+#else /* CONFIG_PM */
+#define dw_wdt_suspend	NULL
+#define dw_wdt_resume	NULL
+#endif /* CONFIG_PM */
+
+static struct file_operations wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.open		= dw_wdt_open,
+	.write		= dw_wdt_write,
+	.unlocked_ioctl	= dw_wdt_ioctl,
+	.release	= dw_wdt_release
+};
+
+static struct miscdevice dw_wdt_miscdev = {
+	.fops		= &wdt_fops,
+	.name		= "watchdog",
+	.minor		= WATCHDOG_MINOR,
+};
+
+static int __devinit dw_wdt_drv_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	if (!mem)
+		return -EINVAL;
+
+	dw_wdt.regs = devm_ioremap(&pdev->dev, mem->start,
+					     resource_size(mem));
+	if (!dw_wdt.regs)
+		return -ENOMEM;
+
+	dw_wdt.clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR_OR_NULL(dw_wdt.clk))
+		return -ENODEV;
+	clk_enable(dw_wdt.clk);
+
+	ret = misc_register(&dw_wdt_miscdev);
+	if (ret)
+		goto register_failed;
+
+	return 0;
+
+register_failed:
+	clk_put(dw_wdt.clk);
+
+	return ret;
+}
+
+static int __devexit dw_wdt_drv_remove(struct platform_device *pdev)
+{
+	clk_disable(dw_wdt.clk);
+	clk_put(dw_wdt.clk);
+
+	misc_deregister(&dw_wdt_miscdev);
+
+	return 0;
+}
+
+static struct platform_driver dw_wdt_driver = {
+	.probe		= dw_wdt_drv_probe,
+	.remove		= __devexit_p(dw_wdt_drv_remove),
+	.suspend	= dw_wdt_suspend,
+	.resume		= dw_wdt_resume,
+	.driver		= {
+		.name	= "dw_wdt",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init dw_wdt_watchdog_init(void)
+{
+	spin_lock_init(&dw_wdt.lock);
+
+	return platform_driver_register(&dw_wdt_driver);
+}
+
+static void __exit dw_wdt_watchdog_exit(void)
+{
+	platform_driver_unregister(&dw_wdt_driver);
+}
+
+module_init(dw_wdt_watchdog_init);
+module_exit(dw_wdt_watchdog_exit);
+
+MODULE_AUTHOR("Jamie Iles");
+MODULE_DESCRIPTION("Synopsys DesignWare Watchdog Driver");
+MODULE_LICENSE("GPL");
-- 
1.7.2.3

