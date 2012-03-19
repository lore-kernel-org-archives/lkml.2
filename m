Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030675Ab2CSKud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:50:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030594Ab2CSKt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:49:57 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/12] GFS2: Clean up log flush header writing
Date: Mon, 19 Mar 2012 10:25:27 +0000
Message-Id: <1332152728-4027-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already send both a pre and post flush to the block device
when writing a journal header. There is no need to wait for
the previous I/O specifically when we do this, unless we've
turned "barriers" off.

As a side effect, this also cleans up the code path for flushing
the journal and makes it more readable.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 2b9f0d9..4752ead 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -491,66 +491,8 @@ static void log_pull_tail(struct gfs2_sbd *sdp, unsigned int new_tail)
 	sdp->sd_log_tail = new_tail;
 }
 
-/**
- * log_write_header - Get and initialize a journal header buffer
- * @sdp: The GFS2 superblock
- *
- * Returns: the initialized log buffer descriptor
- */
 
-static void log_write_header(struct gfs2_sbd *sdp, u32 flags, int pull)
-{
-	u64 blkno = gfs2_log_bmap(sdp, sdp->sd_log_flush_head);
-	struct buffer_head *bh;
-	struct gfs2_log_header *lh;
-	unsigned int tail;
-	u32 hash;
-
-	bh = sb_getblk(sdp->sd_vfs, blkno);
-	lock_buffer(bh);
-	memset(bh->b_data, 0, bh->b_size);
-	set_buffer_uptodate(bh);
-	clear_buffer_dirty(bh);
-
-	gfs2_ail1_empty(sdp);
-	tail = current_tail(sdp);
-
-	lh = (struct gfs2_log_header *)bh->b_data;
-	memset(lh, 0, sizeof(struct gfs2_log_header));
-	lh->lh_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
-	lh->lh_header.mh_type = cpu_to_be32(GFS2_METATYPE_LH);
-	lh->lh_header.__pad0 = cpu_to_be64(0);
-	lh->lh_header.mh_format = cpu_to_be32(GFS2_FORMAT_LH);
-	lh->lh_header.mh_jid = cpu_to_be32(sdp->sd_jdesc->jd_jid);
-	lh->lh_sequence = cpu_to_be64(sdp->sd_log_sequence++);
-	lh->lh_flags = cpu_to_be32(flags);
-	lh->lh_tail = cpu_to_be32(tail);
-	lh->lh_blkno = cpu_to_be32(sdp->sd_log_flush_head);
-	hash = gfs2_disk_hash(bh->b_data, sizeof(struct gfs2_log_header));
-	lh->lh_hash = cpu_to_be32(hash);
-
-	bh->b_end_io = end_buffer_write_sync;
-	get_bh(bh);
-	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags))
-		submit_bh(WRITE_SYNC | REQ_META | REQ_PRIO, bh);
-	else
-		submit_bh(WRITE_FLUSH_FUA | REQ_META, bh);
-	wait_on_buffer(bh);
-
-	if (!buffer_uptodate(bh))
-		gfs2_io_error_bh(sdp, bh);
-	brelse(bh);
-
-	if (sdp->sd_log_tail != tail)
-		log_pull_tail(sdp, tail);
-	else
-		gfs2_assert_withdraw(sdp, !pull);
-
-	sdp->sd_log_idle = (tail == sdp->sd_log_flush_head);
-	gfs2_log_incr_head(sdp);
-}
-
-static void log_flush_commit(struct gfs2_sbd *sdp)
+static void log_flush_wait(struct gfs2_sbd *sdp)
 {
 	DEFINE_WAIT(wait);
 
@@ -563,8 +505,6 @@ static void log_flush_commit(struct gfs2_sbd *sdp)
 		} while(atomic_read(&sdp->sd_log_in_flight));
 		finish_wait(&sdp->sd_log_flush_wait, &wait);
 	}
-
-	log_write_header(sdp, 0, 0);
 }
 
 static int bd_cmp(void *priv, struct list_head *a, struct list_head *b)
