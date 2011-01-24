Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab1AXTgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:36:21 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:36290 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab1AXTgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:36:19 -0500
From: Julia Lawall <julia@diku.dk>
To: Paul Mundt <lethal@linux-sh.org>
Cc: kernel-janitors@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Bryan Wu <cooloney@kernel.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] drivers/video/bf537-lq035.c: Add missing IS_ERR test
Date: Mon, 24 Jan 2011 20:55:21 +0100
Message-Id: <1295898922-18822-4-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295898922-18822-1-git-send-email-julia@diku.dk>
References: <1295898922-18822-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lcd_device_register may return ERR_PTR, so a check is added for this value
before the dereference.  All of the other changes reorganize the error
handling code in this function to avoid duplicating all of it in the added
case.

In the original code, in one case, the global variable fb_buffer was set to
NULL in error code that appears after this variable is initialized.  This
is done now in all error handling code that has this property.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier f;
@@
f(...) { ... return ERR_PTR(...); }

@@
identifier r.f, fld;
expression x;
statement S1,S2;
@@
 x = f(...)
 ... when != IS_ERR(x)
(
 if (IS_ERR(x) ||...) S1 else S2
|
*x->fld
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/bf537-lq035.c |   58 +++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 25 deletions(-)

diff --git a/drivers/video/bf537-lq035.c b/drivers/video/bf537-lq035.c
index 18c5078..47c21fb 100644
--- a/drivers/video/bf537-lq035.c
+++ b/drivers/video/bf537-lq035.c
@@ -696,6 +696,7 @@ static int __devinit bfin_lq035_probe(struct platform_device *pdev)
 {
 	struct backlight_properties props;
 	dma_addr_t dma_handle;
+	int ret;
 
 	if (request_dma(CH_PPI, KBUILD_MODNAME)) {
 		pr_err("couldn't request PPI DMA\n");
@@ -704,17 +705,16 @@ static int __devinit bfin_lq035_probe(struct platform_device *pdev)
 
 	if (request_ports()) {
 		pr_err("couldn't request gpio port\n");
-		free_dma(CH_PPI);
-		return -EFAULT;
+		ret = -EFAULT;
+		goto out_ports;
 	}
 
 	fb_buffer = dma_alloc_coherent(NULL, TOTAL_VIDEO_MEM_SIZE,
 				       &dma_handle, GFP_KERNEL);
 	if (fb_buffer == NULL) {
 		pr_err("couldn't allocate dma buffer\n");
-		free_dma(CH_PPI);
-		free_ports();
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_dma_coherent;
 	}
 
 	if (L1_DATA_A_LENGTH)
@@ -725,10 +725,8 @@ static int __devinit bfin_lq035_probe(struct platform_device *pdev)
 
 	if (dma_desc_table == NULL) {
 		pr_err("couldn't allocate dma descriptor\n");
-		free_dma(CH_PPI);
-		free_ports();
-		dma_free_coherent(NULL, TOTAL_VIDEO_MEM_SIZE, fb_buffer, 0);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_table;
 	}
 
 	bfin_lq035_fb.screen_base = (void *)fb_buffer;
@@ -771,31 +769,21 @@ static int __devinit bfin_lq035_probe(struct platform_device *pdev)
 	bfin_lq035_fb.pseudo_palette = kzalloc(sizeof(u32) * 16, GFP_KERNEL);
 	if (bfin_lq035_fb.pseudo_palette == NULL) {
 		pr_err("failed to allocate pseudo_palette\n");
-		free_dma(CH_PPI);
-		free_ports();
-		dma_free_coherent(NULL, TOTAL_VIDEO_MEM_SIZE, fb_buffer, 0);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_palette;
 	}
 
 	if (fb_alloc_cmap(&bfin_lq035_fb.cmap, NBR_PALETTE, 0) < 0) {
 		pr_err("failed to allocate colormap (%d entries)\n",
 			NBR_PALETTE);
-		free_dma(CH_PPI);
-		free_ports();
-		dma_free_coherent(NULL, TOTAL_VIDEO_MEM_SIZE, fb_buffer, 0);
-		kfree(bfin_lq035_fb.pseudo_palette);
-		return -EFAULT;
+		ret = -EFAULT;
+		goto out_cmap;
 	}
 
 	if (register_framebuffer(&bfin_lq035_fb) < 0) {
 		pr_err("unable to register framebuffer\n");
-		free_dma(CH_PPI);
-		free_ports();
-		dma_free_coherent(NULL, TOTAL_VIDEO_MEM_SIZE, fb_buffer, 0);
-		fb_buffer = NULL;
-		kfree(bfin_lq035_fb.pseudo_palette);
-		fb_dealloc_cmap(&bfin_lq035_fb.cmap);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_reg;
 	}
 
 	i2c_add_driver(&ad5280_driver);
@@ -807,11 +795,31 @@ static int __devinit bfin_lq035_probe(struct platform_device *pdev)
 
 	lcd_dev = lcd_device_register(KBUILD_MODNAME, &pdev->dev, NULL,
 				      &bfin_lcd_ops);
+	if (IS_ERR(lcd_dev)) {
+		pr_err("unable to register lcd\n");
+		ret = PTR_ERR(lcd_dev);
+		goto out_lcd;
+	}
 	lcd_dev->props.max_contrast = 255,
 
 	pr_info("initialized");
 
 	return 0;
+out_lcd:
+	unregister_framebuffer(&bfin_lq035_fb);
+out_reg:
+	fb_dealloc_cmap(&bfin_lq035_fb.cmap);
+out_cmap:
+	kfree(bfin_lq035_fb.pseudo_palette);
+out_palette:
+out_table:
+	dma_free_coherent(NULL, TOTAL_VIDEO_MEM_SIZE, fb_buffer, 0);
+	fb_buffer = NULL;
+out_dma_coherent:
+	free_ports();
+out_ports:
+	free_dma(CH_PPI);
+	return ret;
 }
 
 static int __devexit bfin_lq035_remove(struct platform_device *pdev)

