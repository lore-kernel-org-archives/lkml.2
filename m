Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab2HNT45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 15:56:57 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56405 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab2HNT4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 15:56:54 -0400
Date: Tue, 14 Aug 2012 23:56:49 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 3/8] procfs: Add ability to plug in auxiliary fdinfo
 providers
Message-ID: <20120814195649.GB31043@moon>
References: <20120814140342.354405844@openvz.org>
 <20120814140620.033884909@openvz.org>
 <20120814183142.GH23464@ZenIV.linux.org.uk>
 <20120814183558.GA1551@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814183558.GA1551@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 10:35:58PM +0400, Cyrill Gorcunov wrote:
> On Tue, Aug 14, 2012 at 07:31:42PM +0100, Al Viro wrote:
> > > Initially we considered to inject some "show" metod to
> > > file_operations but since there really a number of
> > > file_operations declared inside kernel (and in real the
> > > further patches cover onle eventfd/epoll/inotify) the
> > > waste of memory space will be inacceptable I think.
> > 
> > NAK.  This is too ugly to live.  Put it into file_operations,
> > with NULL meaning default output, or don't do it at all.
> > 
> > And no, "it's only if you enable CONFIG_SOME_SHIT" gambit won't
> > fly - we have all seen it played too many times.  All it takes
> > is one politically-inclined induhvidual adding a dependency to
> > some "vertically integrated" turd (*cough* systemd *spit* udev
> > *cough*) and we are stuck with the damn thing.  CGROUP shite
> > is already there, DEVTMPFS is well on its way, etc.
> 
> OK, I'll put it into file_operations then (actually Pavel was
> proposing the same but I've been scared by amount of file_operations
> declared). Thanks!

Al, does the patch below looks better? If so I'll fix up the rest.
---
 fs/proc/fd.c            |  109 ++++++++++++++++++++++++++++++++++++++----------
 include/linux/fs.h      |    3 +
 include/linux/proc_fs.h |    8 +++
 3 files changed, 99 insertions(+), 21 deletions(-)

Index: linux-2.6.git/fs/proc/fd.c
===================================================================
--- linux-2.6.git.orig/fs/proc/fd.c
+++ linux-2.6.git/fs/proc/fd.c
@@ -8,18 +8,14 @@
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
-
-static int fdinfo_open_helper(struct inode *inode, int *f_flags, struct path *path)
+static int fdinfo_open_helper(struct inode *inode, int *f_flags, struct file **f_file, struct path *path)
 {
 	struct files_struct *files = NULL;
 	struct task_struct *task;
@@ -49,6 +45,10 @@ static int fdinfo_open_helper(struct ino
 				*path = fd_file->f_path;
 				path_get(&fd_file->f_path);
 			}
+			if (f_file) {
+				*f_file = fd_file;
+				get_file(fd_file);
+			}
 			ret = 0;
 		}
 		spin_unlock(&files->file_lock);
@@ -58,43 +58,110 @@ static int fdinfo_open_helper(struct ino
 	return ret;
 }
 
+static void *seq_start(struct seq_file *m, loff_t *pos)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+
+	extra->pos = *pos;
+
+	return *pos == 0 ? extra :
+		(extra->fdinfo_ops ?
+		 extra->fdinfo_ops->start(m, pos) : NULL);
+}
+
+static void seq_stop(struct seq_file *m, void *v)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+
+	if (extra->fdinfo_ops && extra->pos > 0)
+		extra->fdinfo_ops->stop(m, v);
+}
+
+static void *seq_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+	void *v = NULL;
+
+	if (extra->fdinfo_ops) {
+		int ret = 0;
+
+		if (*pos == 0) {
+			v = extra->fdinfo_ops->start(m, pos);
+			if (v) {
+				ret = extra->fdinfo_ops->show(m, v);
+				p = v;
+			} else
+				ret = -1;
+		}
+
+		if (!ret)
+			v = extra->fdinfo_ops->next(m, p, pos);
+	} else
+		++*pos;
+
+	extra->pos = *pos;
+	return v;
+}
+
 static int seq_show(struct seq_file *m, void *v)
 {
-	struct proc_fdinfo *fdinfo = m->private;
+	struct proc_fdinfo_extra *extra = m->private;
+
+	if (extra->fdinfo_ops && extra->pos > 0)
+		return extra->fdinfo_ops->show(m, v);
+
 	seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
-		   (long long)fdinfo->f_pos,
-		   fdinfo->f_flags);
+		   (long long)extra->f_file->f_pos,
+		   extra->f_flags);
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
-	struct proc_fdinfo *fdinfo = NULL;
-	int ret = -ENOENT;
+	struct proc_fdinfo_extra *extra;
+	struct seq_file *m;
+	int ret;
 
