Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab0JHFX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:23:56 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:40794 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752750Ab0JHFWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:22:15 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/18] fs: split locking of inode writeback and LRU lists
Date: Fri,  8 Oct 2010 16:21:27 +1100
Message-Id: <1286515292-15882-14-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286515292-15882-1-git-send-email-david@fromorbit.com>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that the inode LRU and IO lists are split apart, we can separate
the locking for them. The IO lists are only ever accessed in the
context of writeback, so a per-BDI lock for those lists separates
them out nicely.

For the inode LRU, introduce a simple global lock to protect it.
While this could be made per-sb, it is unclear yet as to what is the
next steps for optimising/parallelising reclaim of inodes. Rather
than optimise now, leave it as a global list and lock until further
analysis canbe done.

Based on a patch originally from Nick Piggin.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/fs-writeback.c           |   48 +++++++++++++-------
 fs/inode.c                  |  101 ++++++++++++++++++++++++++++++++++--------
 fs/internal.h               |    6 +++
 fs/super.c                  |    2 +-
 include/linux/backing-dev.h |    1 +
 include/linux/writeback.h   |   12 ++++-
 mm/backing-dev.c            |   21 +++++++++
 7 files changed, 150 insertions(+), 41 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 29f8032..49d44cc 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -69,16 +69,6 @@ int writeback_in_progress(struct backing_dev_info *bdi)
 	return test_bit(BDI_writeback_running, &bdi->state);
 }
 
