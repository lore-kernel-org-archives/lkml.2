Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab0LFWQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:16:24 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49548 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab0LFWQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:16:18 -0500
From: David Sin <davidsin@ti.com>
To: Greg KH <greg@kroah.com>, Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Lajos Molnar <molnar@ti.com>, David Sin <davidsin@ti.com>,
        Ravi Ramachandra <r.ramachandra@ti.com>
Subject: [PATCH 2/9] TILER-DMM: Container manager interface and utility definitons
Date: Mon,  6 Dec 2010 16:27:19 -0600
Message-Id: <1291674446-10766-3-git-send-email-davidsin@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291674446-10766-1-git-send-email-davidsin@ti.com>
References: <1291674446-10766-1-git-send-email-davidsin@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lajos Molnar <molnar@ti.com>

This patch defined the TILER Container Manager (TCM) interface and
provides utility methods for implementing a TCM.

Signed-off-by: Lajos Molnar <molnar@ti.com>
Signed-off-by: David Sin <davidsin@ti.com>
Signed-off-by: Ravi Ramachandra <r.ramachandra@ti.com>
---
 drivers/misc/tiler/tcm.h           |  171 ++++++++++++++++++++++++++++++++++++
 drivers/misc/tiler/tcm/tcm-utils.h |   51 +++++++++++
 2 files changed, 222 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/tiler/tcm.h
 create mode 100644 drivers/misc/tiler/tcm/tcm-utils.h

