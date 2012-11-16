Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab2KPJwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:52:21 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:56265 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2KPJwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:52:18 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v1 hot_track 10/16] vfs: add FS hot type support
Date: Fri, 16 Nov 2012 17:51:12 +0800
Message-Id: <1353059478-25474-11-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1353059478-25474-1-git-send-email-zwu.kernel@gmail.com>
References: <1353059478-25474-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111609-5518-0000-0000-00000954F5CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Introduce one way to enable that specific FS
can inject its own hot tracking type.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |   43 +++++++++++++++++++++++++++++++----------
 fs/hot_tracking.h            |    1 -
 include/linux/fs.h           |    1 +
 include/linux/hot_tracking.h |   19 ++++++++++++++++++
 4 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 873d234..81fb084 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -64,8 +64,11 @@ void hot_range_tree_init(struct hot_inode_item *he)
 static void hot_range_item_init(struct hot_range_item *hr, loff_t start,
 				struct hot_inode_item *he)
 {
+	struct hot_info *root = container_of(he->hot_inode_tree,
+				struct hot_info, hot_inode_tree);
+
 	hr->start = start;
-	hr->len = RANGE_SIZE;
+	hr->len = hot_raw_shift(1, root->hot_type->range_bits, true);
 	hr->hot_inode = he;
 	kref_init(&hr->hot_range.refs);
 	spin_lock_init(&hr->hot_range.lock);
@@ -302,19 +305,21 @@ static void hot_rw_freq_calc(struct timespec old_atime,
 	*avg = *avg >> FREQ_POWER;
 }
 
-static void hot_freq_data_update(struct hot_freq_data *freq_data, bool write)
+static void hot_freq_data_update(struct hot_info *root,
+		struct hot_freq_data *freq_data, bool write)
 {
 	struct timespec cur_time = current_kernel_time();
 
 	if (write) {
 		freq_data->nr_writes += 1;
-		hot_rw_freq_calc(freq_data->last_write_time,
+		root->hot_type->ops.hot_rw_freq_calc_fn(
+				freq_data->last_write_time,
 				cur_time,
 				&freq_data->avg_delta_writes);
 		freq_data->last_write_time = cur_time;
 	} else {
 		freq_data->nr_reads += 1;
-		hot_rw_freq_calc(freq_data->last_read_time,
+			root->hot_type->ops.hot_rw_freq_calc_fn(
 				freq_data->last_read_time,
 				cur_time,
 				&freq_data->avg_delta_reads);
@@ -418,7 +423,7 @@ static void hot_map_update(struct hot_freq_data *freq_data,
 	struct hot_comm_item *comm_item;
 	struct hot_inode_item *he;
 	struct hot_range_item *hr;
-	u32 temp = hot_temp_calc(freq_data);
+	u32 temp = root->hot_type->ops.hot_temp_calc_fn(freq_data);
 	u8 a_temp = (u8)hot_raw_shift((u64)temp, (32 - HEAT_MAP_BITS), false);
 	u8 b_temp = (u8)hot_raw_shift((u64)freq_data->last_temp,
 					(32 - HEAT_MAP_BITS), false);
@@ -491,7 +496,7 @@ static void hot_range_update(struct hot_inode_item *he,
 		hot_map_update(&hr->hot_range.hot_freq_data, root);
 
 		spin_lock(&hr->hot_range.lock);
-		obsolete = hot_is_obsolete(
+		obsolete = root->hot_type->ops.hot_is_obsolete_fn(
 				&hr->hot_range.hot_freq_data);
 		spin_unlock(&hr->hot_range.lock);
 
@@ -634,6 +639,7 @@ void hot_update_freqs(struct inode *inode, loff_t start,
 	struct hot_info *root = inode->i_sb->s_hot_root;
 	struct hot_inode_item *he;
 	struct hot_range_item *hr;
+	u64 range_size;
 	loff_t cur, end;
 
 	if (!root || (len == 0))
@@ -646,15 +652,19 @@ void hot_update_freqs(struct inode *inode, loff_t start,
 	}
 
 	spin_lock(&he->hot_inode.lock);
-	hot_freq_data_update(&he->hot_inode.hot_freq_data, rw);
+	hot_freq_data_update(root, &he->hot_inode.hot_freq_data, rw);
 	spin_unlock(&he->hot_inode.lock);
 
 	/*
-	 * Align ranges on RANGE_SIZE boundary
+	 * Align ranges on range size boundary
 	 * to prevent proliferation of range structs
 	 */
-	end = (start + len + RANGE_SIZE - 1) >> RANGE_BITS;
-	for (cur = (start >> RANGE_BITS); cur < end; cur++) {
+	range_size  = hot_raw_shift(1,
+			root->hot_type->range_bits, true);
+	end = hot_raw_shift((start + len + range_size - 1),
+			root->hot_type->range_bits, false);
+	cur = hot_raw_shift(start, root->hot_type->range_bits, false);
+	for (; cur < end; cur++) {
 		hr = hot_range_item_lookup(he, cur);
 		if (IS_ERR(hr)) {
 			WARN(1, "hot_range_item_lookup returns %ld\n",
@@ -664,7 +674,7 @@ void hot_update_freqs(struct inode *inode, loff_t start,
 		}
 
 		spin_lock(&hr->hot_range.lock);
-		hot_freq_data_update(&hr->hot_range.hot_freq_data, rw);
+		hot_freq_data_update(root, &hr->hot_range.hot_freq_data, rw);
 		spin_unlock(&hr->hot_range.lock);
 
 		hot_range_item_put(hr);
@@ -692,6 +702,17 @@ int hot_track_init(struct super_block *sb)
 	hot_inode_tree_init(root);
 	hot_map_init(root);
 
+	/* Get hot type for specific FS */
+	root->hot_type = &sb->s_type->hot_type;
+	if (!root->hot_type->ops.hot_rw_freq_calc_fn)
+		root->hot_type->ops.hot_rw_freq_calc_fn = hot_rw_freq_calc;
+	if (!root->hot_type->ops.hot_temp_calc_fn)
+		root->hot_type->ops.hot_temp_calc_fn = hot_temp_calc;
+	if (!root->hot_type->ops.hot_is_obsolete_fn)
+		root->hot_type->ops.hot_is_obsolete_fn = hot_is_obsolete;
+	if (root->hot_type->range_bits == 0)
+		root->hot_type->range_bits = RANGE_BITS;
+
 	root->update_wq = alloc_workqueue(
 		"hot_update_wq", WQ_NON_REENTRANT, 0);
 	if (!root->update_wq) {
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 96379a6..73d2a3e 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -21,7 +21,6 @@
 
 /* size of sub-file ranges */
 #define RANGE_BITS 20
-#define RANGE_SIZE (1 << RANGE_BITS)
 #define FREQ_POWER 4
 
 /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c541ae7..4e2607d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1821,6 +1821,7 @@ struct file_system_type {
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
 	void (*kill_sb) (struct super_block *);
+	struct hot_type hot_type;
 	struct module *owner;
 	struct file_system_type * next;
 	struct hlist_head fs_supers;
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index ef12748..f73111e 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -79,6 +79,24 @@ struct hot_range_item {
 	size_t len; /* length in bytes */
 };
 
+typedef void (hot_rw_freq_calc_fn) (struct timespec old_atime,
+			struct timespec cur_time, u64 *avg);
+typedef u32 (hot_temp_calc_fn) (struct hot_freq_data *freq_data);
+typedef bool (hot_is_obsolete_fn) (struct hot_freq_data *freq_data);
+
+struct hot_func_ops {
+	hot_rw_freq_calc_fn *hot_rw_freq_calc_fn;
+	hot_temp_calc_fn *hot_temp_calc_fn;
+	hot_is_obsolete_fn *hot_is_obsolete_fn;
+};
+
+/* identifies an hot type */
+struct hot_type {
+	u64 range_bits;
+	/* fields provided by specific FS */
+	struct hot_func_ops ops;
+};
+
 struct hot_info {
 	struct hot_rb_tree hot_inode_tree;
 	spinlock_t lock; /*protect inode tree */
@@ -91,6 +109,7 @@ struct hot_info {
 
 	struct workqueue_struct *update_wq;
 	struct delayed_work update_work;
+	struct hot_type *hot_type;
 };
 
 extern void __init hot_cache_init(void);
-- 
1.7.6.5

