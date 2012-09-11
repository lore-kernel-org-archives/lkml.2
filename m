Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980Ab2IKOvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:51:44 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34017 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab2IKOvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:51:42 -0400
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
        viro@zeniv.linux.org.uk, hch@lst.de, chris.mason@fusionio.com,
        cmm@us.ibm.com, linuxram@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC 07/11] vfs: introduce one hash table
Date: Tue, 11 Sep 2012 22:40:41 +0800
Message-Id: <1347374445-3018-2-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1347374445-3018-1-git-send-email-zwu.kernel@gmail.com>
References: <1347374445-3018-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091114-7182-0000-0000-0000029311E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Adds a hash table structure which contains
a lot of hash list and is used to efficiently
look up the data temperature of a file or its
ranges.
  In each hash list of hash table, the hash node
will keep track of temperature info.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/Makefile               |    2 +-
 fs/hot_hash.c             |   66 +++++++++++++++++++++++++++++++++++++++++++++
 fs/hot_hash.h             |   26 +++++++++++++++++
 fs/hot_rb.c               |   20 +++++++++++++
 fs/hot_rb.h               |    2 +
 fs/hot_track.c            |    6 ++++
 fs/hot_track.h            |    1 +
 include/linux/hot_track.h |   38 ++++++++++++++++++++++++++
 8 files changed, 160 insertions(+), 1 deletions(-)
 create mode 100644 fs/hot_hash.c
 create mode 100644 fs/hot_hash.h

diff --git a/fs/Makefile b/fs/Makefile
index b4f620e..f925a66 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -12,7 +12,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
 		stack.o fs_struct.o statfs.o \
-		hot_rb.o hot_track.o
+		hot_rb.o hot_track.o hot_hash.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
diff --git a/fs/hot_hash.c b/fs/hot_hash.c
new file mode 100644
index 0000000..cae5631
--- /dev/null
+++ b/fs/hot_hash.c
@@ -0,0 +1,66 @@
+/*
+ * fs/hot_hash.c
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
+#include <linux/list.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/hardirq.h>
+#include <linux/hash.h>
+#include <linux/types.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/fs.h>
+#include "hot_rb.h"
+#include "hot_hash.h"
+
+/* kmem_cache pointers for slab caches */
+struct kmem_cache *hot_hash_node_cache;
+
+void hot_hash_heat_node_init(void *_node)
+{
+	struct hot_hash_node *node = _node;
+
+	memset(node, 0, sizeof(*node));
+	INIT_HLIST_NODE(&node->hashnode);
+	node->hot_freq_data = NULL;
+	node->hlist = NULL;
+	spin_lock_init(&node->lock);
+	kref_init(&node->refs);
+}
+
+int __init hot_hash_node_cache_init(void)
+{
+	hot_hash_node_cache = kmem_cache_create("hot_hash_node",
+				sizeof(struct hot_hash_node),
+				0,
+				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+				hot_hash_heat_node_init);
+	if (!hot_hash_node_cache)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/*
+ * Initialize the rwlock in heat inode/range hash lists.
+ */
+void hot_hash_heat_rwlock_init(struct hot_info *root)
+{
+	int i;
+	for (i = 0; i < HEAT_HASH_SIZE; i++) {
+		rwlock_init(&root->heat_inode_hl[i].rwlock);
+		rwlock_init(&root->heat_range_hl[i].rwlock);
+	}
+}
+
diff --git a/fs/hot_hash.h b/fs/hot_hash.h
new file mode 100644
index 0000000..65abc6d
--- /dev/null
+++ b/fs/hot_hash.h
@@ -0,0 +1,26 @@
+/*
+ * fs/hot_hash.h
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
+#ifndef __HOT_HASH__
+#define __HOT_HASH__
+
+#include <linux/list.h>
+#include <linux/hash.h>
+#include <linux/hot_track.h>
+
+void hot_hash_heat_node_init(void *_node);
+
+int __init hot_hash_node_cache_init(void);
+
+void hot_hash_heat_rwlock_init(struct hot_info *root);
+
+#endif /* __HOT_HASH__ */
diff --git a/fs/hot_rb.c b/fs/hot_rb.c
index 71f5e76..fd3b9e5 100644
--- a/fs/hot_rb.c
+++ b/fs/hot_rb.c
@@ -68,6 +68,18 @@ inode_err:
 	return -ENOMEM;
 }
 
