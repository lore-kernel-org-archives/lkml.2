Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab2GaNzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:55:45 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:7835 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753930Ab2GaNy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:54:27 -0400
X-IronPort-AV: E=Sophos;i="4.77,686,1336341600"; 
   d="scan'208";a="168682635"
From: Damien Cassou <damien.cassou@lifl.fr>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] drivers/video/bfin-t350mcqb-fb.c: use devm_ functions
Date: Tue, 31 Jul 2012 15:54:19 +0200
Message-Id: <1343742860-16213-5-git-send-email-damien.cassou@lifl.fr>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1343742860-16213-1-git-send-email-damien.cassou@lifl.fr>
References: <1343742860-16213-1-git-send-email-damien.cassou@lifl.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Damien Cassou <damien.cassou@lifl.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>

---
 drivers/video/bfin-t350mcqb-fb.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index 7a0c05f..43e0d1b 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -490,9 +490,10 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 	fbinfo->fbops = &bfin_t350mcqb_fb_ops;
 	fbinfo->flags = FBINFO_FLAG_DEFAULT;
 
-	info->fb_buffer = dma_alloc_coherent(NULL, fbinfo->fix.smem_len +
-				ACTIVE_VIDEO_MEM_OFFSET,
-				&info->dma_handle, GFP_KERNEL);
+	info->fb_buffer = dmam_alloc_coherent(&pdev->dev, NULL,
+					      fbinfo->fix.smem_len +
+					      ACTIVE_VIDEO_MEM_OFFSET,
+					      &info->dma_handle, GFP_KERNEL);
 
 	if (NULL == info->fb_buffer) {
 		printk(KERN_ERR DRIVER_NAME
@@ -514,7 +515,7 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 		       "Fail to allocate colormap (%d entries)\n",
 		       BFIN_LCD_NBR_PALETTE_ENTRIES);
 		ret = -EFAULT;
-		goto out4;
+		goto out3;
 	}
 
 	if (bfin_t350mcqb_request_ports(1)) {
@@ -529,8 +530,8 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 		goto out7;
 	}
 
-	ret = request_irq(info->irq, bfin_t350mcqb_irq_error, 0,
-			"PPI ERROR", info);
+	ret = devm_request_irq(&pdev->dev, info->irq, bfin_t350mcqb_irq_error,
+			       0, "PPI ERROR", info);
 	if (ret < 0) {
 		printk(KERN_ERR DRIVER_NAME
 		       ": unable to request PPI ERROR IRQ\n");
@@ -541,7 +542,7 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 		printk(KERN_ERR DRIVER_NAME
 		       ": unable to register framebuffer.\n");
 		ret = -EINVAL;
-		goto out8;
+		goto out7;
 	}
 #ifndef NO_BL_SUPPORT
 	memset(&props, 0, sizeof(struct backlight_properties));
@@ -554,7 +555,7 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 			": unable to register backlight.\n");
 		ret = -EINVAL;
 		unregister_framebuffer(fbinfo);
-		goto out8;
+		goto out7;
 	}
 
 	lcd_dev = lcd_device_register(DRIVER_NAME, NULL, &bfin_lcd_ops);
@@ -563,15 +564,10 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 
 	return 0;
 
-out8:
-	free_irq(info->irq, info);
 out7:
 	bfin_t350mcqb_request_ports(0);
 out6:
 	fb_dealloc_cmap(&fbinfo->cmap);
-out4:
-	dma_free_coherent(NULL, fbinfo->fix.smem_len + ACTIVE_VIDEO_MEM_OFFSET,
-			 info->fb_buffer, info->dma_handle);
 out3:
 	framebuffer_release(fbinfo);
 out2:
@@ -591,12 +587,6 @@ static int __devexit bfin_t350mcqb_remove(struct platform_device *pdev)
 	unregister_framebuffer(fbinfo);
 
 	free_dma(CH_PPI);
-	free_irq(info->irq, info);
-
-	if (info->fb_buffer != NULL)
-		dma_free_coherent(NULL, fbinfo->fix.smem_len +
-			ACTIVE_VIDEO_MEM_OFFSET, info->fb_buffer,
-			info->dma_handle);
 
 	fb_dealloc_cmap(&fbinfo->cmap);
 

