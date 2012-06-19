Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2FSSHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:07:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab2FSSHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:07:48 -0400
Date: Tue, 19 Jun 2012 20:06:46 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hillf Danton <dhillf@gmail.com>,
        Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 13/35] autonuma: add page structure fields
Message-ID: <20120619180646.GN4633@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
 <1337965359-29725-14-git-send-email-aarcange@redhat.com>
 <1338297385.26856.74.camel@twins>
 <4FC4D58A.50800@redhat.com>
 <1338303251.26856.94.camel@twins>
 <4FC5D973.3080108@gmail.com>
 <1338368763.26856.207.camel@twins>
 <20120530134953.GD21339@redhat.com>
 <1338488339.28384.106.camel@twins>
 <20120605145123.GG21339@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120605145123.GG21339@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On Tue, Jun 05, 2012 at 04:51:23PM +0200, Andrea Arcangeli wrote:
> The details of the solution:
> 
> struct page_autonuma {
>     short autonuma_last_nid;
>     short autonuma_migrate_nid;
>     unsigned int pfn_offset_next;
>     unsigned int pfn_offset_prev;
> } __attribute__((packed));
> 
> page_autonuma can only point to a page that belongs to the same node
> (page_autonuma is queued into the
> NODE_DATA(autonuma_migrate_nid)->autonuma_migrate_head[src_nid]) where
> src_nid is the source node that page_autonuma belongs to, so all pages
> in the autonuma_migrate_head[src_nid] lru must come from the same
> src_nid. So the next page_autonuma in the list will be
> lookup_page_autonuma(pfn_to_page(NODE_DATA(src_nid)->node_start_pfn +
> page_autonuma->pfn_offset_next)) etc..
> 
> Of course all list_add/del must be hardcoded specially for this, but
> it's not a conceptually difficult solution, just we can't use list.h
> and stright pointers anymore and some conversion must happen.

So here the above idea implemented and working fine (it seems...?!? it
has been running only for half an hour but all benchmark regression
tests passed with the same score as before and I verified memory goes
in all directions during the bench, so there's good chance it's ok).

It actually works even if a node has more than 16TB but in that case
it will WARN_ONCE on the first page that is migrated at an offset
above 16TB from the start of the node, and then it will continue
simply skipping migrating those pages with a too large offset.

Next part coming is the docs of autonuma_balance() at the top of
kernel/sched/numa.c and cleanup the autonuma_balance callout location
(if I can figure how to do an active balance on the running task from
softirq). The location at the moment is there just to be invoked after
load_balance runs so it shouldn't make a runtime difference after I
clean it up (hackbench already runs identical to upstream) but
certainly it'll be nice to microoptimize away a call and a branch from
the schedule() fast path.

After that I'll write Documentation/vm/AutoNUMA.txt and I'll finish
the THP native migration (the last one assuming nobody does it before
I get there, if somebody wants to do it sooner, we figured the locking
details with Johannes during the MM summit but it's some work to
implement it).

===
>From 17e1cbc02c1b41037248d9952179ff293a287d58 Mon Sep 17 00:00:00 2001
From: Andrea Arcangeli <aarcange@redhat.com>
Date: Tue, 19 Jun 2012 18:55:25 +0200
Subject: [PATCH] autonuma: shrink the per-page page_autonuma struct size

>From 32 to 12 bytes, so the AutoNUMA memory footprint is reduced to
0.29% of RAM.

This however will fail to migrate pages above a 16 Terabyte offset
from the start of each node (migration failure isn't fatal, simply
those pages will not follow the CPU, a warning will be printed in the
log just once in that case).

AutoNUMA will also fail to build if there are more than (2**15)-1
nodes supported by the MAX_NUMNODES at build time (it would be easy to
relax it to (2**16)-1 nodes without increasing the memory footprint,
but it's not even worth it, so let's keep the negative space reserved
for now).