+void hot_rb_inode_item_exit(void)
+{
+	if (hot_inode_item_cache)
+		kmem_cache_destroy(hot_inode_item_cache);
+}
+
+void hot_rb_range_item_exit(void)
+{
+	if (hot_range_item_cache)
+		kmem_cache_destroy(hot_range_item_cache);
+}
+
 /*
  * Initialize a new hot_inode_item structure. The new structure is
  * returned with a reference count of one and needs to be
@@ -80,6 +92,10 @@ void hot_rb_inode_item_init(void *_item)
 	memset(he, 0, sizeof(*he));
 	kref_init(&he->refs);
 	spin_lock_init(&he->lock);
+	he->heat_node = kmem_cache_alloc(hot_hash_node_cache,
+					GFP_KERNEL | GFP_NOFS);
+	hot_hash_heat_node_init(he->heat_node);
+	he->heat_node->hot_freq_data = &he->hot_freq_data;
 	he->hot_freq_data.avg_delta_reads = (u64) -1;
 	he->hot_freq_data.avg_delta_writes = (u64) -1;
 	he->hot_freq_data.flags = FREQ_DATA_TYPE_INODE;
@@ -98,6 +114,10 @@ void hot_rb_range_item_init(void *_item)
 	memset(hr, 0, sizeof(*hr));
 	kref_init(&hr->refs);
 	spin_lock_init(&hr->lock);
+	hr->heat_node = kmem_cache_alloc(hot_hash_node_cache,
+				GFP_KERNEL | GFP_NOFS);
+	hot_hash_heat_node_init(hr->heat_node);
+	hr->heat_node->hot_freq_data = &hr->hot_freq_data;
 	hr->hot_freq_data.avg_delta_reads = (u64) -1;
 	hr->hot_freq_data.avg_delta_writes = (u64) -1;
 	hr->hot_freq_data.flags = FREQ_DATA_TYPE_RANGE;
diff --git a/fs/hot_rb.h b/fs/hot_rb.h
index df8cd14..193c265 100644
--- a/fs/hot_rb.h
+++ b/fs/hot_rb.h
@@ -57,6 +57,8 @@ void hot_rb_free_hot_inode_tree(struct hot_info *root);
 
 int __init hot_rb_item_cache_init(void);
 
+void hot_rb_inode_item_exit(void);
+void hot_rb_range_item_exit(void);
 void hot_rb_update_freq(struct hot_freq_data *freq_data, int rw);
 void hot_rb_update_freqs(struct inode *inode, u64 start, u64 len,
 			int rw);
diff --git a/fs/hot_track.c b/fs/hot_track.c
index 68f85ad..0ec8b83b 100644
--- a/fs/hot_track.c
+++ b/fs/hot_track.c
@@ -57,6 +57,11 @@ void __init hot_track_item_cache_init(void)
 {
 	if (hot_rb_item_cache_init())
 		return;
+
+	if (hot_hash_node_cache_init()) {
+		hot_rb_inode_item_exit();
+		hot_rb_range_item_exit();
+	}
 }
 
 /*
@@ -66,6 +71,7 @@ void hot_track_init(struct super_block *sb, const char *name)
 {
 	sb->s_hotinfo.mount_opt |= HOT_MOUNT_HOT_TRACK;
 	hot_rb_inode_tree_init(&sb->s_hotinfo.hot_inode_tree);
+	hot_hash_heat_rwlock_init(&sb->s_hotinfo);
 }
 
 void hot_track_exit(struct super_block *sb)
diff --git a/fs/hot_track.h b/fs/hot_track.h
index b2f096c..e137142 100644
--- a/fs/hot_track.h
+++ b/fs/hot_track.h
@@ -14,6 +14,7 @@
 #define __HOT_TRACK__
 
 #include "hot_rb.h"
+#include "hot_hash.h"
 
 bool hot_track_parse_options(char *options);
 void __init hot_track_item_cache_init(void);
diff --git a/include/linux/hot_track.h b/include/linux/hot_track.h
index b56a467..bde61de 100644
--- a/include/linux/hot_track.h
+++ b/include/linux/hot_track.h
@@ -20,11 +20,17 @@
 #include <linux/rbtree.h>
 #include <linux/kref.h>
 
+#define HEAT_HASH_BITS 8
+#define HEAT_HASH_SIZE (1 << HEAT_HASH_BITS)
+
 /*
  * Flags for hot data tracking mount options.
  */
 #define HOT_MOUNT_HOT_TRACK		(1 << 0)
 
+/* kmem_cache pointers for slab caches */
+extern struct kmem_cache *hot_hash_node_cache;
+
 /* A tree that sits on the hot_info */
 struct hot_inode_tree {
 	struct rb_root map;
@@ -52,6 +58,28 @@ struct hot_freq_data {
 	u32 last_temperature;
 };
 
+/* Hash list heads for hot hash table */
+struct hot_hash_head {
+	struct hlist_head hashhead;
+	rwlock_t rwlock;
+	u32 temperature;
+};
+
+/* Nodes stored in each hash list of hash table */
+struct hot_hash_node {
+	struct hlist_node hashnode;
+	struct list_head node;
+	struct hot_freq_data *hot_freq_data;
+	struct hot_hash_head *hlist;
+	spinlock_t lock; /* protects hlist */
+
+	/*
+	 * number of references to this node
+	 * equals 1 (hashlist entry)
+	 */
+	struct kref refs;
+};
+
 /* An item representing an inode and its access frequency */
 struct hot_inode_item {
 	/* node for hot_inode_tree rb_tree */
@@ -68,6 +96,8 @@ struct hot_inode_item {
 	spinlock_t lock;
 	/* prevents kfree */
 	struct kref refs;
+	/* hashlist node for this inode */
+	struct hot_hash_node *heat_node;
 };
 
 /*
@@ -91,6 +121,8 @@ struct hot_range_item {
 	spinlock_t lock;
 	/* prevents kfree */
 	struct kref refs;
+	/* hashlist node for this range */
+	struct hot_hash_node *heat_node;
 };
 
 struct hot_info {
@@ -98,6 +130,12 @@ struct hot_info {
 
 	/* red-black tree that keeps track of fs-wide hot data */
 	struct hot_inode_tree hot_inode_tree;
+
+	/* hash map of inode temperature */
+	struct hot_hash_head heat_inode_hl[HEAT_HASH_SIZE];
+
+	/* hash map of range temperature */
+	struct hot_hash_head heat_range_hl[HEAT_HASH_SIZE];
 };
 
 #endif  /* _LINUX_HOTTRACK_H */
-- 
1.7.6.5

