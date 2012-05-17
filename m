Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761915Ab2EQMx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:53:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760954Ab2EQMs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:28 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/24] GFS2: Make gfs2_log_fake_buf() write the buffer too
Date: Thu, 17 May 2012 13:23:09 +0100
Message-Id: <1337257411-3173-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we always write the buffer directly after this function
returns, we might as well merge it into here. This is a clean
up in preparation for some further updates to the log code
which are coming soon.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 6b1efb5..a5937b3 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -208,15 +208,13 @@ static void gfs2_fake_write_endio(struct buffer_head *bh, int uptodate)
 }
 
 /**
- * gfs2_log_fake_buf - Build a fake buffer head to write metadata buffer to log
+ * gfs2_log_write_buf - write metadata buffer to log
  * @sdp: the filesystem
- * @data: the data the buffer_head should point to
+ * @real: the in-place buffer head
  *
- * Returns: the log buffer descriptor
  */
 
-static struct buffer_head *gfs2_log_fake_buf(struct gfs2_sbd *sdp,
-				      struct buffer_head *real)
+static void gfs2_log_write_buf(struct gfs2_sbd *sdp, struct buffer_head *real)
 {
 	u64 blkno = gfs2_log_bmap(sdp, sdp->sd_log_flush_head);
 	struct buffer_head *bh;
@@ -234,7 +232,7 @@ static struct buffer_head *gfs2_log_fake_buf(struct gfs2_sbd *sdp,
 	gfs2_log_incr_head(sdp);
 	atomic_inc(&sdp->sd_log_in_flight);
 
-	return bh;
+	submit_bh(WRITE, bh);
 }
 
 static struct buffer_head *gfs2_get_log_desc(struct gfs2_sbd *sdp, u32 ld_type)
@@ -321,7 +319,7 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 		}
 
 		gfs2_log_unlock(sdp);
-		submit_bh(WRITE_SYNC, bh);
+		submit_bh(WRITE, bh);
 		gfs2_log_lock(sdp);
 
 		n = 0;
@@ -330,8 +328,7 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 			get_bh(bd2->bd_bh);
 			gfs2_log_unlock(sdp);
 			lock_buffer(bd2->bd_bh);
-			bh = gfs2_log_fake_buf(sdp, bd2->bd_bh);
-			submit_bh(WRITE_SYNC, bh);
+			gfs2_log_write_buf(sdp, bd2->bd_bh);
 			gfs2_log_lock(sdp);
 			if (++n >= num)
 				break;
@@ -475,7 +472,7 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 		sdp->sd_log_num_revoke--;
 
 		if (offset + sizeof(u64) > sdp->sd_sb.sb_bsize) {
-			submit_bh(WRITE_SYNC, bh);
+			submit_bh(WRITE, bh);
 
 			bh = gfs2_log_get_buf(sdp);
 			mh = (struct gfs2_meta_header *)bh->b_data;
@@ -490,7 +487,7 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 	}
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_revoke);
 
-	submit_bh(WRITE_SYNC, bh);
+	submit_bh(WRITE, bh);
 }
 
 static void revoke_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
@@ -672,7 +669,7 @@ static void gfs2_write_blocks(struct gfs2_sbd *sdp, struct buffer_head *bh,
 	ptr = bh_log_ptr(bh);
 	
 	get_bh(bh);
-	submit_bh(WRITE_SYNC, bh);
+	submit_bh(WRITE, bh);
 	gfs2_log_lock(sdp);
 	while(!list_empty(list)) {
 		bd = list_entry(list->next, struct gfs2_bufdata, bd_le.le_list);
@@ -695,10 +692,10 @@ static void gfs2_write_blocks(struct gfs2_sbd *sdp, struct buffer_head *bh,
 			clear_buffer_escaped(bd->bd_bh);
 			unlock_buffer(bd->bd_bh);
 			brelse(bd->bd_bh);
+			submit_bh(WRITE, bh1);
 		} else {
-			bh1 = gfs2_log_fake_buf(sdp, bd->bd_bh);
+			gfs2_log_write_buf(sdp, bd->bd_bh);
 		}
-		submit_bh(WRITE_SYNC, bh1);
 		gfs2_log_lock(sdp);
 		ptr += 2;
 	}
-- 
1.7.4

