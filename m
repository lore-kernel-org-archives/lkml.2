Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1LGJlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:41:55 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51140 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab1LGJlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:41:49 -0500
Date: Wed, 7 Dec 2011 13:41:44 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-ID: <20111207094144.GB21678@moon>
References: <20111206181026.GO29781@moon>
 <20111206143313.ac2e7287.akpm@linux-foundation.org>
 <20111206223558.GQ29781@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206223558.GQ29781@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 02:35:58AM +0400, Cyrill Gorcunov wrote:
> On Tue, Dec 06, 2011 at 02:33:13PM -0800, Andrew Morton wrote:
> ...
> > 
> > It's also worth adding a warning about this into the documentation for
> > this procfs file.  Documentation which this patch forgot to provide,
> > btw!
> > 
> > 
> 
> Yes, thanks for comments Andrew, I already got the feeling that I've
> missed documentation update from the start_brk /proc patch ;)
> 
> I'll address all issues, thanks!
> 

I hope this one addresses all nits.

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v3

There is no easy way to make a reverse parent->children chain
from a task status, in turn children->parent provided with "PPid"
field.

So instead of walking over all pids in system to figure out what
children a task have -- we add explicit /proc/<pid>/children entry,
since kernel already has this kind of information but it is not
yet exported.

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
 - Update changelog and documentation

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
---
 Documentation/filesystems/proc.txt |   15 ++++++++
 fs/proc/array.c                    |   66 +++++++++++++++++++++++++++++++++++++
 fs/proc/base.c                     |    1 
 fs/proc/internal.h                 |    1 
 4 files changed, 83 insertions(+)

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
@@ -1545,3 +1546,17 @@ a task to set its own or one of its thre
 is limited in size compared to the cmdline value, so writing anything longer
 then the kernel's TASK_COMM_LEN (currently 16 chars) will result in a truncated
 comm value.
+
+3.7	/proc/<pid>/children - Information about task children
+--------------------------------------------------------------
+This file provides a fast way to retrieve children pids of the
+task pointed by <pid>. The format is a stream of pids separated
+by space with a new line at the end. If a task has no children at
+all -- only a new line returned.
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
@@ -547,3 +547,69 @@ int proc_pid_statm(struct seq_file *m, s
 
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
+	struct task_struct *task;
+
+	rcu_read_lock();
+	task = seq->private;
+	if (task)
+		return seq_list_start(&task->children, *pos);
+
+	return NULL;
+}
+
+static void *children_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct task_struct *task = seq->private;
+	if (task)
+		return seq_list_next(v, &task->children, pos);
+	return NULL;
+}
+
+static void children_seq_stop(struct seq_file *seq, void *v)
+{
+	rcu_read_unlock();
+	seq_printf(seq, "\n");
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
+	int ret = seq_open(file, &children_seq_ops);
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+		m->private = (void *)get_proc_task(inode);
+	}
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
