Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab0HHPzU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 11:55:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758Ab0HHPzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 11:55:14 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 22/39] union-mount: Add generic_readdir_fallthru() helper
Date: Sun,  8 Aug 2010 11:52:39 -0400
Message-Id: <1281282776-5447-23-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In readdir(), client file systems need to lookup the target of a
fallthru in a lower layer for three reasons: (1) fill in d_ino, (2)
fill in d_type, (2) make sure there is something to fall through to
(and if not, don't return this dentry).  Create a generic helper
function.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/union.c         |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    2 +
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/fs/union.c b/fs/union.c
index 917248d..a91e8fc 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -373,3 +373,57 @@ out_fput:
 	mnt_drop_write(topmost_path->mnt);
 	return res;
 }
+
+/* Relationship between i_mode and the DT_xxx types */
+static inline unsigned char dt_type(struct inode *inode)
+{
+	return (inode->i_mode >> 12) & 15;
+}
+
+/**
+ * generic_readdir_fallthru - Helper to lookup target of a fallthru
+ *
+ * In readdir(), client file systems need to lookup the target of a
+ * fallthru in a lower layer for three reasons: (1) fill in d_ino, (2)
+ * fill in d_type, (2) make sure there is something to fall through to
+ * (and if not, don't return this dentry).  Upon detecting a fallthru
+ * dentry in readdir(), the client file system should call this function.
+ *
+ * @topmost_dentry: dentry for the topmost dentry of the dir being read
+ * @name: name of fallthru dirent
+ * @namelen: length of @name
+ * @ino: return inode number of target, if found
+ * @d_type: return directory type of target, if found
+ *
+ * Returns 0 on success and -ENOENT if no matching directory entry was
+ * found (which happens when a file system will fallthrus is mounted
+ * somewhere other than where the fallthrus were created).  Any other
+ * errors are unexpected.
+ */
+
+int
+generic_readdir_fallthru(struct dentry *topmost_dentry, const char *name,
+			 int namlen, ino_t *ino, unsigned char *d_type)
+{
+	struct dentry *dentry, *parent;
+	struct union_dir *ud = topmost_dentry->d_union_dir;
+
+	BUG_ON(!mutex_is_locked(&topmost_dentry->d_inode->i_mutex));
+
+	for (ud = topmost_dentry->d_union_dir; ud != NULL; ud = ud->u_lower) {
+		parent = ud->u_this.dentry;
+		mutex_lock(&parent->d_inode->i_mutex);
+		dentry = lookup_one_len(name, parent, namlen);
+		mutex_unlock(&parent->d_inode->i_mutex);
+		if (IS_ERR(dentry))
+			return PTR_ERR(dentry);
+		if (dentry->d_inode) {
+			*ino = dentry->d_inode->i_ino;
+			*d_type = dt_type(dentry->d_inode);
+			dput(dentry);
+			return 0;
+		}
+		dput(dentry);
+	}
+	return -ENOENT;
+}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b88d088..3675501 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2140,6 +2140,8 @@ extern int notify_change(struct dentry *, struct iattr *);
 extern int inode_permission(struct inode *, int);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
+extern int generic_readdir_fallthru(struct dentry *topmost_dentry, const char *name,
+				    int namlen, ino_t *ino, unsigned char *d_type);
 
 static inline bool execute_ok(struct inode *inode)
 {
-- 
1.6.3.3

