Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab2KNHTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:19:45 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:15316 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab2KNHTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:19:42 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, wenyou.yang@atmel.com, JM.Lin@atmel.com
Subject: [PATCH 04/11] watchdog/at91sam9_wdt: change "at91_wdt_settimeout" function name to "at91wdt_enable"
Date: Wed, 14 Nov 2012 15:16:02 +0800
Message-Id: <1352877369-19740-5-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
References: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 14 Nov 2012 07:19:26.0619 (UTC) FILETIME=[6112C6B0:01CDC238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the "at91_wdt_settimeout" function name to "at91wdt_enable" for more reasonable,
and also set the drvdata->enabled value.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/watchdog/at91sam9_wdt.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 98e7d5a..e2d6111 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -13,6 +13,9 @@
  * The Watchdog Timer Mode Register can be only written to once. If the
  * timeout need to be set from Linux, be sure that the bootstrap or the
  * bootloader doesn't write to this register.
+ * The Watchdog Timer default is running with maximum counter value
+ * (WDV=0xfff) at reset, i.e., at power-up. It MUST be either disabled
+ * or be reprogrammed within the maxinum margin(16s).
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -105,20 +108,20 @@ static void at91_ping(unsigned long data)
 		pr_crit("I will reset your machine !\n");
 }
 
-/*
- * Set the watchdog time interval in 1/256Hz (write-once)
- * Counter is 12 bit.
- */
-static int at91_wdt_settimeout(struct watchdog_device *wddev,
-					unsigned int timeout)
+static int at91wdt_enable(struct watchdog_device *wddev, unsigned int timeout)
 {
 	struct at91wdt_drvdata *driver_data = watchdog_get_drvdata(wddev);
 	unsigned int reg;
 	unsigned int mr;
 
-	/* Check if disabled */
+	/* Check if the watchdog is disabled,
+	 * if disabled, the reason is the bootstrap or the bootloader has
+	 * written the Watchdog Timer Mode Register to disable the
+	 * watchdog timer
+	 */
 	mr = wdt_read(driver_data, AT91_WDT_MR);
 	if (mr & AT91_WDT_WDDIS) {
+		driver_data->enabled = false;
 		pr_err("sorry, watchdog is disabled\n");
 		return -EIO;
 	}
@@ -136,6 +139,8 @@ static int at91_wdt_settimeout(struct watchdog_device *wddev,
 		| (timeout & AT91_WDT_WDV);  /* timer value */
 	wdt_write(driver_data, AT91_WDT_MR, reg);
 
+	driver_data->enabled = true;
+
 	return 0;
 }
 
@@ -169,10 +174,11 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 
 	watchdog_set_drvdata(&at91_wddev, driver_data);
 
-	/* Set watchdog */
-	res = at91_wdt_settimeout(ms_to_ticks(WDT_HW_TIMEOUT * 1000));
-	if (res)
-		return res;
+	res = at91wdt_enable(&at91_wddev);
+	if (res) {
+		dev_err(&pdev->dev, "cannot enable watchdog (%d)\n", ret);
+		return ret;
+	}
 
 	driver_data->next_heartbeat = jiffies + heartbeat * HZ;
 	setup_timer(&driver_data->timer, at91_ping, 0);
-- 
1.7.9.5