This means the max RAM configuration fully supported by AutoNUMA
becomes AUTONUMA_LIST_MAX_PFN_OFFSET multiplied by 32767 nodes
multiplied by the PAGE_SIZE (assume 4096 here, but for some archs it's
bigger).

4096*32767*(0xffffffff-3)>>(10*5) = 511 PetaBytes.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/linux/autonuma_list.h  |   94 ++++++++++++++++++++++
 include/linux/autonuma_types.h |   48 +++++++-----
 include/linux/mmzone.h         |    3 +-
 include/linux/page_autonuma.h  |    2 +-
 mm/Makefile                    |    2 +-
 mm/autonuma.c                  |   75 +++++++++++++-----
 mm/autonuma_list.c             |  167 ++++++++++++++++++++++++++++++++++++++++
 mm/page_autonuma.c             |   15 ++--
 8 files changed, 355 insertions(+), 51 deletions(-)
 create mode 100644 include/linux/autonuma_list.h
 create mode 100644 mm/autonuma_list.c

diff --git a/include/linux/autonuma_list.h b/include/linux/autonuma_list.h
new file mode 100644
index 0000000..0f338e9
--- /dev/null
+++ b/include/linux/autonuma_list.h
@@ -0,0 +1,94 @@
+#ifndef __AUTONUMA_LIST_H
+#define __AUTONUMA_LIST_H
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+
+typedef uint32_t autonuma_list_entry;
+#define AUTONUMA_LIST_MAX_PFN_OFFSET	(AUTONUMA_LIST_HEAD-3)
+#define AUTONUMA_LIST_POISON1		(AUTONUMA_LIST_HEAD-2)
+#define AUTONUMA_LIST_POISON2		(AUTONUMA_LIST_HEAD-1)
+#define AUTONUMA_LIST_HEAD		((uint32_t)UINT_MAX)
+
+struct autonuma_list_head {
+	autonuma_list_entry anl_next_pfn;
+	autonuma_list_entry anl_prev_pfn;
+};
+
+static inline void AUTONUMA_INIT_LIST_HEAD(struct autonuma_list_head *anl)
+{
+	anl->anl_next_pfn = AUTONUMA_LIST_HEAD;
+	anl->anl_prev_pfn = AUTONUMA_LIST_HEAD;
+}
+
+/* abstraction conversion methods */
+extern struct page *autonuma_list_entry_to_page(int nid,
+					autonuma_list_entry pfn_offset);
+extern autonuma_list_entry autonuma_page_to_list_entry(int page_nid,
+						       struct page *page);
+extern struct autonuma_list_head *__autonuma_list_head(int page_nid,
+					struct autonuma_list_head *head,
+					autonuma_list_entry pfn_offset);
+
+extern bool __autonuma_list_add(int page_nid,
+				struct page *page,
+				struct autonuma_list_head *head,
+				autonuma_list_entry prev,
+				autonuma_list_entry next);
+
+/*
+ * autonuma_list_add - add a new entry
+ *
+ * Insert a new entry after the specified head.
+ */
+static inline bool autonuma_list_add(int page_nid,
+				     struct page *page,
+				     autonuma_list_entry entry,
+				     struct autonuma_list_head *head)
+{
+	struct autonuma_list_head *entry_head;
+	entry_head = __autonuma_list_head(page_nid, head, entry);
+	return __autonuma_list_add(page_nid, page, head,
+				   entry, entry_head->anl_next_pfn);
+}
+
+/*
+ * autonuma_list_add_tail - add a new entry
+ *
+ * Insert a new entry before the specified head.
+ * This is useful for implementing queues.
+ */
+static inline bool autonuma_list_add_tail(int page_nid,
+					  struct page *page,
+					  autonuma_list_entry entry,
+					  struct autonuma_list_head *head)
+{
+	struct autonuma_list_head *entry_head;
+	entry_head = __autonuma_list_head(page_nid, head, entry);
+	return __autonuma_list_add(page_nid, page, head,
+				   entry_head->anl_prev_pfn, entry);
+}
+
+/*
+ * autonuma_list_del - deletes entry from list.
+ * @entry: the element to delete from the list.
+ */
+extern void autonuma_list_del(int page_nid,
+			      struct autonuma_list_head *entry,
+			      struct autonuma_list_head *head);
+
+extern bool autonuma_list_empty(const struct autonuma_list_head *head);
+
+#if 0 /* not needed so far */
+/*
+ * autonuma_list_is_singular - tests whether a list has just one entry.
+ * @head: the list to test.
+ */
+static inline int autonuma_list_is_singular(const struct autonuma_list_head *head)
+{
+	return !autonuma_list_empty(head) &&
+		(head->anl_next_pfn == head->anl_prev_pfn);
+}
+#endif
+
+#endif /* __AUTONUMA_LIST_H */
diff --git a/include/linux/autonuma_types.h b/include/linux/autonuma_types.h
index 6662990..1abde9c5 100644
--- a/include/linux/autonuma_types.h
+++ b/include/linux/autonuma_types.h
@@ -4,6 +4,7 @@
 #ifdef CONFIG_AUTONUMA
 
 #include <linux/numa.h>
