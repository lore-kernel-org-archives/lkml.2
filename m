Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab2KPJwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:52:12 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40580 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab2KPJwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:52:10 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v1 hot_track 09/16] vfs: add one work queue
Date: Fri, 16 Nov 2012 17:51:11 +0800
Message-Id: <1353059478-25474-10-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1353059478-25474-1-git-send-email-zwu.kernel@gmail.com>
References: <1353059478-25474-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111609-6078-0000-0000-000011F8EBD4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add a per-superblock workqueue and a delayed_work
to run periodic work to update map info on each superblock.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |   81 ++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |    3 ++
 include/linux/hot_tracking.h |    3 ++
 3 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 304028d..873d234 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -15,9 +15,12 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 #include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/types.h>
+#include <linux/list_sort.h>
 #include <linux/limits.h>
 #include "hot_tracking.h"
 
@@ -539,6 +542,63 @@ static void hot_map_exit(struct hot_info *root)
 	}
 }
 
+/* Temperature compare function*/
+static int hot_temp_cmp(void *priv, struct list_head *a,
+				struct list_head *b)
+{
+	struct hot_comm_item *ap =
+			container_of(a, struct hot_comm_item, n_list);
+	struct hot_comm_item *bp =
+			container_of(b, struct hot_comm_item, n_list);
+
+	int diff = ap->hot_freq_data.last_temp
+				- bp->hot_freq_data.last_temp;
+	if (diff > 0)
+		return -1;
+	if (diff < 0)
+		return 1;
+	return 0;
+}
+
+/*
+ * Every sync period we update temperatures for
+ * each hot inode item and hot range item for aging
+ * purposes.
+ */
+static void hot_update_worker(struct work_struct *work)
+{
+	struct hot_info *root = container_of(to_delayed_work(work),
+					struct hot_info, update_work);
+	struct rb_node *node;
+	struct hot_comm_item *ci;
+	struct hot_inode_item *he;
+	int i;
+
+	node = rb_first(&root->hot_inode_tree.map);
+	while (node) {
+		ci = rb_entry(node, struct hot_comm_item, rb_node);
+		he = container_of(ci, struct hot_inode_item, hot_inode);
+		kref_get(&he->hot_inode.refs);
+		hot_map_update(
+			&he->hot_inode.hot_freq_data, root);
+		hot_range_update(he, root);
+		node = rb_next(node);
+		hot_inode_item_put(he);
+	}
+
+	/* Sort temperature map info */
+	for (i = 0; i < HEAT_MAP_SIZE; i++) {
+		list_sort(NULL, &root->heat_inode_map[i].node_list,
+			hot_temp_cmp);
+		list_sort(NULL, &root->heat_range_map[i].node_list,
+			hot_temp_cmp);
+	}
+
+	/* Instert next delayed work */
+	queue_delayed_work(root->update_wq, &root->update_work,
+		msecs_to_jiffies(HEAT_UPDATE_DELAY * MSEC_PER_SEC));
+}
+
 /*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
@@ -632,11 +692,30 @@ int hot_track_init(struct super_block *sb)
 	hot_inode_tree_init(root);
 	hot_map_init(root);
 
+	root->update_wq = alloc_workqueue(
+		"hot_update_wq", WQ_NON_REENTRANT, 0);
+	if (!root->update_wq) {
+		printk(KERN_ERR "%s: Failed to create "
+				"hot update workqueue\n", __func__);
+		goto failed_wq;
+	}
+
+	/* Initialize hot tracking wq and arm one delayed work */
+	INIT_DELAYED_WORK(&root->update_work, hot_update_worker);
+	queue_delayed_work(root->update_wq, &root->update_work,
+		msecs_to_jiffies(HEAT_UPDATE_DELAY * MSEC_PER_SEC));
+
 	sb->s_hot_root = root;
 
 	printk(KERN_INFO "VFS: Turning on hot data tracking\n");
 
 	return 0;
+
+failed_wq:
+	hot_map_exit(root);
+	hot_inode_tree_exit(root);
+	kfree(root);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(hot_track_init);
 
@@ -644,6 +723,8 @@ void hot_track_exit(struct super_block *sb)
 {
 	struct hot_info *root = sb->s_hot_root;
 
+	cancel_delayed_work_sync(&root->update_work);
+	destroy_workqueue(root->update_wq);
 	hot_map_exit(root);
 	hot_inode_tree_exit(root);
 	sb->s_hot_root = NULL;
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 46d068a..96379a6 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -30,6 +30,9 @@
  */
 #define TIME_TO_KICK 300
 
+/* set how often to update temperatures (seconds) */
+#define HEAT_UPDATE_DELAY 300
+
 /* NRR/NRW heat unit = 2^X accesses */
 #define NRR_MULTIPLIER_POWER 20 /* NRR - number of reads since mount */
 #define NRR_COEFF_POWER 0
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 34a0530..ef12748 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -88,6 +88,9 @@ struct hot_info {
 	/* map of range temperature */
 	struct hot_map_head heat_range_map[HEAT_MAP_SIZE];
 	unsigned int hot_map_nr;
+
+	struct workqueue_struct *update_wq;
+	struct delayed_work update_work;
 };
 
 extern void __init hot_cache_init(void);
-- 
1.7.6.5

