Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab2KPJvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:51:48 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:43684 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2KPJvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:51:45 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v1 hot_track 03/16] vfs: add I/O frequency update function
Date: Fri, 16 Nov 2012 17:51:05 +0800
Message-Id: <1353059478-25474-4-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1353059478-25474-1-git-send-email-zwu.kernel@gmail.com>
References: <1353059478-25474-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111609-7408-0000-0000-00000A4DB076
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add some util helpers to update access frequencies
for one file or its range.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |  178 ++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |    5 +
 include/linux/hot_tracking.h |    4 +
 3 files changed, 187 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 1fd4d0e..6d396fe 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -162,6 +162,135 @@ static void hot_inode_tree_exit(struct hot_info *root)
 	spin_unlock(&root->lock);
 }
 
+struct hot_inode_item
+*hot_inode_item_lookup(struct hot_info *root, u64 ino)
+{
+	struct rb_node **p = &root->hot_inode_tree.map.rb_node;
+	struct rb_node *parent = NULL;
+	struct hot_comm_item *ci;
+	struct hot_inode_item *entry;
+
+	/* walk tree to find insertion point */
+	spin_lock(&root->lock);
+	while (*p) {
+		parent = *p;
+		ci = rb_entry(parent, struct hot_comm_item, rb_node);
+		entry = container_of(ci, struct hot_inode_item, hot_inode);
+		if (ino < entry->i_ino)
+			p = &(*p)->rb_left;
+		else if (ino > entry->i_ino)
+			p = &(*p)->rb_right;
+		else {
+			spin_unlock(&root->lock);
+			kref_get(&entry->hot_inode.refs);
+			return entry;
+		}
+	}
+	spin_unlock(&root->lock);
+
+	entry = kmem_cache_zalloc(hot_inode_item_cachep, GFP_NOFS);
+	if (!entry)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock(&root->lock);
+	hot_inode_item_init(entry, ino, &root->hot_inode_tree);
+	rb_link_node(&entry->hot_inode.rb_node, parent, p);
+	rb_insert_color(&entry->hot_inode.rb_node,
+			&root->hot_inode_tree.map);
+	spin_unlock(&root->lock);
+
+	kref_get(&entry->hot_inode.refs);
+	return entry;
+}
+EXPORT_SYMBOL_GPL(hot_inode_item_lookup);
+
+static loff_t hot_range_end(struct hot_range_item *hr)
+{
+	if (hr->start + hr->len < hr->start)
+		return (loff_t)-1;
+
+	return hr->start + hr->len - 1;
+}
+
+static struct hot_range_item
+*hot_range_item_lookup(struct hot_inode_item *he,
+			loff_t start)
+{
+	struct rb_node **p = &he->hot_range_tree.map.rb_node;
+	struct rb_node *parent = NULL;
+	struct hot_comm_item *ci;
+	struct hot_range_item *entry;
+
+	/* walk tree to find insertion point */
+	spin_lock(&he->lock);
+	while (*p) {
+		parent = *p;
+		ci = rb_entry(parent, struct hot_comm_item, rb_node);
+		entry = container_of(ci, struct hot_range_item, hot_range);
+		if (start < entry->start)
+			p = &(*p)->rb_left;
+		else if (start > hot_range_end(entry))
+			p = &(*p)->rb_right;
+		else {
+			spin_unlock(&he->lock);
+			kref_get(&entry->hot_range.refs);
+			return entry;
+		}
+	}
+	spin_unlock(&he->lock);
+
+	entry = kmem_cache_zalloc(hot_range_item_cachep, GFP_NOFS);
+	if (!entry)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock(&he->lock);
+	hot_range_item_init(entry, start, he);
+	rb_link_node(&entry->hot_range.rb_node, parent, p);
+	rb_insert_color(&entry->hot_range.rb_node,
+			&he->hot_range_tree.map);
+	spin_unlock(&he->lock);
+
+	kref_get(&entry->hot_range.refs);
+	return entry;
+}
+
+/*
+ * This function does the actual work of updating
+ * the frequency numbers, whatever they turn out to be.
+ */
+static void hot_rw_freq_calc(struct timespec old_atime,
+		struct timespec cur_time, u64 *avg)
+{
+	struct timespec delta_ts;
+	u64 new_delta;
+
+	delta_ts = timespec_sub(cur_time, old_atime);
+	new_delta = timespec_to_ns(&delta_ts) >> FREQ_POWER;
+
+	*avg = (*avg << FREQ_POWER) - *avg + new_delta;
+	*avg = *avg >> FREQ_POWER;
+}
+
+static void hot_freq_data_update(struct hot_freq_data *freq_data, bool write)
+{
+	struct timespec cur_time = current_kernel_time();
+
+	if (write) {
+		freq_data->nr_writes += 1;
+		hot_rw_freq_calc(freq_data->last_write_time,
+				cur_time,
+				&freq_data->avg_delta_writes);
+		freq_data->last_write_time = cur_time;
+	} else {
+		freq_data->nr_reads += 1;
+		hot_rw_freq_calc(freq_data->last_read_time,
+				freq_data->last_read_time,
+				cur_time,
+				&freq_data->avg_delta_reads);
+		freq_data->last_read_time = cur_time;
+	}
+}
+
 /*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
@@ -189,6 +318,55 @@ err:
 EXPORT_SYMBOL_GPL(hot_cache_init);
 
 /*
+ * Main function to update access frequency from read/writepage(s) hooks
+ */
+void hot_update_freqs(struct inode *inode, loff_t start,
+			size_t len, int rw)
+{
+	struct hot_info *root = inode->i_sb->s_hot_root;
+	struct hot_inode_item *he;
+	struct hot_range_item *hr;
+	loff_t cur, end;
+
+	if (!root || (len == 0))
+		return;
+
+	he = hot_inode_item_lookup(root, inode->i_ino);
+	if (IS_ERR(he)) {
+		WARN_ON(1);
+		return;
+	}
+
+	spin_lock(&he->hot_inode.lock);
+	hot_freq_data_update(&he->hot_inode.hot_freq_data, rw);
+	spin_unlock(&he->hot_inode.lock);
+
+	/*
+	 * Align ranges on RANGE_SIZE boundary
+	 * to prevent proliferation of range structs
+	 */
+	end = (start + len + RANGE_SIZE - 1) >> RANGE_BITS;
+	for (cur = (start >> RANGE_BITS); cur < end; cur++) {
+		hr = hot_range_item_lookup(he, cur);
+		if (IS_ERR(hr)) {
+			WARN(1, "hot_range_item_lookup returns %ld\n",
+				PTR_ERR(hr));
+			hot_inode_item_put(he);
+			return;
+		}
+
+		spin_lock(&hr->hot_range.lock);
+		hot_freq_data_update(&hr->hot_range.hot_freq_data, rw);
+		spin_unlock(&hr->hot_range.lock);
+
+		hot_range_item_put(hr);
+	}
+
+	hot_inode_item_put(he);
+}
+EXPORT_SYMBOL_GPL(hot_update_freqs);
+
+/*
  * Initialize the data structures for hot data tracking.
  */
 int hot_track_init(struct super_block *sb)
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index d58a461..8571186 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -19,4 +19,9 @@
 #define FREQ_DATA_TYPE_INODE (1 << 0)
 #define FREQ_DATA_TYPE_RANGE (1 << 1)
 
+/* size of sub-file ranges */
+#define RANGE_BITS 20
+#define RANGE_SIZE (1 << RANGE_BITS)
+#define FREQ_POWER 4
+
 #endif /* __HOT_TRACKING__ */
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 99d0f63..b9992c0 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -78,5 +78,9 @@ extern void __init hot_cache_init(void);
 extern int hot_track_init(struct super_block *sb);
 extern void hot_track_exit(struct super_block *sb);
 extern void hot_inode_item_put(struct hot_inode_item *he);
+extern void hot_update_freqs(struct inode *inode, loff_t start,
+				size_t len, int rw);
+extern struct hot_inode_item *hot_inode_item_lookup(struct hot_info *root,
+						u64 ino);
 
 #endif  /* _LINUX_HOTTRACK_H */
-- 
1.7.6.5

