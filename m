Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab0JUNue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:50:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53348 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab0JUNub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:50:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] BKL: remove BKL from freevxfs
Date: Thu, 21 Oct 2010 15:51:08 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <201009161632.59210.arnd@arndb.de> <20101021124743.GC17654@infradead.org> <201010211538.24733.arnd@arndb.de>
In-Reply-To: <201010211538.24733.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010211551.08870.arnd@arndb.de>
X-Provags-ID: V02:K0:ijvrWgM97qRfZne9M1ImVX1zPFTFNJOB9XLJIt+UW0H
 TiKXblklMJu6Z1248ILhX2vahCS25/b8PioKjQIqLBuSkGrbUn
 w46yR+YLZDae+Ubly1Lx3qfQh4oXD8uTffnjDd7raQTpPjS09W
 J5LjLtNSoiD8w+P4EnyZBeRWBGsQ+PuiTiOGxQZXH03s4Us1jg
 QT7qWluMneomPAFCTNHxg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All uses of the BKL in freevxfs were the result of a pushdown into
code that doesn't really need it. As Christoph points out, this
is a read-only file system, which eliminates most of the races in
readdir/lookup.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/freevxfs/vxfs_lookup.c |   14 ++------------
 fs/freevxfs/vxfs_super.c  |   10 ----------
 2 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/fs/freevxfs/vxfs_lookup.c b/fs/freevxfs/vxfs_lookup.c
index 0ec7bb2..6c5131d 100644
--- a/fs/freevxfs/vxfs_lookup.c
+++ b/fs/freevxfs/vxfs_lookup.c
@@ -36,7 +36,6 @@
 #include <linux/highmem.h>
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 
 #include "vxfs.h"
 #include "vxfs_dir.h"
@@ -212,16 +211,12 @@ vxfs_lookup(struct inode *dip, struct dentry *dp, struct nameidata *nd)
 	if (dp->d_name.len > VXFS_NAMELEN)
 		return ERR_PTR(-ENAMETOOLONG);
 				 
-	lock_kernel();
 	ino = vxfs_inode_by_name(dip, dp);
 	if (ino) {
 		ip = vxfs_iget(dip->i_sb, ino);
-		if (IS_ERR(ip)) {
-			unlock_kernel();
+		if (IS_ERR(ip))
 			return ERR_CAST(ip);
-		}
 	}
-	unlock_kernel();
 	d_add(dp, ip);
 	return NULL;
 }
@@ -248,8 +243,6 @@ vxfs_readdir(struct file *fp, void *retp, filldir_t filler)
 	u_long			page, npages, block, pblocks, nblocks, offset;
 	loff_t			pos;
 
-	lock_kernel();
-
 	switch ((long)fp->f_pos) {
 	case 0:
 		if (filler(retp, ".", 1, fp->f_pos, ip->i_ino, DT_DIR) < 0)
@@ -265,10 +258,8 @@ vxfs_readdir(struct file *fp, void *retp, filldir_t filler)
 
 	pos = fp->f_pos - 2;
 	
-	if (pos > VXFS_DIRROUND(ip->i_size)) {
-		unlock_kernel();
+	if (pos > VXFS_DIRROUND(ip->i_size))
 		return 0;
-	}
 
 	npages = dir_pages(ip);
 	nblocks = dir_blocks(ip);
@@ -327,6 +318,5 @@ vxfs_readdir(struct file *fp, void *retp, filldir_t filler)
 done:
 	fp->f_pos = ((page << PAGE_CACHE_SHIFT) | offset) + 2;
 out:
-	unlock_kernel();
 	return 0;
 }
diff --git a/fs/freevxfs/vxfs_super.c b/fs/freevxfs/vxfs_super.c
index eb2b9e0..71b0148 100644
--- a/fs/freevxfs/vxfs_super.c
+++ b/fs/freevxfs/vxfs_super.c
@@ -38,7 +38,6 @@
 #include <linux/buffer_head.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/stat.h>
 #include <linux/vfs.h>
 #include <linux/mount.h>
@@ -81,16 +80,12 @@ vxfs_put_super(struct super_block *sbp)
 {
 	struct vxfs_sb_info	*infp = VXFS_SBI(sbp);
 
-	lock_kernel();
-
 	vxfs_put_fake_inode(infp->vsi_fship);
 	vxfs_put_fake_inode(infp->vsi_ilist);
 	vxfs_put_fake_inode(infp->vsi_stilist);
 
 	brelse(infp->vsi_bp);
 	kfree(infp);
-
-	unlock_kernel();
 }
 
 /**
@@ -159,14 +154,11 @@ static int vxfs_fill_super(struct super_block *sbp, void *dp, int silent)
 	struct inode *root;
 	int ret = -EINVAL;
 
-	lock_kernel();
-
 	sbp->s_flags |= MS_RDONLY;
 
 	infp = kzalloc(sizeof(*infp), GFP_KERNEL);
 	if (!infp) {
 		printk(KERN_WARNING "vxfs: unable to allocate incore superblock\n");
-		unlock_kernel();
 		return -ENOMEM;
 	}
 
@@ -239,7 +231,6 @@ static int vxfs_fill_super(struct super_block *sbp, void *dp, int silent)
 		goto out_free_ilist;
 	}
 
-	unlock_kernel();
 	return 0;
 	
 out_free_ilist:
@@ -249,7 +240,6 @@ out_free_ilist:
 out:
 	brelse(bp);
 	kfree(infp);
-	unlock_kernel();
 	return ret;
 }
 
-- 
1.7.1

