Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab2KPJvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:51:44 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60893 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab2KPJvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:51:41 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v1 hot_track 02/16] vfs: add init and cleanup functions
Date: Fri, 16 Nov 2012 17:51:04 +0800
Message-Id: <1353059478-25474-3-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1353059478-25474-1-git-send-email-zwu.kernel@gmail.com>
References: <1353059478-25474-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111609-5806-0000-0000-00001BD842E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add initialization function to create some
key data structures when hot tracking is enabled;
Clean up them when hot tracking is disabled

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |  115 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h           |    4 ++
 include/linux/hot_tracking.h |    3 +
 3 files changed, 122 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index ef7ff09..1fd4d0e 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -76,12 +76,92 @@ static void hot_inode_item_init(struct hot_inode_item *he,
 	he->hot_inode_tree = hot_inode_tree;
 	kref_init(&he->hot_inode.refs);
 	spin_lock_init(&he->hot_inode.lock);
+	INIT_LIST_HEAD(&he->hot_inode.n_list);
 	he->hot_inode.hot_freq_data.avg_delta_reads = (u64) -1;
 	he->hot_inode.hot_freq_data.avg_delta_writes = (u64) -1;
 	he->hot_inode.hot_freq_data.flags = FREQ_DATA_TYPE_INODE;
 	hot_range_tree_init(he);
 }
 
+static void hot_range_item_free(struct kref *kref)
+{
+	struct hot_comm_item *comm_item = container_of(kref,
+		struct hot_comm_item, refs);
+	struct hot_range_item *hr = container_of(comm_item,
+		struct hot_range_item, hot_range);
+
+	rb_erase(&hr->hot_range.rb_node,
+		&hr->hot_inode->hot_range_tree.map);
+	kmem_cache_free(hot_range_item_cachep, hr);
+}
+
+/*
+ * Drops the reference out on hot_range_item by one
+ * and free the structure if the reference count hits zero
+ */
+static void hot_range_item_put(struct hot_range_item *hr)
+{
+	kref_put(&hr->hot_range.refs, hot_range_item_free);
+}
+
+/* Frees the entire hot_range_tree. */
+static void hot_range_tree_free(struct hot_inode_item *he)
+{
+	struct rb_node *node;
+	struct hot_comm_item *ci;
+	struct hot_range_item *hr;
+
+	/* Free hot inode and range trees on fs root */
+	spin_lock(&he->lock);
+	while ((node = rb_first(&he->hot_range_tree.map))) {
+		ci = rb_entry(node, struct hot_comm_item, rb_node);
+		hr = container_of(ci,
+			struct hot_range_item, hot_range);
+		hot_range_item_put(hr);
+	}
+	spin_unlock(&he->lock);
+}
+
+static void hot_inode_item_free(struct kref *kref)
+{
+	struct hot_comm_item *comm_item = container_of(kref,
+			struct hot_comm_item, refs);
+	struct hot_inode_item *he = container_of(comm_item,
+			struct hot_inode_item, hot_inode);
+
+	hot_range_tree_free(he);
+	rb_erase(&he->hot_inode.rb_node, &he->hot_inode_tree->map);
+	kmem_cache_free(hot_inode_item_cachep, he);
+}
+
+/*
+ * Drops the reference out on hot_inode_item by one
+ * and free the structure if the reference count hits zero
+ */
+void hot_inode_item_put(struct hot_inode_item *he)
+{
+	kref_put(&he->hot_inode.refs, hot_inode_item_free);
+}
+EXPORT_SYMBOL_GPL(hot_inode_item_put);
+
+/* Frees the entire hot_inode_tree. */
+static void hot_inode_tree_exit(struct hot_info *root)
+{
+	struct rb_node *node;
+	struct hot_comm_item *ci;
+	struct hot_inode_item *he;
+
+	/* Free hot inode and range trees on fs root */
+	spin_lock(&root->lock);
+	while ((node = rb_first(&root->hot_inode_tree.map))) {
+		ci = rb_entry(node, struct hot_comm_item, rb_node);
+		he = container_of(ci,
+			struct hot_inode_item, hot_inode);
+		hot_inode_item_put(he);
+	}
+	spin_unlock(&root->lock);
+}
+
 /*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
@@ -107,3 +187,38 @@ err:
 	kmem_cache_destroy(hot_inode_item_cachep);
 }
 EXPORT_SYMBOL_GPL(hot_cache_init);
+
+/*
+ * Initialize the data structures for hot data tracking.
+ */
+int hot_track_init(struct super_block *sb)
+{
+	struct hot_info *root;
+	int ret = -ENOMEM;
+
+	root = kzalloc(sizeof(struct hot_info), GFP_NOFS);
+	if (!root) {
+		printk(KERN_ERR "%s: Failed to malloc memory for "
+				"hot_info\n", __func__);
+		return ret;
+	}
+
+	hot_inode_tree_init(root);
+
+	sb->s_hot_root = root;
+
+	printk(KERN_INFO "VFS: Turning on hot data tracking\n");
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hot_track_init);
+
+void hot_track_exit(struct super_block *sb)
+{
+	struct hot_info *root = sb->s_hot_root;
+
+	hot_inode_tree_exit(root);
+	sb->s_hot_root = NULL;
+	kfree(root);
+}
+EXPORT_SYMBOL_GPL(hot_track_exit);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b33cfc9..c541ae7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -27,6 +27,7 @@
 #include <linux/lockdep.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/blk_types.h>
+#include <linux/hot_tracking.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -1321,6 +1322,9 @@ struct super_block {
 
 	/* Being remounted read-only */
 	int s_readonly_remount;
+
+	/* Hot data tracking*/
+	struct hot_info *s_hot_root;
 };
 
 /* superblock cache pruning functions */
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index aae8127..99d0f63 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -75,5 +75,8 @@ struct hot_info {
 };
 
 extern void __init hot_cache_init(void);
+extern int hot_track_init(struct super_block *sb);
+extern void hot_track_exit(struct super_block *sb);
+extern void hot_inode_item_put(struct hot_inode_item *he);
 
 #endif  /* _LINUX_HOTTRACK_H */
-- 
1.7.6.5

