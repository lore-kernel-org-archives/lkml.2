Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966195Ab2EQMv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:51:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761841Ab2EQMsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:47 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/24] GFS2: Eliminate needless parameter from function gfs2_setbit
Date: Thu, 17 May 2012 13:23:22 +0100
Message-Id: <1337257411-3173-16-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch eliminates parameter "buf1" from function gfs2_setbit.
This is possible because it was always passed in as bi->bi_bh->b_data.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index b550e5c..645c16f 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -71,7 +71,6 @@ static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
 /**
  * gfs2_setbit - Set a bit in the bitmaps
  * @rgd: the resource group descriptor
- * @buf1: the primary buffer that holds the bitmaps
  * @buf2: the clone buffer that holds the bitmaps
  * @bi: the bitmap structure
  * @block: the block to set
@@ -79,16 +78,16 @@ static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
  *
  */
 
-static inline void gfs2_setbit(struct gfs2_rgrpd *rgd, unsigned char *buf1,
-			       unsigned char *buf2, struct gfs2_bitmap *bi,
-			       u32 block, unsigned char new_state)
+static inline void gfs2_setbit(struct gfs2_rgrpd *rgd, unsigned char *buf2,
+			       struct gfs2_bitmap *bi, u32 block,
+			       unsigned char new_state)
 {
 	unsigned char *byte1, *byte2, *end, cur_state;
 	unsigned int buflen = bi->bi_len;
 	const unsigned int bit = (block % GFS2_NBBY) * GFS2_BIT_SIZE;
 
-	byte1 = buf1 + bi->bi_offset + (block / GFS2_NBBY);
-	end = buf1 + bi->bi_offset + buflen;
+	byte1 = bi->bi_bh->b_data + bi->bi_offset + (block / GFS2_NBBY);
+	end = bi->bi_bh->b_data + bi->bi_offset + buflen;
 
 	BUG_ON(byte1 >= end);
 
@@ -1369,8 +1368,8 @@ static u64 gfs2_alloc_extent(struct gfs2_rgrpd *rgd, struct gfs2_bitmap *bi,
 	*n = 0;
 	buffer = bi->bi_bh->b_data + bi->bi_offset;
 	gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
-	gfs2_setbit(rgd, bi->bi_bh->b_data, bi->bi_clone,
-		    bi, blk, dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
+	gfs2_setbit(rgd, bi->bi_clone, bi, blk,
+		    dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
 	(*n)++;
 	goal = blk;
 	while (*n < elen) {
@@ -1380,8 +1379,7 @@ static u64 gfs2_alloc_extent(struct gfs2_rgrpd *rgd, struct gfs2_bitmap *bi,
 		if (gfs2_testbit(rgd, buffer, bi->bi_len, goal) !=
 		    GFS2_BLKST_FREE)
 			break;
-		gfs2_setbit(rgd, bi->bi_bh->b_data, bi->bi_clone,
-			    bi, goal, GFS2_BLKST_USED);
+		gfs2_setbit(rgd, bi->bi_clone, bi, goal, GFS2_BLKST_USED);
 		(*n)++;
 	}
 	blk = gfs2_bi2rgd_blk(bi, blk);
@@ -1438,8 +1436,7 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
 			       bi->bi_len);
 		}
 		gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
-		gfs2_setbit(rgd, bi->bi_bh->b_data, NULL,
-			    bi, buf_blk, new_state);
+		gfs2_setbit(rgd, NULL, bi, buf_blk, new_state);
 	}
 
 	return rgd;
-- 
1.7.4

