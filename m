Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab1CVLX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:23:56 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:23860 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755400Ab1CVLXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:23:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkEAK8jiE15LK5JgWdsb2JhbAClQxUBARYmJcQUgn4BgmUEkmc
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/8] fs: protect inode->i_state with inode->i_lock
Date: Tue, 22 Mar 2011 22:23:36 +1100
Message-Id: <1300793023-3775-2-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1300793023-3775-1-git-send-email-david@fromorbit.com>
References: <1300793023-3775-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Protect inode state transitions and validity checks with the
inode->i_lock. This enables us to make inode state transitions
independently of the inode_lock and is the first step to peeling
away the inode_lock from the code.

This requires that __iget() is done atomically with i_state checks
during list traversals so that we don't race with another thread
marking the inode I_FREEING between the state check and grabbing the
reference.

Also remove the unlock_new_inode() memory barrier optimisation
required to avoid taking the inode_lock when clearing I_NEW.
Simplify the code by simply taking the inode->i_lock around the
state change and wakeup. Because the wakeup is no longer tricky,
remove the wake_up_inode() function and open code the wakeup where
necessary.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/block_dev.c           |    2 +
 fs/buffer.c              |    2 +-
 fs/drop_caches.c         |    9 ++-
 fs/fs-writeback.c        |   44 ++++++++++---
 fs/inode.c               |  150 ++++++++++++++++++++++++++++++++--------------
 fs/notify/inode_mark.c   |   21 +++++--
 fs/quota/dquot.c         |   13 ++--
 include/linux/fs.h       |    2 +-
 include/linux/quotaops.h |    2 +-
 mm/filemap.c             |    2 +
 mm/rmap.c                |    1 +
 11 files changed, 174 insertions(+), 74 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 8892870..bc39b18 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -56,9 +56,11 @@ static void bdev_inode_switch_bdi(struct inode *inode,
 			struct backing_dev_info *dst)
 {
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	inode->i_data.backing_dev_info = dst;
 	if (inode->i_state & I_DIRTY)
 		list_move(&inode->i_wb_list, &dst->wb.b_dirty);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
 
diff --git a/fs/buffer.c b/fs/buffer.c
index 2219a76..da666f3 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1144,7 +1144,7 @@ __getblk_slow(struct block_device *bdev, sector_t block, int size)
  * inode list.
  *
  * mark_buffer_dirty() is atomic.  It takes bh->b_page->mapping->private_lock,
- * mapping->tree_lock and the global inode_lock.
+ * mapping->tree_lock and mapping->host->i_lock.
  */
 void mark_buffer_dirty(struct buffer_head *bh)
 {
diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 2195c21..62dd8ee 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -18,11 +18,14 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
-			continue;
-		if (inode->i_mapping->nrpages == 0)
+		spin_lock(&inode->i_lock);
+		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+		    (inode->i_mapping->nrpages == 0)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 59c6e49..efd1ebe 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -306,10 +306,12 @@ static void inode_wait_for_writeback(struct inode *inode)
 	wait_queue_head_t *wqh;
 
 	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
-	 while (inode->i_state & I_SYNC) {
+	while (inode->i_state & I_SYNC) {
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
 		spin_lock(&inode_lock);
+		spin_lock(&inode->i_lock);
 	}
 }
 
@@ -333,6 +335,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	unsigned dirty;
 	int ret;
 
+	spin_lock(&inode->i_lock);
 	if (!atomic_read(&inode->i_count))
 		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
 	else
@@ -348,6 +351,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 		 * completed a full scan of b_io.
 		 */
 		if (wbc->sync_mode != WB_SYNC_ALL) {
+			spin_unlock(&inode->i_lock);
 			requeue_io(inode);
 			return 0;
 		}
@@ -363,6 +367,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	/* Set I_SYNC, reset I_DIRTY_PAGES */
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY_PAGES;
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 
 	ret = do_writepages(mapping, wbc);
@@ -384,8 +389,10 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	 * write_inode()
 	 */
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	dirty = inode->i_state & I_DIRTY;
 	inode->i_state &= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
 	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
@@ -395,6 +402,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	}
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
 		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
@@ -436,6 +444,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 		}
 	}
 	inode_sync_complete(inode);
