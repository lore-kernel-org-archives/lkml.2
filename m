Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab2LTOsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 09:48:05 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55568 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab2LTOoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 09:44:23 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, david@fromorbit.com,
        dave@jikos.cz, darrick.wong@oracle.com, andi@firstfloor.org,
        hch@infradead.org, linuxram@linux.vnet.ibm.com, zwu.kernel@gmail.com,
        wuzhy@linux.vnet.ibm.com
Subject: [PATCH RESEND v1 04/16] vfs: add two map arrays
Date: Thu, 20 Dec 2012 22:43:23 +0800
Message-Id: <1356014615-15073-5-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
References: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12122014-7182-0000-0000-000003EDEA10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Adds two map arrays which contains
a lot of list and is used to efficiently
look up the data temperature of a file or its
ranges.
  In each list of map arrays, the array node
will keep track of temperature info.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |   67 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/hot_tracking.h |   17 ++++++++++
 2 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 6f587fa..5f164c8 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -58,6 +58,7 @@ static void hot_range_item_init(struct hot_range_item *hr, loff_t start,
 	hr->hot_inode = he;
 	kref_init(&hr->hot_range.refs);
 	spin_lock_init(&hr->hot_range.lock);
+	INIT_LIST_HEAD(&hr->hot_range.n_list);
 	hr->hot_range.hot_freq_data.avg_delta_reads = (u64) -1;
 	hr->hot_range.hot_freq_data.avg_delta_writes = (u64) -1;
 	hr->hot_range.hot_freq_data.flags = FREQ_DATA_TYPE_RANGE;
@@ -89,9 +90,20 @@ static void hot_range_item_free(struct kref *kref)
 		struct hot_comm_item, refs);
 	struct hot_range_item *hr = container_of(comm_item,
 		struct hot_range_item, hot_range);
+	struct hot_info *root = container_of(
+			hr->hot_inode->hot_inode_tree,
+		struct hot_info, hot_inode_tree);
+
+	spin_lock(&hr->hot_range.lock);
+	if (!list_empty(&hr->hot_range.n_list)) {
+		list_del_init(&hr->hot_range.n_list);
+		root->hot_map_nr--;
+	}
 
 	rb_erase(&hr->hot_range.rb_node,
 		&hr->hot_inode->hot_range_tree.map);
+	spin_unlock(&hr->hot_range.lock);
+
 	kmem_cache_free(hot_range_item_cachep, hr);
 }
 
@@ -128,6 +140,15 @@ static void hot_inode_item_free(struct kref *kref)
 			struct hot_comm_item, refs);
 	struct hot_inode_item *he = container_of(comm_item,
 			struct hot_inode_item, hot_inode);
+	struct hot_info *root = container_of(he->hot_inode_tree,
+		struct hot_info, hot_inode_tree);
+
+	spin_lock(&he->hot_inode.lock);
+	if (!list_empty(&he->hot_inode.n_list)) {
+		list_del_init(&he->hot_inode.n_list);
+		root->hot_map_nr--;
+	}
+	spin_unlock(&he->hot_inode.lock);
 
 	hot_range_tree_free(he);
 	spin_lock(&he->hot_inode.lock);
@@ -294,6 +315,50 @@ static void hot_freq_data_update(struct hot_freq_data *freq_data, bool write)
 }
 
 /*
+ * Initialize inode and range map info.
+ */
+static void hot_map_init(struct hot_info *root)
+{
+	int i;
+	for (i = 0; i < HEAT_MAP_SIZE; i++) {
+		INIT_LIST_HEAD(&root->heat_inode_map[i].node_list);
+		INIT_LIST_HEAD(&root->heat_range_map[i].node_list);
+		root->heat_inode_map[i].temp = i;
+		root->heat_range_map[i].temp = i;
+		spin_lock_init(&root->heat_inode_map[i].lock);
+		spin_lock_init(&root->heat_range_map[i].lock);
+	}
+}
+
+static void hot_map_list_free(struct list_head *node_list,
+				struct hot_info *root)
+{
+	struct list_head *pos, *next;
+	struct hot_comm_item *node;
+
+	list_for_each_safe(pos, next, node_list) {
+		node = list_entry(pos, struct hot_comm_item, n_list);
+		list_del_init(&node->n_list);
+		root->hot_map_nr--;
+	}
+
+}
+
+/* Free inode and range map info */
+static void hot_map_exit(struct hot_info *root)
+{
+	int i;
+	for (i = 0; i < HEAT_MAP_SIZE; i++) {
+		spin_lock(&root->heat_inode_map[i].lock);
+		hot_map_list_free(&root->heat_inode_map[i].node_list, root);
+		spin_unlock(&root->heat_inode_map[i].lock);
+		spin_lock(&root->heat_range_map[i].lock);
+		hot_map_list_free(&root->heat_range_map[i].node_list, root);
+		spin_unlock(&root->heat_range_map[i].lock);
+	}
+}
+
+/*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
 void __init hot_cache_init(void)
@@ -384,6 +449,7 @@ int hot_track_init(struct super_block *sb)
 	}
 
 	hot_inode_tree_init(root);
+	hot_map_init(root);
 
 	sb->s_hot_root = root;
 
@@ -397,6 +463,7 @@ void hot_track_exit(struct super_block *sb)
 {
 	struct hot_info *root = sb->s_hot_root;
 
+	hot_map_exit(root);
 	hot_inode_tree_exit(root);
 	sb->s_hot_root = NULL;
 	kfree(root);
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index d555046..23edad92 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -20,6 +20,9 @@
 #include <linux/kref.h>
 #include <linux/fs.h>
 
+#define HEAT_MAP_BITS 8
+#define HEAT_MAP_SIZE (1 << HEAT_MAP_BITS)
+
 struct hot_rb_tree {
 	struct rb_root map;
 };
@@ -40,12 +43,20 @@ struct hot_freq_data {
 	u32 last_temp;
 };
 
+/* List heads in hot map array */
+struct hot_map_head {
+	struct list_head node_list;
+	u8 temp;
+	spinlock_t lock;
+};
+
 /* The common info for both following structures */
 struct hot_comm_item {
 	struct rb_node rb_node; /* rbtree index */
 	struct hot_freq_data hot_freq_data;  /* frequency data */
 	spinlock_t lock; /* protects object data */
 	struct kref refs;  /* prevents kfree */
+	struct list_head n_list; /* list node index */
 };
 
 /* An item representing an inode and its access frequency */
@@ -71,6 +82,12 @@ struct hot_range_item {
 struct hot_info {
 	struct hot_rb_tree hot_inode_tree;
 	spinlock_t lock; /*protect inode tree */
+
+	/* map of inode temperature */
+	struct hot_map_head heat_inode_map[HEAT_MAP_SIZE];
+	/* map of range temperature */
+	struct hot_map_head heat_range_map[HEAT_MAP_SIZE];
+	unsigned int hot_map_nr;
 };
 
 extern void __init hot_cache_init(void);
-- 
1.7.6.5

