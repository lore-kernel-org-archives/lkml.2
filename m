Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab2F2Kan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 06:30:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54263 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab2F2Kal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 06:30:41 -0400
Date: Fri, 29 Jun 2012 14:30:37 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [rfc 7/7] fs, notify: Add procfs fdinfo helper
Message-ID: <20120629103037.GB1949@moon>
References: <20120627110116.201735815@openvz.org>
 <20120627110512.921499341@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627110512.921499341@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 03:01:23PM +0400, Cyrill Gorcunov wrote:
> This allow us to print out fsnotify details such as
> watchee inode, device, mask and file handle.
> 

A slightly updated version below (I've missed colons
in a couple of printk places).
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, notify: Add procfs fdinfo helper v2

This allow us to print out fsnotify details such as
watchee inode, device, mask and file handle.

For example for inotify objects the output is

 | pos:	0
 | flags:	02000000
 | inotify wd:        3 ino:             9e7e sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 7e9e0000640d1b6d
 | inotify wd:        2 ino:             a111 sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 11a1000020542153
 | inotify wd:        1 ino:            6b149 sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 49b1060023552153

For fanotify it is like

 | pos:	0
 | flags:	02
 | fanotify ino:            68f71 sdev:   800013 mask:        1 ignored_mask: 40000000 fhandle-bytes:        8 fhandle-type:        1 f_handle: 718f0600b9f42053
 | fanotify mnt_id:       13 mask:        1 ignored_mask: 40000000

This feature is CONFIG_CHECKPOINT_RESTORE only. To minimize
impact on general fsnotify code the new functionality is gathered
in fs/notify/fdinfo.c file mostly.

