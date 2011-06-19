Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1FSLrw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 07:47:52 -0400
Received: from mail.southpole.se ([193.12.106.18]:37744 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab1FSLpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 07:45:19 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 07/19] OpenRISC: DMA
Date: Sun, 19 Jun 2011 13:43:33 +0200
Message-Id: <1308483825-6023-8-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308483825-6023-1-git-send-email-jonas@southpole.se>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Simple DMA implementation.  There's some work to do here, but
this allows for allocation of coherent memory (simply uncached) for DMA
operations.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/include/asm/dma-mapping.h |  129 ++++++++++++++++++++++++++
 arch/openrisc/kernel/dma.c              |  152 +++++++++++++++++++++++++++++++
 2 files changed, 281 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/include/asm/dma-mapping.h
 create mode 100644 arch/openrisc/kernel/dma.c

diff --git a/arch/openrisc/include/asm/dma-mapping.h b/arch/openrisc/include/asm/dma-mapping.h
new file mode 100644
index 0000000..10066f4
--- /dev/null
+++ b/arch/openrisc/include/asm/dma-mapping.h
@@ -0,0 +1,129 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_DMA_MAPPING_H
+#define __ASM_OPENRISC_DMA_MAPPING_H
+
+/*
+ * See Documentation/PCI/PCI-DMA-mapping.txt and
+ * Documentation/DMA-API.txt for documentation.
+ */
+
+#include <linux/types.h>
+#include <linux/cache.h>
+#include <linux/mm.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-debug.h>
+#include <linux/dma-attrs.h>
+#include <asm/io.h>
+#include <asm-generic/dma-coherent.h>
+
+#define DMA_ERROR_CODE		(~(dma_addr_t)0x0)
+
+static inline unsigned long device_to_mask(struct device *dev)
+{
+	if (dev->dma_mask && *dev->dma_mask)
+		return *dev->dma_mask;
+	/* Assume devices without mask can take 32 bit addresses */
+	return 0xfffffffful;
+}
+
+extern struct dma_map_ops or1k_dma_ops;
+
+static inline struct dma_map_ops* get_dma_ops(struct device *dev)
+{
+        return &or1k_dma_ops;
+/*#else
+        if (unlikely(!dev) || !dev->archdata.dma_ops)
+                return dma_ops;
+        else
+                return dev->archdata.dma_ops;
+#endif
+*/
+}
+
+#include <asm-generic/dma-mapping-common.h>
+
+/*
+static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
+{
+	dev->archdata.dma_ops = ops;
+}
+*/
+
+static inline int
+dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return 0;
+}
+
+static inline int
+dma_supported(struct device *dev, u64 mask)
+{
+	return 1;
+}
+
+static inline int
+dma_set_mask(struct device *dev, u64 mask)
+{
+	if (!dev->dma_mask || !dma_supported(dev, mask))
+		return -EIO;
+
+	*dev->dma_mask = mask;
+
+	return 0;
+}
+
+#if 0
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	if (ops->mapping_error)
+		return ops->mapping_error(dev, dma_addr);
+
+	return (dma_addr == DMA_ERROR_CODE);
+}
+#endif
+
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
+static inline void *dma_alloc_coherent(struct device *dev, size_t size,
+					dma_addr_t *dma_handle, gfp_t flag)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	void *memory;
+
+	BUG_ON(!ops);
+
+	memory = ops->alloc_coherent(dev, size, dma_handle, flag);
+
+	debug_dma_alloc_coherent(dev, size, *dma_handle, memory);
+	return memory;
+}
+
+static inline void dma_free_coherent(struct device *dev, size_t size,
+				     void *cpu_addr, dma_addr_t dma_handle)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!ops);
+	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
+	ops->free_coherent(dev, size, cpu_addr, dma_handle);
+}
+
+#endif	/* __ASM_OPENRISC_DMA_MAPPING_H */
diff --git a/arch/openrisc/kernel/dma.c b/arch/openrisc/kernel/dma.c
new file mode 100644
index 0000000..3c813a0
--- /dev/null
+++ b/arch/openrisc/kernel/dma.c
@@ -0,0 +1,152 @@
+/*
+ * OpenRISC dma.c
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ * DMA mapping callbacks...
+ * As alloc_coherent is the only DMA callback being used currently, that's
+ * the only thing implemented properly.  The rest need looking into...
+ */
+
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/gfp.h>
+#include <linux/dma-debug.h>
+#include <linux/io.h>
+#include <linux/vmalloc.h>
+#include <asm/bug.h>
+
+/*
+ * Alloc "coherent" memory, which for OpenRISC means simply uncached.
+ */
+static void*
+or1k_dma_alloc_coherent(struct device *dev, size_t size,
+                   dma_addr_t *dma_handle, gfp_t flag)
+{
+	int order;
+	unsigned long page, va;
+	pgprot_t prot;
+	struct vm_struct *area;
+
+	/* Only allocate page size areas. */
+	size = PAGE_ALIGN(size);
+	order = get_order(size);
+
+	page = __get_free_pages(flag, order);
+	if (!page) {
+		return NULL;
+	}
+
+	/* Allocate some common virtual space to map the new pages. */
+	area = get_vm_area(size, VM_ALLOC);
+	if (area == NULL) {
+		free_pages(page, order);
+		return NULL;
+	}
+	va = (unsigned long) area->addr;
+
+	/* This gives us the real physical address of the first page. */
+	//*dma_handle = __pa(page);
+
+	prot = PAGE_KERNEL_NOCACHE;
+
+	/* This isn't so much ioremap as just simply 'remap' */
+	if (ioremap_page_range(va, va + size, page, prot)) {
+		vfree(area->addr);
+		return NULL;
+	}
+
+	*dma_handle = page;
+	return (void*) va;
+}
+
+static void
+or1k_dma_free_coherent(struct device* dev, size_t size, void* vaddr,
+                  dma_addr_t dma_handle)
+{
+	vfree(vaddr);
+}
+
+static int
+or1k_dma_map_sg(struct device *dev, struct scatterlist *sgl,
+                int nents, enum dma_data_direction direction,
+                struct dma_attrs *attrs)
+{
+	struct scatterlist *sg;
+	int i;
+
+	BUG();
+	return 0;
+#if 0
+	/* FIXME this part of code is untested */
+	for_each_sg(sgl, sg, nents, i) {
+		sg->dma_address = sg_phys(sg);
+		__dma_sync_page(page_to_phys(sg_page(sg)), sg->offset,
+							sg->length, direction);
+	}
+
+	return nents;
+#endif
+}
+
+static inline dma_addr_t
+or1k_dma_map_page(struct device *dev,
+                    struct page *page,
+                    unsigned long offset,
+                    size_t size,
+                    enum dma_data_direction direction,
+                    struct dma_attrs *attrs)
+{
+	BUG();
+	return NULL;
+}
+
+#if 0
+static void
+__dma_map_range(dma_addr_t dma_addr, size_t size)
+{
+	struct page *page = pfn_to_page(PFN_DOWN(dma_addr));
+	size_t bytesleft = PAGE_SIZE - (dma_addr & (PAGE_SIZE - 1));
+
+	while ((ssize_t)size > 0) {
+		/* Flush the page. */
+
+                homecache_flush_cache(page++, 0);
+
+                /* Figure out if we need to continue on the next page. */
+                size -= bytesleft;
+                bytesleft = PAGE_SIZE;
+        }
+cacheflush(...);
+}
+#endif
+
+struct dma_map_ops or1k_dma_ops = {
+	.alloc_coherent	= or1k_dma_alloc_coherent,
+	.free_coherent	= or1k_dma_free_coherent,
+	.map_sg		= or1k_dma_map_sg,
+	.map_page	= or1k_dma_map_page,
+};
+EXPORT_SYMBOL(or1k_dma_ops);
+
+/* Number of entries preallocated for DMA-API debugging */
+#define PREALLOC_DMA_DEBUG_ENTRIES (1 << 16)
+
+static int __init dma_init(void)
+{
+       dma_debug_init(PREALLOC_DMA_DEBUG_ENTRIES);
+
+       return 0;
+}
+fs_initcall(dma_init);
-- 
1.7.4.1

