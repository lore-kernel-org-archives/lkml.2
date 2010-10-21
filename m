Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab0JUNWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:22:51 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:7306 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757940Ab0JUNWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:22:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoAGAGfav0x5LdoFgWdsb2JhbACUZ4xxFgEBFiIiwC+FSgSKTYUB
Message-Id: <20101021131016.749495713@kernel.dk>
User-Agent: quilt/0.48-1
Date: Fri, 22 Oct 2010 00:08:37 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk
Subject: [patch 08/14] fs: icache make nr_inodes and nr_unused atomic
References: <20101021130829.442910807@kernel.dk>
Content-Disposition: inline; filename=fs-inode-nr_inodes-atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fix a theoretical bug where number of inuse inodes is
calculated to be a negative number.

[note: at this point, most of the inode_lock could be removed]

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/fs-writeback.c  |    5 +---
 fs/inode.c         |   61 ++++++++++++++++++++++++++++++++++++++++-------------
 include/linux/fs.h |    4 ++-
 kernel/sysctl.c    |    4 +--
 4 files changed, 54 insertions(+), 20 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-21 23:50:43.000000000 +1100
@@ -133,6 +133,43 @@ static DECLARE_RWSEM(iprune_sem);
  */
 struct inodes_stat_t inodes_stat;
 
+static atomic_t nr_inodes = ATOMIC_INIT(0);
+static atomic_t nr_unused = ATOMIC_INIT(0);
+
+static int get_nr_inodes(void)
+{
+	return atomic_read(&nr_inodes);
+}
+
+static int get_nr_unused(void)
+{
+	return atomic_read(&nr_unused);
+}
+
+int get_nr_inodes_inuse(void)
+{
+	int nr;
+	nr = get_nr_inodes() - get_nr_unused();
+	if (nr < 0)
+		nr = 0;
+	return nr;
+}
+
+/*
+ * Handle nr_inodes sysctl
+ */
+int proc_nr_inodes(ctl_table *table, int write,
+		   void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+#if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
+	inodes_stat.nr_inodes = get_nr_inodes();
+	inodes_stat.nr_unused = get_nr_unused();
+	return proc_dointvec(table, write, buffer, lenp, ppos);
+#else
+	return -ENOSYS;
+#endif
+}
+
 static struct kmem_cache *inode_cachep __read_mostly;
 
 static void wake_up_inode(struct inode *inode)
@@ -340,7 +377,7 @@ void inode_get_ilock_wblock(struct inode
 	if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
 		list_move(&inode->i_list, &inode_in_use);
 	}
-	inodes_stat.nr_unused--;
+	atomic_dec(&nr_unused);
 }
 
 /*
@@ -360,7 +397,7 @@ void inode_get_ilock(struct inode *inode
 		list_move(&inode->i_list, &inode_in_use);
 		spin_unlock(&wb_inode_list_lock);
 	}
-	inodes_stat.nr_unused--;
+	atomic_dec(&nr_unused);
 }
 EXPORT_SYMBOL(inode_get_ilock);
 
@@ -436,9 +473,7 @@ static void dispose_list(struct list_hea
 		destroy_inode(inode);
 		nr_disposed++;
 	}
-	spin_lock(&inode_lock);
-	inodes_stat.nr_inodes -= nr_disposed;
-	spin_unlock(&inode_lock);
+	atomic_sub(nr_disposed, &nr_inodes);
 }
 
 /*
@@ -484,9 +519,7 @@ static int invalidate_list(struct super_
 		busy = 1;
 	}
 	/* only unused inodes may be cached with i_count zero */
-	spin_lock(&inode_lock);
-	inodes_stat.nr_unused -= count;
-	spin_unlock(&inode_lock);
+	atomic_sub(count, &nr_unused);
 
 	return busy;
 }
@@ -605,7 +638,7 @@ static void prune_icache(int nr_to_scan)
 		spin_unlock(&inode->i_lock);
 		nr_pruned++;
 	}
-	inodes_stat.nr_unused -= nr_pruned;
+	atomic_sub(nr_pruned, &nr_unused);
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
@@ -638,7 +671,7 @@ static int shrink_icache_memory(struct s
 			return -1;
 		prune_icache(nr);
 	}
-	return (inodes_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
+	return (get_nr_unused() / 100) * sysctl_vfs_cache_pressure;
 }
 
 static struct shrinker icache_shrinker = {
@@ -727,7 +760,7 @@ static inline void
 __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
 			struct inode *inode)
 {
-	inodes_stat.nr_inodes++;
+	atomic_inc(&nr_inodes);
 	spin_lock(&wb_inode_list_lock);
 	list_add(&inode->i_list, &inode_in_use);
 	spin_unlock(&wb_inode_list_lock);
@@ -1429,7 +1462,7 @@ static void iput_final(struct inode *ino
 			list_move(&inode->i_list, &inode_unused);
 			spin_unlock(&wb_inode_list_lock);
 		}
-		inodes_stat.nr_unused++;
+		atomic_inc(&nr_unused);
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
@@ -1444,7 +1477,7 @@ static void iput_final(struct inode *ino
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		inodes_stat.nr_unused--;
+		atomic_dec(&nr_unused);
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
@@ -1457,7 +1490,7 @@ static void iput_final(struct inode *ino
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
-	inodes_stat.nr_inodes--;
+	atomic_dec(&nr_inodes);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	evict(inode);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-10-21 23:50:42.000000000 +1100
@@ -407,6 +407,7 @@ extern struct files_stat_struct files_st
 extern int get_max_files(void);
 extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
+extern int get_nr_inodes_inuse(void);
 extern int leases_enable, lease_break_time;
 
 struct buffer_head;
@@ -2477,7 +2478,8 @@ ssize_t simple_attr_write(struct file *f
 struct ctl_table;
 int proc_nr_files(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
-
+int proc_nr_inodes(struct ctl_table *table, int write,
+		   void __user *buffer, size_t *lenp, loff_t *ppos);
 int __init get_filesystem_list(char *buf);
 
 #define ACC_MODE(x) ("\004\002\006\006"[(x)&O_ACCMODE])
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c	2010-10-21 23:49:52.000000000 +1100
+++ linux-2.6/kernel/sysctl.c	2010-10-21 23:50:27.000000000 +1100
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
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-21 23:50:43.000000000 +1100
@@ -774,7 +774,7 @@ static long wb_check_old_data_flush(stru
 	wb->last_old_flush = jiffies;
 	nr_pages = global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+			get_nr_inodes_inuse();
 
 	if (nr_pages) {
 		struct wb_writeback_work work = {
@@ -1160,8 +1160,7 @@ void writeback_inodes_sb(struct super_bl
 
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	work.nr_pages = nr_dirty + nr_unstable +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+	work.nr_pages = nr_dirty + nr_unstable + get_nr_inodes_inuse();
 
 	bdi_queue_work(sb->s_bdi, &work);
 	wait_for_completion(&done);


