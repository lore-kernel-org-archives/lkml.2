Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab0IPWOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:14:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473Ab0IPWOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:36 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 17/34] union-mount: Create needs_lookup_union()
Date: Thu, 16 Sep 2010 15:12:08 -0700
Message-Id: <1284675145-4391-18-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

needs_lookup_union() tests if a path could possibly require a union
lookup.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/union.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/union.h |    2 ++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/fs/union.c b/fs/union.c
index bc53066..a9427bf 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -127,3 +127,52 @@ int union_create_topmost_dir(struct path *parent, struct qstr *name,
 
 	return res;
 }
+
+/**
+ * needs_lookup_union - Avoid union lookup when not necessary
+ *
+ * @parent_path: path of the parent directory
+ * @path: path of the lookup target
+ *
+ * Check to see if the target needs union lookup - that is, needs its
+ * union stack constructed.  Two cases need union lookup in a unioned
+ * parent directory: the target is a directory without a union stack,
+ * or the target is a negative dentry.
+ *
+ * Returns 0 if this dentry does not need union lookup.  Returns 1 if
+ * it is possible this dentry needs union lookup.
+ */
+
+int needs_lookup_union(struct path *parent_path, struct path *path)
+{
+	if (!IS_DIR_UNIONED(parent_path->dentry))
+		return 0;
+
+	/* Root dir union stack created at mount (if this is a unioned mnt) */
+	if (IS_ROOT(path->dentry))
+		return 0;
+
+	/* Union stack for target already created, clearly */
+	if (IS_DIR_UNIONED(path->dentry))
+		return 0;
+
+	if (d_is_whiteout(path->dentry))
+		return 0;
+
+	if (IS_OPAQUE(parent_path->dentry->d_inode) &&
+	    !d_is_fallthru(path->dentry))
+		return 0;
+
+	/* Non-directories don't need union stacks */
+	if (path->dentry->d_inode &&
+	    !S_ISDIR(path->dentry->d_inode->i_mode))
+		return 0;
+
+	/*
+	 * XXX Things with nothing below them in a union dir
+	 * (including negative dentries) must always go through union
+	 * lookup.  This is like negative dentries in the dcache.
+	 * Write some optimization for this case.
+	 */
+	return 1;
+}
diff --git a/fs/union.h b/fs/union.h
index c496823..0c8fbca 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -56,6 +56,7 @@ extern void d_free_unions(struct dentry *);
 extern int union_add_dir(struct path *, struct path *, unsigned int);
 extern int union_create_topmost_dir(struct path *, struct qstr *, struct path *,
 				    struct path *);
+extern int needs_lookup_union(struct path *, struct path *);
 
 static inline struct path *union_find_dir(struct dentry *dentry,
 					  unsigned int layer) {
@@ -72,6 +73,7 @@ static inline struct path *union_find_dir(struct dentry *dentry,
 #define union_add_dir(x, y, z)		({ BUG(); (0); })
 #define union_find_dir(x, y)		({ BUG(); (NULL); })
 #define union_create_topmost_dir(w, x, y, z)	({ BUG(); (0); })
+#define needs_lookup_union(x, y)	({ (0); })
 
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */
-- 
1.6.3.3