+	spin_unlock(&inode->i_lock);
 	return ret;
 }
 
@@ -506,7 +515,9 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 		 * kind does not need peridic writeout yet, and for the latter
 		 * kind writeout is handled by the freer.
 		 */
+		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
+			spin_unlock(&inode->i_lock);
 			requeue_io(inode);
 			continue;
 		}
@@ -515,10 +526,14 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 		 * Was this inode dirtied after sync_sb_inodes was called?
 		 * This keeps sync from extra jobs and livelock.
 		 */
-		if (inode_dirtied_after(inode, wbc->wb_start))
+		if (inode_dirtied_after(inode, wbc->wb_start)) {
+			spin_unlock(&inode->i_lock);
 			return 1;
+		}
 
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
+
 		pages_skipped = wbc->pages_skipped;
 		writeback_single_inode(inode, wbc);
 		if (wbc->pages_skipped != pages_skipped) {
@@ -724,7 +739,9 @@ static long wb_writeback(struct bdi_writeback *wb,
 		if (!list_empty(&wb->b_more_io))  {
 			inode = wb_inode(wb->b_more_io.prev);
 			trace_wbc_writeback_wait(&wbc, wb->bdi);
+			spin_lock(&inode->i_lock);
 			inode_wait_for_writeback(inode);
+			spin_unlock(&inode->i_lock);
 		}
 		spin_unlock(&inode_lock);
 	}
@@ -1017,6 +1034,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		block_dump___mark_inode_dirty(inode);
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	if ((inode->i_state & flags) != flags) {
 		const int was_dirty = inode->i_state & I_DIRTY;
 
@@ -1028,7 +1046,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 * superblock list, based upon its state.
 		 */
 		if (inode->i_state & I_SYNC)
-			goto out;
+			goto out_unlock_inode;
 
 		/*
 		 * Only add valid (hashed) inodes to the superblock's
@@ -1036,11 +1054,12 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 */
 		if (!S_ISBLK(inode->i_mode)) {
 			if (inode_unhashed(inode))
-				goto out;
+				goto out_unlock_inode;
 		}
 		if (inode->i_state & I_FREEING)
-			goto out;
+			goto out_unlock_inode;
 
+		spin_unlock(&inode->i_lock);
 		/*
 		 * If the inode was already on b_dirty/b_io/b_more_io, don't
 		 * reposition it (that would break b_dirty time-ordering).
@@ -1065,7 +1084,10 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
 		}
+		goto out;
 	}
+out_unlock_inode:
+	spin_unlock(&inode->i_lock);
 out:
 	spin_unlock(&inode_lock);
 
@@ -1111,14 +1133,16 @@ static void wait_sb_inodes(struct super_block *sb)
 	 * we still have to wait for that writeout.
 	 */
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		struct address_space *mapping;
+		struct address_space *mapping = inode->i_mapping;
 
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
-			continue;
-		mapping = inode->i_mapping;
-		if (mapping->nrpages == 0)
+		spin_lock(&inode->i_lock);
+		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+		    (mapping->nrpages == 0)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		/*
 		 * We hold a reference to 'inode' so it couldn't have
diff --git a/fs/inode.c b/fs/inode.c
index 16fefd3..bd5a237 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -27,6 +27,17 @@
 #include <linux/ima.h>
 
 /*
+ * inode locking rules.
+ *
+ * inode->i_lock protects:
+ *   inode->i_state, inode->i_hash, __iget()
+ *
+ * Lock ordering:
+ * inode_lock
+ *   inode->i_lock
+ */
+
+/*
  * This is needed for the following functions:
  *  - inode_has_buffers
  *  - invalidate_bdev
@@ -136,15 +147,6 @@ int proc_nr_inodes(ctl_table *table, int write,
 }
 #endif
 
-static void wake_up_inode(struct inode *inode)
-{
-	/*
-	 * Prevent speculative execution through spin_unlock(&inode_lock);
-	 */
-	smp_mb();
-	wake_up_bit(&inode->i_state, __I_NEW);
-}
-
 /**
  * inode_init_always - perform inode structure intialisation
  * @sb: superblock inode belongs to
@@ -335,7 +337,7 @@ static void init_once(void *foo)
 }
 
 /*
- * inode_lock must be held
+ * inode->i_lock must be held
  */
 void __iget(struct inode *inode)
 {
@@ -412,7 +414,9 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 	struct hlist_head *b = inode_hashtable + hash(inode->i_sb, hashval);
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	hlist_add_head(&inode->i_hash, b);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
@@ -437,7 +441,9 @@ static void __remove_inode_hash(struct inode *inode)
 void remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(remove_inode_hash);
@@ -494,7 +500,9 @@ static void dispose_list(struct list_head *head)
 		__inode_sb_list_del(inode);
 		spin_unlock(&inode_lock);
 
-		wake_up_inode(inode);
+		spin_lock(&inode->i_lock);
+		wake_up_bit(&inode->i_state, __I_NEW);
+		spin_unlock(&inode->i_lock);
 		destroy_inode(inode);
 	}
 }
