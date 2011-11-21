Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab1KUTUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:20:21 -0500
Received: from mail-yw0-f74.google.com ([209.85.213.74]:36874 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab1KUTUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:20:20 -0500
From: Thieu Le <thieule@chromium.org>
To: tyhicks@canonical.com, viro@zeniv.linux.org.uk, hch@infradead.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thieu Le <thieule@chromium.org>
Subject: Re: [PATCH] vfs: Export fallocate facility to kernel modules
Date: Mon, 21 Nov 2011 10:55:41 -0800
Message-Id: <1321901741-3647-1-git-send-email-thieule@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <20111118195338.GC9869@boyd>
References: <20111118195338.GC9869@boyd>
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
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
---
 fs/open.c          |   32 ++++++++++++++++++++------------
 include/linux/fs.h |    2 ++
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 22c41b5..65c0049 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -214,13 +214,9 @@ SYSCALL_ALIAS(sys_ftruncate64, SyS_ftruncate64);
 #endif /* BITS_PER_LONG == 32 */
 
 
-int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
+int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
-	long ret;
-
-	if (offset < 0 || len <= 0)
-		return -EINVAL;
 
 	/* Return error if mode is not supported */
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
@@ -231,13 +227,28 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	    !(mode & FALLOC_FL_KEEP_SIZE))
 		return -EOPNOTSUPP;
 
-	if (!(file->f_mode & FMODE_WRITE))
-		return -EBADF;
-
 	/* It's not possible punch hole on append only file */
 	if (mode & FALLOC_FL_PUNCH_HOLE && IS_APPEND(inode))
 		return -EPERM;
 
+	if (!file->f_op->fallocate)
+		return -EOPNOTSUPP;
+
+	return file->f_op->fallocate(file, mode, offset, len);
+}
+EXPORT_SYMBOL(vfs_fallocate);
+
+int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	long ret;
+
+	if (offset < 0 || len <= 0)
+		return -EINVAL;
+
+	if (!(file->f_mode & FMODE_WRITE))
+		return -EBADF;
+
 	if (IS_IMMUTABLE(inode))
 		return -EPERM;
 
@@ -263,10 +274,7 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
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
index 0c4df26..e7d26ee 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1524,6 +1524,8 @@ extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+extern int vfs_fallocate(struct file *file, int mode, loff_t offset,
+			 loff_t len);
 
 /*
  * VFS dentry helper functions.
-- 
1.7.3.1

