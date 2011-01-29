Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab1A2T0t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 14:26:49 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:41547 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab1A2T0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 14:26:48 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V1 6/7] fs/9p: Add fid to inode in cached mode
Date: Sun, 30 Jan 2011 00:56:25 +0530
Message-Id: <1296329186-23807-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296329186-23807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296329186-23807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fid attached to inode will be opened O_RDWR mode and is used
for dirty page writeback only.

FIXME!!: Should we make the fid owned by uid = 0

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_file.c       |   31 +++++++++++++++++++++++++++++++
 fs/9p/vfs_inode.c      |   34 +++++++++++++++++++++++++++++++++-
 fs/9p/vfs_inode_dotl.c |   30 ++++++++++++++++++++++++++++--
 3 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index ecdd512..0f62b26 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -86,11 +86,42 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 	}
 
 	file->private_data = fid;
+	/*
+	 * In cached mode we need to attach a fid to inode. The fid
+	 * attached to inode will only be used to write back the
+	 * dirty pages. We always request for the open fid in read-write
+	 * mode so that a partial page write which result in page
+	 * read can work.
+	 */
+	if (v9ses->cache && !inode->i_private) {
+		/*
+		 * clone a fid and add it to inode->i_private
+		 * we do it during open time instead of
+		 * page dirty time via write_begin/page_mkwrite
+		 * because we want write after unlink usecase
+		 * to work.
+		 */
+		fid = v9fs_fid_clone(file->f_path.dentry);
+		if (IS_ERR(fid)) {
+			err = PTR_ERR(fid);
+			goto out_error;
+		}
+		err = p9_client_open(fid, O_RDWR);
+		if (err < 0) {
+			p9_client_clunk(fid);
+			goto out_error;
+		}
+		inode->i_private = (void *) fid;
+	}
 #ifdef CONFIG_9P_FSCACHE
 	if (v9ses->cache)
 		v9fs_cache_inode_set_cookie(inode, file);
 #endif
 	return 0;
+out_error:
+	p9_client_clunk(file->private_data);
+	file->private_data = 0;
+	return err;
 }
 
 /**
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index b6b939b..908fa08 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -416,6 +416,11 @@ void v9fs_evict_inode(struct inode *inode)
 #ifdef CONFIG_9P_FSCACHE
 	v9fs_cache_inode_put_cookie(inode);
 #endif
+	/* clunk the fid stashed in inode->i_private */
+	if (inode->i_private) {
+		p9_client_clunk((struct p9_fid *)inode->i_private);
+		inode->i_private = 0;
+	}
 }
 
 struct inode *
@@ -577,7 +582,7 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	u32 perm;
 	int flags;
 	struct v9fs_session_info *v9ses;
-	struct p9_fid *fid;
+	struct p9_fid *fid, *inode_fid;
 	struct file *filp;
 
 	err = 0;
@@ -600,6 +605,33 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 
 	/* if we are opening a file, assign the open fid to the file */
 	if (nd && nd->flags & LOOKUP_OPEN) {
+		/*
+		 * In cached mode we need to attach a fid to inode. The fid
+		 * attached to inode will only be used to write back the
+		 * dirty pages. We always request for the open fid in read-write
+		 * mode so that a partial page write which result in page
+		 * read can work.
+		 */
+		if (v9ses->cache && !dentry->d_inode->i_private) {
+			/*
+			 * clone a fid and add it to inode->i_private
+			 * we do it during open time instead of
+			 * page dirty time via write_begin/page_mkwrite
+			 * because we want write after unlink usecase
+			 * to work.
+			 */
+			inode_fid = v9fs_fid_clone(dentry);
+			if (IS_ERR(inode_fid)) {
+				err = PTR_ERR(inode_fid);
+				goto error;
+			}
+			err = p9_client_open(inode_fid, O_RDWR);
+			if (err < 0) {
+				p9_client_clunk(inode_fid);
+				goto error;
+			}
+			dentry->d_inode->i_private = (void *) inode_fid;
+		}
 		filp = lookup_instantiate_filp(nd, dentry, generic_file_open);
 		if (IS_ERR(filp)) {
 			err = PTR_ERR(filp);
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 265f583..d5aa986 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -142,7 +142,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 	mode_t mode;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid = NULL;
-	struct p9_fid *dfid, *ofid;
+	struct p9_fid *dfid, *ofid, *inode_fid;
 	struct file *filp;
 	struct p9_qid qid;
 	struct inode *inode;
@@ -218,7 +218,33 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 
 	/* Now set the ACL based on the default value */
 	v9fs_set_create_acl(dentry, dacl, pacl);
-
+	/*
+	 * In cached mode we need to attach a fid to inode. The fid
+	 * attached to inode will only be used to write back the
+	 * dirty pages. We always request for the open fid in read-write
+	 * mode so that a partial page write which result in page
+	 * read can work.
+	 */
+	if (v9ses->cache && !inode->i_private) {
+		/*
+		 * clone a fid and add it to inode->i_private
+		 * we do it during open time instead of
+		 * page dirty time via write_begin/page_mkwrite
+		 * because we want write after unlink usecase
+		 * to work.
+		 */
+		inode_fid = v9fs_fid_clone(dentry);
+		if (IS_ERR(inode_fid)) {
+			err = PTR_ERR(inode_fid);
+			goto error;
+		}
+		err = p9_client_open(inode_fid, O_RDWR);
+		if (err < 0) {
+			p9_client_clunk(inode_fid);
+			goto error;
+		}
+		inode->i_private = (void *) inode_fid;
+	}
 	/* Since we are opening a file, assign the open fid to the file */
 	filp = lookup_instantiate_filp(nd, dentry, generic_file_open);
 	if (IS_ERR(filp)) {
-- 
1.7.1

