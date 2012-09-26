Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab2IZIvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:51:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab2IZIvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:33 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/27] GFS2: Replace rgblk_search with gfs2_rbm_find
Date: Wed, 26 Sep 2012 09:25:25 +0100
Message-Id: <1348647948-3219-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of a series of patches which are introducing the
gfs2_rbm structure throughout the block allocation code. The
main aim of this part is to create a search function which can
deal directly with struct gfs2_rbm. In this case it specifies
the initial position at which to start the search and also the
point at which the search terminates.

The net result of this is to clean up the search code and make
it rather more readable, and the various possible exceptions which
may occur during the search are partitioned into their own functions.

There are some bug fixes too. We should not be checking the reservations
while allocating extents - the time for that is when we are searching
for where to put the extent, not when we've already made that decision.

Also, rgblk_search had two uses, and in only one of those cases did
it make sense to check for reservations. This is fixed in the new
gfs2_rbm_find function, which has a cleaner interface.

The reservation checking has been improved by always checking for
contiguous reservations, and returning the first free block after
all contiguous reservations. This is done under the spin lock to
ensure consistancy of the tree.

The allocation of extents is now in all cases done by the existing
allocation code, and if there is an active reservation, that is updated
after the fact. Again this is done under the spin lock, since it entails
changing the lookup key for the reservation in question.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index d5e2546..99d7c64 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -113,6 +113,13 @@ static inline u64 gfs2_rbm_to_block(const struct gfs2_rbm *rbm)
 	return rbm->rgd->rd_data0 + (rbm->bi->bi_start * GFS2_NBBY) + rbm->offset;
 }
 
+static inline bool gfs2_rbm_eq(const struct gfs2_rbm *rbm1,
+			       const struct gfs2_rbm *rbm2)
+{
+	return (rbm1->rgd == rbm2->rgd) && (rbm1->bi == rbm2->bi) && 
+	       (rbm1->offset == rbm2->offset);
+}
+
 enum gfs2_state_bits {
 	BH_Pinned = BH_PrivateStart,
 	BH_Escaped = BH_PrivateStart + 1,
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index eaa4188..bd3b926 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -67,10 +67,6 @@ static const char valid_change[16] = {
 	        1, 0, 0, 0
 };
 
-static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
-			unsigned char old_state,
-			struct gfs2_bitmap **rbi);
-
 /**
  * gfs2_setbit - Set a bit in the bitmaps
  * @rgd: the resource group descriptor
@@ -202,36 +198,6 @@ static inline int rs_cmp(u64 blk, u32 len, struct gfs2_blkreserv *rs)
 }
 
 /**
- * rs_find - Find a rgrp multi-block reservation that contains a given block
- * @rgd: The rgrp
- * @rgblk: The block we're looking for, relative to the rgrp
- */
-static struct gfs2_blkreserv *rs_find(struct gfs2_rgrpd *rgd, u32 rgblk)
-{
-	struct rb_node **newn;
-	int rc;
-	u64 fsblk = rgblk + rgd->rd_data0;
-
-	spin_lock(&rgd->rd_rsspin);
-	newn = &rgd->rd_rstree.rb_node;
-	while (*newn) {
-		struct gfs2_blkreserv *cur =
-			rb_entry(*newn, struct gfs2_blkreserv, rs_node);
-		rc = rs_cmp(fsblk, 1, cur);
-		if (rc < 0)
-			newn = &((*newn)->rb_left);
-		else if (rc > 0)
-			newn = &((*newn)->rb_right);
-		else {
-			spin_unlock(&rgd->rd_rsspin);
-			return cur;
-		}
-	}
-	spin_unlock(&rgd->rd_rsspin);
-	return NULL;
-}
-
-/**
  * gfs2_bitfit - Search an rgrp's bitmap buffer to find a bit-pair representing
  *       a block in a given allocation state.
  * @buf: the buffer that holds the bitmaps
@@ -1306,9 +1272,6 @@ static struct gfs2_blkreserv *rs_insert(struct gfs2_bitmap *bi,
 	rb_link_node(&rs->rs_node, parent, newn);
 	rb_insert_color(&rs->rs_node, &rgd->rd_rstree);
 
-	/* Do our inode accounting for the reservation */
-	/*BUG_ON(!gfs2_glock_is_locked_by_me(ip->i_gl));*/
-
 	/* Do our rgrp accounting for the reservation */
 	rgd->rd_reserved += amount; /* blocks reserved */
 	rgd->rd_rs_cnt++; /* number of in-tree reservations */
