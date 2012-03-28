Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013Ab2C1U07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:26:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46332 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab2C1UYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:24:51 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 14/16] 9p: implement i_op->atomic_create()
Date: Wed, 28 Mar 2012 22:24:43 +0200
Message-Id: <1332966285-30358-15-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332966285-30358-1-git-send-email-miklos@szeredi.hu>
References: <1332966285-30358-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Replace 9p's ->create implementations with ->atomic_create implementations.  No
functionality is changed.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/9p/vfs_inode.c      |  169 +++++++++++++++++++++++++++++-------------------
 fs/9p/vfs_inode_dotl.c |   52 ++++++++++-----
 2 files changed, 137 insertions(+), 84 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 014c8dd..203892d 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -712,11 +712,14 @@ error:
 }
 
 /**
- * v9fs_vfs_create - VFS hook to create files
+ * v9fs_vfs_create - VFS hook to create a regular file
+ *
+ * open(.., O_CREAT) is handled in v9fs_vfs_atomic_open().  This is only called
+ * for mknod(2).
+ *
  * @dir: directory inode that is being created
  * @dentry:  dentry that is being deleted
  * @mode: create permissions
- * @nd: path information
  *
  */
 
@@ -724,76 +727,19 @@ static int
 v9fs_vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 		struct nameidata *nd)
 {
-	int err;
-	u32 perm;
-	int flags;
-	struct file *filp;
-	struct v9fs_inode *v9inode;
-	struct v9fs_session_info *v9ses;
-	struct p9_fid *fid, *inode_fid;
-
-	err = 0;
-	fid = NULL;
-	v9ses = v9fs_inode2v9ses(dir);
-	perm = unixmode2p9mode(v9ses, mode);
-	if (nd)
-		flags = nd->intent.open.flags;
-	else
-		flags = O_RDWR;
+	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dir);
+	u32 perm = unixmode2p9mode(v9ses, mode);
+	struct p9_fid *fid;
 
-	fid = v9fs_create(v9ses, dir, dentry, NULL, perm,
-				v9fs_uflags2omode(flags,
-						v9fs_proto_dotu(v9ses)));
-	if (IS_ERR(fid)) {
-		err = PTR_ERR(fid);
-		fid = NULL;
-		goto error;
-	}
+	/* P9_OEXCL? */
+	fid = v9fs_create(v9ses, dir, dentry, NULL, perm, P9_ORDWR);
+	if (IS_ERR(fid))
+		return PTR_ERR(fid);
 
 	v9fs_invalidate_inode_attr(dir);
-	/* if we are opening a file, assign the open fid to the file */
-	if (nd) {
-		v9inode = V9FS_I(dentry->d_inode);
-		mutex_lock(&v9inode->v_mutex);
-		if (v9ses->cache && !v9inode->writeback_fid &&
-		    ((flags & O_ACCMODE) != O_RDONLY)) {
-			/*
-			 * clone a fid and add it to writeback_fid
-			 * we do it during open time instead of
-			 * page dirty time via write_begin/page_mkwrite
-			 * because we want write after unlink usecase
-			 * to work.
-			 */
-			inode_fid = v9fs_writeback_fid(dentry);
-			if (IS_ERR(inode_fid)) {
-				err = PTR_ERR(inode_fid);
-				mutex_unlock(&v9inode->v_mutex);
-				goto error;
-			}
-			v9inode->writeback_fid = (void *) inode_fid;
-		}
-		mutex_unlock(&v9inode->v_mutex);
-		filp = lookup_instantiate_filp(nd, dentry, generic_file_open);
-		if (IS_ERR(filp)) {
-			err = PTR_ERR(filp);
-			goto error;
-		}
-
-		filp->private_data = fid;
-#ifdef CONFIG_9P_FSCACHE
-		if (v9ses->cache)
-			v9fs_cache_inode_set_cookie(dentry->d_inode, filp);
-#endif
-	} else
-		p9_client_clunk(fid);
+	p9_client_clunk(fid);
 
 	return 0;
