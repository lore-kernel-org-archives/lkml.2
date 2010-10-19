Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab0JSQWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:22:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49278 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab0JSQWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:22:09 -0400
Date: Tue, 19 Oct 2010 12:22:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: npiggin@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 00/35] my inode scaling series for review
Message-ID: <20101019162207.GA3555@infradead.org>
References: <20101019034216.319085068@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019034216.319085068@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 02:42:16PM +1100, npiggin@kernel.dk wrote:
> * My locking design allows i_lock to lock the entire state of the icache
>   for a particular inode. Not so with Dave's, and he had to add code not
>   required with inode_lock synchronisation or my i_lock synchronisation.
>   I prefer being very conservative about making changes, especially before
>   inode_lock is lifted (which will be the end-point of bisection for any
>   locking breakage before it).

Which code exaxtly?  I've done a diff between his inode.c and yours - 
and Dave's is a lot simpler.  Mostly due to the more regular and simpler
locking, but also because he did various cleanups before tackling the
actual locking.  See the diff at the end of this mail for a direct
comparism.

> * As far as I can tell, I have addressed all Dave and Christoph's real
>   concerns.  The disagreement about the i_lock locking model can easily be
>   solved if they post a couple of small incremental patches to the end of the
>   series, making i_lock locking less regular and no longer protecting icache
>   state of that given inode (like inode_lock was able to pre-patchset). I've
>   repeatedly disagreed with this approach, however.

The diff below and looking over the other patches doesn't make it look
like you have actually picked up much at all, neither of the feedback
from me, nor Dave nor Andrew or Al. 

Even worse than that none of the sometimes quite major bug fixes were
picked up either.  The get_new_inode re-lookup locking is still wrong,
the exofs fix is not there. And the fix for mapping move of the
block devices which we unfortunately still have seems to be paper
over by passing the bdi_writeback to the requing helpers instead
of fixing it.  While this makes the assert_spin_lock panic go away
it still leaves a really nasty race as your version locks a different
bdi than the one that it actually modifies.

There's also another bug which was there in your very first version
with an XXX but that Dave AFAIK never picked up: invalidate_inodes is
called from a lot of other places than umount, and unlocked list
access is everything but safe there.

Anyway, below is the diff between the two trees.  I've cut down the
curn in filesystem a bit - every related to the gratious i_ref vs i_ref
and iref vs inode_get difference, as well as the call_rcu boilerplat
additions and get_next_ino calls are removed to make it somewhat
readable.

To me the inode.c and especially fs-writeback.c code in Dave's version
looks a lot more polished.

 b/Documentation/filesystems/porting |   12 
 b/Documentation/filesystems/vfs.txt |   16 
 b/fs/block_dev.c                    |   50 -
 b/fs/btrfs/inode.c                  |    2 
 b/fs/dcache.c                       |   31 -
 b/fs/drop_caches.c                  |   24 
 b/fs/fs-writeback.c                 |  308 ++++------
 b/fs/inode.c                        | 1095  +++++++++++++++---------------------
 b/fs/internal.h                     |   23 
 b/fs/nilfs2/gcdat.c                 |    1 
 b/fs/nilfs2/gcinode.c               |    7 
 b/fs/notify/inode_mark.c            |   41 -
 b/fs/notify/mark.c                  |    1 
 b/fs/notify/vfsmount_mark.c         |    1 
 b/fs/quota/dquot.c                  |   56 -
 b/fs/super.c                        |   17 
 b/include/linux/backing-dev.h       |    5 
 b/include/linux/bit_spinlock.h      |    4 
 b/include/linux/fs.h                |  107 ---
 b/include/linux/fsnotify_backend.h  |    4 
 b/include/linux/list_bl.h           |   41 -
 b/include/linux/poison.h            |    2 
 b/mm/backing-dev.c                  |   19 
 b/fs/xfs/linux-2.6/xfs_buf.c        |    4 
 b/include/linux/rculist_bl.h        |  128 ----
 25 files changed, 804 insertions(+), 1195 deletions(-)

diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index 45160c4..f182795 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -319,14 +319,8 @@ may happen while the inode is in the middle of ->write_inode(); e.g. if you blin
 free the on-disk inode, you may end up doing that while ->write_inode() is writing
 to it.
 
---
 [mandatory]
-	inode_lock is gone, replaced by fine grained locks. See fs/inode.c
-for details of what locks to replace inode_lock with in order to protect
-particular things. Most of the time, a filesystem only needs ->i_lock, which
-protects *all* the inode state and its membership on lists that was
-previously protected with inode_lock.
+        The i_count field in the inode has been replaced with i_ref, which is
+a regular integer instead of an atomic_t.  Filesystems should not manipulate
+it directly but use helpers like igrab(), iref() and iput().
 
---
-[mandatory]
-	Filessystems must RCU-free their inodes. Lots of examples.
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index f63b131..7ab923c 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -246,7 +246,7 @@ or bottom half).
 	should be synchronous or not, not all filesystems check this flag.
 
   drop_inode: called when the last access to the inode is dropped,
