Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761596Ab2FENK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:10:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48161 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899Ab2FENKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:10:21 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz
Subject: [PATCH 04/21] vfs: add lookup_open()
Date: Tue,  5 Jun 2012 15:10:15 +0200
Message-Id: <1338901832-14049-5-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Split out lookup + maybe create from do_last().  This is the part under i_mutex
protection.

The function is called lookup_open() and returns a filp even though the open
part is not used yet.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   99 +++++++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 61 insertions(+), 38 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 0a56b61..1153476 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2188,19 +2188,73 @@ static inline int open_to_namei_flags(int flag)
 }
 
 /*
+ * Lookup, maybe create and open the last component
+ *
+ * Must be called with i_mutex held on parent.
+ *
+ * Returns open file or NULL on success, error otherwise.  NULL means no open
+ * was performed, only lookup.
+ */
+static struct file *lookup_open(struct nameidata *nd, struct path *path,
+				const struct open_flags *op,
+				int *want_write, bool *created)
+{
+	struct dentry *dir = nd->path.dentry;
+	struct dentry *dentry;
+	int error;
+
+	*created = false;
+	dentry = lookup_hash(nd);
+	if (IS_ERR(dentry))
+		return ERR_CAST(dentry);
+
+	/* Negative dentry, just create the file */
+	if (!dentry->d_inode && (op->open_flag & O_CREAT)) {
+		umode_t mode = op->mode;
+		if (!IS_POSIXACL(dir->d_inode))
+			mode &= ~current_umask();
+		/*
+		 * This write is needed to ensure that a
+		 * rw->ro transition does not occur between
+		 * the time when the file is created and when
+		 * a permanent write count is taken through
+		 * the 'struct file' in nameidata_to_filp().
+		 */
+		error = mnt_want_write(nd->path.mnt);
+		if (error)
+			goto out_dput;
+		*want_write = 1;
+		*created = true;
+		error = security_path_mknod(&nd->path, dentry, mode, 0);
+		if (error)
+			goto out_dput;
+		error = vfs_create(dir->d_inode, dentry, mode, nd);
+		if (error)
+			goto out_dput;
+	}
+	path->dentry = dentry;
+	path->mnt = nd->path.mnt;
+	return NULL;
+
+out_dput:
+	dput(dentry);
+	return ERR_PTR(error);
+}
+
+/*
  * Handle the last step of open()
  */
 static struct file *do_last(struct nameidata *nd, struct path *path,
 			    const struct open_flags *op, const char *pathname)
 {
 	struct dentry *dir = nd->path.dentry;
-	struct dentry *dentry;
 	int open_flag = op->open_flag;
 	int will_truncate = open_flag & O_TRUNC;
 	int want_write = 0;
 	int acc_mode = op->acc_mode;
 	struct file *filp;
 	struct inode *inode;
+	bool created;
 	int symlink_ok = 0;
 	struct path save_parent = { .dentry = NULL, .mnt = NULL };
 	bool retried = false;
@@ -2268,53 +2322,24 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 
 retry_lookup:
 	mutex_lock(&dir->d_inode->i_mutex);
+	filp = lookup_open(nd, path, op, &want_write, &created);
+	mutex_unlock(&dir->d_inode->i_mutex);
 
-	dentry = lookup_hash(nd);
-	error = PTR_ERR(dentry);
-	if (IS_ERR(dentry)) {
-		mutex_unlock(&dir->d_inode->i_mutex);
-		goto exit;
-	}
-
-	path->dentry = dentry;
-	path->mnt = nd->path.mnt;
+	if (IS_ERR(filp))
+		goto out;
 
-	/* Negative dentry, just create the file */
-	if (!dentry->d_inode && (open_flag & O_CREAT)) {
-		umode_t mode = op->mode;
-		if (!IS_POSIXACL(dir->d_inode))
-			mode &= ~current_umask();
-		/*
-		 * This write is needed to ensure that a
-		 * rw->ro transition does not occur between
-		 * the time when the file is created and when
-		 * a permanent write count is taken through
-		 * the 'struct file' in nameidata_to_filp().
-		 */
-		error = mnt_want_write(nd->path.mnt);
-		if (error)
-			goto exit_mutex_unlock;
-		want_write = 1;
+	if (created) {
 		/* Don't check for write permission, don't truncate */
 		open_flag &= ~O_TRUNC;
 		will_truncate = 0;
 		acc_mode = MAY_OPEN;
-		error = security_path_mknod(&nd->path, dentry, mode, 0);
-		if (error)
-			goto exit_mutex_unlock;
-		error = vfs_create(dir->d_inode, dentry, mode, nd);
-		if (error)
-			goto exit_mutex_unlock;
-		mutex_unlock(&dir->d_inode->i_mutex);
-		dput(nd->path.dentry);
-		nd->path.dentry = dentry;
+		path_to_nameidata(path, nd);
 		goto common;
 	}
 
 	/*
 	 * It already exists.
 	 */
-	mutex_unlock(&dir->d_inode->i_mutex);
 	audit_inode(pathname, path->dentry);
 
 	error = -EEXIST;
@@ -2423,8 +2448,6 @@ out:
 	terminate_walk(nd);
 	return filp;
 
-exit_mutex_unlock:
-	mutex_unlock(&dir->d_inode->i_mutex);
 exit_dput:
 	path_put_conditional(path, nd);
 exit:
-- 
1.7.7

