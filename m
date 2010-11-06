Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab0KFRrg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 13:47:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57768 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab0KFRrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 13:47:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=dNoWlCNokWdWtOccg0CTK8BR/V4kAsL9kM2OGlhUgd34/teyyc6Hx9+7HFgMiASRDM
         6CZWEaor8cPoFb8pTt9alhIUEm47CP4xRpiRRnT1WoPr0Y6w9NTdr1zNL/usbP8LDxiA
         cIml6wfrdViqC5LF2MYskGsldjvU2Z4uRU0rg=
From: Alessio Igor Bogani <abogani@texware.it>
To: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 2/4] udf: Remove unnecessary bkl usages
Date: Sat,  6 Nov 2010 18:47:09 +0100
Message-Id: <1289065631-2256-2-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1289065631-2256-1-git-send-email-abogani@texware.it>
References: <1289065631-2256-1-git-send-email-abogani@texware.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The udf_lookup, udf_create, udf_mknod, udf_mkdir, udf_rmdir, udf_link,
udf_unlink and udf_readdir functions seems already adequately protected
by i_mutex held by VFS invoking calls. The udf_rename function instead
should be already protected by lock_rename again by VFS.

The udf_get_parent, udf_count_free_bitmap, udf_count_free_table and
udf_put_super functions don't require any protection.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/udf/dir.c   |    5 -----
 fs/udf/namei.c |   26 --------------------------
 fs/udf/super.c |   12 ------------
 3 files changed, 0 insertions(+), 43 deletions(-)

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
 
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 6d8dc02..6e7c1b9 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -263,7 +263,6 @@ static struct dentry *udf_lookup(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_name.len > UDF_NAME_LEN - 2)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	lock_kernel();
 #ifdef UDF_RECOVERY
 	/* temporary shorthand for specifying files by inode number */
 	if (!strncmp(dentry->d_name.name, ".B=", 3)) {
@@ -275,7 +274,6 @@ static struct dentry *udf_lookup(struct inode *dir, struct dentry *dentry,
 		};
 		inode = udf_iget(dir->i_sb, lb);
 		if (!inode) {
-			unlock_kernel();
 			return ERR_PTR(-EACCES);
 		}
 	} else
