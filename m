Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab2DOK1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 06:27:42 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:45533 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab2DOK1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 06:27:40 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: kernel-janitors@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/watchdog/ar7_wdt.c: use devm_request_and_ioremap
Date: Sun, 15 Apr 2012 12:27:33 +0200
Message-Id: <1334485653-13860-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Combine request_region and ioremap into devm_request_and_ioremap.  This has
the effect of fixing a missing iounmap on the failure of clk_get.

This also introduces a call to clk_put and clears the vbus_clk variable in
the case of failure or device removal.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Perhaps the call to clk_put is not necessary.  If it is not wanted, I can
remove it.

 drivers/watchdog/ar7_wdt.c |   35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 639ae9a..425c403 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -280,31 +280,17 @@ static int __devinit ar7_wdt_probe(struct platform_device *pdev)
 
 	ar7_regs_wdt =
 		platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
-	if (!ar7_regs_wdt) {
-		pr_err("could not get registers resource\n");
-		rc = -ENODEV;
-		goto out;
-	}
-
-	if (!request_mem_region(ar7_regs_wdt->start,
-				resource_size(ar7_regs_wdt), LONGNAME)) {
-		pr_warn("watchdog I/O region busy\n");
-		rc = -EBUSY;
-		goto out;
-	}
 
-	ar7_wdt = ioremap(ar7_regs_wdt->start, resource_size(ar7_regs_wdt));
+	ar7_wdt = devm_request_and_ioremap(&pdev->dev, ar7_regs_wdt);
 	if (!ar7_wdt) {
 		pr_err("could not ioremap registers\n");
-		rc = -ENXIO;
-		goto out_mem_region;
+		return -ENXIO;
 	}
 
 	vbus_clk = clk_get(NULL, "vbus");
 	if (IS_ERR(vbus_clk)) {
 		pr_err("could not get vbus clock\n");
-		rc = PTR_ERR(vbus_clk);
-		goto out_mem_region;
+		return PTR_ERR(vbus_clk);
 	}
 
 	ar7_wdt_disable_wdt();
@@ -314,24 +300,21 @@ static int __devinit ar7_wdt_probe(struct platform_device *pdev)
 	rc = misc_register(&ar7_wdt_miscdev);
 	if (rc) {
 		pr_err("unable to register misc device\n");
-		goto out_alloc;
+		goto out;
 	}
-	goto out;
+	return 0;
 
-out_alloc:
-	iounmap(ar7_wdt);
-out_mem_region:
-	release_mem_region(ar7_regs_wdt->start, resource_size(ar7_regs_wdt));
 out:
+	clk_put(vbus_clk);
+	vbus_clk = NULL;
 	return rc;
 }
 
 static int __devexit ar7_wdt_remove(struct platform_device *pdev)
 {
 	misc_deregister(&ar7_wdt_miscdev);
-	iounmap(ar7_wdt);
-	release_mem_region(ar7_regs_wdt->start, resource_size(ar7_regs_wdt));
-
+	clk_put(vbus_clk);
+	vbus_clk = NULL;
 	return 0;
 }
 

