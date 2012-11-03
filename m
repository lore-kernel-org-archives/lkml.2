Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab2KCJiF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 05:38:05 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62467 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab2KCJiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 05:38:02 -0400
Message-ID: <5094E46E.4050903@gmail.com>
Date: Sat, 03 Nov 2012 10:31:26 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 18/21] ntfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/ntfs/file.c  |   16 +++++++++++++---
 fs/ntfs/inode.c |    8 ++++++--
 fs/ntfs/inode.h |    4 ++++
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 1ecf464..5b2d4f0 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -1762,6 +1762,16 @@ err_out:
 	return err;
 }
 
+static void ntfs_write_failed(struct address_space *mapping, loff_t to)
+{
+	struct inode *inode = mapping->host;
+
+	if (to > inode->i_size) {
+		truncate_pagecache(inode, to, inode->i_size);
+		ntfs_truncate_vfs(inode);
+	}
+}
+
 /**
  * ntfs_file_buffered_write -
  *
@@ -2022,8 +2032,9 @@ static ssize_t ntfs_file_buffered_write(struct kiocb *iocb,
 				 * allocated space, which is not a disaster.
 				 */
 				i_size = i_size_read(vi);
-				if (pos + bytes > i_size)
-					vmtruncate(vi, i_size);
+				if (pos + bytes > i_size) {
+					ntfs_write_failed(mapping, pos + bytes);
+				}
 				break;
 			}
 		}
@@ -2227,7 +2238,6 @@ const struct file_operations ntfs_file_ops = {
 
 const struct inode_operations ntfs_file_inode_ops = {
 #ifdef NTFS_RW
-	.truncate	= ntfs_truncate_vfs,
 	.setattr	= ntfs_setattr,
 #endif /* NTFS_RW */
 };
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 1d27331..d3e118c 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -2866,9 +2866,11 @@ conv_err_out:
  *
  * See ntfs_truncate() description above for details.
  */
+#ifdef NTFS_RW
 void ntfs_truncate_vfs(struct inode *vi) {
 	ntfs_truncate(vi);
 }
+#endif
 
 /**
  * ntfs_setattr - called from notify_change() when an attribute is being changed
@@ -2914,8 +2916,10 @@ int ntfs_setattr(struct dentry *dentry, struct iattr *attr)
 						NInoCompressed(ni) ?
 						"compressed" : "encrypted");
 				err = -EOPNOTSUPP;
-			} else
-				err = vmtruncate(vi, attr->ia_size);
+			} else {
+				truncate_setsize(vi, attr->ia_size);
+				ntfs_truncate_vfs(vi);
+			}
 			if (err || ia_valid == ATTR_SIZE)
 				goto out;
 		} else {
diff --git a/fs/ntfs/inode.h b/fs/ntfs/inode.h
index db29695..76b6cfb 100644
--- a/fs/ntfs/inode.h
+++ b/fs/ntfs/inode.h
@@ -316,6 +316,10 @@ static inline void ntfs_commit_inode(struct inode *vi)
 	return;
 }
 
+#else
+
+static inline void ntfs_truncate_vfs(struct inode *vi) {}
+
 #endif /* NTFS_RW */
 
 #endif /* _LINUX_NTFS_INODE_H */
-- 
1.7.3.4
