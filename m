Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab2JIGGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:06:03 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49201 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab2JIGDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:03:34 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 23/30] thermal: exynos: Use devm_* functions
Date: Tue,  9 Oct 2012 01:54:13 -0400
Message-Id: <79e093c3fe9de9fe0743a53e4809f481d2719060.1349761836.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc1
In-Reply-To: <1349762060-25334-1-git-send-email-lenb@kernel.org>
References: <1349762060-25334-1-git-send-email-lenb@kernel.org>
In-Reply-To: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
References: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Daniel Kachhap <amit.kachhap@linaro.org>

devm_* functions are used to replace kzalloc, request_mem_region, ioremap
and request_irq functions in probe call. With the usage of devm_* functions
explicit freeing and unmapping is not required.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/thermal/exynos_thermal.c | 45 ++++++++--------------------------------
 1 file changed, 9 insertions(+), 36 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index 03a99e4..e84acde 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -842,7 +842,8 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "No platform init data supplied.\n");
 		return -ENODEV;
 	}
-	data = kzalloc(sizeof(struct exynos_tmu_data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(struct exynos_tmu_data),
+					GFP_KERNEL);
 	if (!data) {
 		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
 		return -ENOMEM;
@@ -850,47 +851,35 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 
 	data->irq = platform_get_irq(pdev, 0);
 	if (data->irq < 0) {
-		ret = data->irq;
 		dev_err(&pdev->dev, "Failed to get platform irq\n");
-		goto err_free;
+		return data->irq;
 	}
 
 	INIT_WORK(&data->irq_work, exynos_tmu_work);
 
 	data->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!data->mem) {
-		ret = -ENOENT;
 		dev_err(&pdev->dev, "Failed to get platform resource\n");
-		goto err_free;
+		return -ENOENT;
 	}
 
-	data->mem = request_mem_region(data->mem->start,
-			resource_size(data->mem), pdev->name);
-	if (!data->mem) {
-		ret = -ENODEV;
-		dev_err(&pdev->dev, "Failed to request memory region\n");
-		goto err_free;
-	}
-
-	data->base = ioremap(data->mem->start, resource_size(data->mem));
+	data->base = devm_request_and_ioremap(&pdev->dev, data->mem);
 	if (!data->base) {
-		ret = -ENODEV;
 		dev_err(&pdev->dev, "Failed to ioremap memory\n");
-		goto err_mem_region;
+		return -ENODEV;
 	}
 
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
+		return  PTR_ERR(data->clk);
 	}
 
 	if (pdata->type == SOC_ARCH_EXYNOS ||
@@ -942,15 +931,6 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
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
-
 	return ret;
 }
 
@@ -964,15 +944,8 @@ static int __devexit exynos_tmu_remove(struct platform_device *pdev)
 
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
1.8.0.rc1

