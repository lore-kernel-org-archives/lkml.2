Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024Ab0J2DYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 23:24:32 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:54963 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756277Ab0J2DYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 23:24:25 -0400
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] fs: protect inode->i_state with inode->i_lock
Date: Fri, 29 Oct 2010 14:23:33 +1100
Message-Id: <1288322620-8566-2-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288322620-8566-1-git-send-email-david@fromorbit.com>
References: <1288322620-8566-1-git-send-email-david@fromorbit.com>
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
 fs/drop_caches.c       |    9 ++-
 fs/fs-writeback.c      |   42 +++++++++++---
 fs/inode.c             |  138 +++++++++++++++++++++++++++++++++---------------
 fs/notify/inode_mark.c |   21 +++++--
 fs/quota/dquot.c       |   13 +++--
 5 files changed, 157 insertions(+), 66 deletions(-)

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
index f6af81a..50de4f1 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -293,9 +293,11 @@ static void inode_wait_for_writeback(struct inode *inode)
 
 	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
 	 while (inode->i_state & I_SYNC) {
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
 		spin_lock(&inode_lock);
+		spin_lock(&inode->i_lock);
 	}
 }
 
@@ -319,6 +321,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	unsigned dirty;
 	int ret;
 
+	spin_lock(&inode->i_lock);
 	if (!atomic_read(&inode->i_count))
 		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
 	else
@@ -334,6 +337,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 		 * completed a full scan of b_io.
 		 */
 		if (wbc->sync_mode != WB_SYNC_ALL) {
+			spin_unlock(&inode->i_lock);
 			requeue_io(inode);
 			return 0;
 		}
@@ -349,6 +353,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	/* Set I_SYNC, reset I_DIRTY_PAGES */
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY_PAGES;
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 
 	ret = do_writepages(mapping, wbc);
@@ -370,8 +375,10 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
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
@@ -381,6 +388,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	}
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
 		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
@@ -422,6 +430,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 		}
 	}
 	inode_sync_complete(inode);
+	spin_unlock(&inode->i_lock);
 	return ret;
 }
 
@@ -492,7 +501,9 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 		 * kind does not need peridic writeout yet, and for the latter
 		 * kind writeout is handled by the freer.
 		 */
+		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
+			spin_unlock(&inode->i_lock);
 			requeue_io(inode);
 			continue;
 		}
@@ -501,10 +512,14 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
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
@@ -681,7 +696,9 @@ static long wb_writeback(struct bdi_writeback *wb,
 		if (!list_empty(&wb->b_more_io))  {
 			inode = wb_inode(wb->b_more_io.prev);
 			trace_wbc_writeback_wait(&wbc, wb->bdi);
+			spin_lock(&inode->i_lock);
 			inode_wait_for_writeback(inode);
+			spin_unlock(&inode->i_lock);
 		}
 		spin_unlock(&inode_lock);
 	}
@@ -947,6 +964,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		block_dump___mark_inode_dirty(inode);
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	if ((inode->i_state & flags) != flags) {
 		const int was_dirty = inode->i_state & I_DIRTY;
 
@@ -958,7 +976,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 * superblock list, based upon its state.
 		 */
 		if (inode->i_state & I_SYNC)
-			goto out;
+			goto out_unlock_inode;
 
 		/*
 		 * Only add valid (hashed) inodes to the superblock's
@@ -966,11 +984,12 @@ void __mark_inode_dirty(struct inode *inode, int flags)
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
@@ -995,7 +1014,10 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
 		}
+		goto out;
 	}
+out_unlock_inode:
+	spin_unlock(&inode->i_lock);
 out:
 	spin_unlock(&inode_lock);
 
@@ -1041,14 +1063,16 @@ static void wait_sb_inodes(struct super_block *sb)
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
index a6d6068..4c84acb 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -26,6 +26,17 @@
 #include <linux/posix_acl.h>
 
 /*
+ * inode locking rules.
+ *
+ * inode->i_lock protects:
+ *   inode->i_state, __iget()
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
@@ -314,7 +316,7 @@ static void init_once(void *foo)
 }
 
 /*
- * inode_lock must be held
+ * inode->i_lock must be held
  */
 void __iget(struct inode *inode)
 {
@@ -429,7 +431,9 @@ void end_writeback(struct inode *inode)
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
 	inode_sync_wait(inode);
+	spin_lock(&inode->i_lock);
 	inode->i_state = I_FREEING | I_CLEAR;
+	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(end_writeback);
 
@@ -472,7 +476,9 @@ static void dispose_list(struct list_head *head)
 		__inode_sb_list_del(inode);
 		spin_unlock(&inode_lock);
 
-		wake_up_inode(inode);
+		spin_lock(&inode->i_lock);
+		wake_up_bit(&inode->i_state, __I_NEW);
+		spin_unlock(&inode->i_lock);
 		destroy_inode(inode);
 	}
 }
@@ -498,12 +504,17 @@ void evict_inodes(struct super_block *sb)
 		if (atomic_read(&inode->i_count))
 			continue;
 
+		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
+			spin_unlock(&inode->i_lock);
 			WARN_ON(1);
 			continue;
 		}
 
 		inode->i_state |= I_FREEING;
+		if (!(inode->i_state & (I_DIRTY | I_SYNC)))
+			percpu_counter_dec(&nr_inodes_unused);
+		spin_unlock(&inode->i_lock);
 
 		/*
 		 * Move the inode off the IO lists and LRU once I_FREEING is
@@ -511,8 +522,6 @@ void evict_inodes(struct super_block *sb)
 		 */
 		list_move(&inode->i_lru, &dispose);
 		list_del_init(&inode->i_wb_list);
