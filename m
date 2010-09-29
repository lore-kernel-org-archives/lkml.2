Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab0I2MUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:20:49 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:57265 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755646Ab0I2MTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:31 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/17] fs: Inode counters do not need to be atomic.
Date: Wed, 29 Sep 2010 22:18:46 +1000
Message-Id: <1285762729-17928-15-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

atomics for counters do not scale on large machines, so convert them
back to normal variables protected by spin locks. We can do this
because the counters are associated with specific list operations
that are protected by locks; nr_inodes can be protected by the
sb_inode_list_lock, and nr_unused can be protected by the
wb_inode_list_lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/fs-writeback.c  |    6 ++----
 fs/inode.c         |   30 ++++++++++++------------------
 include/linux/fs.h |   12 ++++++------
 3 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 432a4df..8e390e8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -743,8 +743,7 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
 	wb->last_old_flush = jiffies;
 	nr_pages = global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) +
-			(atomic_read(&inodes_stat.nr_inodes) -
-			atomic_read(&inodes_stat.nr_unused));
+			inodes_stat.nr_inodes - inodes_stat.nr_unused;
 
 	if (nr_pages) {
 		struct wb_writeback_work work = {
@@ -1116,8 +1115,7 @@ void writeback_inodes_sb(struct super_block *sb)
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	work.nr_pages = nr_dirty + nr_unstable +
-			(atomic_read(&inodes_stat.nr_inodes) -
-			atomic_read(&inodes_stat.nr_unused));
+			inodes_stat.nr_inodes - inodes_stat.nr_unused;
 
 	bdi_queue_work(sb->s_bdi, &work);
 	wait_for_completion(&done);
diff --git a/fs/inode.c b/fs/inode.c
index 50599d7..d279517 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -139,8 +139,8 @@ static DECLARE_RWSEM(iprune_sem);
  * Statistics gathering..
  */
 struct inodes_stat_t inodes_stat = {
-	.nr_inodes = ATOMIC_INIT(0),
-	.nr_unused = ATOMIC_INIT(0),
+	.nr_inodes = 0,
+	.nr_unused = 0,
 };
 
 static struct kmem_cache *inode_cachep __read_mostly;
@@ -376,7 +376,6 @@ static void dispose_list(struct list_head *head)
 		destroy_inode(inode);
 		nr_disposed++;
 	}
-	atomic_sub(nr_disposed, &inodes_stat.nr_inodes);
 }
 
 /*
@@ -385,7 +384,7 @@ static void dispose_list(struct list_head *head)
 static int invalidate_list(struct list_head *head, struct list_head *dispose)
 {
 	struct list_head *next;
-	int busy = 0, count = 0;
+	int busy = 0;
 
 	next = head->next;
 	for (;;) {
@@ -413,19 +412,17 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
 		if (!inode->i_count) {
 			spin_lock(&wb_inode_list_lock);
 			list_del(&inode->i_list);
+			inodes_stat.nr_unused--;
 			spin_unlock(&wb_inode_list_lock);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			spin_unlock(&inode->i_lock);
 			list_add(&inode->i_list, dispose);
-			count++;
 			continue;
 		}
 		spin_unlock(&inode->i_lock);
 		busy = 1;
 	}
-	/* only unused inodes may be cached with i_count zero */
-	atomic_sub(count, &inodes_stat.nr_unused);
 	return busy;
 }
 
@@ -471,7 +468,6 @@ EXPORT_SYMBOL(invalidate_inodes);
 static void prune_icache(int nr_to_scan)
 {
 	LIST_HEAD(freeable);
-	int nr_pruned = 0;
 	unsigned long reap = 0;
 
 	down_read(&iprune_sem);
@@ -492,7 +488,7 @@ again:
 		if (inode->i_count || (inode->i_state & ~I_REFERENCED)) {
 			list_del_init(&inode->i_list);
 			spin_unlock(&inode->i_lock);
-			atomic_dec(&inodes_stat.nr_unused);
+			inodes_stat.nr_unused--;
 			continue;
 		}
 		if (inode->i_state) {
@@ -518,9 +514,8 @@ again:
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
 		spin_unlock(&inode->i_lock);
-		nr_pruned++;
+		inodes_stat.nr_unused--;
 	}
-	atomic_sub(nr_pruned, &inodes_stat.nr_unused);
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
@@ -552,8 +547,7 @@ static int shrink_icache_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
 			return -1;
 		prune_icache(nr);
 	}
-	return (atomic_read(&inodes_stat.nr_unused) / 100) *
-					sysctl_vfs_cache_pressure;
+	return (inodes_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
 }
 
 static struct shrinker icache_shrinker = {
@@ -649,7 +643,7 @@ static inline void
 __inode_add_to_lists(struct super_block *sb, struct inode_hash_bucket *b,
 			struct inode *inode)
 {
-	atomic_inc(&inodes_stat.nr_inodes);
+	inodes_stat.nr_inodes++;
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
 	if (b) {
@@ -1325,9 +1319,9 @@ static void iput_final(struct inode *inode)
 		if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
 			spin_lock(&wb_inode_list_lock);
 			list_move(&inode->i_list, &inode_unused);
+			inodes_stat.nr_unused++;
 			spin_unlock(&wb_inode_list_lock);
 		}
-		atomic_inc(&inodes_stat.nr_unused);
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&sb_inode_list_lock);
@@ -1347,16 +1341,16 @@ static void iput_final(struct inode *inode)
 	if (!list_empty(&inode->i_list)) {
 		spin_lock(&wb_inode_list_lock);
 		list_del_init(&inode->i_list);
-		spin_unlock(&wb_inode_list_lock);
 		if (!inode->i_state)
-			atomic_dec(&inodes_stat.nr_unused);
+			inodes_stat.nr_unused--;
+		spin_unlock(&wb_inode_list_lock);
 	}
 	list_del_init(&inode->i_sb_list);
+	inodes_stat.nr_inodes--;
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
-	atomic_dec(&inodes_stat.nr_inodes);
 	evict(inode);
 
 	/*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 096a5eb..3a43313 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -32,6 +32,12 @@
 #define SEEK_END	2	/* seek relative to end of file */
 #define SEEK_MAX	SEEK_END
 
+struct inodes_stat_t {
+	int nr_inodes;
+	int nr_unused;
+	int dummy[5];		/* padding for sysctl ABI compatibility */
+};
+
 /* And dynamically-tunable limits and defaults: */
 struct files_stat_struct {
 	int nr_files;		/* read only */
@@ -410,12 +416,6 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 			ssize_t bytes, void *private, int ret,
 			bool is_async);
 
-struct inodes_stat_t {
-	atomic_t nr_inodes;
-	atomic_t nr_unused;
-	int dummy[5];		/* padding for sysctl ABI compatibility */
-};
-
 /*
  * Attribute flags.  These should be or-ed together to figure out what
  * has been changed!
-- 
1.7.1

