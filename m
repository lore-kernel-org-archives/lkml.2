Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0JRGXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 02:23:33 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:43057 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753754Ab0JRGV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 02:21:56 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/20] fs: icache remove inode_lock
Date: Mon, 18 Oct 2010 17:20:54 +1100
Message-Id: <1287382856-29529-19-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287382856-29529-1-git-send-email-david@fromorbit.com>
References: <1287382856-29529-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

All the functionality that the inode_lock protected has now been
wrapped up in new independent locks and/or functionality. Hence the
inode_lock does not serve a purpose any longer and hence can now be
removed.

Based on work originally done by Nick Piggin.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/filesystems/Locking |    2 +-
 Documentation/filesystems/porting |    8 ++-
 Documentation/filesystems/vfs.txt |    2 +-
 fs/block_dev.c                    |    2 -
 fs/buffer.c                       |    2 +-
 fs/drop_caches.c                  |    4 -
 fs/fs-writeback.c                 |   85 ++++++----------------
 fs/inode.c                        |  142 ++++++++-----------------------------
 fs/logfs/inode.c                  |    2 +-
 fs/notify/inode_mark.c            |   10 +--
 fs/notify/mark.c                  |    1 -
 fs/notify/vfsmount_mark.c         |    1 -
 fs/ntfs/inode.c                   |    4 +-
 fs/ocfs2/inode.c                  |    2 +-
 fs/quota/dquot.c                  |   12 +---
 include/linux/fs.h                |    2 +-
 include/linux/writeback.h         |    2 -
 mm/backing-dev.c                  |    4 -
 mm/filemap.c                      |    6 +-
 mm/rmap.c                         |    6 +-
 20 files changed, 80 insertions(+), 219 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 2db4283..7f98cd5 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -114,7 +114,7 @@ alloc_inode:
 destroy_inode:
 dirty_inode:				(must not sleep)
 write_inode:
-drop_inode:				!!!inode_lock!!!
+drop_inode:				!!!i_lock!!!
 evict_inode:
 put_super:		write
 write_super:		read
diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index b12c895..f182795 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -299,7 +299,7 @@ be used instead.  It gets called whenever the inode is evicted, whether it has
 remaining links or not.  Caller does *not* evict the pagecache or inode-associated
 metadata buffers; getting rid of those is responsibility of method, as it had
 been for ->delete_inode().
-	->drop_inode() returns int now; it's called on final iput() with inode_lock
+	->drop_inode() returns int now; it's called on final iput() with i_lock
 held and it returns true if filesystems wants the inode to be dropped.  As before,
 generic_drop_inode() is still the default and it's been updated appropriately.
 generic_delete_inode() is also alive and it consists simply of return 1.  Note that
@@ -318,3 +318,9 @@ if it's zero is not *and* *never* *had* *been* enough.  Final unlink() and iput(
 may happen while the inode is in the middle of ->write_inode(); e.g. if you blindly
 free the on-disk inode, you may end up doing that while ->write_inode() is writing
 to it.
+
+[mandatory]
+        The i_count field in the inode has been replaced with i_ref, which is
+a regular integer instead of an atomic_t.  Filesystems should not manipulate
+it directly but use helpers like igrab(), iref() and iput().
+
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 0dbbbe4..7ab923c 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -246,7 +246,7 @@ or bottom half).
 	should be synchronous or not, not all filesystems check this flag.
 
   drop_inode: called when the last access to the inode is dropped,
