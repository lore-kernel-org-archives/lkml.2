Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab2KWMDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:03:33 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65155 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2KWMDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:03:32 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, linux@prisktech.co.nz, patches@linaro.org
Subject: [PATCH] video: vt8505: Use devm_* APIs
Date: Fri, 23 Nov 2012 17:27:13 +0530
Message-Id: <1353671833-14516-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_request_and_ioremap(), dmam_alloc_coherent() APIs to cleanup
driver probe and remove functions. This also fixes a possible memory
leak as the memory allocated by dma_alloc_coherent() was not getting
freed up.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---

This patch has only been build tested.

 drivers/video/wm8505fb.c |   46 +++++++++-------------------------------------
 1 files changed, 9 insertions(+), 37 deletions(-)

diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index 77539c1..95539af 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -281,8 +281,7 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
 			sizeof(u32) * 16, GFP_KERNEL);
 	if (!fbi) {
 		dev_err(&pdev->dev, "Failed to initialize framebuffer device\n");
-		ret = -ENOMEM;
-		goto failed;
+		return -ENOMEM;
 	}
 
 	strcpy(fbi->fb.fix.id, DRIVER_NAME);
@@ -310,29 +309,19 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "no I/O memory resource defined\n");
-		ret = -ENODEV;
-		goto failed_fbi;
+		return -ENODEV;
 	}
 
-	res = request_mem_region(res->start, resource_size(res), DRIVER_NAME);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "failed to request I/O memory\n");
-		ret = -EBUSY;
-		goto failed_fbi;
-	}
-
-	fbi->regbase = ioremap(res->start, resource_size(res));
+	fbi->regbase = devm_request_and_ioremap(&pdev->dev, res);
 	if (fbi->regbase == NULL) {
-		dev_err(&pdev->dev, "failed to map I/O memory\n");
-		ret = -EBUSY;
-		goto failed_free_res;
+		dev_err(&pdev->dev, "failed to request and map I/O memory\n");
+		return -EBUSY;
 	}
 
 	np = of_parse_phandle(pdev->dev.of_node, "default-mode", 0);
 	if (!np) {
 		pr_err("%s: No display description in Device Tree\n", __func__);
-		ret = -EINVAL;
-		goto failed_free_res;
+		return -EINVAL;
 	}
 
 	/*
@@ -351,7 +340,7 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
 	ret |= of_property_read_u32(np, "bpp", &bpp);
 	if (ret) {
 		pr_err("%s: Unable to read display properties\n", __func__);
-		goto failed_free_res;
+		return ret;
 	}
 
 	of_mode.vmode = FB_VMODE_NONINTERLACED;
@@ -365,7 +354,7 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
 
 	/* try allocating the framebuffer */
 	fb_mem_len = of_mode.xres * of_mode.yres * 2 * (bpp / 8);
-	fb_mem_virt = dma_alloc_coherent(&pdev->dev, fb_mem_len, &fb_mem_phys,
+	fb_mem_virt = dmam_alloc_coherent(&pdev->dev, fb_mem_len, &fb_mem_phys,
 				GFP_KERNEL);
 	if (!fb_mem_virt) {
 		pr_err("%s: Failed to allocate framebuffer\n", __func__);
@@ -383,8 +372,7 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
 
 	if (fb_alloc_cmap(&fbi->fb.cmap, 256, 0) < 0) {
 		dev_err(&pdev->dev, "Failed to allocate color map\n");
-		ret = -ENOMEM;
-		goto failed_free_io;
+		return -ENOMEM;
 	}
 
 	wm8505fb_init_hw(&fbi->fb);
@@ -420,21 +408,12 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
 failed_free_cmap:
 	if (fbi->fb.cmap.len)
 		fb_dealloc_cmap(&fbi->fb.cmap);
-failed_free_io:
-	iounmap(fbi->regbase);
-failed_free_res:
-	release_mem_region(res->start, resource_size(res));
-failed_fbi:
-	platform_set_drvdata(pdev, NULL);
-	kfree(fbi);
-failed:
 	return ret;
 }
 
 static int __devexit wm8505fb_remove(struct platform_device *pdev)
 {
 	struct wm8505fb_info *fbi = platform_get_drvdata(pdev);
-	struct resource *res;
 
 	device_remove_file(&pdev->dev, &dev_attr_contrast);
 
@@ -445,13 +424,6 @@ static int __devexit wm8505fb_remove(struct platform_device *pdev)
 	if (fbi->fb.cmap.len)
 		fb_dealloc_cmap(&fbi->fb.cmap);
 
-	iounmap(fbi->regbase);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
-	kfree(fbi);
-
 	return 0;
 }
 
-- 
1.7.4.1

