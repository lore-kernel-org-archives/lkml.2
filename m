Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1LHV3C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 16:29:02 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64200 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab1LHV27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 16:28:59 -0500
Date: Fri, 9 Dec 2011 01:28:53 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-ID: <20111208212853.GO21678@moon>
References: <20111206181026.GO29781@moon>
 <20111207185343.GA3209@redhat.com>
 <20111207190340.GP21678@moon>
 <20111208163535.GA25023@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208163535.GA25023@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 05:35:35PM +0100, Oleg Nesterov wrote:
...
> 
> However, ->children list is not rcu-safe, this means that even
> list_for_each() itself is not safe. Either you need tasklist or
> we can probably make it rcu-safe...
> 

Andrew, Oleg, does the below one look more less fine? Note the
tasklist_lock is back and it worries me a bit since I imagine
one could be endlessly reading some /proc/<pid>/children file
increasing contention over this lock on the whole system
(regardless the fact that it's take for read only).

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v4

There is no easy way to make a reverse parent->children chain
from arbitrary <pid> (while parent pid is provided in "PPid"
field of /proc/<pid>/status).

So instead of walking over all pids in the system to figure out which
children a task have -- we add explicit /proc/<pid>/children entry,
because kernel already has this kind of information but it is not
yet exported. This is a first level children, not the whole process
tree, neither the process threads are identified with this interface.

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

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
---
 Documentation/filesystems/proc.txt |   11 +++
 fs/proc/array.c                    |  127 +++++++++++++++++++++++++++++++++++++
 fs/proc/base.c                     |    1 
 fs/proc/internal.h                 |    6 +
 4 files changed, 145 insertions(+)

Index: linux-2.6.git/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.git.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.git/Documentation/filesystems/proc.txt
@@ -40,6 +40,7 @@ Table of Contents
   3.4	/proc/<pid>/coredump_filter - Core dump filtering settings
   3.5	/proc/<pid>/mountinfo - Information about mounts
   3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
+  3.7	/proc/<pid>/children - Information about task children
 
 
 ------------------------------------------------------------------------------
@@ -1545,3 +1546,13 @@ a task to set its own or one of its thre
 is limited in size compared to the cmdline value, so writing anything longer
 then the kernel's TASK_COMM_LEN (currently 16 chars) will result in a truncated
 comm value.
+
+3.7	/proc/<pid>/children - Information about task children
+--------------------------------------------------------------
+This file provides a fast way to retrieve first level children pids
+of a task pointed by <pid>. The format is a stream of pids separated
+by space with a new line at the end. If a task has no children at
+all -- only a new line returned. Note the "first level" here -- if
+a task child has own children they will not be printed there, one
+need to read /proc/<children-pid>/children to obtain such pids.
+The same applies to threads -- they are not counted here.
Index: linux-2.6.git/fs/proc/array.c
===================================================================
--- linux-2.6.git.orig/fs/proc/array.c
+++ linux-2.6.git/fs/proc/array.c
@@ -547,3 +547,130 @@ int proc_pid_statm(struct seq_file *m, s
 
 	return 0;
 }
+
+static struct list_head *
+children_get_at(struct proc_pid_children_iter *iter, loff_t pos)
+{
+	struct task_struct *t = iter->leader;
+	do {
+		struct list_head *p;
+		list_for_each(p, &t->children) {
+			if (pos-- == 0) {
+				iter->last = t;
+				return p;
+			}
+		}
+	} while_each_thread(iter->leader, t);
+
+	/* To make sure it's never in unknown state */
+	iter->last = NULL;
+
+	return NULL;
+}
+
+static int children_seq_show(struct seq_file *seq, void *v)
+{
+	struct task_struct *task = container_of(v, struct task_struct, sibling);
+	return seq_printf(seq, " %lu", (unsigned long)pid_vnr(task_pid(task)));
+}
+
+static void *children_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct proc_pid_children_iter *iter = seq->private;
+
+	read_lock(&tasklist_lock);
+	return children_get_at(iter, *pos);
+}
+
+static void *children_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct proc_pid_children_iter *iter = seq->private;
+	struct list_head *next = NULL;
+
+	if (iter->last) {
+		if (list_is_last(v, &iter->last->children)) {
+			while_each_thread(iter->leader, iter->last) {
+				if (!list_empty(&iter->last->children)) {
+					next = iter->last->children.next;
+					goto found;
+				}
+			}
+			iter->last = NULL;
+		} else
+			next = ((struct list_head *)v)->next;
+	}
+
+found:
+	++*pos;
+	if (!next)
+		seq_printf(seq, "\n");
+	return next;
+}
+
+static void children_seq_stop(struct seq_file *seq, void *v)
+{
+	struct proc_pid_children_iter *iter = seq->private;
+
+	iter->last = NULL;
+	read_unlock(&tasklist_lock);
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
+	int ret;
+
+	ret = -ENOMEM;
+	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		goto err;
+
+	ret = -ENOENT;
+	task = get_proc_task(inode);
+	if (!task)
+		goto err;
+
+	ret = seq_open(file, &children_seq_ops);
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+		m->private = iter;
+		iter->leader = task;
+		iter->last = task;
+	}
+
+err:
+	if (ret) {
+		if (task)
+			put_task_struct(task);
+		kfree(iter);
+	}
+
+	return ret;
+}
+
+int children_seq_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *m = file->private_data;
+	struct proc_pid_children_iter *iter = m->private;
+
+	put_task_struct(iter->leader);
+	kfree(iter);
+	seq_release(inode, file);
+
+	return 0;
+}
+
+const struct file_operations proc_pid_children_operations = {
+	.open    = children_seq_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = children_seq_release,
+};
Index: linux-2.6.git/fs/proc/base.c
===================================================================
--- linux-2.6.git.orig/fs/proc/base.c
+++ linux-2.6.git/fs/proc/base.c
@@ -3204,6 +3204,7 @@ static const struct pid_entry tgid_base_
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
+	REG("children",   S_IRUGO, proc_pid_children_operations),
 	REG("maps",       S_IRUGO, proc_maps_operations),
 #ifdef CONFIG_NUMA
 	REG("numa_maps",  S_IRUGO, proc_numa_maps_operations),
Index: linux-2.6.git/fs/proc/internal.h
===================================================================
--- linux-2.6.git.orig/fs/proc/internal.h
+++ linux-2.6.git/fs/proc/internal.h
@@ -53,6 +53,12 @@ extern int proc_pid_statm(struct seq_fil
 				struct pid *pid, struct task_struct *task);
 extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
 
+struct proc_pid_children_iter {
+	struct task_struct *leader;
+	struct task_struct *last;
+};
+
+extern const struct file_operations proc_pid_children_operations;
 extern const struct file_operations proc_maps_operations;
 extern const struct file_operations proc_numa_maps_operations;
 extern const struct file_operations proc_smaps_operations;
