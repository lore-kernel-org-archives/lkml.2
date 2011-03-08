Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1CHMiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 07:38:15 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:34430 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab1CHMiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:38:13 -0500
X-ASG-Debug-ID: 1299587892-03d6a54f6324770001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D762330.8000003@fusionio.com>
Date: Tue, 8 Mar 2011 13:38:08 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "hch@infradead.org" <hch@infradead.org>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/10] fs: make generic file read/write functions plug
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com> <1295659049-2688-8-git-send-email-jaxboe@fusionio.com> <20110304040907.GB32404@redhat.com> <4D70E78D.9000402@fusionio.com> <20110304132551.GA2407@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH 07/10] fs: make generic file read/write functions plug
In-Reply-To: <20110304132551.GA2407@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299587892
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.60
X-Barracuda-Spam-Status: No, SCORE=0.60 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=MARKETING_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57406
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 MARKETING_SUBJECT      Subject contains popular marketing words
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-04 14:25, hch@infradead.org wrote:
> REQ_UNPLUG should simply go away with the explicit stack plugging.
> What's left for REQ_SYNC?  It'll control if the request goes into the
> sync bucket and some cfq tweaks.  We should clearly document what it
> does.

How about the below? It gets rid of REQ_UNPLUG.

diff --git a/block/blk-core.c b/block/blk-core.c
index 82a4589..7e9715a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1290,7 +1290,7 @@ get_rq:
 	}
 
 	plug = current->plug;
