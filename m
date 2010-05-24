Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003Ab0EXXQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:16:23 -0400
Received: from kroah.org ([198.145.64.141]:36369 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758805Ab0EXXJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:09:16 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:03:49 2010
Message-Id: <20100524230349.616731541@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 15:59:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Hennerich <michael.hennerich@analog.com>,
       Mike Frysinger <vapier@gentoo.org>
Subject: [03/34] fbdev: bfin-t350mcqb-fb: fix fbmem allocation with blanking lines
In-Reply-To: <20100524230418.GA12770@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Hennerich <michael.hennerich@analog.com>

commit de145b44b95b9d3212a82d1c0f29b09778ef33c5 upstream.

The current allocation does not include the memory required for blanking
lines.  So avoid memory corruption when multiple devices are using the DMA
memory near each other.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/bfin-t350mcqb-fb.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -515,9 +515,9 @@ static int __devinit bfin_t350mcqb_probe
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
@@ -587,8 +587,8 @@ out7:
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
@@ -611,8 +611,9 @@ static int __devexit bfin_t350mcqb_remov
 	free_irq(info->irq, info);
 
 	if (info->fb_buffer != NULL)
-		dma_free_coherent(NULL, fbinfo->fix.smem_len, info->fb_buffer,
-				  info->dma_handle);
+		dma_free_coherent(NULL, fbinfo->fix.smem_len +
+			ACTIVE_VIDEO_MEM_OFFSET, info->fb_buffer,
+			info->dma_handle);
 
 	fb_dealloc_cmap(&fbinfo->cmap);
 


