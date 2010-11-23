Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab0KWSe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 13:34:28 -0500
Received: from [69.28.251.93] ([69.28.251.93]:49486 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab0KWSe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 13:34:27 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <dediao@cisco.com>, <ddaney@caviumnetworks.com>, <dvomlehn@cisco.com>,
        <sshtylyov@mvista.com>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 RESEND 4/7] MIPS: HIGHMEM DMA on noncoherent MIPS32 processors
Date: Tue, 23 Nov 2010 10:26:42 -0800
Message-Id: <9b2005899868ac5f3e209a15c6261e70@localhost>
In-Reply-To: <8a8eee995454c8b271cceb440e31699a@localhost>
References: <8a8eee995454c8b271cceb440e31699a@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MIPS DMA coherency functions do not work properly (i.e. kernel oops)
when HIGHMEM pages are passed in as arguments.  Use kmap_atomic() to
temporarily map high pages for cache maintenance operations.

Tested on a 2.6.37-rc1 1GB HIGHMEM SMP no-alias system.

Signed-off-by: Dezhong Diao <dediao@cisco.com>
Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/mm/dma-default.c |  114 ++++++++++++++++++++++++++------------------
 1 files changed, 68 insertions(+), 46 deletions(-)

diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index 4fc1a0f..1e20758 100644
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
@@ -148,20 +148,20 @@ static void mips_dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 	free_pages(addr, get_order(size));
 }
 
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
@@ -169,12 +169,49 @@ static inline void __dma_sync(unsigned long addr, size_t size,
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
+	do {
+		size_t len = left;
+
+		if (PageHighMem(page)) {
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
+			addr = kmap_atomic(page);
+			__dma_sync_virtual(addr + offset, len, direction);
+			kunmap_atomic(addr);
+		} else
+			__dma_sync_virtual(page_address(page) + offset,
+					   size, direction);
+		offset = 0;
+		page++;
+		left -= len;
+	} while (left);
+}
+
 static void mips_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
 	size_t size, enum dma_data_direction direction, struct dma_attrs *attrs)
 {
 	if (cpu_is_noncoherent_r10000(dev))
-		__dma_sync(dma_addr_to_virt(dev, dma_addr), size,
-		           direction);
+		__dma_sync(dma_addr_to_page(dev, dma_addr),
+			   dma_addr & ~PAGE_MASK, size, direction);
 
 	plat_unmap_dma_mem(dev, dma_addr, size, direction);
 }
@@ -185,13 +222,11 @@ static int mips_dma_map_sg(struct device *dev, struct scatterlist *sg,
 	int i;
 
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
@@ -201,30 +236,23 @@ static dma_addr_t mips_dma_map_page(struct device *dev, struct page *page,
 	unsigned long offset, size_t size, enum dma_data_direction direction,
 	struct dma_attrs *attrs)
 {
-	unsigned long addr;
-
-	addr = (unsigned long) page_address(page) + offset;
-
 	if (!plat_device_is_coherent(dev))
-		__dma_sync(addr, size, direction);
+		__dma_sync(page, offset, size, direction);
 
-	return plat_map_dma_mem(dev, (void *)addr, size);
+	return plat_map_dma_mem_page(dev, page) + offset;
 }
 
 static void mips_dma_unmap_sg(struct device *dev, struct scatterlist *sg,
 	int nhwentries, enum dma_data_direction direction,
 	struct dma_attrs *attrs)
 {
-	unsigned long addr;
 	int i;
 
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
@@ -232,24 +260,18 @@ static void mips_dma_unmap_sg(struct device *dev, struct scatterlist *sg,
 static void mips_dma_sync_single_for_cpu(struct device *dev,
 	dma_addr_t dma_handle, size_t size, enum dma_data_direction direction)
 {
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
 
 static void mips_dma_sync_single_for_device(struct device *dev,
 	dma_addr_t dma_handle, size_t size, enum dma_data_direction direction)
 {
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
 
 static void mips_dma_sync_sg_for_cpu(struct device *dev,
@@ -260,8 +282,8 @@ static void mips_dma_sync_sg_for_cpu(struct device *dev,
 	/* Make sure that gcc doesn't leave the empty loop body.  */
 	for (i = 0; i < nelems; i++, sg++) {
 		if (cpu_is_noncoherent_r10000(dev))
-			__dma_sync((unsigned long)page_address(sg_page(sg)),
-			           sg->length, direction);
+			__dma_sync(sg_page(sg), sg->offset, sg->length,
+				   direction);
 	}
 }
 
@@ -273,8 +295,8 @@ static void mips_dma_sync_sg_for_device(struct device *dev,
 	/* Make sure that gcc doesn't leave the empty loop body.  */
 	for (i = 0; i < nelems; i++, sg++) {
 		if (!plat_device_is_coherent(dev))
-			__dma_sync((unsigned long)page_address(sg_page(sg)),
-			           sg->length, direction);
+			__dma_sync(sg_page(sg), sg->offset, sg->length,
+				   direction);
 	}
 }
 
@@ -295,7 +317,7 @@ void mips_dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 
 	plat_extra_sync_for_device(dev);
 	if (!plat_device_is_coherent(dev))
-		__dma_sync((unsigned long)vaddr, size, direction);
+		__dma_sync_virtual(vaddr, size, direction);
 }
 
 static struct dma_map_ops mips_default_dma_map_ops = {
-- 
1.7.0.4

