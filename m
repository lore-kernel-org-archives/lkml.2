Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab0I2MVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:21:06 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:48395 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755635Ab0I2MTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:30 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/17] fs: Convert nr_inodes to a per-cpu counter
Date: Wed, 29 Sep 2010 22:18:48 +1000
Message-Id: <1285762729-17928-17-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>

The number of inodes allocated does not need to be tied to the
addition or removal of an inode to/from a list. If we are not tied
to a list lock, we could update the counters when inodes are
initialised or destroyed, but to do that we need to convert the
counters to be per-cpu (i.e. independent of a lock). This means that
we have the freedom to change the list/locking implementation
without needing to care about the counters.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/fs-writeback.c  |   16 +++++++++++++---
 fs/inode.c         |   35 +++++++++++++++++++++++++++++++++--
 include/linux/fs.h |    5 ++++-
 kernel/sysctl.c    |    4 ++--
 4 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8e390e8..348cc18 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -728,6 +728,7 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
 {
 	unsigned long expired;
 	long nr_pages;
+	int nr_dirty_inodes;
 
 	/*
 	 * When set to zero, disable periodic writeback
@@ -740,10 +741,15 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
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
-			inodes_stat.nr_inodes - inodes_stat.nr_unused;
+			nr_dirty_inodes;
 
 	if (nr_pages) {
 		struct wb_writeback_work work = {
@@ -1105,6 +1111,7 @@ void writeback_inodes_sb(struct super_block *sb)
 {
 	unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
 	unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
+	int nr_dirty_inodes;
 	DECLARE_COMPLETION_ONSTACK(done);
 	struct wb_writeback_work work = {
 		.sb		= sb,
@@ -1114,8 +1121,11 @@ void writeback_inodes_sb(struct super_block *sb)
 
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	work.nr_pages = nr_dirty + nr_unstable +
-			inodes_stat.nr_inodes - inodes_stat.nr_unused;
+	nr_dirty_inodes = get_nr_inodes() - get_nr_inodes_unused();
+	if (nr_dirty_inodes < 0)
+		nr_dirty_inodes = 0;
+
+	work.nr_pages = nr_dirty + nr_unstable + nr_dirty_inodes;
 
 	bdi_queue_work(sb->s_bdi, &work);
 	wait_for_completion(&done);
diff --git a/fs/inode.c b/fs/inode.c
index 1388450..a91efab 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -143,8 +143,38 @@ struct inodes_stat_t inodes_stat = {
 	.nr_unused = 0,
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
@@ -232,6 +262,8 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_fsnotify_mask = 0;
 #endif
 
+	this_cpu_inc(nr_inodes);
+
 	return 0;
 out:
 	return -ENOMEM;
@@ -272,6 +304,7 @@ void __destroy_inode(struct inode *inode)
 	if (inode->i_default_acl && inode->i_default_acl != ACL_NOT_CACHED)
 		posix_acl_release(inode->i_default_acl);
 #endif
+	this_cpu_dec(nr_inodes);
 }
 EXPORT_SYMBOL(__destroy_inode);
 
@@ -643,7 +676,6 @@ static inline void
 __inode_add_to_lists(struct super_block *sb, struct inode_hash_bucket *b,
 			struct inode *inode)
 {
-	inodes_stat.nr_inodes++;
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
 	if (b) {
@@ -1382,7 +1414,6 @@ static void iput_final(struct inode *inode)
 		spin_unlock(&wb_inode_list_lock);
 	}
 	list_del_init(&inode->i_sb_list);
-	inodes_stat.nr_inodes--;
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3a43313..d2ee5d0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -407,6 +407,8 @@ extern struct files_stat_struct files_stat;
 extern int get_max_files(void);
 extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
+extern int get_nr_inodes(void);
+extern int get_nr_inodes_unused(void);
 extern int leases_enable, lease_break_time;
 
 struct buffer_head;
@@ -2477,7 +2479,8 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
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

