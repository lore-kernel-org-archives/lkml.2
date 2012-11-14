Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab2KNHVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:21:47 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:27354 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab2KNHTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:19:44 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, wenyou.yang@atmel.com, JM.Lin@atmel.com
Subject: [PATCH 05/11] watchdog/at91sam9_wdt: add to use the watchdog framework
Date: Wed, 14 Nov 2012 15:16:03 +0800
Message-Id: <1352877369-19740-6-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
References: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 14 Nov 2012 07:19:31.0525 (UTC) FILETIME=[63FF5F50:01CDC238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the Watchdog Timer Mode Register can be only written only once,
so struct watchdog_info options only support WDIOF_KEEPALIVEPING,
not support WDIOF_SETTIMEOUT and WDIOF_MAGICCLOSE.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/watchdog/Kconfig        |    1 +
 drivers/watchdog/at91sam9_wdt.c |   90 ++++++++++++++++++++++++++++++++-------
 2 files changed, 76 insertions(+), 15 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index ad1bb93..dda695f 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -114,6 +114,7 @@ config AT91RM9200_WATCHDOG
 config AT91SAM9X_WATCHDOG
 	tristate "AT91SAM9X / AT91CAP9 watchdog"
 	depends on ARCH_AT91 && !ARCH_AT91RM9200
+	select WATCHDOG_CORE
 	help
 	  Watchdog timer embedded into AT91SAM9X and AT91CAP9 chips. This will
 	  reboot your system when the timeout is reached.
diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index e2d6111..84c2aa7 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -85,6 +85,11 @@ static inline void wdt_write(struct at91wdt_drvdata *driver_data,
 	__raw_writel((val), driver_data->base + field);
 }
 
+static inline bool watchdog_is_open(struct watchdog_device *wddev)
+{
+	return test_bit(WDOG_DEV_OPEN, &wddev->status);
+}
+
 /*
  * Reload the watchdog timer.  (ie, pat the watchdog)
  */
@@ -101,9 +106,12 @@ static void at91_ping(unsigned long data)
 	struct watchdog_device *wddev = (struct watchdog_device *)data;
 	struct at91wdt_drvdata *driver_data = watchdog_get_drvdata(wddev);
 
-	if (time_before(jiffies, driver_data->next_heartbeat))
-		at91_wdt_reset();
+	if (time_before(jiffies, driver_data->next_heartbeat)) {
+		at91_wdt_reset(driver_data);
 		mod_timer(&driver_data->timer, jiffies + WDT_TIMEOUT);
+
+		if (!watchdog_is_open(wddev))
+			driver_data->next_heartbeat = jiffies + heartbeat * HZ;
 	} else
 		pr_crit("I will reset your machine !\n");
 }
@@ -144,17 +152,62 @@ static int at91wdt_enable(struct watchdog_device *wddev, unsigned int timeout)
 	return 0;
 }
 
-static const struct watchdog_info at91_wdt_info = {
+static int at91wdt_start(struct watchdog_device *wddev)
+{
+	struct at91wdt_drvdata *driver_data = watchdog_get_drvdata(wddev);
+
+	if (driver_data->enabled)
+		return 0;
+	else
+		return -EIO;
+}
+
+static int at91wdt_stop(struct watchdog_device *wddev)
+{
+	struct at91wdt_drvdata *driver_data = watchdog_get_drvdata(wddev);
+
+	if (driver_data->enabled)
+		return -EIO;
+	else
+		return 0;
+}
+
+static int at91wdt_keepalive(struct watchdog_device *wddev)
+{
+	struct at91wdt_drvdata *driver_data = watchdog_get_drvdata(wddev);
+
+	if (driver_data->enabled) {
+		driver_data->next_heartbeat = jiffies + heartbeat * HZ;
+		return 0;
+	} else
+		return -EIO;
+}
+
+/* ......................................................................... */
+
+static const struct watchdog_info at91wdt_info = {
 	.identity	= DRV_NAME,
-	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
-						WDIOF_MAGICCLOSE,
+	.options	= WDIOF_KEEPALIVEPING,
+	.firmware_version	= 0,
+};
+
+static struct watchdog_ops at91wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = at91wdt_start,
+	.stop = at91wdt_stop,
+	.ping = at91wdt_keepalive,
+};
+
+static struct watchdog_device at91_wddev = {
+	.info = &at91wdt_info,
+	.ops = &at91wdt_ops,
 };
 
 static int __init at91wdt_probe(struct platform_device *pdev)
 {
 	struct at91wdt_drvdata *driver_data;
-	struct resource	*r;
-	int res;
+	struct resource	*res;
+	int ret;
 
 	driver_data = devm_kzalloc(&pdev->dev,
 				sizeof(*driver_data), GFP_KERNEL);
@@ -163,10 +216,10 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r)
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
 		return -ENODEV;
-	driver_data->base = ioremap(r->start, resource_size(r));
+	driver_data->base = ioremap(res->start, resource_size(res));
 	if (!driver_data->base) {
 		dev_err(&pdev->dev, "failed to map registers, aborting.\n");
 		return -ENOMEM;
@@ -174,14 +227,21 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 
 	watchdog_set_drvdata(&at91_wddev, driver_data);
 
-	res = at91wdt_enable(&at91_wddev);
-	if (res) {
+	ret = at91wdt_enable(&at91_wddev, ms_to_ticks(WDT_HW_TIMEOUT * 1000));
+	if (ret) {
 		dev_err(&pdev->dev, "cannot enable watchdog (%d)\n", ret);
 		return ret;
 	}
 
+	ret = watchdog_register_device(&at91_wddev);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot register watchdog (%d)\n", ret);
+		return ret;
+	}
+
 	driver_data->next_heartbeat = jiffies + heartbeat * HZ;
-	setup_timer(&driver_data->timer, at91_ping, 0);
+	setup_timer(&driver_data->timer, at91_ping,
+					(unsigned long)&at91_wddev);
 	mod_timer(&driver_data->timer, jiffies + WDT_TIMEOUT);
 
 	pr_info("enabled (heartbeat=%d sec, nowayout=%d)\n",
@@ -192,9 +252,9 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 
 static int __exit at91wdt_remove(struct platform_device *pdev)
 {
-	int res;
+	watchdog_unregister_device(&at91_wddev);
 
-	return res;
+	return 0;
 }
 
 static struct platform_driver at91wdt_driver = {
-- 
1.7.9.5

