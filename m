Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab0IGK3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 06:29:20 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:32894 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab0IGK2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 06:28:49 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 5/6] fs/9p: Implement create time inheritance
Date: Tue,  7 Sep 2010 15:58:23 +0530
Message-Id: <1283855304-22472-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283855304-22472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1283855304-22472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inherit default ACL on create

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/acl.c       |   52 +++++++++++++++++++
 fs/9p/acl.h       |   17 ++++++
 fs/9p/vfs_inode.c |  141 ++++++++++++++++++++++++++++++++++++----------------
 3 files changed, 166 insertions(+), 44 deletions(-)

diff --git a/fs/9p/acl.c b/fs/9p/acl.c
index 203da2b..1c50a9f 100644
--- a/fs/9p/acl.c
+++ b/fs/9p/acl.c
@@ -152,6 +152,58 @@ int v9fs_acl_chmod(struct dentry *dentry)
 	return retval;
 }
 
+int v9fs_set_create_acl(struct dentry *dentry,
+			struct posix_acl *dpacl, struct posix_acl *pacl)
+{
+	if (dpacl)
+		v9fs_set_acl(dentry, ACL_TYPE_DEFAULT, dpacl);
+	if (pacl)
+		v9fs_set_acl(dentry, ACL_TYPE_ACCESS, pacl);
+	posix_acl_release(dpacl);
+	posix_acl_release(pacl);
+	return 0;
+}
+
+int v9fs_acl_mode(struct inode *dir, mode_t *modep,
+		  struct posix_acl **dpacl, struct posix_acl **pacl)
+{
+	int retval = 0;
+	mode_t mode = *modep;
+	struct posix_acl *acl = NULL;
+
+	if (!S_ISLNK(mode)) {
+		acl = v9fs_get_cached_acl(dir, ACL_TYPE_DEFAULT);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		if (!acl)
+			mode &= ~current_umask();
+	}
+	if (acl) {
+		struct posix_acl *clone;
+
+		if (S_ISDIR(mode))
+			*dpacl = acl;
+		clone = posix_acl_clone(acl, GFP_NOFS);
+		retval = -ENOMEM;
+		if (!clone)
+			goto cleanup;
+
+		retval = posix_acl_create_masq(clone, &mode);
+		if (retval < 0) {
+			posix_acl_release(clone);
+			goto cleanup;
+		}
+		if (retval > 0)
+			*pacl = clone;
+	}
+	*modep  = mode;
+	return 0;
+cleanup:
+	posix_acl_release(acl);
+	return retval;
+
+}
+
 static int v9fs_xattr_get_acl(struct dentry *dentry, const char *name,
 			      void *buffer, size_t size, int type)
 {
diff --git a/fs/9p/acl.h b/fs/9p/acl.h
index 0adcc43..59e18c2 100644
--- a/fs/9p/acl.h
+++ b/fs/9p/acl.h
@@ -18,6 +18,10 @@
 extern int v9fs_get_acl(struct inode *, struct p9_fid *);
 extern int v9fs_check_acl(struct inode *inode, int mask);
 extern int v9fs_acl_chmod(struct dentry *);
+extern int v9fs_set_create_acl(struct dentry *,
+			       struct posix_acl *, struct posix_acl *);
+extern int v9fs_acl_mode(struct inode *dir, mode_t *modep,
+			 struct posix_acl **dpacl, struct posix_acl **pacl);
 #else
 #define v9fs_check_acl NULL
 static inline int v9fs_get_acl(struct inode *inode, struct p9_fid *fid)
@@ -28,5 +32,18 @@ static inline int v9fs_acl_chmod(struct dentry *dentry)
 {
 	return 0;
 }
+static inline int v9fs_set_create_acl(struct dentry *dentry,
+				      struct posix_acl *dpacl,
+				      struct posix_acl *pacl)
+{
+	return 0;
+}
+static inline int v9fs_acl_mode(struct inode *dir, mode_t *modep,
+				struct posix_acl **dpacl,
+				struct posix_acl **pacl)
+{
+	return 0;
+}
+
 #endif
 #endif /* FS_9P_XATTR_H */
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 7983698..2f904a8 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -662,19 +662,21 @@ error:
  */
 
 static int
-v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int mode,
+v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 		struct nameidata *nd)
 {
 	int err = 0;
 	char *name = NULL;
 	gid_t gid;
 	int flags;
+	mode_t mode;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid = NULL;
 	struct p9_fid *dfid, *ofid;
 	struct file *filp;
 	struct p9_qid qid;
 	struct inode *inode;
+	struct posix_acl *pacl = NULL, *dacl = NULL;
 
 	v9ses = v9fs_inode2v9ses(dir);
 	if (nd && nd->flags & LOOKUP_OPEN)
@@ -684,7 +686,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int mode,
 
 	name = (char *) dentry->d_name.name;
 	P9_DPRINTK(P9_DEBUG_VFS, "v9fs_vfs_create_dotl: name:%s flags:0x%x "
-			"mode:0x%x\n", name, flags, mode);
+			"mode:0x%x\n", name, flags, omode);
 
 	dfid = v9fs_fid_lookup(dentry->d_parent);
 	if (IS_ERR(dfid)) {
@@ -702,6 +704,15 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int mode,
 	}
 
 	gid = v9fs_get_fsgid_for_create(dir);
