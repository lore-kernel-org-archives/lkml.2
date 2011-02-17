Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab1BQSES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:04:18 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36075 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465Ab1BQSCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:02:33 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 09/14] fs/9p: Mark inode attr invalid on setattr
Date: Thu, 17 Feb 2011 23:32:00 +0530
Message-Id: <1297965725-25603-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c      |    9 ++++++++-
 fs/9p/vfs_inode_dotl.c |    8 +++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 21d36c7..e3597eb 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -958,9 +958,10 @@ v9fs_vfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 {
 	int retval;
-	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid;
 	struct p9_wstat wstat;
+	struct v9fs_session_info *v9ses;
+
 
 	P9_DPRINTK(P9_DEBUG_VFS, "\n");
 	retval = -EPERM;
@@ -993,6 +994,12 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	retval = p9_client_wstat(fid, &wstat);
 	if (retval < 0)
 		return retval;
+	/*
+	 * Changing some of the attribute can result in
+	 * implicit update of other attributes. So mark
+	 * all of them invalid
+	 */
+	v9fs_invalidate_inode_attr(dentry->d_inode);
 
 	if ((iattr->ia_valid & ATTR_SIZE) &&
 	    iattr->ia_size != i_size_read(dentry->d_inode)) {
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 1cab2b5..81b2b4f 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -436,9 +436,9 @@ v9fs_vfs_getattr_dotl(struct vfsmount *mnt, struct dentry *dentry,
 int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
 {
 	int retval;
-	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid;
 	struct p9_iattr_dotl p9attr;
+	struct v9fs_session_info *v9ses;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "\n");
 
@@ -465,6 +465,12 @@ int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
 	retval = p9_client_setattr(fid, &p9attr);
 	if (retval < 0)
 		return retval;
+	/*
+	 * Changing some of the attribute can result in
+	 * implicit update of other attributes. So mark
+	 * all of them invalid
+	 */
+	v9fs_invalidate_inode_attr(dentry->d_inode);
 
 	if ((iattr->ia_valid & ATTR_SIZE) &&
 	    iattr->ia_size != i_size_read(dentry->d_inode)) {
-- 
1.7.1

