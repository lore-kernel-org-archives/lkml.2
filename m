Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab0I2QYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 12:24:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41388 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab0I2QYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 12:24:04 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@linux.intel.com>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: [PATCH 4/4] rtc/mc13xxx: add support for the rtc found in the MC13892 PMIC
Date: Wed, 29 Sep 2010 18:23:47 +0200
Message-Id: <1285777427-2887-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20100929162315.GG29811@pengutronix.de>
References: <20100929162315.GG29811@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mfd driver for MC13783 recently got support for MC13892 and was
renamed accordingly from mc13783-core to mc13xxx-core.  Do the same for
rtc-mc13783.

The only relevant change is to use platform id's to tell the platform bus
that this driver is responsible for mc13892-rtc devices, too.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/rtc/Kconfig       |    7 +-
 drivers/rtc/Makefile      |    2 +-
 drivers/rtc/rtc-mc13783.c |  428 --------------------------------------------
 drivers/rtc/rtc-mc13xxx.c |  437 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 442 insertions(+), 432 deletions(-)
 delete mode 100644 drivers/rtc/rtc-mc13783.c
 create mode 100644 drivers/rtc/rtc-mc13xxx.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 48ca713..6ac83c2 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -926,10 +926,11 @@ config RTC_DRV_PCAP
 	  the PCAP2 ASIC used on some Motorola phones.
 
 config RTC_DRV_MC13783
-	depends on MFD_MC13783
-	tristate "Freescale MC13783 RTC"
+	depends on MFD_MC13XXX
+	tristate "Freescale MC13xxx RTC"
 	help
-	  This enables support for the Freescale MC13783 PMIC RTC
+	  This enables support for the RTCs found on Freescale's PMICs
+	  MC13783 and MC13892.
 
 config RTC_DRV_MPC5121
 	tristate "Freescale MPC5121 built-in RTC"
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 0f207b3..61d8848 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -60,7 +60,7 @@ obj-$(CONFIG_RTC_MXC)		+= rtc-mxc.o
 obj-$(CONFIG_RTC_DRV_MAX6900)	+= rtc-max6900.o
 obj-$(CONFIG_RTC_DRV_MAX8925)	+= rtc-max8925.o
 obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
-obj-$(CONFIG_RTC_DRV_MC13783)	+= rtc-mc13783.o
+obj-$(CONFIG_RTC_DRV_MC13XXX)	+= rtc-mc13xxx.o
 obj-$(CONFIG_RTC_DRV_MSM6242)	+= rtc-msm6242.o
 obj-$(CONFIG_RTC_DRV_MPC5121)	+= rtc-mpc5121.o
 obj-$(CONFIG_RTC_DRV_MV)	+= rtc-mv.o
