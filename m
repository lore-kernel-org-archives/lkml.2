Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2HaQwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:52:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39341 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab2HaQwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:52:43 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Bonggil Bak <bgbak@samsung.com>
Subject: [PATCH v2] udf: extent cache implementation for manipulating block map
Date: Fri, 31 Aug 2012 12:51:58 -0400
Message-Id: <1346431918-3691-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

While mapping logical blocks of a file to physical blocks on the partition,
everytime UDF read file metadata from the begining which decrease preformance.
The drawback of this scheme is more prominent while reading large files.
For example, while reading a large file of ~5GB, read speed will
gradually become less as we near the end of file because of the time
taken in calculating the corresponding physical block.

This patch implements caching and remembers the location of the last read
extent. Instead of reading file metadata from begining, start from the
cached location.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Signed-off-by: Bonggil Bak <bgbak@samsung.com>
---
 fs/udf/ialloc.c  |    2 ++
 fs/udf/inode.c   |   77 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/udf/udf_i.h   |   17 ++++++++++++
 fs/udf/udfdecl.h |   10 +++----
 4 files changed, 94 insertions(+), 12 deletions(-)

diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index 7e5aae4..7dd86a4 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -117,6 +117,8 @@ struct inode *udf_new_inode(struct inode *dir, umode_t mode, int *err)
 	iinfo->i_lenAlloc = 0;
 	iinfo->i_use = 0;
 	iinfo->i_checkpoint = 1;
+	memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
+	mutex_init(&(iinfo->i_extent_cache_lock));
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_AD_IN_ICB))
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 	else if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 1a0588e..f4cc4e0 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -90,6 +90,7 @@ void udf_evict_inode(struct inode *inode)
 	}
 	kfree(iinfo->i_ext.i_data);
 	iinfo->i_ext.i_data = NULL;
+	udf_clear_extent_cache(iinfo);
 	if (want_delete) {
 		udf_free_inode(inode);
 	}
@@ -133,6 +134,7 @@ static int udf_write_begin(struct file *file, struct address_space *mapping,
 			truncate_pagecache(inode, pos + len, isize);
 			if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
 				down_write(&iinfo->i_data_sem);
+				udf_clear_extent_cache(iinfo);
 				udf_truncate_extents(inode);
 				up_write(&iinfo->i_data_sem);
 			}
