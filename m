Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab0FFLSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 07:18:37 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:54838 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab0FFLSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 07:18:36 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: "Greg Kroah-Hartman" <greg@kroah.com>
Subject: [BUG][PATCH]staging/dt3155v4l: correcting a pointer mismatch bug and cleanups
Date: Sun, 6 Jun 2010 14:16:07 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.34-rc7; KDE/4.4.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006061416.08283.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

The third argument of dma_alloc_coherent() is of type dma_addr_t and is defined
as u64 for x86_64, while the member 'device_base' of struct dma_coherent_mem is
defined as u32.

While at it, clean up the code. Now if dev->dma_mem != NULL all the fields/members
are already properly initialized.

Please apply.

Thanks

Marin Mitov

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

===========================================================================
--- a/drivers/staging/dt3155v4l/dt3155v4l.c	2010-06-06 08:52:06.000000000 +0300
+++ b/drivers/staging/dt3155v4l/dt3155v4l.c	2010-06-06 12:05:32.000000000 +0300
@@ -1008,6 +1008,8 @@
 static int __devinit
 dt3155_alloc_coherent(struct device *dev, size_t size, int flags)
 {
+	struct dma_coherent_mem *mem;
+	dma_addr_t dev_base;
 	int pages = size >> PAGE_SHIFT;
 	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
 
@@ -1018,25 +1020,28 @@
 	if (dev->dma_mem)
 		goto out;
 
-	dev->dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
-	if (!dev->dma_mem)
+	mem = kzalloc(sizeof(*mem), GFP_KERNEL);
+	if (!mem)
 		goto out;
-	dev->dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
-	if (!dev->dma_mem->bitmap)
+	mem->virt_base = dma_alloc_coherent(dev, size, &dev_base,
+							DT3155_COH_FLAGS);
+	if (!mem->virt_base)
+		goto err_alloc_coherent;
+	mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+	if (!mem->bitmap)
 		goto err_bitmap;
 
-	dev->dma_mem->virt_base = dma_alloc_coherent(dev, size,
-				&dev->dma_mem->device_base, DT3155_COH_FLAGS);
-	if (!dev->dma_mem->virt_base)
-		goto err_coherent;
-	dev->dma_mem->size = pages;
-	dev->dma_mem->flags = flags;
+	/* coherent_dma_mask is already set to 32 bits */
+	mem->device_base = dev_base;
+	mem->size = pages;
+	mem->flags = flags;
+	dev->dma_mem = mem;
 	return DMA_MEMORY_MAP;
 
-err_coherent:
-	kfree(dev->dma_mem->bitmap);
 err_bitmap:
-	kfree(dev->dma_mem);
+	dma_free_coherent(dev, size, mem->virt_base, dev_base);
+err_alloc_coherent:
+	kfree(mem);
 out:
 	return 0;
 }