@@ -517,10 +525,17 @@ void evict_inodes(struct super_block *sb)
 	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
 		if (atomic_read(&inode->i_count))
 			continue;
-		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE))
+
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 
 		inode->i_state |= I_FREEING;
+		if (!(inode->i_state & (I_DIRTY | I_SYNC)))
+			inodes_stat.nr_unused--;
+		spin_unlock(&inode->i_lock);
 
 		/*
 		 * Move the inode off the IO lists and LRU once I_FREEING is
@@ -528,8 +543,6 @@ void evict_inodes(struct super_block *sb)
 		 */
 		list_move(&inode->i_lru, &dispose);
 		list_del_init(&inode->i_wb_list);
-		if (!(inode->i_state & (I_DIRTY | I_SYNC)))
-			inodes_stat.nr_unused--;
 	}
 	spin_unlock(&inode_lock);
 
@@ -562,18 +575,26 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 
 	spin_lock(&inode_lock);
 	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE))
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 		if (inode->i_state & I_DIRTY && !kill_dirty) {
+			spin_unlock(&inode->i_lock);
 			busy = 1;
 			continue;
 		}
 		if (atomic_read(&inode->i_count)) {
+			spin_unlock(&inode->i_lock);
 			busy = 1;
 			continue;
 		}
 
 		inode->i_state |= I_FREEING;
+		if (!(inode->i_state & (I_DIRTY | I_SYNC)))
+			inodes_stat.nr_unused--;
+		spin_unlock(&inode->i_lock);
 
 		/*
 		 * Move the inode off the IO lists and LRU once I_FREEING is
@@ -581,8 +602,6 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 		 */
 		list_move(&inode->i_lru, &dispose);
 		list_del_init(&inode->i_wb_list);
-		if (!(inode->i_state & (I_DIRTY | I_SYNC)))
-			inodes_stat.nr_unused--;
 	}
 	spin_unlock(&inode_lock);
 
@@ -640,8 +659,10 @@ static void prune_icache(int nr_to_scan)
 		 * Referenced or dirty inodes are still in use. Give them
 		 * another pass through the LRU as we canot reclaim them now.
 		 */
