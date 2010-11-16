Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab0KPRlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:41:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39512 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab0KPRlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:41:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=ErQ98m0dznAZ9kTubTNLDrssLB8AhFbIVTFf28d03uAAPrxX3XDITSFG+gscewS7Rq
         BaQ3nY69jOdkA9Isv+DpVSPOB7K6OiPVK7RelpRUeTlArSnLPquPYwanBSFgkjfb4Ar3
         H/Rze7HpKgbSsZhpEknGpAN1z1P/42zw+eJcM=
From: Alessio Igor Bogani <abogani@texware.it>
To: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 1/3] udf: Replace bkl with the inode->i_alloc_sem for protect udf_inode_info struct
Date: Tue, 16 Nov 2010 18:40:47 +0100
Message-Id: <1289929249-4863-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace bkl with the inode->i_alloc_sem rw semaphore in udf_release_file(),
udf_symlink(), udf_symlink_filler(), udf_get_block() and udf_block_map().
Add protection in udf_evict_inode() using the same i_alloc_sem rw semaphore.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/udf/file.c    |    4 ++--
 fs/udf/inode.c   |   11 +++++++----
 fs/udf/namei.c   |    4 ++--
 fs/udf/symlink.c |   12 +++++++-----
 fs/udf/udf_i.h   |    9 +++++++++
 5 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index 66b9e7e..4cb0f7a 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -204,10 +204,10 @@ static int udf_release_file(struct inode *inode, struct file *filp)
 {
 	if (filp->f_mode & FMODE_WRITE) {
 		mutex_lock(&inode->i_mutex);
-		lock_kernel();
+		down_write(&inode->i_alloc_sem);
 		udf_discard_prealloc(inode);
 		udf_truncate_tail_extent(inode);
-		unlock_kernel();
+		up_write(&inode->i_alloc_sem);
 		mutex_unlock(&inode->i_mutex);
 	}
 	return 0;
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index fa3c154..14e3f56 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -79,7 +79,9 @@ void udf_evict_inode(struct inode *inode)
 	if (!inode->i_nlink && !is_bad_inode(inode)) {
 		want_delete = 1;
 		inode->i_size = 0;
+		down_write(&inode->i_alloc_sem);
 		udf_truncate(inode);
+		up_write(&inode->i_alloc_sem);
 		udf_update_inode(inode, IS_SYNC(inode));
 	}
 	invalidate_inode_buffers(inode);
@@ -302,9 +304,10 @@ static int udf_get_block(struct inode *inode, sector_t block,
 	new = 0;
 	bh = NULL;
 
-	lock_kernel();
+	down_write(&inode->i_alloc_sem);
 
 	iinfo = UDF_I(inode);
+
 	if (block == iinfo->i_next_alloc_block + 1) {
 		iinfo->i_next_alloc_block++;
 		iinfo->i_next_alloc_goal++;
@@ -323,7 +326,7 @@ static int udf_get_block(struct inode *inode, sector_t block,
 	map_bh(bh_result, inode->i_sb, phys);
 
 abort:
-	unlock_kernel();
+	up_write(&inode->i_alloc_sem);
 	return err;
 }
 
@@ -2043,7 +2046,7 @@ long udf_block_map(struct inode *inode, sector_t block)
 	struct extent_position epos = {};
 	int ret;
 
-	lock_kernel();
+	down_read(&inode->i_alloc_sem);
 
 	if (inode_bmap(inode, block, &epos, &eloc, &elen, &offset) ==
 						(EXT_RECORDED_ALLOCATED >> 30))
@@ -2051,7 +2054,7 @@ long udf_block_map(struct inode *inode, sector_t block)
 	else
 		ret = 0;
 
-	unlock_kernel();
+	up_read(&inode->i_alloc_sem);
 	brelse(epos.bh);
 
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_VARCONV))
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 701fcda..5aa2ca6 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -893,11 +893,11 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 	struct udf_inode_info *iinfo;
 	struct super_block *sb = dir->i_sb;
 
-	lock_kernel();
 	inode = udf_new_inode(dir, S_IFLNK | S_IRWXUGO, &err);
 	if (!inode)
 		goto out;
 
+	down_write(&inode->i_alloc_sem);
 	name = kmalloc(UDF_NAME_LEN, GFP_NOFS);
 	if (!name) {
 		err = -ENOMEM;
@@ -1032,10 +1032,10 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 
 out:
 	kfree(name);
-	unlock_kernel();
 	return err;
 
 out_no_entry:
+	up_write(&inode->i_alloc_sem);
 	inode_dec_link_count(inode);
 	iput(inode);
 	goto out;
diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index 1606478..358673d 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -27,7 +27,6 @@
 #include <linux/mm.h>
 #include <linux/stat.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include "udf_i.h"
 
@@ -78,13 +77,16 @@ static int udf_symlink_filler(struct file *file, struct page *page)
 	int err = -EIO;
 	unsigned char *p = kmap(page);
 	struct udf_inode_info *iinfo;
+	uint32_t pos;
 
-	lock_kernel();
 	iinfo = UDF_I(inode);
+	pos = udf_block_map(inode, 0);
+
+	down_read(&inode->i_alloc_sem);
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 		symlink = iinfo->i_ext.i_data + iinfo->i_lenEAttr;
 	} else {
-		bh = sb_bread(inode->i_sb, udf_block_map(inode, 0));
+		bh = sb_bread(inode->i_sb, pos);
 
 		if (!bh)
 			goto out;
@@ -95,14 +97,14 @@ static int udf_symlink_filler(struct file *file, struct page *page)
 	udf_pc_to_char(inode->i_sb, symlink, inode->i_size, p);
 	brelse(bh);
 
-	unlock_kernel();
+	up_read(&inode->i_alloc_sem);
 	SetPageUptodate(page);
 	kunmap(page);
 	unlock_page(page);
 	return 0;
 
 out:
-	unlock_kernel();
+	up_read(&inode->i_alloc_sem);
 	SetPageError(page);
 	kunmap(page);
 	unlock_page(page);
diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
index e58d1de..d5026ae 100644
--- a/fs/udf/udf_i.h
+++ b/fs/udf/udf_i.h
@@ -1,6 +1,15 @@
 #ifndef _UDF_I_H
 #define _UDF_I_H
 
+/*
+ * The i_alloc_sem serves for protection of allocation information of a regular
+ * files and symlinks. This includes all extents belonging to the file/symlink,
+ * preallocation, and goal block information. When extents are read,
+ * i_alloc_sem must be held for reading, when extents are changed, i_alloc_sem
+ * must be held for writing. For directories i_mutex is used for all the
+ * necessary protection.
+ */
+
 struct udf_inode_info {
 	struct timespec		i_crtime;
 	/* Physical address of inode */
-- 
1.7.0.4

