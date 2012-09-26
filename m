Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab2IZIxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:53:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633Ab2IZIwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:52:04 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>
Subject: [PATCH 24/27] GFS2: Consolidate free block searching functions
Date: Wed, 26 Sep 2012 09:25:45 +0100
Message-Id: <1348647948-3219-25-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recently added block reservation code, an additional function
was added to search for free blocks. This had a restriction of only being
able to search for aligned extents of free blocks. As a result the
allocation patterns when reserving blocks were suboptimal when the
existing allocation of blocks for an inode was not aligned to the same
boundary.

This patch resolves that problem by adding the ability for gfs2_rbm_find
to search for extents of a particular minimum size. We can then use
gfs2_rbm_find for both looking for reservations, and also looking for
free blocks on an individual basis when we actually come to do the
allocation later on. As a result we only need a single set of code
to deal with both situations.

The function gfs2_rbm_from_block() is moved up rgrp.c so that it
occurs before all of its callers.

Many thanks are due to Bob for helping track down the final issue in
this patch. That fix to the rb_tree traversal and to not share
block reservations from a dirctory to its children is included here.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 6aaa07c..3d469d3 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -99,7 +99,6 @@ struct gfs2_rgrpd {
 #define GFS2_RDF_MASK		0xf0000000 /* mask for internal flags */
 	spinlock_t rd_rsspin;           /* protects reservation related vars */
 	struct rb_root rd_rstree;       /* multi-block reservation tree */
-	u32 rd_rs_cnt;                  /* count of current reservations */
 };
 
 struct gfs2_rbm {
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index f2709ea..381893c 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -712,14 +712,9 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (error)
 		goto fail_gunlock2;
 
-	/* The newly created inode needs a reservation so it can allocate
-	   xattrs. At the same time, we want new blocks allocated to the new
-	   dinode to be as contiguous as possible. Since we allocated the
-	   dinode block under the directory's reservation, we transfer
-	   ownership of that reservation to the new inode. The directory
-	   doesn't need a reservation unless it needs a new allocation. */
-	ip->i_res = dip->i_res;
-	dip->i_res = NULL;
+	error = gfs2_rs_alloc(ip);
+	if (error)
+		goto fail_gunlock2;
 
 	error = gfs2_acl_create(dip, inode);
 	if (error)
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index defb826..b933cdc 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -35,9 +35,6 @@
 #define BFITNOENT ((u32)~0)
 #define NO_BLOCK ((u64)~0)
 
-#define RSRV_CONTENTION_FACTOR 4
-#define RGRP_RSRV_MAX_CONTENDERS 2
-
 #if BITS_PER_LONG == 32
 #define LBITMASK   (0x55555555UL)
 #define LBITSKIP55 (0x55555555UL)
@@ -67,6 +64,10 @@ static const char valid_change[16] = {
 	        1, 0, 0, 0
 };
 
+static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state, u32 minext,
+                         const struct gfs2_inode *ip, bool nowrap);
+
+
 /**
  * gfs2_setbit - Set a bit in the bitmaps
  * @rbm: The position of the bit to set
@@ -235,6 +236,130 @@ static u32 gfs2_bitfit(const u8 *buf, const unsigned int len,
 }
 
 /**
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
+	if (block >= rbm->rgd->rd_data0 + rbm->rgd->rd_data)
+		return -E2BIG;
+
+	for (x = 0; x < rbm->rgd->rd_length; x++) {
+		rbm->bi = rbm->rgd->rd_bits + x;
+		if (goal < (rbm->bi->bi_start + rbm->bi->bi_len) * GFS2_NBBY) {
+			rbm->offset = goal - (rbm->bi->bi_start * GFS2_NBBY);
+			break;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * gfs2_unaligned_extlen - Look for free blocks which are not byte aligned
+ * @rbm: Position to search (value/result)
+ * @n_unaligned: Number of unaligned blocks to check
+ * @len: Decremented for each block found (terminate on zero)
+ *
+ * Returns: true if a non-free block is encountered
+ */
+
+static bool gfs2_unaligned_extlen(struct gfs2_rbm *rbm, u32 n_unaligned, u32 *len)
+{
+	u64 block;
+	u32 n;
+	u8 res;
+
+	for (n = 0; n < n_unaligned; n++) {
+		res = gfs2_testbit(rbm);
+		if (res != GFS2_BLKST_FREE)
+			return true;
+		(*len)--;
+		if (*len == 0)
+			return true;
+		block = gfs2_rbm_to_block(rbm);
+		if (gfs2_rbm_from_block(rbm, block + 1))
+			return true;
+	}
+
+	return false;
+}
+
+/**
+ * gfs2_free_extlen - Return extent length of free blocks
+ * @rbm: Starting position
+ * @len: Max length to check
+ *
+ * Starting at the block specified by the rbm, see how many free blocks
+ * there are, not reading more than len blocks ahead. This can be done
+ * using memchr_inv when the blocks are byte aligned, but has to be done
+ * on a block by block basis in case of unaligned blocks. Also this
+ * function can cope with bitmap boundaries (although it must stop on
+ * a resource group boundary)
+ *
+ * Returns: Number of free blocks in the extent
+ */
+
+static u32 gfs2_free_extlen(const struct gfs2_rbm *rrbm, u32 len)
+{
+	struct gfs2_rbm rbm = *rrbm;
+	u32 n_unaligned = rbm.offset & 3;
+	u32 size = len;
+	u32 bytes;
+	u32 chunk_size;
+	u8 *ptr, *start, *end;
+	u64 block;
+
+	if (n_unaligned &&
+	    gfs2_unaligned_extlen(&rbm, 4 - n_unaligned, &len))
+		goto out;
+
+	/* Start is now byte aligned */
+	while (len > 3) {
+		start = rbm.bi->bi_bh->b_data;
+		if (rbm.bi->bi_clone)
+			start = rbm.bi->bi_clone;
+		end = start + rbm.bi->bi_bh->b_size;
+		start += rbm.bi->bi_offset;
+		BUG_ON(rbm.offset & 3);
+		start += (rbm.offset / GFS2_NBBY);
+		bytes = min_t(u32, len / GFS2_NBBY, (end - start));
+		ptr = memchr_inv(start, 0, bytes);
+		chunk_size = ((ptr == NULL) ? bytes : (ptr - start));
+		chunk_size *= GFS2_NBBY;
+		BUG_ON(len < chunk_size);
+		len -= chunk_size;
+		block = gfs2_rbm_to_block(&rbm);
+		gfs2_rbm_from_block(&rbm, block + chunk_size);
+		n_unaligned = 3;
+		if (ptr)
+			break;
+		n_unaligned = len & 3;
+	}
+
+	/* Deal with any bits left over at the end */
+	if (n_unaligned)
+		gfs2_unaligned_extlen(&rbm, n_unaligned, &len);
+out:
+	return size - len;
+}
+
+/**
  * gfs2_bitcount - count the number of bits in a certain state
  * @rgd: the resource group descriptor
  * @buffer: the buffer that holds the bitmaps
@@ -472,8 +597,6 @@ static void __rs_deltree(struct gfs2_inode *ip, struct gfs2_blkreserv *rs)
 	trace_gfs2_rs(rs, TRACE_RS_TREEDEL);
 	rb_erase(&rs->rs_node, &rgd->rd_rstree);
 	RB_CLEAR_NODE(&rs->rs_node);
-	BUG_ON(!rgd->rd_rs_cnt);
-	rgd->rd_rs_cnt--;
 
 	if (rs->rs_free) {
 		/* return reserved blocks to the rgrp and the ip */
