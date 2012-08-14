Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab2HNRyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 13:54:18 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55168 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858Ab2HNRxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 13:53:09 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 14/31] arm64: DMA mapping API
Date: Tue, 14 Aug 2012 18:52:15 +0100
Message-Id: <1344966752-16102-15-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 14 Aug 2012 17:54:50.0979 (UTC) FILETIME=[E6F57330:01CD7A45]
X-MC-Unique: 112081418530707901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q7EHxgbF017368

This patch adds support for the DMA mapping API. It uses dma_map_ops for
flexibility and it currently supports swiotlb. This patch could be
simplified further if the DMA accesses are coherent (not mandated by the
architecture) or if corresponding hooks are placed in the generic
swiotlb code to deal with cache maintenance.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/dma-mapping.h |  124 ++++++++++++++++++++
 arch/arm64/mm/dma-mapping.c          |  208 ++++++++++++++++++++++++++++++++++
 2 files changed, 332 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/dma-mapping.h
 create mode 100644 arch/arm64/mm/dma-mapping.c

diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
new file mode 100644
index 0000000..538f4b4
--- /dev/null
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -0,0 +1,124 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_DMA_MAPPING_H
+#define __ASM_DMA_MAPPING_H
+
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+
+#include <asm-generic/dma-coherent.h>
+
+#define ARCH_HAS_DMA_GET_REQUIRED_MASK
+
+extern struct dma_map_ops *dma_ops;
+
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	if (unlikely(!dev) || !dev->archdata.dma_ops)
+		return dma_ops;
+	else
+		return dev->archdata.dma_ops;
+}
+
+#include <asm-generic/dma-mapping-common.h>
+
+static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
+{
+	return (dma_addr_t)paddr;
+}
+
+static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t dev_addr)
+{
+	return (phys_addr_t)dev_addr;
+}
+
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dev_addr)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	return ops->mapping_error(dev, dev_addr);
+}
+
+static inline int dma_supported(struct device *dev, u64 mask)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	return ops->dma_supported(dev, mask);
+}
+
+static inline int dma_set_mask(struct device *dev, u64 mask)
+{
+	if (!dev->dma_mask || !dma_supported(dev, mask))
+		return -EIO;
+	*dev->dma_mask = mask;
+
+	return 0;
+}
+
+static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
+{
+	if (!dev->dma_mask)
+		return 0;
+
+	return addr + size - 1 <= *dev->dma_mask;
+}
+
+static inline void dma_mark_clean(void *addr, size_t size)
+{
+}
+
+static inline void *dma_alloc_coherent(struct device *dev, size_t size,
+				       dma_addr_t *dma_handle, gfp_t flags)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	void *vaddr;
+
+	if (dma_alloc_from_coherent(dev, size, dma_handle, &vaddr))
+		return vaddr;
+
+	vaddr = ops->alloc(dev, size, dma_handle, flags, NULL);
+	debug_dma_alloc_coherent(dev, size, *dma_handle, vaddr);
+	return vaddr;
+}
+
+static inline void dma_free_coherent(struct device *dev, size_t size,
+				     void *vaddr, dma_addr_t dev_addr)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (dma_release_from_coherent(dev, get_order(size), vaddr))
+		return;
+
+	debug_dma_free_coherent(dev, size, vaddr, dev_addr);
+	ops->free(dev, size, vaddr, dev_addr, NULL);
+}
+
+/*
+ * There is no dma_cache_sync() implementation, so just return NULL here.
+ */
+static inline void *dma_alloc_noncoherent(struct device *dev, size_t size,
+					  dma_addr_t *handle, gfp_t flags)
+{
+	return NULL;
+}
+
+static inline void dma_free_noncoherent(struct device *dev, size_t size,
+					void *cpu_addr, dma_addr_t handle)
+{
+}
+
+#endif	/* __KERNEL__ */
+#endif	/* __ASM_DMA_MAPPING_H */
diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
new file mode 100644
index 0000000..4e5871d
--- /dev/null
+++ b/arch/arm64/mm/dma-mapping.c
@@ -0,0 +1,208 @@
+/*
+ * SWIOTLB-based DMA API implementation
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ * Author: Catalin Marinas <catalin.marinas@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/gfp.h>
+#include <linux/export.h>
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+#include <linux/vmalloc.h>
+#include <linux/swiotlb.h>
+
+#include <asm/cacheflush.h>
+
+struct dma_map_ops *dma_ops;
+EXPORT_SYMBOL(dma_ops);
+
+static void *arm64_swiotlb_alloc_coherent(struct device *dev, size_t size,
+					  dma_addr_t *dma_handle, gfp_t flags,
+					  struct dma_attrs *attrs)
+{
+	struct page *page, **map;
+	void *ptr;
+	int order = get_order(size);
+	int i;
+
+	if (dev->coherent_dma_mask != DMA_BIT_MASK(64))
+		flags |= GFP_DMA;
+
+	ptr = swiotlb_alloc_coherent(dev, size, dma_handle, flags);
+	if (!ptr)
+		goto no_mem;
+	map = kmalloc(sizeof(struct page *) << order, flags & ~GFP_DMA);
+	if (!map)
+		goto no_map;
+
+	/* remove any dirty cache lines on the kernel alias */
+	dmac_flush_range(ptr, ptr + size);
+
+	/* create a coherent mapping */
+	page = virt_to_page(ptr);
+	for (i = 0; i < (size >> PAGE_SHIFT); i++)
+		map[i] = page + i;
+	ptr = vmap(map, size >> PAGE_SHIFT, VM_MAP,
+		   pgprot_dmacoherent(pgprot_default)); kfree(map);
+	if (!ptr)
+		goto no_map;
+
+	return ptr;
+
+no_map:
+	swiotlb_free_coherent(dev, size, ptr, *dma_handle);
+no_mem:
+	*dma_handle = ~0;
+	return NULL;
+}
+
+static void arm64_swiotlb_free_coherent(struct device *dev, size_t size,
+					void *vaddr, dma_addr_t dma_handle,
+					struct dma_attrs *attrs)
+{
+	vunmap(vaddr);
+	swiotlb_free_coherent(dev, size, vaddr, dma_handle);
+}
+
+static dma_addr_t arm64_swiotlb_map_page(struct device *dev,
+					 struct page *page,
+					 unsigned long offset, size_t size,
+					 enum dma_data_direction dir,
+					 struct dma_attrs *attrs)
+{
+	dma_addr_t dev_addr;
+
+	dev_addr = swiotlb_map_page(dev, page, offset, size, dir, attrs);
+	dmac_map_area(phys_to_virt(dma_to_phys(dev, dev_addr)), size, dir);
+
+	return dev_addr;
+}
+
+
+static void arm64_swiotlb_unmap_page(struct device *dev, dma_addr_t dev_addr,
+				     size_t size, enum dma_data_direction dir,
+				     struct dma_attrs *attrs)
+{
+	dmac_unmap_area(phys_to_virt(dma_to_phys(dev, dev_addr)), size, dir);
+	swiotlb_unmap_page(dev, dev_addr, size, dir, attrs);
+}
+
+static int arm64_swiotlb_map_sg_attrs(struct device *dev,
+				      struct scatterlist *sgl, int nelems,
+				      enum dma_data_direction dir,
+				      struct dma_attrs *attrs)
+{
+	struct scatterlist *sg;
+	int i, ret;
+
+	ret = swiotlb_map_sg_attrs(dev, sgl, nelems, dir, attrs);
+	for_each_sg(sgl, sg, ret, i)
+		dmac_map_area(phys_to_virt(dma_to_phys(dev, sg->dma_address)),
+			      sg->length, dir);
+
+	return ret;
+}
+
+static void arm64_swiotlb_unmap_sg_attrs(struct device *dev,
+					 struct scatterlist *sgl, int nelems,
+					 enum dma_data_direction dir,
+					 struct dma_attrs *attrs)
+{
+	struct scatterlist *sg;
+	int i;
+
+	for_each_sg(sgl, sg, nelems, i)
+		dmac_unmap_area(phys_to_virt(dma_to_phys(dev, sg->dma_address)),
+				sg->length, dir);
+	swiotlb_unmap_sg_attrs(dev, sgl, nelems, dir, attrs);
+}
+
+static void arm64_swiotlb_sync_single_for_cpu(struct device *dev,
+					      dma_addr_t dev_addr,
+					      size_t size,
+					      enum dma_data_direction dir)
+{
+	dmac_unmap_area(phys_to_virt(dma_to_phys(dev, dev_addr)), size, dir);
+	swiotlb_sync_single_for_cpu(dev, dev_addr, size, dir);
+}
+
+static void arm64_swiotlb_sync_single_for_device(struct device *dev,
+						 dma_addr_t dev_addr,
+						 size_t size,
+						 enum dma_data_direction dir)
+{
+	swiotlb_sync_single_for_device(dev, dev_addr, size, dir);
+	dmac_map_area(phys_to_virt(dma_to_phys(dev, dev_addr)), size, dir);
+}
+
+static void arm64_swiotlb_sync_sg_for_cpu(struct device *dev,
+					  struct scatterlist *sgl, int nelems,
+					  enum dma_data_direction dir)
+{
+	struct scatterlist *sg;
+	int i;
+
+	for_each_sg(sgl, sg, nelems, i)
+		dmac_unmap_area(phys_to_virt(dma_to_phys(dev, sg->dma_address)),
+				sg->length, dir);
+	swiotlb_sync_sg_for_cpu(dev, sgl, nelems, dir);
+}
+
+static void arm64_swiotlb_sync_sg_for_device(struct device *dev,
+					     struct scatterlist *sgl,
+					     int nelems,
+					     enum dma_data_direction dir)
+{
+	struct scatterlist *sg;
+	int i;
+
+	swiotlb_sync_sg_for_device(dev, sgl, nelems, dir);
+	for_each_sg(sgl, sg, nelems, i)
+		dmac_map_area(phys_to_virt(dma_to_phys(dev, sg->dma_address)),
+			      sg->length, dir);
+}
+
+static struct dma_map_ops arm64_swiotlb_dma_ops = {
+	.alloc = arm64_swiotlb_alloc_coherent,
+	.free = arm64_swiotlb_free_coherent,
+	.map_page = arm64_swiotlb_map_page,
+	.unmap_page = arm64_swiotlb_unmap_page,
+	.map_sg = arm64_swiotlb_map_sg_attrs,
+	.unmap_sg = arm64_swiotlb_unmap_sg_attrs,
+	.sync_single_for_cpu = arm64_swiotlb_sync_single_for_cpu,
+	.sync_single_for_device = arm64_swiotlb_sync_single_for_device,
+	.sync_sg_for_cpu = arm64_swiotlb_sync_sg_for_cpu,
+	.sync_sg_for_device = arm64_swiotlb_sync_sg_for_device,
+	.dma_supported = swiotlb_dma_supported,
+	.mapping_error = swiotlb_dma_mapping_error,
+};
+
+void __init swiotlb_init_with_default_size(size_t default_size, int verbose);
+
+void __init arm64_swiotlb_init(size_t max_size)
+{
+	dma_ops = &arm64_swiotlb_dma_ops;
+	swiotlb_init_with_default_size(min((size_t)SZ_64M, max_size), 1);
+}
+
+#define PREALLOC_DMA_DEBUG_ENTRIES	4096
+
+static int __init dma_debug_do_init(void)
+{
+	dma_debug_init(PREALLOC_DMA_DEBUG_ENTRIES);
+	return 0;
+}
+fs_initcall(dma_debug_do_init);

