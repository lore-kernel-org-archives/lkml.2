Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab0J1Ln1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:43:27 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:60818 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750978Ab0J1LnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:43:25 -0400
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] fs: move i_wb_list out from under inode_lock
Date: Thu, 28 Oct 2010 22:42:40 +1100
Message-Id: <1288266161-28897-3-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288266161-28897-1-git-send-email-david@fromorbit.com>
References: <1288266161-28897-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Protect the inode writeback list with a new global lock
inode_wb_list_lock and use it to protect the list manipulations and
traversals. This lock replaces the inode_lock as the inodes on the
list can be validity checked while holding the inode->i_lock and
hence the inode_lock is no longer needed to protect the list.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/block_dev.c            |    4 +-
 fs/fs-writeback.c         |  152 ++++++++++++++++++++++++---------------------
 fs/inode.c                |   12 +++-
 fs/internal.h             |    7 ++-
 include/linux/writeback.h |    1 +
 mm/backing-dev.c          |    8 +-
 6 files changed, 103 insertions(+), 81 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index dea3b62..a94cbf0 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -56,11 +56,11 @@ EXPORT_SYMBOL(I_BDEV);
 static void bdev_inode_switch_bdi(struct inode *inode,
 			struct backing_dev_info *dst)
 {
-	spin_lock(&inode_lock);
+	spin_lock(&inode_wb_list_lock);
 	inode->i_data.backing_dev_info = dst;
 	if (inode->i_state & I_DIRTY)
 		list_move(&inode->i_wb_list, &dst->wb.b_dirty);
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_wb_list_lock);
 }
 
 static sector_t max_block(struct block_device *bdev)
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 7707a62..5b7cb95 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -162,6 +162,17 @@ void bdi_start_background_writeback(struct backing_dev_info *bdi)
 }
 
 /*
+ * Remove the inode from the writeback list it is on.
+ */
+void inode_wb_list_del(struct inode *inode)
+{
+	spin_lock(&inode_wb_list_lock);
+	list_del_init(&inode->i_wb_list);
+	spin_unlock(&inode_wb_list_lock);
+}
+
+
+/*
  * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
  * furthest end of its superblock's dirty-inode list.
  *
@@ -174,6 +185,7 @@ static void redirty_tail(struct inode *inode)
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
+	assert_spin_locked(&inode_wb_list_lock);
 	if (!list_empty(&wb->b_dirty)) {
 		struct inode *tail;
 
@@ -191,14 +203,17 @@ static void requeue_io(struct inode *inode)
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
+	assert_spin_locked(&inode_wb_list_lock);
 	list_move(&inode->i_wb_list, &wb->b_more_io);
 }
 
 static void inode_sync_complete(struct inode *inode)
 {
 	/*
-	 * Prevent speculative execution through spin_unlock(&inode_lock);
+	 * Prevent speculative execution through
+	 * spin_unlock(&inode_wb_list_lock);
 	 */
+
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_SYNC);
 }
@@ -272,6 +287,7 @@ static void move_expired_inodes(struct list_head *delaying_queue,
  */
 static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
 {
+	assert_spin_locked(&inode_wb_list_lock);
 	list_splice_init(&wb->b_more_io, &wb->b_io);
 	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
 }
@@ -294,25 +310,23 @@ static void inode_wait_for_writeback(struct inode *inode)
 	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
 	 while (inode->i_state & I_SYNC) {
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_wb_list_lock);
 		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
-		spin_lock(&inode_lock);
+		spin_lock(&inode_wb_list_lock);
 		spin_lock(&inode->i_lock);
 	}
 }
 
 /*
- * Write out an inode's dirty pages.  Called under inode_lock.  Either the
- * caller has ref on the inode (either via __iget or via syscall against an fd)
- * or the inode has I_WILL_FREE set (via generic_forget_inode)
+ * Write out an inode's dirty pages.  Called under inode_wb_list_lock.  Either
+ * the caller has ref on the inode (either via __iget or via syscall against an
+ * fd) or the inode has I_WILL_FREE set.
  *
  * If `wait' is set, wait on the writeout.
  *
  * The whole writeout design is quite complex and fragile.  We want to avoid
  * starvation of particular inodes when others are being redirtied, prevent
  * livelocks, etc.
- *
- * Called under inode_lock.
  */
 static int
 writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
@@ -354,7 +368,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY_PAGES;
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_wb_list_lock);
 
 	ret = do_writepages(mapping, wbc);
 
@@ -374,12 +388,10 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
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
@@ -387,7 +399,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			ret = err;
 	}
 
-	spin_lock(&inode_lock);
+	spin_lock(&inode_wb_list_lock);
 	spin_lock(&inode->i_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
@@ -529,10 +541,10 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 			 */
 			redirty_tail(inode);
 		}
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_wb_list_lock);
 		iput(inode);
 		cond_resched();
