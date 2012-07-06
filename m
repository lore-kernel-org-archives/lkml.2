Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab2GFVNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:13:24 -0400
Received: from service87.mimecast.com ([91.220.42.44]:32987 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369Ab2GFVGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:06:43 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 20/36] AArch64: DMA mapping API
Date: Fri,  6 Jul 2012 22:06:01 +0100
Message-Id: <1341608777-12982-21-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 06 Jul 2012 21:07:35.0857 (UTC) FILETIME=[5E0D8A10:01CD5BBB]
X-MC-Unique: 112070622064104301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q66LDmX3005447

This patch adds support for the DMA mapping API. It uses dma_map_ops for
flexibility and it currently supports swiotlb. This patch could be
simplified further if the DMA accesses are coherent (not mandated by the
architecture) or if corresponding hooks are placed in the generic
swiotlb code to deal with cache maintenance.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/aarch64/include/asm/dma-mapping.h |  134 ++++++++++++++++++++
 arch/aarch64/mm/dma-mapping.c          |  209 ++++++++++++++++++++++++++++++++
 2 files changed, 343 insertions(+), 0 deletions(-)
 create mode 100644 arch/aarch64/include/asm/dma-mapping.h
 create mode 100644 arch/aarch64/mm/dma-mapping.c

diff --git a/arch/aarch64/include/asm/dma-mapping.h b/arch/aarch64/include/asm/dma-mapping.h
new file mode 100644
index 0000000..1896880
--- /dev/null
+++ b/arch/aarch64/include/asm/dma-mapping.h
@@ -0,0 +1,134 @@
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
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
+static inline int dma_mmap_coherent(struct device *dev,
+				    struct vm_area_struct *vma,
+				    void *cpu_addr, dma_addr_t dev_addr,
+				    size_t size)
+{
+	vma->vm_page_prot = pgprot_dmacoherent(vma->vm_page_prot);
+	return remap_vmalloc_range(vma, cpu_addr, vma->vm_pgoff);
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
diff --git a/arch/aarch64/mm/dma-mapping.c b/arch/aarch64/mm/dma-mapping.c
new file mode 100644
index 0000000..2ef7a76
--- /dev/null
+++ b/arch/aarch64/mm/dma-mapping.c
@@ -0,0 +1,209 @@
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
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
+static void *aarch64_swiotlb_alloc_coherent(struct device *dev, size_t size,
+					    dma_addr_t *dma_handle, gfp_t flags,
+					    struct dma_attrs *attrs)
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
+static void aarch64_swiotlb_free_coherent(struct device *dev, size_t size,
+					  void *vaddr, dma_addr_t dma_handle,
+					  struct dma_attrs *attrs)
+{
+	vunmap(vaddr);
+	swiotlb_free_coherent(dev, size, vaddr, dma_handle);
+}
+
+static dma_addr_t aarch64_swiotlb_map_page(struct device *dev,
+					   struct page *page,
+					   unsigned long offset, size_t size,
+					   enum dma_data_direction dir,
+					   struct dma_attrs *attrs)
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
+static void aarch64_swiotlb_unmap_page(struct device *dev, dma_addr_t dev_addr,
+				       size_t size, enum dma_data_direction dir,
+				       struct dma_attrs *attrs)
+{
+	dmac_unmap_area(phys_to_virt(dma_to_phys(dev, dev_addr)), size, dir);
+	swiotlb_unmap_page(dev, dev_addr, size, dir, attrs);
+}
+
+static int aarch64_swiotlb_map_sg_attrs(struct device *dev,
+					struct scatterlist *sgl, int nelems,
+					enum dma_data_direction dir,
+					struct dma_attrs *attrs)
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
+static void aarch64_swiotlb_unmap_sg_attrs(struct device *dev,
+					   struct scatterlist *sgl, int nelems,
+					   enum dma_data_direction dir,
+					   struct dma_attrs *attrs)
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
+static void aarch64_swiotlb_sync_single_for_cpu(struct device *dev,
+						dma_addr_t dev_addr,
+						size_t size,
+						enum dma_data_direction dir)
+{
+	dmac_unmap_area(phys_to_virt(dma_to_phys(dev, dev_addr)), size, dir);
+	swiotlb_sync_single_for_cpu(dev, dev_addr, size, dir);
+}
+
+static void aarch64_swiotlb_sync_single_for_device(struct device *dev,
+						   dma_addr_t dev_addr,
+						   size_t size,
+						   enum dma_data_direction dir)
+{
+	swiotlb_sync_single_for_device(dev, dev_addr, size, dir);
+	dmac_map_area(phys_to_virt(dma_to_phys(dev, dev_addr)), size, dir);
+}
+
+static void aarch64_swiotlb_sync_sg_for_cpu(struct device *dev,
+					    struct scatterlist *sgl, int nelems,
+					    enum dma_data_direction dir)
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
+static void aarch64_swiotlb_sync_sg_for_device(struct device *dev,
+					       struct scatterlist *sgl,
+					       int nelems,
+					       enum dma_data_direction dir)
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
+static struct dma_map_ops aarch64_swiotlb_dma_ops = {
+	.alloc = aarch64_swiotlb_alloc_coherent,
+	.free = aarch64_swiotlb_free_coherent,
+	.map_page = aarch64_swiotlb_map_page,
+	.unmap_page = aarch64_swiotlb_unmap_page,
+	.map_sg = aarch64_swiotlb_map_sg_attrs,
+	.unmap_sg = aarch64_swiotlb_unmap_sg_attrs,
+	.sync_single_for_cpu = aarch64_swiotlb_sync_single_for_cpu,
+	.sync_single_for_device = aarch64_swiotlb_sync_single_for_device,
+	.sync_sg_for_cpu = aarch64_swiotlb_sync_sg_for_cpu,
+	.sync_sg_for_device = aarch64_swiotlb_sync_sg_for_device,
+	.dma_supported = swiotlb_dma_supported,
+	.mapping_error = swiotlb_dma_mapping_error,
+};
+
+void __init swiotlb_init_with_default_size(size_t default_size, int verbose);
+
+void __init aarch64_swiotlb_init(size_t max_size)
+{
+	dma_ops = &aarch64_swiotlb_dma_ops;
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

