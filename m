Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab0LFWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:16:26 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52723 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab0LFWQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:16:18 -0500
From: David Sin <davidsin@ti.com>
To: Greg KH <greg@kroah.com>, Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Lajos Molnar <molnar@ti.com>, David Sin <davidsin@ti.com>
Subject: [PATCH 6/9] TILER-DMM: Geometry and view manipulation functions
Date: Mon,  6 Dec 2010 16:27:23 -0600
Message-Id: <1291674446-10766-7-git-send-email-davidsin@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291674446-10766-1-git-send-email-davidsin@ti.com>
References: <1291674446-10766-1-git-send-email-davidsin@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lajos Molnar <molnar@ti.com>

This patch contains information on TILER geometry, as well as
tiler_view_t object manipulation functions.

It also contains an internal TILER header file to share geometric
information with other TILER files.

Signed-off-by: Lajos Molnar <molnar@ti.com>
Signed-off-by: David Sin <davidsin@ti.com>
---
 drivers/misc/tiler/tiler-geom.c |  362 +++++++++++++++++++++++++++++++++++++++
 drivers/misc/tiler/tiler-geom.h |   48 +++++
 2 files changed, 410 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/tiler/tiler-geom.c
 create mode 100644 drivers/misc/tiler/tiler-geom.h

