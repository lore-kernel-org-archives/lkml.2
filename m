Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967983Ab2ERKYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:24:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42249 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967636Ab2ERKY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:24:28 -0400
Date: Fri, 18 May 2012 03:23:56 -0700
From: tip-bot for Lee Schermerhorn <lee.schermerhorn@hp.com>
Message-ID: <tip-5rdttprpo6sj2isc87kns4uc@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        aarcange@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@zytor.com, linux-kernel@vger.kernel.org, pjt@google.com,
        lee.schermerhorn@hp.com, bharata.rao@gmail.com,
        Lee.Schermerhorn@hp.com, danms@us.ibm.com
Reply-To: mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, cl@linux.com, riel@redhat.com,
        akpm@linux-foundation.org, aarcange@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, pjt@google.com, lee.schermerhorn@hp.com,
        bharata.rao@gmail.com, Lee.Schermerhorn@hp.com, danms@us.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm/mpol: Add MPOL_MF_LAZY ...
Git-Commit-ID: 68d9661d42bf59830ae4ebae9e26d7ec6d288519
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:24:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68d9661d42bf59830ae4ebae9e26d7ec6d288519
Gitweb:     http://git.kernel.org/tip/68d9661d42bf59830ae4ebae9e26d7ec6d288519
Author:     Lee Schermerhorn <lee.schermerhorn@hp.com>
AuthorDate: Thu, 12 Jan 2012 12:37:17 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:13 +0200

mm/mpol: Add MPOL_MF_LAZY ...

This patch adds another mbind() flag to request "lazy migration".
The flag, MPOL_MF_LAZY, modifies MPOL_MF_MOVE* such that the selected
pages are simply unmapped from the calling task's page table ['_MOVE]
or from all referencing page tables [_MOVE_ALL].  Anon pages will first
be added to the swap [or migration?] cache, if necessary.  The pages
will be migrated in the fault path on "first touch", if the policy
dictates at that time.

