Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2HRJ6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 05:58:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37883 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab2HRJ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 05:58:38 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jack@suse.cz, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Bonggil Bak <bgbak@samsung.com>
Subject: [PATCH RESEND] udf: extent cache implementation for manipulating block map
Date: Sat, 18 Aug 2012 05:58:22 -0400
Message-Id: <1345283903-7960-1-git-send-email-linkinjeon@gmail.com>
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
 fs/udf/inode.c   |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/udf/udf_i.h   |   13 +++++++++
 fs/udf/udfdecl.h |   13 +++++++++
 4 files changed, 105 insertions(+), 6 deletions(-)

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
index fafaad7..cf34dec 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -345,7 +345,7 @@ static int udf_get_block(struct inode *inode, sector_t block,
 		iinfo->i_next_alloc_goal++;
 	}
 
-
+	udf_clear_extent_cache(iinfo);
 	phys = inode_getblk(inode, block, &err, &new);
 	if (!phys)
 		goto abort;
@@ -1117,6 +1117,7 @@ int udf_setsize(struct inode *inode, loff_t newsize)
 	iinfo = UDF_I(inode);
 	if (newsize > inode->i_size) {
 		down_write(&iinfo->i_data_sem);
+		udf_clear_extent_cache(iinfo);
 		if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 			if (bsize <
 			    (udf_file_entry_alloc_offset(inode) + newsize)) {
@@ -1137,6 +1138,7 @@ int udf_setsize(struct inode *inode, loff_t newsize)
 	} else {
 		if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 			down_write(&iinfo->i_data_sem);
+			udf_clear_extent_cache(iinfo);
 			memset(iinfo->i_ext.i_data + iinfo->i_lenEAttr + newsize,
 			       0x00, bsize - newsize -
 			       udf_file_entry_alloc_offset(inode));
@@ -1150,6 +1152,7 @@ int udf_setsize(struct inode *inode, loff_t newsize)
 		if (err)
 			return err;
 		down_write(&iinfo->i_data_sem);
+		udf_clear_extent_cache(iinfo);
 		truncate_setsize(inode, newsize);
 		udf_truncate_extents(inode);
 		up_write(&iinfo->i_data_sem);
@@ -1267,6 +1270,8 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	iinfo->i_lenAlloc = 0;
 	iinfo->i_next_alloc_block = 0;
 	iinfo->i_next_alloc_goal = 0;
+	memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
+	mutex_init(&(iinfo->i_extent_cache_lock));
 	if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_EFE)) {
 		iinfo->i_efe = 1;
 		iinfo->i_use = 0;
@@ -2118,14 +2123,21 @@ int8_t inode_bmap(struct inode *inode, sector_t block,
 	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
 	loff_t lbcount = 0, bcount =
 	    (loff_t) block << blocksize_bits;
-	int8_t etype;
+	int8_t etype = -1;
 	struct udf_inode_info *iinfo;
 
 	iinfo = UDF_I(inode);
-	pos->offset = 0;
-	pos->block = iinfo->i_location;
-	pos->bh = NULL;
-	*elen = 0;
+
+	if (udf_read_extent_cache(inode, &bcount, &lbcount, elen,
+							pos, eloc, &etype)) {
+		if (etype != -1)
+			goto cache_hit;
+	} else {
+		pos->offset = 0;
+		pos->block = iinfo->i_location;
+		pos->bh = NULL;
+		*elen = 0;
+	}
 
 	do {
 		etype = udf_next_aext(inode, pos, eloc, elen, 1);
@@ -2137,11 +2149,70 @@ int8_t inode_bmap(struct inode *inode, sector_t block,
 		lbcount += *elen;
 	} while (lbcount <= bcount);
 
+	/* update extent cache */
+	udf_update_extent_cache(inode, elen, pos, &lbcount, eloc, &etype);
+
+cache_hit:
 	*offset = (bcount + *elen - lbcount) >> blocksize_bits;
 
 	return etype;
 }
 
+int udf_read_extent_cache(struct inode *inode, loff_t *bcount,
+				loff_t *lbcount, uint32_t *elen,
+				struct extent_position *pos,
+				struct kernel_lb_addr *eloc, int8_t *etype)
+{
+	int ret = 0;
+	struct udf_inode_info *iinfo;
+
+	iinfo = UDF_I(inode);
+	mutex_lock(&iinfo->i_extent_cache_lock);
+	if (((iinfo->cached_extent.last_block - iinfo->cached_extent.elen)
+			<= *bcount) && (iinfo->cached_extent.last_block != 0)) {
+		*elen = iinfo->cached_extent.elen;
+		*lbcount = iinfo->cached_extent.last_block;
+		memcpy(&pos->block, &iinfo->cached_extent.epos,
+				sizeof(struct kernel_lb_addr));
+		pos->offset = iinfo->cached_extent.offset;
+		if (iinfo->cached_extent.p_block_nr != 0)
+			pos->bh = udf_tread(inode->i_sb,
+					   iinfo->cached_extent.p_block_nr);
+		if (in_range(iinfo->cached_extent.last_block,
+					iinfo->cached_extent.elen, *bcount)) {
+			*etype = iinfo->cached_extent.etype;
+			memcpy(eloc, &(iinfo->cached_extent.eloc),
+					sizeof(struct kernel_lb_addr));
+		}
+		ret = 1;
+	}
+	mutex_unlock(&iinfo->i_extent_cache_lock);
+	return ret;
+}
+
+void udf_update_extent_cache(struct inode *inode, uint32_t *elen,
+				struct extent_position *pos, loff_t *lbcount,
+				struct kernel_lb_addr *eloc, int8_t *etype)
+{
+	struct udf_inode_info *iinfo;
+	iinfo = UDF_I(inode);
+	mutex_lock(&iinfo->i_extent_cache_lock);
+	if (pos->bh != NULL)
+		iinfo->cached_extent.p_block_nr =
+			udf_get_lb_pblock(inode->i_sb, &pos->block, 0);
+	else
+		iinfo->cached_extent.p_block_nr = 0;
+	iinfo->cached_extent.elen = *elen;
+	iinfo->cached_extent.last_block = *lbcount;
+	iinfo->cached_extent.etype = *etype;
+	memcpy(&(iinfo->cached_extent.eloc), eloc,
+			sizeof(struct kernel_lb_addr));
+	memcpy(&iinfo->cached_extent.epos, &pos->block,
+			sizeof(struct kernel_lb_addr));
+	iinfo->cached_extent.offset = pos->offset;
+	mutex_unlock(&iinfo->i_extent_cache_lock);
+}
+
 long udf_block_map(struct inode *inode, sector_t block)
 {
 	struct kernel_lb_addr eloc;
diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
index bb8309d..ec168a9 100644
--- a/fs/udf/udf_i.h
+++ b/fs/udf/udf_i.h
@@ -1,6 +1,16 @@
 #ifndef _UDF_I_H
 #define _UDF_I_H
 
+struct udf_ext_cache {
+	struct kernel_lb_addr epos;
+	uint32_t offset;
+	uint32_t p_block_nr;
+	struct kernel_lb_addr eloc;
+	uint32_t elen;
+	int8_t etype;
+	loff_t last_block;
+};
+
 /*
  * The i_data_sem and i_mutex serve for protection of allocation information
  * of a regular files and symlinks. This includes all extents belonging to
@@ -35,6 +45,9 @@ struct udf_inode_info {
 		__u8		*i_data;
 	} i_ext;
 	struct rw_semaphore	i_data_sem;
+	struct udf_ext_cache cached_extent;
+	/* Mutex for protecting extent cache */
+	struct mutex i_extent_cache_lock;
 	struct inode vfs_inode;
 };
 
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index de038da..b3d9f50 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -44,6 +44,7 @@ extern __printf(3, 4) void _udf_warn(struct super_block *sb,
 
 #define udf_fixed_to_variable(x) ( ( ( (x) >> 5 ) * 39 ) + ( (x) & 0x0000001F ) )
 #define udf_variable_to_fixed(x) ( ( ( (x) / 39 ) << 5 ) + ( (x) % 39 ) )
+#define in_range(last, len, b) ((b) >= (last - len) && (b) < last)
 
 #define UDF_EXTENT_LENGTH_MASK	0x3FFFFFFF
 #define UDF_EXTENT_FLAG_MASK	0xC0000000
@@ -52,6 +53,11 @@ extern __printf(3, 4) void _udf_warn(struct super_block *sb,
 #define UDF_NAME_LEN		256
 #define UDF_PATH_LEN		1023
 
+static inline void udf_clear_extent_cache(struct udf_inode_info *iinfo)
+{
+	iinfo->cached_extent.last_block = 0;
+}
+
 static inline size_t udf_file_entry_alloc_offset(struct inode *inode)
 {
 	struct udf_inode_info *iinfo = UDF_I(inode);
@@ -165,6 +171,13 @@ extern int8_t udf_next_aext(struct inode *, struct extent_position *,
 extern int8_t udf_current_aext(struct inode *, struct extent_position *,
 			       struct kernel_lb_addr *, uint32_t *, int);
 
+int udf_read_extent_cache(struct inode *inode, loff_t *bcount, loff_t *lbcount,
+		uint32_t *elen, struct extent_position *pos,
+		struct kernel_lb_addr *eloc, int8_t *etype);
+void udf_update_extent_cache(struct inode *inode, uint32_t *elen,
+		struct extent_position *pos, loff_t *lbcount,
+		struct kernel_lb_addr *eloc, int8_t *etype);
+
 /* misc.c */
 extern struct buffer_head *udf_tgetblk(struct super_block *, int);
 extern struct buffer_head *udf_tread(struct super_block *, int);
-- 
1.7.9.5

