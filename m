Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab2FMBMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 21:12:19 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36844 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab2FMBLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 21:11:21 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: [PATCH 5/6] [RFC][HACK] tmpfs: Purge volatile ranges on writepage instead of using shrinker
Date: Tue, 12 Jun 2012 18:11:00 -0700
Message-Id: <1339549862-653-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1339549862-653-1-git-send-email-john.stultz@linaro.org>
References: <1339549862-653-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061301-7282-0000-0000-000009DBB4CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid using a shrinker, purge volatile ranges on writepage.
This requires deactivating/activating the page ranges together to
ensure relative LRU behavior in purging the volatile ranges.

This no longer requires the volatile range lru so remove that code.
Also add volatile range infrastructure to find a range that contains
a given page.

NOTE: On systems without swap, the VM won't shrink anonymous memory,
so writepage is never called and volatile ranges won't be purged.
This issue will be addressed in a following patch.

I've only been able to do minimal testing, so there's probably much
still wrong with this patch. But hopefully it will provide a concrete
approach for discussion.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Android Kernel Team <kernel-team@android.com>
CC: Robert Love <rlove@google.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Hugh Dickins <hughd@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Rik van Riel <riel@redhat.com>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Neil Brown <neilb@suse.de>
CC: Andrea Righi <andrea@betterlinux.com>
CC: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
CC: Taras Glek <tgek@mozilla.com>
CC: Mike Hommey <mh@glandium.org>
CC: Jan Kara <jack@suse.cz>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/volatile.h |   11 ++----
 mm/shmem.c               |   90 ++++++++++++++++++++-------------------------
 mm/volatile.c            |   84 +++++++++++--------------------------------
 3 files changed, 64 insertions(+), 121 deletions(-)

diff --git a/include/linux/volatile.h b/include/linux/volatile.h
index 51f3d6e..8edb5c1 100644
--- a/include/linux/volatile.h
+++ b/include/linux/volatile.h
@@ -5,15 +5,11 @@
 
 struct volatile_fs_head {
 	struct mutex lock;
-	struct list_head lru_head;
-	s64 unpurged_page_count;
 };
 
 
 #define DEFINE_VOLATILE_FS_HEAD(name) struct volatile_fs_head name = {	\
 	.lock = __MUTEX_INITIALIZER(name.lock),				\
-	.lru_head = LIST_HEAD_INIT(name.lru_head),			\
-	.unpurged_page_count = 0,					\
 }
 
 
@@ -34,12 +30,11 @@ extern long volatile_range_remove(struct volatile_fs_head *head,
 				struct address_space *mapping,
 				pgoff_t start_index, pgoff_t end_index);
 
-extern s64 volatile_range_lru_size(struct volatile_fs_head *head);
-
 extern void volatile_range_clear(struct volatile_fs_head *head,
 					struct address_space *mapping);
 
-extern s64 volatile_ranges_pluck_lru(struct volatile_fs_head *head,
-				struct address_space **mapping,
+int volatile_page_in_range(struct volatile_fs_head *head,
+				struct page *page,
 				loff_t *start, loff_t *end);
+
 #endif /* _LINUX_VOLATILE_H */
diff --git a/mm/shmem.c b/mm/shmem.c
index 0513816..8dbb8ac 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -629,7 +629,7 @@ static DEFINE_VOLATILE_FS_HEAD(shmem_volatile_head);
 
 static int shmem_mark_volatile(struct inode *inode, loff_t offset, loff_t len)
 {
-	loff_t lstart, lend;
+	loff_t lstart, lend, index;
 	int ret;
 
 	lstart = offset >> PAGE_CACHE_SHIFT;
@@ -643,6 +643,17 @@ static int shmem_mark_volatile(struct inode *inode, loff_t offset, loff_t len)
 					((lend+1)<<PAGE_CACHE_SHIFT)-1);
 		ret = 0;
 	}
+
+	for (index = lstart; index < lend; index++) {
+		struct page *page;
+		int error = shmem_getpage(inode, index, &page, SGP_FALLOC,NULL);
+		if (error)
+			break;
+
+		deactivate_page(page);
+		unlock_page(page);
+		page_cache_release(page);
+	}
 	volatile_range_unlock(&shmem_volatile_head);
 
 	return ret;
