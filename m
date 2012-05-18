Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161098Ab2ERK1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:27:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42310 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161032Ab2ERK1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:27:18 -0400
Date: Fri, 18 May 2012 03:26:26 -0700
From: tip-bot for Lee Schermerhorn <lee.schermerhorn@hp.com>
Message-ID: <tip-pianzfvc85f4sd7hnz91g9sl@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        lee.schermerhorn@hp.com, cl@linux.com, riel@redhat.com,
        akpm@linux-foundation.org, bharata.rao@gmail.com, aarcange@redhat.com,
        danms@us.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        lee.schermerhorn@hp.com, cl@linux.com, riel@redhat.com,
        bharata.rao@gmail.com, akpm@linux-foundation.org, aarcange@redhat.com,
        suresh.b.siddha@intel.com, danms@us.ibm.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm: Migrate misplaced page
Git-Commit-ID: 4783af477d3da0e2643cf2f0619265fdf12f29f4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:26:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4783af477d3da0e2643cf2f0619265fdf12f29f4
Gitweb:     http://git.kernel.org/tip/4783af477d3da0e2643cf2f0619265fdf12f29f4
Author:     Lee Schermerhorn <lee.schermerhorn@hp.com>
AuthorDate: Wed, 11 Jan 2012 16:31:57 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:18 +0200

mm: Migrate misplaced page

This patch adds a new function migrate_misplaced_page() to mm/migrate.c
[where most of the other page migration functions live] to migrate a
misplaced page to a specified destination node.  This function will be
called from the fault path.  Because we already know the destination
node for the migration, we allocate pages directly rather than rerunning
the policy node computation in alloc_page_vma().

Since the fault path holds an extra reference from other migration
paths, introduce a new migration_mode (MIGRATE_FAULT) to communicate
this.

The patch adds the function check_migrate_misplaced_page() to migrate.c
to check whether a page is "misplaced" -- i.e. on a node different
from what the policy for (vma, address) dictates.  This check
involves accessing the vma policy, so we only do this if:

   * page has zero mapcount [no pte references]
   * page is not in writeback
   * page is up to date
   * page's mapping has a migratepage a_op [no fallback!]

If these checks are satisfied, the page will be migrated to the
"correct" node, if possible.  If migration fails for any reason,
we just use the original page.

Subsequent patches will hook the fault handlers [anon, and possibly
file and/or shmem] to check_migrate_misplaced_page().

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
[ fixed memcg use-after free ]
Fix-by: Dan Smith <danms@us.ibm.com>
[ removed the weird ignore page count on migrate stuff with the
  new migrate_mode and strict accounting ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-pianzfvc85f4sd7hnz91g9sl@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mempolicy.h    |   18 +-----
 include/linux/migrate.h      |   14 +++++
 include/linux/migrate_mode.h |    3 +
 mm/mempolicy.c               |   19 ++++++
 mm/migrate.c                 |  130 +++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 167 insertions(+), 17 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index f005c00..c970840 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -78,6 +78,7 @@ enum mpol_rebind_step {
 #include <linux/spinlock.h>
 #include <linux/nodemask.h>
 #include <linux/pagemap.h>
+#include <linux/migrate.h>
 
 struct mm_struct;
 
@@ -246,22 +247,7 @@ extern int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context);
 extern int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol,
 			int no_context);
 
-/* Check if a vma is migratable */
-static inline int vma_migratable(struct vm_area_struct *vma)
-{
-	if (vma->vm_flags & (VM_IO|VM_HUGETLB|VM_PFNMAP|VM_RESERVED))
-		return 0;
-	/*
-	 * Migration allocates pages in the highest zone. If we cannot
-	 * do so then migration (at least from node to node) is not
-	 * possible.
-	 */
-	if (vma->vm_file &&
-		gfp_zone(mapping_gfp_mask(vma->vm_file->f_mapping))
-								< policy_zone)
-			return 0;
-	return 1;
-}
+extern int vma_migratable(struct vm_area_struct *);
 
 extern int mpol_misplaced(struct page *, struct vm_area_struct *, unsigned long);
 
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 9e00dc9..0a0dbc0 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -32,6 +32,8 @@ extern int migrate_huge_page_move_mapping(struct address_space *mapping,
 				  struct page *newpage, struct page *page);
 
 extern int migrate_pages_unmap_only(struct list_head *);