@@ -357,8 +359,14 @@ static int udf_get_block(struct inode *inode, sector_t block,
 	if (!phys)
 		goto abort;
 
-	if (new)
+	if (new) {
+		unsigned char lshift = inode->i_sb->s_blocksize_bits;
 		set_buffer_new(bh_result);
+		if (iinfo->cached_extent.sanity &&
+		    (iinfo->cached_extent.eblock > (block << lshift)))
+			/* Block allocated for hole, invalidate cache */
+			udf_clear_extent_cache(iinfo);
+	}
 	map_bh(bh_result, inode->i_sb, phys);
 
 abort:
@@ -1147,6 +1155,7 @@ set_size:
 	} else {
 		if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 			down_write(&iinfo->i_data_sem);
+			udf_clear_extent_cache(iinfo);
 			memset(iinfo->i_ext.i_data + iinfo->i_lenEAttr + newsize,
 			       0x00, bsize - newsize -
 			       udf_file_entry_alloc_offset(inode));
@@ -1160,6 +1169,7 @@ set_size:
 		if (err)
 			return err;
 		down_write(&iinfo->i_data_sem);
+		udf_clear_extent_cache(iinfo);
 		truncate_setsize(inode, newsize);
 		udf_truncate_extents(inode);
 		up_write(&iinfo->i_data_sem);
@@ -1277,6 +1287,8 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	iinfo->i_lenAlloc = 0;
 	iinfo->i_next_alloc_block = 0;
 	iinfo->i_next_alloc_goal = 0;
+	memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
+	mutex_init(&(iinfo->i_extent_cache_lock));
 	if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_EFE)) {
 		iinfo->i_efe = 1;
 		iinfo->i_use = 0;
@@ -2132,11 +2144,12 @@ int8_t inode_bmap(struct inode *inode, sector_t block,
 	struct udf_inode_info *iinfo;
 
 	iinfo = UDF_I(inode);
-	pos->offset = 0;
-	pos->block = iinfo->i_location;
-	pos->bh = NULL;
-	*elen = 0;
-
+	if (!udf_read_extent_cache(inode, bcount, &lbcount, pos)) {
+		pos->offset = 0;
+		pos->block = iinfo->i_location;
+		pos->bh = NULL;
+	}
+		*elen = 0;
 	do {
 		etype = udf_next_aext(inode, pos, eloc, elen, 1);
 		if (etype == -1) {
@@ -2146,7 +2159,8 @@ int8_t inode_bmap(struct inode *inode, sector_t block,
 		}
 		lbcount += *elen;
 	} while (lbcount <= bcount);
-
+	/* update extent cache */
+	udf_update_extent_cache(inode, lbcount - *elen, pos);
 	*offset = (bcount + *elen - lbcount) >> blocksize_bits;
 
 	return etype;
@@ -2176,3 +2190,52 @@ long udf_block_map(struct inode *inode, sector_t block)
 	else
 		return ret;
 }
+int udf_read_extent_cache(struct inode *inode, loff_t bcount,
+			  loff_t *lbcount, struct extent_position *pos)
+{
+	struct udf_inode_info *iinfo = UDF_I(inode);
+	mutex_lock(&iinfo->i_extent_cache_lock);
+	if ((iinfo->cached_extent.eblock <= bcount) &&
+	    (iinfo->cached_extent.sanity)) {
+		/* Cache hit */
+		*lbcount = iinfo->cached_extent.eblock;
+		memcpy(pos, &iinfo->cached_extent.epos,
+		       sizeof(struct extent_position));
+		mutex_unlock(&iinfo->i_extent_cache_lock);
+		return 1;
+	} else
+		udf_clear_extent_cache(iinfo);
+
+	mutex_unlock(&iinfo->i_extent_cache_lock);
+	return 0;
+}
+void udf_update_extent_cache(struct inode *inode, loff_t estart,
+			     struct extent_position *pos)
+{
+	struct udf_inode_info *iinfo = UDF_I(inode);
+	mutex_lock(&iinfo->i_extent_cache_lock);
+	if (pos->bh != NULL)
+		/* Increase ref count */
+		get_bh(pos->bh);
+	memcpy(&iinfo->cached_extent.epos, pos,
+	       sizeof(struct extent_position));
+	iinfo->cached_extent.eblock = estart;
+	iinfo->cached_extent.sanity = 1;
+	switch (iinfo->i_alloc_type) {
+	case ICBTAG_FLAG_AD_SHORT:
+		iinfo->cached_extent.epos.offset -= sizeof(struct short_ad);
+		break;
+	case ICBTAG_FLAG_AD_LONG:
+		iinfo->cached_extent.epos.offset -= sizeof(struct long_ad);
+	}
+	mutex_unlock(&iinfo->i_extent_cache_lock);
+}
+
+void udf_clear_extent_cache(struct udf_inode_info *iinfo)
+{
+	if (iinfo->cached_extent.sanity) {
+		brelse(iinfo->cached_extent.epos.bh);
+		memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
+	}
+}
+
diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
index bb8309d..ec3878a 100644
--- a/fs/udf/udf_i.h
+++ b/fs/udf/udf_i.h
@@ -1,6 +1,20 @@
 #ifndef _UDF_I_H
 #define _UDF_I_H
 
+struct extent_position {
+	struct buffer_head *bh;
+	uint32_t offset;
+	struct kernel_lb_addr block;
+};
+
+struct udf_ext_cache {
+	/* Extent position */
+	struct extent_position epos;
+	/* Start logical block */
+	loff_t eblock;
+	int8_t sanity;
+};
+
 /*
  * The i_data_sem and i_mutex serve for protection of allocation information
  * of a regular files and symlinks. This includes all extents belonging to
@@ -35,6 +49,9 @@ struct udf_inode_info {
 		__u8		*i_data;
 	} i_ext;
 	struct rw_semaphore	i_data_sem;
+	struct udf_ext_cache cached_extent;
+	/* Mutex for protecting extent cache */
+	struct mutex i_extent_cache_lock;
 	struct inode vfs_inode;
 };
 
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index de038da..46eadd3 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -113,11 +113,6 @@ struct ustr {
 	uint8_t u_len;
 };
 
-struct extent_position {
-	struct buffer_head *bh;
-	uint32_t offset;
-	struct kernel_lb_addr block;
-};
 
 /* super.c */
 
@@ -164,6 +159,11 @@ extern int8_t udf_next_aext(struct inode *, struct extent_position *,
 			    struct kernel_lb_addr *, uint32_t *, int);
 extern int8_t udf_current_aext(struct inode *, struct extent_position *,
 			       struct kernel_lb_addr *, uint32_t *, int);
+int udf_read_extent_cache(struct inode *inode, loff_t bcount, loff_t *lbcount,
+			  struct extent_position *pos);
+void udf_update_extent_cache(struct inode *inode, loff_t estart,
+			     struct extent_position *pos);
+void udf_clear_extent_cache(struct udf_inode_info *iinfo);
 
 /* misc.c */
 extern struct buffer_head *udf_tgetblk(struct super_block *, int);
-- 
1.7.9.5

