Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887Ab2IKOdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:33:23 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48771 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab2IKOdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:33:20 -0400
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
        viro@zeniv.linux.org.uk, hch@lst.de, chris.mason@fusionio.com,
        cmm@us.ibm.com, linuxram@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC 02/11] vfs: introduce one rb tree - hot_inode_tree
Date: Tue, 11 Sep 2012 22:27:16 +0800
Message-Id: <1347373645-2119-3-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1347373645-2119-1-git-send-email-zwu.kernel@gmail.com>
References: <1347373645-2119-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091114-7182-0000-0000-00000292C41B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Adds hot_inode_tree struct to keep track of
frequently accessed files, and be keyed by {inode, offset}.
Trees contain hot_inode_items representing those files
and ranges.
  Having these trees means that vfs can quickly determine the
temperature of some data by doing some calculations on the
hot_freq_data struct that hangs off of the tree item.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/Makefile               |    3 ++-
 fs/hot_rb.c               |   30 ++++++++++++++++++++++++++++++
 fs/hot_rb.h               |   21 +++++++++++++++++++++
 include/linux/hot_track.h |    9 +++++++++
 4 files changed, 62 insertions(+), 1 deletions(-)
 create mode 100644 fs/hot_rb.c
 create mode 100644 fs/hot_rb.h

diff --git a/fs/Makefile b/fs/Makefile
index 2fb9779..d3bc906 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -11,7 +11,8 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o fs_struct.o statfs.o
+		stack.o fs_struct.o statfs.o \
+		hot_rb.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
diff --git a/fs/hot_rb.c b/fs/hot_rb.c
new file mode 100644
index 0000000..726d1c5
--- /dev/null
+++ b/fs/hot_rb.c
@@ -0,0 +1,30 @@
+/*
+ * fs/hot_rb.c
+ *
+ * Copyright (C) 2012 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *            Ben Chociej <bchociej@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ */
+
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/hardirq.h>
+#include <linux/blkdev.h>
+#include "hot_rb.h"
+#include "hot_hash.h"
+
+/*
+ * Initialize the inode tree. Should be called for each new inode
+ * access or other user of the hot_inode interface.
+ */
+void hot_rb_inode_tree_init(struct hot_inode_tree *tree)
+{
+	tree->map = RB_ROOT;
+	rwlock_init(&tree->lock);
+}
diff --git a/fs/hot_rb.h b/fs/hot_rb.h
new file mode 100644
index 0000000..895c61c
--- /dev/null
+++ b/fs/hot_rb.h
@@ -0,0 +1,21 @@
+/*
+ * fs/hot_rb.h
+ *
+ * Copyright (C) 2012 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *            Ben Chociej <bchociej@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ */
+
+#ifndef __HOT_MAP__
+#define __HOT_MAP__
+
+#include <linux/rbtree.h>
+#include <linux/hot_track.h>
+
+void hot_rb_inode_tree_init(struct hot_inode_tree *tree);
+
+#endif /* __HOT_MAP__ */
diff --git a/include/linux/hot_track.h b/include/linux/hot_track.h
index 5716b93..fa2aeb6 100644
--- a/include/linux/hot_track.h
+++ b/include/linux/hot_track.h
@@ -20,7 +20,16 @@
 #include <linux/rbtree.h>
 #include <linux/kref.h>
 
+/* A tree that sits on the hot_info */
+struct hot_inode_tree {
+	struct rb_root map;
+	rwlock_t lock;
+};
+
 struct hot_info {
+
+	/* red-black tree that keeps track of fs-wide hot data */
+	struct hot_inode_tree hot_inode_tree;
 };
 
 #endif  /* _LINUX_HOTTRACK_H */
-- 
1.7.6.5

