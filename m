Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965728Ab2EQQ0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:26:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32818 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760212Ab2EQQZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:25:39 -0400
Message-Id: <20120517162534.681059644@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 17 May 2012 20:07:40 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        linux-fsdevel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc 2/4] procfs: Convert /proc/pid/fdinfo/fd handling routines into seq-file with fdinfo helpers
References: <20120517160738.116113099@openvz.org>
Content-Disposition: inline; filename=seq-fdinfo-seq-ops-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts /proc/pid/fdinfo/fd handling routines to seq-files with
ability to plug in additional fdinfo helpers from other subsystems.

For example files created in eventfd/eventpoll/inotify subsystems might print
out additional information, not just file position and flags.

Still if there no fdinfo helpers registered then the output is well known
pos, flags pair.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/proc/fd.c            |  248 +++++++++++++++++++++++++++++++++++++-----------
 fs/proc/fd.h            |    1 
 include/linux/proc_fs.h |   31 ++++++
 3 files changed, 224 insertions(+), 56 deletions(-)

Index: linux-2.6.git/fs/proc/fd.c
===================================================================
--- linux-2.6.git.orig/fs/proc/fd.c
+++ linux-2.6.git/fs/proc/fd.c
@@ -6,66 +6,194 @@
 #include <linux/namei.h>
 #include <linux/pid.h>
 #include <linux/security.h>
+#include <linux/file.h>
+#include <linux/seq_file.h>
+#include <linux/spinlock.h>
 
 #include <linux/proc_fs.h>
 
 #include "internal.h"
+#include "fd.h"
 
-#define PROC_FDINFO_MAX 64
+static LIST_HEAD(fdinfo_helpers);
+static DEFINE_RWLOCK(fdinfo_helpers_lock);
 
-static int proc_fd_info(struct inode *inode, struct path *path, char *info)
+int proc_register_fdinfo_helper(struct proc_fdinfo_helper *helper)
 {
-	struct task_struct *task = get_proc_task(inode);
-	struct files_struct *files = NULL;
-	int fd = proc_fd(inode);
-	struct file *file;
+	struct proc_fdinfo_helper *item;
+	int ret = 0;
 
-	if (task) {
-		files = get_files_struct(task);
-		put_task_struct(task);
+	if (!helper->ops || !helper->probe)
+		return -EINVAL;
+
+	write_lock(&fdinfo_helpers_lock);
+	list_for_each_entry(item, &fdinfo_helpers, list) {
+		if (item == helper) {
+			pr_err("procfs fdinfo helper `%s' is already registered\n",
+			       item->name);
+			ret = -EINVAL;
+			break;
+		}
 	}
+	if (!ret)
+		list_add(&helper->list, &fdinfo_helpers);
+	write_unlock(&fdinfo_helpers_lock);
+	return ret;
+}
 
-	if (files) {
-		/*
-		 * We are not taking a ref to the file structure,
-		 * so we must hold ->file_lock.
-		 */
-		spin_lock(&files->file_lock);
-		file = fcheck_files(files, fd);
+void proc_unregister_fdinfo_helper(struct proc_fdinfo_helper *helper)
+{
+	struct proc_fdinfo_helper *item;
 
-		if (file) {
-			unsigned int f_flags;
-			struct fdtable *fdt;
+	write_lock(&fdinfo_helpers_lock);
+	list_for_each_entry(item, &fdinfo_helpers, list) {
+		if (item == helper) {
+			list_del(&item->list);
+			break;
+		}
+	}
+	write_unlock(&fdinfo_helpers_lock);
+}
 
-			fdt = files_fdtable(files);
-			f_flags = file->f_flags & ~O_CLOEXEC;
-			if (close_on_exec(fd, fdt))
-				f_flags |= O_CLOEXEC;
-
-			if (path) {
-				*path = file->f_path;
-				path_get(&file->f_path);
-			}
+static void assign_fdinfo_helper(struct proc_fdinfo_extra *extra)
+{
+	struct proc_fdinfo_helper *item;
+	read_lock(&fdinfo_helpers_lock);
+	list_for_each_entry(item, &fdinfo_helpers, list) {
+		if (item->probe(extra->fd_file)) {
+			extra->helper = item;
+			break;
+		}
+	}
+	read_unlock(&fdinfo_helpers_lock);
+}
+
+static void *seq_start(struct seq_file *m, loff_t *pos)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+
+	read_lock(&fdinfo_helpers_lock);
+
+	if (*pos > 0)
+		extra->hdr_shown = true;
+
+	return *pos == 0 ? extra :
+		(extra->helper ? extra->helper->ops->start(m, pos) : NULL);
+}
+
+static void seq_stop(struct seq_file *m, void *v)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+
+	if (extra->helper && extra->hdr_shown)
+		extra->helper->ops->stop(m, v);
+
+	read_unlock(&fdinfo_helpers_lock);
+}
+
+static void *seq_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+
+	if (extra->helper)
+		return extra->helper->ops->next(m, p, pos);
+
+	++*pos;
+	return NULL;
+}
+
+static int seq_show(struct seq_file *m, void *v)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+
+	if (extra->helper && extra->hdr_shown)
+		return extra->helper->ops->show(m, v);
+
+	seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
+		   (long long)extra->fd_file->f_pos,
+		   extra->f_flags);
+
+	extra->hdr_shown = 1;
+	return 0;
+}
+
+static const struct seq_operations fdinfo_seq_ops = {
+	.start	= seq_start,
+	.next	= seq_next,
+	.stop	= seq_stop,
+	.show	= seq_show,
+};
 
