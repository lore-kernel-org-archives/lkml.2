Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030327Ab2HPQhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:37:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53920 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030207Ab2HPQhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:37:38 -0400
Message-Id: <20120816163734.339551805@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 16 Aug 2012 20:34:10 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 2/7] procfs: Convert /proc/pid/fdinfo/ handling routines to seq-file v2
References: <20120816163408.625246843@openvz.org>
Content-Disposition: inline; filename=seq-fdinfo-seq-ops-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts /proc/pid/fdinfo/ handling routines to seq-file which
is needed to extend seq operations and plug in auxiliary fdinfo provides
from subsystems like eventfd/eventpoll/fsnotify.

Note the proc_fd_link no longer call for proc_fd_info, simply because
proc_fd_info is converted to seq_fdinfo_open (which is seq-file open()
prototype).

v2 (by Al Viro):
 - Don't use helper function with optional arguments, thus proc_fd_info get deprecated
 - Use proc_fdinfo structure with seq_file embedded, thus we can use container_of helper
 - Use fput to free reference to the file we've grabbed

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
---
 fs/proc/fd.c |  145 ++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 99 insertions(+), 46 deletions(-)

Index: linux-2.6.git/fs/proc/fd.c
===================================================================
--- linux-2.6.git.orig/fs/proc/fd.c
+++ linux-2.6.git/fs/proc/fd.c
@@ -6,61 +6,105 @@
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
+	struct seq_file		m;
+	struct file		*fd_file;
+	int			f_flags;
+};
+
+static int seq_show(struct seq_file *m, void *v)
+{
+	struct proc_fdinfo *fdinfo = container_of(m, struct proc_fdinfo, m);
+	seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
+		   (long long)fdinfo->fd_file->f_pos, fdinfo->f_flags);
+	return 0;
+}
 
-static int proc_fd_info(struct inode *inode, struct path *path, char *info)
+static int seq_fdinfo_open(struct inode *inode, struct file *file)
 {
-	struct task_struct *task = get_proc_task(inode);
+	struct proc_fdinfo *fdinfo = NULL;
 	struct files_struct *files = NULL;
-	int fd = proc_fd(inode);
-	struct file *file;
+	struct task_struct *task;
+	struct file *fd_file;
+	int f_flags, ret;
 
+	ret = -ENOENT;
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
+			f_flags = fd_file->f_flags & ~O_CLOEXEC;
 			if (close_on_exec(fd, fdt))
 				f_flags |= O_CLOEXEC;
 
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
+			get_file(fd_file);
+			ret = 0;
 		}
 		spin_unlock(&files->file_lock);
+
 		put_files_struct(files);
 	}
-	return -ENOENT;
+
+	if (ret)
+		return ret;
+
+	ret = -ENOMEM;
+	fdinfo = kmalloc(sizeof(*fdinfo), GFP_KERNEL);
+	if (!fdinfo)
+		goto err_put;
+
+	fdinfo->fd_file = fd_file;
+	fdinfo->f_flags = f_flags;
+	file->private_data = &fdinfo->m;
+
+	ret = single_open(file, seq_show, NULL);
+	if (ret)
+		goto err_free;
+
+	return 0;
+
+err_free:
+	kfree(fdinfo);
+err_put:
+	fput(fd_file);
+	return ret;
 }
 
+static int seq_fdinfo_release(struct inode *inode, struct file *file)
+{
+	struct proc_fdinfo *fdinfo =
+		container_of((struct seq_file *)file->private_data,
+			     struct proc_fdinfo, m);
+	fput(fdinfo->fd_file);
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
 static int tid_fd_revalidate(struct dentry *dentry, unsigned int flags)
 {
 	struct files_struct *files;
@@ -130,7 +174,32 @@ static const struct dentry_operations ti
 
 static int proc_fd_link(struct dentry *dentry, struct path *path)
 {
-	return proc_fd_info(dentry->d_inode, path, NULL);
+	struct files_struct *files = NULL;
+	struct task_struct *task;
+	int ret = -ENOENT;
+
+	task = get_proc_task(dentry->d_inode);
+	if (task) {
+		files = get_files_struct(task);
+		put_task_struct(task);
+	}
+
+	if (files) {
+		int fd = proc_fd(dentry->d_inode);
+		struct file *fd_file;
+
+		spin_lock(&files->file_lock);
+		fd_file = fcheck_files(files, fd);
+		if (fd_file) {
+			*path = fd_file->f_path;
+			path_get(&fd_file->f_path);
+			ret = 0;
+		}
+		spin_unlock(&files->file_lock);
+		put_files_struct(files);
+	}
+
+	return ret;
 }
 
 static struct dentry *
@@ -245,22 +314,6 @@ out_no_task:
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

