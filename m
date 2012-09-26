Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2IZIxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:53:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab2IZIv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:59 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 21/27] GFS2: Fix unclaimed_blocks() wrapping bug and clean up
Date: Wed, 26 Sep 2012 09:25:42 +0100
Message-Id: <1348647948-3219-22-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When rgd->rd_free_clone is less than rgd->rd_reserved, the
unclaimed_blocks() calculation would wrap and produce
incorrect results. This patch checks for this condition
when this function is called from gfs2_mblk_search()

In addition, the use of this particular function in other
places in the code has been dropped by means of a general
clean up of gfs2_inplace_reserve(). This function is now
much easier to follow.

Also the setting of the rgd->rd_last_alloc field is corrected.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 87ee0b7..8869541 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1231,7 +1231,7 @@ static struct gfs2_blkreserv *rs_insert(struct gfs2_bitmap *bi,
 	BUG_ON(!ip->i_res);
 	BUG_ON(gfs2_rs_active(rs));
 	/* Figure out where to put new node */
-	/*BUG_ON(!gfs2_glock_is_locked_by_me(rgd->rd_gl));*/
+
 	while (*newn) {
 		struct gfs2_blkreserv *cur =
 			rb_entry(*newn, struct gfs2_blkreserv, rs_node);
@@ -1276,17 +1276,16 @@ static u32 unclaimed_blocks(struct gfs2_rgrpd *rgd)
 /**
  * rg_mblk_search - find a group of multiple free blocks
  * @rgd: the resource group descriptor
- * @rs: the block reservation
  * @ip: pointer to the inode for which we're reserving blocks
+ * @requested: number of blocks required for this allocation
  *
  * This is very similar to rgblk_search, except we're looking for whole
  * 64-bit words that represent a chunk of 32 free blocks. I'm only focusing
  * on aligned dwords for speed's sake.
  *
- * Returns: 0 if successful or BFITNOENT if there isn't enough free space
  */
 
-static int rg_mblk_search(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip, unsigned requested)
+static void rg_mblk_search(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip, unsigned requested)
 {
 	struct gfs2_bitmap *bi = rgd->rd_bits;
 	const u32 length = rgd->rd_length;
@@ -1299,11 +1298,16 @@ static int rg_mblk_search(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip, unsigne
 	u32 best_rs_bytes, unclaimed;
 	int best_rs_blocks;
 
+	if ((rgd->rd_free_clone < rgd->rd_reserved) ||
+	    (unclaimed_blocks(rgd) < max(requested, RGRP_RSRV_MINBLKS)))
+		return;
+
 	/* Find bitmap block that contains bits for goal block */
 	if (rgrp_contains_block(rgd, ip->i_goal))
 		goal = ip->i_goal - rgd->rd_data0;
 	else
 		goal = rgd->rd_last_alloc;
+
 	for (buf = 0; buf < length; buf++) {
 		bi = rgd->rd_bits + buf;
 		/* Convert scope of "goal" from rgrp-wide to within
@@ -1366,10 +1370,8 @@ do_search:
 				BUG_ON(blk >= bi->bi_len * GFS2_NBBY);
 				rs = rs_insert(bi, ip, blk,
 					       rsv_bytes * GFS2_NBBY);
-				if (IS_ERR(rs))
-					return PTR_ERR(rs);
 				if (rs)
-					return 0;
+					return;
 			}
 			ptr += ALIGN(search_bytes, sizeof(u64));
 		}
@@ -1380,35 +1382,6 @@ skip:
 		buf %= length;
 		goal = 0;
 	}
-
-	return BFITNOENT;
-}
-
-/**
- * try_rgrp_fit - See if a given reservation will fit in a given RG
- * @rgd: the RG data
- * @ip: the inode
- *
- * If there's room for the requested blocks to be allocated from the RG:
- * This will try to get a multi-block reservation first, and if that doesn't
- * fit, it will take what it can.
- *
- * Returns: 1 on success (it fits), 0 on failure (it doesn't fit)
- */
-
-static int try_rgrp_fit(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip,
-			unsigned requested)
-{
-	if (rgd->rd_flags & (GFS2_RGF_NOALLOC | GFS2_RDF_ERROR))
-		return 0;
-	/* Look for a multi-block reservation. */
-	if (unclaimed_blocks(rgd) >= RGRP_RSRV_MINBLKS &&
-	    rg_mblk_search(rgd, ip, requested) != BFITNOENT)
-		return 1;
-	if (unclaimed_blocks(rgd) >= requested)
-		return 1;
-
-	return 0;
 }
 
 /**
@@ -1678,6 +1651,19 @@ static void try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked, u64 skip
 	return;
 }
 
+static bool gfs2_select_rgrp(struct gfs2_rgrpd **pos, const struct gfs2_rgrpd *begin)
+{
+	struct gfs2_rgrpd *rgd = *pos;
+
+	rgd = gfs2_rgrpd_get_next(rgd);
+	if (rgd == NULL)
+		rgd = gfs2_rgrpd_get_next(NULL);
+	*pos = rgd;
+	if (rgd != begin) /* If we didn't wrap */
+		return true;
+	return false;
+}
+
 /**
  * gfs2_inplace_reserve - Reserve space in the filesystem
  * @ip: the inode to reserve space for
@@ -1697,10 +1683,8 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
 
 	if (sdp->sd_args.ar_rgrplvb)
 		flags |= GL_SKIP;
-	if (gfs2_assert_warn(sdp, requested)) {
-		error = -EINVAL;
-		goto out;
-	}
+	if (gfs2_assert_warn(sdp, requested))
+		return -EINVAL;
 	if (gfs2_rs_active(rs)) {
 		begin = rs->rs_rbm.rgd;
 		flags = 0; /* Yoda: Do or do not. There is no try */
@@ -1713,84 +1697,82 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
 		return -EBADSLT;
 
 	while (loops < 3) {
-		rg_locked = 0;
-
-		if (gfs2_glock_is_locked_by_me(rs->rs_rbm.rgd->rd_gl)) {
-			rg_locked = 1;
-			error = 0;
-		} else if (!loops && !gfs2_rs_active(rs) &&
-			   rs->rs_rbm.rgd->rd_rs_cnt > RGRP_RSRV_MAX_CONTENDERS) {
-			/* If the rgrp already is maxed out for contenders,
-			   we can eliminate it as a "first pass" without even
-			   requesting the rgrp glock. */
-			error = GLR_TRYFAILED;
-		} else {
+		rg_locked = 1;
+
+		if (!gfs2_glock_is_locked_by_me(rs->rs_rbm.rgd->rd_gl)) {
+			rg_locked = 0;
 			error = gfs2_glock_nq_init(rs->rs_rbm.rgd->rd_gl,
 						   LM_ST_EXCLUSIVE, flags,
 						   &rs->rs_rgd_gh);
-			if (!error && sdp->sd_args.ar_rgrplvb) {
+			if (error == GLR_TRYFAILED)
+				goto next_rgrp;
+			if (unlikely(error))
+				return error;
+			if (sdp->sd_args.ar_rgrplvb) {
 				error = update_rgrp_lvb(rs->rs_rbm.rgd);
-				if (error) {
+				if (unlikely(error)) {
 					gfs2_glock_dq_uninit(&rs->rs_rgd_gh);
 					return error;
 				}
 			}
 		}
-		switch (error) {
-		case 0:
-			if (gfs2_rs_active(rs)) {
-				if (unclaimed_blocks(rs->rs_rbm.rgd) +
-				    rs->rs_free >= requested) {
-					ip->i_rgd = rs->rs_rbm.rgd;
-					return 0;
-				}
-				/* We have a multi-block reservation, but the
-				   rgrp doesn't have enough free blocks to
-				   satisfy the request. Free the reservation
-				   and look for a suitable rgrp. */
-				gfs2_rs_deltree(ip, rs);
-			}
-			if (try_rgrp_fit(rs->rs_rbm.rgd, ip, requested)) {
-				if (sdp->sd_args.ar_rgrplvb)
-					gfs2_rgrp_bh_get(rs->rs_rbm.rgd);
-				ip->i_rgd = rs->rs_rbm.rgd;
-				return 0;
-			}
-			if (rs->rs_rbm.rgd->rd_flags & GFS2_RDF_CHECK) {
-				if (sdp->sd_args.ar_rgrplvb)
-					gfs2_rgrp_bh_get(rs->rs_rbm.rgd);
-				try_rgrp_unlink(rs->rs_rbm.rgd, &last_unlinked,
-						ip->i_no_addr);
-			}
-			if (!rg_locked)
-				gfs2_glock_dq_uninit(&rs->rs_rgd_gh);
-			/* fall through */
-		case GLR_TRYFAILED:
-			rs->rs_rbm.rgd = gfs2_rgrpd_get_next(rs->rs_rbm.rgd);
-			rs->rs_rbm.rgd = rs->rs_rbm.rgd ? : begin; /* if NULL, wrap */
-			if (rs->rs_rbm.rgd != begin) /* If we didn't wrap */
-				break;
 
-			flags &= ~LM_FLAG_TRY;
-			loops++;
-			/* Check that fs hasn't grown if writing to rindex */
-			if (ip == GFS2_I(sdp->sd_rindex) &&
-			    !sdp->sd_rindex_uptodate) {
-				error = gfs2_ri_update(ip);
-				if (error)
-					goto out;
-			} else if (loops == 2)
-				/* Flushing the log may release space */
-				gfs2_log_flush(sdp, NULL);
-			break;
-		default:
-			goto out;
+		/* Skip unuseable resource groups */
+		if (rs->rs_rbm.rgd->rd_flags & (GFS2_RGF_NOALLOC | GFS2_RDF_ERROR))
+			goto skip_rgrp;
+
+		if (sdp->sd_args.ar_rgrplvb)
+			gfs2_rgrp_bh_get(rs->rs_rbm.rgd);
+
+		/* Get a reservation if we don't already have one */
+		if (!gfs2_rs_active(rs))
+			rg_mblk_search(rs->rs_rbm.rgd, ip, requested);
+
+		/* Skip rgrps when we can't get a reservation on first pass */
+		if (!gfs2_rs_active(rs) && (loops < 1))
+			goto check_rgrp;
+
+		/* If rgrp has enough free space, use it */
+		if (rs->rs_rbm.rgd->rd_free_clone >= requested) {
+			ip->i_rgd = rs->rs_rbm.rgd;
+			return 0;
 		}
+
+		/* Drop reservation, if we couldn't use reserved rgrp */
+		if (gfs2_rs_active(rs))
+			gfs2_rs_deltree(ip, rs);
+check_rgrp:
+		/* Check for unlinked inodes which can be reclaimed */
+		if (rs->rs_rbm.rgd->rd_flags & GFS2_RDF_CHECK)
+			try_rgrp_unlink(rs->rs_rbm.rgd, &last_unlinked,
+					ip->i_no_addr);
+skip_rgrp:
+		/* Unlock rgrp if required */
+		if (!rg_locked)
+			gfs2_glock_dq_uninit(&rs->rs_rgd_gh);
+next_rgrp:
+		/* Find the next rgrp, and continue looking */
+		if (gfs2_select_rgrp(&rs->rs_rbm.rgd, begin))
+			continue;
+
+		/* If we've scanned all the rgrps, but found no free blocks
+		 * then this checks for some less likely conditions before
+		 * trying again.
+		 */
+		flags &= ~LM_FLAG_TRY;
+		loops++;
+		/* Check that fs hasn't grown if writing to rindex */
+		if (ip == GFS2_I(sdp->sd_rindex) && !sdp->sd_rindex_uptodate) {
+			error = gfs2_ri_update(ip);
+			if (error)
+				return error;
+		}
+		/* Flushing the log may release space */
+		if (loops == 2)
+			gfs2_log_flush(sdp, NULL);
 	}
-	error = -ENOSPC;
 
-out:
-	return error;
+	return -ENOSPC;
 }
 
 /**
@@ -2024,6 +2006,7 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 
 	gfs2_alloc_extent(&rbm, dinode, nblocks);
 	block = gfs2_rbm_to_block(&rbm);
+	rbm.rgd->rd_last_alloc = block - rbm.rgd->rd_data0;
 	if (gfs2_rs_active(ip->i_res))
 		gfs2_adjust_reservation(ip, &rbm, *nblocks);
 	ndata = *nblocks;
-- 
1.7.4

