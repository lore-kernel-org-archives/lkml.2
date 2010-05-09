Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab0EIK74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 06:59:56 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48719 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab0EIK7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 06:59:55 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-fbdev@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH] fbdev: bfin-t350mcqb-fb: fix fbmem allocation with blanking lines
Date: Sun,  9 May 2010 07:02:45 -0400
Message-Id: <1273402965-2995-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

The current allocation does not include the memory required for blanking
lines.  So avoid memory corruption when multiple devices are using the DMA
memory near each other.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/video/bfin-t350mcqb-fb.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index 44e49c2..c2ec3dc 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -488,9 +488,9 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 	fbinfo->fbops = &bfin_t350mcqb_fb_ops;
 	fbinfo->flags = FBINFO_FLAG_DEFAULT;
 
-	info->fb_buffer =
-	    dma_alloc_coherent(NULL, fbinfo->fix.smem_len, &info->dma_handle,
-			       GFP_KERNEL);
+	info->fb_buffer = dma_alloc_coherent(NULL, fbinfo->fix.smem_len +
+				ACTIVE_VIDEO_MEM_OFFSET,
+				&info->dma_handle, GFP_KERNEL);
 
 	if (NULL == info->fb_buffer) {
 		printk(KERN_ERR DRIVER_NAME
@@ -568,8 +568,8 @@ out7:
 out6:
 	fb_dealloc_cmap(&fbinfo->cmap);
 out4:
-	dma_free_coherent(NULL, fbinfo->fix.smem_len, info->fb_buffer,
-			  info->dma_handle);
+	dma_free_coherent(NULL, fbinfo->fix.smem_len + ACTIVE_VIDEO_MEM_OFFSET,
+			 info->fb_buffer, info->dma_handle);
 out3:
 	framebuffer_release(fbinfo);
 out2:
@@ -592,8 +592,9 @@ static int __devexit bfin_t350mcqb_remove(struct platform_device *pdev)
 	free_irq(info->irq, info);
 
 	if (info->fb_buffer != NULL)
-		dma_free_coherent(NULL, fbinfo->fix.smem_len, info->fb_buffer,
-				  info->dma_handle);
+		dma_free_coherent(NULL, fbinfo->fix.smem_len +
+			ACTIVE_VIDEO_MEM_OFFSET, info->fb_buffer,
+			info->dma_handle);
 
 	fb_dealloc_cmap(&fbinfo->cmap);
 
-- 
1.7.1

