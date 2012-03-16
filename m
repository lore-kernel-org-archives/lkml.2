Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032842Ab2CPOxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:53:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45539 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422856Ab2CPOxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:53:30 -0400
Message-Id: <20120316144240.556223451@chello.nl>
User-Agent: quilt/0.48-1
Date: Fri, 16 Mar 2012 15:40:35 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 07/26] mm: Handle misplaced anon pages
References: <20120316144028.036474157@chello.nl>
Content-Disposition: inline; filename=migrate-on-fault-05.1-misplaced-anon-pages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

This patch simply hooks the anon page fault handler [do_swap_page()]
to check for and migrate misplaced pages if enabled and page won't
be "COWed".

This introduces can_reuse_swap_page() since reuse_swap_page() does
delete_from_swap_cache() which messes our migration path (since that
assumes its still a swapcache page).

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
[ removed the retry loops after lock_page on a swapcache which tried
  to fixup the wreckage caused by ignoring the page count on migate;
  added can_reuse_swap_page(); moved the migrate-on-fault enabled
  test into check_migrate_misplaced_page() ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/swap.h |    4 +++-
 mm/memory.c          |   17 +++++++++++++++++
 mm/swapfile.c        |   13 +++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -342,6 +342,7 @@ extern unsigned int count_swap_pages(int
 extern sector_t map_swap_page(struct page *, struct block_device **);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int reuse_swap_page(struct page *);
+extern int can_reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
 
@@ -459,7 +460,8 @@ static inline void delete_from_swap_cach
 {
 }
 
-#define reuse_swap_page(page)	(page_mapcount(page) == 1)
+#define reuse_swap_page(page)		(page_mapcount(page) == 1)
+#define can_reuse_swap_page(page)	(page_mapcount(page) == 1)
 
 static inline int try_to_free_swap(struct page *page)
 {
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -57,6 +57,7 @@
 #include <linux/swapops.h>
 #include <linux/elf.h>
 #include <linux/gfp.h>
+#include <linux/mempolicy.h>	/* check_migrate_misplaced_page() */
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -2962,6 +2963,22 @@ static int do_swap_page(struct mm_struct
 	}
 
 	/*
+	 * No sense in migrating a page that will be "COWed" as the new
+	 * new page will be allocated according to effective mempolicy.
+	 */
+	if ((flags & FAULT_FLAG_WRITE) && can_reuse_swap_page(page)) {
+		/*
+		 * check for misplacement and migrate, if necessary/possible,
+		 * here and now.  Note that if we're racing with another thread,
+		 * we may end up discarding the migrated page after locking
+		 * the page table and checking the pte below.  However, we
+		 * don't want to hold the page table locked over migration, so
+		 * we'll live with that [unlikely, one hopes] possibility.
+		 */
+		page = check_migrate_misplaced_page(page, vma, address);
+	}
+
+	/*
 	 * Back out if somebody else already faulted in this pte.
 	 */
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -640,6 +640,19 @@ int reuse_swap_page(struct page *page)
 	return count <= 1;
 }
 
+int can_reuse_swap_page(struct page *page)
+{
+	int count;
+
+	VM_BUG_ON(!PageLocked(page));
+	if (unlikely(PageKsm(page)))
+		return 0;
+	count = page_mapcount(page);
+	if (count <= 1 && PageSwapCache(page))
+		count += page_swapcount(page);
+	return count <= 1;
+}
+
 /*
  * If swap is getting full, or if there are no more mappings of this page,
  * then try_to_free_swap is called to free its swap space.


