Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945952Ab2ERK2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:28:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42323 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161131Ab2ERK1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:27:48 -0400
Date: Fri, 18 May 2012 03:27:16 -0700
From: tip-bot for Lee Schermerhorn <lee.schermerhorn@hp.com>
Message-ID: <tip-15jgtv7g5i9emxs6jz0gapab@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        lee.schermerhorn@hp.com, cl@linux.com, riel@redhat.com,
        akpm@linux-foundation.org, bharata.rao@gmail.com, aarcange@redhat.com,
        suresh.b.siddha@intel.com, danms@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        lee.schermerhorn@hp.com, cl@linux.com, riel@redhat.com,
        bharata.rao@gmail.com, akpm@linux-foundation.org, aarcange@redhat.com,
        danms@us.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm: Handle misplaced anon pages
Git-Commit-ID: 65699050e8aae41078c9c73f61f6fae26e07e461
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:27:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  65699050e8aae41078c9c73f61f6fae26e07e461
Gitweb:     http://git.kernel.org/tip/65699050e8aae41078c9c73f61f6fae26e07e461
Author:     Lee Schermerhorn <lee.schermerhorn@hp.com>
AuthorDate: Thu, 12 Jan 2012 12:05:17 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:18 +0200

mm: Handle misplaced anon pages

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
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-15jgtv7g5i9emxs6jz0gapab@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/swap.h |    4 +++-
 mm/memory.c          |   17 +++++++++++++++++
 mm/swapfile.c        |   13 +++++++++++++
 3 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index b1fd5c7..0c23738 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -352,6 +352,7 @@ extern unsigned int count_swap_pages(int, int);
 extern sector_t map_swap_page(struct page *, struct block_device **);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int reuse_swap_page(struct page *);
+extern int can_reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
 
@@ -462,7 +463,8 @@ static inline void delete_from_swap_cache(struct page *page)
 {
 }
 
-#define reuse_swap_page(page)	(page_mapcount(page) == 1)
+#define reuse_swap_page(page)		(page_mapcount(page) == 1)
+#define can_reuse_swap_page(page)	(page_mapcount(page) == 1)
 
 static inline int try_to_free_swap(struct page *page)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 6105f47..08a3489 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -57,6 +57,7 @@
 #include <linux/swapops.h>
 #include <linux/elf.h>
 #include <linux/gfp.h>
+#include <linux/mempolicy.h>	/* check_migrate_misplaced_page() */
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -2974,6 +2975,22 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
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
diff --git a/mm/swapfile.c b/mm/swapfile.c
index fafc26d..c5952c0 100644
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
