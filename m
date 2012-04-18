Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab2DRThS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:37:18 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39817 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab2DRThP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:37:15 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/video/ep93xx-fb.c: clean up error-handling code
Date: Wed, 18 Apr 2012 21:37:08 +0200
Message-Id: <1334777828-3557-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

There were two problems in this code: failure of the setup function should
free locally allocated resources like other nearby failures, and the test
if (&info->cmap) can never be false.  To generally clean things up, this
patch reorders the error handling code at the failed label and adds labels
so that the conditionals are not necessary.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/video/ep93xx-fb.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/video/ep93xx-fb.c b/drivers/video/ep93xx-fb.c
index f8babbe..345d962 100644
--- a/drivers/video/ep93xx-fb.c
+++ b/drivers/video/ep93xx-fb.c
@@ -507,16 +507,16 @@ static int __devinit ep93xxfb_probe(struct platform_device *pdev)
 
 	err = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (err)
-		goto failed;
+		goto failed_cmap;
 
 	err = ep93xxfb_alloc_videomem(info);
 	if (err)
-		goto failed;
+		goto failed_videomem;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		err = -ENXIO;
-		goto failed;
+		goto failed_resource;
 	}
 
 	/*
@@ -532,7 +532,7 @@ static int __devinit ep93xxfb_probe(struct platform_device *pdev)
 	fbi->mmio_base = ioremap(res->start, resource_size(res));
 	if (!fbi->mmio_base) {
 		err = -ENXIO;
-		goto failed;
+		goto failed_resource;
 	}
 
 	strcpy(info->fix.id, pdev->name);
@@ -553,24 +553,24 @@ static int __devinit ep93xxfb_probe(struct platform_device *pdev)
 	if (err == 0) {
 		dev_err(info->dev, "No suitable video mode found\n");
 		err = -EINVAL;
-		goto failed;
+		goto failed_mode;
 	}
 
 	if (mach_info->setup) {
 		err = mach_info->setup(pdev);
 		if (err)
-			return err;
+			goto failed_mode;
 	}
 
 	err = ep93xxfb_check_var(&info->var, info);
 	if (err)
-		goto failed;
+		goto failed_check;
 
 	fbi->clk = clk_get(info->dev, NULL);
 	if (IS_ERR(fbi->clk)) {
 		err = PTR_ERR(fbi->clk);
 		fbi->clk = NULL;
-		goto failed;
+		goto failed_check;
 	}
 
 	ep93xxfb_set_par(info);
@@ -585,15 +585,17 @@ static int __devinit ep93xxfb_probe(struct platform_device *pdev)
 	return 0;
 
 failed:
-	if (fbi->clk)
-		clk_put(fbi->clk);
-	if (fbi->mmio_base)
-		iounmap(fbi->mmio_base);
-	ep93xxfb_dealloc_videomem(info);
-	if (&info->cmap)
-		fb_dealloc_cmap(&info->cmap);
+	clk_put(fbi->clk);
+failed_check:
 	if (fbi->mach_info->teardown)
 		fbi->mach_info->teardown(pdev);
+failed_mode:
+	iounmap(fbi->mmio_base);
+failed_resource:
+	ep93xxfb_dealloc_videomem(info);
+failed_videomem:
+	fb_dealloc_cmap(&info->cmap);
+failed_cmap:
 	kfree(info);
 	platform_set_drvdata(pdev, NULL);
 

