Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2IZIv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:51:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab2IZIvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:53 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 17/27] GFS2: Use rbm for gfs2_setbit()
Date: Wed, 26 Sep 2012 09:25:38 +0100
Message-Id: <1348647948-3219-18-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the rbm structure for gfs2_setbit() in order to simplify the
arguments to the function. We have to add a bool to control whether
the clone bitmap should be updated (if it exists) but otherwise it
is a more or less direct substitution.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 3a288ce..55a2651 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -69,47 +69,42 @@ static const char valid_change[16] = {
 
 /**
  * gfs2_setbit - Set a bit in the bitmaps
- * @rgd: the resource group descriptor
- * @buf2: the clone buffer that holds the bitmaps
- * @bi: the bitmap structure
- * @block: the block to set
+ * @rbm: The position of the bit to set
+ * @do_clone: Also set the clone bitmap, if it exists
  * @new_state: the new state of the block
  *
  */
 
-static inline void gfs2_setbit(struct gfs2_rgrpd *rgd, unsigned char *buf2,
-			       struct gfs2_bitmap *bi, u32 block,
+static inline void gfs2_setbit(const struct gfs2_rbm *rbm, bool do_clone,
 			       unsigned char new_state)
 {
 	unsigned char *byte1, *byte2, *end, cur_state;
-	unsigned int buflen = bi->bi_len;
-	const unsigned int bit = (block % GFS2_NBBY) * GFS2_BIT_SIZE;
+	unsigned int buflen = rbm->bi->bi_len;
+	const unsigned int bit = (rbm->offset % GFS2_NBBY) * GFS2_BIT_SIZE;
 
-	byte1 = bi->bi_bh->b_data + bi->bi_offset + (block / GFS2_NBBY);
-	end = bi->bi_bh->b_data + bi->bi_offset + buflen;
+	byte1 = rbm->bi->bi_bh->b_data + rbm->bi->bi_offset + (rbm->offset / GFS2_NBBY);
+	end = rbm->bi->bi_bh->b_data + rbm->bi->bi_offset + buflen;
 
 	BUG_ON(byte1 >= end);
 
 	cur_state = (*byte1 >> bit) & GFS2_BIT_MASK;
 
 	if (unlikely(!valid_change[new_state * 4 + cur_state])) {
-		printk(KERN_WARNING "GFS2: buf_blk = 0x%llx old_state=%d, "
-		       "new_state=%d\n",
-		       (unsigned long long)block, cur_state, new_state);
-		printk(KERN_WARNING "GFS2: rgrp=0x%llx bi_start=0x%lx\n",
-		       (unsigned long long)rgd->rd_addr,
-		       (unsigned long)bi->bi_start);
-		printk(KERN_WARNING "GFS2: bi_offset=0x%lx bi_len=0x%lx\n",
-		       (unsigned long)bi->bi_offset,
-		       (unsigned long)bi->bi_len);
+		printk(KERN_WARNING "GFS2: buf_blk = 0x%x old_state=%d, "
+		       "new_state=%d\n", rbm->offset, cur_state, new_state);
+		printk(KERN_WARNING "GFS2: rgrp=0x%llx bi_start=0x%x\n",
+		       (unsigned long long)rbm->rgd->rd_addr,
+		       rbm->bi->bi_start);
+		printk(KERN_WARNING "GFS2: bi_offset=0x%x bi_len=0x%x\n",
+		       rbm->bi->bi_offset, rbm->bi->bi_len);
 		dump_stack();
-		gfs2_consist_rgrpd(rgd);
+		gfs2_consist_rgrpd(rbm->rgd);
 		return;
 	}
 	*byte1 ^= (cur_state ^ new_state) << bit;
 
-	if (buf2) {
-		byte2 = buf2 + bi->bi_offset + (block / GFS2_NBBY);
+	if (do_clone && rbm->bi->bi_clone) {
+		byte2 = rbm->bi->bi_clone + rbm->bi->bi_offset + (rbm->offset / GFS2_NBBY);
 		cur_state = (*byte2 >> bit) & GFS2_BIT_MASK;
 		*byte2 ^= (cur_state ^ new_state) << bit;
 	}
@@ -1852,8 +1847,7 @@ static void gfs2_alloc_extent(const struct gfs2_rbm *rbm, bool dinode,
 	*n = 1;
 	block = gfs2_rbm_to_block(rbm);
 	gfs2_trans_add_bh(rbm->rgd->rd_gl, rbm->bi->bi_bh, 1);
-	gfs2_setbit(rbm->rgd, rbm->bi->bi_clone, rbm->bi, rbm->offset,
-		    dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
+	gfs2_setbit(rbm, true, dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
 	block++;
 	while (*n < elen) {
 		ret = gfs2_rbm_from_block(&pos, block);
@@ -1861,7 +1855,7 @@ static void gfs2_alloc_extent(const struct gfs2_rbm *rbm, bool dinode,
 		if (gfs2_testbit(&pos) != GFS2_BLKST_FREE)
 			break;
 		gfs2_trans_add_bh(pos.rgd->rd_gl, pos.bi->bi_bh, 1);
-		gfs2_setbit(pos.rgd, pos.bi->bi_clone, pos.bi, pos.offset, GFS2_BLKST_USED);
+		gfs2_setbit(&pos, true, GFS2_BLKST_USED);
 		(*n)++;
 		block++;
 	}
@@ -1900,7 +1894,7 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
 			       rbm.bi->bi_len);
 		}
 		gfs2_trans_add_bh(rbm.rgd->rd_gl, rbm.bi->bi_bh, 1);
-		gfs2_setbit(rbm.rgd, NULL, rbm.bi, rbm.offset, new_state);
+		gfs2_setbit(&rbm, false, new_state);
 	}
 
 	return rbm.rgd;
-- 
1.7.4

