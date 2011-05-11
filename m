Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab1EKVJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:09:54 -0400
Received: from c-76-97-164-112.hsd1.ga.comcast.net ([76.97.164.112]:55110 "EHLO
	deneb.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756062Ab1EKVGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:06:45 -0400
X-Greylist: delayed 3155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 17:06:39 EDT
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 10/16] C6X: add mm files
Date: Wed, 11 May 2011 16:13:57 -0400
Message-Id: <1305144843-5058-11-git-send-email-msalter@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1305144843-5058-10-git-send-email-msalter@redhat.com>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
 <1305144843-5058-2-git-send-email-msalter@redhat.com>
 <1305144843-5058-3-git-send-email-msalter@redhat.com>
 <1305144843-5058-4-git-send-email-msalter@redhat.com>
 <1305144843-5058-5-git-send-email-msalter@redhat.com>
 <1305144843-5058-6-git-send-email-msalter@redhat.com>
 <1305144843-5058-7-git-send-email-msalter@redhat.com>
 <1305144843-5058-8-git-send-email-msalter@redhat.com>
 <1305144843-5058-9-git-send-email-msalter@redhat.com>
 <1305144843-5058-10-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/mm/Makefile       |   10 ++
 arch/c6x/mm/dma-coherent.c |  342 ++++++++++++++++++++++++++++++++++++++++++++
 arch/c6x/mm/init.c         |  115 +++++++++++++++
 3 files changed, 467 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/mm/Makefile
 create mode 100644 arch/c6x/mm/dma-coherent.c
 create mode 100644 arch/c6x/mm/init.c

