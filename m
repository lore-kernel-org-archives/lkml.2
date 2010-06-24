Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab0FXDZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:25:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab0FXDP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:56 -0400
Message-Id: <20100624030732.550332077@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:55 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: [patch 43/52] fs: icache per-cpu nr_inodes counter
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-nr_inodes-percpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>

Avoids cache line ping pongs between cpus and prepare next patch,
because updates of nr_inodes dont need inode_lock anymore.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/fs-writeback.c  |    4 ++--
 fs/inode.c         |   31 ++++++++++++++++++++++++++++---
 include/linux/fs.h |    5 ++++-
 kernel/sysctl.c    |    4 ++--
 4 files changed, 36 insertions(+), 8 deletions(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -904,7 +904,7 @@ static long wb_check_old_data_flush(stru
 	wb->last_old_flush = jiffies;
 	nr_pages = global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) +
-			inodes_stat.nr_inodes - inodes_stat.nr_unused;
+			get_nr_inodes() - inodes_stat.nr_unused;
 
 	if (nr_pages) {
 		struct wb_writeback_args args = {
@@ -1257,7 +1257,7 @@ void writeback_inodes_sb(struct super_bl
 	long nr_to_write;
 
 	nr_to_write = nr_dirty + nr_unstable +
-			inodes_stat.nr_inodes - inodes_stat.nr_unused;
+			get_nr_inodes() - inodes_stat.nr_unused;
 
 	bdi_start_writeback(sb->s_bdi, sb, nr_to_write);
 }
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -144,9 +144,33 @@ struct inodes_stat_t inodes_stat = {
 	.nr_inodes = 0,
 	.nr_unused = 0,
 };
+struct percpu_counter nr_inodes;
 
 static struct kmem_cache *inode_cachep __read_mostly;
 
+int get_nr_inodes(void)
+{
+	return percpu_counter_sum_positive(&nr_inodes);
+}
+
+/*
+ * Handle nr_dentry sysctl
+ */
+#if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
+int proc_nr_inodes(ctl_table *table, int write,
+		   void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	inodes_stat.nr_inodes = get_nr_inodes();
+	return proc_dointvec(table, write, buffer, lenp, ppos);
+}
+#else
+int proc_nr_inodes(ctl_table *table, int write,
+		   void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+#endif
+
 static void wake_up_inode(struct inode *inode)
 {
 	/*
@@ -657,8 +681,8 @@ __inode_add_to_lists(struct super_block
 {
 	spin_lock(&sb_inode_list_lock);
 	list_add_rcu(&inode->i_sb_list, &sb->s_inodes);
-	inodes_stat.nr_inodes++;
 	spin_unlock(&sb_inode_list_lock);
+	percpu_counter_inc(&nr_inodes);
 	if (b) {
 		spin_lock_bucket(b);
 		hlist_bl_add_head_rcu(&inode->i_hash, &b->head);
@@ -1337,8 +1361,8 @@ void generic_delete_inode(struct inode *
 	}
 	spin_lock(&sb_inode_list_lock);
 	list_del_rcu(&inode->i_sb_list);
-	inodes_stat.nr_inodes--;
 	spin_unlock(&sb_inode_list_lock);
+	percpu_counter_dec(&nr_inodes);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
@@ -1413,8 +1437,8 @@ int generic_detach_inode(struct inode *i
 	}
 	spin_lock(&sb_inode_list_lock);
 	list_del_rcu(&inode->i_sb_list);
-	inodes_stat.nr_inodes--;
 	spin_unlock(&sb_inode_list_lock);
+	percpu_counter_dec(&nr_inodes);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
@@ -1723,6 +1747,7 @@ void __init inode_init(void)
 {
 	int loop;
 
+	percpu_counter_init(&nr_inodes, 0);
 	/* inode slab cache */
 	inode_cachep = kmem_cache_create("inode_cache",
 					 sizeof(struct inode),
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -406,6 +406,8 @@ extern struct files_stat_struct files_st
 extern int get_max_files(void);
 extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
+extern struct percpu_counter nr_inodes;
+extern int get_nr_inodes(void);
 extern int leases_enable, lease_break_time;
 #ifdef CONFIG_DNOTIFY
 extern int dir_notify_enable;
@@ -2514,7 +2516,8 @@ ssize_t simple_attr_write(struct file *f
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
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -1338,14 +1338,14 @@ static struct ctl_table fs_table[] = {
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


