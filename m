Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935666Ab1ETS4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:56:42 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:50681 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935041Ab1ETS4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:56:41 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/2] fs/9p: Don't clunk dentry fid when we fail to get a writeback inode
Date: Sat, 21 May 2011 00:25:51 +0530
Message-Id: <1305917752-16539-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dentry fid get clunked via the dput.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode_dotl.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 82a7c38..691c78f 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -259,7 +259,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 		if (IS_ERR(inode_fid)) {
 			err = PTR_ERR(inode_fid);
 			mutex_unlock(&v9inode->v_mutex);
-			goto error;
+			goto err_clunk_old_fid;
 		}
 		v9inode->writeback_fid = (void *) inode_fid;
 	}
@@ -267,8 +267,8 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 	/* Since we are opening a file, assign the open fid to the file */
 	filp = lookup_instantiate_filp(nd, dentry, generic_file_open);
 	if (IS_ERR(filp)) {
-		p9_client_clunk(ofid);
-		return PTR_ERR(filp);
+		err = PTR_ERR(filp);
+		goto err_clunk_old_fid;
 	}
 	filp->private_data = ofid;
 #ifdef CONFIG_9P_FSCACHE
@@ -278,10 +278,11 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 	return 0;
 
 error:
-	if (ofid)
-		p9_client_clunk(ofid);
 	if (fid)
 		p9_client_clunk(fid);
+err_clunk_old_fid:
+	if (ofid)
+		p9_client_clunk(ofid);
 	return err;
 }
 
-- 
1.7.4.1