-	with the inode_lock spinlock held.
+	with the i_lock and sb_inode_list_lock spinlock held.
 
 	This method should be either NULL (normal UNIX filesystem
 	semantics) or "generic_delete_inode" (for filesystems that do not
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7909775..dae9871 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -58,14 +58,12 @@ static void bdev_inode_switch_bdi(struct inode *inode,
 {
 	struct backing_dev_info *old = inode->i_data.backing_dev_info;
 
-	spin_lock(&inode_lock);
 	bdi_lock_two(old, dst);
 	inode->i_data.backing_dev_info = dst;
 	if (!list_empty(&inode->i_wb_list))
 		list_move(&inode->i_wb_list, &dst->wb.b_dirty);
 	spin_unlock(&old->wb.b_lock);
 	spin_unlock(&dst->wb.b_lock);
-	spin_unlock(&inode_lock);
 }
 
 static sector_t max_block(struct block_device *bdev)
diff --git a/fs/buffer.c b/fs/buffer.c
index 3e7dca2..66f7afd 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1145,7 +1145,7 @@ __getblk_slow(struct block_device *bdev, sector_t block, int size)
  * inode list.
  *
  * mark_buffer_dirty() is atomic.  It takes bh->b_page->mapping->private_lock,
- * mapping->tree_lock and the global inode_lock.
+ * and mapping->tree_lock.
  */
 void mark_buffer_dirty(struct buffer_head *bh)
 {
diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index f958dd8..bd39f65 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -16,7 +16,6 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 {
 	struct inode *inode, *toput_inode = NULL;
 
-	spin_lock(&inode_lock);
 	spin_lock(&sb->s_inodes_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
@@ -28,15 +27,12 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 		inode->i_ref++;
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb->s_inodes_lock);
-		spin_unlock(&inode_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
 		toput_inode = inode;
-		spin_lock(&inode_lock);
 		spin_lock(&sb->s_inodes_lock);
 	}
 	spin_unlock(&sb->s_inodes_lock);
-	spin_unlock(&inode_lock);
 	iput(toput_inode);
 }
 
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index b75678b..04e8dd5 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -206,7 +206,7 @@ static void requeue_io(struct inode *inode)
 static void inode_sync_complete(struct inode *inode)
 {
 	/*
-	 * Prevent speculative execution through spin_unlock(&inode_lock);
+	 * Prevent speculative execution through spin_unlock(&inode->i_lock);
 	 */
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_SYNC);
@@ -306,27 +306,30 @@ static void inode_wait_for_writeback(struct inode *inode)
 	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
 	while (inode->i_state & I_SYNC) {
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
-		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
 	}
 }
 
-/*
- * Write out an inode's dirty pages.  Called under inode_lock.  Either the
- * caller has a reference on the inode or the inode has I_WILL_FREE set.
+/**
+ * sync_inode - write an inode and its pages to disk.
+ * @inode: the inode to sync
+ * @wbc: controls the writeback mode
+ *
+ * sync_inode() will write an inode and its pages to disk.  It will also
+ * correctly update the inode on its superblock's dirty inode lists and will
+ * update inode->i_state.
  *
- * If `wait' is set, wait on the writeout.
+ * The caller must have a ref on the inode or the inode has I_WILL_FREE set.
+ *
+ * If @wbc->sync_mode == WB_SYNC_ALL the we are doing a data integrity
+ * operation so we need to wait on the writeout.
  *
  * The whole writeout design is quite complex and fragile.  We want to avoid
  * starvation of particular inodes when others are being redirtied, prevent
  * livelocks, etc.
- *
- * Called under inode_lock.
  */
-static int
-writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
+int sync_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	struct address_space *mapping = inode->i_mapping;
@@ -368,7 +371,6 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY_PAGES;
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 
 	ret = do_writepages(mapping, wbc);
 
@@ -388,12 +390,10 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
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
@@ -401,7 +401,6 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			ret = err;
 	}
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
@@ -460,6 +459,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	inode_sync_complete(inode);
 	return ret;
 }
+EXPORT_SYMBOL(sync_inode);
 
 /*
  * For background writeback the caller does not have the sb pinned
@@ -552,7 +552,7 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 		spin_unlock(&wb->b_lock);
 
 		pages_skipped = wbc->pages_skipped;
-		writeback_single_inode(inode, wbc);
+		sync_inode(inode, wbc);
 		if (wbc->pages_skipped != pages_skipped) {
 			/*
 			 * writeback is not making progress due to locked
@@ -562,10 +562,8 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 			redirty_tail(inode);
 			spin_unlock(&wb->b_lock);
 		}
-		spin_unlock(&inode_lock);
 		iput(inode);
 		cond_resched();
-		spin_lock(&inode_lock);
 		spin_lock(&wb->b_lock);
 		if (wbc->nr_to_write <= 0) {
 			wbc->more_io = 1;
@@ -585,9 +583,7 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
 
 	if (!wbc->wb_start)
 		wbc->wb_start = jiffies; /* livelock avoidance */
-	spin_lock(&inode_lock);
 	spin_lock(&wb->b_lock);
-
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 
@@ -607,7 +603,6 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
 			break;
 	}
 	spin_unlock(&wb->b_lock);
-	spin_unlock(&inode_lock);
 	/* Leave any unwritten inodes on b_io */
 }
 