@@ -291,11 +289,9 @@ static struct dentry *udf_lookup(struct inode *dir, struct dentry *dentry,
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
@@ -562,10 +558,8 @@ static int udf_create(struct inode *dir, struct dentry *dentry, int mode,
 	int err;
 	struct udf_inode_info *iinfo;
 
-	lock_kernel();
 	inode = udf_new_inode(dir, mode, &err);
 	if (!inode) {
-		unlock_kernel();
 		return err;
 	}
 
@@ -583,7 +577,6 @@ static int udf_create(struct inode *dir, struct dentry *dentry, int mode,
 		inode->i_nlink--;
 		mark_inode_dirty(inode);
 		iput(inode);
-		unlock_kernel();
 		return err;
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
@@ -596,7 +589,6 @@ static int udf_create(struct inode *dir, struct dentry *dentry, int mode,
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
-	unlock_kernel();
 	d_instantiate(dentry, inode);
 
 	return 0;
@@ -614,7 +606,6 @@ static int udf_mknod(struct inode *dir, struct dentry *dentry, int mode,
 	if (!old_valid_dev(rdev))
 		return -EINVAL;
 
-	lock_kernel();
 	err = -EIO;
 	inode = udf_new_inode(dir, mode, &err);
 	if (!inode)
@@ -627,7 +618,6 @@ static int udf_mknod(struct inode *dir, struct dentry *dentry, int mode,
 		inode->i_nlink--;
 		mark_inode_dirty(inode);
 		iput(inode);
-		unlock_kernel();
 		return err;
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
@@ -646,7 +636,6 @@ static int udf_mknod(struct inode *dir, struct dentry *dentry, int mode,
 	err = 0;
 
 out:
-	unlock_kernel();
 	return err;
 }
 
@@ -659,7 +648,6 @@ static int udf_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	struct udf_inode_info *dinfo = UDF_I(dir);
 	struct udf_inode_info *iinfo;
 
-	lock_kernel();
 	err = -EMLINK;
 	if (dir->i_nlink >= (256 << sizeof(dir->i_nlink)) - 1)
 		goto out;
@@ -712,7 +700,6 @@ static int udf_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	err = 0;
 
 out:
-	unlock_kernel();
 	return err;
 }
 
@@ -794,7 +781,6 @@ static int udf_rmdir(struct inode *dir, struct dentry *dentry)
 	struct kernel_lb_addr tloc;
 
 	retval = -ENOENT;
-	lock_kernel();
 	fi = udf_find_entry(dir, &dentry->d_name, &fibh, &cfi);
 	if (!fi)
 		goto out;
@@ -826,7 +812,6 @@ end_rmdir:
 	brelse(fibh.sbh);
 
 out:
-	unlock_kernel();
 	return retval;
 }
 
@@ -840,7 +825,6 @@ static int udf_unlink(struct inode *dir, struct dentry *dentry)
 	struct kernel_lb_addr tloc;
 
 	retval = -ENOENT;
-	lock_kernel();
 	fi = udf_find_entry(dir, &dentry->d_name, &fibh, &cfi);
 	if (!fi)
 		goto out;
@@ -870,7 +854,6 @@ end_unlink:
 	brelse(fibh.sbh);
 
 out:
-	unlock_kernel();
 	return retval;
 }
 
@@ -1062,15 +1045,12 @@ static int udf_link(struct dentry *old_dentry, struct inode *dir,
 	int err;
 	struct buffer_head *bh;
 
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
@@ -1103,7 +1083,6 @@ static int udf_link(struct dentry *old_dentry, struct inode *dir,
 	mark_inode_dirty(inode);
 	ihold(inode);
 	d_instantiate(dentry, inode);
-	unlock_kernel();
 
 	return 0;
 }
@@ -1124,7 +1103,6 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct kernel_lb_addr tloc;
 	struct udf_inode_info *old_iinfo = UDF_I(old_inode);
 
-	lock_kernel();
 	ofi = udf_find_entry(old_dir, &old_dentry->d_name, &ofibh, &ocfi);
 	if (ofi) {
 		if (ofibh.sbh != ofibh.ebh)
@@ -1248,7 +1226,6 @@ end_rename:
 			brelse(nfibh.ebh);
 		brelse(nfibh.sbh);
 	}
-	unlock_kernel();
 
 	return retval;
 }
@@ -1261,7 +1238,6 @@ static struct dentry *udf_get_parent(struct dentry *child)
 	struct fileIdentDesc cfi;
 	struct udf_fileident_bh fibh;
 
-	lock_kernel();
 	if (!udf_find_entry(child->d_inode, &dotdot, &fibh, &cfi))
 		goto out_unlock;
 
@@ -1273,11 +1249,9 @@ static struct dentry *udf_get_parent(struct dentry *child)
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
index c05834e..0027c1f 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -2102,8 +2102,6 @@ static void udf_put_super(struct super_block *sb)
 
 	sbi = UDF_SB(sb);
 
-	lock_kernel();
-
 	if (sbi->s_vat_inode)
 		iput(sbi->s_vat_inode);
 	if (sbi->s_partitions)
@@ -2119,8 +2117,6 @@ static void udf_put_super(struct super_block *sb)
 	kfree(sbi->s_partmaps);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
-
-	unlock_kernel();
 }
 
 static int udf_sync_fs(struct super_block *sb, int wait)
@@ -2183,8 +2179,6 @@ static unsigned int udf_count_free_bitmap(struct super_block *sb,
 	uint16_t ident;
 	struct spaceBitmapDesc *bm;
 
-	lock_kernel();
-
 	loc.logicalBlockNum = bitmap->s_extPosition;
 	loc.partitionReferenceNum = UDF_SB(sb)->s_partition;
 	bh = udf_read_ptagged(sb, &loc, 0, &ident);
@@ -2223,8 +2217,6 @@ static unsigned int udf_count_free_bitmap(struct super_block *sb,
 	brelse(bh);
 
 out:
-	unlock_kernel();
-
 	return accum;
 }
 
@@ -2237,8 +2229,6 @@ static unsigned int udf_count_free_table(struct super_block *sb,
 	int8_t etype;
 	struct extent_position epos;
 
-	lock_kernel();
-
 	epos.block = UDF_I(table)->i_location;
 	epos.offset = sizeof(struct unallocSpaceEntry);
 	epos.bh = NULL;
@@ -2248,8 +2238,6 @@ static unsigned int udf_count_free_table(struct super_block *sb,
 
 	brelse(epos.bh);
 
-	unlock_kernel();
-
 	return accum;
 }
 
-- 
1.7.0.4

