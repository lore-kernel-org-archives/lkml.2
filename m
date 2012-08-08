Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab2HHFGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 01:06:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:27266 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab2HHFF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 01:05:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,730,1336374000"; 
   d="scan'208";a="182983469"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Rientjes <rientjes@google.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, qiaowei.ren@intel.com
Subject: [PATCH 1/1] proc: add /proc/pid/shmaps
Date: Wed,  8 Aug 2012 21:04:19 +0800
Message-Id: <1344431059-12514-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a shmaps entry to /proc/pid: show information about shared memory in an address space.

People that use shared memory and want to perform an analyzing about it. For example, judge whether any memory address is shared. This file just contains 'share' part of /proc/pid/maps now. There are too many contents in maps, and so we have to do a lot of analysis to obtain relative information every time.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 fs/proc/base.c     |    2 ++
 fs/proc/internal.h |    2 ++
 fs/proc/task_mmu.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1b6c84c..d49057a 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3047,6 +3047,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
 	REG("maps",       S_IRUGO, proc_pid_maps_operations),
+	REG("shmaps",      S_IRUGO, proc_pid_shmaps_operations),
 #ifdef CONFIG_NUMA
 	REG("numa_maps",  S_IRUGO, proc_pid_numa_maps_operations),
 #endif
@@ -3411,6 +3412,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
 	REG("maps",      S_IRUGO, proc_tid_maps_operations),
+	REG("shmaps",      S_IRUGO, proc_tid_shmaps_operations),
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	REG("children",  S_IRUGO, proc_tid_children_operations),
 #endif
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index e1167a1..3f2882c 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -57,6 +57,8 @@ extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
 extern const struct file_operations proc_tid_children_operations;
 extern const struct file_operations proc_pid_maps_operations;
 extern const struct file_operations proc_tid_maps_operations;
+extern const struct file_operations proc_pid_shmaps_operations;
+extern const struct file_operations proc_tid_shmaps_operations;
 extern const struct file_operations proc_pid_numa_maps_operations;
 extern const struct file_operations proc_tid_numa_maps_operations;
 extern const struct file_operations proc_pid_smaps_operations;
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 4540b8f..59daebf 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -210,7 +210,8 @@ static int do_maps_open(struct inode *inode, struct file *file,
 }
 
 static void
-show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
+show_map_vma(struct seq_file *m, struct vm_area_struct *vma,
+	     int is_pid, int only_shmap)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
@@ -224,6 +225,9 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 	int len;
 	const char *name = NULL;
 
+	if (only_shmap && !(flags & VM_MAYSHARE))
+		return;
+
 	if (file) {
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
@@ -300,13 +304,13 @@ done:
 	seq_putc(m, '\n');
 }
 
-static int show_map(struct seq_file *m, void *v, int is_pid)
+static int show_map(struct seq_file *m, void *v, int is_pid, int only_shmap)
 {
 	struct vm_area_struct *vma = v;
 	struct proc_maps_private *priv = m->private;
 	struct task_struct *task = priv->task;
 
-	show_map_vma(m, vma, is_pid);
+	show_map_vma(m, vma, is_pid, only_shmap);
 
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task->mm))
@@ -316,12 +320,12 @@ static int show_map(struct seq_file *m, void *v, int is_pid)
 
 static int show_pid_map(struct seq_file *m, void *v)
 {
-	return show_map(m, v, 1);
+	return show_map(m, v, 1, 0);
 }
 
 static int show_tid_map(struct seq_file *m, void *v)
 {
-	return show_map(m, v, 0);
+	return show_map(m, v, 0, 0);
 }
 
 static const struct seq_operations proc_pid_maps_op = {
@@ -363,6 +367,57 @@ const struct file_operations proc_tid_maps_operations = {
 };
 
 /*
+ * /proc/pid/shmaps - just contains 'share' part of /proc/maps
+ */
+static int show_pid_shmap(struct seq_file *m, void *v)
+{
+	return show_map(m, v, 1, 1);
+}
+
+static int show_tid_shmap(struct seq_file *m, void *v)
+{
+	return show_map(m, v, 0, 1);
+}
+
+static const struct seq_operations proc_pid_shmaps_op = {
+	.start	= m_start,
+	.next	= m_next,
+	.stop	= m_stop,
+	.show	= show_pid_shmap
+};
+
+static const struct seq_operations proc_tid_shmaps_op = {
+	.start	= m_start,
+	.next	= m_next,
+	.stop	= m_stop,
+	.show	= show_tid_shmap
+};
+
+static int pid_shmaps_open(struct inode *inode, struct file *file)
+{
+	return do_maps_open(inode, file, &proc_pid_shmaps_op);
+}
+
+static int tid_shmaps_open(struct inode *inode, struct file *file)
+{
+	return do_maps_open(inode, file, &proc_tid_shmaps_op);
+}
+
+const struct file_operations proc_pid_shmaps_operations = {
+	.open		= pid_shmaps_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release_private,
+};
+
+const struct file_operations proc_tid_shmaps_operations = {
+	.open		= tid_shmaps_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release_private,
+};
+
+/*
  * Proportional Set Size(PSS): my share of RSS.
  *
  * PSS of a process is the count of pages it has in memory, where each
@@ -498,7 +553,7 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 		walk_page_range(vma->vm_start, vma->vm_end, &smaps_walk);
 
-	show_map_vma(m, vma, is_pid);
+	show_map_vma(m, vma, is_pid, 0);
 
 	seq_printf(m,
 		   "Size:           %8lu kB\n"
-- 
1.7.9.5

