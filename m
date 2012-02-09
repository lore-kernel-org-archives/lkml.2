Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab2BIKpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 05:45:22 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:56496 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab2BIKpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 05:45:19 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: kernel-janitors@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/media/video/s5p-tv/*_drv.c: use devm_ functions
Date: Thu,  9 Feb 2012 11:45:11 +0100
Message-Id: <1328784311-27272-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1328784311-27272-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1328784311-27272-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/video/s5p-tv/hdmi_drv.c |   30 ++++++++++--------------------
 drivers/media/video/s5p-tv/sdo_drv.c  |   26 +++++++++-----------------
 2 files changed, 19 insertions(+), 37 deletions(-)

diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c b/drivers/media/video/s5p-tv/hdmi_drv.c
index 3e0dd09..6c21dc6 100644
--- a/drivers/media/video/s5p-tv/hdmi_drv.c
+++ b/drivers/media/video/s5p-tv/hdmi_drv.c
@@ -875,7 +875,7 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 
 	dev_dbg(dev, "probe start\n");
 
-	hdmi_dev = kzalloc(sizeof(*hdmi_dev), GFP_KERNEL);
+	hdmi_dev = devm_kzalloc(&pdev->dev, sizeof(*hdmi_dev), GFP_KERNEL);
 	if (!hdmi_dev) {
 		dev_err(dev, "out of memory\n");
 		ret = -ENOMEM;
@@ -886,7 +886,7 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 
 	ret = hdmi_resources_init(hdmi_dev);
 	if (ret)
-		goto fail_hdev;
+		goto fail;
 
 	/* mapping HDMI registers */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -896,24 +896,26 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 		goto fail_init;
 	}
 
-	hdmi_dev->regs = ioremap(res->start, resource_size(res));
+	hdmi_dev->regs = devm_ioremap(&pdev->dev, res->start,
+				      resource_size(res));
 	if (hdmi_dev->regs == NULL) {
 		dev_err(dev, "register mapping failed.\n");
 		ret = -ENXIO;
-		goto fail_hdev;
+		goto fail;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res == NULL) {
 		dev_err(dev, "get interrupt resource failed.\n");
 		ret = -ENXIO;
-		goto fail_regs;
+		goto fail_init;
 	}
 
-	ret = request_irq(res->start, hdmi_irq_handler, 0, "hdmi", hdmi_dev);
+	ret = devm_request_irq(&pdev->dev, res->start, hdmi_irq_handler, 0,
+			       "hdmi", hdmi_dev);
 	if (ret) {
 		dev_err(dev, "request interrupt failed.\n");
-		goto fail_regs;
+		goto fail_init;
 	}
 	hdmi_dev->irq = res->start;
 
@@ -924,7 +926,7 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 	ret = v4l2_device_register(NULL, &hdmi_dev->v4l2_dev);
 	if (ret) {
 		dev_err(dev, "could not register v4l2 device.\n");
-		goto fail_irq;
+		goto fail_init;
 	}
 
 	drv_data = (struct hdmi_driver_data *)
@@ -969,18 +971,9 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 fail_vdev:
 	v4l2_device_unregister(&hdmi_dev->v4l2_dev);
 
-fail_irq:
-	free_irq(hdmi_dev->irq, hdmi_dev);
-
-fail_regs:
-	iounmap(hdmi_dev->regs);
-
 fail_init:
 	hdmi_resources_cleanup(hdmi_dev);
 
-fail_hdev:
-	kfree(hdmi_dev);
-
 fail:
 	dev_err(dev, "probe failed\n");
 	return ret;
@@ -996,10 +989,7 @@ static int __devexit hdmi_remove(struct platform_device *pdev)
 	clk_disable(hdmi_dev->res.hdmi);
 	v4l2_device_unregister(&hdmi_dev->v4l2_dev);
 	disable_irq(hdmi_dev->irq);
-	free_irq(hdmi_dev->irq, hdmi_dev);
-	iounmap(hdmi_dev->regs);
 	hdmi_resources_cleanup(hdmi_dev);
-	kfree(hdmi_dev);
 	dev_info(dev, "remove successful\n");
 
 	return 0;
diff --git a/drivers/media/video/s5p-tv/sdo_drv.c b/drivers/media/video/s5p-tv/sdo_drv.c
index 059e774..f6bca2c 100644
--- a/drivers/media/video/s5p-tv/sdo_drv.c
+++ b/drivers/media/video/s5p-tv/sdo_drv.c
@@ -301,7 +301,7 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	struct clk *sclk_vpll;
 
 	dev_info(dev, "probe start\n");
-	sdev = kzalloc(sizeof *sdev, GFP_KERNEL);
+	sdev = devm_kzalloc(&pdev->dev, sizeof *sdev, GFP_KERNEL);
 	if (!sdev) {
 		dev_err(dev, "not enough memory.\n");
 		ret = -ENOMEM;
@@ -314,14 +314,14 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	if (res == NULL) {
 		dev_err(dev, "get memory resource failed.\n");
 		ret = -ENXIO;
-		goto fail_sdev;
+		goto fail;
 	}
 
-	sdev->regs = ioremap(res->start, resource_size(res));
+	sdev->regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (sdev->regs == NULL) {
 		dev_err(dev, "register mapping failed.\n");
 		ret = -ENXIO;
-		goto fail_sdev;
+		goto fail;
 	}
 
 	/* acquiring interrupt */
@@ -329,12 +329,13 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	if (res == NULL) {
 		dev_err(dev, "get interrupt resource failed.\n");
 		ret = -ENXIO;
-		goto fail_regs;
+		goto fail;
 	}
-	ret = request_irq(res->start, sdo_irq_handler, 0, "s5p-sdo", sdev);
+	ret = devm_request_irq(&pdev->dev, res->start, sdo_irq_handler, 0,
+			       "s5p-sdo", sdev);
 	if (ret) {
 		dev_err(dev, "request interrupt failed.\n");
-		goto fail_regs;
+		goto fail;
 	}
 	sdev->irq = res->start;
 
@@ -343,7 +344,7 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	if (IS_ERR_OR_NULL(sdev->sclk_dac)) {
 		dev_err(dev, "failed to get clock 'sclk_dac'\n");
 		ret = -ENXIO;
-		goto fail_irq;
+		goto fail;
 	}
 	sdev->dac = clk_get(dev, "dac");
 	if (IS_ERR_OR_NULL(sdev->dac)) {
@@ -415,12 +416,6 @@ fail_dac:
 	clk_put(sdev->dac);
 fail_sclk_dac:
 	clk_put(sdev->sclk_dac);
-fail_irq:
-	free_irq(sdev->irq, sdev);
-fail_regs:
-	iounmap(sdev->regs);
-fail_sdev:
-	kfree(sdev);
 fail:
 	dev_info(dev, "probe failed\n");
 	return ret;
@@ -439,9 +434,6 @@ static int __devexit sdo_remove(struct platform_device *pdev)
 	clk_put(sdev->dacphy);
 	clk_put(sdev->dac);
 	clk_put(sdev->sclk_dac);
-	free_irq(sdev->irq, sdev);
-	iounmap(sdev->regs);
-	kfree(sdev);
 
 	dev_info(&pdev->dev, "remove successful\n");
 	return 0;

