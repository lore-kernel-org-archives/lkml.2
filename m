Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab0IWWif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:38:35 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5480 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab0IWWid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:38:33 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 5/9] MIPS: Convert DMA to use dma-mapping-common.h
Date: Thu, 23 Sep 2010 15:38:12 -0700
Message-Id: <1285281496-24696-6-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
References: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 23 Sep 2010 22:38:33.0096 (UTC) FILETIME=[0D7D2080:01CB5B70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use asm-generic/dma-mapping-common.h to handle all DMA mapping
operations and establish a default get_dma_ops() that forwards all
operations to the existing code.

Augment dev_archdata to carry a pointer to the struct dma_map_ops,
allowing DMA operations to be overridden on a per device basis.
Currently this is never filled in, so the default dma_map_ops are
used.  A follow-on patch sets this for Octeon PCI devices.

Also initialize the dma_debug system as it is now used if it is
configured.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/Kconfig                   |    2 +
 arch/mips/include/asm/device.h      |   15 +++-
 arch/mips/include/asm/dma-mapping.h |  125 +++++++++++++++++--------
 arch/mips/mm/dma-default.c          |  179 +++++++++++++---------------------
 4 files changed, 172 insertions(+), 149 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 6c33709..e68b89f 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -14,6 +14,8 @@ config MIPS
 	select HAVE_KRETPROBES
 	select RTC_LIB if !MACH_LOONGSON
 	select GENERIC_ATOMIC64 if !64BIT
+	select HAVE_DMA_ATTRS
+	select HAVE_DMA_API_DEBUG
 
 mainmenu "Linux/MIPS Kernel Configuration"
 
diff --git a/arch/mips/include/asm/device.h b/arch/mips/include/asm/device.h
index 06746c5..65bf274 100644
--- a/arch/mips/include/asm/device.h
+++ b/arch/mips/include/asm/device.h
@@ -3,4 +3,17 @@
  *
  * This file is released under the GPLv2
  */
-#include <asm-generic/device.h>
+#ifndef _ASM_MIPS_DEVICE_H
+#define _ASM_MIPS_DEVICE_H
+
+struct mips_dma_map_ops;
+
+struct dev_archdata {
+	/* DMA operations on that device */
+	struct mips_dma_map_ops	*dma_ops;
+};
+
+struct pdev_archdata {
+};
+
+#endif /* _ASM_MIPS_DEVICE_H*/
diff --git a/arch/mips/include/asm/dma-mapping.h b/arch/mips/include/asm/dma-mapping.h
index 18fbf7a..9a4c307 100644
--- a/arch/mips/include/asm/dma-mapping.h
+++ b/arch/mips/include/asm/dma-mapping.h
@@ -5,51 +5,67 @@
 #include <asm/cache.h>
 #include <asm-generic/dma-coherent.h>
 
-void *dma_alloc_noncoherent(struct device *dev, size_t size,
-			   dma_addr_t *dma_handle, gfp_t flag);
+struct mips_dma_map_ops {
+	struct dma_map_ops dma_map_ops;
+	dma_addr_t (*phys_to_dma)(struct device *dev, phys_addr_t paddr);
+	phys_addr_t (*dma_to_phys)(struct device *dev, dma_addr_t daddr);
+};
 
-void dma_free_noncoherent(struct device *dev, size_t size,
-			 void *vaddr, dma_addr_t dma_handle);
+extern struct mips_dma_map_ops *mips_dma_map_ops;
 
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			   dma_addr_t *dma_handle, gfp_t flag);
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	struct mips_dma_map_ops *ops;
 
-void dma_free_coherent(struct device *dev, size_t size,
-			 void *vaddr, dma_addr_t dma_handle);
+	if (dev && dev->archdata.dma_ops)
+		ops = dev->archdata.dma_ops;
+	else
+		ops = mips_dma_map_ops;
+
+	return &ops->dma_map_ops;
+}
+
+static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
+{
+	struct mips_dma_map_ops *ops = container_of(get_dma_ops(dev),
+						    struct mips_dma_map_ops,
+						    dma_map_ops);
+
+	return ops->phys_to_dma(dev, paddr);
+}
+
+static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
+{
+	struct mips_dma_map_ops *ops = container_of(get_dma_ops(dev),
+						    struct mips_dma_map_ops,
+						    dma_map_ops);
+
+	return ops->dma_to_phys(dev, daddr);
+}
+
+static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
+{
+	if (!dev->dma_mask)
+		return 0;
+
+	return addr + size <= *dev->dma_mask;
+}
+
+static inline void dma_mark_clean(void *addr, size_t size) {}
 
