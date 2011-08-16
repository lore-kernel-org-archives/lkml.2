Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1HPQwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 12:52:13 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34086 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab1HPQwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 12:52:11 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] fs/9p: Always ask new inode in lookup for cache mode disabled
Date: Tue, 16 Aug 2011 22:21:04 +0530
Message-Id: <1313513464-8591-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This make sure we don't end up reusing the unlinked inode object.
The ideal way is to use inode i_generation. But i_generation is
not available in userspace always.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 9e3ea6c..b2a41e5 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -40,6 +40,7 @@
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 
+
 #include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "fid.h"
@@ -825,6 +826,7 @@ static int v9fs_vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 				      struct nameidata *nameidata)
 {
+	struct dentry *res;
 	struct super_block *sb;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *dfid, *fid;
@@ -856,22 +858,35 @@ struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 
 		return ERR_PTR(result);
 	}
-
-	inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
+	/*
+	 * Make sure we don't use a wrong inode due to parallel
+	 * unlink. For cached mode create calls request for new
+	 * inode. But with cache disabled, lookup should do this.
+	 */
+	if (v9ses->cache)
+		inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
+	else
+		inode = v9fs_get_new_inode_from_fid(v9ses, fid, dir->i_sb);
 	if (IS_ERR(inode)) {
 		result = PTR_ERR(inode);
 		inode = NULL;
 		goto error;
 	}
-
 	result = v9fs_fid_add(dentry, fid);
 	if (result < 0)
 		goto error_iput;
-
 inst_out:
-	d_add(dentry, inode);
-	return NULL;
-
+	/*
+	 * If we had a rename on the server and a parallel lookup
+	 * for the new name, then make sure we instantiate with
+	 * the new name. ie look up for a/b, while server somebody
+	 * moved b under k and client parallely did a lookup for
+	 * k/b.
+	 */
+	res = d_materialise_unique(dentry, inode);
+	if (!IS_ERR(res))
+		return res;
+	result = PTR_ERR(res);
 error_iput:
 	iput(inode);
 error:
-- 
1.7.4.1

