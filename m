Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab2KNHTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:19:46 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:28839 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab2KNHTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:19:42 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, wenyou.yang@atmel.com, JM.Lin@atmel.com
Subject: [PATCH 03/11] watchdog/at91sam9_wdt: change the wdt_read and wdt_write macro to the inline function
Date: Wed, 14 Nov 2012 15:16:01 +0800
Message-Id: <1352877369-19740-4-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
References: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 14 Nov 2012 07:19:23.0525 (UTC) FILETIME=[5F3AAB50:01CDC238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/watchdog/at91sam9_wdt.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 31c914a..98e7d5a 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -34,11 +34,6 @@
 
 #define DRV_NAME "AT91SAM9 Watchdog"
 
-#define wdt_read(field) \
-	__raw_readl(at91wdt_private.base + field)
-#define wdt_write(field, val) \
-	__raw_writel((val), at91wdt_private.base + field)
-
 /* AT91SAM9 watchdog runs a 12bit counter @ 256Hz,
  * use this to convert a watchdog
  * value from/to milliseconds.
@@ -75,13 +70,24 @@ struct at91wdt_drvdata {
 
 /* ......................................................................... */
 
+static inline unsigned int wdt_read(struct at91wdt_drvdata *driver_data,
+					unsigned int field)
+{
+	return __raw_readl(driver_data->base + field);
+}
+
+static inline void wdt_write(struct at91wdt_drvdata *driver_data,
+				unsigned int field, unsigned int val)
+{
+	__raw_writel((val), driver_data->base + field);
+}
 
 /*
  * Reload the watchdog timer.  (ie, pat the watchdog)
  */
-static inline void at91_wdt_reset(void)
+static inline void at91_wdt_reset(struct at91wdt_drvdata *driver_data)
 {
-	wdt_write(AT91_WDT_CR, AT91_WDT_KEY | AT91_WDT_WDRSTT);
+	wdt_write(driver_data, AT91_WDT_CR, AT91_WDT_KEY | AT91_WDT_WDRSTT);
 }
 
 /*
@@ -103,13 +109,15 @@ static void at91_ping(unsigned long data)
  * Set the watchdog time interval in 1/256Hz (write-once)
  * Counter is 12 bit.
  */
-static int at91_wdt_settimeout(unsigned int timeout)
+static int at91_wdt_settimeout(struct watchdog_device *wddev,
+					unsigned int timeout)
 {
+	struct at91wdt_drvdata *driver_data = watchdog_get_drvdata(wddev);
 	unsigned int reg;
 	unsigned int mr;
 
 	/* Check if disabled */
-	mr = wdt_read(AT91_WDT_MR);
+	mr = wdt_read(driver_data, AT91_WDT_MR);
 	if (mr & AT91_WDT_WDDIS) {
 		pr_err("sorry, watchdog is disabled\n");
 		return -EIO;
@@ -126,7 +134,7 @@ static int at91_wdt_settimeout(unsigned int timeout)
 		| AT91_WDT_WDDBGHLT	/* disabled in debug mode */
 		| AT91_WDT_WDD		/* restart at any time */
 		| (timeout & AT91_WDT_WDV);  /* timer value */
-	wdt_write(AT91_WDT_MR, reg);
+	wdt_write(driver_data, AT91_WDT_MR, reg);
 
 	return 0;
 }
-- 
1.7.9.5

