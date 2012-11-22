Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab2KVTqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:46:25 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59763 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237Ab2KVTqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:46:22 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, linux@prisktech.co.nz, patches@linaro.org
Subject: [PATCH 3/4] video: vt8500: Convert to use devm_request_mem_region()
Date: Thu, 22 Nov 2012 12:12:10 +0530
Message-Id: <1353566531-31251-4-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353566531-31251-1-git-send-email-tushar.behera@linaro.org>
References: <1353566531-31251-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it, fix the return statements.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/video/vt8500lcdfb.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
index 2438368..c42f15d 100644
--- a/drivers/video/vt8500lcdfb.c
+++ b/drivers/video/vt8500lcdfb.c
@@ -330,7 +330,8 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	res = request_mem_region(res->start, resource_size(res), "vt8500lcd");
+	res = devm_request_mem_region(&pdev->dev, res->start,
+			resource_size(res), "vt8500lcd");
 	if (res == NULL) {
 		dev_err(&pdev->dev, "failed to request I/O memory\n");
 		return -EBUSY;
@@ -339,8 +340,7 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 	fbi->regbase = ioremap(res->start, resource_size(res));
 	if (fbi->regbase == NULL) {
 		dev_err(&pdev->dev, "failed to map I/O memory\n");
-		ret = -EBUSY;
-		goto failed_free_res;
+		return -EBUSY;
 	}
 
 	np = of_parse_phandle(pdev->dev.of_node, "default-mode", 0);
@@ -461,15 +461,12 @@ failed_free_fbmem:
 			  fbi->fb.screen_base, fbi->fb.fix.smem_start);
 failed_free_io:
 	iounmap(fbi->regbase);
-failed_free_res:
-	release_mem_region(res->start, resource_size(res));
 	return ret;
 }
 
 static int __devexit vt8500lcd_remove(struct platform_device *pdev)
 {
 	struct vt8500lcd_info *fbi = platform_get_drvdata(pdev);
-	struct resource *res;
 	int irq;
 
 	unregister_framebuffer(&fbi->fb);
@@ -491,9 +488,6 @@ static int __devexit vt8500lcd_remove(struct platform_device *pdev)
 
 	iounmap(fbi->regbase);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
 	return 0;
 }
 
-- 
1.7.4.1

