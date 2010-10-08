Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab0JHFWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:22:48 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:36049 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752583Ab0JHFWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:22:35 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/18] fs: Protect inode->i_state with th einode->i_lock
Date: Fri,  8 Oct 2010 16:21:28 +1100
Message-Id: <1286515292-15882-15-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286515292-15882-1-git-send-email-david@fromorbit.com>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
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
---
 fs/drop_caches.c       |    9 +++--
 fs/fs-writeback.c      |   49 ++++++++++++++++++++++------
 fs/inode.c             |   83 ++++++++++++++++++++++++++++++++---------------
 fs/nilfs2/gcdat.c      |    1 +
 fs/notify/inode_mark.c |   10 ++++--
 fs/quota/dquot.c       |   12 ++++---
 6 files changed, 115 insertions(+), 49 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index c808ca8..00180dc 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -19,11 +19,14 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 	spin_lock(&inode_lock);
 	spin_lock(&sb->s_inodes_lock);
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
 		iref_locked(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb->s_inodes_lock);
 		spin_unlock(&inode_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 49d44cc..404d449 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -281,10 +281,12 @@ static void inode_wait_for_writeback(struct inode *inode)
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
 
@@ -309,7 +311,8 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	unsigned dirty;
 	int ret;
 
-	if (!iref_read(inode))
+	spin_lock(&inode->i_lock);
+	if (!inode->i_ref)
 		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
 	else
 		WARN_ON(inode->i_state & I_WILL_FREE);
@@ -324,6 +327,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 		 * completed a full scan of b_io.
 		 */
 		if (wbc->sync_mode != WB_SYNC_ALL) {
+			spin_unlock(&inode->i_lock);
 			spin_lock(&bdi->wb.b_lock);
 			requeue_io(inode);
 			spin_unlock(&bdi->wb.b_lock);
@@ -341,6 +345,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	/* Set I_SYNC, reset I_DIRTY_PAGES */
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY_PAGES;
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 
 	ret = do_writepages(mapping, wbc);
@@ -362,8 +367,10 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
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
@@ -373,6 +380,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	}
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
 		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
@@ -381,6 +389,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			 * sometimes bales out without doing anything.
 			 */
 			inode->i_state |= I_DIRTY_PAGES;
+			spin_unlock(&inode->i_lock);
 			spin_lock(&bdi->wb.b_lock);
 			if (wbc->nr_to_write <= 0) {
 				/*
@@ -405,16 +414,21 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			 * submission or metadata updates after data IO
 			 * completion.
 			 */
+			spin_unlock(&inode->i_lock);
 			spin_lock(&bdi->wb.b_lock);
 			redirty_tail(inode);
 			spin_unlock(&bdi->wb.b_lock);
 		} else {
 			/* The inode is clean */
+			spin_unlock(&inode->i_lock);
 			spin_lock(&bdi->wb.b_lock);
 			list_del_init(&inode->i_io);
 			spin_unlock(&bdi->wb.b_lock);
 			inode_lru_list_add(inode);
 		}
+	} else {
+		/* freer will clean up */
+		spin_unlock(&inode->i_lock);
 	}
 	inode_sync_complete(inode);
 	return ret;
@@ -483,7 +497,9 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 			return 0;
 		}
 
+		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_NEW | I_WILL_FREE | I_FREEING)) {
+			spin_unlock(&inode->i_lock);
 			requeue_io(inode);
 			continue;
 		}
@@ -491,10 +507,11 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 		 * Was this inode dirtied after sync_sb_inodes was called?
 		 * This keeps sync from extra jobs and livelock.
 		 */
-		if (inode_dirtied_after(inode, wbc->wb_start))
+		if (inode_dirtied_after(inode, wbc->wb_start)) {
+			spin_unlock(&inode->i_lock);
 			return 1;
+		}
 
-		spin_lock(&inode->i_lock);
 		iref_locked(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&wb->b_lock);
@@ -687,7 +704,9 @@ static long wb_writeback(struct bdi_writeback *wb,
 						struct inode, i_io);
 			spin_unlock(&wb->b_lock);
 			trace_wbc_writeback_wait(&wbc, wb->bdi);
