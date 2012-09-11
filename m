Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab2IKOaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:30:14 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:52572 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719Ab2IKOaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:30:11 -0400
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
        viro@zeniv.linux.org.uk, hch@lst.de, chris.mason@fusionio.com,
        cmm@us.ibm.com, linuxram@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC 04/11] vfs: add support for updating access frequency
Date: Tue, 11 Sep 2012 22:27:18 +0800
Message-Id: <1347373645-2119-5-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1347373645-2119-1-git-send-email-zwu.kernel@gmail.com>
References: <1347373645-2119-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091114-2398-0000-0000-00000AAF95D7
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00173223; UDB=6.00039243; UTC=2012-09-11
 14:30:07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add some utils helpers to update access frequencies
for one file or its range.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_rb.c |  359 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/hot_rb.h |   28 +++++
 2 files changed, 387 insertions(+), 0 deletions(-)

diff --git a/fs/hot_rb.c b/fs/hot_rb.c
index e2bee75..560841a 100644
--- a/fs/hot_rb.c
+++ b/fs/hot_rb.c
@@ -102,3 +102,362 @@ void hot_rb_range_item_init(void *_item)
 	hr->hot_freq_data.avg_delta_writes = (u64) -1;
 	hr->hot_freq_data.flags = FREQ_DATA_TYPE_RANGE;
 }