diff --git a/drivers/rtc/rtc-mc13783.c b/drivers/rtc/rtc-mc13783.c
deleted file mode 100644
index 675bfb5..0000000
--- a/drivers/rtc/rtc-mc13783.c
+++ /dev/null
@@ -1,428 +0,0 @@
-/*
- * Real Time Clock driver for Freescale MC13783 PMIC
- *
- * (C) 2009 Sascha Hauer, Pengutronix
- * (C) 2009 Uwe Kleine-Koenig, Pengutronix
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/mfd/mc13783.h>
-#include <linux/platform_device.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/rtc.h>
-
-#define DRIVER_NAME "mc13783-rtc"
-
-#define MC13783_RTCTOD	20
-#define MC13783_RTCTODA	21
-#define MC13783_RTCDAY	22
-#define MC13783_RTCDAYA	23
-
-struct mc13783_rtc {
-	struct rtc_device *rtc;
-	struct mc13783 *mc13783;
-	int valid;
-};
-
-static int mc13783_rtc_irq_enable_unlocked(struct device *dev,
-		unsigned int enabled, int irq)
-{
-	struct mc13783_rtc *priv = dev_get_drvdata(dev);
-	int (*func)(struct mc13783 *mc13783, int irq);
-
-	if (!priv->valid)
-		return -ENODATA;
-
-	func = enabled ? mc13783_irq_unmask : mc13783_irq_mask;
-	return func(priv->mc13783, irq);
-}
-
-static int mc13783_rtc_irq_enable(struct device *dev,
-		unsigned int enabled, int irq)
-{
-	struct mc13783_rtc *priv = dev_get_drvdata(dev);
-	int ret;
-
-	mc13783_lock(priv->mc13783);
-
-	ret = mc13783_rtc_irq_enable_unlocked(dev, enabled, irq);
-
-	mc13783_unlock(priv->mc13783);
-
-	return ret;
-}
-
-static int mc13783_rtc_read_time(struct device *dev, struct rtc_time *tm)
-{
-	struct mc13783_rtc *priv = dev_get_drvdata(dev);
-	unsigned int seconds, days1, days2;
-	unsigned long s1970;
-	int ret;
-
-	mc13783_lock(priv->mc13783);
-
-	if (!priv->valid) {
-		ret = -ENODATA;
-		goto out;
-	}
-
-	ret = mc13783_reg_read(priv->mc13783, MC13783_RTCDAY, &days1);
-	if (unlikely(ret))
-		goto out;
-
-	ret = mc13783_reg_read(priv->mc13783, MC13783_RTCTOD, &seconds);
-	if (unlikely(ret))
-		goto out;
-
-	ret = mc13783_reg_read(priv->mc13783, MC13783_RTCDAY, &days2);
-out:
-	mc13783_unlock(priv->mc13783);
-
-	if (ret)
-		return ret;
-
-	if (days2 == days1 + 1) {
-		if (seconds >= 86400 / 2)
-			days2 = days1;
-		else
-			days1 = days2;
-	}
-
-	if (days1 != days2)
-		return -EIO;
-
-	s1970 = days1 * 86400 + seconds;
-
-	rtc_time_to_tm(s1970, tm);
-
-	return rtc_valid_tm(tm);
-}
-
-static int mc13783_rtc_set_mmss(struct device *dev, unsigned long secs)
-{
-	struct mc13783_rtc *priv = dev_get_drvdata(dev);
-	unsigned int seconds, days;
-	unsigned int alarmseconds;
-	int ret;
-
-	seconds = secs % 86400;
-	days = secs / 86400;
-
-	mc13783_lock(priv->mc13783);
-
-	/*
-	 * temporarily invalidate alarm to prevent triggering it when the day is
-	 * already updated while the time isn't yet.
-	 */
-	ret = mc13783_reg_read(priv->mc13783, MC13783_RTCTODA, &alarmseconds);
-	if (unlikely(ret))
-		goto out;
-
-	if (alarmseconds < 86400) {
-		ret = mc13783_reg_write(priv->mc13783,
-				MC13783_RTCTODA, 0x1ffff);
-		if (unlikely(ret))
-			goto out;
-	}
-
-	/*
-	 * write seconds=0 to prevent a day switch between writing days
-	 * and seconds below
-	 */
-	ret = mc13783_reg_write(priv->mc13783, MC13783_RTCTOD, 0);
-	if (unlikely(ret))
-		goto out;
-
-	ret = mc13783_reg_write(priv->mc13783, MC13783_RTCDAY, days);
-	if (unlikely(ret))
-		goto out;
-
-	ret = mc13783_reg_write(priv->mc13783, MC13783_RTCTOD, seconds);
-	if (unlikely(ret))
-		goto out;
-
-	/* restore alarm */
-	if (alarmseconds < 86400) {
-		ret = mc13783_reg_write(priv->mc13783,
-				MC13783_RTCTODA, alarmseconds);
-		if (unlikely(ret))
-			goto out;
-	}
-
-	ret = mc13783_irq_ack(priv->mc13783, MC13783_IRQ_RTCRST);
-	if (unlikely(ret))
-		goto out;
-
-	ret = mc13783_irq_unmask(priv->mc13783, MC13783_IRQ_RTCRST);
-out:
-	priv->valid = !ret;
-
-	mc13783_unlock(priv->mc13783);
-
-	return ret;
-}
-
-static int mc13783_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
-{
-	struct mc13783_rtc *priv = dev_get_drvdata(dev);
-	unsigned seconds, days;
-	unsigned long s1970;
-	int enabled, pending;
-	int ret;
-
-	mc13783_lock(priv->mc13783);
-
-	ret = mc13783_reg_read(priv->mc13783, MC13783_RTCTODA, &seconds);
-	if (unlikely(ret))
-		goto out;
-	if (seconds >= 86400) {
-		ret = -ENODATA;
-		goto out;
-	}
-
-	ret = mc13783_reg_read(priv->mc13783, MC13783_RTCDAY, &days);
-	if (unlikely(ret))
-		goto out;
-
-	ret = mc13783_irq_status(priv->mc13783, MC13783_IRQ_TODA,
-			&enabled, &pending);
-
-out:
-	mc13783_unlock(priv->mc13783);
-
-	if (ret)
-		return ret;
-
-	alarm->enabled = enabled;
-	alarm->pending = pending;
-
-	s1970 = days * 86400 + seconds;
-
-	rtc_time_to_tm(s1970, &alarm->time);
-	dev_dbg(dev, "%s: %lu\n", __func__, s1970);
-
-	return 0;
-}
-
-static int mc13783_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
-{
-	struct mc13783_rtc *priv = dev_get_drvdata(dev);
-	unsigned long s1970;
-	unsigned seconds, days;
-	int ret;
-
-	mc13783_lock(priv->mc13783);
-
-	/* disable alarm to prevent false triggering */
-	ret = mc13783_reg_write(priv->mc13783, MC13783_RTCTODA, 0x1ffff);
-	if (unlikely(ret))
-		goto out;
-
-	ret = mc13783_irq_ack(priv->mc13783, MC13783_IRQ_TODA);
-	if (unlikely(ret))
-		goto out;
-
-	ret = rtc_tm_to_time(&alarm->time, &s1970);
-	if (unlikely(ret))
-		goto out;
-
-	dev_dbg(dev, "%s: o%2.s %lu\n", __func__, alarm->enabled ? "n" : "ff",
-			s1970);
-
-	ret = mc13783_rtc_irq_enable_unlocked(dev, alarm->enabled,
-			MC13783_IRQ_TODA);
-	if (unlikely(ret))
-		goto out;
-
-	seconds = s1970 % 86400;
-	days = s1970 / 86400;
-
-	ret = mc13783_reg_write(priv->mc13783, MC13783_RTCDAYA, days);
-	if (unlikely(ret))
-		goto out;
-
-	ret = mc13783_reg_write(priv->mc13783, MC13783_RTCTODA, seconds);
-
-out:
-	mc13783_unlock(priv->mc13783);
-
-	return ret;
-}
-
-static irqreturn_t mc13783_rtc_alarm_handler(int irq, void *dev)
-{
-	struct mc13783_rtc *priv = dev;
-	struct mc13783 *mc13783 = priv->mc13783;
-
-	dev_dbg(&priv->rtc->dev, "Alarm\n");
-
-	rtc_update_irq(priv->rtc, 1, RTC_IRQF | RTC_AF);
-
-	mc13783_irq_ack(mc13783, irq);
-
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t mc13783_rtc_update_handler(int irq, void *dev)
-{
-	struct mc13783_rtc *priv = dev;
-	struct mc13783 *mc13783 = priv->mc13783;
-
-	dev_dbg(&priv->rtc->dev, "1HZ\n");
-
-	rtc_update_irq(priv->rtc, 1, RTC_IRQF | RTC_UF);
-
-	mc13783_irq_ack(mc13783, irq);
-
-	return IRQ_HANDLED;
-}
-
-static int mc13783_rtc_update_irq_enable(struct device *dev,
-		unsigned int enabled)
-{
-	return mc13783_rtc_irq_enable(dev, enabled, MC13783_IRQ_1HZ);
-}
-
-static int mc13783_rtc_alarm_irq_enable(struct device *dev,
-		unsigned int enabled)
-{
-	return mc13783_rtc_irq_enable(dev, enabled, MC13783_IRQ_TODA);
-}
-
-static const struct rtc_class_ops mc13783_rtc_ops = {
-	.read_time = mc13783_rtc_read_time,
-	.set_mmss = mc13783_rtc_set_mmss,
-	.read_alarm = mc13783_rtc_read_alarm,
-	.set_alarm = mc13783_rtc_set_alarm,
-	.alarm_irq_enable = mc13783_rtc_alarm_irq_enable,
-	.update_irq_enable = mc13783_rtc_update_irq_enable,
-};
-
-static irqreturn_t mc13783_rtc_reset_handler(int irq, void *dev)
-{
-	struct mc13783_rtc *priv = dev;
-	struct mc13783 *mc13783 = priv->mc13783;
-
-	dev_dbg(&priv->rtc->dev, "RTCRST\n");
-	priv->valid = 0;
-
-	mc13783_irq_mask(mc13783, irq);
-
-	return IRQ_HANDLED;
-}
-
-static int __devinit mc13783_rtc_probe(struct platform_device *pdev)
-{
-	int ret;
-	struct mc13783_rtc *priv;
-	struct mc13783 *mc13783;
-	int rtcrst_pending;
-
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	mc13783 = dev_get_drvdata(pdev->dev.parent);
-	priv->mc13783 = mc13783;
-
-	platform_set_drvdata(pdev, priv);
-
-	mc13783_lock(mc13783);
-
-	ret = mc13783_irq_request(mc13783, MC13783_IRQ_RTCRST,
-			mc13783_rtc_reset_handler, DRIVER_NAME, priv);
-	if (ret)
-		goto err_reset_irq_request;
-
-	ret = mc13783_irq_status(mc13783, MC13783_IRQ_RTCRST,
-			NULL, &rtcrst_pending);
-	if (ret)
-		goto err_reset_irq_status;
-
-	priv->valid = !rtcrst_pending;
-
-	ret = mc13783_irq_request_nounmask(mc13783, MC13783_IRQ_1HZ,
-			mc13783_rtc_update_handler, DRIVER_NAME, priv);
-	if (ret)
-		goto err_update_irq_request;
-
-	ret = mc13783_irq_request_nounmask(mc13783, MC13783_IRQ_TODA,
-			mc13783_rtc_alarm_handler, DRIVER_NAME, priv);
-	if (ret)
-		goto err_alarm_irq_request;
-
-	priv->rtc = rtc_device_register(pdev->name,
-			&pdev->dev, &mc13783_rtc_ops, THIS_MODULE);
-	if (IS_ERR(priv->rtc)) {
-		ret = PTR_ERR(priv->rtc);
-
-		mc13783_irq_free(mc13783, MC13783_IRQ_TODA, priv);
-err_alarm_irq_request:
-
-		mc13783_irq_free(mc13783, MC13783_IRQ_1HZ, priv);
-err_update_irq_request:
-
-err_reset_irq_status:
-
-		mc13783_irq_free(mc13783, MC13783_IRQ_RTCRST, priv);
-err_reset_irq_request:
-
-		platform_set_drvdata(pdev, NULL);
-		kfree(priv);
-	}
-
-	mc13783_unlock(mc13783);
-
-	return ret;
-}
-
-static int __devexit mc13783_rtc_remove(struct platform_device *pdev)
-{
-	struct mc13783_rtc *priv = platform_get_drvdata(pdev);
-
-	mc13783_lock(priv->mc13783);
-
-	rtc_device_unregister(priv->rtc);
-
-	mc13783_irq_free(priv->mc13783, MC13783_IRQ_TODA, priv);
-	mc13783_irq_free(priv->mc13783, MC13783_IRQ_1HZ, priv);
-	mc13783_irq_free(priv->mc13783, MC13783_IRQ_RTCRST, priv);
-
-	mc13783_unlock(priv->mc13783);
-
-	platform_set_drvdata(pdev, NULL);
-
-	kfree(priv);
-
-	return 0;
-}
-
-static struct platform_driver mc13783_rtc_driver = {
-	.remove = __devexit_p(mc13783_rtc_remove),
-	.driver = {
-		.name = DRIVER_NAME,
-		.owner = THIS_MODULE,
-	},
-};
-
-static int __init mc13783_rtc_init(void)
-{
-	return platform_driver_probe(&mc13783_rtc_driver, &mc13783_rtc_probe);
-}
-module_init(mc13783_rtc_init);
-
-static void __exit mc13783_rtc_exit(void)
-{
-	platform_driver_unregister(&mc13783_rtc_driver);
-}
-module_exit(mc13783_rtc_exit);
-
-MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
-MODULE_DESCRIPTION("RTC driver for Freescale MC13783 PMIC");
-MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:" DRIVER_NAME);
diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
new file mode 100644
index 0000000..5314b15
--- /dev/null
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -0,0 +1,437 @@
+/*
+ * Real Time Clock driver for Freescale MC13XXX PMIC
+ *
+ * (C) 2009 Sascha Hauer, Pengutronix
+ * (C) 2009 Uwe Kleine-Koenig, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/mfd/mc13xxx.h>
+#include <linux/platform_device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/rtc.h>
+
+#define DRIVER_NAME "mc13xxx-rtc"
+
+#define MC13XXX_RTCTOD	20
+#define MC13XXX_RTCTODA	21
+#define MC13XXX_RTCDAY	22
+#define MC13XXX_RTCDAYA	23
+
+struct mc13xxx_rtc {
+	struct rtc_device *rtc;
+	struct mc13xxx *mc13xxx;
+	int valid;
+};
+
+static int mc13xxx_rtc_irq_enable_unlocked(struct device *dev,
+		unsigned int enabled, int irq)
+{
+	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
+	int (*func)(struct mc13xxx *mc13xxx, int irq);
+
+	if (!priv->valid)
+		return -ENODATA;
+
+	func = enabled ? mc13xxx_irq_unmask : mc13xxx_irq_mask;
+	return func(priv->mc13xxx, irq);
+}
+
+static int mc13xxx_rtc_irq_enable(struct device *dev,
+		unsigned int enabled, int irq)
+{
+	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
+	int ret;
+
+	mc13xxx_lock(priv->mc13xxx);
+
+	ret = mc13xxx_rtc_irq_enable_unlocked(dev, enabled, irq);
+
+	mc13xxx_unlock(priv->mc13xxx);
+
+	return ret;
+}
+
+static int mc13xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
+	unsigned int seconds, days1, days2;
+	unsigned long s1970;
+	int ret;
+
+	mc13xxx_lock(priv->mc13xxx);
+
+	if (!priv->valid) {
+		ret = -ENODATA;
+		goto out;
+	}
+
+	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCDAY, &days1);
+	if (unlikely(ret))
+		goto out;
+
+	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCTOD, &seconds);
+	if (unlikely(ret))
+		goto out;
+
+	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCDAY, &days2);
+out:
+	mc13xxx_unlock(priv->mc13xxx);
+
+	if (ret)
+		return ret;
+
+	if (days2 == days1 + 1) {
+		if (seconds >= 86400 / 2)
+			days2 = days1;
+		else
+			days1 = days2;
+	}
+
+	if (days1 != days2)
+		return -EIO;
+
+	s1970 = days1 * 86400 + seconds;
+
+	rtc_time_to_tm(s1970, tm);
+
+	return rtc_valid_tm(tm);
+}
+
+static int mc13xxx_rtc_set_mmss(struct device *dev, unsigned long secs)
+{
+	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
+	unsigned int seconds, days;
+	unsigned int alarmseconds;
+	int ret;
+
+	seconds = secs % 86400;
+	days = secs / 86400;
+
+	mc13xxx_lock(priv->mc13xxx);
+
+	/*
+	 * temporarily invalidate alarm to prevent triggering it when the day is
+	 * already updated while the time isn't yet.
+	 */
+	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCTODA, &alarmseconds);
+	if (unlikely(ret))
+		goto out;
+
+	if (alarmseconds < 86400) {
+		ret = mc13xxx_reg_write(priv->mc13xxx,
+				MC13XXX_RTCTODA, 0x1ffff);
+		if (unlikely(ret))
+			goto out;
+	}
+
+	/*
+	 * write seconds=0 to prevent a day switch between writing days
+	 * and seconds below
+	 */
+	ret = mc13xxx_reg_write(priv->mc13xxx, MC13XXX_RTCTOD, 0);
+	if (unlikely(ret))
+		goto out;
+
+	ret = mc13xxx_reg_write(priv->mc13xxx, MC13XXX_RTCDAY, days);
+	if (unlikely(ret))
+		goto out;
+
+	ret = mc13xxx_reg_write(priv->mc13xxx, MC13XXX_RTCTOD, seconds);
+	if (unlikely(ret))
+		goto out;
+
+	/* restore alarm */
+	if (alarmseconds < 86400) {
+		ret = mc13xxx_reg_write(priv->mc13xxx,
+				MC13XXX_RTCTODA, alarmseconds);
+		if (unlikely(ret))
+			goto out;
+	}
+
+	ret = mc13xxx_irq_ack(priv->mc13xxx, MC13XXX_IRQ_RTCRST);
+	if (unlikely(ret))
+		goto out;
+
+	ret = mc13xxx_irq_unmask(priv->mc13xxx, MC13XXX_IRQ_RTCRST);
+out:
+	priv->valid = !ret;
+
+	mc13xxx_unlock(priv->mc13xxx);
+
+	return ret;
+}
+
+static int mc13xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
+	unsigned seconds, days;
+	unsigned long s1970;
+	int enabled, pending;
+	int ret;
+
+	mc13xxx_lock(priv->mc13xxx);
+
+	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCTODA, &seconds);
+	if (unlikely(ret))
+		goto out;
+	if (seconds >= 86400) {
+		ret = -ENODATA;
+		goto out;
+	}
+
+	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCDAY, &days);
+	if (unlikely(ret))
+		goto out;
+
+	ret = mc13xxx_irq_status(priv->mc13xxx, MC13XXX_IRQ_TODA,
+			&enabled, &pending);
+
+out:
+	mc13xxx_unlock(priv->mc13xxx);
+
+	if (ret)
+		return ret;
+
+	alarm->enabled = enabled;
+	alarm->pending = pending;
+
+	s1970 = days * 86400 + seconds;
+
+	rtc_time_to_tm(s1970, &alarm->time);
+	dev_dbg(dev, "%s: %lu\n", __func__, s1970);
+
+	return 0;
+}
+
+static int mc13xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
+	unsigned long s1970;
+	unsigned seconds, days;
+	int ret;
+
+	mc13xxx_lock(priv->mc13xxx);
+
+	/* disable alarm to prevent false triggering */
+	ret = mc13xxx_reg_write(priv->mc13xxx, MC13XXX_RTCTODA, 0x1ffff);
+	if (unlikely(ret))
+		goto out;
+
+	ret = mc13xxx_irq_ack(priv->mc13xxx, MC13XXX_IRQ_TODA);
+	if (unlikely(ret))
+		goto out;
+
+	ret = rtc_tm_to_time(&alarm->time, &s1970);
+	if (unlikely(ret))
+		goto out;
+
+	dev_dbg(dev, "%s: o%2.s %lu\n", __func__, alarm->enabled ? "n" : "ff",
+			s1970);
+
+	ret = mc13xxx_rtc_irq_enable_unlocked(dev, alarm->enabled,
+			MC13XXX_IRQ_TODA);
+	if (unlikely(ret))
+		goto out;
+
+	seconds = s1970 % 86400;
+	days = s1970 / 86400;
+
+	ret = mc13xxx_reg_write(priv->mc13xxx, MC13XXX_RTCDAYA, days);
+	if (unlikely(ret))
+		goto out;
+
+	ret = mc13xxx_reg_write(priv->mc13xxx, MC13XXX_RTCTODA, seconds);
+
+out:
+	mc13xxx_unlock(priv->mc13xxx);
+
+	return ret;
+}
+
+static irqreturn_t mc13xxx_rtc_alarm_handler(int irq, void *dev)
+{
+	struct mc13xxx_rtc *priv = dev;
+	struct mc13xxx *mc13xxx = priv->mc13xxx;
+
+	dev_dbg(&priv->rtc->dev, "Alarm\n");
+
+	rtc_update_irq(priv->rtc, 1, RTC_IRQF | RTC_AF);
+
+	mc13xxx_irq_ack(mc13xxx, irq);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t mc13xxx_rtc_update_handler(int irq, void *dev)
+{
+	struct mc13xxx_rtc *priv = dev;
+	struct mc13xxx *mc13xxx = priv->mc13xxx;
+
+	dev_dbg(&priv->rtc->dev, "1HZ\n");
+
+	rtc_update_irq(priv->rtc, 1, RTC_IRQF | RTC_UF);
+
+	mc13xxx_irq_ack(mc13xxx, irq);
+
+	return IRQ_HANDLED;
+}
+
+static int mc13xxx_rtc_update_irq_enable(struct device *dev,
+		unsigned int enabled)
+{
+	return mc13xxx_rtc_irq_enable(dev, enabled, MC13XXX_IRQ_1HZ);
+}
+
+static int mc13xxx_rtc_alarm_irq_enable(struct device *dev,
+		unsigned int enabled)
+{
+	return mc13xxx_rtc_irq_enable(dev, enabled, MC13XXX_IRQ_TODA);
+}
+
+static const struct rtc_class_ops mc13xxx_rtc_ops = {
+	.read_time = mc13xxx_rtc_read_time,
+	.set_mmss = mc13xxx_rtc_set_mmss,
+	.read_alarm = mc13xxx_rtc_read_alarm,
+	.set_alarm = mc13xxx_rtc_set_alarm,
+	.alarm_irq_enable = mc13xxx_rtc_alarm_irq_enable,
+	.update_irq_enable = mc13xxx_rtc_update_irq_enable,
+};
+
+static irqreturn_t mc13xxx_rtc_reset_handler(int irq, void *dev)
+{
+	struct mc13xxx_rtc *priv = dev;
+	struct mc13xxx *mc13xxx = priv->mc13xxx;
+
+	dev_dbg(&priv->rtc->dev, "RTCRST\n");
+	priv->valid = 0;
+
+	mc13xxx_irq_mask(mc13xxx, irq);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit mc13xxx_rtc_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct mc13xxx_rtc *priv;
+	struct mc13xxx *mc13xxx;
+	int rtcrst_pending;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	mc13xxx = dev_get_drvdata(pdev->dev.parent);
+	priv->mc13xxx = mc13xxx;
+
+	platform_set_drvdata(pdev, priv);
+
+	mc13xxx_lock(mc13xxx);
+
+	ret = mc13xxx_irq_request(mc13xxx, MC13XXX_IRQ_RTCRST,
+			mc13xxx_rtc_reset_handler, DRIVER_NAME, priv);
+	if (ret)
+		goto err_reset_irq_request;
+
+	ret = mc13xxx_irq_status(mc13xxx, MC13XXX_IRQ_RTCRST,
+			NULL, &rtcrst_pending);
+	if (ret)
+		goto err_reset_irq_status;
+
+	priv->valid = !rtcrst_pending;
+
+	ret = mc13xxx_irq_request_nounmask(mc13xxx, MC13XXX_IRQ_1HZ,
+			mc13xxx_rtc_update_handler, DRIVER_NAME, priv);
+	if (ret)
+		goto err_update_irq_request;
+
+	ret = mc13xxx_irq_request_nounmask(mc13xxx, MC13XXX_IRQ_TODA,
+			mc13xxx_rtc_alarm_handler, DRIVER_NAME, priv);
+	if (ret)
+		goto err_alarm_irq_request;
+
+	priv->rtc = rtc_device_register(pdev->name,
+			&pdev->dev, &mc13xxx_rtc_ops, THIS_MODULE);
+	if (IS_ERR(priv->rtc)) {
+		ret = PTR_ERR(priv->rtc);
+
+		mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_TODA, priv);
+err_alarm_irq_request:
+
+		mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_1HZ, priv);
+err_update_irq_request:
+
+err_reset_irq_status:
+
+		mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_RTCRST, priv);
+err_reset_irq_request:
+
+		platform_set_drvdata(pdev, NULL);
+		kfree(priv);
+	}
+
+	mc13xxx_unlock(mc13xxx);
+
+	return ret;
+}
+
+static int __devexit mc13xxx_rtc_remove(struct platform_device *pdev)
+{
+	struct mc13xxx_rtc *priv = platform_get_drvdata(pdev);
+
+	mc13xxx_lock(priv->mc13xxx);
+
+	rtc_device_unregister(priv->rtc);
+
+	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_TODA, priv);
+	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_1HZ, priv);
+	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_RTCRST, priv);
+
+	mc13xxx_unlock(priv->mc13xxx);
+
+	platform_set_drvdata(pdev, NULL);
+
+	kfree(priv);
+
+	return 0;
+}
+
+const struct platform_device_id mc13xxx_rtc_idtable[] = {
+	{
+		.name = "mc13783-rtc",
+	}, {
+		.name = "mc13892-rtc",
+	},
+};
+
+static struct platform_driver mc13xxx_rtc_driver = {
+	.id_table = mc13xxx_rtc_idtable,
+	.remove = __devexit_p(mc13xxx_rtc_remove),
+	.driver = {
+		.name = DRIVER_NAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init mc13xxx_rtc_init(void)
+{
+	return platform_driver_probe(&mc13xxx_rtc_driver, &mc13xxx_rtc_probe);
+}
+module_init(mc13xxx_rtc_init);
+
+static void __exit mc13xxx_rtc_exit(void)
+{
+	platform_driver_unregister(&mc13xxx_rtc_driver);
+}
+module_exit(mc13xxx_rtc_exit);
+
+MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
+MODULE_DESCRIPTION("RTC driver for Freescale MC13XXX PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
-- 
1.7.2.3

