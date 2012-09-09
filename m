Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab2IIPim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 11:38:42 -0400
Received: from smtp-out-022.synserver.de ([212.40.185.22]:1270 "EHLO
	smtp-out-022.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2IIPil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 11:38:41 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 23992
From: Lars-Peter Clausen <lars@metafoo.de>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Damien Cassou <damien.cassou@lifl.fr>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] fbdev: jz4740: Use devm_request_and_ioremap
Date: Sun,  9 Sep 2012 17:38:41 +0200
Message-Id: <1347205121-5551-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_request_and_ioremap instead of request_mem_region + devm_ioremap.

This also fixes the following compile error introduced in commit b2ca7f4d
("drivers/video/jz4740_fb.c: use devm_ functions"):

drivers/video/jz4740_fb.c: In function 'jzfb_probe':
	drivers/video/jz4740_fb.c:676:2: error: implicit declaration of function 'devm_ioremap'
	drivers/video/jz4740_fb.c:676:13: warning: assignment makes pointer from integer without a cast

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/video/jz4740_fb.c |   24 +++---------------------
 1 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/video/jz4740_fb.c b/drivers/video/jz4740_fb.c
index 7669770..b0df279 100644
--- a/drivers/video/jz4740_fb.c
+++ b/drivers/video/jz4740_fb.c
@@ -632,23 +632,10 @@ static int __devinit jzfb_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem) {
-		dev_err(&pdev->dev, "Failed to get register memory resource\n");
-		return -ENXIO;
-	}
-
-	mem = request_mem_region(mem->start, resource_size(mem), pdev->name);
-	if (!mem) {
-		dev_err(&pdev->dev, "Failed to request register memory region\n");
-		return -EBUSY;
-	}
-
 	fb = framebuffer_alloc(sizeof(struct jzfb), &pdev->dev);
 	if (!fb) {
 		dev_err(&pdev->dev, "Failed to allocate framebuffer device\n");
-		ret = -ENOMEM;
-		goto err_release_mem_region;
+		return -ENOMEM;
 	}
 
 	fb->fbops = &jzfb_ops;
@@ -657,7 +644,6 @@ static int __devinit jzfb_probe(struct platform_device *pdev)
 	jzfb = fb->par;
 	jzfb->pdev = pdev;
 	jzfb->pdata = pdata;
-	jzfb->mem = mem;
 
 	jzfb->ldclk = devm_clk_get(&pdev->dev, "lcd");
 	if (IS_ERR(jzfb->ldclk)) {
@@ -673,9 +659,9 @@ static int __devinit jzfb_probe(struct platform_device *pdev)
 		goto err_framebuffer_release;
 	}
 
-	jzfb->base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	jzfb->base = devm_request_and_ioremap(&pdev->dev, mem);
 	if (!jzfb->base) {
-		dev_err(&pdev->dev, "Failed to ioremap register memory region\n");
 		ret = -EBUSY;
 		goto err_framebuffer_release;
 	}
@@ -736,8 +722,6 @@ err_free_devmem:
 	jzfb_free_devmem(jzfb);
 err_framebuffer_release:
 	framebuffer_release(fb);
-err_release_mem_region:
-	release_mem_region(mem->start, resource_size(mem));
 	return ret;
 }
 
@@ -750,8 +734,6 @@ static int __devexit jzfb_remove(struct platform_device *pdev)
 	jz_gpio_bulk_free(jz_lcd_ctrl_pins, jzfb_num_ctrl_pins(jzfb));
 	jz_gpio_bulk_free(jz_lcd_data_pins, jzfb_num_data_pins(jzfb));
 
-	release_mem_region(jzfb->mem->start, resource_size(jzfb->mem));
-
 	fb_dealloc_cmap(&jzfb->fb->cmap);
 	jzfb_free_devmem(jzfb);
 
-- 
1.7.2.5

