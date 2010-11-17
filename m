Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676Ab0KQBAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:00:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34210 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293Ab0KQA7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:59:42 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=8D6FMKkzazgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=2C6YHBdLAAAA:8 a=HVDBIXjw6cNcnZUHYKIA:9 a=quiuSDN3OIYiqlQaeWcA:7 a=cSlreN6gPm3BJMu9eozrzRVfToAA:4 a=jEp0ucaQiEUA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=mJMriH8CDpcA:10 a=z-NE1wRl4_b40_qK:21 a=NcBFGWyZJkZPTjpX:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101117005939.600541101@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 16 Nov 2010 19:53:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Greg KH <gregkh@suse.de>
Subject: [RFC][PATCH 1/5] [PATCH 1/5] events: Add EVENT_FS the event filesystem
References: <20101117005357.024472450@goodmis.org>
Content-Disposition: inline; filename=0001-events-Add-EVENT_FS-the-event-filesystem.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Copied mostly from debugfs, the eventfs is the filesystem
that will include stable tracepoints. Currently nothing
enables this filesystem as of this patch.

Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/Kconfig              |    6 +
 fs/Makefile             |    1 +
 fs/eventfs/Makefile     |    4 +
 fs/eventfs/file.c       |   53 ++++++
 fs/eventfs/inode.c      |  433 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/eventfs.h |   83 +++++++++
 include/linux/magic.h   |    3 +-
 7 files changed, 582 insertions(+), 1 deletions(-)
 create mode 100644 fs/eventfs/Makefile
 create mode 100644 fs/eventfs/file.c
 create mode 100644 fs/eventfs/inode.c
 create mode 100644 include/linux/eventfs.h

diff --git a/fs/Kconfig b/fs/Kconfig
index 771f457..ffd3a8b 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -250,6 +250,12 @@ source "fs/partitions/Kconfig"
 endmenu
 endif
 
+config EVENT_FS
+       bool
+	help
+	  The event filesystem, usually mounted at /sys/kernel/events.
+	  This option is selected by other configs that require it.
+
 source "fs/nls/Kconfig"
 source "fs/dlm/Kconfig"
 
diff --git a/fs/Makefile b/fs/Makefile
index a7f7cef..4fe02d4 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -116,6 +116,7 @@ obj-$(CONFIG_HOSTFS)		+= hostfs/
 obj-$(CONFIG_HPPFS)		+= hppfs/
 obj-$(CONFIG_CACHEFILES)	+= cachefiles/
 obj-$(CONFIG_DEBUG_FS)		+= debugfs/
