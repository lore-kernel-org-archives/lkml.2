Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab2F0LGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 07:06:55 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39773 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab2F0LFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 07:05:18 -0400
Message-Id: <20120627110512.485189390@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 27 Jun 2012 15:01:18 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>
Subject: [rfc 2/7] procfs: Convert /proc/pid/fdinfo/ handling routines to seq-file
References: <20120627110116.201735815@openvz.org>
Content-Disposition: inline; filename=seq-fdinfo-seq-ops-4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts /proc/pid/fdinfo/ handling routines to seq-file which
is needed to extend seq operations and plug in auxiliary fdinfo provides
from subsystems like eventfd/eventpoll/fsnotify.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: James Bottomley <jbottomley@parallels.com>
---
 fs/proc/fd.c |  133 +++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 85 insertions(+), 48 deletions(-)

Index: linux-2.6.git/fs/proc/fd.c
===================================================================
--- linux-2.6.git.orig/fs/proc/fd.c
+++ linux-2.6.git/fs/proc/fd.c
@@ -6,61 +6,90 @@
 #include <linux/namei.h>
 #include <linux/pid.h>
 #include <linux/security.h>
+#include <linux/file.h>
+#include <linux/seq_file.h>
 
 #include <linux/proc_fs.h>
 
 #include "internal.h"
 #include "fd.h"
 
-#define PROC_FDINFO_MAX 64
+struct proc_fdinfo {
+	loff_t	f_pos;
+	int	f_flags;
+};
+
+static int seq_show(struct seq_file *m, void *v)
+{
+	struct proc_fdinfo *fdinfo = m->private;
+	seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
+		   (long long)fdinfo->f_pos,
+		   fdinfo->f_flags);
+	return 0;
+}
 
-static int proc_fd_info(struct inode *inode, struct path *path, char *info)
+static int seq_fdinfo_open(struct inode *inode, struct file *file)
 {
-	struct task_struct *task = get_proc_task(inode);
 	struct files_struct *files = NULL;
-	int fd = proc_fd(inode);
-	struct file *file;
+	struct proc_fdinfo *fdinfo = NULL;
+	struct task_struct *task;
+	int ret = -ENOENT;
 
+	fdinfo = kzalloc(sizeof(*fdinfo), GFP_KERNEL);
+	if (!fdinfo)
+		return -ENOMEM;
+
+	task = get_proc_task(inode);
 	if (task) {
 		files = get_files_struct(task);
 		put_task_struct(task);
 	}
+
 	if (files) {
-		/*
-		 * We are not taking a ref to the file structure, so we must
-		 * hold ->file_lock.
-		 */
+		int fd = proc_fd(inode);
+		struct file *fd_file;
+
 		spin_lock(&files->file_lock);
-		file = fcheck_files(files, fd);
-		if (file) {
-			unsigned int f_flags;
-			struct fdtable *fdt;
+		fd_file = fcheck_files(files, fd);
+		if (fd_file) {
+			struct fdtable *fdt = files_fdtable(files);
 
-			fdt = files_fdtable(files);
-			f_flags = file->f_flags & ~O_CLOEXEC;
+			fdinfo->f_flags = fd_file->f_flags & ~O_CLOEXEC;
 			if (close_on_exec(fd, fdt))
-				f_flags |= O_CLOEXEC;
-
-			if (path) {
-				*path = file->f_path;
-				path_get(&file->f_path);
-			}
-			if (info)
-				snprintf(info, PROC_FDINFO_MAX,
-					 "pos:\t%lli\n"
-					 "flags:\t0%o\n",
-					 (long long) file->f_pos,
-					 f_flags);
-			spin_unlock(&files->file_lock);
-			put_files_struct(files);
-			return 0;
+				fdinfo->f_flags |= O_CLOEXEC;
+			ret = 0;
 		}
 		spin_unlock(&files->file_lock);
 		put_files_struct(files);
 	}
-	return -ENOENT;
+
+	if (!ret) {
+		ret = single_open(file, seq_show, fdinfo);
+		if (!ret)
+			fdinfo = NULL;
+	}
+
+	kfree(fdinfo);
+	return ret;
 }
 
+static int seq_fdinfo_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *m = file->private_data;
+	struct proc_fdinfo *fdinfo = m->private;
+
+	kfree(fdinfo);
+
+	return single_release(inode, file);
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
@@ -130,7 +159,31 @@ static const struct dentry_operations ti
 
 static int proc_fd_link(struct dentry *dentry, struct path *path)
 {
-	return proc_fd_info(dentry->d_inode, path, NULL);
+       struct inode *inode = dentry->d_inode;
+       struct task_struct *task = get_proc_task(inode);
+       struct files_struct *files = NULL;
+       int fd = proc_fd(inode);
+       struct file *file;
+       int err = -ENOENT;
+
+       if (task) {
+	       files = get_files_struct(task);
+	       put_task_struct(task);
+       }
+
+       if (files) {
+	       spin_lock(&files->file_lock);
+	       file = fcheck_files(files, fd);
+	       if (file) {
+		       *path = file->f_path;
+		       path_get(&file->f_path);
+	       }
+	       spin_unlock(&files->file_lock);
+	       put_files_struct(files);
+	       err = 0;
+       }
+
+       return err;
 }
 
 static struct dentry *
@@ -245,22 +298,6 @@ out_no_task:
 	return retval;
 }
 
-static ssize_t proc_fdinfo_read(struct file *file, char __user *buf,
-				size_t len, loff_t *ppos)
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

