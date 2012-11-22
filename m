Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965267Ab2KVTzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:55:14 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52400 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965243Ab2KVTzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:55:10 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, linux@prisktech.co.nz, patches@linaro.org
Subject: [PATCH 1/4] video: vt8500: Fix memory leak in probe function
Date: Thu, 22 Nov 2012 12:12:08 +0530
Message-Id: <1353566531-31251-2-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353566531-31251-1-git-send-email-tushar.behera@linaro.org>
References: <1353566531-31251-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of error in probe function, there is a possibility of
either iounmap not getting called or memory allocated for fb_mem_virt
not getting freed.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/video/vt8500lcdfb.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
index 9af8da7..5777adc 100644
--- a/drivers/video/vt8500lcdfb.c
+++ b/drivers/video/vt8500lcdfb.c
@@ -350,7 +350,7 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 	if (!np) {
 		pr_err("%s: No display description in Device Tree\n", __func__);
 		ret = -EINVAL;
-		goto failed_free_res;
+		goto failed_free_io;
 	}
 
 	/*
@@ -369,7 +369,7 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 	ret |= of_property_read_u32(np, "bpp", &bpp);
 	if (ret) {
 		pr_err("%s: Unable to read display properties\n", __func__);
-		goto failed_free_res;
+		goto failed_free_io;
 	}
 	of_mode.vmode = FB_VMODE_NONINTERLACED;
 
@@ -379,7 +379,8 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 				GFP_KERNEL);
 	if (!fb_mem_virt) {
 		pr_err("%s: Failed to allocate framebuffer\n", __func__);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto failed_free_io;
 	};
 
 	fbi->fb.fix.smem_start	= fb_mem_phys;
@@ -394,7 +395,7 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 	if (fbi->palette_cpu == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate palette buffer\n");
 		ret = -ENOMEM;
-		goto failed_free_io;
+		goto failed_free_fbmem;
 	}
 
 	irq = platform_get_irq(pdev, 0);
@@ -458,6 +459,9 @@ failed_free_irq:
 failed_free_palette:
 	dma_free_coherent(&pdev->dev, fbi->palette_size,
 			  fbi->palette_cpu, fbi->palette_phys);
+failed_free_fbmem:
+	dma_free_coherent(&pdev->dev, fbi->fb.fix.smem_len,
+			  fbi->fb.screen_base, fbi->fb.fix.smem_start);
 failed_free_io:
 	iounmap(fbi->regbase);
 failed_free_res:
@@ -485,6 +489,10 @@ static int __devexit vt8500lcd_remove(struct platform_device *pdev)
 	irq = platform_get_irq(pdev, 0);
 	free_irq(irq, fbi);
 
+	if (fbi->fb.screen_base)
+		dma_free_coherent(&pdev->dev, fbi->fb.fix.smem_len,
+				  fbi->fb.screen_base, fbi->fb.fix.smem_start);
+
 	dma_free_coherent(&pdev->dev, fbi->palette_size,
 			  fbi->palette_cpu, fbi->palette_phys);
 
-- 
1.7.4.1

