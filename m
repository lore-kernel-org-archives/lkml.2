Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116Ab1JaTO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:14:27 -0400
Received: from smtp-out.google.com ([74.125.121.67]:49946 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236Ab1JaTO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:14:26 -0400
From: Thieu Le <thieule@chromium.org>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thieu Le <thieule@chromium.org>
Subject: [PATCH] vfs: Export fallocate facility to kernel modules
Date: Mon, 31 Oct 2011 12:14:05 -0700
Message-Id: <1320088445-12373-1-git-send-email-thieule@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export fallocate facility so layered file systems such as ecryptfs can
take advantage of this feature.  One example of the need for fallocate
is by ecryptfs.  ecryptfs has recently switched to a writeback cache
model so its dirty pages are not written to the lower file system
immediately.  In order to ensure that space is available when the page
is later written, ecryptfs can efficiently preallocate that space using
vfs_fallocate().

vfs_fallocate() does not perform all of the checkings of do_fallocate()
because those checks are done higher in the stack.  Checking of offset and
len are done by rw_verify_area() and generic_write_checks().  These
functions are called by VFS before ecryptfs invokes vfs_fallocate() in its
ecryptfs_write_end() function.  And since ecryptfs directly opens the lower
file, it ensures that the file is opened with the proper flags and mode.

Signed-off-by: Thieu Le <thieule@chromium.org>
---
 fs/open.c          |   14 ++++++++++----
 include/linux/fs.h |    2 ++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index f711921..8a4ba20 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -214,6 +214,15 @@ SYSCALL_ALIAS(sys_ftruncate64, SyS_ftruncate64);
 #endif /* BITS_PER_LONG == 32 */
 
 
+int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
+{
+	if (!file->f_op->fallocate)
+		return -EOPNOTSUPP;
+
+	return file->f_op->fallocate(file, mode, offset, len);
+}
+EXPORT_SYMBOL(vfs_fallocate);
+
 int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -263,10 +272,7 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
 		return -EFBIG;
 
-	if (!file->f_op->fallocate)
-		return -EOPNOTSUPP;
-
-	return file->f_op->fallocate(file, mode, offset, len);
+	return vfs_fallocate(file, mode, offset, len);
 }
 
 SYSCALL_DEFINE(fallocate)(int fd, int mode, loff_t offset, loff_t len)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 277f497..c0e1225 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1504,6 +1504,8 @@ extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+extern int vfs_fallocate(struct file *file, int mode, loff_t offset,
+			 loff_t len);
 
 /*
  * VFS dentry helper functions.
-- 
1.7.3.1

