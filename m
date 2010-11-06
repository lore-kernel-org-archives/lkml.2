Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab0KFRrv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 13:47:51 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:42902 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab0KFRrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 13:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=qNo+W2XBPMIikbISZHdYtBgVO+VsI36xvAe6l5FWrHm+7CAKx/wL2+KQQeSQqk1Wjx
         sftQ3Qq87aasWsA3B7O0Q0ln3eHRYGbp0mczWgMTqHzZdJTBci0N00Tw3jDQZBjFg4Zn
         jROR0Hj7bNAUJ2fILIe+eX+Gi1HYyZ4wfobtY=
From: Alessio Igor Bogani <abogani@texware.it>
To: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 3/4] udf: Replace bkl with a mutex for protect udf_inode_info struct
Date: Sat,  6 Nov 2010 18:47:10 +0100
Message-Id: <1289065631-2256-3-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1289065631-2256-1-git-send-email-abogani@texware.it>
References: <1289065631-2256-1-git-send-email-abogani@texware.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace bkl with a mutex in udf_release_file, udf_symlink, udf_symlink_filler,
udf_truncate, udf_get_block, udf_block_map, udf_evict_inode and udf_write_inode
functions.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/udf/file.c    |    9 +++++----
 fs/udf/inode.c   |   29 ++++++++++++++---------------
 fs/udf/namei.c   |    6 +++---
 fs/udf/super.c   |    3 +++
 fs/udf/symlink.c |   13 ++++++++-----
 fs/udf/udf_i.h   |    3 +++
 6 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index 66b9e7e..688e6ea 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -33,6 +33,7 @@
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
 #include <linux/aio.h>
@@ -202,13 +203,13 @@ out:
 
 static int udf_release_file(struct inode *inode, struct file *filp)
 {
+	struct udf_inode_info *iinfo = UDF_I(inode);
+
 	if (filp->f_mode & FMODE_WRITE) {
-		mutex_lock(&inode->i_mutex);
-		lock_kernel();
+		mutex_lock(&iinfo->lock);
 		udf_discard_prealloc(inode);
 		udf_truncate_tail_extent(inode);
-		unlock_kernel();
-		mutex_unlock(&inode->i_mutex);
+		mutex_unlock(&iinfo->lock);
 	}
 	return 0;
 }
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index fc48f37..6111af5 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -31,7 +31,7 @@
 
 #include "udfdecl.h"
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
@@ -79,9 +79,9 @@ void udf_evict_inode(struct inode *inode)
 		want_delete = 1;
 		inode->i_size = 0;
 		udf_truncate(inode);
-		lock_kernel();
+		mutex_lock(&iinfo->lock);
 		udf_update_inode(inode, IS_SYNC(inode));
-		unlock_kernel();
+		mutex_unlock(&iinfo->lock);
 	}
 	invalidate_inode_buffers(inode);
 	end_writeback(inode);
@@ -97,9 +97,7 @@ void udf_evict_inode(struct inode *inode)
 	kfree(iinfo->i_ext.i_data);
 	iinfo->i_ext.i_data = NULL;
 	if (want_delete) {
-		lock_kernel();
 		udf_free_inode(inode);
-		unlock_kernel();
 	}
 }
 
@@ -303,9 +301,8 @@ static int udf_get_block(struct inode *inode, sector_t block,
 	new = 0;
 	bh = NULL;
 
-	lock_kernel();
-
 	iinfo = UDF_I(inode);
+	mutex_lock(&iinfo->lock);
 	if (block == iinfo->i_next_alloc_block + 1) {
 		iinfo->i_next_alloc_block++;
 		iinfo->i_next_alloc_goal++;
@@ -324,7 +321,7 @@ static int udf_get_block(struct inode *inode, sector_t block,
 	map_bh(bh_result, inode->i_sb, phys);
 
 abort:
-	unlock_kernel();
+	mutex_unlock(&iinfo->lock);
 	return err;
 }
 
@@ -1022,8 +1019,8 @@ void udf_truncate(struct inode *inode)
 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
 		return;
 
-	lock_kernel();
 	iinfo = UDF_I(inode);
+	mutex_lock(&iinfo->lock);
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 		if (inode->i_sb->s_blocksize <
 				(udf_file_entry_alloc_offset(inode) +
@@ -1031,7 +1028,7 @@ void udf_truncate(struct inode *inode)
 			udf_expand_file_adinicb(inode, inode->i_size, &err);
 			if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 				inode->i_size = iinfo->i_lenAlloc;
-				unlock_kernel();
+				mutex_unlock(&iinfo->lock);
 				return;
 			} else
 				udf_truncate_extents(inode);
@@ -1053,7 +1050,7 @@ void udf_truncate(struct inode *inode)
 		udf_sync_inode(inode);
 	else
 		mark_inode_dirty(inode);
-	unlock_kernel();
+	mutex_unlock(&iinfo->lock);
 }
 
 static void __udf_read_inode(struct inode *inode)
@@ -1374,10 +1371,11 @@ static mode_t udf_convert_permissions(struct fileEntry *fe)
 int udf_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int ret;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
-	lock_kernel();
+	mutex_lock(&iinfo->lock);
 	ret = udf_update_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
-	unlock_kernel();
+	mutex_unlock(&iinfo->lock);
 
 	return ret;
 }
@@ -2047,8 +2045,9 @@ long udf_block_map(struct inode *inode, sector_t block)
 	sector_t offset;
 	struct extent_position epos = {};
 	int ret;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
-	lock_kernel();
+	mutex_lock(&iinfo->lock);
 
 	if (inode_bmap(inode, block, &epos, &eloc, &elen, &offset) ==
 						(EXT_RECORDED_ALLOCATED >> 30))
@@ -2056,7 +2055,7 @@ long udf_block_map(struct inode *inode, sector_t block)
 	else
 		ret = 0;
 
-	unlock_kernel();
+	mutex_unlock(&iinfo->lock);
 	brelse(epos.bh);
 
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_VARCONV))
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 6e7c1b9..6022298 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -27,7 +27,7 @@
 #include <linux/errno.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/buffer_head.h>
 #include <linux/sched.h>
 #include <linux/crc-itu-t.h>
