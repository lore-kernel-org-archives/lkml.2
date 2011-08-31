Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab1HaVct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:32:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603Ab1HaV2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:28:12 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ming.lei@canonical.com,
        stern@rowland.harvard.edu, Mark Salter <msalter@redhat.com>
Subject: [PATCH 07/24] C6X: memory management and DMA support
Date: Wed, 31 Aug 2011 17:26:42 -0400
Message-Id: <1314826019-22330-8-git-send-email-msalter@redhat.com>
In-Reply-To: <1314826019-22330-1-git-send-email-msalter@redhat.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The C6X architecture currently lacks an MMU so memory management is relatively
simple. There is no bus snooping between L2 and main memory but coherent DMA
memory is supported by making regions of main memory uncached. If such a region
is desired, it can be specified on the commandline with a "memdma=" argument.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/dma-mapping.h |   91 +++++++++++++++++++
 arch/c6x/kernel/dma.c              |  168 ++++++++++++++++++++++++++++++++++++
 arch/c6x/mm/dma-coherent.c         |  142 ++++++++++++++++++++++++++++++
 arch/c6x/mm/init.c                 |  112 ++++++++++++++++++++++++
 4 files changed, 513 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/include/asm/dma-mapping.h
 create mode 100644 arch/c6x/kernel/dma.c
 create mode 100644 arch/c6x/mm/dma-coherent.c
 create mode 100644 arch/c6x/mm/init.c