@@ -616,13 +611,11 @@ static void __writeback_inodes_sb(struct super_block *sb,
 {
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	spin_lock(&inode_lock);
 	spin_lock(&wb->b_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 	writeback_sb_inodes(sb, wb, wbc, true);
 	spin_unlock(&wb->b_lock);
-	spin_unlock(&inode_lock);
 }
 
 /*
@@ -732,7 +725,6 @@ static long wb_writeback(struct bdi_writeback *wb,
 		 * become available for writeback. Otherwise
 		 * we'll just busyloop.
 		 */
-		spin_lock(&inode_lock);
 		if (!list_empty(&wb->b_more_io))  {
 			spin_lock(&wb->b_lock);
 			inode = list_entry(wb->b_more_io.prev,
@@ -743,7 +735,6 @@ static long wb_writeback(struct bdi_writeback *wb,
 			inode_wait_for_writeback(inode);
 			spin_unlock(&inode->i_lock);
 		}
-		spin_unlock(&inode_lock);
 	}
 
 	return wrote;
@@ -1006,7 +997,6 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	if (unlikely(block_dump))
 		block_dump___mark_inode_dirty(inode);
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	if ((inode->i_state & flags) != flags) {
 		const int was_dirty = inode->i_state & I_DIRTY;
@@ -1064,8 +1054,6 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 out_unlock:
 	spin_unlock(&inode->i_lock);
 out:
-	spin_unlock(&inode_lock);
-
 	if (wakeup_bdi)
 		bdi_wakeup_thread_delayed(bdi);
 }
@@ -1098,7 +1086,6 @@ static void wait_sb_inodes(struct super_block *sb)
 	 */
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	spin_lock(&inode_lock);
 	spin_lock(&sb->s_inodes_lock);
 
 	/*
@@ -1121,14 +1108,12 @@ static void wait_sb_inodes(struct super_block *sb)
 		inode->i_ref++;
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb->s_inodes_lock);
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
+		 * s_inodes_lock.  We cannot iput the inode now as we can be
+		 * holding the last reference and we cannot iput it under
+		 * s_inodes_lock. So we keep the reference and iput it later.
 		 */
 		iput(old_inode);
 		old_inode = inode;
@@ -1137,11 +1122,9 @@ static void wait_sb_inodes(struct super_block *sb)
 
 		cond_resched();
 
-		spin_lock(&inode_lock);
 		spin_lock(&sb->s_inodes_lock);
 	}
 	spin_unlock(&sb->s_inodes_lock);
-	spin_unlock(&inode_lock);
 	iput(old_inode);
 }
 
@@ -1244,33 +1227,9 @@ int write_inode_now(struct inode *inode, int sync)
 		wbc.nr_to_write = 0;
 
 	might_sleep();
-	spin_lock(&inode_lock);
-	ret = writeback_single_inode(inode, &wbc);
-	spin_unlock(&inode_lock);
+	ret = sync_inode(inode, &wbc);
 	if (sync)
 		inode_sync_wait(inode);
 	return ret;
 }
 EXPORT_SYMBOL(write_inode_now);
-
-/**
- * sync_inode - write an inode and its pages to disk.
- * @inode: the inode to sync
- * @wbc: controls the writeback mode
- *
- * sync_inode() will write an inode and its pages to disk.  It will also
- * correctly update the inode on its superblock's dirty inode lists and will
- * update inode->i_state.
- *
- * The caller must have a ref on the inode.
- */
-int sync_inode(struct inode *inode, struct writeback_control *wbc)
-{
-	int ret;
-
-	spin_lock(&inode_lock);
-	ret = writeback_single_inode(inode, wbc);
-	spin_unlock(&inode_lock);
-	return ret;
-}
-EXPORT_SYMBOL(sync_inode);
diff --git a/fs/inode.c b/fs/inode.c
index 0198110..79b95f6 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -44,24 +44,20 @@
  *   inode_lru, i_lru
  *
  * Lock orders
- * inode_lock
- *   inode hash bucket lock
- *     inode->i_lock
+ * inode hash bucket lock
+ *   inode->i_lock
  *
- * inode_lock
- *   sb inode lock
- *     inode_lru_lock
- *       wb->b_lock
- *         inode->i_lock
+ * sb inode lock
+ *   inode_lru_lock
+ *     wb->b_lock
+ *       inode->i_lock
  *
- * inode_lock
- *   wb->b_lock
- *     sb_lock (pin sb for writeback)
- *     inode->i_lock
+ * wb->b_lock
+ *   sb_lock (pin sb for writeback)
+ *   inode->i_lock
  *
