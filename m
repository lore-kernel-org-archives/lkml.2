Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690Ab0JSD4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:56:23 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28449 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933525Ab0JSD4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSoUAag
Message-Id: <20101019034657.693361350@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:37 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [patch 21/35] fs: icache per-cpu nr_inodes, non-atomic nr_unused counters
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode-nr_inodes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

[Eric Dumazet]
Make nr_inodes a per-cpu counter to avoid cache line ping pongs between cpus.

[Nick Piggin]
Make nr_unused non-atomic and protected by wb_inode_list_lock.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/fs-writeback.c  |   18 +++++++++++-----
 fs/inode.c         |   58 ++++++++++++++++++++++++++++++++++++++---------------
 include/linux/fs.h |   15 +++++--------
 kernel/sysctl.c    |    4 +--
 4 files changed, 63 insertions(+), 32 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:38:03.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:38:27.000000000 +1100
@@ -139,12 +139,42 @@
  * Statistics gathering..
  */
 struct inodes_stat_t inodes_stat = {
-	.nr_inodes = ATOMIC_INIT(0),
-	.nr_unused = ATOMIC_INIT(0),
+	.nr_inodes = 0,
+	.nr_unused = 0,
 };
 
+static DEFINE_PER_CPU(unsigned int, nr_inodes);
+
 static struct kmem_cache *inode_cachep __read_mostly;
 
+int get_nr_inodes(void)
+{
+	int i;
+	int sum = 0;
+	for_each_possible_cpu(i)
+		sum += per_cpu(nr_inodes, i);
+	return sum < 0 ? 0 : sum;
+}
+
+int get_nr_inodes_unused(void)
+{
+	return inodes_stat.nr_unused;
+}
+
+/*
+ * Handle nr_dentry sysctl
+ */
+int proc_nr_inodes(ctl_table *table, int write,
+		   void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+#if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
+	inodes_stat.nr_inodes = get_nr_inodes();
+	return proc_dointvec(table, write, buffer, lenp, ppos);
+#else
+	return -ENOSYS;
+#endif
+}
+
 static void wake_up_inode(struct inode *inode)
 {
 	/*
@@ -232,7 +262,7 @@
 	inode->i_fsnotify_mask = 0;
 #endif
 
-	atomic_inc(&inodes_stat.nr_inodes);
+	this_cpu_inc(nr_inodes);
 
 	return 0;
 out:
@@ -280,7 +310,7 @@
 	if (inode->i_default_acl && inode->i_default_acl != ACL_NOT_CACHED)
 		posix_acl_release(inode->i_default_acl);
 #endif
-	atomic_dec(&inodes_stat.nr_inodes);
+	this_cpu_dec(nr_inodes);
 }
 EXPORT_SYMBOL(__destroy_inode);
 
@@ -400,7 +430,7 @@
 static int invalidate_list(struct list_head *head, struct list_head *dispose)
 {
 	struct list_head *next;
-	int busy = 0, count = 0;
+	int busy = 0;
 
 	next = head->next;
 	for (;;) {
@@ -420,19 +450,17 @@
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
 
@@ -494,7 +522,6 @@
 static void prune_icache(unsigned long nr_to_scan)
 {
 	LIST_HEAD(freeable);
-	int nr_pruned = 0;
 	unsigned long reap = 0;
 
 	down_read(&iprune_sem);
@@ -515,7 +542,7 @@
 		if (inode->i_count || (inode->i_state & ~I_REFERENCED)) {
 			list_del_init(&inode->i_list);
 			spin_unlock(&inode->i_lock);
-			atomic_dec(&inodes_stat.nr_unused);
+			inodes_stat.nr_unused--;
 			continue;
 		}
 		if (inode->i_state & I_REFERENCED) {
@@ -557,9 +584,8 @@
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
@@ -587,7 +613,7 @@
 	unsigned long nr;
 
 	shrinker_add_scan(&nr_to_scan, scanned, global,
-			atomic_read(&inodes_stat.nr_unused),
+			inodes_stat.nr_unused,
 			SHRINK_DEFAULT_SEEKS * 100 / sysctl_vfs_cache_pressure);
 	/*
 	 * Nasty deadlock avoidance.  We may hold various FS locks,
@@ -1372,8 +1398,8 @@
 					list_empty(&inode->i_list)) {
 				spin_lock(&wb_inode_list_lock);
 				list_add(&inode->i_list, &inode_unused);
+				inodes_stat.nr_unused++;
 				spin_unlock(&wb_inode_list_lock);
-				atomic_inc(&inodes_stat.nr_unused);
 			}
 			spin_unlock(&inode->i_lock);
 			return;
@@ -1390,9 +1416,9 @@
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
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-19 14:38:03.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-10-19 14:38:05.000000000 +1100
@@ -40,14 +40,8 @@
 };
 
 struct inodes_stat_t {
-	/*
-	 * Using atomics here is a hack which should just happen to
-	 * work on all architectures today. Not a big deal though,
-	 * because it goes away and gets fixed properly later in the
-	 * inode scaling series.
-	 */
-	atomic_t nr_inodes;
-	atomic_t nr_unused;
+	int nr_inodes;
+	int nr_unused;
 	int dummy[5];		/* padding for sysctl ABI compatibility */
 };
 
