Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab0JUNWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:22:45 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:11481 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757940Ab0JUNWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:22:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoAGAGfav0x5LdoFgWdsb2JhbACUZ4xxFgEBFiIiwC+CeAGCUQSKTQ
Message-Id: <20101021131016.209854187@kernel.dk>
User-Agent: quilt/0.48-1
Date: Fri, 22 Oct 2010 00:08:32 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk
Subject: [patch 03/14] fs: icache lock inodes icache state
References: <20101021130829.442910807@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where inode_lock is currently used, add protection of the icache state of a
single inode with i_lock. This includes inode fields and membership on
icache data structures.

This means that once i_lock is held, inode_lock can be lifted without
introducing any new concurrency.

Before i_lock is held, ie. when searching icache data structures for an
inode, inode_lock can now be split into several independent locks.

spin_lock(&inode_lock)
for_each_inode_in_hash() {
	/*
	 * hash membership is invariant
	 * as are all other properties of the inode and membership (or
	 * lack of) in other data structures at a point in time when it
	 * is on the hash.
	 */
}

If we don't have i_lock, then we can't retain the same concurrency
invariants:

spin_lock(&inode_hash_lock)
for_each_inode_in_hash() {
	/*
	 * hash membership is invariant
	 * nothing else is, except what depends on hash membership.
	 */
}

