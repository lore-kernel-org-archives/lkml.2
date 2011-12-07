Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500Ab1LGVwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:52:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36450 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027Ab1LGVwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:52:34 -0500
Date: Thu, 8 Dec 2011 01:52:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-ID: <20111207215228.GU21678@moon>
References: <20111206181026.GO29781@moon>
 <20111207185343.GA3209@redhat.com>
 <20111207190340.GP21678@moon>
 <20111207191916.GR21678@moon>
 <20111207203450.GS21678@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207203450.GS21678@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 12:34:50AM +0400, Cyrill Gorcunov wrote:
...
> 
> So while adding new task to a list is not a problem (the reader
> will simply not notice it) removing task from a list is a bit
> tricky, but as far as I see switch_task_namespaces (from exit_notify)
> uses synchronize_rcu as well as release_task calls for call_rcu
> for put_task_struct) so I think we will not get any wrong dereference
> in
> 
> static int children_seq_show(struct seq_file *seq, void *v)
> {
> 	struct task_struct *task = container_of(v, struct task_struct, sibling);
> 	return seq_printf(seq, " %lu", (unsigned long)pid_vnr(task_pid(task)));
> }
> 
> while we're in rcu reader section. I might be wrong of course, so
> please verify this claim.
> 

An updated version is below (I've updated changelog and docs as well).
Please review if you get a chance. Complains are welcome of course.

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

Note that filling user-space buffer is done in iterative manner
where each iteration is protected via RCU read lock, which means
if between iterations a new task is added it might be missed in
output and to have a consistent image of which children are really
present in system the task should be either frozen or stopped
together with all children.

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
   nit pointed by Tejun
 - documentation update

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
---
 Documentation/filesystems/proc.txt |   19 +++++++++
 fs/proc/array.c                    |   72 +++++++++++++++++++++++++++++++++++++
 fs/proc/base.c                     |    1 
 fs/proc/internal.h                 |    1 
 4 files changed, 93 insertions(+)

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
@@ -1545,3 +1546,21 @@ a task to set its own or one of its thre
 is limited in size compared to the cmdline value, so writing anything longer
 then the kernel's TASK_COMM_LEN (currently 16 chars) will result in a truncated
 comm value.
+
+3.7	/proc/<pid>/children - Information about task children
+--------------------------------------------------------------
+This file provides a fast way to retrieve first level children pids
+of the task pointed by <pid>. The format is a stream of pids separated
+by space with a new line at the end. If a task has no children at
+all -- only a new line returned. Note the "first level" here -- if
+a task child has own children they will not be printed there, one
+need to read /proc/<children-pid>/children to obtain such pids.
+The same applies to threads -- they are not counted via this interface,
+one need to read /proc/<pid>/status to find all threads the task created.
+
+Note that filling user-space buffer is done in iterative manner where
+each iteration is protected via RCU read lock, which means if between
+iterations a new task is added it might be missed in output and
+to have a consistent image of which children are really present in
+system the task should be either frozen or stopped together with
+all children.
Index: linux-2.6.git/fs/proc/array.c
===================================================================
--- linux-2.6.git.orig/fs/proc/array.c
+++ linux-2.6.git/fs/proc/array.c
@@ -547,3 +547,75 @@ int proc_pid_statm(struct seq_file *m, s
 
 	return 0;
 }
+
+static int children_seq_show(struct seq_file *seq, void *v)
+{
+	struct task_struct *task = container_of(v, struct task_struct, sibling);
+	return seq_printf(seq, " %lu", (unsigned long)pid_vnr(task_pid(task)));
+}
+
+static void *children_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct task_struct *task = seq->private;
+
+	rcu_read_lock();
+	return seq_list_start(&task->children, *pos);
+}
+
+static void *children_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct task_struct *task = seq->private;
+	struct list_head *head;
+
+	head = seq_list_next(v, &task->children, pos);
+	if (!head)
+		seq_printf(seq, "\n");
+	return head;
+}
+
+static void children_seq_stop(struct seq_file *seq, void *v)
+{
+	rcu_read_unlock();
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
+	struct task_struct *task;
+	int ret;
+
+	task = get_proc_task(inode);
+	if (!task)
+		return -ENOENT;
+
+	ret = seq_open(file, &children_seq_ops);
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+		m->private = task;
+	} else
+		put_task_struct(task);
+
+	return ret;
+}
+int children_seq_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *m = file->private_data;
+	if (m->private)
+		put_task_struct(m->private);
+
+	seq_release(inode, file);
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
@@ -53,6 +53,7 @@ extern int proc_pid_statm(struct seq_fil
 				struct pid *pid, struct task_struct *task);
 extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
 
+extern const struct file_operations proc_pid_children_operations;
 extern const struct file_operations proc_maps_operations;
 extern const struct file_operations proc_numa_maps_operations;
 extern const struct file_operations proc_smaps_operations;