diff --git a/drivers/misc/tiler/tiler-geom.c b/drivers/misc/tiler/tiler-geom.c
new file mode 100644
index 0000000..c94193b
--- /dev/null
+++ b/drivers/misc/tiler/tiler-geom.c
@@ -0,0 +1,362 @@
+/*
+ * TILER geometry functions for TI TILER hardware block.
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
+#include "tiler-geom.h"
+
+/* bits representing the same slot in DMM-TILER hw-block */
+#define SLOT_WIDTH_BITS		6
+#define SLOT_HEIGHT_BITS	6
+
+/* bits reserved to describe coordinates in DMM-TILER hw-block */
+#define CONT_WIDTH_BITS		14
+#define CONT_HEIGHT_BITS	13
+
+static struct tiler_geom geom[TILER_FORMATS] = {
+	{
+		.x_shft = 0,
+		.y_shft = 0,
+	},
+	{
+		.x_shft = 0,
+		.y_shft = 1,
+	},
+	{
+		.x_shft = 1,
+		.y_shft = 1,
+	},
+};
+
+/* tiler space addressing bitfields */
+#define MASK_XY_FLIP		(1 << 31)
+#define MASK_Y_INVERT		(1 << 30)
+#define MASK_X_INVERT		(1 << 29)
+#define SHIFT_ACC_MODE		27
+#define MASK_ACC_MODE		3
+
+/* calculated constants */
+#define TILER_PAGE		(1 << (SLOT_WIDTH_BITS + SLOT_HEIGHT_BITS))
+#define TILER_WIDTH		(1 << (CONT_WIDTH_BITS - SLOT_WIDTH_BITS))
+#define TILER_HEIGHT		(1 << (CONT_HEIGHT_BITS - SLOT_HEIGHT_BITS))
+
+#define VIEW_SIZE		(1u << (CONT_WIDTH_BITS + CONT_HEIGHT_BITS))
+#define VIEW_MASK		(VIEW_SIZE - 1u)
+
+#define MASK(bits) ((1 << (bits)) - 1)
+
+#define TILER_FMT(x)	((enum tiler_fmt) \
+		((x >> SHIFT_ACC_MODE) & MASK_ACC_MODE))
+
+#define MASK_VIEW		(MASK_X_INVERT | MASK_Y_INVERT | MASK_XY_FLIP)
+
+/* location of the various tiler views in physical address space */
+#define TILVIEW_8BIT	0x60000000u
+#define TILVIEW_16BIT	(TILVIEW_8BIT  + VIEW_SIZE)
+#define TILVIEW_32BIT	(TILVIEW_16BIT + VIEW_SIZE)
+#define TILVIEW_PAGE	(TILVIEW_32BIT + VIEW_SIZE)
+#define TILVIEW_END	(TILVIEW_PAGE  + VIEW_SIZE)
+
+/* create tsptr by adding view orientation and access mode */
+#define TIL_ADDR(x, orient, a)\
+	((u32) (x) | (orient) | ((a) << SHIFT_ACC_MODE))
+
+bool is_tiler_addr(u32 phys)
+{
+	return phys >= TILVIEW_8BIT && phys < TILVIEW_END;
+}
+EXPORT_SYMBOL_GPL(is_tiler_addr);
+
+u32 tiler_bpp(const struct tiler_block_t *b)
+{
+	enum tiler_fmt fmt = tiler_fmt(b->phys);
+	WARN_ON(fmt == TILFMT_INVALID || fmt == TILFMT_PAGE);
+
+	return geom[fmt].bpp;
+}
+EXPORT_SYMBOL_GPL(tiler_bpp);
+
+/* return the stride of a tiler-block in tiler space */
+static inline s32 tiler_stride(u32 tsptr)
+{
+	enum tiler_fmt fmt = TILER_FMT(tsptr);
+
+	if (fmt == TILFMT_PAGE)
+		return 0;
+	else if (tsptr & MASK_XY_FLIP)
+		return 1 << (CONT_HEIGHT_BITS + geom[fmt].x_shft);
+	else
+		return 1 << (CONT_WIDTH_BITS + geom[fmt].y_shft);
+}
+
+u32 tiler_pstride(const struct tiler_block_t *b)
+{
+	enum tiler_fmt fmt = tiler_fmt(b->phys);
+	WARN_ON(fmt == TILFMT_INVALID);
+
+	/* return the virtual stride for page mode */
+	if (fmt == TILFMT_PAGE)
+		return tiler_vstride(b);
+
+	return tiler_stride(b->phys & ~MASK_VIEW);
+}
+EXPORT_SYMBOL_GPL(tiler_pstride);
+
+enum tiler_fmt tiler_fmt(u32 phys)
+{
+	if (!is_tiler_addr(phys))
+		return TILFMT_INVALID;
+
+	return TILER_FMT(phys);
+}
+EXPORT_SYMBOL_GPL(tiler_fmt);
+
+/* returns the tiler geometry information for a format */
+static const struct tiler_geom *get_geom(enum tiler_fmt fmt)
+{
+	if (fmt >= TILFMT_MIN && fmt <= TILFMT_MAX)
+		return geom + fmt;
+	return NULL;
+}
+
+/*
+ * Returns the natural x and y coordinates for a pixel in tiler space address.
+ * That is, the coordinates for the same pixel in the natural (non-rotated,
+ * non-mirrored) view. This allows to uniquely identify a tiler pixel in any
+ * view orientation.
+ */
+static void tiler_get_natural_xy(u32 tsptr, u32 *x, u32 *y)
+{
+	u32 x_bits, y_bits, offset;
+	enum tiler_fmt fmt;
+
+	fmt = TILER_FMT(tsptr);
+
+	x_bits = CONT_WIDTH_BITS - geom[fmt].x_shft;
+	y_bits = CONT_HEIGHT_BITS - geom[fmt].y_shft;
+	offset = (tsptr & VIEW_MASK) >> (geom[fmt].x_shft + geom[fmt].y_shft);
+
+	/* separate coordinate bitfields based on view orientation */
+	if (tsptr & MASK_XY_FLIP) {
+		*x = offset >> y_bits;
+		*y = offset & MASK(y_bits);
+	} else {
+		*x = offset & MASK(x_bits);
+		*y = offset >> x_bits;
+	}
+
+	/* account for mirroring */
+	if (tsptr & MASK_X_INVERT)
+		*x ^= MASK(x_bits);
+	if (tsptr & MASK_Y_INVERT)
+		*y ^= MASK(y_bits);
+}
+
+/* calculate the tiler space address of a pixel in a view orientation */
+static u32 tiler_get_address(u32 orient, enum tiler_fmt fmt, u32 x, u32 y)
+{
+	u32 x_bits, y_bits, tmp, x_mask, y_mask, alignment;
+
+	x_bits = CONT_WIDTH_BITS - geom[fmt].x_shft;
+	y_bits = CONT_HEIGHT_BITS - geom[fmt].y_shft;
+	alignment = geom[fmt].x_shft + geom[fmt].y_shft;
+
+	/* validate coordinate */
+	x_mask = MASK(x_bits);
+	y_mask = MASK(y_bits);
+	if (x < 0 || x > x_mask || y < 0 || y > y_mask)
+		return 0;
+
+	/* account for mirroring */
+	if (orient & MASK_X_INVERT)
+		x ^= x_mask;
+	if (orient & MASK_Y_INVERT)
+		y ^= y_mask;
+
+	/* get coordinate address */
+	if (orient & MASK_XY_FLIP)
+		tmp = ((x << y_bits) + y);
+	else
+		tmp = ((y << x_bits) + x);
+
+	return TIL_ADDR((tmp << alignment), orient, fmt);
+}
+
+void tilview_create(struct tiler_view_t *view, u32 phys, u32 width, u32 height)
+{
+	WARN_ON(!is_tiler_addr(phys));
+
+	view->tsptr = phys & ~MASK_VIEW;
+	view->bpp = geom[TILER_FMT(phys)].bpp;
+	view->width = width;
+	view->height = height;
+	view->h_inc = view->bpp;
+	view->v_inc = tiler_stride(view->tsptr);
+}
+EXPORT_SYMBOL_GPL(tilview_create);
+
+void tilview_get(struct tiler_view_t *view, struct tiler_block_t *blk)
+{
+	view->tsptr = blk->phys & ~MASK_VIEW;
+	view->bpp = tiler_bpp(blk);
+	view->width = blk->width;
+	view->height = blk->height;
+	view->h_inc = view->bpp;
+	view->v_inc = tiler_stride(view->tsptr);
+}
+EXPORT_SYMBOL_GPL(tilview_get);
+
+s32 tilview_crop(struct tiler_view_t *view, u32 left, u32 top, u32 width,
+								u32 height)
+{
+	/* check for valid crop */
+	if (left + width < left || left + width > view->width ||
+	    top + height < top || top + height > view->height)
+		return -EINVAL;
+
+	view->tsptr += left * view->h_inc + top * view->v_inc;
+	view->width = width;
+	view->height = height;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tilview_crop);
+
+/* calculate tilerspace address and stride after view orientation change */
+static void reorient(struct tiler_view_t *view, u32 orient)
+{
+	u32 x, y;
+
+	tiler_get_natural_xy(view->tsptr, &x, &y);
+	view->tsptr = tiler_get_address(orient,
+					TILER_FMT(view->tsptr), x, y);
+	view->v_inc = tiler_stride(view->tsptr);
+}
+
+s32 tilview_rotate(struct tiler_view_t *view, s32 rotation)
+{
+	u32 orient;
+
+	if (rotation % 90)
+		return -EINVAL;
+
+	/* normalize rotation to quarters */
+	rotation = (rotation / 90) & 3;
+	if (!rotation)
+		return 0; /* nothing to do */
+
+	/* PAGE mode view cannot be rotated */
+	if (TILER_FMT(view->tsptr) == TILFMT_PAGE)
+		return -EPERM;
+
+	/*
+	 * first adjust top-left corner. NOTE: it rotates counter-clockwise:
+	 * 0 < 3
+	 * v   ^
+	 * 1 > 2
+	 */
+	if (rotation < 3)
+		view->tsptr += (view->height - 1) * view->v_inc;
+	if (rotation > 1)
+		view->tsptr += (view->width - 1) * view->h_inc;
+
+	/* then rotate view itself */
+	orient = view->tsptr & MASK_VIEW;
+
+	/* rotate first 2 quarters */
+	if (rotation & 2) {
+		orient ^= MASK_X_INVERT;
+		orient ^= MASK_Y_INVERT;
+	}
+
+	/* rotate last quarter */
+	if (rotation & 1) {
+		orient ^= (orient & MASK_XY_FLIP) ?
+			MASK_X_INVERT : MASK_Y_INVERT;
+
+		/* swap x & y */
+		orient ^= MASK_XY_FLIP;
+		swap(view->height, view->width);
+	}
+
+	/* finally reorient view */
+	reorient(view, orient);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tilview_rotate);
+
+s32 tilview_flip(struct tiler_view_t *view, bool flip_x, bool flip_y)
+{
+	u32 orient;
+	orient = view->tsptr & MASK_VIEW;
+
+	if (!flip_x && !flip_y)
+		return 0; /* nothing to do */
+
+	/* PAGE mode view cannot be flipped */
+	if (TILER_FMT(view->tsptr) == TILFMT_PAGE)
+		return -EPERM;
+
+	/* adjust top-left corner */
+	if (flip_x)
+		view->tsptr += (view->width - 1) * view->h_inc;
+	if (flip_y)
+		view->tsptr += (view->height - 1) * view->v_inc;
+
+	/* flip view orientation */
+	if (orient & MASK_XY_FLIP)
+		swap(flip_x, flip_y);
+
+	if (flip_x)
+		orient ^= MASK_X_INVERT;
+	if (flip_y)
+		orient ^= MASK_Y_INVERT;
+
+	/* finally reorient view */
+	reorient(view, orient);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tilview_flip);
+
+/* return the alias address for a coordinate */
+static inline u32 alias_address(enum tiler_fmt fmt, u32 x, u32 y)
+{
+	return tiler_get_address(0, fmt, x, y) + TILVIEW_8BIT;
+}
+
+/* get the coordinates for an alias address */
+static inline void alias_xy(u32 ssptr, u32 *x, u32 *y)
+{
+	tiler_get_natural_xy(ssptr & ~MASK_VIEW, x, y);
+}
+
+/* initialize shared geometric data */
+void tiler_geom_init(struct tiler_ops *tiler)
+{
+	struct tiler_geom *g;
+
+	tiler->xy = alias_xy;
+	tiler->addr = alias_address;
+	tiler->geom = get_geom;
+
+	tiler->page   = TILER_PAGE;
+	tiler->width  = TILER_WIDTH;
+	tiler->height = TILER_HEIGHT;
+
+	/* calculate geometry */
+	for (g = geom; g < geom + TILER_FORMATS; g++) {
+		g->bpp = 1 << (g->x_shft + g->y_shft);
+		g->slot_w = 1 << (SLOT_WIDTH_BITS - g->x_shft);
+		g->slot_h = 1 << (SLOT_HEIGHT_BITS - g->y_shft);
+	}
+}
diff --git a/drivers/misc/tiler/tiler-geom.h b/drivers/misc/tiler/tiler-geom.h
new file mode 100644
index 0000000..f73bcf2
--- /dev/null
+++ b/drivers/misc/tiler/tiler-geom.h
@@ -0,0 +1,48 @@
+/*
+ * TI TILER driver internal shared definitions.
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
+#ifndef TILER_GEOM_H
+#define TILER_GEOM_H
+
+#include <linux/kernel.h>
+#include <linux/tiler.h>
+#include "tcm.h"
+
+#define TILER_FORMATS		(TILFMT_MAX - TILFMT_MIN + 1)
+
+/* tiler geometry information */
+struct tiler_geom {
+	u32 x_shft;	/* unused X-bits (as part of bpp) */
+	u32 y_shft;	/* unused Y-bits (as part of bpp) */
+	u32 bpp;	/* bytes per pixel */
+	u32 slot_w;	/* width of each slot (in pixels) */
+	u32 slot_h;	/* height of each slot (in pixels) */
+};
+
+/* methods and variables shared between source files */
+struct tiler_ops {
+	/* geometry operations */
+	void (*xy) (u32 ssptr, u32 *x, u32 *y);
+	u32 (*addr) (enum tiler_fmt fmt, u32 x, u32 y);
+	const struct tiler_geom * (*geom) (enum tiler_fmt fmt);
+
+	u32 page;		/* page size */
+	u32 width;		/* container width */
+	u32 height;		/* container height */
+};
+
+void tiler_geom_init(struct tiler_ops *tiler);
+
+#endif
-- 
1.7.0.4

