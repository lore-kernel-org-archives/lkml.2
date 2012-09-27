Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2I0GFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:05:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54685 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab2I0GFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:05:48 -0400
Date: Wed, 26 Sep 2012 23:05:24 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-es03i8ne7xee0981brw40fl5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm/migrate: Introduce migrate_misplaced_page()
Git-Commit-ID: 03a040f6c17ab81659579ba6abe267c0562097e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 23:05:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03a040f6c17ab81659579ba6abe267c0562097e4
Gitweb:     http://git.kernel.org/tip/03a040f6c17ab81659579ba6abe267c0562097e4
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 17 Jul 2012 22:54:51 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Sep 2012 11:48:34 +0200

mm/migrate: Introduce migrate_misplaced_page()

Add migrate_misplaced_page() which deals with migrating pages from
faults. This includes adding a new MIGRATE_FAULT migration mode to
deal with the extra page reference required due to having to look up
the page.

Based-on-work-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Paul Turner <pjt@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-es03i8ne7xee0981brw40fl5@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/migrate.h      |    7 +++
 include/linux/migrate_mode.h |    3 +
 mm/migrate.c                 |   85 ++++++++++++++++++++++++++++++++++++++----
 3 files changed, 87 insertions(+), 8 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index ce7e667..7544d1a 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -30,6 +30,7 @@ extern int migrate_vmas(struct mm_struct *mm,
 extern void migrate_page_copy(struct page *newpage, struct page *page);
 extern int migrate_huge_page_move_mapping(struct address_space *mapping,
 				  struct page *newpage, struct page *page);
+extern int migrate_misplaced_page(struct mm_struct *, struct page *, int);
 #else
 
 static inline void putback_lru_pages(struct list_head *l) {}
@@ -63,5 +64,11 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 #define migrate_page NULL
 #define fail_migrate_page NULL
 
+static inline
+int migrate_misplaced_page(struct mm_struct *mm, struct page *page, int node)
+{
+	return -EAGAIN; /* can't migrate now */
+}
 #endif /* CONFIG_MIGRATION */
+
 #endif /* _LINUX_MIGRATE_H */
diff --git a/include/linux/migrate_mode.h b/include/linux/migrate_mode.h
index ebf3d89..40b37dc 100644
--- a/include/linux/migrate_mode.h
+++ b/include/linux/migrate_mode.h
@@ -6,11 +6,14 @@
  *	on most operations but not ->writepage as the potential stall time
  *	is too significant
  * MIGRATE_SYNC will block when migrating pages
+ * MIGRATE_FAULT called from the fault path to migrate-on-fault for mempolicy
+ *	this path has an extra reference count
  */
 enum migrate_mode {
 	MIGRATE_ASYNC,
 	MIGRATE_SYNC_LIGHT,
 	MIGRATE_SYNC,
+	MIGRATE_FAULT,
 };
 
 #endif		/* MIGRATE_MODE_H_INCLUDED */
diff --git a/mm/migrate.c b/mm/migrate.c
index 77ed2d7..e03ed0b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -225,7 +225,7 @@ static bool buffer_migrate_lock_buffers(struct buffer_head *head,
 	struct buffer_head *bh = head;
 
 	/* Simple case, sync compaction */
-	if (mode != MIGRATE_ASYNC) {
+	if (mode != MIGRATE_ASYNC && mode != MIGRATE_FAULT) {
 		do {
 			get_bh(bh);
 			lock_buffer(bh);
@@ -279,12 +279,22 @@ static int migrate_page_move_mapping(struct address_space *mapping,
 		struct page *newpage, struct page *page,
 		struct buffer_head *head, enum migrate_mode mode)
 {
-	int expected_count;
+	int expected_count = 0;
 	void **pslot;
 
+	if (mode == MIGRATE_FAULT) {
+		/*
+		 * MIGRATE_FAULT has an extra reference on the page and
+		 * otherwise acts like ASYNC, no point in delaying the
+		 * fault, we'll try again next time.
+		 */
+		expected_count++;
+	}
+
 	if (!mapping) {
 		/* Anonymous page without mapping */
-		if (page_count(page) != 1)
+		expected_count += 1;
+		if (page_count(page) != expected_count)
 			return -EAGAIN;
 		return 0;
 	}
@@ -294,7 +304,7 @@ static int migrate_page_move_mapping(struct address_space *mapping,
 	pslot = radix_tree_lookup_slot(&mapping->page_tree,
  					page_index(page));
 
-	expected_count = 2 + page_has_private(page);
+	expected_count += 2 + page_has_private(page);
 	if (page_count(page) != expected_count ||
 		radix_tree_deref_slot_protected(pslot, &mapping->tree_lock) != page) {
 		spin_unlock_irq(&mapping->tree_lock);
@@ -313,7 +323,7 @@ static int migrate_page_move_mapping(struct address_space *mapping,
 	 * the mapping back due to an elevated page count, we would have to
 	 * block waiting on other references to be dropped.
 	 */
-	if (mode == MIGRATE_ASYNC && head &&
+	if ((mode == MIGRATE_ASYNC || mode == MIGRATE_FAULT) && head &&
 			!buffer_migrate_lock_buffers(head, mode)) {
 		page_unfreeze_refs(page, expected_count);
 		spin_unlock_irq(&mapping->tree_lock);
@@ -521,7 +531,7 @@ int buffer_migrate_page(struct address_space *mapping,
 	 * with an IRQ-safe spinlock held. In the sync case, the buffers
 	 * need to be locked now
 	 */
-	if (mode != MIGRATE_ASYNC)
+	if (mode != MIGRATE_ASYNC && mode != MIGRATE_FAULT)
 		BUG_ON(!buffer_migrate_lock_buffers(head, mode));
 
 	ClearPagePrivate(page);
@@ -687,7 +697,7 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
 	struct anon_vma *anon_vma = NULL;
 
 	if (!trylock_page(page)) {
-		if (!force || mode == MIGRATE_ASYNC)
+		if (!force || mode == MIGRATE_ASYNC || mode == MIGRATE_FAULT)
 			goto out;
 
 		/*
@@ -1403,4 +1413,63 @@ int migrate_vmas(struct mm_struct *mm, const nodemask_t *to,
  	}
  	return err;
 }
-#endif
+
+/*
+ * Attempt to migrate a misplaced page to the specified destination
+ * node.
+ */
+int migrate_misplaced_page(struct mm_struct *mm, struct page *page, int node)
+{
+	struct address_space *mapping = page_mapping(page);
+	int page_lru = page_is_file_cache(page);
+	struct page *newpage;
+	int ret = -EAGAIN;
+	gfp_t gfp = GFP_HIGHUSER_MOVABLE;
+
+	/*
+	 * Don't migrate pages that are mapped in multiple processes.
+	 */
+	if (page_mapcount(page) != 1)
+		goto out;
+
+	/*
+	 * Never wait for allocations just to migrate on fault, but don't dip
+	 * into reserves. And, only accept pages from the specified node. No
+	 * sense migrating to a different "misplaced" page!
+	 */
+	if (mapping)
+		gfp = mapping_gfp_mask(mapping);
+	gfp &= ~__GFP_WAIT;
+	gfp |= __GFP_NOMEMALLOC | GFP_THISNODE;
+
+	newpage = alloc_pages_node(node, gfp, 0);
+	if (!newpage) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (isolate_lru_page(page)) {
+		ret = -EBUSY;
+		goto put_new;
+	}
+
+	inc_zone_page_state(page, NR_ISOLATED_ANON + page_lru);
+	ret = __unmap_and_move(page, newpage, 0, 0, MIGRATE_FAULT);
+	/*
+	 * A page that has been migrated has all references removed and will be
+	 * freed. A page that has not been migrated will have kepts its
+	 * references and be restored.
+	 */
+	dec_zone_page_state(page, NR_ISOLATED_ANON + page_lru);
+	putback_lru_page(page);
+put_new:
+	/*
+	 * Move the new page to the LRU. If migration was not successful
+	 * then this will free the page.
+	 */
+	putback_lru_page(newpage);
+out:
+	return ret;
+}
+
+#endif /* CONFIG_NUMA */
