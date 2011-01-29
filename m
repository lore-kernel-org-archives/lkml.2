Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab1A2T0q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 14:26:46 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:60763 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab1A2T0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 14:26:40 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V1 2/7] fs/9p: set fs cache cookie in create path also
Date: Sun, 30 Jan 2011 00:56:21 +0530
Message-Id: <1296329186-23807-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296329186-23807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296329186-23807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to call v9fs_cache_inode_set_cookie in create
path also

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_file.c       |    4 +---
 fs/9p/vfs_inode.c      |    4 ++++
 fs/9p/vfs_inode_dotl.c |    4 ++++
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 6a67100..ce1eae4 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -87,10 +87,8 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 
 	file->private_data = fid;
 #ifdef CONFIG_9P_FSCACHE
-	if ((fid->qid.version) && (v9ses->cache)) {
-		P9_DPRINTK(P9_DEBUG_VFS, "cached");
+	if (v9ses->cache)
 		v9fs_cache_inode_set_cookie(inode, file);
-	}
 #endif
 	return 0;
 }
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 45e7ea4..b6b939b 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -607,6 +607,10 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 		}
 
 		filp->private_data = fid;
+#ifdef CONFIG_9P_FSCACHE
+		if (v9ses->cache)
+			v9fs_cache_inode_set_cookie(inode, filp);
+#endif
 	} else
 		p9_client_clunk(fid);
 
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index fe3ffa9..fbe9572 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -226,6 +226,10 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 		return PTR_ERR(filp);
 	}
 	filp->private_data = ofid;
+#ifdef CONFIG_9P_FSCACHE
+	if (v9ses->cache)
+		v9fs_cache_inode_set_cookie(inode, filp);
+#endif
 	return 0;
 
 error:
-- 
1.7.1

