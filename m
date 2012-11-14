Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab2KNHXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:23:10 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:53098 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab2KNHTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:19:33 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, wenyou.yang@atmel.com, JM.Lin@atmel.com
Subject: [PATCH 02/11] watchdog/at91sam9_wdt: change the at91wdt_private struct to the at91wdt_drvdata struct
Date: Wed, 14 Nov 2012 15:16:00 +0800
Message-Id: <1352877369-19740-3-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
References: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 14 Nov 2012 07:19:20.0556 (UTC) FILETIME=[5D75A2C0:01CDC238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the at91wdt_drvdata struct as the driver data of struct watchdog_device.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/watchdog/at91sam9_wdt.c |   35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 549c256..31c914a 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -66,13 +66,12 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
 
 static void at91_ping(unsigned long data);
 
-static struct {
+struct at91wdt_drvdata {
 	void __iomem *base;
+	bool enabled;			/* indicate if the watchdog is eabled */
 	unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
-	unsigned long open;
-	char expect_close;
 	struct timer_list timer;	/* The timer that pings the watchdog */
-} at91wdt_private;
+};
 
 /* ......................................................................... */
 
@@ -90,10 +89,12 @@ static inline void at91_wdt_reset(void)
  */
 static void at91_ping(unsigned long data)
 {
-	if (time_before(jiffies, at91wdt_private.next_heartbeat) ||
-			(!nowayout && !at91wdt_private.open)) {
+	struct watchdog_device *wddev = (struct watchdog_device *)data;
+	struct at91wdt_drvdata *driver_data = watchdog_get_drvdata(wddev);
+
+	if (time_before(jiffies, driver_data->next_heartbeat))
 		at91_wdt_reset();
-		mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
+		mod_timer(&driver_data->timer, jiffies + WDT_TIMEOUT);
 	} else
 		pr_crit("I will reset your machine !\n");
 }
@@ -138,26 +139,36 @@ static const struct watchdog_info at91_wdt_info = {
 
 static int __init at91wdt_probe(struct platform_device *pdev)
 {
+	struct at91wdt_drvdata *driver_data;
 	struct resource	*r;
 	int res;
 
+	driver_data = devm_kzalloc(&pdev->dev,
+				sizeof(*driver_data), GFP_KERNEL);
+	if (!driver_data) {
+		dev_err(&pdev->dev, "Unable to alloacate watchdog device\n");
+		return -ENOMEM;
+	}
+
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r)
 		return -ENODEV;
-	at91wdt_private.base = ioremap(r->start, resource_size(r));
-	if (!at91wdt_private.base) {
+	driver_data->base = ioremap(r->start, resource_size(r));
+	if (!driver_data->base) {
 		dev_err(&pdev->dev, "failed to map registers, aborting.\n");
 		return -ENOMEM;
 	}
 
+	watchdog_set_drvdata(&at91_wddev, driver_data);
+
 	/* Set watchdog */
 	res = at91_wdt_settimeout(ms_to_ticks(WDT_HW_TIMEOUT * 1000));
 	if (res)
 		return res;
 
-	at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
-	setup_timer(&at91wdt_private.timer, at91_ping, 0);
-	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
+	driver_data->next_heartbeat = jiffies + heartbeat * HZ;
+	setup_timer(&driver_data->timer, at91_ping, 0);
+	mod_timer(&driver_data->timer, jiffies + WDT_TIMEOUT);
 
 	pr_info("enabled (heartbeat=%d sec, nowayout=%d)\n",
 		heartbeat, nowayout);
-- 
1.7.9.5

