Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2BUSKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:10:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab2BUSHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:07:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 25/73] union-mount: Create d_free_unions() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:00:41 +0000
Message-ID: <20120221180040.25235.53816.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

d_free_unions() frees the union stack associated with a directory.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/union.c |   24 ++++++++++++++++++++++++
 fs/union.h |   10 ++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/fs/union.c b/fs/union.c
index c8d7766..77d6a74 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -19,6 +19,7 @@
 #include <linux/mount.h>
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
+#include <linux/namei.h>
 
 #include "union.h"
 
@@ -36,3 +37,26 @@ static struct union_stack *union_alloc(struct path *topmost)
 
 	return kcalloc(sizeof(struct path), layers, GFP_KERNEL);
 }
+
+/**
+ * d_free_unions - free all unions for this dentry
+ * @dentry: topmost dentry in the union stack to remove
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
index f90d037..04a02ec 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -51,6 +51,13 @@ struct union_stack {
 	struct path u_dirs[0];
 };
 
+static inline bool IS_DIR_UNIONED(struct dentry *dentry)
+{
+	return !!dentry->d_union_stack;
+}
+
+extern void d_free_unions(struct dentry *);
+
 static inline
 struct path *union_find_dir(struct dentry *dentry, unsigned int layer)
 {
@@ -67,4 +74,7 @@ struct path *union_find_dir(struct dentry *dentry, unsigned int layer)
 	return NULL;
 }
 
+static inline bool IS_DIR_UNIONED(struct dentry *dentry) { return false; }
+static inline void d_free_unions(struct dentry *dentry) {}
+
 #endif	/* CONFIG_UNION_MOUNT */

