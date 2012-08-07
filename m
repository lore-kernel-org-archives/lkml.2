Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab2HGLWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:22:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58230 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab2HGLWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:22:42 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: amit.kachhap@linaro.org, dg77.kim@samsung.com, guenter.roeck@ericsson.com,
        akpm@linux-foundation.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 3/3] thermal: Exynos: Use devm_* functions
Date: Tue,  7 Aug 2012 16:51:05 +0530
Message-Id: <1344338465-15478-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1344338465-15478-1-git-send-email-sachin.kamat@linaro.org>
References: <1344338465-15478-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* functions are used to replace kzalloc, request_mem_region, ioremap
and request_irq functions in probe call. With the usage of devm_* functions
explicit freeing and unmapping is not required.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
 drivers/thermal/exynos_thermal.c |   51 +++++++------------------------------
 1 files changed, 10 insertions(+), 41 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index 3a7a068..86e4e9f 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -780,7 +780,9 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "No platform init data supplied.\n");
 		return -ENODEV;
 	}
-	data = kzalloc(sizeof(struct exynos_tmu_data), GFP_KERNEL);
+
+	data = devm_kzalloc(&pdev->dev, sizeof(struct exynos_tmu_data),
+								GFP_KERNEL);
 	if (!data) {
 		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
 		return -ENOMEM;
@@ -788,47 +790,29 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 
 	data->irq = platform_get_irq(pdev, 0);
 	if (data->irq < 0) {
-		ret = data->irq;
 		dev_err(&pdev->dev, "Failed to get platform irq\n");
-		goto err_free;
+		return data->irq;
 	}
 
 	INIT_WORK(&data->irq_work, exynos_tmu_work);
 
 	data->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!data->mem) {
-		ret = -ENOENT;
-		dev_err(&pdev->dev, "Failed to get platform resource\n");
-		goto err_free;
-	}
 
-	data->mem = request_mem_region(data->mem->start,
-			resource_size(data->mem), pdev->name);
-	if (!data->mem) {
-		ret = -ENODEV;
-		dev_err(&pdev->dev, "Failed to request memory region\n");
-		goto err_free;
-	}
-
-	data->base = ioremap(data->mem->start, resource_size(data->mem));
-	if (!data->base) {
-		ret = -ENODEV;
-		dev_err(&pdev->dev, "Failed to ioremap memory\n");
-		goto err_mem_region;
-	}
+	data->base = devm_request_and_ioremap(&pdev->dev, data->mem);
+	if (!data->base)
+		return -ENODEV;
 
-	ret = request_irq(data->irq, exynos_tmu_irq,
+	ret = devm_request_irq(&pdev->dev, data->irq, exynos_tmu_irq,
 		IRQF_TRIGGER_RISING, "exynos-tmu", data);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq: %d\n", data->irq);
-		goto err_io_remap;
+		return ret;
 	}
 
 	data->clk = clk_get(NULL, "tmu_apbif");
 	if (IS_ERR(data->clk)) {
-		ret = PTR_ERR(data->clk);
 		dev_err(&pdev->dev, "Failed to get clock\n");
-		goto err_irq;
+		return PTR_ERR(data->clk);
 	}
 
 	if (pdata->type == SOC_ARCH_EXYNOS5 ||
@@ -880,14 +864,6 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 err_clk:
 	platform_set_drvdata(pdev, NULL);
 	clk_put(data->clk);
-err_irq:
-	free_irq(data->irq, data);
-err_io_remap:
-	iounmap(data->base);
-err_mem_region:
-	release_mem_region(data->mem->start, resource_size(data->mem));
-err_free:
-	kfree(data);
 
 	return ret;
 }
@@ -902,15 +878,8 @@ static int __devexit exynos_tmu_remove(struct platform_device *pdev)
 
 	clk_put(data->clk);
 
-	free_irq(data->irq, data);
-
-	iounmap(data->base);
-	release_mem_region(data->mem->start, resource_size(data->mem));
-
 	platform_set_drvdata(pdev, NULL);
 
-	kfree(data);
-
 	return 0;
 }
 
-- 
1.7.4.1

