Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab1ADIoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:44:25 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:40953 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab1ADIoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:44:24 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] fs/9p: Use the correct dentry operations
Date: Tue,  4 Jan 2011 14:14:06 +0530
Message-Id: <1294130646-32602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ad77dbce567128d59b37a14c9562c8af6f63aeca removed the changes
done by 3c30750ffafbc32af040b09f777b67aa2486b063. This patch
add the changes back and also simplifies the function

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode_dotl.c |   73 +++++++++++++++++-------------------------------
 1 files changed, 26 insertions(+), 47 deletions(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 38d5880..8527742 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -197,61 +197,40 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 		goto error;
 	}
 	/* instantiate inode and assign the unopened fid to the dentry */
-	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE ||
-	    (nd && nd->flags & LOOKUP_OPEN)) {
-		fid = p9_client_walk(dfid, 1, &name, 1);
-		if (IS_ERR(fid)) {
-			err = PTR_ERR(fid);
-			P9_DPRINTK(P9_DEBUG_VFS, "p9_client_walk failed %d\n",
-				err);
-			fid = NULL;
-			goto error;
-		}
+	fid = p9_client_walk(dfid, 1, &name, 1);
+	if (IS_ERR(fid)) {
+		err = PTR_ERR(fid);
+		P9_DPRINTK(P9_DEBUG_VFS, "p9_client_walk failed %d\n", err);
+		fid = NULL;
+		goto error;
+	}
 
-		inode = v9fs_inode_from_fid(v9ses, fid, dir->i_sb);
-		if (IS_ERR(inode)) {
-			err = PTR_ERR(inode);
-			P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n",
-				err);
-			goto error;
-		}
+	inode = v9fs_inode_from_fid(v9ses, fid, dir->i_sb);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n", err);
+		goto error;
+	}
+	if (v9ses->cache)
 		dentry->d_op = &v9fs_cached_dentry_operations;
-		d_instantiate(dentry, inode);
-		err = v9fs_fid_add(dentry, fid);
-		if (err < 0)
-			goto error;
-		/* The fid would get clunked via a dput */
-		fid = NULL;
-	} else {
-		/*
-		 * Not in cached mode. No need to populate
-		 * inode with stat. We need to get an inode
-		 * so that we can set the acl with dentry
-		 */
-		inode = v9fs_get_inode(dir->i_sb, mode);
-		if (IS_ERR(inode)) {
-			err = PTR_ERR(inode);
-			goto error;
-		}
+	else
 		dentry->d_op = &v9fs_dentry_operations;
-		d_instantiate(dentry, inode);
-	}
+	d_instantiate(dentry, inode);
+	err = v9fs_fid_add(dentry, fid);
+	if (err < 0)
+		goto error;
+
 	/* Now set the ACL based on the default value */
 	v9fs_set_create_acl(dentry, dacl, pacl);
 
-	/* if we are opening a file, assign the open fid to the file */
-	if (nd && nd->flags & LOOKUP_OPEN) {
-		filp = lookup_instantiate_filp(nd, dentry, generic_file_open);
-		if (IS_ERR(filp)) {
-			p9_client_clunk(ofid);
-			return PTR_ERR(filp);
-		}
-		filp->private_data = ofid;
-	} else
+	/* Since we are opening a file, assign the open fid to the file */
+	filp = lookup_instantiate_filp(nd, dentry, generic_file_open);
+	if (IS_ERR(filp)) {
 		p9_client_clunk(ofid);
-
+		return PTR_ERR(filp);
+	}
+	filp->private_data = ofid;
 	return 0;
-
 error:
 	if (ofid)
 		p9_client_clunk(ofid);
-- 
1.7.1

