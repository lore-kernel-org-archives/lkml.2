Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab1CERvB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:51:01 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:57982 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab1CERum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:50:42 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 4/4] fs/9p: Add v9fs_dentry2v9ses
Date: Sat,  5 Mar 2011 23:20:25 +0530
Message-Id: <1299347425-16810-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299347425-16810-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1299347425-16810-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new static inline and use the same

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/acl.c            |    4 ++--
 fs/9p/fid.c            |    6 +++---
 fs/9p/v9fs.h           |    5 +++++
 fs/9p/vfs_inode.c      |    6 +++---
 fs/9p/vfs_inode_dotl.c |    4 ++--
 fs/9p/vfs_super.c      |    2 +-
 6 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/9p/acl.c b/fs/9p/acl.c
index 5154552..33aa116 100644
--- a/fs/9p/acl.c
+++ b/fs/9p/acl.c
@@ -262,7 +262,7 @@ static int v9fs_xattr_get_acl(struct dentry *dentry, const char *name,
 	if (strcmp(name, "") != 0)
 		return -EINVAL;
 
-	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	v9ses = v9fs_dentry2v9ses(dentry);
 	/*
 	 * We allow set/get/list of acl when access=client is not specified
 	 */
@@ -312,7 +312,7 @@ static int v9fs_xattr_set_acl(struct dentry *dentry, const char *name,
 	if (strcmp(name, "") != 0)
 		return -EINVAL;
 
-	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	v9ses = v9fs_dentry2v9ses(dentry);
 	/*
 	 * set the attribute on the remote. Without even looking at the
 	 * xattr value. We leave it to the server to validate
diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 99a1a7b..0ee5945 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -134,7 +134,7 @@ static struct p9_fid *v9fs_fid_lookup_with_uid(struct dentry *dentry,
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid, *old_fid = NULL;
 
-	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	v9ses = v9fs_dentry2v9ses(dentry);
 	access = v9ses->flags & V9FS_ACCESS_MASK;
 	fid = v9fs_fid_find(dentry, uid, any);
 	if (fid)
@@ -237,7 +237,7 @@ struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
 	int  any, access;
 	struct v9fs_session_info *v9ses;
 
-	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	v9ses = v9fs_dentry2v9ses(dentry);
 	access = v9ses->flags & V9FS_ACCESS_MASK;
 	switch (access) {
 	case V9FS_ACCESS_SINGLE:
@@ -290,7 +290,7 @@ struct p9_fid *v9fs_writeback_fid(struct dentry *dentry)
 	struct p9_fid *fid;
 	struct v9fs_session_info *v9ses;
 
-	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	v9ses = v9fs_dentry2v9ses(dentry);
 	fid = v9fs_fid_clone_with_uid(dentry, 0);
 	if (IS_ERR(fid))
 		goto error_out;
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 89657e8..9665c2b 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -174,6 +174,11 @@ static inline struct v9fs_session_info *v9fs_inode2v9ses(struct inode *inode)
 	return (inode->i_sb->s_fs_info);
 }
 
+static inline struct v9fs_session_info *v9fs_dentry2v9ses(struct dentry *dentry)
+{
+	return dentry->d_sb->s_fs_info;
+}
+
 static inline int v9fs_proto_dotu(struct v9fs_session_info *v9ses)
 {
 	return v9ses->flags & V9FS_PROTO_2000U;
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 774a20a..7f6c677 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -936,7 +936,7 @@ v9fs_vfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 
 	P9_DPRINTK(P9_DEBUG_VFS, "dentry: %p\n", dentry);
 	err = -EPERM;
-	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	v9ses = v9fs_dentry2v9ses(dentry);
 	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE) {
 		generic_fillattr(dentry->d_inode, stat);
 		return 0;
@@ -977,7 +977,7 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 		return retval;
 
 	retval = -EPERM;
-	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	v9ses = v9fs_dentry2v9ses(dentry);
 	fid = v9fs_fid_lookup(dentry);
 	if(IS_ERR(fid))
 		return PTR_ERR(fid);
@@ -1139,7 +1139,7 @@ static int v9fs_readlink(struct dentry *dentry, char *buffer, int buflen)
 
 	P9_DPRINTK(P9_DEBUG_VFS, " %s\n", dentry->d_name.name);
 	retval = -EPERM;
-	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	v9ses = v9fs_dentry2v9ses(dentry);
 	fid = v9fs_fid_lookup(dentry);
 	if (IS_ERR(fid))
 		return PTR_ERR(fid);
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 8b616dc..ffbb113 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -395,7 +395,7 @@ v9fs_vfs_getattr_dotl(struct vfsmount *mnt, struct dentry *dentry,
 
 	P9_DPRINTK(P9_DEBUG_VFS, "dentry: %p\n", dentry);
 	err = -EPERM;
-	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	v9ses = v9fs_dentry2v9ses(dentry);
 	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE) {
 		generic_fillattr(dentry->d_inode, stat);
 		return 0;
@@ -452,7 +452,7 @@ int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
 	p9attr.mtime_nsec = iattr->ia_mtime.tv_nsec;
 
 	retval = -EPERM;
-	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	v9ses = v9fs_dentry2v9ses(dentry);
 	fid = v9fs_fid_lookup(dentry);
 	if (IS_ERR(fid))
 		return PTR_ERR(fid);
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 09fd08d..f3eed33 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -262,7 +262,7 @@ static int v9fs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		goto done;
 	}
 
-	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	v9ses = v9fs_dentry2v9ses(dentry);
 	if (v9fs_proto_dotl(v9ses)) {
 		res = p9_client_statfs(fid, &rs);
 		if (res == 0) {
-- 
1.7.1