+			spin_lock(&inode->i_lock);
 			inode_wait_for_writeback(inode);
+			spin_unlock(&inode->i_lock);
 		}
 		spin_unlock(&inode_lock);
 	}
@@ -953,6 +972,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		block_dump___mark_inode_dirty(inode);
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	if ((inode->i_state & flags) != flags) {
 		const int was_dirty = inode->i_state & I_DIRTY;
 
@@ -964,7 +984,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 * superblock list, based upon its state.
 		 */
 		if (inode->i_state & I_SYNC)
-			goto out;
+			goto out_unlock;
 
 		/*
 		 * Only add valid (hashed) inodes to the superblock's
@@ -972,10 +992,10 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 */
 		if (!S_ISBLK(inode->i_mode)) {
 			if (hlist_bl_unhashed(&inode->i_hash))
-				goto out;
+				goto out_unlock;
 		}
 		if (inode->i_state & I_FREEING)
-			goto out;
+			goto out_unlock;
 
 		/*
 		 * If the inode was already on b_dirty/b_io/b_more_io, don't
@@ -998,12 +1018,16 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 					wakeup_bdi = true;
 			}
 
-			spin_lock(&bdi->wb.b_lock);
 			inode->dirtied_when = jiffies;
+			spin_unlock(&inode->i_lock);
+			spin_lock(&bdi->wb.b_lock);
 			list_move(&inode->i_io, &bdi->wb.b_dirty);
 			spin_unlock(&bdi->wb.b_lock);
+			goto out;
 		}
 	}
+out_unlock:
+	spin_unlock(&inode->i_lock);
 out:
 	spin_unlock(&inode_lock);
 
@@ -1052,12 +1076,15 @@ static void wait_sb_inodes(struct super_block *sb)
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		struct address_space *mapping;
 
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
-			continue;
+		spin_lock(&inode->i_lock);
 		mapping = inode->i_mapping;
-		if (mapping->nrpages == 0)
+		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+		    (mapping->nrpages == 0)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 		iref_locked(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb->s_inodes_lock);
 		spin_unlock(&inode_lock);
 		/*
diff --git a/fs/inode.c b/fs/inode.c
index 4ad7900..d3bd08a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -30,7 +30,7 @@
  * Locking rules.
  *
  * inode->i_lock protects:
- *   i_ref
+ *   i_ref i_state
  * inode_hash_bucket lock protects:
  *   inode hash table, i_hash
  * sb inode lock protects:
@@ -182,7 +182,7 @@ int proc_nr_inodes(ctl_table *table, int write,
 static void wake_up_inode(struct inode *inode)
 {
 	/*
-	 * Prevent speculative execution through spin_unlock(&inode_lock);
+	 * Prevent speculative execution through spin_unlock(&inode->i_lock);
 	 */
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_NEW);
@@ -361,6 +361,8 @@ static void init_once(void *foo)
  */
 void iref_locked(struct inode *inode)
 {
+	assert_spin_locked(&inode->i_lock);
+
 	inode->i_ref++;
 }
 EXPORT_SYMBOL_GPL(iref_locked);
@@ -484,7 +486,9 @@ void end_writeback(struct inode *inode)
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
 	inode_sync_wait(inode);
+	spin_lock(&inode->i_lock);
 	inode->i_state = I_FREEING | I_CLEAR;
+	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(end_writeback);
 