@@ -1208,179 +1331,85 @@ out:
 
 /**
  * rs_insert - insert a new multi-block reservation into the rgrp's rb_tree
- * @bi: the bitmap with the blocks
  * @ip: the inode structure
- * @biblk: the 32-bit block number relative to the start of the bitmap
- * @amount: the number of blocks to reserve
  *
- * Returns: NULL - reservation was already taken, so not inserted
- *          pointer to the inserted reservation
  */
-static struct gfs2_blkreserv *rs_insert(struct gfs2_bitmap *bi,
-				       struct gfs2_inode *ip, u32 biblk,
-				       int amount)
+static void rs_insert(struct gfs2_inode *ip)
 {
 	struct rb_node **newn, *parent = NULL;
 	int rc;
 	struct gfs2_blkreserv *rs = ip->i_res;
 	struct gfs2_rgrpd *rgd = rs->rs_rbm.rgd;
-	u64 fsblock = gfs2_bi2rgd_blk(bi, biblk) + rgd->rd_data0;
+	u64 fsblock = gfs2_rbm_to_block(&rs->rs_rbm);
 
-	spin_lock(&rgd->rd_rsspin);
-	newn = &rgd->rd_rstree.rb_node;
-	BUG_ON(!ip->i_res);
 	BUG_ON(gfs2_rs_active(rs));
-	/* Figure out where to put new node */
 
+	spin_lock(&rgd->rd_rsspin);
+	newn = &rgd->rd_rstree.rb_node;
 	while (*newn) {
 		struct gfs2_blkreserv *cur =
 			rb_entry(*newn, struct gfs2_blkreserv, rs_node);
 
 		parent = *newn;
-		rc = rs_cmp(fsblock, amount, cur);
+		rc = rs_cmp(fsblock, rs->rs_free, cur);
 		if (rc > 0)
 			newn = &((*newn)->rb_right);
 		else if (rc < 0)
 			newn = &((*newn)->rb_left);
 		else {
 			spin_unlock(&rgd->rd_rsspin);
-			return NULL; /* reservation already in use */
+			WARN_ON(1);
+			return;
 		}
 	}
 
-	/* Do our reservation work */
-	rs = ip->i_res;
-	rs->rs_free = amount;
-	rs->rs_rbm.offset = biblk;
-	rs->rs_rbm.bi = bi;
-	rs->rs_inum = ip->i_no_addr;
 	rb_link_node(&rs->rs_node, parent, newn);
 	rb_insert_color(&rs->rs_node, &rgd->rd_rstree);
 
 	/* Do our rgrp accounting for the reservation */
-	rgd->rd_reserved += amount; /* blocks reserved */
-	rgd->rd_rs_cnt++; /* number of in-tree reservations */
+	rgd->rd_reserved += rs->rs_free; /* blocks reserved */
 	spin_unlock(&rgd->rd_rsspin);
 	trace_gfs2_rs(rs, TRACE_RS_INSERT);
-	return rs;
 }
 
 /**
- * unclaimed_blocks - return number of blocks that aren't spoken for
- */
-static u32 unclaimed_blocks(struct gfs2_rgrpd *rgd)
-{
-	return rgd->rd_free_clone - rgd->rd_reserved;
-}
-
-/**
- * rg_mblk_search - find a group of multiple free blocks
+ * rg_mblk_search - find a group of multiple free blocks to form a reservation
  * @rgd: the resource group descriptor
  * @ip: pointer to the inode for which we're reserving blocks
  * @requested: number of blocks required for this allocation
  *
- * This is very similar to rgblk_search, except we're looking for whole
- * 64-bit words that represent a chunk of 32 free blocks. I'm only focusing
- * on aligned dwords for speed's sake.
- *
  */
 
