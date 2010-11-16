Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442Ab0KPXF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:05:28 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57817 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315Ab0KPXFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:05:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ODTp0rf+8HdHriI8x90eIqBS9iG/2lOxwBTQrMcyckhfUigUERhQogJ/B+0EWIHgnG
         lqaQ4dPan095BsbUCz0XRE/YCZBRH4zjD3ESKqpGwYYg4G6XQ9/y4yxHcQqQMV0ZoQg/
         /Kw7d09kmIERldhrr6UcU6zTAZYp0VAREp2FY=
From: Alessio Igor Bogani <abogani@texware.it>
To: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 3/3] udf: Remove unnecessary bkl usages
Date: Wed, 17 Nov 2010 00:04:27 +0100
Message-Id: <1289948667-2197-3-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20101116180544.GA29896@infradead.org>
References: <20101116180544.GA29896@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The udf_readdir(), udf_lookup(), udf_create(), udf_mknod(), udf_mkdir(),
udf_rmdir(), udf_link(), udf_get_parent() and udf_unlink() seems already
adequately protected by i_mutex held by VFS invoking calls. The udf_rename()
instead should be already protected by lock_rename again by VFS. The
udf_truncate() is protected by ii_alloc_sem. The udf_ioctl(), udf_fill_super()
and udf_evict_inode() don't requires any further protection.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/udf/dir.c   |    5 -----
 fs/udf/file.c  |    4 ----
 fs/udf/inode.c |    6 ------
 fs/udf/namei.c |   27 ---------------------------
 fs/udf/super.c |    9 +--------
 5 files changed, 1 insertions(+), 50 deletions(-)

diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 51552bf..eb8bfe2 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -30,7 +30,6 @@
 #include <linux/errno.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 
 #include "udf_i.h"
@@ -190,18 +189,14 @@ static int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	struct inode *dir = filp->f_path.dentry->d_inode;
 	int result;
 
-	lock_kernel();
-
 	if (filp->f_pos == 0) {
 		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR) < 0) {
-			unlock_kernel();
 			return 0;
 		}
 		filp->f_pos++;
 	}
 
 	result = do_udf_readdir(dir, filp, filldir, dirent);
-	unlock_kernel();
  	return result;
 }
 
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 5724eca..b20e429 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -32,7 +32,6 @@
 #include <linux/string.h> /* memset */
 #include <linux/capability.h>
 #include <linux/errno.h>
-#include <linux/smp_lock.h>
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
 #include <linux/aio.h>
@@ -149,8 +148,6 @@ long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	long old_block, new_block;
 	int result = -EINVAL;
 
-	lock_kernel();
-
 	if (file_permission(filp, MAY_READ) != 0) {
 		udf_debug("no permission to access inode %lu\n", inode->i_ino);
 		result = -EPERM;
@@ -196,7 +193,6 @@ long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 
 out:
-	unlock_kernel();
 	return result;
 }
 
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index b7e5089..b9df673 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -31,7 +31,6 @@
 
 #include "udfdecl.h"
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
@@ -98,9 +97,7 @@ void udf_evict_inode(struct inode *inode)
 	kfree(iinfo->i_ext.i_data);
 	iinfo->i_ext.i_data = NULL;
 	if (want_delete) {
-		lock_kernel();
 		udf_free_inode(inode);
-		unlock_kernel();
 	}
 }
 
@@ -1024,7 +1021,6 @@ void udf_truncate(struct inode *inode)
 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
 		return;
 
-	lock_kernel();
 	iinfo = UDF_I(inode);
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 		if (inode->i_sb->s_blocksize <
@@ -1033,7 +1029,6 @@ void udf_truncate(struct inode *inode)
 			udf_expand_file_adinicb(inode, inode->i_size, &err);
 			if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 				inode->i_size = iinfo->i_lenAlloc;
-				unlock_kernel();
 				return;
 			} else
 				udf_truncate_extents(inode);
@@ -1055,7 +1050,6 @@ void udf_truncate(struct inode *inode)
 		udf_sync_inode(inode);
 	else
 		mark_inode_dirty(inode);