@@ -561,17 +565,18 @@ static int invalidate_list(struct super_block *sb, struct list_head *head,
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
 			struct backing_dev_info *bdi = inode_to_bdi(inode);
 
-			spin_unlock(&inode->i_lock);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
-
+			spin_unlock(&inode->i_lock);
 
 			/*
 			 * move the inode off the IO lists and LRU once
@@ -625,11 +630,12 @@ EXPORT_SYMBOL(invalidate_inodes);
 
 static int can_unuse(struct inode *inode)
 {
+	assert_spin_locked(&inode->i_lock);
 	if (inode->i_state)
 		return 0;
 	if (inode_has_buffers(inode))
 		return 0;
-	if (iref_read(inode))
+	if (inode->i_ref)
 		return 0;
 	if (inode->i_data.nrpages)
 		return 0;
@@ -675,9 +681,9 @@ static void prune_icache(int nr_to_scan)
 			continue;
 		}
 		if (inode->i_state & I_REFERENCED) {
+			inode->i_state &= ~I_REFERENCED;
 			spin_unlock(&inode->i_lock);
 			list_move(&inode->i_lru, &inode_lru);
-			inode->i_state &= ~I_REFERENCED;
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
@@ -691,6 +697,7 @@ static void prune_icache(int nr_to_scan)
 			iput(inode);
 			spin_lock(&inode_lock);
 			spin_lock(&inode_lru_lock);
+			spin_lock(&inode->i_lock);
 
 			/*
 			 * if we can't reclaim this inod immediately, give it
@@ -699,12 +706,14 @@ static void prune_icache(int nr_to_scan)
 			 */
 			if (!can_unuse(inode)) {
 				list_move(&inode->i_lru, &inode_lru);
+				spin_unlock(&inode->i_lock);
 				continue;
 			}
-		} else
-			spin_unlock(&inode->i_lock);
+		}
+
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
+		spin_unlock(&inode->i_lock);
 
 		/*
 		 * move the inode off the IO lists and LRU once
@@ -761,7 +770,7 @@ static struct shrinker icache_shrinker = {
 
 static void __wait_on_freeing_inode(struct inode *inode);
 /*
- * Called with the inode lock held.
+ * Returns with inode->i_lock held.
  * NOTE: we are not increasing the inode-refcount, you must call iref_locked()
  * by hand after calling find_inode now! This simplifies iunique and won't
  * add any additional branch in the common code.
@@ -779,8 +788,11 @@ repeat:
 	hlist_bl_for_each_entry(inode, node, &b->head, i_hash) {
 		if (inode->i_sb != sb)
 			continue;
-		if (!test(inode, data))
+		spin_lock(&inode->i_lock);
+		if (!test(inode, data)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
 			spin_unlock_bucket(b);
 			__wait_on_freeing_inode(inode);
@@ -810,6 +822,7 @@ repeat:
 			continue;
 		if (inode->i_sb != sb)
 			continue;
+		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
 			spin_unlock_bucket(b);
 			__wait_on_freeing_inode(inode);
@@ -884,9 +897,9 @@ struct inode *new_inode(struct super_block *sb)
 	inode = alloc_inode(sb);
 	if (inode) {
 		spin_lock(&inode_lock);
-		__inode_add_to_lists(sb, NULL, inode);
 		inode->i_ino = ++last_ino;
 		inode->i_state = 0;
+		__inode_add_to_lists(sb, NULL, inode);
 		spin_unlock(&inode_lock);
 	}
 	return inode;
@@ -953,8 +966,8 @@ static struct inode *get_new_inode(struct super_block *sb,
 			if (set(inode, data))
 				goto set_failed;
 
-			__inode_add_to_lists(sb, b, inode);
 			inode->i_state = I_NEW;
+			__inode_add_to_lists(sb, b, inode);
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -968,7 +981,6 @@ static struct inode *get_new_inode(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		spin_lock(&old->i_lock);
 		iref_locked(old);
 		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
@@ -1017,7 +1029,6 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		spin_lock(&old->i_lock);
 		iref_locked(old);
 		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
@@ -1071,17 +1082,19 @@ EXPORT_SYMBOL(iunique);
 struct inode *igrab(struct inode *inode)
 {
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	if (!(inode->i_state & (I_FREEING|I_WILL_FREE))) {
-		spin_lock(&inode->i_lock);
 		iref_locked(inode);
 		spin_unlock(&inode->i_lock);
-	} else
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
@@ -1116,7 +1129,6 @@ static struct inode *ifind(struct super_block *sb,
 	spin_lock(&inode_lock);
 	inode = find_inode(sb, b, test, data);
 	if (inode) {
-		spin_lock(&inode->i_lock);
 		iref_locked(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
@@ -1152,7 +1164,6 @@ static struct inode *ifind_fast(struct super_block *sb,
 	spin_lock(&inode_lock);
 	inode = find_inode_fast(sb, b, ino);
 	if (inode) {
-		spin_lock(&inode->i_lock);
 		iref_locked(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
@@ -1318,6 +1329,10 @@ int insert_inode_locked(struct inode *inode)
 	ino_t ino = inode->i_ino;
 	struct inode_hash_bucket *b = inode_hashtable + hash(sb, ino);
 
+	/*
+	 * Nobody else can see the new inode yet, so it is safe to set flags
+	 * without locking here.
+	 */
 	inode->i_state |= I_NEW;
 	while (1) {
 		struct hlist_bl_node *node;
@@ -1329,8 +1344,11 @@ int insert_inode_locked(struct inode *inode)
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
@@ -1339,7 +1357,6 @@ int insert_inode_locked(struct inode *inode)
 			spin_unlock(&inode_lock);
 			return 0;
 		}
