Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab2J1IKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 04:10:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35890 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751058Ab2J1IKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 04:10:37 -0400
From: Joe Perches <joe@perches.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 15/16] watchdog: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
Date: Sun, 28 Oct 2012 01:05:53 -0700
Message-Id: <e77e06add16c9cb82fd359b68f63d7b9f4597ed3.1351411048.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351411047.git.joe@perches.com>
References: <cover.1351411047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
and reducing object size is good.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/watchdog/mpcore_wdt.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 7c741dc..24388c2 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -80,8 +80,7 @@ static irqreturn_t mpcore_wdt_fire(int irq, void *arg)
 
 	/* Check it really was our interrupt */
 	if (readl(wdt->base + TWD_WDOG_INTSTAT)) {
-		dev_printk(KERN_CRIT, wdt->dev,
-					"Triggered - Reboot ignored.\n");
+		dev_crit(wdt->dev, "Triggered - Reboot ignored\n");
 		/* Clear the interrupt on the watchdog */
 		writel(1, wdt->base + TWD_WDOG_INTSTAT);
 		return IRQ_HANDLED;
@@ -123,7 +122,7 @@ static void mpcore_wdt_stop(struct mpcore_wdt *wdt)
 
 static void mpcore_wdt_start(struct mpcore_wdt *wdt)
 {
-	dev_printk(KERN_INFO, wdt->dev, "enabling watchdog.\n");
+	dev_info(wdt->dev, "enabling watchdog\n");
 
 	/* This loads the count register but does NOT start the count yet */
 	mpcore_wdt_keepalive(wdt);
@@ -180,8 +179,8 @@ static int mpcore_wdt_release(struct inode *inode, struct file *file)
 	if (wdt->expect_close == 42)
 		mpcore_wdt_stop(wdt);
 	else {
-		dev_printk(KERN_CRIT, wdt->dev,
-				"unexpected close, not stopping watchdog!\n");
+		dev_crit(wdt->dev,
+			 "unexpected close, not stopping watchdog!\n");
 		mpcore_wdt_keepalive(wdt);
 	}
 	clear_bit(0, &wdt->timer_alive);
@@ -351,9 +350,9 @@ static int __devinit mpcore_wdt_probe(struct platform_device *pdev)
 		ret = devm_request_irq(wdt->dev, wdt->irq, mpcore_wdt_fire, 0,
 				"mpcore_wdt", wdt);
 		if (ret) {
-			dev_printk(KERN_ERR, wdt->dev,
-					"cannot register IRQ%d for watchdog\n",
-					wdt->irq);
+			dev_err(wdt->dev,
+				"cannot register IRQ%d for watchdog\n",
+				wdt->irq);
 			return ret;
 		}
 	}
@@ -365,9 +364,9 @@ static int __devinit mpcore_wdt_probe(struct platform_device *pdev)
 	mpcore_wdt_miscdev.parent = &pdev->dev;
 	ret = misc_register(&mpcore_wdt_miscdev);
 	if (ret) {
-		dev_printk(KERN_ERR, wdt->dev,
+		dev_err(wdt->dev,
 			"cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
+			WATCHDOG_MINOR, ret);
 		return ret;
 	}
 
-- 
1.7.8.112.g3fd21