-		if (!(inode->i_state & (I_DIRTY | I_SYNC)))
-			percpu_counter_dec(&nr_inodes_unused);
 	}
 	spin_unlock(&inode_lock);
 
@@ -537,14 +546,21 @@ int invalidate_inodes(struct super_block *sb)
 
 	spin_lock(&inode_lock);
 	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE))
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 		if (atomic_read(&inode->i_count)) {
+			spin_unlock(&inode->i_lock);
 			busy = 1;
 			continue;
 		}
 
 		inode->i_state |= I_FREEING;
+		if (!(inode->i_state & (I_DIRTY | I_SYNC)))
+			percpu_counter_dec(&nr_inodes_unused);
+		spin_unlock(&inode->i_lock);
 
 		/*
 		 * Move the inode off the IO lists and LRU once I_FREEING is
@@ -552,8 +568,6 @@ int invalidate_inodes(struct super_block *sb)
 		 */
 		list_move(&inode->i_lru, &dispose);
 		list_del_init(&inode->i_wb_list);
-		if (!(inode->i_state & (I_DIRTY | I_SYNC)))
-			percpu_counter_dec(&nr_inodes_unused);
 	}
 	spin_unlock(&inode_lock);
 
@@ -612,8 +626,10 @@ static void prune_icache(int nr_to_scan)
 		 * Referenced or dirty inodes are still in use. Give them
 		 * another pass through the LRU as we canot reclaim them now.
 		 */
+		spin_lock(&inode->i_lock);
 		if (atomic_read(&inode->i_count) ||
 		    (inode->i_state & ~I_REFERENCED)) {
+			spin_unlock(&inode->i_lock);
 			list_del_init(&inode->i_lru);
 			percpu_counter_dec(&nr_inodes_unused);
 			continue;
@@ -621,12 +637,14 @@ static void prune_icache(int nr_to_scan)
 
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
@@ -637,11 +655,15 @@ static void prune_icache(int nr_to_scan)
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
@@ -708,11 +730,13 @@ repeat:
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
@@ -734,11 +758,13 @@ repeat:
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
@@ -803,14 +829,23 @@ struct inode *new_inode(struct super_block *sb)
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
@@ -830,19 +865,11 @@ void unlock_new_inode(struct inode *inode)
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
 
@@ -871,9 +898,11 @@ static struct inode *get_new_inode(struct super_block *sb,
 			if (set(inode, data))
 				goto set_failed;
 
+			spin_lock(&inode->i_lock);
+			inode->i_state = I_NEW;
+			spin_unlock(&inode->i_lock);
 			hlist_add_head(&inode->i_hash, head);
 			__inode_sb_list_add(inode);
-			inode->i_state = I_NEW;
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -917,10 +946,12 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
+			spin_lock(&inode->i_lock);
 			inode->i_ino = ino;
+			inode->i_state = I_NEW;
+			spin_unlock(&inode->i_lock);
 			hlist_add_head(&inode->i_hash, head);
 			__inode_sb_list_add(inode);
-			inode->i_state = I_NEW;
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -1005,15 +1036,19 @@ EXPORT_SYMBOL(iunique);
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
@@ -1242,7 +1277,9 @@ int insert_inode_locked(struct inode *inode)
 	ino_t ino = inode->i_ino;
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 
+	spin_lock(&inode->i_lock);
 	inode->i_state |= I_NEW;
+	spin_unlock(&inode->i_lock);
 	while (1) {
 		struct hlist_node *node;
 		struct inode *old = NULL;
@@ -1252,8 +1289,11 @@ int insert_inode_locked(struct inode *inode)
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
@@ -1262,6 +1302,7 @@ int insert_inode_locked(struct inode *inode)
 			return 0;
 		}
 		__iget(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!inode_unhashed(old))) {
@@ -1279,7 +1320,9 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 	struct super_block *sb = inode->i_sb;
 	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
 
+	spin_lock(&inode->i_lock);
 	inode->i_state |= I_NEW;
+	spin_unlock(&inode->i_lock);
 
 	while (1) {
 		struct hlist_node *node;
@@ -1291,8 +1334,11 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
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
@@ -1301,6 +1347,7 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 			return 0;
 		}
 		__iget(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!inode_unhashed(old))) {
@@ -1346,6 +1393,9 @@ static void iput_final(struct inode *inode)
 	const struct super_operations *op = inode->i_sb->s_op;
 	int drop;
 
+	spin_lock(&inode->i_lock);
+	WARN_ON(inode->i_state & I_NEW);
+
 	if (op && op->drop_inode)
 		drop = op->drop_inode(inode);
 	else
@@ -1357,21 +1407,23 @@ static void iput_final(struct inode *inode)
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
@@ -1384,8 +1436,10 @@ static void iput_final(struct inode *inode)
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
 
@@ -1582,9 +1636,8 @@ EXPORT_SYMBOL(inode_wait);
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
@@ -1592,6 +1645,7 @@ static void __wait_on_freeing_inode(struct inode *inode)
 	DEFINE_WAIT_BIT(wait, &inode->i_state, __I_NEW);
 	wq = bit_waitqueue(&inode->i_state, __I_NEW);
 	prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	schedule();
 	finish_wait(wq, &wait.wait);
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 21ed106..9c0fb09 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -249,8 +249,11 @@ void fsnotify_unmount_inodes(struct list_head *list)
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
@@ -258,8 +261,10 @@ void fsnotify_unmount_inodes(struct list_head *list)
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
@@ -269,13 +274,17 @@ void fsnotify_unmount_inodes(struct list_head *list)
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
index aad1316..a2d89f8 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -898,18 +898,19 @@ static void add_dquot_ref(struct super_block *sb, int type)
 
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
-- 
1.7.1

