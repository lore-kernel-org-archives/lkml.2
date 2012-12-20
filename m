Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab2LTOpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 09:45:20 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:55044 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2LTOpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 09:45:06 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, david@fromorbit.com,
        dave@jikos.cz, darrick.wong@oracle.com, andi@firstfloor.org,
        hch@infradead.org, linuxram@linux.vnet.ibm.com, zwu.kernel@gmail.com,
        wuzhy@linux.vnet.ibm.com
Subject: [PATCH RESEND v1 11/16] vfs: register one shrinker
Date: Thu, 20 Dec 2012 22:43:30 +0800
Message-Id: <1356014615-15073-12-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
References: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12122014-3620-0000-0000-000000B09125
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Register a shrinker to control the amount of
memory that is used in tracking hot regions - if we are throwing
inodes out of memory due to memory pressure, we most definitely are
going to need to reduce the amount of memory the tracking code is
using, even if it means losing useful information (i.e. the shrinker
accelerates the aging process).

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |   63 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/hot_tracking.h |    1 +
 2 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 07a2a81..a59521c 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -643,6 +643,63 @@ err:
 }
 EXPORT_SYMBOL_GPL(hot_cache_init);
 
+static int hot_track_prune_map(struct hot_map_head *map_head,
+				bool type, int nr)
+{
+	struct hot_comm_item *node;
+	int i;
+
+	for (i = 0; i < HEAT_MAP_SIZE; i++) {
+		spin_lock(&(map_head + i)->lock);
+		while (!list_empty(&(map_head + i)->node_list)) {
+			if (nr-- <= 0)
+				break;
+
+			node = list_first_entry(&(map_head + i)->node_list,
+					struct hot_comm_item, n_list);
+			if (type) {
+				struct hot_inode_item *hot_inode =
+					container_of(node,
+					struct hot_inode_item, hot_inode);
+				hot_inode_item_put(hot_inode);
+			} else {
+				struct hot_range_item *hot_range =
+					container_of(node,
+					struct hot_range_item, hot_range);
+				hot_range_item_put(hot_range);
+			}
+		}
+		spin_unlock(&(map_head + i)->lock);
+	}
+
+	return nr;
+}
+
+/* The shrinker callback function */
+static int hot_track_prune(struct shrinker *shrink,
+			struct shrink_control *sc)
+{
+	struct hot_info *root =
+		container_of(shrink, struct hot_info, hot_shrink);
+	int ret;
+
+	if (sc->nr_to_scan == 0)
+		return root->hot_map_nr;
+
+	if (!(sc->gfp_mask & __GFP_FS))
+		return -1;
+
+	ret = hot_track_prune_map(root->heat_range_map,
+				false, sc->nr_to_scan);
+	if (ret > 0)
+		ret = hot_track_prune_map(root->heat_inode_map,
+					true, ret);
+	if (ret > 0)
+		root->hot_map_nr -= (sc->nr_to_scan - ret);
+
+	return root->hot_map_nr;
+}
+
 /*
  * Main function to update access frequency from read/writepage(s) hooks
  */
@@ -739,6 +796,11 @@ int hot_track_init(struct super_block *sb)
 	queue_delayed_work(root->update_wq, &root->update_work,
 		msecs_to_jiffies(HEAT_UPDATE_DELAY * MSEC_PER_SEC));
 
+	/* Register a shrinker callback */
+	root->hot_shrink.shrink = hot_track_prune;
+	root->hot_shrink.seeks = DEFAULT_SEEKS;
+	register_shrinker(&root->hot_shrink);
+
 	sb->s_hot_root = root;
 
 	printk(KERN_INFO "VFS: Turning on hot data tracking\n");
@@ -757,6 +819,7 @@ void hot_track_exit(struct super_block *sb)
 {
 	struct hot_info *root = sb->s_hot_root;
 
+	unregister_shrinker(&root->hot_shrink);
 	cancel_delayed_work_sync(&root->update_work);
 	destroy_workqueue(root->update_wq);
 	hot_map_exit(root);
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 003af47..36dac41 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -110,6 +110,7 @@ struct hot_info {
 	struct workqueue_struct *update_wq;
 	struct delayed_work update_work;
 	struct hot_type *hot_type;
+	struct shrinker hot_shrink;
 };
 
 extern void __init hot_cache_init(void);
-- 
1.7.6.5

