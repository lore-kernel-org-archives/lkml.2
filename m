Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab0LFWQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:16:16 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49545 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab0LFWQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:16:14 -0500
From: David Sin <davidsin@ti.com>
To: Greg KH <greg@kroah.com>, Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Lajos Molnar <molnar@ti.com>, David Sin <davidsin@ti.com>
Subject: [PATCH 7/9] TILER-DMM: Main TILER driver implementation
Date: Mon,  6 Dec 2010 16:27:24 -0600
Message-Id: <1291674446-10766-8-git-send-email-davidsin@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291674446-10766-1-git-send-email-davidsin@ti.com>
References: <1291674446-10766-1-git-send-email-davidsin@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lajos Molnar <molnar@ti.com>

This patch contains the TILER driver and implementation of the TILER
block manipulation and mapping functions.

It also contains the makefile and config file for the TILER driver.

Signed-off-by: Lajos Molnar <molnar@ti.com>
Signed-off-by: David Sin <davidsin@ti.com>
---
 drivers/misc/tiler/Kconfig       |   72 +++++++
 drivers/misc/tiler/Makefile      |    7 +
 drivers/misc/tiler/tiler-iface.c |   66 ++++++
 drivers/misc/tiler/tiler-main.c  |  405 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 550 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/tiler/Kconfig
 create mode 100644 drivers/misc/tiler/Makefile
 create mode 100644 drivers/misc/tiler/tiler-iface.c
 create mode 100644 drivers/misc/tiler/tiler-main.c

