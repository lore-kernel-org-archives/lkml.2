Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab2BUSTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:19:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089Ab2BUSRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:17:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 27/73] union-mount: Create union_add_dir() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:00:55 +0000
Message-ID: <20120221180055.25235.61001.stgit@warthog.procyon.org.uk>
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

union_add_dir() fills out the union stack for the topmost dentry with
the path of the directory in this layer of the union.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/union.c |   28 ++++++++++++++++++++++++++++
 fs/union.h |    8 ++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/fs/union.c b/fs/union.c
index 77d6a74..1e459b0 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -60,3 +60,31 @@ void d_free_unions(struct dentry *topmost)
 	kfree(topmost->d_union_stack);
 	topmost->d_union_stack = NULL;
 }
+
+/**
+ * union_add_dir - Add another layer to a unioned directory
+ * @topmost: topmost directory
+ * @lower: directory in the current layer
+ * @layer: index of layer to add this at
+ *
+ * @layer counts starting at 0 for the dir below the topmost dir.
+ *
+ * This transfers the caller's references to the constituents of *lower to the
+ * union stack.
+ */
+int union_add_dir(struct path *topmost, struct path *lower, unsigned layer)
+{
+	struct dentry *dentry = topmost->dentry;
+	struct path *path;
+
+	BUG_ON(layer >= dentry->d_sb->s_union_count);
+
+	if (!dentry->d_union_stack)
+		dentry->d_union_stack = union_alloc(topmost);
+	if (!dentry->d_union_stack)
+		return -ENOMEM;
+
+	path = union_find_dir(dentry, layer);
+	*path = *lower;
+	return 0;
+}
diff --git a/fs/union.h b/fs/union.h
index 04a02ec..f39c88d 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -57,6 +57,7 @@ static inline bool IS_DIR_UNIONED(struct dentry *dentry)
 }
 
 extern void d_free_unions(struct dentry *);
+extern int union_add_dir(struct path *, struct path *, unsigned int);
 
 static inline
 struct path *union_find_dir(struct dentry *dentry, unsigned int layer)
@@ -77,4 +78,11 @@ struct path *union_find_dir(struct dentry *dentry, unsigned int layer)
 static inline bool IS_DIR_UNIONED(struct dentry *dentry) { return false; }
 static inline void d_free_unions(struct dentry *dentry) {}
 
+static inline
+int union_add_dir(struct path *topmost, struct path *lower, unsigned layer)
+{
+	BUG();
+	return 0;
+}
+
 #endif	/* CONFIG_UNION_MOUNT */

