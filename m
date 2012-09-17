Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab2IQHTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:19:20 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46261 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab2IQHTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:19:16 -0400
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
        viro@zeniv.linux.org.uk, cmm@us.ibm.com, tytso@mit.edu,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC v1 03/11] vfs: introduce 2 rb tree items - inode and range
Date: Mon, 17 Sep 2012 15:18:37 +0800
Message-Id: <1347866325-25979-4-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1347866325-25979-1-git-send-email-zwu.kernel@gmail.com>
References: <1347866325-25979-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091707-5406-0000-0000-0000005AC449
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Define two items hot_inode_item and hot_range_item,
one of them represents one tracked file
to keep track of its access frequency and the tree of
ranges in this file, while the latter represents
a file range of one inode.
  Each of the two structures contains a hot_freq_data
struct with its frequency of access metrics (number of
{reads, writes}, last {read,write} time, frequency of
{reads,writes}).
  Also, each hot_inode_item contains one hot_range_tree
struct which is keyed by {inode, offset, length}
and used to keep track of all the ranges in this file.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/Makefile               |    2 +-
 fs/dcache.c               |    2 +
 fs/hot_rb.c               |   74 +++++++++++++++++++++++++++++++++++++++++++++
 fs/hot_rb.h               |    9 +++++
 fs/hot_track.c            |   26 ++++++++++++++++
 fs/hot_track.h            |   20 ++++++++++++
 include/linux/hot_track.h |   62 +++++++++++++++++++++++++++++++++++++
 7 files changed, 194 insertions(+), 1 deletions(-)
 create mode 100644 fs/hot_track.c
 create mode 100644 fs/hot_track.h

diff --git a/fs/Makefile b/fs/Makefile
index d3bc906..b4f620e 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -12,7 +12,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
 		stack.o fs_struct.o statfs.o \
-		hot_rb.o
+		hot_rb.o hot_track.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
diff --git a/fs/dcache.c b/fs/dcache.c
index 8086636..8ec6136 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -39,6 +39,7 @@
 #include <linux/ratelimit.h>
 #include "internal.h"
 #include "mount.h"
+#include "hot_track.h"
 
 /*
  * Usage:
@@ -3164,6 +3165,7 @@ void __init vfs_caches_init(unsigned long mempages)
 	inode_init();
 	files_init(mempages);
 	mnt_init();
+	hot_track_kmem_cache_init();
 	bdev_cache_init();
 	chrdev_init();
 }
diff --git a/fs/hot_rb.c b/fs/hot_rb.c
index 726d1c5..e2bee75 100644
--- a/fs/hot_rb.c
+++ b/fs/hot_rb.c
@@ -19,6 +19,10 @@
 #include "hot_rb.h"
 #include "hot_hash.h"
 
+/* kmem_cache pointers for slab caches */
+static struct kmem_cache *hot_inode_item_cache;
+static struct kmem_cache *hot_range_item_cache;
+
 /*
  * Initialize the inode tree. Should be called for each new inode
  * access or other user of the hot_inode interface.
@@ -28,3 +32,73 @@ void hot_rb_inode_tree_init(struct hot_inode_tree *tree)
 	tree->map = RB_ROOT;
 	rwlock_init(&tree->lock);
 }
+
+/*
+ * Initialize the hot range tree. Should be called for each new inode
+ * access or other user of the hot_range interface.
+ */
+void hot_rb_range_tree_init(struct hot_range_tree *tree)
+{
+	tree->map = RB_ROOT;
+	rwlock_init(&tree->lock);
+}
+
+/* init hot_inode_item and hot_range_item kmem cache */
+int __init hot_rb_item_cache_init(void)
+{
+	hot_inode_item_cache = kmem_cache_create("hot_inode_item",
+			sizeof(struct hot_inode_item), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+			hot_rb_inode_item_init);
+	if (!hot_inode_item_cache)
+		goto inode_err;
+
+	hot_range_item_cache = kmem_cache_create("hot_range_item",
+					sizeof(struct hot_range_item), 0,
+					SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+					hot_rb_range_item_init);
+	if (!hot_range_item_cache)
+		goto range_err;
+
+	return 0;
+
+range_err:
+	kmem_cache_destroy(hot_inode_item_cache);
+inode_err:
+	return -ENOMEM;
+}
+
+/*
+ * Initialize a new hot_inode_item structure. The new structure is
+ * returned with a reference count of one and needs to be
+ * freed using free_inode_item()
+ */
+void hot_rb_inode_item_init(void *_item)
+{
+	struct hot_inode_item *he = _item;
+
+	memset(he, 0, sizeof(*he));
+	kref_init(&he->refs);
+	spin_lock_init(&he->lock);
+	he->hot_freq_data.avg_delta_reads = (u64) -1;
+	he->hot_freq_data.avg_delta_writes = (u64) -1;
+	he->hot_freq_data.flags = FREQ_DATA_TYPE_INODE;
+	hot_rb_range_tree_init(&he->hot_range_tree);
+}
+
+/*
+ * Initialize a new hot_range_item structure. The new structure is
+ * returned with a reference count of one and needs to be
+ * freed using free_range_item()
+ */
+void hot_rb_range_item_init(void *_item)
+{
+	struct hot_range_item *hr = _item;
+
+	memset(hr, 0, sizeof(*hr));
+	kref_init(&hr->refs);
+	spin_lock_init(&hr->lock);
+	hr->hot_freq_data.avg_delta_reads = (u64) -1;
+	hr->hot_freq_data.avg_delta_writes = (u64) -1;
+	hr->hot_freq_data.flags = FREQ_DATA_TYPE_RANGE;
+}
diff --git a/fs/hot_rb.h b/fs/hot_rb.h
index 895c61c..71c51e0 100644
--- a/fs/hot_rb.h
+++ b/fs/hot_rb.h
@@ -16,6 +16,15 @@
 #include <linux/rbtree.h>
 #include <linux/hot_track.h>
 
