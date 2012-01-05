Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab2AEMQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:16:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab2AEMQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:16:51 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>, Steven Whitehouse <swhiteho@rehat.com>
Subject: [PATCH 12/16] GFS2: split function rgblk_search
Date: Thu,  5 Jan 2012 11:51:58 +0000
Message-Id: <1325764322-10807-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
References: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch splits function rgblk_search into a function that finds
blocks to allocate (rgblk_search) and a function that assigns those
blocks (gfs2_alloc_extent).

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@rehat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index f1d1960..6b6cc09 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -65,8 +65,8 @@ static const char valid_change[16] = {
 };
 
 static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
-                        unsigned char old_state, bool dinode,
-			unsigned int *ndata);
+			unsigned char old_state, bool dinode,
+			struct gfs2_bitmap **rbi);
 
 /**
  * gfs2_setbit - Set a bit in the bitmaps
@@ -899,6 +899,11 @@ static int try_rgrp_fit(const struct gfs2_rgrpd *rgd, const struct gfs2_inode *i
 	return 0;
 }
 
+static inline u32 gfs2_bi2rgd_blk(struct gfs2_bitmap *bi, u32 blk)
+{
+	return (bi->bi_start * GFS2_NBBY) + blk;
+}
+
 /**
  * try_rgrp_unlink - Look for any unlinked, allocated, but unused inodes
  * @rgd: The rgrp
@@ -912,19 +917,20 @@ static void try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked, u64 skip
 	u32 goal = 0, block;
 	u64 no_addr;
 	struct gfs2_sbd *sdp = rgd->rd_sbd;
-	unsigned int n;
 	struct gfs2_glock *gl;
 	struct gfs2_inode *ip;
 	int error;
 	int found = 0;
+	struct gfs2_bitmap *bi;
 
 	while (goal < rgd->rd_data) {
 		down_write(&sdp->sd_log_flush_lock);
-		n = 1;
-		block = rgblk_search(rgd, goal, GFS2_BLKST_UNLINKED, 0, &n);
+		block = rgblk_search(rgd, goal, GFS2_BLKST_UNLINKED, 0, &bi);
 		up_write(&sdp->sd_log_flush_lock);
 		if (block == BFITNOENT)
 			break;
+
+		block = gfs2_bi2rgd_blk(bi, block);
 		/* rgblk_search can return a block < goal, so we need to
 		   keep it marching forward. */
 		no_addr = block + rgd->rd_data0;
@@ -1109,38 +1115,35 @@ static unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block)
 }
 
 /**
- * rgblk_search - find a block in @old_state, change allocation
- *           state to @new_state
+ * rgblk_search - find a block in @old_state
  * @rgd: the resource group descriptor
  * @goal: the goal block within the RG (start here to search for avail block)
  * @old_state: GFS2_BLKST_XXX the before-allocation state to find
  * @dinode: TRUE if the first block we allocate is for a dinode
- * @n: The extent length
+ * @rbi: address of the pointer to the bitmap containing the block found
  *
  * Walk rgrp's bitmap to find bits that represent a block in @old_state.
- * Add the found bitmap buffer to the transaction.
- * Set the found bits to @new_state to change block's allocation state.
  *
  * This function never fails, because we wouldn't call it unless we
  * know (from reservation results, etc.) that a block is available.
  *
- * Scope of @goal and returned block is just within rgrp, not the whole
- * filesystem.
+ * Scope of @goal is just within rgrp, not the whole filesystem.
+ * Scope of @returned block is just within bitmap, not the whole filesystem.
  *
- * Returns:  the block number allocated
+ * Returns: the block number found relative to the bitmap rbi
  */
 
 static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
-			unsigned char old_state, bool dinode, unsigned int *n)
+			unsigned char old_state, bool dinode,
+			struct gfs2_bitmap **rbi)
 {
 	struct gfs2_bitmap *bi = NULL;
 	const u32 length = rgd->rd_length;
 	u32 blk = BFITNOENT;
 	unsigned int buf, x;
-	const unsigned int elen = *n;
 	const u8 *buffer = NULL;
 
-	*n = 0;
+	*rbi = NULL;
 	/* Find bitmap block that contains bits for goal block */
 	for (buf = 0; buf < length; buf++) {
 		bi = rgd->rd_bits + buf;
@@ -1187,12 +1190,32 @@ skip:
 		goal = 0;
 	}
 
-	if (blk == BFITNOENT)
-		return blk;
+	if (blk != BFITNOENT)
+		*rbi = bi;
 
-	if (old_state == GFS2_BLKST_UNLINKED)
-		goto out;
+	return blk;
+}
 
+/**
+ * gfs2_alloc_extent - allocate an extent from a given bitmap
+ * @rgd: the resource group descriptor
+ * @bi: the bitmap within the rgrp
+ * @blk: the block within the bitmap
+ * @dinode: TRUE if the first block we allocate is for a dinode
+ * @n: The extent length
+ *
+ * Add the found bitmap buffer to the transaction.
+ * Set the found bits to @new_state to change block's allocation state.
+ * Returns: starting block number of the extent (fs scope)
+ */
+static u64 gfs2_alloc_extent(struct gfs2_rgrpd *rgd, struct gfs2_bitmap *bi,
+			     u32 blk, bool dinode, unsigned int *n)
+{
+	const unsigned int elen = *n;
+	u32 goal;
+	const u8 *buffer = NULL;
+
+	buffer = bi->bi_bh->b_data + bi->bi_offset;
 	gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
 	gfs2_setbit(rgd, bi->bi_bh->b_data, bi->bi_clone, bi->bi_offset,
 		    bi, blk, dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
@@ -1210,8 +1233,9 @@ skip:
 			    bi, goal, GFS2_BLKST_USED);
 		(*n)++;
 	}
-out:
-	return (bi->bi_start * GFS2_NBBY) + blk;
+	blk = gfs2_bi2rgd_blk(bi, blk);
+	rgd->rd_last_alloc = blk;
+	return rgd->rd_data0 + blk;
 }
 
 /**
@@ -1319,6 +1343,7 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *ndata,
 	u32 goal, extlen, blk; /* block, within the rgrp scope */
 	u64 block; /* block, within the file system scope */
 	int error;
+	struct gfs2_bitmap *bi;
 
 	/* Only happens if there is a bug in gfs2, return something distinctive
 	 * to ensure that it is noticed.
@@ -1333,14 +1358,15 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *ndata,
 	else
 		goal = rgd->rd_last_alloc;
 
-	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, dinode, ndata);
+	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, dinode, &bi);
 
+	*ndata = 0;
 	/* Since all blocks are reserved in advance, this shouldn't happen */
 	if (blk == BFITNOENT)
 		goto rgrp_error;
 
-	rgd->rd_last_alloc = blk;
-	block = rgd->rd_data0 + blk;
+	block = gfs2_alloc_extent(rgd, bi, blk, dinode, ndata);
+
 	if (!dinode) {
 		ip->i_goal = block + *ndata - 1;
 		error = gfs2_meta_inode_buffer(ip, &dibh);
-- 
1.7.4