diff --git a/drivers/misc/tiler/tcm.h b/drivers/misc/tiler/tcm.h
new file mode 100644
index 0000000..8968108
--- /dev/null
+++ b/drivers/misc/tiler/tcm.h
@@ -0,0 +1,171 @@
+/*
+ * TILER container manager specification and support functions for TI
+ * TILER driver.
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
+#ifndef TCM_H
+#define TCM_H
+
+struct tcm;
+
+/* point */
+struct tcm_pt {
+	u16 x;
+	u16 y;
+};
+
+/* 2d area */
+struct tcm_area {
+	struct tcm    *tcm;	/* parent */
+	struct tcm_pt  p0;
+	struct tcm_pt  p1;
+};
+
+struct tcm {
+	u16 width, height;	/* container dimensions */
+
+	/*
+	 * 'pvt' structure shall contain any tcm details (attr) along with
+	 * linked list of allocated areas and mutex for mutually exclusive
+	 * access to the list.  It may also contain copies of width and height
+	 * to notice any changes to the publicly available width and height
+	 * fields.
+	 */
+	void *pvt;
+
+	/* function table */
+	s32 (*reserve_2d)(struct tcm *tcm, u16 height, u16 width, u8 align,
+			  struct tcm_area *area);
+	s32 (*free)      (struct tcm *tcm, struct tcm_area *area);
+	void (*deinit)   (struct tcm *tcm);
+};
+
+/*
+ * Since some basic parameter checking is done outside the TCM algorithms,
+ * TCM implementation do NOT have to check the following:
+ *
+ *   area pointer is NULL
+ *   width and height fits within container
+ *   number of pages is more than the size of the container
+ */
+
+/*
+ * Template for <ALGO_NAME>_tcm_init method.  Define as:
+ * TCM_INIT(<ALGO_NAME>_tcm_init)
+ *
+ * Allocates and initializes a tiler container manager.
+ *
+ * Pointer to the allocated and initialized container manager.
+ * NULL on failure.  DO NOT leak any memory on failure!
+ */
+#define TCM_INIT(name, attr_t) \
+struct tcm *name(u16 width, u16 height, typeof(attr_t) *attr);
+
+/*
+ * Deinitialize tiler container manager.
+ *
+ * The call should free as much memory as possible and meaningful
+ * even on failure.  Some error codes: -ENODEV: invalid manager.
+ */
+static inline void tcm_deinit(struct tcm *tcm)
+{
+	if (tcm)
+		tcm->deinit(tcm);
+}
+
+/*
+ * Reserves a 2D area in the container.
+ *
+ * The tcm field of the area will be set to NULL on failure.
+ * Some error codes: -ENODEV: invalid manager, -EINVAL:
+ * invalid area, -ENOMEM: not enough space for allocation.
+ */
+static inline s32 tcm_reserve_2d(struct tcm *tcm, u16 width, u16 height,
+				 u16 align, struct tcm_area *area)
+{
+	/* perform rudimentary error checking */
+	s32 res = (tcm  == NULL ? -ENODEV :
+		(area == NULL || width == 0 || height == 0 ||
+		 /* align must be a 2 power */
+		 align & (align - 1)) ? -EINVAL :
+		(height > tcm->height || width > tcm->width) ? -ENOMEM :
+		tcm->reserve_2d(tcm, height, width, align, area));
+
+	if (area)
+		area->tcm = res ? NULL : tcm;
+
+	return res;
+}
+
+/*
+ * Free a previously reserved area from the container.
+ *
+ * The tcm field of the area is set to NULL on success
+ * to avoid subsequent freeing.  This call will succeed
+ * even if supplying the area from a failed reserved call.
+ */
+static inline s32 tcm_free(struct tcm_area *area)
+{
+	s32 res = 0; /* free succeeds by default */
+
+	if (area && area->tcm) {
+		res = area->tcm->free(area->tcm, area);
+		if (res == 0)
+			area->tcm = NULL;
+	}
+
+	return res;
+}
+
+/* Verify if a tcm area is logically valid */
+static inline bool tcm_area_is_valid(struct tcm_area *area)
+{
+	return area && area->tcm &&
+		/* coordinate bounds */
+		area->p1.x < area->tcm->width &&
+		area->p1.y < area->tcm->height &&
+		area->p0.y <= area->p1.y &&
+		area->p0.x <= area->p1.x;
+}
+
+/* see if a coordinate is within an area */
+static inline bool __tcm_is_in(struct tcm_pt *p, struct tcm_area *a)
+{
+	return p->x >= a->p0.x && p->x <= a->p1.x &&
+		p->y >= a->p0.y && p->y <= a->p1.y;
+}
+
+/* calculate area width */
+static inline u16 __tcm_area_width(struct tcm_area *area)
+{
+	return area->p1.x - area->p0.x + 1;
+}
+
+/* calculate area height */
+static inline u16 __tcm_area_height(struct tcm_area *area)
+{
+	return area->p1.y - area->p0.y + 1;
+}
+
+/* calculate number of slots in an area */
+static inline u16 __tcm_sizeof(struct tcm_area *area)
+{
+	return __tcm_area_width(area) * __tcm_area_height(area);
+}
+#define tcm_sizeof(area) __tcm_sizeof(&(area))
+#define tcm_awidth(area) __tcm_area_width(&(area))
+#define tcm_aheight(area) __tcm_area_height(&(area))
+#define tcm_is_in(pt, area) __tcm_is_in(&(pt), &(area))
+
+#endif
diff --git a/drivers/misc/tiler/tcm/tcm-utils.h b/drivers/misc/tiler/tcm/tcm-utils.h
new file mode 100644
index 0000000..400c2fe
--- /dev/null
+++ b/drivers/misc/tiler/tcm/tcm-utils.h
@@ -0,0 +1,51 @@
+/*
+ * Utility functions for implementing TILER container managers.
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
+#ifndef TCM_UTILS_H
+#define TCM_UTILS_H
+
+#include "../tcm.h"
+
+/* TCM_ALG_NAME must be defined to use the debug methods */
+
+#ifdef DEBUG
+#define IFDEBUG(x) x
+#else
+/* compile-check debug statements even if not DEBUG */
+#define IFDEBUG(x) do { if (0) x; } while (0)
+#endif
+
+#define P(level, fmt, ...) \
+	IFDEBUG(printk(level TCM_ALG_NAME ":%d:%s()" fmt "\n", \
+			__LINE__, __func__, ##__VA_ARGS__))
+
+#define P1(fmt, ...) P(KERN_NOTICE, fmt, ##__VA_ARGS__)
+#define P2(fmt, ...) P(KERN_INFO, fmt, ##__VA_ARGS__)
+#define P3(fmt, ...) P(KERN_DEBUG, fmt, ##__VA_ARGS__)
+
+#define PA(level, msg, p_area) P##level(msg " (%03d %03d)-(%03d %03d)\n", \
+	(p_area)->p0.x, (p_area)->p0.y, (p_area)->p1.x, (p_area)->p1.y)
+
+/* assign coordinates to area */
+static inline
+void assign(struct tcm_area *a, u16 x0, u16 y0, u16 x1, u16 y1)
+{
+	a->p0.x = x0;
+	a->p0.y = y0;
+	a->p1.x = x1;
+	a->p1.y = y1;
+}
+
+#endif
-- 
1.7.0.4