+#include <linux/autonuma_list.h>
 
 /*
  * Per-mm (process) structure dynamically allocated only if autonuma
@@ -45,15 +46,36 @@ struct task_autonuma {
 /*
  * Per page (or per-pageblock) structure dynamically allocated only if
  * autonuma is not impossible.
+ *
+ * This structure takes 12 bytes per page for all architectures. There
+ * are two constraints to make this work:
+ *
+ * 1) the build will abort if * MAX_NUMNODES is too big according to
+ *    the #error check below
+ *
+ * 2) AutoNUMA will not succeed to insert into the migration queue any
+ *    page whose pfn offset value (offset with respect to the first
+ *    pfn of the node) is bigger than AUTONUMA_LIST_MAX_PFN_OFFSET
+ *    (NOTE: AUTONUMA_LIST_MAX_PFN_OFFSET is still a valid pfn offset
+ *    value). This means with huge node sizes and small PAGE_SIZE,
+ *    some pages may not be allowed to be migrated.
  */
 struct page_autonuma {
 	/*
 	 * To modify autonuma_last_nid lockless the architecture,
 	 * needs SMP atomic granularity < sizeof(long), not all archs
-	 * have that, notably some alpha. Archs without that requires
+	 * have that, notably some ancient alpha (but none of those
+	 * should run in NUMA systems). Archs without that requires
 	 * autonuma_last_nid to be a long.
 	 */
-#if BITS_PER_LONG > 32
+#if MAX_NUMNODES > 32767
+	/*
+	 * Verify at build time that int16_t for autonuma_migrate_nid
+	 * and autonuma_last_nid won't risk to overflow, max allowed
+	 * nid value is (2**15)-1.
+	 */
+#error "too many nodes"
+#endif
 	/*
 	 * autonuma_migrate_nid is -1 if the page_autonuma structure
 	 * is not linked into any
@@ -63,7 +85,7 @@ struct page_autonuma {
 	 * page_nid is the nid that the page (referenced by the
 	 * page_autonuma structure) belongs to.
 	 */
-	int autonuma_migrate_nid;
+	int16_t autonuma_migrate_nid;
 	/*
 	 * autonuma_last_nid records which is the NUMA nid that tried
 	 * to access this page at the last NUMA hinting page fault.
@@ -72,28 +94,14 @@ struct page_autonuma {
 	 * it will make different threads trashing on the same pages,
 	 * converge on the same NUMA node (if possible).
 	 */
-	int autonuma_last_nid;
-#else
-#if MAX_NUMNODES >= 32768
-#error "too many nodes"
-#endif
-	short autonuma_migrate_nid;
-	short autonuma_last_nid;
-#endif
+	int16_t autonuma_last_nid;
+
 	/*
 	 * This is the list node that links the page (referenced by
 	 * the page_autonuma structure) in the
 	 * &NODE_DATA(dst_nid)->autonuma_migrate_head[page_nid] lru.
 	 */
-	struct list_head autonuma_migrate_node;
-
-	/*
-	 * To find the page starting from the autonuma_migrate_node we
-	 * need a backlink.
-	 *
-	 * FIXME: drop it;
-	 */
-	struct page *page;
+	struct autonuma_list_head autonuma_migrate_node;
 };
 
 extern int alloc_task_autonuma(struct task_struct *tsk,
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ed5b0c0..acefdfa 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -17,6 +17,7 @@
 #include <linux/pageblock-flags.h>
 #include <generated/bounds.h>
 #include <linux/atomic.h>
+#include <linux/autonuma_list.h>
 #include <asm/page.h>
 
 /* Free memory management - zoned buddy allocator.  */
@@ -710,7 +711,7 @@ typedef struct pglist_data {
 	 * <linux/page_autonuma.h> and the below field must remain the
 	 * last one of this structure.
 	 */
-	struct list_head autonuma_migrate_head[0];
+	struct autonuma_list_head autonuma_migrate_head[0];
 #endif
 } pg_data_t;
 
diff --git a/include/linux/page_autonuma.h b/include/linux/page_autonuma.h
index bc7a629..e78beda 100644
--- a/include/linux/page_autonuma.h
+++ b/include/linux/page_autonuma.h
@@ -53,7 +53,7 @@ extern void __init sparse_early_page_autonuma_alloc_node(struct page_autonuma **
 /* inline won't work here */
 #define autonuma_pglist_data_size() (sizeof(struct pglist_data) +	\
 				     (autonuma_impossible() ? 0 :	\
-				      sizeof(struct list_head) * \
+				      sizeof(struct autonuma_list_head) * \
 				      num_possible_nodes()))
 
 #endif /* _LINUX_PAGE_AUTONUMA_H */
diff --git a/mm/Makefile b/mm/Makefile
index a4d8354..4aa90d4 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -33,7 +33,7 @@ obj-$(CONFIG_FRONTSWAP)	+= frontswap.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
 obj-$(CONFIG_NUMA) 	+= mempolicy.o
-obj-$(CONFIG_AUTONUMA) 	+= autonuma.o page_autonuma.o
+obj-$(CONFIG_AUTONUMA) 	+= autonuma.o page_autonuma.o autonuma_list.o
 obj-$(CONFIG_SPARSEMEM)	+= sparse.o
 obj-$(CONFIG_SPARSEMEM_VMEMMAP) += sparse-vmemmap.o
 obj-$(CONFIG_SLOB) += slob.o
diff --git a/mm/autonuma.c b/mm/autonuma.c
index 9834f5d..8aed9af 100644
--- a/mm/autonuma.c
+++ b/mm/autonuma.c
@@ -89,12 +89,21 @@ void autonuma_migrate_split_huge_page(struct page *page,
 	VM_BUG_ON(nid < -1);
 	VM_BUG_ON(page_tail_autonuma->autonuma_migrate_nid != -1);
 	if (nid >= 0) {
-		VM_BUG_ON(page_to_nid(page) != page_to_nid(page_tail));
+		int page_nid = page_to_nid(page);
+		struct autonuma_list_head *head;
+		autonuma_list_entry entry;
+		entry = autonuma_page_to_list_entry(page_nid, page);
+		head = &NODE_DATA(nid)->autonuma_migrate_head[page_nid];
+		VM_BUG_ON(page_nid != page_to_nid(page_tail));
+		VM_BUG_ON(page_nid == nid);
 
 		compound_lock(page_tail);
 		autonuma_migrate_lock(nid);
-		list_add_tail(&page_tail_autonuma->autonuma_migrate_node,
-			      &page_autonuma->autonuma_migrate_node);
+		if (!autonuma_list_add_tail(page_nid,
+					    page_tail,
+					    entry,
+					    head))
+			BUG();
 		autonuma_migrate_unlock(nid);
 
 		page_tail_autonuma->autonuma_migrate_nid = nid;
@@ -119,8 +128,15 @@ void __autonuma_migrate_page_remove(struct page *page,
 	VM_BUG_ON(nid < -1);
 	if (nid >= 0) {
 		int numpages = hpage_nr_pages(page);
+		int page_nid = page_to_nid(page);
+		struct autonuma_list_head *head;
+		VM_BUG_ON(nid == page_nid);
+		head = &NODE_DATA(nid)->autonuma_migrate_head[page_nid];
+
 		autonuma_migrate_lock(nid);
-		list_del(&page_autonuma->autonuma_migrate_node);
+		autonuma_list_del(page_nid,
+				  &page_autonuma->autonuma_migrate_node,
+				  head);
 		NODE_DATA(nid)->autonuma_nr_migrate_pages -= numpages;
 		autonuma_migrate_unlock(nid);
 
@@ -139,6 +155,8 @@ static void __autonuma_migrate_page_add(struct page *page,
 	int numpages;
 	unsigned long nr_migrate_pages;
 	wait_queue_head_t *wait_queue;
+	struct autonuma_list_head *head;
+	bool added;
 
 	VM_BUG_ON(dst_nid >= MAX_NUMNODES);
 	VM_BUG_ON(dst_nid < -1);
@@ -155,25 +173,33 @@ static void __autonuma_migrate_page_add(struct page *page,
 	VM_BUG_ON(nid >= MAX_NUMNODES);
 	VM_BUG_ON(nid < -1);
 	if (nid >= 0) {
+		VM_BUG_ON(nid == page_nid);
+		head = &NODE_DATA(nid)->autonuma_migrate_head[page_nid];
+
 		autonuma_migrate_lock(nid);
-		list_del(&page_autonuma->autonuma_migrate_node);
+		autonuma_list_del(page_nid,
+				  &page_autonuma->autonuma_migrate_node,
+				  head);
 		NODE_DATA(nid)->autonuma_nr_migrate_pages -= numpages;
 		autonuma_migrate_unlock(nid);
 	}
 
+	head = &NODE_DATA(dst_nid)->autonuma_migrate_head[page_nid];
+
 	autonuma_migrate_lock(dst_nid);
-	list_add(&page_autonuma->autonuma_migrate_node,
-		 &NODE_DATA(dst_nid)->autonuma_migrate_head[page_nid]);
-	NODE_DATA(dst_nid)->autonuma_nr_migrate_pages += numpages;
+	added = autonuma_list_add(page_nid, page, AUTONUMA_LIST_HEAD, head);
+	if (added)
+		NODE_DATA(dst_nid)->autonuma_nr_migrate_pages += numpages;
 	nr_migrate_pages = NODE_DATA(dst_nid)->autonuma_nr_migrate_pages;
 
 	autonuma_migrate_unlock(dst_nid);
 
-	page_autonuma->autonuma_migrate_nid = dst_nid;
+	if (added)
+		page_autonuma->autonuma_migrate_nid = dst_nid;
 
 	compound_unlock_irqrestore(page, flags);
 
-	if (!autonuma_migrate_defer()) {
+	if (added && !autonuma_migrate_defer()) {
 		wait_queue = &NODE_DATA(dst_nid)->autonuma_knuma_migrated_wait;
 		if (nr_migrate_pages >= pages_to_migrate &&
 		    nr_migrate_pages - numpages < pages_to_migrate &&
@@ -813,7 +839,7 @@ static int isolate_migratepages(struct list_head *migratepages,
 				struct pglist_data *pgdat)
 {
 	int nr = 0, nid;
-	struct list_head *heads = pgdat->autonuma_migrate_head;
+	struct autonuma_list_head *heads = pgdat->autonuma_migrate_head;
 
 	/* FIXME: THP balancing, restart from last nid */
 	for_each_online_node(nid) {
@@ -825,10 +851,10 @@ static int isolate_migratepages(struct list_head *migratepages,
 		cond_resched();
 		VM_BUG_ON(numa_node_id() != pgdat->node_id);
 		if (nid == pgdat->node_id) {
-			VM_BUG_ON(!list_empty(&heads[nid]));
+			VM_BUG_ON(!autonuma_list_empty(&heads[nid]));
 			continue;
 		}
-		if (list_empty(&heads[nid]))
+		if (autonuma_list_empty(&heads[nid]))
 			continue;
 		/* some page wants to go to this pgdat */
 		/*
@@ -840,22 +866,29 @@ static int isolate_migratepages(struct list_head *migratepages,
 		 * irqs.
 		 */
 		autonuma_migrate_lock_irq(pgdat->node_id);
-		if (list_empty(&heads[nid])) {
+		if (autonuma_list_empty(&heads[nid])) {
 			autonuma_migrate_unlock_irq(pgdat->node_id);
 			continue;
 		}
-		page_autonuma = list_entry(heads[nid].prev,
-					   struct page_autonuma,
-					   autonuma_migrate_node);
-		page = page_autonuma->page;
+		page = autonuma_list_entry_to_page(nid,
+						   heads[nid].anl_prev_pfn);
+		page_autonuma = lookup_page_autonuma(page);
 		if (unlikely(!get_page_unless_zero(page))) {
+			int page_nid = page_to_nid(page);
+			struct autonuma_list_head *entry_head;
+			VM_BUG_ON(nid == page_nid);
+
 			/*
 			 * Is getting freed and will remove self from the
 			 * autonuma list shortly, skip it for now.
 			 */
-			list_del(&page_autonuma->autonuma_migrate_node);
-			list_add(&page_autonuma->autonuma_migrate_node,
-				 &heads[nid]);
+			entry_head = &page_autonuma->autonuma_migrate_node;
+			autonuma_list_del(page_nid, entry_head,
+					  &heads[nid]);
+			if (!autonuma_list_add(page_nid, page,
+					       AUTONUMA_LIST_HEAD,
+					       &heads[nid]))
+				BUG();
 			autonuma_migrate_unlock_irq(pgdat->node_id);
 			autonuma_printk("autonuma migrate page is free\n");
 			continue;
diff --git a/mm/autonuma_list.c b/mm/autonuma_list.c
new file mode 100644
index 0000000..2c840f7
--- /dev/null
+++ b/mm/autonuma_list.c
@@ -0,0 +1,167 @@
+/*
+ * Copyright 2006, Red Hat, Inc., Dave Jones
+ * Copyright 2012, Red Hat, Inc.
+ * Released under the General Public License (GPL).
+ *
+ * This file contains the linked list implementations for
+ * autonuma migration lists.
+ */
+
+#include <linux/mm.h>
+#include <linux/autonuma.h>
+
+/*
+ * Insert a new entry between two known consecutive entries.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ *
+ * return true if succeeded, or false if the (page_nid, pfn_offset)
+ * pair couldn't represent the pfn and the list_add didn't succeed.
+ */
+bool __autonuma_list_add(int page_nid,
+			 struct page *page,
+			 struct autonuma_list_head *head,
+			 autonuma_list_entry prev,
+			 autonuma_list_entry next)
+{
+	autonuma_list_entry new;
+
+	VM_BUG_ON(page_nid != page_to_nid(page));
+	new = autonuma_page_to_list_entry(page_nid, page);
+	if (new > AUTONUMA_LIST_MAX_PFN_OFFSET)
+		return false;
+
+	WARN(new == prev || new == next,
+	     "autonuma_list_add double add: new=%u, prev=%u, next=%u.\n",
+	     new, prev, next);
+
+	__autonuma_list_head(page_nid, head, next)->anl_prev_pfn = new;
+	__autonuma_list_head(page_nid, head, new)->anl_next_pfn = next;
+	__autonuma_list_head(page_nid, head, new)->anl_prev_pfn = prev;
+	__autonuma_list_head(page_nid, head, prev)->anl_next_pfn = new;
+	return true;
+}
+
+static inline void __autonuma_list_del_entry(int page_nid,
+					     struct autonuma_list_head *entry,
+					     struct autonuma_list_head *head)
+{
+	autonuma_list_entry prev, next;
+
+	prev = entry->anl_prev_pfn;
+	next = entry->anl_next_pfn;
+
+	if (WARN(next == AUTONUMA_LIST_POISON1,
+		 "autonuma_list_del corruption, "
+		 "%p->anl_next_pfn is AUTONUMA_LIST_POISON1 (%u)\n",
+		entry, AUTONUMA_LIST_POISON1) ||
+	    WARN(prev == AUTONUMA_LIST_POISON2,
+		"autonuma_list_del corruption, "
+		 "%p->anl_prev_pfn is AUTONUMA_LIST_POISON2 (%u)\n",
+		entry, AUTONUMA_LIST_POISON2))
+		return;
+
+	__autonuma_list_head(page_nid, head, next)->anl_prev_pfn = prev;
+	__autonuma_list_head(page_nid, head, prev)->anl_next_pfn = next;
+}
+
+/*
+ * autonuma_list_del - deletes entry from list.
+ *
+ * Note: autonuma_list_empty on entry does not return true after this,
+ * the entry is in an undefined state.
+ */
+void autonuma_list_del(int page_nid, struct autonuma_list_head *entry,
+		       struct autonuma_list_head *head)
+{
+	__autonuma_list_del_entry(page_nid, entry, head);
+	entry->anl_next_pfn = AUTONUMA_LIST_POISON1;
+	entry->anl_prev_pfn = AUTONUMA_LIST_POISON2;
+}
+
+/*
+ * autonuma_list_empty - tests whether a list is empty
+ * @head: the list to test.
+ */
+bool autonuma_list_empty(const struct autonuma_list_head *head)
+{
+	bool ret = false;
+	if (head->anl_next_pfn == AUTONUMA_LIST_HEAD) {
+		ret = true;
+		BUG_ON(head->anl_prev_pfn != AUTONUMA_LIST_HEAD);
+	}
+	return ret;
+}
+
+/* abstraction conversion methods */
+
+static inline struct page *__autonuma_list_entry_to_page(int page_nid,
+							 autonuma_list_entry pfn_offset)
+{
+	struct pglist_data *pgdat = NODE_DATA(page_nid);
+	unsigned long pfn = pgdat->node_start_pfn + pfn_offset;
+	return pfn_to_page(pfn);
+}
+
+struct page *autonuma_list_entry_to_page(int page_nid,
+					 autonuma_list_entry pfn_offset)
+{
+	VM_BUG_ON(page_nid < 0);
+	BUG_ON(pfn_offset == AUTONUMA_LIST_POISON1);
+	BUG_ON(pfn_offset == AUTONUMA_LIST_POISON2);
+	BUG_ON(pfn_offset == AUTONUMA_LIST_HEAD);
+	return __autonuma_list_entry_to_page(page_nid, pfn_offset);
+}
+
+/*
+ * returns a value above AUTONUMA_LIST_MAX_PFN_OFFSET if the pfn is
+ * located a too big offset from the start of the node and cannot be
+ * represented by the (page_nid, pfn_offset) pair.
+ */
+autonuma_list_entry autonuma_page_to_list_entry(int page_nid,
+						struct page *page)
+{
+	unsigned long pfn = page_to_pfn(page);
+	struct pglist_data *pgdat = NODE_DATA(page_nid);
+	VM_BUG_ON(page_nid != page_to_nid(page));
+	BUG_ON(pfn < pgdat->node_start_pfn);
+	pfn -= pgdat->node_start_pfn;
+	if (pfn > AUTONUMA_LIST_MAX_PFN_OFFSET) {
+		WARN_ONCE(1, "autonuma_page_to_list_entry: "
+			  "pfn_offset  %lu, pgdat %p, "
+			  "pgdat->node_start_pfn %lu\n",
+			  pfn, pgdat, pgdat->node_start_pfn);
+		/*
+		 * Any value bigger than AUTONUMA_LIST_MAX_PFN_OFFSET
+		 * will work as an error retval, but better pick one
+		 * that will cause noise if computed wrong by the
+		 * caller.
+		 */
+		return AUTONUMA_LIST_POISON1;
+	}
+	return pfn; /* convert to uint16_t without losing information */
+}
+
+static inline struct autonuma_list_head *____autonuma_list_head(int page_nid,
+					autonuma_list_entry pfn_offset)
+{
+	struct pglist_data *pgdat = NODE_DATA(page_nid);
+	unsigned long pfn = pgdat->node_start_pfn + pfn_offset;
+	struct page *page = pfn_to_page(pfn);
+	struct page_autonuma *page_autonuma = lookup_page_autonuma(page);
+	return &page_autonuma->autonuma_migrate_node;
+}
+
+struct autonuma_list_head *__autonuma_list_head(int page_nid,
+					struct autonuma_list_head *head,
+					autonuma_list_entry pfn_offset)
+{
+	VM_BUG_ON(page_nid < 0);
+	BUG_ON(pfn_offset == AUTONUMA_LIST_POISON1);
+	BUG_ON(pfn_offset == AUTONUMA_LIST_POISON2);
+	if (pfn_offset != AUTONUMA_LIST_HEAD)
+		return ____autonuma_list_head(page_nid, pfn_offset);
+	else
+		return head;
+}
diff --git a/mm/page_autonuma.c b/mm/page_autonuma.c
index f929d81..151f25c 100644
--- a/mm/page_autonuma.c
+++ b/mm/page_autonuma.c
@@ -12,7 +12,6 @@ void __meminit page_autonuma_map_init(struct page *page,
 	for (end = page + nr_pages; page < end; page++, page_autonuma++) {
 		page_autonuma->autonuma_last_nid = -1;
 		page_autonuma->autonuma_migrate_nid = -1;
-		page_autonuma->page = page;
 	}
 }
 
@@ -20,12 +19,18 @@ static void __meminit __pgdat_autonuma_init(struct pglist_data *pgdat)
 {
 	int node_iter;
 
+	/* verify the per-page page_autonuma 12 byte fixed cost */
+	BUILD_BUG_ON((unsigned long) &((struct page_autonuma *)0)[1] != 12);
+
 	spin_lock_init(&pgdat->autonuma_lock);
 	init_waitqueue_head(&pgdat->autonuma_knuma_migrated_wait);
 	pgdat->autonuma_nr_migrate_pages = 0;
 	if (!autonuma_impossible())
-		for_each_node(node_iter)
-			INIT_LIST_HEAD(&pgdat->autonuma_migrate_head[node_iter]);
+		for_each_node(node_iter) {
+			struct autonuma_list_head *head;
+			head = &pgdat->autonuma_migrate_head[node_iter];
+			AUTONUMA_INIT_LIST_HEAD(head);
+		}
 }
 
 #if !defined(CONFIG_SPARSEMEM)
@@ -112,10 +117,6 @@ struct page_autonuma *lookup_page_autonuma(struct page *page)
 	unsigned long pfn = page_to_pfn(page);
 	struct mem_section *section = __pfn_to_section(pfn);
 
-	/* if it's not a power of two we may be wasting memory */
-	BUILD_BUG_ON(SECTION_PAGE_AUTONUMA_SIZE &
-		     (SECTION_PAGE_AUTONUMA_SIZE-1));
-
 #ifdef CONFIG_DEBUG_VM
 	/*
 	 * The sanity checks the page allocator does upon freeing a
