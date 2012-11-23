Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab2KWIsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:48:45 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57928 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758209Ab2KWIsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:48:41 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: w.sang@pengutronix.de, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH V2 3/4] i2c: s3c2410: Move location of clk_prepare_enable() call in probe function
Date: Fri, 23 Nov 2012 14:11:54 +0530
Message-Id: <1353660115-9710-4-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353660115-9710-1-git-send-email-tushar.behera@linaro.org>
References: <1353660115-9710-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In i2c-s3c2410 driver probe, only s3c24xx_i2c_init() needs the I2C clock
to be enabled. Moving clk_prepare_enable() and clk_disable_unprepare()
calls to around this function simplifies the return path of probe call.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
Changes since V1:
  * Rebased as per the V2 patch series.

 drivers/i2c/busses/i2c-s3c2410.c |   26 +++++++++++---------------
 1 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index a203917..3f2d632 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -975,23 +975,20 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "clock source %p\n", i2c->clk);
 
-	clk_prepare_enable(i2c->clk);
 
 	/* map the registers */
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "cannot find IO resource\n");
-		ret = -ENOENT;
-		goto err_clk;
+		return -ENOENT;
 	}
 
 	i2c->regs = devm_request_and_ioremap(&pdev->dev, res);
 
 	if (i2c->regs == NULL) {
 		dev_err(&pdev->dev, "cannot request and map IO\n");
-		ret = -ENXIO;
-		goto err_clk;
+		return -ENXIO;
 	}
 
 	dev_dbg(&pdev->dev, "registers %p (%p)\n",
@@ -1004,10 +1001,13 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 
 	/* initialise the i2c controller */
 
+	clk_prepare_enable(i2c->clk);
 	ret = s3c24xx_i2c_init(i2c);
-	if (ret != 0)
-		goto err_clk;
-
+	clk_disable_unprepare(i2c->clk);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "I2C controller init failed\n");
+		return ret;
+	}
 	/* find the IRQ for this unit (note, this relies on the init call to
 	 * ensure no current IRQs pending
 	 */
@@ -1015,7 +1015,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	i2c->irq = ret = platform_get_irq(pdev, 0);
 	if (ret <= 0) {
 		dev_err(&pdev->dev, "cannot find IRQ\n");
-		goto err_clk;
+		return ret;
 	}
 
 	ret = devm_request_irq(&pdev->dev, i2c->irq, s3c24xx_i2c_irq, 0,
@@ -1023,13 +1023,13 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 
 	if (ret != 0) {
 		dev_err(&pdev->dev, "cannot claim IRQ %d\n", i2c->irq);
-		goto err_clk;
+		return ret;
 	}
 
 	ret = s3c24xx_i2c_register_cpufreq(i2c);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to register cpufreq notifier\n");
-		goto err_clk;
+		return ret;
 	}
 
 	/* Note, previous versions of the driver used i2c_add_adapter()
@@ -1054,14 +1054,10 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	pm_runtime_enable(&i2c->adap.dev);
 
 	dev_info(&pdev->dev, "%s: S3C I2C adapter\n", dev_name(&i2c->adap.dev));
-	clk_disable_unprepare(i2c->clk);
 	return 0;
 
  err_cpufreq:
 	s3c24xx_i2c_deregister_cpufreq(i2c);
-
- err_clk:
-	clk_disable_unprepare(i2c->clk);
 	return ret;
 }
 
-- 
1.7.4.1

