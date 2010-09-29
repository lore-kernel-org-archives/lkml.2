Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0I2MVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:21:49 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:57254 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755613Ab0I2MT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:29 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/17] fs: icache lock i_state
Date: Wed, 29 Sep 2010 22:18:36 +1000
Message-Id: <1285762729-17928-5-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

We currently protect the per-inode state flags with the inode_lock.
Using a global lock to protect per-object state is overkill when we
coul duse a per-inode lock to protect the state.  Use the
inode->i_lock for this, and wrap all the state changes and checks
with the inode->i_lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/drop_caches.c  |    9 ++++--
 fs/fs-writeback.c |   29 +++++++++++++++--
 fs/inode.c        |   86 +++++++++++++++++++++++++++++++++++++++++++++-------
 fs/nilfs2/gcdat.c |    1 +
 fs/quota/dquot.c  |   12 ++++---
 5 files changed, 113 insertions(+), 24 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index ab69ae7..45bdf88 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -19,11 +19,14 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
-			continue;
-		if (inode->i_mapping->nrpages == 0)
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)
+				|| inode->i_mapping->nrpages == 0) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 9adc9d9..7bd1aef 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -280,10 +280,12 @@ static void inode_wait_for_writeback(struct inode *inode)
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
 
@@ -337,6 +339,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	/* Set I_SYNC, reset I_DIRTY_PAGES */
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY_PAGES;
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 
 	ret = do_writepages(mapping, wbc);
@@ -358,8 +361,10 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
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
@@ -369,6 +374,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	}
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
 		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
@@ -479,7 +485,9 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 			return 0;
 		}
 
+		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_NEW | I_WILL_FREE)) {
+			spin_unlock(&inode->i_lock);
 			requeue_io(inode);
 			continue;
 		}
@@ -487,8 +495,10 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 		 * Was this inode dirtied after sync_sb_inodes was called?
 		 * This keeps sync from extra jobs and livelock.
 		 */
-		if (inode_dirtied_after(inode, wbc->wb_start))
+		if (inode_dirtied_after(inode, wbc->wb_start)) {
+			spin_unlock(&inode->i_lock);
 			return 1;
+		}
 
 		BUG_ON(inode->i_state & I_FREEING);
 		__iget(inode);
@@ -501,6 +511,7 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 			 */
 			redirty_tail(inode);
 		}
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		iput(inode);
 		cond_resched();
@@ -936,6 +947,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		block_dump___mark_inode_dirty(inode);
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	if ((inode->i_state & flags) != flags) {
 		const int was_dirty = inode->i_state & I_DIRTY;
 
@@ -986,6 +998,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		}
 	}
 out:
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 
 	if (wakeup_bdi)
