Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab0EZPDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:03:17 -0400
Received: from av7-1-sn3.vrr.skanova.net ([81.228.9.181]:41651 "EHLO
	av7-1-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab0EZPDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:03:16 -0400
X-Greylist: delayed 1561 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 May 2010 11:03:15 EDT
Subject: Re: [PATCH 1/2] media: Add timberdale video-in driver
From: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Douglas Schilling Landgraf <dougsland@gmail.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>
In-Reply-To: <4BD46A0E.8030705@redhat.com>
References: <1271435291.11641.45.camel@debian> <4BD45EB1.5020804@redhat.com>
	 <4BD46753.9010807@pelagicore.com>  <4BD46A0E.8030705@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 16:19:33 +0200
Message-ID: <1274883573.12092.4.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Sun, 2010-04-25 at 13:13 -0300, Mauro Carvalho Chehab wrote:
> > 
> > 2.
> > I tried using videobuf-dma-contig, but got poor performance. I can not
> > really explain why, I though it's due to the fact that the contiguous
> > buffer is allocated coherent -> no caching.
> > I saw both gstreamer and mplayer perform very badly.
> > The frame grabber requires the DMA transfer for a frame beeing started
> > while the frame is decoded. When I tested using contigous buffers
> > gstreamer sometimes was that slow that it sometimes missed to have a
> > frame queued when a transfer was finished, so I got frame drops. Any
> > other ideas of the poor performance? otherwise I would like to go for
> > the double buffered solution.
> 
> The better is to fix videobuf-dma_contig to better work on your hardware.
> It makes sense to add a flag to allow specifying if it should use coherent
> or non-coherent memory for the dma buffer alloc/free calls.
> 

I have verified the performance issue and it goes back to non cached coherent buffers.
I did an update to the videobuf-dma-contig. I did it by adding another init function,
which calls videobuf_queue_core_init with another set of qops.
The other set uses the same functions as the uncached version, but a sync function
is added, and the alloc_functions are different.

What do you think?

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index dce4f3a..2fc923c 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -27,6 +27,7 @@ struct videobuf_dma_contig_memory {
 	u32 magic;
 	void *vaddr;
 	dma_addr_t dma_handle;
+	bool cached;
 	unsigned long size;
 	int is_userptr;
 };
@@ -38,6 +39,54 @@ struct videobuf_dma_contig_memory {
 		BUG();							    \
 	}
 
+static int __videobuf_dc_alloc(struct device *dev,
+	struct videobuf_dma_contig_memory *mem, unsigned long size)
+{
+	mem->size = size;
+	if (mem->cached) {
+		mem->vaddr = kmalloc(mem->size, GFP_KERNEL);
+		if (mem->vaddr) {
+			int err;
+
+			mem->dma_handle = dma_map_single(dev, mem->vaddr,
+				mem->size, DMA_FROM_DEVICE);
+			err = dma_mapping_error(dev, mem->dma_handle);
+			if (err) {
+				dev_err(dev, "dma_map_single failed\n");
+
+				kfree(mem->vaddr);
+				mem->vaddr = 0;
+				return err;
+			}
+		}
+	} else
+		mem->vaddr = dma_alloc_coherent(dev, mem->size,
+			&mem->dma_handle, GFP_KERNEL);
+
+	if (!mem->vaddr) {
+		dev_err(dev, "memory alloc size %ld failed\n",
+			mem->size);
+		return -ENOMEM;
+	}
+
+	dev_dbg(dev, "dma mapped data is at %p (%ld)\n", mem->vaddr, mem->size);
+
+	return 0;
+}
+
+static void __videobuf_dc_free(struct device *dev,
+	struct videobuf_dma_contig_memory *mem)
+{
+	if (mem->cached) {
+		dma_unmap_single(dev, mem->dma_handle, mem->size,
+			DMA_FROM_DEVICE);
+		kfree(mem->vaddr);
+	} else
+		dma_free_coherent(dev, mem->size, mem->vaddr, mem->dma_handle);
+
+	mem->vaddr = NULL;
+}
+
 static void
 videobuf_vm_open(struct vm_area_struct *vma)
 {
@@ -92,9 +141,7 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 				dev_dbg(map->q->dev, "buf[%d] freeing %p\n",
 					i, mem->vaddr);
 
-				dma_free_coherent(q->dev, mem->size,
-						  mem->vaddr, mem->dma_handle);
-				mem->vaddr = NULL;
+				__videobuf_dc_free(q->dev, mem);
 			}
 
 			q->bufs[i]->map   = NULL;
@@ -190,7 +237,7 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
 	return ret;
 }
 