+		spin_lock(&inode->i_lock);
 		if (atomic_read(&inode->i_count) ||
 		    (inode->i_state & ~I_REFERENCED)) {
+			spin_unlock(&inode->i_lock);
 			list_del_init(&inode->i_lru);
 			inodes_stat.nr_unused--;
 			continue;
@@ -649,12 +670,14 @@ static void prune_icache(int nr_to_scan)
 
 		/* recently referenced inodes get one more pass */
 		if (inode->i_state & I_REFERENCED) {
-			list_move(&inode->i_lru, &inode_lru);
 			inode->i_state &= ~I_REFERENCED;
+			spin_unlock(&inode->i_lock);
+			list_move(&inode->i_lru, &inode_lru);
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
 			__iget(inode);
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
@@ -665,11 +688,15 @@ static void prune_icache(int nr_to_scan)
 			if (inode != list_entry(inode_lru.next,
 						struct inode, i_lru))
 				continue;	/* wrong inode or list_empty */
-			if (!can_unuse(inode))
+			spin_lock(&inode->i_lock);
+			if (!can_unuse(inode)) {
+				spin_unlock(&inode->i_lock);
 				continue;
+			}
 		}
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
+		spin_unlock(&inode->i_lock);
 
 		/*
 		 * Move the inode off the IO lists and LRU once I_FREEING is
@@ -736,11 +763,13 @@ repeat:
 			continue;
 		if (!test(inode, data))
 			continue;
+		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		return inode;
 	}
 	return NULL;
@@ -762,11 +791,13 @@ repeat:
 			continue;
 		if (inode->i_sb != sb)
 			continue;
+		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		return inode;
 	}
 	return NULL;
@@ -831,14 +862,23 @@ struct inode *new_inode(struct super_block *sb)
 	inode = alloc_inode(sb);
 	if (inode) {
 		spin_lock(&inode_lock);
-		__inode_sb_list_add(inode);
+		spin_lock(&inode->i_lock);
 		inode->i_state = 0;
+		spin_unlock(&inode->i_lock);
+		__inode_sb_list_add(inode);
 		spin_unlock(&inode_lock);
 	}
 	return inode;
 }
 EXPORT_SYMBOL(new_inode);
 
+/**
+ * unlock_new_inode - clear the I_NEW state and wake up any waiters
+ * @inode:	new inode to unlock
+ *
+ * Called when the inode is fully initialised to clear the new state of the
+ * inode and wake up anyone waiting for the inode to finish initialisation.
+ */
 void unlock_new_inode(struct inode *inode)
 {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -858,19 +898,11 @@ void unlock_new_inode(struct inode *inode)
 		}
 	}
 #endif
-	/*
-	 * This is special!  We do not need the spinlock when clearing I_NEW,
-	 * because we're guaranteed that nobody else tries to do anything about
-	 * the state of the inode when it is locked, as we just created it (so
-	 * there can be no old holders that haven't tested I_NEW).
-	 * However we must emit the memory barrier so that other CPUs reliably
-	 * see the clearing of I_NEW after the other inode initialisation has
-	 * completed.
-	 */
-	smp_mb();
+	spin_lock(&inode->i_lock);
 	WARN_ON(!(inode->i_state & I_NEW));
 	inode->i_state &= ~I_NEW;
-	wake_up_inode(inode);
+	wake_up_bit(&inode->i_state, __I_NEW);
+	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(unlock_new_inode);
 
