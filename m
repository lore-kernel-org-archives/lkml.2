Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2AXIvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 03:51:09 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37091 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab2AXIvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 03:51:06 -0500
Date: Tue, 24 Jan 2012 12:51:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] fs, proc: Introduce /proc/<pid>/task/<tid>/children
 entry v8
Message-ID: <20120124085100.GH29735@moon>
References: <20120123142036.025893883@openvz.org>
 <20120123142436.181674896@openvz.org>
 <20120124110730.a3536647.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124065338.GB29735@moon>
 <20120124160709.e05c51b5.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124160709.e05c51b5.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 04:07:09PM +0900, KAMEZAWA Hiroyuki wrote:
> On Tue, 24 Jan 2012 10:53:38 +0400
> Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > On Tue, Jan 24, 2012 at 11:07:30AM +0900, KAMEZAWA Hiroyuki wrote:
> > ...
> > > 
> > > From viewpoint I played with seq_file, yesterday.
> > > 
> > > > +static void *children_seq_start(struct seq_file *seq, loff_t *pos)
> > > > +{
> > > > +	return get_children_pid(seq->private, NULL, *pos);
> > > > +}
> > > > +
> > > > +static void *children_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> > > > +{
> > > > +	struct pid *pid = NULL;
> > > > +
> > > > +	pid = get_children_pid(seq->private, v, *pos + 1);
> > > > +	if (!pid)
> > > > +		seq_printf(seq, "\n");
> > > > +	put_pid(v);
> > > 
> > > Because seq_printf() may fail. This seems dangeorus.
> > > 
> > > If seq_printf() fails and returns NULL, "\n" will not be
> > > printed out and user land parser will go wrong.
> > >
> > 
> > Hmm. But userspace app will get eof, so frankly I don't see
> > a problem here. Or maybe I miss something?
> > 
> 
> Userspace need to take care of whether there may be"\n" or not even
> if read() returns EOF.
> As an interface, it's BUG to say "\n" will be there if you're lucky!"
> (*) I know script language can handle this but we shouldn't assume that.
> 
> How about just remove "\n" at EOF  ? I think it's unnecessary.
> 

This one should fit both "%d " and no "\n" requirements.

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, proc: Introduce /proc/<pid>/task/<tid>/children entry v9

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
 fs/proc/array.c                    |  121 +++++++++++++++++++++++++++++++++++++
 fs/proc/base.c                     |    1 
 fs/proc/internal.h                 |    1 
 4 files changed, 141 insertions(+)

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
@@ -547,3 +547,124 @@ int proc_pid_statm(struct seq_file *m, s
 
 	return 0;
 }
+
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
Index: linux-2.6.git/fs/proc/base.c
===================================================================
--- linux-2.6.git.orig/fs/proc/base.c
+++ linux-2.6.git/fs/proc/base.c
@@ -3384,6 +3384,7 @@ static const struct pid_entry tid_base_s
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