Wheras if we take i_lock in the hash search (with inode_hash_lock held),
then we have our hash membership invariant, and the i_lock gives all the
other invariants of inode_lock.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/drop_caches.c       |   12 +++-
 fs/fs-writeback.c      |   35 +++++++++++--
 fs/inode.c             |  127 +++++++++++++++++++++++++++++++++++++------------
 fs/notify/inode_mark.c |   25 ++++++---
 fs/quota/dquot.c       |   30 +++++++++--
 5 files changed, 176 insertions(+), 53 deletions(-)

Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/drop_caches.c	2010-10-21 23:50:45.000000000 +1100
@@ -18,11 +18,17 @@ static void drop_pagecache_sb(struct sup
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
+			spin_unlock(&inode->i_lock);
 			continue;
-		if (inode->i_mapping->nrpages == 0)
+		}
+		if (inode->i_mapping->nrpages == 0) {
+			spin_unlock(&inode->i_lock);
 			continue;
-		inode_get(inode);
+		}
+		inode_get_ilock(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-21 23:50:45.000000000 +1100
@@ -288,10 +288,12 @@ static void inode_wait_for_writeback(str
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
 
@@ -345,6 +347,7 @@ writeback_single_inode(struct inode *ino
 	/* Set I_SYNC, reset I_DIRTY_PAGES */
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY_PAGES;
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 
 	ret = do_writepages(mapping, wbc);
@@ -366,8 +369,10 @@ writeback_single_inode(struct inode *ino
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
@@ -377,6 +382,7 @@ writeback_single_inode(struct inode *ino
 	}
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
 		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
@@ -487,7 +493,9 @@ static int writeback_sb_inodes(struct su
 			return 0;
 		}
 
+		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_NEW | I_WILL_FREE)) {
+			spin_unlock(&inode->i_lock);
 			requeue_io(inode);
 			continue;
 		}
@@ -495,11 +503,13 @@ static int writeback_sb_inodes(struct su
 		 * Was this inode dirtied after sync_sb_inodes was called?
 		 * This keeps sync from extra jobs and livelock.
 		 */
-		if (inode_dirtied_after(inode, wbc->wb_start))
+		if (inode_dirtied_after(inode, wbc->wb_start)) {
+			spin_unlock(&inode->i_lock);
 			return 1;
+		}
 
 		BUG_ON(inode->i_state & I_FREEING);
-		inode_get(inode);
+		inode_get_ilock(inode);
 		pages_skipped = wbc->pages_skipped;
 		writeback_single_inode(inode, wbc);
 		if (wbc->pages_skipped != pages_skipped) {
@@ -509,6 +519,7 @@ static int writeback_sb_inodes(struct su
 			 */
 			redirty_tail(inode);
 		}
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		iput(inode);
 		cond_resched();
@@ -944,6 +955,7 @@ void __mark_inode_dirty(struct inode *in
 		block_dump___mark_inode_dirty(inode);
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	if ((inode->i_state & flags) != flags) {
 		const int was_dirty = inode->i_state & I_DIRTY;
 
@@ -994,6 +1006,7 @@ void __mark_inode_dirty(struct inode *in
 		}
 	}
 out:
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 
 	if (wakeup_bdi)
@@ -1040,12 +1053,18 @@ static void wait_sb_inodes(struct super_
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		struct address_space *mapping;
 
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 		mapping = inode->i_mapping;
-		if (mapping->nrpages == 0)
+		if (mapping->nrpages == 0) {
+			spin_unlock(&inode->i_lock);
 			continue;
-		inode_get(inode);
+		}
+		inode_get_ilock(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		/*
 		 * We hold a reference to 'inode' so it couldn't have
@@ -1169,7 +1188,9 @@ int write_inode_now(struct inode *inode,
 
 	might_sleep();
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	ret = writeback_single_inode(inode, &wbc);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	if (sync)
 		inode_sync_wait(inode);
@@ -1193,7 +1214,9 @@ int sync_inode(struct inode *inode, stru
 	int ret;
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	ret = writeback_single_inode(inode, wbc);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	return ret;
 }
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-21 23:50:46.000000000 +1100
@@ -33,6 +33,10 @@
  *   everything
  * inode->i_lock protects:
  *   i_count
+ *   i_state
+ *   i_hash
+ *   i_list
+ *   i_sb_list
  *
  * Ordering:
  * inode_lock
@@ -381,8 +385,10 @@ static void dispose_list(struct list_hea
 		evict(inode);
 
 		spin_lock(&inode_lock);
+		spin_lock(&inode->i_lock);
 		hlist_del_init(&inode->i_hash);
 		list_del_init(&inode->i_sb_list);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 
 		wake_up_inode(inode);
@@ -419,16 +425,21 @@ static int invalidate_list(struct list_h
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
 		if (!inode->i_count) {
 			list_move(&inode->i_list, dispose);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			count++;
+			spin_unlock(&inode->i_lock);
 			continue;
 		}
+		spin_unlock(&inode->i_lock);
 		busy = 1;
 	}
 	/* only unused inodes may be cached with i_count zero */
@@ -505,28 +516,37 @@ static void prune_icache(int nr_to_scan)
 
 		inode = list_entry(inode_unused.prev, struct inode, i_list);
 
+		spin_lock(&inode->i_lock);
 		if (inode->i_state || inode->i_count) {
 			list_move(&inode->i_list, &inode_unused);
+			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
-			inode_get(inode);
+			inode_get_ilock(inode);
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
 								0, -1);
 			iput(inode);
 			spin_lock(&inode_lock);
+			spin_lock(&inode->i_lock);
 
 			if (inode != list_entry(inode_unused.next,
-						struct inode, i_list))
+						struct inode, i_list)) {
+				spin_unlock(&inode->i_lock);
 				continue;	/* wrong inode or list_empty */
-			if (!can_unuse(inode))
+			}
+			if (!can_unuse(inode)) {
+				spin_unlock(&inode->i_lock);
 				continue;
+			}
 		}
 		list_move(&inode->i_list, &freeable);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
+		spin_unlock(&inode->i_lock);
 		nr_pruned++;
 	}
 	inodes_stat.nr_unused -= nr_pruned;
@@ -590,6 +610,7 @@ static struct inode *find_inode(struct s
 			continue;
 		if (!test(inode, data))
 			continue;
+		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
 			__wait_on_freeing_inode(inode);
 			goto repeat;
@@ -615,6 +636,7 @@ static struct inode *find_inode_fast(str
 			continue;
 		if (inode->i_sb != sb)
 			continue;
+		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
 			__wait_on_freeing_inode(inode);
 			goto repeat;
@@ -662,7 +684,9 @@ void inode_add_to_lists(struct super_blo
 	struct hlist_head *head = inode_hashtable + hash(sb, inode->i_ino);
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	__inode_add_to_lists(sb, head, inode);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL_GPL(inode_add_to_lists);
@@ -694,9 +718,11 @@ struct inode *new_inode(struct super_blo
 	inode = alloc_inode(sb);
 	if (inode) {
 		spin_lock(&inode_lock);
-		__inode_add_to_lists(sb, NULL, inode);
+		spin_lock(&inode->i_lock);
 		inode->i_ino = ++last_ino;
 		inode->i_state = 0;
+		__inode_add_to_lists(sb, NULL, inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 	}
 	return inode;
@@ -763,8 +789,10 @@ static struct inode *get_new_inode(struc
 			if (set(inode, data))
 				goto set_failed;
 
-			__inode_add_to_lists(sb, head, inode);
+			spin_lock(&inode->i_lock);
 			inode->i_state = I_NEW;
+			__inode_add_to_lists(sb, head, inode);
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -778,7 +806,8 @@ static struct inode *get_new_inode(struc
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		inode_get(old);
+		inode_get_ilock(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -809,9 +838,11 @@ static struct inode *get_new_inode_fast(
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
+			spin_lock(&inode->i_lock);
 			inode->i_ino = ino;
-			__inode_add_to_lists(sb, head, inode);
 			inode->i_state = I_NEW;
+			__inode_add_to_lists(sb, head, inode);
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -825,7 +856,8 @@ static struct inode *get_new_inode_fast(
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		inode_get(old);
+		inode_get_ilock(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -867,6 +899,8 @@ ino_t iunique(struct super_block *sb, in
 		res = counter++;
 		head = inode_hashtable + hash(sb, res);
 		inode = find_inode_fast(sb, head, res);
+		if (inode)
+			spin_unlock(&inode->i_lock);
 	} while (inode != NULL);
 	spin_unlock(&inode_lock);
 
@@ -876,18 +910,23 @@ EXPORT_SYMBOL(iunique);
 
 struct inode *igrab(struct inode *inode)
 {
+	struct inode *ret = inode;
+
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	if (!(inode->i_state & (I_FREEING|I_WILL_FREE)))
-		inode_get(inode);
+		inode_get_ilock(inode);
 	else
 		/*
 		 * Handle the case where s_op->clear_inode is not been
 		 * called yet, and somebody is calling igrab
 		 * while the inode is getting freed.
 		 */
-		inode = NULL;
+		ret = NULL;
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
-	return inode;
+
+	return ret;
 }
 EXPORT_SYMBOL(igrab);
 
@@ -919,7 +958,8 @@ static struct inode *ifind(struct super_
 	spin_lock(&inode_lock);
 	inode = find_inode(sb, head, test, data);
 	if (inode) {
-		inode_get(inode);
+		inode_get_ilock(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
@@ -952,7 +992,8 @@ static struct inode *ifind_fast(struct s
 	spin_lock(&inode_lock);
 	inode = find_inode_fast(sb, head, ino);
 	if (inode) {
-		inode_get(inode);
+		inode_get_ilock(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(inode);
 		return inode;
@@ -1126,16 +1167,22 @@ int insert_inode_locked(struct inode *in
 				continue;
 			if (old->i_sb != sb)
 				continue;
-			if (old->i_state & (I_FREEING|I_WILL_FREE))
+			spin_lock(&old->i_lock);
+			if (old->i_state & (I_FREEING|I_WILL_FREE)) {
+				spin_unlock(&old->i_lock);
 				continue;
-			break;
+			}
+			goto found_old;
 		}
-		if (likely(!node)) {
-			hlist_add_head(&inode->i_hash, head);
-			spin_unlock(&inode_lock);
-			return 0;
-		}
-		inode_get(old);
+		spin_lock(&inode->i_lock);
+		hlist_add_head(&inode->i_hash, head);
+		spin_unlock(&inode->i_lock);
+		spin_unlock(&inode_lock);
+		return 0;
+
+found_old:
+		inode_get_ilock(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
@@ -1165,16 +1212,22 @@ int insert_inode_locked4(struct inode *i
 				continue;
 			if (!test(old, data))
 				continue;
-			if (old->i_state & (I_FREEING|I_WILL_FREE))
+			spin_lock(&old->i_lock);
+			if (old->i_state & (I_FREEING|I_WILL_FREE)) {
+				spin_unlock(&old->i_lock);
 				continue;
-			break;
-		}
-		if (likely(!node)) {
-			hlist_add_head(&inode->i_hash, head);
-			spin_unlock(&inode_lock);
-			return 0;
+			}
+			goto found_old;
 		}
-		inode_get(old);
+		spin_lock(&inode->i_lock);
+		hlist_add_head(&inode->i_hash, head);
+		spin_unlock(&inode->i_lock);
+		spin_unlock(&inode_lock);
+		return 0;
+
+found_old:
+		inode_get_ilock(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
@@ -1198,7 +1251,9 @@ void __insert_inode_hash(struct inode *i
 {
 	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	hlist_add_head(&inode->i_hash, head);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
@@ -1212,7 +1267,9 @@ EXPORT_SYMBOL(__insert_inode_hash);
 void remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(remove_inode_hash);
@@ -1260,14 +1317,17 @@ static void iput_final(struct inode *ino
 			list_move(&inode->i_list, &inode_unused);
 		inodes_stat.nr_unused++;
 		if (sb->s_flags & MS_ACTIVE) {
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
 		inodes_stat.nr_unused--;
@@ -1278,10 +1338,13 @@ static void iput_final(struct inode *ino
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	inodes_stat.nr_inodes--;
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	evict(inode);
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	wake_up_inode(inode);
 	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
@@ -1307,7 +1370,6 @@ void iput(struct inode *inode)
 		spin_lock(&inode->i_lock);
 		inode->i_count--;
 		if (inode->i_count == 0) {
-			spin_unlock(&inode->i_lock);
 			iput_final(inode);
 		} else {
 			spin_unlock(&inode->i_lock);
@@ -1493,6 +1555,8 @@ EXPORT_SYMBOL(inode_wait);
  * wake_up_inode() after removing from the hash list will DTRT.
  *
  * This is called with inode_lock held.
+ *
+ * Called with i_lock held and returns with it dropped.
  */
 static void __wait_on_freeing_inode(struct inode *inode)
 {
@@ -1500,6 +1564,7 @@ static void __wait_on_freeing_inode(stru
 	DEFINE_WAIT_BIT(wait, &inode->i_state, __I_NEW);
 	wq = bit_waitqueue(&inode->i_state, __I_NEW);
 	prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	schedule();
 	finish_wait(wq, &wait.wait);
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/quota/dquot.c	2010-10-21 23:50:45.000000000 +1100
@@ -246,6 +246,7 @@ struct dqstats dqstats;
 EXPORT_SYMBOL(dqstats);
 
 static qsize_t inode_get_rsv_space(struct inode *inode);
+static qsize_t __inode_get_rsv_space(struct inode *inode);
 static void __dquot_initialize(struct inode *inode, int type);
 
 static inline unsigned int
@@ -898,18 +899,26 @@ static void add_dquot_ref(struct super_b
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 #ifdef CONFIG_QUOTA_DEBUG
-		if (unlikely(inode_get_rsv_space(inode) > 0))
+		if (unlikely(__inode_get_rsv_space(inode) > 0))
 			reserved = 1;
 #endif
-		if (!atomic_read(&inode->i_writecount))
+		if (!atomic_read(&inode->i_writecount)) {
+			spin_unlock(&inode->i_lock);
 			continue;
-		if (!dqinit_needed(inode, type))
+		}
+		if (!dqinit_needed(inode, type)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 
-		inode_get(inode);
+		inode_get_ilock(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 
 		iput(old_inode);
@@ -1488,6 +1497,17 @@ void inode_sub_rsv_space(struct inode *i
 }
 EXPORT_SYMBOL(inode_sub_rsv_space);
 
+/* no i_lock variant of inode_get_rsv_space */
+static qsize_t __inode_get_rsv_space(struct inode *inode)
+{
+	qsize_t ret;
+
+	if (!inode->i_sb->dq_op->get_reserved_space)
+		return 0;
+	ret = *inode_reserved_space(inode);
+	return ret;
+}
+
 static qsize_t inode_get_rsv_space(struct inode *inode)
 {
 	qsize_t ret;
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/notify/inode_mark.c	2010-10-21 23:50:46.000000000 +1100
@@ -248,8 +248,11 @@ void fsnotify_unmount_inodes(struct list
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
@@ -257,24 +260,30 @@ void fsnotify_unmount_inodes(struct list
 		 * evict all inodes with zero i_count from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
-		if (!inode->i_count)
+		if (!inode->i_count) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 
 		need_iput_tmp = need_iput;
 		need_iput = NULL;
 
 		/* In case fsnotify_inode_delete() drops a reference. */
 		if (inode != need_iput_tmp)
-			inode_get(inode);
+			inode_get_ilock(inode);
 		else
 			need_iput_tmp = NULL;
+		spin_unlock(&inode->i_lock);
 
 		/* In case the dropping of a reference would nuke next_i. */
-		if ((&next_i->i_sb_list != list) &&
-		    next_i->i_count &&
-		    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
-			inode_get(next_i);
-			need_iput = next_i;
+		if ((&next_i->i_sb_list != list)) {
+			spin_lock(&next_i->i_lock);
+			if (next_i->i_count &&
+			    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
+				inode_get_ilock(next_i);
+				need_iput = next_i;
+			}
+			spin_unlock(&next_i->i_lock);
 		}
 
 		/*