"Lazy Migration" will allow testing of migrate-on-fault via mbind().
Also allows applications to specify that only subsequently touched
pages be migrated to obey new policy, instead of all pages in range.
This can be useful for multi-threaded applications working on a
large shared data area that is initialized by an initial thread
resulting in all pages on one [or a few, if overflowed] nodes.
After unmap, the pages in regions assigned to the worker threads
will be automatically migrated local to the threads on 1st touch.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-5rdttprpo6sj2isc87kns4uc@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mempolicy.h |   13 +++++-
 include/linux/migrate.h   |    7 +++
 include/linux/rmap.h      |    5 +-
 mm/mempolicy.c            |   20 ++++++----
 mm/migrate.c              |   96 ++++++++++++++++++++++++++++++++++++++++++++-
 mm/rmap.c                 |    6 +-
 6 files changed, 129 insertions(+), 18 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index a51e5db..801ad50 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -48,9 +48,16 @@ enum mpol_rebind_step {
 
 /* Flags for mbind */
 #define MPOL_MF_STRICT	(1<<0)	/* Verify existing pages in the mapping */
-#define MPOL_MF_MOVE	(1<<1)	/* Move pages owned by this process to conform to mapping */
-#define MPOL_MF_MOVE_ALL (1<<2)	/* Move every page to conform to mapping */
-#define MPOL_MF_INTERNAL (1<<3)	/* Internal flags start here */
+#define MPOL_MF_MOVE	 (1<<1)	/* Move pages owned by this process to conform
+				   to policy */
+#define MPOL_MF_MOVE_ALL (1<<2)	/* Move every page to conform to policy */
+#define MPOL_MF_LAZY	 (1<<3)	/* Modifies '_MOVE:  lazy migrate on fault */
+#define MPOL_MF_INTERNAL (1<<4)	/* Internal flags start here */
+
+#define MPOL_MF_VALID	(MPOL_MF_STRICT   | 	\
+			 MPOL_MF_MOVE     | 	\
+			 MPOL_MF_MOVE_ALL |	\
+			 MPOL_MF_LAZY)
 
 /*
  * Internal flags that share the struct mempolicy flags word with
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 855c337..9e00dc9 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -30,6 +30,8 @@ extern int migrate_vmas(struct mm_struct *mm,
 extern void migrate_page_copy(struct page *newpage, struct page *page);
 extern int migrate_huge_page_move_mapping(struct address_space *mapping,
 				  struct page *newpage, struct page *page);
+
+extern int migrate_pages_unmap_only(struct list_head *);
 #else
 
 static inline void putback_lru_pages(struct list_head *l) {}
@@ -59,6 +61,11 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 	return -ENOSYS;
 }
 
+static inline int migrate_pages_unmap_only(struct list_head *l)
+{
+	return -ENOSYS;
+}
+
 /* Possible settings for the migrate_page() method in address_operations */
 #define migrate_page NULL
 #define fail_migrate_page NULL
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index fd07c45..969d232 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -163,8 +163,9 @@ int page_referenced_one(struct page *, struct vm_area_struct *,
 
 enum ttu_flags {
 	TTU_UNMAP = 0,			/* unmap mode */
-	TTU_MIGRATION = 1,		/* migration mode */
-	TTU_MUNLOCK = 2,		/* munlock mode */
+	TTU_MIGRATE_DIRECT = 1,		/* direct migration mode */
+	TTU_MIGRATE_DEFERRED = 2,	/* deferred [lazy] migration mode */
+	TTU_MUNLOCK = 4,		/* munlock mode */
 	TTU_ACTION_MASK = 0xff,
 
 	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index a7516db..f261c52 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1048,8 +1048,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 	int err;
 	LIST_HEAD(pagelist);
 
-	if (flags & ~(unsigned long)(MPOL_MF_STRICT |
-				     MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
+  	if (flags & ~(unsigned long)MPOL_MF_VALID)
 		return -EINVAL;
 	if ((flags & MPOL_MF_MOVE_ALL) && !capable(CAP_SYS_NICE))
 		return -EPERM;
@@ -1108,21 +1107,26 @@ static long do_mbind(unsigned long start, unsigned long len,
 	vma = check_range(mm, start, end, nmask,
 			  flags | MPOL_MF_INVERT, &pagelist);
 
-	err = PTR_ERR(vma);
-	if (!IS_ERR(vma)) {
-		int nr_failed = 0;
-
+	err = PTR_ERR(vma);	/* maybe ... */
+	if (!IS_ERR(vma))
 		err = mbind_range(mm, start, end, new);
 
+	if (!err) {
+		int nr_failed = 0;
+
 		if (!list_empty(&pagelist)) {
-			nr_failed = migrate_pages(&pagelist, new_vma_page,
+			if (flags & MPOL_MF_LAZY)
+				nr_failed = migrate_pages_unmap_only(&pagelist);
+			else {
+				nr_failed = migrate_pages(&pagelist, new_vma_page,
 						(unsigned long)vma,
 						false, true);
+			}
 			if (nr_failed)
 				putback_lru_pages(&pagelist);
 		}
 
-		if (!err && nr_failed && (flags & MPOL_MF_STRICT))
+		if (nr_failed && (flags & MPOL_MF_STRICT))
 			err = -EIO;
 	} else
 		putback_lru_pages(&pagelist);
diff --git a/mm/migrate.c b/mm/migrate.c
index 1107238..45ad2b3 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -802,7 +802,7 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
 	}
 
 	/* Establish migration ptes or remove ptes */
-	try_to_unmap(page, TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
+	try_to_unmap(page, TTU_MIGRATE_DIRECT|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
 
 skip_unmap:
 	if (!page_mapped(page))
@@ -918,7 +918,7 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 	if (PageAnon(hpage))
 		anon_vma = page_get_anon_vma(hpage);
 
-	try_to_unmap(hpage, TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
+	try_to_unmap(hpage, TTU_MIGRATE_DIRECT|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
 
 	if (!page_mapped(hpage))
 		rc = move_to_new_page(new_hpage, hpage, 1, mode);
@@ -948,6 +948,98 @@ out:
 }
 
 /*
+ * Lazy migration:  just unmap pages, moving anon pages to swap cache, if
+ * necessary.  Migration will occur, if policy dictates, when a task faults
+ * an unmapped page back into its page table--i.e., on "first touch" after
+ * unmapping.  Note that migrate-on-fault only migrates pages whose mapping
+ * [e.g., file system] supplies a migratepage op, so we skip pages that
+ * wouldn't migrate on fault.
+ *
+ * Pages are placed back on the lru whether or not they were successfully
+ * unmapped.  Like migrate_pages().
+ *
+ * Unline migrate_pages(), this function is only called in the context of
+ * a task that is unmapping it's own pages while holding its map semaphore
+ * for write.
+ */
+int migrate_pages_unmap_only(struct list_head *pagelist)
+{
+	struct page *page;
+	struct page *page2;
+	int nr_failed = 0;
+	int nr_unmapped = 0;
+
+	list_for_each_entry_safe(page, page2, pagelist, lru) {
+		int ret;
+
+		cond_resched();
+
+		/*
+		 * Give up easily.  We ARE being lazy.
+		 */
+		if (page_count(page) == 1)
+			goto next;
+
+		if (unlikely(PageTransHuge(page)))
+			if (unlikely(split_huge_page(page)))
+				goto next;
+
+		if (!trylock_page(page))
+			goto next;
+
+		if (PageKsm(page) || PageWriteback(page))
+			goto unlock;
+
+		/*
+		 * see comments in unmap_and_move()
+		 */
+		if (!page->mapping)
+			goto unlock;
+
+		if (PageAnon(page)) {
+			if (!PageSwapCache(page) && !add_to_swap(page)) {
+				nr_failed++;
+				goto unlock;
+			}
+		} else {
+			struct address_space *mapping = page_mapping(page);
+			BUG_ON(!mapping);
+			if (!mapping->a_ops->migratepage)
+				goto unlock;
+		}
+
+		ret = try_to_unmap(page,
+	             TTU_MIGRATE_DEFERRED|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
+		if (ret != SWAP_SUCCESS || page_mapped(page))
+			nr_failed++;
+		else
+			nr_unmapped++;
+
+unlock:
+		unlock_page(page);
+next:
+		list_del(&page->lru);
+		dec_zone_page_state(page, NR_ISOLATED_ANON +
+				page_is_file_cache(page));
+		putback_lru_page(page);
+
+	}
+
+	/*
+	 * Drain local per cpu pagevecs so fault path can find the the pages
+	 * on the lru.  If we got migrated during the loop above, we may
+	 * have left pages cached on other cpus.  But, we'll live with that
+	 * here to avoid lru_add_drain_all().
+	 * TODO:  mechanism to drain on only those cpus we've been
+	 *        scheduled on between two points--e.g., during the loop.
+	 */
+	if (nr_unmapped)
+		lru_add_drain();
+
+	return nr_failed;
+}
+
+/*
  * migrate_pages
  *
  * The function takes one list of pages to migrate and a function
diff --git a/mm/rmap.c b/mm/rmap.c
index 5b5ad58..b10f2f9 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1305,13 +1305,13 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 			 * pte. do_swap_page() will wait until the migration
 			 * pte is removed and then restart fault handling.
 			 */
-			BUG_ON(TTU_ACTION(flags) != TTU_MIGRATION);
+			BUG_ON(TTU_ACTION(flags) != TTU_MIGRATE_DIRECT);
 			entry = make_migration_entry(page, pte_write(pteval));
 		}
 		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
 		BUG_ON(pte_file(*pte));
 	} else if (IS_ENABLED(CONFIG_MIGRATION) &&
-		   (TTU_ACTION(flags) == TTU_MIGRATION)) {
+		   (TTU_ACTION(flags) == TTU_MIGRATE_DIRECT)) {
 		/* Establish migration entry for a file page */
 		swp_entry_t entry;
 		entry = make_migration_entry(page, pte_write(pteval));
@@ -1517,7 +1517,7 @@ static int try_to_unmap_anon(struct page *page, enum ttu_flags flags)
 		 * locking requirements of exec(), migration skips
 		 * temporary VMAs until after exec() completes.
 		 */
-		if (IS_ENABLED(CONFIG_MIGRATION) && (flags & TTU_MIGRATION) &&
+		if (IS_ENABLED(CONFIG_MIGRATION) && (flags & TTU_MIGRATE_DIRECT) &&
 				is_vma_temporary_stack(vma))
 			continue;
 
