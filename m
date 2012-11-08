Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab2KHJHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:07:32 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39603 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206Ab2KHJD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:03:27 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, david@fromorbit.com,
        cmm@us.ibm.com, swhiteho@redhat.com, dave@jikos.cz,
        darrick.wong@oracle.com, andi@firstfloor.org, northrup.james@gmail.com,
        gregkh@linuxfoundation.org, linuxram@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v1 hot_track 13/18] vfs: add debugfs support
Date: Thu,  8 Nov 2012 17:01:20 +0800
Message-Id: <1352365285-32419-14-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1352365285-32419-1-git-send-email-zwu.kernel@gmail.com>
References: <1352365285-32419-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110809-5112-0000-0000-00000E560440
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add a /sys/kernel/debug/hot_track/<device_name>/ directory for each
volume that contains two files. The first, `inode_stats', contains the
heat information for inodes that have been brought into the hot data map
structures. The second, `range_stats', contains similar information for
subfile ranges.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |  484 ++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |    5 +
 include/linux/hot_tracking.h |    1 +
 3 files changed, 490 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 3d96512..db430e8 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -21,9 +21,12 @@
 #include <linux/blkdev.h>
 #include <linux/types.h>
 #include <linux/list_sort.h>
+#include <linux/debugfs.h>
 #include <linux/limits.h>
 #include "hot_tracking.h"
 
+static struct dentry *hot_debugfs_root;
+
 /* kmem_cache pointers for slab caches */
 static struct kmem_cache *hot_inode_item_cachep __read_mostly;
 static struct kmem_cache *hot_range_item_cachep __read_mostly;