-static void rg_mblk_search(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip, unsigned requested)
+static void rg_mblk_search(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip,
+			   unsigned requested)
 {
-	struct gfs2_bitmap *bi = rgd->rd_bits;
-	const u32 length = rgd->rd_length;
-	u32 blk;
-	unsigned int buf, x, search_bytes;
-	u8 *buffer = NULL;
-	u8 *ptr, *end, *nonzero;
-	u32 goal, rsv_bytes;
-	struct gfs2_blkreserv *rs;
-	u32 best_rs_bytes, unclaimed;
-	int best_rs_blocks;
+	struct gfs2_rbm rbm = { .rgd = rgd, };
+	u64 goal;
+	struct gfs2_blkreserv *rs = ip->i_res;
+	u32 extlen;
+	u32 free_blocks = rgd->rd_free_clone - rgd->rd_reserved;
+	int ret;
 
-	if ((rgd->rd_free_clone < rgd->rd_reserved) ||
-	    (unclaimed_blocks(rgd) < max(requested, RGRP_RSRV_MINBLKS)))
+	extlen = max_t(u32, atomic_read(&rs->rs_sizehint), requested);
+	extlen = clamp(extlen, RGRP_RSRV_MINBLKS, free_blocks);
+	if ((rgd->rd_free_clone < rgd->rd_reserved) || (free_blocks < extlen))
 		return;
 
 	/* Find bitmap block that contains bits for goal block */
 	if (rgrp_contains_block(rgd, ip->i_goal))
-		goal = ip->i_goal - rgd->rd_data0;
+		goal = ip->i_goal;
 	else
-		goal = rgd->rd_last_alloc;
+		goal = rgd->rd_last_alloc + rgd->rd_data0;
 
-	for (buf = 0; buf < length; buf++) {
-		bi = rgd->rd_bits + buf;
-		/* Convert scope of "goal" from rgrp-wide to within
-		   found bit block */
-		if (goal < (bi->bi_start + bi->bi_len) * GFS2_NBBY) {
-			goal -= bi->bi_start * GFS2_NBBY;
-			goto do_search;
-		}
-	}
-	buf = 0;
-	goal = 0;
-
-do_search:
-	best_rs_blocks = max_t(int, atomic_read(&ip->i_res->rs_sizehint),
-			       (RGRP_RSRV_MINBLKS * rgd->rd_length));
-	best_rs_bytes = (best_rs_blocks *
-			 (1 + (RSRV_CONTENTION_FACTOR * rgd->rd_rs_cnt))) /
-		GFS2_NBBY; /* 1 + is for our not-yet-created reservation */
-	best_rs_bytes = ALIGN(best_rs_bytes, sizeof(u64));
-	unclaimed = unclaimed_blocks(rgd);
-	if (best_rs_bytes * GFS2_NBBY > unclaimed)
-		best_rs_bytes = unclaimed >> GFS2_BIT_SIZE;
-
-	for (x = 0; x <= length; x++) {
-		bi = rgd->rd_bits + buf;
-
-		if (test_bit(GBF_FULL, &bi->bi_flags))
-			goto skip;
+	if (WARN_ON(gfs2_rbm_from_block(&rbm, goal)))
+		return;
 
-		WARN_ON(!buffer_uptodate(bi->bi_bh));
-		if (bi->bi_clone)
-			buffer = bi->bi_clone + bi->bi_offset;
-		else
-			buffer = bi->bi_bh->b_data + bi->bi_offset;
-
-		/* We have to keep the reservations aligned on u64 boundaries
-		   otherwise we could get situations where a byte can't be
-		   used because it's after a reservation, but a free bit still
-		   is within the reservation's area. */
-		ptr = buffer + ALIGN(goal >> GFS2_BIT_SIZE, sizeof(u64));
-		end = (buffer + bi->bi_len);
-		while (ptr < end) {
-			rsv_bytes = 0;
-			if ((ptr + best_rs_bytes) <= end)
-				search_bytes = best_rs_bytes;
-			else
-				search_bytes = end - ptr;
-			BUG_ON(!search_bytes);
-			nonzero = memchr_inv(ptr, 0, search_bytes);
-			/* If the lot is all zeroes, reserve the whole size. If
-			   there's enough zeroes to satisfy the request, use
-			   what we can. If there's not enough, keep looking. */
-			if (nonzero == NULL)
-				rsv_bytes = search_bytes;
-			else if ((nonzero - ptr) * GFS2_NBBY >= requested)
-				rsv_bytes = (nonzero - ptr);
-
-			if (rsv_bytes) {
-				blk = ((ptr - buffer) * GFS2_NBBY);
-				BUG_ON(blk >= bi->bi_len * GFS2_NBBY);
-				rs = rs_insert(bi, ip, blk,
-					       rsv_bytes * GFS2_NBBY);
-				if (rs)
-					return;
-			}
-			ptr += ALIGN(search_bytes, sizeof(u64));
-		}
-skip:
-		/* Try next bitmap block (wrap back to rgrp header
-		   if at end) */
-		buf++;
-		buf %= length;
-		goal = 0;
+	ret = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, extlen, ip, true);
+	if (ret == 0) {
+		rs->rs_rbm = rbm;
+		rs->rs_free = extlen;
+		rs->rs_inum = ip->i_no_addr;
+		rs_insert(ip);
 	}
 }
 
