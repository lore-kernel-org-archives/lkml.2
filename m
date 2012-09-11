Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424Ab2IKOvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:51:50 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34162 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759170Ab2IKOvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:51:48 -0400
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
        viro@zeniv.linux.org.uk, hch@lst.de, chris.mason@fusionio.com,
        cmm@us.ibm.com, linuxram@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC 11/11] vfs: add debugfs support
Date: Tue, 11 Sep 2012 22:40:45 +0800
Message-Id: <1347374445-3018-6-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1347374445-3018-1-git-send-email-zwu.kernel@gmail.com>
References: <1347374445-3018-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091114-7182-0000-0000-0000029312AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add a /sys/kernel/debug/hot_track/<device_name>/ directory for each
volume that contains two files. The first, `inode_data', contains the
heat information for inodes that have been brought into the hot data map
structures. The second, `range_data', contains similar information for
subfile ranges.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/Makefile      |    2 +-
 fs/hot_debugfs.c |  488 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/hot_debugfs.h |   60 +++++++
 fs/hot_track.c   |    1 +
 fs/hot_track.h   |    3 +-
 fs/namespace.c   |    6 +
 6 files changed, 557 insertions(+), 3 deletions(-)
 create mode 100644 fs/hot_debugfs.c
 create mode 100644 fs/hot_debugfs.h

diff --git a/fs/Makefile b/fs/Makefile
index f925a66..a70f288 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -12,7 +12,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
 		stack.o fs_struct.o statfs.o \