-			if (info)
-				snprintf(info, PROC_FDINFO_MAX,
-					 "pos:\t%lli\n"
-					 "flags:\t0%o\n",
-					 (long long)file->f_pos,
-					 f_flags);
+static int seq_fdinfo_open(struct inode *inode, struct file *file)
+{
+	struct files_struct *files = NULL;
+	struct proc_fdinfo_extra *extra;
+	struct task_struct *task;
+	struct seq_file *m;
+	int ret;
+
+	extra = kzalloc(sizeof(*extra), GFP_KERNEL);
+	if (!extra)
+		return -ENOMEM;
+	extra->inode = inode;
+
+	ret = seq_open(file, &fdinfo_seq_ops);
+	if (!ret) {
+		ret = -ENOENT;
+		m = file->private_data;
+		m->private = extra;
+
+		task = get_proc_task(inode);
+		if (task) {
+			files = get_files_struct(task);
+			put_task_struct(task);
+		}
+
+		if (files) {
+			int fd = proc_fd(inode);
 
+			spin_lock(&files->file_lock);
+			extra->fd_file = fcheck_files(files, fd);
+			if (extra->fd_file) {
+				struct fdtable *fdt = files_fdtable(files);
+
+				extra->f_flags = extra->fd_file->f_flags & ~O_CLOEXEC;
+				if (close_on_exec(fd, fdt))
+					extra->f_flags |= O_CLOEXEC;
+				get_file(extra->fd_file);
+				ret = 0;
+			}
 			spin_unlock(&files->file_lock);
 			put_files_struct(files);
-			return 0;
-		}
 
-		spin_unlock(&files->file_lock);
-		put_files_struct(files);
+			if (extra->fd_file)
+				assign_fdinfo_helper(extra);
+		}
 	}
 
-	return -ENOENT;
+	if (ret)
+		kfree(extra);
+	return ret;
 }
 
+static int seq_fdinfo_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *m = file->private_data;
+	struct proc_fdinfo_extra *extra = m->private;
+
+	put_filp(extra->fd_file);
+	kfree(m->private);
+
+	return seq_release(inode, file);
+}
+
+static const struct file_operations proc_fdinfo_file_operations = {
+	.open		= seq_fdinfo_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_fdinfo_release,
+};
+
 static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	struct files_struct *files;
