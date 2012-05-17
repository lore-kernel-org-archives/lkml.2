Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966505Ab2EQVzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 17:55:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41392 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965954Ab2EQVzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 17:55:01 -0400
Date: Fri, 18 May 2012 01:49:08 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [rfc 2/4] procfs: Convert /proc/pid/fdinfo/fd handling routines
 into seq-file with fdinfo helpers
Message-ID: <20120517214908.GD10530@moon>
References: <20120517160738.116113099@openvz.org>
 <20120517162534.681059644@openvz.org>
 <4FB52804.8090004@parallels.com>
 <20120517173848.GE6183@moon>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20120517173848.GE6183@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 17, 2012 at 09:38:48PM +0400, Cyrill Gorcunov wrote:
> On Thu, May 17, 2012 at 08:32:04PM +0400, Pavel Emelyanov wrote:
> > 
> > I would split this into two parts -- the 1st one turns fdinfo into seq-files
> > and the 2nd one adds the fdinfo helpers. This will make the review MUCH simpler.
> 
> Yeah, will do and send. Thanks.
> 

Here are two patches, hope such split will help in review procedure.
(I pushed them on github as well, so the complete fd.c can be seen
 here http://goo.gl/mt4q8 ).

	Cyrill

--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=seq-fdinfo-seq-ops-3

From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: procfs: Convert /proc/pid/fdinfo/fd handling routines into seq-file

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/proc/fd.c |  136 ++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 84 insertions(+), 52 deletions(-)

Index: linux-2.6.git/fs/proc/fd.c
===================================================================
--- linux-2.6.git.orig/fs/proc/fd.c
+++ linux-2.6.git/fs/proc/fd.c
@@ -6,66 +6,90 @@
 #include <linux/namei.h>
 #include <linux/pid.h>
 #include <linux/security.h>
+#include <linux/file.h>
+#include <linux/seq_file.h>
 
 #include <linux/proc_fs.h>
 
 #include "internal.h"
+#include "fd.h"
 
-#define PROC_FDINFO_MAX 64
+struct proc_fdinfo {
+	loff_t	f_pos;
+	int	f_flags;
+};
 
-static int proc_fd_info(struct inode *inode, struct path *path, char *info)
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
 {
-	struct task_struct *task = get_proc_task(inode);
 	struct files_struct *files = NULL;
-	int fd = proc_fd(inode);
-	struct file *file;
+	struct proc_fdinfo *fdinfo = NULL;
+	struct task_struct *task;
+	int ret = -ENOENT;
+
+	fdinfo = kzalloc(sizeof(*fdinfo), GFP_KERNEL);
+	if (!fdinfo)
+		return -ENOMEM;
 
+	task = get_proc_task(inode);
 	if (task) {
 		files = get_files_struct(task);
 		put_task_struct(task);
 	}
 
 	if (files) {
-		/*
-		 * We are not taking a ref to the file structure,
-		 * so we must hold ->file_lock.
-		 */
-		spin_lock(&files->file_lock);
-		file = fcheck_files(files, fd);
+		int fd = proc_fd(inode);
+		struct file *fd_file;
 
-		if (file) {
-			unsigned int f_flags;
-			struct fdtable *fdt;
+		spin_lock(&files->file_lock);
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
-
-			if (info)
-				snprintf(info, PROC_FDINFO_MAX,
-					 "pos:\t%lli\n"
-					 "flags:\t0%o\n",
-					 (long long)file->f_pos,
-					 f_flags);
-
-			spin_unlock(&files->file_lock);
-			put_files_struct(files);
-			return 0;
+				fdinfo->f_flags |= O_CLOEXEC;
+			ret = 0;
 		}
-
 		spin_unlock(&files->file_lock);
 		put_files_struct(files);
 	}
 
-	return -ENOENT;
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
@@ -120,7 +144,31 @@ static const struct dentry_operations ti
 
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
@@ -263,22 +311,6 @@ out_no_task:
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

--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=seq-fdinfo-seq-ops-helpers

From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: procfs: Add ability to plugin auxiliary fdinfo providers

This patch brings ability to plugin auxiliary fdinfo providers.
For example in further patches eventfd, evenpoll and fsnotify
will print out additional information associated with files
being inspected after traditional pos,flags pair.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/proc/fd.c            |  186 +++++++++++++++++++++++++++++++++++++-----------
 include/linux/proc_fs.h |   23 +++++
 2 files changed, 168 insertions(+), 41 deletions(-)

Index: linux-2.6.git/fs/proc/fd.c
===================================================================
--- linux-2.6.git.orig/fs/proc/fd.c
+++ linux-2.6.git/fs/proc/fd.c
@@ -8,79 +8,183 @@
 #include <linux/security.h>
 #include <linux/file.h>
 #include <linux/seq_file.h>
+#include <linux/spinlock.h>
 
 #include <linux/proc_fs.h>
 
 #include "internal.h"
 #include "fd.h"
 
-struct proc_fdinfo {
-	loff_t	f_pos;
-	int	f_flags;
-};
+static LIST_HEAD(fdinfo_helpers);
+static DEFINE_RWLOCK(fdinfo_helpers_lock);
+
+int proc_register_fdinfo_helper(struct proc_fdinfo_helper *helper)
+{
+	struct proc_fdinfo_helper *item;
+	int ret = 0;
+
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
+	}
+	if (!ret)
+		list_add(&helper->list, &fdinfo_helpers);
+	write_unlock(&fdinfo_helpers_lock);
+	return ret;
+}
+
+void proc_unregister_fdinfo_helper(struct proc_fdinfo_helper *helper)
+{
+	struct proc_fdinfo_helper *item;
+
+	write_lock(&fdinfo_helpers_lock);
+	list_for_each_entry(item, &fdinfo_helpers, list) {
+		if (item == helper) {
+			list_del(&item->list);
+			break;
+		}
+	}
+	write_unlock(&fdinfo_helpers_lock);
+}
+
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
 
 static int seq_show(struct seq_file *m, void *v)
 {
-	struct proc_fdinfo *fdinfo = m->private;
+	struct proc_fdinfo_extra *extra = m->private;
+
+	if (extra->helper && extra->hdr_shown)
+		return extra->helper->ops->show(m, v);
+
 	seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
-		   (long long)fdinfo->f_pos,
-		   fdinfo->f_flags);
+		   (long long)extra->fd_file->f_pos,
+		   extra->f_flags);
+
+	extra->hdr_shown = 1;
 	return 0;
 }
 
