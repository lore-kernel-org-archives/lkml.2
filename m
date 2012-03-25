Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab2CYQ4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 12:56:22 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39989 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756560Ab2CYQ4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 12:56:20 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Inki Dae <inki.dae@samsung.com>
Cc: kernel-janitors@vger.kernel.org, Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/gpu/drm/exynos: use devm_ functions
Date: Sun, 25 Mar 2012 18:56:11 +0200
Message-Id: <1332694571-18004-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc, devm_request_irq, etc. for data
that is allocated in the probe function of a platform device and is only
freed in the remove function.

This patch changes the semantics in the case of exynos_hdmi.c, in that in
the original code, there was no free of drm_hdmi_ctx in the remove function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   48 +++++----------------------
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c |    3 -
 drivers/gpu/drm/exynos/exynos_drm_vidi.c |    4 --
 drivers/gpu/drm/exynos/exynos_hdmi.c     |   54 ++++++-------------------------
 4 files changed, 23 insertions(+), 86 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index ecb6db2..223cabe 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -806,15 +806,14 @@ static int __devinit fimd_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
 	ctx->bus_clk = clk_get(dev, "fimd");
 	if (IS_ERR(ctx->bus_clk)) {
 		dev_err(dev, "failed to get bus clock\n");
-		ret = PTR_ERR(ctx->bus_clk);
-		goto err_clk_get;
+		return PTR_ERR(ctx->bus_clk);
 	}
 
 	ctx->lcd_clk = clk_get(dev, "sclk_fimd");
@@ -825,39 +824,27 @@ static int __devinit fimd_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "failed to find registers\n");
-		ret = -ENOENT;
-		goto err_clk;
-	}
 
-	ctx->regs_res = request_mem_region(res->start, resource_size(res),
-					   dev_name(dev));
-	if (!ctx->regs_res) {
-		dev_err(dev, "failed to claim register region\n");
-		ret = -ENOENT;
-		goto err_clk;
-	}
-
-	ctx->regs = ioremap(res->start, resource_size(res));
+	ctx->regs = devm_request_and_ioremap(&pdev->dev, res);
 	if (!ctx->regs) {
-		dev_err(dev, "failed to map registers\n");
+		dev_err(dev, "failed to claim region or map registers\n");
 		ret = -ENXIO;
-		goto err_req_region_io;
+		goto err_clk;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
 		dev_err(dev, "irq request failed.\n");
-		goto err_req_region_irq;
+		goto err_clk;
 	}
 
 	ctx->irq = res->start;
 
-	ret = request_irq(ctx->irq, fimd_irq_handler, 0, "drm_fimd", ctx);
+	ret = devm_request_irq(&pdev->dev, ctx->irq, fimd_irq_handler, 0,
+			       "drm_fimd", ctx);
 	if (ret < 0) {
 		dev_err(dev, "irq request failed.\n");
-		goto err_req_irq;
+		goto err_clk;
 	}
 
 	ctx->vidcon0 = pdata->vidcon0;
@@ -895,14 +882,6 @@ static int __devinit fimd_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_req_irq:
-err_req_region_irq:
-	iounmap(ctx->regs);
-
-err_req_region_io:
-	release_resource(ctx->regs_res);
-	kfree(ctx->regs_res);
-
 err_clk:
 	clk_disable(ctx->lcd_clk);
 	clk_put(ctx->lcd_clk);
@@ -911,8 +890,6 @@ err_bus_clk:
 	clk_disable(ctx->bus_clk);
 	clk_put(ctx->bus_clk);
 
-err_clk_get:
-	kfree(ctx);
 	return ret;
 }
 
@@ -940,13 +917,6 @@ out:
 	clk_put(ctx->lcd_clk);
 	clk_put(ctx->bus_clk);
 