-	with the i_lock spinlock held.
+	with the i_lock and sb_inode_list_lock spinlock held.
 
 	This method should be either NULL (normal UNIX filesystem
 	semantics) or "generic_delete_inode" (for filesystems that do not
@@ -347,8 +347,8 @@ otherwise noted.
   lookup: called when the VFS needs to look up an inode in a parent
 	directory. The name to look for is found in the dentry. This
 	method must call d_add() to insert the found inode into the
-	dentry. The "i_refs" field in the inode structure should be
-	incremented. If the named inode does not exist a NULL inode
+	dentry. A reference to the inode should be taken via the
+	iref() function.  If the named inode does not exist a NULL inode
 	should be inserted into the dentry (this is called a negative
 	dentry). Returning an error code from this routine must only
 	be done on a real error, otherwise creating inodes with system
@@ -926,11 +926,11 @@ manipulate dentries:
 	d_instantiate()
 
   d_instantiate: add a dentry to the alias hash list for the inode and
-	updates the "d_inode" member. The "i_refs" member in the
-	inode structure should be set/incremented. If the inode
-	pointer is NULL, the dentry is called a "negative
-	dentry". This function is commonly called when an inode is
-	created for an existing negative dentry
+	updates the "d_inode" member. A reference to the inode
+	should be taken via the iref() function.  If the inode
+	pointer is NULL, the dentry is called a "negative dentry".
+	This function is commonly called when an inode is created
+	for an existing negative dentry
 
   d_lookup: look up a dentry given its parent and path name component
 	It looks up the child of that given name from the dcache
diff --git a/fs/block_dev.c b/fs/block_dev.c
index a2de19e..dae9871 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -48,6 +48,24 @@ inline struct block_device *I_BDEV(struct inode *inode)
 
 EXPORT_SYMBOL(I_BDEV);
 
+/*
+ * move the inode from it's current bdi to the a new bdi. if the inode is dirty
+ * we need to move it onto the dirty list of @dst so that the inode is always
+ * on the right list.
+ */
+static void bdev_inode_switch_bdi(struct inode *inode,
+			struct backing_dev_info *dst)
+{
+	struct backing_dev_info *old = inode->i_data.backing_dev_info;
+
+	bdi_lock_two(old, dst);
+	inode->i_data.backing_dev_info = dst;
+	if (!list_empty(&inode->i_wb_list))
+		list_move(&inode->i_wb_list, &dst->wb.b_dirty);
+	spin_unlock(&old->wb.b_lock);
+	spin_unlock(&dst->wb.b_lock);
+}
+
 static sector_t max_block(struct block_device *bdev)
 {
 	sector_t retval = ~((sector_t)0);
@@ -395,20 +413,13 @@ static struct inode *bdev_alloc_inode(struct super_block *sb)
 	return &ei->vfs_inode;
 }
 
-static void bdev_i_callback(struct rcu_head *head)
+static void bdev_destroy_inode(struct inode *inode)
 {
-	struct inode *inode = container_of(head, struct inode, i_rcu);
 	struct bdev_inode *bdi = BDEV_I(inode);
 
-	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(bdev_cachep, bdi);
 }
 
-static void bdev_destroy_inode(struct inode *inode)
-{
-	call_rcu(&inode->i_rcu, bdev_i_callback);
-}
-
 static void init_once(void *foo)
 {
 	struct bdev_inode *ei = (struct bdev_inode *) foo;
@@ -557,8 +568,7 @@ EXPORT_SYMBOL(bdget);
  */
 struct block_device *bdgrab(struct block_device *bdev)
 {
-	inode_get(bdev->bd_inode);
-
+	iref(bdev->bd_inode);
 	return bdev;
 }
 
@@ -599,12 +609,11 @@ static struct block_device *bd_acquire(struct inode *inode)
 		spin_lock(&bdev_lock);
 		if (!inode->i_bdev) {
 			/*
-			 * We take an additional bd_inode->i_refs for inode,
-			 * and it's released in clear_inode() of inode.
-			 * So, we can access it via ->i_mapping always
-			 * without igrab().
+			 * We take an additional bdev reference here so
+			 * we can access it via ->i_mapping always
+			 * without first needing to grab a reference.
 			 */
-			inode_get(bdev->bd_inode);
+			bdgrab(bdev);
 			inode->i_bdev = bdev;
 			inode->i_mapping = bdev->bd_inode->i_mapping;
 			list_add(&inode->i_devices, &bdev->bd_inodes);
@@ -1398,7 +1407,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 				bdi = blk_get_backing_dev_info(bdev);
 				if (bdi == NULL)
 					bdi = &default_backing_dev_info;
-				bdev->bd_inode->i_data.backing_dev_info = bdi;
+				bdev_inode_switch_bdi(bdev->bd_inode, bdi);
 			}
 			if (bdev->bd_invalidated)
 				rescan_partitions(disk, bdev);
@@ -1413,8 +1422,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 			if (ret)
 				goto out_clear;
 			bdev->bd_contains = whole;
-			bdev->bd_inode->i_data.backing_dev_info =
-			   whole->bd_inode->i_data.backing_dev_info;
+			bdev_inode_switch_bdi(bdev->bd_inode,
+				whole->bd_inode->i_data.backing_dev_info);
 			bdev->bd_part = disk_get_part(disk, partno);
 			if (!(disk->flags & GENHD_FL_UP) ||
 			    !bdev->bd_part || !bdev->bd_part->nr_sects) {
@@ -1447,7 +1456,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	disk_put_part(bdev->bd_part);
 	bdev->bd_disk = NULL;
 	bdev->bd_part = NULL;
-	bdev->bd_inode->i_data.backing_dev_info = &default_backing_dev_info;
+	bdev_inode_switch_bdi(bdev->bd_inode, &default_backing_dev_info);
 	if (bdev != bdev->bd_contains)
 		__blkdev_put(bdev->bd_contains, mode, 1);
 	bdev->bd_contains = NULL;
@@ -1541,7 +1550,8 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 		disk_put_part(bdev->bd_part);
 		bdev->bd_part = NULL;
 		bdev->bd_disk = NULL;
-		bdev->bd_inode->i_data.backing_dev_info = &default_backing_dev_info;
+		bdev_inode_switch_bdi(bdev->bd_inode,
+					&default_backing_dev_info);
 		if (bdev != bdev->bd_contains)
 			victim = bdev->bd_contains;
 		bdev->bd_contains = NULL;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4da677e..c7a2bef 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3854,7 +3855,7 @@ again:
 	p = &root->inode_tree.rb_node;
 	parent = NULL;
 
-	if (hlist_bl_unhashed(&inode->i_hash))
+	if (inode_unhashed(inode))
 		return;
 
 	spin_lock(&root->inode_lock);
diff --git a/fs/dcache.c b/fs/dcache.c
index e309f9b..83293be 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -534,7 +534,7 @@ restart:
  *
  * This function may fail to free any resources if all the dentries are in use.
  */
-static void prune_dcache(unsigned long count)
+static void prune_dcache(int count)
 {
 	struct super_block *sb, *p = NULL;
 	int w_count;
@@ -887,8 +887,7 @@ void shrink_dcache_parent(struct dentry * parent)
 EXPORT_SYMBOL(shrink_dcache_parent);
 
 /*
- * shrink_dcache_memory scans and reclaims unused dentries. This function
- * is defined according to the shrinker API described in linux/mm.h.
+ * Scan `nr' dentries and return the number which remain.
  *
  * We need to avoid reentering the filesystem if the caller is performing a
  * GFP_NOFS allocation attempt.  One example deadlock is:
@@ -896,30 +895,22 @@ EXPORT_SYMBOL(shrink_dcache_parent);
  * ext2_new_block->getblk->GFP->shrink_dcache_memory->prune_dcache->
  * prune_one_dentry->dput->dentry_iput->iput->inode->i_sb->s_op->put_inode->
  * ext2_discard_prealloc->ext2_free_blocks->lock_super->DEADLOCK.
+ *
+ * In this case we return -1 to tell the caller that we baled.
  */
-static void shrink_dcache_memory(struct shrinker *shrink,
-		struct zone *zone, unsigned long scanned,
-		unsigned long total, unsigned long global,
-		unsigned long flags, gfp_t gfp_mask)
+static int shrink_dcache_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
 {
-	static unsigned long nr_to_scan;
-	unsigned long nr;
-
-	shrinker_add_scan(&nr_to_scan, scanned, global,
-			dentry_stat.nr_unused,
-			SHRINK_DEFAULT_SEEKS * 100 / sysctl_vfs_cache_pressure);
-	if (!(gfp_mask & __GFP_FS))
-	       return;
-
-	while ((nr = shrinker_do_scan(&nr_to_scan, SHRINK_BATCH))) {
+	if (nr) {
+		if (!(gfp_mask & __GFP_FS))
+			return -1;
 		prune_dcache(nr);
-		count_vm_events(SLABS_SCANNED, nr);
-		cond_resched();
 	}
+	return (dentry_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
 }
 
 static struct shrinker dcache_shrinker = {
-	.shrink_zone = shrink_dcache_memory,
+	.shrink = shrink_dcache_memory,
+	.seeks = DEFAULT_SEEKS,
 };
 
 /**
diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 2c8b7df..bd39f65 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -16,29 +16,33 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 {
 	struct inode *inode, *toput_inode = NULL;
 
-	rcu_read_lock();
-	do_inode_list_for_each_entry_rcu(sb, inode) {
+	spin_lock(&sb->s_inodes_lock);
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)
-				|| inode->i_mapping->nrpages == 0) {
+		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+		    (inode->i_mapping->nrpages == 0)) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		inode_get_ilock(inode);
+		inode->i_ref++;
 		spin_unlock(&inode->i_lock);
-		rcu_read_unlock();
+		spin_unlock(&sb->s_inodes_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
 		toput_inode = inode;
-		rcu_read_lock();
-	} while_inode_list_for_each_entry_rcu
-	rcu_read_unlock();
+		spin_lock(&sb->s_inodes_lock);
+	}
+	spin_unlock(&sb->s_inodes_lock);
 	iput(toput_inode);
 }
 
 static void drop_slab(void)
 {
-	shrink_all_slab();
+	int nr_objects;
+
+	do {
+		nr_objects = shrink_slab(1000, GFP_KERNEL, 1000);
+	} while (nr_objects > 10);
 }
 
 int drop_caches_sysctl_handler(ctl_table *table, int write,
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 9b2e2c3..04e8dd5 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -69,6 +69,16 @@ int writeback_in_progress(struct backing_dev_info *bdi)
 	return test_bit(BDI_writeback_running, &bdi->state);
 }
 
+static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+
+	if (strcmp(sb->s_type->name, "bdev") == 0)
+		return inode->i_mapping->backing_dev_info;
+
+	return sb->s_bdi;
+}
+
 static void bdi_queue_work(struct backing_dev_info *bdi,
 		struct wb_writeback_work *work)
 {
@@ -147,6 +157,18 @@ void bdi_start_background_writeback(struct backing_dev_info *bdi)
 }
 
 /*
+ * Remove the inode from the writeback list it is on.
+ */
+void inode_wb_list_del(struct inode *inode)
+{
+	struct backing_dev_info *bdi = inode_to_bdi(inode);
+
+	spin_lock(&bdi->wb.b_lock);
+	list_del_init(&inode->i_wb_list);
+	spin_unlock(&bdi->wb.b_lock);
+}
+
+/*
  * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
  * furthest end of its superblock's dirty-inode list.
  *
@@ -155,26 +177,30 @@ void bdi_start_background_writeback(struct backing_dev_info *bdi)
  * the case then the inode must have been redirtied while it was being written
  * out and we don't reset its dirtied_when.
  */
-static void redirty_tail(struct bdi_writeback *wb, struct inode *inode)
+static void redirty_tail(struct inode *inode)
 {
+	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
+
 	assert_spin_locked(&wb->b_lock);
 	if (!list_empty(&wb->b_dirty)) {
 		struct inode *tail;
 
-		tail = list_entry(wb->b_dirty.next, struct inode, i_io);
+		tail = list_entry(wb->b_dirty.next, struct inode, i_wb_list);
 		if (time_before(inode->dirtied_when, tail->dirtied_when))
 			inode->dirtied_when = jiffies;
 	}
-	list_move(&inode->i_io, &wb->b_dirty);
+	list_move(&inode->i_wb_list, &wb->b_dirty);
 }
 
 /*
  * requeue inode for re-scanning after bdi->b_io list is exhausted.
  */
-static void requeue_io(struct bdi_writeback *wb, struct inode *inode)
+static void requeue_io(struct inode *inode)
 {
+	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
+
 	assert_spin_locked(&wb->b_lock);
-	list_move(&inode->i_io, &wb->b_more_io);
+	list_move(&inode->i_wb_list, &wb->b_more_io);
 }
 
 static void inode_sync_complete(struct inode *inode)
@@ -215,14 +241,15 @@ static void move_expired_inodes(struct list_head *delaying_queue,
 	int do_sb_sort = 0;
 
 	while (!list_empty(delaying_queue)) {
-		inode = list_entry(delaying_queue->prev, struct inode, i_io);
+		inode = list_entry(delaying_queue->prev,
+						struct inode, i_wb_list);
 		if (older_than_this &&
 		    inode_dirtied_after(inode, *older_than_this))
 			break;
 		if (sb && sb != inode->i_sb)
 			do_sb_sort = 1;
 		sb = inode->i_sb;
-		list_move(&inode->i_io, &tmp);
+		list_move(&inode->i_wb_list, &tmp);
 	}
 
 	/* just one sb in list, splice to dispatch_queue and we're done */
@@ -233,12 +260,12 @@ static void move_expired_inodes(struct list_head *delaying_queue,
 
 	/* Move inodes from one superblock together */
 	while (!list_empty(&tmp)) {
-		inode = list_entry(tmp.prev, struct inode, i_io);
+		inode = list_entry(tmp.prev, struct inode, i_wb_list);
 		sb = inode->i_sb;
 		list_for_each_prev_safe(pos, node, &tmp) {
-			inode = list_entry(pos, struct inode, i_io);
+			inode = list_entry(pos, struct inode, i_wb_list);
 			if (inode->i_sb == sb)
-				list_move(&inode->i_io, dispatch_queue);
+				list_move(&inode->i_wb_list, dispatch_queue);
 		}
 	}
 }
@@ -256,6 +283,7 @@ static void move_expired_inodes(struct list_head *delaying_queue,
  */
 static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
 {
+	assert_spin_locked(&wb->b_lock);
 	list_splice_init(&wb->b_more_io, &wb->b_io);
 	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
 }
@@ -270,45 +298,46 @@ static int write_inode(struct inode *inode, struct writeback_control *wbc)
 /*
  * Wait for writeback on an inode to complete.
  */
-static void inode_wait_for_writeback(struct bdi_writeback *wb,
-					struct inode *inode)
+static void inode_wait_for_writeback(struct inode *inode)
 {
 	DEFINE_WAIT_BIT(wq, &inode->i_state, __I_SYNC);
 	wait_queue_head_t *wqh;
 
 	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
 	while (inode->i_state & I_SYNC) {
-		spin_unlock(&wb->b_lock);
 		spin_unlock(&inode->i_lock);
 		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
 		spin_lock(&inode->i_lock);
-		spin_lock(&wb->b_lock);
 	}
 }
 
-/*
- * Write out an inode's dirty pages. Either the caller has ref on the inode
- * (either via inode_get or via syscall against an fd) or the inode has
- * I_WILL_FREE set (via generic_forget_inode)
+/**
+ * sync_inode - write an inode and its pages to disk.
+ * @inode: the inode to sync
+ * @wbc: controls the writeback mode
  *
- * If `wait' is set, wait on the writeout.
+ * sync_inode() will write an inode and its pages to disk.  It will also
+ * correctly update the inode on its superblock's dirty inode lists and will
+ * update inode->i_state.
+ *
+ * The caller must have a ref on the inode or the inode has I_WILL_FREE set.
+ *
+ * If @wbc->sync_mode == WB_SYNC_ALL the we are doing a data integrity
+ * operation so we need to wait on the writeout.
  *
  * The whole writeout design is quite complex and fragile.  We want to avoid
  * starvation of particular inodes when others are being redirtied, prevent
  * livelocks, etc.
- *
- * Called under wb_inode_list_lock and i_lock. May drop the locks but returns
- * with them locked.
  */
-static int
-writeback_single_inode(struct bdi_writeback *wb, struct inode *inode,
-			struct writeback_control *wbc)
+int sync_inode(struct inode *inode, struct writeback_control *wbc)
 {
+	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	struct address_space *mapping = inode->i_mapping;
 	unsigned dirty;
 	int ret;
 
-	if (!inode->i_refs)
+	spin_lock(&inode->i_lock);
+	if (!inode->i_ref)
 		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
 	else
 		WARN_ON(inode->i_state & I_WILL_FREE);
@@ -323,14 +352,17 @@ writeback_single_inode(struct bdi_writeback *wb, struct inode *inode,
 		 * completed a full scan of b_io.
 		 */
 		if (wbc->sync_mode != WB_SYNC_ALL) {
-			requeue_io(wb, inode);
+			spin_unlock(&inode->i_lock);
+			spin_lock(&bdi->wb.b_lock);
+			requeue_io(inode);
+			spin_unlock(&bdi->wb.b_lock);
 			return 0;
 		}
 
 		/*
 		 * It's a data-integrity sync.  We must wait.
 		 */
-		inode_wait_for_writeback(wb, inode);
+		inode_wait_for_writeback(inode);
 	}
 
 	BUG_ON(inode->i_state & I_SYNC);
@@ -338,7 +370,6 @@ writeback_single_inode(struct bdi_writeback *wb, struct inode *inode,
 	/* Set I_SYNC, reset I_DIRTY_PAGES */
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY_PAGES;
-	spin_unlock(&wb->b_lock);
 	spin_unlock(&inode->i_lock);
 
 	ret = do_writepages(mapping, wbc);
@@ -362,18 +393,15 @@ writeback_single_inode(struct bdi_writeback *wb, struct inode *inode,
 	spin_lock(&inode->i_lock);
 	dirty = inode->i_state & I_DIRTY;
 	inode->i_state &= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC);
+	spin_unlock(&inode->i_lock);
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
 	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
-		int err;
-
-		spin_unlock(&inode->i_lock);
-		err = write_inode(inode, wbc);
+		int err = write_inode(inode, wbc);
 		if (ret == 0)
 			ret = err;
-		spin_lock(&inode->i_lock);
 	}
 
-	spin_lock(&wb->b_lock);
+	spin_lock(&inode->i_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
 		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
@@ -382,11 +410,13 @@ writeback_single_inode(struct bdi_writeback *wb, struct inode *inode,
 			 * sometimes bales out without doing anything.
 			 */
 			inode->i_state |= I_DIRTY_PAGES;
+			spin_unlock(&inode->i_lock);
+			spin_lock(&bdi->wb.b_lock);
 			if (wbc->nr_to_write <= 0) {
 				/*
 				 * slice used up: queue for next turn
 				 */
-				requeue_io(wb, inode);
+				requeue_io(inode);
 			} else {
 				/*
 				 * Writeback blocked by something other than
@@ -395,8 +425,9 @@ writeback_single_inode(struct bdi_writeback *wb, struct inode *inode,
 				 * retrying writeback of the dirty page/inode
 				 * that cannot be performed immediately.
 				 */
-				redirty_tail(wb, inode);
+				redirty_tail(inode);
 			}
+			spin_unlock(&bdi->wb.b_lock);
 		} else if (inode->i_state & I_DIRTY) {
 			/*
 			 * Filesystems can dirty the inode during writeback
@@ -404,23 +435,31 @@ writeback_single_inode(struct bdi_writeback *wb, struct inode *inode,
 			 * submission or metadata updates after data IO
 			 * completion.
 			 */
-			redirty_tail(wb, inode);
+			spin_unlock(&inode->i_lock);
+			spin_lock(&bdi->wb.b_lock);
+			redirty_tail(inode);
+			spin_unlock(&bdi->wb.b_lock);
 		} else {
 			/*
-			 * The inode is clean
+			 * The inode is clean. If it is unused, then make sure
+			 * that it is put on the LRU correctly as iput_final()
+			 * does not move dirty inodes to the LRU and dirty
+			 * inodes are removed from the LRU during scanning.
 			 */
-			list_del_init(&inode->i_io);
-
-			/*
-			 * Put it on the LRU if it is unused, otherwise lazy.
-			 */
-			if (!inode->i_refs && list_empty(&inode->i_lru))
-				__inode_lru_list_add(inode);
+			int unused = inode->i_ref == 0;
+			spin_unlock(&inode->i_lock);
+			inode_wb_list_del(inode);
+			if (unused)
+				inode_lru_list_add(inode);
 		}
+	} else {
+		/* freer will clean up */
+		spin_unlock(&inode->i_lock);
 	}
 	inode_sync_complete(inode);
 	return ret;
 }
+EXPORT_SYMBOL(sync_inode);
 
 /*
  * For background writeback the caller does not have the sb pinned
@@ -461,18 +500,11 @@ static bool pin_sb_for_writeback(struct super_block *sb)
 static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 		struct writeback_control *wbc, bool only_this_sb)
 {
-again:
+	assert_spin_locked(&wb->b_lock);
 	while (!list_empty(&wb->b_io)) {
 		long pages_skipped;
 		struct inode *inode = list_entry(wb->b_io.prev,
-						 struct inode, i_io);
-
-		if (!spin_trylock(&inode->i_lock)) {
-			spin_unlock(&wb->b_lock);
-			cpu_relax();
-			spin_lock(&wb->b_lock);
-			goto again;
-		}
+						 struct inode, i_wb_list);
 
 		if (inode->i_sb != sb) {
 			if (only_this_sb) {
@@ -481,13 +513,9 @@ again:
 				 * superblock, move all inodes not belonging
 				 * to it back onto the dirty list.
 				 */
-				redirty_tail(wb, inode);
-				spin_unlock(&inode->i_lock);
+				redirty_tail(inode);
 				continue;
 			}
-
-			spin_unlock(&inode->i_lock);
-
 			/*
 			 * The inode belongs to a different superblock.
 			 * Bounce back to the caller to unpin this and
@@ -496,9 +524,18 @@ again:
 			return 0;
 		}
 
-		if (inode->i_state & (I_NEW | I_WILL_FREE)) {
-			requeue_io(wb, inode);
+		/*
+		 * We can see I_FREEING here when the inod isin the process of
+		 * being reclaimed. In that case the freer is waiting on the
+		 * wb->b_lock that we currently hold to remove the inode from
+		 * the writeback list. So we don't spin on it here, requeue it
+		 * and move on to the next inode, which will allow the other
+		 * thread to free the inode when we drop the lock.
+		 */
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_NEW | I_WILL_FREE | I_FREEING)) {
 			spin_unlock(&inode->i_lock);
+			requeue_io(inode);
 			continue;
 		}
 		/*
@@ -510,19 +547,21 @@ again:
 			return 1;
 		}
 
-		BUG_ON(inode->i_state & I_FREEING);
-		inode_get_ilock(inode);
+		inode->i_ref++;
+		spin_unlock(&inode->i_lock);
+		spin_unlock(&wb->b_lock);
+
 		pages_skipped = wbc->pages_skipped;
-		writeback_single_inode(wb, inode, wbc);
+		sync_inode(inode, wbc);
 		if (wbc->pages_skipped != pages_skipped) {
 			/*
 			 * writeback is not making progress due to locked
 			 * buffers.  Skip this inode for now.
 			 */
-			redirty_tail(wb, inode);
+			spin_lock(&wb->b_lock);
+			redirty_tail(inode);
+			spin_unlock(&wb->b_lock);
 		}
-		spin_unlock(&wb->b_lock);
-		spin_unlock(&inode->i_lock);
 		iput(inode);
 		cond_resched();
 		spin_lock(&wb->b_lock);
@@ -544,25 +583,17 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
 
 	if (!wbc->wb_start)
 		wbc->wb_start = jiffies; /* livelock avoidance */
-again:
 	spin_lock(&wb->b_lock);
-
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = list_entry(wb->b_io.prev,
-						 struct inode, i_io);
+						 struct inode, i_wb_list);
 		struct super_block *sb = inode->i_sb;
 
 		if (!pin_sb_for_writeback(sb)) {
-			if (!spin_trylock(&inode->i_lock)) {
-				spin_unlock(&wb->b_lock);
-				cpu_relax();
-				goto again;
-			}
-			requeue_io(wb, inode);
-			spin_unlock(&inode->i_lock);
+			requeue_io(inode);
 			continue;
 		}
 		ret = writeback_sb_inodes(sb, wb, wbc, false);
@@ -694,20 +725,16 @@ static long wb_writeback(struct bdi_writeback *wb,
 		 * become available for writeback. Otherwise
 		 * we'll just busyloop.
 		 */
-retry:
-		spin_lock(&wb->b_lock);
 		if (!list_empty(&wb->b_more_io))  {
+			spin_lock(&wb->b_lock);
 			inode = list_entry(wb->b_more_io.prev,
-						struct inode, i_io);
-			if (!spin_trylock(&inode->i_lock)) {
-				spin_unlock(&wb->b_lock);
-				goto retry;
-			}
+						struct inode, i_wb_list);
+			spin_lock(&inode->i_lock);
+			spin_unlock(&wb->b_lock);
 			trace_wbc_writeback_wait(&wbc, wb->bdi);
-			inode_wait_for_writeback(wb, inode);
+			inode_wait_for_writeback(inode);
 			spin_unlock(&inode->i_lock);
 		}
-		spin_unlock(&wb->b_lock);
 	}
 
 	return wrote;
@@ -735,7 +762,6 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
 {
 	unsigned long expired;
 	long nr_pages;
-	int nr_dirty_inodes;
 
 	/*
 	 * When set to zero, disable periodic writeback
@@ -748,15 +774,10 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
 	if (time_before(jiffies, expired))
 		return 0;
 
-	/* approximate dirty inodes */
-	nr_dirty_inodes = get_nr_inodes() - get_nr_inodes_unused();
-	if (nr_dirty_inodes < 0)
-		nr_dirty_inodes = 0;
-
 	wb->last_old_flush = jiffies;
 	nr_pages = global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) +
-			nr_dirty_inodes;
+			get_nr_dirty_inodes();
 
 	if (nr_pages) {
 		struct wb_writeback_work work = {
@@ -988,27 +1009,25 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 * superblock list, based upon its state.
 		 */
 		if (inode->i_state & I_SYNC)
-			goto out;
+			goto out_unlock;
 
 		/*
 		 * Only add valid (hashed) inodes to the superblock's
 		 * dirty list.  Add blockdev inodes as well.
 		 */
 		if (!S_ISBLK(inode->i_mode)) {
-			if (hlist_bl_unhashed(&inode->i_hash))
-				goto out;
+			if (inode_unhashed(inode))
+				goto out_unlock;
 		}
 		if (inode->i_state & I_FREEING)
-			goto out;
+			goto out_unlock;
 
 		/*
 		 * If the inode was already on b_dirty/b_io/b_more_io, don't
 		 * reposition it (that would break b_dirty time-ordering).
 		 */
 		if (!was_dirty) {
-			struct bdi_writeback *wb;
- 			bdi = inode_to_bdi(inode);
-			wb = inode_to_wb(inode);
+			bdi = inode_to_bdi(inode);
 
 			if (bdi_cap_writeback_dirty(bdi)) {
 				WARN(!test_bit(BDI_registered, &bdi->state),
@@ -1024,16 +1043,17 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 					wakeup_bdi = true;
 			}
 
+			spin_unlock(&inode->i_lock);
+			spin_lock(&bdi->wb.b_lock);
 			inode->dirtied_when = jiffies;
-			spin_lock(&wb->b_lock);
-			BUG_ON(!list_empty(&inode->i_io));
-			list_add(&inode->i_io, &wb->b_dirty);
-			spin_unlock(&wb->b_lock);
+			list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
+			spin_unlock(&bdi->wb.b_lock);
+			goto out;
 		}
 	}
-out:
+out_unlock:
 	spin_unlock(&inode->i_lock);
-
+out:
 	if (wakeup_bdi)
 		bdi_wakeup_thread_delayed(bdi);
 }
@@ -1066,6 +1086,8 @@ static void wait_sb_inodes(struct super_block *sb)
 	 */
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
+	spin_lock(&sb->s_inodes_lock);
+
 	/*
 	 * Data integrity sync. Must wait for all pages under writeback,
 	 * because there may have been pages dirtied before our sync
@@ -1073,32 +1095,25 @@ static void wait_sb_inodes(struct super_block *sb)
 	 * In which case, the inode may not be on the dirty list, but
 	 * we still have to wait for that writeout.
 	 */
-	rcu_read_lock();
-	do_inode_list_for_each_entry_rcu(sb, inode) {
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		struct address_space *mapping;
 
 		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-
 		mapping = inode->i_mapping;
-		if (mapping->nrpages == 0) {
+		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+		    mapping->nrpages == 0) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-
- 		inode_get_ilock(inode);
+		inode->i_ref++;
 		spin_unlock(&inode->i_lock);
-		rcu_read_unlock();
+		spin_unlock(&sb->s_inodes_lock);
 		/*
-		 * We hold a reference to 'inode' so it couldn't have
-		 * been removed from s_inodes list while we dropped the
-		 * i_lock.  We cannot iput the inode now as we can be
-		 * holding the last reference and we cannot iput it
-		 * under spinlock. So we keep the reference and iput it
-		 * later.
+		 * We hold a reference to 'inode' so it couldn't have been
+		 * removed from s_inodes list while we dropped the
+		 * s_inodes_lock.  We cannot iput the inode now as we can be
+		 * holding the last reference and we cannot iput it under
+		 * s_inodes_lock. So we keep the reference and iput it later.
 		 */
 		iput(old_inode);
 		old_inode = inode;
@@ -1107,9 +1122,9 @@ static void wait_sb_inodes(struct super_block *sb)
 
 		cond_resched();
 
-		rcu_read_lock();
-	} while_inode_list_for_each_entry_rcu
-	rcu_read_unlock();
+		spin_lock(&sb->s_inodes_lock);
+	}
+	spin_unlock(&sb->s_inodes_lock);
 	iput(old_inode);
 }
 
@@ -1126,7 +1141,6 @@ void writeback_inodes_sb(struct super_block *sb)
 {
 	unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
 	unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
-	int nr_dirty_inodes;
 	DECLARE_COMPLETION_ONSTACK(done);
 	struct wb_writeback_work work = {
 		.sb		= sb,
@@ -1136,11 +1150,7 @@ void writeback_inodes_sb(struct super_block *sb)
 
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	nr_dirty_inodes = get_nr_inodes() - get_nr_inodes_unused();
-	if (nr_dirty_inodes < 0)
-		nr_dirty_inodes = 0;
-
-	work.nr_pages = nr_dirty + nr_unstable + nr_dirty_inodes;
+	work.nr_pages = nr_dirty + nr_unstable + get_nr_dirty_inodes();
 
 	bdi_queue_work(sb->s_bdi, &work);
 	wait_for_completion(&done);
@@ -1205,7 +1215,6 @@ EXPORT_SYMBOL(sync_inodes_sb);
  */
 int write_inode_now(struct inode *inode, int sync)
 {
-	struct bdi_writeback *wb = inode_to_wb(inode);
 	int ret;
 	struct writeback_control wbc = {
 		.nr_to_write = LONG_MAX,
@@ -1218,38 +1227,9 @@ int write_inode_now(struct inode *inode, int sync)
 		wbc.nr_to_write = 0;
 
 	might_sleep();
-	spin_lock(&inode->i_lock);
-	spin_lock(&wb->b_lock);
-	ret = writeback_single_inode(wb, inode, &wbc);
-	spin_unlock(&wb->b_lock);
-	spin_unlock(&inode->i_lock);
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
-	struct bdi_writeback *wb = inode_to_wb(inode);
-	int ret;
-
-	spin_lock(&inode->i_lock);
-	spin_lock(&wb->b_lock);
-	ret = writeback_single_inode(wb, inode, wbc);
-	spin_unlock(&wb->b_lock);
-	spin_unlock(&inode->i_lock);
-	return ret;
-}
-EXPORT_SYMBOL(sync_inode);
diff --git a/fs/inode.c b/fs/inode.c
index c682715..6a9b1ea 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -24,36 +24,40 @@
 #include <linux/mount.h>
 #include <linux/async.h>
 #include <linux/posix_acl.h>
-#include <linux/bit_spinlock.h>
-#include <linux/lglock.h>
+
 #include "internal.h"
 
 /*
- * Usage:
- * inode_list_lglock protects:
- *   s_inodes, i_sb_list
- * inode_hash_bucket lock protects:
+ * Locking rules.
+ *
+ * inode->i_lock is *always* the innermost lock.
+ *
+ * inode->i_lock protects:
+ *   i_ref i_state
+ * inode hash lock protects:
  *   inode hash table, i_hash
- * zone->inode_lru_lock protects:
+ * sb inode lock protects:
+ *   s_inodes, i_sb_list
+ * bdi writeback lock protects:
+ *   b_io, b_more_io, b_dirty, i_wb_list
+ * inode_lru_lock protects:
  *   inode_lru, i_lru
- * wb->b_lock protects:
- *   b_io, b_more_io, b_dirty, i_io, i_lru
- * inode->i_lock protects:
- *   i_state
- *   i_refs
- *   i_hash
- *   i_io
- *   i_lru
- *   i_sb_list
  *
- * Ordering:
- * inode->i_lock
- *   inode_list_lglock
- *   zone->inode_lru_lock
+ * Lock orders
+ * inode hash bucket lock
+ *   inode->i_lock
+ *
+ * sb inode lock
+ *   inode_lru_lock
  *   wb->b_lock
- *     sb_lock (pin_sb_for_writeback)
- *   inode_hash_bucket lock
- *   dentry->d_lock (alias management)
+ *     inode->i_lock
+ *
+ * wb->b_lock
+ *   sb_lock (pin sb for writeback)
+ *   inode->i_lock
+ *
+ * inode_lru
+ *   inode->i_lock
  */
 /*
  * This is needed for the following functions:
@@ -89,43 +93,21 @@
 
 static unsigned int i_hash_mask __read_mostly;
 static unsigned int i_hash_shift __read_mostly;
+static struct hlist_bl_head *inode_hashtable __read_mostly;
 
 /*
  * Each inode can be on two separate lists. One is
  * the hash list of the inode, used for lookups. The
  * other linked list is the "type" list:
- *  "in_use" - valid inode, i_refs > 0, i_nlink > 0
+ *  "in_use" - valid inode, i_ref > 0, i_nlink > 0
  *  "dirty"  - as "in_use" but also dirty
- *  "unused" - valid inode, i_refs = 0
+ *  "unused" - valid inode, i_ref = 0
  *
  * A "dirty" list is maintained for each super block,
  * allowing for low-overhead inode sync() operations.
  */
-
-struct inode_hash_bucket {
-	struct hlist_bl_head head;
-};
-
-static inline void spin_lock_bucket(struct inode_hash_bucket *b)
-{
-	bit_spin_lock(0, (unsigned long *)b);
-}
-
-static inline void spin_unlock_bucket(struct inode_hash_bucket *b)
-{
-	__bit_spin_unlock(0, (unsigned long *)b);
-}
-
-static struct inode_hash_bucket *inode_hashtable __read_mostly;
-
-/*
- * A simple spinlock to protect the list manipulations.
- *
- * NOTE! You also have to own the lock if you change
- * the i_state of an inode while it is in use..
- */
-DECLARE_LGLOCK(inode_list_lglock);
-DEFINE_LGLOCK(inode_list_lglock);
+static LIST_HEAD(inode_lru);
+static DEFINE_SPINLOCK(inode_lru_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
@@ -144,48 +126,42 @@ static DECLARE_RWSEM(iprune_sem);
 /*
  * Statistics gathering..
  */
-struct inodes_stat_t inodes_stat = {
-	.nr_inodes = 0,
-	.nr_unused = 0,
-};
+struct inodes_stat_t inodes_stat;
 
-static DEFINE_PER_CPU(unsigned int, nr_inodes);
+static struct percpu_counter nr_inodes __cacheline_aligned_in_smp;
+static struct percpu_counter nr_inodes_unused __cacheline_aligned_in_smp;
 
 static struct kmem_cache *inode_cachep __read_mostly;
 
-int get_nr_inodes(void)
+static inline int get_nr_inodes(void)
+{
+	return percpu_counter_sum_positive(&nr_inodes);
+}
+
+static inline int get_nr_inodes_unused(void)
 {
-	int i;
-	int sum = 0;
-	for_each_possible_cpu(i)
-		sum += per_cpu(nr_inodes, i);
-	return sum < 0 ? 0 : sum;
+	return percpu_counter_sum_positive(&nr_inodes_unused);
 }
 
-int get_nr_inodes_unused(void)
+int get_nr_dirty_inodes(void)
 {
-	int nr = 0;
-	struct zone *z;
+	int nr_dirty = get_nr_inodes() - get_nr_inodes_unused();
+	return nr_dirty > 0 ? nr_dirty : 0;
 
-	for_each_populated_zone(z)
-		nr += z->inode_nr_lru;
-	return nr;
 }
 
 /*
- * Handle nr_dentry sysctl
+ * Handle nr_inode sysctl
  */
+#if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
 int proc_nr_inodes(ctl_table *table, int write,
 		   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-#if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
 	inodes_stat.nr_inodes = get_nr_inodes();
 	inodes_stat.nr_unused = get_nr_inodes_unused();
 	return proc_dointvec(table, write, buffer, lenp, ppos);
-#else
-	return -ENOSYS;
-#endif
 }
+#endif
 
 static void wake_up_inode(struct inode *inode)
 {
@@ -214,7 +190,7 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_sb = sb;
 	inode->i_blkbits = sb->s_blocksize_bits;
 	inode->i_flags = 0;
-	inode->i_refs = 1;
+	inode->i_ref = 1;
 	inode->i_op = &empty_iops;
 	inode->i_fop = &empty_fops;
 	inode->i_nlink = 1;
@@ -228,7 +204,6 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 #ifdef CONFIG_QUOTA
 	memset(&inode->i_dquot, 0, sizeof(inode->i_dquot));
 #endif
-	INIT_LIST_HEAD(&inode->i_sb_list);
 	inode->i_pipe = NULL;
 	inode->i_bdev = NULL;
 	inode->i_cdev = NULL;
@@ -275,7 +250,7 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_fsnotify_mask = 0;
 #endif
 
-	this_cpu_inc(nr_inodes);
+	percpu_counter_inc(&nr_inodes);
 
 	return 0;
 out:
@@ -306,12 +281,6 @@ static struct inode *alloc_inode(struct super_block *sb)
 	return inode;
 }
 
-void free_inode_nonrcu(struct inode *inode)
-{
-	kmem_cache_free(inode_cachep, inode);
-}
-EXPORT_SYMBOL(free_inode_nonrcu);
-
 void __destroy_inode(struct inode *inode)
 {
 	BUG_ON(inode_has_buffers(inode));
@@ -323,25 +292,18 @@ void __destroy_inode(struct inode *inode)
 	if (inode->i_default_acl && inode->i_default_acl != ACL_NOT_CACHED)
 		posix_acl_release(inode->i_default_acl);
 #endif
-	this_cpu_dec(nr_inodes);
+	percpu_counter_dec(&nr_inodes);
 }
 EXPORT_SYMBOL(__destroy_inode);
 
-static void i_callback(struct rcu_head *head)
-{
-	struct inode *inode = container_of(head, struct inode, i_rcu);
-	INIT_LIST_HEAD(&inode->i_dentry);
-	kmem_cache_free(inode_cachep, inode);
-}
-
 void destroy_inode(struct inode *inode)
 {
-	BUG_ON(!list_empty(&inode->i_io));
+	BUG_ON(!list_empty(&inode->i_lru));
 	__destroy_inode(inode);
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
 	else
-		call_rcu(&inode->i_rcu, i_callback);
+		kmem_cache_free(inode_cachep, (inode));
 }
 
 /*
@@ -352,10 +314,10 @@ void destroy_inode(struct inode *inode)
 void inode_init_once(struct inode *inode)
 {
 	memset(inode, 0, sizeof(*inode));
-	INIT_HLIST_BL_NODE(&inode->i_hash);
+	init_hlist_bl_node(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
-	INIT_LIST_HEAD(&inode->i_io);
+	INIT_LIST_HEAD(&inode->i_wb_list);
 	INIT_LIST_HEAD(&inode->i_lru);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
 	spin_lock_init(&inode->i_data.tree_lock);
@@ -378,6 +340,117 @@ static void init_once(void *foo)
 	inode_init_once(inode);
 }
 
+/**
+ * iref - increment the reference count on an inode
+ * @inode:	inode to take a reference on
+ *
+ * iref() should be called to take an extra reference to an inode. The inode
+ * must already have a reference count obtained via igrab() as iref() does not
+ * do checks for the inode being freed and hence cannot be used to initially
+ * obtain a reference to the inode.
+ */
+void iref(struct inode *inode)
+{
+	WARN_ON(inode->i_ref < 1);
+	spin_lock(&inode->i_lock);
+	inode->i_ref++;
+	spin_unlock(&inode->i_lock);
+}
+EXPORT_SYMBOL_GPL(iref);
+
+/*
+ * check against I_FREEING as inode writeback completion could race with
+ * setting the I_FREEING and removing the inode from the LRU.
+ */
+void inode_lru_list_add(struct inode *inode)
+{
+	spin_lock(&inode_lru_lock);
+	if (list_empty(&inode->i_lru) && !(inode->i_state & I_FREEING)) {
+		list_add(&inode->i_lru, &inode_lru);
+		percpu_counter_inc(&nr_inodes_unused);
+	}
+	spin_unlock(&inode_lru_lock);
+}
+
+void inode_lru_list_del(struct inode *inode)
+{
+	spin_lock(&inode_lru_lock);
+	if (!list_empty(&inode->i_lru)) {
+		list_del_init(&inode->i_lru);
+		percpu_counter_dec(&nr_inodes_unused);
+	}
+	spin_unlock(&inode_lru_lock);
+}
+
+/**
+ * inode_sb_list_add - add inode to the superblock list of inodes
+ * @inode: inode to add
+ */
+void inode_sb_list_add(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+
+	spin_lock(&sb->s_inodes_lock);
+	list_add(&inode->i_sb_list, &sb->s_inodes);
+	spin_unlock(&sb->s_inodes_lock);
+}
+EXPORT_SYMBOL_GPL(inode_sb_list_add);
+
+static void inode_sb_list_del(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+
+	spin_lock(&sb->s_inodes_lock);
+	list_del_init(&inode->i_sb_list);
+	spin_unlock(&sb->s_inodes_lock);
+}
+
+static unsigned long hash(struct super_block *sb, unsigned long hashval)
+{
+	unsigned long tmp;
+
+	tmp = (hashval * (unsigned long)sb) ^ (GOLDEN_RATIO_PRIME + hashval) /
+			L1_CACHE_BYTES;
+	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> I_HASHBITS);
+	return tmp & I_HASHMASK;
+}
+
+/**
+ *	__insert_inode_hash - hash an inode
+ *	@inode: unhashed inode
+ *	@hashval: unsigned long value used to locate this object in the
+ *		inode_hashtable.
+ *
+ *	Add an inode to the inode hash for this superblock.
+ */
+void __insert_inode_hash(struct inode *inode, unsigned long hashval)
+{
+	struct hlist_bl_head *b = inode_hashtable + hash(inode->i_sb, hashval);
+
+	hlist_bl_lock(b);
+	hlist_bl_add_head(&inode->i_hash, b);
+	hlist_bl_unlock(b);
+}
+EXPORT_SYMBOL(__insert_inode_hash);
+
+/**
+ *	remove_inode_hash - remove an inode from the hash
+ *	@inode: inode to unhash
+ *
+ *	Remove an inode from the superblock. inode->i_lock must be
+ *	held.
+ */
+void remove_inode_hash(struct inode *inode)
+{
+	struct hlist_bl_head *b;
+
+	b = inode_hashtable + hash(inode->i_sb, inode->i_ino);
+	hlist_bl_lock(b);
+	hlist_bl_del_init(&inode->i_hash);
+	hlist_bl_unlock(b);
+}
+EXPORT_SYMBOL(remove_inode_hash);
+
 void end_writeback(struct inode *inode)
 {
 	might_sleep();
@@ -386,8 +459,9 @@ void end_writeback(struct inode *inode)
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
 	inode_sync_wait(inode);
-	/* don't need i_lock here, no concurrent mods to i_state */
+	spin_lock(&inode->i_lock);
 	inode->i_state = I_FREEING | I_CLEAR;
+	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(end_writeback);
 
@@ -408,20 +482,36 @@ static void evict(struct inode *inode)
 		cd_forget(inode);
 }
 
-static void __remove_inode_hash(struct inode *inode);
-
-static void inode_sb_list_del(struct inode *inode);
-
+/*
+ * Free the inode passed in, removing it from the lists it is still connected
+ * to but avoiding unnecessary lock round-trips for the lists it is no longer
+ * on.
+ *
+ * An inode must already be marked I_FREEING so that we avoid the inode being
+ * moved back onto lists if we race with other code that manipulates the lists
+ * (e.g. writeback_single_inode). The caller
+ */
 static void dispose_one_inode(struct inode *inode)
 {
-	evict(inode);
+	BUG_ON(!(inode->i_state & I_FREEING));
 
-	spin_lock(&inode->i_lock);
-	__remove_inode_hash(inode);
-	inode_sb_list_del(inode);
-	spin_unlock(&inode->i_lock);
+	/*
+	 * move the inode off the IO lists and LRU once
+	 * I_FREEING is set so that it won't get moved back on
+	 * there if it is dirty.
+	 */
+	if (!list_empty(&inode->i_wb_list))
+		inode_wb_list_del(inode);
+	if (!list_empty(&inode->i_lru))
+		inode_lru_list_del(inode);
+	if (!list_empty(&inode->i_sb_list))
+		inode_sb_list_del(inode);
+
+	evict(inode);
 
+	remove_inode_hash(inode);
 	wake_up_inode(inode);
+	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
 	destroy_inode(inode);
 }
 
@@ -437,74 +527,57 @@ static void dispose_list(struct list_head *head)
 	while (!list_empty(head)) {
 		struct inode *inode;
 
-		inode = list_first_entry(head, struct inode, i_lru);
-		list_del_init(&inode->i_lru);
+		inode = list_first_entry(head, struct inode, i_sb_list);
+		list_del_init(&inode->i_sb_list);
 
 		dispose_one_inode(inode);
-		cond_resched();
 	}
 }
 
 /*
- * Add an inode to the LRU list. i_lock must be held.
- */
-void __inode_lru_list_add(struct inode *inode)
-{
-	struct zone *z = page_zone(virt_to_page(inode));
-
-	spin_lock(&z->inode_lru_lock);
-	list_add(&inode->i_lru, &z->inode_lru);
-	z->inode_nr_lru++;
-	spin_unlock(&z->inode_lru_lock);
-}
-
-/*
- * Remove an inode from the LRU list. i_lock must be held.
- */
-void __inode_lru_list_del(struct inode *inode)
-{
-	struct zone *z = page_zone(virt_to_page(inode));
-
-	spin_lock(&z->inode_lru_lock);
-	list_del_init(&inode->i_lru);
-	z->inode_nr_lru--;
-	spin_unlock(&z->inode_lru_lock);
-}
-
-/*
  * Invalidate all inodes for a device.
  */
-static int invalidate_sb_inodes(struct super_block *sb, struct list_head *dispose)
+static int invalidate_list(struct super_block *sb, struct list_head *head,
+			struct list_head *dispose)
 {
-	struct inode *inode;
+	struct list_head *next;
 	int busy = 0;
 
-	do_inode_list_for_each_entry_rcu(sb, inode) {
+	next = head->next;
+	for (;;) {
+		struct list_head *tmp = next;
+		struct inode *inode;
+
+		/*
+		 * We can reschedule here without worrying about the list's
+		 * consistency because the per-sb list of inodes must not
+		 * change during umount anymore, and because iprune_sem keeps
+		 * shrink_icache_memory() away.
+		 */
+		cond_resched_lock(&sb->s_inodes_lock);
+
+		next = next->next;
+		if (tmp == head)
+			break;
+		inode = list_entry(tmp, struct inode, i_sb_list);
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & I_NEW) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		invalidate_inode_buffers(inode);
-		if (!inode->i_refs) {
-			struct bdi_writeback *wb = inode_to_wb(inode);
-
-			spin_lock(&wb->b_lock);
-			list_del_init(&inode->i_io);
-			spin_unlock(&wb->b_lock);
-
-			__inode_lru_list_del(inode);
-
+		if (!inode->i_ref) {
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			spin_unlock(&inode->i_lock);
-			list_add(&inode->i_lru, dispose);
+
+			/* save a lock round trip by removing the inode here. */
+			list_move(&inode->i_sb_list, dispose);
 			continue;
 		}
 		spin_unlock(&inode->i_lock);
 		busy = 1;
-	} while_inode_list_for_each_entry_rcu
-
+	}
 	return busy;
 }
 
@@ -518,127 +591,113 @@ static int invalidate_sb_inodes(struct super_block *sb, struct list_head *dispos
  */
 int invalidate_inodes(struct super_block *sb)
 {
-	int busy;
 	LIST_HEAD(throw_away);
+	int busy;
 
 	down_write(&iprune_sem);
-	/*
-	 * We can walk the per-sb list of inodes here without worrying about
-	 * its consistency, because the list must not change during umount
-	 * anymore, and because iprune_sem keeps shrink_icache_memory() away.
-	 */
-	fsnotify_unmount_inodes(sb);
-	busy = invalidate_sb_inodes(sb, &throw_away);
+	spin_lock(&sb->s_inodes_lock);
+	fsnotify_unmount_inodes(&sb->s_inodes);
+	busy = invalidate_list(sb, &sb->s_inodes, &throw_away);
+	spin_unlock(&sb->s_inodes_lock);
+	up_write(&iprune_sem);
 
 	dispose_list(&throw_away);
-	up_write(&iprune_sem);
 
 	return busy;
 }
 EXPORT_SYMBOL(invalidate_inodes);
 
-static int can_unuse(struct inode *inode)
-{
-	if (inode->i_state & ~I_REFERENCED)
-		return 0;
-	if (inode_has_buffers(inode))
-		return 0;
-	if (inode->i_refs)
-		return 0;
-	if (inode->i_data.nrpages)
-		return 0;
-	return 1;
-}
-
 /*
- * Scan `goal' inodes on the unused list for freeable ones. They are moved to
- * a temporary list and then are freed outside LRU lock by dispose_list().
+ * Scan `goal' inodes on the unused list for freeable ones. They are moved to a
+ * temporary list and then are freed outside locks by dispose_list().
  *
  * Any inodes which are pinned purely because of attached pagecache have their
- * pagecache removed.  We expect the final iput() on that inode to add it to
- * the front of the inode_lru list.  So look for it there and if the
- * inode is still freeable, proceed.  The right inode is found 99.9% of the
- * time in testing on a 4-way.
+ * pagecache removed.  If the inode has metadata buffers attached to
+ * mapping->private_list then try to remove them.
  *
- * If the inode has metadata buffers attached to mapping->private_list then
- * try to remove them.
+ * If the inode has the I_REFERENCED flag set, it means that it has been used
+ * recently - the flag is set in iput_final(). When we encounter such an inode,
+ * clear the flag and move it to the back of the LRU so it gets another pass
+ * through the LRU before it gets reclaimed. This is necessary because of the
+ * fact we are doing lazy LRU updates to minimise lock contention so the LRU
+ * does not have strict ordering. Hence we don't want to reclaim inodes with
+ * this flag set because they are the inodes that are out of order...
  */
-static void prune_icache(struct zone *zone, unsigned long nr_to_scan)
+static void prune_icache(int nr_to_scan)
 {
+	int nr_scanned;
 	unsigned long reap = 0;
 
 	down_read(&iprune_sem);
-again:
-	spin_lock(&zone->inode_lru_lock);
-	for (; nr_to_scan; nr_to_scan--) {
+	spin_lock(&inode_lru_lock);
+	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
 		struct inode *inode;
 
-		if (list_empty(&zone->inode_lru))
+		if (list_empty(&inode_lru))
 			break;
 
-		inode = list_entry(zone->inode_lru.prev, struct inode, i_lru);
+		inode = list_entry(inode_lru.prev, struct inode, i_lru);
 
-		if (!spin_trylock(&inode->i_lock)) {
-			spin_unlock(&zone->inode_lru_lock);
-			cpu_relax();
-			goto again;
-		}
-		if (inode->i_refs || (inode->i_state & ~I_REFERENCED)) {
-			list_del_init(&inode->i_lru);
+		/*
+		 * Referenced or dirty inodes are still in use. Give them
+		 * another pass through the LRU as we canot reclaim them now.
+		 */
+		spin_lock(&inode->i_lock);
+		if (inode->i_ref || (inode->i_state & ~I_REFERENCED)) {
 			spin_unlock(&inode->i_lock);
-			zone->inode_nr_lru--;
+			list_del_init(&inode->i_lru);
+			percpu_counter_dec(&nr_inodes_unused);
 			continue;
 		}
+
+		/* recently referenced inodes get one more pass */
 		if (inode->i_state & I_REFERENCED) {
-			list_move(&inode->i_lru, &zone->inode_lru);
 			inode->i_state &= ~I_REFERENCED;
 			spin_unlock(&inode->i_lock);
+			list_move(&inode->i_lru, &inode_lru);
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
-			/*
-			 * Move back to the head of the unused list in case the
-			 * invalidations failed. Could improve this by going to
-			 * the head of the list only if invalidation fails.
-			 *
-			 * We'll try to get it back if it becomes freeable.
-			 */
-			list_move(&inode->i_lru, &zone->inode_lru);
-			spin_unlock(&zone->inode_lru_lock);
-			inode_get_ilock(inode);
+			inode->i_ref++;
 			spin_unlock(&inode->i_lock);
-
+			spin_unlock(&inode_lru_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
 								0, -1);
 			iput(inode);
-			spin_lock(&zone->inode_lru_lock);
-			if (inode == list_entry(zone->inode_lru.next,
-						struct inode, i_lru)) {
-				if (spin_trylock(&inode->i_lock)) {
-					if (can_unuse(inode))
-						goto freeable;
-					spin_unlock(&inode->i_lock);
-				}
-			}
+
+			/*
+			 * Rather than try to determine if we can still use the
+			 * inode after calling iput(), leave the inode where it
+			 * is on the LRU. If we race with another recalimer,
+			 * that reclaimer will either see the a reference count
+			 * or the I_REFERENCED flag, and move the inode to the
+			 * back of the LRU. It we don't race, then we'll see
+			 * the I_REFERENCED flag on the next pass and do the
+			 * same. Either way, we won't spin on it in this loop.
+			 */
+			spin_lock(&inode_lru_lock);
 			continue;
 		}
-freeable:
-		list_del_init(&inode->i_lru);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
 		spin_unlock(&inode->i_lock);
-		zone->inode_nr_lru--;
-		spin_unlock(&zone->inode_lru_lock);
+
+		/* save a lock round trip by removing the inode here. */
+		list_del_init(&inode->i_lru);
+		percpu_counter_dec(&nr_inodes_unused);
+		spin_unlock(&inode_lru_lock);
+
 		dispose_one_inode(inode);
 		cond_resched();
-		spin_lock(&zone->inode_lru_lock);
+
+		spin_lock(&inode_lru_lock);
 	}
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
 		__count_vm_events(PGINODESTEAL, reap);
-	spin_unlock(&zone->inode_lru_lock);
+	spin_unlock(&inode_lru_lock);
 
 	up_read(&iprune_sem);
 }
@@ -649,47 +708,33 @@ freeable:
  * not open and the dcache references to those inodes have already been
  * reclaimed.
  *
- * This function is defined according to shrinker API described in linux/mm.h.
+ * This function is passed the number of inodes to scan, and it returns the
+ * total number of remaining possibly-reclaimable inodes.
  */
-static void shrink_icache_memory(struct shrinker *shrink,
-		struct zone *zone, unsigned long scanned,
-		unsigned long total, unsigned long global,
-		unsigned long flags, gfp_t gfp_mask)
+static int shrink_icache_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
 {
-	unsigned long nr;
-
-	shrinker_add_scan(&zone->inode_nr_scan, scanned, total,
-			zone->inode_nr_lru,
-			SHRINK_DEFAULT_SEEKS * 100 / sysctl_vfs_cache_pressure);
-	/*
-	 * Nasty deadlock avoidance.  We may hold various FS locks,
-	 * and we don't want to recurse into the FS that called us
-	 * in clear_inode() and friends..
-	 */
-	if (!(gfp_mask & __GFP_FS))
-	       return;
-
-	nr = ACCESS_ONCE(zone->inode_nr_scan);
-	if (nr < SHRINK_BATCH)
-		return;
-	zone->inode_nr_scan = 0;
-	prune_icache(zone, nr);
-	count_vm_events(SLABS_SCANNED, nr);
+	if (nr) {
+		/*
+		 * Nasty deadlock avoidance.  We may hold various FS locks,
+		 * and we don't want to recurse into the FS that called us
+		 * in clear_inode() and friends..
+		 */
+		if (!(gfp_mask & __GFP_FS))
+			return -1;
+		prune_icache(nr);
+	}
+	return (get_nr_inodes_unused() / 100) * sysctl_vfs_cache_pressure;
 }
 
 static struct shrinker icache_shrinker = {
-	.shrink_zone = shrink_icache_memory,
+	.shrink = shrink_icache_memory,
+	.seeks = DEFAULT_SEEKS,
 };
 
 static void __wait_on_freeing_inode(struct inode *inode);
-/*
- * Called with the inode lock held.
- * NOTE: we are not increasing the inode-refcount, you must call inode_get_ilock()
- * by hand after calling find_inode now! This simplifies iunique and won't
- * add any additional branch in the common code.
- */
+
 static struct inode *find_inode(struct super_block *sb,
-				struct inode_hash_bucket *b,
+				struct hlist_bl_head *b,
 				int (*test)(struct inode *, void *),
 				void *data)
 {
@@ -697,28 +742,25 @@ static struct inode *find_inode(struct super_block *sb,
 	struct inode *inode = NULL;
 
 repeat:
-	rcu_read_lock();
-	hlist_bl_for_each_entry_rcu(inode, node, &b->head, i_hash) {
+	hlist_bl_for_each_entry(inode, node, b, i_hash) {
 		if (inode->i_sb != sb)
 			continue;
 		spin_lock(&inode->i_lock);
-		if (hlist_bl_unhashed(&inode->i_hash)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
 		if (!test(inode, data)) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
-			rcu_read_unlock();
+			hlist_bl_unlock(b);
 			__wait_on_freeing_inode(inode);
+			hlist_bl_lock(b);
 			goto repeat;
 		}
-		break;
+		inode->i_ref++;
+		spin_unlock(&inode->i_lock);
+		return inode;
 	}
-	rcu_read_unlock();
-	return node ? inode : NULL;
+	return NULL;
 }
 
 /*
@@ -726,135 +768,31 @@ repeat:
  * iget_locked for details.
  */
 static struct inode *find_inode_fast(struct super_block *sb,
-				struct inode_hash_bucket *b,
-				unsigned long ino)
+		struct hlist_bl_head *b, unsigned long ino)
 {
 	struct hlist_bl_node *node;
 	struct inode *inode = NULL;
 
 repeat:
-	rcu_read_lock();
-	hlist_bl_for_each_entry_rcu(inode, node, &b->head, i_hash) {
+	hlist_bl_for_each_entry(inode, node, b, i_hash) {
 		if (inode->i_ino != ino)
 			continue;
 		if (inode->i_sb != sb)
 			continue;
 		spin_lock(&inode->i_lock);
-		if (hlist_bl_unhashed(&inode->i_hash)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
-			rcu_read_unlock();
+			hlist_bl_unlock(b);
 			__wait_on_freeing_inode(inode);
+			hlist_bl_lock(b);
 			goto repeat;
 		}
-		break;
-	}
-	rcu_read_unlock();
-	return node ? inode : NULL;
-}
-
-static unsigned long hash(struct super_block *sb, unsigned long hashval)
-{
-	unsigned long tmp;
-
-	tmp = (hashval * (unsigned long)sb) ^ (GOLDEN_RATIO_PRIME + hashval) /
-			L1_CACHE_BYTES;
-	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> I_HASHBITS);
-	return tmp & I_HASHMASK;
-}
-
-static inline int inode_list_cpu(struct inode *inode)
-{
-#ifdef CONFIG_SMP
-	return inode->i_sb_list_cpu;
-#else
-	return smp_processor_id();
-#endif
-}
-
-/* helper for file_sb_list_add to reduce ifdefs */
-static inline void __inode_sb_list_add(struct inode *inode, struct super_block *sb)
-{
-	struct list_head *list;
-#ifdef CONFIG_SMP
-	int cpu;
-	cpu = smp_processor_id();
-	inode->i_sb_list_cpu = cpu;
-	list = per_cpu_ptr(sb->s_inodes, cpu);
-#else
-	list = &sb->s_inodes;
-#endif
-	list_add_rcu(&inode->i_sb_list, list);
-}
-
-/**
- * inode_sb_list_add - add an inode to the sb's file list
- * @inode: inode to add
- * @sb: sb to add it to
- *
- * Use this function to associate an with the superblock it belongs to.
- */
-static void inode_sb_list_add(struct inode *inode, struct super_block *sb)
-{
-	lg_local_lock(inode_list_lglock);
-	__inode_sb_list_add(inode, sb);
-	lg_local_unlock(inode_list_lglock);
-}
-
-/**
- * inode_sb_list_del - remove an inode from the sb's inode list
- * @inode: inode to remove
- * @sb: sb to remove it from
- *
- * Use this function to remove an inode from its superblock.
- */
-static void inode_sb_list_del(struct inode *inode)
-{
-	if (list_empty(&inode->i_sb_list))
-		return;
-	lg_local_lock_cpu(inode_list_lglock, inode_list_cpu(inode));
-	list_del_rcu(&inode->i_sb_list);
-	lg_local_unlock_cpu(inode_list_lglock, inode_list_cpu(inode));
-}
-
-static inline void
-__inode_add_to_lists(struct super_block *sb, struct inode_hash_bucket *b,
-			struct inode *inode)
-{
-	inode_sb_list_add(inode, sb);
-	if (b) {
-		spin_lock_bucket(b);
-		hlist_bl_add_head_rcu(&inode->i_hash, &b->head);
-		spin_unlock_bucket(b);
+		inode->i_ref++;
+		spin_unlock(&inode->i_lock);
+		return inode;
 	}
+	return NULL;
 }
 
-/**
- * inode_add_to_lists - add a new inode to relevant lists
- * @sb: superblock inode belongs to
- * @inode: inode to mark in use
- *
- * When an inode is allocated it needs to be accounted for, added to the in use
- * list, the owning superblock and the inode hash.
- *
- * We calculate the hash list to add to here so it is all internal
- * which requires the caller to have already set up the inode number in the
- * inode to add.
- */
-void inode_add_to_lists(struct super_block *sb, struct inode *inode)
-{
-	struct inode_hash_bucket *b = inode_hashtable + hash(sb, inode->i_ino);
-
-	spin_lock(&inode->i_lock);
-	__inode_add_to_lists(sb, b, inode);
-	spin_unlock(&inode->i_lock);
-}
-EXPORT_SYMBOL_GPL(inode_add_to_lists);
-
-#define LAST_INO_BATCH 1024
-
 /*
  * Each cpu owns a range of LAST_INO_BATCH numbers.
  * 'shared_last_ino' is dirtied only once out of LAST_INO_BATCH allocations,
@@ -870,25 +808,25 @@ EXPORT_SYMBOL_GPL(inode_add_to_lists);
  * error if st_ino won't fit in target struct field. Use 32bit counter
  * here to attempt to avoid that.
  */
+#define LAST_INO_BATCH 1024
 static DEFINE_PER_CPU(unsigned int, last_ino);
 
 unsigned int get_next_ino(void)
 {
-	unsigned int res;
+	unsigned int *p = &get_cpu_var(last_ino);
+	unsigned int res = *p;
 
-	get_cpu();
-	res = __this_cpu_read(last_ino);
 #ifdef CONFIG_SMP
-	if (unlikely((res & (LAST_INO_BATCH - 1)) == 0)) {
+	if (unlikely((res & (LAST_INO_BATCH-1)) == 0)) {
 		static atomic_t shared_last_ino;
 		int next = atomic_add_return(LAST_INO_BATCH, &shared_last_ino);
 
 		res = next - LAST_INO_BATCH;
 	}
 #endif
-	res++;
-	__this_cpu_write(last_ino, res);
-	put_cpu();
+
+	*p = ++res;
+	put_cpu_var(last_ino);
 	return res;
 }
 EXPORT_SYMBOL(get_next_ino);
@@ -911,44 +849,16 @@ struct inode *new_inode(struct super_block *sb)
 
 	inode = alloc_inode(sb);
 	if (inode) {
-		inode->i_ino = get_next_ino();
-		inode->i_state = 0;
 		/*
-		 * We could init inode locked here, to improve performance.
+		 * set the inode state before we make the inode accessible to
+		 * the outside world.
 		 */
-		spin_lock(&inode->i_lock);
-		__inode_add_to_lists(sb, NULL, inode);
-		spin_unlock(&inode->i_lock);
-	}
-	return inode;
-}
-EXPORT_SYMBOL(new_inode);
-
-/**
- *	new_anon_inode 	- obtain an anonymous inode
- *	@sb: superblock
- *
- *	Similar to new_inode, however the inode is not given an inode
- *	number, and is not added to the sb's list of inodes, to reduce
- *	overheads.
- *
- *	A filesystem which needs an inode number must subsequently
- *	assign one to i_ino. A filesystem which needs inodes to be on the
- *	per-sb list (currently only used by the vfs for umount or remount)
- *	must add the inode to that list.
- */
-struct inode *new_anon_inode(struct super_block *sb)
-{
-	struct inode *inode;
-
-	inode = alloc_inode(sb);
-	if (inode) {
-		inode->i_ino = ULONG_MAX;
 		inode->i_state = 0;
+		inode_sb_list_add(inode);
 	}
 	return inode;
 }
-EXPORT_SYMBOL(new_anon_inode);
+EXPORT_SYMBOL(new_inode);
 
 void unlock_new_inode(struct inode *inode)
 {
@@ -992,7 +902,7 @@ EXPORT_SYMBOL(unlock_new_inode);
  *	-- rmk@arm.uk.linux.org
  */
 static struct inode *get_new_inode(struct super_block *sb,
-				struct inode_hash_bucket *b,
+				struct hlist_bl_head *b,
 				int (*test)(struct inode *, void *),
 				int (*set)(struct inode *, void *),
 				void *data)
@@ -1003,16 +913,21 @@ static struct inode *get_new_inode(struct super_block *sb,
 	if (inode) {
 		struct inode *old;
 
+		hlist_bl_lock(b);
 		/* We released the lock, so.. */
 		old = find_inode(sb, b, test, data);
 		if (!old) {
-			spin_lock(&inode->i_lock);
 			if (set(inode, data))
 				goto set_failed;
 
+			/*
+			 * Set the inode state before we make the inode
+			 * visible to the outside world.
+			 */
 			inode->i_state = I_NEW;
-			__inode_add_to_lists(sb, b, inode);
-			spin_unlock(&inode->i_lock);
+			hlist_bl_add_head(&inode->i_hash, b);
+			hlist_bl_unlock(b);
+			inode_sb_list_add(inode);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -1025,8 +940,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		inode_get_ilock(old);
-		spin_unlock(&old->i_lock);
+		hlist_bl_unlock(b);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -1034,7 +948,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 	return inode;
 
 set_failed:
-	spin_unlock(&inode->i_lock);
+	hlist_bl_unlock(b);
 	destroy_inode(inode);
 	return NULL;
 }
@@ -1044,7 +958,7 @@ set_failed:
  * comment at iget_locked for details.
  */
 static struct inode *get_new_inode_fast(struct super_block *sb,
-				struct inode_hash_bucket *b, unsigned long ino)
+				struct hlist_bl_head *b, unsigned long ino)
 {
 	struct inode *inode;
 
@@ -1052,14 +966,19 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 	if (inode) {
 		struct inode *old;
 
+		hlist_bl_lock(b);
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, b, ino);
 		if (!old) {
-			spin_lock(&inode->i_lock);
+			/*
+			 * Set the inode state before we make the inode
+			 * visible to the outside world.
+			 */
 			inode->i_ino = ino;
 			inode->i_state = I_NEW;
-			__inode_add_to_lists(sb, b, inode);
-			spin_unlock(&inode->i_lock);
+			hlist_bl_add_head(&inode->i_hash, b);
+			hlist_bl_unlock(b);
+			inode_sb_list_add(inode);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -1072,8 +991,7 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		inode_get_ilock(old);
-		spin_unlock(&old->i_lock);
+		hlist_bl_unlock(b);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -1081,26 +999,28 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 	return inode;
 }
 
-/* Is the ino for this sb hashed right now? */
-static int is_ino_hashed(struct super_block *sb, unsigned long ino)
+/*
+ * search the inode cache for a matching inode number.
+ * If we find one, then the inode number we are trying to
+ * allocate is not unique and so we should not use it.
+ *
+ * Returns 1 if the inode number is unique, 0 if it is not.
+ */
+static int test_inode_iunique(struct super_block *sb, unsigned long ino)
 {
+	struct hlist_bl_head *b = inode_hashtable + hash(sb, ino);
 	struct hlist_bl_node *node;
-	struct inode *inode = NULL;
-	struct inode_hash_bucket *b = inode_hashtable + hash(sb, ino);
+	struct inode *inode;
 
-	spin_lock_bucket(b);
-	hlist_bl_for_each_entry(inode, node, &b->head, i_hash) {
+	hlist_bl_lock(b);
+	hlist_bl_for_each_entry(inode, node, b, i_hash) {
 		if (inode->i_ino == ino && inode->i_sb == sb) {
-			spin_unlock_bucket(b);
+			hlist_bl_unlock(b);
 			return 0;
 		}
-		/*
-		 * Don't bother checking for I_FREEING etc., because
-		 * we don't want iunique to wait on freeing inodes. Just
-		 * skip it and get the next one.
-		 */
 	}
-	spin_unlock_bucket(b);
+
+	hlist_bl_unlock(b);
 	return 1;
 }
 
@@ -1125,17 +1045,17 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 	 * error if st_ino won't fit in target struct field. Use 32bit counter
 	 * here to attempt to avoid that.
 	 */
-	static DEFINE_SPINLOCK(unique_lock);
+	static DEFINE_SPINLOCK(iunique_lock);
 	static unsigned int counter;
 	ino_t res;
 
-	spin_lock(&unique_lock);
+	spin_lock(&iunique_lock);
 	do {
 		if (counter <= max_reserved)
 			counter = max_reserved + 1;
 		res = counter++;
-	} while (!is_ino_hashed(sb, res));
-	spin_unlock(&unique_lock);
+	} while (!test_inode_iunique(sb, res));
+	spin_unlock(&iunique_lock);
 
 	return res;
 }
@@ -1143,21 +1063,20 @@ EXPORT_SYMBOL(iunique);
 
 struct inode *igrab(struct inode *inode)
 {
-	struct inode *ret = inode;
-
 	spin_lock(&inode->i_lock);
-	if (!(inode->i_state & (I_FREEING|I_WILL_FREE)))
-		inode_get_ilock(inode);
-	else
+	if (!(inode->i_state & (I_FREEING|I_WILL_FREE))) {
+		inode->i_ref++;
+		spin_unlock(&inode->i_lock);
+	} else {
+		spin_unlock(&inode->i_lock);
 		/*
 		 * Handle the case where s_op->clear_inode is not been
 		 * called yet, and somebody is calling igrab
 		 * while the inode is getting freed.
 		 */
-		ret = NULL;
-	spin_unlock(&inode->i_lock);
-
-	return ret;
+		inode = NULL;
+	}
+	return inode;
 }
 EXPORT_SYMBOL(igrab);
 
@@ -1181,21 +1100,19 @@ EXPORT_SYMBOL(igrab);
  * Note, @test is called with the i_lock held, so can't sleep.
  */
 static struct inode *ifind(struct super_block *sb,
-		struct inode_hash_bucket *b,
+		struct hlist_bl_head *b,
 		int (*test)(struct inode *, void *),
 		void *data, const int wait)
 {
 	struct inode *inode;
 
+	hlist_bl_lock(b);
 	inode = find_inode(sb, b, test, data);
-	if (inode) {
-		inode_get_ilock(inode);
-		spin_unlock(&inode->i_lock);
-		if (likely(wait))
-			wait_on_inode(inode);
-		return inode;
-	}
-	return NULL;
+	hlist_bl_unlock(b);
+
+	if (inode && likely(wait))
+		wait_on_inode(inode);
+	return inode;
 }
 
 /**
@@ -1214,19 +1131,18 @@ static struct inode *ifind(struct super_block *sb,
  * Otherwise NULL is returned.
  */
 static struct inode *ifind_fast(struct super_block *sb,
-		struct inode_hash_bucket *b,
+		struct hlist_bl_head *b,
 		unsigned long ino)
 {
 	struct inode *inode;
 
+	hlist_bl_lock(b);
 	inode = find_inode_fast(sb, b, ino);
-	if (inode) {
-		inode_get_ilock(inode);
-		spin_unlock(&inode->i_lock);
+	hlist_bl_unlock(b);
+
+	if (inode)
 		wait_on_inode(inode);
-		return inode;
-	}
-	return NULL;
+	return inode;
 }
 
 /**
@@ -1253,7 +1169,7 @@ static struct inode *ifind_fast(struct super_block *sb,
 struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
-	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
+	struct hlist_bl_head *b = inode_hashtable + hash(sb, hashval);
 
 	return ifind(sb, b, test, data, 0);
 }
@@ -1281,7 +1197,7 @@ EXPORT_SYMBOL(ilookup5_nowait);
 struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
-	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
+	struct hlist_bl_head *b = inode_hashtable + hash(sb, hashval);
 
 	return ifind(sb, b, test, data, 1);
 }
@@ -1303,7 +1219,7 @@ EXPORT_SYMBOL(ilookup5);
  */
 struct inode *ilookup(struct super_block *sb, unsigned long ino)
 {
-	struct inode_hash_bucket *b = inode_hashtable + hash(sb, ino);
+	struct hlist_bl_head *b = inode_hashtable + hash(sb, ino);
 
 	return ifind_fast(sb, b, ino);
 }
@@ -1333,7 +1249,7 @@ struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *),
 		int (*set)(struct inode *, void *), void *data)
 {
-	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
+	struct hlist_bl_head *b = inode_hashtable + hash(sb, hashval);
 	struct inode *inode;
 
 	inode = ifind(sb, b, test, data, 1);
@@ -1364,7 +1280,7 @@ EXPORT_SYMBOL(iget5_locked);
  */
 struct inode *iget_locked(struct super_block *sb, unsigned long ino)
 {
-	struct inode_hash_bucket *b = inode_hashtable + hash(sb, ino);
+	struct hlist_bl_head *b = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
 
 	inode = ifind_fast(sb, b, ino);
@@ -1382,43 +1298,40 @@ int insert_inode_locked(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 	ino_t ino = inode->i_ino;
-	struct inode_hash_bucket *b = inode_hashtable + hash(sb, ino);
-	struct hlist_bl_node *node;
-	struct inode *old;
+	struct hlist_bl_head *b = inode_hashtable + hash(sb, ino);
 
 	inode->i_state |= I_NEW;
-
-repeat:
-	spin_lock_bucket(b);
-	hlist_bl_for_each_entry(old, node, &b->head, i_hash) {
-		if (old->i_ino != ino)
-			continue;
-		if (old->i_sb != sb)
-			continue;
-		if (old->i_state & (I_FREEING|I_WILL_FREE))
-			continue;
-		if (!spin_trylock(&old->i_lock)) {
-			spin_unlock_bucket(b);
-			cpu_relax();
-			goto repeat;
+	while (1) {
+		struct hlist_bl_node *node;
+		struct inode *old = NULL;
+		hlist_bl_lock(b);
+		hlist_bl_for_each_entry(old, node, b, i_hash) {
+			if (old->i_ino != ino)
+				continue;
+			if (old->i_sb != sb)
+				continue;
+			spin_lock(&old->i_lock);
+			if (old->i_state & (I_FREEING|I_WILL_FREE)) {
+				spin_unlock(&old->i_lock);
+				continue;
+			}
+			break;
+		}
+		if (likely(!node)) {
+			hlist_bl_add_head(&inode->i_hash, b);
+			hlist_bl_unlock(b);
+			return 0;
+		}
+		old->i_ref++;
+		spin_unlock(&old->i_lock);
+		hlist_bl_unlock(b);
+		wait_on_inode(old);
+		if (unlikely(!inode_unhashed(old))) {
+			iput(old);
+			return -EBUSY;
 		}
-		goto found_old;
-	}
-	hlist_bl_add_head_rcu(&inode->i_hash, &b->head);
-	spin_unlock_bucket(b);
-	return 0;
-
-found_old:
-	spin_unlock_bucket(b);
-	inode_get_ilock(old);
-	spin_unlock(&old->i_lock);
-	wait_on_inode(old);
-	if (unlikely(!hlist_bl_unhashed(&old->i_hash))) {
 		iput(old);
-		return -EBUSY;
 	}
-	iput(old);
-	goto repeat;
 }
 EXPORT_SYMBOL(insert_inode_locked);
 
@@ -1426,95 +1339,49 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
 	struct super_block *sb = inode->i_sb;
-	struct inode_hash_bucket *b = inode_hashtable + hash(sb, hashval);
-	struct hlist_bl_node *node;
-	struct inode *old;
+	struct hlist_bl_head *b = inode_hashtable + hash(sb, hashval);
 
+	/*
+	 * Nobody else can see the new inode yet, so it is safe to set flags
+	 * without locking here.
+	 */
 	inode->i_state |= I_NEW;
 
-repeat:
-	spin_lock_bucket(b);
-	hlist_bl_for_each_entry(old, node, &b->head, i_hash) {
-		if (old->i_sb != sb)
-			continue;
-		/* XXX: audit put test outside i_lock? */
-		if (!test(old, data))
-			continue;
-		if (old->i_state & (I_FREEING|I_WILL_FREE))
-			continue;
-		if (!spin_trylock(&old->i_lock)) {
-			spin_unlock_bucket(b);
-			cpu_relax();
-			goto repeat;
+	while (1) {
+		struct hlist_bl_node *node;
+		struct inode *old = NULL;
+
+		hlist_bl_lock(b);
+		hlist_bl_for_each_entry(old, node, b, i_hash) {
+			if (old->i_sb != sb)
+				continue;
+			if (!test(old, data))
+				continue;
+			spin_lock(&old->i_lock);
+			if (old->i_state & (I_FREEING|I_WILL_FREE)) {
+				spin_unlock(&old->i_lock);
+				continue;
+			}
+			break;
+		}
+		if (likely(!node)) {
+			hlist_bl_add_head(&inode->i_hash, b);
+			hlist_bl_unlock(b);
+			return 0;
+		}
+		old->i_ref++;
+		spin_unlock(&old->i_lock);
+		hlist_bl_unlock(b);
+		wait_on_inode(old);
+		if (unlikely(!inode_unhashed(old))) {
+			iput(old);
+			return -EBUSY;
 		}
-		goto found_old;
-	}
-	hlist_bl_add_head_rcu(&inode->i_hash, &b->head);
-	spin_unlock_bucket(b);
-	return 0;
-
-found_old:
-	spin_unlock_bucket(b);
-	inode_get_ilock(old);
-	spin_unlock(&old->i_lock);
-	wait_on_inode(old);
-	if (unlikely(!hlist_bl_unhashed(&old->i_hash))) {
 		iput(old);
-		return -EBUSY;
 	}
-	iput(old);
-	goto repeat;
 }
 EXPORT_SYMBOL(insert_inode_locked4);
 
-/**
- *	__insert_inode_hash - hash an inode
- *	@inode: unhashed inode
- *	@hashval: unsigned long value used to locate this object in the
- *		inode_hashtable.
- *
- *	Add an inode to the inode hash for this superblock.
- */
-void __insert_inode_hash(struct inode *inode, unsigned long hashval)
-{
-	struct inode_hash_bucket *b = inode_hashtable + hash(inode->i_sb, hashval);
-
-	spin_lock(&inode->i_lock);
-	spin_lock_bucket(b);
-	hlist_bl_add_head_rcu(&inode->i_hash, &b->head);
-	spin_unlock_bucket(b);
-	spin_unlock(&inode->i_lock);
-}
-EXPORT_SYMBOL(__insert_inode_hash);
-
-/**
- *	__remove_inode_hash - remove an inode from the hash
- *	@inode: inode to unhash
- *
- *	Remove an inode from the superblock. inode->i_lock must be
- *	held.
- */
-static void __remove_inode_hash(struct inode *inode)
-{
-	struct inode_hash_bucket *b = inode_hashtable + hash(inode->i_sb, inode->i_ino);
-	spin_lock_bucket(b);
-	hlist_bl_del_init_rcu(&inode->i_hash);
-	spin_unlock_bucket(b);
-}
-
-/**
- *	remove_inode_hash - remove an inode from the hash
- *	@inode: inode to unhash
- *
- *	Remove an inode from the superblock.
- */
-void remove_inode_hash(struct inode *inode)
-{
-	spin_lock(&inode->i_lock);
-	__remove_inode_hash(inode);
-	spin_unlock(&inode->i_lock);
-}
-EXPORT_SYMBOL(remove_inode_hash);
 
 int generic_delete_inode(struct inode *inode)
 {
@@ -1529,7 +1396,7 @@ EXPORT_SYMBOL(generic_delete_inode);
  */
 int generic_drop_inode(struct inode *inode)
 {
-	return !inode->i_nlink || hlist_bl_unhashed(&inode->i_hash);
+	return !inode->i_nlink || inode_unhashed(inode);
 }
 EXPORT_SYMBOL_GPL(generic_drop_inode);
 
@@ -1549,6 +1416,8 @@ static void iput_final(struct inode *inode)
 	const struct super_operations *op = inode->i_sb->s_op;
 	int drop;
 
+	assert_spin_locked(&inode->i_lock);
+
 	if (op && op->drop_inode)
 		drop = op->drop_inode(inode);
 	else
@@ -1558,8 +1427,11 @@ static void iput_final(struct inode *inode)
 		if (sb->s_flags & MS_ACTIVE) {
 			inode->i_state |= I_REFERENCED;
 			if (!(inode->i_state & (I_DIRTY|I_SYNC)) &&
-					list_empty(&inode->i_lru))
-				__inode_lru_list_add(inode);
+			    list_empty(&inode->i_lru)) {
+				spin_unlock(&inode->i_lock);
+				inode_lru_list_add(inode);
+				return;
+			}
 			spin_unlock(&inode->i_lock);
 			return;
 		}
@@ -1567,32 +1439,16 @@ static void iput_final(struct inode *inode)
 		inode->i_state |= I_WILL_FREE;
 		spin_unlock(&inode->i_lock);
 		write_inode_now(inode, 1);
+		remove_inode_hash(inode);
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		__remove_inode_hash(inode);
 	}
-	if (!list_empty(&inode->i_lru))
-		__inode_lru_list_del(inode);
-	if (!list_empty(&inode->i_io)) {
-		struct bdi_writeback *wb = inode_to_wb(inode);
-		spin_lock(&wb->b_lock);
-		list_del_init(&inode->i_io);
-		spin_unlock(&wb->b_lock);
-	}
-	inode_sb_list_del(inode);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
-	evict(inode);
-	/*
-	 * i_lock is required to delete from hash because find_inode_fast
-	 * might find us but go to sleep before we run wake_up_inode.
-	 */
-	remove_inode_hash(inode);
-	wake_up_inode(inode);
-	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
-	destroy_inode(inode);
+
+	dispose_one_inode(inode);
 }
 
 /**
@@ -1607,14 +1463,14 @@ static void iput_final(struct inode *inode)
 void iput(struct inode *inode)
 {
 	if (inode) {
+		spin_lock(&inode->i_lock);
 		BUG_ON(inode->i_state & I_CLEAR);
 
-		spin_lock(&inode->i_lock);
-		inode->i_refs--;
-		if (inode->i_refs == 0)
+		if (--inode->i_ref == 0) {
 			iput_final(inode);
-		else
-			spin_unlock(&inode->i_lock);
+			return;
+		}
+		spin_unlock(&inode->i_lock);
 	}
 }
 EXPORT_SYMBOL(iput);
@@ -1832,7 +1688,7 @@ void __init inode_init_early(void)
 
 	inode_hashtable =
 		alloc_large_system_hash("Inode-cache",
-					sizeof(struct inode_hash_bucket),
+					sizeof(struct hlist_bl_head),
 					ihash_entries,
 					14,
 					HASH_EARLY,
@@ -1841,13 +1697,12 @@ void __init inode_init_early(void)
 					0);
 
 	for (loop = 0; loop < (1 << i_hash_shift); loop++)
-		INIT_HLIST_BL_HEAD(&inode_hashtable[loop].head);
+		INIT_HLIST_HEAD(&inode_hashtable[loop]);
 }
 
 void __init inode_init(void)
 {
 	int loop;
-	struct zone *zone;
 
 	/* inode slab cache */
 	inode_cachep = kmem_cache_create("inode_cache",
@@ -1856,15 +1711,9 @@ void __init inode_init(void)
 					 (SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
 					 SLAB_MEM_SPREAD),
 					 init_once);
-	for_each_zone(zone) {
-		spin_lock_init(&zone->inode_lru_lock);
-		INIT_LIST_HEAD(&zone->inode_lru);
-		zone->inode_nr_lru = 0;
-		zone->inode_nr_scan = 0;
-	}
 	register_shrinker(&icache_shrinker);
-
-	lg_lock_init(inode_list_lglock);
+	percpu_counter_init(&nr_inodes, 0);
+	percpu_counter_init(&nr_inodes_unused, 0);
 
 	/* Hash may have been set up in inode_init_early */
 	if (!hashdist)
@@ -1872,7 +1721,7 @@ void __init inode_init(void)
 
 	inode_hashtable =
 		alloc_large_system_hash("Inode-cache",
-					sizeof(struct inode_hash_bucket),
+					sizeof(struct hlist_bl_head),
 					ihash_entries,
 					14,
 					0,
@@ -1881,7 +1730,7 @@ void __init inode_init(void)
 					0);
 
 	for (loop = 0; loop < (1 << i_hash_shift); loop++)
-		INIT_HLIST_BL_HEAD(&inode_hashtable[loop].head);
+		INIT_HLIST_BL_HEAD(&inode_hashtable[loop]);
 }
 
 void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
diff --git a/fs/internal.h b/fs/internal.h
index ada4564..f8825ae 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -15,18 +15,6 @@ struct super_block;
 struct linux_binprm;
 struct path;
 
-static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
-{
-	struct super_block *sb = inode->i_sb;
-
-	if (strcmp(sb->s_type->name, "bdev") == 0)
-		return inode->i_mapping->backing_dev_info;
-
-	return sb->s_bdi;
-}
-
-#define inode_to_wb(inode)   (&inode_to_bdi(inode)->wb)
-
 /*
  * block_dev.c
  */
@@ -113,3 +101,14 @@ extern void put_super(struct super_block *sb);
 struct nameidata;
 extern struct file *nameidata_to_filp(struct nameidata *);
 extern void release_open_intent(struct nameidata *);
+
+/*
+ * inode.c
+ */
+extern void inode_lru_list_add(struct inode *inode);
+extern void inode_lru_list_del(struct inode *inode);
+
+/*
+ * fs-writeback.c
+ */
+extern void inode_wb_list_del(struct inode *inode);
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
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 9b2b81c..ce7344e 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -45,7 +45,6 @@
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
 #include <linux/hash.h>
-#include <linux/list_bl.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include "nilfs.h"
@@ -286,15 +285,17 @@ void nilfs_clear_gcinode(struct inode *inode)
 void nilfs_remove_all_gcinode(struct the_nilfs *nilfs)
 {
 	struct hlist_bl_head *head = nilfs->ns_gc_inodes_h;
-	struct hlist_bl_node *node, *n;
+	struct hlist_bl_node *node;
 	struct inode *inode;
 	int loop;
 
 	for (loop = 0; loop < NILFS_GCINODE_HASH_SIZE; loop++, head++) {
-		hlist_bl_for_each_entry_safe(inode, node, n, head, i_hash) {
+restart:
+		hlist_bl_for_each_entry(inode, node, head, i_hash) {
 			hlist_bl_del_init(&inode->i_hash);
 			list_del_init(&NILFS_I(inode)->i_dirty);
 			nilfs_clear_gcinode(inode); /* might sleep */
+			goto restart;
 		}
 	}
 }
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 08b9888..265ecba 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -22,7 +22,6 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
-#include <linux/writeback.h>
 
 #include <asm/atomic.h>
 
@@ -232,35 +231,35 @@ out:
  * fsnotify_unmount_inodes - an sb is unmounting.  handle any watched inodes.
  * @list: list of inodes being unmounted (sb->s_inodes)
  *
- * Called with iprune_mutex held, keeping shrink_icache_memory() at bay,
- * and with the sb going away, no new inodes will appear or be referenced
- * from other paths.
+ * Called with iprune_mutex held, keeping shrink_icache_memory() at bay.
+ * sb->s_inodes_lock protects the super block's list of inodes.
  */
-void fsnotify_unmount_inodes(struct super_block *sb)
+void fsnotify_unmount_inodes(struct list_head *list)
 {
 	struct inode *inode, *next_i, *need_iput = NULL;
 
-	do_inode_list_for_each_entry_safe(sb, inode, next_i) {
+	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
 		struct inode *need_iput_tmp;
+		struct super_block *sb = inode->i_sb;
 
-		spin_lock(&inode->i_lock);
 		/*
-		 * We cannot inode_get() an inode in state I_FREEING,
+		 * We cannot iref() an inode in state I_FREEING,
 		 * I_WILL_FREE, or I_NEW which is fine because by that point
 		 * the inode cannot have any associated watches.
 		 */
+		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 
 		/*
-		 * If i_refs is zero, the inode cannot have any watches and
-		 * doing an inode_get/iput with MS_ACTIVE clear would actually
-		 * evict all inodes with zero i_refs from icache which is
+		 * If i_ref is zero, the inode cannot have any watches and
+		 * doing an iref/iput with MS_ACTIVE clear would actually
+		 * evict all inodes with zero i_ref from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
-		if (!inode->i_refs) {
+		if (!inode->i_ref) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
@@ -270,7 +269,7 @@ void fsnotify_unmount_inodes(struct super_block *sb)
 
 		/* In case fsnotify_inode_delete() drops a reference. */
 		if (inode != need_iput_tmp)
-			inode_get_ilock(inode);
+			inode->i_ref++;
 		else
 			need_iput_tmp = NULL;
 		spin_unlock(&inode->i_lock);
@@ -278,14 +277,22 @@ void fsnotify_unmount_inodes(struct super_block *sb)
 		/* In case the dropping of a reference would nuke next_i. */
 		if (&next_i->i_sb_list != list) {
 			spin_lock(&next_i->i_lock);
-			if (next_i->i_refs &&
+			if (inode->i_ref &&
 			    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
-				inode_get_ilock(next_i);
+				next_i->i_ref++;
 				need_iput = next_i;
 			}
 			spin_unlock(&next_i->i_lock);
 		}
 
+		/*
+		 * We can safely drop sb->s_inodes_lock here because we hold
+		 * references on both inode and next_i.  Also no new inodes
+		 * will be added since the umount has begun.  Finally,
+		 * iprune_mutex keeps shrink_icache_memory() away.
+		 */
+		spin_unlock(&sb->s_inodes_lock);
+
 		if (need_iput_tmp)
 			iput(need_iput_tmp);
 
@@ -295,5 +302,7 @@ void fsnotify_unmount_inodes(struct super_block *sb)
 		fsnotify_inode_delete(inode);
 
 		iput(inode);
-	} while_inode_list_for_each_entry_safe
+
+		spin_lock(&sb->s_inodes_lock);
+	}
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
 
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index aed3559..178bed4 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -246,7 +246,6 @@ struct dqstats dqstats;
 EXPORT_SYMBOL(dqstats);
 
 static qsize_t inode_get_rsv_space(struct inode *inode);
-static qsize_t __inode_get_rsv_space(struct inode *inode);
 static void __dquot_initialize(struct inode *inode, int type);
 
 static inline unsigned int
@@ -897,41 +896,35 @@ static void add_dquot_ref(struct super_block *sb, int type)
 	int reserved = 0;
 #endif
 
-	rcu_read_lock();
-	do_inode_list_for_each_entry_rcu(sb, inode) {
+	spin_lock(&sb->s_inodes_lock);
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
+		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+		    !atomic_read(&inode->i_writecount) ||
+		    !dqinit_needed(inode, type)) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 #ifdef CONFIG_QUOTA_DEBUG
-		if (unlikely(__inode_get_rsv_space(inode) > 0))
+		if (unlikely(inode_get_rsv_space(inode) > 0))
 			reserved = 1;
 #endif
-		if (!atomic_read(&inode->i_writecount)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-		if (!dqinit_needed(inode, type)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
 
-		inode_get_ilock(inode);
+		inode->i_ref++;
 		spin_unlock(&inode->i_lock);
-		rcu_read_unlock();
+		spin_unlock(&sb->s_inodes_lock);
 
 		iput(old_inode);
 		__dquot_initialize(inode, type);
 		/* We hold a reference to 'inode' so it couldn't have been
-		 * removed from s_inodes list while we dropped the
-		 * i_lock.  We cannot iput the inode now as we can
-		 * be holding the last reference and we cannot iput it under
-		 * lock. So we keep the reference and iput it later. */
+		 * removed from s_inodes list while we dropped the lock.
+		 * We cannot iput the inode now as we can be holding the last
+		 * reference and we cannot iput it under the lock. So we
+		 * keep the reference and iput it later. */
 		old_inode = inode;
-		rcu_read_lock();
-	} while_inode_list_for_each_entry_rcu
-	rcu_read_unlock();
+		spin_lock(&sb->s_inodes_lock);
+	}
+	spin_unlock(&sb->s_inodes_lock);
 	iput(old_inode);
 
 #ifdef CONFIG_QUOTA_DEBUG
@@ -1012,8 +1005,8 @@ static void remove_dquot_ref(struct super_block *sb, int type,
 	struct inode *inode;
 	int reserved = 0;
 
-	rcu_read_lock();
-	do_inode_list_for_each_entry_rcu(sb, inode) {
+	spin_lock(&sb->s_inodes_lock);
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		/*
 		 *  We have to scan also I_NEW inodes because they can already
 		 *  have quota pointer initialized. Luckily, we need to touch
@@ -1025,8 +1018,8 @@ static void remove_dquot_ref(struct super_block *sb, int type,
 				reserved = 1;
 			remove_inode_dquot_ref(inode, type, tofree_head);
 		}
-	} while_inode_list_for_each_entry_rcu
-	rcu_read_unlock();
+	}
+	spin_unlock(&sb->s_inodes_lock);
 #ifdef CONFIG_QUOTA_DEBUG
 	if (reserved) {
 		printk(KERN_WARNING "VFS (%s): Writes happened after quota"
@@ -1497,17 +1490,6 @@ void inode_sub_rsv_space(struct inode *inode, qsize_t number)
 }
 EXPORT_SYMBOL(inode_sub_rsv_space);
 
-/* no i_lock variant of inode_get_rsv_space */
-static qsize_t __inode_get_rsv_space(struct inode *inode)
-{
-	qsize_t ret;
-
-	if (!inode->i_sb->dq_op->get_reserved_space)
-		return 0;
-	ret = *inode_reserved_space(inode);
-	return ret;
-}
-
 static qsize_t inode_get_rsv_space(struct inode *inode)
 {
 	qsize_t ret;
diff --git a/fs/super.c b/fs/super.c
index 573c040..c5332e5 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -67,28 +67,16 @@ static struct super_block *alloc_super(struct file_system_type *type)
 			for_each_possible_cpu(i)
 				INIT_LIST_HEAD(per_cpu_ptr(s->s_files, i));
 		}
-		s->s_inodes = alloc_percpu(struct list_head);
-		if (!s->s_inodes) {
-			free_percpu(s->s_files);
-			security_sb_free(s);
-			kfree(s);
-			s = NULL;
-			goto out;
-		} else {
-			int i;
-
-			for_each_possible_cpu(i)
-				INIT_LIST_HEAD(per_cpu_ptr(s->s_inodes, i));
-		}
 #else
 		INIT_LIST_HEAD(&s->s_files);
-		INIT_LIST_HEAD(&s->s_inodes);
 #endif
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
+		INIT_LIST_HEAD(&s->s_inodes);
 		INIT_LIST_HEAD(&s->s_dentry_lru);
 		init_rwsem(&s->s_umount);
 		mutex_init(&s->s_lock);
+		spin_lock_init(&s->s_inodes_lock);
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
 		/*
 		 * The locking rules for s_lock are up to the
@@ -137,7 +125,6 @@ out:
 static inline void destroy_super(struct super_block *s)
 {
 #ifdef CONFIG_SMP
-	free_percpu(s->s_inodes);
 	free_percpu(s->s_files);
 #endif
 	security_sb_free(s);
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -795,7 +795,9 @@ xfs_setup_inode(
 
 	inode->i_ino = ip->i_ino;
 	inode->i_state = I_NEW;
-	inode_add_to_lists(ip->i_mount->m_super, inode);
+
+	inode_sb_list_add(inode);
+	insert_inode_hash(inode);
 
 	inode->i_mode	= ip->i_d.di_mode;
 	inode->i_nlink	= ip->i_d.di_nlink;
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index a87f6e7..995a3ad 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -16,7 +16,6 @@
 #include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/writeback.h>
-#include <linux/spinlock.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -55,10 +54,10 @@ struct bdi_writeback {
 
 	struct task_struct *task;	/* writeback thread */
 	struct timer_list wakeup_timer; /* used for delayed bdi thread wakeup */
-	spinlock_t b_lock;		/* lock for inode lists */
 	struct list_head b_dirty;	/* dirty inodes */
 	struct list_head b_io;		/* parked for writeback */
 	struct list_head b_more_io;	/* parked for more writeback */
+	spinlock_t b_lock;		/* writeback lists lock */
 };
 
 struct backing_dev_info {
@@ -110,6 +109,8 @@ int bdi_writeback_thread(void *data);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 void bdi_arm_supers_timer(void);
 void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi);
+void bdi_lock_two(struct backing_dev_info *bdi1,
+				struct backing_dev_info *bdi2);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
index e612575..7113a32 100644
--- a/include/linux/bit_spinlock.h
+++ b/include/linux/bit_spinlock.h
@@ -1,10 +1,6 @@
 #ifndef __LINUX_BIT_SPINLOCK_H
 #define __LINUX_BIT_SPINLOCK_H
 
-#include <linux/kernel.h>
-#include <linux/preempt.h>
-#include <asm/atomic.h>
-
 /*
  *  bit-based spin_lock()
  *
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9063486..213272b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -45,6 +45,7 @@ struct inodes_stat_t {
 	int dummy[5];		/* padding for sysctl ABI compatibility */
 };
 
+
 #define NR_FILE  8192	/* this can well be larger on a larger system */
 
 #define MAY_EXEC 1
@@ -374,8 +375,6 @@ struct inodes_stat_t {
 #include <linux/cache.h>
 #include <linux/kobject.h>
 #include <linux/list.h>
-#include <linux/rculist.h>
-#include <linux/rculist_bl.h>
 #include <linux/radix-tree.h>
 #include <linux/prio_tree.h>
 #include <linux/init.h>
@@ -384,6 +383,7 @@ struct inodes_stat_t {
 #include <linux/capability.h>
 #include <linux/semaphore.h>
 #include <linux/fiemap.h>
+#include <linux/list_bl.h>
 
 #include <asm/atomic.h>
 #include <asm/byteorder.h>
@@ -408,8 +408,7 @@ extern struct files_stat_struct files_stat;
 extern int get_max_files(void);
 extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
-extern int get_nr_inodes(void);
-extern int get_nr_inodes_unused(void);
+extern int get_nr_dirty_inodes(void);
 extern int leases_enable, lease_break_time;
 
 struct buffer_head;
@@ -727,18 +726,12 @@ struct posix_acl;
 
 struct inode {
 	struct hlist_bl_node	i_hash;
-	struct list_head	i_io;		/* backing dev IO list */
+	struct list_head	i_wb_list;	/* backing dev IO list */
 	struct list_head	i_lru;		/* inode LRU list */
 	struct list_head	i_sb_list;
-	union {
-		struct list_head	i_dentry;
-		struct rcu_head		i_rcu;
-	};
+	struct list_head	i_dentry;
 	unsigned long		i_ino;
-#ifdef CONFIG_SMP
-	int			i_sb_list_cpu;
-#endif
-	unsigned int		i_refs;
+	unsigned int		i_ref;
 	unsigned int		i_nlink;
 	uid_t			i_uid;
 	gid_t			i_gid;
@@ -797,6 +790,11 @@ struct inode {
 	void			*i_private; /* fs or device private pointer */
 };
 
+static inline int inode_unhashed(struct inode *inode)
+{
+	return hlist_bl_unhashed(&inode->i_hash);
+}
+
 /*
  * inode->i_mutex nesting subclasses for the lock validator:
  *
@@ -1349,12 +1347,12 @@ struct super_block {
 #endif
 	const struct xattr_handler **s_xattr;
 
+	spinlock_t		s_inodes_lock;	/* lock for s_inodes */
+	struct list_head	s_inodes;	/* all inodes */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 #ifdef CONFIG_SMP
-	struct list_head __percpu *s_inodes;
 	struct list_head __percpu *s_files;
 #else
-	struct list_head	s_inodes;	/* all inodes */
 	struct list_head	s_files;
 #endif
 	/* s_dentry_lru and s_nr_dentry_unused are protected by dcache_lock */
@@ -1621,7 +1619,7 @@ struct super_operations {
  *			also cause waiting on I_NEW, without I_NEW actually
  *			being set.  find_inode() uses this to prevent returning
  *			nearly-dead inodes.
- * I_WILL_FREE		Must be set when calling write_inode_now() if i_refs
+ * I_WILL_FREE		Must be set when calling write_inode_now() if i_ref
  *			is zero.  I_FREEING must be set when I_WILL_FREE is
  *			cleared.
  * I_FREEING		Set when inode is about to be freed but still has dirty
@@ -2088,8 +2086,6 @@ extern int check_disk_change(struct block_device *);
 extern int __invalidate_device(struct block_device *);
 extern int invalidate_partition(struct gendisk *, int);
 #endif
-extern void __inode_lru_list_add(struct inode *inode);
-extern void __inode_lru_list_del(struct inode *inode);
 extern int invalidate_inodes(struct super_block *);
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);
@@ -2174,7 +2170,6 @@ extern loff_t vfs_llseek(struct file *file, loff_t offset, int origin);
 
 extern int inode_init_always(struct super_block *, struct inode *);
 extern void inode_init_once(struct inode *);
-extern void inode_add_to_lists(struct super_block *, struct inode *);
 extern void iput(struct inode *);
 extern struct inode * igrab(struct inode *);
 extern ino_t iunique(struct super_block *, ino_t);
@@ -2194,74 +2189,24 @@ extern struct inode * iget_locked(struct super_block *, unsigned long);
 extern int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
 extern int insert_inode_locked(struct inode *);
 extern void unlock_new_inode(struct inode *);
-
 extern unsigned int get_next_ino(void);
+
+extern void iref(struct inode *inode);
 extern void iget_failed(struct inode *);
 extern void end_writeback(struct inode *);
 extern void destroy_inode(struct inode *);
 extern void __destroy_inode(struct inode *);
 extern struct inode *new_inode(struct super_block *);
-extern struct inode *new_anon_inode(struct super_block *);
-extern void free_inode_nonrcu(struct inode *inode);
 extern int should_remove_suid(struct dentry *);
 extern int file_remove_suid(struct file *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
 extern void remove_inode_hash(struct inode *);
-static inline void insert_inode_hash(struct inode *inode) {
+static inline void insert_inode_hash(struct inode *inode)
+{
 	__insert_inode_hash(inode, inode->i_ino);
 }
-
-#ifdef CONFIG_SMP
-/*
- * These macros iterate all inodes on all CPUs for a given superblock.
- * rcu_read_lock must be held.
- */
-#define do_inode_list_for_each_entry_rcu(__sb, __inode)		\
-{								\
-	int i;							\
-	for_each_possible_cpu(i) {				\
-		struct list_head *list;				\
-		list = per_cpu_ptr((__sb)->s_inodes, i);	\
-		list_for_each_entry_rcu((__inode), list, i_sb_list)
-
-#define while_inode_list_for_each_entry_rcu			\
-	}							\
-}
-
-#define do_inode_list_for_each_entry_safe(__sb, __inode, __tmp)	\
-{								\
-	int i;							\
-	for_each_possible_cpu(i) {				\
-		struct list_head *list;				\
-		list = per_cpu_ptr((__sb)->s_inodes, i);	\
-		list_for_each_entry_safe((__inode), (__tmp), list, i_sb_list)
-
-#define while_inode_list_for_each_entry_safe			\
-	}							\
-}
-
-#else
-
-#define do_inode_list_for_each_entry_rcu(__sb, __inode)		\
-{								\
-	struct list_head *list;					\
-	list = &(sb)->s_inodes;					\
-	list_for_each_entry_rcu((__inode), list, i_sb_list)
-
-#define while_inode_list_for_each_entry_rcu			\
-}
-
-#define do_inode_list_for_each_entry_safe(__sb, __inode, __tmp)	\
-{								\
-	struct list_head *list;					\
-	list = &(sb)->s_inodes;					\
-	list_for_each_entry_safe((__inode), (__tmp), list, i_sb_list)
-
-#define while_inode_list_for_each_entry_safe			\
-}
-
-#endif
+extern void inode_sb_list_add(struct inode *inode);
 
 #ifdef CONFIG_BLOCK
 extern void submit_bio(int, struct bio *);
@@ -2462,20 +2407,6 @@ extern int generic_show_options(struct seq_file *m, struct vfsmount *mnt);
 extern void save_mount_options(struct super_block *sb, char *options);
 extern void replace_mount_options(struct super_block *sb, char *options);
 
-static inline void inode_get_ilock(struct inode *inode)
-{
-	assert_spin_locked(&inode->i_lock);
-	BUG_ON(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE));
-	inode->i_refs++;
-}
-
-static inline void inode_get(struct inode *inode)
-{
-	spin_lock(&inode->i_lock);
-	inode_get_ilock(inode);
-	spin_unlock(&inode->i_lock);
-}
-
 static inline ino_t parent_ino(struct dentry *dentry)
 {
 	ino_t res;
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index d1849f9..e40190d 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -402,7 +402,7 @@ extern void fsnotify_clear_marks_by_group_flags(struct fsnotify_group *group, un
 extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
 extern void fsnotify_get_mark(struct fsnotify_mark *mark);
 extern void fsnotify_put_mark(struct fsnotify_mark *mark);
-extern void fsnotify_unmount_inodes(struct super_block *sb);
+extern void fsnotify_unmount_inodes(struct list_head *list);
 
 /* put here because inotify does some weird stuff when destroying watches */
 extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
@@ -443,7 +443,7 @@ static inline u32 fsnotify_get_cookie(void)
 	return 0;
 }
 
-static inline void fsnotify_unmount_inodes(struct super_block *sb)
+static inline void fsnotify_unmount_inodes(struct list_head *list)
 {}
 
 #endif	/* CONFIG_FSNOTIFY */
diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index c2034b9..5bb2370 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -36,13 +36,13 @@ struct hlist_bl_node {
 #define INIT_HLIST_BL_HEAD(ptr) \
 	((ptr)->first = NULL)
 
-static inline void INIT_HLIST_BL_NODE(struct hlist_bl_node *h)
+static inline void init_hlist_bl_node(struct hlist_bl_node *h)
 {
 	h->next = NULL;
 	h->pprev = NULL;
 }
 
-#define hlist_bl_entry(ptr, type, member) container_of(ptr,type,member)
+#define hlist_bl_entry(ptr, type, member) container_of(ptr, type, member)
 
 static inline int hlist_bl_unhashed(const struct hlist_bl_node *h)
 {
@@ -98,15 +98,15 @@ static inline void __hlist_bl_del(struct hlist_bl_node *n)
 static inline void hlist_bl_del(struct hlist_bl_node *n)
 {
 	__hlist_bl_del(n);
-	n->next = LIST_POISON1;
-	n->pprev = LIST_POISON2;
+	n->next = BL_LIST_POISON1;
+	n->pprev = BL_LIST_POISON2;
 }
 
 static inline void hlist_bl_del_init(struct hlist_bl_node *n)
 {
 	if (!hlist_bl_unhashed(n)) {
 		__hlist_bl_del(n);
-		INIT_HLIST_BL_NODE(n);
+		init_hlist_bl_node(n);
 	}
 }
 
@@ -121,21 +121,26 @@ static inline void hlist_bl_del_init(struct hlist_bl_node *n)
 #define hlist_bl_for_each_entry(tpos, pos, head, member)		\
 	for (pos = hlist_bl_first(head);				\
 	     pos &&							\
-		({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1;}); \
+		({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1; }); \
 	     pos = pos->next)
 
+#endif
+
+
 /**
- * hlist_bl_for_each_entry_safe - iterate over list of given type safe against removal of list entry
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
- * @n:		another &struct hlist_node to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the hlist_node within the struct.
+ * hlist_bl_lock	- lock a hash list
+ * @h:	hash list head to lock
  */
-#define hlist_bl_for_each_entry_safe(tpos, pos, n, head, member)	 \
-	for (pos = hlist_bl_first(head);				 \
-	     pos && ({ n = pos->next; 1; }) && 				 \
-		({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = n)
+static inline void hlist_bl_lock(struct hlist_bl_head *h)
+{
+	bit_spin_lock(0, (unsigned long *)h);
+}
 
-#endif
+/**
+ * hlist_bl_unlock	- unlock a hash list
+ * @h:	hash list head to unlock
+ */
+static inline void hlist_bl_unlock(struct hlist_bl_head *h)
+{
+	__bit_spin_unlock(0, (unsigned long *)h);
+}
diff --git a/include/linux/poison.h b/include/linux/poison.h
index 2110a81..d367d39 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -22,6 +22,8 @@
 #define LIST_POISON1  ((void *) 0x00100100 + POISON_POINTER_DELTA)
 #define LIST_POISON2  ((void *) 0x00200200 + POISON_POINTER_DELTA)
 
+#define BL_LIST_POISON1  ((void *) 0x00300300 + POISON_POINTER_DELTA)
+#define BL_LIST_POISON2  ((void *) 0x00400400 + POISON_POINTER_DELTA)
 /********** include/linux/timer.h **********/
 /*
  * Magic number "tsta" to indicate a static timer initializer
diff --git a/include/linux/rculist_bl.h b/include/linux/rculist_bl.h
deleted file mode 100644
index cdfb54e..0000000
--- a/include/linux/rculist_bl.h
+++ /dev/null
@@ -1,128 +0,0 @@
-#ifndef _LINUX_RCULIST_BL_H
-#define _LINUX_RCULIST_BL_H
-
-/*
- * RCU-protected bl list version. See include/linux/list_bl.h.
- */
-#include <linux/list_bl.h>
-#include <linux/rcupdate.h>
-#include <linux/bit_spinlock.h>
-
-static inline void hlist_bl_set_first_rcu(struct hlist_bl_head *h,
-					struct hlist_bl_node *n)
-{
-	LIST_BL_BUG_ON((unsigned long)n & LIST_BL_LOCKMASK);
-	LIST_BL_BUG_ON(!bit_spin_is_locked(0, (unsigned long *)&h->first));
-	rcu_assign_pointer(h->first,
-		(struct hlist_bl_node *)((unsigned long)n | LIST_BL_LOCKMASK));
-}
-
-static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
-{
-	return (struct hlist_bl_node *)
-		((unsigned long)rcu_dereference(h->first) & ~LIST_BL_LOCKMASK);
-}
-
-/**
- * hlist_bl_del_init_rcu - deletes entry from hash list with re-initialization
- * @n: the element to delete from the hash list.
- *
- * Note: hlist_bl_unhashed() on the node returns true after this. It is
- * useful for RCU based read lockfree traversal if the writer side
- * must know if the list entry is still hashed or already unhashed.
- *
- * In particular, it means that we can not poison the forward pointers
- * that may still be used for walking the hash list and we can only
- * zero the pprev pointer so list_unhashed() will return true after
- * this.
- *
- * The caller must take whatever precautions are necessary (such as
- * holding appropriate locks) to avoid racing with another
- * list-mutation primitive, such as hlist_bl_add_head_rcu() or
- * hlist_bl_del_rcu(), running on this same list.  However, it is
- * perfectly legal to run concurrently with the _rcu list-traversal
- * primitives, such as hlist_bl_for_each_entry_rcu().
- */
-static inline void hlist_bl_del_init_rcu(struct hlist_bl_node *n)
-{
-	if (!hlist_bl_unhashed(n)) {
-		__hlist_bl_del(n);
-		n->pprev = NULL;
-	}
-}
-
-/**
- * hlist_bl_del_rcu - deletes entry from hash list without re-initialization
- * @n: the element to delete from the hash list.
- *
- * Note: hlist_bl_unhashed() on entry does not return true after this,
- * the entry is in an undefined state. It is useful for RCU based
- * lockfree traversal.
- *
- * In particular, it means that we can not poison the forward
- * pointers that may still be used for walking the hash list.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_bl_add_head_rcu()
- * or hlist_bl_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_bl_for_each_entry().
- */
-static inline void hlist_bl_del_rcu(struct hlist_bl_node *n)
-{
-	__hlist_bl_del(n);
-	n->pprev = LIST_POISON2;
-}
-
-/**
- * hlist_bl_add_head_rcu
- * @n: the element to add to the hash list.
- * @h: the list to add to.
- *
- * Description:
- * Adds the specified element to the specified hlist_bl,
- * while permitting racing traversals.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_bl_add_head_rcu()
- * or hlist_bl_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_bl_for_each_entry_rcu(), used to prevent memory-consistency
- * problems on Alpha CPUs.  Regardless of the type of CPU, the
- * list-traversal primitive must be guarded by rcu_read_lock().
- */
-static inline void hlist_bl_add_head_rcu(struct hlist_bl_node *n,
-					struct hlist_bl_head *h)
-{
-	struct hlist_bl_node *first;
-
-	/* don't need hlist_bl_first_rcu because we're under lock */
-	first = hlist_bl_first(h);
-
-	n->next = first;
-	if (first)
-		first->pprev = &n->next;
-	n->pprev = &h->first;
-
-	/* need _rcu because we can have concurrent lock free readers */
-	hlist_bl_set_first_rcu(h, n);
-}
-/**
- * hlist_bl_for_each_entry_rcu - iterate over rcu list of given type
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_bl_node to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the hlist_bl_node within the struct.
- *
- */
-#define hlist_bl_for_each_entry_rcu(tpos, pos, head, member)		\
-	for (pos = hlist_bl_first_rcu(head);				\
-		pos &&							\
-		({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1; }); \
-		pos = rcu_dereference_raw(pos->next))
-
-#endif
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index d52ae7c..af060d4 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -74,11 +74,11 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 
 	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
 	spin_lock(&wb->b_lock);
-	list_for_each_entry(inode, &wb->b_dirty, i_io)
+	list_for_each_entry(inode, &wb->b_dirty, i_wb_list)
 		nr_dirty++;
-	list_for_each_entry(inode, &wb->b_io, i_io)
+	list_for_each_entry(inode, &wb->b_io, i_wb_list)
 		nr_io++;
-	list_for_each_entry(inode, &wb->b_more_io, i_io)
+	list_for_each_entry(inode, &wb->b_more_io, i_wb_list)
 		nr_more_io++;
 	spin_unlock(&wb->b_lock);
 
@@ -631,10 +631,10 @@ static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
 
 	wb->bdi = bdi;
 	wb->last_old_flush = jiffies;
-	spin_lock_init(&wb->b_lock);
 	INIT_LIST_HEAD(&wb->b_dirty);
 	INIT_LIST_HEAD(&wb->b_io);
 	INIT_LIST_HEAD(&wb->b_more_io);
+	spin_lock_init(&wb->b_lock);
 	setup_timer(&wb->wakeup_timer, wakeup_timer_fn, (unsigned long)bdi);
 }
 
@@ -672,7 +672,8 @@ err:
 }
 EXPORT_SYMBOL(bdi_init);
 
-static void bdi_lock_two(struct backing_dev_info *bdi1, struct backing_dev_info *bdi2)
+void bdi_lock_two(struct backing_dev_info *bdi1,
+				struct backing_dev_info *bdi2)
 {
 	if (bdi1 < bdi2) {
 		spin_lock(&bdi1->wb.b_lock);
@@ -682,6 +683,7 @@ static void bdi_lock_two(struct backing_dev_info *bdi1, struct backing_dev_info
 		spin_lock_nested(&bdi1->wb.b_lock, 1);
 	}
 }
+EXPORT_SYMBOL(bdi_lock_two);
 
 void bdi_destroy(struct backing_dev_info *bdi)
 {
@@ -695,13 +697,6 @@ void bdi_destroy(struct backing_dev_info *bdi)
 		struct bdi_writeback *dst = &default_backing_dev_info.wb;
 
 		bdi_lock_two(bdi, &default_backing_dev_info);
-		/*
-		 * It's OK to move inodes between different wb lists without
-		 * locking the individual inodes. i_lock will still protect
-		 * whether or not it is on a writeback list or not. However it
-		 * is a little quirk, maybe better to lock all inodes in this
-		 * uncommon case just to keep locking very regular.
-		 */
 		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
 		list_splice(&bdi->wb.b_io, &dst->b_io);
 		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