@@ -1464,6 +1427,199 @@ static int try_rgrp_fit(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip,
 }
 
 /**
+ * gfs2_next_unreserved_block - Return next block that is not reserved
+ * @rgd: The resource group
+ * @block: The starting block
+ * @ip: Ignore any reservations for this inode
+ *
+ * If the block does not appear in any reservation, then return the
+ * block number unchanged. If it does appear in the reservation, then
+ * keep looking through the tree of reservations in order to find the
+ * first block number which is not reserved.
+ */
+
+static u64 gfs2_next_unreserved_block(struct gfs2_rgrpd *rgd, u64 block,
+				      const struct gfs2_inode *ip)
+{
+	struct gfs2_blkreserv *rs;
+	struct rb_node *n;
+	int rc;
+
+	spin_lock(&rgd->rd_rsspin);
+	n = rb_first(&rgd->rd_rstree);
+	while (n) {
+		rs = rb_entry(n, struct gfs2_blkreserv, rs_node);
+		rc = rs_cmp(block, 1, rs);
+		if (rc < 0)
+			n = n->rb_left;
+		else if (rc > 0)
+			n = n->rb_right;
+		else
+			break;
+	}
+
+	if (n) {
+		while ((rs_cmp(block, 1, rs) == 0) && (ip->i_res != rs)) {
+			block = gfs2_rbm_to_block(&rs->rs_rbm) + rs->rs_free;
+			n = rb_next(&rs->rs_node);
+			if (n == NULL)
+				break;
+			rs = rb_entry(n, struct gfs2_blkreserv, rs_node);
+		}
+	}
+
+	spin_unlock(&rgd->rd_rsspin);
+	return block;
+}
+
+/**
+ * gfs2_rbm_from_block - Set the rbm based upon rgd and block number
+ * @rbm: The rbm with rgd already set correctly
+ * @block: The block number (filesystem relative)
+ *
+ * This sets the bi and offset members of an rbm based on a
+ * resource group and a filesystem relative block number. The
+ * resource group must be set in the rbm on entry, the bi and
+ * offset members will be set by this function.
+ *
+ * Returns: 0 on success, or an error code
+ */
+
+static int gfs2_rbm_from_block(struct gfs2_rbm *rbm, u64 block)
+{
+	u64 rblock = block - rbm->rgd->rd_data0;
+	u32 goal = (u32)rblock;
+	int x;
+
+	if (WARN_ON_ONCE(rblock > UINT_MAX))
+		return -EINVAL;
+
+	for (x = 0; x < rbm->rgd->rd_length; x++) {
+		rbm->bi = rbm->rgd->rd_bits + x;
+		if (goal < (rbm->bi->bi_start + rbm->bi->bi_len) * GFS2_NBBY) {
+			rbm->offset = goal - (rbm->bi->bi_start * GFS2_NBBY);
+			return 0;
+		}
+	}
+
+	return -E2BIG;
+}
+
+/**
+ * gfs2_reservation_check_and_update - Check for reservations during block alloc
+ * @rbm: The current position in the resource group
+ *
+ * This checks the current position in the rgrp to see whether there is
+ * a reservation covering this block. If not then this function is a
+ * no-op. If there is, then the position is moved to the end of the
+ * contiguous reservation(s) so that we are pointing at the first
+ * non-reserved block.
+ *
+ * Returns: 0 if no reservation, 1 if @rbm has changed, otherwise an error
+ */
+
+static int gfs2_reservation_check_and_update(struct gfs2_rbm *rbm,
+					     const struct gfs2_inode *ip)
+{
+	u64 block = gfs2_rbm_to_block(rbm);
+	u64 nblock;
+	int ret;
+
+	nblock = gfs2_next_unreserved_block(rbm->rgd, block, ip);
+	if (nblock == block)
+		return 0;
+	ret = gfs2_rbm_from_block(rbm, nblock);
+	if (ret < 0)
+		return ret;
+	return 1;
+}
+
+/**
+ * gfs2_rbm_find - Look for blocks of a particular state
+ * @rbm: Value/result starting position and final position
+ * @state: The state which we want to find
+ * @ip: If set, check for reservations
+ * @nowrap: Stop looking at the end of the rgrp, rather than wrapping
+ *          around until we've reached the starting point.
+ *
+ * Side effects:
+ * - If looking for free blocks, we set GBF_FULL on each bitmap which
+ *   has no free blocks in it.
+ *
+ * Returns: 0 on success, -ENOSPC if there is no block of the requested state
+ */
+
+static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state,
+			 const struct gfs2_inode *ip, bool nowrap)
+{
+	struct buffer_head *bh;
+	struct gfs2_bitmap *initial_bi;
+	u32 initial_offset;
+	u32 offset;
+	u8 *buffer;
+	int index;
+	int n = 0;
+	int iters = rbm->rgd->rd_length;
+	int ret;
+
+	/* If we are not starting at the beginning of a bitmap, then we
+	 * need to add one to the bitmap count to ensure that we search
+	 * the starting bitmap twice.
+	 */
+	if (rbm->offset != 0)
+		iters++;
+
+	while(1) {
+		if (test_bit(GBF_FULL, &rbm->bi->bi_flags) &&
+		    (state == GFS2_BLKST_FREE))
+			goto next_bitmap;
+
+		bh = rbm->bi->bi_bh;
+		buffer = bh->b_data + rbm->bi->bi_offset;
+		WARN_ON(!buffer_uptodate(bh));
+		if (state != GFS2_BLKST_UNLINKED && rbm->bi->bi_clone)
+			buffer = rbm->bi->bi_clone + rbm->bi->bi_offset;
+find_next:
+		initial_offset = rbm->offset;
+		offset = gfs2_bitfit(buffer, rbm->bi->bi_len, rbm->offset, state);
+		if (offset == BFITNOENT)
+			goto bitmap_full;
+		rbm->offset = offset;
+		if (ip == NULL)
+			return 0;
+
+		initial_bi = rbm->bi;
+		ret = gfs2_reservation_check_and_update(rbm, ip);
+		if (ret == 0)
+			return 0;
+		if (ret > 0) {
+			n += (rbm->bi - initial_bi);
+			goto find_next;
+		}
+		return ret;
+
+bitmap_full:	/* Mark bitmap as full and fall through */
+		if ((state == GFS2_BLKST_FREE) && initial_offset == 0)
+			set_bit(GBF_FULL, &rbm->bi->bi_flags);
+
+next_bitmap:	/* Find next bitmap in the rgrp */
+		rbm->offset = 0;
+		index = rbm->bi - rbm->rgd->rd_bits;
+		index++;
+		if (index == rbm->rgd->rd_length)
+			index = 0;
+		rbm->bi = &rbm->rgd->rd_bits[index];
+		if ((index == 0) && nowrap)
+			break;
+		n++;
+		if (n >= iters)
+			break;
+	}
+
+	return -ENOSPC;
+}
+
+/**
  * try_rgrp_unlink - Look for any unlinked, allocated, but unused inodes
  * @rgd: The rgrp
  * @last_unlinked: block address of the last dinode we unlinked
@@ -1475,34 +1631,33 @@ static int try_rgrp_fit(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip,
 
 static void try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked, u64 skip)
 {
-	u32 goal = 0, block;
-	u64 no_addr;
+	u64 block;
 	struct gfs2_sbd *sdp = rgd->rd_sbd;
 	struct gfs2_glock *gl;
 	struct gfs2_inode *ip;
 	int error;
 	int found = 0;
-	struct gfs2_bitmap *bi;
+	struct gfs2_rbm rbm = { .rgd = rgd, .bi = rgd->rd_bits, .offset = 0 };
 
-	while (goal < rgd->rd_data) {
+	while (1) {
 		down_write(&sdp->sd_log_flush_lock);
-		block = rgblk_search(rgd, goal, GFS2_BLKST_UNLINKED, &bi);
+		error = gfs2_rbm_find(&rbm, GFS2_BLKST_UNLINKED, NULL, true);
 		up_write(&sdp->sd_log_flush_lock);
-		if (block == BFITNOENT)
+		if (error == -ENOSPC)
+			break;
+		if (WARN_ON_ONCE(error))
 			break;
 
-		block = gfs2_bi2rgd_blk(bi, block);
-		/* rgblk_search can return a block < goal, so we need to
-		   keep it marching forward. */
-		no_addr = block + rgd->rd_data0;
-		goal = max(block + 1, goal + 1);
-		if (*last_unlinked != NO_BLOCK && no_addr <= *last_unlinked)
+		block = gfs2_rbm_to_block(&rbm);
+		if (gfs2_rbm_from_block(&rbm, block + 1))
+			break;
+		if (*last_unlinked != NO_BLOCK && block <= *last_unlinked)
 			continue;