+
+	mode = omode;
+	/* Update mode based on ACL value */
+	err = v9fs_acl_mode(dir, &mode, &dacl, &pacl);
+	if (err) {
+		P9_DPRINTK(P9_DEBUG_VFS,
+			   "Failed to get acl values in creat %d\n", err);
+		goto error;
+	}
 	err = p9_client_create_dotl(ofid, name, flags, mode, gid, &qid);
 	if (err < 0) {
 		P9_DPRINTK(P9_DEBUG_VFS,
@@ -709,42 +720,48 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int mode,
 				err);
 		goto error;
 	}
+	/* instantiate inode and assign the unopened fid to the dentry */
+	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE ||
+	    (nd && nd->flags & LOOKUP_OPEN)) {
+		fid = p9_client_walk(dfid, 1, &name, 1);
+		if (IS_ERR(fid)) {
+			err = PTR_ERR(fid);
+			P9_DPRINTK(P9_DEBUG_VFS, "p9_client_walk failed %d\n",
+				err);
+			fid = NULL;
+			goto error;
+		}
 
-	/* No need to populate the inode if we are not opening the file AND
-	 * not in cached mode.
-	 */
-	if (!v9ses->cache && !(nd && nd->flags & LOOKUP_OPEN)) {
-		/* Not in cached mode. No need to populate inode with stat */
-		dentry->d_op = &v9fs_dentry_operations;
-		p9_client_clunk(ofid);
-		d_instantiate(dentry, NULL);
-		return 0;
-	}
-
-	/* Now walk from the parent so we can get an unopened fid. */
-	fid = p9_client_walk(dfid, 1, &name, 1);
-	if (IS_ERR(fid)) {
-		err = PTR_ERR(fid);
-		P9_DPRINTK(P9_DEBUG_VFS, "p9_client_walk failed %d\n", err);
-		fid = NULL;
-		goto error;
-	}
-
-	/* instantiate inode and assign the unopened fid to dentry */
-	inode = v9fs_inode_from_fid(v9ses, fid, dir->i_sb);
-	if (IS_ERR(inode)) {
-		err = PTR_ERR(inode);
-		P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n", err);
-		goto error;
-	}
-	if (v9ses->cache)
+		inode = v9fs_inode_from_fid(v9ses, fid, dir->i_sb);
+		if (IS_ERR(inode)) {
+			err = PTR_ERR(inode);
+			P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n",
+				err);
+			goto error;
+		}
 		dentry->d_op = &v9fs_cached_dentry_operations;
