Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab2LIRVf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 12:21:35 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:49522
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622Ab2LIRVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 12:21:33 -0500
X-IronPort-AV: E=Sophos;i="4.84,246,1355094000"; 
   d="scan'208";a="165253095"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: kernel-janitors@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/video/vt8500lcdfb.c: use devm_ functions
Date: Sun,  9 Dec 2012 19:21:26 +0100
Message-Id: <1355077286-3871-1-git-send-email-Julia.Lawall@lip6.fr>
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

The error-handing code of devm_request_and_ioremap does not print any
warning message, because devm_request_and_ioremap does this.

The first call to dma_alloc_coherent is converted to its devm equivalent,
dmam_alloc_coherent.  This implicitly introduces a call to
dmam_free_coherent, which was completly missing in the original code.

A semicolon is removed at the end of the error-handling code for the first
call to dma_alloc_coherent.

The block of code calling fb_alloc_cmap is moved below the block of code
calling vt8500lcd_set_par, so that the error-handing code of the call to
vt8500lcd_set_par can just return ret.  This way there is only one block of
error-handling code that needs to call fb_dealloc_cmap, and so this is
moved up to the place where it is needed, eliminating the need for all
gotos and labels in the function.  This was suggested by Tony Prisk.

The initializations of fbi and ret at the beginning of the function are not
necessary and are removed.  The call platform_set_drvdata(pdev, NULL); at
the end of the function is also removed.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Only compiled.  Not tested.

 drivers/video/vt8500lcdfb.c |  107 +++++++++++---------------------------------
 1 file changed, 27 insertions(+), 80 deletions(-)

diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
index 9af8da7..fae2456 100644
--- a/drivers/video/vt8500lcdfb.c
+++ b/drivers/video/vt8500lcdfb.c
@@ -287,15 +287,11 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 	unsigned long fb_mem_len;
 	void *fb_mem_virt;
 
-	ret = -ENOMEM;
-	fbi = NULL;
-
 	fbi = devm_kzalloc(&pdev->dev, sizeof(struct vt8500lcd_info)
-			+ sizeof(u32) * 16, GFP_KERNEL);
+			   + sizeof(u32) * 16, GFP_KERNEL);
 	if (!fbi) {
 		dev_err(&pdev->dev, "Failed to initialize framebuffer device\n");
-		ret = -ENOMEM;
-		goto failed;
+		return -ENOMEM;
 	}
 
 	strcpy(fbi->fb.fix.id, "VT8500 LCD");
@@ -326,31 +322,15 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 	fbi->fb.pseudo_palette	= addr;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "no I/O memory resource defined\n");
-		ret = -ENODEV;
-		goto failed_fbi;
-	}
 
-	res = request_mem_region(res->start, resource_size(res), "vt8500lcd");
-	if (res == NULL) {
-		dev_err(&pdev->dev, "failed to request I/O memory\n");
-		ret = -EBUSY;
-		goto failed_fbi;
-	}
-
-	fbi->regbase = ioremap(res->start, resource_size(res));
-	if (fbi->regbase == NULL) {
-		dev_err(&pdev->dev, "failed to map I/O memory\n");
-		ret = -EBUSY;
-		goto failed_free_res;
-	}
+	fbi->regbase = devm_request_and_ioremap(&pdev->dev, res);
+	if (fbi->regbase == NULL)
+		return -EBUSY;
 
 	np = of_parse_phandle(pdev->dev.of_node, "default-mode", 0);
 	if (!np) {
 		pr_err("%s: No display description in Device Tree\n", __func__);
-		ret = -EINVAL;
-		goto failed_free_res;
+		return -EINVAL;
 	}
 
 	/*
@@ -369,54 +349,44 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 	ret |= of_property_read_u32(np, "bpp", &bpp);
 	if (ret) {
 		pr_err("%s: Unable to read display properties\n", __func__);
-		goto failed_free_res;
+		return ret;
 	}
 	of_mode.vmode = FB_VMODE_NONINTERLACED;
 
 	/* try allocating the framebuffer */
 	fb_mem_len = of_mode.xres * of_mode.yres * 2 * (bpp / 8);
