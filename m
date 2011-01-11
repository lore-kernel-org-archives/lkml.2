Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab1AKPtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:49:50 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:48391 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192Ab1AKPts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:49:48 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] fs/9p: Don't set dentry->d_op in create routines
Date: Tue, 11 Jan 2011 21:19:42 +0530
Message-Id: <1294760982-26732-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do set dentry->d_op in lookup even in case of ENOENT entries.
That implies we should have dentry->d_op already set when
create/mkdir/mknod/link/symlink routines are called

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c      |    6 ------
 fs/9p/vfs_inode_dotl.c |   13 -------------
 2 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 3923586..5076eeb 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -537,12 +537,6 @@ v9fs_create(struct v9fs_session_info *v9ses, struct inode *dir,
 		P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n", err);
 		goto error;
 	}
-
-	if (v9ses->cache)
-		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
-	else
-		d_set_d_op(dentry, &v9fs_dentry_operations);
-
 	d_instantiate(dentry, inode);
 	err = v9fs_fid_add(dentry, fid);
 	if (err < 0)
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index b7f8dcb..8cb1eb8 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -211,11 +211,6 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 		P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n", err);
 		goto error;
 	}
-	if (v9ses->cache)
-		dentry->d_op = &v9fs_cached_dentry_operations;
-	else
-		dentry->d_op = &v9fs_dentry_operations;
-
 	d_instantiate(dentry, inode);
 	err = v9fs_fid_add(dentry, fid);
 	if (err < 0)
@@ -312,7 +307,6 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
 				err);
 			goto error;
 		}
-		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
 		d_instantiate(dentry, inode);
 		err = v9fs_fid_add(dentry, fid);
 		if (err < 0)
@@ -329,7 +323,6 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
 			err = PTR_ERR(inode);
 			goto error;
 		}
-		d_set_d_op(dentry, &v9fs_dentry_operations);
 		d_instantiate(dentry, inode);
 	}
 	/* Now set the ACL based on the default value */
@@ -560,7 +553,6 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
 					err);
 			goto error;
 		}
-		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
 		d_instantiate(dentry, inode);
 		err = v9fs_fid_add(dentry, fid);
 		if (err < 0)
@@ -573,7 +565,6 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
 			err = PTR_ERR(inode);
 			goto error;
 		}
-		d_set_d_op(dentry, &v9fs_dentry_operations);
 		d_instantiate(dentry, inode);
 	}
 
@@ -648,8 +639,6 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 		 */
 		ihold(old_dentry->d_inode);
 	}
-
-	d_set_d_op(dentry, old_dentry->d_op);
 	d_instantiate(dentry, old_dentry->d_inode);
 
 	return err;
@@ -728,7 +717,6 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int omode,
 				err);
 			goto error;
 		}
-		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
 		d_instantiate(dentry, inode);
 		err = v9fs_fid_add(dentry, fid);
 		if (err < 0)
@@ -744,7 +732,6 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int omode,
 			err = PTR_ERR(inode);
 			goto error;
 		}
-		d_set_d_op(dentry, &v9fs_dentry_operations);
 		d_instantiate(dentry, inode);
 	}
 	/* Now set the ACL based on the default value */
-- 
1.7.1