-		hot_rb.o hot_track.o hot_hash.o
+		hot_rb.o hot_track.o hot_hash.o hot_debugfs.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
diff --git a/fs/hot_debugfs.c b/fs/hot_debugfs.c
new file mode 100644
index 0000000..362f093
--- /dev/null
+++ b/fs/hot_debugfs.c
@@ -0,0 +1,488 @@
+/*
+ * fs/hot_debugfs.c
+ *
+ * This file contains the code to interface with the debugfs.
+ * The debugfs outputs range- and file-level access frequency
+ * statistics for each mounted volume.
+ *
+ * Copyright (C) 2012 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *            Ben Chociej <bchociej@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+#include <linux/limits.h>
+#include <linux/slab.h>
+#include "hot_debugfs.h"
+
+/* list to keep track of each mounted volumes debugfs_vol_data */
+static struct list_head hot_debugfs_vol_data_list;
+
+/* lock for debugfs_vol_data_list */
+static spinlock_t hot_debugfs_data_list_lock;
+
+/* pointer to top level debugfs dentry */
+static struct dentry *hot_debugfs_root_dentry;
+
+static int hot_debugfs_copy(struct debugfs_vol_data *data, char *msg, int len)
+{
+	struct lstring *debugfs_log = data->debugfs_log;
+	uint new_log_alloc_size;
+	char *new_log;
+	static char err_msg[] = "No more memory!\n";
+
+	if (len >= data->log_alloc_size - debugfs_log->len) {
+		/* Not enough room in the log buffer for the new message. */
+		/* Allocate a bigger buffer. */
+		new_log_alloc_size = data->log_alloc_size + LOG_PAGE_SIZE;
+		new_log = vmalloc(new_log_alloc_size);
+
+		if (new_log) {
+			memcpy(new_log, debugfs_log->str, debugfs_log->len);
+			memset(new_log + debugfs_log->len, 0,
+				new_log_alloc_size - debugfs_log->len);
+			vfree(debugfs_log->str);
+			debugfs_log->str = new_log;
+			data->log_alloc_size = new_log_alloc_size;
+		} else {
+			WARN_ON(1);
+			if (data->log_alloc_size - debugfs_log->len) {
+				strlcpy(debugfs_log->str +
+				debugfs_log->len,
+				err_msg,
+				data->log_alloc_size - debugfs_log->len);
+				debugfs_log->len +=
+				min((typeof(debugfs_log->len))
+				sizeof(err_msg),
+				((typeof(debugfs_log->len))
+				data->log_alloc_size - debugfs_log->len));
+			}
+			return 0;
+		}
+	}
+
+	memcpy(debugfs_log->str + debugfs_log->len, data->log_work_buff, len);
+	debugfs_log->len += (unsigned long) len;
+
+	return len;
+}
+
+/* Returns the number of bytes written to the log. */
+static int hot_debugfs_log(struct debugfs_vol_data *data, const char *fmt, ...)
+{
+	struct lstring *debugfs_log = data->debugfs_log;
+	va_list args;
+	int len;
+	static char trunc_msg[] =
+			"The next message has been truncated.\n";
+
+	if (debugfs_log->str == NULL)
+		return -1;
+
+	spin_lock(&data->log_lock);
+
+	va_start(args, fmt);
+	len = vsnprintf(data->log_work_buff,
+			sizeof(data->log_work_buff), fmt, args);
+	va_end(args);
+
+	if (len >= sizeof(data->log_work_buff)) {
+		hot_debugfs_copy(data, trunc_msg, sizeof(trunc_msg));
+	}
+
+	len = hot_debugfs_copy(data, data->log_work_buff, len);
+	spin_unlock(&data->log_lock);
+
+	return len;
+}
+
+/* initialize a log corresponding to a fs volume */
+static int hot_debugfs_log_init(struct debugfs_vol_data *data)
+{
+	int err = 0;
+	struct lstring *debugfs_log = data->debugfs_log;
+
+	spin_lock(&data->log_lock);
+	debugfs_log->str = vmalloc(INIT_LOG_ALLOC_SIZE);
+	if (debugfs_log->str) {
+		memset(debugfs_log->str, 0, INIT_LOG_ALLOC_SIZE);
+		data->log_alloc_size = INIT_LOG_ALLOC_SIZE;
+	} else {
+		err = -ENOMEM;
+	}
+	spin_unlock(&data->log_lock);
+
+	return err;
+}
+
+/* free a log corresponding to a fs volume */
+static void hot_debugfs_log_exit(struct debugfs_vol_data *data)
+{
+	struct lstring *debugfs_log = data->debugfs_log;
+
+	spin_lock(&data->log_lock);
+	vfree(debugfs_log->str);
+	debugfs_log->str = NULL;
+	debugfs_log->len = 0;
+	spin_unlock(&data->log_lock);
+}
+
+/* debugfs open file override from fops table */
+static int __hot_debugfs_open(struct inode *inode, struct file *file)
+{
+	if (inode->i_private)
+		file->private_data = inode->i_private;
+
+	return 0;
+}
+
+static void __hot_debugfs_print_range_freq_data(
+			struct hot_inode_item *hot_inode,
+			struct hot_range_item *hot_range,
+			struct debugfs_vol_data *data,
+			struct hot_info *root)
+{
+	struct hot_freq_data *freq_data;
+	u64 start;
+	u64 len;
+
+	freq_data = &hot_range->hot_freq_data;
+
+	spin_lock(&hot_range->lock);
+	start = hot_range->start;
+	len = hot_range->len;
+	spin_unlock(&hot_range->lock);
+
+	/* Always lock hot_inode_item first */
+	spin_lock(&hot_inode->lock);
+	spin_lock(&hot_range->lock);
+	hot_debugfs_log(data, "inode #%lu, range start " \
+			"%llu (range len %llu) reads %u, writes %u, "
+			"avg read time %llu, avg write time %llu, temp %u\n",
+			hot_inode->i_ino,
+			hot_range->start,
+			hot_range->len,
+			freq_data->nr_reads,
+			freq_data->nr_writes,
+			freq_data->avg_delta_reads,
+			freq_data->avg_delta_writes,
+			freq_data->last_temperature);
+	spin_unlock(&hot_range->lock);
+	spin_unlock(&hot_inode->lock);
+}
+
+/*
+ * take the inode, find ranges associated with inode
+ * and print each range data struct
+ */
+static void __hot_debugfs_walk_range_tree(struct hot_inode_item *hot_inode,
+				struct debugfs_vol_data *data,
+				struct hot_info *root)
+{
+	struct hot_range_tree *inode_range_tree;
+	struct rb_node *node;
+	struct hot_range_item *current_range;
+
+	inode_range_tree = &hot_inode->hot_range_tree;
+	read_lock(&inode_range_tree->lock);
+	node = rb_first(&inode_range_tree->map);
+
+	/* Walk the hot_range_tree for inode */
+	while (node) {
+		current_range = rb_entry(node, struct hot_range_item, rb_node);
+		__hot_debugfs_print_range_freq_data(hot_inode,
+						current_range, data, root);
+		node = rb_next(node);
+	}
+	read_unlock(&inode_range_tree->lock);
+}
+
+/* Print frequency data for each freq data to log */
+static void __hot_debugfs_print_inode_freq_data(
+				struct hot_inode_item *hot_inode,
+				struct debugfs_vol_data *data,
+				struct hot_info *root)
+{
+	struct hot_freq_data *freq_data = &hot_inode->hot_freq_data;
+
+	spin_lock(&hot_inode->lock);
+	hot_debugfs_log(data, "inode #%lu, reads %u, writes %u, " \
+		"avg read time %llu, avg write time %llu, temp %u\n",
+		hot_inode->i_ino,
+		freq_data->nr_reads,
+		freq_data->nr_writes,
+		freq_data->avg_delta_reads,
+		freq_data->avg_delta_writes,
+		freq_data->last_temperature);
+	spin_unlock(&hot_inode->lock);
+}
+
+/* debugfs read file override from fops table */
+static ssize_t __hot_debugfs_range_read(struct file *file, char __user *user,
+					size_t count, loff_t *ppos)
+{
+	int err = 0;
+	struct hot_info *root;
+	struct hot_inode_item *current_hot_inode;
+	struct debugfs_vol_data *data;
+	struct lstring *debugfs_log;
+	unsigned long inode_num;
+
+	data = (struct debugfs_vol_data *) file->private_data;
+	root = &(data->sb->s_hotinfo);
+
+	if (!data->debugfs_log) {
+		/* initialize debugfs log corresponding to this volume*/
+		debugfs_log = kmalloc(sizeof(struct lstring),
+				GFP_KERNEL | GFP_NOFS);
+		debugfs_log->str = NULL,
+		debugfs_log->len = 0;
+		data->debugfs_log = debugfs_log;
+		hot_debugfs_log_init(data);
+	}
+
+	if ((unsigned long) *ppos > 0) {
+		/* caller is continuing a previous read, don't walk tree */
+		if ((unsigned long) *ppos >= data->debugfs_log->len)
+			goto clean_up;
+
+		goto print_to_user;
+	}
+
+	/* walk the inode tree */
+	current_hot_inode = hot_rb_find_next_hot_inode(root, 0);
+
+	while (current_hot_inode) {
+		/* walk ranges, print data to debugfs log */
+		__hot_debugfs_walk_range_tree(current_hot_inode, data, root);
+		inode_num = current_hot_inode->i_ino;
+		hot_rb_free_hot_inode_item(current_hot_inode);
+		current_hot_inode = hot_rb_find_next_hot_inode(root,
+							inode_num + 1);
+	}
+
+print_to_user:
+	if (data->debugfs_log->len) {
+		err = simple_read_from_buffer(user, count, ppos,
+						data->debugfs_log->str,
+						data->debugfs_log->len);
+	}
+
+	return err;
+
+clean_up:
+	/* Reader has finished the file, clean up */
+	hot_debugfs_log_exit(data);
+	kfree(data->debugfs_log);
+	data->debugfs_log = NULL;
+
+	return 0;
+}
+
+/* debugfs read file override from fops table */
+static ssize_t __hot_debugfs_inode_read(struct file *file, char __user *user,
+					size_t count, loff_t *ppos)
+{
+	int err = 0;
+	struct hot_info *root;
+	struct hot_inode_item *current_hot_inode;
+	struct debugfs_vol_data *data;
+	struct lstring *debugfs_log;
+	unsigned long inode_num;
+
+	data = (struct debugfs_vol_data *) file->private_data;
+	root = &(data->sb->s_hotinfo);
+
+	if (!data->debugfs_log) {
+		/* initialize debugfs log corresponding to this volume */
+		debugfs_log = kmalloc(sizeof(struct lstring),
+					GFP_KERNEL | GFP_NOFS);
+		debugfs_log->str = NULL,
+		debugfs_log->len = 0;
+		data->debugfs_log = debugfs_log;
+		hot_debugfs_log_init(data);
+	}
+
+	if ((unsigned long) *ppos > 0) {
+		/* caller is continuing a previous read, don't walk tree */
+		if ((unsigned long) *ppos >= data->debugfs_log->len)
+			goto clean_up;
+
+			goto print_to_user;
+	}
+
+	/* walk the inode tree */
+	current_hot_inode = hot_rb_find_next_hot_inode(root, 0);
+
+	while (current_hot_inode) {
+		/* walk ranges, print data to debugfs log */
+		__hot_debugfs_print_inode_freq_data(current_hot_inode,
+							data, root);
+		inode_num = current_hot_inode->i_ino;
+		hot_rb_free_hot_inode_item(current_hot_inode);
+		current_hot_inode = hot_rb_find_next_hot_inode(root,
+								inode_num+1);
+	}
+
+print_to_user:
+	if (data->debugfs_log->len) {
+		err = simple_read_from_buffer(user, count, ppos,
+					data->debugfs_log->str,
+					data->debugfs_log->len);
+	}
+
+	return err;
+
+clean_up:
+	/* reader has finished the file, clean up */
+	hot_debugfs_log_exit(data);
+	kfree(data->debugfs_log);
+	data->debugfs_log = NULL;
+
+	return 0;
+}
+
+/* fops to override for printing range data */
+static const struct file_operations hot_debugfs_range_fops = {
+	.read = __hot_debugfs_range_read,
+	.open = __hot_debugfs_open,
+};
+
+/* fops to override for printing inode data */
+static const struct file_operations hot_debugfs_inode_fops = {
+	.read = __hot_debugfs_inode_read,
+	.open = __hot_debugfs_open,
+};
+
+/* initialize debugfs at module init */
+int hot_debugfs_init(void)
+{
+	hot_debugfs_root_dentry = debugfs_create_dir(DEBUGFS_ROOT_NAME, NULL);
+	/*init list of debugfs data list */
+	INIT_LIST_HEAD(&hot_debugfs_vol_data_list);
+	/*init lock to list of debugfs data list */
+	spin_lock_init(&hot_debugfs_data_list_lock);
+	if (!hot_debugfs_root_dentry)
+		goto debugfs_error;
+
+	return 0;
+
+debugfs_error:
+	return -EIO;
+}
+
+/*
+ * on each volume mount, initialize the debugfs dentries and associated
+ * structures (debugfs_vol_data and debugfs_log)
+ */
+int hot_debugfs_volume_init(const char *uuid, struct super_block *sb)
+{
+	struct dentry *debugfs_volume_entry = NULL;
+	struct dentry *debugfs_range_entry = NULL;
+	struct dentry *debugfs_inode_entry = NULL;
+	struct debugfs_vol_data *range_data = NULL;
+	struct debugfs_vol_data *inode_data = NULL;
+	size_t dev_name_length = strlen(uuid);
+	char dev[NAME_MAX];
+
+	if (!hot_debugfs_root_dentry)
+		goto debugfs_error;
+
+	/* create debugfs folder for this volume by mounted dev name */
+	memcpy(dev, uuid + DEV_NAME_CHOP, dev_name_length - DEV_NAME_CHOP + 1);
+	debugfs_volume_entry = debugfs_create_dir(dev, hot_debugfs_root_dentry);
+
+	if (!debugfs_volume_entry)
+		goto debugfs_error;
+
+	/* malloc and initialize debugfs_vol_data for range_data */
+	range_data = kmalloc(sizeof(struct debugfs_vol_data),
+				GFP_KERNEL | GFP_NOFS);
+	memset(range_data, 0, sizeof(struct debugfs_vol_data));
+	range_data->debugfs_log = NULL;
+	range_data->sb = sb;
+	spin_lock_init(&range_data->log_lock);
+	range_data->log_alloc_size = 0;
+
+	/* malloc and initialize debugfs_vol_data for range_data */
+	inode_data = kmalloc(sizeof(struct debugfs_vol_data),
+				GFP_KERNEL | GFP_NOFS);
+	memset(inode_data, 0, sizeof(struct debugfs_vol_data));
+	inode_data->debugfs_log = NULL;
+	inode_data->sb = sb;
+	spin_lock_init(&inode_data->log_lock);
+	inode_data->log_alloc_size = 0;
+
+	/*
+	 * add debugfs_vol_data for inode data and range data for
+	 * volume to list
+	 */
+	range_data->de = debugfs_volume_entry;
+	inode_data->de = debugfs_volume_entry;
+	spin_lock(&hot_debugfs_data_list_lock);
+	list_add(&range_data->node, &hot_debugfs_vol_data_list);
+	list_add(&inode_data->node, &hot_debugfs_vol_data_list);
+	spin_unlock(&hot_debugfs_data_list_lock);
+
+	/* create debugfs range_data file */
+	debugfs_range_entry = debugfs_create_file("range_data",
+				S_IFREG | S_IRUSR | S_IWUSR | S_IRUGO,
+				debugfs_volume_entry,
+				(void *) range_data,
+				&hot_debugfs_range_fops);
+	if (!debugfs_range_entry)
+		goto debugfs_error;
+
+	/* create debugfs inode_data file */
+	debugfs_inode_entry = debugfs_create_file("inode_data",
+				S_IFREG | S_IRUSR | S_IWUSR | S_IRUGO,
+				debugfs_volume_entry,
+				(void *) inode_data,
+				&hot_debugfs_inode_fops);
+
+	if (!debugfs_inode_entry)
+		goto debugfs_error;
+
+	return 0;
+
+debugfs_error:
+	kfree(range_data);
+	kfree(inode_data);
+
+	return -EIO;
+}
+
+/*
+ * find volume mounted (match by superblock) and remove
+ * debugfs dentry
+ */
+void hot_debugfs_volume_exit(struct super_block *sb)
+{
+	struct list_head *head;
+	struct list_head *pos;
+	struct debugfs_vol_data *data;
+
+	spin_lock(&hot_debugfs_data_list_lock);
+	head = &hot_debugfs_vol_data_list;
+	/* must clean up memory assicatied with superblock */
+	list_for_each(pos, head)
+	{
+		data = list_entry(pos, struct debugfs_vol_data, node);
+		if (data->sb == sb) {
+			list_del(pos);
+			debugfs_remove_recursive(data->de);
+			kfree(data);
+			data = NULL;
+			break;
+		}
+	}
+	spin_unlock(&hot_debugfs_data_list_lock);
+}
diff --git a/fs/hot_debugfs.h b/fs/hot_debugfs.h
new file mode 100644
index 0000000..977ad4c
--- /dev/null
+++ b/fs/hot_debugfs.h
@@ -0,0 +1,60 @@
+/*
+ * fs/debugfs.h
+ *
+ * Copyright (C) 2012 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *            Ben Chociej <bchociej@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ */
+
+#ifndef __HOT_DEBUGFS__
+#define __HOT_DEBUGFS__
+
+#include <linux/fs.h>
+#include "hot_rb.h"
+#include "hot_hash.h"
+
+/* size of log to vmalloc */
+#define INIT_LOG_ALLOC_SIZE (PAGE_SIZE * 10)
+#define LOG_PAGE_SIZE (PAGE_SIZE * 10)
+
+/*
+ * number of chars of device name of chop off for making debugfs folder
+ * e.g. /dev/sda -> sda
+ *
+ * TODO: use something better for this
+ */
+#define DEV_NAME_CHOP 5
+
+/*
+ * Name for VFS data in debugfs directory
+ * e.g. /sys/kernel/debug/hot_track
+ */
+#define DEBUGFS_ROOT_NAME "hot_track"
+
+/* log to output to userspace in debugfs files */
+struct lstring {
+	char *str;
+	unsigned long len;
+};
+
+/* debugfs_vol_data is a struct of items that is passed to the debugfs */
+struct debugfs_vol_data {
+	struct list_head node; /* protected by data_list_lock */
+	struct lstring *debugfs_log;
+	struct super_block *sb;
+	struct dentry *de;
+	spinlock_t log_lock; /* protects debugfs_log */
+	char log_work_buff[1024];
+	uint log_alloc_size;
+};
+
+int hot_debugfs_init(void);
+void hot_debugfs_exit(void);
+int hot_debugfs_volume_init(const char *, struct super_block *);
+void hot_debugfs_volume_exit(struct super_block *);
+
+#endif /* __HOT_DEBUGFS__ */
diff --git a/fs/hot_track.c b/fs/hot_track.c
index be5bae4..ae113db 100644
--- a/fs/hot_track.c
+++ b/fs/hot_track.c
@@ -81,4 +81,5 @@ void hot_track_exit(struct super_block *sb)
 	sb->s_hotinfo.mount_opt &= ~HOT_MOUNT_HOT_TRACK;
 	hot_hash_free_heat_hash_list(&sb->s_hotinfo);
 	hot_rb_free_hot_inode_tree(&sb->s_hotinfo);
+	hot_debugfs_volume_exit(sb);
 }
diff --git a/fs/hot_track.h b/fs/hot_track.h
index e137142..3cb5a01 100644
--- a/fs/hot_track.h
+++ b/fs/hot_track.h
@@ -13,8 +13,7 @@
 #ifndef __HOT_TRACK__
 #define __HOT_TRACK__
 
-#include "hot_rb.h"
-#include "hot_hash.h"
+#include "hot_debugfs.h"
 
 bool hot_track_parse_options(char *options);
 void __init hot_track_item_cache_init(void);
diff --git a/fs/namespace.c b/fs/namespace.c
index 90c958a..6843489 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2629,6 +2629,12 @@ void __init mnt_init(void)
 	fs_kobj = kobject_create_and_add("fs", NULL);
 	if (!fs_kobj)
 		printk(KERN_WARNING "%s: kobj create error\n", __func__);
+
+	err = hot_debugfs_init();
+	if (err)
+		printk(KERN_WARNING "%s: sysfs_init error: %d\n",
+			__func__, err);
+
 	init_rootfs();
 	init_mount_tree();
 }
-- 
1.7.6.5

