Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab0IPWOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:14:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404Ab0IPWOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:32 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 15/34] union-mount: Add union_create_topmost_dir()
Date: Thu, 16 Sep 2010 15:12:06 -0700
Message-Id: <1284675145-4391-16-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Union mounts design requires that the topmost directory exist for
every single directory at the time lookup completes.  This is so that
we don't have to double back and create a whole path's worth of
directories whenever we copy up a file in a directory for the first
time.  This greatly simplifies locking and error handling.

XXX - attributes of copied-up dir are wrong

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/union.c |   34 ++++++++++++++++++++++++++++++++++
 fs/union.h |    3 +++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/fs/union.c b/fs/union.c
index 45552f8..bc53066 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -93,3 +93,37 @@ int union_add_dir(struct path *topmost, struct path *lower,
 	*path = *lower;
 	return 0;
 }
+
+/**
+ * union_create_topmost_dir - Create a matching dir in the topmost file system
+ *
+ * @parent - parent of target on topmost layer
+ * @name - name of target
+ * @topmost - path of target on topmost layer
+ * @lower - path of source on lower layer
+ *
+ * As we lookup each directory on the lower layer of a union, we
+ * create a matching directory on the topmost layer if it does not
+ * already exist.
+ *
+ * XXX - owner is wrong, set credentials properly
+ */
+
+int union_create_topmost_dir(struct path *parent, struct qstr *name,
+			     struct path *topmost, struct path *lower)
+{
+	int mode = lower->dentry->d_inode->i_mode;
+	int res;
+
+	BUG_ON(topmost->dentry->d_inode);
+
+	res = mnt_want_write(parent->mnt);
+	if (res)
+		return res;
+
+	res = vfs_mkdir(parent->dentry->d_inode, topmost->dentry, mode);
+
+	mnt_drop_write(parent->mnt);
+
+	return res;
+}
diff --git a/fs/union.h b/fs/union.h
index bd03d67..1692803 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -53,6 +53,8 @@ struct union_stack {
 
 extern void d_free_unions(struct dentry *);
 extern int union_add_dir(struct path *, struct path *, unsigned int);
+extern int union_create_topmost_dir(struct path *, struct qstr *, struct path *,
+				    struct path *);
 
 static inline struct path *union_find_dir(struct dentry *dentry,
 					  unsigned int layer) {
@@ -67,6 +69,7 @@ static inline struct path *union_find_dir(struct dentry *dentry,
 #define d_free_unions(x)		do { } while (0)
 #define union_add_dir(x, y, z)		({ BUG(); (0); })
 #define union_find_dir(x, y)		({ BUG(); (NULL); })
+#define union_create_topmost_dir(w, x, y, z)	({ BUG(); (0); })
 
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */
-- 
1.6.3.3

