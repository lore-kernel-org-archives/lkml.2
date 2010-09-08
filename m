Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab0IHXLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 19:11:21 -0400
Received: from [69.28.251.93] ([69.28.251.93]:46916 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932078Ab0IHXLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 19:11:16 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Wed, 8 Sep 2010 16:02:12 -0700
Subject: [PATCH v2 1/3] MIPS: HIGHMEM DMA on noncoherent MIPS32 processors
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <dediao@cisco.com>, <dvomlehn@cisco.com>, <sshtylyov@mvista.com>,
        <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Message-Id: <064bb0722da5d8c271c2bd9fe0a521cc@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[v2: Formatting changes only.]

The MIPS DMA coherency functions do not work properly (i.e. kernel oops)
when HIGHMEM pages are passed in as arguments.  This patch uses the PPC
approach of calling kmap_atomic() with IRQs disabled to temporarily map
high pages, in order to flush them out to memory.

Signed-off-by: Dezhong Diao <dediao@cisco.com>
Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/mm/dma-default.c |  159 ++++++++++++++++++++++----------------------
 1 files changed, 80 insertions(+), 79 deletions(-)

diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index 469d401..79dfb9c 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -15,18 +15,18 @@
 #include <linux/scatterlist.h>
 #include <linux/string.h>
 #include <linux/gfp.h>
+#include <linux/highmem.h>
 
 #include <asm/cache.h>
 #include <asm/io.h>
 
 #include <dma-coherence.h>
 
-static inline unsigned long dma_addr_to_virt(struct device *dev,
+static inline struct page *dma_addr_to_page(struct device *dev,
 	dma_addr_t dma_addr)
 {
-	unsigned long addr = plat_dma_addr_to_phys(dev, dma_addr);
-
-	return (unsigned long)phys_to_virt(addr);
+	return pfn_to_page(
+		plat_dma_addr_to_phys(dev, dma_addr) >> PAGE_SHIFT);
 }
 
 /*
@@ -153,20 +153,20 @@ void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 
 EXPORT_SYMBOL(dma_free_coherent);
 
-static inline void __dma_sync(unsigned long addr, size_t size,
+static inline void __dma_sync_virtual(void *addr, size_t size,
 	enum dma_data_direction direction)
 {
 	switch (direction) {
 	case DMA_TO_DEVICE:
-		dma_cache_wback(addr, size);
+		dma_cache_wback((unsigned long)addr, size);
 		break;
 
 	case DMA_FROM_DEVICE:
-		dma_cache_inv(addr, size);
+		dma_cache_inv((unsigned long)addr, size);
 		break;
 
 	case DMA_BIDIRECTIONAL:
-		dma_cache_wback_inv(addr, size);
+		dma_cache_wback_inv((unsigned long)addr, size);
 		break;
 
 	default:
@@ -174,13 +174,53 @@ static inline void __dma_sync(unsigned long addr, size_t size,
 	}
 }
 
+/*
+ * A single sg entry may refer to multiple physically contiguous
+ * pages. But we still need to process highmem pages individually.
+ * If highmem is not configured then the bulk of this loop gets
+ * optimized out.
+ */
+static inline void __dma_sync(struct page *page,
+	unsigned long offset, size_t size, enum dma_data_direction direction)
+{
+	size_t left = size;
+
+	BUG_ON(direction == DMA_NONE);
+
+	do {
+		size_t len = left;
+
+		if (PageHighMem(page)) {
+			unsigned long flags;
+			void *addr;
+
+			if (offset + len > PAGE_SIZE) {
+				if (offset >= PAGE_SIZE) {
+					page += offset >> PAGE_SHIFT;
+					offset &= ~PAGE_MASK;
+				}
+				len = PAGE_SIZE - offset;
+			}
+
+			local_irq_save(flags);
+			addr = kmap_atomic(page, KM_SYNC_DCACHE);
+			__dma_sync_virtual(addr + offset, len, direction);
+			kunmap_atomic(addr, KM_SYNC_DCACHE);
+			local_irq_restore(flags);
+		} else
+			__dma_sync_virtual(page_address(page) + offset,
+				size, direction);
+		offset = 0;
+		page++;
+		left -= len;
+	} while (left);
+}
+
 dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 	enum dma_data_direction direction)
 {
-	unsigned long addr = (unsigned long) ptr;
-
 	if (!plat_device_is_coherent(dev))
-		__dma_sync(addr, size, direction);
+		__dma_sync_virtual(ptr, size, direction);
 
 	return plat_map_dma_mem(dev, ptr, size);
 }
@@ -191,8 +231,8 @@ void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 	enum dma_data_direction direction)
 {
 	if (cpu_is_noncoherent_r10000(dev))
-		__dma_sync(dma_addr_to_virt(dev, dma_addr), size,
-		           direction);
+		__dma_sync(dma_addr_to_page(dev, dma_addr),
+			   dma_addr & ~PAGE_MASK, size, direction);
 
 	plat_unmap_dma_mem(dev, dma_addr, size, direction);
 }
