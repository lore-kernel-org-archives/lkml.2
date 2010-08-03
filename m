Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab0HCPYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:24:30 -0400
Received: from smtp-gw11.han.skanova.net ([81.236.55.20]:40932 "EHLO
	smtp-gw11.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab0HCPY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:24:26 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Aug 2010 11:24:25 EDT
Subject: [PATCH 1/3 v2] media: Add a cached version of the contiguous video
 buffers
From: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Douglas Schilling Landgraf <dougsland@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 17:18:31 +0200
Message-ID: <1280848711.19898.161.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds another init functions in the videobuf-dma-contig
which is named _cached in the end. It creates a buffer factory
which allocates buffers using kmalloc and the buffers are cached.

A sync callback is added to sync the buffers.

Most of the code is reused from the uncached version a bool is added
to the memory struct to flag if the buffers are to be cached or not.

The reason is that I found the performance of the uncached buffers
was too poor on an atom-based X86, so I added this cached version.

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index 74730c6..a35f65a 100644
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
 				dev_dbg(q->dev, "buf[%d] freeing %p\n",
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
 
-static struct videobuf_buffer *__videobuf_alloc(size_t size)
+static struct videobuf_buffer *__videobuf_alloc(size_t size, bool cached)
 {
 	struct videobuf_dma_contig_memory *mem;
 	struct videobuf_buffer *vb;
@@ -199,11 +246,22 @@ static struct videobuf_buffer *__videobuf_alloc(size_t size)
 	if (vb) {
 		mem = vb->priv = ((char *)vb) + size;
 		mem->magic = MAGIC_DC_MEM;
+		mem->cached = cached;
 	}
 
 	return vb;
 }
 
+static struct videobuf_buffer *__videobuf_alloc_uncached(size_t size)
+{
+	return __videobuf_alloc(size, false);
+}
+
+static struct videobuf_buffer *__videobuf_alloc_cached(size_t size)
+{
+	return __videobuf_alloc(size, true);
+}
+
 static void *__videobuf_to_vaddr(struct videobuf_buffer *buf)
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
@@ -263,6 +312,19 @@ static int __videobuf_iolock(struct videobuf_queue *q,
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
+	return 0;
+}
+
 static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 				  struct videobuf_buffer *buf,
 				  struct vm_area_struct *vma)
@@ -290,30 +352,22 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	BUG_ON(!mem);
 	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
 
-	mem->size = PAGE_ALIGN(buf->bsize);
-	mem->vaddr = dma_alloc_coherent(q->dev, mem->size,
-					&mem->dma_handle, GFP_KERNEL);
-	if (!mem->vaddr) {
-		dev_err(q->dev, "dma_alloc_coherent size %ld failed\n",
-			mem->size);
+	if (__videobuf_dc_alloc(q->dev, mem, PAGE_ALIGN(buf->bsize)))
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
 
@@ -338,8 +392,18 @@ error:
 static struct videobuf_qtype_ops qops = {
 	.magic        = MAGIC_QTYPE_OPS,
 
-	.alloc        = __videobuf_alloc,
+	.alloc        = __videobuf_alloc_uncached,
+	.iolock       = __videobuf_iolock,
+	.mmap_mapper  = __videobuf_mmap_mapper,
+	.vaddr        = __videobuf_to_vaddr,
+};
+
+static struct videobuf_qtype_ops qops_cached = {
+	.magic        = MAGIC_QTYPE_OPS,
+
+	.alloc        = __videobuf_alloc_cached,
 	.iolock       = __videobuf_iolock,
+	.sync         = __videobuf_sync,
 	.mmap_mapper  = __videobuf_mmap_mapper,
 	.vaddr        = __videobuf_to_vaddr,
 };
@@ -358,6 +422,20 @@ void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
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
@@ -394,9 +472,7 @@ void videobuf_dma_contig_free(struct videobuf_queue *q,
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