-extern dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
-	enum dma_data_direction direction);
-extern void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
-	size_t size, enum dma_data_direction direction);
-extern int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-	enum dma_data_direction direction);
-extern dma_addr_t dma_map_page(struct device *dev, struct page *page,
-	unsigned long offset, size_t size, enum dma_data_direction direction);
-
-static inline void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
-	size_t size, enum dma_data_direction direction)
+#include <asm-generic/dma-mapping-common.h>
+
+static inline int dma_supported(struct device *dev, u64 mask)
 {
-	dma_unmap_single(dev, dma_address, size, direction);
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	return ops->dma_supported(dev, mask);
 }
 
-extern void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-	int nhwentries, enum dma_data_direction direction);
-extern void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
-	size_t size, enum dma_data_direction direction);
-extern void dma_sync_single_for_device(struct device *dev,
-	dma_addr_t dma_handle, size_t size, enum dma_data_direction direction);
-extern void dma_sync_single_range_for_cpu(struct device *dev,
-	dma_addr_t dma_handle, unsigned long offset, size_t size,
-	enum dma_data_direction direction);
-extern void dma_sync_single_range_for_device(struct device *dev,
-	dma_addr_t dma_handle, unsigned long offset, size_t size,
-	enum dma_data_direction direction);
-extern void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
-	int nelems, enum dma_data_direction direction);
-extern void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
-	int nelems, enum dma_data_direction direction);
-extern int dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
-extern int dma_supported(struct device *dev, u64 mask);
+static inline int dma_mapping_error(struct device *dev, u64 mask)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	return ops->mapping_error(dev, mask);
+}
 
 static inline int
 dma_set_mask(struct device *dev, u64 mask)
@@ -65,4 +81,37 @@ dma_set_mask(struct device *dev, u64 mask)
 extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction);
 
+static inline void *dma_alloc_coherent(struct device *dev, size_t size,
+				       dma_addr_t *dma_handle, gfp_t gfp)
+{
+	void *ret;
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	ret = ops->alloc_coherent(dev, size, dma_handle, gfp);
+
+	debug_dma_alloc_coherent(dev, size, *dma_handle, ret);
+
+	return ret;
+}
+
+static inline void dma_free_coherent(struct device *dev, size_t size,
+				     void *vaddr, dma_addr_t dma_handle)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	ops->free_coherent(dev, size, vaddr, dma_handle);
+
+	debug_dma_free_coherent(dev, size, vaddr, dma_handle);
+}
+
+
+void *dma_alloc_noncoherent(struct device *dev, size_t size,
+			   dma_addr_t *dma_handle, gfp_t flag);
+
+void dma_free_noncoherent(struct device *dev, size_t size,
+			 void *vaddr, dma_addr_t dma_handle);
+
+dma_addr_t mips_unity_phys_to_dma(struct device *dev, phys_addr_t paddr);
+phys_addr_t mips_unity_dma_to_phys(struct device *dev, dma_addr_t daddr);
+
 #endif /* _ASM_DMA_MAPPING_H */
diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index 469d401..4aeae57 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -95,10 +95,9 @@ void *dma_alloc_noncoherent(struct device *dev, size_t size,
 
 	return ret;
 }
-
 EXPORT_SYMBOL(dma_alloc_noncoherent);
 
-void *dma_alloc_coherent(struct device *dev, size_t size,
+static void *mips_dma_alloc_coherent(struct device *dev, size_t size,
 	dma_addr_t * dma_handle, gfp_t gfp)
 {
 	void *ret;
@@ -123,7 +122,6 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
 	return ret;
 }
 
-EXPORT_SYMBOL(dma_alloc_coherent);
 
 void dma_free_noncoherent(struct device *dev, size_t size, void *vaddr,
 	dma_addr_t dma_handle)
@@ -131,10 +129,9 @@ void dma_free_noncoherent(struct device *dev, size_t size, void *vaddr,
 	plat_unmap_dma_mem(dev, dma_handle, size, DMA_BIDIRECTIONAL);
 	free_pages((unsigned long) vaddr, get_order(size));
 }
-
 EXPORT_SYMBOL(dma_free_noncoherent);
 
-void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
+static void mips_dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 	dma_addr_t dma_handle)
 {
 	unsigned long addr = (unsigned long) vaddr;
@@ -151,8 +148,6 @@ void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 	free_pages(addr, get_order(size));
 }
 
