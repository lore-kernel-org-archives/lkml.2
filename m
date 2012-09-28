Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab2I1IEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:04:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38151 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab2I1IEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:04:43 -0400
Date: Fri, 28 Sep 2012 01:04:26 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-0uois4f9skfw9mwyk1yoy0jq@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, riel@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: riel@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm: Fold page::nid_last into page::
 flags when possible
Git-Commit-ID: 835e3cf29f4eeba6c5c8bcc188b2138029157938
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 01:04:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  835e3cf29f4eeba6c5c8bcc188b2138029157938
Gitweb:     http://git.kernel.org/tip/835e3cf29f4eeba6c5c8bcc188b2138029157938
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 13 Aug 2012 15:22:20 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Sep 2012 19:17:30 +0200

mm: Fold page::nid_last into page::flags when possible

Save page frame memory.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Link: http://lkml.kernel.org/n/tip-0uois4f9skfw9mwyk1yoy0jq@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mm.h                |   90 ++++++++++++++++++++-----------------
 include/linux/mm_types.h          |    9 ++--
 include/linux/mmzone.h            |   14 +-----
 include/linux/page-flags-layout.h |   83 ++++++++++++++++++++++++++++++++++
 mm/huge_memory.c                  |    2 +-
 mm/memory.c                       |    4 ++
 mm/mempolicy.c                    |    5 +-
 7 files changed, 144 insertions(+), 63 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5f59128..02e8c1f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -592,50 +592,11 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
  * sets it, so none of the operations on it need to be atomic.
  */
 
-
-/*
- * page->flags layout:
- *
- * There are three possibilities for how page->flags get
- * laid out.  The first is for the normal case, without
- * sparsemem.  The second is for sparsemem when there is
- * plenty of space for node and section.  The last is when
- * we have run out of space and have to fall back to an
- * alternate (slower) way of determining the node.
- *
- * No sparsemem or sparsemem vmemmap: |       NODE     | ZONE | ... | FLAGS |
- * classic sparse with space for node:| SECTION | NODE | ZONE | ... | FLAGS |
- * classic sparse no space for node:  | SECTION |     ZONE    | ... | FLAGS |
- */
-#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
-#define SECTIONS_WIDTH		SECTIONS_SHIFT
-#else
-#define SECTIONS_WIDTH		0
-#endif
-
-#define ZONES_WIDTH		ZONES_SHIFT
-
-#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
-#define NODES_WIDTH		NODES_SHIFT
-#else
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-#error "Vmemmap: No space for nodes field in page flags"
-#endif
-#define NODES_WIDTH		0
-#endif
-
-/* Page flags: | [SECTION] | [NODE] | ZONE | ... | FLAGS | */
+/* Page flags: | [SECTION] | [NODE] | ZONE | [LAST_NID] | ... | FLAGS | */
 #define SECTIONS_PGOFF		((sizeof(unsigned long)*8) - SECTIONS_WIDTH)
 #define NODES_PGOFF		(SECTIONS_PGOFF - NODES_WIDTH)
 #define ZONES_PGOFF		(NODES_PGOFF - ZONES_WIDTH)
-
-/*
- * We are going to use the flags for the page to node mapping if its in
- * there.  This includes the case where there is no node, so it is implicit.
- */
-#if !(NODES_WIDTH > 0 || NODES_SHIFT == 0)
-#define NODE_NOT_IN_PAGE_FLAGS
-#endif
+#define LAST_NID_PGOFF		(ZONES_PGOFF - LAST_NID_WIDTH)
 
 /*
  * Define the bit shifts to access each section.  For non-existent
@@ -645,6 +606,7 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
 #define SECTIONS_PGSHIFT	(SECTIONS_PGOFF * (SECTIONS_WIDTH != 0))
 #define NODES_PGSHIFT		(NODES_PGOFF * (NODES_WIDTH != 0))
 #define ZONES_PGSHIFT		(ZONES_PGOFF * (ZONES_WIDTH != 0))
+#define LAST_NID_PGSHIFT	(LAST_NID_PGOFF * (LAST_NID_WIDTH != 0))
 
 /* NODE:ZONE or SECTION:ZONE is used to ID a zone for the buddy allocator */
 #ifdef NODE_NOT_IN_PAGE_FLAGS
@@ -666,6 +628,7 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
 #define ZONES_MASK		((1UL << ZONES_WIDTH) - 1)
 #define NODES_MASK		((1UL << NODES_WIDTH) - 1)
 #define SECTIONS_MASK		((1UL << SECTIONS_WIDTH) - 1)
