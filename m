Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143Ab1FARLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:11:34 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:38646 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759038Ab1FARKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:10:23 -0400
From: Julia Lawall <julia@diku.dk>
To: Paul Mundt <lethal@linux-sh.org>
Cc: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] drivers/video/pxa168fb.c: add missing clk_put
Date: Wed,  1 Jun 2011 19:10:13 +0200
Message-Id: <1306948213-20767-10-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a label for error-handling code in the case where only clk_get has
succeeded.  Rename the label failed to be consistent with the rest.

A simplified version of the semantic match that finds the missing clk_put
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression e1,e2;
statement S;
@@

e1 = clk_get@p1(...);
... when != e1 = e2
    when != clk_put(e1)
    when any
if (...) { ... when != clk_put(e1)
               when != if (...) { ... clk_put(e1) ... }
* return@p3 ...;
 } else S
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/pxa168fb.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/video/pxa168fb.c b/drivers/video/pxa168fb.c
index 35f61dd..bb95ec5 100644
--- a/drivers/video/pxa168fb.c
+++ b/drivers/video/pxa168fb.c
@@ -623,19 +623,21 @@ static int __devinit pxa168fb_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "no IO memory defined\n");
-		return -ENOENT;
+		ret = -ENOENT;
+		goto failed_put_clk;
 	}
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_err(&pdev->dev, "no IRQ defined\n");
-		return -ENOENT;
+		ret = -ENOENT;
+		goto failed_put_clk;
 	}
 
 	info = framebuffer_alloc(sizeof(struct pxa168fb_info), &pdev->dev);
 	if (info == NULL) {
-		clk_put(clk);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto failed_put_clk;
 	}
 
 	/* Initialize private data */
@@ -671,7 +673,7 @@ static int __devinit pxa168fb_probe(struct platform_device *pdev)
 	fbi->reg_base = ioremap_nocache(res->start, resource_size(res));
 	if (fbi->reg_base == NULL) {
 		ret = -ENOMEM;
-		goto failed;
+		goto failed_free_info;
 	}
 
 	/*
@@ -683,7 +685,7 @@ static int __devinit pxa168fb_probe(struct platform_device *pdev)
 						&fbi->fb_start_dma, GFP_KERNEL);
 	if (info->screen_base == NULL) {
 		ret = -ENOMEM;
-		goto failed;
+		goto failed_free_info;
 	}
 
 	info->fix.smem_start = (unsigned long)fbi->fb_start_dma;
@@ -772,8 +774,9 @@ failed_free_clk:
 failed_free_fbmem:
 	dma_free_coherent(fbi->dev, info->fix.smem_len,
 			info->screen_base, fbi->fb_start_dma);
-failed:
+failed_free_info:
 	kfree(info);
+failed_put_clk:
 	clk_put(clk);
 
 	dev_err(&pdev->dev, "frame buffer device init failed with %d\n", ret);

