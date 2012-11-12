Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab2KLSrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 13:47:21 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:52724 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab2KLSrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 13:47:17 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [RESEND PATCH v3 2/6] watchdog: omap_wdt: convert kzalloc() to devm_kzalloc()
Date: Mon, 12 Nov 2012 20:47:01 +0200
Message-Id: <1352746025-1669-3-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352746025-1669-1-git-send-email-aaro.koskinen@iki.fi>
References: <1352746025-1669-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to simplify the code.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/omap_wdt.c |   23 ++++++-----------------
 1 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index d28ad5e..d6722db 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -208,24 +208,20 @@ static int __devinit omap_wdt_probe(struct platform_device *pdev)
 	struct omap_wdt_dev *wdev;
 	int ret;
 
-	omap_wdt = kzalloc(sizeof(*omap_wdt), GFP_KERNEL);
+	omap_wdt = devm_kzalloc(&pdev->dev, sizeof(*omap_wdt), GFP_KERNEL);
 	if (!omap_wdt)
 		return -ENOMEM;
 
 	/* reserve static register mappings */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		ret = -ENOENT;
-		goto err_get_resource;
-	}
+	if (!res)
+		return -ENOENT;
 
 	mem = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (!mem) {
-		ret = -EBUSY;
-		goto err_busy;
-	}
+	if (!mem)
+		return -EBUSY;
 
-	wdev = kzalloc(sizeof(struct omap_wdt_dev), GFP_KERNEL);
+	wdev = devm_kzalloc(&pdev->dev, sizeof(*wdev), GFP_KERNEL);
 	if (!wdev) {
 		ret = -ENOMEM;
 		goto err_kzalloc;
@@ -292,14 +288,10 @@ err_misc:
 
 err_ioremap:
 	wdev->base = NULL;
-	kfree(wdev);
 
 err_kzalloc:
 	release_mem_region(res->start, resource_size(res));
 
-err_busy:
-err_get_resource:
-	kfree(omap_wdt);
 	return ret;
 }
 
@@ -329,9 +321,6 @@ static int __devexit omap_wdt_remove(struct platform_device *pdev)
 
 	iounmap(wdev->base);
 
-	kfree(wdev);
-	kfree(wdog);
-
 	return 0;
 }
 
-- 
1.7.2.5

