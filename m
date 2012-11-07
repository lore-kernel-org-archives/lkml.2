Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab2KGKAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:00:19 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:52770 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2KGJ71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:59:27 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 23/31] ARC: I/O and DMA Mappings
Date: Wed,  7 Nov 2012 10:47:46 +0100
Message-Id: <1352281674-2186-24-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TBD: Do we need early ioremap support like openrisc

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/dma-mapping.h            |  176 +++++++++++++++++++++++++
 arch/arc/include/asm/dma.h                    |   14 ++
 arch/arc/include/asm/io.h                     |   26 ++++
 arch/arc/mm/dma.c                             |   91 +++++++++++++
 arch/arc/mm/ioremap.c                         |   62 +++++++++
 arch/arc/plat-arcfpga/include/plat/dma_addr.h |   45 +++++++
 6 files changed, 414 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/dma-mapping.h
 create mode 100644 arch/arc/include/asm/dma.h
 create mode 100644 arch/arc/include/asm/io.h
 create mode 100644 arch/arc/mm/dma.c
 create mode 100644 arch/arc/mm/ioremap.c
 create mode 100644 arch/arc/plat-arcfpga/include/plat/dma_addr.h

diff --git a/arch/arc/include/asm/dma-mapping.h b/arch/arc/include/asm/dma-mapping.h
new file mode 100644
index 0000000..ea0f56f
--- /dev/null
+++ b/arch/arc/include/asm/dma-mapping.h
@@ -0,0 +1,176 @@
+/*
+ * DMA Mapping glue for ARC
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef ASM_ARC_DMA_MAPPING_H
+#define ASM_ARC_DMA_MAPPING_H
+
+#include <asm-generic/dma-coherent.h>
+#include <plat/dma_addr.h>
+
+void *dma_alloc_noncoherent(struct device *dev, size_t size,
+			    dma_addr_t *dma_handle, gfp_t gfp);
+
+void dma_free_noncoherent(struct device *dev, size_t size, void *vaddr,
+			  dma_addr_t dma_handle);
+
+void *dma_alloc_coherent(struct device *dev, size_t size,
+			 dma_addr_t *dma_handle, gfp_t gfp);
+
+void dma_free_coherent(struct device *dev, size_t size, void *kvaddr,
+		       dma_addr_t dma_handle);
+
+/*
+ * streaming DMA Mapping API...
+ * CPU accesses page via normal paddr, thus needs to explicitly made
+ * consistent before each use
+ */
+
+static inline void __inline_dma_cache_sync(unsigned long paddr, size_t size,
+					   enum dma_data_direction dir)
+{
+	switch (dir) {
+	case DMA_FROM_DEVICE:
+		dma_cache_inv(paddr, size);
+		break;
+	case DMA_TO_DEVICE:
+		dma_cache_wback(paddr, size);
+		break;
+	case DMA_BIDIRECTIONAL:
+		dma_cache_wback_inv(paddr, size);
+		break;
+	default:
+		pr_err("Invalid DMA dir [%d] for OP @ %lx\n", dir, paddr);
+	}
+}
+
+void __arc_dma_cache_sync(unsigned long paddr, size_t size,
+			  enum dma_data_direction dir);
+
+#define _dma_cache_sync(addr, sz, dir)			\
+do {							\
+	if (__builtin_constant_p(dir))			\
+		__inline_dma_cache_sync(addr, sz, dir);	\
+	else						\
+		__arc_dma_cache_sync(addr, sz, dir);	\
+}							\
+while (0);
+
+static inline dma_addr_t
+dma_map_single(struct device *dev, void *cpu_addr, size_t size,
+	       enum dma_data_direction dir)
+{
+	_dma_cache_sync((unsigned long)cpu_addr, size, dir);
+	return plat_kernel_addr_to_dma(dev, cpu_addr);
+}
+
+static inline void
+dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
+		 size_t size, enum dma_data_direction dir)
+{
+}
+
+static inline dma_addr_t
+dma_map_page(struct device *dev, struct page *page,
+	     unsigned long offset, size_t size,
+	     enum dma_data_direction dir)
+{
+	unsigned long paddr = page_to_phys(page) + offset;
+	return dma_map_single(dev, (void *)paddr, size, dir);
+}
+
+static inline void
+dma_unmap_page(struct device *dev, dma_addr_t dma_handle,
+	       size_t size, enum dma_data_direction dir)
+{
+}
+
+static inline int
+dma_map_sg(struct device *dev, struct scatterlist *sg,
+	   int nents, enum dma_data_direction dir)
+{
+	struct scatterlist *s;
+	int i;
+
+	for_each_sg(sg, s, nents, i)
+		sg->dma_address = dma_map_page(dev, sg_page(s), s->offset,
+					       s->length, dir);
+
+	return nents;
+}
+
+static inline void
+dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+	     int nents, enum dma_data_direction dir)
+{
+	struct scatterlist *s;
+	int i;
+
+	for_each_sg(sg, s, nents, i)
+		dma_unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir);
+}
+
+static inline void
+dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			size_t size, enum dma_data_direction dir)
+{
+	_dma_cache_sync(plat_dma_addr_to_kernel(dev, dma_handle), size,
+			DMA_FROM_DEVICE);
+}
+
+static inline void
+dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
+			   size_t size, enum dma_data_direction dir)
+{
+	_dma_cache_sync(plat_dma_addr_to_kernel(dev, dma_handle), size,
+			DMA_TO_DEVICE);
+}
+
+static inline void
+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
+		    enum dma_data_direction dir)
+{
+	int i;
+
+	for (i = 0; i < nelems; i++, sg++)
+		_dma_cache_sync((unsigned int)sg_virt(sg), sg->length, dir);
+}
+
+static inline void
+dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
+		       enum dma_data_direction dir)
+{
+	int i;
+
+	for (i = 0; i < nelems; i++, sg++)
+		_dma_cache_sync((unsigned int)sg_virt(sg), sg->length, dir);
+}
+
+static inline int dma_supported(struct device *dev, u64 dma_mask)
+{
+	/* Support 32 bit DMA mask exclusively */
+	return dma_mask == DMA_BIT_MASK(32);
+}
+
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return 0;
+}
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
+#endif
diff --git a/arch/arc/include/asm/dma.h b/arch/arc/include/asm/dma.h
new file mode 100644
index 0000000..ca7c451
--- /dev/null
+++ b/arch/arc/include/asm/dma.h
@@ -0,0 +1,14 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef ASM_ARC_DMA_H
+#define ASM_ARC_DMA_H
+
+#define MAX_DMA_ADDRESS 0xC0000000
+
+#endif
diff --git a/arch/arc/include/asm/io.h b/arch/arc/include/asm/io.h
new file mode 100644
index 0000000..b2221f5
--- /dev/null
+++ b/arch/arc/include/asm/io.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_IO_H
+#define _ASM_ARC_IO_H
+
+#include <asm/byteorder.h>
+#include <asm/page.h>
+
+extern void __iomem *ioremap(unsigned long physaddr, unsigned long size);
+extern void iounmap(const void __iomem *addr);
+
+#define ioremap_nocache(phy, sz)	ioremap(phy, sz)
+#define ioremap_wc(phy, sz)		ioremap(phy, sz)
+
+/* Change struct page to physical address */
+#define page_to_phys(page)		(page_to_pfn(page) << PAGE_SHIFT)
+
+#include <asm-generic/io.h>
+
+#endif /* _ASM_ARC_IO_H */
diff --git a/arch/arc/mm/dma.c b/arch/arc/mm/dma.c
new file mode 100644
index 0000000..91fc4ef
--- /dev/null
+++ b/arch/arc/mm/dma.c
@@ -0,0 +1,91 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * Helpers for Coherent DMA API.
+ *
+ * Allocate pages(s) but the CPU always accesses them using a V-P mapping
+ * which has Cached Bit off
+ *
+ * If NON_CONSISTENT request, then CPU accesses page with normal paddr
+ *
+ * For both the cases above, actual DMA handle gen by platform as some
+ * platforms are OK with 0x8000_0000 baed addresses while some are NOT.
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/dma-debug.h>
+#include <linux/export.h>
+#include <asm/cacheflush.h>
+
+void *dma_alloc_noncoherent(struct device *dev, size_t size,
+			    dma_addr_t *dma_handle, gfp_t gfp)
+{
+	void *paddr;
+
+	/* This is linear addr (0x8000_0000 based) */
+	paddr = alloc_pages_exact(size, gfp);
+	if (!paddr)
+		return NULL;
+
+	/* This is bus address, platform dependent */
+	*dma_handle = plat_kernel_addr_to_dma(dev, paddr);
+
+	return paddr;
+}
+EXPORT_SYMBOL(dma_alloc_noncoherent);
+
+void dma_free_noncoherent(struct device *dev, size_t size, void *vaddr,
+			  dma_addr_t dma_handle)
+{
+	free_pages_exact((void *)plat_dma_addr_to_kernel(dev, dma_handle),
+			 size);
+}
+EXPORT_SYMBOL(dma_free_noncoherent);
+
+void *dma_alloc_coherent(struct device *dev, size_t size,
+			 dma_addr_t *dma_handle, gfp_t gfp)
+{
+	void *paddr, *kvaddr;
+
+	/* This is linear addr (0x8000_0000 based) */
+	paddr = alloc_pages_exact(size, gfp);
+	if (!paddr)
+		return NULL;
+
+	/* This is kernel Virtual address (0x7000_0000 based) */
+	kvaddr = ioremap_nocache((unsigned long)paddr, size);
+	if (kvaddr != NULL)
+		memset(kvaddr, 0, size);
+
+	/* This is bus address, platform dependent */
+	*dma_handle = plat_kernel_addr_to_dma(dev, paddr);
+
+	return kvaddr;
+}
+EXPORT_SYMBOL(dma_alloc_coherent);
+
+void dma_free_coherent(struct device *dev, size_t size, void *kvaddr,
+		       dma_addr_t dma_handle)
+{
+	iounmap((void __force __iomem *)kvaddr);
+
+	free_pages_exact((void *)plat_dma_addr_to_kernel(dev, dma_handle),
+			 size);
+}
+EXPORT_SYMBOL(dma_free_coherent);
+
+/*
+ * Helper for streaming DMA...
+ */
+void __arc_dma_cache_sync(unsigned long paddr, size_t size,
+			  enum dma_data_direction dir)
+{
+	__inline_dma_cache_sync(paddr, size, dir);
+}
+EXPORT_SYMBOL(__arc_dma_cache_sync);
diff --git a/arch/arc/mm/ioremap.c b/arch/arc/mm/ioremap.c
new file mode 100644
index 0000000..a82ec3a
--- /dev/null
+++ b/arch/arc/mm/ioremap.c
@@ -0,0 +1,62 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/vmalloc.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/mm.h>
+#include <asm/cache.h>
+
+void __iomem *ioremap(unsigned long paddr, unsigned long size)
+{
+	unsigned long vaddr;
+	struct vm_struct *area;
+	unsigned long off, end;
+	const pgprot_t prot = PAGE_KERNEL_NO_CACHE;
+
+	/* Don't allow wraparound or zero size */
+	end = paddr + size - 1;
+	if (!size || (end < paddr))
+		return NULL;
+
+	/* If the region is h/w uncached, nothing special needed */
+	if (paddr >= ARC_UNCACHED_ADDR_SPACE)
+		return (void __iomem *)paddr;
+
+	/* Mappings have to be page-aligned, page-sized */
+	off = paddr & ~PAGE_MASK;
+	paddr &= PAGE_MASK;
+	size = PAGE_ALIGN(end + 1) - paddr;
+
+	/*
+	 * Ok, go for it..
+	 */
+	area = get_vm_area(size, VM_IOREMAP);
+	if (!area)
+		return NULL;
+
+	area->phys_addr = paddr;
+	vaddr = (unsigned long)area->addr;
+	if (ioremap_page_range(vaddr, vaddr + size, paddr, prot)) {
+		vfree(area->addr);
+		return NULL;
+	}
+
+	return (void __iomem *)(off + (char __iomem *)vaddr);
+}
+EXPORT_SYMBOL(ioremap);
+
+void iounmap(const void __iomem *addr)
+{
+	if (addr >= (void __force __iomem *)ARC_UNCACHED_ADDR_SPACE)
+		return;
+
+	vfree((void *)(PAGE_MASK & (unsigned long __force)addr));
+}
+EXPORT_SYMBOL(iounmap);
diff --git a/arch/arc/plat-arcfpga/include/plat/dma_addr.h b/arch/arc/plat-arcfpga/include/plat/dma_addr.h
new file mode 100644
index 0000000..0e96343
--- /dev/null
+++ b/arch/arc/plat-arcfpga/include/plat/dma_addr.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * vineetg: Feb 2009
+ *  -For AA4 board, kernel to DMA address APIs
+ */
+
+/*
+ * kernel addresses are 0x800_000 based, while Bus addr are 0 based
+ */
+
+#ifndef __PLAT_DMA_ADDR_H
+#define __PLAT_DMA_ADDR_H
+
+#include <linux/device.h>
+
+static inline unsigned long plat_dma_addr_to_kernel(struct device *dev,
+						    dma_addr_t dma_addr)
+{
+	return dma_addr + PAGE_OFFSET;
+}
+
+static inline dma_addr_t plat_kernel_addr_to_dma(struct device *dev, void *ptr)
+{
+	unsigned long addr = (unsigned long)ptr;
+	/*
+	 * To Catch buggy drivers which can call DMA map API with kernel vaddr
+	 * i.e. for buffers alloc via vmalloc or ioremap which are not
+	 * gaurnateed to be PHY contiguous and hence unfit for DMA anyways.
+	 * On ARC kernel virtual address is 0x7000_0000 to 0x7FFF_FFFF, so
+	 * ideally we want to check this range here, but our implementation is
+	 * better as it checks for even worse user virtual address as well.
+	 */
+	if (likely(addr >= PAGE_OFFSET))
+		return addr - PAGE_OFFSET;
+
+	BUG();
+	return addr;
+}
+
+#endif
-- 
1.7.4.1