v2:
 - append missing colons to terms

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: James Bottomley <jbottomley@parallels.com>
---
 fs/notify/Makefile                 |    2 
 fs/notify/fanotify/fanotify_user.c |   17 ++
 fs/notify/fdinfo.c                 |  219 +++++++++++++++++++++++++++++++++++++
 fs/notify/fdinfo.h                 |   19 +++
 fs/notify/inotify/inotify_user.c   |   32 +++++
 5 files changed, 287 insertions(+), 2 deletions(-)

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
@@ -877,6 +878,20 @@ asmlinkage long SyS_fanotify_mark(long f
 SYSCALL_ALIAS(sys_fanotify_mark, SyS_fanotify_mark);
 #endif
 
+#if defined(CONFIG_PROC_FS) && defined(CONFIG_CHECKPOINT_RESTORE)
+int is_file_fanotify(struct file *file)
+{
+	return file->f_op == &fanotify_fops;
+}
+
+static int __init fanotify_register_fdinfo_driver(void)
+{
+	return proc_register_fdinfo_driver(&fanotify_fdinfo);
+}
+#else
+void fanotify_register_fdinfo_driver(void) { }
+#endif /* CONFIG_PROC_FS && CONFIG_CHECKPOINT_RESTORE */
+
 /*
  * fanotify_user_setup - Our initialization function.  Note that we cannot return
  * error because we have compiled-in VFS hooks.  So an (unlikely) failure here
@@ -887,7 +902,7 @@ static int __init fanotify_user_setup(vo
 	fanotify_mark_cache = KMEM_CACHE(fsnotify_mark, SLAB_PANIC);
 	fanotify_response_event_cache = KMEM_CACHE(fanotify_response_event,
 						   SLAB_PANIC);
-
+	fanotify_register_fdinfo_driver();
 	return 0;
 }
 device_initcall(fanotify_user_setup);
Index: linux-2.6.git/fs/notify/fdinfo.c
===================================================================
--- /dev/null
+++ linux-2.6.git/fs/notify/fdinfo.c
@@ -0,0 +1,219 @@
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
+#include <linux/exportfs.h>
+#include <linux/proc_fs.h>
+
+#include "inotify/inotify.h"
+#include "../fs/mount.h"
+
+struct inode_file_handle {
+	struct file_handle		h;
+	struct fid			fid;
+} __packed;
+
+#if defined(CONFIG_PROC_FS) && defined(CONFIG_CHECKPOINT_RESTORE)
+
+#if defined(CONFIG_INOTIFY_USER) || defined(CONFIG_FANOTIFY)
+
+#ifdef CONFIG_EXPORTFS
+static int inotify_encode_target(struct inode *inode, struct inode_file_handle *fhandle)
+{
+	int ret, size;
+
+	size = sizeof(fhandle->fid) >> 2;
+	ret = export_encode_inode_fh(inode, &fhandle->fid, &size);
+	BUG_ON(ret != FILEID_INO32_GEN);
+
+	fhandle->h.handle_type = FILEID_INO32_GEN;
+	fhandle->h.handle_bytes = size * sizeof(u32);
+
+	return 0;
+}
+#else
+static int inotify_encode_target(struct inode *inode, struct inode_file_handle *fhandle)
+{
+	fhandle->h.handle_type = FILEID_ROOT;
+	fhandle->h.handle_bytes = 0;
+	return 0;
+}
+#endif /* CONFIG_EXPORTFS */
+
+struct fsnotify_mark *
+seq_lookup_mark(struct proc_fdinfo_extra *extra, loff_t num)
+{
+	const int match = FSNOTIFY_MARK_FLAG_INODE | FSNOTIFY_MARK_FLAG_VFSMOUNT;
+        struct fsnotify_group *group = extra->f_file->private_data;
+        struct fsnotify_mark *mark, *v = NULL;
+
+        spin_lock(&group->mark_lock);
+        list_for_each_entry(mark, &group->marks_list, g_list) {
+                if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE) ||
+		    !(mark->flags & match))
+                        continue;
+                if (num-- == 0) {
+                        v = mark;
+                        fsnotify_get_mark(mark);
+                        break;
+                }
+        }
+
+        spin_unlock(&group->mark_lock);
+        return v;
+}
+
+static void *seq_start(struct seq_file *m, loff_t *pos)
+{
+        struct proc_fdinfo_extra *extra = m->private;
+        return seq_lookup_mark(extra, *pos);
+}
+
+static void seq_stop(struct seq_file *m, void *v)
+{
+        if (v)
+                fsnotify_put_mark(v);
+}
+
+static void *seq_next(struct seq_file *m, void *p, loff_t *pos)
+{
+        struct proc_fdinfo_extra *extra = m->private;
+        ++*pos;
+        if (p)
+                fsnotify_put_mark(p);
+        return (void *)seq_lookup_mark(extra, *pos);
+}
+
+#ifdef CONFIG_INOTIFY_USER
+
+extern int is_file_inotify(struct file *file);
+
+static int seq_show_inotify(struct seq_file *m, void *v)
+{
+        struct inotify_inode_mark *inode_mark;
+        struct fsnotify_mark *mark = v;
+        struct inode *inode;
+
+        spin_lock(&mark->lock);
+	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE))
+		goto out;
+
+	if (unlikely(!(mark->flags & FSNOTIFY_MARK_FLAG_INODE)))
+		goto out;
+
+	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
+	inode = igrab(mark->i.inode);
+	if (inode) {
+		struct inode_file_handle fhandle;
+		int i;
+
+		inotify_encode_target(inode, &fhandle);
+
+		seq_printf(m, "inotify wd: %8d ino: %16lx sdev: %8x "
+			   "mask: %8x ignored_mask: %8x "
+			   "fhandle-bytes: %8x fhandle-type: %8x f_handle: ",
+			   inode_mark->wd, inode->i_ino,
+			   inode->i_sb->s_dev,
+			   mark->mask,
+			   mark->ignored_mask,
+			   fhandle.h.handle_bytes,
+			   fhandle.h.handle_type);
+
+		for (i = 0; i < fhandle.h.handle_bytes; i++)
+			seq_printf(m, "%02x",
+				   (int)(unsigned char)fhandle.h.f_handle[i]);
+		seq_putc(m, '\n');
+		iput(inode);
+	}
+out:
+        spin_unlock(&mark->lock);
+        return 0;
+}
+
+static const struct seq_operations inotify_fdinfo_ops = {
+	.start	= seq_start,
+	.next	= seq_next,
+	.stop	= seq_stop,
+	.show	= seq_show_inotify,
+};
+
+struct proc_fdinfo_driver inotify_fdinfo = {
+	.name	= "inotify",
+	.ops	= &inotify_fdinfo_ops,
+	.probe	= is_file_inotify,
+};
+
+#endif /* CONFIG_INOTIFY_USER */
+
+#ifdef CONFIG_FANOTIFY
+
+extern int is_file_fanotify(struct file *file);
+
+static int seq_show_fanotify(struct seq_file *m, void *v)
+{
+        struct fsnotify_mark *mark = v;
+        struct inode *inode;
+
+        spin_lock(&mark->lock);
+	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE))
+		goto out;
+	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE) {
+		struct inode_file_handle fhandle;
+		int i;
+
+		inode = igrab(mark->i.inode);
+		if (!inode)
+			goto out;
+		inotify_encode_target(inode, &fhandle);
+
+		seq_printf(m, "fanotify ino: %16lx sdev: %8x "
+			   "mask: %8x ignored_mask: %8x "
+			   "fhandle-bytes: %8x fhandle-type: %8x f_handle: ",
+			   inode->i_ino,
+			   inode->i_sb->s_dev,
+			   mark->mask,
+			   mark->ignored_mask,
+			   fhandle.h.handle_bytes,
+			   fhandle.h.handle_type);
+
+		for (i = 0; i < fhandle.h.handle_bytes; i++)
+			seq_printf(m, "%02x",
+				   (int)(unsigned char)fhandle.h.f_handle[i]);
+		seq_putc(m, '\n');
+		iput(inode);
+	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT) {
+		struct mount *mnt = real_mount(mark->m.mnt);
+
+		seq_printf(m, "fanotify mnt_id: %8x mask: %8x ignored_mask: %8x\n",
+			   mnt->mnt_id, mark->mask, mark->ignored_mask);
+	}
+out:
+        spin_unlock(&mark->lock);
+        return 0;
+}
+
+static const struct seq_operations fanotify_fdinfo_ops = {
+	.start	= seq_start,
+	.next	= seq_next,
+	.stop	= seq_stop,
+	.show	= seq_show_fanotify,
+};
+
+struct proc_fdinfo_driver fanotify_fdinfo = {
+	.name		= "fanotify",
+	.ops		= &fanotify_fdinfo_ops,
+	.probe		= is_file_fanotify,
+};
+
+#endif /* CONFIG_FANOTIFY */
+
+#endif /* CONFIG_INOTIFY_USER || CONFIG_FANOTIFY */
+
+#endif /* CONFIG_PROC_FS && CONFIG_CHECKPOINT_RESTORE */
Index: linux-2.6.git/fs/notify/fdinfo.h
===================================================================
--- /dev/null
+++ linux-2.6.git/fs/notify/fdinfo.h
@@ -0,0 +1,19 @@
+#ifndef __FSNOTIFY_FDINFO_H__
+#define __FSNOTIFY_FDINFO_H__
+
+#include <linux/errno.h>
+#include <linux/proc_fs.h>
+
+#if defined(CONFIG_PROC_FS) && defined(CONFIG_CHECKPOINT_RESTORE)
+
+#ifdef CONFIG_INOTIFY_USER
+extern struct proc_fdinfo_driver inotify_fdinfo;
+#endif
+
+#ifdef CONFIG_FANOTIFY
+extern struct proc_fdinfo_driver fanotify_fdinfo;
+#endif
+
+#endif
+
+#endif /* __FSNOTIFY_FDINFO_H__ */
Index: linux-2.6.git/fs/notify/inotify/inotify_user.c
===================================================================
--- linux-2.6.git.orig/fs/notify/inotify/inotify_user.c
+++ linux-2.6.git/fs/notify/inotify/inotify_user.c
@@ -38,8 +38,12 @@
 #include <linux/uaccess.h>
 #include <linux/poll.h>
 #include <linux/wait.h>