-	unlock_kernel();
 }
 
 static void __udf_read_inode(struct inode *inode)
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index d7d3d01..14384e9 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -27,7 +27,6 @@
 #include <linux/errno.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/sched.h>
 #include <linux/crc-itu-t.h>
@@ -263,7 +262,6 @@ static struct dentry *udf_lookup(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_name.len > UDF_NAME_LEN - 2)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	lock_kernel();
 #ifdef UDF_RECOVERY
 	/* temporary shorthand for specifying files by inode number */
 	if (!strncmp(dentry->d_name.name, ".B=", 3)) {
@@ -275,7 +273,6 @@ static struct dentry *udf_lookup(struct inode *dir, struct dentry *dentry,
 		};
 		inode = udf_iget(dir->i_sb, lb);
 		if (!inode) {
-			unlock_kernel();
 			return ERR_PTR(-EACCES);
 		}
 	} else
@@ -291,11 +288,9 @@ static struct dentry *udf_lookup(struct inode *dir, struct dentry *dentry,
 		loc = lelb_to_cpu(cfi.icb.extLocation);
 		inode = udf_iget(dir->i_sb, &loc);
 		if (!inode) {
-			unlock_kernel();
 			return ERR_PTR(-EACCES);
 		}
 	}
-	unlock_kernel();
 
 	return d_splice_alias(inode, dentry);
 }