-
-error:
-	if (fid)
-		p9_client_clunk(fid);
-
-	return err;
 }
 
 /**
@@ -910,6 +856,93 @@ error:
 	return ERR_PTR(result);
 }
 
+static struct file *
+v9fs_vfs_atomic_open(struct inode *dir, struct dentry *dentry,
+		     struct opendata *od, unsigned flags, umode_t mode,
+		     bool *created)
+{
+	int err;
+	u32 perm;
+	struct file *filp;
+	struct v9fs_inode *v9inode;
+	struct v9fs_session_info *v9ses;
+	struct p9_fid *fid, *inode_fid;
+	struct dentry *res = NULL;
+
+	if (d_unhashed(dentry)) {
+		res = v9fs_vfs_lookup(dir, dentry, NULL);
+		if (IS_ERR(res))
+			return ERR_CAST(res);
+
+		if (res)
+			dentry = res;
+	}
+
+	/* Only creates */
+	if (!(flags & O_CREAT) || dentry->d_inode) {
+		finish_no_open(od, res);
+		return NULL;
+	}
+
+	err = 0;
+	fid = NULL;
+	v9ses = v9fs_inode2v9ses(dir);
+	perm = unixmode2p9mode(v9ses, mode);
+	fid = v9fs_create(v9ses, dir, dentry, NULL, perm,
+				v9fs_uflags2omode(flags,
+						v9fs_proto_dotu(v9ses)));
+	if (IS_ERR(fid)) {
+		err = PTR_ERR(fid);
+		fid = NULL;
+		goto error;
+	}
+
+	v9fs_invalidate_inode_attr(dir);
+	v9inode = V9FS_I(dentry->d_inode);
+	mutex_lock(&v9inode->v_mutex);
+	if (v9ses->cache && !v9inode->writeback_fid &&
+	    ((flags & O_ACCMODE) != O_RDONLY)) {
+		/*
+		 * clone a fid and add it to writeback_fid
+		 * we do it during open time instead of
+		 * page dirty time via write_begin/page_mkwrite
+		 * because we want write after unlink usecase
+		 * to work.
+		 */
+		inode_fid = v9fs_writeback_fid(dentry);
+		if (IS_ERR(inode_fid)) {
+			err = PTR_ERR(inode_fid);
+			mutex_unlock(&v9inode->v_mutex);
+			goto error;
+		}
+		v9inode->writeback_fid = (void *) inode_fid;
+	}
+	mutex_unlock(&v9inode->v_mutex);
+	filp = finish_open(od, dentry, generic_file_open);
+	if (IS_ERR(filp)) {
+		err = PTR_ERR(filp);
+		goto error;
+	}
+
+	filp->private_data = fid;
+#ifdef CONFIG_9P_FSCACHE
+	if (v9ses->cache)
+		v9fs_cache_inode_set_cookie(dentry->d_inode, filp);
+#endif
+
+	*created = true;
+out:
+	dput(res);
+	return filp;
+
+error:
+	if (fid)
+		p9_client_clunk(fid);
+
+	filp = ERR_PTR(err);
+	goto out;
+}
+
 /**
  * v9fs_vfs_unlink - VFS unlink hook to delete an inode
  * @i:  inode that is being unlinked
@@ -1488,6 +1521,7 @@ out:
 static const struct inode_operations v9fs_dir_inode_operations_dotu = {
 	.create = v9fs_vfs_create,
 	.lookup = v9fs_vfs_lookup,
+	.atomic_open = v9fs_vfs_atomic_open,
 	.symlink = v9fs_vfs_symlink,
 	.link = v9fs_vfs_link,
 	.unlink = v9fs_vfs_unlink,
@@ -1502,6 +1536,7 @@ static const struct inode_operations v9fs_dir_inode_operations_dotu = {
 static const struct inode_operations v9fs_dir_inode_operations = {
 	.create = v9fs_vfs_create,
 	.lookup = v9fs_vfs_lookup,
+	.atomic_open = v9fs_vfs_atomic_open,
 	.unlink = v9fs_vfs_unlink,
 	.mkdir = v9fs_vfs_mkdir,
 	.rmdir = v9fs_vfs_rmdir,
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index a1e6c99..7a1b48e 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -248,7 +248,6 @@ int v9fs_open_to_dotl_flags(int flags)
  * @dir: directory inode that is being created
  * @dentry:  dentry that is being deleted
  * @mode: create permissions
- * @nd: path information
  *
  */
 
