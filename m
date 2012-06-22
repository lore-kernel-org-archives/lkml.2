Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762455Ab2FVQJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:09:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64763 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab2FVQJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:09:42 -0400
From: Emil Goode <emilgoode@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] grvga: Fix error handling issues
Date: Fri, 22 Jun 2012 18:11:19 +0200
Message-Id: <1340381479-6371-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two problems with the error handling in the
grvga_probe function.

- If the call to grvga_parse_custom on line 370 fails we use
  the wrong label so that release_mem_region will be called
  without a call to request_mem_region being made.

- If the call to ioremap on line 436 fails we should not try
  to call iounmap. I added an if statement to check whether or
  not a call to iounmap should be made.

- I also changed the names of the labels to make the code
  easier to read.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/video/grvga.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/video/grvga.c b/drivers/video/grvga.c
index da066c2..d9d688a 100644
--- a/drivers/video/grvga.c
+++ b/drivers/video/grvga.c
@@ -354,7 +354,7 @@ static int __devinit grvga_probe(struct platform_device *dev)
 	 */
 	if (fb_get_options("grvga", &options)) {
 		retval = -ENODEV;
-		goto err;
+		goto free_fb;
 	}
 
 	if (!options || !*options)
@@ -370,7 +370,7 @@ static int __devinit grvga_probe(struct platform_device *dev)
 			if (grvga_parse_custom(this_opt, &info->var) < 0) {
 				dev_err(&dev->dev, "Failed to parse custom mode (%s).\n", this_opt);
 				retval = -EINVAL;
-				goto err1;
+				goto free_fb;
 			}
 		} else if (!strncmp(this_opt, "addr", 4))
 			grvga_fix_addr = simple_strtoul(this_opt + 5, NULL, 16);
@@ -390,7 +390,7 @@ static int __devinit grvga_probe(struct platform_device *dev)
 	if (!request_mem_region(dev->resource[0].start, resource_size(&dev->resource[0]), "grlib-svgactrl regs")) {
 		dev_err(&dev->dev, "registers already mapped\n");
 		retval = -EBUSY;
-		goto err;
+		goto free_fb;
 	}
 
 	par->regs = of_ioremap(&dev->resource[0], 0,
@@ -400,14 +400,14 @@ static int __devinit grvga_probe(struct platform_device *dev)
 	if (!par->regs) {
 		dev_err(&dev->dev, "failed to map registers\n");
 		retval = -ENOMEM;
-		goto err1;
+		goto release_regs;
 	}
 
 	retval = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (retval < 0) {
 		dev_err(&dev->dev, "failed to allocate mem with fb_alloc_cmap\n");
 		retval = -ENOMEM;
-		goto err2;
+		goto unmap_regs;
 	}
 
 	if (mode_opt) {
@@ -415,7 +415,7 @@ static int __devinit grvga_probe(struct platform_device *dev)
 				      grvga_modedb, sizeof(grvga_modedb), &grvga_modedb[0], 8);
 		if (!retval || retval == 4) {
 			retval = -EINVAL;
-			goto err3;
+			goto dealloc_cmap;
 		}
 	}
 
@@ -430,7 +430,7 @@ static int __devinit grvga_probe(struct platform_device *dev)
 		if (!request_mem_region(physical_start, grvga_mem_size, dev->name)) {
 			dev_err(&dev->dev, "failed to request memory region\n");
 			retval = -ENOMEM;
-			goto err3;
+			goto dealloc_cmap;
 		}
 
 		virtual_start = (unsigned long) ioremap(physical_start, grvga_mem_size);
@@ -438,7 +438,7 @@ static int __devinit grvga_probe(struct platform_device *dev)
 		if (!virtual_start) {
 			dev_err(&dev->dev, "error mapping framebuffer memory\n");
 			retval = -ENOMEM;
-			goto err4;
+			goto free_mem;
 		}
 	} else {	/* Allocate frambuffer memory */
 
@@ -451,7 +451,7 @@ static int __devinit grvga_probe(struct platform_device *dev)
 				"unable to allocate framebuffer memory (%lu bytes)\n",
 				grvga_mem_size);
 			retval = -ENOMEM;
-			goto err3;
+			goto dealloc_cmap;
 		}
 
 		physical_start = dma_map_single(&dev->dev, (void *)virtual_start, grvga_mem_size, DMA_TO_DEVICE);
@@ -484,7 +484,7 @@ static int __devinit grvga_probe(struct platform_device *dev)
 	retval = register_framebuffer(info);
 	if (retval < 0) {
 		dev_err(&dev->dev, "failed to register framebuffer\n");
-		goto err4;
+		goto free_mem;
 	}
 
 	__raw_writel(physical_start, &par->regs->fb_pos);
@@ -493,21 +493,23 @@ static int __devinit grvga_probe(struct platform_device *dev)
 
 	return 0;
 
-err4:
+free_mem:
 	dev_set_drvdata(&dev->dev, NULL);
 	if (grvga_fix_addr) {
 		release_mem_region(physical_start, grvga_mem_size);
-		iounmap((void *)virtual_start);
+		if (virtual_start)
+			iounmap((void *)virtual_start);
 	} else
 		kfree((void *)virtual_start);
-err3:
+
+dealloc_cmap:
 	fb_dealloc_cmap(&info->cmap);
-err2:
+unmap_regs:
 	of_iounmap(&dev->resource[0], par->regs,
 		   resource_size(&dev->resource[0]));
-err1:
+release_regs:
 	release_mem_region(dev->resource[0].start, resource_size(&dev->resource[0]));
-err:
+free_fb:
 	framebuffer_release(info);
 
 	return retval;
-- 
1.7.10

