Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab0G1K1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 06:27:38 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34694 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752Ab0G1K1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 06:27:30 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 9/9] writeback: Prioritise dirty inodes encountered by reclaim for background flushing
Date: Wed, 28 Jul 2010 11:27:23 +0100
Message-Id: <1280312843-11789-10-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280312843-11789-1-git-send-email-mel@csn.ul.ie>
References: <1280312843-11789-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is preferable that as few dirty pages are dispatched for cleaning from
the page reclaim path. When dirty pages are encountered by page reclaim,
this patch marks the inodes that they should be dispatched immediately. When
the background flusher runs, it moves such inodes immediately to the dispatch
queue regardless of inode age.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 fs/fs-writeback.c         |   52 ++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/fs.h        |    5 ++-
 include/linux/writeback.h |    1 +
 mm/vmscan.c               |    6 +++-
 4 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5a3c764..27a8b75 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -221,7 +221,7 @@ static void move_expired_inodes(struct list_head *delaying_queue,
 	LIST_HEAD(tmp);
 	struct list_head *pos, *node;
 	struct super_block *sb = NULL;
-	struct inode *inode;
+	struct inode *inode, *tinode;
 	int do_sb_sort = 0;
 
 	if (wbc->for_kupdate || wbc->for_background) {
@@ -229,6 +229,14 @@ static void move_expired_inodes(struct list_head *delaying_queue,
 		older_than_this = jiffies - expire_interval;
 	}
 
+	/* Move inodes reclaim found at end of LRU to dispatch queue */
+	list_for_each_entry_safe(inode, tinode, delaying_queue, i_list) {
+		if (inode->i_state & I_DIRTY_RECLAIM) {
+			inode->i_state &= ~I_DIRTY_RECLAIM;
+			list_move(&inode->i_list, &tmp);
+		}
+	}
+
 	while (!list_empty(delaying_queue)) {
 		inode = list_entry(delaying_queue->prev, struct inode, i_list);
 		if (expire_interval &&
@@ -906,6 +914,48 @@ void wakeup_flusher_threads(long nr_pages)
 	rcu_read_unlock();
 }
 
+/*
+ * Similar to wakeup_flusher_threads except prioritise inodes contained
+ * in the page_list regardless of age
+ */
+void wakeup_flusher_threads_pages(long nr_pages, struct list_head *page_list)
+{
+	struct page *page;
+	struct address_space *mapping;
+	struct inode *inode;
+
+	list_for_each_entry(page, page_list, lru) {
+		if (!PageDirty(page))
+			continue;
+
+		lock_page(page);
+		mapping = page_mapping(page);
+		if (!mapping || mapping == &swapper_space)
+			goto unlock;
+
+		/*
+		 * Test outside the lock to see as if it is already set, taking
+		 * the inode lock is a waste and the inode should be pinned by
+		 * the lock_page
+		 */
+		inode = page->mapping->host;
+		if (inode->i_state & I_DIRTY_RECLAIM)
+			goto unlock;
+
+		/*
+		 * XXX: Yuck, has to be a way of batching this by not requiring
+		 * 	the page lock to pin the inode
+		 */
+		spin_lock(&inode_lock);
+		inode->i_state |= I_DIRTY_RECLAIM;
+		spin_unlock(&inode_lock);
+unlock:
+		unlock_page(page);
+	}
+
+	wakeup_flusher_threads(nr_pages);
+}
+
 static noinline void block_dump___mark_inode_dirty(struct inode *inode)
 {
 	if (inode->i_ino || strcmp(inode->i_sb->s_id, "bdev")) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e29f0ed..8836698 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1585,8 +1585,8 @@ struct super_operations {
 /*
  * Inode state bits.  Protected by inode_lock.
  *
- * Three bits determine the dirty state of the inode, I_DIRTY_SYNC,
- * I_DIRTY_DATASYNC and I_DIRTY_PAGES.
+ * Four bits determine the dirty state of the inode, I_DIRTY_SYNC,
+ * I_DIRTY_DATASYNC, I_DIRTY_PAGES and I_DIRTY_RECLAIM.
  *
  * Four bits define the lifetime of an inode.  Initially, inodes are I_NEW,
  * until that flag is cleared.  I_WILL_FREE, I_FREEING and I_CLEAR are set at
@@ -1633,6 +1633,7 @@ struct super_operations {
 #define I_DIRTY_SYNC		1
 #define I_DIRTY_DATASYNC	2
 #define I_DIRTY_PAGES		4
+#define I_DIRTY_RECLAIM		256
 #define __I_NEW			3
 #define I_NEW			(1 << __I_NEW)
 #define I_WILL_FREE		16
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 494edd6..73a4df2 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -64,6 +64,7 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
 		struct writeback_control *wbc);
 long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
 void wakeup_flusher_threads(long nr_pages);
+void wakeup_flusher_threads_pages(long nr_pages, struct list_head *page_list);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b66d1f5..bad1abf 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -901,7 +901,8 @@ keep:
 	 * laptop mode avoiding disk spin-ups
 	 */
 	if (file && nr_dirty_seen && sc->may_writepage)
-		wakeup_flusher_threads(nr_writeback_pages(nr_dirty));
+		wakeup_flusher_threads_pages(nr_writeback_pages(nr_dirty),
+					page_list);
 
 	*nr_still_dirty = nr_dirty;
 	count_vm_events(PGACTIVATE, pgactivate);
@@ -1368,7 +1369,8 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
 				list_add(&page->lru, &putback_list);
 			}
 
-			wakeup_flusher_threads(laptop_mode ? 0 : nr_dirty);
+			wakeup_flusher_threads_pages(laptop_mode ? 0 : nr_dirty,
+								&page_list);
 			congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 			/*
-- 
1.7.1