- * inode_lock
- *   inode_lru
- *     inode->i_lock
+ * inode_lru
+ *   inode->i_lock
  */
 /*
  * This is needed for the following functions:
@@ -114,14 +110,6 @@ static LIST_HEAD(inode_lru);
 static DEFINE_SPINLOCK(inode_lru_lock);
 
 /*
- * A simple spinlock to protect the list manipulations.
- *
- * NOTE! You also have to own the lock if you change
- * the i_state of an inode while it is in use..
- */
-DEFINE_SPINLOCK(inode_lock);
-
-/*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
  * icache shrinking path, and the umount path.  Without this exclusion,
  * by the time prune_icache calls iput for the inode whose pages it has
@@ -364,11 +352,9 @@ static void init_once(void *foo)
 void iref(struct inode *inode)
 {
 	WARN_ON(inode->i_ref < 1);
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	inode->i_ref++;
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL_GPL(iref);
 
@@ -396,28 +382,21 @@ void inode_lru_list_del(struct inode *inode)
 	spin_unlock(&inode_lru_lock);
 }
 
-static void __inode_sb_list_add(struct inode *inode)
-{
-	struct super_block *sb = inode->i_sb;
-
-	spin_lock(&sb->s_inodes_lock);
-	list_add(&inode->i_sb_list, &sb->s_inodes);
-	spin_unlock(&sb->s_inodes_lock);
-}
-
 /**
  * inode_sb_list_add - add inode to the superblock list of inodes
  * @inode: inode to add
  */
 void inode_sb_list_add(struct inode *inode)
 {
-	spin_lock(&inode_lock);
-	__inode_sb_list_add(inode);
-	spin_unlock(&inode_lock);
+	struct super_block *sb = inode->i_sb;
+
+	spin_lock(&sb->s_inodes_lock);
+	list_add(&inode->i_sb_list, &sb->s_inodes);
+	spin_unlock(&sb->s_inodes_lock);
 }
 EXPORT_SYMBOL_GPL(inode_sb_list_add);
 