-	else
+		d_instantiate(dentry, inode);
+		err = v9fs_fid_add(dentry, fid);
+		if (err < 0)
+			goto error;
+		/* The fid would get clunked via a dput */
+		fid = NULL;
+	} else {
+		/*
+		 * Not in cached mode. No need to populate
+		 * inode with stat. We need to get an inode
+		 * so that we can set the acl with dentry
+		 */
+		inode = v9fs_get_inode(dir->i_sb, mode);
+		if (IS_ERR(inode)) {
+			err = PTR_ERR(inode);
+			goto error;
+		}
 		dentry->d_op = &v9fs_dentry_operations;
-	d_instantiate(dentry, inode);
-	err = v9fs_fid_add(dentry, fid);
-	if (err < 0)
-		goto error;
+		d_instantiate(dentry, inode);
+	}
+	/* Now set the ACL based on the default value */
+	v9fs_set_create_acl(dentry, dacl, pacl);
 
 	/* if we are opening a file, assign the open fid to the file */
 	if (nd && nd->flags & LOOKUP_OPEN) {
@@ -866,25 +883,28 @@ static int v9fs_vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
  *
  */
 
-static int v9fs_vfs_mkdir_dotl(struct inode *dir, struct dentry *dentry,
-					int mode)
+static int v9fs_vfs_mkdir_dotl(struct inode *dir,
+			       struct dentry *dentry, int omode)
 {
 	int err;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid = NULL, *dfid = NULL;
 	gid_t gid;
 	char *name;
+	mode_t mode;
 	struct inode *inode;
 	struct p9_qid qid;
 	struct dentry *dir_dentry;
+	struct posix_acl *dacl = NULL, *pacl = NULL;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "name %s\n", dentry->d_name.name);
 	err = 0;
 	v9ses = v9fs_inode2v9ses(dir);
 
-	mode |= S_IFDIR;
+	omode |= S_IFDIR;
 	if (dir->i_mode & S_ISGID)
-		mode |= S_ISGID;
+		omode |= S_ISGID;
+
 	dir_dentry = v9fs_dentry_from_dir_inode(dir);
 	dfid = v9fs_fid_lookup(dir_dentry);
 	if (IS_ERR(dfid)) {
@@ -895,7 +915,14 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir, struct dentry *dentry,
 	}
 
 	gid = v9fs_get_fsgid_for_create(dir);
-
+	mode = omode;
+	/* Update mode based on ACL value */
+	err = v9fs_acl_mode(dir, &mode, &dacl, &pacl);
+	if (err) {
+		P9_DPRINTK(P9_DEBUG_VFS,
+			   "Failed to get acl values in mkdir %d\n", err);
+		goto error;
+	}
 	name = (char *) dentry->d_name.name;
 	err = p9_client_mkdir_dotl(dfid, name, mode, gid, &qid);
 	if (err < 0)
@@ -925,7 +952,23 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir, struct dentry *dentry,
 		if (err < 0)
 			goto error;
 		fid = NULL;
+	} else {
+		/*
+		 * Not in cached mode. No need to populate
+		 * inode with stat. We need to get an inode
+		 * so that we can set the acl with dentry
+		 */
+		inode = v9fs_get_inode(dir->i_sb, mode);
+		if (IS_ERR(inode)) {
+			err = PTR_ERR(inode);
+			goto error;
+		}
+		dentry->d_op = &v9fs_dentry_operations;
+		d_instantiate(dentry, inode);
 	}
+	/* Now set the ACL based on the default value */
+	v9fs_set_create_acl(dentry, dacl, pacl);
+
 error:
 	if (fid)
 		p9_client_clunk(fid);
@@ -1860,21 +1903,23 @@ v9fs_vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
  *
  */
 static int
-v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int mode,
+v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int omode,
 		dev_t rdev)
 {
 	int err;
 	char *name;
+	mode_t mode;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid = NULL, *dfid = NULL;
 	struct inode *inode;
 	gid_t gid;
 	struct p9_qid qid;
 	struct dentry *dir_dentry;
+	struct posix_acl *dacl = NULL, *pacl = NULL;
 
 	P9_DPRINTK(P9_DEBUG_VFS,
 		" %lu,%s mode: %x MAJOR: %u MINOR: %u\n", dir->i_ino,
-		dentry->d_name.name, mode, MAJOR(rdev), MINOR(rdev));
+		dentry->d_name.name, omode, MAJOR(rdev), MINOR(rdev));
 
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
@@ -1890,7 +1935,14 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int mode,
 	}
 
 	gid = v9fs_get_fsgid_for_create(dir);
-
+	mode = omode;
+	/* Update mode based on ACL value */
+	err = v9fs_acl_mode(dir, &mode, &dacl, &pacl);
+	if (err) {
+		P9_DPRINTK(P9_DEBUG_VFS,
+			   "Failed to get acl values in mknod %d\n", err);
+		goto error;
+	}
 	name = (char *) dentry->d_name.name;
 
 	err = p9_client_mknod_dotl(dfid, name, mode, rdev, gid, &qid);
@@ -1934,7 +1986,8 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int mode,
 		dentry->d_op = &v9fs_dentry_operations;
 		d_instantiate(dentry, inode);
 	}
-
+	/* Now set the ACL based on the default value */
+	v9fs_set_create_acl(dentry, dacl, pacl);
 error:
 	if (fid)
 		p9_client_clunk(fid);
-- 
1.7.0.4

