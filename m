Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab2AEIKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 03:10:18 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35912 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758123Ab2AEIKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 03:10:08 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/2] fs/9p: We should not allocate a new inode when creating hardlinks.
Date: Thu,  5 Jan 2012 13:39:50 +0530
Message-Id: <1325750990-8149-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8.1.362.g5d6df
In-Reply-To: <1325750990-8149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1325750990-8149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
x-cbid: 12010423-3568-0000-0000-0000010388FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Don't do new_inode_from fid in case of hardlink creation. This ensures
that link count for hardlink files get updated properly. Earlier link count
was not updated on removing a hardlink with cache mode enabled.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c |   43 ++++++++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index c330776..5dd0c46 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -678,26 +678,31 @@ v9fs_create(struct v9fs_session_info *v9ses, struct inode *dir,
 		goto error;
 	}
 
-	/* now walk from the parent so we can get unopened fid */
-	fid = p9_client_walk(dfid, 1, &name, 1);
-	if (IS_ERR(fid)) {
-		err = PTR_ERR(fid);
-		P9_DPRINTK(P9_DEBUG_VFS, "p9_client_walk failed %d\n", err);
-		fid = NULL;
-		goto error;
-	}
-
-	/* instantiate inode and assign the unopened fid to the dentry */
-	inode = v9fs_get_new_inode_from_fid(v9ses, fid, dir->i_sb);
-	if (IS_ERR(inode)) {
-		err = PTR_ERR(inode);
-		P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n", err);
-		goto error;
+	if (!(perm & P9_DMLINK)) {
+		/* now walk from the parent so we can get unopened fid */
+		fid = p9_client_walk(dfid, 1, &name, 1);
+		if (IS_ERR(fid)) {
+			err = PTR_ERR(fid);
+			P9_DPRINTK(P9_DEBUG_VFS,
+				   "p9_client_walk failed %d\n", err);
+			fid = NULL;
+			goto error;
+		}
+		/*
+		 * instantiate inode and assign the unopened fid to the dentry
+		 */
+		inode = v9fs_get_new_inode_from_fid(v9ses, fid, dir->i_sb);
+		if (IS_ERR(inode)) {
+			err = PTR_ERR(inode);
+			P9_DPRINTK(P9_DEBUG_VFS,
+				   "inode creation failed %d\n", err);
+			goto error;
+		}
+		err = v9fs_fid_add(dentry, fid);
+		if (err < 0)
+			goto error;
+		d_instantiate(dentry, inode);
 	}
-	err = v9fs_fid_add(dentry, fid);
-	if (err < 0)
-		goto error;
-	d_instantiate(dentry, inode);
 	return ofid;
 error:
 	if (ofid)
-- 
1.7.8.1.362.g5d6df

