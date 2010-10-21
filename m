Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab0JUAvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:51:39 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:42668 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756508Ab0JUAuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:50:52 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/21] fs: Protect inode->i_state with the inode->i_lock
Date: Thu, 21 Oct 2010 11:49:41 +1100
Message-Id: <1287622186-1935-17-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287622186-1935-1-git-send-email-david@fromorbit.com>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We currently protect the per-inode state flags with the inode_lock.
Using a global lock to protect per-object state is overkill when we
coul duse a per-inode lock to protect the state.  Use the
inode->i_lock for this, and wrap all the state changes and checks
with the inode->i_lock.

Based on work originally written by Nick Piggin.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/drop_caches.c       |    9 +++--
 fs/fs-writeback.c      |   48 +++++++++++++++++++++------
 fs/inode.c             |   85 ++++++++++++++++++++++++++++++++++--------------
 fs/nilfs2/gcdat.c      |    1 +
 fs/notify/inode_mark.c |    6 ++-
 fs/quota/dquot.c       |   12 +++---
 6 files changed, 113 insertions(+), 48 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index dfe8cb1..f958dd8 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -19,11 +19,12 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 	spin_lock(&inode_lock);
 	spin_lock(&sb->s_inodes_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
-			continue;
-		if (inode->i_mapping->nrpages == 0)
-			continue;
 		spin_lock(&inode->i_lock);
+		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+		    (inode->i_mapping->nrpages == 0)) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
 		inode->i_ref++;
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb->s_inodes_lock);
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 36106e6..807d936 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -304,10 +304,12 @@ static void inode_wait_for_writeback(struct inode *inode)
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
 
@@ -331,6 +333,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	unsigned dirty;
 	int ret;
 
+	spin_lock(&inode->i_lock);
 	if (!inode->i_ref)
 		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
 	else
@@ -346,6 +349,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 		 * completed a full scan of b_io.
 		 */
 		if (wbc->sync_mode != WB_SYNC_ALL) {
+			spin_unlock(&inode->i_lock);
 			spin_lock(&bdi->wb.b_lock);
 			requeue_io(inode);
 			spin_unlock(&bdi->wb.b_lock);
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
@@ -403,6 +411,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			 * sometimes bales out without doing anything.
 			 */
 			inode->i_state |= I_DIRTY_PAGES;
+			spin_unlock(&inode->i_lock);
 			spin_lock(&bdi->wb.b_lock);
 			if (wbc->nr_to_write <= 0) {
 				/*
@@ -427,6 +436,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			 * submission or metadata updates after data IO
 			 * completion.
 			 */
+			spin_unlock(&inode->i_lock);
 			spin_lock(&bdi->wb.b_lock);
 			redirty_tail(inode);
 			spin_unlock(&bdi->wb.b_lock);
@@ -437,10 +447,15 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			 * does not move dirty inodes to the LRU and dirty
 			 * inodes are removed from the LRU during scanning.
 			 */
+			int unused = inode->i_ref == 0;
+			spin_unlock(&inode->i_lock);
 			inode_wb_list_del(inode);
-			if (!inode->i_ref)
+			if (unused)
 				inode_lru_list_add(inode);
 		}
+	} else {
+		/* freer will clean up */
+		spin_unlock(&inode->i_lock);
 	}
 	inode_sync_complete(inode);
 	return ret;
@@ -517,7 +532,9 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 		 * and move on to the next inode, which will allow the other
 		 * thread to free the inode when we drop the lock.
 		 */
+		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_NEW | I_WILL_FREE | I_FREEING)) {
+			spin_unlock(&inode->i_lock);
 			requeue_io(inode);
 			continue;
 		}
@@ -525,10 +542,11 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 		 * Was this inode dirtied after sync_sb_inodes was called?
 		 * This keeps sync from extra jobs and livelock.
 		 */
-		if (inode_dirtied_after(inode, wbc->wb_start))
+		if (inode_dirtied_after(inode, wbc->wb_start)) {
+			spin_unlock(&inode->i_lock);
 			return 1;
+		}
 