-		if (no_addr == skip)
+		if (block == skip)
 			continue;
-		*last_unlinked = no_addr;
+		*last_unlinked = block;
 
-		error = gfs2_glock_get(sdp, no_addr, &gfs2_inode_glops, CREATE, &gl);
+		error = gfs2_glock_get(sdp, block, &gfs2_inode_glops, CREATE, &gl);
 		if (error)
 			continue;
 
@@ -1692,105 +1847,6 @@ static unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block)
 	return type;
 }
 
-/**
- * rgblk_search - find a block in @state
- * @rgd: the resource group descriptor
- * @goal: the goal block within the RG (start here to search for avail block)
- * @state: GFS2_BLKST_XXX the before-allocation state to find
- * @rbi: address of the pointer to the bitmap containing the block found
- *
- * Walk rgrp's bitmap to find bits that represent a block in @state.
- *
- * This function never fails, because we wouldn't call it unless we
- * know (from reservation results, etc.) that a block is available.
- *
- * Scope of @goal is just within rgrp, not the whole filesystem.
- * Scope of @returned block is just within bitmap, not the whole filesystem.
- *
- * Returns: the block number found relative to the bitmap rbi
- */
-
-static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal, unsigned char state,
-			struct gfs2_bitmap **rbi)
-{
-	struct gfs2_bitmap *bi = NULL;
-	const u32 length = rgd->rd_length;
-	u32 biblk = BFITNOENT;
-	unsigned int buf, x;
-	const u8 *buffer = NULL;
-
-	*rbi = NULL;
-	/* Find bitmap block that contains bits for goal block */
-	for (buf = 0; buf < length; buf++) {
-		bi = rgd->rd_bits + buf;
-		/* Convert scope of "goal" from rgrp-wide to within found bit block */
-		if (goal < (bi->bi_start + bi->bi_len) * GFS2_NBBY) {
-			goal -= bi->bi_start * GFS2_NBBY;
-			goto do_search;
-		}
-	}
-	buf = 0;
-	goal = 0;
-
-do_search:
-	/* Search (up to entire) bitmap in this rgrp for allocatable block.
-	   "x <= length", instead of "x < length", because we typically start
-	   the search in the middle of a bit block, but if we can't find an
-	   allocatable block anywhere else, we want to be able wrap around and
-	   search in the first part of our first-searched bit block.  */
-	for (x = 0; x <= length; x++) {
-		bi = rgd->rd_bits + buf;
-
-		if (test_bit(GBF_FULL, &bi->bi_flags) &&
-		    (state == GFS2_BLKST_FREE))
-			goto skip;
-
-		/* The GFS2_BLKST_UNLINKED state doesn't apply to the clone
-		   bitmaps, so we must search the originals for that. */
-		buffer = bi->bi_bh->b_data + bi->bi_offset;
-		WARN_ON(!buffer_uptodate(bi->bi_bh));
-		if (state != GFS2_BLKST_UNLINKED && bi->bi_clone)
-			buffer = bi->bi_clone + bi->bi_offset;
-
-		while (1) {
-			struct gfs2_blkreserv *rs;
-			u32 rgblk;
-
-			biblk = gfs2_bitfit(buffer, bi->bi_len, goal, state);
-			if (biblk == BFITNOENT)
-				break;
-			/* Check if this block is reserved() */
-			rgblk = gfs2_bi2rgd_blk(bi, biblk);
-			rs = rs_find(rgd, rgblk);
-			if (rs == NULL)
-				break;
-
-			BUG_ON(rs->rs_rbm.bi != bi);
-			biblk = BFITNOENT;
-			/* This should jump to the first block after the
-			   reservation. */
-			goal = rs->rs_rbm.offset + rs->rs_free;
-			if (goal >= bi->bi_len * GFS2_NBBY)
-				break;
-		}
-		if (biblk != BFITNOENT)
-			break;
-
-		if ((goal == 0) && (state == GFS2_BLKST_FREE))
-			set_bit(GBF_FULL, &bi->bi_flags);
-
-		/* Try next bitmap block (wrap back to rgrp header if at end) */
-skip:
-		buf++;
-		buf %= length;
-		goal = 0;
-	}
-
-	if (biblk != BFITNOENT)
-		*rbi = bi;
-
-	return biblk;
-}
 
 /**
  * gfs2_alloc_extent - allocate an extent from a given bitmap
@@ -1809,9 +1865,8 @@ static u64 gfs2_alloc_extent(const struct gfs2_rbm *rbm, bool dinode,
 	struct gfs2_bitmap *bi = rbm->bi;
 	u32 blk = rbm->offset;
 	const unsigned int elen = *n;
-	u32 goal, rgblk;
+	u32 goal;
 	const u8 *buffer = NULL;
-	struct gfs2_blkreserv *rs;
 
 	*n = 0;
 	buffer = bi->bi_bh->b_data + bi->bi_offset;
@@ -1824,10 +1879,6 @@ static u64 gfs2_alloc_extent(const struct gfs2_rbm *rbm, bool dinode,
 		goal++;
 		if (goal >= (bi->bi_len * GFS2_NBBY))
 			break;
-		rgblk = gfs2_bi2rgd_blk(bi, goal);
-		rs = rs_find(rgd, rgblk);
-		if (rs) /* Oops, we bumped into someone's reservation */
-			break;
 		if (gfs2_testbit(rgd, buffer, bi->bi_len, goal) !=
 		    GFS2_BLKST_FREE)
 			break;
