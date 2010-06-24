Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab0FXDQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:48459 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab0FXDPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:50 -0400
Message-Id: <20100624030732.254378018@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:53 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 41/52] fs: icache reduce atomics
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode-nr_inodes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put inode counters under locks to reduce atomics.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/fs-writeback.c  |    6 ++----
 fs/inode.c         |   30 ++++++++++++------------------
 include/linux/fs.h |    4 ++--
 3 files changed, 16 insertions(+), 24 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -141,8 +141,8 @@ static DECLARE_RWSEM(iprune_sem);
  * Statistics gathering..
  */
 struct inodes_stat_t inodes_stat = {
-	.nr_inodes = ATOMIC_INIT(0),
-	.nr_unused = ATOMIC_INIT(0),
+	.nr_inodes = 0,
+	.nr_unused = 0,
 };
 
 static struct kmem_cache *inode_cachep __read_mostly;
@@ -390,7 +390,6 @@ static void dispose_list(struct list_hea
 		destroy_inode(inode);
 		nr_disposed++;
 	}
-	atomic_sub(nr_disposed, &inodes_stat.nr_inodes);
 }
 
 /*
@@ -399,7 +398,7 @@ static void dispose_list(struct list_hea
 static int invalidate_list(struct list_head *head, struct list_head *dispose)
 {
 	struct list_head *next;
-	int busy = 0, count = 0;
+	int busy = 0;
 
 	next = head->next;
 	for (;;) {
@@ -419,19 +418,17 @@ static int invalidate_list(struct list_h
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
 
@@ -483,7 +480,6 @@ EXPORT_SYMBOL(invalidate_inodes);
 static void prune_icache(int nr_to_scan)
 {
 	LIST_HEAD(freeable);
-	int nr_pruned = 0;
 	unsigned long reap = 0;
 
 	down_read(&iprune_sem);
@@ -504,7 +500,7 @@ again:
 		if (inode->i_count || (inode->i_state & ~I_REFERENCED)) {
 			list_del_init(&inode->i_list);
 			spin_unlock(&inode->i_lock);
-			atomic_dec(&inodes_stat.nr_unused);
+			inodes_stat.nr_unused--;
 			continue;
 		}
 		if (inode->i_state) {
@@ -530,9 +526,8 @@ again:
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
@@ -564,8 +559,7 @@ static int shrink_icache_memory(int nr,
 			return -1;
 		prune_icache(nr);
 	}
-	return (atomic_read(&inodes_stat.nr_unused) / 100) *
-					sysctl_vfs_cache_pressure;
+	return inodes_stat.nr_unused / 100 * sysctl_vfs_cache_pressure;
 }
 
 static struct shrinker icache_shrinker = {
@@ -661,9 +655,9 @@ static inline void
 __inode_add_to_lists(struct super_block *sb, struct inode_hash_bucket *b,
 			struct inode *inode)
 {
-	atomic_inc(&inodes_stat.nr_inodes);
 	spin_lock(&sb_inode_list_lock);
 	list_add_rcu(&inode->i_sb_list, &sb->s_inodes);
+	inodes_stat.nr_inodes++;
 	spin_unlock(&sb_inode_list_lock);
 	if (b) {
 		spin_lock_bucket(b);
@@ -1309,17 +1303,17 @@ void generic_delete_inode(struct inode *
 	if (!list_empty(&inode->i_list)) {
 		spin_lock(&wb_inode_list_lock);
 		list_del_init(&inode->i_list);
-		spin_unlock(&wb_inode_list_lock);
 		if (!inode->i_state)
-			atomic_dec(&inodes_stat.nr_unused);
+			inodes_stat.nr_unused--;
+		spin_unlock(&wb_inode_list_lock);
 	}
 	spin_lock(&sb_inode_list_lock);
 	list_del_rcu(&inode->i_sb_list);
+	inodes_stat.nr_inodes--;
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
-	atomic_dec(&inodes_stat.nr_inodes);
 
 	if (op->delete_inode) {
 		void (*delete)(struct inode *) = op->delete_inode;
@@ -1367,8 +1361,8 @@ int generic_detach_inode(struct inode *i
 					list_empty(&inode->i_list)) {
 				spin_lock(&wb_inode_list_lock);
 				list_add(&inode->i_list, &inode_unused);
+				inodes_stat.nr_unused++;
 				spin_unlock(&wb_inode_list_lock);
-				atomic_inc(&inodes_stat.nr_unused);
 			}
 			spin_unlock(&inode->i_lock);
 			return 0;
@@ -1385,17 +1379,17 @@ int generic_detach_inode(struct inode *i
 	if (!list_empty(&inode->i_list)) {
 		spin_lock(&wb_inode_list_lock);
 		list_del_init(&inode->i_list);
-		spin_unlock(&wb_inode_list_lock);
 		if (!inode->i_state)
-			atomic_dec(&inodes_stat.nr_unused);
+			inodes_stat.nr_unused--;
+		spin_unlock(&wb_inode_list_lock);
 	}
 	spin_lock(&sb_inode_list_lock);
 	list_del_rcu(&inode->i_sb_list);
+	inodes_stat.nr_inodes--;
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
-	atomic_dec(&inodes_stat.nr_inodes);
 	return 1;
 }
 EXPORT_SYMBOL_GPL(generic_detach_inode);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -31,6 +31,12 @@
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
@@ -411,12 +417,6 @@ typedef int (get_block_t)(struct inode *
 typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 			ssize_t bytes, void *private);
 
-struct inodes_stat_t {
-	atomic_t nr_inodes;
-	atomic_t nr_unused;
-	int dummy[5];		/* padding for sysctl ABI compatibility */
-};
-
 /*
  * Attribute flags.  These should be or-ed together to figure out what
  * has been changed!
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -904,8 +904,7 @@ static long wb_check_old_data_flush(stru
 	wb->last_old_flush = jiffies;
 	nr_pages = global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) +
-			(atomic_read(&inodes_stat.nr_inodes) -
-			atomic_read(&inodes_stat.nr_unused));
+			inodes_stat.nr_inodes - inodes_stat.nr_unused;
 
 	if (nr_pages) {
 		struct wb_writeback_args args = {
@@ -1258,8 +1257,7 @@ void writeback_inodes_sb(struct super_bl
 	long nr_to_write;
 
 	nr_to_write = nr_dirty + nr_unstable +
-			(atomic_read(&inodes_stat.nr_inodes) -
-			atomic_read(&inodes_stat.nr_unused));
+			inodes_stat.nr_inodes - inodes_stat.nr_unused;
 
 	bdi_start_writeback(sb->s_bdi, sb, nr_to_write);
 }


