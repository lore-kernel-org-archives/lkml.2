Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab2IZI6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:58:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab2IZIvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:36 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/27] GFS2: Update rgblk_free() to use rbm
Date: Wed, 26 Sep 2012 09:25:27 +0100
Message-Id: <1348647948-3219-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace open coded version with a call to gfs2_rbm_from_block()

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 0c1be38..06476b3 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1890,46 +1890,30 @@ static u64 gfs2_alloc_extent(const struct gfs2_rbm *rbm, bool dinode,
 static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
 				     u32 blen, unsigned char new_state)
 {
-	struct gfs2_rgrpd *rgd;
-	struct gfs2_bitmap *bi = NULL;
-	u32 length, rgrp_blk, buf_blk;
-	unsigned int buf;
+	struct gfs2_rbm rbm;
 
-	rgd = gfs2_blk2rgrpd(sdp, bstart, 1);
-	if (!rgd) {
+	rbm.rgd = gfs2_blk2rgrpd(sdp, bstart, 1);
+	if (!rbm.rgd) {
 		if (gfs2_consist(sdp))
 			fs_err(sdp, "block = %llu\n", (unsigned long long)bstart);
 		return NULL;
 	}
 
-	length = rgd->rd_length;
-
-	rgrp_blk = bstart - rgd->rd_data0;
-
 	while (blen--) {
-		for (buf = 0; buf < length; buf++) {
-			bi = rgd->rd_bits + buf;
-			if (rgrp_blk < (bi->bi_start + bi->bi_len) * GFS2_NBBY)
-				break;
+		gfs2_rbm_from_block(&rbm, bstart);
+		bstart++;
+		if (!rbm.bi->bi_clone) {
+			rbm.bi->bi_clone = kmalloc(rbm.bi->bi_bh->b_size,
+						   GFP_NOFS | __GFP_NOFAIL);
+			memcpy(rbm.bi->bi_clone + rbm.bi->bi_offset,
+			       rbm.bi->bi_bh->b_data + rbm.bi->bi_offset,
+			       rbm.bi->bi_len);
 		}
-
-		gfs2_assert(rgd->rd_sbd, buf < length);
-
-		buf_blk = rgrp_blk - bi->bi_start * GFS2_NBBY;
-		rgrp_blk++;
-
-		if (!bi->bi_clone) {
-			bi->bi_clone = kmalloc(bi->bi_bh->b_size,
-					       GFP_NOFS | __GFP_NOFAIL);
-			memcpy(bi->bi_clone + bi->bi_offset,
-			       bi->bi_bh->b_data + bi->bi_offset,
-			       bi->bi_len);
-		}
-		gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
-		gfs2_setbit(rgd, NULL, bi, buf_blk, new_state);
+		gfs2_trans_add_bh(rbm.rgd->rd_gl, rbm.bi->bi_bh, 1);
+		gfs2_setbit(rbm.rgd, NULL, rbm.bi, rbm.offset, new_state);
 	}
 
-	return rgd;
+	return rbm.rgd;
 }
 
 /**
-- 
1.7.4