-static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
-{
-	struct super_block *sb = inode->i_sb;
-
-	if (strcmp(sb->s_type->name, "bdev") == 0)
-		return inode->i_mapping->a_bdi;
-
-	return sb->s_bdi;
-}
-
 static void bdi_queue_work(struct backing_dev_info *bdi,
 		struct wb_writeback_work *work)
 {
@@ -169,6 +159,7 @@ static void redirty_tail(struct inode *inode)
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
+	assert_spin_locked(&wb->b_lock);
 	if (!list_empty(&wb->b_dirty)) {
 		struct inode *tail;
 
@@ -186,6 +177,7 @@ static void requeue_io(struct inode *inode)
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
+	assert_spin_locked(&wb->b_lock);
 	list_move(&inode->i_io, &wb->b_more_io);
 }
 
@@ -268,6 +260,7 @@ static void move_expired_inodes(struct list_head *delaying_queue,
  */
 static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
 {
+	assert_spin_locked(&wb->b_lock);
 	list_splice_init(&wb->b_more_io, &wb->b_io);
 	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
 }
@@ -311,6 +304,7 @@ static void inode_wait_for_writeback(struct inode *inode)
 static int
 writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 {
+	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	struct address_space *mapping = inode->i_mapping;
 	unsigned dirty;
 	int ret;
@@ -330,7 +324,9 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 		 * completed a full scan of b_io.
 		 */
 		if (wbc->sync_mode != WB_SYNC_ALL) {
+			spin_lock(&bdi->wb.b_lock);
 			requeue_io(inode);
+			spin_unlock(&bdi->wb.b_lock);
 			return 0;
 		}
 
@@ -385,6 +381,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			 * sometimes bales out without doing anything.
 			 */
 			inode->i_state |= I_DIRTY_PAGES;
+			spin_lock(&bdi->wb.b_lock);
 			if (wbc->nr_to_write <= 0) {
 				/*
 				 * slice used up: queue for next turn
@@ -400,6 +397,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 				 */
 				redirty_tail(inode);
 			}
+			spin_unlock(&bdi->wb.b_lock);
 		} else if (inode->i_state & I_DIRTY) {
 			/*
 			 * Filesystems can dirty the inode during writeback
@@ -407,14 +405,15 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			 * submission or metadata updates after data IO
 			 * completion.
 			 */
+			spin_lock(&bdi->wb.b_lock);
 			redirty_tail(inode);
+			spin_unlock(&bdi->wb.b_lock);
 		} else {
 			/* The inode is clean */
+			spin_lock(&bdi->wb.b_lock);
 			list_del_init(&inode->i_io);
-			if (list_empty(&inode->i_lru)) {
-				list_add(&inode->i_lru, &inode_unused);
-				percpu_counter_inc(&nr_inodes_unused);
-			}
+			spin_unlock(&bdi->wb.b_lock);
+			inode_lru_list_add(inode);
 		}
 	}
 	inode_sync_complete(inode);
@@ -460,6 +459,7 @@ static bool pin_sb_for_writeback(struct super_block *sb)
 static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 		struct writeback_control *wbc, bool only_this_sb)
 {
+	assert_spin_locked(&wb->b_lock);
 	while (!list_empty(&wb->b_io)) {
 		long pages_skipped;
 		struct inode *inode = list_entry(wb->b_io.prev,
@@ -475,7 +475,6 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 				redirty_tail(inode);
 				continue;
 			}
-
 			/*
 			 * The inode belongs to a different superblock.
 			 * Bounce back to the caller to unpin this and
@@ -484,7 +483,7 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 			return 0;
 		}
 
-		if (inode->i_state & (I_NEW | I_WILL_FREE)) {
+		if (inode->i_state & (I_NEW | I_WILL_FREE | I_FREEING)) {
 			requeue_io(inode);
 			continue;
 		}
@@ -495,8 +494,11 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 		if (inode_dirtied_after(inode, wbc->wb_start))
 			return 1;
 
-		BUG_ON(inode->i_state & I_FREEING);
+		spin_lock(&inode->i_lock);
 		iref_locked(inode);
+		spin_unlock(&inode->i_lock);
+		spin_unlock(&wb->b_lock);
+
 		pages_skipped = wbc->pages_skipped;
 		writeback_single_inode(inode, wbc);
 		if (wbc->pages_skipped != pages_skipped) {
@@ -504,12 +506,15 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 			 * writeback is not making progress due to locked
 			 * buffers.  Skip this inode for now.
 			 */
+			spin_lock(&wb->b_lock);
 			redirty_tail(inode);
+			spin_unlock(&wb->b_lock);
 		}
 		spin_unlock(&inode_lock);
 		iput(inode);
 		cond_resched();
 		spin_lock(&inode_lock);
+		spin_lock(&wb->b_lock);
 		if (wbc->nr_to_write <= 0) {
 			wbc->more_io = 1;
 			return 1;
@@ -529,6 +534,8 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
 	if (!wbc->wb_start)
 		wbc->wb_start = jiffies; /* livelock avoidance */
 	spin_lock(&inode_lock);
+	spin_lock(&wb->b_lock);
+
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 
@@ -547,6 +554,7 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
 		if (ret)
 			break;
 	}
+	spin_unlock(&wb->b_lock);
 	spin_unlock(&inode_lock);
 	/* Leave any unwritten inodes on b_io */
 }
@@ -557,9 +565,11 @@ static void __writeback_inodes_sb(struct super_block *sb,
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	spin_lock(&inode_lock);
+	spin_lock(&wb->b_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 	writeback_sb_inodes(sb, wb, wbc, true);
+	spin_unlock(&wb->b_lock);
 	spin_unlock(&inode_lock);
 }
 
@@ -672,8 +682,10 @@ static long wb_writeback(struct bdi_writeback *wb,
 		 */
 		spin_lock(&inode_lock);
 		if (!list_empty(&wb->b_more_io))  {
+			spin_lock(&wb->b_lock);
 			inode = list_entry(wb->b_more_io.prev,
 						struct inode, i_io);
+			spin_unlock(&wb->b_lock);
 			trace_wbc_writeback_wait(&wbc, wb->bdi);
 			inode_wait_for_writeback(inode);
 		}
@@ -986,8 +998,10 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 					wakeup_bdi = true;
 			}
 
+			spin_lock(&bdi->wb.b_lock);
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_io, &bdi->wb.b_dirty);
+			spin_unlock(&bdi->wb.b_lock);
 		}
 	}
 out:
diff --git a/fs/inode.c b/fs/inode.c
index e6bb36d..4ad7900 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -35,6 +35,10 @@
  *   inode hash table, i_hash
  * sb inode lock protects:
  *   s_inodes, i_sb_list