-	fdinfo = kzalloc(sizeof(*fdinfo), GFP_KERNEL);
-	if (!fdinfo)
+	extra = kzalloc(sizeof(*extra), GFP_KERNEL);
+	if (!extra)
 		return -ENOMEM;
 
-	ret = fdinfo_open_helper(inode, &fdinfo->f_flags, NULL);
+	ret = seq_open(file, &fdinfo_seq_ops);
 	if (!ret) {
-		ret = single_open(file, seq_show, fdinfo);
+		ret = -ENOENT;
+		m = file->private_data;
+		m->private = extra;
+
+		ret = fdinfo_open_helper(inode, &extra->f_flags,
+					 &extra->f_file, NULL);
 		if (!ret)
-			fdinfo = NULL;
+			extra->fdinfo_ops = extra->f_file->f_op->fdinfo_ops;
 	}
 
-	kfree(fdinfo);
+	if (ret) {
+		if (extra->f_file)
+			put_filp(extra->f_file);
+		kfree(extra);
+	}
 	return ret;
 }
 
 static int seq_fdinfo_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = file->private_data;
-	struct proc_fdinfo *fdinfo = m->private;
+	struct proc_fdinfo_extra *extra = m->private;
 
-	kfree(fdinfo);
+	put_filp(extra->f_file);
+	kfree(m->private);
 
-	return single_release(inode, file);
+	return seq_release(inode, file);
 }
 
 static const struct file_operations proc_fdinfo_file_operations = {
@@ -173,7 +240,7 @@ static const struct dentry_operations ti
 
 static int proc_fd_link(struct dentry *dentry, struct path *path)
 {
-	return fdinfo_open_helper(dentry->d_inode, NULL, path);
+	return fdinfo_open_helper(dentry->d_inode, NULL, NULL, path);
 }
 
 static struct dentry *
Index: linux-2.6.git/include/linux/fs.h
===================================================================
--- linux-2.6.git.orig/include/linux/fs.h
+++ linux-2.6.git/include/linux/fs.h
@@ -1775,8 +1775,11 @@ struct block_device_operations;
 #define HAVE_COMPAT_IOCTL 1
 #define HAVE_UNLOCKED_IOCTL 1
 
+struct seq_operations;
+
 struct file_operations {
 	struct module *owner;
+	struct seq_operations *fdinfo_ops;
 	loff_t (*llseek) (struct file *, loff_t, int);
 	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
 	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
Index: linux-2.6.git/include/linux/proc_fs.h
===================================================================
--- linux-2.6.git.orig/include/linux/proc_fs.h
+++ linux-2.6.git/include/linux/proc_fs.h
@@ -100,6 +100,14 @@ struct vmcore {
 	loff_t offset;
 };
 
+/* auxiliary data allocated per fdinfo reader */
+struct proc_fdinfo_extra {
+	loff_t			pos;
+	struct file		*f_file;
+	struct seq_operations	*fdinfo_ops;
+	unsigned int		f_flags;
+};
+
 #ifdef CONFIG_PROC_FS
 
 extern void proc_root_init(void);