@@ -634,6 +574,68 @@ static void gfs2_ordered_wait(struct gfs2_sbd *sdp)
 }
 
 /**
+ * log_write_header - Get and initialize a journal header buffer
+ * @sdp: The GFS2 superblock
+ *
+ * Returns: the initialized log buffer descriptor
+ */
+
+static void log_write_header(struct gfs2_sbd *sdp, u32 flags, int pull)
+{
+	u64 blkno = gfs2_log_bmap(sdp, sdp->sd_log_flush_head);
+	struct buffer_head *bh;
+	struct gfs2_log_header *lh;
+	unsigned int tail;
+	u32 hash;
+
+	bh = sb_getblk(sdp->sd_vfs, blkno);
+	lock_buffer(bh);
+	memset(bh->b_data, 0, bh->b_size);
+	set_buffer_uptodate(bh);
+	clear_buffer_dirty(bh);
+
+	gfs2_ail1_empty(sdp);
+	tail = current_tail(sdp);
+
+	lh = (struct gfs2_log_header *)bh->b_data;
+	memset(lh, 0, sizeof(struct gfs2_log_header));
+	lh->lh_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
+	lh->lh_header.mh_type = cpu_to_be32(GFS2_METATYPE_LH);
+	lh->lh_header.__pad0 = cpu_to_be64(0);
+	lh->lh_header.mh_format = cpu_to_be32(GFS2_FORMAT_LH);
+	lh->lh_header.mh_jid = cpu_to_be32(sdp->sd_jdesc->jd_jid);
+	lh->lh_sequence = cpu_to_be64(sdp->sd_log_sequence++);
+	lh->lh_flags = cpu_to_be32(flags);
+	lh->lh_tail = cpu_to_be32(tail);
+	lh->lh_blkno = cpu_to_be32(sdp->sd_log_flush_head);
+	hash = gfs2_disk_hash(bh->b_data, sizeof(struct gfs2_log_header));
+	lh->lh_hash = cpu_to_be32(hash);
+
+	bh->b_end_io = end_buffer_write_sync;
+	get_bh(bh);
+	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags)) {
+		gfs2_ordered_wait(sdp);
+		log_flush_wait(sdp);
+		submit_bh(WRITE_SYNC | REQ_META | REQ_PRIO, bh);
+	} else {
+		submit_bh(WRITE_FLUSH_FUA | REQ_META, bh);
+	}
+	wait_on_buffer(bh);
+
+	if (!buffer_uptodate(bh))
+		gfs2_io_error_bh(sdp, bh);
+	brelse(bh);
+
+	if (sdp->sd_log_tail != tail)
+		log_pull_tail(sdp, tail);
+	else
+		gfs2_assert_withdraw(sdp, !pull);
+
+	sdp->sd_log_idle = (tail == sdp->sd_log_flush_head);
+	gfs2_log_incr_head(sdp);
+}
+
+/**
  * gfs2_log_flush - flush incore transaction(s)
  * @sdp: the filesystem
  * @gl: The glock structure to flush.  If NULL, flush the whole incore log
@@ -676,11 +678,10 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 
 	gfs2_ordered_write(sdp);
 	lops_before_commit(sdp);
-	gfs2_ordered_wait(sdp);
 
-	if (sdp->sd_log_head != sdp->sd_log_flush_head)
-		log_flush_commit(sdp);
-	else if (sdp->sd_log_tail != current_tail(sdp) && !sdp->sd_log_idle){
+	if (sdp->sd_log_head != sdp->sd_log_flush_head) {
+		log_write_header(sdp, 0, 0);
+	} else if (sdp->sd_log_tail != current_tail(sdp) && !sdp->sd_log_idle){
 		gfs2_log_lock(sdp);
 		atomic_dec(&sdp->sd_log_blks_free); /* Adjust for unreserved buffer */
 		trace_gfs2_log_blocks(sdp, -1);
-- 
1.7.4