@@ -1033,12 +1046,16 @@ static void wait_sb_inodes(struct super_block *sb)
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		struct address_space *mapping;
 
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
-			continue;
 		mapping = inode->i_mapping;
 		if (mapping->nrpages == 0)
 			continue;
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 		/*
@@ -1165,7 +1182,9 @@ int write_inode_now(struct inode *inode, int sync)
 
 	might_sleep();
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	ret = writeback_single_inode(inode, &wbc);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	if (sync)
 		inode_sync_wait(inode);
@@ -1189,7 +1208,9 @@ int sync_inode(struct inode *inode, struct writeback_control *wbc)
 	int ret;
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	ret = writeback_single_inode(inode, wbc);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	return ret;
 }
diff --git a/fs/inode.c b/fs/inode.c
index 9d7ffb1..906a4ad 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -31,10 +31,13 @@
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
@@ -296,6 +299,8 @@ static void init_once(void *foo)
  */
 void __iget(struct inode *inode)
 {
+	assert_spin_locked(&inode->i_lock);
+
 	if (atomic_inc_return(&inode->i_count) != 1)
 		return;
 
@@ -396,16 +401,21 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
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
@@ -484,12 +494,15 @@ static void prune_icache(int nr_to_scan)
 
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
@@ -500,12 +513,16 @@ static void prune_icache(int nr_to_scan)
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
@@ -568,8 +585,14 @@ repeat:
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
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
 			spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
@@ -598,6 +621,10 @@ repeat:
 			continue;
 		if (inode->i_sb != sb)
 			continue;
+		if (!spin_trylock(&inode->i_lock)) {
+			spin_unlock(&inode_hash_lock);
+			goto repeat;
+		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
 			spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
@@ -624,10 +651,10 @@ __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
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
@@ -684,9 +711,9 @@ struct inode *new_inode(struct super_block *sb)
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
@@ -753,8 +780,8 @@ static struct inode *get_new_inode(struct super_block *sb,
 			if (set(inode, data))
 				goto set_failed;
 
-			__inode_add_to_lists(sb, head, inode);
 			inode->i_state = I_NEW;
+			__inode_add_to_lists(sb, head, inode);
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -769,6 +796,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 		 * allocated.
 		 */
 		__iget(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -777,6 +805,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 	return inode;
 
 set_failed:
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	destroy_inode(inode);
 	return NULL;
@@ -800,8 +829,8 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
 			inode->i_ino = ino;
-			__inode_add_to_lists(sb, head, inode);
 			inode->i_state = I_NEW;
+			__inode_add_to_lists(sb, head, inode);
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -816,6 +845,7 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 		 * allocated.
 		 */
 		__iget(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -857,6 +887,7 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 		res = counter++;
 		head = inode_hashtable + hash(sb, res);
 		inode = find_inode_fast(sb, head, res);
+		spin_unlock(&inode->i_lock);
 	} while (inode != NULL);
 	spin_unlock(&inode_lock);
 
@@ -866,18 +897,24 @@ EXPORT_SYMBOL(iunique);
 
 struct inode *igrab(struct inode *inode)
 {
+	struct inode *ret = inode;
+
 	spin_lock(&inode_lock);
-	if (!(inode->i_state & (I_FREEING|I_WILL_FREE)))
+	spin_lock(&inode->i_lock);
+	if (!(inode->i_state & (I_FREEING|I_WILL_FREE))) {
 		__iget(inode);
-	else
+	} else {
 		/*
 		 * Handle the case where s_op->clear_inode is not been
 		 * called yet, and somebody is calling igrab
 		 * while the inode is getting freed.
 		 */
-		inode = NULL;
+		ret = NULL;
+	}
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
-	return inode;
+
+	return ret;
 }
 EXPORT_SYMBOL(igrab);
 
@@ -910,6 +947,7 @@ static struct inode *ifind(struct super_block *sb,
 	inode = find_inode(sb, head, test, data);
 	if (inode) {
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
@@ -943,6 +981,7 @@ static struct inode *ifind_fast(struct super_block *sb,
 	inode = find_inode_fast(sb, head, ino);
 	if (inode) {
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(inode);
 		return inode;
@@ -1112,6 +1151,7 @@ int insert_inode_locked(struct inode *inode)
 		struct inode *old = NULL;
 
 		spin_lock(&inode_lock);
+repeat:
 		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_ino != ino)
@@ -1120,6 +1160,10 @@ int insert_inode_locked(struct inode *inode)
 				continue;
 			if (old->i_state & (I_FREEING|I_WILL_FREE))
 				continue;
+			if (!spin_trylock(&old->i_lock)) {
+				spin_unlock(&inode_hash_lock);
+				goto repeat;
+			}
 			break;
 		}
 		if (likely(!node)) {
@@ -1130,6 +1174,7 @@ int insert_inode_locked(struct inode *inode)
 		}
 		spin_unlock(&inode_hash_lock);
 		__iget(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
@@ -1154,6 +1199,7 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 		struct inode *old = NULL;
 
 		spin_lock(&inode_lock);
+repeat:
 		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_sb != sb)
@@ -1162,6 +1208,10 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 				continue;
 			if (old->i_state & (I_FREEING|I_WILL_FREE))
 				continue;
+			if (!spin_trylock(&old->i_lock)) {
+				spin_unlock(&inode_hash_lock);
+				goto repeat;
+			}
 			break;
 		}
 		if (likely(!node)) {
@@ -1172,6 +1222,7 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 		}
 		spin_unlock(&inode_hash_lock);
 		__iget(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
@@ -1256,19 +1307,27 @@ static void iput_final(struct inode *inode)
 	else
 		drop = generic_drop_inode(inode);
 
+	spin_lock(&sb_inode_list_lock);
+	spin_lock(&inode->i_lock);
 	if (!drop) {
 		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			list_move(&inode->i_list, &inode_unused);
 		inodes_stat.nr_unused++;
 		if (sb->s_flags & MS_ACTIVE) {
+			spin_unlock(&inode->i_lock);
+			spin_unlock(&sb_inode_list_lock);
 			spin_unlock(&inode_lock);
 			return;
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
@@ -1277,12 +1336,12 @@ static void iput_final(struct inode *inode)
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
 	evict(inode);
 	spin_lock(&inode_lock);
@@ -1491,6 +1550,8 @@ EXPORT_SYMBOL(inode_wait);
  * wake_up_inode() after removing from the hash list will DTRT.
  *
  * This is called with inode_lock held.
+ *
+ * Called with i_lock held and returns with it dropped.
  */
 static void __wait_on_freeing_inode(struct inode *inode)
 {
@@ -1498,6 +1559,7 @@ static void __wait_on_freeing_inode(struct inode *inode)
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
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 2e3b913..15f66f1 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -899,18 +899,20 @@ static void add_dquot_ref(struct super_block *sb, int type)
 	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
+		spin_lock(&inode->i_lock);
+		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW) ||
+		    !atomic_read(&inode->i_writecount) ||
+		    !dqinit_needed(inode, type))) {
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
 
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 
-- 
1.7.1

