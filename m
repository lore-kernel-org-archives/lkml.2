Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab2A0SBC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:01:02 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44598 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab2A0R7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:59:45 -0500
Message-Id: <20120127175939.726222479@openvz.org>
User-Agent: quilt/0.48-1
Date: Fri, 27 Jan 2012 21:53:43 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [RFC c/r 1/4] fs, proc: Introduce /proc/<pid>/task/<tid>/children entry v9
References: <20120127175342.273260614@openvz.org>
Content-Disposition: inline; filename=fs-proc-tid-children-13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we do checkpoint of a task we need to know the list of children
the task, has but there is no easy and fast way to generate reverse
parent->children chain from arbitrary <pid> (while a parent pid is
provided in "PPid" field of /proc/<pid>/status).

So instead of walking over all pids in the system (creating one big process
tree in memory, just to figure out which children a task has) -- we add
explicit /proc/<pid>/task/<tid>/children entry, because the kernel already has
this kind of information but it is not yet exported.

This is a first level children, not the whole process tree.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 Documentation/filesystems/proc.txt |   18 +++++
 fs/proc/array.c                    |  123 +++++++++++++++++++++++++++++++++++++
 fs/proc/base.c                     |    3 
 fs/proc/internal.h                 |    1 
 4 files changed, 145 insertions(+)

Index: linux-2.6.git/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.git.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.git/Documentation/filesystems/proc.txt
@@ -40,6 +40,7 @@ Table of Contents
   3.4	/proc/<pid>/coredump_filter - Core dump filtering settings
   3.5	/proc/<pid>/mountinfo - Information about mounts
   3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
+  3.7   /proc/<pid>/task/<tid>/children - Information about task children
 
   4	Configuring procfs
   4.1	Mount options
@@ -1549,6 +1550,23 @@ then the kernel's TASK_COMM_LEN (current
 comm value.
 
 
+3.7	/proc/<pid>/task/<tid>/children - Information about task children
+-------------------------------------------------------------------------
+This file provides a fast way to retrieve first level children pids
+of a task pointed by <pid>/<tid> pair. The format is a space separated
+stream of pids.
+
+Note the "first level" here -- if a child has own children they will
+not be listed here, one needs to read /proc/<children-pid>/task/<tid>/children
+to obtain the descendants.
+
+Since this interface is intended to be fast and cheap it doesn't
+guarantee to provide precise results and some children might be
+skipped, especially if they've exited right after we printed their
+pids, so one need to either stop or freeze processes being inspected
+if precise results are needed.
+
+
 ------------------------------------------------------------------------------
 Configuring procfs
 ------------------------------------------------------------------------------
Index: linux-2.6.git/fs/proc/array.c
===================================================================
--- linux-2.6.git.orig/fs/proc/array.c
+++ linux-2.6.git/fs/proc/array.c
@@ -547,3 +547,126 @@ int proc_pid_statm(struct seq_file *m, s
 
 	return 0;
 }
+
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static struct pid *
+get_children_pid(struct inode *inode, struct pid *pid_prev, loff_t pos)
+{
+	struct task_struct *start, *task;
+	struct pid *pid = NULL;
+
+	read_lock(&tasklist_lock);
+
+	start = pid_task(proc_pid(inode), PIDTYPE_PID);
+	if (!start)
+		goto out;
+
+	/*
+	 * Lets try to continue searching first, this gives
+	 * us significant speedup on children-rich processes.
+	 */
+	if (pid_prev) {
+		task = pid_task(pid_prev, PIDTYPE_PID);
+		if (task && task->real_parent == start &&
+		    !(list_empty(&task->sibling))) {
+			if (list_is_last(&task->sibling, &start->children))
+				goto out;
+			task = list_first_entry(&task->sibling,
+						struct task_struct, sibling);
+			pid = get_pid(task_pid(task));
+			goto out;
+		}
+	}
+
+	/*
+	 * Slow search case.
+	 *
+	 * We might miss some children here if children
+	 * are exited while we were not holding the lock,
+	 * but it was never promised to be accurate that
+	 * much.
+	 *
+	 * "Just suppose that the parent sleeps, but N children
+	 *  exit after we printed their tids. Now the slow paths
+	 *  skips N extra children, we miss N tasks." (c)
+	 *
+	 * So one need to stop or freeze the leader and all
+	 * its children to get a precise result.
+	 */
+	list_for_each_entry(task, &start->children, sibling) {
+		if (pos-- == 0) {
+			pid = get_pid(task_pid(task));
+			break;
+		}
+	}
+
+out:
+	read_unlock(&tasklist_lock);
+	return pid;
+}
+
+static int children_seq_show(struct seq_file *seq, void *v)
+{
+	struct inode *inode = seq->private;
+	pid_t pid;
+
+	pid = pid_nr_ns(v, inode->i_sb->s_fs_info);
+	return seq_printf(seq, "%d ", pid);
+}
+
+static void *children_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	return get_children_pid(seq->private, NULL, *pos);
+}
+
+static void *children_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct pid *pid;
+
+	pid = get_children_pid(seq->private, v, *pos + 1);
+	put_pid(v);
+
+	++*pos;
+	return pid;
+}
+
+static void children_seq_stop(struct seq_file *seq, void *v)
+{
+	put_pid(v);
+}
+
+static const struct seq_operations children_seq_ops = {
+	.start	= children_seq_start,
+	.next	= children_seq_next,
+	.stop	= children_seq_stop,
+	.show	= children_seq_show,
+};
+
+static int children_seq_open(struct inode *inode, struct file *file)
+{
+	struct seq_file *m;
+	int ret;
+
+	ret = seq_open(file, &children_seq_ops);
+	if (ret)
+		return ret;
+
+	m = file->private_data;
+	m->private = inode;
+
+	return ret;
+}
+
+int children_seq_release(struct inode *inode, struct file *file)
+{
+	seq_release(inode, file);
+	return 0;
+}
+
+const struct file_operations proc_tid_children_operations = {
+	.open    = children_seq_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = children_seq_release,
+};
+#endif
Index: linux-2.6.git/fs/proc/base.c
===================================================================
--- linux-2.6.git.orig/fs/proc/base.c
+++ linux-2.6.git/fs/proc/base.c
@@ -3384,6 +3384,9 @@ static const struct pid_entry tid_base_s
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
 	REG("maps",      S_IRUGO, proc_maps_operations),
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	REG("children",  S_IRUGO, proc_tid_children_operations),
+#endif
 #ifdef CONFIG_NUMA
 	REG("numa_maps", S_IRUGO, proc_numa_maps_operations),
 #endif
Index: linux-2.6.git/fs/proc/internal.h
===================================================================
--- linux-2.6.git.orig/fs/proc/internal.h
+++ linux-2.6.git/fs/proc/internal.h
@@ -53,6 +53,7 @@ extern int proc_pid_statm(struct seq_fil
 				struct pid *pid, struct task_struct *task);
 extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
 
+extern const struct file_operations proc_tid_children_operations;
 extern const struct file_operations proc_maps_operations;
 extern const struct file_operations proc_numa_maps_operations;
 extern const struct file_operations proc_smaps_operations;

