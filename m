Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab0KFRrj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 13:47:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57768 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab0KFRrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 13:47:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=cR4LLFhb8U8197czekrr7Ri/qQHvdudCK4ifUt3cpm3auZ4Fvobh/1Bvxvc4pCpbwm
         VA0uhoMt7TAJoyYvNU1uEy9vi7W/YZ4OMqD6JjcgS6uEIDgeB7mNLmHS706dWcFyphkg
         bPFuQUtjKeeZU0YkgYAYbYnPuzW6umxRFsqkE=
From: Alessio Igor Bogani <abogani@texware.it>
To: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 4/4] udf: Replace bkl with a mutex for protect udf_sb_info struct
Date: Sat,  6 Nov 2010 18:47:11 +0100
Message-Id: <1289065631-2256-4-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1289065631-2256-1-git-send-email-abogani@texware.it>
References: <1289065631-2256-1-git-send-email-abogani@texware.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace bkl with a mutex in udf_ioctl, udf_remount_fs and  udf_fill_super
functions.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/udf/file.c   |    7 +++----
 fs/udf/super.c  |   15 +++++++--------
 fs/udf/udf_sb.h |    3 +++
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index 688e6ea..aa36fce 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -32,7 +32,6 @@
 #include <linux/string.h> /* memset */
 #include <linux/capability.h>
 #include <linux/errno.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
@@ -149,8 +148,7 @@ long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	struct inode *inode = filp->f_dentry->d_inode;
 	long old_block, new_block;
 	int result = -EINVAL;
-
-	lock_kernel();
+	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
 
 	if (file_permission(filp, MAY_READ) != 0) {
 		udf_debug("no permission to access inode %lu\n", inode->i_ino);
@@ -181,8 +179,10 @@ long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			result = -EFAULT;
 			goto out;
 		}
+		mutex_lock(&sbi->lock);
 		result = udf_relocate_blocks(inode->i_sb,
 						old_block, &new_block);
+		mutex_unlock(&sbi->lock);
 		if (result == 0)
 			result = put_user(new_block, (long __user *)arg);
 		goto out;
@@ -197,7 +197,6 @@ long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 
 out:
-	unlock_kernel();
 	return result;
 }
 
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 615859b..49e7b88 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -48,7 +48,6 @@
 #include <linux/stat.h>
 #include <linux/cdrom.h>
 #include <linux/nls.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
@@ -570,7 +569,7 @@ static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
 	if (!udf_parse_options(options, &uopt, true))
 		return -EINVAL;
 
-	lock_kernel();
+	mutex_lock(&sbi->lock);
 	sbi->s_flags = uopt.flags;
 	sbi->s_uid   = uopt.uid;
 	sbi->s_gid   = uopt.gid;
@@ -593,7 +592,7 @@ static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
 		udf_open_lvid(sb);
 
 out_unlock:
-	unlock_kernel();
+	mutex_unlock(&sbi->lock);
 	return error;
 }
 
@@ -1886,8 +1885,6 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	struct kernel_lb_addr rootdir, fileset;
 	struct udf_sb_info *sbi;
 
-	lock_kernel();
-
 	uopt.flags = (1 << UDF_FLAG_USE_AD_IN_ICB) | (1 << UDF_FLAG_STRICT);
 	uopt.uid = -1;
 	uopt.gid = -1;
@@ -1897,10 +1894,12 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 
 	sbi = kzalloc(sizeof(struct udf_sb_info), GFP_KERNEL);
 	if (!sbi) {
-		unlock_kernel();
 		return -ENOMEM;
 	}
 
+	mutex_init(&sbi->lock);
+	mutex_lock(&sbi->lock);
+
 	sb->s_fs_info = sbi;
 
 	mutex_init(&sbi->s_alloc_mutex);
@@ -2045,7 +2044,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 		goto error_out;
 	}
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
-	unlock_kernel();
+	mutex_unlock(&sbi->lock);
 	return 0;
 
 error_out:
@@ -2066,7 +2065,7 @@ error_out:
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 
-	unlock_kernel();
+	mutex_unlock(&sbi->lock);
 	return -EINVAL;
 }
 
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index d113b72..fd0dc81 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -150,6 +150,9 @@ struct udf_sb_info {
 	struct mutex		s_alloc_mutex;
 	/* Protected by s_alloc_mutex */
 	unsigned int		s_lvid_dirty;
+
+	/* Serialize writer access, replace the old bkl */
+	struct mutex lock;
 };
 
 static inline struct udf_sb_info *UDF_SB(struct super_block *sb)
-- 
1.7.0.4

