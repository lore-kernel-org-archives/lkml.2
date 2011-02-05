Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab1BERrA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:47:00 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:39050 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab1BERq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:46:58 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V2 02/17] fs/9p: set fs cache cookie in create path also
Date: Sat,  5 Feb 2011 23:16:30 +0530
Message-Id: <1296928005-9529-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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
index 45e7ea4..ce56571 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -607,6 +607,10 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 		}
 
 		filp->private_data = fid;
+#ifdef CONFIG_9P_FSCACHE
+		if (v9ses->cache)
+			v9fs_cache_inode_set_cookie(dentry->d_inode, filp);
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

