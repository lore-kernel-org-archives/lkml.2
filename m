Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2HOJZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 05:25:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43550 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab2HOJYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 05:24:13 -0400
Message-Id: <20120815092409.424674336@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 15 Aug 2012 13:21:18 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 2/8] procfs: Convert /proc/pid/fdinfo/ handling routines to seq-file
References: <20120815092116.700948346@openvz.org>
Content-Disposition: inline; filename=seq-fdinfo-seq-ops-6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts /proc/pid/fdinfo/ handling routines to seq-file which
is needed to extend seq operations and plug in auxiliary fdinfo provides
from subsystems like eventfd/eventpoll/fsnotify.

Note the proc_fd_link no longer call for proc_fd_info, simply because
proc_fd_info is converted to seq_fdinfo_open (which is seq-file open()
prototype).

Also, to eliminate code duplication (and Pavel's concerns) the fdinfo_open_helper
function introduced which is used in both seq_fdinfo_open and proc_fd_link.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
---
 fs/proc/fd.c |  123 +++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 75 insertions(+), 48 deletions(-)

Index: linux-2.6.git/fs/proc/fd.c
===================================================================
--- linux-2.6.git.orig/fs/proc/fd.c
+++ linux-2.6.git/fs/proc/fd.c
@@ -6,61 +6,104 @@
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
 
-static int proc_fd_info(struct inode *inode, struct path *path, char *info)
+static int fdinfo_open_helper(struct inode *inode, int *f_flags, struct path *path)
 {
-	struct task_struct *task = get_proc_task(inode);
 	struct files_struct *files = NULL;
-	int fd = proc_fd(inode);
-	struct file *file;
+	struct task_struct *task;
+	int ret = -ENOENT;
 
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
-		spin_lock(&files->file_lock);
-		file = fcheck_files(files, fd);
-		if (file) {
-			unsigned int f_flags;
-			struct fdtable *fdt;
-
-			fdt = files_fdtable(files);
-			f_flags = file->f_flags & ~O_CLOEXEC;
-			if (close_on_exec(fd, fdt))
-				f_flags |= O_CLOEXEC;
+		int fd = proc_fd(inode);
+		struct file *fd_file;
 
+		spin_lock(&files->file_lock);
+		fd_file = fcheck_files(files, fd);
+		if (fd_file) {
+			if (f_flags) {
+				struct fdtable *fdt = files_fdtable(files);
+
+				*f_flags = fd_file->f_flags & ~O_CLOEXEC;
+				if (close_on_exec(fd, fdt))
+					*f_flags |= O_CLOEXEC;
+			}
 			if (path) {
-				*path = file->f_path;
-				path_get(&file->f_path);
+				*path = fd_file->f_path;
+				path_get(&fd_file->f_path);
 			}
-			if (info)
-				snprintf(info, PROC_FDINFO_MAX,
-					 "pos:\t%lli\n"
-					 "flags:\t0%o\n",
-					 (long long) file->f_pos,
-					 f_flags);
-			spin_unlock(&files->file_lock);
-			put_files_struct(files);
-			return 0;
+			ret = 0;
 		}
 		spin_unlock(&files->file_lock);
 		put_files_struct(files);
 	}
-	return -ENOENT;
+
+	return ret;
 }
 
+static int seq_show(struct seq_file *m, void *v)
+{
+	struct proc_fdinfo *fdinfo = m->private;
+	seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
+		   (long long)fdinfo->f_pos,
+		   fdinfo->f_flags);
+	return 0;
+}
+
+static int seq_fdinfo_open(struct inode *inode, struct file *file)
+{
+	struct proc_fdinfo *fdinfo = NULL;
+	int ret = -ENOENT;
+
+	fdinfo = kzalloc(sizeof(*fdinfo), GFP_KERNEL);
+	if (!fdinfo)
+		return -ENOMEM;
+
+	ret = fdinfo_open_helper(inode, &fdinfo->f_flags, NULL);
+	if (!ret) {
+		ret = single_open(file, seq_show, fdinfo);
+		if (!ret)
+			fdinfo = NULL;
+	}
+
+	kfree(fdinfo);
+	return ret;
+}
+
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
 static int tid_fd_revalidate(struct dentry *dentry, unsigned int flags)
 {
 	struct files_struct *files;
@@ -130,7 +173,7 @@ static const struct dentry_operations ti
 
 static int proc_fd_link(struct dentry *dentry, struct path *path)
 {
-	return proc_fd_info(dentry->d_inode, path, NULL);
+	return fdinfo_open_helper(dentry->d_inode, NULL, path);
 }
 
 static struct dentry *
@@ -245,22 +288,6 @@ out_no_task:
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

