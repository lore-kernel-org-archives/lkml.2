Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0LFWRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:17:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35678 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab0LFWQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:16:08 -0500
From: David Sin <davidsin@ti.com>
To: Greg KH <greg@kroah.com>, Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Lajos Molnar <molnar@ti.com>, David Sin <davidsin@ti.com>
Subject: [PATCH 4/9] TILER-DMM: TILER Memory Manager interface and implementation
Date: Mon,  6 Dec 2010 16:27:21 -0600
Message-Id: <1291674446-10766-5-git-send-email-davidsin@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291674446-10766-1-git-send-email-davidsin@ti.com>
References: <1291674446-10766-1-git-send-email-davidsin@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lajos Molnar <molnar@ti.com>

This patch defines the TILER Memory Manager (TMM) interface and
provides implementation for a PAT-supporting TMM.

Signed-off-by: Lajos Molnar <molnar@ti.com>
Signed-off-by: David Sin <davidsin@ti.com>
---
 drivers/misc/tiler/tmm-pat.c |  266 ++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/tiler/tmm.h     |  103 ++++++++++++++++
 2 files changed, 369 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/tiler/tmm-pat.c
 create mode 100644 drivers/misc/tiler/tmm.h

diff --git a/drivers/misc/tiler/tmm-pat.c b/drivers/misc/tiler/tmm-pat.c
new file mode 100644
index 0000000..682f549
--- /dev/null
+++ b/drivers/misc/tiler/tmm-pat.c
@@ -0,0 +1,266 @@
+/*
+ * DMM driver support functions for TI TILER hardware block.
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
+#include <linux/mm.h>
+#include <linux/mmzone.h>
+#include <asm/cacheflush.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+
+#include "tmm.h"
+
+/* Page size granularity can be 4k, 16k, or 64k */
+#define DMM_PAGE SZ_4K
+
+/* Memory limit to cache free pages. TILER will eventually use this much */
+static u32 cache_limit = CONFIG_TILER_CACHE_LIMIT << 20;
+module_param_named(cache, cache_limit, uint, 0644);
+MODULE_PARM_DESC(cache, "Cache free pages if total memory is under this limit");
+
+/* global state - statically initialized */
+static LIST_HEAD(free_list);	/* page cache: list of free pages */
+static u32 total_mem;		/* total memory allocated (free & used) */
+static u32 refs;		/* number of tmm_pat instances */
+static DEFINE_MUTEX(mtx);	/* global mutex */
+
+/* The page struct pointer and physical address of each page.*/
+struct mem {
+	struct list_head list;
+	u32 *pg;	/* page struct */
+	dma_addr_t pa;	/* physical address */
+};
+
+/* Used to keep track of mem per tmm_pat_get_pages call */
+struct fast {
+	struct list_head list;
+	struct mem **mem;	/* array of page info */
+	u32 *pa;		/* array of physical addresses */
+	u32 num;		/* number of pages */
+};
+
+/* TMM PAT private structure */
+struct dmm_mem {
+	struct list_head fast_list;
+	struct dmm *dmm;
+};
+
+/*
+ *  Frees pages in a fast structure.  Moves pages to the free list if there
+ *  are	less pages used	than max_to_keep.  Otherwise, it frees the pages
+ */
+static void free_fast(struct fast *f)
+{
+	s32 i = 0;
+
+	/* mutex is locked */
+	for (i = 0; i < f->num; i++) {
+		if (total_mem < cache_limit) {
+			/* cache free page if under the limit */
+			list_add(&f->mem[i]->list, &free_list);
+		} else {
+			/* otherwise, free */
+			total_mem -= PAGE_SIZE;
+			dma_free_coherent(NULL, DMM_PAGE, f->mem[i]->pg,
+								f->mem[i]->pa);
+		}
+	}
+	kfree(f->pa);
+	kfree(f->mem);
+	/* remove only if element was added */
+	if (f->list.next)
+		list_del(&f->list);
+	kfree(f);
+}
+
+/* allocate and flush a page */
+static struct mem *alloc_mem(void)
+{
+	struct mem *m = kzalloc(sizeof(*m), GFP_KERNEL);
+	if (!m)
+		return NULL;
+
+	m->pg = dma_alloc_coherent(NULL, DMM_PAGE, &m->pa, GFP_KERNEL);
+	if (!m->pg) {
+		kfree(m);
+		return NULL;
+	}
+	wmb();
+
+	return m;
+}
+
+static void free_page_cache(void)
+{
+	struct mem *m, *m_;
+
+	/* mutex is locked */
+	list_for_each_entry_safe(m, m_, &free_list, list) {
+		dma_free_coherent(NULL, DMM_PAGE, m->pg, m->pa);
+		total_mem -= PAGE_SIZE;
+		list_del(&m->list);
+		kfree(m);
+	}
+}
+
+static void tmm_pat_deinit(struct tmm *tmm)
+{
+	struct fast *f, *f_;
+	struct dmm_mem *pvt = (struct dmm_mem *) tmm->pvt;
+
+	mutex_lock(&mtx);
+
+	/* free all outstanding used memory */
+	list_for_each_entry_safe(f, f_, &pvt->fast_list, list)
+		free_fast(f);
+
+	/* if this is the last tmm_pat, free all memory */
+	if (--refs == 0)
+		free_page_cache();
+
+	mutex_unlock(&mtx);
+}
+
+static u32 *tmm_pat_get_pages(struct tmm *tmm, u32 n)
+{
+	struct mem *m;
+	struct fast *f;
+	struct dmm_mem *pvt = (struct dmm_mem *) tmm->pvt;
+
+	f = kzalloc(sizeof(*f), GFP_KERNEL);
+	if (!f)
+		return NULL;
+
+	/* array of mem struct pointers */
+	f->mem = kzalloc(n * sizeof(*f->mem), GFP_KERNEL);
+
+	/* array of physical addresses */
+	f->pa = kzalloc(n * sizeof(*f->pa), GFP_KERNEL);
+
+	/* no pages have been allocated yet (needed for cleanup) */
+	f->num = 0;
+
+	if (!f->mem || !f->pa)
+		goto cleanup;
+
+	/* fill out fast struct mem array with free pages */
+	mutex_lock(&mtx);
+	while (f->num < n) {
+		/* if there is a free cached page use it */
+		if (!list_empty(&free_list)) {
+			/* unbind first element from list */
+			m = list_first_entry(&free_list, typeof(*m), list);
+			list_del(&m->list);
+		} else {
+			mutex_unlock(&mtx);
+
+			/*
+			 * Unlock mutex during allocation and cache flushing.
+			 */
+			m = alloc_mem();
+			if (!m)
+				goto cleanup;
+
+			mutex_lock(&mtx);
+			total_mem += PAGE_SIZE;
+		}
+
+		f->mem[f->num] = m;
+		f->pa[f->num++] = m->pa;
+	}
+
+	list_add(&f->list, &pvt->fast_list);
+	mutex_unlock(&mtx);
+	return f->pa;
+
+cleanup:
+	free_fast(f);
+	return NULL;
+}
+
+static void tmm_pat_free_pages(struct tmm *tmm, u32 *page_list)
+{
+	struct dmm_mem *pvt = (struct dmm_mem *) tmm->pvt;
+	struct fast *f, *f_;
+
+	mutex_lock(&mtx);
+	/* find fast struct based on 1st page */
+	list_for_each_entry_safe(f, f_, &pvt->fast_list, list) {
+		if (f->pa[0] == page_list[0]) {
+			free_fast(f);
+			break;
+		}
+	}
+	mutex_unlock(&mtx);
+}
+
+static s32 tmm_pat_map(struct tmm *tmm, struct pat_area area, u32 page_pa)
+{
+	struct dmm_mem *pvt = (struct dmm_mem *) tmm->pvt;
+	struct pat pat_desc = {NULL};
+
+	/* send pat descriptor to dmm driver */
+	pat_desc.ctrl.dir = 0;
+	pat_desc.ctrl.ini = 0;
+	pat_desc.ctrl.lut_id = 0;
+	pat_desc.ctrl.start = 1;
+	pat_desc.ctrl.sync = 0;
+	pat_desc.area = area;
+	pat_desc.next = NULL;
+
+	/* must be a 16-byte aligned physical address */
+	pat_desc.data = page_pa;
+	return dmm_pat_refill(pvt->dmm, &pat_desc, MANUAL);
+}
+
+struct tmm *tmm_pat_init(u32 pat_id)
+{
+	struct tmm *tmm = NULL;
+	struct dmm_mem *pvt = NULL;
+
+	struct dmm *dmm = dmm_pat_init(pat_id);
+	if (dmm)
+		tmm = kzalloc(sizeof(*tmm), GFP_KERNEL);
+	if (tmm)
+		pvt = kzalloc(sizeof(*pvt), GFP_KERNEL);
+	if (pvt) {
+		/* private data */
+		pvt->dmm = dmm;
+		INIT_LIST_HEAD(&pvt->fast_list);
+
+		/* increate tmm_pat references */
+		mutex_lock(&mtx);
+		refs++;
+		mutex_unlock(&mtx);
+
+		/* public data */
+		tmm->pvt = pvt;
+		tmm->deinit = tmm_pat_deinit;
+		tmm->get = tmm_pat_get_pages;
+		tmm->free = tmm_pat_free_pages;
+		tmm->map = tmm_pat_map;
+		tmm->clear = NULL;   /* not yet supported */
+
+		return tmm;
+	}
+
+	kfree(pvt);
+	kfree(tmm);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(tmm_pat_init);
diff --git a/drivers/misc/tiler/tmm.h b/drivers/misc/tiler/tmm.h
new file mode 100644
index 0000000..cb90664
--- /dev/null
+++ b/drivers/misc/tiler/tmm.h
@@ -0,0 +1,103 @@
+/*
+ * TMM interface definition for TI TILER driver.
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
+#ifndef TMM_H
+#define TMM_H
+
+#include <mach/dmm.h>
+/*
+ * TMM interface
+ */
+struct tmm {
+	void *pvt;
+
+	/* function table */
+	u32 *(*get)	(struct tmm *tmm, u32 num_pages);
+	void (*free)	(struct tmm *tmm, u32 *pages);
+	s32  (*map)	(struct tmm *tmm, struct pat_area area, u32 page_pa);
+	void (*clear)	(struct tmm *tmm, struct pat_area area);
+	void (*deinit)	(struct tmm *tmm);
+};
+
+/*
+ * Request a set of pages from the DMM free page stack.
+ * Return a pointer to a list of physical page addresses.
+ */
+static inline
+u32 *tmm_get(struct tmm *tmm, u32 num_pages)
+{
+	if (tmm && tmm->pvt)
+		return tmm->get(tmm, num_pages);
+	return NULL;
+}
+
+/*
+ * Return a set of used pages to the DMM free page stack.
+ */
+static inline
+void tmm_free(struct tmm *tmm, u32 *pages)
+{
+	if (tmm && tmm->pvt)
+		tmm->free(tmm, pages);
+}
+
+/*
+ * Program the physical address translator.
+ */
+static inline
+s32 tmm_map(struct tmm *tmm, struct pat_area area, u32 page_pa)
+{
+	if (tmm && tmm->map && tmm->pvt)
+		return tmm->map(tmm, area, page_pa);
+	return -ENODEV;
+}
+
+/*
+ * Clears the physical address translator.
+ */
+static inline
+void tmm_clear(struct tmm *tmm, struct pat_area area)
+{
+	if (tmm && tmm->clear && tmm->pvt)
+		tmm->clear(tmm, area);
+}
+
+/*
+ * Checks whether tiler memory manager supports mapping
+ */
+static inline
+bool tmm_can_map(struct tmm *tmm)
+{
+	return tmm && tmm->map;
+}
+
+/*
+ * Deinitialize tiler memory manager
+ */
+static inline
+void tmm_deinit(struct tmm *tmm)
+{
+	if (tmm && tmm->pvt)
+		tmm->deinit(tmm);
+}
+
+/*
+ * TMM implementation for PAT support.
+ *
+ * Initialize TMM for PAT with given id.
+ */
+struct tmm *tmm_pat_init(u32 pat_id);
+
+#endif
-- 
1.7.0.4

