Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2KQIen (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 03:34:43 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:46882 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab2KQIel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 03:34:41 -0500
Date: Sat, 17 Nov 2012 12:34:37 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [patch 7/7] fs, notify: Add procfs fdinfo helper v6
Message-ID: <20121117083437.GC22855@moon>
References: <20121114151937.344922058@openvz.org>
 <20121114152239.936025193@openvz.org>
 <20121116155603.2118394c.akpm@linux-foundation.org>
 <20121117071039.GA22855@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121117071039.GA22855@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 11:10:39AM +0400, Cyrill Gorcunov wrote:
> > 
> > What happens if we do something like the below (which will require a
> > changelog update)?
> 
> Looks good for me, Andrew. The only reason for such whitespace rich format
> was to make output column aligned. But it's fine to have name:val as well.
> I'll update. Thanks!

Andrew, here is a patch which contains and your change, and changelog update
and one fix (you've lost %lx for ino number thus compiler warns me about
missing specificator). Also the inotify/fanotify at first position on the
line (without dash, as you propose, ie inotify-wd) applies to the whole line,
that's why I didn't use dashes in first place.

Right below changelog I wrote which patches this one deprecate. If it's inconvenient
and I better should provide you the patch on top instead -- just give me a word.
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, notify: Add procfs fdinfo helper v7

This allow us to print out fsnotify details such as
watchee inode, device, mask and optionally a file handle.

For inotify objects if kernel compiled with exportfs support
the output will be

 | pos:	0
 | flags:	02000000
 | inotify wd:3 ino:9e7e sdev:800013 mask:800afce ignored_mask:0 fhandle-bytes:8 fhandle-type:1 f_handle:7e9e0000640d1b6d
 | inotify wd:2 ino:a111 sdev:800013 mask:800afce ignored_mask:0 fhandle-bytes:8 fhandle-type:1 f_handle:11a1000020542153
 | inotify wd:1 ino:6b149 sdev:800013 mask:800afce ignored_mask:0 fhandle-bytes:8 fhandle-type:1 f_handle:49b1060023552153

If kernel compiled without exportfs support, the file handle
won't be provided but inode and device only.

 | pos:	0
 | flags:	02000000
 | inotify wd:3 ino:9e7e sdev:800013 mask:800afce ignored_mask:0
 | inotify wd:2 ino:a111 sdev:800013 mask:800afce ignored_mask:0
 | inotify wd:1 ino:6b149 sdev:800013 mask:800afce ignored_mask:0

For fanotify the output is like

 | pos:	0
 | flags:	02
 | fanotify ino:68f71 sdev:800013 mask:1 ignored_mask:40000000

 | pos:	0
 | flags:	02
 | fanotify mnt_id:13 mask:1 ignored_mask:40000000

To minimize impact on general fsnotify code the new functionality
is gathered in fs/notify/fdinfo.c file.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Andrey Vagin <avagin@openvz.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Matthew Helsley <matt.helsley@gmail.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
---

The patch to substitute two patches in -mm tree
fs-notify-add-procfs-fdinfo-helper-v6.patch
fs-notify-add-procfs-fdinfo-helper-v6-fix.patch

 fs/notify/Makefile                 |    2 
 fs/notify/fanotify/fanotify_user.c |    2 
 fs/notify/fdinfo.c                 |  153 +++++++++++++++++++++++++++++++++++++
 fs/notify/fdinfo.h                 |   22 +++++
 fs/notify/inotify/inotify_user.c   |    2 
 5 files changed, 180 insertions(+), 1 deletion(-)

Index: linux-2.6.git/fs/notify/Makefile
===================================================================
--- linux-2.6.git.orig/fs/notify/Makefile
+++ linux-2.6.git/fs/notify/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_FSNOTIFY)		+= fsnotify.o notification.o group.o inode_mark.o \
-				   mark.o vfsmount_mark.o
+				   mark.o vfsmount_mark.o fdinfo.o
 
 obj-y			+= dnotify/
 obj-y			+= inotify/
Index: linux-2.6.git/fs/notify/fanotify/fanotify_user.c
===================================================================
--- linux-2.6.git.orig/fs/notify/fanotify/fanotify_user.c
+++ linux-2.6.git/fs/notify/fanotify/fanotify_user.c
@@ -17,6 +17,7 @@
 #include <asm/ioctls.h>
 
 #include "../../mount.h"
+#include "../fdinfo.h"
 
 #define FANOTIFY_DEFAULT_MAX_EVENTS	16384
 #define FANOTIFY_DEFAULT_MAX_MARKS	8192
