Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab1CERuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:50:40 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:43891 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1CERui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:50:38 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/4] fs/9p: Use truncate_setsize instead of vmtruncate
Date: Sat,  5 Mar 2011 23:20:22 +0530
Message-Id: <1299347425-16810-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert vmtruncate usage to truncate_setsize. We also writeback
all dirty pages before doing 9p operations and on success call truncate_setsize.
This ensure that we continue sanely on failed truncate on the server. The
disadvantage is that we are now going to write back the content that get
thrown away later as a part of truncate.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c      |   16 ++++++++++------
 fs/9p/vfs_inode_dotl.c |   12 +++++-------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index c6cef24..0afbbb4 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -971,6 +971,10 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	struct p9_wstat wstat;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "\n");
+	retval = inode_change_ok(dentry->d_inode, iattr);
+	if (retval)
+		return retval;
+
 	retval = -EPERM;
 	v9ses = v9fs_inode2v9ses(dentry->d_inode);
 	fid = v9fs_fid_lookup(dentry);
@@ -997,12 +1001,7 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 		if (iattr->ia_valid & ATTR_GID)
 			wstat.n_gid = iattr->ia_gid;
 	}
-	if ((iattr->ia_valid & ATTR_SIZE) &&
-	    iattr->ia_size != i_size_read(dentry->d_inode)) {
-		retval = vmtruncate(dentry->d_inode, iattr->ia_size);
-		if (retval)
-			return retval;
-	}
+
 	/* Write all dirty data */
 	if (S_ISREG(dentry->d_inode->i_mode))
 		filemap_write_and_wait(dentry->d_inode->i_mapping);
@@ -1010,6 +1009,11 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	retval = p9_client_wstat(fid, &wstat);
 	if (retval < 0)
 		return retval;
+
+	if ((iattr->ia_valid & ATTR_SIZE) &&
+	    iattr->ia_size != i_size_read(dentry->d_inode))
+		truncate_setsize(dentry->d_inode, iattr->ia_size);
+
 	v9fs_invalidate_inode_attr(dentry->d_inode);
 
 	setattr_copy(dentry->d_inode, iattr);
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 327c578..0a0ac30 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -456,12 +456,6 @@ int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
 	if (IS_ERR(fid))
 		return PTR_ERR(fid);
 
-	if ((iattr->ia_valid & ATTR_SIZE) &&
-	    iattr->ia_size != i_size_read(dentry->d_inode)) {
-		retval = vmtruncate(dentry->d_inode, iattr->ia_size);
-		if (retval)
-			return retval;
-	}
 	/* Write all dirty data */
 	if (S_ISREG(dentry->d_inode->i_mode))
 		filemap_write_and_wait(dentry->d_inode->i_mapping);
@@ -469,8 +463,12 @@ int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
 	retval = p9_client_setattr(fid, &p9attr);
 	if (retval < 0)
 		return retval;
-	v9fs_invalidate_inode_attr(dentry->d_inode);
 
+	if ((iattr->ia_valid & ATTR_SIZE) &&
+	    iattr->ia_size != i_size_read(dentry->d_inode))
+		truncate_setsize(dentry->d_inode, iattr->ia_size);
+
+	v9fs_invalidate_inode_attr(dentry->d_inode);
 	setattr_copy(dentry->d_inode, iattr);
 	mark_inode_dirty(dentry->d_inode);
 	if (iattr->ia_valid & ATTR_MODE) {
-- 
1.7.1

