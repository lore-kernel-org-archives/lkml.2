Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1BERsN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:48:13 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:53000 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab1BERrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:47:22 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V2 14/17] fs/9p: Don't set stat.st_blocks based on nrpages
Date: Sat,  5 Feb 2011 23:16:42 +0530
Message-Id: <1296928005-9529-15-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simple_getattr does set stat.st_blocks to a value
derived from nrpages. That is not correct with 9p

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c      |    7 ++++---
 fs/9p/vfs_inode_dotl.c |    7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 472d447..8cf88eb 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -902,9 +902,10 @@ v9fs_vfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	P9_DPRINTK(P9_DEBUG_VFS, "dentry: %p\n", dentry);
 	err = -EPERM;
 	v9ses = v9fs_inode2v9ses(dentry->d_inode);
-	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE)
-		return simple_getattr(mnt, dentry, stat);
-
+	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE) {
+		generic_fillattr(dentry->d_inode, stat);
+		return 0;
+	}
 	fid = v9fs_fid_lookup(dentry);
 	if (IS_ERR(fid))
 		return PTR_ERR(fid);
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index a11e04a..4f27fee 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -399,9 +399,10 @@ v9fs_vfs_getattr_dotl(struct vfsmount *mnt, struct dentry *dentry,
 	P9_DPRINTK(P9_DEBUG_VFS, "dentry: %p\n", dentry);
 	err = -EPERM;
 	v9ses = v9fs_inode2v9ses(dentry->d_inode);
-	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE)
-		return simple_getattr(mnt, dentry, stat);
-
+	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE) {
+		generic_fillattr(dentry->d_inode, stat);
+		return 0;
+	}
 	fid = v9fs_fid_lookup(dentry);
 	if (IS_ERR(fid))
 		return PTR_ERR(fid);
-- 
1.7.1

