Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab0JRGVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 02:21:31 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:44745 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751299Ab0JRGV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 02:21:29 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/20] fs: Convert nr_inodes and nr_unused to per-cpu counters
Date: Mon, 18 Oct 2010 17:20:39 +1100
Message-Id: <1287382856-29529-4-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287382856-29529-1-git-send-email-david@fromorbit.com>
References: <1287382856-29529-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The number of inodes allocated does not need to be tied to the
addition or removal of an inode to/from a list. If we are not tied
to a list lock, we could update the counters when inodes are
initialised or destroyed, but to do that we need to convert the
counters to be per-cpu (i.e. independent of a lock). This means that
we have the freedom to change the list/locking implementation
without needing to care about the counters.

Based on a patch originally from Eric Dumazet.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/fs-writeback.c  |    5 +--
 fs/inode.c         |   64 ++++++++++++++++++++++++++++++++++++---------------
 include/linux/fs.h |    4 ++-
 kernel/sysctl.c    |    4 +-
 4 files changed, 52 insertions(+), 25 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ab38fef..58a95b7 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -723,7 +723,7 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
 	wb->last_old_flush = jiffies;
 	nr_pages = global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+			get_nr_dirty_inodes();
 
 	if (nr_pages) {
 		struct wb_writeback_work work = {
@@ -1090,8 +1090,7 @@ void writeback_inodes_sb(struct super_block *sb)
 
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	work.nr_pages = nr_dirty + nr_unstable +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+	work.nr_pages = nr_dirty + nr_unstable + get_nr_dirty_inodes();
 
 	bdi_queue_work(sb->s_bdi, &work);
 	wait_for_completion(&done);
diff --git a/fs/inode.c b/fs/inode.c
index 8646433..b3b6a4b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -103,8 +103,41 @@ static DECLARE_RWSEM(iprune_sem);
  */
 struct inodes_stat_t inodes_stat;
 
+static struct percpu_counter nr_inodes __cacheline_aligned_in_smp;
+static struct percpu_counter nr_inodes_unused __cacheline_aligned_in_smp;
+
 static struct kmem_cache *inode_cachep __read_mostly;
 
+static inline int get_nr_inodes(void)
+{
+	return percpu_counter_sum_positive(&nr_inodes);
+}
+
+static inline int get_nr_inodes_unused(void)
+{
+	return percpu_counter_sum_positive(&nr_inodes_unused);
+}
+
+int get_nr_dirty_inodes(void)
+{
+	int nr_dirty = get_nr_inodes() - get_nr_inodes_unused();
+	return nr_dirty > 0 ? nr_dirty : 0;
+
+}
+
+/*
+ * Handle nr_inode sysctl
+ */
+#if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
+int proc_nr_inodes(ctl_table *table, int write,
+		   void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	inodes_stat.nr_inodes = get_nr_inodes();
+	inodes_stat.nr_unused = get_nr_inodes_unused();
+	return proc_dointvec(table, write, buffer, lenp, ppos);
+}
+#endif
+
 static void wake_up_inode(struct inode *inode)
 {
 	/*
@@ -192,6 +225,8 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_fsnotify_mask = 0;
 #endif
 
+	percpu_counter_inc(&nr_inodes);
+
 	return 0;
 out:
 	return -ENOMEM;
@@ -232,6 +267,7 @@ void __destroy_inode(struct inode *inode)
 	if (inode->i_default_acl && inode->i_default_acl != ACL_NOT_CACHED)
 		posix_acl_release(inode->i_default_acl);
 #endif
+	percpu_counter_dec(&nr_inodes);
 }
 EXPORT_SYMBOL(__destroy_inode);
 
@@ -286,7 +322,7 @@ void __iget(struct inode *inode)
 
 	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 		list_move(&inode->i_list, &inode_in_use);
-	inodes_stat.nr_unused--;
+	percpu_counter_dec(&nr_inodes_unused);
 }
 
 void end_writeback(struct inode *inode)
@@ -327,8 +363,6 @@ static void evict(struct inode *inode)
  */
 static void dispose_list(struct list_head *head)
 {
-	int nr_disposed = 0;
-
 	while (!list_empty(head)) {
 		struct inode *inode;
 
@@ -344,11 +378,7 @@ static void dispose_list(struct list_head *head)
 
 		wake_up_inode(inode);
 		destroy_inode(inode);
-		nr_disposed++;
 	}
-	spin_lock(&inode_lock);
-	inodes_stat.nr_inodes -= nr_disposed;
-	spin_unlock(&inode_lock);
 }
 
 /*
@@ -357,7 +387,7 @@ static void dispose_list(struct list_head *head)
 static int invalidate_list(struct list_head *head, struct list_head *dispose)
 {
 	struct list_head *next;
-	int busy = 0, count = 0;
+	int busy = 0;
 
 	next = head->next;
 	for (;;) {
@@ -383,13 +413,11 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
 			list_move(&inode->i_list, dispose);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
-			count++;
+			percpu_counter_dec(&nr_inodes_unused);
 			continue;
 		}
 		busy = 1;
 	}
-	/* only unused inodes may be cached with i_count zero */
-	inodes_stat.nr_unused -= count;
 	return busy;
 }
 
@@ -448,7 +476,6 @@ static int can_unuse(struct inode *inode)
 static void prune_icache(int nr_to_scan)
 {
 	LIST_HEAD(freeable);
-	int nr_pruned = 0;
 	int nr_scanned;
 	unsigned long reap = 0;
 
@@ -484,9 +511,8 @@ static void prune_icache(int nr_to_scan)
 		list_move(&inode->i_list, &freeable);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
-		nr_pruned++;
+		percpu_counter_dec(&nr_inodes_unused);
 	}
-	inodes_stat.nr_unused -= nr_pruned;
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
@@ -518,7 +544,7 @@ static int shrink_icache_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
 			return -1;
 		prune_icache(nr);
 	}
-	return (inodes_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
+	return (get_nr_inodes_unused() / 100) * sysctl_vfs_cache_pressure;
 }
 
 static struct shrinker icache_shrinker = {
@@ -595,7 +621,6 @@ static inline void
 __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
 			struct inode *inode)
 {
-	inodes_stat.nr_inodes++;
 	list_add(&inode->i_list, &inode_in_use);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	if (head)
@@ -1215,7 +1240,7 @@ static void iput_final(struct inode *inode)
 	if (!drop) {
 		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			list_move(&inode->i_list, &inode_unused);
-		inodes_stat.nr_unused++;
+		percpu_counter_inc(&nr_inodes_unused);
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode_lock);
 			return;
@@ -1227,14 +1252,13 @@ static void iput_final(struct inode *inode)
 		spin_lock(&inode_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		inodes_stat.nr_unused--;
+		percpu_counter_dec(&nr_inodes_unused);
 		hlist_del_init(&inode->i_hash);
 	}
 	list_del_init(&inode->i_list);
 	list_del_init(&inode->i_sb_list);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
-	inodes_stat.nr_inodes--;
 	spin_unlock(&inode_lock);
 	evict(inode);
 	spin_lock(&inode_lock);
@@ -1503,6 +1527,8 @@ void __init inode_init(void)
 					 SLAB_MEM_SPREAD),
 					 init_once);
 	register_shrinker(&icache_shrinker);