-		spin_lock(&inode_lock);
+		spin_lock(&inode_wb_list_lock);
 		if (wbc->nr_to_write <= 0) {
 			wbc->more_io = 1;
 			return 1;
@@ -551,7 +563,7 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
 
 	if (!wbc->wb_start)
 		wbc->wb_start = jiffies; /* livelock avoidance */
-	spin_lock(&inode_lock);
+	spin_lock(&inode_wb_list_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 
@@ -569,7 +581,7 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
 		if (ret)
 			break;
 	}
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_wb_list_lock);
 	/* Leave any unwritten inodes on b_io */
 }
 
@@ -578,11 +590,11 @@ static void __writeback_inodes_sb(struct super_block *sb,
 {
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	spin_lock(&inode_lock);
+	spin_lock(&inode_wb_list_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 	writeback_sb_inodes(sb, wb, wbc, true);
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_wb_list_lock);
 }
 
 /*
@@ -692,7 +704,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 		 * become available for writeback. Otherwise
 		 * we'll just busyloop.
 		 */
-		spin_lock(&inode_lock);
+		spin_lock(&inode_wb_list_lock);
 		if (!list_empty(&wb->b_more_io))  {
 			inode = wb_inode(wb->b_more_io.prev);
 			trace_wbc_writeback_wait(&wbc, wb->bdi);
@@ -700,7 +712,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 			inode_wait_for_writeback(inode);
 			spin_unlock(&inode->i_lock);
 		}
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_wb_list_lock);
 	}
 
 	return wrote;
@@ -940,6 +952,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	struct super_block *sb = inode->i_sb;
 	struct backing_dev_info *bdi = NULL;
 	bool wakeup_bdi = false;
+	int was_dirty;
 
 	/*
 	 * Don't do this for I_DIRTY_PAGES - that doesn't actually
@@ -963,63 +976,62 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	if (unlikely(block_dump))
 		block_dump___mark_inode_dirty(inode);
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
-	if ((inode->i_state & flags) != flags) {
-		const int was_dirty = inode->i_state & I_DIRTY;
+	if ((inode->i_state & flags) == flags)
+		goto out_unlock_inode;
 
-		inode->i_state |= flags;
+	was_dirty = inode->i_state & I_DIRTY;
+	inode->i_state |= flags;
 
-		/*
-		 * If the inode is being synced, just update its dirty state.
-		 * The unlocker will place the inode on the appropriate
-		 * superblock list, based upon its state.
-		 */
-		if (inode->i_state & I_SYNC)
-			goto out_unlock_inode;
+	/*
+	 * If the inode is being synced, just update its dirty state.
+	 * The unlocker will place the inode on the appropriate
+	 * superblock list, based upon its state.
+	 */
+	if (inode->i_state & I_SYNC)
+		goto out_unlock_inode;
 
-		/*
-		 * Only add valid (hashed) inodes to the superblock's
-		 * dirty list.  Add blockdev inodes as well.
-		 */
-		if (!S_ISBLK(inode->i_mode)) {
-			if (inode_unhashed(inode))
-				goto out_unlock_inode;
-		}
-		if (inode->i_state & I_FREEING)
+	/*
+	 * Only add valid (hashed) inodes to the superblock's
+	 * dirty list.  Add blockdev inodes as well.
+	 */
+	if (!S_ISBLK(inode->i_mode)) {
+		if (inode_unhashed(inode))
 			goto out_unlock_inode;
+	}
+	if (inode->i_state & I_FREEING)
+		goto out_unlock_inode;
 
+	/*
+	 * If the inode was already on b_dirty/b_io/b_more_io, don't
+	 * reposition it (that would break b_dirty time-ordering).
+	 */
+	if (was_dirty) {
+out_unlock_inode:
 		spin_unlock(&inode->i_lock);
-		/*
-		 * If the inode was already on b_dirty/b_io/b_more_io, don't
-		 * reposition it (that would break b_dirty time-ordering).
-		 */
-		if (!was_dirty) {
-			bdi = inode_to_bdi(inode);
+		return;
+	}
 
-			if (bdi_cap_writeback_dirty(bdi)) {
-				WARN(!test_bit(BDI_registered, &bdi->state),
-				     "bdi-%s not registered\n", bdi->name);
+	spin_unlock(&inode->i_lock);
+	bdi = inode_to_bdi(inode);
 
-				/*
-				 * If this is the first dirty inode for this
-				 * bdi, we have to wake-up the corresponding
-				 * bdi thread to make sure background
-				 * write-back happens later.
-				 */
-				if (!wb_has_dirty_io(&bdi->wb))
-					wakeup_bdi = true;
-			}
+	if (bdi_cap_writeback_dirty(bdi)) {
+		WARN(!test_bit(BDI_registered, &bdi->state),
+		     "bdi-%s not registered\n", bdi->name);
 
-			inode->dirtied_when = jiffies;
-			list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
-		}
-		goto out;
+		/*
+		 * If this is the first dirty inode for this bdi, we have to
+		 * wake-up the corresponding bdi thread to make sure background
+		 * write-back happens later.
+		 */
+		if (!wb_has_dirty_io(&bdi->wb))
+			wakeup_bdi = true;
 	}