-		spin_lock(&old->i_lock);
 		iref_locked(old);
 		spin_unlock(&old->i_lock);
 		spin_unlock_bucket(b);
@@ -1373,8 +1390,11 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
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
@@ -1383,7 +1403,6 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 			spin_unlock(&inode_lock);
 			return 0;
 		}
-		spin_lock(&old->i_lock);
 		iref_locked(old);
 		spin_unlock(&old->i_lock);
 		spin_unlock_bucket(b);
@@ -1433,6 +1452,8 @@ static void iput_final(struct inode *inode)
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	int drop;
 
+	assert_spin_locked(&inode->i_lock);
+
 	if (op && op->drop_inode)
 		drop = op->drop_inode(inode);
 	else
@@ -1443,22 +1464,28 @@ static void iput_final(struct inode *inode)
 			inode->i_state |= I_REFERENCED;
 			if (!(inode->i_state & (I_DIRTY|I_SYNC)) &&
 			    list_empty(&inode->i_lru)) {
+				spin_unlock(&inode->i_lock);
 				inode_lru_list_add(inode);
+				return;
 			}
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
+		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
 		__remove_inode_hash(inode);
 	}
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
+	spin_unlock(&inode->i_lock);
 
 	/*
 	 * move the inode off the IO lists and LRU once I_FREEING is set so
@@ -1495,13 +1522,12 @@ static void iput_final(struct inode *inode)
 void iput(struct inode *inode)
 {
 	if (inode) {
-		BUG_ON(inode->i_state & I_CLEAR);
-
 		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
+		BUG_ON(inode->i_state & I_CLEAR);
+
 		inode->i_ref--;
 		if (inode->i_ref == 0) {
-			spin_unlock(&inode->i_lock);
 			iput_final(inode);
 			return;
 		}
@@ -1687,6 +1713,8 @@ EXPORT_SYMBOL(inode_wait);
  * wake_up_inode() after removing from the hash list will DTRT.
  *
  * This is called with inode_lock held.
+ *
+ * Called with i_lock held and returns with it dropped.
  */
 static void __wait_on_freeing_inode(struct inode *inode)
 {
@@ -1694,6 +1722,7 @@ static void __wait_on_freeing_inode(struct inode *inode)
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
index 3389ff0..8a05213 100644
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
 		 * If the inode is not referenced, the inode cannot have any
@@ -258,9 +261,10 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		 * actually evict all unreferenced inodes from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
-		spin_lock(&inode->i_lock);
-		if (!inode->i_ref)
+		if (!inode->i_ref) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 
 		need_iput_tmp = need_iput;
 		need_iput = NULL;
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index b7cbc41..c7b5fc6 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -899,18 +899,20 @@ static void add_dquot_ref(struct super_block *sb, int type)
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
 
 		iref_locked(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb->s_inodes_lock);
 		spin_unlock(&inode_lock);
 
-- 
1.7.1

