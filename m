Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab1ESJKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:10:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305Ab1ESJKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:02 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/32] GFS2: Dump better debug info if a bitmap inconsistency is detected
Date: Thu, 19 May 2011 09:46:56 +0100
Message-Id: <1305794847-3291-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

On rare occasions we encounter gfs2 problems where an
invalid bitmap state transition is attempted.  For example,
trying to "unlink" a free block.  In these cases, there
is really no useful information logged to debug the problem.
This patch adds more debug details that should allow us to
more closely examine the problem and possibly solve it.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 6fcae84..b643c14 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -78,10 +78,11 @@ static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
 
 static inline void gfs2_setbit(struct gfs2_rgrpd *rgd, unsigned char *buf1,
 			       unsigned char *buf2, unsigned int offset,
-			       unsigned int buflen, u32 block,
+			       struct gfs2_bitmap *bi, u32 block,
 			       unsigned char new_state)
 {
 	unsigned char *byte1, *byte2, *end, cur_state;
+	unsigned int buflen = bi->bi_len;
 	const unsigned int bit = (block % GFS2_NBBY) * GFS2_BIT_SIZE;
 
 	byte1 = buf1 + offset + (block / GFS2_NBBY);
@@ -92,6 +93,16 @@ static inline void gfs2_setbit(struct gfs2_rgrpd *rgd, unsigned char *buf1,
 	cur_state = (*byte1 >> bit) & GFS2_BIT_MASK;
 
 	if (unlikely(!valid_change[new_state * 4 + cur_state])) {
+		printk(KERN_WARNING "GFS2: buf_blk = 0x%llx old_state=%d, "
+		       "new_state=%d\n",
+		       (unsigned long long)block, cur_state, new_state);
+		printk(KERN_WARNING "GFS2: rgrp=0x%llx bi_start=0x%lx\n",
+		       (unsigned long long)rgd->rd_addr,
+		       (unsigned long)bi->bi_start);
+		printk(KERN_WARNING "GFS2: bi_offset=0x%lx bi_len=0x%lx\n",
+		       (unsigned long)bi->bi_offset,
+		       (unsigned long)bi->bi_len);
+		dump_stack();
 		gfs2_consist_rgrpd(rgd);
 		return;
 	}
@@ -1365,7 +1376,7 @@ skip:
 
 	gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
 	gfs2_setbit(rgd, bi->bi_bh->b_data, bi->bi_clone, bi->bi_offset,
-		    bi->bi_len, blk, new_state);
+		    bi, blk, new_state);
 	goal = blk;
 	while (*n < elen) {
 		goal++;
@@ -1375,7 +1386,7 @@ skip:
 		    GFS2_BLKST_FREE)
 			break;
 		gfs2_setbit(rgd, bi->bi_bh->b_data, bi->bi_clone, bi->bi_offset,
-			    bi->bi_len, goal, new_state);
+			    bi, goal, new_state);
 		(*n)++;
 	}
 out:
@@ -1432,7 +1443,7 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
 		}
 		gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
 		gfs2_setbit(rgd, bi->bi_bh->b_data, NULL, bi->bi_offset,
-			    bi->bi_len, buf_blk, new_state);
+			    bi, buf_blk, new_state);
 	}
 
 	return rgd;
-- 
1.7.4