+obj-$(CONFIG_EVENT_FS)		+= eventfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_BTRFS_FS)		+= btrfs/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
diff --git a/fs/eventfs/Makefile b/fs/eventfs/Makefile
new file mode 100644
index 0000000..5e991a5
--- /dev/null
+++ b/fs/eventfs/Makefile
@@ -0,0 +1,4 @@
+eventfs-objs	:= inode.o file.o
+
+obj-$(CONFIG_EVENT_FS)	+= eventfs.o
+
diff --git a/fs/eventfs/file.c b/fs/eventfs/file.c
new file mode 100644
index 0000000..7b4cd64
--- /dev/null
+++ b/fs/eventfs/file.c
@@ -0,0 +1,53 @@
+/*
+ *  file.c - part of eventfs, hierarchy structure for stable tracepoints
+ *
+ * Initially copied from debugfs which is:
+ *  Copyright (C) 2004 Greg Kroah-Hartman <greg@kroah.com>
+ *  Copyright (C) 2004 IBM Inc.
+ *
+ * Conversion to eventfs:
+ *  Copyright (C) 2010 Steven Rostedt <srostedt@redhat.com>, Red Hat Inc
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License version
+ *	2 as published by the Free Software Foundation.
+ *
+ *  eventfs is for stable tracepoints. Linus has stated that these tracepoints
+ *  should not contain any module tracepoints, thus no function will be
+ *  exported.
+ *  See Documentation/DocBook/filesystems for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/pagemap.h>
+#include <linux/namei.h>
+#include <linux/eventfs.h>
+
+static ssize_t default_read_file(struct file *file, char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	return 0;
+}
+
+static ssize_t default_write_file(struct file *file, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	return count;
+}
+
+static int default_open(struct inode *inode, struct file *file)
+{
+	if (inode->i_private)
+		file->private_data = inode->i_private;
+
+	return 0;
+}
+
+const struct file_operations eventfs_file_operations = {
+	.read =		default_read_file,
+	.write =	default_write_file,
+	.open =		default_open,
+	.llseek =	noop_llseek,
+};
diff --git a/fs/eventfs/inode.c b/fs/eventfs/inode.c
new file mode 100644
index 0000000..07b8091
--- /dev/null
+++ b/fs/eventfs/inode.c
@@ -0,0 +1,433 @@
+/*
+ *  inode.c - part of eventfs, hierarchy structure for stable tracepoints
+ *
+ * Initially copied from debugfs which is:
+ *  Copyright (C) 2004 Greg Kroah-Hartman <greg@kroah.com>
+ *  Copyright (C) 2004 IBM Inc.
+ *
+ * Conversion to eventfs:
+ *  Copyright (C) 2010 Steven Rostedt <srostedt@redhat.com>, Red Hat Inc
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License version
+ *	2 as published by the Free Software Foundation.
+ *
+ *  eventfs is for stable tracepoints. Linus has stated that these tracepoints
+ *  should not contain any module tracepoints, thus no function will be
+ *  exported.
+ *  See Documentation/DocBook/filesystems for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/pagemap.h>
+#include <linux/init.h>
+#include <linux/kobject.h>
+#include <linux/namei.h>
+#include <linux/eventfs.h>
+#include <linux/fsnotify.h>
+#include <linux/string.h>
+#include <linux/magic.h>
+#include <linux/slab.h>
+
+static struct vfsmount *eventfs_mount;
+static int eventfs_mount_count;
+static bool eventfs_registered;
+
+static struct inode *
+eventfs_get_inode(struct super_block *sb, int mode, dev_t dev,
+		  void *data, const struct file_operations *fops)
+
+{
+	struct inode *inode;
+
+	/* links are not currently supported */
+	if ((mode & S_IFMT) == S_IFLNK)
+		return NULL;
+
+	inode = new_inode(sb);
+
+	if (inode) {
+		inode->i_ino = get_next_ino();
+		inode->i_mode = mode;
+		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		switch (mode & S_IFMT) {
+		default:
+			init_special_inode(inode, mode, dev);
+			break;
+		case S_IFREG:
+			inode->i_fop = fops ? fops : &eventfs_file_operations;
+			inode->i_private = data;
+			break;
+		case S_IFDIR:
+			inode->i_op = &simple_dir_inode_operations;
+			inode->i_fop = fops ? fops : &simple_dir_operations;
+			inode->i_private = data;
+
+			/* directory inodes start off with i_nlink == 2
+			 * (for "." entry) */
+			inc_nlink(inode);
+			break;
+		}
+	}
+	return inode;
+}
+
+/* SMP-safe */
+static int eventfs_mknod(struct inode *dir, struct dentry *dentry,
+			 int mode, dev_t dev, void *data,
+			 const struct file_operations *fops)
+{
+	struct inode *inode;
+	int error = -EPERM;
+
+	if (dentry->d_inode)
+		return -EEXIST;
+
+	inode = eventfs_get_inode(dir->i_sb, mode, dev, data, fops);
+	if (inode) {
+		d_instantiate(dentry, inode);
+		dget(dentry);
+		error = 0;
+	}
+	return error;
+}
+
+static int eventfs_mkdir(struct inode *dir, struct dentry *dentry, int mode,
+			 void *data, const struct file_operations *fops)
+{
+	int res;
+
+	mode = (mode & (S_IRWXUGO | S_ISVTX)) | S_IFDIR;
+	res = eventfs_mknod(dir, dentry, mode, 0, data, fops);
+	if (!res) {
+		inc_nlink(dir);
+		fsnotify_mkdir(dir, dentry);
+	}
+	return res;
+}
+
+static int eventfs_create(struct inode *dir, struct dentry *dentry, int mode,
+			  void *data, const struct file_operations *fops)
+{
+	int res;
+
+	mode = (mode & S_IALLUGO) | S_IFREG;
+	res = eventfs_mknod(dir, dentry, mode, 0, data, fops);
+	if (!res)
+		fsnotify_create(dir, dentry);
+	return res;
+}
+
+static inline int eventfs_positive(struct dentry *dentry)
+{
+	return dentry->d_inode && !d_unhashed(dentry);
+}
+
+static int event_fill_super(struct super_block *sb, void *data, int silent)
+{
+	static struct tree_descr event_files[] = { {""} };
+
+	return simple_fill_super(sb, EVENTFS_MAGIC, event_files);
+}
+
+static struct dentry *event_mount(struct file_system_type *fs_type,
+			int flags, const char *dev_name,
+			void *data)
+{
+	return mount_single(fs_type, flags, data, event_fill_super);
+}
+
+static struct file_system_type event_fs_type = {
+	.owner =	THIS_MODULE,
+	.name =		"eventfs",
+	.mount =	event_mount,
+	.kill_sb =	kill_litter_super,
+};
+
+static int eventfs_create_by_name(const char *name, mode_t mode,
+				  struct dentry *parent,
+				  struct dentry **dentry,
+				  void *data,
+				  const struct file_operations *fops)
+{
+	int error = 0;
+
+	/* If the parent is not specified, we create it in the root.
+	 * We need the root dentry to do this, which is in the super
+	 * block. A pointer to that is in the struct vfsmount that we
+	 * have around.
+	 */
+	if (!parent)
+		parent = eventfs_mount->mnt_sb->s_root;
+
+	*dentry = NULL;
+	mutex_lock(&parent->d_inode->i_mutex);
+	*dentry = lookup_one_len(name, parent, strlen(name));
+	if (!IS_ERR(*dentry)) {
+		switch (mode & S_IFMT) {
+		case S_IFDIR:
+			error = eventfs_mkdir(parent->d_inode, *dentry, mode,
+					      data, fops);
+			break;
+		case S_IFLNK:
+			error = -EINVAL;
+			break;
+		default:
+			error = eventfs_create(parent->d_inode, *dentry, mode,
+					       data, fops);
+			break;
+		}
+		dput(*dentry);
+	} else
+		error = PTR_ERR(*dentry);
+	mutex_unlock(&parent->d_inode->i_mutex);
+
+	return error;
+}
+
+/**
+ * eventfs_create_file - create a file in the eventfs filesystem
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have.
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this paramater is NULL, then the
+ *          file will be created in the root of the eventfs filesystem.
+ * @data: a pointer to something that the caller will want to get to later
+ *        on.  The inode.i_private pointer will point to this value on
+ *        the open() call.
+ * @fops: a pointer to a struct file_operations that should be used for
+ *        this file.
+ *
+ * This is the basic "create a file" function for eventfs.  It allows for a
+ * wide range of flexibility in creating a file, or a directory (if you want
+ * to create a directory, the eventfs_create_dir() function is
+ * recommended to be used instead.)
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the eventfs_remove() function when the file is
+ * to be removed (no automatic cleanup happens if your module is unloaded,
+ * you are responsible here.)  If an error occurs, %NULL will be returned.
+ *
+ * If eventfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.
+ */
+struct dentry *eventfs_create_file(const char *name, mode_t mode,
+				   struct dentry *parent, void *data,
+				   const struct file_operations *fops)
+{
+	struct dentry *dentry = NULL;
+	int error;
+
+	pr_debug("eventfs: creating file '%s'\n", name);
+
+	error = simple_pin_fs(&event_fs_type, &eventfs_mount,
+			      &eventfs_mount_count);
+	if (error)
+		goto exit;
+
+	error = eventfs_create_by_name(name, mode, parent, &dentry,
+				       data, fops);
+	if (error) {
+		dentry = NULL;
+		simple_release_fs(&eventfs_mount, &eventfs_mount_count);
+		goto exit;
+	}
+exit:
+	return dentry;
+}
+
+/**
+ * eventfs_create_dir - create a directory in the eventfs filesystem
+ * @name: a pointer to a string containing the name of the directory to
+ *        create.
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this paramater is NULL, then the
+ *          directory will be created in the root of the eventfs filesystem.
+ *
+ * This function creates a directory in eventfs with the given name.
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the eventfs_remove() function when the file is
+ * to be removed (no automatic cleanup happens if your module is unloaded,
+ * you are responsible here.)  If an error occurs, %NULL will be returned.
+ *
+ * If eventfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.
+ */
+struct dentry *eventfs_create_dir(const char *name, struct dentry *parent)
+{
+	return eventfs_create_file(name,
+				   S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
+				   parent, NULL, NULL);
+}
+
+static void __eventfs_remove(struct dentry *dentry, struct dentry *parent)
+{
+	int ret = 0;
+
+	if (eventfs_positive(dentry)) {
+		if (dentry->d_inode) {
+			dget(dentry);
+			switch (dentry->d_inode->i_mode & S_IFMT) {
+			case S_IFDIR:
+				ret = simple_rmdir(parent->d_inode, dentry);
+				break;
+			case S_IFLNK:
+				kfree(dentry->d_inode->i_private);
+				/* fall through */
+			default:
+				simple_unlink(parent->d_inode, dentry);
+				break;
+			}
+			if (!ret)
+				d_delete(dentry);
+			dput(dentry);
+		}
+	}
+}
+
+/**
+ * eventfs_remove - removes a file or directory from the eventfs filesystem
+ * @dentry: a pointer to a the dentry of the file or directory to be
+ *          removed.
+ *
+ * This function removes a file or directory in eventfs that was previously
+ * created with a call to another eventfs function (like
+ * eventfs_create_file() or variants thereof.)
+ *
+ * This function is required to be called in order for the file to be
+ * removed, no automatic cleanup of files will happen when a module is
+ * removed, you are responsible here.
+ */
+void eventfs_remove(struct dentry *dentry)
+{
+	struct dentry *parent;
+
+	if (!dentry)
+		return;
+
+	parent = dentry->d_parent;
+	if (!parent || !parent->d_inode)
+		return;
+
+	mutex_lock(&parent->d_inode->i_mutex);
+	__eventfs_remove(dentry, parent);
+	mutex_unlock(&parent->d_inode->i_mutex);
+	simple_release_fs(&eventfs_mount, &eventfs_mount_count);
+}
+
+/**
+ * eventfs_remove_recursive - recursively removes a directory
+ * @dentry: a pointer to a the dentry of the directory to be removed.
+ *
+ * This function recursively removes a directory tree in eventfs that
+ * was previously created with a call to another eventfs function
+ * (like eventfs_create_file() or variants thereof.)
+ *
+ * This function is required to be called in order for the file to be
+ * removed, no automatic cleanup of files will happen when a module is
+ * removed, you are responsible here.
+ */
+void eventfs_remove_recursive(struct dentry *dentry)
+{
+	struct dentry *child;
+	struct dentry *parent;
+
+	if (!dentry)
+		return;
+
+	parent = dentry->d_parent;
+	if (!parent || !parent->d_inode)
+		return;
+
+	parent = dentry;
+	mutex_lock(&parent->d_inode->i_mutex);
+
+	while (1) {
+		/*
+		 * When all dentries under "parent" has been removed,
+		 * walk up the tree until we reach our starting point.
+		 */
+		if (list_empty(&parent->d_subdirs)) {
+			mutex_unlock(&parent->d_inode->i_mutex);
+			if (parent == dentry)
+				break;
+			parent = parent->d_parent;
+			mutex_lock(&parent->d_inode->i_mutex);
+		}
+		child = list_entry(parent->d_subdirs.next, struct dentry,
+				d_u.d_child);
+ next_sibling:
+
+		/*
+		 * If "child" isn't empty, walk down the tree and
+		 * remove all its descendants first.
+		 */
+		if (!list_empty(&child->d_subdirs)) {
+			mutex_unlock(&parent->d_inode->i_mutex);
+			parent = child;
+			mutex_lock(&parent->d_inode->i_mutex);
+			continue;
+		}
+		__eventfs_remove(child, parent);
+		if (parent->d_subdirs.next == &child->d_u.d_child) {
+			/*
+			 * Try the next sibling.
+			 */
+			if (child->d_u.d_child.next != &parent->d_subdirs) {
+				child = list_entry(child->d_u.d_child.next,
+						   struct dentry,
+						   d_u.d_child);
+				goto next_sibling;
+			}
+
+			/*
+			 * Avoid infinite loop if we fail to remove
+			 * one dentry.
+			 */
+			mutex_unlock(&parent->d_inode->i_mutex);
+			break;
+		}
+		simple_release_fs(&eventfs_mount, &eventfs_mount_count);
+	}
+
+	parent = dentry->d_parent;
+	mutex_lock(&parent->d_inode->i_mutex);
+	__eventfs_remove(dentry, parent);
+	mutex_unlock(&parent->d_inode->i_mutex);
+	simple_release_fs(&eventfs_mount, &eventfs_mount_count);
+}
+
+/**
+ * eventfs_initialized - Tells whether eventfs has been registered
+ */
+bool eventfs_initialized(void)
+{
+	return eventfs_registered;
+}
+
+
+static struct kobject *event_kobj;
+
+static int __init eventfs_init(void)
+{
+	int retval;
+
+	event_kobj = kobject_create_and_add("event", kernel_kobj);
+	if (!event_kobj)
+		return -EINVAL;
+
+	retval = register_filesystem(&event_fs_type);
+	if (retval)
+		kobject_put(event_kobj);
+	else
+		eventfs_registered = true;
+
+	return retval;
+}
+
+core_initcall(eventfs_init);
+
diff --git a/include/linux/eventfs.h b/include/linux/eventfs.h
new file mode 100644
index 0000000..95b5c42
--- /dev/null
+++ b/include/linux/eventfs.h
@@ -0,0 +1,83 @@
+/*
+ *  eventfs.h - filesystem for stable events
+ *
+ * Initially copied from debugfs which is:
+ *  Copyright (C) 2004 Greg Kroah-Hartman <greg@kroah.com>
+ *  Copyright (C) 2004 IBM Inc.
+ *
+ * Conversion to eventfs:
+ *  Copyright (C) 2010 Steven Rostedt <srostedt@redhat.com>, Red Hat Inc
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License version
+ *	2 as published by the Free Software Foundation.
+ *
+ *  eventfs is for stable tracepoints. Linus has stated that these tracepoints
+ *  should not contain any module tracepoints, thus no function will be
+ *  exported.
+ *  See Documentation/DocBook/filesystems for more details.
+ */
+
+#ifndef _EVENTFS_H_
+#define _EVENTFS_H_
+
+#include <linux/fs.h>
+
+#include <linux/types.h>
+
+struct file_operations;
+
+#if defined(CONFIG_EVENT_FS)
+
+/* declared over in file.c */
+extern const struct file_operations eventfs_file_operations;
+extern const struct inode_operations eventfs_link_operations;
+
+struct dentry *eventfs_create_file(const char *name, mode_t mode,
+				   struct dentry *parent, void *data,
+				   const struct file_operations *fops);
+
+struct dentry *eventfs_create_dir(const char *name, struct dentry *parent);
+
+void eventfs_remove(struct dentry *dentry);
+void eventfs_remove_recursive(struct dentry *dentry);
+
+bool eventfs_initialized(void);
+
+#else
+
+#include <linux/err.h>
+
+/*
+ * We do not return NULL from these functions if CONFIG_EVENT_FS is not enabled
+ * so users have a chance to detect if there was a real error or not.  We don't
+ * want to duplicate the design decision mistakes of procfs and devfs again.
+ */
+
+static inline struct dentry *eventfs_create_file(const char *name, mode_t mode,
+					struct dentry *parent, void *data,
+					const struct file_operations *fops)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline struct dentry *eventfs_create_dir(const char *name,
+						struct dentry *parent)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline void eventfs_remove(struct dentry *dentry)
+{ }
+
+static inline void eventfs_remove_recursive(struct dentry *dentry)
+{ }
+
+static inline bool eventfs_initialized(void)
+{
+	return false;
+}
+
+#endif
+
+#endif
diff --git a/include/linux/magic.h b/include/linux/magic.h
index ff690d0..0126169 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@ -8,7 +8,8 @@
 #define CODA_SUPER_MAGIC	0x73757245
 #define CRAMFS_MAGIC		0x28cd3d45	/* some random number */
 #define CRAMFS_MAGIC_WEND	0x453dcd28	/* magic number with the wrong endianess */
-#define DEBUGFS_MAGIC          0x64626720
+#define DEBUGFS_MAGIC		0x64626720
+#define EVENTFS_MAGIC		0x65667310
 #define SYSFS_MAGIC		0x62656572
 #define SECURITYFS_MAGIC	0x73636673
 #define SELINUX_MAGIC		0xf97cff8c
-- 
1.7.1