@@ -876,7 +876,6 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 	struct buffer_head *bh;
 	struct udf_inode_info *iinfo;
 
-	lock_kernel();
 	inode = udf_new_inode(dir, S_IFLNK | S_IRWXUGO, &err);
 	if (!inode)
 		goto out;
@@ -888,6 +887,7 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 	}
 
 	iinfo = UDF_I(inode);
+	mutex_lock(&iinfo->lock);
 	inode->i_data.a_ops = &udf_symlink_aops;
 	inode->i_op = &udf_symlink_inode_operations;
 
@@ -1026,8 +1026,8 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 	err = 0;
 
 out:
+	mutex_unlock(&iinfo->lock);
 	kfree(name);
-	unlock_kernel();
 	return err;
 
 out_no_entry:
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 0027c1f..615859b 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -49,6 +49,7 @@
 #include <linux/cdrom.h>
 #include <linux/nls.h>
 #include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
 #include <linux/vmalloc.h>
@@ -130,6 +131,8 @@ static struct inode *udf_alloc_inode(struct super_block *sb)
 	if (!ei)
 		return NULL;
 
+	mutex_init(&ei->lock);
+
 	ei->i_unique = 0;
 	ei->i_lenExtents = 0;
 	ei->i_next_alloc_block = 0;
diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index 1606478..5ef30b9 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -27,7 +27,7 @@
 #include <linux/mm.h>
 #include <linux/stat.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/buffer_head.h>
 #include "udf_i.h"
 
@@ -78,13 +78,16 @@ static int udf_symlink_filler(struct file *file, struct page *page)
 	int err = -EIO;
 	unsigned char *p = kmap(page);
 	struct udf_inode_info *iinfo;
+	uint32_t pos;
 
-	lock_kernel();
 	iinfo = UDF_I(inode);
+	pos = udf_block_map(inode, 0);
+
+	mutex_lock(&iinfo->lock);
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 		symlink = iinfo->i_ext.i_data + iinfo->i_lenEAttr;
 	} else {
-		bh = sb_bread(inode->i_sb, udf_block_map(inode, 0));
+		bh = sb_bread(inode->i_sb, pos);
 
 		if (!bh)
 			goto out;
@@ -95,14 +98,14 @@ static int udf_symlink_filler(struct file *file, struct page *page)
 	udf_pc_to_char(inode->i_sb, symlink, inode->i_size, p);
 	brelse(bh);
 
-	unlock_kernel();
+	mutex_unlock(&iinfo->lock);
 	SetPageUptodate(page);
 	kunmap(page);
 	unlock_page(page);
 	return 0;
 
 out:
-	unlock_kernel();
+	mutex_unlock(&iinfo->lock);
 	SetPageError(page);
 	kunmap(page);
 	unlock_page(page);
diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
index e58d1de..8f140ad 100644
--- a/fs/udf/udf_i.h
+++ b/fs/udf/udf_i.h
@@ -22,6 +22,9 @@ struct udf_inode_info {
 		__u8		*i_data;
 	} i_ext;
 	struct inode vfs_inode;
+
+	/* Serialize writer access, replace the old bkl */
+	struct mutex lock;
 };
 
 static inline struct udf_inode_info *UDF_I(struct inode *inode)
-- 
1.7.0.4

