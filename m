Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab2G0S3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 14:29:37 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39127 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab2G0S3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 14:29:35 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 1/4] zsmalloc: collapse internal .h into .c
Date: Fri, 27 Jul 2012 13:18:34 -0500
Message-Id: <1343413117-1989-2-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343413117-1989-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1343413117-1989-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072718-5112-0000-0000-00000A76396C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch collapses in the internal zsmalloc_int.h into
the zsmalloc-main.c file.

This is done in preparation for the promotion to mm/ where
separate internal headers are discouraged.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zsmalloc/zsmalloc-main.c |  132 +++++++++++++++++++++++++-
 drivers/staging/zsmalloc/zsmalloc_int.h  |  149 ------------------------------
 2 files changed, 131 insertions(+), 150 deletions(-)
 delete mode 100644 drivers/staging/zsmalloc/zsmalloc_int.h

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index defe350..09a9d35 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -76,9 +76,139 @@
 #include <linux/cpu.h>
 #include <linux/vmalloc.h>
 #include <linux/hardirq.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
 
 #include "zsmalloc.h"
-#include "zsmalloc_int.h"
+
+/*
+ * This must be power of 2 and greater than of equal to sizeof(link_free).
+ * These two conditions ensure that any 'struct link_free' itself doesn't
+ * span more than 1 page which avoids complex case of mapping 2 pages simply
+ * to restore link_free pointer values.
+ */
+#define ZS_ALIGN		8
+
+/*
+ * A single 'zspage' is composed of up to 2^N discontiguous 0-order (single)
+ * pages. ZS_MAX_ZSPAGE_ORDER defines upper limit on N.
+ */
+#define ZS_MAX_ZSPAGE_ORDER 2
+#define ZS_MAX_PAGES_PER_ZSPAGE (_AC(1, UL) << ZS_MAX_ZSPAGE_ORDER)
+
+/*
+ * Object location (<PFN>, <obj_idx>) is encoded as
+ * as single (void *) handle value.
+ *
+ * Note that object index <obj_idx> is relative to system
+ * page <PFN> it is stored in, so for each sub-page belonging
+ * to a zspage, obj_idx starts with 0.
+ *
+ * This is made more complicated by various memory models and PAE.
+ */
+
+#ifndef MAX_PHYSMEM_BITS
+#ifdef CONFIG_HIGHMEM64G
+#define MAX_PHYSMEM_BITS 36
+#else /* !CONFIG_HIGHMEM64G */
+/*
+ * If this definition of MAX_PHYSMEM_BITS is used, OBJ_INDEX_BITS will just
+ * be PAGE_SHIFT
+ */
+#define MAX_PHYSMEM_BITS BITS_PER_LONG
+#endif
+#endif
+#define _PFN_BITS		(MAX_PHYSMEM_BITS - PAGE_SHIFT)
+#define OBJ_INDEX_BITS	(BITS_PER_LONG - _PFN_BITS)
+#define OBJ_INDEX_MASK	((_AC(1, UL) << OBJ_INDEX_BITS) - 1)
+
+#define MAX(a, b) ((a) >= (b) ? (a) : (b))
+/* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
+#define ZS_MIN_ALLOC_SIZE \
+	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
+#define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
+
+/*
+ * On systems with 4K page size, this gives 254 size classes! There is a
+ * trader-off here:
+ *  - Large number of size classes is potentially wasteful as free page are
+ *    spread across these classes
+ *  - Small number of size classes causes large internal fragmentation
+ *  - Probably its better to use specific size classes (empirically
+ *    determined). NOTE: all those class sizes must be set as multiple of
+ *    ZS_ALIGN to make sure link_free itself never has to span 2 pages.
+ *
+ *  ZS_MIN_ALLOC_SIZE and ZS_SIZE_CLASS_DELTA must be multiple of ZS_ALIGN
+ *  (reason above)
+ */
+#define ZS_SIZE_CLASS_DELTA	16
+#define ZS_SIZE_CLASSES		((ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) / \
+					ZS_SIZE_CLASS_DELTA + 1)
+
+/*
+ * We do not maintain any list for completely empty or full pages
+ */
+enum fullness_group {
+	ZS_ALMOST_FULL,
+	ZS_ALMOST_EMPTY,
+	_ZS_NR_FULLNESS_GROUPS,
+
+	ZS_EMPTY,
+	ZS_FULL
+};
+
+/*
+ * We assign a page to ZS_ALMOST_EMPTY fullness group when:
+ *	n <= N / f, where
+ * n = number of allocated objects
+ * N = total number of objects zspage can store
+ * f = 1/fullness_threshold_frac
+ *
+ * Similarly, we assign zspage to:
+ *	ZS_ALMOST_FULL	when n > N / f
+ *	ZS_EMPTY	when n == 0
+ *	ZS_FULL		when n == N
+ *
+ * (see: fix_fullness_group())
+ */
+static const int fullness_threshold_frac = 4;
+
+struct size_class {
+	/*
+	 * Size of objects stored in this class. Must be multiple
+	 * of ZS_ALIGN.
+	 */
+	int size;
+	unsigned int index;
+
+	/* Number of PAGE_SIZE sized pages to combine to form a 'zspage' */
+	int pages_per_zspage;
+
+	spinlock_t lock;
+
+	/* stats */
+	u64 pages_allocated;
+
+	struct page *fullness_list[_ZS_NR_FULLNESS_GROUPS];
+};
+
+/*
+ * Placed within free objects to form a singly linked list.
+ * For every zspage, first_page->freelist gives head of this list.
+ *
+ * This must be power of 2 and less than or equal to ZS_ALIGN
+ */
+struct link_free {
+	/* Handle of next free chunk (encodes <PFN, obj_idx>) */
+	void *next;
+};
+
+struct zs_pool {
+	struct size_class size_class[ZS_SIZE_CLASSES];
+
+	gfp_t flags;	/* allocation flags used when growing pool */
+	const char *name;
+};
 
 /*
  * A zspage's class index and fullness group
diff --git a/drivers/staging/zsmalloc/zsmalloc_int.h b/drivers/staging/zsmalloc/zsmalloc_int.h
deleted file mode 100644
index 8c0b344..0000000
--- a/drivers/staging/zsmalloc/zsmalloc_int.h
+++ /dev/null
@@ -1,149 +0,0 @@
-/*
- * zsmalloc memory allocator
- *
- * Copyright (C) 2011  Nitin Gupta
- *
- * This code is released using a dual license strategy: BSD/GPL
- * You can choose the license that better fits your requirements.
- *
- * Released under the terms of 3-clause BSD License
- * Released under the terms of GNU General Public License Version 2.0
- */
-
-#ifndef _ZS_MALLOC_INT_H_
-#define _ZS_MALLOC_INT_H_
-
-#include <linux/kernel.h>
-#include <linux/spinlock.h>
-#include <linux/types.h>
-
-/*
- * This must be power of 2 and greater than of equal to sizeof(link_free).
- * These two conditions ensure that any 'struct link_free' itself doesn't
- * span more than 1 page which avoids complex case of mapping 2 pages simply
- * to restore link_free pointer values.
- */
-#define ZS_ALIGN		8
-
-/*
- * A single 'zspage' is composed of up to 2^N discontiguous 0-order (single)
- * pages. ZS_MAX_ZSPAGE_ORDER defines upper limit on N.
- */
-#define ZS_MAX_ZSPAGE_ORDER 2
-#define ZS_MAX_PAGES_PER_ZSPAGE (_AC(1, UL) << ZS_MAX_ZSPAGE_ORDER)
-
-/*
- * Object location (<PFN>, <obj_idx>) is encoded as
- * as single (void *) handle value.
- *
- * Note that object index <obj_idx> is relative to system
- * page <PFN> it is stored in, so for each sub-page belonging
- * to a zspage, obj_idx starts with 0.
- *
- * This is made more complicated by various memory models and PAE.
- */
-
-#ifndef MAX_PHYSMEM_BITS
-#ifdef CONFIG_HIGHMEM64G
-#define MAX_PHYSMEM_BITS 36
-#else /* !CONFIG_HIGHMEM64G */
-/*
- * If this definition of MAX_PHYSMEM_BITS is used, OBJ_INDEX_BITS will just
- * be PAGE_SHIFT
- */
-#define MAX_PHYSMEM_BITS BITS_PER_LONG
-#endif
-#endif
-#define _PFN_BITS		(MAX_PHYSMEM_BITS - PAGE_SHIFT)
-#define OBJ_INDEX_BITS	(BITS_PER_LONG - _PFN_BITS)
-#define OBJ_INDEX_MASK	((_AC(1, UL) << OBJ_INDEX_BITS) - 1)
-
-#define MAX(a, b) ((a) >= (b) ? (a) : (b))
-/* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
-#define ZS_MIN_ALLOC_SIZE \
-	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
-#define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
-
-/*
- * On systems with 4K page size, this gives 254 size classes! There is a
- * trader-off here:
- *  - Large number of size classes is potentially wasteful as free page are
- *    spread across these classes
- *  - Small number of size classes causes large internal fragmentation
- *  - Probably its better to use specific size classes (empirically
- *    determined). NOTE: all those class sizes must be set as multiple of
- *    ZS_ALIGN to make sure link_free itself never has to span 2 pages.
- *
- *  ZS_MIN_ALLOC_SIZE and ZS_SIZE_CLASS_DELTA must be multiple of ZS_ALIGN
- *  (reason above)
- */
-#define ZS_SIZE_CLASS_DELTA	16
-#define ZS_SIZE_CLASSES		((ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) / \
-					ZS_SIZE_CLASS_DELTA + 1)
-
-/*
- * We do not maintain any list for completely empty or full pages
- */
-enum fullness_group {
-	ZS_ALMOST_FULL,
-	ZS_ALMOST_EMPTY,
-	_ZS_NR_FULLNESS_GROUPS,
-
-	ZS_EMPTY,
-	ZS_FULL
-};
-
-/*
- * We assign a page to ZS_ALMOST_EMPTY fullness group when:
- *	n <= N / f, where
- * n = number of allocated objects
- * N = total number of objects zspage can store
- * f = 1/fullness_threshold_frac
- *
- * Similarly, we assign zspage to:
- *	ZS_ALMOST_FULL	when n > N / f
- *	ZS_EMPTY	when n == 0
- *	ZS_FULL		when n == N
- *
- * (see: fix_fullness_group())
- */
-static const int fullness_threshold_frac = 4;
-
-struct size_class {
-	/*
-	 * Size of objects stored in this class. Must be multiple
-	 * of ZS_ALIGN.
-	 */
-	int size;
-	unsigned int index;
-
-	/* Number of PAGE_SIZE sized pages to combine to form a 'zspage' */
-	int pages_per_zspage;
-
-	spinlock_t lock;
-
-	/* stats */
-	u64 pages_allocated;
-
-	struct page *fullness_list[_ZS_NR_FULLNESS_GROUPS];
-};
-
-/*
- * Placed within free objects to form a singly linked list.
- * For every zspage, first_page->freelist gives head of this list.
- *
- * This must be power of 2 and less than or equal to ZS_ALIGN
- */
-struct link_free {
-	/* Handle of next free chunk (encodes <PFN, obj_idx>) */
-	void *next;
-};
-
-struct zs_pool {
-	struct size_class size_class[ZS_SIZE_CLASSES];
-
-	gfp_t flags;	/* allocation flags used when growing pool */
-	const char *name;
-};
-
-#endif
-- 
1.7.9.5

