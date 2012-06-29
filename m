Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab2F2Nah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 09:30:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36738 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab2F2Nag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 09:30:36 -0400
Message-ID: <1340976628.4752.0.camel@phoenix>
Subject: [PATCH 1/4] pwm: Convert pwm-imx to use devm_* APIs
From: Axel Lin <axel.lin@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Date: Fri, 29 Jun 2012 21:30:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/pwm/pwm-imx.c |   55 +++++++++----------------------------------------
 1 file changed, 10 insertions(+), 45 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 900d145..d878c13 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -159,18 +159,16 @@ static int __devinit imx_pwm_probe(struct platform_device *pdev)
 	struct resource *r;
 	int ret = 0;
 
-	imx = kzalloc(sizeof(*imx), GFP_KERNEL);
+	imx = devm_kzalloc(&pdev->dev, sizeof(*imx), GFP_KERNEL);
 	if (imx == NULL) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
 		return -ENOMEM;
 	}
 
-	imx->clk = clk_get(&pdev->dev, "pwm");
+	imx->clk = devm_clk_get(&pdev->dev, "pwm");
 
-	if (IS_ERR(imx->clk)) {
-		ret = PTR_ERR(imx->clk);
-		goto err_free;
-	}
+	if (IS_ERR(imx->clk))
+		return PTR_ERR(imx->clk);
 
 	imx->chip.ops = &imx_pwm_ops;
 	imx->chip.dev = &pdev->dev;
@@ -182,46 +180,24 @@ static int __devinit imx_pwm_probe(struct platform_device *pdev)
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (r == NULL) {
 		dev_err(&pdev->dev, "no memory resource defined\n");
-		ret = -ENODEV;
-		goto err_free_clk;
-	}
-
-	r = request_mem_region(r->start, resource_size(r), pdev->name);
-	if (r == NULL) {
-		dev_err(&pdev->dev, "failed to request memory resource\n");
-		ret = -EBUSY;
-		goto err_free_clk;
+		return -ENODEV;
 	}
 
-	imx->mmio_base = ioremap(r->start, resource_size(r));
-	if (imx->mmio_base == NULL) {
-		dev_err(&pdev->dev, "failed to ioremap() registers\n");
-		ret = -ENODEV;
-		goto err_free_mem;
-	}
+	imx->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
+	if (imx->mmio_base == NULL)
+		return -ENODEV;
 
 	ret = pwmchip_add(&imx->chip);
 	if (ret < 0)
-		goto err_iounmap;
+		return ret;
 
 	platform_set_drvdata(pdev, imx);
 	return 0;
-
-err_iounmap:
-	iounmap(imx->mmio_base);
-err_free_mem:
-	release_mem_region(r->start, resource_size(r));
-err_free_clk:
-	clk_put(imx->clk);
-err_free:
-	kfree(imx);
-	return ret;
 }
 
 static int __devexit imx_pwm_remove(struct platform_device *pdev)
 {
 	struct imx_chip *imx;
-	struct resource *r;
 	int ret;
 
 	imx = platform_get_drvdata(pdev);
@@ -229,18 +205,7 @@ static int __devexit imx_pwm_remove(struct platform_device *pdev)
 		return -ENODEV;
 
 	ret = pwmchip_remove(&imx->chip);
-	if (ret)
-		return ret;
-
-	iounmap(imx->mmio_base);
-
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(r->start, resource_size(r));
-
-	clk_put(imx->clk);
-
-	kfree(imx);
-	return 0;
+	return ret;
 }
 
 static struct platform_driver imx_pwm_driver = {
-- 
1.7.9.5



