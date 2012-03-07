Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab2CGVXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:23:10 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37696 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab2CGVXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:05 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 06/25] vfs: add i_op->atomic_create()
Date: Wed,  7 Mar 2012 22:22:23 +0100
Message-Id: <1331155362-11132-7-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new inode operation which is called on regular file create.  This is a
replacement for ->create() which allows the file to be opened atomically with
creation.

This function is also called for non-open creates (mknod(2)) with a NULL file
argument.  Only one of ->create or ->atomic_create will be called, implementing
both makes no sense.

The functionality of this method partially overlaps that of ->atomic_open().
FUSE and 9P only use ->atomic_create, NFS, CIFS and CEPH use both.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c         |  118 +++++++++++++++++++++++++++++++++++++++++-----------
 include/linux/fs.h |    4 ++
 2 files changed, 97 insertions(+), 25 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 8dfbe45..200cffe 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1998,27 +1998,6 @@ void unlock_rename(struct dentry *p1, struct dentry *p2)
 	}
 }
 
-int vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-		struct nameidata *nd)
-{
-	int error = may_create(dir, dentry);
-
-	if (error)
-		return error;
-
-	if (!dir->i_op->create)
-		return -EACCES;	/* shouldn't it be ENOSYS? */
-	mode &= S_IALLUGO;
-	mode |= S_IFREG;
-	error = security_inode_create(dir, dentry, mode);
-	if (error)
-		return error;
-	error = dir->i_op->create(dir, dentry, mode, nd);
-	if (!error)
-		fsnotify_create(dir, dentry);
-	return error;
-}
-
 static int may_open(struct path *path, int acc_mode, int flag)
 {
 	struct dentry *dentry = path->dentry;
@@ -2071,6 +2050,87 @@ static int may_open(struct path *path, int acc_mode, int flag)
 	return 0;
 }
 
+static struct file *atomic_create(struct inode *dir, struct dentry *dentry,
+				  struct opendata *od, unsigned open_flag,
+				  umode_t mode)
+{
+	struct file *filp;
+	int error;
+
+	filp = dir->i_op->atomic_create(dir, dentry, od, open_flag, mode);
+	if (IS_ERR(filp))
+		goto out;
+
+	fsnotify_create(dir, dentry);
+
+	if (!filp)
+		goto out;
+
+	/*
+	 * We don't have the inode before the open, so check open permission
+	 * here.
+	 */
+	error = may_open(&filp->f_path, MAY_OPEN, open_flag);
+	if (error)
+		goto out_fput;
+
+	error = open_check_o_direct(filp);
+	if (error)
+		goto out_fput;
+
+out:
+	return filp;
+
+out_fput:
+	fput(filp);
+	return ERR_PTR(error);
+}
+
+static struct file *create_open(struct inode *dir, struct dentry *dentry,
+				struct opendata *od, unsigned open_flag,
+				umode_t mode, struct nameidata *nd)
+{
+	int error = may_create(dir, dentry);
+	if (error)
+		goto out_err;
+
+	error = -EACCES; /* shouldn't it be ENOSYS? */
+	if (!dir->i_op->create && !dir->i_op->atomic_create)
+		goto out_err;
+	mode &= S_IALLUGO;
+	mode |= S_IFREG;
+	error = security_inode_create(dir, dentry, mode);
+	if (error)
+		goto out_err;
+	if (dir->i_op->create) {
+		error = dir->i_op->create(dir, dentry, mode, nd);
+		if (error)
+			goto out_err;
+
+		fsnotify_create(dir, dentry);
+		return NULL;
+	} else {
+		return atomic_create(dir, dentry, od, open_flag, mode);
+	}
+
+out_err:
+	return ERR_PTR(error);
+}
+
+int vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
+	       struct nameidata *nd)
+{
+	struct file *res;
+	unsigned open_flag = O_RDONLY|O_CREAT|O_EXCL;
+
+	res = create_open(dir, dentry, NULL, open_flag, mode, NULL);
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+
+	BUG_ON(res != NULL);
+	return 0;
+}
+
 static int handle_truncate(struct file *filp)
 {
 	struct path *path = &filp->f_path;
@@ -2317,7 +2377,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 {
 	struct dentry *dir = nd->path.dentry;
 	struct dentry *dentry;
-	int open_flag = op->open_flag;
+	int open_flag = open_to_namei_flags(op->open_flag);
 	int will_truncate = open_flag & O_TRUNC;
 	int want_write = 0;
 	int acc_mode = op->acc_mode;
@@ -2402,6 +2462,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 
 	/* Negative dentry, create the file if O_CREAT */
 	if (!dentry->d_inode) {
+		struct opendata od;
 		umode_t mode = op->mode;
 
 		error = -ENOENT;
@@ -2430,12 +2491,19 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		error = security_path_mknod(&nd->path, dentry, mode, 0);
 		if (error)
 			goto exit_mutex_unlock;
-		error = vfs_create(dir->d_inode, dentry, mode, nd);
-		if (error)
-			goto exit_mutex_unlock;
+		od.mnt = nd->path.mnt;
+		od.filp = &nd->intent.open.file;
+		filp = create_open(dir->d_inode, dentry, &od, open_flag, mode,
+				   nd);
 		mutex_unlock(&dir->d_inode->i_mutex);
 		dput(nd->path.dentry);
 		nd->path.dentry = dentry;
+		if (filp) {
+			if (IS_ERR(filp))
+				goto out;
+
+			goto opened;
+		}
 		goto common;
 	}
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6615355..af291bb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1659,6 +1659,10 @@ struct inode_operations {
 	struct file * (*atomic_open)(struct inode *, struct dentry *,
 				     struct opendata *, unsigned open_flag,
 				     umode_t create_mode, bool *created);
+	struct file * (*atomic_create)(struct inode *, struct dentry *,
+				       struct opendata *, unsigned open_flag,
+				       umode_t create_mode);
+
 } ____cacheline_aligned;
 
 struct seq_file;
-- 
1.7.7

