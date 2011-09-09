Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab1IIBPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:15:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53605 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab1IIBLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:11:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6463"; a="116864787"
Message-Id: <20110909010917.279812342@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Thu, 08 Sep 2011 20:09:14 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Linas Vepstas <linas@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [patch v3 27/36] Hexagon: Provide DMA implementation
References: <20110909010847.294039464@codeaurora.org>
Content-Disposition: inline; filename=dma.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basic DMA implementation for our architecture.

Added sync_single_for_* routines; hexagon_map_page() still seems to be a
convenient place to flush/invalidate.


Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Linas Vepstas <linas@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>

---
 arch/hexagon/include/asm/dma-mapping.h |  101 +++++++++++++++
 arch/hexagon/include/asm/dma.h         |   29 ++++
 arch/hexagon/kernel/dma.c              |  220 +++++++++++++++++++++++++++++++++
 3 files changed, 350 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/dma.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/dma.h	2011-09-03 20:14:59.764981503 -0500
@@ -0,0 +1,29 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_DMA_H
+#define _ASM_DMA_H
+
+#include <asm/io.h>
+
+#define MAX_DMA_CHANNELS 1
+#define MAX_DMA_ADDRESS  (PAGE_OFFSET)
+
+extern size_t hexagon_coherent_pool_size;
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/dma-mapping.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/dma-mapping.h	2011-09-03 20:14:59.764981503 -0500
@@ -0,0 +1,101 @@
+/*
+ * DMA operations for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_DMA_MAPPING_H
+#define _ASM_DMA_MAPPING_H
+
+#include <linux/types.h>
+#include <linux/cache.h>
+#include <linux/mm.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+#include <linux/dma-debug.h>
+#include <linux/dma-attrs.h>
+#include <asm/io.h>
+
+struct device;
+extern int bad_dma_address;
+
+extern struct dma_map_ops *dma_ops;
+
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	if (unlikely(dev == NULL))
+		return NULL;
+
+	return dma_ops;
+}
+
+extern int dma_supported(struct device *dev, u64 mask);
+extern int dma_set_mask(struct device *dev, u64 mask);
+extern int dma_is_consistent(struct device *dev, dma_addr_t dma_handle);
+extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+			   enum dma_data_direction direction);
+
+#include <asm-generic/dma-mapping-common.h>
+
+static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
+{
+	if (!dev->dma_mask)
+		return 0;
+	return addr + size - 1 <= *dev->dma_mask;
+}
+
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+
+	if (dma_ops->mapping_error)
+		return dma_ops->mapping_error(dev, dma_addr);
+
+	return (dma_addr == bad_dma_address);
+}
+
+static inline void *dma_alloc_coherent(struct device *dev, size_t size,
+				       dma_addr_t *dma_handle, gfp_t flag)
+{
+	void *ret;
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!dma_ops);
+
+	ret = ops->alloc_coherent(dev, size, dma_handle, flag);
+
+	debug_dma_alloc_coherent(dev, size, *dma_handle, ret);
+
+	return ret;
+}
+
+static inline void dma_free_coherent(struct device *dev, size_t size,
+				     void *cpu_addr, dma_addr_t dma_handle)
+{
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+
+	BUG_ON(!dma_ops);
+
+	dma_ops->free_coherent(dev, size, cpu_addr, dma_handle);
+
+	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
+}
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/kernel/dma.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/dma.c	2011-09-07 13:00:31.040646956 -0500
@@ -0,0 +1,220 @@
+/*
+ * DMA implementation for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/bootmem.h>
+#include <linux/genalloc.h>
+#include <asm/dma-mapping.h>
+
+struct dma_map_ops *dma_ops;
+EXPORT_SYMBOL(dma_ops);
+
+int bad_dma_address;  /*  globals are automatically initialized to zero  */
+
+int dma_supported(struct device *dev, u64 mask)
+{
+	if (mask == DMA_BIT_MASK(32))
+		return 1;
+	else
+		return 0;
+}
+EXPORT_SYMBOL(dma_supported);
+
+int dma_set_mask(struct device *dev, u64 mask)
+{
+	if (!dev->dma_mask || !dma_supported(dev, mask))
+		return -EIO;
+
+	*dev->dma_mask = mask;
+
+	return 0;
+}
+EXPORT_SYMBOL(dma_set_mask);
+
+static struct gen_pool *coherent_pool;
+
+
+/* Allocates from a pool of uncached memory that was reserved at boot time */
+
+void *hexagon_dma_alloc_coherent(struct device *dev, size_t size,
+				 dma_addr_t *dma_addr, gfp_t flag)
+{
+	void *ret;
+
+	if (coherent_pool == NULL) {
+		coherent_pool = gen_pool_create(PAGE_SHIFT, -1);
+
+		if (coherent_pool == NULL)
+			panic("Can't create %s() memory pool!", __func__);
+		else
+			gen_pool_add(coherent_pool,
+				(PAGE_OFFSET + (max_low_pfn << PAGE_SHIFT)),
+				hexagon_coherent_pool_size, -1);
+	}
+
+	ret = (void *) gen_pool_alloc(coherent_pool, size);
+
+	if (ret) {
+		memset(ret, 0, size);
+		*dma_addr = (dma_addr_t) (ret - PAGE_OFFSET);
+	} else
+		*dma_addr = ~0;
+
+	return ret;
+}
+
+static void hexagon_free_coherent(struct device *dev, size_t size, void *vaddr,
+				  dma_addr_t dma_addr)
+{
+	gen_pool_free(coherent_pool, (unsigned long) vaddr, size);
+}
+
+static int check_addr(const char *name, struct device *hwdev,
+		      dma_addr_t bus, size_t size)
+{
+	if (hwdev && hwdev->dma_mask && !dma_capable(hwdev, bus, size)) {
+		if (*hwdev->dma_mask >= DMA_BIT_MASK(32))
+			printk(KERN_ERR
+				"%s: overflow %Lx+%zu of device mask %Lx\n",
+				name, (long long)bus, size,
+				(long long)*hwdev->dma_mask);
+		return 0;
+	}
+	return 1;
+}
+
+static int hexagon_map_sg(struct device *hwdev, struct scatterlist *sg,
+			  int nents, enum dma_data_direction dir,
+			  struct dma_attrs *attrs)
+{
+	struct scatterlist *s;
+	int i;
+
+	WARN_ON(nents == 0 || sg[0].length == 0);
+
+	for_each_sg(sg, s, nents, i) {
+		s->dma_address = sg_phys(s);
+		if (!check_addr("map_sg", hwdev, s->dma_address, s->length))
+			return 0;
+
+		s->dma_length = s->length;
+
+		flush_dcache_range(PAGE_OFFSET + s->dma_address,
+				   PAGE_OFFSET + s->dma_address + s->length);
+	}
+
+	return nents;
+}
+
+/*
+ * address is virtual
+ */
+static inline void dma_sync(void *addr, size_t size,
+			    enum dma_data_direction dir)
+{
+	switch (dir) {
+	case DMA_TO_DEVICE:
+		hexagon_clean_dcache_range((unsigned long) addr,
+		(unsigned long) addr + size);
+		break;
+	case DMA_FROM_DEVICE:
+		hexagon_inv_dcache_range((unsigned long) addr,
+		(unsigned long) addr + size);
+		break;
+	case DMA_BIDIRECTIONAL:
+		flush_dcache_range((unsigned long) addr,
+		(unsigned long) addr + size);
+		break;
+	default:
+		BUG();
+	}
+}
+
+static inline void *dma_addr_to_virt(dma_addr_t dma_addr)
+{
+	return phys_to_virt((unsigned long) dma_addr);
+}
+
+/**
+ * hexagon_map_page() - maps an address for device DMA
+ * @dev:	pointer to DMA device
+ * @page:	pointer to page struct of DMA memory
+ * @offset:	offset within page
+ * @size:	size of memory to map
+ * @dir:	transfer direction
+ * @attrs:	pointer to DMA attrs (not used)
+ *
+ * Called to map a memory address to a DMA address prior
+ * to accesses to/from device.
+ *
+ * We don't particularly have many hoops to jump through
+ * so far.  Straight translation between phys and virtual.
+ *
+ * DMA is not cache coherent so sync is necessary; this
+ * seems to be a convenient place to do it.
+ *
+ */
+static dma_addr_t hexagon_map_page(struct device *dev, struct page *page,
+				   unsigned long offset, size_t size,
+				   enum dma_data_direction dir,
+				   struct dma_attrs *attrs)
+{
+	dma_addr_t bus = page_to_phys(page) + offset;
+	WARN_ON(size == 0);
+
+	if (!check_addr("map_single", dev, bus, size))
+		return bad_dma_address;
+
+	dma_sync(dma_addr_to_virt(bus), size, dir);
+
+	return bus;
+}
+
+static void hexagon_sync_single_for_cpu(struct device *dev,
+					dma_addr_t dma_handle, size_t size,
+					enum dma_data_direction dir)
+{
+	dma_sync(dma_addr_to_virt(dma_handle), size, dir);
+}
+
+static void hexagon_sync_single_for_device(struct device *dev,
+					dma_addr_t dma_handle, size_t size,
+					enum dma_data_direction dir)
+{
+	dma_sync(dma_addr_to_virt(dma_handle), size, dir);
+}
+
+struct dma_map_ops hexagon_dma_ops = {
+	.alloc_coherent	= hexagon_dma_alloc_coherent,
+	.free_coherent	= hexagon_free_coherent,
+	.map_sg		= hexagon_map_sg,
+	.map_page	= hexagon_map_page,
+	.sync_single_for_cpu = hexagon_sync_single_for_cpu,
+	.sync_single_for_device = hexagon_sync_single_for_device,
+	.is_phys	= 1,
+};
+
+void __init hexagon_dma_init(void)
+{
+	if (dma_ops)
+		return;
+
+	dma_ops = &hexagon_dma_ops;
+}

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