-static void __inode_sb_list_del(struct inode *inode)
+static void inode_sb_list_del(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
@@ -448,22 +427,20 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 {
 	struct hlist_bl_head *b = inode_hashtable + hash(inode->i_sb, hashval);
 
-	spin_lock(&inode_lock);
 	hlist_bl_lock(b);
 	hlist_bl_add_head(&inode->i_hash, b);
 	hlist_bl_unlock(b);
-	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
 
 /**
- *	__remove_inode_hash - remove an inode from the hash
+ *	remove_inode_hash - remove an inode from the hash
  *	@inode: inode to unhash
  *
  *	Remove an inode from the superblock. inode->i_lock must be
  *	held.
  */
-static void __remove_inode_hash(struct inode *inode)
+void remove_inode_hash(struct inode *inode)
 {
 	struct hlist_bl_head *b;
 
@@ -472,19 +449,6 @@ static void __remove_inode_hash(struct inode *inode)
 	hlist_bl_del_init(&inode->i_hash);
 	hlist_bl_unlock(b);
 }
-
-/**
- *	remove_inode_hash - remove an inode from the hash
- *	@inode: inode to unhash
- *
- *	Remove an inode from the superblock.
- */
-void remove_inode_hash(struct inode *inode)
-{
-	spin_lock(&inode_lock);
-	__remove_inode_hash(inode);
-	spin_unlock(&inode_lock);
-}
 EXPORT_SYMBOL(remove_inode_hash);
 
 void end_writeback(struct inode *inode)
@@ -535,10 +499,8 @@ static void dispose_list(struct list_head *head)
 
 		evict(inode);
 
-		spin_lock(&inode_lock);
-		__remove_inode_hash(inode);
-		__inode_sb_list_del(inode);
-		spin_unlock(&inode_lock);
+		remove_inode_hash(inode);
+		inode_sb_list_del(inode);
 
 		wake_up_inode(inode);
 		destroy_inode(inode);
@@ -565,7 +527,6 @@ static int invalidate_list(struct super_block *sb, struct list_head *head,
 		 * change during umount anymore, and because iprune_sem keeps
 		 * shrink_icache_memory() away.
 		 */
-		cond_resched_lock(&inode_lock);
 		cond_resched_lock(&sb->s_inodes_lock);
 
 		next = next->next;
@@ -616,12 +577,10 @@ int invalidate_inodes(struct super_block *sb)
 	LIST_HEAD(throw_away);
 
 	down_write(&iprune_sem);
-	spin_lock(&inode_lock);
 	spin_lock(&sb->s_inodes_lock);
 	fsnotify_unmount_inodes(&sb->s_inodes);
 	busy = invalidate_list(sb, &sb->s_inodes, &throw_away);
 	spin_unlock(&sb->s_inodes_lock);
-	spin_unlock(&inode_lock);
 
 	dispose_list(&throw_away);
 	up_write(&iprune_sem);
@@ -632,7 +591,7 @@ EXPORT_SYMBOL(invalidate_inodes);
 
 /*
  * Scan `goal' inodes on the unused list for freeable ones. They are moved to a
- * temporary list and then are freed outside inode_lock by dispose_list().
+ * temporary list and then are freed outside locks by dispose_list().
  *
  * Any inodes which are pinned purely because of attached pagecache have their
  * pagecache removed.  If the inode has metadata buffers attached to
@@ -653,7 +612,6 @@ static void prune_icache(int nr_to_scan)
 	unsigned long reap = 0;
 
 	down_read(&iprune_sem);
-	spin_lock(&inode_lock);
 	spin_lock(&inode_lru_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
 		struct inode *inode;
@@ -686,7 +644,6 @@ static void prune_icache(int nr_to_scan)
 			inode->i_ref++;
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lru_lock);
-			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
 								0, -1);
@@ -702,7 +659,6 @@ static void prune_icache(int nr_to_scan)
 			 * the I_REFERENCED flag on the next pass and do the
 			 * same. Either way, we won't spin on it in this loop.
 			 */
-			spin_lock(&inode_lock);
 			spin_lock(&inode_lru_lock);
 			continue;
 		}
@@ -725,7 +681,6 @@ static void prune_icache(int nr_to_scan)
 	else
 		__count_vm_events(PGINODESTEAL, reap);
 	spin_unlock(&inode_lru_lock);
-	spin_unlock(&inode_lock);
 
 	dispose_list(&freeable);
 	up_read(&iprune_sem);
@@ -875,19 +830,15 @@ struct inode *new_inode(struct super_block *sb)
 {
 	struct inode *inode;
 
-	spin_lock_prefetch(&inode_lock);
-
 	inode = alloc_inode(sb);
 	if (inode) {
-		spin_lock(&inode_lock);
 		/*
 		 * set the inode state before we make the inode accessible to
 		 * the outside world.
 		 */
 		inode->i_ino = get_next_ino();
 		inode->i_state = 0;
-		__inode_sb_list_add(inode);
-		spin_unlock(&inode_lock);
+		inode_sb_list_add(inode);
 	}
 	return inode;
 }
@@ -946,7 +897,6 @@ static struct inode *get_new_inode(struct super_block *sb,
 	if (inode) {
 		struct inode *old;
 
-		spin_lock(&inode_lock);
 		hlist_bl_lock(b);
 		/* We released the lock, so.. */
 		old = find_inode(sb, b, test, data);
@@ -961,8 +911,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 			inode->i_state = I_NEW;
 			hlist_bl_add_head(&inode->i_hash, b);
 			hlist_bl_unlock(b);
-			__inode_sb_list_add(inode);
-			spin_unlock(&inode_lock);
+			inode_sb_list_add(inode);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -976,7 +925,6 @@ static struct inode *get_new_inode(struct super_block *sb,
 		 * allocated.
 		 */
 		hlist_bl_unlock(b);
-		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -985,7 +933,6 @@ static struct inode *get_new_inode(struct super_block *sb,
 
 set_failed:
 	hlist_bl_unlock(b);
-	spin_unlock(&inode_lock);
 	destroy_inode(inode);
 	return NULL;
 }
@@ -1003,7 +950,6 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 	if (inode) {
 		struct inode *old;
 
-		spin_lock(&inode_lock);
 		hlist_bl_lock(b);
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, b, ino);
@@ -1016,8 +962,7 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 			inode->i_state = I_NEW;
 			hlist_bl_add_head(&inode->i_hash, b);
 			hlist_bl_unlock(b);
-			__inode_sb_list_add(inode);
-			spin_unlock(&inode_lock);
+			inode_sb_list_add(inode);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -1031,7 +976,6 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 		 * allocated.
 		 */
 		hlist_bl_unlock(b);
-		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -1089,7 +1033,6 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 	static unsigned int counter;
 	ino_t res;
 
-	spin_lock(&inode_lock);
 	spin_lock(&iunique_lock);
 	do {
 		if (counter <= max_reserved)
@@ -1097,7 +1040,6 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 		res = counter++;
 	} while (!test_inode_iunique(sb, res));
 	spin_unlock(&iunique_lock);
-	spin_unlock(&inode_lock);
 
 	return res;
 }
@@ -1105,7 +1047,6 @@ EXPORT_SYMBOL(iunique);
 
 struct inode *igrab(struct inode *inode)
 {
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	if (!(inode->i_state & (I_FREEING|I_WILL_FREE))) {
 		inode->i_ref++;
@@ -1119,7 +1060,6 @@ struct inode *igrab(struct inode *inode)
 		 */
 		inode = NULL;
 	}
-	spin_unlock(&inode_lock);
 	return inode;
 }
 EXPORT_SYMBOL(igrab);
@@ -1141,7 +1081,7 @@ EXPORT_SYMBOL(igrab);
  *
  * Otherwise NULL is returned.
  *
- * Note, @test is called with the inode_lock held, so can't sleep.
+ * Note, @test is called with the i_lock held, so can't sleep.
  */
 static struct inode *ifind(struct super_block *sb,
 		struct hlist_bl_head *b,
@@ -1150,11 +1090,9 @@ static struct inode *ifind(struct super_block *sb,
 {
 	struct inode *inode;
 
-	spin_lock(&inode_lock);
 	hlist_bl_lock(b);
 	inode = find_inode(sb, b, test, data);
 	hlist_bl_unlock(b);
-	spin_unlock(&inode_lock);
 
 	if (inode && likely(wait))
 		wait_on_inode(inode);
@@ -1182,11 +1120,9 @@ static struct inode *ifind_fast(struct super_block *sb,
 {
 	struct inode *inode;
 
-	spin_lock(&inode_lock);
 	hlist_bl_lock(b);
 	inode = find_inode_fast(sb, b, ino);
 	hlist_bl_unlock(b);
-	spin_unlock(&inode_lock);
 
 	if (inode)
 		wait_on_inode(inode);
@@ -1212,7 +1148,7 @@ static struct inode *ifind_fast(struct super_block *sb,
  *
  * Otherwise NULL is returned.
  *
- * Note, @test is called with the inode_lock held, so can't sleep.
+ * Note, @test is called with the i_lock held, so can't sleep.
  */
 struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
@@ -1240,7 +1176,7 @@ EXPORT_SYMBOL(ilookup5_nowait);
  *
  * Otherwise NULL is returned.
  *
- * Note, @test is called with the inode_lock held, so can't sleep.
+ * Note, @test is called with the i_lock held, so can't sleep.
  */
 struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
@@ -1291,7 +1227,7 @@ EXPORT_SYMBOL(ilookup);
  * inode and this is returned locked, hashed, and with the I_NEW flag set. The
  * file system gets to fill it in before unlocking it via unlock_new_inode().
  *
- * Note both @test and @set are called with the inode_lock held, so can't sleep.
+ * Note both @test and @set are called with the i_lock held, so can't sleep.
  */
 struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *),
@@ -1352,7 +1288,6 @@ int insert_inode_locked(struct inode *inode)
 	while (1) {
 		struct hlist_bl_node *node;
 		struct inode *old = NULL;
-		spin_lock(&inode_lock);
 		hlist_bl_lock(b);
 		hlist_bl_for_each_entry(old, node, b, i_hash) {
 			if (old->i_ino != ino)
@@ -1369,13 +1304,11 @@ int insert_inode_locked(struct inode *inode)
 		if (likely(!node)) {
 			hlist_bl_add_head(&inode->i_hash, b);
 			hlist_bl_unlock(b);
-			spin_unlock(&inode_lock);
 			return 0;
 		}
 		old->i_ref++;
 		spin_unlock(&old->i_lock);
 		hlist_bl_unlock(b);
-		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!inode_unhashed(old))) {
 			iput(old);
@@ -1402,7 +1335,6 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 		struct hlist_bl_node *node;
 		struct inode *old = NULL;
 
-		spin_lock(&inode_lock);
 		hlist_bl_lock(b);
 		hlist_bl_for_each_entry(old, node, b, i_hash) {
 			if (old->i_sb != sb)
@@ -1419,13 +1351,11 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 		if (likely(!node)) {
 			hlist_bl_add_head(&inode->i_hash, b);
 			hlist_bl_unlock(b);
-			spin_unlock(&inode_lock);
 			return 0;
 		}
 		old->i_ref++;
 		spin_unlock(&old->i_lock);
 		hlist_bl_unlock(b);
-		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!inode_unhashed(old))) {
 			iput(old);
@@ -1487,16 +1417,13 @@ static void iput_final(struct inode *inode)
 				return;
 			}
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
-		__remove_inode_hash(inode);
+		remove_inode_hash(inode);
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
@@ -1513,8 +1440,7 @@ static void iput_final(struct inode *inode)
 	inode_wb_list_del(inode);
 	inode_lru_list_del(inode);
 
-	__inode_sb_list_del(inode);
-	spin_unlock(&inode_lock);
+	inode_sb_list_del(inode);
 	evict(inode);
 	remove_inode_hash(inode);
 	wake_up_inode(inode);
@@ -1534,7 +1460,6 @@ static void iput_final(struct inode *inode)
 void iput(struct inode *inode)
 {
 	if (inode) {
-		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
 		BUG_ON(inode->i_state & I_CLEAR);
 
@@ -1543,7 +1468,6 @@ void iput(struct inode *inode)
 			return;
 		}
 		spin_unlock(&inode->i_lock);
-		spin_lock(&inode_lock);
 	}
 }
 EXPORT_SYMBOL(iput);
@@ -1723,8 +1647,6 @@ EXPORT_SYMBOL(inode_wait);
  * It doesn't matter if I_NEW is not set initially, a call to
  * wake_up_inode() after removing from the hash list will DTRT.
  *
- * This is called with inode_lock held.
- *
  * Called with i_lock held and returns with it dropped.
  */
 static void __wait_on_freeing_inode(struct inode *inode)
@@ -1734,10 +1656,8 @@ static void __wait_on_freeing_inode(struct inode *inode)
 	wq = bit_waitqueue(&inode->i_state, __I_NEW);
 	prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	schedule();
 	finish_wait(wq, &wait.wait);
-	spin_lock(&inode_lock);
 }
 
 static __initdata unsigned long ihash_entries;
diff --git a/fs/logfs/inode.c b/fs/logfs/inode.c
index d8c71ec..a67b607 100644
--- a/fs/logfs/inode.c
+++ b/fs/logfs/inode.c
@@ -286,7 +286,7 @@ static int logfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	return ret;
 }
 
-/* called with inode_lock held */
+/* called with i_lock held */
 static int logfs_drop_inode(struct inode *inode)
 {
 	struct logfs_super *super = logfs_super(inode->i_sb);
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 203146b..265ecba 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -22,7 +22,6 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
-#include <linux/writeback.h> /* for inode_lock */
 
 #include <asm/atomic.h>
 
@@ -232,9 +231,8 @@ out:
  * fsnotify_unmount_inodes - an sb is unmounting.  handle any watched inodes.
  * @list: list of inodes being unmounted (sb->s_inodes)
  *
- * Called with inode_lock held, protecting the unmounting super block's list
- * of inodes, and with iprune_mutex held, keeping shrink_icache_memory() at bay.
- * We temporarily drop inode_lock, however, and CAN block.
+ * Called with iprune_mutex held, keeping shrink_icache_memory() at bay.
+ * sb->s_inodes_lock protects the super block's list of inodes.
  */
 void fsnotify_unmount_inodes(struct list_head *list)
 {
@@ -288,13 +286,12 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		}
 
 		/*
-		 * We can safely drop inode_lock here because we hold
+		 * We can safely drop sb->s_inodes_lock here because we hold
 		 * references on both inode and next_i.  Also no new inodes
 		 * will be added since the umount has begun.  Finally,
 		 * iprune_mutex keeps shrink_icache_memory() away.
 		 */
 		spin_unlock(&sb->s_inodes_lock);
-		spin_unlock(&inode_lock);
 
 		if (need_iput_tmp)
 			iput(need_iput_tmp);
@@ -306,7 +303,6 @@ void fsnotify_unmount_inodes(struct list_head *list)
 
 		iput(inode);
 
-		spin_lock(&inode_lock);
 		spin_lock(&sb->s_inodes_lock);
 	}
 }
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 325185e..50c0085 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -91,7 +91,6 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/srcu.h>
-#include <linux/writeback.h> /* for inode_lock */
 
 #include <asm/atomic.h>
 
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
index 56772b5..6f8eefe 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -23,7 +23,6 @@
 #include <linux/mount.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
-#include <linux/writeback.h> /* for inode_lock */
 
 #include <asm/atomic.h>
 
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 07fdef8..9b9375a 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -54,7 +54,7 @@
  *
  * Return 1 if the attributes match and 0 if not.
  *
- * NOTE: This function runs with the inode_lock spin lock held so it is not
+ * NOTE: This function runs with the i_lock spin lock held so it is not
  * allowed to sleep.
  */
 int ntfs_test_inode(struct inode *vi, ntfs_attr *na)
@@ -98,7 +98,7 @@ int ntfs_test_inode(struct inode *vi, ntfs_attr *na)
  *
  * Return 0 on success and -errno on error.
  *
- * NOTE: This function runs with the inode_lock spin lock held so it is not
+ * NOTE: This function runs with the i_lock spin lock held so it is not
  * allowed to sleep. (Hence the GFP_ATOMIC allocation.)
  */
 static int ntfs_init_locked_inode(struct inode *vi, ntfs_attr *na)
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index eece3e0..65c61e2 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1195,7 +1195,7 @@ void ocfs2_evict_inode(struct inode *inode)
 	ocfs2_clear_inode(inode);
 }
 
-/* Called under inode_lock, with no more references on the
+/* Called under i_lock, with no more references on the
  * struct inode, so it's safe here to check the flags field
  * and to manipulate i_nlink without any other locks. */
 int ocfs2_drop_inode(struct inode *inode)
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index b02a3e1..178bed4 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -76,7 +76,7 @@
 #include <linux/buffer_head.h>
 #include <linux/capability.h>
 #include <linux/quotaops.h>
-#include <linux/writeback.h> /* for inode_lock, oddly enough.. */
+#include <linux/writeback.h>
 
 #include <asm/uaccess.h>
 
@@ -896,7 +896,6 @@ static void add_dquot_ref(struct super_block *sb, int type)
 	int reserved = 0;
 #endif
 
-	spin_lock(&inode_lock);
 	spin_lock(&sb->s_inodes_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
@@ -914,21 +913,18 @@ static void add_dquot_ref(struct super_block *sb, int type)
 		inode->i_ref++;
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb->s_inodes_lock);
-		spin_unlock(&inode_lock);
 
 		iput(old_inode);
 		__dquot_initialize(inode, type);
 		/* We hold a reference to 'inode' so it couldn't have been
-		 * removed from s_inodes list while we dropped the inode_lock.
+		 * removed from s_inodes list while we dropped the lock.
 		 * We cannot iput the inode now as we can be holding the last
-		 * reference and we cannot iput it under inode_lock. So we
+		 * reference and we cannot iput it under the lock. So we
 		 * keep the reference and iput it later. */
 		old_inode = inode;
-		spin_lock(&inode_lock);
 		spin_lock(&sb->s_inodes_lock);
 	}
 	spin_unlock(&sb->s_inodes_lock);
-	spin_unlock(&inode_lock);
 	iput(old_inode);
 
 #ifdef CONFIG_QUOTA_DEBUG
@@ -1009,7 +1005,6 @@ static void remove_dquot_ref(struct super_block *sb, int type,
 	struct inode *inode;
 	int reserved = 0;
 
-	spin_lock(&inode_lock);
 	spin_lock(&sb->s_inodes_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		/*
@@ -1025,7 +1020,6 @@ static void remove_dquot_ref(struct super_block *sb, int type,
 		}
 	}
 	spin_unlock(&sb->s_inodes_lock);
-	spin_unlock(&inode_lock);
 #ifdef CONFIG_QUOTA_DEBUG
 	if (reserved) {
 		printk(KERN_WARNING "VFS (%s): Writes happened after quota"
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f222ce8..abdb756 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1593,7 +1593,7 @@ struct super_operations {
 };
 
 /*
- * Inode state bits.  Protected by inode_lock.
+ * Inode state bits.  Protected by i_lock.
  *
  * Three bits determine the dirty state of the inode, I_DIRTY_SYNC,
  * I_DIRTY_DATASYNC and I_DIRTY_PAGES.
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 242b6f8..fa38cf0 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -9,8 +9,6 @@
 
 struct backing_dev_info;
 
-extern spinlock_t inode_lock;
-
 /*
  * fs/fs-writeback.c
  */
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 40b84c6..af060d4 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -73,7 +73,6 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 	struct inode *inode;
 
 	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
-	spin_lock(&inode_lock);
 	spin_lock(&wb->b_lock);
 	list_for_each_entry(inode, &wb->b_dirty, i_wb_list)
 		nr_dirty++;
@@ -82,7 +81,6 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 	list_for_each_entry(inode, &wb->b_more_io, i_wb_list)
 		nr_more_io++;
 	spin_unlock(&wb->b_lock);
-	spin_unlock(&inode_lock);
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
 	bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
@@ -698,14 +696,12 @@ void bdi_destroy(struct backing_dev_info *bdi)
 	if (bdi_has_dirty_io(bdi)) {
 		struct bdi_writeback *dst = &default_backing_dev_info.wb;
 
-		spin_lock(&inode_lock);
 		bdi_lock_two(bdi, &default_backing_dev_info);
 		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
 		list_splice(&bdi->wb.b_io, &dst->b_io);
 		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
 		spin_unlock(&bdi->wb.b_lock);
 		spin_unlock(&dst->b_lock);
-		spin_unlock(&inode_lock);
 	}
 
 	bdi_unregister(bdi);
diff --git a/mm/filemap.c b/mm/filemap.c
index 3d4df44..ece6ef2 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
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
diff --git a/mm/rmap.c b/mm/rmap.c
index 92e6757..dbfccae 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
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
-- 
1.7.1