+	percpu_counter_init(&nr_inodes, 0);
+	percpu_counter_init(&nr_inodes_unused, 0);
 
 	/* Hash may have been set up in inode_init_early */
 	if (!hashdist)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 63d069b..1fb92f9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -407,6 +407,7 @@ extern struct files_stat_struct files_stat;
 extern int get_max_files(void);
 extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
+extern int get_nr_dirty_inodes(void);
 extern int leases_enable, lease_break_time;
 
 struct buffer_head;
@@ -2474,7 +2475,8 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
 struct ctl_table;
 int proc_nr_files(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
-
+int proc_nr_inodes(struct ctl_table *table, int write,
+		   void __user *buffer, size_t *lenp, loff_t *ppos);
 int __init get_filesystem_list(char *buf);
 
 #define ACC_MODE(x) ("\004\002\006\006"[(x)&O_ACCMODE])
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f88552c..33d1733 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1340,14 +1340,14 @@ static struct ctl_table fs_table[] = {
 		.data		= &inodes_stat,
 		.maxlen		= 2*sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_nr_inodes,
 	},
 	{
 		.procname	= "inode-state",
 		.data		= &inodes_stat,
 		.maxlen		= 7*sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_nr_inodes,
 	},
 	{
 		.procname	= "file-nr",
-- 
1.7.1