@@ -899,9 +931,11 @@ static struct inode *get_new_inode(struct super_block *sb,
 			if (set(inode, data))
 				goto set_failed;
 
+			spin_lock(&inode->i_lock);
+			inode->i_state = I_NEW;
 			hlist_add_head(&inode->i_hash, head);
+			spin_unlock(&inode->i_lock);
 			__inode_sb_list_add(inode);
-			inode->i_state = I_NEW;
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -946,9 +980,11 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
 			inode->i_ino = ino;
+			spin_lock(&inode->i_lock);
+			inode->i_state = I_NEW;
 			hlist_add_head(&inode->i_hash, head);
+			spin_unlock(&inode->i_lock);
 			__inode_sb_list_add(inode);
-			inode->i_state = I_NEW;
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -1033,15 +1069,19 @@ EXPORT_SYMBOL(iunique);
 struct inode *igrab(struct inode *inode)
 {
 	spin_lock(&inode_lock);
-	if (!(inode->i_state & (I_FREEING|I_WILL_FREE)))
+	spin_lock(&inode->i_lock);
+	if (!(inode->i_state & (I_FREEING|I_WILL_FREE))) {
 		__iget(inode);
-	else
+		spin_unlock(&inode->i_lock);
+	} else {
+		spin_unlock(&inode->i_lock);
 		/*
 		 * Handle the case where s_op->clear_inode is not been
 		 * called yet, and somebody is calling igrab
 		 * while the inode is getting freed.
 		 */
 		inode = NULL;
+	}
 	spin_unlock(&inode_lock);
 	return inode;
 }
@@ -1270,7 +1310,6 @@ int insert_inode_locked(struct inode *inode)
 	ino_t ino = inode->i_ino;
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 
-	inode->i_state |= I_NEW;
 	while (1) {
 		struct hlist_node *node;
 		struct inode *old = NULL;
@@ -1280,16 +1319,23 @@ int insert_inode_locked(struct inode *inode)
 				continue;
 			if (old->i_sb != sb)
 				continue;
-			if (old->i_state & (I_FREEING|I_WILL_FREE))
+			spin_lock(&old->i_lock);
+			if (old->i_state & (I_FREEING|I_WILL_FREE)) {
+				spin_unlock(&old->i_lock);
 				continue;
+			}
 			break;
 		}
 		if (likely(!node)) {
+			spin_lock(&inode->i_lock);
+			inode->i_state |= I_NEW;
 			hlist_add_head(&inode->i_hash, head);
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 			return 0;
 		}
 		__iget(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!inode_unhashed(old))) {
@@ -1307,8 +1353,6 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 	struct super_block *sb = inode->i_sb;
 	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
 
-	inode->i_state |= I_NEW;
-
 	while (1) {
 		struct hlist_node *node;
 		struct inode *old = NULL;
@@ -1319,16 +1363,23 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 				continue;
 			if (!test(old, data))
 				continue;
-			if (old->i_state & (I_FREEING|I_WILL_FREE))
+			spin_lock(&old->i_lock);
+			if (old->i_state & (I_FREEING|I_WILL_FREE)) {
+				spin_unlock(&old->i_lock);
 				continue;
+			}
 			break;
 		}
 		if (likely(!node)) {
+			spin_lock(&inode->i_lock);
+			inode->i_state |= I_NEW;
 			hlist_add_head(&inode->i_hash, head);
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 			return 0;
 		}
 		__iget(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!inode_unhashed(old))) {
@@ -1374,6 +1425,9 @@ static void iput_final(struct inode *inode)
 	const struct super_operations *op = inode->i_sb->s_op;
 	int drop;
 
+	spin_lock(&inode->i_lock);
+	WARN_ON(inode->i_state & I_NEW);
+
 	if (op && op->drop_inode)
 		drop = op->drop_inode(inode);
 	else
@@ -1385,21 +1439,23 @@ static void iput_final(struct inode *inode)
 			if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
 				inode_lru_list_add(inode);
 			}
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 			return;
 		}
-		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		write_inode_now(inode, 1);
 		spin_lock(&inode_lock);
+		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
 		__remove_inode_hash(inode);
 	}
 
