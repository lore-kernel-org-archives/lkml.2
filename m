Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030771Ab2CSKxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:53:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab2CSKto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:49:44 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/12] GFS2: Move two functions from log.c to lops.c
Date: Mon, 19 Mar 2012 10:25:18 +0000
Message-Id: <1332152728-4027-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gfs2_log_get_buf() and gfs2_log_fake_buf() are both used
only in lops.c, so move them next to their callers and they
can then become static.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 756fae9..4d31379 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -358,7 +358,7 @@ retry:
 	return 0;
 }
 
-static u64 log_bmap(struct gfs2_sbd *sdp, unsigned int lbn)
+u64 gfs2_log_bmap(struct gfs2_sbd *sdp, unsigned int lbn)
 {
 	struct gfs2_journal_extent *je;
 
@@ -467,8 +467,8 @@ static unsigned int current_tail(struct gfs2_sbd *sdp)
 
 void gfs2_log_incr_head(struct gfs2_sbd *sdp)
 {
-	if (sdp->sd_log_flush_head == sdp->sd_log_tail)
-		BUG_ON(sdp->sd_log_flush_head != sdp->sd_log_head);
+	BUG_ON((sdp->sd_log_flush_head == sdp->sd_log_tail) &&
+	       (sdp->sd_log_flush_head != sdp->sd_log_head));
 
 	if (++sdp->sd_log_flush_head == sdp->sd_jdesc->jd_blocks) {
 		sdp->sd_log_flush_head = 0;
@@ -476,99 +476,6 @@ void gfs2_log_incr_head(struct gfs2_sbd *sdp)
 	}
 }
 
-/**
- * gfs2_log_write_endio - End of I/O for a log buffer
- * @bh: The buffer head
- * @uptodate: I/O Status
- *
- */
-
-static void gfs2_log_write_endio(struct buffer_head *bh, int uptodate)
-{
-	struct gfs2_sbd *sdp = bh->b_private;
-	bh->b_private = NULL;
-
-	end_buffer_write_sync(bh, uptodate);
-	if (atomic_dec_and_test(&sdp->sd_log_in_flight))
-		wake_up(&sdp->sd_log_flush_wait);
-}
-
-/**
- * gfs2_log_get_buf - Get and initialize a buffer to use for log control data
- * @sdp: The GFS2 superblock
- *
- * Returns: the buffer_head
- */
-
-struct buffer_head *gfs2_log_get_buf(struct gfs2_sbd *sdp)
-{
-	u64 blkno = log_bmap(sdp, sdp->sd_log_flush_head);
-	struct buffer_head *bh;
-
-	bh = sb_getblk(sdp->sd_vfs, blkno);
-	lock_buffer(bh);
-	memset(bh->b_data, 0, bh->b_size);
-	set_buffer_uptodate(bh);
-	clear_buffer_dirty(bh);
-	gfs2_log_incr_head(sdp);
-	atomic_inc(&sdp->sd_log_in_flight);
-	bh->b_private = sdp;
-	bh->b_end_io = gfs2_log_write_endio;
-
-	return bh;
-}
-
-/**
- * gfs2_fake_write_endio - 
- * @bh: The buffer head
- * @uptodate: The I/O Status
- *
- */
-
-static void gfs2_fake_write_endio(struct buffer_head *bh, int uptodate)
-{
-	struct buffer_head *real_bh = bh->b_private;
-	struct gfs2_bufdata *bd = real_bh->b_private;
-	struct gfs2_sbd *sdp = bd->bd_gl->gl_sbd;
-
-	end_buffer_write_sync(bh, uptodate);
-	free_buffer_head(bh);
-	unlock_buffer(real_bh);
-	brelse(real_bh);
-	if (atomic_dec_and_test(&sdp->sd_log_in_flight))
-		wake_up(&sdp->sd_log_flush_wait);
-}
-
-/**
- * gfs2_log_fake_buf - Build a fake buffer head to write metadata buffer to log
- * @sdp: the filesystem
- * @data: the data the buffer_head should point to
- *
- * Returns: the log buffer descriptor
- */
-
-struct buffer_head *gfs2_log_fake_buf(struct gfs2_sbd *sdp,
-				      struct buffer_head *real)
-{
-	u64 blkno = log_bmap(sdp, sdp->sd_log_flush_head);
-	struct buffer_head *bh;
-
-	bh = alloc_buffer_head(GFP_NOFS | __GFP_NOFAIL);
-	atomic_set(&bh->b_count, 1);
-	bh->b_state = (1 << BH_Mapped) | (1 << BH_Uptodate) | (1 << BH_Lock);
-	set_bh_page(bh, real->b_page, bh_offset(real));
-	bh->b_blocknr = blkno;
-	bh->b_size = sdp->sd_sb.sb_bsize;
-	bh->b_bdev = sdp->sd_vfs->s_bdev;
-	bh->b_private = real;
-	bh->b_end_io = gfs2_fake_write_endio;
-
-	gfs2_log_incr_head(sdp);
-	atomic_inc(&sdp->sd_log_in_flight);
-
-	return bh;
-}
-
 static void log_pull_tail(struct gfs2_sbd *sdp, unsigned int new_tail)
 {
 	unsigned int dist = log_distance(sdp, new_tail, sdp->sd_log_tail);
@@ -592,7 +499,7 @@ static void log_pull_tail(struct gfs2_sbd *sdp, unsigned int new_tail)
 
 static void log_write_header(struct gfs2_sbd *sdp, u32 flags, int pull)
 {
-	u64 blkno = log_bmap(sdp, sdp->sd_log_flush_head);
+	u64 blkno = gfs2_log_bmap(sdp, sdp->sd_log_flush_head);
 	struct buffer_head *bh;
 	struct gfs2_log_header *lh;
 	unsigned int tail;
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index ab06216..ff07454 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -53,10 +53,7 @@ extern unsigned int gfs2_struct2blk(struct gfs2_sbd *sdp, unsigned int nstruct,
 
 extern int gfs2_log_reserve(struct gfs2_sbd *sdp, unsigned int blks);
 extern void gfs2_log_incr_head(struct gfs2_sbd *sdp);
-
-extern struct buffer_head *gfs2_log_get_buf(struct gfs2_sbd *sdp);
-extern struct buffer_head *gfs2_log_fake_buf(struct gfs2_sbd *sdp,
-				      struct buffer_head *real);
+extern u64 gfs2_log_bmap(struct gfs2_sbd *sdp, unsigned int lbn);
 extern void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl);
 extern void gfs2_log_commit(struct gfs2_sbd *sdp, struct gfs2_trans *trans);
 extern void gfs2_remove_from_ail(struct gfs2_bufdata *bd);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 0301be6..8e323c4 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -143,6 +143,98 @@ static inline __be64 *bh_ptr_end(struct buffer_head *bh)
 	return (__force __be64 *)(bh->b_data + bh->b_size);
 }
 
+/**
+ * gfs2_log_write_endio - End of I/O for a log buffer
+ * @bh: The buffer head
+ * @uptodate: I/O Status
+ *
+ */
+
+static void gfs2_log_write_endio(struct buffer_head *bh, int uptodate)
+{
+	struct gfs2_sbd *sdp = bh->b_private;
+	bh->b_private = NULL;
+
+	end_buffer_write_sync(bh, uptodate);
+	if (atomic_dec_and_test(&sdp->sd_log_in_flight))
+		wake_up(&sdp->sd_log_flush_wait);
+}
+
+/**
+ * gfs2_log_get_buf - Get and initialize a buffer to use for log control data
+ * @sdp: The GFS2 superblock
+ *
+ * tReturns: the buffer_head
+ */
+
+static struct buffer_head *gfs2_log_get_buf(struct gfs2_sbd *sdp)
+{
+	u64 blkno = gfs2_log_bmap(sdp, sdp->sd_log_flush_head);
+	struct buffer_head *bh;
+
+	bh = sb_getblk(sdp->sd_vfs, blkno);
+	lock_buffer(bh);
+	memset(bh->b_data, 0, bh->b_size);
+	set_buffer_uptodate(bh);
+	clear_buffer_dirty(bh);
+	gfs2_log_incr_head(sdp);
+	atomic_inc(&sdp->sd_log_in_flight);
+	bh->b_private = sdp;
+	bh->b_end_io = gfs2_log_write_endio;
+
+	return bh;
+}
+
+/**
+ * gfs2_fake_write_endio - 
+ * @bh: The buffer head
+ * @uptodate: The I/O Status
+ *
+ */
+
+static void gfs2_fake_write_endio(struct buffer_head *bh, int uptodate)
+{
+	struct buffer_head *real_bh = bh->b_private;
+	struct gfs2_bufdata *bd = real_bh->b_private;
+	struct gfs2_sbd *sdp = bd->bd_gl->gl_sbd;
+
+	end_buffer_write_sync(bh, uptodate);
+	free_buffer_head(bh);
+	unlock_buffer(real_bh);
+	brelse(real_bh);
+	if (atomic_dec_and_test(&sdp->sd_log_in_flight))
+		wake_up(&sdp->sd_log_flush_wait);
+}
+
+/**
+ * gfs2_log_fake_buf - Build a fake buffer head to write metadata buffer to log
+ * @sdp: the filesystem
+ * @data: the data the buffer_head should point to
+ *
+ * Returns: the log buffer descriptor
+ */
+
+static struct buffer_head *gfs2_log_fake_buf(struct gfs2_sbd *sdp,
+				      struct buffer_head *real)
+{
+	u64 blkno = gfs2_log_bmap(sdp, sdp->sd_log_flush_head);
+	struct buffer_head *bh;
+
+	bh = alloc_buffer_head(GFP_NOFS | __GFP_NOFAIL);
+	atomic_set(&bh->b_count, 1);
+	bh->b_state = (1 << BH_Mapped) | (1 << BH_Uptodate) | (1 << BH_Lock);
+	set_bh_page(bh, real->b_page, bh_offset(real));
+	bh->b_blocknr = blkno;
+	bh->b_size = sdp->sd_sb.sb_bsize;
+	bh->b_bdev = sdp->sd_vfs->s_bdev;
+	bh->b_private = real;
+	bh->b_end_io = gfs2_fake_write_endio;
+
+	gfs2_log_incr_head(sdp);
+	atomic_inc(&sdp->sd_log_in_flight);
+
+	return bh;
+}
 
 static struct buffer_head *gfs2_get_log_desc(struct gfs2_sbd *sdp, u32 ld_type)
 {
-- 
1.7.4

