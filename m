Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab2EGGrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 02:47:25 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12787 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab2EGGrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 02:47:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 06 May 2012 23:47:23 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: =khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        swarren@wwwdotorg.org, olof@lixom.net, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V1 1/2] i2c: tegra: make all resource allocation through devm_*
Date: Mon,  7 May 2012 12:14:05 +0530
Message-Id: <1336373047-12654-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the devm_* for the memory region allocation, interrupt request,
clock handler request.
By doing this, it does not require to explicitly free it and hence
saving some code.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/i2c/busses/i2c-tegra.c |   64 ++++++++++-----------------------------
 1 files changed, 17 insertions(+), 47 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 18067b3..390d379 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -106,7 +106,6 @@
  * @adapter: core i2c layer adapter information
  * @clk: clock reference for i2c controller
  * @i2c_clk: clock reference for i2c bus
- * @iomem: memory resource for registers
  * @base: ioremapped registers cookie
  * @cont_id: i2c controller id, used for for packet header
  * @irq: irq number of transfer complete interrupt
@@ -124,7 +123,6 @@ struct tegra_i2c_dev {
 	struct i2c_adapter adapter;
 	struct clk *clk;
 	struct clk *i2c_clk;
-	struct resource *iomem;
 	void __iomem *base;
 	int cont_id;
 	int irq;
@@ -573,7 +571,6 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 	struct tegra_i2c_dev *i2c_dev;
 	struct tegra_i2c_platform_data *pdata = pdev->dev.platform_data;
 	struct resource *res;
-	struct resource *iomem;
 	struct clk *clk;
 	struct clk *i2c_clk;
 	const unsigned int *prop;
@@ -586,50 +583,41 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "no mem resource\n");
 		return -EINVAL;
 	}
-	iomem = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (!iomem) {
-		dev_err(&pdev->dev, "I2C region already claimed\n");
-		return -EBUSY;
-	}
 
-	base = ioremap(iomem->start, resource_size(iomem));
+	base = devm_request_and_ioremap(&pdev->dev, res);
 	if (!base) {
-		dev_err(&pdev->dev, "Cannot ioremap I2C region\n");
-		return -ENOMEM;
+		dev_err(&pdev->dev, "Cannot request/ioremap I2C registers\n");
+		return -EADDRNOTAVAIL;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "no irq resource\n");
-		ret = -EINVAL;
-		goto err_iounmap;
+		return -EINVAL;
 	}
 	irq = res->start;
 
-	clk = clk_get(&pdev->dev, NULL);
+	clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "missing controller clock");
-		ret = PTR_ERR(clk);
-		goto err_release_region;
+		return PTR_ERR(clk);
 	}
 
-	i2c_clk = clk_get(&pdev->dev, "i2c");
+	i2c_clk = devm_clk_get(&pdev->dev, "i2c");
 	if (IS_ERR(i2c_clk)) {
 		dev_err(&pdev->dev, "missing bus clock");
-		ret = PTR_ERR(i2c_clk);
-		goto err_clk_put;
+		return PTR_ERR(i2c_clk);
 	}
 
-	i2c_dev = kzalloc(sizeof(struct tegra_i2c_dev), GFP_KERNEL);
+	i2c_dev = devm_kzalloc(&pdev->dev, sizeof(*i2c_dev), GFP_KERNEL);
 	if (!i2c_dev) {
-		ret = -ENOMEM;
-		goto err_i2c_clk_put;
+		dev_err(&pdev->dev, "Could not allocate struct tegra_i2c_dev");
+		return -ENOMEM;
 	}
 
 	i2c_dev->base = base;
 	i2c_dev->clk = clk;
 	i2c_dev->i2c_clk = i2c_clk;
-	i2c_dev->iomem = iomem;
 	i2c_dev->adapter.algo = &tegra_i2c_algo;
 	i2c_dev->irq = irq;
 	i2c_dev->cont_id = pdev->id;
@@ -658,13 +646,14 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 	ret = tegra_i2c_init(i2c_dev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to initialize i2c controller");
-		goto err_free;
+		return ret;
 	}
 
-	ret = request_irq(i2c_dev->irq, tegra_i2c_isr, 0, pdev->name, i2c_dev);
+	ret = devm_request_irq(&pdev->dev, i2c_dev->irq,
+			tegra_i2c_isr, 0, pdev->name, i2c_dev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq %i\n", i2c_dev->irq);
-		goto err_free;
+		return ret;
 	}
 
 	clk_enable(i2c_dev->i2c_clk);
@@ -682,38 +671,19 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 	ret = i2c_add_numbered_adapter(&i2c_dev->adapter);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to add I2C adapter\n");
-		goto err_free_irq;
+		clk_disable(i2c_dev->i2c_clk);
+		return ret;
 	}
 
 	of_i2c_register_devices(&i2c_dev->adapter);
 
 	return 0;
-err_free_irq:
-	free_irq(i2c_dev->irq, i2c_dev);
-err_free:
-	kfree(i2c_dev);
-err_i2c_clk_put:
-	clk_put(i2c_clk);
-err_clk_put:
-	clk_put(clk);
-err_release_region:
-	release_mem_region(iomem->start, resource_size(iomem));
-err_iounmap:
-	iounmap(base);
-	return ret;
 }
 
 static int __devexit tegra_i2c_remove(struct platform_device *pdev)
 {
 	struct tegra_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
 	i2c_del_adapter(&i2c_dev->adapter);
-	free_irq(i2c_dev->irq, i2c_dev);
-	clk_put(i2c_dev->i2c_clk);
-	clk_put(i2c_dev->clk);
-	release_mem_region(i2c_dev->iomem->start,
-		resource_size(i2c_dev->iomem));
-	iounmap(i2c_dev->base);
-	kfree(i2c_dev);
 	return 0;
 }
 
-- 
1.7.1.1

