Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab2HOHks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 03:40:48 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37134 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946Ab2HOHkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 03:40:46 -0400
Date: Wed, 15 Aug 2012 11:40:42 +0400
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
Message-ID: <20120815074042.GB23657@moon>
References: <20120814140342.354405844@openvz.org>
 <20120814140620.033884909@openvz.org>
 <20120814183142.GH23464@ZenIV.linux.org.uk>
 <20120814183558.GA1551@moon>
 <20120814195649.GB31043@moon>
 <20120814212721.GJ23464@ZenIV.linux.org.uk>
 <20120814215616.GC31043@moon>
 <20120814222147.GA21674@moon>
 <20120815000703.GL23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815000703.GL23464@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 01:07:03AM +0100, Al Viro wrote:
> On Wed, Aug 15, 2012 at 02:21:47AM +0400, Cyrill Gorcunov wrote:
> > > Hmm, in very first versions I've been using one ->show method, but
> > > then I thought that this is not very correlate with seq-files idea
> > > where for each record show/next sequence is called. I'll update (this
> > > for sure will make code simplier, and I'll have to check for seq-file
> > > overflow after seq_printf call to not continue printing data for too
> > > long if buffer already out of space).
> > 
> > Al, I'll cook the whole series tomorrow and resend it for review,
> > also I guess the new show_fdinfo() member in file-operations should
> > be guarded with CONFIG_PROC_FS, right?
> 
> I seriously doubt that it's worth bothering.  If somebody cares, they
> can add making it conditional later.

That's what I've beed testing, does it looks good for you?
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: procfs: Add ability to plug in auxiliary fdinfo providers

This patch brings ability to print out auxiliary data associated
with file in procfs interface /proc/pid/fdinfo/fd.

Inparticular further patches make eventfd, evenpoll, signalfd
and fsnotify to print additional information complete enough
to restore these objects after checkpoint.

To simplify the code we add show_fdinfo callback into
struct file_operations (as Al proposed).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
---
 fs/proc/fd.c       |   51 ++++++++++++++++++++++++++++++++++++---------------
 include/linux/fs.h |    3 +++
 2 files changed, 39 insertions(+), 15 deletions(-)

Index: linux-2.6.git/fs/proc/fd.c
===================================================================
--- linux-2.6.git.orig/fs/proc/fd.c
+++ linux-2.6.git/fs/proc/fd.c
@@ -15,11 +15,11 @@
 #include "fd.h"
 
 struct proc_fdinfo {
-	loff_t	f_pos;
-	int	f_flags;
+	struct file	*f_file;
+	int		f_flags;
 };
 
-static int fdinfo_open_helper(struct inode *inode, int *f_flags, struct path *path)
+static int fdinfo_open_helper(struct inode *inode, int *f_flags, struct file **f_file, struct path *path)
 {
 	struct files_struct *files = NULL;
 	struct task_struct *task;
@@ -49,6 +49,10 @@ static int fdinfo_open_helper(struct ino
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
@@ -61,28 +65,44 @@ static int fdinfo_open_helper(struct ino
 static int seq_show(struct seq_file *m, void *v)
 {
 	struct proc_fdinfo *fdinfo = m->private;
-	seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
-		   (long long)fdinfo->f_pos,
-		   fdinfo->f_flags);
-	return 0;
+	int ret;
+
+	ret = seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
+			 (long long)fdinfo->f_file->f_pos,
+			 fdinfo->f_flags);
+
+	if (!ret && fdinfo->f_file->f_op->show_fdinfo)
+		ret = fdinfo->f_file->f_op->show_fdinfo(m, fdinfo->f_file);
+
+	return ret;
 }
 
 static int seq_fdinfo_open(struct inode *inode, struct file *file)
 {
-	struct proc_fdinfo *fdinfo = NULL;
-	int ret = -ENOENT;
+	struct proc_fdinfo *fdinfo;
+	struct seq_file *m;
+	int ret;
 
 	fdinfo = kzalloc(sizeof(*fdinfo), GFP_KERNEL);
 	if (!fdinfo)
 		return -ENOMEM;
 
-	ret = fdinfo_open_helper(inode, &fdinfo->f_flags, NULL);
-	if (!ret) {
-		ret = single_open(file, seq_show, fdinfo);
-		if (!ret)
-			fdinfo = NULL;
+	ret = fdinfo_open_helper(inode, &fdinfo->f_flags, &fdinfo->f_file, NULL);
+	if (ret)
+		goto err_free;
+
+	ret = single_open(file, seq_show, fdinfo);
+	if (ret) {
+		put_filp(fdinfo->f_file);
+		goto err_free;
 	}
 
+	m = file->private_data;
+	m->private = fdinfo;
+
+	return ret;
+
+err_free:
 	kfree(fdinfo);
 	return ret;
 }
@@ -92,6 +112,7 @@ static int seq_fdinfo_release(struct ino
 	struct seq_file *m = file->private_data;
 	struct proc_fdinfo *fdinfo = m->private;
 
+	put_filp(fdinfo->f_file);
 	kfree(fdinfo);
 
 	return single_release(inode, file);
@@ -173,7 +194,7 @@ static const struct dentry_operations ti
 
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
@@ -1775,6 +1775,8 @@ struct block_device_operations;
 #define HAVE_COMPAT_IOCTL 1
 #define HAVE_UNLOCKED_IOCTL 1
 
+struct seq_file;
+
 struct file_operations {
 	struct module *owner;
 	loff_t (*llseek) (struct file *, loff_t, int);
@@ -1803,6 +1805,7 @@ struct file_operations {
 	int (*setlease)(struct file *, long, struct file_lock **);
 	long (*fallocate)(struct file *file, int mode, loff_t offset,
 			  loff_t len);
+	int (*show_fdinfo)(struct seq_file *m, struct file *f);
 };
 
 struct inode_operations {
