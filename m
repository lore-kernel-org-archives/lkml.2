Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab1CAIw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:52:58 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:50962 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab1CAIvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:51:37 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/6] fs/9p: call vmtruncate before setattr 9p opeation
Date: Tue,  1 Mar 2011 14:21:20 +0530
Message-Id: <1298969484-16199-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298969484-16199-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1298969484-16199-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to call vmtruncate before 9p setattr operation, otherwise we
could write back some dirty pages between setattr with ATTR_SIZE and vmtruncate
causing some truncated pages to be written back to server

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c      |   10 ++++------
 fs/9p/vfs_inode_dotl.c |    9 ++++-----
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 64f2e4e..7c60011 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -996,18 +996,16 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 		if (iattr->ia_valid & ATTR_GID)
 			wstat.n_gid = iattr->ia_gid;
 	}
-
-	retval = p9_client_wstat(fid, &wstat);
-	if (retval < 0)
-		return retval;
-
-	v9fs_invalidate_inode_attr(dentry->d_inode);
 	if ((iattr->ia_valid & ATTR_SIZE) &&
 	    iattr->ia_size != i_size_read(dentry->d_inode)) {
 		retval = vmtruncate(dentry->d_inode, iattr->ia_size);
 		if (retval)
 			return retval;
 	}
+	retval = p9_client_wstat(fid, &wstat);
+	if (retval < 0)
+		return retval;
+	v9fs_invalidate_inode_attr(dentry->d_inode);
 
 	setattr_copy(dentry->d_inode, iattr);
 	mark_inode_dirty(dentry->d_inode);
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 2826026..b14d740 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -456,17 +456,16 @@ int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
 	if (IS_ERR(fid))
 		return PTR_ERR(fid);
 
-	retval = p9_client_setattr(fid, &p9attr);
-	if (retval < 0)
-		return retval;
-
-	v9fs_invalidate_inode_attr(dentry->d_inode);
 	if ((iattr->ia_valid & ATTR_SIZE) &&
 	    iattr->ia_size != i_size_read(dentry->d_inode)) {
 		retval = vmtruncate(dentry->d_inode, iattr->ia_size);
 		if (retval)
 			return retval;
 	}
+	retval = p9_client_setattr(fid, &p9attr);
+	if (retval < 0)
+		return retval;
+	v9fs_invalidate_inode_attr(dentry->d_inode);
 
 	setattr_copy(dentry->d_inode, iattr);
 	mark_inode_dirty(dentry->d_inode);
-- 
1.7.1