-	if (plug && !sync) {
+	if (plug) {
 		if (!plug->should_sort && !list_empty(&plug->list)) {
 			struct request *__rq;
 
diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 2096628..aca3024 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -80,7 +80,7 @@ static int _drbd_md_sync_page_io(struct drbd_conf *mdev,
 
 	if ((rw & WRITE) && !test_bit(MD_NO_FUA, &mdev->flags))
 		rw |= REQ_FUA;
-	rw |= REQ_UNPLUG | REQ_SYNC;
+	rw |= REQ_SYNC;
 
 	bio = bio_alloc(GFP_NOIO, 1);
 	bio->bi_bdev = bdev->md_bdev;
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 0b5718e..b0bd27d 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -377,7 +377,7 @@ union p_header {
 #define DP_HARDBARRIER	      1 /* depricated */
 #define DP_RW_SYNC	      2 /* equals REQ_SYNC    */
 #define DP_MAY_SET_IN_SYNC    4
-#define DP_UNPLUG             8 /* equals REQ_UNPLUG  */
+#define DP_UNPLUG             8 /* not used anymore   */
 #define DP_FUA               16 /* equals REQ_FUA     */
 #define DP_FLUSH             32 /* equals REQ_FLUSH   */
 #define DP_DISCARD           64 /* equals REQ_DISCARD */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 6049cb8..8a43ce0 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2477,12 +2477,11 @@ static u32 bio_flags_to_wire(struct drbd_conf *mdev, unsigned long bi_rw)
 {
 	if (mdev->agreed_pro_version >= 95)
 		return  (bi_rw & REQ_SYNC ? DP_RW_SYNC : 0) |
-			(bi_rw & REQ_UNPLUG ? DP_UNPLUG : 0) |
 			(bi_rw & REQ_FUA ? DP_FUA : 0) |
 			(bi_rw & REQ_FLUSH ? DP_FLUSH : 0) |
 			(bi_rw & REQ_DISCARD ? DP_DISCARD : 0);
 	else
-		return bi_rw & (REQ_SYNC | REQ_UNPLUG) ? DP_RW_SYNC : 0;
+		return bi_rw & REQ_SYNC ? DP_RW_SYNC : 0;
 }
 
 /* Used to send write requests
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 84132f8..8e68be9 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1100,8 +1100,6 @@ next_bio:
 	/* > e->sector, unless this is the first bio */
 	bio->bi_sector = sector;
 	bio->bi_bdev = mdev->ldev->backing_bdev;
-	/* we special case some flags in the multi-bio case, see below
-	 * (REQ_UNPLUG) */
 	bio->bi_rw = rw;
 	bio->bi_private = e;
 	bio->bi_end_io = drbd_endio_sec;
@@ -1130,10 +1128,6 @@ next_bio:
 		bios = bios->bi_next;
 		bio->bi_next = NULL;
 
-		/* strip off REQ_UNPLUG unless it is the last bio */
-		if (bios)
-			bio->bi_rw &= ~REQ_UNPLUG;
-
 		drbd_generic_make_request(mdev, fault_type, bio);
 	} while (bios);
 	return 0;
@@ -1621,12 +1615,11 @@ static unsigned long write_flags_to_bio(struct drbd_conf *mdev, u32 dpf)
 {
 	if (mdev->agreed_pro_version >= 95)
 		return  (dpf & DP_RW_SYNC ? REQ_SYNC : 0) |
-			(dpf & DP_UNPLUG ? REQ_UNPLUG : 0) |
 			(dpf & DP_FUA ? REQ_FUA : 0) |
 			(dpf & DP_FLUSH ? REQ_FUA : 0) |
 			(dpf & DP_DISCARD ? REQ_DISCARD : 0);
 	else
-		return dpf & DP_RW_SYNC ? (REQ_SYNC | REQ_UNPLUG) : 0;
+		return dpf & DP_RW_SYNC ? REQ_SYNC : 0;
 }
 
 /* mirrored write */
diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 54bfc27..ca203cb 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -347,7 +347,7 @@ static void write_page(struct bitmap *bitmap, struct page *page, int wait)
 			atomic_inc(&bitmap->pending_writes);
 			set_buffer_locked(bh);
 			set_buffer_mapped(bh);
-			submit_bh(WRITE | REQ_UNPLUG | REQ_SYNC, bh);
+			submit_bh(WRITE | REQ_SYNC, bh);
 			bh = bh->b_this_page;
 		}
 
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 136d4f7..76a5af0 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -352,7 +352,7 @@ static void dispatch_io(int rw, unsigned int num_regions,
 	BUG_ON(num_regions > DM_IO_MAX_REGIONS);
 
 	if (sync)
-		rw |= REQ_SYNC | REQ_UNPLUG;
+		rw |= REQ_SYNC;
 
 	/*
 	 * For multiple regions we need to be careful to rewind
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index e8429ce..2c880e9 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -363,11 +363,8 @@ static int run_io_job(struct kcopyd_job *job)
 
 	if (job->rw == READ)
 		r = dm_io(&io_req, 1, &job->source, NULL);
-	else {
-		if (job->num_dests > 1)
-			io_req.bi_rw |= REQ_UNPLUG;
+	else
 		r = dm_io(&io_req, job->num_dests, job->dests, NULL);
-	}
 
 	return r;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ca0d79c..28f9c1e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -777,8 +777,7 @@ void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
 	bio->bi_end_io = super_written;
 
 	atomic_inc(&mddev->pending_writes);
-	submit_bio(REQ_WRITE | REQ_SYNC | REQ_UNPLUG | REQ_FLUSH | REQ_FUA,
-		   bio);
+	submit_bio(REQ_WRITE | REQ_SYNC | REQ_FLUSH | REQ_FUA, bio);
 }
 
 void md_super_wait(mddev_t *mddev)
@@ -806,7 +805,7 @@ int sync_page_io(mdk_rdev_t *rdev, sector_t sector, int size,
 	struct completion event;
 	int ret;
 
-	rw |= REQ_SYNC | REQ_UNPLUG;
+	rw |= REQ_SYNC;
 
 	bio->bi_bdev = (metadata_op && rdev->meta_bdev) ?
 		rdev->meta_bdev : rdev->bdev;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 92ac519..b76f7cd 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2182,7 +2182,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	unsigned long nr_written = 0;
 
 	if (wbc->sync_mode == WB_SYNC_ALL)
-		write_flags = WRITE_SYNC_PLUG;
+		write_flags = WRITE_SYNC;
 	else
 		write_flags = WRITE;
 
diff --git a/fs/buffer.c b/fs/buffer.c
index f903f2e..19ae76a 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -767,7 +767,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 				 * still in flight on potentially older
 				 * contents.
 				 */
-				write_dirty_buffer(bh, WRITE_SYNC_PLUG);
+				write_dirty_buffer(bh, WRITE_SYNC);
 
 				/*
 				 * Kick off IO for the previous mapping. Note
@@ -1602,14 +1602,11 @@ EXPORT_SYMBOL(unmap_underlying_metadata);
  * prevents this contention from occurring.
  *
  * If block_write_full_page() is called with wbc->sync_mode ==
- * WB_SYNC_ALL, the writes are posted using WRITE_SYNC_PLUG; this
- * causes the writes to be flagged as synchronous writes, but the
- * block device queue will NOT be unplugged, since usually many pages
- * will be pushed to the out before the higher-level caller actually
- * waits for the writes to be completed.  The various wait functions,
- * such as wait_on_writeback_range() will ultimately call sync_page()
- * which will ultimately call blk_run_backing_dev(), which will end up
- * unplugging the device queue.
+ * WB_SYNC_ALL, the writes are posted using WRITE_SYNC; this
+ * causes the writes to be flagged as synchronous writes.
+ * The various wait functions, such as wait_on_writeback_range() will
+ * ultimately call sync_page() which will ultimately call
+ * blk_run_backing_dev(), which will end up unplugging the device queue.
  */
 static int __block_write_full_page(struct inode *inode, struct page *page,
 			get_block_t *get_block, struct writeback_control *wbc,
@@ -1622,7 +1619,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	const unsigned blocksize = 1 << inode->i_blkbits;
 	int nr_underway = 0;
 	int write_op = (wbc->sync_mode == WB_SYNC_ALL ?
-			WRITE_SYNC_PLUG : WRITE);
+			WRITE_SYNC : WRITE);
 
 	BUG_ON(!PageLocked(page));
 
diff --git a/fs/direct-io.c b/fs/direct-io.c
index df709b3..4260831 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1173,7 +1173,7 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct dio *dio;
 
 	if (rw & WRITE)
-		rw = WRITE_ODIRECT_PLUG;
+		rw = WRITE_ODIRECT;
 
 	if (bdev)
 		bdev_blkbits = blksize_bits(bdev_logical_block_size(bdev));
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 955cc30..e2cd90e 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -310,8 +310,7 @@ static int io_submit_init(struct ext4_io_submit *io,
 	io_end->offset = (page->index << PAGE_CACHE_SHIFT) + bh_offset(bh);
 
 	io->io_bio = bio;
-	io->io_op = (wbc->sync_mode == WB_SYNC_ALL ?
-			WRITE_SYNC_PLUG : WRITE);
+	io->io_op = (wbc->sync_mode == WB_SYNC_ALL ?  WRITE_SYNC : WRITE);
 	io->io_next_block = bh->b_blocknr;
 	return 0;
 }
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index eb01f35..7f1c112 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -121,7 +121,7 @@ __acquires(&sdp->sd_log_lock)
 			lock_buffer(bh);
 			if (test_clear_buffer_dirty(bh)) {
 				bh->b_end_io = end_buffer_write_sync;
-				submit_bh(WRITE_SYNC_PLUG, bh);
+				submit_bh(WRITE_SYNC, bh);
 			} else {
 				unlock_buffer(bh);
 				brelse(bh);
@@ -647,7 +647,7 @@ static void gfs2_ordered_write(struct gfs2_sbd *sdp)
 		lock_buffer(bh);
 		if (buffer_mapped(bh) && test_clear_buffer_dirty(bh)) {
 			bh->b_end_io = end_buffer_write_sync;
-			submit_bh(WRITE_SYNC_PLUG, bh);
+			submit_bh(WRITE_SYNC, bh);
 		} else {
 			unlock_buffer(bh);
 			brelse(bh);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index bf33f82..48b545a 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -200,7 +200,7 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 		}
 
 		gfs2_log_unlock(sdp);
-		submit_bh(WRITE_SYNC_PLUG, bh);
+		submit_bh(WRITE_SYNC, bh);
 		gfs2_log_lock(sdp);
 
 		n = 0;
@@ -210,7 +210,7 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 			gfs2_log_unlock(sdp);
 			lock_buffer(bd2->bd_bh);
 			bh = gfs2_log_fake_buf(sdp, bd2->bd_bh);
-			submit_bh(WRITE_SYNC_PLUG, bh);
+			submit_bh(WRITE_SYNC, bh);
 			gfs2_log_lock(sdp);
 			if (++n >= num)
 				break;
@@ -352,7 +352,7 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 		sdp->sd_log_num_revoke--;
 
 		if (offset + sizeof(u64) > sdp->sd_sb.sb_bsize) {
-			submit_bh(WRITE_SYNC_PLUG, bh);
+			submit_bh(WRITE_SYNC, bh);
 
 			bh = gfs2_log_get_buf(sdp);
 			mh = (struct gfs2_meta_header *)bh->b_data;
@@ -369,7 +369,7 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 	}
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_revoke);
 
-	submit_bh(WRITE_SYNC_PLUG, bh);
+	submit_bh(WRITE_SYNC, bh);
 }
 
 static void revoke_lo_before_scan(struct gfs2_jdesc *jd,
@@ -571,7 +571,7 @@ static void gfs2_write_blocks(struct gfs2_sbd *sdp, struct buffer_head *bh,
 	ptr = bh_log_ptr(bh);
 	
 	get_bh(bh);
-	submit_bh(WRITE_SYNC_PLUG, bh);
+	submit_bh(WRITE_SYNC, bh);
 	gfs2_log_lock(sdp);
 	while(!list_empty(list)) {
 		bd = list_entry(list->next, struct gfs2_bufdata, bd_le.le_list);
@@ -597,7 +597,7 @@ static void gfs2_write_blocks(struct gfs2_sbd *sdp, struct buffer_head *bh,
 		} else {
 			bh1 = gfs2_log_fake_buf(sdp, bd->bd_bh);
 		}
-		submit_bh(WRITE_SYNC_PLUG, bh1);
+		submit_bh(WRITE_SYNC, bh1);
 		gfs2_log_lock(sdp);
 		ptr += 2;
 	}
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index a566331..867b713 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -37,7 +37,7 @@ static int gfs2_aspace_writepage(struct page *page, struct writeback_control *wb
 	struct buffer_head *bh, *head;
 	int nr_underway = 0;
 	int write_op = REQ_META |
-		(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC_PLUG : WRITE);
+		(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(!page_has_buffers(page));
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 34a4861..66be299 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -333,7 +333,7 @@ void journal_commit_transaction(journal_t *journal)
 	 * instead we rely on sync_buffer() doing the unplug for us.
 	 */
 	if (commit_transaction->t_synchronous_commit)
-		write_op = WRITE_SYNC_PLUG;
+		write_op = WRITE_SYNC;
 	spin_lock(&commit_transaction->t_handle_lock);
 	while (commit_transaction->t_updates) {
 		DEFINE_WAIT(wait);
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index f3ad159..3da1cc4 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -137,9 +137,9 @@ static int journal_submit_commit_record(journal_t *journal,
 	if (journal->j_flags & JBD2_BARRIER &&
 	    !JBD2_HAS_INCOMPAT_FEATURE(journal,
 				       JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT))
-		ret = submit_bh(WRITE_SYNC_PLUG | WRITE_FLUSH_FUA, bh);
+		ret = submit_bh(WRITE_SYNC | WRITE_FLUSH_FUA, bh);
 	else
-		ret = submit_bh(WRITE_SYNC_PLUG, bh);
+		ret = submit_bh(WRITE_SYNC, bh);
 
 	*cbh = bh;
 	return ret;
@@ -369,7 +369,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	 * instead we rely on sync_buffer() doing the unplug for us.
 	 */
 	if (commit_transaction->t_synchronous_commit)
-		write_op = WRITE_SYNC_PLUG;
+		write_op = WRITE_SYNC;
 	trace_jbd2_commit_locking(journal, commit_transaction);
 	stats.run.rs_wait = commit_transaction->t_max_wait;
 	stats.run.rs_locked = jiffies;
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 0f83e93..2853ff2 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -509,7 +509,7 @@ static int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
 		 * Last BIO is always sent through the following
 		 * submission.
 		 */
-		rw |= REQ_SYNC | REQ_UNPLUG;
+		rw |= REQ_SYNC;
 		res = nilfs_segbuf_submit_bio(segbuf, &wi, rw);
 	}
 
diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 83c1c20..6bbb0ee 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -413,8 +413,7 @@ xfs_submit_ioend_bio(
 	if (xfs_ioend_new_eof(ioend))
 		xfs_mark_inode_dirty(XFS_I(ioend->io_inode));
 
-	submit_bio(wbc->sync_mode == WB_SYNC_ALL ?
-		   WRITE_SYNC_PLUG : WRITE, bio);
+	submit_bio(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE, bio);
 }
 
 STATIC struct bio *
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 16b2864..be50d9e 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -128,7 +128,6 @@ enum rq_flag_bits {
 	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
 
 	/* bio only flags */
-	__REQ_UNPLUG,		/* unplug the immediately after submission */
 	__REQ_RAHEAD,		/* read ahead, can fail anytime */
 	__REQ_THROTTLED,	/* This bio has already been subjected to
 				 * throttling rules. Don't do it again. */
@@ -172,7 +171,6 @@ enum rq_flag_bits {
 	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
-#define REQ_UNPLUG		(1 << __REQ_UNPLUG)
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
 #define REQ_THROTTLED		(1 << __REQ_THROTTLED)
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9f2cf69..543e226 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -135,16 +135,10 @@ struct inodes_stat_t {
  *			block layer could (in theory) choose to ignore this
  *			request if it runs into resource problems.
  * WRITE		A normal async write. Device will be plugged.
- * WRITE_SYNC_PLUG	Synchronous write. Identical to WRITE, but passes down
+ * WRITE_SYNC		Synchronous write. Identical to WRITE, but passes down
  *			the hint that someone will be waiting on this IO
- *			shortly. The device must still be unplugged explicitly,
- *			WRITE_SYNC_PLUG does not do this as we could be
- *			submitting more writes before we actually wait on any
- *			of them.
- * WRITE_SYNC		Like WRITE_SYNC_PLUG, but also unplugs the device
- *			immediately after submission. The write equivalent
- *			of READ_SYNC.
- * WRITE_ODIRECT_PLUG	Special case write for O_DIRECT only.
+ *			shortly. The write equivalent of READ_SYNC.
+ * WRITE_ODIRECT	Special case write for O_DIRECT only.
  * WRITE_FLUSH		Like WRITE_SYNC but with preceding cache flush.
  * WRITE_FUA		Like WRITE_SYNC but data is guaranteed to be on
  *			non-volatile media on completion.
@@ -160,18 +154,14 @@ struct inodes_stat_t {
 #define WRITE			RW_MASK
 #define READA			RWA_MASK
 
-#define READ_SYNC		(READ | REQ_SYNC | REQ_UNPLUG)
+#define READ_SYNC		(READ | REQ_SYNC)
 #define READ_META		(READ | REQ_META)
-#define WRITE_SYNC_PLUG		(WRITE | REQ_SYNC | REQ_NOIDLE)
-#define WRITE_SYNC		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG)
-#define WRITE_ODIRECT_PLUG	(WRITE | REQ_SYNC)
+#define WRITE_SYNC		(WRITE | REQ_SYNC | REQ_NOIDLE)
+#define WRITE_ODIRECT		(WRITE | REQ_SYNC)
 #define WRITE_META		(WRITE | REQ_META)
-#define WRITE_FLUSH		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
-				 REQ_FLUSH)
-#define WRITE_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
-				 REQ_FUA)
-#define WRITE_FLUSH_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
-				 REQ_FLUSH | REQ_FUA)
+#define WRITE_FLUSH		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH)
+#define WRITE_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FUA)
+#define WRITE_FLUSH_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
 
 #define SEL_IN		1
 #define SEL_OUT		2
diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index 83bbc7c..d09dd10 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -28,7 +28,7 @@
 static int submit(int rw, struct block_device *bdev, sector_t sector,
 		struct page *page, struct bio **bio_chain)
 {
-	const int bio_rw = rw | REQ_SYNC | REQ_UNPLUG;
+	const int bio_rw = rw | REQ_SYNC;
 	struct bio *bio;
 
 	bio = bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
diff --git a/mm/page_io.c b/mm/page_io.c
index 2dee975..dc76b4d 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -106,7 +106,7 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 		goto out;
 	}
 	if (wbc->sync_mode == WB_SYNC_ALL)
-		rw |= REQ_SYNC | REQ_UNPLUG;
+		rw |= REQ_SYNC;
 	count_vm_event(PSWPOUT);
 	set_page_writeback(page);
 	unlock_page(page);

-- 
Jens Axboe