@@ -562,10 +557,8 @@ static int udf_create(struct inode *dir, struct dentry *dentry, int mode,
 	int err;
 	struct udf_inode_info *iinfo;
 
-	lock_kernel();
 	inode = udf_new_inode(dir, mode, &err);
 	if (!inode) {
-		unlock_kernel();
 		return err;
 	}
 
@@ -583,7 +576,6 @@ static int udf_create(struct inode *dir, struct dentry *dentry, int mode,
 		inode->i_nlink--;
 		mark_inode_dirty(inode);
 		iput(inode);
-		unlock_kernel();
 		return err;
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
@@ -596,7 +588,6 @@ static int udf_create(struct inode *dir, struct dentry *dentry, int mode,
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
-	unlock_kernel();
 	d_instantiate(dentry, inode);
 
 	return 0;
@@ -614,7 +605,6 @@ static int udf_mknod(struct inode *dir, struct dentry *dentry, int mode,
 	if (!old_valid_dev(rdev))
 		return -EINVAL;
 
-	lock_kernel();
 	err = -EIO;
 	inode = udf_new_inode(dir, mode, &err);
 	if (!inode)
@@ -627,7 +617,6 @@ static int udf_mknod(struct inode *dir, struct dentry *dentry, int mode,
 		inode->i_nlink--;
 		mark_inode_dirty(inode);
 		iput(inode);
-		unlock_kernel();
 		return err;
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
@@ -646,7 +635,6 @@ static int udf_mknod(struct inode *dir, struct dentry *dentry, int mode,
 	err = 0;
 
 out:
-	unlock_kernel();
 	return err;
 }
 
@@ -659,7 +647,6 @@ static int udf_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	struct udf_inode_info *dinfo = UDF_I(dir);
 	struct udf_inode_info *iinfo;
 
-	lock_kernel();
 	err = -EMLINK;
 	if (dir->i_nlink >= (256 << sizeof(dir->i_nlink)) - 1)
 		goto out;
@@ -712,7 +699,6 @@ static int udf_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	err = 0;
 
 out:
-	unlock_kernel();
 	return err;
 }
 
@@ -794,7 +780,6 @@ static int udf_rmdir(struct inode *dir, struct dentry *dentry)
 	struct kernel_lb_addr tloc;
 
 	retval = -ENOENT;
-	lock_kernel();
 	fi = udf_find_entry(dir, &dentry->d_name, &fibh, &cfi);
 	if (!fi)
 		goto out;
@@ -826,7 +811,6 @@ end_rmdir:
 	brelse(fibh.sbh);
 
 out:
-	unlock_kernel();
 	return retval;
 }
 
@@ -840,7 +824,6 @@ static int udf_unlink(struct inode *dir, struct dentry *dentry)
 	struct kernel_lb_addr tloc;
 
 	retval = -ENOENT;
-	lock_kernel();
 	fi = udf_find_entry(dir, &dentry->d_name, &fibh, &cfi);
 	if (!fi)
 		goto out;
@@ -870,7 +853,6 @@ end_unlink:
 	brelse(fibh.sbh);
 
 out:
-	unlock_kernel();
 	return retval;
 }
 
@@ -1049,15 +1031,12 @@ static int udf_link(struct dentry *old_dentry, struct inode *dir,
 	struct fileIdentDesc cfi, *fi;
 	int err;
 
-	lock_kernel();
 	if (inode->i_nlink >= (256 << sizeof(inode->i_nlink)) - 1) {
-		unlock_kernel();
 		return -EMLINK;
 	}
 
 	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
 	if (!fi) {
-		unlock_kernel();
 		return err;
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
@@ -1078,7 +1057,6 @@ static int udf_link(struct dentry *old_dentry, struct inode *dir,
 	mark_inode_dirty(inode);
 	ihold(inode);
 	d_instantiate(dentry, inode);
-	unlock_kernel();
 
 	return 0;
 }
@@ -1099,7 +1077,6 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct kernel_lb_addr tloc;
 	struct udf_inode_info *old_iinfo = UDF_I(old_inode);
 
-	lock_kernel();
 	ofi = udf_find_entry(old_dir, &old_dentry->d_name, &ofibh, &ocfi);
 	if (ofi) {
 		if (ofibh.sbh != ofibh.ebh)
@@ -1223,7 +1200,6 @@ end_rename:
 			brelse(nfibh.ebh);
 		brelse(nfibh.sbh);
 	}
-	unlock_kernel();
 
 	return retval;
 }
@@ -1236,7 +1212,6 @@ static struct dentry *udf_get_parent(struct dentry *child)
 	struct fileIdentDesc cfi;
 	struct udf_fileident_bh fibh;
 
-	lock_kernel();
 	if (!udf_find_entry(child->d_inode, &dotdot, &fibh, &cfi))
 		goto out_unlock;
 
@@ -1248,11 +1223,9 @@ static struct dentry *udf_get_parent(struct dentry *child)
 	inode = udf_iget(child->d_inode->i_sb, &tloc);
 	if (!inode)
 		goto out_unlock;
-	unlock_kernel();
 
 	return d_obtain_alias(inode);
 out_unlock:
-	unlock_kernel();
 	return ERR_PTR(-EACCES);
 }
 
diff --git a/fs/udf/super.c b/fs/udf/super.c
index e23d4e3..ca19438 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -48,7 +48,6 @@
 #include <linux/stat.h>
 #include <linux/cdrom.h>
 #include <linux/nls.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
 #include <linux/vmalloc.h>
@@ -1912,8 +1911,6 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	struct kernel_lb_addr rootdir, fileset;
 	struct udf_sb_info *sbi;
 
-	lock_kernel();
-
 	uopt.flags = (1 << UDF_FLAG_USE_AD_IN_ICB) | (1 << UDF_FLAG_STRICT);
 	uopt.uid = -1;
 	uopt.gid = -1;
@@ -1922,10 +1919,8 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	uopt.dmode = UDF_INVALID_MODE;
 
 	sbi = kzalloc(sizeof(struct udf_sb_info), GFP_KERNEL);
-	if (!sbi) {
-		unlock_kernel();
+	if (!sbi)
 		return -ENOMEM;
-	}
 
 	sb->s_fs_info = sbi;
 
@@ -2072,7 +2067,6 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 		goto error_out;
 	}
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
-	unlock_kernel();
 	return 0;
 
 error_out:
@@ -2093,7 +2087,6 @@ error_out:
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 
-	unlock_kernel();
 	return -EINVAL;
 }
 
-- 
1.7.0.4