+#define LAST_NID_MASK		((1UL << LAST_NID_WIDTH) - 1)
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
 static inline enum zone_type page_zonenum(const struct page *page)
@@ -704,6 +667,51 @@ static inline int page_to_nid(const struct page *page)
 }
 #endif
 
+#ifdef CONFIG_SCHED_NUMA
+#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
+static inline int page_xchg_last_nid(struct page *page, int nid)
+{
+	return xchg(&page->_last_nid, nid);
+}
+
+static inline int page_last_nid(struct page *page)
+{
+	return page->_last_nid;
+}
+#else
+static inline int page_xchg_last_nid(struct page *page, int nid)
+{
+	unsigned long old_flags, flags;
+	int last_nid;
+
+	do {
+		old_flags = flags = page->flags;
+		last_nid = (flags >> LAST_NID_PGSHIFT) & LAST_NID_MASK;
+
+		flags &= ~(LAST_NID_MASK << LAST_NID_PGSHIFT);
+		flags |= (nid & LAST_NID_MASK) << LAST_NID_PGSHIFT;
+	} while (unlikely(cmpxchg(&page->flags, old_flags, flags) != old_flags));
+
+	return last_nid;
+}
+
+static inline int page_last_nid(struct page *page)
+{
+	return (page->flags >> LAST_NID_PGSHIFT) & LAST_NID_MASK;
+}
+#endif /* LAST_NID_NOT_IN_PAGE_FLAGS */
+#else /* CONFIG_SCHED_NUMA */
+static inline int page_xchg_last_nid(struct page *page, int nid)
+{
+	return page_to_nid(page);
+}
+
+static inline int page_last_nid(struct page *page)
+{
+	return page_to_nid(page);
+}
+#endif /* CONFIG_SCHED_NUMA */
+
 static inline struct zone *page_zone(const struct page *page)
 {
 	return &NODE_DATA(page_to_nid(page))->node_zones[page_zonenum(page)];
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index f306cbb..e7fb4bc 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -13,6 +13,7 @@
 #include <linux/cpumask.h>
 #include <linux/page-debug-flags.h>
 #include <linux/uprobes.h>
+#include <linux/page-flags-layout.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
 
@@ -176,11 +177,9 @@ struct page {
 	 */
 	void *shadow;
 #endif
-#ifdef CONFIG_SCHED_NUMA
-	/*
-	 * XXX fold this into flags for 64bit.. see next patch.
-	 */
-	int nid_last;
+
+#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
+	int _last_nid;
 #endif
 }
 /*
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f222e06..36405f1 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -15,7 +15,7 @@
 #include <linux/seqlock.h>
 #include <linux/nodemask.h>
 #include <linux/pageblock-flags.h>
-#include <generated/bounds.h>
+#include <linux/page-flags-layout.h>
 #include <linux/atomic.h>
 #include <asm/page.h>
 
@@ -314,16 +314,6 @@ enum zone_type {
  * match the requested limits. See gfp_zone() in include/linux/gfp.h
  */
 
-#if MAX_NR_ZONES < 2
-#define ZONES_SHIFT 0
-#elif MAX_NR_ZONES <= 2
-#define ZONES_SHIFT 1
-#elif MAX_NR_ZONES <= 4
-#define ZONES_SHIFT 2
-#else
-#error ZONES_SHIFT -- too many zones configured adjust calculation
-#endif
-
 struct zone {
 	/* Fields commonly accessed by the page allocator */
 
@@ -1021,8 +1011,6 @@ static inline unsigned long early_pfn_to_nid(unsigned long pfn)
  * PA_SECTION_SHIFT		physical address to/from section number
  * PFN_SECTION_SHIFT		pfn to/from section number
  */
-#define SECTIONS_SHIFT		(MAX_PHYSMEM_BITS - SECTION_SIZE_BITS)
-
 #define PA_SECTION_SHIFT	(SECTION_SIZE_BITS)
 #define PFN_SECTION_SHIFT	(SECTION_SIZE_BITS - PAGE_SHIFT)
 
diff --git a/include/linux/page-flags-layout.h b/include/linux/page-flags-layout.h
new file mode 100644
index 0000000..586ddb6
--- /dev/null
+++ b/include/linux/page-flags-layout.h
@@ -0,0 +1,83 @@
+#ifndef _LINUX_PAGE_FLAGS_LAYOUT
+#define _LINUX_PAGE_FLAGS_LAYOUT
+
+#include <linux/numa.h>
+#include <generated/bounds.h>
+
+#if MAX_NR_ZONES < 2
+#define ZONES_SHIFT 0
+#elif MAX_NR_ZONES <= 2
+#define ZONES_SHIFT 1
+#elif MAX_NR_ZONES <= 4
+#define ZONES_SHIFT 2
+#else
+#error ZONES_SHIFT -- too many zones configured adjust calculation
+#endif
+
+#ifdef CONFIG_SPARSEMEM
+#include <asm/sparsemem.h>
+
+/* 
+ * SECTION_SHIFT    		#bits space required to store a section #
+ */
+#define SECTIONS_SHIFT         (MAX_PHYSMEM_BITS - SECTION_SIZE_BITS)
+#endif
+
+/*
+ * page->flags layout:
+ *
+ * There are five possibilities for how page->flags get laid out.  The first
+ * (and second) is for the normal case, without sparsemem. The third is for
+ * sparsemem when there is plenty of space for node and section. The last is
+ * when we have run out of space and have to fall back to an alternate (slower)
+ * way of determining the node.
+ *
+ * No sparsemem or sparsemem vmemmap: |       NODE     | ZONE |            ... | FLAGS |
+ *     "      plus space for last_nid:|       NODE     | ZONE | LAST_NID | ... | FLAGS |
+ * classic sparse with space for node:| SECTION | NODE | ZONE |            ... | FLAGS |
+ *     "      plus space for last_nid:| SECTION | NODE | ZONE | LAST_NID | ... | FLAGS |
+ * classic sparse no space for node:  | SECTION |     ZONE    |            ... | FLAGS |
+ */
+#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+
+#define SECTIONS_WIDTH		SECTIONS_SHIFT
+#else
+#define SECTIONS_WIDTH		0
+#endif
+
+#define ZONES_WIDTH		ZONES_SHIFT
+
+#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
+#define NODES_WIDTH		NODES_SHIFT
+#else
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+#error "Vmemmap: No space for nodes field in page flags"
+#endif
+#define NODES_WIDTH		0
+#endif
+
+#ifdef CONFIG_SCHED_NUMA
+#define LAST_NID_SHIFT	NODES_SHIFT
+#else
+#define LAST_NID_SHIFT	0
+#endif
+
+#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT+LAST_NID_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
+#define LAST_NID_WIDTH	LAST_NID_SHIFT
+#else
+#define LAST_NID_WIDTH	0
+#endif
+
+/*
+ * We are going to use the flags for the page to node mapping if its in
+ * there.  This includes the case where there is no node, so it is implicit.
+ */
+#if !(NODES_WIDTH > 0 || NODES_SHIFT == 0)
+#define NODE_NOT_IN_PAGE_FLAGS
+#endif
+
+#if defined(CONFIG_SCHED_NUMA) && LAST_NID_WIDTH == 0
+#define LAST_NID_NOT_IN_PAGE_FLAGS
+#endif
+
+#endif /* _LINUX_PAGE_FLAGS_LAYOUT */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 45b11f1..4a9ea86 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1377,7 +1377,7 @@ static void __split_huge_page_refcount(struct page *page)
 		page_tail->mapping = page->mapping;
 
 		page_tail->index = page->index + i;
-		page_tail->nid_last = page->nid_last;
+		page_xchg_last_nid(page, page_last_nid(page_tail));
 
 		BUG_ON(!PageAnon(page_tail));
 		BUG_ON(!PageUptodate(page_tail));
diff --git a/mm/memory.c b/mm/memory.c
index 7dbdd85..f10b4e2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -68,6 +68,10 @@
 
 #include "internal.h"
 
+#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
+#warning Unfortunate NUMA config, growing page-frame for last_nid.
+#endif
+
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 /* use the per-pgdat data instead for discontigmem - mbligh */
 unsigned long max_mapnr;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 861190f..7b4ff19 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2265,10 +2265,9 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma,
 	 * task_tick_numa().
 	 */
 	if (multi && (pol->flags & MPOL_F_HOME)) {
-		if (page->nid_last != polnid) {
-			page->nid_last = polnid;
+		int last_nid = page_xchg_last_nid(page, polnid);
+		if (last_nid != polnid)
 			goto out;
-		}
 	}
 
 	if (curnid != polnid)