@@ -120,7 +248,31 @@ static const struct dentry_operations ti
 
 static int proc_fd_link(struct dentry *dentry, struct path *path)
 {
-	return proc_fd_info(dentry->d_inode, path, NULL);
+	struct inode *inode = dentry->d_inode;
+	struct task_struct *task = get_proc_task(inode);
+	struct files_struct *files = NULL;
+	int fd = proc_fd(inode);
+	struct file *file;
+	int err = -ENOENT;
+
+	if (task) {
+		files = get_files_struct(task);
+		put_task_struct(task);
+	}
+
+	if (files) {
+		spin_lock(&files->file_lock);
+		file = fcheck_files(files, fd);
+		if (file) {
+			*path = file->f_path;
+			path_get(&file->f_path);
+		}
+		spin_unlock(&files->file_lock);
+		put_files_struct(files);
+		err = 0;
+	}
+
+	return err;
 }
 
 static struct dentry *
@@ -263,22 +415,6 @@ out_no_task:
 	return retval;
 }
 
-static ssize_t proc_fdinfo_read(struct file *file, char __user *buf,
-				      size_t len, loff_t *ppos)
-{
-	char tmp[PROC_FDINFO_MAX];
-	int err = proc_fd_info(file->f_path.dentry->d_inode, NULL, tmp);
-	if (!err)
-		err = simple_read_from_buffer(buf, len, ppos, tmp, strlen(tmp));
-	return err;
-}
-
-static const struct file_operations proc_fdinfo_file_operations = {
-	.open           = nonseekable_open,
-	.read		= proc_fdinfo_read,
-	.llseek		= no_llseek,
-};
-
 static int proc_readfd(struct file *filp, void *dirent, filldir_t filldir)
 {
 	return proc_readfd_common(filp, dirent, filldir, proc_fd_instantiate);
Index: linux-2.6.git/fs/proc/fd.h
===================================================================
--- linux-2.6.git.orig/fs/proc/fd.h
+++ linux-2.6.git/fs/proc/fd.h
@@ -1,6 +1,7 @@
 #ifndef __PROCFS_FD_H__
 #define __PROCFS_FD_H__
 
+#include <linux/types.h>
 #include <linux/fs.h>
 
 extern const struct file_operations proc_fd_operations;
Index: linux-2.6.git/include/linux/proc_fs.h
===================================================================
--- linux-2.6.git.orig/include/linux/proc_fs.h
+++ linux-2.6.git/include/linux/proc_fs.h
@@ -100,6 +100,25 @@ struct vmcore {
 	loff_t offset;
 };
 
+struct seq_operations;
+struct proc_fdinfo_helper {
+	struct list_head		list;
+	const char			*name;
+	const struct seq_operations	*ops;
+	int				(*probe)(struct file *file);
+	int				(*init)(void *private);
+	void				(*fini)(void *private);
+};
+
+struct proc_fdinfo_extra {
+	struct proc_fdinfo_helper	*helper;
+	struct inode			*inode;
+	struct file			*fd_file;
+	unsigned int			f_flags;
+	void				*private;
+	int				hdr_shown;
+};
+
 #ifdef CONFIG_PROC_FS
 
 extern void proc_root_init(void);
@@ -175,6 +194,9 @@ extern struct proc_dir_entry *proc_net_m
 
 extern struct file *proc_ns_fget(int fd);
 
+extern int proc_register_fdinfo_helper(struct proc_fdinfo_helper *helper);
+extern void proc_unregister_fdinfo_helper(struct proc_fdinfo_helper *helper);
+
 #else
 
 #define proc_net_fops_create(net, name, mode, fops)  ({ (void)(mode), NULL; })
@@ -229,6 +251,15 @@ static inline struct file *proc_ns_fget(
 	return ERR_PTR(-EINVAL);
 }
 
+static inline int proc_register_fdinfo_helper(struct proc_fdinfo_helper *helper)
+{
+	return -EINVAL;
+}
+
+static inline void proc_unregister_fdinfo_helper(struct proc_fdinfo_helper *helper)
+{
+}
+
 #endif /* CONFIG_PROC_FS */
 
 #if !defined(CONFIG_PROC_KCORE)

