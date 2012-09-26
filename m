Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2IZIyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:54:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab2IZIvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:52 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/27] GFS2: Use rbm for gfs2_testbit()
Date: Wed, 26 Sep 2012 09:25:37 +0100
Message-Id: <1348647948-3219-17-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the arguments to gfs2_testbit() so that it now just takes an
rbm specifying the position of the two bit entry to return.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 47d2346..3a288ce 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -117,30 +117,21 @@ static inline void gfs2_setbit(struct gfs2_rgrpd *rgd, unsigned char *buf2,
 
 /**
  * gfs2_testbit - test a bit in the bitmaps
- * @rgd: the resource group descriptor
- * @buffer: the buffer that holds the bitmaps
- * @buflen: the length (in bytes) of the buffer
- * @block: the block to read
+ * @rbm: The bit to test
  *
+ * Returns: The two bit block state of the requested bit
  */
 
-static inline unsigned char gfs2_testbit(struct gfs2_rgrpd *rgd,
-					 const unsigned char *buffer,
-					 unsigned int buflen, u32 block)
+static inline u8 gfs2_testbit(const struct gfs2_rbm *rbm)
 {
-	const unsigned char *byte, *end;
-	unsigned char cur_state;
+	const u8 *buffer = rbm->bi->bi_bh->b_data + rbm->bi->bi_offset;
+	const u8 *byte;
 	unsigned int bit;
 
-	byte = buffer + (block / GFS2_NBBY);
-	bit = (block % GFS2_NBBY) * GFS2_BIT_SIZE;
-	end = buffer + buflen;
-
-	gfs2_assert(rgd->rd_sbd, byte < end);
-
-	cur_state = (*byte >> bit) & GFS2_BIT_MASK;
+	byte = buffer + (rbm->offset / GFS2_NBBY);
+	bit = (rbm->offset % GFS2_NBBY) * GFS2_BIT_SIZE;
 
-	return cur_state;
+	return (*byte >> bit) & GFS2_BIT_MASK;
 }
 
 /**
@@ -1837,8 +1828,7 @@ static unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block)
 	ret = gfs2_rbm_from_block(&rbm, block);
 	WARN_ON_ONCE(ret != 0);
 
-	return gfs2_testbit(rgd, rbm.bi->bi_bh->b_data + rbm.bi->bi_offset,
-			    rbm.bi->bi_len, rbm.offset);
+	return gfs2_testbit(&rbm);
 }
 
 
@@ -1846,42 +1836,35 @@ static unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block)
  * gfs2_alloc_extent - allocate an extent from a given bitmap
  * @rbm: the resource group information
  * @dinode: TRUE if the first block we allocate is for a dinode
- * @n: The extent length
+ * @n: The extent length (value/result)
  *
- * Add the found bitmap buffer to the transaction.
+ * Add the bitmap buffer to the transaction.
  * Set the found bits to @new_state to change block's allocation state.
- * Returns: starting block number of the extent (fs scope)
  */
-static u64 gfs2_alloc_extent(const struct gfs2_rbm *rbm, bool dinode,
+static void gfs2_alloc_extent(const struct gfs2_rbm *rbm, bool dinode,
 			     unsigned int *n)
 {
-	struct gfs2_rgrpd *rgd = rbm->rgd;
-	struct gfs2_bitmap *bi = rbm->bi;
-	u32 blk = rbm->offset;
+	struct gfs2_rbm pos = { .rgd = rbm->rgd, };
 	const unsigned int elen = *n;
-	u32 goal;
-	const u8 *buffer = NULL;
+	u64 block;
+	int ret;
 
-	*n = 0;
-	buffer = bi->bi_bh->b_data + bi->bi_offset;
-	gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
-	gfs2_setbit(rgd, bi->bi_clone, bi, blk,
+	*n = 1;
+	block = gfs2_rbm_to_block(rbm);
+	gfs2_trans_add_bh(rbm->rgd->rd_gl, rbm->bi->bi_bh, 1);
+	gfs2_setbit(rbm->rgd, rbm->bi->bi_clone, rbm->bi, rbm->offset,
 		    dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
-	(*n)++;
-	goal = blk;
+	block++;
 	while (*n < elen) {
-		goal++;
-		if (goal >= (bi->bi_len * GFS2_NBBY))
-			break;
-		if (gfs2_testbit(rgd, buffer, bi->bi_len, goal) !=
-		    GFS2_BLKST_FREE)
+		ret = gfs2_rbm_from_block(&pos, block);
+		WARN_ON(ret);
+		if (gfs2_testbit(&pos) != GFS2_BLKST_FREE)
 			break;
-		gfs2_setbit(rgd, bi->bi_clone, bi, goal, GFS2_BLKST_USED);
+		gfs2_trans_add_bh(pos.rgd->rd_gl, pos.bi->bi_bh, 1);
+		gfs2_setbit(pos.rgd, pos.bi->bi_clone, pos.bi, pos.offset, GFS2_BLKST_USED);
 		(*n)++;
+		block++;
 	}
-	blk = gfs2_bi2rgd_blk(bi, blk);
-	rgd->rd_last_alloc = blk + *n - 1;
-	return rgd->rd_data0 + blk;
 }
 
 /**
@@ -2042,7 +2025,8 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 		goto rgrp_error;
 	}
 
-	block = gfs2_alloc_extent(&rbm, dinode, nblocks);
+	gfs2_alloc_extent(&rbm, dinode, nblocks);
+	block = gfs2_rbm_to_block(&rbm);
 	if (gfs2_rs_active(ip->i_res))
 		gfs2_adjust_reservation(ip, &rbm, *nblocks);
 	ndata = *nblocks;
-- 
1.7.4

