Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab2IGQeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:34:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34418 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2IGQ1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:54 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 14/31] arm64: DMA mapping API
Date: Fri,  7 Sep 2012 17:26:49 +0100
Message-Id: <1347035226-18649-15-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:52.0910 (UTC) FILETIME=[BAA94EE0:01CD8D15]
X-MC-Unique: 112090717275303501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GZchL008467

This patch adds support for the DMA mapping API. It uses dma_map_ops for
flexibility and it currently supports swiotlb. This patch could be
simplified further if the DMA accesses are coherent (not mandated by the
architecture) or if corresponding hooks are placed in the generic
swiotlb code to deal with cache maintenance.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm64/include/asm/dma-mapping.h |  124 ++++++++++++++++++++++++++++++++++
 arch/arm64/mm/dma-mapping.c          |   79 +++++++++++++++++++++
 2 files changed, 203 insertions(+), 0 deletions(-)
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
index 0000000..5eb2444
--- /dev/null
+++ b/arch/arm64/mm/dma-mapping.c
@@ -0,0 +1,79 @@
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
+	if (IS_ENABLED(CONFIG_ZONE_DMA32) &&
+	    dev->coherent_dma_mask <= DMA_BIT_MASK(32))
+		flags |= GFP_DMA32;
+	return swiotlb_alloc_coherent(dev, size, dma_handle, flags);
+}
+
+static void arm64_swiotlb_free_coherent(struct device *dev, size_t size,
+					void *vaddr, dma_addr_t dma_handle,
+					struct dma_attrs *attrs)
+{
+	swiotlb_free_coherent(dev, size, vaddr, dma_handle);
+}
+
+static struct dma_map_ops arm64_swiotlb_dma_ops = {
+	.alloc = arm64_swiotlb_alloc_coherent,
+	.free = arm64_swiotlb_free_coherent,
+	.map_page = swiotlb_map_page,
+	.unmap_page = swiotlb_unmap_page,
+	.map_sg = swiotlb_map_sg_attrs,
+	.unmap_sg = swiotlb_unmap_sg_attrs,
+	.sync_single_for_cpu = swiotlb_sync_single_for_cpu,
+	.sync_single_for_device = swiotlb_sync_single_for_device,
+	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
+	.sync_sg_for_device = swiotlb_sync_sg_for_device,
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

