Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab2BQRue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:50:34 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:30627 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2BQRub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:50:31 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/18] ARM: at91/rtc-at91sam9: each SoC can select the RTT device to use
Date: Fri, 17 Feb 2012 18:50:03 +0100
Message-Id: <9d1120bd8f1cf0615ff5044745b00fd3988397a7.1329500622.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

For the RTT as RTC driver rtc-at91sam9, the platform_device structure
is filled during SoC initialization. This will allow to convert this
RTC driver as a standard platform driver.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam9260_devices.c |   11 +++++
 arch/arm/mach-at91/at91sam9261_devices.c |   10 +++++
 arch/arm/mach-at91/at91sam9263_devices.c |   25 ++++++++++++
 arch/arm/mach-at91/at91sam9g45_devices.c |   10 +++++
 arch/arm/mach-at91/at91sam9rl_devices.c  |   10 +++++
 drivers/rtc/rtc-at91sam9.c               |   61 ++++-------------------------
 6 files changed, 75 insertions(+), 52 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index b93a337..2071017 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -728,8 +728,19 @@ static struct platform_device at91sam9260_rtt_device = {
 	.num_resources	= ARRAY_SIZE(rtt_resources),
 };
 
+
+#if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
+static void __init at91_add_device_rtt_rtc(void)
+{
+	at91sam9260_rtt_device.name = "rtc-at91sam9";
+}
+#else
+static void __init at91_add_device_rtt_rtc(void) {}
+#endif
+
 static void __init at91_add_device_rtt(void)
 {
+	at91_add_device_rtt_rtc();
 	platform_device_register(&at91sam9260_rtt_device);
 }
 
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index 52c1f1a..b3ceb97 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -614,8 +614,18 @@ static struct platform_device at91sam9261_rtt_device = {
 	.num_resources	= ARRAY_SIZE(rtt_resources),
 };
 
+#if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
+static void __init at91_add_device_rtt_rtc(void)
+{
+	at91sam9261_rtt_device.name = "rtc-at91sam9";
+}
+#else
+static void __init at91_add_device_rtt_rtc(void) {}
+#endif
+
 static void __init at91_add_device_rtt(void)
 {
+	at91_add_device_rtt_rtc();
 	platform_device_register(&at91sam9261_rtt_device);
 }
 
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index 545826b..b4a6adb 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -992,8 +992,33 @@ static struct platform_device at91sam9263_rtt1_device = {
 	.num_resources	= ARRAY_SIZE(rtt1_resources),
 };
 
+#if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
+static void __init at91_add_device_rtt_rtc(void)
+{
+	struct platform_device *pdev;
+
+	switch (CONFIG_RTC_DRV_AT91SAM9_RTT) {
+	case 0:
+		pdev = &at91sam9263_rtt0_device;
+		break;
+	case 1:
+		pdev = &at91sam9263_rtt1_device;
+		break;
+	default:
+		pr_err("at91sam9263: support only 2 RTT (%d)\n",
+			 CONFIG_RTC_DRV_AT91SAM9_RTT);
+		return;
+	}
+
+	pdev->name = "rtc-at91sam9";
+}
+#else
+static void __init at91_add_device_rtt_rtc(void) {}
+#endif
+
 static void __init at91_add_device_rtt(void)
 {
+	at91_add_device_rtt_rtc();
 	platform_device_register(&at91sam9263_rtt0_device);
 	platform_device_register(&at91sam9263_rtt1_device);
 }
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 8c036ff..81d1adf 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -1204,8 +1204,18 @@ static struct platform_device at91sam9g45_rtt_device = {
 	.num_resources	= ARRAY_SIZE(rtt_resources),
 };
 
+#if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
+static void __init at91_add_device_rtt_rtc(void)
+{
+	at91sam9g45_rtt_device.name = "rtc-at91sam9";
+}
+#else
+static void __init at91_add_device_rtt_rtc(void) {}
+#endif
+
 static void __init at91_add_device_rtt(void)
 {
+	at91_add_device_rtt_rtc();
 	platform_device_register(&at91sam9g45_rtt_device);
 }
 
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 936cf20..dd248c8 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -693,8 +693,18 @@ static struct platform_device at91sam9rl_rtt_device = {
 	.num_resources	= ARRAY_SIZE(rtt_resources),
 };
 