@@ -1388,6 +1417,7 @@ skip:
  * gfs2_next_unreserved_block - Return next block that is not reserved
  * @rgd: The resource group
  * @block: The starting block
+ * @length: The required length
  * @ip: Ignore any reservations for this inode
  *
  * If the block does not appear in any reservation, then return the
@@ -1397,6 +1427,7 @@ skip:
  */
 
 static u64 gfs2_next_unreserved_block(struct gfs2_rgrpd *rgd, u64 block,
+				      u32 length,
 				      const struct gfs2_inode *ip)
 {
 	struct gfs2_blkreserv *rs;
@@ -1404,10 +1435,10 @@ static u64 gfs2_next_unreserved_block(struct gfs2_rgrpd *rgd, u64 block,
 	int rc;
 
 	spin_lock(&rgd->rd_rsspin);
-	n = rb_first(&rgd->rd_rstree);
+	n = rgd->rd_rstree.rb_node;
 	while (n) {
 		rs = rb_entry(n, struct gfs2_blkreserv, rs_node);
-		rc = rs_cmp(block, 1, rs);
+		rc = rs_cmp(block, length, rs);
 		if (rc < 0)
 			n = n->rb_left;
 		else if (rc > 0)
@@ -1417,9 +1448,9 @@ static u64 gfs2_next_unreserved_block(struct gfs2_rgrpd *rgd, u64 block,
 	}
 
 	if (n) {
-		while ((rs_cmp(block, 1, rs) == 0) && (ip->i_res != rs)) {
+		while ((rs_cmp(block, length, rs) == 0) && (ip->i_res != rs)) {
 			block = gfs2_rbm_to_block(&rs->rs_rbm) + rs->rs_free;
-			n = rb_next(&rs->rs_node);
+			n = n->rb_right;
 			if (n == NULL)
 				break;
 			rs = rb_entry(n, struct gfs2_blkreserv, rs_node);
@@ -1431,43 +1462,10 @@ static u64 gfs2_next_unreserved_block(struct gfs2_rgrpd *rgd, u64 block,
 }
 
 /**
- * gfs2_rbm_from_block - Set the rbm based upon rgd and block number
- * @rbm: The rbm with rgd already set correctly
- * @block: The block number (filesystem relative)
- *
- * This sets the bi and offset members of an rbm based on a
- * resource group and a filesystem relative block number. The
- * resource group must be set in the rbm on entry, the bi and
- * offset members will be set by this function.
- *
- * Returns: 0 on success, or an error code
- */
-
-static int gfs2_rbm_from_block(struct gfs2_rbm *rbm, u64 block)
-{
-	u64 rblock = block - rbm->rgd->rd_data0;
-	u32 goal = (u32)rblock;
-	int x;
-
-	if (WARN_ON_ONCE(rblock > UINT_MAX))
-		return -EINVAL;
-	if (block >= rbm->rgd->rd_data0 + rbm->rgd->rd_data)
-		return -E2BIG;
-
-	for (x = 0; x < rbm->rgd->rd_length; x++) {
-		rbm->bi = rbm->rgd->rd_bits + x;
-		if (goal < (rbm->bi->bi_start + rbm->bi->bi_len) * GFS2_NBBY) {
-			rbm->offset = goal - (rbm->bi->bi_start * GFS2_NBBY);
-			break;
-		}
-	}
-
-	return 0;
-}
-
-/**
  * gfs2_reservation_check_and_update - Check for reservations during block alloc
  * @rbm: The current position in the resource group
+ * @ip: The inode for which we are searching for blocks
+ * @minext: The minimum extent length
  *
  * This checks the current position in the rgrp to see whether there is
  * a reservation covering this block. If not then this function is a
@@ -1479,15 +1477,33 @@ static int gfs2_rbm_from_block(struct gfs2_rbm *rbm, u64 block)
  */
 
 static int gfs2_reservation_check_and_update(struct gfs2_rbm *rbm,
-					     const struct gfs2_inode *ip)
+					     const struct gfs2_inode *ip,
+					     u32 minext)
 {
 	u64 block = gfs2_rbm_to_block(rbm);
+	u32 extlen = 1;
 	u64 nblock;
 	int ret;
 
-	nblock = gfs2_next_unreserved_block(rbm->rgd, block, ip);
+	/*
+	 * If we have a minimum extent length, then skip over any extent
+	 * which is less than the min extent length in size.
+	 */
+	if (minext) {
+		extlen = gfs2_free_extlen(rbm, minext);
+		nblock = block + extlen;
+		if (extlen < minext)
+			goto fail;
+	}
+
+	/*
+	 * Check the extent which has been found against the reservations
+	 * and skip if parts of it are already reserved
+	 */
+	nblock = gfs2_next_unreserved_block(rbm->rgd, block, extlen, ip);
 	if (nblock == block)
 		return 0;
+fail:
 	ret = gfs2_rbm_from_block(rbm, nblock);
 	if (ret < 0)
 		return ret;
@@ -1498,6 +1514,7 @@ static int gfs2_reservation_check_and_update(struct gfs2_rbm *rbm,
  * gfs2_rbm_find - Look for blocks of a particular state
  * @rbm: Value/result starting position and final position
  * @state: The state which we want to find
+ * @minext: The requested extent length (0 for a single block)
  * @ip: If set, check for reservations
  * @nowrap: Stop looking at the end of the rgrp, rather than wrapping
  *          around until we've reached the starting point.
@@ -1509,7 +1526,7 @@ static int gfs2_reservation_check_and_update(struct gfs2_rbm *rbm,
  * Returns: 0 on success, -ENOSPC if there is no block of the requested state
  */
 
-static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state,
+static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state, u32 minext,
 			 const struct gfs2_inode *ip, bool nowrap)
 {
 	struct buffer_head *bh;
@@ -1548,7 +1565,7 @@ static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state,
 			return 0;
 
 		initial_bi = rbm->bi;
-		ret = gfs2_reservation_check_and_update(rbm, ip);
+		ret = gfs2_reservation_check_and_update(rbm, ip, minext);
 		if (ret == 0)
 			return 0;
 		if (ret > 0) {
@@ -1608,7 +1625,7 @@ static void try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked, u64 skip
 
 	while (1) {
 		down_write(&sdp->sd_log_flush_lock);
-		error = gfs2_rbm_find(&rbm, GFS2_BLKST_UNLINKED, NULL, true);
+		error = gfs2_rbm_find(&rbm, GFS2_BLKST_UNLINKED, 0, NULL, true);
 		up_write(&sdp->sd_log_flush_lock);
 		if (error == -ENOSPC)
 			break;
@@ -1988,11 +2005,11 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 		goal = rbm.rgd->rd_last_alloc + rbm.rgd->rd_data0;
 
 	gfs2_rbm_from_block(&rbm, goal);
-	error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, ip, false);
+	error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, 0, ip, false);
 
 	if (error == -ENOSPC) {
 		gfs2_rbm_from_block(&rbm, goal);
-		error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, NULL, false);
+		error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, 0, NULL, false);
 	}
 
 	/* Since all blocks are reserved in advance, this shouldn't happen */
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index c98f6af..2407795 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -79,10 +79,4 @@ static inline bool gfs2_rs_active(struct gfs2_blkreserv *rs)
 	return rs && !RB_EMPTY_NODE(&rs->rs_node);
 }
 
-
-static inline u32 gfs2_bi2rgd_blk(const struct gfs2_bitmap *bi, u32 blk)
-{
-	return (bi->bi_start * GFS2_NBBY) + blk;
-}
-
 #endif /* __RGRP_DOT_H__ */
-- 
1.7.4

