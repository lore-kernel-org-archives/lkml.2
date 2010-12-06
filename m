Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab0LFWQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:16:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35676 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231Ab0LFWQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:16:06 -0500
From: David Sin <davidsin@ti.com>
To: Greg KH <greg@kroah.com>, Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Lajos Molnar <molnar@ti.com>, David Sin <davidsin@ti.com>
Subject: [PATCH 5/9] TILER-DMM: TILER interface file and documentation
Date: Mon,  6 Dec 2010 16:27:22 -0600
Message-Id: <1291674446-10766-6-git-send-email-davidsin@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291674446-10766-1-git-send-email-davidsin@ti.com>
References: <1291674446-10766-1-git-send-email-davidsin@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lajos Molnar <molnar@ti.com>

This patch contains the TILER interface file and the documentation.

Signed-off-by: Lajos Molnar <molnar@ti.com>
Signed-off-by: David Sin <davidsin@ti.com>
---
 Documentation/arm/OMAP/TILER |  126 ++++++++++++++++++++++++++++++
 include/linux/tiler.h        |  173 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 299 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/arm/OMAP/TILER
 create mode 100644 include/linux/tiler.h

diff --git a/Documentation/arm/OMAP/TILER b/Documentation/arm/OMAP/TILER
new file mode 100644
index 0000000..2e94ad7
--- /dev/null
+++ b/Documentation/arm/OMAP/TILER
@@ -0,0 +1,126 @@
+Tiling and Isometric Lightweight Engine for Rotation (TILER) driver
+
+Dynamic Memory Manager (DMM) is a hardware block made by Texas Instruments.
+Within the DMM exists at least one TILER hardware component.  Its purpose is to
+organize video/image memory in a 2-dimensional fashion to limit memory
+bandwidth and facilitate 0 effort rotation and mirroring.  The TILER driver
+facilitates allocating, freeing, as well as mapping 2D blocks (areas) in the
+TILER container(s).  It also facilitates rotating and mirroring the allocated
+blocks or its rectangular subsections.
+
+TERMINOLOGY
+
+"slot"
+
+The basic TILER driver operates on blocks of slots.  A slot is the granularity
+of the TILER hardware device.  For all current uses it is 4K, but could also be
+16 or 64K.  The DMM-TILER TRM refers to this as "page" but we want to separate
+this concept from the MMU pages.
+
+"page"
+
+The granularity of the MMU, used by the kernel.  This is 4K.
+
+"block"
+
+The TILER hardware component supports 1D and 2D blocks.  A 2D block is a
+rectangular arrangement of slots with arbitrary width and height in a 2D 
+container.  A 1D block is a linear arrangement of slots with arbitrary length
+ in a 1D container.  This TILER driver only supports 2D blocks.
+
+"container"
+
+The TILER driver supports an arbitrary TILER container size.  However, for
+all current implementations it is 256 by 128 slots.  The container currently can
+only be used as a 2D container.
+
+"reserved area"
+
+Each block resides within a reserved area in the container.  This area may
+be larger than the actual set of slots that a block occupies.  The reason for
+this is to protect access from one block into another.  Since TILER container is
+mmap-ped into user space as individual pages, all slots that are spanned by
+that page become visible to the user.  The tiler driver allows restricting the
+granularity of the reserved area (default alignment) as well as the mapped
+area (granularity).
+
+Using TILER driver KERNEL APIs:
+
+1. Allocating and freeing a 1080p YUV422 block
+
+        struct tiler_block_t blk = {0};
+        int res;
+
+        blk.width = 1920;
+        blk.height = 1080;
+        res = tiler_alloc(&blk, TILFMT_16BIT, 0, 0);
+
+        tiler_free(&blk);
+
+2. Allocating and freeing a 1080p YUV420p block
+
+        struct tiler_block_t blk_Y = {0}, blk_UV = {0};
+        int res;
+
+        blk_Y.width = 1920;
+        blk_Y.height = 1080;
+        blk_UV.widht = 960;
+        blk_UV.height = 540;
+        res = tiler_alloc(&blk_Y, TILFMT_8BIT, 0, 0) ? :
+                tiler_alloc(&blk_UV, TILFMT_16BIT, PAGE_SIZE,
+                                blk_y->phys & ~PAGE_MASK);
+
+        tiler_free(&blk_Y);
+        tiler_free(&blk_UV);
+
+Note how we allocated the UV block at the same in-page offset as the Y buffer.
+This facilitates mmap-ping both Y and UV blocks into userspace as one
+contiguous buffer.
+
+3. Mmap-ing YUV420p block into user space
+
+        static int my_mmap(struct file *file, struct vm_area_struct *vma)
+        {
+                unsigned long size = (vma->vm_end - vma->vm_start);
+                unsigned long start = vma->vm_start;
+
+                if (size != tiler_size(&blk_Y) + tiler_size(&blk_UV))
+                        return -EINVAL;
+
+                return tiler_mmap_blk(&blk_Y, 0, tiler_size(&blk_Y), vma, 0) ?
+                        : tiler_mmap_blk(&blk_UV, 0, tiler_size(&blk_UV), vma,
+                                tiler_size(&blk_Y));
+        }
+
+CONFIGURATIONS
+
+The TILER driver allows specifying a container manager (tcm) for each
+pixel format.  The same container manager can be specified for more than
+one pixel formats.
+
+Each container manager also operates on a Physical Address Translator PAT
+ instance.  One can also specify a "virtual" PAT (with a linear preassigned
+ memory space no actual PAT programming), but it is not implemented.
+
+PARAMETERS
+
+The TILER driver allows specifying:
+
+    granularity (tiler.grain, CONFIG_TILER_GRANULARITY):
+
+        Each block is mapped in width-chunks of granularity.
+
+    default alignment (tiler.align, CONFIG_TILER_ALIGNMENT):
+
+        Default alignment if aligment is not specified (0). Otherwise,
+        blocks are allocated at an address aligned to the value given plus an
+        offset within the alignment.
+
+    cache limit (tiler.cache, CONFIG_TILER_CACHE_LIMIT):
+
+        TILER driver keeps a cache of allocated pages to speed up allocation of
+        TILER blocks.  You can set a limit of how much memory the TILER driver
+        should keep if there are no actual TILER allocations.  This also means
+        that if there is less memory used than this limit, the pages of freed
+        tiler blocks will not actually be freed, but instead are put into this
+        cache.
diff --git a/include/linux/tiler.h b/include/linux/tiler.h
new file mode 100644
index 0000000..280f7bb
--- /dev/null
+++ b/include/linux/tiler.h
@@ -0,0 +1,173 @@
+/*
+ * TILER driver support functions for TI TILER hardware block.
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
+#ifndef TILER_H
+#define TILER_H
+
+#include <linux/mm.h>
+
+/* API Definitions */
+
+/* return true if physical address is in the tiler container */
+bool is_tiler_addr(u32 phys);
+
+enum tiler_fmt {
+	TILFMT_MIN     = -2,
+	TILFMT_INVALID = -2,
+	TILFMT_NONE    = -1,
+	TILFMT_8BIT    = 0,
+	TILFMT_16BIT   = 1,
+	TILFMT_32BIT   = 2,
+	TILFMT_MAX     = 2,
+	TILFMT_PAGE    = 3,	/* for completeness */
+};
+
+/* tiler block info */
+struct tiler_block_t {
+	u32 phys;		/* system space (L3) tiler addr */
+	u32 width;		/* width */
+	u32 height;		/* height */
+};
+
+/* tiler (image/video frame) view */
+struct tiler_view_t {
+	u32 tsptr;		/* tiler space addr */
+	u32 width;		/* width */
+	u32 height;		/* height */
+	u32 bpp;		/* bytes per pixel */
+	s32 h_inc;		/* horizontal increment */
+	s32 v_inc;		/* vertical increment */
+};
+
+/* get tiler format for a physical address */
+enum tiler_fmt tiler_fmt(u32 phys);
+
+/* get tiler block bytes-per-pixel */
+u32 tiler_bpp(const struct tiler_block_t *b);
+
+/* get tiler block physical stride */
+u32 tiler_pstride(const struct tiler_block_t *b);
+
+/* get tiler block virtual stride */
+static inline u32 tiler_vstride(const struct tiler_block_t *b)
+{
+	return PAGE_ALIGN((b->phys & ~PAGE_MASK) + tiler_bpp(b) * b->width);
+}
+
+/* returns the virtual size of the block (for mmap) */
+static inline u32 tiler_size(const struct tiler_block_t *b)
+{
+	return b->height * tiler_vstride(b);
+}
+
+/*
+ * Reserves a 2D TILER block area and memory.
+ *
+ * @blk:   pointer to tiler block data.  This must be set up ('phys' member must
+ *         be 0) with the tiler block information.
+ * @fmt:   TILER block format
+ * @align: block alignment (default: normally PAGE_SIZE)
+ * @offs:  block offset
+ *
+ */
+s32 tiler_alloc(struct tiler_block_t *blk, enum tiler_fmt fmt, u32 align,
+		u32 offs);
+
+/*
+ * Mmaps a portion of a tiler block to a virtual address.  Use this method in
+ * your driver's mmap function to potentially combine multiple tiler blocks as
+ * one virtual buffer.
+ *
+ * @blk:   pointer to tiler block data
+ * @offs:  offset from where to map (must be page aligned)
+ * @size:  size of area to map (must be page aligned)
+ * @vma:   VMM memory area to map to
+ * @voffs: offset (from vm_start) in the VMM memory area to start mapping at
+ *
+ */
+s32 tiler_mmap_blk(struct tiler_block_t *blk, u32 offs, u32 size,
+				struct vm_area_struct *vma, u32 voffs);
+
+/*
+ * Frees TILER memory.  Since there may be multiple references for the same area
+ * if duplicated by tiler_dup, the area is only actually freed if all references
+ * have been freed.
+ *
+ * @blk:   pointer to a tiler block data as filled by tiler_alloc, tiler_map
+ *         or tiler_dup.  'phys' member will be set to 0 on success.
+ */
+void tiler_free(struct tiler_block_t *blk);
+
+/*
+ * Create a view based on a tiler address and width and height
+ *
+ * This method should only be used as a last resort, e.g. if tilview object
+ * cannot be passed because of incoherence with other view 2D objects that must
+ * be supported.
+ *
+ * @view:   Pointer to a view where the information will be stored
+ * @ssptr:  MUST BE a tiler address
+ * @width:  view width
+ * @height: view height
+ */
+void tilview_create(struct tiler_view_t *view, u32 phys, u32 width, u32 height);
+
+/*
+ * Obtains the view information for a tiler block
+ *
+ * @view:   Pointer to a view where the information will be stored
+ * @blk:    Pointer to an existing allocated tiler block
+ */
+void tilview_get(struct tiler_view_t *view, struct tiler_block_t *blk);
+
+/*
+ * Crops a tiler view to a rectangular portion. Crop area must be fully within
+ * the orginal tiler view: 0 <= left <= left + width <= view->width, also:
+ * 0 <= top <= top + height <= view->height.
+ *
+ * @view:    Pointer to tiler view to be cropped
+ * @left:    x of top-left corner
+ * @top:     y of top-left corner
+ * @width:   crop width
+ * @height:  crop height
+ *
+ * The view will be reduced to the crop region if the crop region is correct.
+ * Otherwise, no modifications are made.
+ */
+s32 tilview_crop(struct tiler_view_t *view, u32 left, u32 top, u32 width,
+								u32 height);
+
+/*
+ * Rotates a tiler view clockwise by a specified degree.
+ *
+ * @view:    Pointer to tiler view to be cropped
+ * @rotate:  Degree of rotation (clockwise).  Must be a multiple of 90.
+ *
+ * View is not modified on error; otherwise, it is updated in place.
+ */
+s32 tilview_rotate(struct tiler_view_t *view, s32 rotation);
+
+/*
+ * Mirrors a tiler view horizontally and/or vertically.
+ *
+ * @view:    Pointer to tiler view to be cropped
+ * @flip_x:  Mirror horizontally (left-to-right)
+ * @flip_y:  Mirror vertically (top-to-bottom)
+ *
+ * View is not modified on error; otherwise, it is updated in place.
+ */
+s32 tilview_flip(struct tiler_view_t *view, bool flip_x, bool flip_y);
+
+#endif
-- 
1.7.0.4

