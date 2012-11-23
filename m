Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab2KWIse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:48:34 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38235 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148Ab2KWIsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:48:30 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: w.sang@pengutronix.de, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH V2 2/4] i2c: s3c2410: Convert to use devm_* APIs
Date: Fri, 23 Nov 2012 14:11:53 +0530
Message-Id: <1353660115-9710-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353660115-9710-1-git-send-email-tushar.behera@linaro.org>
References: <1353660115-9710-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c-s3c2410 driver is modified to use devm_clk_get(),
devm_request_and_ioremap() (combining request_mem_region() and
ioremap()) and devm_request_irq(). This also simplifies the
return path in driver's probe.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
Changes since V1:
  * devm_request_mem_region and devm_ioremap calls were replaced by
devm_request_and_ioremap() call.
  * All devm_* related modifications (earlier patches 2-5) were merged
to a single patch.

 drivers/i2c/busses/i2c-s3c2410.c |   51 +++++++++-----------------------------
 1 files changed, 12 insertions(+), 39 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 7522f40..a203917 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -78,7 +78,6 @@ struct s3c24xx_i2c {
 	void __iomem		*regs;
 	struct clk		*clk;
 	struct device		*dev;
-	struct resource		*ioarea;
 	struct i2c_adapter	adap;
 
 	struct s3c2410_platform_i2c	*pdata;
@@ -968,7 +967,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	/* find the clock and enable it */
 
 	i2c->dev = &pdev->dev;
-	i2c->clk = clk_get(&pdev->dev, "i2c");
+	i2c->clk = devm_clk_get(&pdev->dev, "i2c");
 	if (IS_ERR(i2c->clk)) {
 		dev_err(&pdev->dev, "cannot get clock\n");
 		return -ENOENT;
@@ -987,25 +986,16 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	i2c->ioarea = request_mem_region(res->start, resource_size(res),
-					 pdev->name);
-
-	if (i2c->ioarea == NULL) {
-		dev_err(&pdev->dev, "cannot request IO\n");
-		ret = -ENXIO;
-		goto err_clk;
-	}
-
-	i2c->regs = ioremap(res->start, resource_size(res));
+	i2c->regs = devm_request_and_ioremap(&pdev->dev, res);
 
 	if (i2c->regs == NULL) {
-		dev_err(&pdev->dev, "cannot map IO\n");
+		dev_err(&pdev->dev, "cannot request and map IO\n");
 		ret = -ENXIO;
-		goto err_ioarea;
+		goto err_clk;
 	}
 
-	dev_dbg(&pdev->dev, "registers %p (%p, %p)\n",
-		i2c->regs, i2c->ioarea, res);
+	dev_dbg(&pdev->dev, "registers %p (%p)\n",
+		i2c->regs, res);
 
 	/* setup info block for the i2c core */
 
@@ -1016,7 +1006,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 
 	ret = s3c24xx_i2c_init(i2c);
 	if (ret != 0)
-		goto err_iomap;
+		goto err_clk;
 
 	/* find the IRQ for this unit (note, this relies on the init call to
 	 * ensure no current IRQs pending
@@ -1025,21 +1015,21 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	i2c->irq = ret = platform_get_irq(pdev, 0);
 	if (ret <= 0) {
 		dev_err(&pdev->dev, "cannot find IRQ\n");
-		goto err_iomap;
+		goto err_clk;
 	}
 
-	ret = request_irq(i2c->irq, s3c24xx_i2c_irq, 0,
-			  dev_name(&pdev->dev), i2c);
+	ret = devm_request_irq(&pdev->dev, i2c->irq, s3c24xx_i2c_irq, 0,
+			       dev_name(&pdev->dev), i2c);
 
 	if (ret != 0) {
 		dev_err(&pdev->dev, "cannot claim IRQ %d\n", i2c->irq);
-		goto err_iomap;
+		goto err_clk;
 	}
 
 	ret = s3c24xx_i2c_register_cpufreq(i2c);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to register cpufreq notifier\n");
-		goto err_irq;
+		goto err_clk;
 	}
 
 	/* Note, previous versions of the driver used i2c_add_adapter()
@@ -1070,19 +1060,8 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
  err_cpufreq:
 	s3c24xx_i2c_deregister_cpufreq(i2c);
 
- err_irq:
-	free_irq(i2c->irq, i2c);
-
- err_iomap:
-	iounmap(i2c->regs);
-
- err_ioarea:
-	release_resource(i2c->ioarea);
-	kfree(i2c->ioarea);
-
  err_clk:
 	clk_disable_unprepare(i2c->clk);
-	clk_put(i2c->clk);
 	return ret;
 }
 
@@ -1101,16 +1080,10 @@ static int s3c24xx_i2c_remove(struct platform_device *pdev)
 	s3c24xx_i2c_deregister_cpufreq(i2c);
 
 	i2c_del_adapter(&i2c->adap);
-	free_irq(i2c->irq, i2c);
 
 	clk_disable_unprepare(i2c->clk);
-	clk_put(i2c->clk);
-
-	iounmap(i2c->regs);
 
-	release_resource(i2c->ioarea);
 	s3c24xx_i2c_dt_gpio_free(i2c);
-	kfree(i2c->ioarea);
 
 	return 0;
 }
-- 
1.7.4.1

