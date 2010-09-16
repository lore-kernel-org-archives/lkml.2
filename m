Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab0IPWVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:21:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004Ab0IPWOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:25 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 12/34] union-mount: Create d_free_unions()
Date: Thu, 16 Sep 2010 15:12:03 -0700
Message-Id: <1284675145-4391-13-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d_free_unions() frees the union stack associated with a directory.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/union.c |   25 +++++++++++++++++++++++++
 fs/union.h |    7 +++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/fs/union.c b/fs/union.c
index 52a5c28..a191bef 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -21,6 +21,7 @@
 #include <linux/mount.h>
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
+#include <linux/namei.h>
 
 #include "union.h"
 
@@ -40,3 +41,27 @@ static struct union_stack *union_alloc(struct path *topmost)
 
 	return kzalloc(sizeof(struct path) * layers, GFP_KERNEL);
 }
+
+/**
+ * d_free_unions - free all unions for this dentry
+ *
+ * @dentry - topmost dentry in the union stack to remove
+ *
+ * This must be called when freeing a dentry.
+ */
+void d_free_unions(struct dentry *topmost)
+{
+	struct path *path;
+	unsigned int i, layers = topmost->d_sb->s_union_count;
+
+	if (!IS_DIR_UNIONED(topmost))
+		return;
+
+	for (i = 0; i < layers; i++) {
+		path = union_find_dir(topmost, i);
+		if (path->mnt)
+			path_put(path);
+	}
+	kfree(topmost->d_union_stack);
+	topmost->d_union_stack = NULL;
+}
diff --git a/fs/union.h b/fs/union.h
index e242451..353f78d 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -49,6 +49,10 @@ struct union_stack {
 	struct path u_dirs[0];
 };
 
+#define IS_DIR_UNIONED(dentry)	((dentry)->d_union_stack)
+
+extern void d_free_unions(struct dentry *);
+
 static inline struct path *union_find_dir(struct dentry *dentry,
 					  unsigned int layer) {
 	BUG_ON(layer >= dentry->d_sb->s_union_count);
@@ -57,6 +61,9 @@ static inline struct path *union_find_dir(struct dentry *dentry,
 
 #else /* CONFIG_UNION_MOUNT */
 
+#define IS_DIR_UNIONED(x)		(0)
+
+#define d_free_unions(x)		do { } while (0)
 #define union_find_dir(x, y)		({ BUG(); (NULL); })
 
 #endif	/* CONFIG_UNION_MOUNT */
-- 
1.6.3.3

