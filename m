Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab1IPT1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 15:27:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37173 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab1IPT1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 15:27:34 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, tytso@mit.edu,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/3] ext4: migrate code cleanup
Date: Fri, 16 Sep 2011 23:27:27 +0400
Message-Id: <1316201249-16819-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleanup code a bit, actual logic not changed
- Move current block pointer to migrate_structure, let's all
  related info will be in one place.
- Get rid of usless null ind-block ptr checks, caller already
  does that.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/migrate.c |  101 ++++++++++++++++++-----------------------------------
 1 files changed, 34 insertions(+), 67 deletions(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index b57b98f..e263d78 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -21,13 +21,14 @@
  * The contiguous blocks details which can be
  * represented by a single extent
  */
-struct list_blocks_struct {
-	ext4_lblk_t first_block, last_block;
+struct migrate_struct {
+	ext4_lblk_t first_block, last_block, curr_block;
 	ext4_fsblk_t first_pblock, last_pblock;
+
 };
 
 static int finish_range(handle_t *handle, struct inode *inode,
-				struct list_blocks_struct *lb)
+				struct migrate_struct *lb)
 
 {
 	int retval = 0, needed;
@@ -87,8 +88,7 @@ err_out:
 }
 
 static int update_extent_range(handle_t *handle, struct inode *inode,
-				ext4_fsblk_t pblock, ext4_lblk_t blk_num,
-				struct list_blocks_struct *lb)
+				ext4_fsblk_t pblock, struct migrate_struct *lb)
 {
 	int retval;
 	/*
@@ -96,9 +96,10 @@ static int update_extent_range(handle_t *handle, struct inode *inode,
 	 */
 	if (lb->first_pblock &&
 		(lb->last_pblock+1 == pblock) &&
-		(lb->last_block+1 == blk_num)) {
+		(lb->last_block+1 == lb->curr_block)) {
 		lb->last_pblock = pblock;
-		lb->last_block = blk_num;
+		lb->last_block = lb->curr_block;
+		lb->curr_block++;
 		return 0;
 	}
 	/*
@@ -106,64 +107,47 @@ static int update_extent_range(handle_t *handle, struct inode *inode,
 	 */
 	retval = finish_range(handle, inode, lb);
 	lb->first_pblock = lb->last_pblock = pblock;
-	lb->first_block = lb->last_block = blk_num;
-
+	lb->first_block = lb->last_block = lb->curr_block;
+	lb->curr_block++;
 	return retval;
 }
 
 static int update_ind_extent_range(handle_t *handle, struct inode *inode,
-				   ext4_fsblk_t pblock, ext4_lblk_t *blk_nump,
-				   struct list_blocks_struct *lb)
+				ext4_fsblk_t pblock, struct migrate_struct *lb)
 {
 	struct buffer_head *bh;
 	__le32 *i_data;
 	int i, retval = 0;
-	ext4_lblk_t blk_count = *blk_nump;
 	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
 
-	if (!pblock) {
-		/* Only update the file block number */
-		*blk_nump += max_entries;
-		return 0;
-	}
-
 	bh = sb_bread(inode->i_sb, pblock);
 	if (!bh)
 		return -EIO;
 
 	i_data = (__le32 *)bh->b_data;
-	for (i = 0; i < max_entries; i++, blk_count++) {
+	for (i = 0; i < max_entries; i++) {
 		if (i_data[i]) {
 			retval = update_extent_range(handle, inode,
-						le32_to_cpu(i_data[i]),
-						blk_count, lb);
+						le32_to_cpu(i_data[i]), lb);
 			if (retval)
 				break;
+		} else {
+			lb->curr_block++;
 		}
 	}
-
-	/* Update the file block number */
-	*blk_nump = blk_count;
 	put_bh(bh);
 	return retval;
 
 }
 
 static int update_dind_extent_range(handle_t *handle, struct inode *inode,
-				    ext4_fsblk_t pblock, ext4_lblk_t *blk_nump,
-				    struct list_blocks_struct *lb)
+				ext4_fsblk_t pblock, struct migrate_struct *lb)
 {
 	struct buffer_head *bh;
 	__le32 *i_data;
 	int i, retval = 0;
-	ext4_lblk_t blk_count = *blk_nump;
 	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
 
-	if (!pblock) {
-		/* Only update the file block number */
-		*blk_nump += max_entries * max_entries;
-		return 0;
-	}
 	bh = sb_bread(inode->i_sb, pblock);
 	if (!bh)
 		return -EIO;
@@ -172,38 +156,27 @@ static int update_dind_extent_range(handle_t *handle, struct inode *inode,
 	for (i = 0; i < max_entries; i++) {
 		if (i_data[i]) {
 			retval = update_ind_extent_range(handle, inode,
-						le32_to_cpu(i_data[i]),
-						&blk_count, lb);
+						le32_to_cpu(i_data[i]), lb);
 			if (retval)
 				break;
 		} else {
 			/* Only update the file block number */
-			blk_count += max_entries;
+			lb->curr_block += max_entries;
 		}
 	}
-
-	/* Update the file block number */
-	*blk_nump = blk_count;
 	put_bh(bh);
 	return retval;
 
 }
 
 static int update_tind_extent_range(handle_t *handle, struct inode *inode,
-				     ext4_fsblk_t pblock, ext4_lblk_t *blk_nump,
-				     struct list_blocks_struct *lb)
+				ext4_fsblk_t pblock, struct migrate_struct *lb)
 {
 	struct buffer_head *bh;
 	__le32 *i_data;
 	int i, retval = 0;
-	ext4_lblk_t blk_count = *blk_nump;
 	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
 
-	if (!pblock) {
-		/* Only update the file block number */
-		*blk_nump += max_entries * max_entries * max_entries;
-		return 0;
-	}
 	bh = sb_bread(inode->i_sb, pblock);
 	if (!bh)
 		return -EIO;
@@ -211,17 +184,15 @@ static int update_tind_extent_range(handle_t *handle, struct inode *inode,
 	i_data = (__le32 *)bh->b_data;
 	for (i = 0; i < max_entries; i++) {
 		if (i_data[i]) {
-			retval = update_dind_extent_range(handle, inode,
-						le32_to_cpu(i_data[i]),
-						&blk_count, lb);
+			retval = update_ind_extent_range(handle, inode,
+						le32_to_cpu(i_data[i]), lb);
 			if (retval)
 				break;
-		} else
+		} else {
 			/* Only update the file block number */
-			blk_count += max_entries * max_entries;
+			lb->curr_block += max_entries * max_entries;
+		}
 	}
-	/* Update the file block number */
-	*blk_nump = blk_count;
 	put_bh(bh);
 	return retval;
 
@@ -462,10 +433,9 @@ int ext4_ext_migrate(struct inode *inode)
 	handle_t *handle;
 	int retval = 0, i;
 	__le32 *i_data;
-	ext4_lblk_t blk_count = 0;
 	struct ext4_inode_info *ei;
 	struct inode *tmp_inode = NULL;
-	struct list_blocks_struct lb;
+	struct migrate_struct lb;
 	unsigned long max_entries;
 	__u32 goal;
 
@@ -551,35 +521,32 @@ int ext4_ext_migrate(struct inode *inode)
 
 	/* 32 bit block address 4 bytes */
 	max_entries = inode->i_sb->s_blocksize >> 2;
-	for (i = 0; i < EXT4_NDIR_BLOCKS; i++, blk_count++) {
+	for (i = 0; i < EXT4_NDIR_BLOCKS; i++) {
 		if (i_data[i]) {
 			retval = update_extent_range(handle, tmp_inode,
-						le32_to_cpu(i_data[i]),
-						blk_count, &lb);
+						le32_to_cpu(i_data[i]), &lb);
 			if (retval)
 				goto err_out;
-		}
+		} else
+			lb.curr_block++;
 	}
 	if (i_data[EXT4_IND_BLOCK]) {
 		retval = update_ind_extent_range(handle, tmp_inode,
-					le32_to_cpu(i_data[EXT4_IND_BLOCK]),
-					&blk_count, &lb);
+				le32_to_cpu(i_data[EXT4_IND_BLOCK]), &lb);
 			if (retval)
 				goto err_out;
 	} else
-		blk_count +=  max_entries;
+		lb.curr_block += max_entries;
 	if (i_data[EXT4_DIND_BLOCK]) {
 		retval = update_dind_extent_range(handle, tmp_inode,
-					le32_to_cpu(i_data[EXT4_DIND_BLOCK]),
-					&blk_count, &lb);
+				le32_to_cpu(i_data[EXT4_DIND_BLOCK]), &lb);
 			if (retval)
 				goto err_out;
 	} else
-		blk_count += max_entries * max_entries;
+		lb.curr_block += max_entries * max_entries;
 	if (i_data[EXT4_TIND_BLOCK]) {
 		retval = update_tind_extent_range(handle, tmp_inode,
-					le32_to_cpu(i_data[EXT4_TIND_BLOCK]),
-					&blk_count, &lb);
+				le32_to_cpu(i_data[EXT4_TIND_BLOCK]), &lb);
 			if (retval)
 				goto err_out;
 	}
-- 
1.7.2.3

