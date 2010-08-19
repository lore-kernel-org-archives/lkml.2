Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab0HSPUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:20:08 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:56572 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab0HSPUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:20:05 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] add dma_reserve_coherent_memory()/dma_free_reserved_memory() API
Date: Thu, 19 Aug 2010 18:18:35 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.36-rc1; KDE/4.4.3; x86_64; ; )
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008191818.36068.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

struct device contains a member: struct dma_coherent_mem *dma_mem;
to hold information for a piece of memory declared dma-coherent.
Alternatively the same member could also be used to hold preallocated
dma-coherent memory for latter per-device use.

This tric is already used in drivers/staging/dt3155v4l.c
dt3155_alloc_coherent()/dt3155_free_coherent()

Here proposed for general use by popular demand from video4linux folks.
Helps for videobuf-dma-contig framework.

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

======================================================================
--- a/drivers/base/dma-coherent.c	2010-08-19 15:50:42.000000000 +0300
+++ b/drivers/base/dma-coherent.c	2010-08-19 17:27:56.000000000 +0300
@@ -93,6 +93,83 @@ void *dma_mark_declared_memory_occupied(
 EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
 
 /**
+ * dma_reserve_coherent_memory() - reserve coherent memory for per-device use
+ *
+ * @dev:	device from which we allocate memory
+ * @size:	size of requested memory area in bytes
+ * @flags:	same as in dma_declare_coherent_memory()
+ *
+ * This function reserves coherent memory allocating it early (during probe())
+ * to support latter allocations from per-device coherent memory pools.
+ * For a given device one could use either dma_declare_coherent_memory() or
+ * dma_reserve_coherent_memory(), but not both, becase the result of these
+ * functions is stored in a single struct device member - dma_mem
+ *
+ * Returns DMA_MEMORY_MAP on success, or 0 if failed.
+ * (same as dma_declare_coherent_memory()
+ */
+int dma_reserve_coherent_memory(struct device *dev, size_t size, int flags)
+{
+	struct dma_coherent_mem *mem;
+	dma_addr_t dev_base;
+	int pages = size >> PAGE_SHIFT;
+	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
+
+	if ((flags & DMA_MEMORY_MAP) == 0)
+		goto out;
+	if (!size)
+		goto out;
+	if (dev->dma_mem)
+		goto out;
+
+	mem = kzalloc(sizeof(*mem), GFP_KERNEL);
+	if (!mem)
+		goto out;
+	mem->virt_base = dma_alloc_coherent(dev, size, &dev_base,
+							DT3155_COH_FLAGS);
+	if (!mem->virt_base)
+		goto err_alloc_coherent;
+	mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+	if (!mem->bitmap)
+		goto err_bitmap;
+
+	mem->device_base = dev_base;
+	mem->size = pages;
+	mem->flags = flags;
+	dev->dma_mem = mem;
+	return DMA_MEMORY_MAP;
+
+err_bitmap:
+	dma_free_coherent(dev, size, mem->virt_base, dev_base);
+err_alloc_coherent:
+	kfree(mem);
+out:
+	return 0;
+}
+EXPORT_SYMBOL(dma_reserve_coherent_memory);
+
+/**
+ * dma_free_reserved_memory() - free the reserved dma-coherent memoty
+ *
+ * @dev:	device for which we free the dma-coherent memory
+ *
+ * same as dma_release_declared_memory()
+ */
+void dma_free_reserved_memory(struct device *dev)
+{
+	struct dma_coherent_mem *mem = dev->dma_mem;
+
+	if (!mem)
+		return;
+	dev->dma_mem = NULL;
+	dma_free_coherent(dev, mem->size << PAGE_SHIFT,
+					mem->virt_base, mem->device_base);
+	kfree(mem->bitmap);
+	kfree(mem);
+}
+EXPORT_SYMBOL(dma_free_reserved_memory);
+
+/**
  * dma_alloc_from_coherent() - try to allocate memory from the per-device coherent area
  *
  * @dev:	device from which we allocate memory
