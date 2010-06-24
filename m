Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab0FXD02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:26:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:48474 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab0FXDPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:53 -0400
Message-Id: <20100624030730.094326462@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:40 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 28/52] fs: icache lock i_state
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect i_state updates with i_lock

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/drop_caches.c  |    9 ++++--
 fs/fs-writeback.c |   37 +++++++++++++++++++-----
 fs/inode.c        |   81 ++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/nilfs2/gcdat.c |    1 
 fs/quota/dquot.c  |   14 +++++++--
 5 files changed, 117 insertions(+), 25 deletions(-)

Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c
+++ linux-2.6/fs/drop_caches.c
@@ -19,11 +19,14 @@ static void drop_pagecache_sb(struct sup
 	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
-			continue;
-		if (inode->i_mapping->nrpages == 0)
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW)
+				|| inode->i_mapping->nrpages == 0) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -398,10 +398,12 @@ static void inode_wait_for_writeback(str
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
 
@@ -455,6 +457,7 @@ writeback_single_inode(struct inode *ino
 	/* Set I_SYNC, reset I_DIRTY_PAGES */
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY_PAGES;
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 
 	ret = do_writepages(mapping, wbc);
@@ -476,8 +479,10 @@ writeback_single_inode(struct inode *ino
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
@@ -487,6 +492,7 @@ writeback_single_inode(struct inode *ino
 	}
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
 		if ((inode->i_state & I_DIRTY_PAGES) && wbc->for_kupdate) {
@@ -630,7 +636,9 @@ static int writeback_sb_inodes(struct su
 		if (sb != inode->i_sb)
 			/* finish with this superblock */
 			return 0;
+		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_NEW | I_WILL_FREE)) {
+			spin_unlock(&inode->i_lock);
 			requeue_io(inode);
 			continue;
 		}
@@ -638,8 +646,10 @@ static int writeback_sb_inodes(struct su
 		 * Was this inode dirtied after sync_sb_inodes was called?
 		 * This keeps sync from extra jobs and livelock.
 		 */
-		if (inode_dirtied_after(inode, wbc->wb_start))
+		if (inode_dirtied_after(inode, wbc->wb_start)) {
+			spin_unlock(&inode->i_lock);
 			return 1;
+		}
 
 		BUG_ON(inode->i_state & (I_FREEING | I_CLEAR));
 		__iget(inode);
@@ -652,6 +662,7 @@ static int writeback_sb_inodes(struct su
 			 */
 			redirty_tail(inode);
 		}
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		iput(inode);
 		cond_resched();
@@ -1090,6 +1101,7 @@ void __mark_inode_dirty(struct inode *in
 		block_dump___mark_inode_dirty(inode);
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	if ((inode->i_state & flags) != flags) {
 		const int was_dirty = inode->i_state & I_DIRTY;
 
@@ -1134,6 +1146,7 @@ void __mark_inode_dirty(struct inode *in
 		}
 	}
 out:
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(__mark_inode_dirty);
@@ -1178,12 +1191,17 @@ static void wait_sb_inodes(struct super_
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		struct address_space *mapping;
 
-		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
-			continue;
 		mapping = inode->i_mapping;
 		if (mapping->nrpages == 0)
 			continue;
+
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW)) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 		/*
@@ -1287,7 +1305,9 @@ int write_inode_now(struct inode *inode,
 
 	might_sleep();
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	ret = writeback_single_inode(inode, &wbc);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	if (sync)
 		inode_sync_wait(inode);
@@ -1311,7 +1331,9 @@ int sync_inode(struct inode *inode, stru
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
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -32,10 +32,13 @@
  *   s_inodes, i_sb_list
  * inode_hash_lock protects:
  *   inode hash table, i_hash
+ * inode->i_lock protects:
+ *   i_state
  *
  * Ordering:
  * inode_lock
  *   sb_inode_list_lock
+ *     inode->i_lock
  * inode_lock
  *   inode_hash_lock
  */
@@ -301,6 +304,8 @@ static void init_once(void *foo)
  */
 void __iget(struct inode *inode)
 {
+	assert_spin_locked(&inode->i_lock);
+
 	if (atomic_inc_return(&inode->i_count) != 1)
 		return;
 
@@ -401,16 +406,21 @@ static int invalidate_list(struct list_h
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
 		if (!atomic_read(&inode->i_count)) {
 			list_move(&inode->i_list, dispose);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
+			spin_unlock(&inode->i_lock);
 			count++;
 			continue;
 		}
+		spin_unlock(&inode->i_lock);
 		busy = 1;
 	}
 	/* only unused inodes may be cached with i_count zero */
@@ -490,12 +500,15 @@ static void prune_icache(int nr_to_scan)
 
 		inode = list_entry(inode_unused.prev, struct inode, i_list);
 
+		spin_lock(&inode->i_lock);
 		if (inode->i_state || atomic_read(&inode->i_count)) {
 			list_move(&inode->i_list, &inode_unused);
+			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
 			__iget(inode);
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
@@ -506,12 +519,16 @@ static void prune_icache(int nr_to_scan)
 			if (inode != list_entry(inode_unused.next,
 						struct inode, i_list))
 				continue;	/* wrong inode or list_empty */
-			if (!can_unuse(inode))
+			spin_lock(&inode->i_lock);
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
@@ -574,8 +591,14 @@ repeat:
 	hlist_for_each_entry(inode, node, head, i_hash) {
 		if (inode->i_sb != sb)
 			continue;
-		if (!test(inode, data))
+		if (!spin_trylock(&inode->i_lock)) {
+			spin_unlock(&inode_hash_lock);
+			goto repeat;
+		}
+		if (!test(inode, data)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)) {
 			spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
@@ -604,6 +627,10 @@ repeat:
 			continue;
 		if (inode->i_sb != sb)
 			continue;
+		if (!spin_trylock(&inode->i_lock)) {
+			spin_unlock(&inode_hash_lock);
+			goto repeat;
+		}
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)) {
 			spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
@@ -630,10 +657,10 @@ __inode_add_to_lists(struct super_block
 			struct inode *inode)
 {
 	inodes_stat.nr_inodes++;
-	list_add(&inode->i_list, &inode_in_use);
 	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
+	list_add(&inode->i_list, &inode_in_use);
 	if (head) {
 		spin_lock(&inode_hash_lock);
 		hlist_add_head(&inode->i_hash, head);
@@ -690,9 +717,9 @@ struct inode *new_inode(struct super_blo
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
@@ -759,8 +786,8 @@ static struct inode *get_new_inode(struc
 			if (set(inode, data))
 				goto set_failed;
 
-			__inode_add_to_lists(sb, head, inode);
 			inode->i_state = I_NEW;
+			__inode_add_to_lists(sb, head, inode);
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -775,6 +802,7 @@ static struct inode *get_new_inode(struc
 		 * allocated.
 		 */
 		__iget(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -783,6 +811,7 @@ static struct inode *get_new_inode(struc
 	return inode;
 
 set_failed:
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	destroy_inode(inode);
 	return NULL;
@@ -806,8 +835,8 @@ static struct inode *get_new_inode_fast(
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
 			inode->i_ino = ino;
-			__inode_add_to_lists(sb, head, inode);
 			inode->i_state = I_NEW;
+			__inode_add_to_lists(sb, head, inode);
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -822,6 +851,7 @@ static struct inode *get_new_inode_fast(
 		 * allocated.
 		 */
 		__iget(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -863,6 +893,7 @@ ino_t iunique(struct super_block *sb, in
 		res = counter++;
 		head = inode_hashtable + hash(sb, res);
 		inode = find_inode_fast(sb, head, res);
+		spin_unlock(&inode->i_lock);
 	} while (inode != NULL);
 	spin_unlock(&inode_lock);
 
@@ -872,7 +903,10 @@ EXPORT_SYMBOL(iunique);
 
 struct inode *igrab(struct inode *inode)
 {
+	struct inode *ret = inode;
+
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	if (!(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)))
 		__iget(inode);
 	else
@@ -881,9 +915,11 @@ struct inode *igrab(struct inode *inode)
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
 
@@ -916,6 +952,7 @@ static struct inode *ifind(struct super_
 	inode = find_inode(sb, head, test, data);
 	if (inode) {
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
@@ -949,6 +986,7 @@ static struct inode *ifind_fast(struct s
 	inode = find_inode_fast(sb, head, ino);
 	if (inode) {
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(inode);
 		return inode;
@@ -1118,6 +1156,7 @@ int insert_inode_locked(struct inode *in
 		struct inode *old = NULL;
 
 		spin_lock(&inode_lock);
+repeat:
 		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_ino != ino)
@@ -1126,6 +1165,10 @@ int insert_inode_locked(struct inode *in
 				continue;
 			if (old->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
 				continue;
+			if (!spin_trylock(&old->i_lock)) {
+				spin_unlock(&inode_hash_lock);
+				goto repeat;
+			}
 			break;
 		}
 		if (likely(!node)) {
@@ -1136,6 +1179,7 @@ int insert_inode_locked(struct inode *in
 		}
 		spin_unlock(&inode_hash_lock);
 		__iget(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
@@ -1160,6 +1204,7 @@ int insert_inode_locked4(struct inode *i
 		struct inode *old = NULL;
 
 		spin_lock(&inode_lock);
+repeat:
 		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_sb != sb)
@@ -1168,6 +1213,10 @@ int insert_inode_locked4(struct inode *i
 				continue;
 			if (old->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
 				continue;
+			if (!spin_trylock(&old->i_lock)) {
+				spin_unlock(&inode_hash_lock);
+				goto repeat;
+			}
 			break;
 		}
 		if (likely(!node)) {
@@ -1178,6 +1227,7 @@ int insert_inode_locked4(struct inode *i
 		}
 		spin_unlock(&inode_hash_lock);
 		__iget(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
@@ -1240,12 +1290,14 @@ void generic_delete_inode(struct inode *
 {
 	const struct super_operations *op = inode->i_sb->s_op;
 
-	list_del_init(&inode->i_list);
 	spin_lock(&sb_inode_list_lock);
+	spin_lock(&inode->i_lock);
+	list_del_init(&inode->i_list);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
+	spin_unlock(&inode->i_lock);
 	inodes_stat.nr_inodes--;
 	spin_unlock(&inode_lock);
 
@@ -1284,19 +1336,27 @@ int generic_detach_inode(struct inode *i
 {
 	struct super_block *sb = inode->i_sb;
 
+	spin_lock(&sb_inode_list_lock);
+	spin_lock(&inode->i_lock);
 	if (!hlist_unhashed(&inode->i_hash)) {
 		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			list_move(&inode->i_list, &inode_unused);
 		inodes_stat.nr_unused++;
 		if (sb->s_flags & MS_ACTIVE) {
+			spin_unlock(&inode->i_lock);
+			spin_unlock(&sb_inode_list_lock);
 			spin_unlock(&inode_lock);
 			return 0;
 		}
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
+		spin_unlock(&inode->i_lock);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 		write_inode_now(inode, 1);
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
+		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
 		inodes_stat.nr_unused--;
@@ -1305,12 +1365,12 @@ int generic_detach_inode(struct inode *i
 		spin_unlock(&inode_hash_lock);
 	}
 	list_del_init(&inode->i_list);
-	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	inodes_stat.nr_inodes--;
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	return 1;
 }
@@ -1558,6 +1618,8 @@ EXPORT_SYMBOL(inode_wait);
  * wake_up_inode() after removing from the hash list will DTRT.
  *
  * This is called with inode_lock held.
+ *
+ * Called with i_lock held and returns with it dropped.
  */
 static void __wait_on_freeing_inode(struct inode *inode)
 {
@@ -1565,6 +1627,7 @@ static void __wait_on_freeing_inode(stru
 	DEFINE_WAIT_BIT(wait, &inode->i_state, __I_NEW);
 	wq = bit_waitqueue(&inode->i_state, __I_NEW);
 	prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	schedule();
 	finish_wait(wq, &wait.wait);
Index: linux-2.6/fs/nilfs2/gcdat.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/gcdat.c
+++ linux-2.6/fs/nilfs2/gcdat.c
@@ -27,6 +27,7 @@
 #include "page.h"
 #include "mdt.h"
 
+/* XXX: what protects i_state? */
 int nilfs_init_gcdat_inode(struct the_nilfs *nilfs)
 {
 	struct inode *dat = nilfs->ns_dat, *gcdat = nilfs->ns_gc_dat;
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c
+++ linux-2.6/fs/quota/dquot.c
@@ -886,18 +886,26 @@ static void add_dquot_ref(struct super_b
 	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 #ifdef CONFIG_QUOTA_DEBUG
 		if (unlikely(inode_get_rsv_space(inode) > 0))
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
 
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 


