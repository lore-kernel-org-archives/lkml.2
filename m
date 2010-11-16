Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab0KPXFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:05:08 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53955 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844Ab0KPXFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:05:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=B8+oJbsI6S7/Fl4jqP+exSQh+IeIadd/udAgsiK0gNBTzENO9HTilt0TjRHQfTaeWE
         00/3T8OfYmzDHECKFnXhPl6zwvRs2G0c+D+lC4/jMPFyXj1RQGkaU1xRBmvekb3jrldS
         fQLFB+4RVG3mJNF2nz/cYnjR2GLwAjdePmXEE=
From: Alessio Igor Bogani <abogani@texware.it>
To: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 1/3] udf: Replace bkl with the a new semaphore for protect udf_inode_info struct
Date: Wed, 17 Nov 2010 00:04:25 +0100
Message-Id: <1289948667-2197-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20101116180544.GA29896@infradead.org>
References: <20101116180544.GA29896@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace bkl with the udf_inode_info's ii_alloc_sem rw semaphore in
udf_release_file(), udf_symlink(), udf_symlink_filler(), udf_get_block() and
udf_block_map(). Add protection in udf_evict_inode() using the same
ii_alloc_sem rw semaphore.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/udf/file.c    |    6 ++++--
 fs/udf/inode.c   |   14 +++++++++-----
 fs/udf/namei.c   |    6 +++---
 fs/udf/super.c   |    2 ++
 fs/udf/symlink.c |   12 +++++++-----
 fs/udf/udf_i.h   |   10 ++++++++++
 6 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index 66b9e7e..5724eca 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -202,12 +202,14 @@ out:
 
 static int udf_release_file(struct inode *inode, struct file *filp)
 {
+	struct udf_inode_info *iinfo = UDF_I(inode);
+
 	if (filp->f_mode & FMODE_WRITE) {
 		mutex_lock(&inode->i_mutex);
-		lock_kernel();
+		down_write(&iinfo->ii_alloc_sem);
 		udf_discard_prealloc(inode);
 		udf_truncate_tail_extent(inode);
-		unlock_kernel();
+		up_write(&iinfo->ii_alloc_sem);
 		mutex_unlock(&inode->i_mutex);
 	}
 	return 0;
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index fa3c154..b7e5089 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -79,7 +79,9 @@ void udf_evict_inode(struct inode *inode)
 	if (!inode->i_nlink && !is_bad_inode(inode)) {
 		want_delete = 1;
 		inode->i_size = 0;
+		down_write(&iinfo->ii_alloc_sem);
 		udf_truncate(inode);
+		up_write(&iinfo->ii_alloc_sem);
 		udf_update_inode(inode, IS_SYNC(inode));
 	}
 	invalidate_inode_buffers(inode);
@@ -302,9 +304,10 @@ static int udf_get_block(struct inode *inode, sector_t block,
 	new = 0;
 	bh = NULL;
 
-	lock_kernel();
-
 	iinfo = UDF_I(inode);
+
+	down_write(&iinfo->ii_alloc_sem);
+
 	if (block == iinfo->i_next_alloc_block + 1) {
 		iinfo->i_next_alloc_block++;
 		iinfo->i_next_alloc_goal++;
@@ -323,7 +326,7 @@ static int udf_get_block(struct inode *inode, sector_t block,
 	map_bh(bh_result, inode->i_sb, phys);
 
 abort:
-	unlock_kernel();
+	up_write(&iinfo->ii_alloc_sem);
 	return err;
 }
 
@@ -2042,8 +2045,9 @@ long udf_block_map(struct inode *inode, sector_t block)
 	sector_t offset;
 	struct extent_position epos = {};
 	int ret;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
-	lock_kernel();
+	down_read(&iinfo->ii_alloc_sem);
 
 	if (inode_bmap(inode, block, &epos, &eloc, &elen, &offset) ==
 						(EXT_RECORDED_ALLOCATED >> 30))
@@ -2051,7 +2055,7 @@ long udf_block_map(struct inode *inode, sector_t block)
 	else
 		ret = 0;
 
-	unlock_kernel();
+	up_read(&iinfo->ii_alloc_sem);
 	brelse(epos.bh);
 
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_VARCONV))
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 701fcda..d7d3d01 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -893,18 +893,18 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 	struct udf_inode_info *iinfo;
 	struct super_block *sb = dir->i_sb;
 
-	lock_kernel();
 	inode = udf_new_inode(dir, S_IFLNK | S_IRWXUGO, &err);
 	if (!inode)
 		goto out;
 
+	iinfo = UDF_I(inode);
+	down_write(&iinfo->ii_alloc_sem);
 	name = kmalloc(UDF_NAME_LEN, GFP_NOFS);
 	if (!name) {
 		err = -ENOMEM;
 		goto out_no_entry;
 	}
 
-	iinfo = UDF_I(inode);
 	inode->i_data.a_ops = &udf_symlink_aops;
 	inode->i_op = &udf_symlink_inode_operations;
 
@@ -1032,10 +1032,10 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 
 out:
 	kfree(name);
-	unlock_kernel();
 	return err;
 
 out_no_entry:
+	up_write(&iinfo->ii_alloc_sem);
 	inode_dec_link_count(inode);
 	iput(inode);
 	goto out;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index d2ec9f3..e23d4e3 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -130,6 +130,8 @@ static struct inode *udf_alloc_inode(struct super_block *sb)
 	if (!ei)
 		return NULL;
 
+	init_rwsem(&ei->ii_alloc_sem);
+
 	ei->i_unique = 0;
 	ei->i_lenExtents = 0;
 	ei->i_next_alloc_block = 0;
diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index 1606478..28780dc 100644
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
+	down_read(&iinfo->ii_alloc_sem);
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
+	up_read(&iinfo->ii_alloc_sem);
 	SetPageUptodate(page);
 	kunmap(page);
 	unlock_page(page);
 	return 0;
 
 out:
-	unlock_kernel();
+	up_read(&iinfo->ii_alloc_sem);
 	SetPageError(page);
 	kunmap(page);
 	unlock_page(page);
diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
index e58d1de..e4e72d9 100644
--- a/fs/udf/udf_i.h
+++ b/fs/udf/udf_i.h
@@ -1,6 +1,15 @@
 #ifndef _UDF_I_H
 #define _UDF_I_H
 
+/*
+ * The ii_alloc_sem serves for protection of allocation information of a regular
+ * files and symlinks. This includes all extents belonging to the file/symlink,
+ * preallocation, and goal block information. When extents are read,
+ * ii_alloc_sem must be held for reading, when extents are changed, ii_alloc_sem
+ * must be held for writing. For directories i_mutex is used for all the
+ * necessary protection.
+ */
+
 struct udf_inode_info {
 	struct timespec		i_crtime;
 	/* Physical address of inode */
@@ -22,6 +31,7 @@ struct udf_inode_info {
 		__u8		*i_data;
 	} i_ext;
 	struct inode vfs_inode;
+	struct rw_semaphore ii_alloc_sem;
 };
 
 static inline struct udf_inode_info *UDF_I(struct inode *inode)
-- 
1.7.0.4

