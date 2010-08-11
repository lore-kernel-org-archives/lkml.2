Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab0HKXGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:06:37 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51068 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab0HKXGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:06:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=saQaiAAsrpif8vSUy/wH8eTecDEDrFShguBpQXvG51wOfXKnpbRI1Nug++5wLxXaoK
         +5sy7JBBOtYtD+H6z/bo6S0bvYRTuSXKobcZZmQd9TzzgRaPp0vPYjxDqUjcFJ5Vdvfh
         Xxmn1wvpKaqTskSKX0CvRZsnqlEVIcVa85sXI=
From: wellsk40@gmail.com
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Wells <wellsk40@gmail.com>,
        Durgesh Pattamatta <durgesh.pattamatta@nxp.com>
Subject: [PATCH] rtc: rtc-lpc32xx: Introduce RTC driver for the LPC32XX SoC (v2)
Date: Wed, 11 Aug 2010 16:06:20 -0700
Message-Id: <1281567980-12792-2-git-send-email-wellsk40@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1281567980-12792-1-git-send-email-wellsk40@gmail.com>
References: <1281567980-12792-1-git-send-email-wellsk40@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Wells <wellsk40@gmail.com>

This patch contains the RTC driver for the built-in RTC in
the LPC32XX SoC. This patch includes updates from the initial
review comments.

Changes since v1:
	Fixed spaces/tabbing in lpc32xx entry in Kconfig/Makefile
	Remove improper enable for rtc->alarm_enabled
	Removed typecast on rtc structure in irq handler
	Switch to resource managed (devm_) variants of kzalloc
		and other functions in probe. Updated remove
		based on these changes.
	Disabled alarm on probe instead of keeping current register
		settings. No changes for suspend.
	Allowed driver to continue operation without wakeup or
		alarm irq if the rtc irq request failed.
	Relocated module_init and _exit macros to just after it's
		associated function
	Passed a NULL pointer to .driver.pm in platform driver
		structure instead of a list of NULL functions.
	Added MODULE_ALIAS

Signed-off-by: Kevin Wells <wellsk40@gmail.com>
Signed-off-by: Durgesh Pattamatta <durgesh.pattamatta@nxp.com>
---
 drivers/rtc/Kconfig       |    9 +
 drivers/rtc/Makefile      |    1 +
 drivers/rtc/rtc-lpc32xx.c |  392 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 402 insertions(+), 0 deletions(-)
 create mode 100644 drivers/rtc/rtc-lpc32xx.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 4301a6c..5bfb91e 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -916,4 +916,13 @@ config RTC_DRV_JZ4740
 	  This driver can also be buillt as a module. If so, the module
 	  will be called rtc-jz4740.
 
+config RTC_DRV_LPC32XX
+	depends on ARCH_LPC32XX
+	tristate "NXP LPC32XX RTC"
+	help
+	  This enables support for the NXP RTC in the LPC32XX
+
+	  This driver can also be buillt as a module. If so, the module
+	  will be called rtc-lpc32xx.
+
 endif # RTC_CLASS
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index fedf9bb..f90c5ad 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_RTC_DRV_FM3130)	+= rtc-fm3130.o
 obj-$(CONFIG_RTC_DRV_GENERIC)	+= rtc-generic.o
 obj-$(CONFIG_RTC_DRV_ISL1208)	+= rtc-isl1208.o
 obj-$(CONFIG_RTC_DRV_JZ4740)	+= rtc-jz4740.o
+obj-$(CONFIG_RTC_DRV_LPC32XX)	+= rtc-lpc32xx.o
 obj-$(CONFIG_RTC_DRV_M41T80)	+= rtc-m41t80.o
 obj-$(CONFIG_RTC_DRV_M41T94)	+= rtc-m41t94.o
 obj-$(CONFIG_RTC_DRV_M48T35)	+= rtc-m48t35.o
