Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab0ELVgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:36:32 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45255 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758087Ab0ELVd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:33:57 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@arndb.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH RFC tip/core/rcu 20/23] kernel: __rcu annotations
Date: Wed, 12 May 2010 14:33:39 -0700
Message-Id: <1273700022-16523-20-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100512213317.GA15085@linux.vnet.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This adds annotations for RCU operations in core kernel components

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/fdtable.h   |    6 +++---
 include/linux/fs.h        |    2 +-
 include/linux/genhd.h     |    6 +++---
 include/linux/init_task.h |    4 ++--
 include/linux/iocontext.h |    2 +-
 include/linux/mm_types.h  |    2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 551671e..3e4c4f4 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -31,7 +31,7 @@ struct embedded_fd_set {
 
 struct fdtable {
 	unsigned int max_fds;
-	struct file ** fd;      /* current fd array */
+	struct file __rcu **fd;      /* current fd array */
 	fd_set *close_on_exec;
 	fd_set *open_fds;
 	struct rcu_head rcu;
@@ -46,7 +46,7 @@ struct files_struct {
    * read mostly part
    */
 	atomic_t count;
-	struct fdtable *fdt;
+	struct fdtable __rcu *fdt;
 	struct fdtable fdtab;
   /*
    * written part on a separate cache line in SMP
@@ -55,7 +55,7 @@ struct files_struct {
 	int next_fd;
 	struct embedded_fd_set close_on_exec_init;
 	struct embedded_fd_set open_fds_init;
-	struct file * fd_array[NR_OPEN_DEFAULT];
+	struct file __rcu * fd_array[NR_OPEN_DEFAULT];
 };
 
 #define rcu_dereference_check_fdtable(files, fdtfd) \
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 44f35ae..752bc76 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1382,7 +1382,7 @@ struct super_block {
 	 * Saved mount options for lazy filesystems using
 	 * generic_show_options()
 	 */
-	char *s_options;
+	char __rcu *s_options;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 5f2f4c4..af3f06b 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -129,8 +129,8 @@ struct blk_scsi_cmd_filter {
 struct disk_part_tbl {
 	struct rcu_head rcu_head;
 	int len;
-	struct hd_struct *last_lookup;
-	struct hd_struct *part[];
+	struct hd_struct __rcu *last_lookup;
+	struct hd_struct __rcu *part[];
 };
 
 struct gendisk {
@@ -149,7 +149,7 @@ struct gendisk {
 	 * non-critical accesses use RCU.  Always access through
 	 * helpers.
 	 */
-	struct disk_part_tbl *part_tbl;
+	struct disk_part_tbl __rcu *part_tbl;
 	struct hd_struct part0;
 
 	const struct block_device_operations *fops;
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 7996fc2..f05af8c 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -137,8 +137,8 @@ extern struct cred init_cred;
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
 	.group_leader	= &tsk,						\
-	.real_cred	= &init_cred,					\
-	.cred		= &init_cred,					\
+	RCU_INIT_POINTER(.real_cred, &init_cred),			\
+	RCU_INIT_POINTER(.cred, &init_cred),				\
 	.cred_guard_mutex =						\
 		 __MUTEX_INITIALIZER(tsk.cred_guard_mutex),		\
 	.comm		= "swapper",					\
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index a0bb301..6d4cd79 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -54,7 +54,7 @@ struct io_context {
 
 	struct radix_tree_root radix_root;
 	struct hlist_head cic_list;
-	void *ioc_data;
+	void __rcu *ioc_data;
 };
 
 static inline struct io_context *ioc_task_link(struct io_context *ioc)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b8bb9a6..05537a5 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -299,7 +299,7 @@ struct mm_struct {
 	 * new_owner->mm == mm
 	 * new_owner->alloc_lock is held
 	 */
-	struct task_struct *owner;
+	struct task_struct __rcu *owner;
 #endif
 
 #ifdef CONFIG_PROC_FS
-- 
1.7.0.6