+ * bdi writeback lock protects:
+ *   b_io, b_more_io, b_dirty, i_io
+ * inode_lru_lock protects:
+ *   inode_lru, i_lru
  *
  * Lock orders
  * inode_lock
@@ -43,7 +47,9 @@
  *
  * inode_lock
  *   sb inode lock
- *     inode->i_lock
+ *     inode_lru_lock
+ *       wb->b_lock
+ *         inode->i_lock
  */
 /*
  * This is needed for the following functions:
@@ -92,7 +98,8 @@ static unsigned int i_hash_shift __read_mostly;
  * allowing for low-overhead inode sync() operations.
  */
 
-LIST_HEAD(inode_unused);
+static LIST_HEAD(inode_lru);
+static DEFINE_SPINLOCK(inode_lru_lock);
 
 struct inode_hash_bucket {
 	struct hlist_bl_head head;
@@ -383,6 +390,30 @@ int iref_read(struct inode *inode)
 }
 EXPORT_SYMBOL_GPL(iref_read);
 
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
 static unsigned long hash(struct super_block *sb, unsigned long hashval)
 {
 	unsigned long tmp;
@@ -535,11 +566,26 @@ static int invalidate_list(struct super_block *sb, struct list_head *head,
 		invalidate_inode_buffers(inode);
 		spin_lock(&inode->i_lock);
 		if (!inode->i_ref) {
+			struct backing_dev_info *bdi = inode_to_bdi(inode);
+
 			spin_unlock(&inode->i_lock);
-			list_move(&inode->i_lru, dispose);
-			list_del_init(&inode->i_io);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
+
+
+			/*
+			 * move the inode off the IO lists and LRU once
+			 * I_FREEING is set so that it won't get moved back on
+			 * there if it is dirty.
+			 */
+			spin_lock(&bdi->wb.b_lock);
+			list_del_init(&inode->i_io);
+			spin_unlock(&bdi->wb.b_lock);
+
+			spin_lock(&inode_lru_lock);
+			list_move(&inode->i_lru, dispose);
+			spin_unlock(&inode_lru_lock);
+
 			percpu_counter_dec(&nr_inodes_unused);
 			continue;
 		}
@@ -596,7 +642,7 @@ static int can_unuse(struct inode *inode)
  *
  * Any inodes which are pinned purely because of attached pagecache have their
  * pagecache removed.  We expect the final iput() on that inode to add it to
- * the front of the inode_unused list.  So look for it there and if the
+ * the front of the inode_lru list.  So look for it there and if the
  * inode is still freeable, proceed.  The right inode is found 99.9% of the
  * time in testing on a 4-way.
  *
@@ -611,13 +657,15 @@ static void prune_icache(int nr_to_scan)
 
 	down_read(&iprune_sem);
 	spin_lock(&inode_lock);
+	spin_lock(&inode_lru_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
 		struct inode *inode;
+		struct backing_dev_info *bdi;
 
-		if (list_empty(&inode_unused))
+		if (list_empty(&inode_lru))
 			break;
 
-		inode = list_entry(inode_unused.prev, struct inode, i_lru);
+		inode = list_entry(inode_lru.prev, struct inode, i_lru);
 
 		spin_lock(&inode->i_lock);
 		if (inode->i_ref || (inode->i_state & ~I_REFERENCED)) {
@@ -628,19 +676,21 @@ static void prune_icache(int nr_to_scan)
 		}
 		if (inode->i_state & I_REFERENCED) {
 			spin_unlock(&inode->i_lock);
-			list_move(&inode->i_lru, &inode_unused);
+			list_move(&inode->i_lru, &inode_lru);
 			inode->i_state &= ~I_REFERENCED;
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
 			iref_locked(inode);
 			spin_unlock(&inode->i_lock);
+			spin_unlock(&inode_lru_lock);
 			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
 								0, -1);
 			iput(inode);
 			spin_lock(&inode_lock);
+			spin_lock(&inode_lru_lock);
 
 			/*
 			 * if we can't reclaim this inod immediately, give it
@@ -648,21 +698,32 @@ static void prune_icache(int nr_to_scan)
 			 * on it.
 			 */
 			if (!can_unuse(inode)) {
-				list_move(&inode->i_lru, &inode_unused);
+				list_move(&inode->i_lru, &inode_lru);
 				continue;
 			}
 		} else
 			spin_unlock(&inode->i_lock);
-		list_move(&inode->i_lru, &freeable);
-		list_del_init(&inode->i_io);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
+
+		/*
+		 * move the inode off the IO lists and LRU once
+		 * I_FREEING is set so that it won't get moved back on
+		 * there if it is dirty.
+		 */
+		bdi = inode_to_bdi(inode);
+		spin_lock(&bdi->wb.b_lock);
+		list_del_init(&inode->i_io);
+		spin_unlock(&bdi->wb.b_lock);
+
+		list_move(&inode->i_lru, &freeable);
 		percpu_counter_dec(&nr_inodes_unused);
 	}
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
 		__count_vm_events(PGINODESTEAL, reap);
+	spin_unlock(&inode_lru_lock);
 	spin_unlock(&inode_lock);
 
 	dispose_list(&freeable);
@@ -1369,6 +1430,7 @@ static void iput_final(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 	const struct super_operations *op = inode->i_sb->s_op;
+	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	int drop;
 
 	if (op && op->drop_inode)
@@ -1381,8 +1443,7 @@ static void iput_final(struct inode *inode)
 			inode->i_state |= I_REFERENCED;
 			if (!(inode->i_state & (I_DIRTY|I_SYNC)) &&
 			    list_empty(&inode->i_lru)) {
-				list_add(&inode->i_lru, &inode_unused);
-				percpu_counter_inc(&nr_inodes_unused);
+				inode_lru_list_add(inode);
 			}
 			spin_unlock(&inode_lock);
 			return;
@@ -1396,19 +1457,19 @@ static void iput_final(struct inode *inode)
 		inode->i_state &= ~I_WILL_FREE;
 		__remove_inode_hash(inode);
 	}
-	list_del_init(&inode->i_io);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 
 	/*
-	 * We avoid moving dirty inodes back onto the LRU now because I_FREEING
-	 * is set and hence writeback_single_inode() won't move the inode
+	 * move the inode off the IO lists and LRU once I_FREEING is set so
+	 * that it won't get moved back on there if it is dirty.
 	 * around.
 	 */
-	if (!list_empty(&inode->i_lru)) {
-		list_del_init(&inode->i_lru);
-		percpu_counter_dec(&nr_inodes_unused);
-	}
+	spin_lock(&bdi->wb.b_lock);
+	list_del_init(&inode->i_io);
+	spin_unlock(&bdi->wb.b_lock);
+
+	inode_lru_list_del(inode);
 
 	spin_lock(&sb->s_inodes_lock);
 	list_del_init(&inode->i_sb_list);
diff --git a/fs/internal.h b/fs/internal.h
index a6910e9..ece3565 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -101,3 +101,9 @@ extern void put_super(struct super_block *sb);
 struct nameidata;
 extern struct file *nameidata_to_filp(struct nameidata *);
 extern void release_open_intent(struct nameidata *);
+
+/*
+ * inode.c
+ */
+extern void inode_lru_list_add(struct inode *inode);
+extern void inode_lru_list_del(struct inode *inode);
diff --git a/fs/super.c b/fs/super.c
index d826214..c5332e5 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -76,7 +76,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		INIT_LIST_HEAD(&s->s_dentry_lru);
 		init_rwsem(&s->s_umount);
 		mutex_init(&s->s_lock);
-		spin_lock_init(&(s->s_inodes_lock);
+		spin_lock_init(&s->s_inodes_lock);
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
 		/*
 		 * The locking rules for s_lock are up to the
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 31e1346..5106fc4 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -57,6 +57,7 @@ struct bdi_writeback {
 	struct list_head b_dirty;	/* dirty inodes */
 	struct list_head b_io;		/* parked for writeback */
 	struct list_head b_more_io;	/* parked for more writeback */
+	spinlock_t b_lock;		/* writeback lists lock */
 };
 
 struct backing_dev_info {
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index f7ed2a0..b182ccc 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -10,10 +10,7 @@
 struct backing_dev_info;
 
 extern spinlock_t inode_lock;
-extern struct list_head inode_unused;
 
-extern struct percpu_counter nr_inodes;
-extern struct percpu_counter nr_inodes_unused;
 
 /*
  * fs/fs-writeback.c
@@ -82,6 +79,15 @@ static inline void inode_sync_wait(struct inode *inode)
 							TASK_UNINTERRUPTIBLE);
 }
 
+static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+
+	if (strcmp(sb->s_type->name, "bdev") == 0)
+		return inode->i_mapping->a_bdi;
+
+	return sb->s_bdi;
+}
 
 /*
  * mm/page-writeback.c
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index a124991..74e8269 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -74,12 +74,14 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 
 	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
 	spin_lock(&inode_lock);
+	spin_lock(&wb->b_lock);
 	list_for_each_entry(inode, &wb->b_dirty, i_io)
 		nr_dirty++;
 	list_for_each_entry(inode, &wb->b_io, i_io)
 		nr_io++;
 	list_for_each_entry(inode, &wb->b_more_io, i_io)
 		nr_more_io++;
+	spin_unlock(&wb->b_lock);
 	spin_unlock(&inode_lock);
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
@@ -634,6 +636,7 @@ static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
 	INIT_LIST_HEAD(&wb->b_dirty);
 	INIT_LIST_HEAD(&wb->b_io);
 	INIT_LIST_HEAD(&wb->b_more_io);
+	spin_lock_init(&wb->b_lock);
 	setup_timer(&wb->wakeup_timer, wakeup_timer_fn, (unsigned long)bdi);
 }
 
@@ -671,6 +674,18 @@ err:
 }
 EXPORT_SYMBOL(bdi_init);
 
+static void bdi_lock_two(struct backing_dev_info *bdi1,
+				struct backing_dev_info *bdi2)
+{
+	if (bdi1 < bdi2) {
+		spin_lock(&bdi1->wb.b_lock);
+		spin_lock_nested(&bdi2->wb.b_lock, 1);
+	} else {
+		spin_lock(&bdi2->wb.b_lock);
+		spin_lock_nested(&bdi1->wb.b_lock, 1);
+	}
+}
+
 void mapping_set_bdi(struct address_space *mapping,
 				struct backing_dev_info *bdi)
 {
@@ -681,6 +696,7 @@ void mapping_set_bdi(struct address_space *mapping,
 		return;
 
 	spin_lock(&inode_lock);
+	bdi_lock_two(bdi, old);
 	if (!list_empty(&inode->i_io)) {
 		struct inode *i;
 
@@ -709,6 +725,8 @@ void mapping_set_bdi(struct address_space *mapping,
 	}
 found:
 	mapping->a_bdi = bdi;
+	spin_unlock(&bdi->wb.b_lock);
+	spin_unlock(&old->wb.b_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(mapping_set_bdi);
@@ -726,6 +744,7 @@ void bdi_destroy(struct backing_dev_info *bdi)
 		struct inode *i, *tmp;
 
 		spin_lock(&inode_lock);
+		bdi_lock_two(bdi, &default_backing_dev_info);
 		list_for_each_entry_safe(i, tmp, &bdi->wb.b_dirty, i_io) {
 			list_del(&i->i_io);
 			list_add_tail(&i->i_io, &dst->b_dirty);
@@ -741,6 +760,8 @@ void bdi_destroy(struct backing_dev_info *bdi)
 			list_add_tail(&i->i_io, &dst->b_more_io);
 			i->i_mapping->a_bdi = bdi;
 		}
+		spin_unlock(&bdi->wb.b_lock);
+		spin_unlock(&dst->b_lock);
 		spin_unlock(&inode_lock);
 	}
 
-- 
1.7.1

