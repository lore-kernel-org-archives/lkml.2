Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab2F2Nb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 09:31:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43878 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab2F2Nb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 09:31:28 -0400
Message-ID: <1340976682.4752.1.camel@phoenix>
Subject: [PATCH 2/4] pwm: Convert pwm-pxa to use devm_* APIs
From: Axel Lin <axel.lin@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 29 Jun 2012 21:31:22 +0800
In-Reply-To: <1340976628.4752.0.camel@phoenix>
References: <1340976628.4752.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/pwm/pwm-pxa.c |   49 ++++++++++---------------------------------------
 1 file changed, 10 insertions(+), 39 deletions(-)

diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
index d5c6ce5..1cf0597 100644
--- a/drivers/pwm/pwm-pxa.c
+++ b/drivers/pwm/pwm-pxa.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/arm/mach-pxa/pwm.c
+ * drivers/pwm/pwm-pxa.c
  *
  * simple driver for PWM (Pulse Width Modulator) controller
  *
@@ -145,17 +145,16 @@ static int __devinit pwm_probe(struct platform_device *pdev)
 	struct resource *r;
 	int ret = 0;
 
-	pwm = kzalloc(sizeof(*pwm), GFP_KERNEL);
+	pwm = devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
 	if (pwm == NULL) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
 		return -ENOMEM;
 	}
 
-	pwm->clk = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(pwm->clk)) {
-		ret = PTR_ERR(pwm->clk);
-		goto err_free;
-	}
+	pwm->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(pwm->clk))
+		return PTR_ERR(pwm->clk);
+
 	pwm->clk_enabled = 0;
 
 	pwm->chip.dev = &pdev->dev;
@@ -166,23 +165,12 @@ static int __devinit pwm_probe(struct platform_device *pdev)
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
 
-	pwm->mmio_base = ioremap(r->start, resource_size(r));
-	if (pwm->mmio_base == NULL) {
-		dev_err(&pdev->dev, "failed to ioremap() registers\n");
-		ret = -ENODEV;
-		goto err_free_mem;
-	}
+	pwm->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
+	if (pwm->mmio_base == NULL)
+		return -ENODEV;
 
 	ret = pwmchip_add(&pwm->chip);
 	if (ret < 0) {
@@ -192,34 +180,17 @@ static int __devinit pwm_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, pwm);
 	return 0;
-
-err_free_mem:
-	release_mem_region(r->start, resource_size(r));
-err_free_clk:
-	clk_put(pwm->clk);
-err_free:
-	kfree(pwm);
-	return ret;
 }
 
 static int __devexit pwm_remove(struct platform_device *pdev)
 {
 	struct pxa_pwm_chip *chip;
-	struct resource *r;
 
 	chip = platform_get_drvdata(pdev);
 	if (chip == NULL)
 		return -ENODEV;
 
 	pwmchip_remove(&chip->chip);
-
-	iounmap(chip->mmio_base);
-
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(r->start, resource_size(r));
-
-	clk_put(chip->clk);
-	kfree(chip);
 	return 0;
 }
 
-- 
1.7.9.5