-EXPORT_SYMBOL(dma_free_coherent);
-
 static inline void __dma_sync(unsigned long addr, size_t size,
 	enum dma_data_direction direction)
 {
@@ -174,21 +169,8 @@ static inline void __dma_sync(unsigned long addr, size_t size,
 	}
 }
 
-dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
-	enum dma_data_direction direction)
-{
-	unsigned long addr = (unsigned long) ptr;
-
-	if (!plat_device_is_coherent(dev))
-		__dma_sync(addr, size, direction);
-
-	return plat_map_dma_mem(dev, ptr, size);
-}
-
-EXPORT_SYMBOL(dma_map_single);
-
-void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-	enum dma_data_direction direction)
+static void mips_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
+	size_t size, enum dma_data_direction direction, struct dma_attrs *attrs)
 {
 	if (cpu_is_noncoherent_r10000(dev))
 		__dma_sync(dma_addr_to_virt(dev, dma_addr), size,
@@ -197,15 +179,11 @@ void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 	plat_unmap_dma_mem(dev, dma_addr, size, direction);
 }
 
-EXPORT_SYMBOL(dma_unmap_single);
-
-int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-	enum dma_data_direction direction)
+static int mips_dma_map_sg(struct device *dev, struct scatterlist *sg,
+	int nents, enum dma_data_direction direction, struct dma_attrs *attrs)
 {
 	int i;
 
-	BUG_ON(direction == DMA_NONE);
-
 	for (i = 0; i < nents; i++, sg++) {
 		unsigned long addr;
 
@@ -219,33 +197,27 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	return nents;
 }
 
-EXPORT_SYMBOL(dma_map_sg);
-
-dma_addr_t dma_map_page(struct device *dev, struct page *page,
-	unsigned long offset, size_t size, enum dma_data_direction direction)
+static dma_addr_t mips_dma_map_page(struct device *dev, struct page *page,
+	unsigned long offset, size_t size, enum dma_data_direction direction,
+	struct dma_attrs *attrs)
 {
-	BUG_ON(direction == DMA_NONE);
+	unsigned long addr;
 
-	if (!plat_device_is_coherent(dev)) {
-		unsigned long addr;
+	addr = (unsigned long) page_address(page) + offset;
 
-		addr = (unsigned long) page_address(page) + offset;
+	if (!plat_device_is_coherent(dev))
 		__dma_sync(addr, size, direction);
-	}
 
-	return plat_map_dma_mem_page(dev, page) + offset;
+	return plat_map_dma_mem(dev, (void *)addr, size);
 }
 
-EXPORT_SYMBOL(dma_map_page);
-
-void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-	enum dma_data_direction direction)
+static void mips_dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+	int nhwentries, enum dma_data_direction direction,
+	struct dma_attrs *attrs)
 {
 	unsigned long addr;
 	int i;
 
-	BUG_ON(direction == DMA_NONE);
-
 	for (i = 0; i < nhwentries; i++, sg++) {
 		if (!plat_device_is_coherent(dev) &&
 		    direction != DMA_TO_DEVICE) {
@@ -257,13 +229,9 @@ void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
 	}
 }
 
-EXPORT_SYMBOL(dma_unmap_sg);
-
-void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
-	size_t size, enum dma_data_direction direction)
+static void mips_dma_sync_single_for_cpu(struct device *dev,
+	dma_addr_t dma_handle, size_t size, enum dma_data_direction direction)
 {
-	BUG_ON(direction == DMA_NONE);
-
 	if (cpu_is_noncoherent_r10000(dev)) {
 		unsigned long addr;
 
@@ -272,13 +240,9 @@ void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
 	}
 }
 
-EXPORT_SYMBOL(dma_sync_single_for_cpu);
-
-void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
-	size_t size, enum dma_data_direction direction)
+static void mips_dma_sync_single_for_device(struct device *dev,
+	dma_addr_t dma_handle, size_t size, enum dma_data_direction direction)
 {
-	BUG_ON(direction == DMA_NONE);
-
 	plat_extra_sync_for_device(dev);
 	if (!plat_device_is_coherent(dev)) {
 		unsigned long addr;
@@ -288,46 +252,11 @@ void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
 	}
 }
 