+extern struct page *migrate_misplaced_page(struct page *,
+			struct mm_struct *, int);
 #else
 
 static inline void putback_lru_pages(struct list_head *l) {}
@@ -71,4 +73,16 @@ static inline int migrate_pages_unmap_only(struct list_head *l)
 #define fail_migrate_page NULL
 
 #endif /* CONFIG_MIGRATION */
+
+#if defined(CONFIG_MIGRATION) && defined(CONFIG_NUMA)
+extern struct page *check_migrate_misplaced_page(struct page *,
+			struct vm_area_struct *, unsigned long);
+#else
+static inline struct page *check_migrate_misplaced_page(struct page *page,
+			struct vm_area_struct *vma, unsigned long addr)
+{
+	return page;
+}
+#endif
+
 #endif /* _LINUX_MIGRATE_H */
diff --git a/include/linux/migrate_mode.h b/include/linux/migrate_mode.h
index ebf3d89..9694347 100644
--- a/include/linux/migrate_mode.h
+++ b/include/linux/migrate_mode.h
@@ -6,11 +6,14 @@
  *	on most operations but not ->writepage as the potential stall time
  *	is too significant
  * MIGRATE_SYNC will block when migrating pages
+ * MIGRATE_FAULT called from the fault path to migrate-on-fault for mempolicy
+ * 	this path has an extra reference count
  */
 enum migrate_mode {
 	MIGRATE_ASYNC,
 	MIGRATE_SYNC_LIGHT,
 	MIGRATE_SYNC,
+	MIGRATE_FAULT,
 };
 
 #endif		/* MIGRATE_MODE_H_INCLUDED */
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 651b7a3..b60c991 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -464,6 +464,25 @@ static const struct mempolicy_operations mpol_ops[MPOL_MAX] = {
 static void migrate_page_add(struct page *page, struct list_head *pagelist,
 				unsigned long flags);
 
+/*
+ * Check whether a vma is migratable
+ */
+int vma_migratable(struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & (VM_IO|VM_HUGETLB|VM_PFNMAP|VM_RESERVED))
+		return 0;
+	/*
+	 * Migration allocates pages in the highest zone. If we cannot
+	 * do so then migration (at least from node to node) is not
+	 * possible.
+	 */
+	if (vma->vm_file &&
+		gfp_zone(mapping_gfp_mask(vma->vm_file->f_mapping))
+								< policy_zone)
+			return 0;
+	return 1;
+}
+
 struct mempol_walk_data {
 	struct vm_area_struct *vma;
 	const nodemask_t *nodes;
diff --git a/mm/migrate.c b/mm/migrate.c
index 45ad2b3..4140f69 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -294,6 +294,10 @@ static int migrate_page_move_mapping(struct address_space *mapping,
  					page_index(page));
 
 	expected_count = 2 + page_has_private(page);
+	if (mode == MIGRATE_FAULT) {
+		expected_count++;
+		mode = MIGRATE_ASYNC; /* don't bother blocking for MoF */
+	}
 	if (page_count(page) != expected_count ||
 		radix_tree_deref_slot_protected(pslot, &mapping->tree_lock) != page) {
 		spin_unlock_irq(&mapping->tree_lock);
@@ -1517,4 +1521,128 @@ int migrate_vmas(struct mm_struct *mm, const nodemask_t *to,
  	}
  	return err;
 }
-#endif
+
+/*
+ * Attempt to migrate a misplaced page to the specified destination
+ * node.  Page is already unmapped, up to date and locked by caller.
+ * Anon pages are in the swap cache.  Page's mapping has a migratepage aop.
+ *
+ * page refs on entry/exit:  cache + fault path [+ bufs]
+ */
+struct page *
+migrate_misplaced_page(struct page *page, struct mm_struct *mm, int node)
+{
+	struct page *oldpage = page, *newpage;
+	struct address_space *mapping = page_mapping(page);
+	struct mem_cgroup *mcg;
+	unsigned int gfp;
+	int rc = 0;
+	int charge = -ENOMEM;
+
+	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON(page_mapcount(page));
+	VM_BUG_ON(PageAnon(page) && !PageSwapCache(page));
+	VM_BUG_ON(!mapping || !mapping->a_ops->migratepage);
+
+	/*
+	 * remove old page from LRU so it can't be found while migrating
+	 * except thru' the cache by other faulting tasks who will
+	 * block behind my lock.
+	 */
+	if (isolate_lru_page(page))	/* incrs page count on success */
+		goto out_nolru;	/* we lost */
+
+	/*
+	 * Never wait for allocations just to migrate on fault,
+	 * but don't dip into reserves.
+	 * And, only accept pages from specified node.
+	 * No sense migrating to a different "misplaced" page!
+	 */
+	gfp = (unsigned int)mapping_gfp_mask(mapping) & ~__GFP_WAIT;
+	gfp |= __GFP_NOMEMALLOC | GFP_THISNODE ;
+
+	newpage = alloc_pages_node(node, gfp, 0);
+	if (!newpage)
+		goto out;	/* give up */
+
+	/*
+	 * can't just lock_page() -- "might sleep" in atomic context
+	 */
+	if (!trylock_page(newpage))
+		BUG();		/* new page should be unlocked!!! */
+
+	// XXX hnaz, is this right?
+	charge = mem_cgroup_prepare_migration(page, newpage, &mcg, gfp);
+	if (charge == -ENOMEM) {
+		rc = charge;
+		goto out;
+	}
+
+	newpage->index = page->index;
+	newpage->mapping = page->mapping;
+	if (PageSwapBacked(page))		/* like move_to_new_page() */
+		SetPageSwapBacked(newpage);
+
+	/*
+	 * migrate a_op transfers cache [+ buf] refs
+	 */
+	rc = mapping->a_ops->migratepage(mapping, newpage, page, MIGRATE_FAULT);
+	if (!rc) {
+		get_page(newpage);	/* add isolate_lru_page ref */
+		put_page(page);		/* drop       "          "  */
+
+		unlock_page(page);
+
+		page = newpage;
+	}
+
+out:
+	if (!charge)
+		mem_cgroup_end_migration(mcg, oldpage, newpage, !rc);
+
+       if (oldpage != page)
+               put_page(oldpage);
+
+	if (rc) {
+		unlock_page(newpage);
+		__free_page(newpage);
+	}
+
+	putback_lru_page(page);		/* ultimately, drops a page ref */
+
+out_nolru:
+	return page;			/* locked, to complete fault */
+}
+
+/*
+ * Called in fault path, if migrate_on_fault_enabled(current) for a page
+ * found in the cache, page is locked, and page_mapping(page) != NULL;
+ * We check for page uptodate here because we want to be able to do any
+ * needed migration before grabbing the page table lock.  In the anon fault
+ * path, PageUptodate() isn't checked until after locking the page table.
+ *
+ * For migrate on fault, we only migrate pages whose mapping has a
+ * migratepage op.  The fallback path requires writing out the page and
+ * reading it back in.  That sort of defeats the purpose of
+ * migrate-on-fault [performance].  So, we don't even bother to check
+ * for misplacment unless the op is present.  Of course, this is an extra
+ * check in the fault path for pages we care about :-(
+ */
+struct page *check_migrate_misplaced_page(struct page *page,
+		struct vm_area_struct *vma, unsigned long address)
+{
+	int node;
+
+	if (page_mapcount(page) || PageWriteback(page) ||
+			unlikely(!PageUptodate(page))  ||
+			!page_mapping(page)->a_ops->migratepage)
+		return page;
+
+	node = mpol_misplaced(page, vma, address);
+	if (node == -1)
+		return page;
+
+	return migrate_misplaced_page(page, vma->vm_mm, node);
+}
+
+#endif /* CONFIG_NUMA */