+#include <linux/seq_file.h>
+#include <linux/exportfs.h>
+#include <linux/proc_fs.h>
 
 #include "inotify.h"
+#include "../fdinfo.h"
 
 #include <asm/ioctls.h>
 
@@ -827,6 +831,26 @@ out:
 	return ret;
 }
 
+#if defined(CONFIG_PROC_FS) && defined(CONFIG_CHECKPOINT_RESTORE)
+int is_file_inotify(struct file *file)
+{
+	return file->f_op == &inotify_fops;
+}
+
+static int __init inotify_register_fdinfo_driver(void)
+{
+	return proc_register_fdinfo_driver(&inotify_fdinfo);
+}
+
+static void __exit inotify_unregister_fdinfo_driver(void)
+{
+	proc_unregister_fdinfo_driver(&inotify_fdinfo);
+}
+#else
+static int __init inotify_register_fdinfo_driver(void) { return 0; }
+static void __exit inotify_unregister_fdinfo_driver(void) { }
+#endif /* CONFIG_PROC_FS && CONFIG_CHECKPOINT_RESTORE */
+
 /*
  * inotify_user_setup - Our initialization function.  Note that we cannot return
  * error because we have compiled-in VFS hooks.  So an (unlikely) failure here
@@ -862,6 +886,14 @@ static int __init inotify_user_setup(voi
 	inotify_max_user_instances = 128;
 	inotify_max_user_watches = 8192;
 
+	inotify_register_fdinfo_driver();
+
 	return 0;
 }
 module_init(inotify_user_setup);
+
+static void __exit inotify_user_exit(void)
+{
+	inotify_unregister_fdinfo_driver();
+}
+module_exit(inotify_user_exit);