diff --git a/arch/c6x/include/asm/dma-mapping.h b/arch/c6x/include/asm/dma-mapping.h
new file mode 100644
index 0000000..03579fd
--- /dev/null
+++ b/arch/c6x/include/asm/dma-mapping.h
@@ -0,0 +1,91 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot <aurelien.jacquiot@ti.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+#ifndef _ASM_C6X_DMA_MAPPING_H
+#define _ASM_C6X_DMA_MAPPING_H
+
+#include <linux/dma-debug.h>
+#include <asm-generic/dma-coherent.h>
+
+#define dma_supported(d, m)	1
+
+static inline int dma_set_mask(struct device *dev, u64 dma_mask)
+{
+	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
+		return -EIO;
+
+	*dev->dma_mask = dma_mask;
+
+	return 0;
+}
+
+/*
+ * DMA errors are defined by all-bits-set in the DMA address.
+ */
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return dma_addr == ~0;
+}
+
+extern dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
+				 size_t size, enum dma_data_direction dir);
+
+extern void dma_unmap_single(struct device *dev, dma_addr_t handle,
+			     size_t size, enum dma_data_direction dir);
+
+extern int dma_map_sg(struct device *dev, struct scatterlist *sglist,
+		      int nents, enum dma_data_direction direction);
+
+extern void dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
+			 int nents, enum dma_data_direction direction);
+
+static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
+				      unsigned long offset, size_t size,
+				      enum dma_data_direction dir)
+{
+	dma_addr_t handle;
+
+	handle = dma_map_single(dev, page_address(page) + offset, size, dir);
+
+	debug_dma_map_page(dev, page, offset, size, dir, handle, false);
+
+	return handle;
+}
+
+static inline void dma_unmap_page(struct device *dev, dma_addr_t handle,
+		size_t size, enum dma_data_direction dir)
+{
+	dma_unmap_single(dev, handle, size, dir);
+
+	debug_dma_unmap_page(dev, handle, size, dir, false);
+}
+
+extern void dma_sync_single_for_cpu(struct device *dev, dma_addr_t handle,
+				    size_t size, enum dma_data_direction dir);
+
+extern void dma_sync_single_for_device(struct device *dev, dma_addr_t handle,
+				       size_t size,
+				       enum dma_data_direction dir);
+
+extern void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
+				int nents, enum dma_data_direction dir);
+
+extern void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
+				   int nents, enum dma_data_direction dir);
+
+extern void coherent_mem_init(u32 start, u32 size);
+extern void *dma_alloc_coherent(struct device *, size_t, dma_addr_t *, gfp_t);
+extern void dma_free_coherent(struct device *, size_t, void *, dma_addr_t);
+
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent((d), (s), (h), (f))
+#define dma_free_noncoherent(d, s, v, h)  dma_free_coherent((d), (s), (v), (h))
+
+#endif	/* _ASM_C6X_DMA_MAPPING_H */
diff --git a/arch/c6x/kernel/dma.c b/arch/c6x/kernel/dma.c
new file mode 100644
index 0000000..4120de0
--- /dev/null
+++ b/arch/c6x/kernel/dma.c
@@ -0,0 +1,168 @@
+/*
+ *  Copyright (C) 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/dma-mapping.h>
+#include <linux/mm.h>
+#include <linux/mm_types.h>
+#include <linux/scatterlist.h>
+
+#include <asm/cacheflush.h>
+
+dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
+			  enum dma_data_direction dir)
+{
+	dma_addr_t addr = virt_to_phys(ptr);
+
+	BUG_ON(!valid_dma_direction(dir));
+
+	switch (dir) {
+	case DMA_FROM_DEVICE:
+		L2_cache_block_invalidate(addr, addr + size);
+		break;
+	case DMA_TO_DEVICE:
+		L2_cache_block_writeback(addr, addr + size);
+		break;
+	case DMA_BIDIRECTIONAL:
+		/*
+		 * If area will be used bidirectionally, syncing will
+		 * take place manually in the driver.
+		 */
+	default:
+		break;
+	}
+
+	debug_dma_map_page(dev, virt_to_page(ptr),
+			   (unsigned long)ptr & ~PAGE_MASK, size,
+			   dir, addr, true);
+	return addr;
+}
+EXPORT_SYMBOL(dma_map_single);
+
+
+void dma_unmap_single(struct device *dev, dma_addr_t handle,
+		      size_t size, enum dma_data_direction dir)
+{
+	/* nothing to do here */
+	debug_dma_unmap_page(dev, handle, size, dir, true);
+}
+EXPORT_SYMBOL(dma_unmap_single);
+
+
+int dma_map_sg(struct device *dev, struct scatterlist *sglist,
+	       int nents, enum dma_data_direction dir)
+{
+	struct scatterlist *sg;
+	int i;
+
+	for_each_sg(sglist, sg, nents, i)
+		sg->dma_address = dma_map_single(dev, sg_virt(sg), sg->length,
+						 dir);
+
+	debug_dma_map_sg(dev, sglist, nents, nents, dir);
+
+	return nents;
+}
+EXPORT_SYMBOL(dma_map_sg);
+
+
+void dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
+		  int nents, enum dma_data_direction dir)
+{
+	struct scatterlist *sg;
+	int i;
+
+	for_each_sg(sglist, sg, nents, i)
+		dma_unmap_single(dev, sg_dma_address(sg), sg->length, dir);
+
+	debug_dma_unmap_sg(dev, sglist,	nents, dir);
+}
+EXPORT_SYMBOL(dma_unmap_sg);
+
+
+void dma_sync_single_for_cpu(struct device *dev, dma_addr_t handle,
+			     size_t size, enum dma_data_direction dir)
+{
+	unsigned long paddr = handle;
+
+	BUG_ON(!valid_dma_direction(dir));
+
+	switch (dir) {
+	case DMA_FROM_DEVICE:
+		L2_cache_block_invalidate(paddr, paddr + size);
+		break;
+	case DMA_TO_DEVICE:
+		L2_cache_block_writeback(paddr, paddr + size);
+		break;
+	case DMA_BIDIRECTIONAL:
+		L2_cache_block_writeback_invalidate(paddr, paddr + size);
+		break;
+	default:
+		break;
+	}
+
+	debug_dma_sync_single_for_cpu(dev, handle, size, dir);
+}
+EXPORT_SYMBOL(dma_sync_single_for_cpu);
+
+
+void dma_sync_single_for_device(struct device *dev, dma_addr_t handle,
+				size_t size, enum dma_data_direction dir)
+{
+	unsigned long paddr = handle;
+
+	BUG_ON(!valid_dma_direction(dir));
+
+	/* don't bother invalidating if DMA to device */
+	if (dir != DMA_TO_DEVICE)
+		L2_cache_block_invalidate(paddr, paddr + size);
+
+	debug_dma_sync_single_for_device(dev, handle, size, dir);
+}
+EXPORT_SYMBOL(dma_sync_single_for_device);
+
+
+void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sglist,
+			 int nents, enum dma_data_direction dir)
+{
+	struct scatterlist *sg;
+	int i;
+
+	for_each_sg(sglist, sg, nents, i)
+		dma_sync_single_for_cpu(dev, sg_dma_address(sg),
+					sg->length, dir);
+
+	debug_dma_sync_sg_for_cpu(dev, sglist, nents, dir);
+}
+EXPORT_SYMBOL(dma_sync_sg_for_cpu);
+
+
+void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
+			    int nents, enum dma_data_direction dir)
+{
+	struct scatterlist *sg;
+	int i;
+
+	for_each_sg(sglist, sg, nents, i)
+		dma_sync_single_for_device(dev, sg_dma_address(sg),
+					   sg->length, dir);
+
+	debug_dma_sync_sg_for_device(dev, sglist, nents, dir);
+}
+EXPORT_SYMBOL(dma_sync_sg_for_device);
+
+
+/* Number of entries preallocated for DMA-API debugging */
+#define PREALLOC_DMA_DEBUG_ENTRIES (1 << 16)
+
+static int __init dma_init(void)
+{
+	dma_debug_init(PREALLOC_DMA_DEBUG_ENTRIES);
+
+	return 0;
+}
+fs_initcall(dma_init);
diff --git a/arch/c6x/mm/dma-coherent.c b/arch/c6x/mm/dma-coherent.c
new file mode 100644
index 0000000..98ef9e1
--- /dev/null
+++ b/arch/c6x/mm/dma-coherent.c
@@ -0,0 +1,142 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot <aurelien.jacquiot@ti.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  DMA uncached mapping support.
+ *
+ *  Using code pulled from ARM
+ *  Copyright (C) 2000-2004 Russell King
+ *
+ */
+#include <linux/slab.h>
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+#include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+#include <linux/memblock.h>
+
+#include <asm/page.h>
+
+/*
+ * DMA coherent memory management, can be redefined using the memdma=
+ * kernel command line
+ */
+
+/* none by default */
+static phys_addr_t dma_base;
+static u32 dma_size;
+static u32 dma_pages;
+
+static unsigned long *dma_bitmap;
+
+/* bitmap lock */
+static DEFINE_SPINLOCK(dma_lock);
+
+/*
+ * Return a DMA coherent and contiguous memory chunk from the DMA memory
+ */
+static inline u32 __alloc_dma_pages(int order)
+{
+	unsigned long flags;
+	u32 pos;
+
+	spin_lock_irqsave(&dma_lock, flags);
+	pos = bitmap_find_free_region(dma_bitmap, dma_pages, order);
+	spin_unlock_irqrestore(&dma_lock, flags);
+
+	return dma_base + (pos << PAGE_SHIFT);
+}
+
+static void __free_dma_pages(u32 addr, int order)
+{
+	unsigned long flags;
+	u32 pos = (addr - dma_base) >> PAGE_SHIFT;
+
+	if (addr < dma_base || (pos + (1 << order)) >= dma_pages) {
+		printk(KERN_ERR "%s: freeing outside range.\n", __func__);
+		BUG();
+	}
+
+	spin_lock_irqsave(&dma_lock, flags);
+	bitmap_release_region(dma_bitmap, pos, order);
+	spin_unlock_irqrestore(&dma_lock, flags);
+}
+
+/*
+ * Allocate DMA coherent memory space and return both the kernel
+ * virtual and DMA address for that space.
+ */
+void *dma_alloc_coherent(struct device *dev, size_t size,
+			 dma_addr_t *handle, gfp_t gfp)
+{
+	u32 paddr;
+	int order;
+
+	if (!dma_size || !size)
+		return NULL;
+
+	order = get_count_order(((size - 1) >> PAGE_SHIFT) + 1);
+
+	paddr = __alloc_dma_pages(order);
+
+	if (handle)
+		*handle = paddr;
+
+	if (!paddr)
+		return NULL;
+
+	return phys_to_virt(paddr);
+}
+EXPORT_SYMBOL(dma_alloc_coherent);
+
+/*
+ * Free DMA coherent memory as defined by the above mapping.
+ */
+void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
+		       dma_addr_t dma_handle)
+{
+	int order;
+
+	if (!dma_size || !size)
+		return;
+
+	order = get_count_order(((size - 1) >> PAGE_SHIFT) + 1);
+
+	__free_dma_pages(virt_to_phys(vaddr), order);
+}
+EXPORT_SYMBOL(dma_free_coherent);
+
+/*
+ * Initialise the coherent DMA memory allocator using the given uncached region.
+ */
+void __init coherent_mem_init(phys_addr_t start, u32 size)
+{
+	phys_addr_t bitmap_phys;
+
+	if (!size)
+		return;
+
+	printk(KERN_INFO
+	       "Coherent memory (DMA) region start=0x%x size=0x%x\n",
+	       start, size);
+
+	dma_base = start;
+	dma_size = size;
+
+	/* allocate bitmap */
+	dma_pages = dma_size >> PAGE_SHIFT;
+	if (dma_size & (PAGE_SIZE - 1))
+		++dma_pages;
+
+	bitmap_phys = memblock_alloc(BITS_TO_LONGS(dma_pages) * sizeof(long),
+				     sizeof(long));
+
+	dma_bitmap = phys_to_virt(bitmap_phys);
+	memset(dma_bitmap, 0, dma_pages * PAGE_SIZE);
+}
diff --git a/arch/c6x/mm/init.c b/arch/c6x/mm/init.c
new file mode 100644
index 0000000..6b4d396
--- /dev/null
+++ b/arch/c6x/mm/init.c
@@ -0,0 +1,112 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/mm.h>
+#include <linux/swap.h>
+#include <linux/bootmem.h>
+#ifdef CONFIG_BLK_DEV_RAM
+#include <linux/blkdev.h>
+#endif
+#include <linux/initrd.h>
+
+#include <asm/sections.h>
+
+/*
+ * ZERO_PAGE is a special page that is used for zero-initialized
+ * data and COW.
+ */
+unsigned long empty_zero_page;
+EXPORT_SYMBOL(empty_zero_page);
+
+/*
+ * paging_init() continues the virtual memory environment setup which
+ * was begun by the code in arch/head.S.
+ * The parameters are pointers to where to stick the starting and ending
+ * addresses  of available kernel virtual memory.
+ */
+void __init paging_init(void)
+{
+	struct pglist_data *pgdat = NODE_DATA(0);
+	unsigned long zones_size[MAX_NR_ZONES] = {0, };
+
+	empty_zero_page      = (unsigned long) alloc_bootmem_pages(PAGE_SIZE);
+	memset((void *)empty_zero_page, 0, PAGE_SIZE);
+
+	/*
+	 * Set up user data space
+	 */
+	set_fs(KERNEL_DS);
+
+	/*
+	 * Define zones
+	 */
+	zones_size[ZONE_NORMAL] = (memory_end - PAGE_OFFSET) >> PAGE_SHIFT;
+	pgdat->node_zones[ZONE_NORMAL].zone_start_pfn =
+		__pa(PAGE_OFFSET) >> PAGE_SHIFT;
+
+	free_area_init(zones_size);
+}
+
+void __init mem_init(void)
+{
+	int codek, datak;
+	unsigned long tmp;
+	unsigned long len = memory_end - memory_start;
+
+	high_memory = (void *)(memory_end & PAGE_MASK);
+
+	/* this will put all memory onto the freelists */
+	totalram_pages = free_all_bootmem();
+
+	codek = (_etext - _stext) >> 10;
+	datak = (_end - _sdata) >> 10;
+
+	tmp = nr_free_pages() << PAGE_SHIFT;
+	printk(KERN_INFO "Memory: %luk/%luk RAM (%dk kernel code, %dk data)\n",
+	       tmp >> 10, len >> 10, codek, datak);
+}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+void __init free_initrd_mem(unsigned long start, unsigned long end)
+{
+	int pages = 0;
+	for (; start < end; start += PAGE_SIZE) {
+		ClearPageReserved(virt_to_page(start));
+		init_page_count(virt_to_page(start));
+		free_page(start);
+		totalram_pages++;
+		pages++;
+	}
+	printk(KERN_INFO "Freeing initrd memory: %luk freed\n",
+	       (pages * PAGE_SIZE) >> 10);
+}
+#endif
+
+void __init free_initmem(void)
+{
+	unsigned long addr;
+
+	/*
+	 * The following code should be cool even if these sections
+	 * are not page aligned.
+	 */
+	addr = PAGE_ALIGN((unsigned long)(__init_begin));
+
+	/* next to check that the page we free is not a partial page */
+	for (; addr + PAGE_SIZE < (unsigned long)(__init_end);
+	     addr += PAGE_SIZE) {
+		ClearPageReserved(virt_to_page(addr));
+		init_page_count(virt_to_page(addr));
+		free_page(addr);
+		totalram_pages++;
+	}
+	printk(KERN_INFO "Freeing unused kernel memory: %dK freed\n",
+	       (int) ((addr - PAGE_ALIGN((long) &__init_begin)) >> 10));
+}
-- 
1.7.6