-		spin_lock(&inode->i_lock);
 		inode->i_ref++;
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&wb->b_lock);
@@ -719,9 +737,11 @@ static long wb_writeback(struct bdi_writeback *wb,
 			spin_lock(&wb->b_lock);
 			inode = list_entry(wb->b_more_io.prev,
 						struct inode, i_wb_list);
+			spin_lock(&inode->i_lock);
 			spin_unlock(&wb->b_lock);
 			trace_wbc_writeback_wait(&wbc, wb->bdi);
 			inode_wait_for_writeback(inode);
+			spin_unlock(&inode->i_lock);
 		}
 		spin_unlock(&inode_lock);
 	}
@@ -987,6 +1007,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		block_dump___mark_inode_dirty(inode);
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	if ((inode->i_state & flags) != flags) {
 		const int was_dirty = inode->i_state & I_DIRTY;
 
@@ -998,7 +1019,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 * superblock list, based upon its state.
 		 */
 		if (inode->i_state & I_SYNC)
-			goto out;
+			goto out_unlock;
 
 		/*
 		 * Only add valid (hashed) inodes to the superblock's
@@ -1006,10 +1027,10 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 */
 		if (!S_ISBLK(inode->i_mode)) {
 			if (inode_unhashed(inode))
-				goto out;
+				goto out_unlock;
 		}
 		if (inode->i_state & I_FREEING)
-			goto out;
+			goto out_unlock;
 
 		/*
 		 * If the inode was already on b_dirty/b_io/b_more_io, don't
@@ -1032,12 +1053,16 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 					wakeup_bdi = true;
 			}
 
+			spin_unlock(&inode->i_lock);
 			spin_lock(&bdi->wb.b_lock);
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
 			spin_unlock(&bdi->wb.b_lock);
+			goto out;
 		}
 	}
+out_unlock:
+	spin_unlock(&inode->i_lock);
 out:
 	spin_unlock(&inode_lock);
 
@@ -1086,12 +1111,13 @@ static void wait_sb_inodes(struct super_block *sb)
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		struct address_space *mapping;
 
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
-			continue;
+		spin_lock(&inode->i_lock);
 		mapping = inode->i_mapping;
-		if (mapping->nrpages == 0)
+		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+		    mapping->nrpages == 0) {
+			spin_unlock(&inode->i_lock);
 			continue;
-		spin_lock(&inode->i_lock);
+		}
 		inode->i_ref++;
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb->s_inodes_lock);
diff --git a/fs/inode.c b/fs/inode.c
index 959c8b5..32bac58 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -33,7 +33,7 @@
  * inode->i_lock is *always* the innermost lock.
  *
  * inode->i_lock protects:
- *   i_ref
+ *   i_ref i_state
  * inode hash lock protects:
  *   inode hash table, i_hash
  * sb inode lock protects:
@@ -178,7 +178,7 @@ int proc_nr_inodes(ctl_table *table, int write,
 static void wake_up_inode(struct inode *inode)
 {
 	/*
-	 * Prevent speculative execution through spin_unlock(&inode_lock);
+	 * Prevent speculative execution through spin_unlock(&inode->i_lock);
 	 */
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_NEW);
@@ -495,7 +495,9 @@ void end_writeback(struct inode *inode)
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
 	inode_sync_wait(inode);
+	spin_lock(&inode->i_lock);
 	inode->i_state = I_FREEING | I_CLEAR;
+	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(end_writeback);
 
