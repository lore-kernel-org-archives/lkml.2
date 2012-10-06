Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab2JFImZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:42:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33475 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab2JFImU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:42:20 -0400
Message-ID: <506FED58.7050700@gmail.com>
Date: Sat, 06 Oct 2012 10:35:36 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 19/22] ntfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
Reviewed-by: Anton Altaparmakov <anton@tuxera.com>
---
 fs/ntfs/file.c  |    8 +++++---
 fs/ntfs/inode.c |   11 +++++++++--
 fs/ntfs/inode.h |    4 ++++
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 1ecf464..5332e90 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -2022,8 +2022,11 @@ static ssize_t ntfs_file_buffered_write(struct kiocb *iocb,
 				 * allocated space, which is not a disaster.
 				 */
 				i_size = i_size_read(vi);
-				if (pos + bytes > i_size)
-					vmtruncate(vi, i_size);
+				if ((pos + bytes > i_size) &&
+					inode_newsize_ok(vi, i_size) == 0) {
+					truncate_setsize(vi, i_size);
+					ntfs_truncate_vfs(vi);
+				}
 				break;
 			}
 		}
@@ -2227,7 +2230,6 @@ const struct file_operations ntfs_file_ops = {
 
 const struct inode_operations ntfs_file_inode_ops = {
 #ifdef NTFS_RW
-	.truncate	= ntfs_truncate_vfs,
 	.setattr	= ntfs_setattr,
 #endif /* NTFS_RW */
 };
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 1d27331..40e8137 100644
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
@@ -2914,8 +2916,13 @@ int ntfs_setattr(struct dentry *dentry, struct iattr *attr)
 						NInoCompressed(ni) ?
 						"compressed" : "encrypted");
 				err = -EOPNOTSUPP;
-			} else
-				err = vmtruncate(vi, attr->ia_size);
+			} else {
+				err = inode_newsize_ok(vi, attr->ia_size);
+				if (!err) {
+					truncate_setsize(vi, attr->ia_size);
+					ntfs_truncate_vfs(vi);
+				}
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
