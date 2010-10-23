Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab0JWLib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 07:38:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41490 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab0JWLi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 07:38:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=vkimg5gLhRRyLye3GM3qf3yzi/BIdWd1iIxb1ib8h3PJ7YgBc15k8WGvJvO+JOVVCp
         XuUMD/J60ZNs3aWV5u+JNpeCiphh9mJ2ehxjf00bws16PhLklTX2ac0qEjOwO3g/Mw8T
         RIuqLKGl0ydNJ0Dw/caPBpzEOK7LQVGr9neKs=
From: Alessio Igor Bogani <abogani@texware.it>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 3/6] udf: Remove BKL
Date: Sat, 23 Oct 2010 13:37:30 +0200
Message-Id: <1287833853-4175-3-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1287833853-4175-1-git-send-email-abogani@texware.it>
References: <1287833853-4175-1-git-send-email-abogani@texware.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lookup, create, mknod, mkdir, rmdir, unlink and symlink functions seems
already adequately protected by i_mutex held by VFS invoking calls.

In get_parent the BKL seems unecessary.

The rename function instead should be protected by lock_rename again
by VFS.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/udf/namei.c |   38 +++-----------------------------------
 1 files changed, 3 insertions(+), 35 deletions(-)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index bf5fc67..3e9cb90 100644
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
@@ -562,12 +557,9 @@ static int udf_create(struct inode *dir, struct dentry *dentry, int mode,
 	int err;
 	struct udf_inode_info *iinfo;
 
-	lock_kernel();
 	inode = udf_new_inode(dir, mode, &err);
-	if (!inode) {
-		unlock_kernel();
+	if (!inode)
 		return err;
-	}
 
 	iinfo = UDF_I(inode);
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
@@ -583,7 +575,6 @@ static int udf_create(struct inode *dir, struct dentry *dentry, int mode,
 		inode->i_nlink--;
 		mark_inode_dirty(inode);
 		iput(inode);
-		unlock_kernel();
 		return err;
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
@@ -596,7 +587,6 @@ static int udf_create(struct inode *dir, struct dentry *dentry, int mode,
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
-	unlock_kernel();
 	d_instantiate(dentry, inode);
 
 	return 0;
@@ -614,7 +604,6 @@ static int udf_mknod(struct inode *dir, struct dentry *dentry, int mode,
 	if (!old_valid_dev(rdev))
 		return -EINVAL;
 
-	lock_kernel();
 	err = -EIO;
 	inode = udf_new_inode(dir, mode, &err);
 	if (!inode)
@@ -627,7 +616,6 @@ static int udf_mknod(struct inode *dir, struct dentry *dentry, int mode,
 		inode->i_nlink--;
 		mark_inode_dirty(inode);
 		iput(inode);
-		unlock_kernel();
 		return err;
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
@@ -646,7 +634,6 @@ static int udf_mknod(struct inode *dir, struct dentry *dentry, int mode,
 	err = 0;
 
 out:
-	unlock_kernel();
 	return err;
 }
 
@@ -659,7 +646,6 @@ static int udf_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	struct udf_inode_info *dinfo = UDF_I(dir);
 	struct udf_inode_info *iinfo;
 
-	lock_kernel();
 	err = -EMLINK;
 	if (dir->i_nlink >= (256 << sizeof(dir->i_nlink)) - 1)
 		goto out;
@@ -712,7 +698,6 @@ static int udf_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	err = 0;
 
 out:
-	unlock_kernel();
 	return err;
 }
 
@@ -794,7 +779,6 @@ static int udf_rmdir(struct inode *dir, struct dentry *dentry)
 	struct kernel_lb_addr tloc;
 
 	retval = -ENOENT;
-	lock_kernel();
 	fi = udf_find_entry(dir, &dentry->d_name, &fibh, &cfi);
 	if (!fi)
 		goto out;
@@ -826,7 +810,6 @@ end_rmdir:
 	brelse(fibh.sbh);
 
 out:
-	unlock_kernel();
 	return retval;
 }
 
@@ -840,7 +823,6 @@ static int udf_unlink(struct inode *dir, struct dentry *dentry)
 	struct kernel_lb_addr tloc;
 
 	retval = -ENOENT;
-	lock_kernel();
 	fi = udf_find_entry(dir, &dentry->d_name, &fibh, &cfi);
 	if (!fi)
 		goto out;
@@ -870,7 +852,6 @@ end_unlink:
 	brelse(fibh.sbh);
 
 out:
-	unlock_kernel();
 	return retval;
 }
 
@@ -893,7 +874,6 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 	struct buffer_head *bh;
 	struct udf_inode_info *iinfo;
 
-	lock_kernel();
 	inode = udf_new_inode(dir, S_IFLNK | S_IRWXUGO, &err);
 	if (!inode)
 		goto out;
@@ -1044,7 +1024,6 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 
 out:
 	kfree(name);
-	unlock_kernel();
 	return err;
 
 out_no_entry:
@@ -1062,17 +1041,12 @@ static int udf_link(struct dentry *old_dentry, struct inode *dir,
 	int err;
 	struct buffer_head *bh;
 
-	lock_kernel();
-	if (inode->i_nlink >= (256 << sizeof(inode->i_nlink)) - 1) {
-		unlock_kernel();
+	if (inode->i_nlink >= (256 << sizeof(inode->i_nlink)) - 1)
 		return -EMLINK;
-	}
 
 	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
-	if (!fi) {
-		unlock_kernel();
+	if (!fi)
 		return err;
-	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I(inode)->i_location);
 	bh = UDF_SB(inode->i_sb)->s_lvid_bh;
@@ -1103,7 +1077,6 @@ static int udf_link(struct dentry *old_dentry, struct inode *dir,
 	mark_inode_dirty(inode);
 	atomic_inc(&inode->i_count);
 	d_instantiate(dentry, inode);
-	unlock_kernel();
 
 	return 0;
 }
@@ -1124,7 +1097,6 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct kernel_lb_addr tloc;
 	struct udf_inode_info *old_iinfo = UDF_I(old_inode);
 
-	lock_kernel();
 	ofi = udf_find_entry(old_dir, &old_dentry->d_name, &ofibh, &ocfi);
 	if (ofi) {
 		if (ofibh.sbh != ofibh.ebh)
@@ -1248,7 +1220,6 @@ end_rename:
 			brelse(nfibh.ebh);
 		brelse(nfibh.sbh);
 	}
-	unlock_kernel();
 
 	return retval;
 }
@@ -1261,7 +1232,6 @@ static struct dentry *udf_get_parent(struct dentry *child)
 	struct fileIdentDesc cfi;
 	struct udf_fileident_bh fibh;
 
-	lock_kernel();
 	if (!udf_find_entry(child->d_inode, &dotdot, &fibh, &cfi))
 		goto out_unlock;
 
@@ -1273,11 +1243,9 @@ static struct dentry *udf_get_parent(struct dentry *child)
 	inode = udf_iget(child->d_inode->i_sb, &tloc);
 	if (!inode)
 		goto out_unlock;
-	unlock_kernel();
 
 	return d_obtain_alias(inode);
 out_unlock:
-	unlock_kernel();
 	return ERR_PTR(-EACCES);
 }
 
-- 
1.7.0.4

