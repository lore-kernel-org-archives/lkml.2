Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab2AEMQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:16:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757042Ab2AEMQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:16:34 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/16] GFS2: Fix multi-block allocation
Date: Thu,  5 Jan 2012 11:52:00 +0000
Message-Id: <1325764322-10807-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
References: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up gfs2_alloc_blocks so that it takes the full extent length
rather than just the number of non-inode blocks as an argument. That
will only make a difference in the inode allocation case for now.

Also, this fixes the extent length handling around gfs2_alloc_extent() so
that multi block allocations will work again.

The rd_last_alloc block is set to the final block in the allocated
extent (as per the update to i_goal, but referenced to a different
start point).

This also removes the dinode argument to rgblk_search() which is no
longer used.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index ab8c429..e0ada04 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -389,7 +389,7 @@ static int alloc_dinode(struct gfs2_inode *dip, u64 *no_addr, u64 *generation)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	int error;
-	int dblocks = 0;
+	int dblocks = 1;
 
 	error = gfs2_rindex_update(sdp);
 	if (error)
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index f6e05d6..2223462 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -65,7 +65,7 @@ static const char valid_change[16] = {
 };
 
 static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
-			unsigned char old_state, bool dinode,
+			unsigned char old_state,
 			struct gfs2_bitmap **rbi);
 
 /**
@@ -939,7 +939,7 @@ static void try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked, u64 skip
 
 	while (goal < rgd->rd_data) {
 		down_write(&sdp->sd_log_flush_lock);
-		block = rgblk_search(rgd, goal, GFS2_BLKST_UNLINKED, 0, &bi);
+		block = rgblk_search(rgd, goal, GFS2_BLKST_UNLINKED, &bi);
 		up_write(&sdp->sd_log_flush_lock);
 		if (block == BFITNOENT)
 			break;
@@ -1147,14 +1147,14 @@ static unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block)
 }
 
 /**
- * rgblk_search - find a block in @old_state
+ * rgblk_search - find a block in @state
  * @rgd: the resource group descriptor
  * @goal: the goal block within the RG (start here to search for avail block)
- * @old_state: GFS2_BLKST_XXX the before-allocation state to find
+ * @state: GFS2_BLKST_XXX the before-allocation state to find
  * @dinode: TRUE if the first block we allocate is for a dinode
  * @rbi: address of the pointer to the bitmap containing the block found
  *
- * Walk rgrp's bitmap to find bits that represent a block in @old_state.
+ * Walk rgrp's bitmap to find bits that represent a block in @state.
  *
  * This function never fails, because we wouldn't call it unless we
  * know (from reservation results, etc.) that a block is available.
@@ -1166,7 +1166,7 @@ static unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block)
  */
 
 static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
-			unsigned char old_state, bool dinode,
+			unsigned char state,
 			struct gfs2_bitmap **rbi)
 {
 	struct gfs2_bitmap *bi = NULL;
@@ -1198,21 +1198,21 @@ do_search:
 		bi = rgd->rd_bits + buf;
 
 		if (test_bit(GBF_FULL, &bi->bi_flags) &&
-		    (old_state == GFS2_BLKST_FREE))
+		    (state == GFS2_BLKST_FREE))
 			goto skip;
 
 		/* The GFS2_BLKST_UNLINKED state doesn't apply to the clone
 		   bitmaps, so we must search the originals for that. */
 		buffer = bi->bi_bh->b_data + bi->bi_offset;
 		WARN_ON(!buffer_uptodate(bi->bi_bh));
-		if (old_state != GFS2_BLKST_UNLINKED && bi->bi_clone)
+		if (state != GFS2_BLKST_UNLINKED && bi->bi_clone)
 			buffer = bi->bi_clone + bi->bi_offset;
 
-		blk = gfs2_bitfit(buffer, bi->bi_len, goal, old_state);
+		blk = gfs2_bitfit(buffer, bi->bi_len, goal, state);
 		if (blk != BFITNOENT)
 			break;
 
-		if ((goal == 0) && (old_state == GFS2_BLKST_FREE))
+		if ((goal == 0) && (state == GFS2_BLKST_FREE))
 			set_bit(GBF_FULL, &bi->bi_flags);
 
 		/* Try next bitmap block (wrap back to rgrp header if at end) */
