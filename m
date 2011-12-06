Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab1LFSKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:10:35 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61971 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab1LFSKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:10:33 -0500
Date: Tue, 6 Dec 2011 22:10:26 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Andrew Vagin <avagin@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-ID: <20111206181026.GO29781@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no easy way to make a reverse parent->children chain
from the task status, in turn children->parent provided with "PPid"
field.

So instead of walking over all pids in system to figure out what
children the task have -- we add explicit /proc/<pid>/children entry,
since kernel already knows this kind of information but it was not
yet exported.

v2:
 - Kame suggested to use a separated /proc/<pid>/children entry
   instead of poking /proc/<pid>/status
 - Andew suggested to use rcu facility instead of locking
   tasklist_lock
 - Tejun pointed that non-seekable seq file might not be
   enough for tasks with large number of children

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
---

Please review. I hope I didn't miss anything here.

 fs/proc/array.c    |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/base.c     |    1 
 fs/proc/internal.h |    1 
 3 files changed, 68 insertions(+)

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
+	return seq_printf(seq, " %d", pid_vnr(task_pid(task)));
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
