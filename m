Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1GYSHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:07:17 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:41919 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab1GYSHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:07:14 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH 1/2] fs/9p: Add fid before dentry instantiation
Date: Mon, 25 Jul 2011 23:36:32 +0530
Message-Id: <1311617193-11682-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d_instantiate marks the dentry positive. So a parallel lookup and mkdir of
the directory can find dentry that doesn't have fid attached. This can result
in both the code path doing v9fs_fid_add which results in v9fs_dentry leak.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c      |    4 +---
 fs/9p/vfs_inode_dotl.c |    8 ++++----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index cbba7c7..6d2278f 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -645,13 +645,11 @@ v9fs_create(struct v9fs_session_info *v9ses, struct inode *dir,
 		P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n", err);
 		goto error;
 	}
-	d_instantiate(dentry, inode);
 	err = v9fs_fid_add(dentry, fid);
 	if (err < 0)
 		goto error;
-
+	d_instantiate(dentry, inode);
 	return ofid;
-
 error:
 	if (ofid)
 		p9_client_clunk(ofid);
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 185ce37..0a17235 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -281,10 +281,10 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 		P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n", err);
 		goto error;
 	}
-	d_instantiate(dentry, inode);
 	err = v9fs_fid_add(dentry, fid);
 	if (err < 0)
 		goto error;
+	d_instantiate(dentry, inode);
 
 	/* Now set the ACL based on the default value */
 	v9fs_set_create_acl(dentry, &dacl, &pacl);
@@ -403,10 +403,10 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
 				err);
 			goto error;
 		}
-		d_instantiate(dentry, inode);
 		err = v9fs_fid_add(dentry, fid);
 		if (err < 0)
 			goto error;
+		d_instantiate(dentry, inode);
 		fid = NULL;
 	} else {
 		/*
@@ -657,10 +657,10 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
 					err);
 			goto error;
 		}
-		d_instantiate(dentry, inode);
 		err = v9fs_fid_add(dentry, fid);
 		if (err < 0)
 			goto error;
+		d_instantiate(dentry, inode);
 		fid = NULL;
 	} else {
 		/* Not in cached mode. No need to populate inode with stat */
@@ -810,10 +810,10 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int omode,
 				err);
 			goto error;
 		}
-		d_instantiate(dentry, inode);
 		err = v9fs_fid_add(dentry, fid);
 		if (err < 0)
 			goto error;
+		d_instantiate(dentry, inode);
 		fid = NULL;
 	} else {
 		/*
-- 
1.7.4.1

