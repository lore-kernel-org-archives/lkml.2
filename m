Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab2KNHVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:21:48 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:10645 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab2KNHTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:19:44 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, wenyou.yang@atmel.com, JM.Lin@atmel.com
Subject: [PATCH 06/11] watchdog/at91sam9_wdt: change the timer function name
Date: Wed, 14 Nov 2012 15:16:04 +0800
Message-Id: <1352877369-19740-7-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
References: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 14 Nov 2012 07:19:34.0447 (UTC) FILETIME=[65BD3BF0:01CDC238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the timer function name "at91_ping" to "at91wdt_timer_tick"
as an appropriate name, and change at91_wdt_reset to at91wdt_reset

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/watchdog/at91sam9_wdt.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 84c2aa7..d764f36 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -62,8 +62,6 @@ module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
 	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-static void at91_ping(unsigned long data);
-
 struct at91wdt_drvdata {
 	void __iomem *base;
 	bool enabled;			/* indicate if the watchdog is eabled */
@@ -90,24 +88,18 @@ static inline bool watchdog_is_open(struct watchdog_device *wddev)
 	return test_bit(WDOG_DEV_OPEN, &wddev->status);
 }
 
-/*
- * Reload the watchdog timer.  (ie, pat the watchdog)
- */
-static inline void at91_wdt_reset(struct at91wdt_drvdata *driver_data)
+static inline void at91wdt_reset(struct at91wdt_drvdata *driver_data)
 {
 	wdt_write(driver_data, AT91_WDT_CR, AT91_WDT_KEY | AT91_WDT_WDRSTT);
 }
 
-/*
- * Timer tick
- */
-static void at91_ping(unsigned long data)
+static void at91wdt_timer_tick(unsigned long data)
 {
 	struct watchdog_device *wddev = (struct watchdog_device *)data;
 	struct at91wdt_drvdata *driver_data = watchdog_get_drvdata(wddev);
 
 	if (time_before(jiffies, driver_data->next_heartbeat)) {
-		at91_wdt_reset(driver_data);
+		at91wdt_reset(driver_data);
 		mod_timer(&driver_data->timer, jiffies + WDT_TIMEOUT);
 
 		if (!watchdog_is_open(wddev))
@@ -240,7 +232,7 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 	}
 
 	driver_data->next_heartbeat = jiffies + heartbeat * HZ;
-	setup_timer(&driver_data->timer, at91_ping,
+	setup_timer(&driver_data->timer, at91wdt_timer_tick,
 					(unsigned long)&at91_wddev);
 	mod_timer(&driver_data->timer, jiffies + WDT_TIMEOUT);
 
-- 
1.7.9.5

