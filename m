Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab2KHJCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:02:30 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44544 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095Ab2KHJCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:02:25 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, david@fromorbit.com,
        cmm@us.ibm.com, swhiteho@redhat.com, dave@jikos.cz,
        darrick.wong@oracle.com, andi@firstfloor.org, northrup.james@gmail.com,
        gregkh@linuxfoundation.org, linuxram@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v1 hot_track 03/18] vfs: add I/O frequency update function
Date: Thu,  8 Nov 2012 17:01:10 +0800
Message-Id: <1352365285-32419-4-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1352365285-32419-1-git-send-email-zwu.kernel@gmail.com>
References: <1352365285-32419-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110809-3534-0000-0000-00000EBE1C98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add some util helpers to update access frequencies
for one file or its range.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |  174 ++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |    5 +
 include/linux/hot_tracking.h |    4 +
 3 files changed, 183 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 3118c0b..1142ef1 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -173,6 +173,131 @@ static void hot_inode_tree_exit(struct hot_info *root)
 	}
 }
 
+struct hot_inode_item
+*hot_inode_item_lookup(struct hot_info *root, unsigned long ino)
+{
+	struct hot_inode_item *he;
+	int ret;
+
+again:
+	spin_lock(&root->lock);
+	he = radix_tree_lookup(&root->hot_inode_tree, ino);
+	if (he) {
+		kref_get(&he->hot_inode.refs);
+		spin_unlock(&root->lock);
+		return he;
+	}
+	spin_unlock(&root->lock);
+
+	he = kmem_cache_zalloc(hot_inode_item_cachep, GFP_NOFS);
+	if (!he)
+		return ERR_PTR(-ENOMEM);
+
+	hot_inode_item_init(he, ino, &root->hot_inode_tree);
+
+	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
+	if (ret) {
+		kmem_cache_free(hot_inode_item_cachep, he);
+		return ERR_PTR(ret);
+	}
+
+	spin_lock(&root->lock);
+	ret = radix_tree_insert(&root->hot_inode_tree, ino, he);
+	if (ret == -EEXIST) {
+		kmem_cache_free(hot_inode_item_cachep, he);
+		spin_unlock(&root->lock);
+		radix_tree_preload_end();
+		goto again;
+	}
+	spin_unlock(&root->lock);
+	radix_tree_preload_end();
+
+	kref_get(&he->hot_inode.refs);
+	return he;
+}
+EXPORT_SYMBOL_GPL(hot_inode_item_lookup);
+
+static struct hot_range_item
+*hot_range_item_lookup(struct hot_inode_item *he,
+			loff_t start)
+{
+	struct hot_range_item *hr;
+	int ret;
+
+again:
+	spin_lock(&he->lock);
+	hr = radix_tree_lookup(&he->hot_range_tree, start);
+	if (hr) {
+		kref_get(&hr->hot_range.refs);
+		spin_unlock(&he->lock);
+		return hr;
+	}
+	spin_unlock(&he->lock);
+
+	hr = kmem_cache_zalloc(hot_range_item_cachep, GFP_NOFS);
+	if (!hr)
+		return ERR_PTR(-ENOMEM);
+
+	hot_range_item_init(hr, start, he);
+
+	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
+	if (ret) {
+		kmem_cache_free(hot_range_item_cachep, hr);
+		return ERR_PTR(ret);
+	}
+
+	spin_lock(&he->lock);
+	ret = radix_tree_insert(&he->hot_range_tree, start, hr);
+	if (ret == -EEXIST) {
+		kmem_cache_free(hot_range_item_cachep, hr);
+		spin_unlock(&he->lock);
+		radix_tree_preload_end();
+		goto again;
+	}
+	spin_unlock(&he->lock);
+	radix_tree_preload_end();
+
+	kref_get(&hr->hot_range.refs);
+	return hr;
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
@@ -200,6 +325,55 @@ err:
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
index febf699..7f279af 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -20,4 +20,9 @@
 #define FREQ_DATA_TYPE_INODE (1 << 0)
 #define FREQ_DATA_TYPE_RANGE (1 << 1)
 
+/* size of sub-file ranges */
+#define RANGE_BITS 20
+#define RANGE_SIZE (1 << RANGE_BITS)
+#define FREQ_POWER 4
+
 #endif /* __HOT_TRACKING__ */
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 1c364f6..3797cf0 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -72,5 +72,9 @@ extern void __init hot_cache_init(void);
 extern int hot_track_init(struct super_block *sb);
 extern void hot_track_exit(struct super_block *sb);
 extern void hot_inode_item_put(struct hot_inode_item *he);
+extern void hot_update_freqs(struct inode *inode, loff_t start,
+				size_t len, int rw);
+extern struct hot_inode_item *hot_inode_item_lookup(struct hot_info *root,
+						unsigned long ino);
 
 #endif  /* _LINUX_HOTTRACK_H */
-- 
1.7.6.5