@@ -256,9 +255,16 @@ static int
 v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
 		struct nameidata *nd)
 {
+	return v9fs_vfs_mknod_dotl(dir, dentry, omode, 0);
+}
+
+static struct file *
+v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
+			  struct opendata *od, unsigned flags, umode_t omode,
+			  bool *created)
+{
 	int err = 0;
 	gid_t gid;
-	int flags;
 	umode_t mode;
 	char *name = NULL;
 	struct file *filp;
@@ -269,19 +275,25 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
 	struct p9_fid *dfid, *ofid, *inode_fid;
 	struct v9fs_session_info *v9ses;
 	struct posix_acl *pacl = NULL, *dacl = NULL;
+	struct dentry *res = NULL;
 
-	v9ses = v9fs_inode2v9ses(dir);
-	if (nd)
-		flags = nd->intent.open.flags;
-	else {
-		/*
-		 * create call without LOOKUP_OPEN is due
-		 * to mknod of regular files. So use mknod
-		 * operation.
-		 */
-		return v9fs_vfs_mknod_dotl(dir, dentry, omode, 0);
+	if (d_unhashed(dentry)) {
+		res = v9fs_vfs_lookup(dir, dentry, NULL);
+		if (IS_ERR(res))
+			return ERR_CAST(res);
+
+		if (res)
+			dentry = res;
+	}
+
+	/* Only creates */
+	if (!(flags & O_CREAT) || dentry->d_inode) {
+		finish_no_open(od, res);
+		return NULL;
 	}
 
+	v9ses = v9fs_inode2v9ses(dir);
+
 	name = (char *) dentry->d_name.name;
 	p9_debug(P9_DEBUG_VFS, "name:%s flags:0x%x mode:0x%hx\n",
 		 name, flags, omode);
@@ -290,7 +302,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
 	if (IS_ERR(dfid)) {
 		err = PTR_ERR(dfid);
 		p9_debug(P9_DEBUG_VFS, "fid lookup failed %d\n", err);
-		return err;
+		goto err_return;
 	}
 
 	/* clone a fid to use for creation */
@@ -298,7 +310,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
 	if (IS_ERR(ofid)) {
 		err = PTR_ERR(ofid);
 		p9_debug(P9_DEBUG_VFS, "p9_client_walk failed %d\n", err);
-		return err;
+		goto err_return;
 	}
 
 	gid = v9fs_get_fsgid_for_create(dir);
@@ -363,7 +375,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
 	}
 	mutex_unlock(&v9inode->v_mutex);
 	/* Since we are opening a file, assign the open fid to the file */
-	filp = lookup_instantiate_filp(nd, dentry, generic_file_open);
+	filp = finish_open(od, dentry, generic_file_open);
 	if (IS_ERR(filp)) {
 		err = PTR_ERR(filp);
 		goto err_clunk_old_fid;
@@ -373,7 +385,10 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
 	if (v9ses->cache)
 		v9fs_cache_inode_set_cookie(inode, filp);
 #endif
-	return 0;
+	*created = true;
+out:
+	dput(res);
+	return filp;
 
 error:
 	if (fid)
@@ -382,7 +397,9 @@ err_clunk_old_fid:
 	if (ofid)
 		p9_client_clunk(ofid);
 	v9fs_set_create_acl(NULL, &dacl, &pacl);
-	return err;
+err_return:
+	filp = ERR_PTR(err);
+	goto out;
 }
 
 /**
@@ -1000,6 +1017,7 @@ out:
 
 const struct inode_operations v9fs_dir_inode_operations_dotl = {
 	.create = v9fs_vfs_create_dotl,
+	.atomic_open = v9fs_vfs_atomic_open_dotl,
 	.lookup = v9fs_vfs_lookup,
 	.link = v9fs_vfs_link_dotl,
 	.symlink = v9fs_vfs_symlink_dotl,
-- 
1.7.7

