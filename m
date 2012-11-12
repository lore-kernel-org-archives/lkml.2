Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab2KLSsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 13:48:38 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:52734 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab2KLSrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 13:47:18 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [RESEND PATCH v3 4/6] watchdog: omap_wdt: convert ioremap() to devm_ioremap()
Date: Mon, 12 Nov 2012 20:47:03 +0200
Message-Id: <1352746025-1669-5-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352746025-1669-1-git-send-email-aaro.koskinen@iki.fi>
References: <1352746025-1669-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap() to simplify the code.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/omap_wdt.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 45019b0..7e8d3e0 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -255,11 +255,9 @@ static int __devinit omap_wdt_probe(struct platform_device *pdev)
 	wdev->wdt_trgr_pattern	= 0x1234;
 	mutex_init(&wdev->lock);
 
-	wdev->base = ioremap(res->start, resource_size(res));
-	if (!wdev->base) {
-		ret = -ENOMEM;
-		goto err_ioremap;
-	}
+	wdev->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!wdev->base)
+		return -ENOMEM;
 
 	platform_set_drvdata(pdev, omap_wdt);
 
@@ -283,10 +281,6 @@ static int __devinit omap_wdt_probe(struct platform_device *pdev)
 err_misc:
 	pm_runtime_disable(wdev->dev);
 	platform_set_drvdata(pdev, NULL);
-	iounmap(wdev->base);
-
-err_ioremap:
-	wdev->base = NULL;
 
 	return ret;
 }
@@ -314,8 +308,6 @@ static int __devexit omap_wdt_remove(struct platform_device *pdev)
 	watchdog_unregister_device(wdog);
 	platform_set_drvdata(pdev, NULL);
 
-	iounmap(wdev->base);
-
 	return 0;
 }
 
-- 
1.7.2.5