+
+/*
+ * Drops the reference out on hot_inode_item by one and free the structure
+ * if the reference count hits zero
+ */
+void hot_rb_free_hot_inode_item(struct hot_inode_item *he)
+{
+	if (!he)
+		return;
+
+	if (atomic_dec_and_test(&he->refs.refcount)) {
+		WARN_ON(he->in_tree);
+		kmem_cache_free(hot_inode_item_cache, he);
+	}
+}
+
+/*
+ * Drops the reference out on hot_range_item by one and free the structure
+ * if the reference count hits zero
+ */
+void hot_rb_free_hot_range_item(struct hot_range_item *hr)
+{
+	if (!hr)
+		return;
+
+	if (atomic_dec_and_test(&hr->refs.refcount)) {
+		WARN_ON(hr->in_tree);
+		kmem_cache_free(hot_range_item_cache, hr);
+	}
+}
+
+static struct rb_node *hot_rb_insert_hot_inode_item(struct rb_root *root,
+						unsigned long inode_num,
+						struct rb_node *node)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct hot_inode_item *entry;
+
+	/* walk tree to find insertion point */
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct hot_inode_item, rb_node);
+
+		if (inode_num < entry->i_ino)
+			p = &(*p)->rb_left;
+		else if (inode_num > entry->i_ino)
+			p = &(*p)->rb_right;
+		else
+			return parent;
+	}
+
+	entry = rb_entry(node, struct hot_inode_item, rb_node);
+	entry->in_tree = 1;
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, root);
+
+	return NULL;
+}
+
+static u64 hot_rb_range_end(struct hot_range_item *hr)
+{
+	if (hr->start + hr->len < hr->start)
+		return (u64)-1;
+
+	return hr->start + hr->len - 1;
+}
+
+static struct rb_node *hot_rb_insert_hot_range_item(struct rb_root *root,
+						u64 start,
+						struct rb_node *node)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct hot_range_item *entry;
+
+	/* ensure start is on a range boundary */
+	start = start & RANGE_SIZE_MASK;
+	/* walk tree to find insertion point */
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct hot_range_item, rb_node);
+
+		if (start < entry->start)
+			p = &(*p)->rb_left;
+		else if (start >= hot_rb_range_end(entry))
+			p = &(*p)->rb_right;
+		else
+			return parent;
+	}
+
+	entry = rb_entry(node, struct hot_range_item, rb_node);
+	entry->in_tree = 1;
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, root);
+
+	return NULL;
+}
+
+/*
+ * Add a hot_inode_item to a hot_inode_tree. If the tree already contains
+ * an item with the index given, return -EEXIST
+ */
+int hot_rb_add_hot_inode_item(struct hot_inode_tree *tree,
+				struct hot_inode_item *he)
+{
+	int ret = 0;
+	struct rb_node *rb;
+
+	rb = hot_rb_insert_hot_inode_item(
+			&tree->map, he->i_ino, &he->rb_node);
+	if (rb) {
+		ret = -EEXIST;
+		goto out;
+	}
+
+	kref_get(&he->refs);
+
+out:
+	return ret;
+}
+
+/*
+ * Add a hot_range_item to a hot_range_tree. If the tree already contains
+ * an item with the index given, return -EEXIST
+ *
+ * Also optionally aggresively merge ranges (currently disabled)
+ */
+int hot_rb_add_hot_range_item(struct hot_range_tree *tree,
+			struct hot_range_item *hr)
+{
+	int ret = 0;
+	struct rb_node *rb;
+
+	rb = hot_rb_insert_hot_range_item(
+				&tree->map, hr->start, &hr->rb_node);
+	if (rb) {
+		ret = -EEXIST;
+		goto out;
+	}
+
+	kref_get(&hr->refs);
+
+out:
+	return ret;
+}
+
+/*
+ * Lookup a hot_inode_item in the hot_inode_tree with the given index
+ * (inode_num)
+ */
+struct hot_inode_item
+*hot_rb_lookup_hot_inode_item(struct hot_inode_tree *tree,
+				unsigned long inode_num)
+{
+	struct rb_node **p = &(tree->map.rb_node);
+	struct rb_node *parent = NULL;
+	struct hot_inode_item *entry;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct hot_inode_item, rb_node);
+
+		if (inode_num < entry->i_ino)
+			p = &(*p)->rb_left;
+		else if (inode_num > entry->i_ino)
+			p = &(*p)->rb_right;
+		else {
+			kref_get(&entry->refs);
+			return entry;
+		}
+	}
+
+	return NULL;
+}
+
+/*
+ * Lookup a hot_range_item in a hot_range_tree with the given index
+ * (start, offset)
+ */
+struct hot_range_item
+*hot_rb_lookup_hot_range_item(struct hot_range_tree *tree,
+				u64 start)
+{
+	struct rb_node **p = &(tree->map.rb_node);
+	struct rb_node *parent = NULL;
+	struct hot_range_item *entry;
+
+	/* ensure start is on a range boundary */
+	start = start & RANGE_SIZE_MASK;
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct hot_range_item, rb_node);
+
+		if (start < entry->start)
+			p = &(*p)->rb_left;
+		else if (start > hot_rb_range_end(entry))
+			p = &(*p)->rb_right;
+		else {
+			kref_get(&entry->refs);
+			return entry;
+		}
+	}
+
+	return NULL;
+}
+
+/* Update inode frequency struct */
+static struct hot_inode_item *hot_rb_update_inode_freq(struct inode *inode,
+							int rw)
+{
+	struct hot_info *root = &(inode->i_sb->s_hotinfo);
+	struct hot_inode_tree *hitree = &(root->hot_inode_tree);
+	struct hot_inode_item *he;
+
+	read_lock(&hitree->lock);
+	he = hot_rb_lookup_hot_inode_item(hitree, inode->i_ino);
+	read_unlock(&hitree->lock);
+
+	if (!he) {
+		he = kmem_cache_alloc(hot_inode_item_cache,
+					GFP_KERNEL | GFP_NOFS);
+		if (!he)
+			goto out;
+
+		write_lock(&hitree->lock);
+		hot_rb_inode_item_init(he);
+		he->i_ino = inode->i_ino;
+		hot_rb_add_hot_inode_item(hitree, he);
+		write_unlock(&hitree->lock);
+	}
+
+	spin_lock(&he->lock);
+	hot_rb_update_freq(&he->hot_freq_data, rw);
+	spin_unlock(&he->lock);
+
+out:
+	return he;
+}
+
+/* Update range frequency struct */
+static bool hot_rb_update_range_freq(struct hot_inode_item *he,
+				u64 off, u64 len, int rw,
+				struct hot_info *root)
+{
+	struct hot_range_tree *hrtree = &(he->hot_range_tree);
+	struct hot_range_item *hr = NULL;
+	u64 start_off = off & RANGE_SIZE_MASK;
+	u64 end_off = (off + len - 1) & RANGE_SIZE_MASK;
+	u64 cur;
+	int ret = true;
+
+	if (len == 0)
+		return false;
+
+	/*
+	 * Align ranges on RANGE_SIZE boundary to prevent proliferation
+	 * of range structs
+	 */
+	for (cur = start_off; cur <= end_off; cur += RANGE_SIZE) {
+		read_lock(&hrtree->lock);
+		hr = hot_rb_lookup_hot_range_item(hrtree, cur);
+		read_unlock(&hrtree->lock);
+
+		if (!hr) {
+			hr = kmem_cache_alloc(hot_range_item_cache,
+						GFP_KERNEL | GFP_NOFS);
+			if (!hr) {
+				ret = false;
+				goto out;
+			}
+
+			write_lock(&hrtree->lock);
+			hot_rb_range_item_init(hr);
+			hr->start = cur & RANGE_SIZE_MASK;
+			hr->len = RANGE_SIZE;
+			hr->hot_inode = he;
+			hot_rb_add_hot_range_item(hrtree, hr);
+			write_unlock(&hrtree->lock);
+		}
+
+		spin_lock(&hr->lock);
+		hot_rb_update_freq(&hr->hot_freq_data, rw);
+		spin_unlock(&hr->lock);
+		hot_rb_free_hot_range_item(hr);
+	}
+
+out:
+	return ret;
+}
+
+/*
+ * This function does the actual work of updating the frequency numbers,
+ * whatever they turn out to be. FREQ_POWER determines how many atime
+ * deltas we keep track of (as a power of 2). So, setting it to anything above
+ * 16ish is probably overkill. Also, the higher the power, the more bits get
+ * right shifted out of the timestamp, reducing precision, so take note of that
+ * as well.
+ *
+ * The caller should have already locked freq_data's parent's spinlock.
+ *
+ * FREQ_POWER, defined immediately below, determines how heavily to weight
+ * the current frequency numbers against the newest access. For example, a value
+ * of 4 means that the new access information will be weighted 1/16th (ie 2^-4)
+ * as heavily as the existing frequency info. In essence, this is a kludged-
+ * together version of a weighted average, since we can't afford to keep all of
+ * the information that it would take to get a _real_ weighted average.
+ */
+void hot_rb_update_freq(struct hot_freq_data *freq_data, int rw)
+{
+	struct timespec old_atime;
+	struct timespec current_time;
+	struct timespec delta_ts;
+	u64 new_avg;
+	u64 new_delta;
+
+	if (unlikely(rw)) {
+		old_atime = freq_data->last_write_time;
+		freq_data->nr_writes += 1;
+		new_avg = freq_data->avg_delta_writes;
+	} else {
+		old_atime = freq_data->last_read_time;
+		freq_data->nr_reads += 1;
+		new_avg = freq_data->avg_delta_reads;
+	}
+
+	current_time = current_kernel_time();
+	delta_ts = timespec_sub(current_time, old_atime);
+	new_delta = timespec_to_ns(&delta_ts) >> FREQ_POWER;
+
+	new_avg = (new_avg << FREQ_POWER) - new_avg + new_delta;
+	new_avg = new_avg >> FREQ_POWER;
+
+	if (unlikely(rw)) {
+		freq_data->last_write_time = current_time;
+		freq_data->avg_delta_writes = new_avg;
+	} else {
+		freq_data->last_read_time = current_time;
+		freq_data->avg_delta_reads = new_avg;
+	}
+}
+
+/* main function to update access frequency from read/writepage(s) hooks */
+void hot_rb_update_freqs(struct inode *inode, u64 start,
+			u64 len, int rw)
+{
+	struct hot_inode_item *he;
+
+	he = hot_rb_update_inode_freq(inode, rw);
+
+	WARN_ON(!he);
+
+	if (he) {
+		hot_rb_update_range_freq(he, start, len,
+			rw, &(inode->i_sb->s_hotinfo));
+
+		hot_rb_free_hot_inode_item(he);
+	}
+}
diff --git a/fs/hot_rb.h b/fs/hot_rb.h
index 9a68d699..4048027 100644
--- a/fs/hot_rb.h
+++ b/fs/hot_rb.h
@@ -21,10 +21,38 @@ void hot_rb_inode_tree_init(struct hot_inode_tree *tree);
 /* values for hot_freq_data flags */
 #define FREQ_DATA_TYPE_INODE (1 << 0) /* freq data struct is for an inode */
 #define FREQ_DATA_TYPE_RANGE (1 << 1) /* freq data struct is for a range */
