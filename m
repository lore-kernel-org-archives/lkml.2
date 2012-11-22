Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab2KVUFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:05:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47907 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab2KVUF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:05:26 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, linux@prisktech.co.nz, patches@linaro.org
Subject: [PATCH 4/4] video: vt8500: Convert to use devm_ioremap()
Date: Thu, 22 Nov 2012 12:12:11 +0530
Message-Id: <1353566531-31251-5-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353566531-31251-1-git-send-email-tushar.behera@linaro.org>
References: <1353566531-31251-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it, fix the return statements.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/video/vt8500lcdfb.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
index c42f15d..96a955e 100644
--- a/drivers/video/vt8500lcdfb.c
+++ b/drivers/video/vt8500lcdfb.c
@@ -337,7 +337,7 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 		return -EBUSY;
 	}
 
-	fbi->regbase = ioremap(res->start, resource_size(res));
+	fbi->regbase = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (fbi->regbase == NULL) {
 		dev_err(&pdev->dev, "failed to map I/O memory\n");
 		return -EBUSY;
@@ -346,8 +346,7 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 	np = of_parse_phandle(pdev->dev.of_node, "default-mode", 0);
 	if (!np) {
 		pr_err("%s: No display description in Device Tree\n", __func__);
-		ret = -EINVAL;
-		goto failed_free_io;
+		return -EINVAL;
 	}
 
 	/*
@@ -366,7 +365,7 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 	ret |= of_property_read_u32(np, "bpp", &bpp);
 	if (ret) {
 		pr_err("%s: Unable to read display properties\n", __func__);
-		goto failed_free_io;
+		return ret;
 	}
 	of_mode.vmode = FB_VMODE_NONINTERLACED;
 
@@ -376,8 +375,7 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 				GFP_KERNEL);
 	if (!fb_mem_virt) {
 		pr_err("%s: Failed to allocate framebuffer\n", __func__);
-		ret = -ENOMEM;
-		goto failed_free_io;
+		return -ENOMEM;
 	};
 
 	fbi->fb.fix.smem_start	= fb_mem_phys;
@@ -459,8 +457,6 @@ failed_free_palette:
 failed_free_fbmem:
 	dma_free_coherent(&pdev->dev, fbi->fb.fix.smem_len,
 			  fbi->fb.screen_base, fbi->fb.fix.smem_start);
-failed_free_io:
-	iounmap(fbi->regbase);
 	return ret;
 }
 
@@ -486,8 +482,6 @@ static int __devexit vt8500lcd_remove(struct platform_device *pdev)
 	dma_free_coherent(&pdev->dev, fbi->palette_size,
 			  fbi->palette_cpu, fbi->palette_phys);
 
-	iounmap(fbi->regbase);
-
 	return 0;
 }
 
-- 
1.7.4.1

