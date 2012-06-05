Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705Ab2FENTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:19:04 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16324 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934136Ab2FENS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:18:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 05 Jun 2012 06:17:57 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <khali@linux-fr.org>, <w.sang@pengutronix.de>, <ben-linux@fluff.org>,
        <swarren@wwwdotorg.org>, <olof@lixom.net>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 4/4] i2c: tegra: make all resource allocation through devm_*
Date: Tue, 5 Jun 2012 18:40:00 +0530
Message-ID: <1338901800-23968-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1338901800-23968-1-git-send-email-ldewangan@nvidia.com>
References: <1338901800-23968-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the devm_* for the memory region allocation, interrupt request,
clock handler request.
By doing this, it does not require to explicitly free it and hence
saving some code.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This is rebased of earlier similar patch and sending as
part of this series.

 drivers/i2c/busses/i2c-tegra.c |   62 +++++++++++-----------------------------
 1 files changed, 17 insertions(+), 45 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 4cc9594..6745631 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -607,7 +607,6 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 	struct tegra_i2c_dev *i2c_dev;
 	struct tegra_i2c_platform_data *pdata = pdev->dev.platform_data;
 	struct resource *res;
-	struct resource *iomem;
 	struct clk *clk;
 	struct clk *i2c_clk;
 	const unsigned int *prop;
@@ -620,50 +619,41 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
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
@@ -692,13 +682,14 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
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
@@ -716,38 +707,19 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
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