+static const struct seq_operations fdinfo_seq_ops = {
+	.start	= seq_start,
+	.next	= seq_next,
+	.stop	= seq_stop,
+	.show	= seq_show,
+};
+
 static int seq_fdinfo_open(struct inode *inode, struct file *file)
 {
 	struct files_struct *files = NULL;
-	struct proc_fdinfo *fdinfo = NULL;
+	struct proc_fdinfo_extra *extra;
 	struct task_struct *task;
-	int ret = -ENOENT;
+	struct seq_file *m;
+	int ret;
 
-	fdinfo = kzalloc(sizeof(*fdinfo), GFP_KERNEL);
-	if (!fdinfo)
+	extra = kzalloc(sizeof(*extra), GFP_KERNEL);
+	if (!extra)
 		return -ENOMEM;
+	extra->inode = inode;
 
-	task = get_proc_task(inode);
-	if (task) {
-		files = get_files_struct(task);
-		put_task_struct(task);
-	}
-
-	if (files) {
-		int fd = proc_fd(inode);
-		struct file *fd_file;
-
-		spin_lock(&files->file_lock);
-		fd_file = fcheck_files(files, fd);
-		if (fd_file) {
-			struct fdtable *fdt = files_fdtable(files);
-
-			fdinfo->f_flags = fd_file->f_flags & ~O_CLOEXEC;
-			if (close_on_exec(fd, fdt))
-				fdinfo->f_flags |= O_CLOEXEC;
-			ret = 0;
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
 		}
-		spin_unlock(&files->file_lock);
-		put_files_struct(files);
-	}
 
-	if (!ret) {
-		ret = single_open(file, seq_show, fdinfo);
-		if (!ret)
-			fdinfo = NULL;
+		if (files) {
+			int fd = proc_fd(inode);
+
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
+			spin_unlock(&files->file_lock);
+			put_files_struct(files);
+
+			if (extra->fd_file)
+				assign_fdinfo_helper(extra);
+		}
 	}
 
-	kfree(fdinfo);
+	if (ret)
+		kfree(extra);
 	return ret;
 }
 
 static int seq_fdinfo_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = file->private_data;
-	struct proc_fdinfo *fdinfo = m->private;
+	struct proc_fdinfo_extra *extra = m->private;
 
-	kfree(fdinfo);
+	put_filp(extra->fd_file);
+	kfree(m->private);
 
-	return single_release(inode, file);
+	return seq_release(inode, file);
 }
 
 static const struct file_operations proc_fdinfo_file_operations = {
Index: linux-2.6.git/include/linux/proc_fs.h
===================================================================
--- linux-2.6.git.orig/include/linux/proc_fs.h
+++ linux-2.6.git/include/linux/proc_fs.h
@@ -100,6 +100,23 @@ struct vmcore {
 	loff_t offset;
 };
 
+struct seq_operations;
+struct proc_fdinfo_helper {
+	struct list_head		list;
+	const char			*name;
+	const struct seq_operations	*ops;
+	int				(*probe)(struct file *file);
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
@@ -175,6 +192,9 @@ extern struct proc_dir_entry *proc_net_m
 
 extern struct file *proc_ns_fget(int fd);
 
+extern int proc_register_fdinfo_helper(struct proc_fdinfo_helper *helper);
+extern void proc_unregister_fdinfo_helper(struct proc_fdinfo_helper *helper);
+
 #else
 
 #define proc_net_fops_create(net, name, mode, fops)  ({ (void)(mode), NULL; })
@@ -229,6 +249,9 @@ static inline struct file *proc_ns_fget(
 	return ERR_PTR(-EINVAL);
 }
 
+static inline int proc_register_fdinfo_helper(struct proc_fdinfo_helper *helper) { return -EINVAL; }
+static inline void proc_unregister_fdinfo_helper(struct proc_fdinfo_helper *helper) { }
+
 #endif /* CONFIG_PROC_FS */
 
 #if !defined(CONFIG_PROC_KCORE)

--vkogqOf2sHV7VnPd--
