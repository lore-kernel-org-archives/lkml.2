Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001Ab2IKOjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:39:49 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60447 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755975Ab2IKOjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:39:47 -0400
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
        viro@zeniv.linux.org.uk, hch@lst.de, chris.mason@fusionio.com,
        cmm@us.ibm.com, linuxram@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC 05/11] vfs: add one new mount option -o hottrack
Date: Tue, 11 Sep 2012 22:27:19 +0800
Message-Id: <1347373645-2119-6-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1347373645-2119-1-git-send-email-zwu.kernel@gmail.com>
References: <1347373645-2119-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091114-5806-0000-0000-0000197794C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Introduce one new mount option '-o hottrack',
and add its parsing support.
  Its usage looks like:
   mount -o hottrack
   mount -o nouser,hottrack
   mount -o nouser,hottrack,loop
   mount -o hottrack,nouser

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_track.c            |   34 ++++++++++++++++++++++++++++++++++
 fs/hot_track.h            |    1 +
 fs/super.c                |    5 +++++
 include/linux/hot_track.h |    6 ++++++
 4 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/fs/hot_track.c b/fs/hot_track.c
index 3690f26..36a41cb 100644
--- a/fs/hot_track.c
+++ b/fs/hot_track.c
@@ -16,6 +16,40 @@
 #include "hot_track.h"
 
 /*
+ * Regular mount options parser for -hottrack option.
+ * return false if no -hottrack is specified;
+ * otherwise return true. And the -hottrack will be
+ * removed from options.
+ */
+bool hot_track_parse_options(char *options)
+{
+	long len;
+	char *p;
+	static char opts_hot[] = "hottrack";
+
+	if (!options)
+		return false;
+
+	p = strstr(options, opts_hot);
+	if (!p)
+		return false;
+
+	while (p) {
+		len = options + strlen(options) - (p + strlen(opts_hot));
+		if (len == 0) {
+			options[0] = '\0';
+			break;
+		}
+
+		memmove(p, p + strlen(opts_hot) + 1, len);
+		p = strstr(options, opts_hot);
+	}
+
+	printk(KERN_INFO "vfs: turning on hot data tracking\n");
+	return true;
+}
+
+/*
  * Initialize hot_inode_item, hot_range_item
  * and hot_hash_node kmem cache
  */
diff --git a/fs/hot_track.h b/fs/hot_track.h
index cf4cf35..dc0f5a2 100644
--- a/fs/hot_track.h
+++ b/fs/hot_track.h
@@ -15,6 +15,7 @@
 
 #include "hot_rb.h"
 
+bool hot_track_parse_options(char *options);
 void __init hot_track_item_cache_init(void);
 
 #endif /* __HOT_TRACK__ */
diff --git a/fs/super.c b/fs/super.c
index 0902cfa..d5bc781 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -35,6 +35,7 @@
 #include <linux/fsnotify.h>
 #include <linux/lockdep.h>
 #include "internal.h"
+#include "hot_track.h"
 
 
 LIST_HEAD(super_blocks);
@@ -1125,6 +1126,7 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
 	struct dentry *root;
 	struct super_block *sb;
 	char *secdata = NULL;
+	bool hottrack = false;
 	int error = -ENOMEM;
 
 	if (data && !(type->fs_flags & FS_BINARY_MOUNTDATA)) {
@@ -1137,6 +1139,9 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
 			goto out_free_secdata;
 	}
 
+	if (data && hot_track_parse_options(data))
+		hottrack = true;
+
 	root = type->mount(type, flags, name, data);
 	if (IS_ERR(root)) {
 		error = PTR_ERR(root);
diff --git a/include/linux/hot_track.h b/include/linux/hot_track.h
index 2256496..b56a467 100644
--- a/include/linux/hot_track.h
+++ b/include/linux/hot_track.h
@@ -20,6 +20,11 @@
 #include <linux/rbtree.h>
 #include <linux/kref.h>
 
+/*
+ * Flags for hot data tracking mount options.
+ */
+#define HOT_MOUNT_HOT_TRACK		(1 << 0)
+
 /* A tree that sits on the hot_info */
 struct hot_inode_tree {
 	struct rb_root map;
@@ -89,6 +94,7 @@ struct hot_range_item {
 };
 
 struct hot_info {
+	unsigned long mount_opt;
 
 	/* red-black tree that keeps track of fs-wide hot data */
 	struct hot_inode_tree hot_inode_tree;
-- 
1.7.6.5

