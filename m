Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab2JJUXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 16:23:54 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:39209 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094Ab2JJUXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 16:23:45 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH v3 3/6] watchdog: omap_wdt: convert request_mem_region() to devm_request_mem_region()
Date: Wed, 10 Oct 2012 23:23:34 +0300
Message-Id: <1349900617-7035-4-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1349900617-7035-1-git-send-email-aaro.koskinen@iki.fi>
References: <1349900617-7035-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_request_mem_region() to simplify the code.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/watchdog/omap_wdt.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index d6722db..45019b0 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -217,15 +217,14 @@ static int __devinit omap_wdt_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENOENT;
 
-	mem = request_mem_region(res->start, resource_size(res), pdev->name);
+	mem = devm_request_mem_region(&pdev->dev, res->start,
+				      resource_size(res), pdev->name);
 	if (!mem)
 		return -EBUSY;
 
 	wdev = devm_kzalloc(&pdev->dev, sizeof(*wdev), GFP_KERNEL);
-	if (!wdev) {
-		ret = -ENOMEM;
-		goto err_kzalloc;
-	}
+	if (!wdev)
+		return -ENOMEM;
 
 	omap_wdt->info	      = &omap_wdt_info;
 	omap_wdt->ops	      = &omap_wdt_ops;
@@ -289,9 +288,6 @@ err_misc:
 err_ioremap:
 	wdev->base = NULL;
 
-err_kzalloc:
-	release_mem_region(res->start, resource_size(res));
-
 	return ret;
 }
 
@@ -316,7 +312,6 @@ static int __devexit omap_wdt_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(wdev->dev);
 	watchdog_unregister_device(wdog);
-	release_mem_region(res->start, resource_size(res));
 	platform_set_drvdata(pdev, NULL);
 
 	iounmap(wdev->base);
-- 
1.7.2.5

