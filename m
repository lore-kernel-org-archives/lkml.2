Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab2KVUZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:25:52 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43124 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab2KVUZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:25:49 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, linux@prisktech.co.nz, patches@linaro.org
Subject: [PATCH 2/4] video: vt8500: Fix invalid free of devm_ allocated data
Date: Thu, 22 Nov 2012 12:12:09 +0530
Message-Id: <1353566531-31251-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353566531-31251-1-git-send-email-tushar.behera@linaro.org>
References: <1353566531-31251-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it, also fix the related return statements.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/video/vt8500lcdfb.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
index 5777adc..2438368 100644
--- a/drivers/video/vt8500lcdfb.c
+++ b/drivers/video/vt8500lcdfb.c
@@ -294,8 +294,7 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 			+ sizeof(u32) * 16, GFP_KERNEL);
 	if (!fbi) {
 		dev_err(&pdev->dev, "Failed to initialize framebuffer device\n");
-		ret = -ENOMEM;
-		goto failed;
+		return -ENOMEM;
 	}
 
 	strcpy(fbi->fb.fix.id, "VT8500 LCD");
@@ -328,15 +327,13 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "no I/O memory resource defined\n");
-		ret = -ENODEV;
-		goto failed_fbi;
+		return -ENODEV;
 	}
 
 	res = request_mem_region(res->start, resource_size(res), "vt8500lcd");
 	if (res == NULL) {
 		dev_err(&pdev->dev, "failed to request I/O memory\n");
-		ret = -EBUSY;
-		goto failed_fbi;
+		return -EBUSY;
 	}
 
 	fbi->regbase = ioremap(res->start, resource_size(res));
@@ -466,10 +463,6 @@ failed_free_io:
 	iounmap(fbi->regbase);
 failed_free_res:
 	release_mem_region(res->start, resource_size(res));
-failed_fbi:
-	platform_set_drvdata(pdev, NULL);
-	kfree(fbi);
-failed:
 	return ret;
 }
 
@@ -501,8 +494,6 @@ static int __devexit vt8500lcd_remove(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(res->start, resource_size(res));
 
-	kfree(fbi);
-
 	return 0;
 }
 
-- 
1.7.4.1