-out_unlock_inode:
-	spin_unlock(&inode->i_lock);
-out:
-	spin_unlock(&inode_lock);
+
+	spin_lock(&inode_wb_list_lock);
+	inode->dirtied_when = jiffies;
+	list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
+	spin_unlock(&inode_wb_list_lock);
 
 	if (wakeup_bdi)
 		bdi_wakeup_thread_delayed(bdi);
@@ -1195,9 +1207,9 @@ int write_inode_now(struct inode *inode, int sync)
 		wbc.nr_to_write = 0;
 
 	might_sleep();
-	spin_lock(&inode_lock);
+	spin_lock(&inode_wb_list_lock);
 	ret = writeback_single_inode(inode, &wbc);
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_wb_list_lock);
 	if (sync)
 		inode_sync_wait(inode);
 	return ret;
@@ -1219,9 +1231,9 @@ int sync_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int ret;
 
-	spin_lock(&inode_lock);
+	spin_lock(&inode_wb_list_lock);
 	ret = writeback_single_inode(inode, wbc);
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_wb_list_lock);
 	return ret;
 }
 EXPORT_SYMBOL(sync_inode);
diff --git a/fs/inode.c b/fs/inode.c
index 44f28dd..130aa74 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -24,6 +24,7 @@
 #include <linux/mount.h>
 #include <linux/async.h>
 #include <linux/posix_acl.h>
+#include "internal.h"
 
 /*
  * inode locking rules.
@@ -34,6 +35,8 @@
  *   inode_lru, inode->i_lru
  * inode_sb_list_lock protects:
  *   sb->s_inodes, inode->i_sb_list
+ * inode_sb_list_lock protects:
+ *   bdi->wb.b_{dirty,io,more_io}, inode->i_wb_list
  *
  * Lock ordering:
  * inode_lock
@@ -42,6 +45,9 @@
  * inode_sb_list_lock
  *   inode->i_lock
  *     inode_lru_lock
+ *
+ * inode_wb_list_lock
+ *   inode->i_lock
  */
 
 /*
@@ -103,6 +109,7 @@ static struct hlist_head *inode_hashtable __read_mostly;
 DEFINE_SPINLOCK(inode_lock);
 
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_sb_list_lock);
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_wb_list_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
@@ -462,10 +469,7 @@ static void evict(struct inode *inode)
 
 	BUG_ON(!(inode->i_state & I_FREEING));
 
-	spin_lock(&inode_lock);
-	list_del_init(&inode->i_wb_list);
-	spin_unlock(&inode_lock);
-
+	inode_wb_list_del(inode);
 	inode_sb_list_del(inode);
 
 	if (op->evict_inode) {
diff --git a/fs/internal.h b/fs/internal.h
index 493baa1..fd3f700 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -106,7 +106,12 @@ extern void release_open_intent(struct nameidata *);
  * inode.c
  */
 extern int get_nr_dirty_inodes(void);
-extern int evict_inodes(struct super_block *);
+extern void evict_inodes(struct super_block *);
 extern int invalidate_inodes(struct super_block *);
 
 extern spinlock_t inode_sb_list_lock;
+
+/*
+ * fs-writeback.c
+ */
+extern void inode_wb_list_del(struct inode *inode);
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 242b6f8..e78a240 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -10,6 +10,7 @@
 struct backing_dev_info;
 
 extern spinlock_t inode_lock;
+extern spinlock_t inode_wb_list_lock;
 
 /*
  * fs/fs-writeback.c
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 15d5097..168ba5e 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -73,14 +73,14 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 	struct inode *inode;
 
 	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
-	spin_lock(&inode_lock);
+	spin_lock(&inode_wb_list_lock);
 	list_for_each_entry(inode, &wb->b_dirty, i_wb_list)
 		nr_dirty++;
 	list_for_each_entry(inode, &wb->b_io, i_wb_list)
 		nr_io++;
 	list_for_each_entry(inode, &wb->b_more_io, i_wb_list)
 		nr_more_io++;
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_wb_list_lock);
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
 	bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
@@ -682,11 +682,11 @@ void bdi_destroy(struct backing_dev_info *bdi)
 	if (bdi_has_dirty_io(bdi)) {
 		struct bdi_writeback *dst = &default_backing_dev_info.wb;
 
-		spin_lock(&inode_lock);
+		spin_lock(&inode_wb_list_lock);
 		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
 		list_splice(&bdi->wb.b_io, &dst->b_io);
 		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_wb_list_lock);
 	}
 
 	bdi_unregister(bdi);
-- 
1.7.1

