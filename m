Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0FXDXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:23:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab0FXDQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:16:05 -0400
Message-Id: <20100624030731.109899538@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:46 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 34/52] fs: icache remove inode_lock
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale-7.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the global inode_lock, as it doesn't protect anything.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/buffer.c                 |    2 -
 fs/drop_caches.c            |    4 --
 fs/fs-writeback.c           |   35 ++++-------------------
 fs/hugetlbfs/inode.c        |    2 -
 fs/inode.c                  |   65 ++------------------------------------------
 fs/notify/inode_mark.c      |   14 +++++----
 fs/notify/inotify/inotify.c |   16 ++++++----
 fs/quota/dquot.c            |    6 ----
 include/linux/writeback.h   |    1 
 mm/backing-dev.c            |    4 --
 10 files changed, 30 insertions(+), 119 deletions(-)

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -1144,7 +1144,7 @@ __getblk_slow(struct block_device *bdev,
  * inode list.
  *
  * mark_buffer_dirty() is atomic.  It takes bh->b_page->mapping->private_lock,
- * mapping->tree_lock and the global inode_lock.
+ * and mapping->tree_lock.
  */
 void mark_buffer_dirty(struct buffer_head *bh)
 {
Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c
+++ linux-2.6/fs/drop_caches.c
@@ -16,7 +16,6 @@ static void drop_pagecache_sb(struct sup
 {
 	struct inode *inode, *toput_inode = NULL;
 
-	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
@@ -28,15 +27,12 @@ static void drop_pagecache_sb(struct sup
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
-		spin_unlock(&inode_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
 		toput_inode = inode;
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 	}
 	spin_unlock(&sb_inode_list_lock);
-	spin_unlock(&inode_lock);
 	iput(toput_inode);
 }
 
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -312,7 +312,7 @@ static void requeue_io(struct inode *ino
 static void inode_sync_complete(struct inode *inode)
 {
 	/*
-	 * Prevent speculative execution through spin_unlock(&inode_lock);
+	 * Prevent speculative execution through spin_unlock(&inode->i_lock);
 	 */
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_SYNC);
@@ -404,9 +404,7 @@ static void inode_wait_for_writeback(str
 	while (inode->i_state & I_SYNC) {
 		spin_unlock(&wb_inode_list_lock);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
-		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
 		spin_lock(&wb_inode_list_lock);
 	}
@@ -464,7 +462,6 @@ writeback_single_inode(struct inode *ino
 	inode->i_state &= ~I_DIRTY_PAGES;
 	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 
 	ret = do_writepages(mapping, wbc);
 
@@ -484,12 +481,10 @@ writeback_single_inode(struct inode *ino
 	 * due to delalloc, clear dirty metadata flags right before
 	 * write_inode()
 	 */
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	dirty = inode->i_state & I_DIRTY;
 	inode->i_state &= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
 	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
 		int err = write_inode(inode, wbc);
@@ -497,7 +492,6 @@ writeback_single_inode(struct inode *ino
 			ret = err;
 	}
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	spin_lock(&wb_inode_list_lock);
 	inode->i_state &= ~I_SYNC;
@@ -679,10 +673,8 @@ again:
 		}
 		spin_unlock(&wb_inode_list_lock);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 		iput(inode);
 		cond_resched();
-		spin_lock(&inode_lock);
 		spin_lock(&wb_inode_list_lock);
 		if (wbc->nr_to_write <= 0) {
 			wbc->more_io = 1;
@@ -701,7 +693,6 @@ static void writeback_inodes_wb(struct b
 	int ret = 0;
 
 	wbc->wb_start = jiffies; /* livelock avoidance */
-	spin_lock(&inode_lock);
 again:
 	spin_lock(&wb_inode_list_lock);
 
@@ -744,7 +735,6 @@ again:
 			break;
 	}
 	spin_unlock(&wb_inode_list_lock);
-	spin_unlock(&inode_lock);
 	/* Leave any unwritten inodes on b_io */
 }
 
@@ -857,21 +847,18 @@ static long wb_writeback(struct bdi_writ
 		 * we'll just busyloop.
 		 */
 retry:
-		spin_lock(&inode_lock);
 		spin_lock(&wb_inode_list_lock);
 		if (!list_empty(&wb->b_more_io))  {
 			inode = list_entry(wb->b_more_io.prev,
 						struct inode, i_list);
 			if (!spin_trylock(&inode->i_lock)) {
 				spin_unlock(&wb_inode_list_lock);
-				spin_unlock(&inode_lock);
 				goto retry;
 			}
 			inode_wait_for_writeback(inode);
 			spin_unlock(&inode->i_lock);
 		}
 		spin_unlock(&wb_inode_list_lock);
-		spin_unlock(&inode_lock);
 	}
 
 	return wrote;
@@ -1141,7 +1128,6 @@ void __mark_inode_dirty(struct inode *in
 	if (unlikely(block_dump))
 		block_dump___mark_inode_dirty(inode);
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	if ((inode->i_state & flags) != flags) {
 		const int was_dirty = inode->i_state & I_DIRTY;
@@ -1190,7 +1176,6 @@ void __mark_inode_dirty(struct inode *in
 	}
 out:
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(__mark_inode_dirty);
 
@@ -1221,7 +1206,6 @@ static void wait_sb_inodes(struct super_
 	 */
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 
 	/*
@@ -1246,14 +1230,12 @@ static void wait_sb_inodes(struct super_
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
-		spin_unlock(&inode_lock);
 		/*
-		 * We hold a reference to 'inode' so it couldn't have
-		 * been removed from s_inodes list while we dropped the
-		 * inode_lock.  We cannot iput the inode now as we can
-		 * be holding the last reference and we cannot iput it
-		 * under inode_lock. So we keep the reference and iput
-		 * it later.
+		 * We hold a reference to 'inode' so it couldn't have been
+		 * removed from s_inodes list while we dropped the
+		 * sb_inode_list_lock.  We cannot iput the inode now as we can
+		 * be holding the last reference and we cannot iput it under
+		 * spinlock. So we keep the reference and iput it later.
 		 */
 		iput(old_inode);
 		old_inode = inode;
@@ -1262,11 +1244,9 @@ static void wait_sb_inodes(struct super_
 
 		cond_resched();
 
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 	}
 	spin_unlock(&sb_inode_list_lock);
-	spin_unlock(&inode_lock);
 	iput(old_inode);
 }
 
@@ -1348,13 +1328,11 @@ int write_inode_now(struct inode *inode,
 		wbc.nr_to_write = 0;
 
 	might_sleep();
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	spin_lock(&wb_inode_list_lock);
 	ret = writeback_single_inode(inode, &wbc);
 	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	if (sync)
 		inode_sync_wait(inode);
 	return ret;
@@ -1376,13 +1354,11 @@ int sync_inode(struct inode *inode, stru
 {
 	int ret;
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	spin_lock(&wb_inode_list_lock);
 	ret = writeback_single_inode(inode, wbc);
 	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	return ret;
 }
 EXPORT_SYMBOL(sync_inode);
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c
+++ linux-2.6/fs/hugetlbfs/inode.c
@@ -377,7 +377,7 @@ static void hugetlbfs_delete_inode(struc
 	clear_inode(inode);
 }
 
-static void hugetlbfs_forget_inode(struct inode *inode) __releases(inode_lock)
+static void hugetlbfs_forget_inode(struct inode *inode)
 {
 	if (generic_detach_inode(inode)) {
 		truncate_hugepages(inode, 0);
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -105,7 +105,6 @@ static struct hlist_head *inode_hashtabl
  * NOTE! You also have to own the lock if you change
  * the i_state of an inode while it is in use..
  */
-DEFINE_SPINLOCK(inode_lock);
 DEFINE_SPINLOCK(sb_inode_list_lock);
 DEFINE_SPINLOCK(wb_inode_list_lock);
 DEFINE_SPINLOCK(inode_hash_lock);
@@ -376,16 +375,14 @@ static void dispose_list(struct list_hea
 			truncate_inode_pages(&inode->i_data, 0);
 		clear_inode(inode);
 
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
 		list_del_init(&inode->i_sb_list);
-		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
+		spin_unlock(&sb_inode_list_lock);
 
 		wake_up_inode(inode);
 		destroy_inode(inode);
@@ -413,7 +410,6 @@ static int invalidate_list(struct list_h
 		 * change during umount anymore, and because iprune_sem keeps
 		 * shrink_icache_memory() away.
 		 */
-		cond_resched_lock(&inode_lock);
 		cond_resched_lock(&sb_inode_list_lock);
 
 		next = next->next;
@@ -458,13 +454,11 @@ int invalidate_inodes(struct super_block
 	LIST_HEAD(throw_away);
 
 	down_write(&iprune_sem);
-	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 	inotify_unmount_inodes(&sb->s_inodes);
 	fsnotify_unmount_inodes(&sb->s_inodes);
 	busy = invalidate_list(&sb->s_inodes, &throw_away);
 	spin_unlock(&sb_inode_list_lock);
-	spin_unlock(&inode_lock);
 
 	dispose_list(&throw_away);
 	up_write(&iprune_sem);
@@ -507,7 +501,6 @@ static void prune_icache(int nr_to_scan)
 	unsigned long reap = 0;
 
 	down_read(&iprune_sem);
-	spin_lock(&inode_lock);
 again:
 	spin_lock(&wb_inode_list_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
@@ -531,12 +524,10 @@ again:
 			spin_unlock(&wb_inode_list_lock);
 			__iget(inode);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
 								0, -1);
 			iput(inode);
-			spin_lock(&inode_lock);
 again2:
 			spin_lock(&wb_inode_list_lock);
 
@@ -563,7 +554,6 @@ again2:
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
 		__count_vm_events(PGINODESTEAL, reap);
-	spin_unlock(&inode_lock);
 	spin_unlock(&wb_inode_list_lock);
 
 	dispose_list(&freeable);
@@ -714,12 +704,10 @@ void inode_add_to_lists(struct super_blo
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, inode->i_ino);
 
-	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 	spin_lock(&inode->i_lock);
 	__inode_add_to_lists(sb, head, inode);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL_GPL(inode_add_to_lists);
 
@@ -745,18 +733,14 @@ struct inode *new_inode(struct super_blo
 	static atomic_t last_ino = ATOMIC_INIT(0);
 	struct inode *inode;
 
-	spin_lock_prefetch(&inode_lock);
-
 	inode = alloc_inode(sb);
 	if (inode) {
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
 		inode->i_ino = atomic_inc_return(&last_ino);
 		inode->i_state = 0;
 		__inode_add_to_lists(sb, NULL, inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 	}
 	return inode;
 }
@@ -815,7 +799,6 @@ static struct inode *get_new_inode(struc
 	if (inode) {
 		struct inode *old;
 
-		spin_lock(&inode_lock);
 		/* We released the lock, so.. */
 		old = find_inode(sb, head, test, data);
 		if (!old) {
@@ -827,7 +810,6 @@ static struct inode *get_new_inode(struc
 			inode->i_state = I_NEW;
 			__inode_add_to_lists(sb, head, inode);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -842,7 +824,6 @@ static struct inode *get_new_inode(struc
 		 */
 		__iget(old);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -852,7 +833,6 @@ static struct inode *get_new_inode(struc
 set_failed:
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&sb_inode_list_lock);
-	spin_unlock(&inode_lock);
 	destroy_inode(inode);
 	return NULL;
 }
@@ -870,7 +850,6 @@ static struct inode *get_new_inode_fast(
 	if (inode) {
 		struct inode *old;
 
-		spin_lock(&inode_lock);
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
@@ -880,7 +859,6 @@ static struct inode *get_new_inode_fast(
 			inode->i_state = I_NEW;
 			__inode_add_to_lists(sb, head, inode);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -895,7 +873,6 @@ static struct inode *get_new_inode_fast(
 		 */
 		__iget(old);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -945,7 +922,6 @@ ino_t iunique(struct super_block *sb, in
 	struct hlist_head *head;
 	ino_t res;
 
-	spin_lock(&inode_lock);
 	spin_lock(&unique_lock);
 	do {
 		if (counter <= max_reserved)
@@ -954,7 +930,6 @@ ino_t iunique(struct super_block *sb, in
 		head = inode_hashtable + hash(sb, res);
 	} while (!test_inode_iunique(sb, head, res));
 	spin_unlock(&unique_lock);
-	spin_unlock(&inode_lock);
 
 	return res;
 }
@@ -964,7 +939,6 @@ struct inode *igrab(struct inode *inode)
 {
 	struct inode *ret = inode;
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	if (!(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)))
 		__iget(inode);
@@ -976,7 +950,6 @@ struct inode *igrab(struct inode *inode)
 		 */
 		ret = NULL;
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 
 	return ret;
 }
@@ -1007,17 +980,14 @@ static struct inode *ifind(struct super_
 {
 	struct inode *inode;
 
-	spin_lock(&inode_lock);
 	inode = find_inode(sb, head, test, data);
 	if (inode) {
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
 		return inode;
 	}
-	spin_unlock(&inode_lock);
 	return NULL;
 }
 
@@ -1041,16 +1011,13 @@ static struct inode *ifind_fast(struct s
 {
 	struct inode *inode;
 
-	spin_lock(&inode_lock);
 	inode = find_inode_fast(sb, head, ino);
 	if (inode) {
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 		wait_on_inode(inode);
 		return inode;
 	}
-	spin_unlock(&inode_lock);
 	return NULL;
 }
 
@@ -1214,7 +1181,6 @@ int insert_inode_locked(struct inode *in
 		struct hlist_node *node;
 		struct inode *old = NULL;
 
-		spin_lock(&inode_lock);
 repeat:
 		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
@@ -1233,13 +1199,11 @@ repeat:
 		if (likely(!node)) {
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode_hash_lock);
-			spin_unlock(&inode_lock);
 			return 0;
 		}
 		spin_unlock(&inode_hash_lock);
 		__iget(old);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
 			iput(old);
@@ -1262,7 +1226,6 @@ int insert_inode_locked4(struct inode *i
 		struct hlist_node *node;
 		struct inode *old = NULL;
 
-		spin_lock(&inode_lock);
 repeat:
 		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
@@ -1281,13 +1244,11 @@ repeat:
 		if (likely(!node)) {
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode_hash_lock);
-			spin_unlock(&inode_lock);
 			return 0;
 		}
 		spin_unlock(&inode_hash_lock);
 		__iget(old);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
 			iput(old);
@@ -1310,13 +1271,11 @@ void __insert_inode_hash(struct inode *i
 {
 	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	spin_lock(&inode_hash_lock);
 	hlist_add_head(&inode->i_hash, head);
 	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
 
@@ -1328,13 +1287,11 @@ EXPORT_SYMBOL(__insert_inode_hash);
  */
 void remove_inode_hash(struct inode *inode)
 {
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
 	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(remove_inode_hash);
 
@@ -1362,7 +1319,6 @@ void generic_delete_inode(struct inode *
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	atomic_dec(&inodes_stat.nr_inodes);
 
 	if (op->delete_inode) {
@@ -1376,13 +1332,11 @@ void generic_delete_inode(struct inode *
 		truncate_inode_pages(&inode->i_data, 0);
 		clear_inode(inode);
 	}
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
 	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	wake_up_inode(inode);
 	BUG_ON(inode->i_state != I_CLEAR);
 	destroy_inode(inode);
@@ -1412,16 +1366,13 @@ int generic_detach_inode(struct inode *i
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&sb_inode_list_lock);
-			spin_unlock(&inode_lock);
 			return 0;
 		}
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
-		spin_unlock(&inode_lock);
 		write_inode_now(inode, 1);
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
@@ -1439,7 +1390,6 @@ int generic_detach_inode(struct inode *i
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	atomic_dec(&inodes_stat.nr_inodes);
 	return 1;
 }
@@ -1505,17 +1455,12 @@ void iput(struct inode *inode)
 	if (inode) {
 		BUG_ON(inode->i_state == I_CLEAR);
 
-retry1:
+retry:
 		spin_lock(&inode->i_lock);
 		if (inode->i_count == 1) {
-			if (!spin_trylock(&inode_lock)) {
-retry2:
-				spin_unlock(&inode->i_lock);
-				goto retry1;
-			}
 			if (!spin_trylock(&sb_inode_list_lock)) {
-				spin_unlock(&inode_lock);
-				goto retry2;
+				spin_unlock(&inode->i_lock);
+				goto retry;
 			}
 			inode->i_count--;
 			iput_final(inode);
@@ -1713,10 +1658,8 @@ static void __wait_on_freeing_inode(stru
 	wq = bit_waitqueue(&inode->i_state, __I_NEW);
 	prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	schedule();
 	finish_wait(wq, &wait.wait);
-	spin_lock(&inode_lock);
 }
 
 static __initdata unsigned long ihash_entries;
Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -390,13 +390,16 @@ void inotify_unmount_inodes(struct list_
 		struct inode *need_iput_tmp;
 		struct list_head *watches;
 
+		spin_lock(&inode->i_lock);
 		/*
 		 * We cannot __iget() an inode in state I_CLEAR, I_FREEING,
 		 * I_WILL_FREE, or I_NEW which is fine because by that point
 		 * the inode cannot have any associated watches.
 		 */
-		if (inode->i_state & (I_CLEAR|I_FREEING|I_WILL_FREE|I_NEW))
+		if (inode->i_state & (I_CLEAR|I_FREEING|I_WILL_FREE|I_NEW)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 
 		/*
 		 * If i_count is zero, the inode cannot have any watches and
@@ -404,18 +407,21 @@ void inotify_unmount_inodes(struct list_
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
 		/* In case inotify_remove_watch_locked() drops a reference. */
 		if (inode != need_iput_tmp) {
-			spin_lock(&inode->i_lock);
 			__iget(inode);
-			spin_unlock(&inode->i_lock);
 		} else
 			need_iput_tmp = NULL;
+
+		spin_unlock(&inode->i_lock);
+
 		/* In case the dropping of a reference would nuke next_i. */
 		if (&next_i->i_sb_list != list) {
 			spin_lock(&next_i->i_lock);
@@ -435,7 +441,6 @@ void inotify_unmount_inodes(struct list_
 		 * iprune_mutex keeps shrink_icache_memory() away.
 		 */
 		spin_unlock(&sb_inode_list_lock);
-		spin_unlock(&inode_lock);
 
 		if (need_iput_tmp)
 			iput(need_iput_tmp);
@@ -455,7 +460,6 @@ void inotify_unmount_inodes(struct list_
 		mutex_unlock(&inode->inotify_mutex);
 		iput(inode);		
 
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 	}
 }
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h
+++ linux-2.6/include/linux/writeback.h
@@ -9,7 +9,6 @@
 
 struct backing_dev_info;
 
-extern spinlock_t inode_lock;
 extern spinlock_t sb_inode_list_lock;
 extern spinlock_t wb_inode_list_lock;
 extern spinlock_t inode_hash_lock;
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c
+++ linux-2.6/fs/quota/dquot.c
@@ -883,7 +883,6 @@ static void add_dquot_ref(struct super_b
 	int reserved = 0;
 #endif
 
-	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
@@ -907,7 +906,6 @@ static void add_dquot_ref(struct super_b
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
-		spin_unlock(&inode_lock);
 
 		iput(old_inode);
 		__dquot_initialize(inode, type);
@@ -917,11 +915,9 @@ static void add_dquot_ref(struct super_b
 		 * reference and we cannot iput it under inode_lock. So we
 		 * keep the reference and iput it later. */
 		old_inode = inode;
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 	}
 	spin_unlock(&sb_inode_list_lock);
-	spin_unlock(&inode_lock);
 	iput(old_inode);
 
 #ifdef CONFIG_QUOTA_DEBUG
@@ -999,7 +995,6 @@ static void remove_dquot_ref(struct supe
 {
 	struct inode *inode;
 
-	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		/*
@@ -1012,7 +1007,6 @@ static void remove_dquot_ref(struct supe
 			remove_inode_dquot_ref(inode, type, tofree_head);
 	}
 	spin_unlock(&sb_inode_list_lock);
-	spin_unlock(&inode_lock);
 }
 
 /* Gather all references from inodes and drop them */
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c
+++ linux-2.6/fs/notify/inode_mark.c
@@ -368,13 +368,16 @@ void fsnotify_unmount_inodes(struct list
 	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
 		struct inode *need_iput_tmp;
 
+		spin_lock(&inode->i_lock);
 		/*
 		 * We cannot __iget() an inode in state I_CLEAR, I_FREEING,
 		 * I_WILL_FREE, or I_NEW which is fine because by that point
 		 * the inode cannot have any associated watches.
 		 */
-		if (inode->i_state & (I_CLEAR|I_FREEING|I_WILL_FREE|I_NEW))
+		if (inode->i_state & (I_CLEAR|I_FREEING|I_WILL_FREE|I_NEW)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 
 		/*
 		 * If i_count is zero, the inode cannot have any watches and
@@ -382,19 +385,20 @@ void fsnotify_unmount_inodes(struct list
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
 		if (inode != need_iput_tmp) {
-			spin_lock(&inode->i_lock);
 			__iget(inode);
-			spin_unlock(&inode->i_lock);
 		} else
 			need_iput_tmp = NULL;
+		spin_unlock(&inode->i_lock);
 
 		/* In case the dropping of a reference would nuke next_i. */
 		if (&next_i->i_sb_list != list) {
@@ -415,7 +419,6 @@ void fsnotify_unmount_inodes(struct list
 		 * iprune_mutex keeps shrink_icache_memory() away.
 		 */
 		spin_unlock(&sb_inode_list_lock);
-		spin_unlock(&inode_lock);
 
 		if (need_iput_tmp)
 			iput(need_iput_tmp);
@@ -427,7 +430,6 @@ void fsnotify_unmount_inodes(struct list
 
 		iput(inode);
 
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 	}
 }
Index: linux-2.6/mm/backing-dev.c
===================================================================
--- linux-2.6.orig/mm/backing-dev.c
+++ linux-2.6/mm/backing-dev.c
@@ -77,7 +77,6 @@ static int bdi_debug_stats_show(struct s
 	 * RCU on the reader side
 	 */
 	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
-	spin_lock(&inode_lock);
 	spin_lock(&wb_inode_list_lock);
 	list_for_each_entry(wb, &bdi->wb_list, list) {
 		nr_wb++;
@@ -89,7 +88,6 @@ static int bdi_debug_stats_show(struct s
 			nr_more_io++;
 	}
 	spin_unlock(&wb_inode_list_lock);
-	spin_unlock(&inode_lock);
 
 	get_dirty_limits(&background_thresh, &dirty_thresh, &bdi_thresh, bdi);
 
@@ -713,13 +711,11 @@ void bdi_destroy(struct backing_dev_info
 	if (bdi_has_dirty_io(bdi)) {
 		struct bdi_writeback *dst = &default_backing_dev_info.wb;
 
-		spin_lock(&inode_lock);
 		spin_lock(&wb_inode_list_lock);
 		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
 		list_splice(&bdi->wb.b_io, &dst->b_io);
 		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
 		spin_unlock(&wb_inode_list_lock);
-		spin_unlock(&inode_lock);
 	}
 
 	bdi_unregister(bdi);