@@ -570,14 +572,16 @@ static int invalidate_list(struct super_block *sb, struct list_head *head,
 		if (tmp == head)
 			break;
 		inode = list_entry(tmp, struct inode, i_sb_list);
-		if (inode->i_state & I_NEW)
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & I_NEW) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 		invalidate_inode_buffers(inode);
-		spin_lock(&inode->i_lock);
 		if (!inode->i_ref) {
-			spin_unlock(&inode->i_lock);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
+			spin_unlock(&inode->i_lock);
 
 			/*
 			 * move the inode off the IO lists and LRU once
@@ -673,9 +677,9 @@ static void prune_icache(int nr_to_scan)
 
 		/* recently referenced inodes get one more pass */
 		if (inode->i_state & I_REFERENCED) {
+			inode->i_state &= ~I_REFERENCED;
 			spin_unlock(&inode->i_lock);
 			list_move(&inode->i_lru, &inode_lru);
-			inode->i_state &= ~I_REFERENCED;
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
@@ -702,9 +706,9 @@ static void prune_icache(int nr_to_scan)
 			spin_lock(&inode_lru_lock);
 			continue;
 		}
-		spin_unlock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
+		spin_unlock(&inode->i_lock);
 
 		/*
 		 * move the inode off the io lists and lru once
@@ -758,9 +762,6 @@ static struct shrinker icache_shrinker = {
 
 static void __wait_on_freeing_inode(struct inode *inode);
 
-/*
- * Called with the inode lock held.
- */
 static struct inode *find_inode(struct super_block *sb,
 				struct hlist_bl_head *b,
 				int (*test)(struct inode *, void *),
@@ -773,15 +774,17 @@ repeat:
 	hlist_bl_for_each_entry(inode, node, b, i_hash) {
 		if (inode->i_sb != sb)
 			continue;
-		if (!test(inode, data))
+		spin_lock(&inode->i_lock);
+		if (!test(inode, data)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
 			hlist_bl_unlock(b);
 			__wait_on_freeing_inode(inode);
 			hlist_bl_lock(b);
 			goto repeat;
 		}
-		spin_lock(&inode->i_lock);
 		inode->i_ref++;
 		spin_unlock(&inode->i_lock);
 		return inode;
@@ -805,13 +808,13 @@ repeat:
 			continue;
 		if (inode->i_sb != sb)
 			continue;
+		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
 			hlist_bl_unlock(b);
 			__wait_on_freeing_inode(inode);
 			hlist_bl_lock(b);
 			goto repeat;
 		}
-		spin_lock(&inode->i_lock);
 		inode->i_ref++;
 		spin_unlock(&inode->i_lock);
 		return inode;
@@ -846,9 +849,13 @@ struct inode *new_inode(struct super_block *sb)
 	inode = alloc_inode(sb);
 	if (inode) {
 		spin_lock(&inode_lock);
-		__inode_sb_list_add(inode);
+		/*
+		 * set the inode state before we make the inode accessible to
+		 * the outside world.
+		 */
 		inode->i_ino = ++last_ino;
 		inode->i_state = 0;
+		__inode_sb_list_add(inode);
 		spin_unlock(&inode_lock);
 	}
 	return inode;
@@ -916,10 +923,14 @@ static struct inode *get_new_inode(struct super_block *sb,
 			if (set(inode, data))
 				goto set_failed;
 
+			/*
+			 * Set the inode state before we make the inode
+			 * visible to the outside world.
+			 */
+			inode->i_state = I_NEW;
 			hlist_bl_add_head(&inode->i_hash, b);
 			hlist_bl_unlock(b);
 			__inode_sb_list_add(inode);
-			inode->i_state = I_NEW;
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -966,11 +977,15 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, b, ino);
 		if (!old) {
+			/*
+			 * Set the inode state before we make the inode
+			 * visible to the outside world.
+			 */
 			inode->i_ino = ino;
+			inode->i_state = I_NEW;
 			hlist_bl_add_head(&inode->i_hash, b);
 			hlist_bl_unlock(b);
 			__inode_sb_list_add(inode);
-			inode->i_state = I_NEW;
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -1313,8 +1328,11 @@ int insert_inode_locked(struct inode *inode)
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
@@ -1323,7 +1341,6 @@ int insert_inode_locked(struct inode *inode)
 			spin_unlock(&inode_lock);
 			return 0;
 		}
-		spin_lock(&old->i_lock);
 		old->i_ref++;
 		spin_unlock(&old->i_lock);
 		hlist_bl_unlock(b);
@@ -1344,6 +1361,10 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 	struct super_block *sb = inode->i_sb;
 	struct hlist_bl_head *b = inode_hashtable + hash(sb, hashval);
 
+	/*
+	 * Nobody else can see the new inode yet, so it is safe to set flags
+	 * without locking here.
+	 */
 	inode->i_state |= I_NEW;
 
 	while (1) {
@@ -1357,8 +1378,11 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
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
@@ -1367,7 +1391,6 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 			spin_unlock(&inode_lock);
 			return 0;
 		}
-		spin_lock(&old->i_lock);
 		old->i_ref++;
 		spin_unlock(&old->i_lock);
 		hlist_bl_unlock(b);
@@ -1416,6 +1439,8 @@ static void iput_final(struct inode *inode)
 	const struct super_operations *op = inode->i_sb->s_op;
 	int drop;
 
+	assert_spin_locked(&inode->i_lock);
+
 	if (op && op->drop_inode)
 		drop = op->drop_inode(inode);
 	else
@@ -1424,22 +1449,30 @@ static void iput_final(struct inode *inode)
 	if (!drop) {
 		if (sb->s_flags & MS_ACTIVE) {
 			inode->i_state |= I_REFERENCED;
-			if (!(inode->i_state & (I_DIRTY|I_SYNC)))
+			if (!(inode->i_state & (I_DIRTY|I_SYNC)) &&
+			    list_empty(&inode->i_lru)) {
+				spin_unlock(&inode->i_lock);
 				inode_lru_list_add(inode);
+				return;
+			}
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 			return;
 		}
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		write_inode_now(inode, 1);
 		spin_lock(&inode_lock);
+		__remove_inode_hash(inode);
+		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		__remove_inode_hash(inode);
 	}
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
+	spin_unlock(&inode->i_lock);
 
 	/*
 	 * After we delete the inode from the LRU and IO lists here, we avoid
@@ -1470,12 +1503,11 @@ static void iput_final(struct inode *inode)
 void iput(struct inode *inode)
 {
 	if (inode) {
-		BUG_ON(inode->i_state & I_CLEAR);
-
 		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
+		BUG_ON(inode->i_state & I_CLEAR);
+
 		if (--inode->i_ref == 0) {
-			spin_unlock(&inode->i_lock);
 			iput_final(inode);
 			return;
 		}
@@ -1661,6 +1693,8 @@ EXPORT_SYMBOL(inode_wait);
  * wake_up_inode() after removing from the hash list will DTRT.
  *
  * This is called with inode_lock held.
+ *
+ * Called with i_lock held and returns with it dropped.
  */
 static void __wait_on_freeing_inode(struct inode *inode)
 {
@@ -1668,6 +1702,7 @@ static void __wait_on_freeing_inode(struct inode *inode)
 	DEFINE_WAIT_BIT(wait, &inode->i_state, __I_NEW);
 	wq = bit_waitqueue(&inode->i_state, __I_NEW);
 	prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	schedule();
 	finish_wait(wq, &wait.wait);
diff --git a/fs/nilfs2/gcdat.c b/fs/nilfs2/gcdat.c
index 84a45d1..c51f0e8 100644
--- a/fs/nilfs2/gcdat.c
+++ b/fs/nilfs2/gcdat.c
@@ -27,6 +27,7 @@
 #include "page.h"
 #include "mdt.h"
 
+/* XXX: what protects i_state? */
 int nilfs_init_gcdat_inode(struct the_nilfs *nilfs)
 {
 	struct inode *dat = nilfs->ns_dat, *gcdat = nilfs->ns_gc_dat;
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 4ed0e43..203146b 100644
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
 		 * If i_ref is zero, the inode cannot have any watches and
@@ -258,7 +261,6 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		 * evict all inodes with zero i_ref from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
-		spin_lock(&inode->i_lock);
 		if (!inode->i_ref) {
 			spin_unlock(&inode->i_lock);
 			continue;
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 7ef5411..b02a3e1 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -899,18 +899,18 @@ static void add_dquot_ref(struct super_block *sb, int type)
 	spin_lock(&inode_lock);
 	spin_lock(&sb->s_inodes_lock);
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
 
-		spin_lock(&inode->i_lock);
 		inode->i_ref++;
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb->s_inodes_lock);
-- 
1.7.1

