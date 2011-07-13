Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab1GMUZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:25:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55530 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1GMUZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:25:03 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-watchdog@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wim@iguana.be, tim.bird@am.sony.com,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [RFC 3/6] watchdog: pnx4008: cleanup resource handling using managed devices
Date: Wed, 13 Jul 2011 22:26:03 +0200
Message-Id: <1310588766-16638-4-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1310588766-16638-1-git-send-email-w.sang@pengutronix.de>
References: <1310588766-16638-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The resource handling in this driver was flaky: IO_ADDRESS instead of
ioremap (and no unmapping), an unneeded static resource, no central exit
path for error cases. Fix this by converting the driver to used managed
resources. Also use dev_*-messages instead of printk while we are here.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/watchdog/pnx4008_wdt.c |   70 +++++++++++++++++++---------------------
 1 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 6149332..8e34691 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -89,7 +89,6 @@ static unsigned long wdt_status;
 
 static unsigned long boot_status;
 
-static struct resource	*wdt_mem;
 static void __iomem	*wdt_base;
 struct clk		*wdt_clk;
 
@@ -253,61 +252,62 @@ static struct miscdevice pnx4008_wdt_miscdev = {
 
 static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 {
+	struct resource *r;
 	int ret = 0, size;
 
 	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
 		heartbeat = DEFAULT_HEARTBEAT;
 
-	printk(KERN_INFO MODULE_NAME
-		"PNX4008 Watchdog Timer: heartbeat %d sec\n", heartbeat);
-
-	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (wdt_mem == NULL) {
-		printk(KERN_INFO MODULE_NAME
-			"failed to get memory region resouce\n");
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r) {
+		dev_err(&pdev->dev, "failed to get memory region resouce\n");
 		return -ENOENT;
 	}
 
-	size = resource_size(wdt_mem);
+	size = resource_size(r);
 
-	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {
-		printk(KERN_INFO MODULE_NAME "failed to get memory region\n");
-		return -ENOENT;
+	if (!devm_request_mem_region(&pdev->dev, r->start, size, pdev->name)) {
+		dev_err(&pdev->dev, "failed to get memory region\n");
+		return -ENOMEM;
+	}
+
+	wdt_base = devm_ioremap_nocache(&pdev->dev, r->start, size);
+	if (!wdt_base) {
+		dev_err(&pdev->dev, "ioremap failed\n");
+		return -ENOMEM;
 	}
-	wdt_base = (void __iomem *)IO_ADDRESS(wdt_mem->start);
 
 	wdt_clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(wdt_clk)) {
 		ret = PTR_ERR(wdt_clk);
-		release_mem_region(wdt_mem->start, size);
-		wdt_mem = NULL;
 		goto out;
 	}
 
 	ret = clk_enable(wdt_clk);
-	if (ret) {
-		release_mem_region(wdt_mem->start, size);
-		wdt_mem = NULL;
-		clk_put(wdt_clk);
-		goto out;
-	}
+	if (ret)
+		goto put_clk;
 
 	ret = misc_register(&pnx4008_wdt_miscdev);
 	if (ret < 0) {
-		printk(KERN_ERR MODULE_NAME "cannot register misc device\n");
-		release_mem_region(wdt_mem->start, size);
-		wdt_mem = NULL;
-		clk_disable(wdt_clk);
-		clk_put(wdt_clk);
-	} else {
-		boot_status = (__raw_readl(WDTIM_RES(wdt_base)) & WDOG_RESET) ?
-		    WDIOF_CARDRESET : 0;
-		wdt_disable();		/*disable for now */
-		clk_disable(wdt_clk);
-		set_bit(WDT_DEVICE_INITED, &wdt_status);
+		dev_err(&pdev->dev, "cannot register misc device\n");
+		goto disable_clk;
 	}
 
-out:
+	pnx4008_wdd.bootstatus = (__raw_readl(WDTIM_RES(wdt_base)) &
+		WDOG_RESET) ? WDIOF_CARDRESET : 0;
+	wdt_disable();		/*disable for now */
+	clk_disable(wdt_clk);
+
+	dev_info(&pdev->dev, "PNX4008 Watchdog Timer: heartbeat %d sec\n",
+			heartbeat);
+
+	return 0;
+
+ disable_clk:
+	clk_disable(wdt_clk);
+ put_clk:
+	clk_put(wdt_clk);
+ out:
 	return ret;
 }
 
@@ -318,10 +318,6 @@ static int __devexit pnx4008_wdt_remove(struct platform_device *pdev)
 	clk_disable(wdt_clk);
 	clk_put(wdt_clk);
 
-	if (wdt_mem) {
-		release_mem_region(wdt_mem->start, resource_size(wdt_mem));
-		wdt_mem = NULL;
-	}
 	return 0;
 }
 
-- 
1.7.2.5

