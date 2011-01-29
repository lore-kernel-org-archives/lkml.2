Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab1A2T0k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 14:26:40 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:50618 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab1A2T0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 14:26:38 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V1 1/7] fs/9p: set the cached file_operations struct during inode init
Date: Sun, 30 Jan 2011 00:56:20 +0530
Message-Id: <1296329186-23807-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296329186-23807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296329186-23807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the old code we were not setting the file->f_op
with cached file operations during creat.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/v9fs_vfs.h  |    2 ++
 fs/9p/vfs_file.c  |   18 ++++--------------
 fs/9p/vfs_inode.c |   10 ++++++++--
 3 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index b789f8e..e4d5540 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -45,6 +45,8 @@ extern const struct file_operations v9fs_dir_operations;
 extern const struct file_operations v9fs_dir_operations_dotl;
 extern const struct dentry_operations v9fs_dentry_operations;
 extern const struct dentry_operations v9fs_cached_dentry_operations;
+extern const struct file_operations v9fs_cached_file_operations;
+extern const struct file_operations v9fs_cached_file_operations_dotl;
 
 #ifdef CONFIG_9P_FSCACHE
 struct inode *v9fs_alloc_inode(struct super_block *sb);
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 240c306..6a67100 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -44,9 +44,6 @@
 #include "fid.h"
 #include "cache.h"
 
-static const struct file_operations v9fs_cached_file_operations;
-static const struct file_operations v9fs_cached_file_operations_dotl;
-
 /**
  * v9fs_file_open - open a file (or directory)
  * @inode: inode to be opened
@@ -89,19 +86,12 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 	}
 
 	file->private_data = fid;
+#ifdef CONFIG_9P_FSCACHE
 	if ((fid->qid.version) && (v9ses->cache)) {
 		P9_DPRINTK(P9_DEBUG_VFS, "cached");
-		/* enable cached file options */
-		if(file->f_op == &v9fs_file_operations)
-			file->f_op = &v9fs_cached_file_operations;
-		else if (file->f_op == &v9fs_file_operations_dotl)
-			file->f_op = &v9fs_cached_file_operations_dotl;
-
-#ifdef CONFIG_9P_FSCACHE
 		v9fs_cache_inode_set_cookie(inode, file);
-#endif
 	}
-
+#endif
 	return 0;
 }
 
@@ -505,7 +495,7 @@ int v9fs_file_fsync_dotl(struct file *filp, int datasync)
 	return retval;
 }
 
-static const struct file_operations v9fs_cached_file_operations = {
+const struct file_operations v9fs_cached_file_operations = {
 	.llseek = generic_file_llseek,
 	.read = do_sync_read,
 	.aio_read = generic_file_aio_read,
@@ -517,7 +507,7 @@ static const struct file_operations v9fs_cached_file_operations = {
 	.fsync = v9fs_file_fsync,
 };
 
-static const struct file_operations v9fs_cached_file_operations_dotl = {
+const struct file_operations v9fs_cached_file_operations_dotl = {
 	.llseek = generic_file_llseek,
 	.read = do_sync_read,
 	.aio_read = generic_file_aio_read,
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index b76a40b..45e7ea4 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -292,10 +292,16 @@ struct inode *v9fs_get_inode(struct super_block *sb, int mode)
 	case S_IFREG:
 		if (v9fs_proto_dotl(v9ses)) {
 			inode->i_op = &v9fs_file_inode_operations_dotl;
-			inode->i_fop = &v9fs_file_operations_dotl;
+			if (v9ses->cache)
+				inode->i_fop = &v9fs_cached_file_operations_dotl;
+			else
+				inode->i_fop = &v9fs_file_operations_dotl;
 		} else {
 			inode->i_op = &v9fs_file_inode_operations;
-			inode->i_fop = &v9fs_file_operations;
+			if (v9ses->cache)
+				inode->i_fop = &v9fs_cached_file_operations;
+			else
+				inode->i_fop = &v9fs_file_operations;
 		}
 
 		break;
-- 
1.7.1

