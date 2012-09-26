Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab2IZI7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:59:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab2IZIvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:32 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/27] GFS2: Add structure to contain rgrp, bitmap, offset tuple
Date: Wed, 26 Sep 2012 09:25:24 +0100
Message-Id: <1348647948-3219-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new structure, gfs2_rbm, which is a
tuple of a resource group, a bitmap within the resource group
and an offset within that bitmap. This is designed to make
manipulating these sets of variables easier. There is also a
new helper function which converts this representation back
to a disk block address.

In addition, the rbtree nodes which are used for the reservations
were not being correctly initialised, which is now fixed. Also,
the tracing was not passing through the inode where it should
have been. That is mostly fixed aside from one corner case. This
needs to be revisited since there can also be a NULL rgrp in
some cases which results in the device being incorrect in the
trace.

This is intended to be the first step towards cleaning up some
of the allocation code, and some further bug fixes.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 49cd7dd..1fd3ae2 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -786,7 +786,7 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 		goto out_rlist;
 
 	if (gfs2_rs_active(ip->i_res)) /* needs to be done with the rgrp glock held */
-		gfs2_rs_deltree(ip->i_res);
+		gfs2_rs_deltree(ip, ip->i_res);
 
 	error = gfs2_trans_begin(sdp, rg_blocks + RES_DINODE +
 				 RES_INDIRECT + RES_STATFS + RES_QUOTA,
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 52078a1..d5e2546 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -102,6 +102,17 @@ struct gfs2_rgrpd {
 	u32 rd_rs_cnt;                  /* count of current reservations */
 };
 
+struct gfs2_rbm {
+	struct gfs2_rgrpd *rgd;
+	struct gfs2_bitmap *bi;	/* Bitmap must belong to the rgd */
+	u32 offset;		/* The offset is bitmap relative */
+};
+
+static inline u64 gfs2_rbm_to_block(const struct gfs2_rbm *rbm)
+{
+	return rbm->rgd->rd_data0 + (rbm->bi->bi_start * GFS2_NBBY) + rbm->offset;
+}
+
 enum gfs2_state_bits {
 	BH_Pinned = BH_PrivateStart,
 	BH_Escaped = BH_PrivateStart + 1,
@@ -251,13 +262,11 @@ struct gfs2_blkreserv {
 	atomic_t rs_sizehint;         /* hint of the write size */
 
 	/* components used during get_local_rgrp (step 3): */
-	struct gfs2_rgrpd *rs_rgd;    /* pointer to the gfs2_rgrpd */
+	struct gfs2_rbm rs_rbm;
 	struct gfs2_holder rs_rgd_gh; /* Filled in by get_local_rgrp */
 	struct rb_node rs_node;       /* link to other block reservations */
 
 	/* components used during block searches and assignments (step 4): */
-	struct gfs2_bitmap *rs_bi;    /* bitmap for the current allocation */
-	u32 rs_biblk;                 /* start block relative to the bi */
 	u32 rs_free;                  /* how many blocks are still free */
 
 	/* ancillary quota stuff */
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index a2b43bb..eaa4188 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -192,7 +192,7 @@ static inline u64 gfs2_bit_search(const __le64 *ptr, u64 mask, u8 state)
  */
 static inline int rs_cmp(u64 blk, u32 len, struct gfs2_blkreserv *rs)
 {
-	u64 startblk = gfs2_rs_startblk(rs);
+	u64 startblk = gfs2_rbm_to_block(&rs->rs_rbm);
 
 	if (blk >= startblk + rs->rs_free)
 		return 1;
@@ -487,6 +487,8 @@ int gfs2_rs_alloc(struct gfs2_inode *ip)
 	if (!res)
 		error = -ENOMEM;
 
+	rb_init_node(&res->rs_node);
+
 	down_write(&ip->i_rw_mutex);
 	if (ip->i_res)
 		kmem_cache_free(gfs2_rsrv_cachep, res);
@@ -499,8 +501,8 @@ int gfs2_rs_alloc(struct gfs2_inode *ip)
 static void dump_rs(struct seq_file *seq, struct gfs2_blkreserv *rs)
 {
 	gfs2_print_dbg(seq, "  r: %llu s:%llu b:%u f:%u\n",
-		       rs->rs_rgd->rd_addr, gfs2_rs_startblk(rs), rs->rs_biblk,
-		       rs->rs_free);
+		       rs->rs_rbm.rgd->rd_addr, gfs2_rbm_to_block(&rs->rs_rbm), 
+		       rs->rs_rbm.offset, rs->rs_free);
 }
 
 /**
@@ -508,40 +510,28 @@ static void dump_rs(struct seq_file *seq, struct gfs2_blkreserv *rs)
  * @rs: The reservation to remove
  *
  */
-static void __rs_deltree(struct gfs2_blkreserv *rs)
+static void __rs_deltree(struct gfs2_inode *ip, struct gfs2_blkreserv *rs)
 {
 	struct gfs2_rgrpd *rgd;
 
 	if (!gfs2_rs_active(rs))
 		return;
 
-	rgd = rs->rs_rgd;
-	/* We can't do this: The reason is that when the rgrp is invalidated,
-	   it's in the "middle" of acquiring the glock, but the HOLDER bit
-	   isn't set yet:
-	   BUG_ON(!gfs2_glock_is_locked_by_me(rs->rs_rgd->rd_gl));*/
-	trace_gfs2_rs(NULL, rs, TRACE_RS_TREEDEL);
-
-	if (!RB_EMPTY_ROOT(&rgd->rd_rstree))
-		rb_erase(&rs->rs_node, &rgd->rd_rstree);
+	rgd = rs->rs_rbm.rgd;
+	trace_gfs2_rs(ip, rs, TRACE_RS_TREEDEL);
+	rb_erase(&rs->rs_node, &rgd->rd_rstree);
+	rb_init_node(&rs->rs_node);
 	BUG_ON(!rgd->rd_rs_cnt);
 	rgd->rd_rs_cnt--;
 
 	if (rs->rs_free) {
 		/* return reserved blocks to the rgrp and the ip */
-		BUG_ON(rs->rs_rgd->rd_reserved < rs->rs_free);
-		rs->rs_rgd->rd_reserved -= rs->rs_free;
+		BUG_ON(rs->rs_rbm.rgd->rd_reserved < rs->rs_free);
+		rs->rs_rbm.rgd->rd_reserved -= rs->rs_free;
 		rs->rs_free = 0;
-		clear_bit(GBF_FULL, &rs->rs_bi->bi_flags);
+		clear_bit(GBF_FULL, &rs->rs_rbm.bi->bi_flags);
 		smp_mb__after_clear_bit();
 	}
-	/* We can't change any of the step 1 or step 2 components of the rs.
-	   E.g. We can't set rs_rgd to NULL because the rgd glock is held and
-	   dequeued through this pointer.
-	   Can't: atomic_set(&rs->rs_sizehint, 0);
-	   Can't: rs->rs_rgd = NULL;*/
-	rs->rs_bi = NULL;
-	rs->rs_biblk = 0;
 }
 
 /**
@@ -549,17 +539,16 @@ static void __rs_deltree(struct gfs2_blkreserv *rs)
  * @rs: The reservation to remove
  *
  */
-void gfs2_rs_deltree(struct gfs2_blkreserv *rs)
+void gfs2_rs_deltree(struct gfs2_inode *ip, struct gfs2_blkreserv *rs)
 {
 	struct gfs2_rgrpd *rgd;
 
-	if (!gfs2_rs_active(rs))
-		return;
-
-	rgd = rs->rs_rgd;
-	spin_lock(&rgd->rd_rsspin);
-	__rs_deltree(rs);
-	spin_unlock(&rgd->rd_rsspin);
+	rgd = rs->rs_rbm.rgd;
+	if (rgd) {
+		spin_lock(&rgd->rd_rsspin);
+		__rs_deltree(ip, rs);
+		spin_unlock(&rgd->rd_rsspin);
+	}
 }
 
 /**
@@ -571,7 +560,7 @@ void gfs2_rs_delete(struct gfs2_inode *ip)
 {
 	down_write(&ip->i_rw_mutex);
 	if (ip->i_res) {
-		gfs2_rs_deltree(ip->i_res);
+		gfs2_rs_deltree(ip, ip->i_res);
 		trace_gfs2_rs(ip, ip->i_res, TRACE_RS_DELETE);
 		BUG_ON(ip->i_res->rs_free);
 		kmem_cache_free(gfs2_rsrv_cachep, ip->i_res);
@@ -596,7 +585,7 @@ static void return_all_reservations(struct gfs2_rgrpd *rgd)
 	spin_lock(&rgd->rd_rsspin);
 	while ((n = rb_first(&rgd->rd_rstree))) {
 		rs = rb_entry(n, struct gfs2_blkreserv, rs_node);
-		__rs_deltree(rs);
+		__rs_deltree(NULL, rs);
 	}
 	spin_unlock(&rgd->rd_rsspin);
 }
@@ -1284,7 +1273,7 @@ static struct gfs2_blkreserv *rs_insert(struct gfs2_bitmap *bi,
 	struct rb_node **newn, *parent = NULL;
 	int rc;
 	struct gfs2_blkreserv *rs = ip->i_res;
-	struct gfs2_rgrpd *rgd = rs->rs_rgd;
+	struct gfs2_rgrpd *rgd = rs->rs_rbm.rgd;
 	u64 fsblock = gfs2_bi2rgd_blk(bi, biblk) + rgd->rd_data0;
 
 	spin_lock(&rgd->rd_rsspin);
@@ -1312,8 +1301,8 @@ static struct gfs2_blkreserv *rs_insert(struct gfs2_bitmap *bi,
 	/* Do our reservation work */
 	rs = ip->i_res;
 	rs->rs_free = amount;
-	rs->rs_biblk = biblk;
-	rs->rs_bi = bi;
+	rs->rs_rbm.offset = biblk;
+	rs->rs_rbm.bi = bi;
 	rb_link_node(&rs->rs_node, parent, newn);
 	rb_insert_color(&rs->rs_node, &rgd->rd_rstree);
 
@@ -1564,34 +1553,34 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
 		goto out;
 	}
 	if (gfs2_rs_active(rs)) {
-		begin = rs->rs_rgd;
+		begin = rs->rs_rbm.rgd;
 		flags = 0; /* Yoda: Do or do not. There is no try */
 	} else if (ip->i_rgd && rgrp_contains_block(ip->i_rgd, ip->i_goal)) {
-		rs->rs_rgd = begin = ip->i_rgd;
+		rs->rs_rbm.rgd = begin = ip->i_rgd;
 	} else {
-		rs->rs_rgd = begin = gfs2_blk2rgrpd(sdp, ip->i_goal, 1);
+		rs->rs_rbm.rgd = begin = gfs2_blk2rgrpd(sdp, ip->i_goal, 1);
 	}
-	if (rs->rs_rgd == NULL)
+	if (rs->rs_rbm.rgd == NULL)
 		return -EBADSLT;
 
 	while (loops < 3) {
 		rg_locked = 0;
 
-		if (gfs2_glock_is_locked_by_me(rs->rs_rgd->rd_gl)) {
+		if (gfs2_glock_is_locked_by_me(rs->rs_rbm.rgd->rd_gl)) {
 			rg_locked = 1;
 			error = 0;
 		} else if (!loops && !gfs2_rs_active(rs) &&
-			   rs->rs_rgd->rd_rs_cnt > RGRP_RSRV_MAX_CONTENDERS) {
+			   rs->rs_rbm.rgd->rd_rs_cnt > RGRP_RSRV_MAX_CONTENDERS) {
 			/* If the rgrp already is maxed out for contenders,
 			   we can eliminate it as a "first pass" without even
 			   requesting the rgrp glock. */
 			error = GLR_TRYFAILED;
 		} else {
-			error = gfs2_glock_nq_init(rs->rs_rgd->rd_gl,
+			error = gfs2_glock_nq_init(rs->rs_rbm.rgd->rd_gl,
 						   LM_ST_EXCLUSIVE, flags,
 						   &rs->rs_rgd_gh);
 			if (!error && sdp->sd_args.ar_rgrplvb) {
-				error = update_rgrp_lvb(rs->rs_rgd);
+				error = update_rgrp_lvb(rs->rs_rbm.rgd);
 				if (error) {
 					gfs2_glock_dq_uninit(&rs->rs_rgd_gh);
 					return error;
@@ -1601,36 +1590,36 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
 		switch (error) {
 		case 0:
 			if (gfs2_rs_active(rs)) {
-				if (unclaimed_blocks(rs->rs_rgd) +
+				if (unclaimed_blocks(rs->rs_rbm.rgd) +
 				    rs->rs_free >= requested) {
-					ip->i_rgd = rs->rs_rgd;
+					ip->i_rgd = rs->rs_rbm.rgd;
 					return 0;
 				}
 				/* We have a multi-block reservation, but the
 				   rgrp doesn't have enough free blocks to
 				   satisfy the request. Free the reservation
 				   and look for a suitable rgrp. */
-				gfs2_rs_deltree(rs);
+				gfs2_rs_deltree(ip, rs);
 			}
-			if (try_rgrp_fit(rs->rs_rgd, ip, requested)) {
+			if (try_rgrp_fit(rs->rs_rbm.rgd, ip, requested)) {
 				if (sdp->sd_args.ar_rgrplvb)
-					gfs2_rgrp_bh_get(rs->rs_rgd);
-				ip->i_rgd = rs->rs_rgd;
+					gfs2_rgrp_bh_get(rs->rs_rbm.rgd);
+				ip->i_rgd = rs->rs_rbm.rgd;
 				return 0;
 			}
-			if (rs->rs_rgd->rd_flags & GFS2_RDF_CHECK) {
+			if (rs->rs_rbm.rgd->rd_flags & GFS2_RDF_CHECK) {
 				if (sdp->sd_args.ar_rgrplvb)
-					gfs2_rgrp_bh_get(rs->rs_rgd);
-				try_rgrp_unlink(rs->rs_rgd, &last_unlinked,
+					gfs2_rgrp_bh_get(rs->rs_rbm.rgd);
+				try_rgrp_unlink(rs->rs_rbm.rgd, &last_unlinked,
 						ip->i_no_addr);
 			}
 			if (!rg_locked)
 				gfs2_glock_dq_uninit(&rs->rs_rgd_gh);
 			/* fall through */
 		case GLR_TRYFAILED:
-			rs->rs_rgd = gfs2_rgrpd_get_next(rs->rs_rgd);
-			rs->rs_rgd = rs->rs_rgd ? : begin; /* if NULL, wrap */
-			if (rs->rs_rgd != begin) /* If we didn't wrap */
+			rs->rs_rbm.rgd = gfs2_rgrpd_get_next(rs->rs_rbm.rgd);
+			rs->rs_rbm.rgd = rs->rs_rbm.rgd ? : begin; /* if NULL, wrap */
+			if (rs->rs_rbm.rgd != begin) /* If we didn't wrap */
 				break;
 
 			flags &= ~LM_FLAG_TRY;
@@ -1776,11 +1765,11 @@ do_search:
 			if (rs == NULL)
 				break;
 
-			BUG_ON(rs->rs_bi != bi);
+			BUG_ON(rs->rs_rbm.bi != bi);
 			biblk = BFITNOENT;
 			/* This should jump to the first block after the
 			   reservation. */
-			goal = rs->rs_biblk + rs->rs_free;
+			goal = rs->rs_rbm.offset + rs->rs_free;
 			if (goal >= bi->bi_len * GFS2_NBBY)
 				break;
 		}
@@ -1805,9 +1794,7 @@ skip:
 
 /**
  * gfs2_alloc_extent - allocate an extent from a given bitmap
- * @rgd: the resource group descriptor
- * @bi: the bitmap within the rgrp
- * @blk: the block within the bitmap
+ * @rbm: the resource group information
  * @dinode: TRUE if the first block we allocate is for a dinode
  * @n: The extent length
  *
@@ -1815,9 +1802,12 @@ skip:
  * Set the found bits to @new_state to change block's allocation state.
  * Returns: starting block number of the extent (fs scope)
  */
-static u64 gfs2_alloc_extent(struct gfs2_rgrpd *rgd, struct gfs2_bitmap *bi,
-			     u32 blk, bool dinode, unsigned int *n)
+static u64 gfs2_alloc_extent(const struct gfs2_rbm *rbm, bool dinode,
+			     unsigned int *n)
 {
+	struct gfs2_rgrpd *rgd = rbm->rgd;
+	struct gfs2_bitmap *bi = rbm->bi;
+	u32 blk = rbm->offset;
 	const unsigned int elen = *n;
 	u32 goal, rgblk;
 	const u8 *buffer = NULL;
@@ -1956,21 +1946,21 @@ static u64 claim_reserved_blks(struct gfs2_inode *ip, bool dinode,
 			       unsigned int *nblocks)
 {
 	struct gfs2_blkreserv *rs = ip->i_res;
-	struct gfs2_rgrpd *rgd = rs->rs_rgd;
+	struct gfs2_rgrpd *rgd = rs->rs_rbm.rgd;
 	struct gfs2_bitmap *bi;
-	u64 start_block = gfs2_rs_startblk(rs);
+	u64 start_block = gfs2_rbm_to_block(&rs->rs_rbm);
 	const unsigned int elen = *nblocks;
 
-	bi = rs->rs_bi;
+	bi = rs->rs_rbm.bi;
 	gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
 
 	for (*nblocks = 0; *nblocks < elen && rs->rs_free; (*nblocks)++) {
 		if (gfs2_testbit(rgd, bi->bi_bh->b_data + bi->bi_offset,
-				 bi->bi_len, rs->rs_biblk) != GFS2_BLKST_FREE)
+				 bi->bi_len, rs->rs_rbm.offset) != GFS2_BLKST_FREE)
 			break;
-		gfs2_setbit(rgd, bi->bi_clone, bi, rs->rs_biblk,
+		gfs2_setbit(rgd, bi->bi_clone, bi, rs->rs_rbm.offset,
 			    dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
-		rs->rs_biblk++;
+		rs->rs_rbm.offset++;
 		rs->rs_free--;
 
 		BUG_ON(!rgd->rd_reserved);
@@ -1980,7 +1970,7 @@ static u64 claim_reserved_blks(struct gfs2_inode *ip, bool dinode,
 
 	trace_gfs2_rs(ip, rs, TRACE_RS_CLAIM);
 	if (!rs->rs_free || *nblocks != elen)
-		gfs2_rs_deltree(rs);
+		gfs2_rs_deltree(ip, rs);
 
 	return start_block;
 }
@@ -2001,40 +1991,37 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct buffer_head *dibh;
-	struct gfs2_rgrpd *rgd;
+	struct gfs2_rbm rbm = { .rgd = ip->i_rgd, };
 	unsigned int ndata;
-	u32 goal, blk; /* block, within the rgrp scope */
+	u32 goal; /* block, within the rgrp scope */
 	u64 block; /* block, within the file system scope */
 	int error;
-	struct gfs2_bitmap *bi;
 
 	/* If we have a reservation, claim blocks from it. */
 	if (gfs2_rs_active(ip->i_res)) {
 		BUG_ON(!ip->i_res->rs_free);
-		rgd = ip->i_res->rs_rgd;
+		rbm.rgd = ip->i_res->rs_rbm.rgd;
 		block = claim_reserved_blks(ip, dinode, nblocks);
 		if (*nblocks)
 			goto found_blocks;
 	}
 
-	rgd = ip->i_rgd;
-
-	if (!dinode && rgrp_contains_block(rgd, ip->i_goal))
-		goal = ip->i_goal - rgd->rd_data0;
+	if (!dinode && rgrp_contains_block(rbm.rgd, ip->i_goal))
+		goal = ip->i_goal - rbm.rgd->rd_data0;
 	else
-		goal = rgd->rd_last_alloc;
+		goal = rbm.rgd->rd_last_alloc;
 
-	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, &bi);
+	rbm.offset = rgblk_search(rbm.rgd, goal, GFS2_BLKST_FREE, &rbm.bi);
 
 	/* Since all blocks are reserved in advance, this shouldn't happen */
-	if (blk == BFITNOENT) {
+	if (rbm.offset == BFITNOENT) {
 		printk(KERN_WARNING "BFITNOENT, nblocks=%u\n", *nblocks);
 		printk(KERN_WARNING "FULL=%d\n",
-		       test_bit(GBF_FULL, &rgd->rd_bits->bi_flags));
+		       test_bit(GBF_FULL, &rbm.rgd->rd_bits->bi_flags));
 		goto rgrp_error;
 	}
 
-	block = gfs2_alloc_extent(rgd, bi, blk, dinode, nblocks);
+	block = gfs2_alloc_extent(&rbm, dinode, nblocks);
 found_blocks:
 	ndata = *nblocks;
 	if (dinode)
@@ -2052,22 +2039,22 @@ found_blocks:
 			brelse(dibh);
 		}
 	}
-	if (rgd->rd_free < *nblocks) {
+	if (rbm.rgd->rd_free < *nblocks) {
 		printk(KERN_WARNING "nblocks=%u\n", *nblocks);
 		goto rgrp_error;
 	}
 
-	rgd->rd_free -= *nblocks;
+	rbm.rgd->rd_free -= *nblocks;
 	if (dinode) {
-		rgd->rd_dinodes++;
-		*generation = rgd->rd_igeneration++;
+		rbm.rgd->rd_dinodes++;
+		*generation = rbm.rgd->rd_igeneration++;
 		if (*generation == 0)
-			*generation = rgd->rd_igeneration++;
+			*generation = rbm.rgd->rd_igeneration++;
 	}
 
-	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
-	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
-	gfs2_rgrp_ondisk2lvb(rgd->rd_rgl, rgd->rd_bits[0].bi_bh->b_data);
+	gfs2_trans_add_bh(rbm.rgd->rd_gl, rbm.rgd->rd_bits[0].bi_bh, 1);
+	gfs2_rgrp_out(rbm.rgd, rbm.rgd->rd_bits[0].bi_bh->b_data);
+	gfs2_rgrp_ondisk2lvb(rbm.rgd->rd_rgl, rbm.rgd->rd_bits[0].bi_bh->b_data);
 
 	gfs2_statfs_change(sdp, 0, -(s64)*nblocks, dinode ? 1 : 0);
 	if (dinode)
@@ -2081,14 +2068,14 @@ found_blocks:
 		gfs2_quota_change(ip, ndata, ip->i_inode.i_uid,
 				  ip->i_inode.i_gid);
 
-	rgd->rd_free_clone -= *nblocks;
-	trace_gfs2_block_alloc(ip, rgd, block, *nblocks,
+	rbm.rgd->rd_free_clone -= *nblocks;
+	trace_gfs2_block_alloc(ip, rbm.rgd, block, *nblocks,
 			       dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
 	*bn = block;
 	return 0;
 
 rgrp_error:
-	gfs2_rgrp_error(rgd);
+	gfs2_rgrp_error(rbm.rgd);
 	return -EIO;
 }
 
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 0b0e9cc..c98f6af 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -46,7 +46,7 @@ extern int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
 			     bool dinode, u64 *generation);
 
 extern int gfs2_rs_alloc(struct gfs2_inode *ip);
-extern void gfs2_rs_deltree(struct gfs2_blkreserv *rs);
+extern void gfs2_rs_deltree(struct gfs2_inode *ip, struct gfs2_blkreserv *rs);
 extern void gfs2_rs_delete(struct gfs2_inode *ip);
 extern void __gfs2_free_blocks(struct gfs2_inode *ip, u64 bstart, u32 blen, int meta);
 extern void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen);
@@ -73,22 +73,16 @@ extern int gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
 				   const struct gfs2_bitmap *bi, unsigned minlen, u64 *ptrimmed);
 extern int gfs2_fitrim(struct file *filp, void __user *argp);
 
-/* This is how to tell if a multi-block reservation is in the rgrp tree: */
-static inline int gfs2_rs_active(struct gfs2_blkreserv *rs)
+/* This is how to tell if a reservation is in the rgrp tree: */
+static inline bool gfs2_rs_active(struct gfs2_blkreserv *rs)
 {
-	if (rs && rs->rs_bi)
-		return 1;
-	return 0;
+	return rs && !RB_EMPTY_NODE(&rs->rs_node);
 }
 
+
 static inline u32 gfs2_bi2rgd_blk(const struct gfs2_bitmap *bi, u32 blk)
 {
 	return (bi->bi_start * GFS2_NBBY) + blk;
 }
 
-static inline u64 gfs2_rs_startblk(const struct gfs2_blkreserv *rs)
-{
-	return gfs2_bi2rgd_blk(rs->rs_bi, rs->rs_biblk) + rs->rs_rgd->rd_data0;
-}
-
 #endif /* __RGRP_DOT_H__ */
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index fc3168f..3cbac68 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1557,7 +1557,7 @@ out_truncate:
 out_unlock:
 	/* Error path for case 1 */
 	if (gfs2_rs_active(ip->i_res))
-		gfs2_rs_deltree(ip->i_res);
+		gfs2_rs_deltree(ip, ip->i_res);
 
 	if (test_bit(HIF_HOLDER, &ip->i_iopen_gh.gh_iflags))
 		gfs2_glock_dq(&ip->i_iopen_gh);
diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
index a25c252..b947aa4 100644
--- a/fs/gfs2/trace_gfs2.h
+++ b/fs/gfs2/trace_gfs2.h
@@ -526,12 +526,12 @@ TRACE_EVENT(gfs2_rs,
 	),
 
 	TP_fast_assign(
-		__entry->dev		= rs->rs_rgd ? rs->rs_rgd->rd_sbd->sd_vfs->s_dev : 0;
-		__entry->rd_addr	= rs->rs_rgd ? rs->rs_rgd->rd_addr : 0;
-		__entry->rd_free_clone	= rs->rs_rgd ? rs->rs_rgd->rd_free_clone : 0;
-		__entry->rd_reserved	= rs->rs_rgd ? rs->rs_rgd->rd_reserved : 0;
+		__entry->dev		= rs->rs_rbm.rgd ? rs->rs_rbm.rgd->rd_sbd->sd_vfs->s_dev : 0;
+		__entry->rd_addr	= rs->rs_rbm.rgd ? rs->rs_rbm.rgd->rd_addr : 0;
+		__entry->rd_free_clone	= rs->rs_rbm.rgd ? rs->rs_rbm.rgd->rd_free_clone : 0;
+		__entry->rd_reserved	= rs->rs_rbm.rgd ? rs->rs_rbm.rgd->rd_reserved : 0;
 		__entry->inum		= ip ? ip->i_no_addr : 0;
-		__entry->start		= gfs2_rs_startblk(rs);
+		__entry->start		= gfs2_rbm_to_block(&rs->rs_rbm);
 		__entry->free		= rs->rs_free;
 		__entry->func		= func;
 	),
-- 
1.7.4