@@ -1933,46 +1984,41 @@ static void gfs2_rgrp_error(struct gfs2_rgrpd *rgd)
 }
 
 /**
- * claim_reserved_blks - Claim previously reserved blocks
- * @ip: the inode that's claiming the reservation
- * @dinode: 1 if this block is a dinode block, otherwise data block
- * @nblocks: desired extent length
+ * gfs2_adjust_reservation - Adjust (or remove) a reservation after allocation
+ * @ip: The inode we have just allocated blocks for
+ * @rbm: The start of the allocated blocks
+ * @len: The extent length
  *
- * Lay claim to previously reserved blocks.
- * Returns: Starting block number of the blocks claimed.
- * Sets *nblocks to the actual extent length allocated.
+ * Adjusts a reservation after an allocation has taken place. If the
+ * reservation does not match the allocation, or if it is now empty
+ * then it is removed.
  */
-static u64 claim_reserved_blks(struct gfs2_inode *ip, bool dinode,
-			       unsigned int *nblocks)
+
+static void gfs2_adjust_reservation(struct gfs2_inode *ip,
+				    const struct gfs2_rbm *rbm, unsigned len)
 {
 	struct gfs2_blkreserv *rs = ip->i_res;
-	struct gfs2_rgrpd *rgd = rs->rs_rbm.rgd;
-	struct gfs2_bitmap *bi;
-	u64 start_block = gfs2_rbm_to_block(&rs->rs_rbm);
-	const unsigned int elen = *nblocks;
-
-	bi = rs->rs_rbm.bi;
-	gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
+	struct gfs2_rgrpd *rgd = rbm->rgd;
+	unsigned rlen;
+	u64 block;
+	int ret;
 
-	for (*nblocks = 0; *nblocks < elen && rs->rs_free; (*nblocks)++) {
-		if (gfs2_testbit(rgd, bi->bi_bh->b_data + bi->bi_offset,
-				 bi->bi_len, rs->rs_rbm.offset) != GFS2_BLKST_FREE)
-			break;
-		gfs2_setbit(rgd, bi->bi_clone, bi, rs->rs_rbm.offset,
-			    dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
-		rs->rs_rbm.offset++;
-		rs->rs_free--;
-
-		BUG_ON(!rgd->rd_reserved);
-		rgd->rd_reserved--;
-		dinode = false;
+	spin_lock(&rgd->rd_rsspin);
+	if (gfs2_rs_active(rs)) {
+		if (gfs2_rbm_eq(&rs->rs_rbm, rbm)) {
+			block = gfs2_rbm_to_block(rbm);
+			ret = gfs2_rbm_from_block(&rs->rs_rbm, block + len);
+			rlen = min(rs->rs_free, len);
+			rs->rs_free -= rlen;
+			rgd->rd_reserved -= rlen;
+			trace_gfs2_rs(ip, rs, TRACE_RS_CLAIM);
+			if (rs->rs_free && !ret)
+				goto out;
+		}
+		__rs_deltree(ip, rs);
 	}
-
-	trace_gfs2_rs(ip, rs, TRACE_RS_CLAIM);
-	if (!rs->rs_free || *nblocks != elen)
-		gfs2_rs_deltree(ip, rs);
-
-	return start_block;
+out:
+	spin_unlock(&rgd->rd_rsspin);
 }
 
 /**
@@ -1993,36 +2039,30 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 	struct buffer_head *dibh;
 	struct gfs2_rbm rbm = { .rgd = ip->i_rgd, };
 	unsigned int ndata;
-	u32 goal; /* block, within the rgrp scope */
+	u64 goal;
 	u64 block; /* block, within the file system scope */
 	int error;
 
-	/* If we have a reservation, claim blocks from it. */
-	if (gfs2_rs_active(ip->i_res)) {
-		BUG_ON(!ip->i_res->rs_free);
-		rbm.rgd = ip->i_res->rs_rbm.rgd;
-		block = claim_reserved_blks(ip, dinode, nblocks);
-		if (*nblocks)
-			goto found_blocks;
-	}
-
-	if (!dinode && rgrp_contains_block(rbm.rgd, ip->i_goal))
-		goal = ip->i_goal - rbm.rgd->rd_data0;
+	if (gfs2_rs_active(ip->i_res))
+		goal = gfs2_rbm_to_block(&ip->i_res->rs_rbm);
+	else if (!dinode && rgrp_contains_block(rbm.rgd, ip->i_goal))
+		goal = ip->i_goal;
 	else
-		goal = rbm.rgd->rd_last_alloc;
+		goal = rbm.rgd->rd_last_alloc + rbm.rgd->rd_data0;
 
-	rbm.offset = rgblk_search(rbm.rgd, goal, GFS2_BLKST_FREE, &rbm.bi);
+	gfs2_rbm_from_block(&rbm, goal);
+	error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, ip, false);
 
 	/* Since all blocks are reserved in advance, this shouldn't happen */
-	if (rbm.offset == BFITNOENT) {
-		printk(KERN_WARNING "BFITNOENT, nblocks=%u\n", *nblocks);
-		printk(KERN_WARNING "FULL=%d\n",
-		       test_bit(GBF_FULL, &rbm.rgd->rd_bits->bi_flags));
+	if (error) {
+		fs_warn(sdp, "error=%d, nblocks=%u, full=%d\n", error, *nblocks,
+			test_bit(GBF_FULL, &rbm.rgd->rd_bits->bi_flags));
 		goto rgrp_error;
 	}
 
 	block = gfs2_alloc_extent(&rbm, dinode, nblocks);
-found_blocks:
+	if (gfs2_rs_active(ip->i_res))
+		gfs2_adjust_reservation(ip, &rbm, *nblocks);
 	ndata = *nblocks;
 	if (dinode)
 		ndata--;
-- 
1.7.4