@@ -204,16 +244,12 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 {
 	int i;
 
-	BUG_ON(direction == DMA_NONE);
-
 	for (i = 0; i < nents; i++, sg++) {
-		unsigned long addr;
-
-		addr = (unsigned long) sg_virt(sg);
-		if (!plat_device_is_coherent(dev) && addr)
-			__dma_sync(addr, sg->length, direction);
-		sg->dma_address = plat_map_dma_mem(dev,
-				                   (void *)addr, sg->length);
+		if (!plat_device_is_coherent(dev))
+			__dma_sync(sg_page(sg), sg->offset, sg->length,
+				   direction);
+		sg->dma_address = plat_map_dma_mem_page(dev, sg_page(sg)) +
+				  sg->offset;
 	}
 
 	return nents;
@@ -224,14 +260,8 @@ EXPORT_SYMBOL(dma_map_sg);
 dma_addr_t dma_map_page(struct device *dev, struct page *page,
 	unsigned long offset, size_t size, enum dma_data_direction direction)
 {
-	BUG_ON(direction == DMA_NONE);
-
-	if (!plat_device_is_coherent(dev)) {
-		unsigned long addr;
-
-		addr = (unsigned long) page_address(page) + offset;
-		__dma_sync(addr, size, direction);
-	}
+	if (!plat_device_is_coherent(dev))
+		__dma_sync(page, offset, size, direction);
 
 	return plat_map_dma_mem_page(dev, page) + offset;
 }
@@ -241,18 +271,13 @@ EXPORT_SYMBOL(dma_map_page);
 void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
 	enum dma_data_direction direction)
 {
-	unsigned long addr;
 	int i;
 
-	BUG_ON(direction == DMA_NONE);
-
 	for (i = 0; i < nhwentries; i++, sg++) {
 		if (!plat_device_is_coherent(dev) &&
-		    direction != DMA_TO_DEVICE) {
-			addr = (unsigned long) sg_virt(sg);
-			if (addr)
-				__dma_sync(addr, sg->length, direction);
-		}
+		    direction != DMA_TO_DEVICE)
+			__dma_sync(sg_page(sg), sg->offset, sg->length,
+				   direction);
 		plat_unmap_dma_mem(dev, sg->dma_address, sg->length, direction);
 	}
 }
@@ -262,14 +287,9 @@ EXPORT_SYMBOL(dma_unmap_sg);
 void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
 	size_t size, enum dma_data_direction direction)
 {
-	BUG_ON(direction == DMA_NONE);
-
-	if (cpu_is_noncoherent_r10000(dev)) {
-		unsigned long addr;
-
-		addr = dma_addr_to_virt(dev, dma_handle);
-		__dma_sync(addr, size, direction);
-	}
+	if (cpu_is_noncoherent_r10000(dev))
+		__dma_sync(dma_addr_to_page(dev, dma_handle),
+			   dma_handle & ~PAGE_MASK, size, direction);
 }
 
 EXPORT_SYMBOL(dma_sync_single_for_cpu);
