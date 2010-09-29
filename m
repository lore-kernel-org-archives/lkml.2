Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0I2MTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:19:22 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:44213 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755378Ab0I2MTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:20 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/17] fs: icache atomic inodes_stat
Date: Wed, 29 Sep 2010 22:18:39 +1000
Message-Id: <1285762729-17928-8-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

The inode use statistics are currently protected by the inode_lock.
Before we can remove the inode_lock, we need to protect these
counters against races. Do this by converting them to atomic
counters so they ar enot dependent on any lock at all.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/fs-writeback.c  |    6 ++++--
 fs/inode.c         |   26 ++++++++++++++------------
 include/linux/fs.h |   13 ++++++-------
 3 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index fb7b723..f6c8975 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -764,7 +764,8 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
 	wb->last_old_flush = jiffies;
 	nr_pages = global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+			(atomic_read(&inodes_stat.nr_inodes) -
+			atomic_read(&inodes_stat.nr_unused));
 
 	if (nr_pages) {
 		struct wb_writeback_work work = {
@@ -1144,7 +1145,8 @@ void writeback_inodes_sb(struct super_block *sb)
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	work.nr_pages = nr_dirty + nr_unstable +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+			(atomic_read(&inodes_stat.nr_inodes) -
+			atomic_read(&inodes_stat.nr_unused));
 
 	bdi_queue_work(sb->s_bdi, &work);
 	wait_for_completion(&done);
diff --git a/fs/inode.c b/fs/inode.c
index e15620f..6d982e6 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -122,7 +122,10 @@ static DECLARE_RWSEM(iprune_sem);
 /*
  * Statistics gathering..
  */
-struct inodes_stat_t inodes_stat;
+struct inodes_stat_t inodes_stat = {
+	.nr_inodes = ATOMIC_INIT(0),
+	.nr_unused = ATOMIC_INIT(0),
+};
 
 static struct kmem_cache *inode_cachep __read_mostly;
 
@@ -313,7 +316,7 @@ void __iget(struct inode *inode)
 		list_move(&inode->i_list, &inode_in_use);
 		spin_unlock(&wb_inode_list_lock);
 	}
-	inodes_stat.nr_unused--;
+	atomic_dec(&inodes_stat.nr_unused);
 }
 
 void end_writeback(struct inode *inode)
@@ -377,9 +380,7 @@ static void dispose_list(struct list_head *head)
 		destroy_inode(inode);
 		nr_disposed++;
 	}
-	spin_lock(&inode_lock);
-	inodes_stat.nr_inodes -= nr_disposed;
-	spin_unlock(&inode_lock);
+	atomic_sub(nr_disposed, &inodes_stat.nr_inodes);
 }
 
 /*
@@ -428,7 +429,7 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
 		busy = 1;
 	}
 	/* only unused inodes may be cached with i_count zero */
-	inodes_stat.nr_unused -= count;
+	atomic_sub(count, &inodes_stat.nr_unused);
 	return busy;
 }
 
@@ -545,7 +546,7 @@ again2:
 		spin_unlock(&inode->i_lock);
 		nr_pruned++;
 	}
-	inodes_stat.nr_unused -= nr_pruned;
+	atomic_sub(nr_pruned, &inodes_stat.nr_unused);
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
@@ -578,7 +579,8 @@ static int shrink_icache_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
 			return -1;
 		prune_icache(nr);
 	}
-	return (inodes_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
+	return (atomic_read(&inodes_stat.nr_unused) / 100) *
+					sysctl_vfs_cache_pressure;
 }
 
 static struct shrinker icache_shrinker = {
@@ -671,7 +673,7 @@ static inline void
 __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
 			struct inode *inode)
 {
-	inodes_stat.nr_inodes++;
+	atomic_inc(&inodes_stat.nr_inodes);
 	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
@@ -1336,7 +1338,7 @@ static void iput_final(struct inode *inode)
 			list_move(&inode->i_list, &inode_unused);
 			spin_unlock(&wb_inode_list_lock);
 		}
-		inodes_stat.nr_unused++;
+		atomic_inc(&inodes_stat.nr_unused);
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&sb_inode_list_lock);
@@ -1354,7 +1356,7 @@ static void iput_final(struct inode *inode)
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		inodes_stat.nr_unused--;
+		atomic_dec(&inodes_stat.nr_unused);
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
@@ -1366,9 +1368,9 @@ static void iput_final(struct inode *inode)
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
-	inodes_stat.nr_inodes--;
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
+	atomic_dec(&inodes_stat.nr_inodes);
 	evict(inode);
 	spin_lock(&inode_lock);
 	spin_lock(&inode_hash_lock);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 415c88e..d60f256 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -39,13 +39,6 @@ struct files_stat_struct {
 	int max_files;		/* tunable */
 };
 
-struct inodes_stat_t {
-	int nr_inodes;
-	int nr_unused;
-	int dummy[5];		/* padding for sysctl ABI compatibility */
-};
-
-
 #define NR_FILE  8192	/* this can well be larger on a larger system */
 
 #define MAY_EXEC 1
@@ -416,6 +409,12 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 			ssize_t bytes, void *private, int ret,
 			bool is_async);
 
+struct inodes_stat_t {
+	atomic_t nr_inodes;
+	atomic_t nr_unused;
+	int dummy[5];		/* padding for sysctl ABI compatibility */
+};
+
 /*
  * Attribute flags.  These should be or-ed together to figure out what
  * has been changed!
-- 
1.7.1