-EXPORT_SYMBOL(dma_sync_single_for_device);
-
-void dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
-	unsigned long offset, size_t size, enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-
-	if (cpu_is_noncoherent_r10000(dev)) {
-		unsigned long addr;
-
-		addr = dma_addr_to_virt(dev, dma_handle);
-		__dma_sync(addr + offset, size, direction);
-	}
-}
-
-EXPORT_SYMBOL(dma_sync_single_range_for_cpu);
-
-void dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
-	unsigned long offset, size_t size, enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-
-	plat_extra_sync_for_device(dev);
-	if (!plat_device_is_coherent(dev)) {
-		unsigned long addr;
-
-		addr = dma_addr_to_virt(dev, dma_handle);
-		__dma_sync(addr + offset, size, direction);
-	}
-}
-
-EXPORT_SYMBOL(dma_sync_single_range_for_device);
-
-void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
-	enum dma_data_direction direction)
+static void mips_dma_sync_sg_for_cpu(struct device *dev,
+	struct scatterlist *sg, int nelems, enum dma_data_direction direction)
 {
 	int i;
 
-	BUG_ON(direction == DMA_NONE);
-
 	/* Make sure that gcc doesn't leave the empty loop body.  */
 	for (i = 0; i < nelems; i++, sg++) {
 		if (cpu_is_noncoherent_r10000(dev))
@@ -336,15 +265,11 @@ void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
 	}
 }
 
-EXPORT_SYMBOL(dma_sync_sg_for_cpu);
-
-void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
-	enum dma_data_direction direction)
+static void mips_dma_sync_sg_for_device(struct device *dev,
+	struct scatterlist *sg, int nelems, enum dma_data_direction direction)
 {
 	int i;
 
-	BUG_ON(direction == DMA_NONE);
-
 	/* Make sure that gcc doesn't leave the empty loop body.  */
 	for (i = 0; i < nelems; i++, sg++) {
 		if (!plat_device_is_coherent(dev))
@@ -353,24 +278,18 @@ void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nele
 	}
 }
 
-EXPORT_SYMBOL(dma_sync_sg_for_device);
-
-int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+int mips_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return plat_dma_mapping_error(dev, dma_addr);
 }
 
-EXPORT_SYMBOL(dma_mapping_error);
-
-int dma_supported(struct device *dev, u64 mask)
+int mips_dma_supported(struct device *dev, u64 mask)
 {
 	return plat_dma_supported(dev, mask);
 }
 
-EXPORT_SYMBOL(dma_supported);
-
-void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-	       enum dma_data_direction direction)
+void mips_dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+			 enum dma_data_direction direction)
 {
 	BUG_ON(direction == DMA_NONE);
 
@@ -379,4 +298,44 @@ void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		__dma_sync((unsigned long)vaddr, size, direction);
 }
 
-EXPORT_SYMBOL(dma_cache_sync);
+dma_addr_t mips_unity_phys_to_dma(struct device *dev, phys_addr_t paddr)
+{
+	return paddr;
+}
+
+phys_addr_t mips_unity_dma_to_phys(struct device *dev, dma_addr_t daddr)
+{
+	return daddr;
+}
+
+static struct mips_dma_map_ops mips_default_dma_map_ops = {
+	.dma_map_ops = {
+		.alloc_coherent = mips_dma_alloc_coherent,
+		.free_coherent = mips_dma_free_coherent,
+		.map_page = mips_dma_map_page,
+		.unmap_page = mips_dma_unmap_page,
+		.map_sg = mips_dma_map_sg,
+		.unmap_sg = mips_dma_unmap_sg,
+		.sync_single_for_cpu = mips_dma_sync_single_for_cpu,
+		.sync_single_for_device = mips_dma_sync_single_for_device,
+		.sync_sg_for_cpu = mips_dma_sync_sg_for_cpu,
+		.sync_sg_for_device = mips_dma_sync_sg_for_device,
+		.mapping_error = mips_dma_mapping_error,
+		.dma_supported = mips_dma_supported
+	},
+	.phys_to_dma = mips_unity_phys_to_dma,
+	.dma_to_phys = mips_unity_dma_to_phys
+};
+
+struct mips_dma_map_ops *mips_dma_map_ops = &mips_default_dma_map_ops;
+EXPORT_SYMBOL(mips_dma_map_ops);
+
+#define PREALLOC_DMA_DEBUG_ENTRIES (1 << 16)
+
+static int __init mips_dma_init(void)
+{
+	dma_debug_init(PREALLOC_DMA_DEBUG_ENTRIES);
+
+	return 0;
+}
+fs_initcall(mips_dma_init);
-- 
1.7.2.2