-static void *__videobuf_alloc(size_t size)
+static void *__videobuf_alloc(size_t size, bool cached)
 {
 	struct videobuf_dma_contig_memory *mem;
 	struct videobuf_buffer *vb;
@@ -199,11 +246,22 @@ static void *__videobuf_alloc(size_t size)
 	if (vb) {
 		mem = vb->priv = ((char *)vb) + size;
 		mem->magic = MAGIC_DC_MEM;
+		mem->cached = cached;
 	}
 
 	return vb;
 }
 
+static void *__videobuf_alloc_uncached(size_t size)
+{
+	return __videobuf_alloc(size, false);
+}
+
+static void *__videobuf_alloc_cached(size_t size)
+{
+	return __videobuf_alloc(size, true);
+}
+
 static void *__videobuf_to_vmalloc(struct videobuf_buffer *buf)
 {
 	struct videobuf_dma_contig_memory *mem = buf->priv;
@@ -241,17 +299,8 @@ static int __videobuf_iolock(struct videobuf_queue *q,
 			return videobuf_dma_contig_user_get(mem, vb);
 
 		/* allocate memory for the read() method */
-		mem->size = PAGE_ALIGN(vb->size);
-		mem->vaddr = dma_alloc_coherent(q->dev, mem->size,
-						&mem->dma_handle, GFP_KERNEL);
-		if (!mem->vaddr) {
-			dev_err(q->dev, "dma_alloc_coherent %ld failed\n",
-					 mem->size);
+		if (__videobuf_dc_alloc(q->dev, mem, PAGE_ALIGN(vb->size)))
 			return -ENOMEM;
-		}
-
-		dev_dbg(q->dev, "dma_alloc_coherent data is at %p (%ld)\n",
-			mem->vaddr, mem->size);
 		break;
 	case V4L2_MEMORY_OVERLAY:
 	default:
@@ -276,6 +325,20 @@ static int __videobuf_mmap_free(struct videobuf_queue *q)
 	return 0;
 }
 
+static int __videobuf_sync(struct videobuf_queue *q,
+			   struct videobuf_buffer *buf)
+{
+	struct videobuf_dma_contig_memory *mem = buf->priv;
+	BUG_ON(!mem);
+	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+	dma_sync_single_for_cpu(q->dev, mem->dma_handle, mem->size,
+		DMA_FROM_DEVICE);
+
+    return 0;
+}
+
+
 static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 				  struct vm_area_struct *vma)
 {
@@ -321,30 +384,22 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	BUG_ON(!mem);
 	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
 
-	mem->size = PAGE_ALIGN(q->bufs[first]->bsize);
-	mem->vaddr = dma_alloc_coherent(q->dev, mem->size,
-					&mem->dma_handle, GFP_KERNEL);
-	if (!mem->vaddr) {
-		dev_err(q->dev, "dma_alloc_coherent size %ld failed\n",
-			mem->size);
+	if (__videobuf_dc_alloc(q->dev, mem, PAGE_ALIGN(q->bufs[first]->bsize)))
 		goto error;
-	}
-	dev_dbg(q->dev, "dma_alloc_coherent data is at addr %p (size %ld)\n",
-		mem->vaddr, mem->size);
 
 	/* Try to remap memory */
 
 	size = vma->vm_end - vma->vm_start;
 	size = (size < mem->size) ? size : mem->size;
 
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	if (!mem->cached)
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	retval = remap_pfn_range(vma, vma->vm_start,
 				 mem->dma_handle >> PAGE_SHIFT,
 				 size, vma->vm_page_prot);
 	if (retval) {
 		dev_err(q->dev, "mmap: remap failed with error %d. ", retval);
-		dma_free_coherent(q->dev, mem->size,
-				  mem->vaddr, mem->dma_handle);
+		__videobuf_dc_free(q->dev, mem);
 		goto error;
 	}
 
@@ -422,9 +477,22 @@ static int __videobuf_copy_stream(struct videobuf_queue *q,
 static struct videobuf_qtype_ops qops = {
 	.magic        = MAGIC_QTYPE_OPS,
 
-	.alloc        = __videobuf_alloc,
+	.alloc        = __videobuf_alloc_uncached,
+	.iolock       = __videobuf_iolock,
+	.mmap_free    = __videobuf_mmap_free,
+	.mmap_mapper  = __videobuf_mmap_mapper,
+	.video_copy_to_user = __videobuf_copy_to_user,
+	.copy_stream  = __videobuf_copy_stream,
+	.vmalloc      = __videobuf_to_vmalloc,
+};
+
+static struct videobuf_qtype_ops qops_cached = {
+	.magic        = MAGIC_QTYPE_OPS,
+
+	.alloc        = __videobuf_alloc_cached,
 	.iolock       = __videobuf_iolock,
 	.mmap_free    = __videobuf_mmap_free,
+	.sync         = __videobuf_sync,
 	.mmap_mapper  = __videobuf_mmap_mapper,
 	.video_copy_to_user = __videobuf_copy_to_user,
 	.copy_stream  = __videobuf_copy_stream,
@@ -445,6 +513,20 @@ void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
 }
 EXPORT_SYMBOL_GPL(videobuf_queue_dma_contig_init);
 
+void videobuf_queue_dma_contig_init_cached(struct videobuf_queue *q,
+				    const struct videobuf_queue_ops *ops,
+				    struct device *dev,
+				    spinlock_t *irqlock,
+				    enum v4l2_buf_type type,
+				    enum v4l2_field field,
+				    unsigned int msize,
+				    void *priv)
+{
+	videobuf_queue_core_init(q, ops, dev, irqlock, type, field, msize,
+				 priv, &qops_cached);
+}
+EXPORT_SYMBOL_GPL(videobuf_queue_dma_contig_init_cached);
+
 dma_addr_t videobuf_to_dma_contig(struct videobuf_buffer *buf)
 {
 	struct videobuf_dma_contig_memory *mem = buf->priv;
@@ -481,9 +563,7 @@ void videobuf_dma_contig_free(struct videobuf_queue *q,
 		return;
 	}
 
-	/* read() method */
-	dma_free_coherent(q->dev, mem->size, mem->vaddr, mem->dma_handle);
-	mem->vaddr = NULL;
+	__videobuf_dc_free(q->dev, mem);
 }
 EXPORT_SYMBOL_GPL(videobuf_dma_contig_free);
 
diff --git a/include/media/videobuf-dma-contig.h b/include/media/videobuf-dma-contig.h
index ebaa9bc..43b94cd 100644
--- a/include/media/videobuf-dma-contig.h
+++ b/include/media/videobuf-dma-contig.h
@@ -25,6 +25,15 @@ void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
 				    unsigned int msize,
 				    void *priv);
 
+void videobuf_queue_dma_contig_init_cached(struct videobuf_queue *q,
+				    const struct videobuf_queue_ops *ops,
+				    struct device *dev,
+				    spinlock_t *irqlock,
+				    enum v4l2_buf_type type,
+				    enum v4l2_field field,
+				    unsigned int msize,
+				    void *priv);
+
 dma_addr_t videobuf_to_dma_contig(struct videobuf_buffer *buf);
 void videobuf_dma_contig_free(struct videobuf_queue *q,
 			      struct videobuf_buffer *buf);

