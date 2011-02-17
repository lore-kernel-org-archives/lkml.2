Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab1BQSCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:02:41 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36081 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523Ab1BQSCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:02:38 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 11/14] fs/9p: Mark directory inode invalid for many directory inode operations
Date: Thu, 17 Feb 2011 23:32:02 +0530
Message-Id: <1297965725-25603-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One successfull directory operation we would have changed directory
inode attribute. So mark them invalid

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c      |   22 +++++++++++++++-------
 fs/9p/vfs_inode_dotl.c |   23 ++++++++++++++---------
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index e3597eb..27045d9 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -498,8 +498,8 @@ v9fs_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
 static int v9fs_remove(struct inode *dir, struct dentry *file, int rmdir)
 {
 	int retval;
-	struct inode *file_inode;
 	struct p9_fid *v9fid;
+	struct inode *file_inode;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "inode: %p dentry: %p rmdir: %d\n", dir, file,
 		rmdir);
@@ -520,6 +520,7 @@ static int v9fs_remove(struct inode *dir, struct dentry *file, int rmdir)
 			drop_nlink(dir);
 		} else
 			drop_nlink(file_inode);
+		v9fs_invalidate_inode_attr(dir);
 	}
 	return retval;
 }
@@ -642,6 +643,7 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 		goto error;
 	}
 
+	v9fs_invalidate_inode_attr(dir);
 	/* if we are opening a file, assign the open fid to the file */
 	if (nd && nd->flags & LOOKUP_OPEN) {
 		v9inode = V9FS_I(dentry->d_inode);
@@ -707,8 +709,8 @@ static int v9fs_vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
 	int err;
 	u32 perm;
-	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid;
+	struct v9fs_session_info *v9ses;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "name %s\n", dentry->d_name.name);
 	err = 0;
@@ -718,8 +720,10 @@ static int v9fs_vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	if (IS_ERR(fid)) {
 		err = PTR_ERR(fid);
 		fid = NULL;
-	} else
+	} else {
 		inc_nlink(dir);
+		v9fs_invalidate_inode_attr(dir);
+	}
 
 	if (fid)
 		p9_client_clunk(fid);
@@ -830,6 +834,7 @@ int
 v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		struct inode *new_dir, struct dentry *new_dentry)
 {
+	int retval;
 	struct inode *old_inode;
 	struct inode *new_inode;
 	struct v9fs_session_info *v9ses;
@@ -837,7 +842,6 @@ v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct p9_fid *olddirfid;
 	struct p9_fid *newdirfid;
 	struct p9_wstat wstat;
-	int retval;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "\n");
 	retval = 0;
@@ -895,6 +899,8 @@ clunk_newdir:
 				inc_nlink(new_dir);
 			drop_nlink(old_dir);
 		}
+		v9fs_invalidate_inode_attr(old_dir);
+		v9fs_invalidate_inode_attr(new_dir);
 		/* successful rename */
 		d_move(old_dentry, new_dentry);
 	}
@@ -1222,8 +1228,8 @@ static int v9fs_vfs_mkspecial(struct inode *dir, struct dentry *dentry,
 	int mode, const char *extension)
 {
 	u32 perm;
-	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid;
+	struct v9fs_session_info *v9ses;
 
 	v9ses = v9fs_inode2v9ses(dir);
 	if (!v9fs_proto_dotu(v9ses)) {
@@ -1237,6 +1243,7 @@ static int v9fs_vfs_mkspecial(struct inode *dir, struct dentry *dentry,
 	if (IS_ERR(fid))
 		return PTR_ERR(fid);
 
+	v9fs_invalidate_inode_attr(dir);
 	p9_client_clunk(fid);
 	return 0;
 }
@@ -1273,8 +1280,8 @@ v9fs_vfs_link(struct dentry *old_dentry, struct inode *dir,
 	      struct dentry *dentry)
 {
 	int retval;
-	struct p9_fid *oldfid;
 	char *name;
+	struct p9_fid *oldfid;
 
 	P9_DPRINTK(P9_DEBUG_VFS,
 		" %lu,%s,%s\n", dir->i_ino, dentry->d_name.name,
@@ -1293,7 +1300,8 @@ v9fs_vfs_link(struct dentry *old_dentry, struct inode *dir,
 	sprintf(name, "%d\n", oldfid->fid);
 	retval = v9fs_vfs_mkspecial(dir, dentry, P9_DMLINK, name);
 	__putname(name);
-
+	if (!retval)
+		v9fs_invalidate_inode_attr(dir);
 clunk_fid:
 	p9_client_clunk(oldfid);
 	return retval;
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 81b2b4f..167959f 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -220,6 +220,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 				err);
 		goto error;
 	}
+	v9fs_invalidate_inode_attr(dir);
 
 	/* instantiate inode and assign the unopened fid to the dentry */
 	fid = p9_client_walk(dfid, 1, &name, 1);
@@ -383,6 +384,7 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
 	/* Now set the ACL based on the default value */
 	v9fs_set_create_acl(dentry, dacl, pacl);
 	inc_nlink(dir);
+	v9fs_invalidate_inode_attr(dir);
 error:
 	if (fid)
 		p9_client_clunk(fid);
@@ -567,14 +569,14 @@ static int
 v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
 		const char *symname)
 {
-	struct v9fs_session_info *v9ses;
-	struct p9_fid *dfid;
-	struct p9_fid *fid = NULL;
-	struct inode *inode;
-	struct p9_qid qid;
-	char *name;
 	int err;
 	gid_t gid;
+	char *name;
+	struct p9_qid qid;
+	struct inode *inode;
+	struct p9_fid *dfid;
+	struct p9_fid *fid = NULL;
+	struct v9fs_session_info *v9ses;
 
 	name = (char *) dentry->d_name.name;
 	P9_DPRINTK(P9_DEBUG_VFS, "v9fs_vfs_symlink_dotl : %lu,%s,%s\n",
@@ -598,6 +600,7 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
 		goto error;
 	}
 
+	v9fs_invalidate_inode_attr(dir);
 	if (v9ses->cache) {
 		/* Now walk from the parent so we can get an unopened fid. */
 		fid = p9_client_walk(dfid, 1, &name, 1);
@@ -652,10 +655,10 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 		struct dentry *dentry)
 {
 	int err;
-	struct p9_fid *dfid, *oldfid;
 	char *name;
-	struct v9fs_session_info *v9ses;
 	struct dentry *dir_dentry;
+	struct p9_fid *dfid, *oldfid;
+	struct v9fs_session_info *v9ses;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "dir ino: %lu, old_name: %s, new_name: %s\n",
 			dir->i_ino, old_dentry->d_name.name,
@@ -680,6 +683,7 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 		return err;
 	}
 
+	v9fs_invalidate_inode_attr(dir);
 	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE) {
 		/* Get the latest stat info from server. */
 		struct p9_fid *fid;
@@ -716,12 +720,12 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int omode,
 		dev_t rdev)
 {
 	int err;
+	gid_t gid;
 	char *name;
 	mode_t mode;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid = NULL, *dfid = NULL;
 	struct inode *inode;
-	gid_t gid;
 	struct p9_qid qid;
 	struct dentry *dir_dentry;
 	struct posix_acl *dacl = NULL, *pacl = NULL;
@@ -758,6 +762,7 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int omode,
 	if (err < 0)
 		goto error;
 
+	v9fs_invalidate_inode_attr(dir);
 	/* instantiate inode and assign the unopened fid to the dentry */
 	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE) {
 		fid = p9_client_walk(dfid, 1, &name, 1);
-- 
1.7.1