-	iounmap(ctx->regs);
-	release_resource(ctx->regs_res);
-	kfree(ctx->regs_res);
-	free_irq(ctx->irq, ctx);
-
-	kfree(ctx);
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_hdmi.c b/drivers/gpu/drm/exynos/exynos_drm_hdmi.c
index 14eb26b..263cad4 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_hdmi.c
@@ -324,7 +324,7 @@ static int __devinit exynos_drm_hdmi_probe(struct platform_device *pdev)
 
 	DRM_DEBUG_KMS("%s\n", __FILE__);
 
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
 	if (!ctx) {
 		DRM_LOG_KMS("failed to alloc common hdmi context.\n");
 		return -ENOMEM;
@@ -372,7 +372,6 @@ static int __devexit exynos_drm_hdmi_remove(struct platform_device *pdev)
 	DRM_DEBUG_KMS("%s\n", __FILE__);
 
 	exynos_drm_subdrv_unregister(&ctx->subdrv);
-	kfree(ctx);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/exynos/exynos_drm_vidi.c b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
index 8e1339f..bab567b 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
@@ -599,7 +599,7 @@ static int __devinit vidi_probe(struct platform_device *pdev)
 
 	DRM_DEBUG_KMS("%s\n", __FILE__);
 
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
@@ -640,8 +640,6 @@ static int __devexit vidi_remove(struct platform_device *pdev)
 
 	exynos_drm_subdrv_unregister(&ctx->subdrv);
 
-	kfree(ctx);
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 575a8cb..dfe1692 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -2225,16 +2225,17 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	drm_hdmi_ctx = kzalloc(sizeof(*drm_hdmi_ctx), GFP_KERNEL);
+	drm_hdmi_ctx = devm_kzalloc(&pdev->dev, sizeof(*drm_hdmi_ctx),
+				    GFP_KERNEL);
 	if (!drm_hdmi_ctx) {
 		DRM_ERROR("failed to allocate common hdmi context.\n");
 		return -ENOMEM;
 	}
 
-	hdata = kzalloc(sizeof(struct hdmi_context), GFP_KERNEL);
+	hdata = devm_kzalloc(&pdev->dev, sizeof(struct hdmi_context),
+			     GFP_KERNEL);
 	if (!hdata) {
 		DRM_ERROR("out of memory\n");
-		kfree(drm_hdmi_ctx);
 		return -ENOMEM;
 	}
 
@@ -2250,38 +2251,23 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 	hdata->dev = dev;
 
 	ret = hdmi_resources_init(hdata);
-	if (ret) {
-		ret = -EINVAL;
-		goto err_data;
-	}
+	if (ret)
+		return -EINVAL;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		DRM_ERROR("failed to find registers\n");
-		ret = -ENOENT;
-		goto err_resource;
-	}
 
-	hdata->regs_res = request_mem_region(res->start, resource_size(res),
-					   dev_name(dev));
-	if (!hdata->regs_res) {
-		DRM_ERROR("failed to claim register region\n");
-		ret = -ENOENT;
-		goto err_resource;
-	}
-
-	hdata->regs = ioremap(res->start, resource_size(res));
+	hdata->regs = devm_request_and_ioremap(&pdev->dev, res);
 	if (!hdata->regs) {
-		DRM_ERROR("failed to map registers\n");
+		DRM_ERROR("failed to claim region or map registers\n");
 		ret = -ENXIO;
-		goto err_req_region;
+		goto err_resource;
 	}
 
 	/* DDC i2c driver */
 	if (i2c_add_driver(&ddc_driver)) {
 		DRM_ERROR("failed to register ddc i2c driver\n");
 		ret = -ENOENT;
-		goto err_iomap;
+		goto err_resource;
 	}
 
 	hdata->ddc_port = hdmi_ddc;
@@ -2313,8 +2299,8 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 	INIT_WORK(&hdata->hotplug_work, hdmi_hotplug_func);
 
 	/* register hpd interrupt */
-	ret = request_irq(res->start, hdmi_irq_handler, 0, "drm_hdmi",
-				drm_hdmi_ctx);
+	ret = devm_request_irq(&pdev->dev, res->start, hdmi_irq_handler, 0,
+			       "drm_hdmi", drm_hdmi_ctx);
 	if (ret) {
 		DRM_ERROR("request interrupt failed.\n");
 		goto err_workqueue;
@@ -2335,16 +2321,8 @@ err_hdmiphy:
 	i2c_del_driver(&hdmiphy_driver);
 err_ddc:
 	i2c_del_driver(&ddc_driver);
-err_iomap:
-	iounmap(hdata->regs);
-err_req_region:
-	release_mem_region(hdata->regs_res->start,
-			resource_size(hdata->regs_res));
 err_resource:
 	hdmi_resources_cleanup(hdata);
-err_data:
-	kfree(hdata);
-	kfree(drm_hdmi_ctx);
 	return ret;
 }
 
@@ -2358,25 +2336,17 @@ static int __devexit hdmi_remove(struct platform_device *pdev)
 	hdmi_resource_poweroff(hdata);
 
 	disable_irq(hdata->irq);
-	free_irq(hdata->irq, hdata);
 
 	cancel_work_sync(&hdata->hotplug_work);
 	destroy_workqueue(hdata->wq);
 
 	hdmi_resources_cleanup(hdata);
 
-	iounmap(hdata->regs);
-
-	release_mem_region(hdata->regs_res->start,
-			resource_size(hdata->regs_res));
-
 	/* hdmiphy i2c driver */
 	i2c_del_driver(&hdmiphy_driver);
 	/* DDC i2c driver */
 	i2c_del_driver(&ddc_driver);
 
-	kfree(hdata);
-
 	return 0;
 }
 