diff --git a/drivers/rtc/rtc-lpc32xx.c b/drivers/rtc/rtc-lpc32xx.c
new file mode 100644
index 0000000..b331742
--- /dev/null
+++ b/drivers/rtc/rtc-lpc32xx.c
@@ -0,0 +1,392 @@
+/*
+ * Copyright (C) 2010 NXP Semiconductors
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/rtc.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+
+/*
+ * Clock and Power control register offsets
+ */
+#define RTC_UCOUNT		0x00
+#define RTC_DCOUNT		0x04
+#define RTC_MATCH0		0x08
+#define RTC_MATCH1		0x0C
+#define RTC_CTRL		0x10
+#define RTC_INTSTAT		0x14
+#define RTC_KEY			0x18
+#define RTC_SRAM		0x80
+
+#define RTC_MATCH0_EN		(1 << 0)
+#define RTC_MATCH1_EN		(1 << 1)
+#define RTC_ONSW_MATCH0_EN	(1 << 2)
+#define RTC_ONSW_MATCH1_EN	(1 << 3)
+#define RTC_SW_RESET		(1 << 4)
+#define RTC_CNTR_DIS		(1 << 6)
+#define RTC_ONSW_FORCE_HIGH	(1 << 7)
+
+#define RTC_MATCH0_INT_STS	(1 << 0)
+#define RTC_MATCH1_INT_STS	(1 << 1)
+#define RTC_ONSW_INT_STS	(1 << 2)
+
+#define RTC_KEY_ONSW_LOADVAL	0xB5C13F27
+
+#define RTC_NAME "rtc-lpc32xx"
+
+#define rtc_readl(dev, reg) \
+	__raw_readl((dev)->rtc_base + (reg))
+#define rtc_writel(dev, reg, val) \
+	__raw_writel((val), (dev)->rtc_base + (reg))
+
+struct lpc32xx_rtc {
+	void __iomem *rtc_base;
+	int irq;
+	int alarm_enabled;
+	struct rtc_device *rtc;
+	spinlock_t lock;
+};
+
+static int lpc32xx_rtc_read_time(struct device *dev, struct rtc_time *time)
+{
+	unsigned long elapsed_sec;
+	struct lpc32xx_rtc *rtc = dev_get_drvdata(dev);
+
+	elapsed_sec = rtc_readl(rtc, RTC_UCOUNT);
+	rtc_time_to_tm(elapsed_sec, time);
+
+	return rtc_valid_tm(time);
+}
+
+static int lpc32xx_rtc_set_mmss(struct device *dev, unsigned long secs)
+{
+	struct lpc32xx_rtc *rtc = dev_get_drvdata(dev);
+	u32 tmp;
+
+	spin_lock_irq(&rtc->lock);
+
+	/* RTC must be disabled during count update */
+	tmp = rtc_readl(rtc, RTC_CTRL);
+	rtc_writel(rtc, RTC_CTRL, tmp | RTC_CNTR_DIS);
+	rtc_writel(rtc, RTC_UCOUNT, secs);
+	rtc_writel(rtc, RTC_DCOUNT, 0xFFFFFFFF - secs);
+	rtc_writel(rtc, RTC_CTRL, tmp &= ~RTC_CNTR_DIS);
+
+	spin_unlock_irq(&rtc->lock);
+
+	return 0;
+}
+
+static int lpc32xx_rtc_read_alarm(struct device *dev,
+	struct rtc_wkalrm *wkalrm)
+{
+	struct lpc32xx_rtc *rtc = dev_get_drvdata(dev);
+
+	rtc_time_to_tm(rtc_readl(rtc, RTC_MATCH0), &wkalrm->time);
+	wkalrm->enabled = rtc->alarm_enabled;
+
+	return rtc_valid_tm(&wkalrm->time);
+}
+
+static int lpc32xx_rtc_set_alarm(struct device *dev,
+	struct rtc_wkalrm *wkalrm)
+{
+	struct lpc32xx_rtc *rtc = dev_get_drvdata(dev);
+	unsigned long alarmsecs;
+	u32 tmp;
+	int ret;
+
+	ret = rtc_tm_to_time(&wkalrm->time, &alarmsecs);
+	if (ret < 0) {
+		dev_err(dev, "Failed to convert time: %d\n", ret);
+		return ret;
+	}
+
+	spin_lock_irq(&rtc->lock);
+
+	/* Disable alarm during update */
+	tmp = rtc_readl(rtc, RTC_CTRL);
+	rtc_writel(rtc, RTC_CTRL, tmp & ~RTC_MATCH0_EN);
+
+	rtc->alarm_enabled = wkalrm->enabled;
+	if (wkalrm->enabled) {
+		rtc_writel(rtc, RTC_MATCH0, alarmsecs);
+		rtc_writel(rtc, RTC_INTSTAT, RTC_MATCH0_INT_STS);
+		rtc_writel(rtc, RTC_CTRL, tmp | RTC_MATCH0_EN);
+	}
+
+	spin_unlock_irq(&rtc->lock);
+
+	return 0;
+}
+
+static int lpc32xx_rtc_alarm_irq_enable(struct device *dev,
+	unsigned int enabled)
+{
+	struct lpc32xx_rtc *rtc = dev_get_drvdata(dev);
+	u32 tmp;
+
+	spin_lock_irq(&rtc->lock);
+	rtc->alarm_enabled = (int) enabled;
+	tmp = rtc_readl(rtc, RTC_CTRL);
+
+	if (enabled)
+		tmp |= RTC_MATCH0_EN;
+	else
+		tmp &= ~RTC_MATCH0_EN;
+
+	rtc_writel(rtc, RTC_CTRL, tmp);
+	spin_unlock_irq(&rtc->lock);
+
+	return 0;
+}
+
+static irqreturn_t lpc32xx_rtc_alarm_interrupt(int irq, void *dev)
+{
+	struct lpc32xx_rtc *rtc = dev;
+
+	spin_lock(&rtc->lock);
+
+	/* Disable alarm interrupt */
+	rtc_writel(rtc, RTC_CTRL,
+		rtc_readl(rtc, RTC_CTRL) & ~RTC_MATCH0_EN);
+	rtc->alarm_enabled = 0;
+
+	/*
+	 * Write a large value to the match value so the RTC won't
+	 * keep firing the match status
+	 */
+	rtc_writel(rtc, RTC_MATCH0, 0xFFFFFFFF);
+	rtc_writel(rtc, RTC_INTSTAT, RTC_MATCH0_INT_STS);
+
+	spin_unlock(&rtc->lock);
+
+	rtc_update_irq(rtc->rtc, 1, RTC_IRQF | RTC_AF);
+
+	return IRQ_HANDLED;
+}
+
+static const struct rtc_class_ops lpc32xx_rtc_ops = {
+	.read_time		= lpc32xx_rtc_read_time,
+	.set_mmss		= lpc32xx_rtc_set_mmss,
+	.read_alarm		= lpc32xx_rtc_read_alarm,
+	.set_alarm		= lpc32xx_rtc_set_alarm,
+	.alarm_irq_enable	= lpc32xx_rtc_alarm_irq_enable,
+};
+
+static int __devinit lpc32xx_rtc_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct lpc32xx_rtc *rtc;
+	resource_size_t size;
+	int rtcirq;
+	u32 tmp;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "Can't get memory resource\n");
+		return -ENOENT;
+	}
+
+	rtcirq = platform_get_irq(pdev, 0);
+	if (rtcirq < 0 || rtcirq >= NR_IRQS) {
+		dev_warn(&pdev->dev, "Can't get interrupt resource\n");
+		rtcirq = -1;
+	}
+
+	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
+	if (unlikely(!rtc)) {
+		dev_err(&pdev->dev, "Can't allocate memory\n");
+		return -ENOMEM;
+	}
+	rtc->irq = rtcirq;
+
+	size = resource_size(res);
+
+	if (!devm_request_mem_region(&pdev->dev, res->start, size,
+				     pdev->name)) {
+		dev_err(&pdev->dev, "RTC registers are not free\n");
+		return -EBUSY;
+	}
+
+	rtc->rtc_base = devm_ioremap(&pdev->dev, res->start, size);
+	if (!rtc->rtc_base) {
+		dev_err(&pdev->dev, "Can't map memory\n");
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&rtc->lock);
+
+	/*
+	 * The RTC is on a seperate power domain and can keep it's state
+	 * across a chip power cycle. If the RTC has never been previously
+	 * setup, then set it up now for the first time.
+	 */
+	tmp = rtc_readl(rtc, RTC_CTRL);
+	if (rtc_readl(rtc, RTC_KEY) == RTC_KEY_ONSW_LOADVAL) {
+		tmp &= ~(RTC_SW_RESET | RTC_CNTR_DIS | RTC_MATCH0_EN |
+			RTC_MATCH1_EN |	RTC_ONSW_MATCH0_EN |
+			RTC_ONSW_MATCH1_EN | RTC_ONSW_FORCE_HIGH);
+		rtc_writel(rtc, RTC_CTRL, tmp);
+
+		/* Clear latched interrupt states */
+		rtc_writel(rtc, RTC_MATCH0, 0xFFFFFFFF);
+		rtc_writel(rtc, RTC_INTSTAT, RTC_MATCH0_INT_STS |
+			RTC_MATCH1_INT_STS | RTC_ONSW_INT_STS);
+
+		/* Write key value to RTC so it won't reload on reset */
+		rtc_writel(rtc, RTC_KEY, RTC_KEY_ONSW_LOADVAL);
+	} else
+		rtc_writel(rtc, RTC_CTRL, tmp & ~RTC_ONSW_MATCH0_EN);
+
+	platform_set_drvdata(pdev, rtc);
+
+	rtc->rtc = rtc_device_register(RTC_NAME, &pdev->dev, &lpc32xx_rtc_ops,
+		THIS_MODULE);
+	if (IS_ERR(rtc->rtc)) {
+		dev_err(&pdev->dev, "Can't get RTC\n");
+		return PTR_ERR(rtc->rtc);
+	}
+
+	/*
+	 * IRQ is enabled after device registration in case alarm IRQ
+	 * is pending upon suspend exit.
+	 */
+	if (rtc->irq >= 0) {
+		if (devm_request_irq(&pdev->dev, rtc->irq,
+				     lpc32xx_rtc_alarm_interrupt,
+				     IRQF_DISABLED, pdev->name, rtc) < 0) {
+			dev_warn(&pdev->dev, "Can't request interrupt.\n");
+			rtc->irq = -1;
+		} else
+			device_init_wakeup(&pdev->dev, 1);
+	}
+
+	return 0;
+}
+
+static int __devexit lpc32xx_rtc_remove(struct platform_device *pdev)
+{
+	struct lpc32xx_rtc *rtc = platform_get_drvdata(pdev);
+
+	if (rtc->irq >= 0)
+		device_init_wakeup(&pdev->dev, 0);
+
+	rtc_device_unregister(rtc->rtc);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int lpc32xx_rtc_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct lpc32xx_rtc *rtc = platform_get_drvdata(pdev);
+
+	if (rtc->irq >= 0) {
+		if (device_may_wakeup(&pdev->dev))
+			enable_irq_wake(rtc->irq);
+		else
+			disable_irq_wake(rtc->irq);
+	}
+
+	return 0;
+}
+
+static int lpc32xx_rtc_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct lpc32xx_rtc *rtc = platform_get_drvdata(pdev);
+
+	if (rtc->irq >= 0 && device_may_wakeup(&pdev->dev))
+		disable_irq_wake(rtc->irq);
+
+	return 0;
+}
+
+/* Unconditionally disable the alarm */
+static int lpc32xx_rtc_freeze(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct lpc32xx_rtc *rtc = platform_get_drvdata(pdev);
+
+	spin_lock_irq(&rtc->lock);
+
+	rtc_writel(rtc, RTC_CTRL,
+		rtc_readl(rtc, RTC_CTRL) & ~RTC_MATCH0_EN);
+
+	spin_unlock_irq(&rtc->lock);
+
+	return 0;
+}
+
+static int lpc32xx_rtc_thaw(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct lpc32xx_rtc *rtc = platform_get_drvdata(pdev);
+
+	if (rtc->alarm_enabled) {
+		spin_lock_irq(&rtc->lock);
+
+		rtc_writel(rtc, RTC_CTRL,
+			rtc_readl(rtc, RTC_CTRL) | RTC_MATCH0_EN);
+
+		spin_unlock_irq(&rtc->lock);
+	}
+
+	return 0;
+}
+
+static const struct dev_pm_ops lpc32xx_rtc_pm_ops = {
+	.suspend = lpc32xx_rtc_suspend,
+	.resume = lpc32xx_rtc_resume,
+	.freeze = lpc32xx_rtc_freeze,
+	.thaw = lpc32xx_rtc_thaw,
+	.restore = lpc32xx_rtc_resume
+};
+
+#define LPC32XX_RTC_PM_OPS (&lpc32xx_rtc_pm_ops)
+#else
+#define LPC32XX_RTC_PM_OPS NULL
+#endif
+
+static struct platform_driver lpc32xx_rtc_driver = {
+	.probe		= lpc32xx_rtc_probe,
+	.remove		= __devexit_p(lpc32xx_rtc_remove),
+	.driver = {
+		.name	= RTC_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= LPC32XX_RTC_PM_OPS
+	},
+};
+
+static int __init lpc32xx_rtc_init(void)
+{
+	return platform_driver_register(&lpc32xx_rtc_driver);
+}
+module_init(lpc32xx_rtc_init);
+
+static void __exit lpc32xx_rtc_exit(void)
+{
+	platform_driver_unregister(&lpc32xx_rtc_driver);
+}
+module_exit(lpc32xx_rtc_exit);
+
+MODULE_AUTHOR("Kevin Wells <wellsk40@gmail.com");
+MODULE_DESCRIPTION("RTC driver for the LPC32xx SoC");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rtc-lpc32xx");
-- 
1.7.1.1

