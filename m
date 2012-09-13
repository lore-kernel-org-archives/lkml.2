Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2IMKIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:08:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544Ab2IMKII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:08:08 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>
Subject: [PATCH 3/3] GFS2: Take account of blockages when using reserved blocks
Date: Thu, 13 Sep 2012 10:42:29 +0100
Message-Id: <1347529349-6704-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1347529349-6704-1-git-send-email-swhiteho@redhat.com>
References: <1347529349-6704-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The claim_reserved_blks() function was not taking account of
the possibility of "blockages" while performing allocation.
This can be caused by another node allocating something in
the same extent which has been reserved locally.

This patch tests for this condition and then skips the remainder
of the reservation in this case. This is a relatively rare event,
so that it should not affect the general performance improvement
which the block reservations provide.

The claim_reserved_blks() function also appears not to be able
to deal with reservations which cross bitmap boundaries, but
that can be dealt with in a future patch since we don't generate
boundary crossing reservations currently.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-by: David Teigland <teigland@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 4d34887..c9ed814 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1961,7 +1961,7 @@ static void gfs2_rgrp_error(struct gfs2_rgrpd *rgd)
  * @dinode: 1 if this block is a dinode block, otherwise data block
  * @nblocks: desired extent length
  *
- * Lay claim to previously allocated block reservation blocks.
+ * Lay claim to previously reserved blocks.
  * Returns: Starting block number of the blocks claimed.
  * Sets *nblocks to the actual extent length allocated.
  */
@@ -1970,19 +1970,17 @@ static u64 claim_reserved_blks(struct gfs2_inode *ip, bool dinode,
 {
 	struct gfs2_blkreserv *rs = ip->i_res;
 	struct gfs2_rgrpd *rgd = rs->rs_rgd;
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_bitmap *bi;
 	u64 start_block = gfs2_rs_startblk(rs);
 	const unsigned int elen = *nblocks;
 
-	/*BUG_ON(!gfs2_glock_is_locked_by_me(ip->i_gl));*/
-	gfs2_assert_withdraw(sdp, rgd);
-	/*BUG_ON(!gfs2_glock_is_locked_by_me(rgd->rd_gl));*/
 	bi = rs->rs_bi;
 	gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
 
 	for (*nblocks = 0; *nblocks < elen && rs->rs_free; (*nblocks)++) {
-		/* Make sure the bitmap hasn't changed */
+		if (gfs2_testbit(rgd, bi->bi_bh->b_data + bi->bi_offset,
+				 bi->bi_len, rs->rs_biblk) != GFS2_BLKST_FREE)
+			break;
 		gfs2_setbit(rgd, bi->bi_clone, bi, rs->rs_biblk,
 			    dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
 		rs->rs_biblk++;
@@ -1991,20 +1989,12 @@ static u64 claim_reserved_blks(struct gfs2_inode *ip, bool dinode,
 		BUG_ON(!rgd->rd_reserved);
 		rgd->rd_reserved--;
 		dinode = false;
-		trace_gfs2_rs(ip, rs, TRACE_RS_CLAIM);
 	}
 
-	if (!rs->rs_free) {
-		struct gfs2_rgrpd *rgd = ip->i_res->rs_rgd;
-
+	trace_gfs2_rs(ip, rs, TRACE_RS_CLAIM);
+	if (!rs->rs_free || *nblocks != elen)
 		gfs2_rs_deltree(rs);
-		/* -nblocks because we haven't returned to do the math yet.
-		   I'm doing the math backwards to prevent negative numbers,
-		   but think of it as:
-		   if (unclaimed_blocks(rgd) - *nblocks >= RGRP_RSRV_MINBLKS */
-		if (unclaimed_blocks(rgd) >= RGRP_RSRV_MINBLKS + *nblocks)
-			rg_mblk_search(rgd, ip);
-	}
+
 	return start_block;
 }
 
@@ -2037,34 +2027,34 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 	if (ip->i_res->rs_requested == 0)
 		return -ECANCELED;
 
-	/* Check if we have a multi-block reservation, and if so, claim the
-	   next free block from it. */
+	/* If we have a reservation, claim blocks from it. */
 	if (gfs2_rs_active(ip->i_res)) {
 		BUG_ON(!ip->i_res->rs_free);
 		rgd = ip->i_res->rs_rgd;
 		block = claim_reserved_blks(ip, dinode, nblocks);
-	} else {
-		rgd = ip->i_rgd;
+		if (*nblocks)
+			goto found_blocks;
+	}
 
-		if (!dinode && rgrp_contains_block(rgd, ip->i_goal))
-			goal = ip->i_goal - rgd->rd_data0;
-		else
-			goal = rgd->rd_last_alloc;
-
-		blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, &bi);
-
-		/* Since all blocks are reserved in advance, this shouldn't
-		   happen */
-		if (blk == BFITNOENT) {
-			printk(KERN_WARNING "BFITNOENT, nblocks=%u\n",
-			       *nblocks);
-			printk(KERN_WARNING "FULL=%d\n",
-			       test_bit(GBF_FULL, &rgd->rd_bits->bi_flags));
-			goto rgrp_error;
-		}
+	rgd = ip->i_rgd;
 
-		block = gfs2_alloc_extent(rgd, bi, blk, dinode, nblocks);
+	if (!dinode && rgrp_contains_block(rgd, ip->i_goal))
+		goal = ip->i_goal - rgd->rd_data0;
+	else
+		goal = rgd->rd_last_alloc;
+
+	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, &bi);
+
+	/* Since all blocks are reserved in advance, this shouldn't happen */
+	if (blk == BFITNOENT) {
+		printk(KERN_WARNING "BFITNOENT, nblocks=%u\n", *nblocks);
+		printk(KERN_WARNING "FULL=%d\n",
+		       test_bit(GBF_FULL, &rgd->rd_bits->bi_flags));
+		goto rgrp_error;
 	}
+
+	block = gfs2_alloc_extent(rgd, bi, blk, dinode, nblocks);
+found_blocks:
 	ndata = *nblocks;
 	if (dinode)
 		ndata--;
-- 
1.7.4