-	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
+	spin_unlock(&inode->i_lock);
 
 	/*
 	 * Move the inode off the IO lists and LRU once I_FREEING is
@@ -1412,8 +1468,10 @@ static void iput_final(struct inode *inode)
 	spin_unlock(&inode_lock);
 	evict(inode);
 	remove_inode_hash(inode);
-	wake_up_inode(inode);
+	spin_lock(&inode->i_lock);
+	wake_up_bit(&inode->i_state, __I_NEW);
 	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
+	spin_unlock(&inode->i_lock);
 	destroy_inode(inode);
 }
 
@@ -1610,9 +1668,8 @@ EXPORT_SYMBOL(inode_wait);
  * to recheck inode state.
  *
  * It doesn't matter if I_NEW is not set initially, a call to
- * wake_up_inode() after removing from the hash list will DTRT.
- *
- * This is called with inode_lock held.
+ * wake_up_bit(&inode->i_state, __I_NEW) after removing from the hash list
+ * will DTRT.
  */
 static void __wait_on_freeing_inode(struct inode *inode)
 {
@@ -1620,6 +1677,7 @@ static void __wait_on_freeing_inode(struct inode *inode)
 	DEFINE_WAIT_BIT(wait, &inode->i_state, __I_NEW);
 	wq = bit_waitqueue(&inode->i_state, __I_NEW);
 	prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	schedule();
 	finish_wait(wq, &wait.wait);
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 4c29fcf..4dd53fb 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -254,8 +254,11 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		 * I_WILL_FREE, or I_NEW which is fine because by that point
 		 * the inode cannot have any associated watches.
 		 */
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 
 		/*
 		 * If i_count is zero, the inode cannot have any watches and
@@ -263,8 +266,10 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		 * evict all inodes with zero i_count from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
-		if (!atomic_read(&inode->i_count))
+		if (!atomic_read(&inode->i_count)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 
 		need_iput_tmp = need_iput;
 		need_iput = NULL;
@@ -274,13 +279,17 @@ void fsnotify_unmount_inodes(struct list_head *list)
 			__iget(inode);
 		else
 			need_iput_tmp = NULL;
+		spin_unlock(&inode->i_lock);
 
 		/* In case the dropping of a reference would nuke next_i. */
 		if ((&next_i->i_sb_list != list) &&
-		    atomic_read(&next_i->i_count) &&
-		    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
-			__iget(next_i);
-			need_iput = next_i;
+		    atomic_read(&next_i->i_count)) {
+			spin_lock(&next_i->i_lock);
+			if (!(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
+				__iget(next_i);
+				need_iput = next_i;
+			}
+			spin_unlock(&next_i->i_lock);
 		}
 
 		/*
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index a2a622e..a1470fd 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -902,18 +902,19 @@ static void add_dquot_ref(struct super_block *sb, int type)
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
+		spin_lock(&inode->i_lock);
+		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+		    !atomic_read(&inode->i_writecount) ||
+		    !dqinit_needed(inode, type)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 #ifdef CONFIG_QUOTA_DEBUG
 		if (unlikely(inode_get_rsv_space(inode) > 0))
 			reserved = 1;
 #endif
-		if (!atomic_read(&inode->i_writecount))
-			continue;
-		if (!dqinit_needed(inode, type))
-			continue;
-
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 
 		iput(old_inode);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7061a85..0a96bb0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1642,7 +1642,7 @@ struct super_operations {
 };
 
 /*
- * Inode state bits.  Protected by inode_lock.
+ * Inode state bits.  Protected by inode->i_lock
  *
  * Three bits determine the dirty state of the inode, I_DIRTY_SYNC,
  * I_DIRTY_DATASYNC and I_DIRTY_PAGES.
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index eb354f6..26f9e36 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -277,7 +277,7 @@ static inline int dquot_alloc_space(struct inode *inode, qsize_t nr)
 		/*
 		 * Mark inode fully dirty. Since we are allocating blocks, inode
 		 * would become fully dirty soon anyway and it reportedly
-		 * reduces inode_lock contention.
+		 * reduces lock contention.
 		 */
 		mark_inode_dirty(inode);
 	}
diff --git a/mm/filemap.c b/mm/filemap.c
index 83a45d3..79b021d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -99,7 +99,9 @@
  *    ->private_lock		(page_remove_rmap->set_page_dirty)
  *    ->tree_lock		(page_remove_rmap->set_page_dirty)
  *    ->inode_lock		(page_remove_rmap->set_page_dirty)
+ *    ->inode->i_lock		(page_remove_rmap->set_page_dirty)
  *    ->inode_lock		(zap_pte_range->set_page_dirty)
+ *    ->inode->i_lock		(zap_pte_range->set_page_dirty)
  *    ->private_lock		(zap_pte_range->__set_page_dirty_buffers)
  *
  *  (code doesn't rely on that order, so you could switch it around)
diff --git a/mm/rmap.c b/mm/rmap.c
index 941bf82..81a95c3 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -32,6 +32,7 @@
  *               mmlist_lock (in mmput, drain_mmlist and others)
  *               mapping->private_lock (in __set_page_dirty_buffers)
  *               inode_lock (in set_page_dirty's __mark_inode_dirty)
+ *               inode->i_lock (in set_page_dirty's __mark_inode_dirty)
  *                 sb_lock (within inode_lock in fs/fs-writeback.c)
  *                 mapping->tree_lock (widely used, in set_page_dirty,
  *                           in arch-dependent flush_dcache_mmap_lock,
-- 
1.7.2.3

