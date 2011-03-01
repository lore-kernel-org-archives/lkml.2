Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab1CAIvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:51:38 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:55090 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab1CAIve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:51:34 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/6] fs/9p: Properly update inode attributes on link
Date: Tue,  1 Mar 2011 14:21:19 +0530
Message-Id: <1298969484-16199-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With caching enabled, we need to make sure we don't
update inode->i_size via stat2inode because we could
have dirty data which is not yet written to the server

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c      |    4 +++-
 fs/9p/vfs_inode_dotl.c |   10 +---------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index e5cd2c4..64f2e4e 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1295,8 +1295,10 @@ v9fs_vfs_link(struct dentry *old_dentry, struct inode *dir,
 	sprintf(name, "%d\n", oldfid->fid);
 	retval = v9fs_vfs_mkspecial(dir, dentry, P9_DMLINK, name);
 	__putname(name);
-	if (!retval)
+	if (!retval) {
+		v9fs_refresh_inode(oldfid, old_dentry->d_inode);
 		v9fs_invalidate_inode_attr(dir);
+	}
 clunk_fid:
 	p9_client_clunk(oldfid);
 	return retval;
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 5d66a21..2826026 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -674,19 +674,11 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE) {
 		/* Get the latest stat info from server. */
 		struct p9_fid *fid;
-		struct p9_stat_dotl *st;
-
 		fid = v9fs_fid_lookup(old_dentry);
 		if (IS_ERR(fid))
 			return PTR_ERR(fid);
 
-		st = p9_client_getattr_dotl(fid, P9_STATS_BASIC);
-		if (IS_ERR(st))
-			return PTR_ERR(st);
-
-		v9fs_stat2inode_dotl(st, old_dentry->d_inode);
-
-		kfree(st);
+		v9fs_refresh_inode_dotl(fid, old_dentry->d_inode);
 	}
 	ihold(old_dentry->d_inode);
 	d_instantiate(dentry, old_dentry->d_inode);
-- 
1.7.1

