Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab0IPWVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:21:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756406Ab0IPWOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:30 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 14/34] union-mount: Create union_add_dir()
Date: Thu, 16 Sep 2010 15:12:05 -0700
Message-Id: <1284675145-4391-15-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

union_add_dir() fills out the union stack for the topmost dentry with
the path of the directory in this layer of the union.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/union.c |   28 ++++++++++++++++++++++++++++
 fs/union.h |    2 ++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/fs/union.c b/fs/union.c
index a191bef..45552f8 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -65,3 +65,31 @@ void d_free_unions(struct dentry *topmost)
 	kfree(topmost->d_union_stack);
 	topmost->d_union_stack = NULL;
 }
+
+/**
+ * union_add_dir - Add another layer to a unioned directory
+ *
+ * @topmost - topmost directory
+ * @lower - directory in the current layer
+ * @layer - index of layer to add this at
+ *
+ * @layer counts starting at 0 for the dir below the topmost dir.
+ * Must take a reference to @lower (call path_get()) before calling
+ * this function.
+ */
+
+int union_add_dir(struct path *topmost, struct path *lower,
+		  unsigned int layer)
+{
+	struct path *path;
+	struct dentry *dentry = topmost->dentry;
+	BUG_ON(layer >= dentry->d_sb->s_union_count);
+
+	if (!dentry->d_union_stack)
+		dentry->d_union_stack = union_alloc(topmost);
+	if (!dentry->d_union_stack)
+		return -ENOMEM;
+	path = union_find_dir(dentry, layer);
+	*path = *lower;
+	return 0;
+}
diff --git a/fs/union.h b/fs/union.h
index 353f78d..bd03d67 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -52,6 +52,7 @@ struct union_stack {
 #define IS_DIR_UNIONED(dentry)	((dentry)->d_union_stack)
 
 extern void d_free_unions(struct dentry *);
+extern int union_add_dir(struct path *, struct path *, unsigned int);
 
 static inline struct path *union_find_dir(struct dentry *dentry,
 					  unsigned int layer) {
@@ -64,6 +65,7 @@ static inline struct path *union_find_dir(struct dentry *dentry,
 #define IS_DIR_UNIONED(x)		(0)
 
 #define d_free_unions(x)		do { } while (0)
+#define union_add_dir(x, y, z)		({ BUG(); (0); })
 #define union_find_dir(x, y)		({ BUG(); (NULL); })
 
 #endif	/* CONFIG_UNION_MOUNT */
-- 
1.6.3.3