@@ -650,7 +661,7 @@ static int shmem_mark_volatile(struct inode *inode, loff_t offset, loff_t len)
 
 static int shmem_unmark_volatile(struct inode *inode, loff_t offset, loff_t len)
 {
-	loff_t lstart, lend;
+	loff_t lstart, lend, index;
 	int ret;
 
 	lstart = offset >> PAGE_CACHE_SHIFT;
@@ -660,6 +671,18 @@ static int shmem_unmark_volatile(struct inode *inode, loff_t offset, loff_t len)
 	ret = volatile_range_remove(&shmem_volatile_head,
 					&inode->i_data,
 					lstart, lend);
+
+	for (index = lstart; index < lend; index++) {
+		struct page *page;
+		int error = shmem_getpage(inode, index, &page, SGP_FALLOC,NULL);
+		if (error)
+			break;
+
+		activate_page(page);
+		unlock_page(page);
+		page_cache_release(page);
+	}
+
 	volatile_range_unlock(&shmem_volatile_head);
 
 	return ret;
@@ -672,54 +695,6 @@ static void shmem_clear_volatile(struct inode *inode)
 	volatile_range_unlock(&shmem_volatile_head);
 }
 
-static
-int shmem_volatile_shrink(struct shrinker *ignored, struct shrink_control *sc)
-{
-	s64 nr_to_scan = sc->nr_to_scan;
-	const gfp_t gfp_mask = sc->gfp_mask;
-	struct address_space *mapping;
-	loff_t start, end;
-	int ret;
-	s64 page_count;
-
-	if (nr_to_scan && !(gfp_mask & __GFP_FS))
-		return -1;
-
-	volatile_range_lock(&shmem_volatile_head);
-	page_count = volatile_range_lru_size(&shmem_volatile_head);
-	if (!nr_to_scan)
-		goto out;
-
-	do {
-		ret = volatile_ranges_pluck_lru(&shmem_volatile_head,
-							&mapping, &start, &end);
-		if (ret) {
-			shmem_truncate_range(mapping->host,
-						start<<PAGE_CACHE_SHIFT,
-						(end<<PAGE_CACHE_SHIFT)-1);
-			nr_to_scan -= end-start;
-			page_count -= end-start;
-		};
-	} while (ret && (nr_to_scan > 0));
-
-out:
-	volatile_range_unlock(&shmem_volatile_head);
-
-	return page_count;
-}
-
-static struct shrinker shmem_volatile_shrinker = {
-	.shrink = shmem_volatile_shrink,
-	.seeks = DEFAULT_SEEKS,
-};
-
-static int __init shmem_shrinker_init(void)
-{
-	register_shrinker(&shmem_volatile_shrinker);
-	return 0;
-}
-arch_initcall(shmem_shrinker_init);
-
 
 static void shmem_evict_inode(struct inode *inode)
 {
@@ -884,14 +859,29 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 	struct inode *inode;
 	swp_entry_t swap;
 	pgoff_t index;
+	loff_t start, end;
 
 	BUG_ON(!PageLocked(page));
 	mapping = page->mapping;
 	index = page->index;
 	inode = mapping->host;
 	info = SHMEM_I(inode);
+
 	if (info->flags & VM_LOCKED)
 		goto redirty;
+
+	volatile_range_lock(&shmem_volatile_head);
+	if (volatile_page_in_range(&shmem_volatile_head, page, &start, &end)) {
+		unlock_page(page);
+		volatile_range_unlock(&shmem_volatile_head);
+		shmem_truncate_range(inode, start<<PAGE_CACHE_SHIFT,
+					(end<<PAGE_CACHE_SHIFT)-1);
+
+		return 0;
+	}
+	volatile_range_unlock(&shmem_volatile_head);
+
+
 	if (!total_swap_pages)
 		goto redirty;
 
diff --git a/mm/volatile.c b/mm/volatile.c
index f822ba2..5d5c2cd 100644
--- a/mm/volatile.c
+++ b/mm/volatile.c
@@ -158,14 +158,6 @@ static inline void vrange_resize(struct volatile_fs_head *head,
 				struct volatile_range *range,
 				pgoff_t start_index, pgoff_t end_index)
 {
-	s64 old_size, new_size;
-
-	old_size = range->interval_node.end - range->interval_node.start;
-	new_size = end_index-start_index;
-
-	if (!range->purged)
-		head->unpurged_page_count += new_size - old_size;
-
 	range->interval_node.start = start_index;
 	range->interval_node.end = end_index;
 }
@@ -185,11 +177,6 @@ static void vrange_del(struct volatile_fs_head *head,
 				struct interval_tree_root *root,
 				struct volatile_range *vrange)
 {
-	if (!vrange->purged) {
-		head->unpurged_page_count -=
-			vrange->interval_node.end - vrange->interval_node.start;
-		list_del(&vrange->lru);
-	}
 	interval_tree_remove(root, &vrange->interval_node);
 	kfree(vrange);
 }
@@ -309,11 +296,6 @@ long volatile_range_add(struct volatile_fs_head *head,
 	new->purged = purged;
 	interval_tree_add(root, &new->interval_node);
 
-	/* Only add unpurged ranges to LRU */
-	if (!purged) {
-		head->unpurged_page_count += end - start;
-		list_add_tail(&new->lru, &head->lru_head);
-	}
 	return purged;
 }
 
@@ -400,8 +382,6 @@ long volatile_range_remove(struct volatile_fs_head *head,
 			new->purged = vrange->purged;
 			vrange_resize(head, vrange, node->start, start-1);
 			interval_tree_add(root, &new->interval_node);
-			if (!new->purged)
-				list_add_tail(&new->lru, &head->lru_head);
 
 			break;
 		}
@@ -414,62 +394,40 @@ out:
 	return ret;
 }
 