@@ -1247,12 +1247,12 @@ static u64 gfs2_alloc_extent(struct gfs2_rgrpd *rgd, struct gfs2_bitmap *bi,
 	u32 goal;
 	const u8 *buffer = NULL;
 
+	*n = 0;
 	buffer = bi->bi_bh->b_data + bi->bi_offset;
 	gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
 	gfs2_setbit(rgd, bi->bi_bh->b_data, bi->bi_clone, bi->bi_offset,
 		    bi, blk, dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
-	if (!dinode)
-		(*n)++;
+	(*n)++;
 	goal = blk;
 	while (*n < elen) {
 		goal++;
@@ -1266,7 +1266,7 @@ static u64 gfs2_alloc_extent(struct gfs2_rgrpd *rgd, struct gfs2_bitmap *bi,
 		(*n)++;
 	}
 	blk = gfs2_bi2rgd_blk(bi, blk);
-	rgd->rd_last_alloc = blk;
+	rgd->rd_last_alloc = blk + *n - 1;
 	return rgd->rd_data0 + blk;
 }
 
@@ -1358,20 +1358,21 @@ static void gfs2_rgrp_error(struct gfs2_rgrpd *rgd)
  * gfs2_alloc_blocks - Allocate one or more blocks of data and/or a dinode
  * @ip: the inode to allocate the block for
  * @bn: Used to return the starting block number
- * @ndata: requested number of data blocks/extent length (value/result)
+ * @ndata: requested number of blocks/extent length (value/result)
  * @dinode: 1 if we're allocating a dinode block, else 0
  * @generation: the generation number of the inode
  *
  * Returns: 0 or error
  */
 
-int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *ndata,
+int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 		      bool dinode, u64 *generation)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct buffer_head *dibh;
 	struct gfs2_rgrpd *rgd;
-	u32 goal, extlen, blk; /* block, within the rgrp scope */
+	unsigned int ndata;
+	u32 goal, blk; /* block, within the rgrp scope */
 	u64 block; /* block, within the file system scope */
 	int error;
 	struct gfs2_bitmap *bi;
@@ -1389,17 +1390,19 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *ndata,
 	else
 		goal = rgd->rd_last_alloc;
 
-	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, dinode, &bi);
+	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, &bi);
 
-	*ndata = 0;
 	/* Since all blocks are reserved in advance, this shouldn't happen */
 	if (blk == BFITNOENT)
 		goto rgrp_error;
 
-	block = gfs2_alloc_extent(rgd, bi, blk, dinode, ndata);
+	block = gfs2_alloc_extent(rgd, bi, blk, dinode, nblocks);
+	ndata = *nblocks;
+	if (dinode)
+		ndata--;
 
 	if (!dinode) {
-		ip->i_goal = block + *ndata - 1;
+		ip->i_goal = block + ndata - 1;
 		error = gfs2_meta_inode_buffer(ip, &dibh);
 		if (error == 0) {
 			struct gfs2_dinode *di =
@@ -1410,13 +1413,10 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *ndata,
 			brelse(dibh);
 		}
 	}
-	extlen = *ndata;
-	if (dinode)
-		extlen++;
-	if (rgd->rd_free < extlen)
+	if (rgd->rd_free < *nblocks)
 		goto rgrp_error;
 
-	rgd->rd_free -= extlen;
+	rgd->rd_free -= *nblocks;
 	if (dinode) {
 		rgd->rd_dinodes++;
 		*generation = rgd->rd_igeneration++;
@@ -1427,15 +1427,20 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *ndata,
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
-	gfs2_statfs_change(sdp, 0, -(s64)extlen, dinode ? 1 : 0);
+	gfs2_statfs_change(sdp, 0, -(s64)*nblocks, dinode ? 1 : 0);
 	if (dinode)
 		gfs2_trans_add_unrevoke(sdp, block, 1);
-	if (*ndata)
-		gfs2_quota_change(ip, *ndata, ip->i_inode.i_uid,
+
+	/*
+	 * This needs reviewing to see why we cannot do the quota change
+	 * at this point in the dinode case.
+	 */
+	if (ndata)
+		gfs2_quota_change(ip, ndata, ip->i_inode.i_uid,
 				  ip->i_inode.i_gid);
 
-	rgd->rd_free_clone -= extlen;
-	trace_gfs2_block_alloc(ip, block, extlen,
+	rgd->rd_free_clone -= *nblocks;
+	trace_gfs2_block_alloc(ip, block, *nblocks,
 			       dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
 	*bn = block;
 	return 0;
-- 
1.7.4

