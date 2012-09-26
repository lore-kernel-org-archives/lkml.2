Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab2IZI4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:56:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab2IZIvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:41 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/27] GFS2: rbm code cleanup
Date: Wed, 26 Sep 2012 09:25:30 +0100
Message-Id: <1348647948-3219-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes a few small rbm related things. First, it fixes
a corner case where the rbm needs to switch bitmaps and wasn't
adjusting its buffer pointer. Second, there's a white space issue
fixed. Third, the logic in function gfs2_rbm_from_block was optimized
a bit. Lastly, a check for goal block overflows was added to function
gfs2_alloc_blocks.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index c17029a..c267118 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -467,7 +467,7 @@ int gfs2_rs_alloc(struct gfs2_inode *ip)
 static void dump_rs(struct seq_file *seq, struct gfs2_blkreserv *rs)
 {
 	gfs2_print_dbg(seq, "  r: %llu s:%llu b:%u f:%u\n",
-		       rs->rs_rbm.rgd->rd_addr, gfs2_rbm_to_block(&rs->rs_rbm), 
+		       rs->rs_rbm.rgd->rd_addr, gfs2_rbm_to_block(&rs->rs_rbm),
 		       rs->rs_rbm.offset, rs->rs_free);
 }
 
@@ -1493,16 +1493,18 @@ static int gfs2_rbm_from_block(struct gfs2_rbm *rbm, u64 block)
 
 	if (WARN_ON_ONCE(rblock > UINT_MAX))
 		return -EINVAL;
+	if (block >= rbm->rgd->rd_data0 + rbm->rgd->rd_data)
+		return -E2BIG;
 
 	for (x = 0; x < rbm->rgd->rd_length; x++) {
 		rbm->bi = rbm->rgd->rd_bits + x;
 		if (goal < (rbm->bi->bi_start + rbm->bi->bi_len) * GFS2_NBBY) {
 			rbm->offset = goal - (rbm->bi->bi_start * GFS2_NBBY);
-			return 0;
+			break;
 		}
 	}
 
-	return -E2BIG;
+	return 0;
 }
 
 /**
@@ -1579,7 +1581,6 @@ static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state,
 		WARN_ON(!buffer_uptodate(bh));
 		if (state != GFS2_BLKST_UNLINKED && rbm->bi->bi_clone)
 			buffer = rbm->bi->bi_clone + rbm->bi->bi_offset;
-find_next:
 		initial_offset = rbm->offset;
 		offset = gfs2_bitfit(buffer, rbm->bi->bi_len, rbm->offset, state);
 		if (offset == BFITNOENT)
@@ -1594,7 +1595,7 @@ find_next:
 			return 0;
 		if (ret > 0) {
 			n += (rbm->bi - initial_bi);
-			goto find_next;
+			goto next_iter;
 		}
 		if (ret == -E2BIG) {
 			index = 0;
@@ -1619,6 +1620,7 @@ res_covered_end_of_rgrp:
 		if ((index == 0) && nowrap)
 			break;
 		n++;
+next_iter:
 		if (n >= iters)
 			break;
 	}
@@ -2028,6 +2030,10 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 	else
 		goal = rbm.rgd->rd_last_alloc + rbm.rgd->rd_data0;
 
+	if ((goal < rbm.rgd->rd_data0) ||
+	    (goal >= rbm.rgd->rd_data0 + rbm.rgd->rd_data))
+		rbm.rgd = gfs2_blk2rgrpd(sdp, goal, 1);
+
 	gfs2_rbm_from_block(&rbm, goal);
 	error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, ip, false);
 
-- 
1.7.4

