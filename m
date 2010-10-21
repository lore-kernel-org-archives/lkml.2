Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab0JUNYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:24:17 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:50996 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758013Ab0JUNWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:22:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoAGAGfav0x5LdoFgWdsb2JhbACUZ4xxFgEBFiIiwC+CeAGCUQSFDoU/hQE
Message-Id: <20101021131016.963931270@kernel.dk>
User-Agent: quilt/0.48-1
Date: Fri, 22 Oct 2010 00:08:39 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk
Subject: [patch 10/14] fs: icache remove inode_lock
References: <20101021130829.442910807@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale-7.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the global inode_lock, it has been made redundant by the
previous lock breakup.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 Documentation/filesystems/Locking |    2 
 Documentation/filesystems/porting |   10 +++-
 Documentation/filesystems/vfs.txt |    2 
 fs/buffer.c                       |    2 
 fs/drop_caches.c                  |    4 -
 fs/fs-writeback.c                 |   46 ++++--------------
 fs/inode.c                        |   93 ++++++--------------------------------
 fs/notify/inode_mark.c            |   13 +----
 fs/ntfs/inode.c                   |    4 -
 fs/ocfs2/inode.c                  |    2 
 fs/quota/dquot.c                  |   16 ++----
 include/linux/fs.h                |    2 
 include/linux/writeback.h         |    1 
 mm/backing-dev.c                  |    4 -
 mm/filemap.c                      |    6 +-
 mm/rmap.c                         |    6 +-
 16 files changed, 59 insertions(+), 154 deletions(-)

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c	2010-10-21 23:49:52.000000000 +1100
+++ linux-2.6/fs/buffer.c	2010-10-21 23:50:27.000000000 +1100
@@ -1145,7 +1145,7 @@ __getblk_slow(struct block_device *bdev,
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
--- linux-2.6.orig/fs/drop_caches.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/drop_caches.c	2010-10-21 23:50:41.000000000 +1100
@@ -16,7 +16,6 @@ static void drop_pagecache_sb(struct sup
 {
 	struct inode *inode, *toput_inode = NULL;
 
-	spin_lock(&inode_lock);
 lock_again:
 	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
@@ -36,15 +35,12 @@ static void drop_pagecache_sb(struct sup
 		inode_get_ilock(inode);
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
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-21 23:50:41.000000000 +1100
@@ -194,7 +194,7 @@ static void requeue_io(struct inode *ino
 static void inode_sync_complete(struct inode *inode)
 {
 	/*
-	 * Prevent speculative execution through spin_unlock(&inode_lock);
+	 * Prevent speculative execution through spin_unlock(&inode->i_lock);
 	 */
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_SYNC);
@@ -294,18 +294,16 @@ static void inode_wait_for_writeback(str
 	while (inode->i_state & I_SYNC) {
 		spin_unlock(&wb_inode_list_lock);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
-		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
 		spin_lock(&wb_inode_list_lock);
 	}
 }
 
 /*
- * Write out an inode's dirty pages.  Called under inode_lock.  Either the
- * caller has ref on the inode (either via inode_get or via syscall against an
- * fd) or the inode has I_WILL_FREE set (via generic_forget_inode)
+ * Write out an inode's dirty pages.  Called under wb_inode_list_lock.  Either
+ * the caller has ref on the inode (either via inode_get or via syscall against
+ * an fd) or the inode has I_WILL_FREE set (via generic_forget_inode)
  *
  * If `wait' is set, wait on the writeout.
  *
@@ -313,7 +311,8 @@ static void inode_wait_for_writeback(str
  * starvation of particular inodes when others are being redirtied, prevent
  * livelocks, etc.
  *
- * Called under inode_lock.
+ * Called under wb_inode_list_lock and i_lock. May drop the locks but returns
+ * with them locked.
  */
 static int
 writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
@@ -354,7 +353,6 @@ writeback_single_inode(struct inode *ino
 	inode->i_state &= ~I_DIRTY_PAGES;
 	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 
 	ret = do_writepages(mapping, wbc);
 
@@ -374,12 +372,10 @@ writeback_single_inode(struct inode *ino
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
@@ -387,7 +383,6 @@ writeback_single_inode(struct inode *ino
 			ret = err;
 	}
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	spin_lock(&wb_inode_list_lock);
 	inode->i_state &= ~I_SYNC;
@@ -538,10 +533,8 @@ static int writeback_sb_inodes(struct su
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
@@ -561,7 +554,6 @@ void writeback_inodes_wb(struct bdi_writ
 
 	if (!wbc->wb_start)
 		wbc->wb_start = jiffies; /* livelock avoidance */
-	spin_lock(&inode_lock);
 lock_again:
 	spin_lock(&wb_inode_list_lock);
 
@@ -590,7 +582,6 @@ void writeback_inodes_wb(struct bdi_writ
 			break;
 	}
 	spin_unlock(&wb_inode_list_lock);
-	spin_unlock(&inode_lock);
 	/* Leave any unwritten inodes on b_io */
 }
 
@@ -599,13 +590,11 @@ static void __writeback_inodes_sb(struct
 {
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	spin_lock(&inode_lock);
 	spin_lock(&wb_inode_list_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 	writeback_sb_inodes(sb, wb, wbc, true);
 	spin_unlock(&wb_inode_list_lock);
-	spin_unlock(&inode_lock);
 }
 
 /*
@@ -715,7 +704,6 @@ static long wb_writeback(struct bdi_writ
 		 * become available for writeback. Otherwise
 		 * we'll just busyloop.
 		 */
-		spin_lock(&inode_lock);
 lock_again:
 		spin_lock(&wb_inode_list_lock);
 		if (!list_empty(&wb->b_more_io))  {
@@ -731,7 +719,6 @@ static long wb_writeback(struct bdi_writ
 			spin_unlock(&inode->i_lock);
 		}
 		spin_unlock(&wb_inode_list_lock);
-		spin_unlock(&inode_lock);
 	}
 
 	return wrote;
@@ -994,7 +981,6 @@ void __mark_inode_dirty(struct inode *in
 	if (unlikely(block_dump))
 		block_dump___mark_inode_dirty(inode);
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	if ((inode->i_state & flags) != flags) {
 		const int was_dirty = inode->i_state & I_DIRTY;
@@ -1049,7 +1035,6 @@ void __mark_inode_dirty(struct inode *in
 	}
 out:
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 
 	if (wakeup_bdi)
 		bdi_wakeup_thread_delayed(bdi);
@@ -1083,7 +1068,6 @@ static void wait_sb_inodes(struct super_
 	 */
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	spin_lock(&inode_lock);
 lock_again:
 	spin_lock(&sb_inode_list_lock);
 
@@ -1114,14 +1098,12 @@ static void wait_sb_inodes(struct super_
 		inode_get_ilock_wblock(inode);
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
@@ -1130,11 +1112,9 @@ static void wait_sb_inodes(struct super_
 
 		cond_resched();
 
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 	}
 	spin_unlock(&sb_inode_list_lock);
-	spin_unlock(&inode_lock);
 	iput(old_inode);
 }
 
@@ -1237,13 +1217,11 @@ int write_inode_now(struct inode *inode,
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
@@ -1265,13 +1243,11 @@ int sync_inode(struct inode *inode, stru
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
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-21 23:50:42.000000000 +1100
@@ -29,8 +29,6 @@
  * Icache locking
  *
  * Usage:
- * inode_lock protects:
- *   everything
  * inode->i_lock protects:
  *   i_count
  *   i_state
@@ -45,12 +43,11 @@
  *   inode_in_use, inode_unused, b_io, b_more_io, b_dirty, i_list
  *
  * Ordering:
- * inode_lock
- *   i_lock
- *     sb_inode_list_lock
- *       wb_inode_list_lock
- *     inode_hash_lock
- *       wb_inode_list_lock
+ * i_lock
+ *   sb_inode_list_lock
+ *     wb_inode_list_lock
+ *   inode_hash_lock
+ *     wb_inode_list_lock
  */
 /*
  * This is needed for the following functions:
@@ -109,7 +106,6 @@ static struct hlist_head *inode_hashtabl
  * NOTE! You also have to own the lock if you change
  * the i_state of an inode while it is in use..
  */
-DEFINE_SPINLOCK(inode_lock);
 DEFINE_SPINLOCK(sb_inode_list_lock);
 DEFINE_SPINLOCK(wb_inode_list_lock);
 static DEFINE_SPINLOCK(inode_hash_lock);
@@ -175,7 +171,7 @@ static struct kmem_cache *inode_cachep _
 static void wake_up_inode(struct inode *inode)
 {
 	/*
-	 * Prevent speculative execution through spin_unlock(&inode_lock);
+	 * Prevent speculative execution through spin_unlock(&inode->i_lock);
 	 */
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_NEW);
@@ -366,7 +362,6 @@ EXPORT_SYMBOL(__inode_get);
  */
 void inode_get_ilock_wblock(struct inode *inode)
 {
- 	assert_spin_locked(&inode_lock);
  	assert_spin_locked(&inode->i_lock);
 	assert_spin_locked(&wb_inode_list_lock);
 	BUG_ON(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE));
@@ -381,11 +376,10 @@ void inode_get_ilock_wblock(struct inode
 }
 
 /*
- * inode_lock must be held
+ * i_lock must be held
  */
 void inode_get_ilock(struct inode *inode)
 {
- 	assert_spin_locked(&inode_lock);
  	assert_spin_locked(&inode->i_lock);
 	BUG_ON(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE));
 	inode->i_count++;
@@ -458,7 +452,6 @@ static void dispose_list(struct list_hea
 
 		evict(inode);
 
-		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
@@ -467,7 +460,6 @@ static void dispose_list(struct list_hea
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 
 		wake_up_inode(inode);
 		destroy_inode(inode);
@@ -563,7 +555,7 @@ static int can_unuse(struct inode *inode
 
 /*
  * Scan `goal' inodes on the unused list for freeable ones. They are moved to
- * a temporary list and then are freed outside inode_lock by dispose_list().
+ * a temporary list and then are freed outside LRU lock by dispose_list().
  *
  * Any inodes which are pinned purely because of attached pagecache have their
  * pagecache removed.  We expect the final iput() on that inode to add it to
@@ -582,7 +574,6 @@ static void prune_icache(int nr_to_scan)
 	unsigned long reap = 0;
 
 	down_read(&iprune_sem);
-	spin_lock(&inode_lock);
 lock_again:
 	spin_lock(&wb_inode_list_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
@@ -608,12 +599,10 @@ static void prune_icache(int nr_to_scan)
 			inode_get_ilock_wblock(inode);
 			spin_unlock(&wb_inode_list_lock);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
 								0, -1);
 			iput(inode);
-			spin_lock(&inode_lock);
 lock_again_2:
 			spin_lock(&wb_inode_list_lock);
 			if (!spin_trylock(&inode->i_lock)) {
@@ -644,7 +633,6 @@ static void prune_icache(int nr_to_scan)
 	else
 		__count_vm_events(PGINODESTEAL, reap);
 	spin_unlock(&wb_inode_list_lock);
-	spin_unlock(&inode_lock);
 
 	dispose_list(&freeable);
 	up_read(&iprune_sem);
@@ -780,9 +768,9 @@ __inode_add_to_lists(struct super_block
  * @inode: inode to mark in use
  *
  * When an inode is allocated it needs to be accounted for, added to the in use
- * list, the owning superblock and the inode hash. This needs to be done under
- * the inode_lock, so export a function to do this rather than the inode lock
- * itself. We calculate the hash list to add to here so it is all internal
+ * list, the owning superblock and the inode hash.
+ *
+ * We calculate the hash list to add to here so it is all internal
  * which requires the caller to have already set up the inode number in the
  * inode to add.
  */
@@ -790,11 +778,9 @@ void inode_add_to_lists(struct super_blo
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, inode->i_ino);
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	__inode_add_to_lists(sb, head, inode);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL_GPL(inode_add_to_lists);
 
@@ -820,17 +806,13 @@ struct inode *new_inode(struct super_blo
 	static atomic_t last_ino = ATOMIC_INIT(0);
 	struct inode *inode;
 
-	spin_lock_prefetch(&inode_lock);
-
 	inode = alloc_inode(sb);
 	if (inode) {
-		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
 		inode->i_ino = (unsigned int)atomic_inc_return(&last_ino);
 		inode->i_state = 0;
 		__inode_add_to_lists(sb, NULL, inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 	}
 	return inode;
 }
@@ -889,7 +871,6 @@ static struct inode *get_new_inode(struc
 	if (inode) {
 		struct inode *old;
 
-		spin_lock(&inode_lock);
 		spin_lock(&inode_hash_lock);
 		/* We released the lock, so.. */
 		old = find_inode(sb, head, test, data);
@@ -903,7 +884,6 @@ static struct inode *get_new_inode(struc
 			spin_unlock(&inode_hash_lock);
 			__inode_add_to_lists(sb, NULL, inode);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -919,7 +899,6 @@ static struct inode *get_new_inode(struc
 		inode_get_ilock(old);
 		spin_unlock(&inode_hash_lock);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -928,7 +907,6 @@ static struct inode *get_new_inode(struc
 
 set_failed:
 	spin_unlock(&inode_hash_lock);
-	spin_unlock(&inode_lock);
 	destroy_inode(inode);
 	return NULL;
 }
@@ -946,7 +924,6 @@ static struct inode *get_new_inode_fast(
 	if (inode) {
 		struct inode *old;
 
-		spin_lock(&inode_lock);
 		spin_lock(&inode_hash_lock);
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, head, ino);
@@ -958,7 +935,6 @@ static struct inode *get_new_inode_fast(
 			spin_unlock(&inode_hash_lock);
 			__inode_add_to_lists(sb, NULL, inode);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -974,7 +950,6 @@ static struct inode *get_new_inode_fast(
 		inode_get_ilock(old);
 		spin_unlock(&inode_hash_lock);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -1034,7 +1009,6 @@ ino_t iunique(struct super_block *sb, in
 	static unsigned int counter;
 	ino_t res;
 
-	spin_lock(&inode_lock);
 	spin_lock(&unique_lock);
 	do {
 		if (counter <= max_reserved)
@@ -1042,7 +1016,6 @@ ino_t iunique(struct super_block *sb, in
 		res = counter++;
 	} while (!is_ino_hashed(sb, res));
 	spin_unlock(&unique_lock);
-	spin_unlock(&inode_lock);
 
 	return res;
 }
@@ -1052,7 +1025,6 @@ struct inode *igrab(struct inode *inode)
 {
 	struct inode *ret = inode;
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	if (!(inode->i_state & (I_FREEING|I_WILL_FREE)))
 		inode_get_ilock(inode);
@@ -1064,7 +1036,6 @@ struct inode *igrab(struct inode *inode)
 		 */
 		ret = NULL;
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 
 	return ret;
 }
@@ -1087,7 +1058,7 @@ EXPORT_SYMBOL(igrab);
  *
  * Otherwise NULL is returned.
  *
- * Note, @test is called with the inode_lock held, so can't sleep.
+ * Note, @test is called with the inode_hash_lock held, so can't sleep.
  */
 static struct inode *ifind(struct super_block *sb,
 		struct hlist_head *head, int (*test)(struct inode *, void *),
@@ -1095,20 +1066,17 @@ static struct inode *ifind(struct super_
 {
 	struct inode *inode;
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode_hash_lock);
 	inode = find_inode(sb, head, test, data);
 	if (inode) {
 		inode_get_ilock(inode);
 		spin_unlock(&inode_hash_lock);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
 		return inode;
 	}
 	spin_unlock(&inode_hash_lock);
-	spin_unlock(&inode_lock);
 	return NULL;
 }
 
@@ -1132,19 +1100,16 @@ static struct inode *ifind_fast(struct s
 {
 	struct inode *inode;
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode_hash_lock);
 	inode = find_inode_fast(sb, head, ino);
 	if (inode) {
 		inode_get_ilock(inode);
 		spin_unlock(&inode_hash_lock);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 		wait_on_inode(inode);
 		return inode;
 	}
 	spin_unlock(&inode_hash_lock);
-	spin_unlock(&inode_lock);
 	return NULL;
 }
 
@@ -1167,7 +1132,7 @@ static struct inode *ifind_fast(struct s
  *
  * Otherwise NULL is returned.
  *
- * Note, @test is called with the inode_lock held, so can't sleep.
+ * Note, @test is called with the i_lock held, so can't sleep.
  */
 struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
@@ -1195,7 +1160,7 @@ EXPORT_SYMBOL(ilookup5_nowait);
  *
  * Otherwise NULL is returned.
  *
- * Note, @test is called with the inode_lock held, so can't sleep.
+ * Note, @test is called with the i_lock held, so can't sleep.
  */
 struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
@@ -1246,7 +1211,7 @@ EXPORT_SYMBOL(ilookup);
  * inode and this is returned locked, hashed, and with the I_NEW flag set. The
  * file system gets to fill it in before unlocking it via unlock_new_inode().
  *
- * Note both @test and @set are called with the inode_lock held, so can't sleep.
+ * Note both @test and @set are called with the i_lock held, so can't sleep.
  */
 struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *),
@@ -1307,7 +1272,6 @@ int insert_inode_locked(struct inode *in
 	while (1) {
 		struct hlist_node *node;
 		struct inode *old = NULL;
-		spin_lock(&inode_lock);
 lock_again:
 		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
@@ -1330,14 +1294,12 @@ int insert_inode_locked(struct inode *in
 		hlist_add_head(&inode->i_hash, head);
 		spin_unlock(&inode_hash_lock);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 		return 0;
 
 found_old:
 		inode_get_ilock(old);
 		spin_unlock(&inode_hash_lock);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
 			iput(old);
@@ -1360,7 +1322,6 @@ int insert_inode_locked4(struct inode *i
 		struct hlist_node *node;
 		struct inode *old = NULL;
 
-		spin_lock(&inode_lock);
 lock_again:
 		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
@@ -1383,14 +1344,12 @@ int insert_inode_locked4(struct inode *i
 		hlist_add_head(&inode->i_hash, head);
 		spin_unlock(&inode_hash_lock);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 		return 0;
 
 found_old:
 		inode_get_ilock(old);
 		spin_unlock(&inode_hash_lock);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
 			iput(old);
@@ -1412,13 +1371,11 @@ EXPORT_SYMBOL(insert_inode_locked4);
 void __insert_inode_hash(struct inode *inode, unsigned long hashval)
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
 
@@ -1430,13 +1387,11 @@ EXPORT_SYMBOL(__insert_inode_hash);
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
 
@@ -1487,15 +1442,12 @@ static void iput_final(struct inode *ino
 		atomic_inc(&nr_unused);
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
 			return;
 		}
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 		write_inode_now(inode, 1);
-		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
@@ -1514,15 +1466,12 @@ static void iput_final(struct inode *ino
 	inode->i_state |= I_FREEING;
 	atomic_dec(&nr_inodes);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	evict(inode);
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
 	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	wake_up_inode(inode);
 	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
 	destroy_inode(inode);
@@ -1542,16 +1491,12 @@ void iput(struct inode *inode)
 	if (inode) {
 		BUG_ON(inode->i_state & I_CLEAR);
 
-		/* open-code atomic_dec_and_lock */
-		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
 		inode->i_count--;
-		if (inode->i_count == 0) {
+		if (inode->i_count == 0)
 			iput_final(inode);
-		} else {
+		else
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
-		}
 	}
 }
 EXPORT_SYMBOL(iput);
@@ -1731,8 +1676,6 @@ EXPORT_SYMBOL(inode_wait);
  * It doesn't matter if I_NEW is not set initially, a call to
  * wake_up_inode() after removing from the hash list will DTRT.
  *
- * This is called with inode_lock held.
- *
  * Called with i_lock held and returns with it dropped.
  */
 static void __wait_on_freeing_inode(struct inode *inode)
@@ -1743,10 +1686,8 @@ static void __wait_on_freeing_inode(stru
 	prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
 	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	schedule();
 	finish_wait(wq, &wait.wait);
-	spin_lock(&inode_lock);
 	spin_lock(&inode_hash_lock);
 }
 
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/include/linux/writeback.h	2010-10-21 23:50:40.000000000 +1100
@@ -9,7 +9,6 @@
 
 struct backing_dev_info;
 
-extern spinlock_t inode_lock;
 extern spinlock_t sb_inode_list_lock;
 extern spinlock_t wb_inode_list_lock;
 extern struct list_head inode_in_use;
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/quota/dquot.c	2010-10-21 23:50:41.000000000 +1100
@@ -76,7 +76,7 @@
 #include <linux/buffer_head.h>
 #include <linux/capability.h>
 #include <linux/quotaops.h>
-#include <linux/writeback.h> /* for inode_lock, oddly enough.. */
+#include <linux/writeback.h>
 
 #include <asm/uaccess.h>
 
@@ -897,7 +897,6 @@ static void add_dquot_ref(struct super_b
 	int reserved = 0;
 #endif
 
-	spin_lock(&inode_lock);
 lock_again:
 	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
@@ -926,21 +925,18 @@ static void add_dquot_ref(struct super_b
 		inode_get_ilock(inode);
 		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 
 		iput(old_inode);
 		__dquot_initialize(inode, type);
 		/* We hold a reference to 'inode' so it couldn't have been
-		 * removed from s_inodes list while we dropped the inode_lock.
-		 * We cannot iput the inode now as we can be holding the last
-		 * reference and we cannot iput it under inode_lock. So we
-		 * keep the reference and iput it later. */
+		 * removed from s_inodes list while we dropped the
+		 * sb_inode_list_lock.  We cannot iput the inode now as we can
+		 * be holding the last reference and we cannot iput it under
+		 * lock. So we keep the reference and iput it later. */
 		old_inode = inode;
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 	}
 	spin_unlock(&sb_inode_list_lock);
-	spin_unlock(&inode_lock);
 	iput(old_inode);
 
 #ifdef CONFIG_QUOTA_DEBUG
@@ -1021,7 +1017,6 @@ static void remove_dquot_ref(struct supe
 	struct inode *inode;
 	int reserved = 0;
 
-	spin_lock(&inode_lock);
 lock_again:
 	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
@@ -1044,7 +1039,6 @@ static void remove_dquot_ref(struct supe
 		}
 	}
 	spin_unlock(&sb_inode_list_lock);
-	spin_unlock(&inode_lock);
 #ifdef CONFIG_QUOTA_DEBUG
 	if (reserved) {
 		printk(KERN_WARNING "VFS (%s): Writes happened after quota"
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/notify/inode_mark.c	2010-10-21 23:50:41.000000000 +1100
@@ -22,7 +22,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
-#include <linux/writeback.h> /* for inode_lock */
+#include <linux/writeback.h>
 
 #include <asm/atomic.h>
 
@@ -232,16 +232,14 @@ int fsnotify_add_inode_mark(struct fsnot
  * fsnotify_unmount_inodes - an sb is unmounting.  handle any watched inodes.
  * @list: list of inodes being unmounted (sb->s_inodes)
  *
- * Called with inode_lock held, protecting the unmounting super block's list
- * of inodes, and with iprune_mutex held, keeping shrink_icache_memory() at bay.
- * We temporarily drop inode_lock, however, and CAN block.
+ * Called with iprune_mutex held, keeping shrink_icache_memory() at bay.
+ * sb_inode_list_lock to protect the super block's list of inodes.
  */
 void fsnotify_unmount_inodes(struct super_block *sb)
 {
 	struct list_head *list = &sb->s_inodes;
 	struct inode *inode, *next_i, *need_iput = NULL;
 
-	spin_lock(&inode_lock);
 lock_again:
 	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
@@ -307,13 +305,12 @@ void fsnotify_unmount_inodes(struct supe
 		spin_unlock(&next_i->i_lock);
 
 		/*
-		 * We can safely drop inode_lock here because we hold
+		 * We can safely drop sb_inode_list_lock here because we hold
 		 * references on both inode and next_i.  Also no new inodes
 		 * will be added since the umount has begun.  Finally,
 		 * iprune_mutex keeps shrink_icache_memory() away.
 		 */
 		spin_unlock(&sb_inode_list_lock);
-		spin_unlock(&inode_lock);
 
 		if (need_iput_tmp)
 			iput(need_iput_tmp);
@@ -325,9 +322,7 @@ void fsnotify_unmount_inodes(struct supe
 
 		iput(inode);
 
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 	}
 	spin_unlock(&sb_inode_list_lock);
-	spin_unlock(&inode_lock);
 }
Index: linux-2.6/mm/backing-dev.c
===================================================================
--- linux-2.6.orig/mm/backing-dev.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/mm/backing-dev.c	2010-10-21 23:50:39.000000000 +1100
@@ -73,7 +73,6 @@ static int bdi_debug_stats_show(struct s
 	struct inode *inode;
 
 	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
-	spin_lock(&inode_lock);
 	spin_lock(&wb_inode_list_lock);
 	list_for_each_entry(inode, &wb->b_dirty, i_list)
 		nr_dirty++;
@@ -82,7 +81,6 @@ static int bdi_debug_stats_show(struct s
 	list_for_each_entry(inode, &wb->b_more_io, i_list)
 		nr_more_io++;
 	spin_unlock(&wb_inode_list_lock);
-	spin_unlock(&inode_lock);
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
 	bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
@@ -684,13 +682,11 @@ void bdi_destroy(struct backing_dev_info
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
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2010-10-21 23:49:57.000000000 +1100
+++ linux-2.6/mm/filemap.c	2010-10-21 23:50:27.000000000 +1100
@@ -80,7 +80,7 @@
  *  ->i_mutex
  *    ->i_alloc_sem             (various)
  *
- *  ->inode_lock
+ *  ->i_lock
  *    ->sb_lock			(fs/fs-writeback.c)
  *    ->mapping->tree_lock	(__sync_single_inode)
  *
@@ -98,8 +98,8 @@
  *    ->zone.lru_lock		(check_pte_range->isolate_lru_page)
  *    ->private_lock		(page_remove_rmap->set_page_dirty)
  *    ->tree_lock		(page_remove_rmap->set_page_dirty)
- *    ->inode_lock		(page_remove_rmap->set_page_dirty)
- *    ->inode_lock		(zap_pte_range->set_page_dirty)
+ *    ->i_lock			(page_remove_rmap->set_page_dirty)
+ *    ->i_lock			(zap_pte_range->set_page_dirty)
  *    ->private_lock		(zap_pte_range->__set_page_dirty_buffers)
  *
  *  ->task->proc_lock
Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c	2010-10-21 23:49:52.000000000 +1100
+++ linux-2.6/mm/rmap.c	2010-10-21 23:50:27.000000000 +1100
@@ -31,11 +31,11 @@
  *             swap_lock (in swap_duplicate, swap_info_get)
  *               mmlist_lock (in mmput, drain_mmlist and others)
  *               mapping->private_lock (in __set_page_dirty_buffers)
- *               inode_lock (in set_page_dirty's __mark_inode_dirty)
- *                 sb_lock (within inode_lock in fs/fs-writeback.c)
+ *               i_lock (in set_page_dirty's __mark_inode_dirty)
+ *                 sb_lock (within i_lock in fs/fs-writeback.c)
  *                 mapping->tree_lock (widely used, in set_page_dirty,
  *                           in arch-dependent flush_dcache_mmap_lock,
- *                           within inode_lock in __sync_single_inode)
+ *                           within i_lock in __sync_single_inode)
  *
  * (code doesn't rely on that order so it could be switched around)
  * ->tasklist_lock
Index: linux-2.6/Documentation/filesystems/Locking
===================================================================
--- linux-2.6.orig/Documentation/filesystems/Locking	2010-10-21 23:49:52.000000000 +1100
+++ linux-2.6/Documentation/filesystems/Locking	2010-10-21 23:50:27.000000000 +1100
@@ -114,7 +114,7 @@ of the locking scheme for directory oper
 destroy_inode:
 dirty_inode:				(must not sleep)
 write_inode:
-drop_inode:				!!!inode_lock!!!
+drop_inode:				!!!i_lock, sb_inode_list_lock!!!
 evict_inode:
 put_super:		write
 write_super:		read
Index: linux-2.6/Documentation/filesystems/vfs.txt
===================================================================
--- linux-2.6.orig/Documentation/filesystems/vfs.txt	2010-10-21 23:49:52.000000000 +1100
+++ linux-2.6/Documentation/filesystems/vfs.txt	2010-10-21 23:50:27.000000000 +1100
@@ -246,7 +246,7 @@ or bottom half).
 	should be synchronous or not, not all filesystems check this flag.
 
   drop_inode: called when the last access to the inode is dropped,
-	with the inode_lock spinlock held.
+	with the i_lock and sb_inode_list_lock spinlock held.
 
 	This method should be either NULL (normal UNIX filesystem
 	semantics) or "generic_delete_inode" (for filesystems that do not
Index: linux-2.6/fs/ntfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ntfs/inode.c	2010-10-21 23:49:52.000000000 +1100
+++ linux-2.6/fs/ntfs/inode.c	2010-10-21 23:50:27.000000000 +1100
@@ -54,7 +54,7 @@
  *
  * Return 1 if the attributes match and 0 if not.
  *
- * NOTE: This function runs with the inode_lock spin lock held so it is not
+ * NOTE: This function runs with the i_lock spin lock held so it is not
  * allowed to sleep.
  */
 int ntfs_test_inode(struct inode *vi, ntfs_attr *na)
@@ -98,7 +98,7 @@ int ntfs_test_inode(struct inode *vi, nt
  *
  * Return 0 on success and -errno on error.
  *
- * NOTE: This function runs with the inode_lock spin lock held so it is not
+ * NOTE: This function runs with the i_lock spin lock held so it is not
  * allowed to sleep. (Hence the GFP_ATOMIC allocation.)
  */
 static int ntfs_init_locked_inode(struct inode *vi, ntfs_attr *na)
Index: linux-2.6/fs/ocfs2/inode.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/inode.c	2010-10-21 23:49:52.000000000 +1100
+++ linux-2.6/fs/ocfs2/inode.c	2010-10-21 23:50:27.000000000 +1100
@@ -1195,7 +1195,7 @@ void ocfs2_evict_inode(struct inode *ino
 	ocfs2_clear_inode(inode);
 }
 
-/* Called under inode_lock, with no more references on the
+/* Called under i_lock, with no more references on the
  * struct inode, so it's safe here to check the flags field
  * and to manipulate i_nlink without any other locks. */
 int ocfs2_drop_inode(struct inode *inode)
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-10-21 23:50:40.000000000 +1100
@@ -1585,7 +1585,7 @@ struct super_operations {
 };
 
 /*
- * Inode state bits.  Protected by inode_lock.
+ * Inode state bits.  Protected by i_lock.
  *
  * Three bits determine the dirty state of the inode, I_DIRTY_SYNC,
  * I_DIRTY_DATASYNC and I_DIRTY_PAGES.
Index: linux-2.6/Documentation/filesystems/porting
===================================================================
--- linux-2.6.orig/Documentation/filesystems/porting	2010-10-21 23:49:52.000000000 +1100
+++ linux-2.6/Documentation/filesystems/porting	2010-10-21 23:50:27.000000000 +1100
@@ -299,7 +299,7 @@ be used instead.  It gets called wheneve
 remaining links or not.  Caller does *not* evict the pagecache or inode-associated
 metadata buffers; getting rid of those is responsibility of method, as it had
 been for ->delete_inode().
-	->drop_inode() returns int now; it's called on final iput() with inode_lock
+	->drop_inode() returns int now; it's called on final iput() with i_lock
 held and it returns true if filesystems wants the inode to be dropped.  As before,
 generic_drop_inode() is still the default and it's been updated appropriately.
 generic_delete_inode() is also alive and it consists simply of return 1.  Note that
@@ -318,3 +318,11 @@ if it's zero is not *and* *never* *had*
 may happen while the inode is in the middle of ->write_inode(); e.g. if you blindly
 free the on-disk inode, you may end up doing that while ->write_inode() is writing
 to it.
+
+--
+[mandatory]
+	inode_lock is gone, replaced by fine grained locks. See fs/inode.c
+for details of what locks to replace inode_lock with in order to protect
+particular things. Most of the time, a filesystem only needs ->i_lock, which
+protects *all* the inode state and its membership on lists that was
+previously protected with inode_lock.