diff --git a/drivers/misc/tiler/Kconfig b/drivers/misc/tiler/Kconfig
new file mode 100644
index 0000000..eae4fb1
--- /dev/null
+++ b/drivers/misc/tiler/Kconfig
@@ -0,0 +1,72 @@
+config HAVE_TI_DMM
+	bool
+	default y
+	depends on ARCH_OMAP4
+
+menuconfig TI_DMM
+        tristate "TI DMM support"
+        default y
+        depends on HAVE_TI_DMM
+        help
+           DMM driver for TI chips.
+
+menuconfig TI_TILER
+        tristate "TI TILER support"
+        default y
+        depends on TI_DMM
+        help
+           TILER driver for TI chips.  The TI TILER device
+           enables video rotation on certain TI chips such as OMAP4 or
+           TI816x.  Video rotation will be limited without TILER support.
+
+config TILER_GRANULARITY
+        int "Allocation granularity"
+        range 1 4096
+        default 128
+        depends on TI_TILER
+        help
+           This option sets the default TILER allocation granularity.  It can
+           be overriden by the tiler.grain boot argument.
+
+           The allocation granularity is the smallest TILER block size (in
+           bytes) managed distinctly by the TILER driver.  TILER blocks of any
+           size are managed in chunks of at least this size.
+
+           Must be a power of 2 in the range of 1 to 4096; however, the TILER
+           driver may use a larger supported granularity.
+
+           Supported values are: 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024,
+           2048, 4096.
+
+config TILER_ALIGNMENT
+        int "Allocation alignment"
+        range 1 4096
+        default 4096
+        depends on TI_TILER
+        help
+           This option sets the default TILER allocation alignment.  It can
+           be overriden by the tiler.align boot argument.
+
+           Must be a power of 2 in the range of 1 to 4096; however, it is
+           naturally aligned to the TILER granularity.
+
+           Supported values are: 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024,
+           2048, 4096.
+
+config TILER_CACHE_LIMIT
+        int "Memory limit to cache free pages in MBytes"
+        range 0 128
+        default 40
+        depends on TI_TILER
+        help
+           This option sets the minimum memory that TILER retains even if
+           there is less TILER allocated memory is use.  The unused memory is
+           instead stored in a cache to speed up allocation and freeing of
+           physical pages.
+
+           This option can be overriden by the tiler.cache boot argument.
+
+           While initially TILER will use less memory than this limit (0), it
+           will not release any memory used until it reaches this limit.
+           Thereafter, TILER will release any unused memory immediately as
+           long as there it is above this threshold.
diff --git a/drivers/misc/tiler/Makefile b/drivers/misc/tiler/Makefile
new file mode 100644
index 0000000..7dbc828
--- /dev/null
+++ b/drivers/misc/tiler/Makefile
@@ -0,0 +1,7 @@
+obj-$(CONFIG_TI_DMM) += dmm.o
+dmm-objs = dmm-main.o
+
+obj-$(CONFIG_TI_TILER) += tcm/
+
+obj-$(CONFIG_TI_TILER) += tiler.o
+tiler-objs = tiler-geom.o tiler-main.o tiler-iface.o tmm-pat.o
diff --git a/drivers/misc/tiler/tiler-iface.c b/drivers/misc/tiler/tiler-iface.c
new file mode 100644
index 0000000..02c95c5
--- /dev/null
+++ b/drivers/misc/tiler/tiler-iface.c
@@ -0,0 +1,66 @@
+/*
+ * TILER driver interace functions for TI TILER hardware block.
+ *
+ * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/mm_types.h>
+#include <asm/mach/map.h>
+
+#include "tiler-geom.h"
+
+/*
+ * Memory-Map Kernel APIs
+ */
+
+s32 tiler_mmap_blk(struct tiler_block_t *blk, u32 offs, u32 size,
+				struct vm_area_struct *vma, u32 voffs)
+{
+	u32 v, p, len;
+
+	/* don't allow mremap */
+	vma->vm_flags |= VM_DONTEXPAND | VM_RESERVED;
+
+	/* mapping must fit into vma */
+	WARN_ON(vma->vm_start > vma->vm_start + voffs ||
+		vma->vm_start + voffs > vma->vm_start + voffs + size ||
+		vma->vm_start + voffs + size > vma->vm_end);
+
+	/* mapping must fit into block */
+	WARN_ON(offs > offs + size || offs + size > tiler_size(blk));
+
+	v = tiler_vstride(blk);
+	p = tiler_pstride(blk);
+
+	/* remap block portion */
+	len = v - (offs % v);	/* initial area to map */
+	while (size) {
+		/* restrict to size still needs mapping */
+		if (len > size)
+			len = size;
+
+		vma->vm_pgoff = (blk->phys + offs) >> PAGE_SHIFT;
+		if (remap_pfn_range(vma, vma->vm_start + voffs, vma->vm_pgoff,
+				    len, vma->vm_page_prot))
+			return -EAGAIN;
+		voffs += len;
+		offs += len + p - v;
+		size -= len;
+		len = v;	/* subsequent area to map */
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tiler_mmap_blk);
+
diff --git a/drivers/misc/tiler/tiler-main.c b/drivers/misc/tiler/tiler-main.c
new file mode 100644
index 0000000..ce9145d
--- /dev/null
+++ b/drivers/misc/tiler/tiler-main.c
@@ -0,0 +1,405 @@
+/*
+ * TILER driver main support functions for TI TILER hardware block.
+ *
+ * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/errno.h>
+#include <linux/mutex.h>
+#include <linux/dma-mapping.h>
+#include <linux/pagemap.h>
+#include <linux/slab.h>
+
+#include <mach/dmm.h>
+#include "tmm.h"
+#include "tiler-geom.h"
+#include "tcm/tcm-sita.h"
+
+static uint default_align = CONFIG_TILER_ALIGNMENT;
+static uint granularity = CONFIG_TILER_GRANULARITY;
+
+module_param_named(align, default_align, uint, 0444);
+MODULE_PARM_DESC(align, "Default block ssptr alignment");
+module_param_named(grain, granularity, uint, 0444);
+MODULE_PARM_DESC(grain, "Granularity (bytes)");
+
+static struct tiler_ops tiler;		/* shared methods and variables */
+
+static struct list_head blocks;		/* all tiler blocks */
+
+static struct mutex mtx;
+static struct tcm *tcm[TILER_FORMATS];
+static struct tmm *tmm[TILER_FORMATS];
+static u32 *dmac_va;
+static dma_addr_t dmac_pa;
+
+/* info for a block */
+struct mem_info {
+	struct list_head global;	/* global blocks */
+	struct tiler_block_t blk;	/* block info */
+	struct tcm_area area;
+	u32 *mem;			/* list of alloced phys addresses */
+};
+
+/*
+ *  TILER Memory Manager (TMM) connectors
+ */
+
+/* wrapper around tmm_map */
+static s32 refill_pat(struct tmm *tmm, struct tcm_area *area, u32 *ptr)
+{
+	s32 res = 0;
+	struct pat_area p_area = {0};
+
+	p_area.x0 = area->p0.x;
+	p_area.y0 = area->p0.y;
+	p_area.x1 = area->p1.x;
+	p_area.y1 = area->p1.y;
+
+	memcpy(dmac_va, ptr, sizeof(*ptr) * tcm_sizeof(*area));
+
+	if (tmm_map(tmm, p_area, dmac_pa))
+		res = -EFAULT;
+
+	return res;
+}
+
+/* wrapper around tmm_clear */
+static void clear_pat(struct tmm *tmm, struct tcm_area *area)
+{
+	struct pat_area p_area = {0};
+
+	p_area.x0 = area->p0.x;
+	p_area.y0 = area->p0.y;
+	p_area.x1 = area->p1.x;
+	p_area.y1 = area->p1.y;
+
+	tmm_clear(tmm, p_area);
+}
+
+/*
+ *  Area handling methods
+ */
+
+/* verify input params and calculate tiler container params for a block */
+static s32 __analyze_area(enum tiler_fmt fmt, u32 width, u32 height,
+			  u16 *x_area, u16 *y_area, u16 *align, u16 *offs)
+{
+	/* input: width, height is in pixels, *align, *offs in bytes */
+	/* output: x_area, y_area, *align in slots */
+
+	/* slot width, height, and row size */
+	u32 slot_row, min_align;
+	const struct tiler_geom *g;
+
+	/* width and height must be positive, format must be 2D */
+	if (!width || !height || fmt == TILFMT_PAGE)
+		return -EINVAL;
+
+	/* align must be 2 power */
+	if (*align & (*align - 1))
+		return -EINVAL;
+
+	/* format must be valid */
+	g = tiler.geom(fmt);
+	if (!g)
+		return -EINVAL;
+
+	/* get the # of bytes per row in 1 slot */
+	slot_row = g->slot_w * g->bpp;
+
+	/* minimum alignment is at least 1 slot.  Use default if needed */
+	min_align = max(slot_row, granularity);
+	*align = ALIGN(*align ? : default_align, min_align);
+
+	/* offset must be multiple of bpp */
+	if (*offs & (g->bpp - 1) || *offs >= *align)
+		return -EINVAL;
+
+	/* round down the offset to the nearest slot size, and increase width
+	   to allow space for having the correct offset */
+	width += (*offs & (min_align - 1)) / g->bpp;
+
+	/* expand width to block size */
+	width = ALIGN(width, min_align / g->bpp);
+
+	/* adjust to slots */
+	*x_area = DIV_ROUND_UP(width, g->slot_w);
+	*y_area = DIV_ROUND_UP(height, g->slot_h);
+	*align /= slot_row;
+
+	if (*x_area > tiler.width || *y_area > tiler.height)
+		return -ENOMEM;
+	return 0;
+}
+
+/* allocate a mem_info structure and reserves a 2d container area */
+static struct mem_info *get_2d_area(u16 w, u16 h, u16 align, struct tcm *tcm)
+{
+	struct mem_info *mi = NULL;
+
+	/* reserve a block struct */
+	mi = kmalloc(sizeof(*mi), GFP_KERNEL);
+	if (!mi)
+		return mi;
+	memset(mi, 0, sizeof(*mi));
+
+	/* reserve an area */
+	if (tcm_reserve_2d(tcm, w, h, align, &mi->area)) {
+		kfree(mi);
+		return NULL;
+	}
+
+	return mi;
+}
+
+/*
+ *  Block operations
+ */
+
+/* free a block */
+static s32 free_block(struct mem_info *mi)
+{
+	/* release memory */
+	if (mi->mem)
+		tmm_free(tmm[tiler_fmt(mi->blk.phys)], mi->mem);
+	clear_pat(tmm[tiler_fmt(mi->blk.phys)], &mi->area);
+
+	/* unreserve area */
+	tcm_free(&mi->area);
+
+	/* have mutex */
+
+	/* safe deletion as list may not have been assigned */
+	if (mi->global.next)
+		list_del(&mi->global);
+
+	kfree(mi);
+	return 0;
+}
+
+/* create an empty block with just an area and add it to the global list */
+static struct mem_info *get_area(enum tiler_fmt fmt, u32 width, u32 height,
+							u16 align, u16 offs)
+{
+	u16 x, y;
+	struct mem_info *mi = NULL;
+	const struct tiler_geom *g = tiler.geom(fmt);
+
+	/* calculate dimensions and alignment in slots */
+	if (__analyze_area(fmt, width, height, &x, &y, &align, &offs))
+		return NULL;
+
+	mi = get_2d_area(x, y, align, tcm[fmt]);
+	if (!mi)
+		return NULL;
+
+	/* have mutex */
+	list_add(&mi->global, &blocks);
+
+	mi->blk.phys = tiler.addr(fmt,
+		mi->area.p0.x * g->slot_w, mi->area.p0.y * g->slot_h)
+		+ offs;
+	return mi;
+}
+
+/* allocate a new tiler block */
+static s32 alloc_block(enum tiler_fmt fmt, u32 width, u32 height,
+		u32 align, u32 offs, struct mem_info **info)
+{
+	struct mem_info *mi = NULL;
+
+	*info = NULL;
+
+	/* only support up to page alignment */
+	if (align > PAGE_SIZE || offs >= (align ? : default_align))
+		return -EINVAL;
+
+	mutex_lock(&mtx);
+
+	/* reserve area in tiler container */
+	mi = get_area(fmt, width, height, align, offs);
+	if (!mi)
+		goto nomem;
+
+	mi->blk.width = width;
+	mi->blk.height = height;
+
+	/* allocate and map if mapping is supported */
+	if (tmm_can_map(tmm[fmt])) {
+		mi->mem = tmm_get(tmm[fmt], tcm_sizeof(mi->area));
+		if (!mi->mem)
+			goto cleanup;
+
+		/* program PAT */
+		if (refill_pat(tmm[fmt], &mi->area, mi->mem))
+			goto cleanup;
+	}
+	*info = mi;
+	mutex_unlock(&mtx);
+	return 0;
+
+cleanup:
+	free_block(mi);
+nomem:
+	mutex_unlock(&mtx);
+	return -ENOMEM;
+}
+
+/*
+ *  Driver code
+ */
+
+/* driver initialization */
+static s32 __init tiler_init(void)
+{
+	s32 r = 0;
+	struct tcm *sita = NULL;
+	struct tmm *tmm_pat = NULL;
+
+	tiler_geom_init(&tiler);
+
+	/* check module parameters for correctness */
+	if (default_align > PAGE_SIZE ||
+	    default_align & (default_align - 1) ||
+	    granularity < 1 || granularity > PAGE_SIZE ||
+	    granularity & (granularity - 1))
+		return -EINVAL;
+
+	/*
+	 * Array of physical pages for PAT programming, which must be a 16-byte
+	 * aligned physical address.
+	 */
+	dmac_va = dma_alloc_coherent(NULL, tiler.width * tiler.height *
+					sizeof(*dmac_va), &dmac_pa, GFP_KERNEL);
+	if (!dmac_va)
+		return -ENOMEM;
+
+	/* Allocate tiler container manager (we share 1 on OMAP4) */
+	sita = sita_init(tiler.width, tiler.height, NULL);
+
+	tcm[TILFMT_8BIT]  = sita;
+	tcm[TILFMT_16BIT] = sita;
+	tcm[TILFMT_32BIT] = sita;
+
+	/* Allocate tiler memory manager (must have 1 unique TMM per TCM ) */
+	tmm_pat = tmm_pat_init(0);
+	tmm[TILFMT_8BIT]  = tmm_pat;
+	tmm[TILFMT_16BIT] = tmm_pat;
+	tmm[TILFMT_32BIT] = tmm_pat;
+
+	if (!sita || !tmm_pat) {
+		r = -ENOMEM;
+		goto error;
+	}
+
+	mutex_init(&mtx);
+	INIT_LIST_HEAD(&blocks);
+
+error:
+	if (r) {
+		tcm_deinit(sita);
+		tmm_deinit(tmm_pat);
+		dma_free_coherent(NULL, tiler.width * tiler.height *
+					sizeof(*dmac_va), dmac_va, dmac_pa);
+	}
+
+	return r;
+}
+
+/* driver cleanup */
+static void __exit tiler_exit(void)
+{
+	int i, j;
+	struct mem_info *mi, *mi_;
+
+	mutex_lock(&mtx);
+
+	/* free all blocks */
+	list_for_each_entry_safe(mi, mi_, &blocks, global)
+		free_block(mi);
+
+	/* all lists should have cleared */
+	WARN_ON(!list_empty(&blocks));
+
+	mutex_unlock(&mtx);
+
+	dma_free_coherent(NULL, tiler.width * tiler.height * sizeof(*dmac_va),
+							dmac_va, dmac_pa);
+
+	/* close containers only once */
+	for (i = TILFMT_MIN; i <= TILFMT_MAX; i++) {
+		/*
+		 * Remove identical containers.  TILER Memory Manager (TMM)
+		 * is unique per TILER Container Manager (TCM)
+		 */
+		for (j = i + 1; j <= TILFMT_MAX; j++)
+			if (tcm[i] == tcm[j]) {
+				tcm[j] = NULL;
+				tmm[j] = NULL;
+			}
+
+		tcm_deinit(tcm[i]);
+		tmm_deinit(tmm[i]);
+	}
+
+	mutex_destroy(&mtx);
+}
+
+/*
+ *  Block Kernel APIs
+ */
+
+s32 tiler_alloc(struct tiler_block_t *blk, enum tiler_fmt fmt,
+		u32 align, u32 offs)
+{
+	struct mem_info *mi;
+	s32 res;
+
+	/* blk must be valid, and blk->phys must be 0 */
+	WARN_ON(!blk || blk->phys);
+
+	res = alloc_block(fmt, blk->width, blk->height, align, offs, &mi);
+	if (mi)
+		blk->phys = mi->blk.phys;
+	return res;
+}
+EXPORT_SYMBOL_GPL(tiler_alloc);
+
+void tiler_free(struct tiler_block_t *blk)
+{
+	struct mem_info *mi;
+
+	mutex_lock(&mtx);
+
+	/* find block */
+	list_for_each_entry(mi, &blocks, global) {
+		if (mi->blk.phys == blk->phys) {
+			free_block(mi);
+			break;
+		}
+	}
+
+	blk->phys = 0;
+
+	mutex_unlock(&mtx);
+}
+EXPORT_SYMBOL_GPL(tiler_free);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Lajos Molnar <molnar@ti.com>");
+MODULE_AUTHOR("David Sin <davidsin@ti.com>");
+module_init(tiler_init);
+module_exit(tiler_exit);
-- 
1.7.0.4