+/* size of sub-file ranges */
+#define RANGE_SIZE (1<<20)
+#define RANGE_SIZE_MASK (~((u64)(RANGE_SIZE - 1)))
+
+#define FREQ_POWER 4
+
+struct hot_info;
+struct inode;
 
 void hot_rb_inode_item_init(void *_item);
 void hot_rb_range_item_init(void *_item);
 
+struct hot_range_item
+*hot_rb_lookup_hot_range_item(struct hot_range_tree *tree,
+				u64 start);
+
+struct hot_inode_item
+*hot_rb_lookup_hot_inode_item(struct hot_inode_tree *tree,
+				unsigned long inode_num);
+
+int hot_rb_add_hot_inode_item(struct hot_inode_tree *tree,
+				struct hot_inode_item *he);
+int hot_rb_add_hot_range_item(struct hot_range_tree *tree,
+				struct hot_range_item *hr);
+
+void hot_rb_free_hot_inode_item(struct hot_inode_item *he);
+void hot_rb_free_hot_range_item(struct hot_range_item *hr);
+
 int __init hot_rb_item_cache_init(void);
 
+void hot_rb_update_freq(struct hot_freq_data *freq_data, int rw);
+void hot_rb_update_freqs(struct inode *inode, u64 start, u64 len,
+			int rw);
+
 #endif /* __HOT_MAP__ */
-- 
1.7.6.5