@@ -413,6 +407,8 @@
 extern int get_max_files(void);
 extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
+extern int get_nr_inodes(void);
+extern int get_nr_inodes_unused(void);
 extern int leases_enable, lease_break_time;
 
 struct buffer_head;
@@ -2490,7 +2486,8 @@
 struct ctl_table;
 int proc_nr_files(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
-
+int proc_nr_inodes(struct ctl_table *table, int write,
+		   void __user *buffer, size_t *lenp, loff_t *ppos);
 int __init get_filesystem_list(char *buf);
 
 #define ACC_MODE(x) ("\004\002\006\006"[(x)&O_ACCMODE])
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:38:03.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:38:05.000000000 +1100
@@ -738,6 +738,7 @@
 {
 	unsigned long expired;
 	long nr_pages;
+	int nr_dirty_inodes;
 
 	/*
 	 * When set to zero, disable periodic writeback
@@ -750,11 +751,15 @@
 	if (time_before(jiffies, expired))
 		return 0;
 
+	/* approximate dirty inodes */
+	nr_dirty_inodes = get_nr_inodes() - get_nr_inodes_unused();
+	if (nr_dirty_inodes < 0)
+		nr_dirty_inodes = 0;
+
 	wb->last_old_flush = jiffies;
 	nr_pages = global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) +
-			(atomic_read(&inodes_stat.nr_inodes) -
-			atomic_read(&inodes_stat.nr_unused));
+			nr_dirty_inodes;
 
 	if (nr_pages) {
 		struct wb_writeback_work work = {
@@ -1120,6 +1125,7 @@
 {
 	unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
 	unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
+	int nr_dirty_inodes;
 	DECLARE_COMPLETION_ONSTACK(done);
 	struct wb_writeback_work work = {
 		.sb		= sb,
@@ -1129,9 +1135,11 @@
 
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	work.nr_pages = nr_dirty + nr_unstable +
-			(atomic_read(&inodes_stat.nr_inodes) -
-			atomic_read(&inodes_stat.nr_unused));
+	nr_dirty_inodes = get_nr_inodes() - get_nr_inodes_unused();
+	if (nr_dirty_inodes < 0)
+		nr_dirty_inodes = 0;
+
+	work.nr_pages = nr_dirty + nr_unstable + nr_dirty_inodes;
 
 	bdi_queue_work(sb->s_bdi, &work);
 	wait_for_completion(&done);
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c	2010-10-19 14:19:24.000000000 +1100
+++ linux-2.6/kernel/sysctl.c	2010-10-19 14:38:05.000000000 +1100
@@ -1340,14 +1340,14 @@
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


