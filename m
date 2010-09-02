Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab0IBOfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:35:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59600 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab0IBOfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:35:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=iajex6U+B6uB+/dl51Chm6NXZ3BHC8g7QlC4+3bHz8L7WwRQ4VWPdO86WbNtJNHwAi
         aYPYJ0wlBOcPtSG+l3jYaAPS2gQ1fl8jkIAW65OmBQhOpRWJRleljPaMK2fze2jNdfUC
         8ILf/xl8kBpw9oWUbTCiphF2rhIvLACKJdug8=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Hugh Dickins <hughd@google.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [RESEND PATCH v2] compaction: fix COMPACTPAGEFAILED counting
Date: Thu,  2 Sep 2010 23:34:47 +0900
Message-Id: <1283438087-11842-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now update_nr_listpages doesn't have a role. That's because
lists passed is always empty just after calling migrate_pages.
The migrate_pages cleans up page list which have failed to migrate
before returning by aaa994b3.

 [PATCH] page migration: handle freeing of pages in migrate_pages()

 Do not leave pages on the lists passed to migrate_pages().  Seems that we will
 not need any postprocessing of pages.  This will simplify the handling of
 pages by the callers of migrate_pages().

At that time, we thought we don't need any postprocessing of pages.
But the situation is changed. The compaction need to know the number of
failed to migrate for COMPACTPAGEFAILED stat

This patch makes new rule for caller of migrate_pages to call putback_lru_pages.
So caller need to clean up the lists so it has a chance to postprocess the pages.
[suggested by Christoph Lameter]

Cc: Hugh Dickins <hughd@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Reviewed-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/memory-failure.c |    1 +
 mm/memory_hotplug.c |    2 ++
 mm/mempolicy.c      |   10 ++++++++--
 mm/migrate.c        |   12 +++++++-----
 4 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 9c26eec..5267861 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1339,6 +1339,7 @@ int soft_offline_page(struct page *page, int flags)
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0);
 		if (ret) {
+			putback_lru_pages(&pagelist);
 			pr_debug("soft offline: %#lx: migration failed %d, type %lx\n",
 				pfn, ret, page->flags);
 			if (ret > 0)
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a4cfcdc..2638079 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -731,6 +731,8 @@ do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		goto out;
 	/* this function returns # of failed pages */
 	ret = migrate_pages(&source, hotremove_migrate_alloc, 0, 1);
+	if (ret)
+		putback_lru_pages(&source);
 
 out:
 	return ret;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index f969da5..21243b2 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -931,8 +931,11 @@ static int migrate_to_node(struct mm_struct *mm, int source, int dest,
 	check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
 
-	if (!list_empty(&pagelist))
+	if (!list_empty(&pagelist)) {
 		err = migrate_pages(&pagelist, new_node_page, dest, 0);
+		if (err)
+			putback_lru_pages(&pagelist);
+	}
 
 	return err;
 }
@@ -1147,9 +1150,12 @@ static long do_mbind(unsigned long start, unsigned long len,
 
 		err = mbind_range(mm, start, end, new);
 
-		if (!list_empty(&pagelist))
+		if (!list_empty(&pagelist)) {
 			nr_failed = migrate_pages(&pagelist, new_vma_page,
 						(unsigned long)vma, 0);
+			if (nr_failed)
+				putback_lru_pages(&pagelist);
+		}
 
 		if (!err && nr_failed && (flags & MPOL_MF_STRICT))
 			err = -EIO;
diff --git a/mm/migrate.c b/mm/migrate.c
index 38e7cad..ed38c22 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -732,8 +732,9 @@ move_newpage:
  *
  * The function returns after 10 attempts or if no pages
  * are movable anymore because to has become empty
- * or no retryable pages exist anymore. All pages will be
- * returned to the LRU or freed.
+ * or no retryable pages exist anymore.
+ * Caller should call putback_lru_pages to return pages to the LRU
+ * or free list.
  *
  * Return: Number of pages not migrated or error code.
  */
@@ -780,8 +781,6 @@ out:
 	if (!swapwrite)
 		current->flags &= ~PF_SWAPWRITE;
 
-	putback_lru_pages(from);
-
 	if (rc)
 		return rc;
 
@@ -890,9 +889,12 @@ set_status:
 	}
 
 	err = 0;
-	if (!list_empty(&pagelist))
+	if (!list_empty(&pagelist)) {
 		err = migrate_pages(&pagelist, new_page_node,
 				(unsigned long)pm, 0);
+		if (err)
+			putback_lru_pages(&pagelist);
+	}
 
 	up_read(&mm->mmap_sem);
 	return err;
-- 
1.7.0.5

