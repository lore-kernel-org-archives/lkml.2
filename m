Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab2BUT7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:59:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922Ab2BUTx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:57 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 54/73] union-mount: Add generic_readdir_fallthru() helper [ver
 #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:04:14 +0000
Message-ID: <20120221180414.25235.2831.stgit@warthog.procyon.org.uk>
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

In readdir(), client file systems need to lookup the target of a
fallthru in a lower layer for three reasons: (1) fill in d_ino, (2)
fill in d_type, (2) make sure there is something to fall through to
(and if not, don't return this dentry).  Create a generic helper
function.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/union.c         |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/union.h         |   10 ++++++++++
 include/linux/fs.h |   15 +++++++++++++++
 3 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/fs/union.c b/fs/union.c
index 0c0490f..8efed50 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -386,3 +386,56 @@ out_fput:
 	mnt_drop_write(topmost_path->mnt);
 	return error;
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
+ * @topmost_dentry: dentry for the topmost dentry of the dir being read
+ * @name: name of fallthru dirent
+ * @namelen: length of @name
+ * @ino: return inode number of target, if found
+ * @d_type: return directory type of target, if found
+ *
+ * In readdir(), client file systems need to lookup the target of a
+ * fallthru in a lower layer for three reasons: (1) fill in d_ino, (2)
+ * fill in d_type, (2) make sure there is something to fall through to
+ * (and if not, don't return this dentry).  Upon detecting a fallthru
+ * dentry in readdir(), the client file system should call this function.
+ *
+ * Returns 0 on success and -ENOENT if no matching directory entry was
+ * found (which can happen when the topmost file system is unmounted
+ * and remounted over a different file system than).  Any other errors
+ * are unexpected.
+ */
+int generic_readdir_fallthru(struct dentry *topmost_dentry, const char *name,
+			     int namlen, ino_t *ino, unsigned char *d_type)
+{
+	struct path *parent;
+	struct dentry *dentry;
+	unsigned int i, layers = topmost_dentry->d_sb->s_union_count;
+
+	BUG_ON(!mutex_is_locked(&topmost_dentry->d_inode->i_mutex));
+
+	for (i = 0; i < layers; i++) {
+		parent = union_find_dir(topmost_dentry, i);
+		mutex_lock(&parent->dentry->d_inode->i_mutex);
+		dentry = lookup_one_len(name, parent->dentry, namlen);
+		mutex_unlock(&parent->dentry->d_inode->i_mutex);
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
+EXPORT_SYMBOL(generic_readdir_fallthru);
diff --git a/fs/union.h b/fs/union.h
index a77bd5f..46944b9 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -71,6 +71,8 @@ extern int union_add_dir(struct path *, struct path *, unsigned int);
 extern int union_create_topmost_dir(struct path *, struct qstr *, struct path *,
 				    struct path *);
 extern int union_copyup_dir(struct path *);
+extern int generic_readdir_fallthru(struct dentry *topmost_dentry, const char *name,
+				    int namlen, ino_t *ino, unsigned char *d_type);
 
 static inline
 struct path *union_find_dir(struct dentry *dentry, unsigned int layer)
@@ -137,4 +139,12 @@ static inline int union_copyup_dir(struct path *topmost_path)
 	return 0;
 }
 
+static inline
+int generic_readdir_fallthru(struct dentry *topmost_dentry, const char *name,
+			     int namlen, ino_t *ino, unsigned char *d_type)
+{
+	BUG();
+	return 0;
+}
+
 #endif	/* CONFIG_UNION_MOUNT */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e130d00..46b35ea 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2569,6 +2569,21 @@ extern int generic_file_fsync(struct file *, loff_t, loff_t, int);
 
 extern int generic_check_addressable(unsigned, u64);
 
+#ifdef CONFIG_UNION_MOUNT
+extern int generic_readdir_fallthru(struct dentry *topmost_dentry, const char *name,
+				    int namlen, ino_t *ino, unsigned char *d_type);
+#else
+static inline int generic_readdir_fallthru(struct dentry *topmost_dentry, const char *name,
+					   int namlen, ino_t *ino, unsigned char *d_type)
+{
+	/*
+	 * Found a fallthru on a kernel without union support.
+	 * There's nothing to fall through to, so return -ENOENT.
+	 */
+	return -ENOENT;
+}
+#endif
+
 #ifdef CONFIG_MIGRATION
 extern int buffer_migrate_page(struct address_space *,
 				struct page *, struct page *,

