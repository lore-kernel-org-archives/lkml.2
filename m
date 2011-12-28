Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab1L1MOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 07:14:16 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61513 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab1L1MON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 07:14:13 -0500
Date: Wed, 28 Dec 2011 16:14:07 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [RFC] fs, proc: Introduce /proc/<pid>/task/<tid>/children entry v5
Message-ID: <20111228121407.GL27266@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we do checkpoint of a task we need to know the list of children
the task has but there is no easy way to make a reverse parent->children
chain from an arbitrary <pid> (while a parent pid is provided in "PPid"
field of /proc/<pid>/status).

So instead of walking over all pids in the system creating the big process
tree just to figure out which children a task has -- we add the explicit
/proc/<pid>/task/<tid>/children entry, because the kernel already has
this kind of information but it is not yet exported.

This is a first level children, not the whole process tree.

v2:
 - Kame suggested to use a separated /proc/<pid>/children entry
   instead of poking /proc/<pid>/status
 - Andew suggested to use rcu facility instead of locking
   tasklist_lock
 - Tejun pointed that non-seekable seq file might not be
   enough for tasks with large number of children

v3:
 - To be on a safe side use %lu format for pid_t printing

v4:
 - New line get printed when sequence ends not at seq->stop,
   a nit pointed by Tejun
 - Documentation update
 - tasklist_lock is back, Oleg pointed that ->children list
   is actually not rcu-safe

v5:
 - Oleg suggested to make /proc/<pid>/task/<tid>/children
   instead of global /proc/<pid>/children, which eliminates
   hardness related to threads and children migration, and
   allows patch to be a way simplier.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 Documentation/filesystems/proc.txt |   20 ++++
 fs/proc/array.c                    |  162 +++++++++++++++++++++++++++++++++++++
 fs/proc/base.c                     |    1 
 fs/proc/internal.h                 |    1 
 4 files changed, 183 insertions(+), 1 deletion(-)

Index: linux-2.6.git/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.git.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.git/Documentation/filesystems/proc.txt
@@ -40,7 +40,7 @@ Table of Contents
   3.4	/proc/<pid>/coredump_filter - Core dump filtering settings
   3.5	/proc/<pid>/mountinfo - Information about mounts
   3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
-
+  3.7	/proc/<pid>/task/<tid>/children - Information about task children
 
 ------------------------------------------------------------------------------
 Preface
@@ -1545,3 +1545,21 @@ a task to set its own or one of its thre
 is limited in size compared to the cmdline value, so writing anything longer
 then the kernel's TASK_COMM_LEN (currently 16 chars) will result in a truncated
 comm value.
+
+3.7	/proc/<pid>/task/<tid>/children - Information about task children
+-------------------------------------------------------------------------
+This file provides a fast way to retrieve first level children pids
+of a task pointed by <pid>/<tid> pair. The format is a space separated
+stream of pids.
+
+Note the "first level" here -- if a child has own children they will
+not be shown here, one needs to read /proc/<children-pid>/task/<tid>/children
+to obtain descendants.
+
+Because this interface is intended to be fast and cheap it doesn't
+guarantee to provide precise results, which means if a child is exiting
+it might or might not be counted. The same applies to freshly created
+children -- they might or might not be counted.
+
+If one needs precise pids -- the task and children should be stopped
+or frozen.
Index: linux-2.6.git/fs/proc/array.c
===================================================================
--- linux-2.6.git.orig/fs/proc/array.c
+++ linux-2.6.git/fs/proc/array.c
@@ -547,3 +547,165 @@ int proc_pid_statm(struct seq_file *m, s
 
 	return 0;
 }
+
+struct proc_pid_children_iter {
+	struct pid_namespace *pid_ns;
+	struct pid *pid_start;
+};
+
+static struct pid *
+get_children_pid(struct proc_pid_children_iter *iter, struct pid *pid_prev, loff_t pos)
+{
+	struct task_struct *start, *task;
+	struct pid *pid = NULL;
+
+	read_lock(&tasklist_lock);
+
+	start = pid_task(iter->pid_start, PIDTYPE_PID);
+	if (!start)
+		goto out;
+
+	/*
+	 * Lets try to continue searching this would speed
+	 * search significantly.
+	 */
+	if (pid_prev) {
+		task = pid_task(pid_prev, PIDTYPE_PID);
+		if (task && task->real_parent == start &&
+		    !(list_empty(&task->sibling))) {
+			/*
+			 * OK, ltes try the fastpath, we might
+			 * miss some freshly created children
+			 * here, but it was never promised to be
+			 * accurate.
+			 *
+			 * Also note if we have not enough rights
+			 * to access the next children pid we simply
+			 * fall into slow-search version.
+			 */
+			if (!list_is_last(&task->sibling, &start->children)) {
+				task = list_first_entry(&task->sibling,
+							struct task_struct, sibling);
+				if (ptrace_may_access(task, PTRACE_MODE_READ)) {
+					pid = get_pid(task_pid(task));
+					goto out;
+				}
+			} else
+				goto out;
+		}
+	}
+
+	list_for_each_entry(task, &start->children, sibling) {
+		if (pos-- == 0) {
+			if (ptrace_may_access(task, PTRACE_MODE_READ)) {
+				pid = get_pid(task_pid(task));
+				goto out;
+			} else {
+				/* Maybe we success with the next children */
+				pos++;
+			}
+		}
+	}
+out:
+	read_unlock(&tasklist_lock);
+	return pid;
+}
+
+static int children_seq_show(struct seq_file *seq, void *v)
+{
+	struct proc_pid_children_iter *iter = seq->private;
+	unsigned long pid = (unsigned long)pid_nr_ns(v, iter->pid_ns);
+
+	return seq_printf(seq, " %lu", pid);
+}
+
+static void *children_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	return get_children_pid(seq->private, NULL, *pos);
+}
+
+static void *children_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct proc_pid_children_iter *iter = seq->private;
+	struct pid *pid = NULL;
+
+	pid = get_children_pid(iter, v, *pos + 1);
+	if (!pid)
+		seq_printf(seq, "\n");
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
+	struct proc_pid_children_iter *iter = NULL;
+	struct task_struct *task = NULL;
+	int ret = 0;
+
+	task = get_proc_task(inode);
+	if (!task) {
+		ret = -ENOENT;
+		goto err;
+	}
+
+	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
+		ret = -EACCES;
+		goto err;
+	}
+
+	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ret = seq_open(file, &children_seq_ops);
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+		m->private = iter;
+
+		iter->pid_start = get_pid(task_pid(task));
+		iter->pid_ns = inode->i_sb->s_fs_info;
+	}
+
+err:
+	if (task)
+		put_task_struct(task);
+	if (ret)
+		kfree(iter);
+
+	return ret;
+}
+
+int children_seq_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *m = file->private_data;
+	struct proc_pid_children_iter *iter = m->private;
+
+	put_pid(iter->pid_start);
+	kfree(iter);
+
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
Index: linux-2.6.git/fs/proc/base.c
===================================================================
--- linux-2.6.git.orig/fs/proc/base.c
+++ linux-2.6.git/fs/proc/base.c
@@ -3497,6 +3497,7 @@ static const struct pid_entry tid_base_s
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
 	REG("maps",      S_IRUGO, proc_maps_operations),
+	REG("children",  S_IRUGO, proc_tid_children_operations),
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
