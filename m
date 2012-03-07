Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030267Ab2CGV0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:26:25 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65496 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab2CGVXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:24 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 16/25] 9p: implement i_op->atomic_create()
Date: Wed,  7 Mar 2012 22:22:33 +0100
Message-Id: <1331155362-11132-17-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Replace 9p's ->create implementations with ->atomic_create implementations.  No
functionality is changed.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/9p/vfs_inode.c      |   28 ++++++++++++----------------
 fs/9p/vfs_inode_dotl.c |   36 ++++++++++++++++++------------------
 2 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 014c8dd..3d526a7 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -716,18 +716,16 @@ error:
  * @dir: directory inode that is being created
  * @dentry:  dentry that is being deleted
  * @mode: create permissions
- * @nd: path information
  *
  */
 
-static int
-v9fs_vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-		struct nameidata *nd)
+static struct file *
+v9fs_vfs_create(struct inode *dir, struct dentry *dentry, struct opendata *od,
+		unsigned flags, umode_t mode)
 {
 	int err;
 	u32 perm;
-	int flags;
-	struct file *filp;
+	struct file *filp = NULL;
 	struct v9fs_inode *v9inode;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid, *inode_fid;
@@ -736,10 +734,8 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	fid = NULL;
 	v9ses = v9fs_inode2v9ses(dir);
 	perm = unixmode2p9mode(v9ses, mode);
-	if (nd)
-		flags = nd->intent.open.flags;
-	else
-		flags = O_RDWR;
+	if (!od)
+		flags = O_RDWR; /* Why not O_RDONLY|O_CREAT|O_EXCL? */
 
 	fid = v9fs_create(v9ses, dir, dentry, NULL, perm,
 				v9fs_uflags2omode(flags,
@@ -752,7 +748,7 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 
 	v9fs_invalidate_inode_attr(dir);
 	/* if we are opening a file, assign the open fid to the file */
-	if (nd) {
+	if (od) {
 		v9inode = V9FS_I(dentry->d_inode);
 		mutex_lock(&v9inode->v_mutex);
 		if (v9ses->cache && !v9inode->writeback_fid &&
@@ -773,7 +769,7 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 			v9inode->writeback_fid = (void *) inode_fid;
 		}
 		mutex_unlock(&v9inode->v_mutex);
-		filp = lookup_instantiate_filp(nd, dentry, generic_file_open);
+		filp = finish_open(od, dentry, generic_file_open);
 		if (IS_ERR(filp)) {
 			err = PTR_ERR(filp);
 			goto error;
@@ -787,13 +783,13 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	} else
 		p9_client_clunk(fid);
 
-	return 0;
+	return filp;
 
 error:
 	if (fid)
 		p9_client_clunk(fid);
 
-	return err;
+	return ERR_PTR(err);
 }
 
 /**
@@ -1486,7 +1482,7 @@ out:
 }
 
 static const struct inode_operations v9fs_dir_inode_operations_dotu = {
-	.create = v9fs_vfs_create,
+	.atomic_create = v9fs_vfs_create,
 	.lookup = v9fs_vfs_lookup,
 	.symlink = v9fs_vfs_symlink,
 	.link = v9fs_vfs_link,
@@ -1500,7 +1496,7 @@ static const struct inode_operations v9fs_dir_inode_operations_dotu = {
 };
 
 static const struct inode_operations v9fs_dir_inode_operations = {
-	.create = v9fs_vfs_create,
+	.atomic_create = v9fs_vfs_create,
 	.lookup = v9fs_vfs_lookup,
 	.unlink = v9fs_vfs_unlink,
 	.mkdir = v9fs_vfs_mkdir,
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index a1e6c99..6e37911 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -248,17 +248,15 @@ int v9fs_open_to_dotl_flags(int flags)
  * @dir: directory inode that is being created
  * @dentry:  dentry that is being deleted
  * @mode: create permissions
- * @nd: path information
  *
  */
 
-static int
-v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
-		struct nameidata *nd)
+static struct file *
+v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry,
+		     struct opendata *od, unsigned flags,  umode_t omode)
 {
 	int err = 0;
 	gid_t gid;
-	int flags;
 	umode_t mode;
 	char *name = NULL;
 	struct file *filp;
@@ -271,15 +269,16 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
 	struct posix_acl *pacl = NULL, *dacl = NULL;
 
 	v9ses = v9fs_inode2v9ses(dir);
-	if (nd)
-		flags = nd->intent.open.flags;
-	else {
+	if (!od) {
 		/*
-		 * create call without LOOKUP_OPEN is due
-		 * to mknod of regular files. So use mknod
-		 * operation.
+		 * create call without filp is due to mknod of regular files.
+		 * So use mknod operation.
 		 */
-		return v9fs_vfs_mknod_dotl(dir, dentry, omode, 0);
+		err = v9fs_vfs_mknod_dotl(dir, dentry, omode, 0);
+		if (err)
+			goto err_return;
+
+		return NULL;
 	}
 
 	name = (char *) dentry->d_name.name;
@@ -290,7 +289,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
 	if (IS_ERR(dfid)) {
 		err = PTR_ERR(dfid);
 		p9_debug(P9_DEBUG_VFS, "fid lookup failed %d\n", err);
-		return err;
+		goto err_return;
 	}
 
 	/* clone a fid to use for creation */
@@ -298,7 +297,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
 	if (IS_ERR(ofid)) {
 		err = PTR_ERR(ofid);
 		p9_debug(P9_DEBUG_VFS, "p9_client_walk failed %d\n", err);
-		return err;
+		goto err_return;
 	}
 
 	gid = v9fs_get_fsgid_for_create(dir);
@@ -363,7 +362,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
 	}
 	mutex_unlock(&v9inode->v_mutex);
 	/* Since we are opening a file, assign the open fid to the file */
-	filp = lookup_instantiate_filp(nd, dentry, generic_file_open);
+	filp = finish_open(od, dentry, generic_file_open);
 	if (IS_ERR(filp)) {
 		err = PTR_ERR(filp);
 		goto err_clunk_old_fid;
@@ -373,7 +372,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
 	if (v9ses->cache)
 		v9fs_cache_inode_set_cookie(inode, filp);
 #endif
-	return 0;
+	return filp;
 
 error:
 	if (fid)
@@ -382,7 +381,8 @@ err_clunk_old_fid:
 	if (ofid)
 		p9_client_clunk(ofid);
 	v9fs_set_create_acl(NULL, &dacl, &pacl);
-	return err;
+err_return:
+	return ERR_PTR(err);
 }
 
 /**
@@ -999,7 +999,7 @@ out:
 }
 
 const struct inode_operations v9fs_dir_inode_operations_dotl = {
-	.create = v9fs_vfs_create_dotl,
+	.atomic_create = v9fs_vfs_create_dotl,
 	.lookup = v9fs_vfs_lookup,
 	.link = v9fs_vfs_link_dotl,
 	.symlink = v9fs_vfs_symlink_dotl,
-- 
1.7.7