+/* values for hot_freq_data flags */
+#define FREQ_DATA_TYPE_INODE (1 << 0) /* freq data struct is for an inode */
+#define FREQ_DATA_TYPE_RANGE (1 << 1) /* freq data struct is for a range */
+
 void hot_rb_inode_tree_init(struct hot_inode_tree *tree);
 
+void hot_rb_inode_item_init(void *_item);
+void hot_rb_range_item_init(void *_item);
+
+int __init hot_rb_item_cache_init(void);
+
 #endif /* __HOT_MAP__ */
diff --git a/fs/hot_track.c b/fs/hot_track.c
new file mode 100644
index 0000000..064c7dc
--- /dev/null
+++ b/fs/hot_track.c
@@ -0,0 +1,26 @@
+/*
+ * fs/hot_track.c
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
+#include <linux/slab.h>
+#include <linux/gfp.h>
+#include <linux/parser.h>
+#include "hot_track.h"
+
+/*
+ * Initialize kmem cache for hot_inode_item
+ * and hot_range_item
+ */
+void __init hot_track_kmem_cache_init(void)
+{
+	if (hot_rb_item_cache_init())
+		return;
+}
diff --git a/fs/hot_track.h b/fs/hot_track.h
new file mode 100644
index 0000000..9a52945
--- /dev/null
+++ b/fs/hot_track.h
@@ -0,0 +1,20 @@
+/*
+ * fs/hot_track.h
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
+#ifndef __HOT_TRACK__
+#define __HOT_TRACK__
+
+#include "hot_rb.h"
+
+void __init hot_track_kmem_cache_init(void);
+
+#endif /* __HOT_TRACK__ */
diff --git a/include/linux/hot_track.h b/include/linux/hot_track.h
index fa2aeb6..2256496 100644
--- a/include/linux/hot_track.h
+++ b/include/linux/hot_track.h
@@ -26,6 +26,68 @@ struct hot_inode_tree {
 	rwlock_t lock;
 };
 
+/* A tree of ranges for each inode in the hot_inode_tree */
+struct hot_range_tree {
+	struct rb_root map;
+	rwlock_t lock;
+};
+
+/* A frequency data struct holds values that are used to
+ * determine temperature of files and file ranges. These structs
+ * are members of hot_inode_item and hot_range_item
+ */
+struct hot_freq_data {
+	struct timespec last_read_time;
+	struct timespec last_write_time;
+	u32 nr_reads;
+	u32 nr_writes;
+	u64 avg_delta_reads;
+	u64 avg_delta_writes;
+	u8 flags;
+	u32 last_temperature;
+};
+
+/* An item representing an inode and its access frequency */
+struct hot_inode_item {
+	/* node for hot_inode_tree rb_tree */
+	struct rb_node rb_node;
+	/* tree of ranges in this inode */
+	struct hot_range_tree hot_range_tree;
+	/* frequency data for this inode */
+	struct hot_freq_data hot_freq_data;
+	/* inode number, copied from inode */
+	unsigned long i_ino;
+	/* used to check for errors in ref counting */
+	u8 in_tree;
+	/* protects hot_freq_data, i_no, in_tree */
+	spinlock_t lock;
+	/* prevents kfree */
+	struct kref refs;
+};
+
+/*
+ * An item representing a range inside of an inode whose frequency
+ * is being tracked
+ */
+struct hot_range_item {
+	/* node for hot_range_tree rb_tree */
+	struct rb_node rb_node;
+	/* frequency data for this range */
+	struct hot_freq_data hot_freq_data;
+	/* the hot_inode_item associated with this hot_range_item */
+	struct hot_inode_item *hot_inode;
+	/* starting offset of this range */
+	u64 start;
+	/* length of this range */
+	u64 len;
+	/* used to check for errors in ref counting */
+	u8 in_tree;
+	/* protects hot_freq_data, start, len, and in_tree */
+	spinlock_t lock;
+	/* prevents kfree */
+	struct kref refs;
+};
+
 struct hot_info {
 
 	/* red-black tree that keeps track of fs-wide hot data */
-- 
1.7.6.5

