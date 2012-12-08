Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965352Ab2LHPbg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 10:31:36 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:6705 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215Ab2LHPbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 10:31:34 -0500
X-IronPort-AV: E=Sophos;i="4.84,243,1355094000"; 
   d="scan'208";a="185236119"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: kernel-janitors@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/video/wm8505fb.c: use devm_ functions
Date: Sat,  8 Dec 2012 17:31:28 +0100
Message-Id: <1354984288-773-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

The patch makes some other cleanups.  First, the original code used
devm_kzalloc, but kfree.  This would lead to a double free.  The problem
was found using the following semantic match (http://coccinelle.lip6.fr/):

// <smpl>
@@
expression x,e;
@@
x = devm_kzalloc(...)
... when != x = e
?-kfree(x,...);
// </smpl>

The error-handling code for the call to dma_alloc_coherent is copied to the
end of the function, like the other error-handling code.  Given the
introduction of the devm functions, this is just for uniformity, because
the label at the end of the function now just returns the error code.

A semicolon is removed at the end of this error handling code.

The call platform_set_drvdata(pdev, NULL); is moved up under the label
failed_free_cmap, because platform_set_drvdata(pdev, fbi); doesn't happen
in the function until after gotos to this label are reached.

The initializations of fbi and ret are not necessary and are removed.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/video/wm8505fb.c |   44 ++++++++------------------------------------
 1 file changed, 8 insertions(+), 36 deletions(-)

diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index 77539c1..3bad805 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -274,9 +274,6 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
 	unsigned long fb_mem_len;
 	void *fb_mem_virt;
 
-	ret = -ENOMEM;
-	fbi = NULL;
-
 	fbi = devm_kzalloc(&pdev->dev, sizeof(struct wm8505fb_info) +
 			sizeof(u32) * 16, GFP_KERNEL);
 	if (!fbi) {
@@ -308,31 +305,19 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
 	fbi->fb.pseudo_palette	= addr;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "no I/O memory resource defined\n");
-		ret = -ENODEV;
-		goto failed_fbi;
-	}
-
-	res = request_mem_region(res->start, resource_size(res), DRIVER_NAME);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "failed to request I/O memory\n");
-		ret = -EBUSY;
-		goto failed_fbi;
-	}
 
-	fbi->regbase = ioremap(res->start, resource_size(res));
+	fbi->regbase = devm_request_and_ioremap(&pdev->dev, res);
 	if (fbi->regbase == NULL) {
 		dev_err(&pdev->dev, "failed to map I/O memory\n");
 		ret = -EBUSY;
-		goto failed_free_res;
+		goto failed;
 	}
 
 	np = of_parse_phandle(pdev->dev.of_node, "default-mode", 0);
 	if (!np) {
 		pr_err("%s: No display description in Device Tree\n", __func__);
 		ret = -EINVAL;
-		goto failed_free_res;
+		goto failed;
 	}
 
 	/*
@@ -351,7 +336,7 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
 	ret |= of_property_read_u32(np, "bpp", &bpp);
 	if (ret) {
 		pr_err("%s: Unable to read display properties\n", __func__);
-		goto failed_free_res;
+		goto failed;
 	}
 
 	of_mode.vmode = FB_VMODE_NONINTERLACED;
@@ -369,8 +354,9 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
 				GFP_KERNEL);
 	if (!fb_mem_virt) {
 		pr_err("%s: Failed to allocate framebuffer\n", __func__);
-		return -ENOMEM;
-	};
+		ret = -ENOMEM;
+		goto failed;
+	}
 
 	fbi->fb.var.xres_virtual	= of_mode.xres;
 	fbi->fb.var.yres_virtual	= of_mode.yres * 2;
@@ -384,7 +370,7 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
 	if (fb_alloc_cmap(&fbi->fb.cmap, 256, 0) < 0) {
 		dev_err(&pdev->dev, "Failed to allocate color map\n");
 		ret = -ENOMEM;
-		goto failed_free_io;
+		goto failed;
 	}
 
 	wm8505fb_init_hw(&fbi->fb);
@@ -420,13 +406,7 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
 failed_free_cmap:
 	if (fbi->fb.cmap.len)
 		fb_dealloc_cmap(&fbi->fb.cmap);
-failed_free_io:
-	iounmap(fbi->regbase);
-failed_free_res:
-	release_mem_region(res->start, resource_size(res));
-failed_fbi:
 	platform_set_drvdata(pdev, NULL);
-	kfree(fbi);
 failed:
 	return ret;
 }
@@ -434,7 +414,6 @@ failed:
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
 