+#if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
+static void __init at91_add_device_rtt_rtc(void)
+{
+	at91sam9rl_rtt_device.name = "rtc-at91sam9";
+}
+#else
+static void __init at91_add_device_rtt_rtc(void) {}
+#endif
+
 static void __init at91_add_device_rtt(void)
 {
+	at91_add_device_rtt_rtc();
 	platform_device_register(&at91sam9rl_rtt_device);
 }
 
diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index a3ad957..65896a3 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -287,7 +287,7 @@ static const struct rtc_class_ops at91_rtc_ops = {
 /*
  * Initialize and install RTC driver
  */
-static int __init at91_rtc_probe(struct platform_device *pdev)
+static int __devinit at91_rtc_probe(struct platform_device *pdev)
 {
 	struct resource	*r;
 	struct sam9_rtc	*rtc;
@@ -360,7 +360,7 @@ fail:
 /*
  * Disable and remove the RTC driver
  */
-static int __exit at91_rtc_remove(struct platform_device *pdev)
+static int __devexit at91_rtc_remove(struct platform_device *pdev)
 {
 	struct sam9_rtc	*rtc = platform_get_drvdata(pdev);
 	u32		mr = rtt_readl(rtc, MR);
@@ -433,63 +433,20 @@ static int at91_rtc_resume(struct platform_device *pdev)
 #endif
 
 static struct platform_driver at91_rtc_driver = {
-	.driver.name	= "rtc-at91sam9",
-	.driver.owner	= THIS_MODULE,
-	.remove		= __exit_p(at91_rtc_remove),
+	.probe		= at91_rtc_probe,
+	.remove		= __devexit_p(at91_rtc_remove),
 	.shutdown	= at91_rtc_shutdown,
 	.suspend	= at91_rtc_suspend,
 	.resume		= at91_rtc_resume,
+	.driver		= {
+		.name	= "rtc-at91sam9",
+		.owner	= THIS_MODULE,
+	},
 };
 
-/* Chips can have more than one RTT module, and they can be used for more
- * than just RTCs.  So we can't just register as "the" RTT driver.
- *
- * A normal approach in such cases is to create a library to allocate and
- * free the modules.  Here we just use bus_find_device() as like such a
- * library, binding directly ... no runtime "library" footprint is needed.
- */
-static int __init at91_rtc_match(struct device *dev, void *v)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	int ret;
-
-	/* continue searching if this isn't the RTT we need */
-	if (strcmp("at91_rtt", pdev->name) != 0
-			|| pdev->id != CONFIG_RTC_DRV_AT91SAM9_RTT)
-		goto fail;
-
-	/* else we found it ... but fail unless we can bind to the RTC driver */
-	if (dev->driver) {
-		dev_dbg(dev, "busy, can't use as RTC!\n");
-		goto fail;
-	}
-	dev->driver = &at91_rtc_driver.driver;
-	if (device_attach(dev) == 0) {
-		dev_dbg(dev, "can't attach RTC!\n");
-		goto fail;
-	}
-	ret = at91_rtc_probe(pdev);
-	if (ret == 0)
-		return true;
-
-	dev_dbg(dev, "RTC probe err %d!\n", ret);
-fail:
-	return false;
-}
-
 static int __init at91_rtc_init(void)
 {
-	int status;
-	struct device *rtc;
-
-	status = platform_driver_register(&at91_rtc_driver);
-	if (status)
-		return status;
-	rtc = bus_find_device(&platform_bus_type, NULL,
-			NULL, at91_rtc_match);
-	if (!rtc)
-		platform_driver_unregister(&at91_rtc_driver);
-	return rtc ? 0 : -ENODEV;
+	return platform_driver_register(&at91_rtc_driver);
 }
 module_init(at91_rtc_init);
 
-- 
1.7.9

