Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387Ab2IKOlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:41:31 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55295 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759259Ab2IKOlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:41:25 -0400
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
        viro@zeniv.linux.org.uk, hch@lst.de, chris.mason@fusionio.com,
        cmm@us.ibm.com, linuxram@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC 06/11] vfs: add init and exit support
Date: Tue, 11 Sep 2012 22:40:40 +0800
Message-Id: <1347374445-3018-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091114-4242-0000-0000-000002DF27FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add initialization function to create some
key data structures when hot tracking is enabled;
Clean up them when hot tracking is disabled.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_rb.c    |   45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/hot_rb.h    |    6 ++++++
 fs/hot_track.c |   15 +++++++++++++++
 fs/hot_track.h |    2 ++
 fs/namespace.c |    4 ++++
 fs/super.c     |    6 ++++++
 6 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/fs/hot_rb.c b/fs/hot_rb.c
index 560841a..71f5e76 100644
--- a/fs/hot_rb.c
+++ b/fs/hot_rb.c
@@ -133,6 +133,33 @@ void hot_rb_free_hot_range_item(struct hot_range_item *hr)
 	}
 }
 
+/* Frees the entire hot_inode_tree. */
+void hot_rb_free_hot_inode_tree(struct hot_info *root)
+{
+	struct rb_node *node, *node2;
+	struct hot_inode_item *he;
+	struct hot_range_item *hr;
+
+	/* Free hot inode and range trees on fs root */
+	node = rb_first(&root->hot_inode_tree.map);
+
+	while (node) {
+		he = rb_entry(node, struct hot_inode_item, rb_node);
+
+		node2 = rb_first(&he->hot_range_tree.map);
+		while (node2) {
+			hr = rb_entry(node2, struct hot_range_item, rb_node);
+			hot_rb_remove_hot_range_item(&he->hot_range_tree, hr);
+			hot_rb_free_hot_range_item(hr);
+			node2 = rb_first(&he->hot_range_tree.map);
+		}
+
+		hot_rb_remove_hot_inode_item(&root->hot_inode_tree, he);
+		hot_rb_free_hot_inode_item(he);
+		node = rb_first(&root->hot_inode_tree.map);
+	}
+}
+
 static struct rb_node *hot_rb_insert_hot_inode_item(struct rb_root *root,
 						unsigned long inode_num,
 						struct rb_node *node)
@@ -309,6 +336,24 @@ struct hot_range_item
 	return NULL;
 }
 
+int hot_rb_remove_hot_inode_item(struct hot_inode_tree *tree,
+				struct hot_inode_item *he)
+{
+	int ret = 0;
+	rb_erase(&he->rb_node, &tree->map);
+	he->in_tree = 0;
+	return ret;
+}
+
+int hot_rb_remove_hot_range_item(struct hot_range_tree *tree,
+				struct hot_range_item *hr)
+{
+	int ret = 0;
+	rb_erase(&hr->rb_node, &tree->map);
+	hr->in_tree = 0;
+	return ret;
+}
+
 /* Update inode frequency struct */
 static struct hot_inode_item *hot_rb_update_inode_freq(struct inode *inode,
 							int rw)
diff --git a/fs/hot_rb.h b/fs/hot_rb.h
index 4048027..df8cd14 100644
--- a/fs/hot_rb.h
+++ b/fs/hot_rb.h
@@ -46,8 +46,14 @@ int hot_rb_add_hot_inode_item(struct hot_inode_tree *tree,
 int hot_rb_add_hot_range_item(struct hot_range_tree *tree,
 				struct hot_range_item *hr);
 
+int hot_rb_remove_hot_inode_item(struct hot_inode_tree *tree,
+				struct hot_inode_item *he);
+int hot_rb_remove_hot_range_item(struct hot_range_tree *tree,
+				struct hot_range_item *hr);
+
 void hot_rb_free_hot_inode_item(struct hot_inode_item *he);
 void hot_rb_free_hot_range_item(struct hot_range_item *hr);
+void hot_rb_free_hot_inode_tree(struct hot_info *root);
 
 int __init hot_rb_item_cache_init(void);
 
diff --git a/fs/hot_track.c b/fs/hot_track.c
index 36a41cb..68f85ad 100644
--- a/fs/hot_track.c
+++ b/fs/hot_track.c
@@ -58,3 +58,18 @@ void __init hot_track_item_cache_init(void)
 	if (hot_rb_item_cache_init())
 		return;
 }
+
+/*
+ * Initialize the data structures for hot data tracking.
+ */
+void hot_track_init(struct super_block *sb, const char *name)
+{
+	sb->s_hotinfo.mount_opt |= HOT_MOUNT_HOT_TRACK;
+	hot_rb_inode_tree_init(&sb->s_hotinfo.hot_inode_tree);
+}
+
+void hot_track_exit(struct super_block *sb)
+{
+	sb->s_hotinfo.mount_opt &= ~HOT_MOUNT_HOT_TRACK;
+	hot_rb_free_hot_inode_tree(&sb->s_hotinfo);
+}
diff --git a/fs/hot_track.h b/fs/hot_track.h
index dc0f5a2..b2f096c 100644
--- a/fs/hot_track.h
+++ b/fs/hot_track.h
@@ -17,5 +17,7 @@
 
 bool hot_track_parse_options(char *options);
 void __init hot_track_item_cache_init(void);
+void hot_track_init(struct super_block *sb, const char *name);
+void hot_track_exit(struct super_block *sb);
 
 #endif /* __HOT_TRACK__ */
diff --git a/fs/namespace.c b/fs/namespace.c
index 4d31f73..90c958a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -22,6 +22,7 @@
 #include <linux/uaccess.h>
 #include "pnode.h"
 #include "internal.h"
+#include "hot_track.h"
 
 #define HASH_SHIFT ilog2(PAGE_SIZE / sizeof(struct list_head))
 #define HASH_SIZE (1UL << HASH_SHIFT)
@@ -1215,6 +1216,9 @@ static int do_umount(struct mount *mnt, int flags)
 		return retval;
 	}
 
+	if (sb->s_hotinfo.mount_opt & HOT_MOUNT_HOT_TRACK)
+		hot_track_exit(sb);
+
 	down_write(&namespace_sem);
 	br_write_lock(&vfsmount_lock);
 	event++;
diff --git a/fs/super.c b/fs/super.c
index d5bc781..eaf95fe 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1153,6 +1153,9 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
 	WARN_ON(sb->s_bdi == &default_backing_dev_info);
 	sb->s_flags |= MS_BORN;
 
+	if (hottrack)
+		hot_track_init(sb, name);
+
 	error = security_sb_kern_mount(sb, flags, secdata);
 	if (error)
 		goto out_sb;
@@ -1170,6 +1173,9 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
 	free_secdata(secdata);
 	return root;
 out_sb:
+	if (hottrack)
+		hot_track_exit(sb);
+
 	dput(root);
 	deactivate_locked_super(sb);
 out_free_secdata:
-- 
1.7.6.5