@@ -623,6 +626,475 @@ static void hot_update_worker(struct work_struct *work)
 }
 
 /*
+ * take the inode, find ranges associated with inode
+ * and print each range data struct
+ */
+static struct hot_range_item
+*hot_range_tree_walk(struct hot_inode_item *he,
+			loff_t *pos, loff_t start, bool flag)
+{
+	struct hot_range_item *hr_nodes[8];
+	loff_t l = *pos;
+	int i, n;
+
+	/* Walk the hot_range_tree for inode */
+	while (1) {
+		spin_lock(&he->lock);
+		n = radix_tree_gang_lookup(&he->hot_range_tree,
+					   (void **)hr_nodes, start,
+					   ARRAY_SIZE(hr_nodes));
+		if (!n) {
+			spin_unlock(&he->lock);
+			break;
+		}
+		spin_unlock(&he->lock);
+
+		start = hr_nodes[n - 1]->start + 1;
+		for (i = 0; i < n; i++) {
+			if ((!flag && !l--) || (flag)) {
+				if (flag)
+					(*pos)++;
+				kref_get(&hr_nodes[i]->hot_range.refs);
+				return hr_nodes[i];
+			}
+		}
+	}
+
+	return NULL;
+}
+
+static void
+*hot_inode_tree_walk(struct seq_file *seq, loff_t *pos,
+			unsigned long ino, bool type, bool flag)
+{
+	struct hot_info *root = seq->private;
+	struct hot_inode_item *hi_nodes[8];
+	struct hot_range_item *hr;
+	loff_t l = *pos;
+	int i, n;
+
+	while (1) {
+		spin_lock(&root->lock);
+		n = radix_tree_gang_lookup(&root->hot_inode_tree,
+					(void **)hi_nodes, ino,
+					ARRAY_SIZE(hi_nodes));
+		if (!n) {
+			spin_unlock(&root->lock);
+			break;
+		}
+		spin_unlock(&root->lock);
+
+		ino = hi_nodes[n - 1]->i_ino + 1;
+		for (i = 0; i < n; i++) {
+			if (!type) {
+				hr = hot_range_tree_walk(hi_nodes[i],
+						pos, 0, flag);
+				if (hr)
+					return hr;
+			} else {
+				if ((!flag && !l--) || (flag)) {
+					if (flag)
+						(*pos)++;
+					kref_get(&hi_nodes[i]->hot_inode.refs);
+					return hi_nodes[i];
+				}
+			}
+		}
+	}
+
+	return NULL;
+}
+
+static void *hot_range_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	return hot_inode_tree_walk(seq, pos, 0, false, false);
+}
+
+static void *hot_range_seq_next(struct seq_file *seq,
+				void *v, loff_t *pos)
+{
+	struct hot_range_item *hr_next, *hr = v;
+	loff_t start = hr->start + 1;
+
+	/* Walk the hot_range_tree for inode */
+	hr_next = hot_range_tree_walk(hr->hot_inode, pos, start, true);
+	if (hr_next)
+		return hr_next;
+
+	return hot_inode_tree_walk(seq, pos,
+			hr->hot_inode->i_ino + 1, false, true);
+}
+
+static void hot_range_seq_stop(struct seq_file *seq, void *v)
+{
+	struct hot_range_item *hr = v;
+
+	if (hr)
+		hot_range_item_put(hr);
+}
+
+static int hot_range_seq_show(struct seq_file *seq, void *v)
+{
+	struct hot_range_item *hr = v;
+	struct hot_inode_item *he = hr->hot_inode;
+	struct hot_freq_data *freq_data = &hr->hot_range.hot_freq_data;
+	struct hot_info *root = container_of(he->hot_inode_tree,
+		struct hot_info, hot_inode_tree);
+	loff_t start = hr->start * hot_raw_shift(1,
+			root->hot_type->range_bits, true);
+
+	/* Always lock hot_inode_item first */
+	spin_lock(&he->hot_inode.lock);
+	spin_lock(&hr->hot_range.lock);
+	seq_printf(seq, "inode %lu, range start " \
+			"%llu (range len %llu) reads %u, writes %u, "
+			"avg read time %llu, avg write time %llu, temp %u\n",
+			he->i_ino, (unsigned long long)start,
+			(unsigned long long)hr->len,
+			freq_data->nr_reads,
+			freq_data->nr_writes,
+			freq_data->avg_delta_reads / NSEC_PER_MSEC,
+			freq_data->avg_delta_writes / NSEC_PER_MSEC,
+			(u8)hot_raw_shift((u64)freq_data->last_temp,
+					(32 - HEAT_MAP_BITS), false));
+	spin_unlock(&hr->hot_range.lock);
+	spin_unlock(&he->hot_inode.lock);
+
+	return 0;
+}
+
+static void *hot_inode_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	return hot_inode_tree_walk(seq, pos, 0, true, false);
+}
+
+static void *hot_inode_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct hot_inode_item *he = v;
+	unsigned long ino = he->i_ino + 1;
+
+	hot_inode_item_put(he);
+
+	return hot_inode_tree_walk(seq, pos, ino, true, true);
+}
+
+static void hot_inode_seq_stop(struct seq_file *seq, void *v)
+{
+	struct hot_inode_item *he = v;
+
+	if (he)
+		hot_inode_item_put(he);
+}
+
+static int hot_inode_seq_show(struct seq_file *seq, void *v)
+{
+	struct hot_inode_item *he = v;
+	struct hot_freq_data *freq_data = &he->hot_inode.hot_freq_data;
+
+	spin_lock(&he->hot_inode.lock);
+	seq_printf(seq, "inode %lu, reads %u, writes %u, " \
+		"avg read time %llu, avg write time %llu, temp %d\n",
+		he->i_ino,
+		freq_data->nr_reads,
+		freq_data->nr_writes,
+		freq_data->avg_delta_reads / NSEC_PER_MSEC,
+		freq_data->avg_delta_writes / NSEC_PER_MSEC,
+		(u8)hot_raw_shift((u64)freq_data->last_temp,
+				(32 - HEAT_MAP_BITS), false));
+	spin_unlock(&he->hot_inode.lock);
+
+	return 0;
+}
+
+static void *hot_spot_range_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct hot_info *root = seq->private;
+	struct hot_range_item *hr;
+	struct hot_comm_item *comm_item;
+	struct list_head *n_list;
+	int i;
+
+	for (i = HEAT_MAP_SIZE - 1; i >= 0; i--) {
+		n_list = seq_list_start(
+			&root->heat_range_map[i].node_list, *pos);
+		if (n_list) {
+			comm_item = container_of(n_list,
+				struct hot_comm_item, n_list);
+			hr = container_of(comm_item,
+				struct hot_range_item, hot_range);
+			kref_get(&hr->hot_range.refs);
+			return hr;
+		}
+	}
+
+	return NULL;
+}
+
+static void *hot_spot_range_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct hot_info *root = seq->private;
+	struct hot_range_item *hr_next, *hr = v;
+	struct hot_comm_item *comm_item;
+	struct list_head *n_list;
+	int i = (int)hot_raw_shift(hr->hot_range.hot_freq_data.last_temp,
+				(32 - HEAT_MAP_BITS), false);
+
+	n_list = seq_list_next(&hr->hot_range.n_list,
+		&root->heat_range_map[i].node_list, pos);
+	hot_range_item_put(hr);
+next:
+	if (n_list) {
+		comm_item = container_of(n_list,
+			struct hot_comm_item, n_list);
+		hr_next = container_of(comm_item,
+			struct hot_range_item, hot_range);
+		kref_get(&hr_next->hot_range.refs);
+		return hr_next;
+	} else if (--i >= 0) {
+		n_list = seq_list_next(&root->heat_range_map[i].node_list,
+				&root->heat_range_map[i].node_list, pos);
+		goto next;
+	}
+
+	return NULL;
+}
+
+static void *hot_spot_inode_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct hot_info *root = seq->private;
+	struct hot_inode_item *he;
+	struct hot_comm_item *comm_item;
+	struct list_head *n_list;
+	int i;
+
+	for (i = HEAT_MAP_SIZE - 1; i >= 0; i--) {
+		n_list = seq_list_start(
+			&root->heat_inode_map[i].node_list, *pos);
+		if (n_list) {
+			comm_item = container_of(n_list,
+				struct hot_comm_item, n_list);
+			he = container_of(comm_item,
+				struct hot_inode_item, hot_inode);
+			kref_get(&he->hot_inode.refs);
+			return he;
+		}
+	}
+
+	return NULL;
+}
+
+static void *hot_spot_inode_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct hot_info *root = seq->private;
+	struct hot_inode_item *he_next, *he = v;
+	struct hot_comm_item *comm_item;
+	struct list_head *n_list;
+	int i = (int)hot_raw_shift(he->hot_inode.hot_freq_data.last_temp,
+				(32 - HEAT_MAP_BITS), false);
+
+	n_list = seq_list_next(&he->hot_inode.n_list,
+			&root->heat_inode_map[i].node_list, pos);
+	hot_inode_item_put(he);
+next:
+	if (n_list) {
+		comm_item = container_of(n_list,
+			struct hot_comm_item, n_list);
+		he_next = container_of(comm_item,
+			struct hot_inode_item, hot_inode);
+		kref_get(&he_next->hot_inode.refs);
+		return he_next;
+	} else if (--i >= 0) {
+		n_list = seq_list_next(&root->heat_inode_map[i].node_list,
+				&root->heat_inode_map[i].node_list, pos);
+		goto next;
+	}
+
+	return NULL;
+}
+
+static const struct seq_operations hot_range_seq_ops = {
+	.start = hot_range_seq_start,
+	.next = hot_range_seq_next,
+	.stop = hot_range_seq_stop,
+	.show = hot_range_seq_show
+};
+
+static const struct seq_operations hot_inode_seq_ops = {
+	.start = hot_inode_seq_start,
+	.next = hot_inode_seq_next,
+	.stop = hot_inode_seq_stop,
+	.show = hot_inode_seq_show
+};
+
+static const struct seq_operations hot_spot_range_seq_ops = {
+	.start = hot_spot_range_seq_start,
+	.next = hot_spot_range_seq_next,
+	.stop = hot_range_seq_stop,
+	.show = hot_range_seq_show
+};
+
+static const struct seq_operations hot_spot_inode_seq_ops = {
+	.start = hot_spot_inode_seq_start,
+	.next = hot_spot_inode_seq_next,
+	.stop = hot_inode_seq_stop,
+	.show = hot_inode_seq_show
+};
+
+static int hot_range_seq_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open_private(file, &hot_range_seq_ops, 0);
+	if (ret == 0) {
+		struct seq_file *seq = file->private_data;
+		seq->private = inode->i_private;
+	}
+	return ret;
+}
+
+static int hot_inode_seq_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open_private(file, &hot_inode_seq_ops, 0);
+	if (ret == 0) {
+		struct seq_file *seq = file->private_data;
+		seq->private = inode->i_private;
+	}
+	return ret;
+}
+
+static int hot_spot_range_seq_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open_private(file, &hot_spot_range_seq_ops, 0);
+	if (ret == 0) {
+		struct seq_file *seq = file->private_data;
+		seq->private = inode->i_private;
+	}
+	return ret;
+}
+
+static int hot_spot_inode_seq_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open_private(file, &hot_spot_inode_seq_ops, 0);
+	if (ret == 0) {
+		struct seq_file *seq = file->private_data;
+		seq->private = inode->i_private;
+	}
+	return ret;
+}
+
+/* fops to override for printing range data */
+static const struct file_operations hot_debugfs_range_fops = {
+	.open = hot_range_seq_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+/* fops to override for printing inode data */
+static const struct file_operations hot_debugfs_inode_fops = {
+	.open = hot_inode_seq_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+/* fops to override for printing temperature data */
+static const struct file_operations hot_debugfs_spot_range_fops = {
+	.open = hot_spot_range_seq_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+static const struct file_operations hot_debugfs_spot_inode_fops = {
+	.open = hot_spot_inode_seq_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+static const struct hot_debugfs hot_debugfs[] = {
+	{
+		.name = "rt_stats_range",
+		.fops  = &hot_debugfs_range_fops,
+	},
+	{
+		.name = "rt_stats_inode",
+		.fops  = &hot_debugfs_inode_fops,
+	},
+	{
+		.name = "hot_spots_range",
+		.fops  = &hot_debugfs_spot_range_fops,
+	},
+	{
+		.name = "hot_spots_inode",
+		.fops  = &hot_debugfs_spot_inode_fops,
+	},
+};
+
+/* initialize debugfs */
+static int hot_debugfs_init(struct super_block *sb)
+{
+	static const char hot_name[] = "hot_track";
+	struct dentry *dentry;
+	int i, ret = 0;
+
+	/* Determine if hot debufs root has existed */
+	if (!hot_debugfs_root) {
+		hot_debugfs_root = debugfs_create_dir(hot_name, NULL);
+		if (IS_ERR(hot_debugfs_root)) {
+			ret = PTR_ERR(hot_debugfs_root);
+			return ret;
+		}
+	}
+
+	if (!S_ISDIR(hot_debugfs_root->d_inode->i_mode))
+		return -ENOTDIR;
+
+	/* create debugfs folder for this volume by mounted dev name */
+	sb->s_hot_root->vol_dentry =
+			debugfs_create_dir(sb->s_id, hot_debugfs_root);
+	if (IS_ERR(sb->s_hot_root->vol_dentry)) {
+		ret = PTR_ERR(sb->s_hot_root->vol_dentry);
+		goto err;
+	}
+
+	/* create debugfs hot data files */
+	for (i = 0; i < ARRAY_SIZE(hot_debugfs); i++) {
+		dentry = debugfs_create_file(hot_debugfs[i].name,
+					S_IFREG | S_IRUSR | S_IWUSR,
+					sb->s_hot_root->vol_dentry,
+					sb->s_hot_root,
+					hot_debugfs[i].fops);
+		if (IS_ERR(dentry)) {
+			ret = PTR_ERR(dentry);
+			goto err;
+		}
+	}
+
+	return 0;
+
+err:
+	debugfs_remove_recursive(sb->s_hot_root->vol_dentry);
+
+	if (list_empty(&hot_debugfs_root->d_subdirs))
+		debugfs_remove(hot_debugfs_root);
+
+	return ret;
+}
+
+/* remove dentries for debugsfs */
+static void hot_debugfs_exit(struct super_block *sb)
+{
+	/* remove all debugfs entries recursively from the volume root */
+	if (sb->s_hot_root->vol_dentry)
+		debugfs_remove_recursive(sb->s_hot_root->vol_dentry);
+	else
+		BUG();
+
+	if (list_empty(&hot_debugfs_root->d_subdirs))
+		debugfs_remove(hot_debugfs_root);
+}
+
+/*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
 void __init hot_cache_init(void)
@@ -805,10 +1277,21 @@ int hot_track_init(struct super_block *sb)
 	root->hot_shrink.seeks = DEFAULT_SEEKS;
 	register_shrinker(&root->hot_shrink);
 
+	ret = hot_debugfs_init(sb);
+	if (ret) {
+		printk(KERN_ERR "%s: hot_debugfs_init error: %d\n",
+				__func__, ret);
+		goto failed_debugfs;
+	}
+
 	printk(KERN_INFO "VFS: Turning on hot data tracking\n");
 
 	return 0;
 
+failed_debugfs:
+	unregister_shrinker(&root->hot_shrink);
+	cancel_delayed_work_sync(&root->update_work);
+	destroy_workqueue(root->update_wq);
 failed_wq:
 	hot_map_exit(root);
 	hot_inode_tree_exit(root);
@@ -826,6 +1309,7 @@ void hot_track_exit(struct super_block *sb)
 	destroy_workqueue(root->update_wq);
 	hot_map_exit(root);
 	hot_inode_tree_exit(root);
+	hot_debugfs_exit(sb);
 	kfree(root);
 }
 EXPORT_SYMBOL_GPL(hot_track_exit);
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 2914203..1a445a6 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -54,4 +54,9 @@
 #define AVW_DIVIDER_POWER 40 /* AVW - average delta between recent writes(ns) */
 #define AVW_COEFF_POWER 0
 
+struct hot_debugfs {
+	const char *name;
+	const struct file_operations *fops;
+};
+
 #endif /* __HOT_TRACKING__ */
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 5c0074a..d9a49f9 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -116,6 +116,7 @@ struct hot_info {
 	struct delayed_work update_work;
 	struct hot_type *hot_type;
 	struct shrinker hot_shrink;
+	struct dentry *vol_dentry;
 };
 
 /*
-- 
1.7.6.5