@@ -427,6 +428,7 @@ static long fanotify_ioctl(struct file *
 }
 
 static const struct file_operations fanotify_fops = {
+	.show_fdinfo	= fanotify_show_fdinfo,
 	.poll		= fanotify_poll,
 	.read		= fanotify_read,
 	.write		= fanotify_write,
Index: linux-2.6.git/fs/notify/fdinfo.c
===================================================================
--- /dev/null
+++ linux-2.6.git/fs/notify/fdinfo.c
@@ -0,0 +1,153 @@
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/fsnotify_backend.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/inotify.h>
+#include <linux/kernel.h>
+#include <linux/namei.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/seq_file.h>
+#include <linux/proc_fs.h>
+#include <linux/exportfs.h>
+
+#include "inotify/inotify.h"
+#include "../fs/mount.h"
+
+#if defined(CONFIG_PROC_FS)
+
+#if defined(CONFIG_INOTIFY_USER) || defined(CONFIG_FANOTIFY)
+
+static int show_fdinfo(struct seq_file *m, struct file *f,
+		       int (*show)(struct seq_file *m, struct fsnotify_mark *mark))
+{
+	struct fsnotify_group *group = f->private_data;
+	struct fsnotify_mark *mark;
+	int ret = 0;
+
+	spin_lock(&group->mark_lock);
+	list_for_each_entry(mark, &group->marks_list, g_list) {
+		ret = show(m, mark);
+		if (ret)
+			break;
+	}
+	spin_unlock(&group->mark_lock);
+	return ret;
+}
+
+#ifdef CONFIG_INOTIFY_USER
+
+#if defined(CONFIG_EXPORTFS)
+static int show_mark_fhandle(struct seq_file *m, struct inode *inode)
+{
+	struct {
+		struct file_handle handle;
+		u8 pad[64];
+	} f;
+	int size, ret, i;
+
+	f.handle.handle_bytes = sizeof(f.pad);
+	size = f.handle.handle_bytes >> 2;
+
+	ret = exportfs_encode_inode_fh(inode, (struct fid *)f.handle.f_handle, &size, 0);
+	if ((ret == 255) || (ret == -ENOSPC)) {
+		WARN_ONCE(1, "Can't encode file handler for inotify: %d\n", ret);
+		return 0;
+	}
+
+	f.handle.handle_type = ret;
+	f.handle.handle_bytes = size * sizeof(u32);
+
+	ret = seq_printf(m, "fhandle-bytes:%x fhandle-type:%x f_handle:",
+			 f.handle.handle_bytes, f.handle.handle_type);
+
+	for (i = 0; i < f.handle.handle_bytes; i++)
+		ret |= seq_printf(m, "%02x", (int)f.handle.f_handle[i]);
+
+	return ret;
+}
+#else
+static int show_mark_fhandle(struct seq_file *m, struct inode *inode)
+{
+	return 0;
+}
+#endif
+
+static int inotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
+{
+	struct inotify_inode_mark *inode_mark;
+	struct inode *inode;
+	int ret = 0;
+
+	if (!(mark->flags & (FSNOTIFY_MARK_FLAG_ALIVE | FSNOTIFY_MARK_FLAG_INODE)))
+		return 0;
+
+	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
+	inode = igrab(mark->i.inode);
+	if (inode) {
+		ret = seq_printf(m, "inotify-wd:%x ino:%lx sdev:%x "
+				 "mask:%x ignored_mask:%x ",
+				 inode_mark->wd, inode->i_ino,
+				 inode->i_sb->s_dev,
+				 mark->mask, mark->ignored_mask);
+		ret |= show_mark_fhandle(m, inode);
+		ret |= seq_putc(m, '\n');
+		iput(inode);
+	}
+
+	return ret;
+}
+
+int inotify_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	return show_fdinfo(m, f, inotify_fdinfo);
+}
+
+#endif /* CONFIG_INOTIFY_USER */
+
+#ifdef CONFIG_FANOTIFY
+
+static int fanotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
+{
+	struct inode *inode;
+	int ret = 0;
+
+	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE))
+		return 0;
+
+	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE) {
+		inode = igrab(mark->i.inode);
+		if (!inode)
+			goto out;
+		ret = seq_printf(m, "fanotify ino:%lx sdev:%x "
+				 "mask:%x ignored_mask:%x\n",
+				 inode->i_ino, inode->i_sb->s_dev,
+				 mark->mask, mark->ignored_mask);
+		iput(inode);
+	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT) {
+		struct mount *mnt = real_mount(mark->m.mnt);
+
+		ret = seq_printf(m, "fanotify mnt_id:%x mask:%x "
+				 "ignored_mask:%x\n",
+				 mnt->mnt_id, mark->mask, mark->ignored_mask);
+	}
+out:
+	return ret;
+}
+
+int fanotify_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	return show_fdinfo(m, f, fanotify_fdinfo);
+}
+
+#endif /* CONFIG_FANOTIFY */
+
+#endif /* CONFIG_INOTIFY_USER || CONFIG_FANOTIFY */
+
+#else /* CONFIG_PROC_FS */
+
+#define inotify_show_fdinfo	NULL
+#define fanotify_show_fdinfo	NULL
+
+#endif /* CONFIG_PROC_FS */
Index: linux-2.6.git/fs/notify/fdinfo.h
===================================================================
--- /dev/null
+++ linux-2.6.git/fs/notify/fdinfo.h
@@ -0,0 +1,22 @@
+#ifndef __FSNOTIFY_FDINFO_H__
+#define __FSNOTIFY_FDINFO_H__
+
+#include <linux/errno.h>
+#include <linux/proc_fs.h>
+
+struct seq_file;
+struct file;
+
+#ifdef CONFIG_PROC_FS
+
+#ifdef CONFIG_INOTIFY_USER
+extern int inotify_show_fdinfo(struct seq_file *m, struct file *f);
+#endif
+
+#ifdef CONFIG_FANOTIFY
+extern int fanotify_show_fdinfo(struct seq_file *m, struct file *f);
+#endif
+
+#endif /* CONFIG_PROC_FS */
+
+#endif /* __FSNOTIFY_FDINFO_H__ */
Index: linux-2.6.git/fs/notify/inotify/inotify_user.c
===================================================================
--- linux-2.6.git.orig/fs/notify/inotify/inotify_user.c
+++ linux-2.6.git/fs/notify/inotify/inotify_user.c
@@ -40,6 +40,7 @@
 #include <linux/wait.h>
 
 #include "inotify.h"
+#include "../fdinfo.h"
 
 #include <asm/ioctls.h>
 
@@ -335,6 +336,7 @@ static long inotify_ioctl(struct file *f
 }
 
 static const struct file_operations inotify_fops = {
+	.show_fdinfo	= inotify_show_fdinfo,
 	.poll		= inotify_poll,
 	.read		= inotify_read,
 	.fasync		= inotify_fasync,