-/**
- * volatile_range_lru_size: Returns the number of unpurged pages on the lru
- * @head: per-fs volatile head
- *
- * Returns the number of unpurged pages on the LRU
- *
- * Must lock the volatile_fs_head before calling!
- *
- */
-s64 volatile_range_lru_size(struct volatile_fs_head *head)
-{
-	WARN_ON(!mutex_is_locked(&head->lock));
-	return head->unpurged_page_count;
-}
-
 
-/**
- * volatile_ranges_pluck_lru: Returns mapping and size of lru unpurged range
- * @head: per-fs volatile head
- * @mapping: dbl pointer to mapping who's range is being purged
- * @start: Pointer to starting address of range being purged
- * @end: Pointer to ending address of range being purged
- *
- * Returns the mapping, start and end values of the least recently used
- * range. Marks the range as purged and removes it from the LRU.
- *
- * Must lock the volatile_fs_head before calling!
- *
- * Returns 1 on success if a range was returned
- * Return 0 if no ranges were found.
- */
-s64 volatile_ranges_pluck_lru(struct volatile_fs_head *head,
-				struct address_space **mapping,
+int volatile_page_in_range(struct volatile_fs_head *head,
+				struct page *page,
 				loff_t *start, loff_t *end)
 {
-	struct volatile_range *range;
+	struct interval_tree_root *root;
+	struct interval_tree_node *node;
+	int ret	= 0;
 
 	WARN_ON(!mutex_is_locked(&head->lock));
 
-	if (list_empty(&head->lru_head))
+	root = mapping_to_root(page->mapping);
+	if (!root)
 		return 0;
 
-	range = list_first_entry(&head->lru_head, struct volatile_range, lru);
-
-	*start = range->interval_node.start;
-	*end = range->interval_node.end;
-	*mapping = range->mapping;
+	node = interval_tree_in_interval(root, page->index, page->index);
+	if (node) {
+		struct volatile_range *vrange;
 
-	head->unpurged_page_count -= *end - *start;
-	list_del(&range->lru);
-	range->purged = 1;
+		vrange = container_of(node, struct volatile_range,
+								interval_node);
 
-	return 1;
+		if (!vrange->purged) {
+			*start = vrange->interval_node.start;
+			*end = vrange->interval_node.end;
+			vrange->purged = 1;
+			ret = 1;
+		}
+	}
+	return ret;
 }
 
 
+
 /*
  * Cleans up any volatile ranges.
  */
-- 
1.7.3.2.146.gca209

