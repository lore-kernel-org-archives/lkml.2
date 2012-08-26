Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab2HZO21 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 10:28:27 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55439 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab2HZO2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 10:28:24 -0400
Date: Sun, 26 Aug 2012 18:28:20 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 2/9] procfs: Convert /proc/pid/fdinfo/ handling routines
 to seq-file v2
Message-ID: <20120826142820.GA16038@moon>
References: <20120823104323.040550004@openvz.org>
 <20120823104725.686586462@openvz.org>
 <20120826024653.GY23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120826024653.GY23464@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 03:46:53AM +0100, Al Viro wrote:
> 
> IMO doing that at open() time is just a headache for no good reason -
> resolving descriptor to struct file * at read() time as we do now
> is much saner.  Better do that in your ->show(), since you are using
> a single-shot iterator anyway...

Al, the updated version is below. I suppose I can grab proc inode then
and lookup for file position and flags at show method. (I remember
what you've said about O_CLOEXEC bit, but I'll address this in
another patch).
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: procfs: Convert /proc/pid/fdinfo/ handling routines to seq-file v3

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

v3 (by Al Viro):
 - Don't grab struct file at read(2) time since it breaks ABI, instead all
   manipulations should be done at ->show() call.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Matthew Helsley <matt.helsley@gmail.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/proc/fd.c |  142 +++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 95 insertions(+), 47 deletions(-)

Index: linux-2.6.git/fs/proc/fd.c
===================================================================
--- linux-2.6.git.orig/fs/proc/fd.c
+++ linux-2.6.git/fs/proc/fd.c
@@ -6,61 +6,100 @@
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
+	struct seq_file	m;
+	struct inode	*inode;
+};
 
-static int proc_fd_info(struct inode *inode, struct path *path, char *info)
+static int seq_show(struct seq_file *m, void *v)
 {
-	struct task_struct *task = get_proc_task(inode);
+	struct proc_fdinfo *fdinfo = container_of(m, struct proc_fdinfo, m);
 	struct files_struct *files = NULL;
-	int fd = proc_fd(inode);
-	struct file *file;
+	int f_flags = 0, ret = -ENOENT;
+	struct file *file = NULL;
+	struct task_struct *task;
+
+	task = get_proc_task(fdinfo->inode);
+	if (!task)
+		return -ENOENT;
+
+	files = get_files_struct(task);
+	put_task_struct(task);
 
-	if (task) {
-		files = get_files_struct(task);
-		put_task_struct(task);
-	}
 	if (files) {
-		/*
-		 * We are not taking a ref to the file structure, so we must
-		 * hold ->file_lock.
-		 */
+		int fd = proc_fd(fdinfo->inode);
+
 		spin_lock(&files->file_lock);
 		file = fcheck_files(files, fd);
 		if (file) {
-			unsigned int f_flags;
-			struct fdtable *fdt;
+			struct fdtable *fdt = files_fdtable(files);
 
-			fdt = files_fdtable(files);
 			f_flags = file->f_flags & ~O_CLOEXEC;
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
+			get_file(file);
+			ret = 0;
 		}
 		spin_unlock(&files->file_lock);
 		put_files_struct(files);
 	}
-	return -ENOENT;
+
+	if (!ret) {
+                seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
+			   (long long)file->f_pos, f_flags);
+		fput(file);
+	}
+
+	return ret;
+}
+
+static int seq_fdinfo_open(struct inode *inode, struct file *file)
+{
+	struct proc_fdinfo *fdinfo;
+	int ret = 0;
+
+	fdinfo = kmalloc(sizeof(*fdinfo), GFP_KERNEL);
+	if (!fdinfo)
+		return -ENOMEM;
+
+	ihold(inode);
+	fdinfo->inode = inode;
+
+	file->private_data = &fdinfo->m;
+	ret = single_open(file, seq_show, NULL);
+	if (ret) {
+		iput(inode);
+		kfree(fdinfo);
+	}
+
+	return ret;
+}
+
+static int seq_fdinfo_release(struct inode *inode, struct file *file)
+{
+	struct proc_fdinfo *fdinfo =
+		container_of((struct seq_file *)file->private_data,
+			     struct proc_fdinfo, m);
+	iput(fdinfo->inode);
+	return single_release(inode, file);
 }
 
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
@@ -130,7 +169,32 @@ static const struct dentry_operations ti
 
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
@@ -245,22 +309,6 @@ out_no_task:
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
