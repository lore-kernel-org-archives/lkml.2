Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab2EIOTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:19:17 -0400
Received: from relay.sigmatic.fi ([80.69.161.51]:52904 "EHLO relay.sigmatic.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757919Ab2EIOTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:19:15 -0400
From: Hannu Heikkinen <hannuxx@iki.fi>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: a.zummo@towertech.it, swarren@wwwdotorg.org
Subject: [PATCH RESEND] rtc: tegra: cleanup probe/remove routines
Date: Wed,  9 May 2012 17:19:11 +0300
Message-Id: <1336573151-8984-1-git-send-email-hannuxx@iki.fi>
X-Mailer: git-send-email 1.7.10
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannu Heikkinen <ext-hannu.m.heikkinen@nokia.com>

Use the devres managed resource functions in the probe routine.
Affects also in remove routine where previously used free and release
functions are not needed.

The devm_* functions eliminate the need for manual resource releasing
and simplify error handling. Resources allocated by devm_* are freed
automatically on driver detach.

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Hannu Heikkinen <ext-hannu.m.heikkinen@nokia.com>
---
 drivers/rtc/rtc-tegra.c |   50 ++++++++++++-----------------------------------
 1 file changed, 13 insertions(+), 37 deletions(-)

diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index 75259fe..c006025 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -309,7 +309,8 @@ static int __devinit tegra_rtc_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret;
 
-	info = kzalloc(sizeof(struct tegra_rtc_info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(struct tegra_rtc_info),
+		GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
@@ -317,29 +318,18 @@ static int __devinit tegra_rtc_probe(struct platform_device *pdev)
 	if (!res) {
 		dev_err(&pdev->dev,
 			"Unable to allocate resources for device.\n");
-		ret = -EBUSY;
-		goto err_free_info;
+		return -EBUSY;
 	}
 
-	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
-		dev_err(&pdev->dev,
-			"Unable to request mem region for device.\n");
-		ret = -EBUSY;
-		goto err_free_info;
+	info->rtc_base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!info->rtc_base) {
+		dev_err(&pdev->dev, "Unable to request mem region and grab IOs for device.\n");
+		return -EBUSY;
 	}
 
 	info->tegra_rtc_irq = platform_get_irq(pdev, 0);
-	if (info->tegra_rtc_irq <= 0) {
-		ret = -EBUSY;
-		goto err_release_mem_region;
-	}
-
-	info->rtc_base = ioremap_nocache(res->start, resource_size(res));
-	if (!info->rtc_base) {
-		dev_err(&pdev->dev, "Unable to grab IOs for device.\n");
-		ret = -EBUSY;
-		goto err_release_mem_region;
-	}
+	if (info->tegra_rtc_irq <= 0)
+		return -EBUSY;
 
 	/* set context info. */
 	info->pdev = pdev;
@@ -362,11 +352,12 @@ static int __devinit tegra_rtc_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev,
 			"Unable to register device (err=%d).\n",
 			ret);
-		goto err_iounmap;
+		return ret;
 	}
 
-	ret = request_irq(info->tegra_rtc_irq, tegra_rtc_irq_handler,
-		IRQF_TRIGGER_HIGH, "rtc alarm", &pdev->dev);
+	ret = devm_request_irq(&pdev->dev, info->tegra_rtc_irq,
+			tegra_rtc_irq_handler, IRQF_TRIGGER_HIGH,
+			"rtc alarm", &pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev,
 			"Unable to request interrupt for device (err=%d).\n",
@@ -380,12 +371,6 @@ static int __devinit tegra_rtc_probe(struct platform_device *pdev)
 
 err_dev_unreg:
 	rtc_device_unregister(info->rtc_dev);
-err_iounmap:
-	iounmap(info->rtc_base);
-err_release_mem_region:
-	release_mem_region(res->start, resource_size(res));
-err_free_info:
-	kfree(info);
 
 	return ret;
 }
@@ -393,17 +378,8 @@ err_free_info:
 static int __devexit tegra_rtc_remove(struct platform_device *pdev)
 {
 	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
-	struct resource *res;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -EBUSY;
 
-	free_irq(info->tegra_rtc_irq, &pdev->dev);
 	rtc_device_unregister(info->rtc_dev);
-	iounmap(info->rtc_base);
-	release_mem_region(res->start, resource_size(res));
-	kfree(info);
 
 	platform_set_drvdata(pdev, NULL);
 
-- 
1.7.10