diff --git a/arch/c6x/mm/Makefile b/arch/c6x/mm/Makefile
new file mode 100644
index 0000000..75bf2af
--- /dev/null
+++ b/arch/c6x/mm/Makefile
@@ -0,0 +1,10 @@
+#
+# Makefile for the linux c6x-specific parts of the memory manager.
+#
+# Note! Dependencies are done automagically by 'make dep', which also
+# removes any old dependencies. DON'T put your own dependencies here
+# unless it's something special (ie not a .c file).
+#
+# Note 2! The CFLAGS definition is now in the main makefile...
+
+obj-y	 := init.o dma-coherent.o
diff --git a/arch/c6x/mm/dma-coherent.c b/arch/c6x/mm/dma-coherent.c
new file mode 100644
index 0000000..d466869
--- /dev/null
+++ b/arch/c6x/mm/dma-coherent.c
@@ -0,0 +1,342 @@
+/*
+ *  linux/arch/c6x/mm/dma-coherent.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
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
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/vmalloc.h>
+#include <linux/interrupt.h>
+#include <linux/errno.h>
+#include <linux/scatterlist.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/wait.h>
+
+#include <asm-generic/dma-coherent.h>
+#include <linux/dma-mapping.h>
+
+#include <asm/io.h>
+#include <asm/cache.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+
+/*
+ * DMA coherent memory management, can be redefined using the memdma=
+ * kernel command line
+ */
+
+/* by default at the end of the Linux physical memory */
+unsigned long dma_memory_start;
+/* none by default */
+unsigned long dma_memory_size;
+
+static u32    dma_page_heap;
+static u32    dma_page_top;
+
+static DEFINE_SPINLOCK(dma_mem_lock);
+
+/*
+ * Return a DMA coherent and contiguous memory chunk from the DMA memory
+ */
+static inline u32 __dma_alloc_coherent(size_t size, gfp_t gfp)
+{
+	u32 paddr;
+
+	if ((dma_page_heap + size) > dma_page_top)
+		return -1;
+
+	paddr	       = dma_page_heap;
+	dma_page_heap += size;
+
+	return paddr;
+}
+
+/*
+ * Return a standard contigous memory chunk
+ */
+static inline u32 __dma_alloc_coherent_stdmem(size_t size, gfp_t gfp)
+{
+	void *virt;
+
+	virt = kmalloc(size, gfp);
+	if (!virt)
+		return -1;
+
+	return virt_to_phys(virt);
+}
+
+/*
+ * Allocate DMA-coherent memory space and return both the kernel remapped
+ * virtual and bus address for that space.
+ *
+ * Note that this does *not* zero the allocated area!
+ */
+void *
+dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp)
+{
+	u32 paddr;
+	void __iomem *virt;
+
+	if (in_interrupt())
+		BUG();
+
+	/* Round up to a page */
+	size = PAGE_ALIGN(size);
+
+	spin_lock_irq(&dma_mem_lock);
+
+	/* Check if we have a DMA memory */
+	if (dma_page_heap)
+		paddr = __dma_alloc_coherent(size, gfp);
+	else
+		/* Otherwise do an allocation using standard allocator */
+		paddr = __dma_alloc_coherent_stdmem(size, gfp);
+
+	spin_unlock_irq(&dma_mem_lock);
+
+	if (paddr == -1)
+		return NULL;
+
+	if (handle)
+		*handle = __phys_to_bus(paddr);
+
+	/*
+	 * In a near future we can expect having a partial MMU with
+	 * chaching attributes
+	 */
+	virt = ioremap_nocache(paddr, size);
+	if (!virt)
+		return NULL;
+
+	/*
+	 * We need to ensure that there are no cachelines in use, or
+	 * worse dirty in this area.
+	 */
+	L2_cache_block_invalidate(paddr, paddr + size);
+
+	return (void *) virt;
+}
+EXPORT_SYMBOL(dma_alloc_coherent);
+
+/*
+ * Free a DMA coherent and contiguous memory chunk from the DMA memory
+ */
+static inline void __dma_free_coherent(size_t size, dma_addr_t dma_handle)
+{
+	/* Do nothing (we do not have real memory alloctor here) */
+}
+
+/*
+ * Free a standard contigous memory chunk
+ */
+static inline void __dma_free_coherent_stdmem(size_t size, dma_addr_t dma_handle)
+{
+	void *virt = bus_to_virt(dma_handle);
+
+	kfree(virt);
+}
+
+/*
+ * Free a page as defined by the above mapping.
+ * Must not be called with IRQs disabled.
+ */
+void
+dma_free_coherent(struct device *dev, size_t size, void *vaddr, dma_addr_t dma_handle)
+{
+	if (in_interrupt())
+		BUG();
+
+	/* Check if we have a DMA memory */
+	if (dma_page_heap)
+		__dma_free_coherent(size, dma_handle);
+	else
+		/* Otherwise use standard allocator */
+		__dma_free_coherent_stdmem(size, dma_handle);
+
+	iounmap(vaddr);
+}
+EXPORT_SYMBOL(dma_free_coherent);
+
+int
+__dma_is_coherent(struct device *dev, dma_addr_t handle)
+{
+	u32 paddr;
+
+	/* If we do not have DMA memory */
+	if (!dma_page_heap)
+		return 0;
+
+	paddr = __bus_to_phys(handle);
+
+	/*
+	 * If the address is in the DMA memory range, the memory
+	 * is coherent.
+	 */
+	if ((paddr >= dma_memory_start) &&
+	    (paddr < dma_page_top))
+		return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL(__dma_is_coherent);
+
+/*
+ * Make an area consistent for devices.
+ * Note: Drivers should NOT use this function directly, as it will break
+ * platforms with CONFIG_DMABOUNCE.
+ * Use the driver DMA support - see dma-mapping.h (dma_sync_*)
+ */
+void __dma_single_cpu_to_dev(const void *kaddr, size_t size,
+			     enum dma_data_direction dir)
+{
+	unsigned long paddr;
+
+	BUG_ON(!virt_addr_valid(kaddr) || !virt_addr_valid(kaddr + size - 1));
+
+	paddr = __pa(kaddr);
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
+}
+EXPORT_SYMBOL(__dma_single_cpu_to_dev);
+
+void __dma_single_dev_to_cpu(const void *kaddr, size_t size,
+			     enum dma_data_direction dir)
+{
+	BUG_ON(!virt_addr_valid(kaddr) || !virt_addr_valid(kaddr + size - 1));
+
+	/* don't bother invalidating if DMA to device */
+	if (dir != DMA_TO_DEVICE) {
+		unsigned long paddr = __pa(kaddr);
+		L2_cache_block_invalidate(paddr, paddr + size);
+	}
+}
+EXPORT_SYMBOL(__dma_single_dev_to_cpu);
+
+void __dma_page_cpu_to_dev(struct page *page, unsigned long off,
+			   size_t size, enum dma_data_direction dir)
+{
+	unsigned long paddr;
+
+	paddr = page_to_phys(page) + off;
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
+}
+EXPORT_SYMBOL(__dma_page_cpu_to_dev);
+
+void __dma_page_dev_to_cpu(struct page *page, unsigned long off,
+			   size_t size, enum dma_data_direction dir)
+{
+	unsigned long paddr = page_to_phys(page) + off;
+
+	/* don't bother invalidating if DMA to device */
+	if (dir != DMA_TO_DEVICE)
+		L2_cache_block_invalidate(paddr, paddr + size);
+}
+EXPORT_SYMBOL(__dma_page_dev_to_cpu);
+
+/*
+ * Initialise the coherent memory and its allocator
+ */
+int coherent_mem_init(void)
+{
+	/*
+	 * Define the (DMA) coherent memory
+	 */
+	if (dma_memory_size != 0) {
+
+		/* Round it to the (upper) MAR granularity  */
+		dma_memory_size = CACHE_REGION_END(dma_memory_size);
+
+		if (!dma_memory_start) {
+			/*
+			 * Take the coherent memory from the end of the physical
+			 * memory and round it to the lower MAR.
+			 * We may waste some cacheable memory if memory_end is not
+			 * aligned on a MAR region.
+			 */
+			dma_memory_start =
+				CACHE_REGION_START(memory_end - dma_memory_size);
+
+			/* Then remove the coherent memory from the paged one */
+			memory_end = dma_memory_start;
+
+
+		} else {
+			/* Align it on MAR */
+			dma_memory_start = CACHE_REGION_START(dma_memory_start);
+
+			/*
+			 * Check if the defined coherent memory is within the paged
+			 * memory. If so remove the corresponding memory
+			 */
+			if ((dma_memory_start < memory_end) && (dma_memory_start > memory_start))
+				memory_end = dma_memory_start;
+		}
+
+		printk(KERN_INFO "Coherent memory (DMA) region start=0x%lx size=0x%lx\n",
+		       dma_memory_start,
+		       dma_memory_size);
+
+		/*
+		 * We need to ensure that there are no cachelines in use, or
+		 * worse dirty in this area.
+		 */
+		L2_cache_block_writeback(dma_memory_start,
+					 dma_memory_start + dma_memory_size - 1);
+
+		/* Make this memory coherent (so non-cacheable) */
+		disable_caching(dma_memory_start,
+				dma_memory_start + dma_memory_size - 1);
+
+		printk(KERN_INFO "disabling caching for 0x%lx to 0x%lx\n",
+		       dma_memory_start,
+		       dma_memory_start + dma_memory_size - 1);
+
+		/* The allocator starts here */
+		dma_page_heap = dma_memory_start;
+
+		/* And finish here */
+		dma_page_top = PAGE_ALIGN(dma_memory_start + dma_memory_size);
+	}
+
+	return 0;
+}
+
diff --git a/arch/c6x/mm/init.c b/arch/c6x/mm/init.c
new file mode 100644
index 0000000..520bcdc
--- /dev/null
+++ b/arch/c6x/mm/init.c
@@ -0,0 +1,115 @@
+/*
+ *  linux/arch/c6x/mm/init.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/sched.h>
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
+	datak = (_ebss - _sdata) >> 10;
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
1.6.2.5

