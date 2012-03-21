Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab2CUAER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 20:04:17 -0400
Received: from intmgw002.ash2.facebook.com ([66.220.155.179]:59434 "EHLO
	intmgw003.ash2.facebook.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753852Ab2CUAEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 20:04:15 -0400
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
        mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dsharp@google.com, Namhyung Kim <namhyung.kim@lge.com>
Subject: [RFC][PATCH] trace: add last read file to sched_stat_iowait
Date: Tue, 20 Mar 2012 17:00:13 -0700
Message-Id: <1332288013-14632-1-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a lighter weight, but potentially imprecise way of figuring
out which files are responsible for a process to enter iowait.

It only keeps track of read code paths (vfs_read) and ignores
writeback related iowaits.

Sample output:

localhost ~ # perf record -ae sched:sched_stat_iowait -- sleep 10 &
<do some io>
localhosfd~ # perf script
         swapper     0 [000]   176.082523: sched_stat_iowait: comm=cat pid=1387 delay=1362 [ns] ino=116899
         swapper     0 [000]   176.082523: sched_stat_iowait: comm=cat pid=1387 delay=1362 [ns] ino=116899
         swapper     0 [000]   176.082523: sched_stat_iowait: comm=cat pid=1387 delay=1362 [ns] ino=116899

localhost ~ # find /usr -inum 116899
/usr/tests/sets/files/testStaticFileSet.py

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk
Cc: mingo@redhat.com
Cc: rostedt@goodmis.org
Cc: fweisbec@gmail.com 
Cc: teravest@google.com 
Cc: slavapestov@google.com
Cc: ctalbott@google.com
Cc: dsharp@google.com
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: linux-kernel@vger.kernel.org

diff --git a/fs/file.c b/fs/file.c
index 4c6992d..eb77c95 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -304,6 +304,7 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 
 	spin_lock_init(&newf->file_lock);
 	newf->next_fd = 0;
+	newf->last_read = NULL;
 	new_fdt = &newf->fdtab;
 	new_fdt->max_fds = NR_OPEN_DEFAULT;
 	new_fdt->close_on_exec = (fd_set *)&newf->close_on_exec_init;
diff --git a/fs/read_write.c b/fs/read_write.c
index 5ad4248..c5a8e13 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -8,6 +8,7 @@
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/file.h>
+#include <linux/fdtable.h>
 #include <linux/uio.h>
 #include <linux/fsnotify.h>
 #include <linux/security.h>
@@ -375,6 +376,8 @@ ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 	ret = rw_verify_area(READ, file, pos, count);
 	if (ret >= 0) {
 		count = ret;
+		if (current->files)
+			current->files->last_read = file;
 		if (file->f_op->read)
 			ret = file->f_op->read(file, buf, count, pos);
 		else
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 82163c4..0868880 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -53,6 +53,7 @@ struct files_struct {
    */
 	spinlock_t file_lock ____cacheline_aligned_in_smp;
 	int next_fd;
+	struct file *last_read;
 	struct embedded_fd_set close_on_exec_init;
 	struct embedded_fd_set open_fds_init;
 	struct file __rcu * fd_array[NR_OPEN_DEFAULT];
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index e33ed1b..3e96ea7 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -326,9 +326,41 @@ DEFINE_EVENT(sched_stat_template, sched_stat_sleep,
  * Tracepoint for accounting iowait time (time the task is not runnable
  * due to waiting on IO to complete).
  */
-DEFINE_EVENT(sched_stat_template, sched_stat_iowait,
-	     TP_PROTO(struct task_struct *tsk, u64 delay),
-	     TP_ARGS(tsk, delay));
+TRACE_EVENT(sched_stat_iowait,
+
+	TP_PROTO(struct task_struct *tsk, u64 delay, struct file *file),
+
+	TP_ARGS(tsk, delay, file),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+		__field( u64,	delay			)
+		__field(	ino_t,  ino		)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid	= tsk->pid;
+		__entry->delay	= delay;
+		if (file) {
+			struct dentry *dentry = file->f_path.dentry;
+			struct inode *inode = NULL;
+			if (dentry)
+				inode = dentry->d_inode;
+			if (inode)
+				__entry->ino		= inode->i_ino;
+		}
+	)
+	TP_perf_assign(
+		__perf_count(delay);
+	),
+
+	TP_printk("comm=%s pid=%d delay=%Lu [ns] ino=%ld",
+			__entry->comm, __entry->pid,
+			(unsigned long long)__entry->delay,
+			(unsigned long) __entry->ino)
+);
 
 /*
  * Tracepoint for accounting blocked time (time the task is in uninterruptible).
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index aca16b8..5283990 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/profile.h>
 #include <linux/interrupt.h>
+#include <linux/fdtable.h>
 
 #include <trace/events/sched.h>
 
@@ -1025,9 +1026,12 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 		if (tsk) {
 			if (tsk->in_iowait) {
+				struct file *last_read_file = NULL;
+				if (tsk->files)
+					last_read_file = tsk->files->last_read;
 				se->statistics.iowait_sum += delta;
 				se->statistics.iowait_count++;
-				trace_sched_stat_iowait(tsk, delta);
+				trace_sched_stat_iowait(tsk, delta, last_read_file);
 			}
 
 			trace_sched_stat_blocked(tsk, delta);
