Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab2K3KYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:24:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756978Ab2K3KSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:18:18 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/16] GFS2: Speed up gfs2_rbm_from_block
Date: Fri, 30 Nov 2012 09:52:07 +0000
Message-Id: <1354269141-3311-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
References: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch is a rewrite of function gfs2_rbm_from_block. Rather than
looping to find the right bitmap, the code now does a few simple
math calculations.

I compared the performance of both algorithms side by side and the new
algorithm is noticeably faster. Sample instrumentation output from a
"fast" machine:

5 million calls: millisec spent: Orig: 166 New: 113
5 million calls: millisec spent: Orig: 189 New: 114

In addition, I ran postmark (on a somewhat slowr CPU) before the after
the new algorithm was put in place and postmark showed a decent
improvement:

Before the new algorithm:
-------------------------
Time:
	645 seconds total
	584 seconds of transactions (171 per second)

Files:
	150087 created (232 per second)
		Creation alone: 100000 files (2083 per second)
		Mixed with transactions: 50087 files (85 per second)
	49995 read (85 per second)
	49991 appended (85 per second)
	150087 deleted (232 per second)
		Deletion alone: 100174 files (7705 per second)
		Mixed with transactions: 49913 files (85 per second)

Data:
	273.42 megabytes read (434.08 kilobytes per second)
	852.13 megabytes written (1.32 megabytes per second)

With the new algorithm:
-----------------------
Time:
	599 seconds total
	530 seconds of transactions (188 per second)

Files:
	150087 created (250 per second)
		Creation alone: 100000 files (1886 per second)
		Mixed with transactions: 50087 files (94 per second)
	49995 read (94 per second)
	49991 appended (94 per second)
	150087 deleted (250 per second)
		Deletion alone: 100174 files (6260 per second)
		Mixed with transactions: 49913 files (94 per second)

Data:
	273.42 megabytes read (467.42 kilobytes per second)
	852.13 megabytes written (1.42 megabytes per second)

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 3d469d3..24bb0b8 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -621,6 +621,7 @@ struct gfs2_sbd {
 	u32 sd_hash_bsize_shift;
 	u32 sd_hash_ptrs;	/* Number of pointers in a hash block */
 	u32 sd_qc_per_block;
+	u32 sd_blocks_per_bitmap;
 	u32 sd_max_dirres;	/* Max blocks needed to add a directory entry */
 	u32 sd_max_height;	/* Max height of a file's metadata tree */
 	u64 sd_heightsize[GFS2_MAX_META_HEIGHT + 1];
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index e443966..0e3554e 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -278,6 +278,9 @@ static int gfs2_read_sb(struct gfs2_sbd *sdp, int silent)
 	sdp->sd_qc_per_block = (sdp->sd_sb.sb_bsize -
 				sizeof(struct gfs2_meta_header)) /
 			        sizeof(struct gfs2_quota_change);
+	sdp->sd_blocks_per_bitmap = (sdp->sd_sb.sb_bsize -
+				     sizeof(struct gfs2_meta_header))
+		* GFS2_NBBY; /* not the rgrp bitmap, subsequent bitmaps only */
 
 	/* Compute maximum reservation required to add a entry to a directory */
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 38fe18f..669b89b 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -251,22 +251,25 @@ static u32 gfs2_bitfit(const u8 *buf, const unsigned int len,
 static int gfs2_rbm_from_block(struct gfs2_rbm *rbm, u64 block)
 {
 	u64 rblock = block - rbm->rgd->rd_data0;
-	u32 goal = (u32)rblock;
-	int x;
+	u32 x;
 
 	if (WARN_ON_ONCE(rblock > UINT_MAX))
 		return -EINVAL;
 	if (block >= rbm->rgd->rd_data0 + rbm->rgd->rd_data)
 		return -E2BIG;
 
-	for (x = 0; x < rbm->rgd->rd_length; x++) {
-		rbm->bi = rbm->rgd->rd_bits + x;
-		if (goal < (rbm->bi->bi_start + rbm->bi->bi_len) * GFS2_NBBY) {
-			rbm->offset = goal - (rbm->bi->bi_start * GFS2_NBBY);
-			break;
-		}
-	}
+	rbm->bi = rbm->rgd->rd_bits;
+	rbm->offset = (u32)(rblock);
+	/* Check if the block is within the first block */
+	if (rbm->offset < (rbm->bi->bi_start + rbm->bi->bi_len) * GFS2_NBBY)
+		return 0;
 
+	/* Adjust for the size diff between gfs2_meta_header and gfs2_rgrp */
+	rbm->offset += (sizeof(struct gfs2_rgrp) -
+			sizeof(struct gfs2_meta_header)) * GFS2_NBBY;
+	x = rbm->offset / rbm->rgd->rd_sbd->sd_blocks_per_bitmap;
+	rbm->offset -= x * rbm->rgd->rd_sbd->sd_blocks_per_bitmap;
+	rbm->bi += x;
 	return 0;
 }
 
-- 
1.7.4