-	fb_mem_virt = dma_alloc_coherent(&pdev->dev, fb_mem_len, &fb_mem_phys,
+	fb_mem_virt = dmam_alloc_coherent(&pdev->dev, fb_mem_len, &fb_mem_phys,
 				GFP_KERNEL);
 	if (!fb_mem_virt) {
 		pr_err("%s: Failed to allocate framebuffer\n", __func__);
 		return -ENOMEM;
-	};
+	}
 
 	fbi->fb.fix.smem_start	= fb_mem_phys;
 	fbi->fb.fix.smem_len	= fb_mem_len;
 	fbi->fb.screen_base	= fb_mem_virt;
 
 	fbi->palette_size	= PAGE_ALIGN(512);
-	fbi->palette_cpu	= dma_alloc_coherent(&pdev->dev,
+	fbi->palette_cpu	= dmam_alloc_coherent(&pdev->dev,
 						     fbi->palette_size,
 						     &fbi->palette_phys,
 						     GFP_KERNEL);
 	if (fbi->palette_cpu == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate palette buffer\n");
-		ret = -ENOMEM;
-		goto failed_free_io;
+		return -ENOMEM;
 	}
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_err(&pdev->dev, "no IRQ defined\n");
-		ret = -ENODEV;
-		goto failed_free_palette;
+		return -ENODEV;
 	}
 
-	ret = request_irq(irq, vt8500lcd_handle_irq, 0, "LCD", fbi);
+	ret = devm_request_irq(&pdev->dev, irq, vt8500lcd_handle_irq, 0,
+			       "LCD", fbi);
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed: %d\n", ret);
-		ret = -EBUSY;
-		goto failed_free_palette;
-	}
-
-	init_waitqueue_head(&fbi->wait);
-
-	if (fb_alloc_cmap(&fbi->fb.cmap, 256, 0) < 0) {
-		dev_err(&pdev->dev, "Failed to allocate color map\n");
-		ret = -ENOMEM;
-		goto failed_free_irq;
+		return -EBUSY;
 	}
 
 	fb_videomode_to_var(&fbi->fb.var, &of_mode);
@@ -428,7 +398,14 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 	ret = vt8500lcd_set_par(&fbi->fb);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to set parameters\n");
-		goto failed_free_cmap;
+		return ret;
+	}
+
+	init_waitqueue_head(&fbi->wait);
+
+	if (fb_alloc_cmap(&fbi->fb.cmap, 256, 0) < 0) {
+		dev_err(&pdev->dev, "Failed to allocate color map\n");
+		return -ENOMEM;
 	}
 
 	writel(fbi->fb.fix.smem_start >> 22, fbi->regbase + 0x1c);
@@ -440,7 +417,10 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev,
 			"Failed to register framebuffer device: %d\n", ret);
-		goto failed_free_cmap;
+		if (fbi->fb.cmap.len)
+			fb_dealloc_cmap(&fbi->fb.cmap);
+		platform_set_drvdata(pdev, NULL);
+		return ret;
 	}
 
 	/*
@@ -449,31 +429,11 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 	writel(readl(fbi->regbase) | 1, fbi->regbase);
 
 	return 0;
-
-failed_free_cmap:
-	if (fbi->fb.cmap.len)
-		fb_dealloc_cmap(&fbi->fb.cmap);
-failed_free_irq:
-	free_irq(irq, fbi);
-failed_free_palette:
-	dma_free_coherent(&pdev->dev, fbi->palette_size,
-			  fbi->palette_cpu, fbi->palette_phys);
-failed_free_io:
-	iounmap(fbi->regbase);
-failed_free_res:
-	release_mem_region(res->start, resource_size(res));
-failed_fbi:
-	platform_set_drvdata(pdev, NULL);
-	kfree(fbi);
-failed:
-	return ret;
 }
 
 static int __devexit vt8500lcd_remove(struct platform_device *pdev)
 {
 	struct vt8500lcd_info *fbi = platform_get_drvdata(pdev);
-	struct resource *res;
-	int irq;
 
 	unregister_framebuffer(&fbi->fb);
 
@@ -482,19 +442,6 @@ static int __devexit vt8500lcd_remove(struct platform_device *pdev)
 	if (fbi->fb.cmap.len)
 		fb_dealloc_cmap(&fbi->fb.cmap);
 
-	irq = platform_get_irq(pdev, 0);
-	free_irq(irq, fbi);
-
-	dma_free_coherent(&pdev->dev, fbi->palette_size,
-			  fbi->palette_cpu, fbi->palette_phys);
-
-	iounmap(fbi->regbase);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
-	kfree(fbi);
-
 	return 0;
 }
 