@@ -277,15 +297,10 @@ EXPORT_SYMBOL(dma_sync_single_for_cpu);
 void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
 	size_t size, enum dma_data_direction direction)
 {
-	BUG_ON(direction == DMA_NONE);
-
 	plat_extra_sync_for_device(dev);
-	if (!plat_device_is_coherent(dev)) {
-		unsigned long addr;
-
-		addr = dma_addr_to_virt(dev, dma_handle);
-		__dma_sync(addr, size, direction);
-	}
+	if (!plat_device_is_coherent(dev))
+		__dma_sync(dma_addr_to_page(dev, dma_handle),
+			   dma_handle & ~PAGE_MASK, size, direction);
 }
 
 EXPORT_SYMBOL(dma_sync_single_for_device);
@@ -293,14 +308,9 @@ EXPORT_SYMBOL(dma_sync_single_for_device);
 void dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
 	unsigned long offset, size_t size, enum dma_data_direction direction)
 {
-	BUG_ON(direction == DMA_NONE);
-
-	if (cpu_is_noncoherent_r10000(dev)) {
-		unsigned long addr;
-
-		addr = dma_addr_to_virt(dev, dma_handle);
-		__dma_sync(addr + offset, size, direction);
-	}
+	if (cpu_is_noncoherent_r10000(dev))
+		__dma_sync(dma_addr_to_page(dev, dma_handle), offset, size,
+			   direction);
 }
 
 EXPORT_SYMBOL(dma_sync_single_range_for_cpu);
@@ -308,15 +318,10 @@ EXPORT_SYMBOL(dma_sync_single_range_for_cpu);
 void dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
 	unsigned long offset, size_t size, enum dma_data_direction direction)
 {
-	BUG_ON(direction == DMA_NONE);
-
 	plat_extra_sync_for_device(dev);
-	if (!plat_device_is_coherent(dev)) {
-		unsigned long addr;
-
-		addr = dma_addr_to_virt(dev, dma_handle);
-		__dma_sync(addr + offset, size, direction);
-	}
+	if (!plat_device_is_coherent(dev))
+		__dma_sync(dma_addr_to_page(dev, dma_handle), offset, size,
+			   direction);
 }
 
 EXPORT_SYMBOL(dma_sync_single_range_for_device);
@@ -326,13 +331,11 @@ void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
 {
 	int i;
 
-	BUG_ON(direction == DMA_NONE);
-
 	/* Make sure that gcc doesn't leave the empty loop body.  */
 	for (i = 0; i < nelems; i++, sg++) {
 		if (cpu_is_noncoherent_r10000(dev))
-			__dma_sync((unsigned long)page_address(sg_page(sg)),
-			           sg->length, direction);
+			__dma_sync(sg_page(sg), sg->offset, sg->length,
+				   direction);
 	}
 }
 
@@ -343,13 +346,11 @@ void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nele
 {
 	int i;
 
-	BUG_ON(direction == DMA_NONE);
-
 	/* Make sure that gcc doesn't leave the empty loop body.  */
 	for (i = 0; i < nelems; i++, sg++) {
 		if (!plat_device_is_coherent(dev))
-			__dma_sync((unsigned long)page_address(sg_page(sg)),
-			           sg->length, direction);
+			__dma_sync(sg_page(sg), sg->offset, sg->length,
+				   direction);
 	}
 }
 
@@ -376,7 +377,7 @@ void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 
 	plat_extra_sync_for_device(dev);
 	if (!plat_device_is_coherent(dev))
-		__dma_sync((unsigned long)vaddr, size, direction);
+		__dma_sync_virtual(vaddr, size, direction);
 }
 
 EXPORT_SYMBOL(dma_cache_sync);
-- 
1.7.0.4

