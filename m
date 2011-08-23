Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab1HWKJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 06:09:48 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42249
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751Ab1HWKJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 06:09:45 -0400
Date: Tue, 23 Aug 2011 06:09:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2 v2] block: separate priority boosting from REQ_META
Message-ID: <20110823100940.GA4903@infradead.org>
References: <4E4E6238.3080808@fusionio.com>
 <20110820174137.GA27243@infradead.org>
 <4E5146C1.508@fusionio.com>
 <20110821181935.GA28979@infradead.org>
 <4E515057.7040802@fusionio.com>
 <20110822165221.GB7257@infradead.org>
 <87r54cg9vn.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r54cg9vn.fsf@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new REQ_PRIO to let requests preempt others in the cfq I/O schedule,
and lave REQ_META purely for marking requests as metadata in blktrace.

All existing callers of REQ_META except for XFS are updated to also
set REQ_PRIO for now.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c	2011-08-23 02:29:10.843355420 +0200
+++ linux-2.6/block/cfq-iosched.c	2011-08-23 10:18:19.430245519 +0200
@@ -130,8 +130,8 @@ struct cfq_queue {
 	unsigned long slice_end;
 	long slice_resid;
 
-	/* pending metadata requests */
-	int meta_pending;
+	/* pending priority requests */
+	int prio_pending;
 	/* number of requests that are on the dispatch list or inside driver */
 	int dispatched;
 
@@ -684,8 +684,8 @@ cfq_choose_req(struct cfq_data *cfqd, st
 	if (rq_is_sync(rq1) != rq_is_sync(rq2))
 		return rq_is_sync(rq1) ? rq1 : rq2;
 
-	if ((rq1->cmd_flags ^ rq2->cmd_flags) & REQ_META)
-		return rq1->cmd_flags & REQ_META ? rq1 : rq2;
+	if ((rq1->cmd_flags ^ rq2->cmd_flags) & REQ_PRIO)
+		return rq1->cmd_flags & REQ_PRIO ? rq1 : rq2;
 
 	s1 = blk_rq_pos(rq1);
 	s2 = blk_rq_pos(rq2);
@@ -1612,9 +1612,9 @@ static void cfq_remove_request(struct re
 	cfqq->cfqd->rq_queued--;
 	cfq_blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg,
 					rq_data_dir(rq), rq_is_sync(rq));
-	if (rq->cmd_flags & REQ_META) {
-		WARN_ON(!cfqq->meta_pending);
-		cfqq->meta_pending--;
+	if (rq->cmd_flags & REQ_PRIO) {
+		WARN_ON(!cfqq->prio_pending);
+		cfqq->prio_pending--;
 	}
 }
 
@@ -3372,7 +3372,7 @@ cfq_should_preempt(struct cfq_data *cfqd
 	 * So both queues are sync. Let the new request get disk time if
 	 * it's a metadata request and the current queue is doing regular IO.
 	 */
-	if ((rq->cmd_flags & REQ_META) && !cfqq->meta_pending)
+	if ((rq->cmd_flags & REQ_PRIO) && !cfqq->prio_pending)
 		return true;
 
 	/*
@@ -3439,8 +3439,8 @@ cfq_rq_enqueued(struct cfq_data *cfqd, s
 	struct cfq_io_context *cic = RQ_CIC(rq);
 
 	cfqd->rq_queued++;
-	if (rq->cmd_flags & REQ_META)
-		cfqq->meta_pending++;
+	if (rq->cmd_flags & REQ_PRIO)
+		cfqq->prio_pending++;
 
 	cfq_update_io_thinktime(cfqd, cfqq, cic);
 	cfq_update_io_seektime(cfqd, cfqq, rq);
Index: linux-2.6/drivers/mmc/card/block.c
===================================================================
--- linux-2.6.orig/drivers/mmc/card/block.c	2011-08-23 02:29:10.830022159 +0200
+++ linux-2.6/drivers/mmc/card/block.c	2011-08-23 10:18:19.430245519 +0200
@@ -926,6 +926,9 @@ static void mmc_blk_rw_rq_prep(struct mm
 	/*
 	 * Reliable writes are used to implement Forced Unit Access and
 	 * REQ_META accesses, and are supported only on MMCs.
+	 *
+	 * XXX: this really needs a good explanation of why REQ_META
+	 * is treated special.
 	 */
 	bool do_rel_wr = ((req->cmd_flags & REQ_FUA) ||
 			  (req->cmd_flags & REQ_META)) &&
Index: linux-2.6/fs/ext3/inode.c
===================================================================
--- linux-2.6.orig/fs/ext3/inode.c	2011-08-23 10:18:18.910248335 +0200
+++ linux-2.6/fs/ext3/inode.c	2011-08-23 10:18:19.433578834 +0200
@@ -1134,7 +1134,7 @@ struct buffer_head *ext3_bread(handle_t
 		return bh;
 	if (buffer_uptodate(bh))
 		return bh;
-	ll_rw_block(READ | REQ_META, 1, &bh);
+	ll_rw_block(READ | REQ_META | REQ_PRIO, 1, &bh);
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
 		return bh;
@@ -2807,7 +2807,7 @@ make_io:
 		trace_ext3_load_inode(inode);
 		get_bh(bh);
 		bh->b_end_io = end_buffer_read_sync;
-		submit_bh(READ | REQ_META, bh);
+		submit_bh(READ | REQ_META | REQ_PRIO, bh);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh)) {
 			ext3_error(inode->i_sb, "ext3_get_inode_loc",
Index: linux-2.6/fs/ext3/namei.c
===================================================================
--- linux-2.6.orig/fs/ext3/namei.c	2011-08-23 10:18:18.910248335 +0200
+++ linux-2.6/fs/ext3/namei.c	2011-08-23 10:18:19.436912149 +0200
@@ -922,7 +922,8 @@ restart:
 				bh = ext3_getblk(NULL, dir, b++, 0, &err);
 				bh_use[ra_max] = bh;
 				if (bh)
-					ll_rw_block(READ | REQ_META, 1, &bh);
+					ll_rw_block(READ | REQ_META | REQ_PRIO,
+						    1, &bh);
 			}
 		}
 		if ((bh = bh_use[ra_ptr++]) == NULL)
Index: linux-2.6/fs/ext4/inode.c
===================================================================
--- linux-2.6.orig/fs/ext4/inode.c	2011-08-23 10:18:18.910248335 +0200
+++ linux-2.6/fs/ext4/inode.c	2011-08-23 10:18:19.440245464 +0200
@@ -650,7 +650,7 @@ struct buffer_head *ext4_bread(handle_t
 		return bh;
 	if (buffer_uptodate(bh))
 		return bh;
-	ll_rw_block(READ | REQ_META, 1, &bh);
+	ll_rw_block(READ | REQ_META | REQ_PRIO, 1, &bh);
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
 		return bh;
@@ -3301,7 +3301,7 @@ make_io:
 		trace_ext4_load_inode(inode);
 		get_bh(bh);
 		bh->b_end_io = end_buffer_read_sync;
-		submit_bh(READ | REQ_META, bh);
+		submit_bh(READ | REQ_META | REQ_PRIO, bh);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh)) {
 			EXT4_ERROR_INODE_BLOCK(inode, block,
Index: linux-2.6/fs/ext4/namei.c
===================================================================
--- linux-2.6.orig/fs/ext4/namei.c	2011-08-23 10:18:18.913581650 +0200
+++ linux-2.6/fs/ext4/namei.c	2011-08-23 10:18:19.443578779 +0200
@@ -922,7 +922,8 @@ restart:
 				bh = ext4_getblk(NULL, dir, b++, 0, &err);
 				bh_use[ra_max] = bh;
 				if (bh)
-					ll_rw_block(READ | REQ_META, 1, &bh);
+					ll_rw_block(READ | REQ_META | REQ_PRIO,
+						    1, &bh);
 			}
 		}
 		if ((bh = bh_use[ra_ptr++]) == NULL)
Index: linux-2.6/fs/gfs2/log.c
===================================================================
--- linux-2.6.orig/fs/gfs2/log.c	2011-08-23 02:29:10.883355202 +0200
+++ linux-2.6/fs/gfs2/log.c	2011-08-23 10:18:19.446912094 +0200
@@ -624,9 +624,9 @@ static void log_write_header(struct gfs2
 	bh->b_end_io = end_buffer_write_sync;
 	get_bh(bh);
 	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags))
-		submit_bh(WRITE_SYNC | REQ_META, bh);
+		submit_bh(WRITE_SYNC | REQ_META | REQ_PRIO, bh);
 	else
-		submit_bh(WRITE_FLUSH_FUA | REQ_META, bh);
+		submit_bh(WRITE_FLUSH_FUA | REQ_META | REQ_PRIO, bh);
 	wait_on_buffer(bh);
 
 	if (!buffer_uptodate(bh))
Index: linux-2.6/fs/gfs2/meta_io.c
===================================================================
--- linux-2.6.orig/fs/gfs2/meta_io.c	2011-08-23 02:29:10.890021834 +0200
+++ linux-2.6/fs/gfs2/meta_io.c	2011-08-23 10:18:19.446912094 +0200
@@ -37,7 +37,7 @@ static int gfs2_aspace_writepage(struct
 {
 	struct buffer_head *bh, *head;
 	int nr_underway = 0;
-	int write_op = REQ_META |
+	int write_op = REQ_META | REQ_PRIO |
 		(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
 
 	BUG_ON(!PageLocked(page));
@@ -225,7 +225,7 @@ int gfs2_meta_read(struct gfs2_glock *gl
 	}
 	bh->b_end_io = end_buffer_read_sync;
 	get_bh(bh);
-	submit_bh(READ_SYNC | REQ_META, bh);
+	submit_bh(READ_SYNC | REQ_META | REQ_PRIO, bh);
 	if (!(flags & DIO_WAIT))
 		return 0;
 
@@ -435,7 +435,7 @@ struct buffer_head *gfs2_meta_ra(struct
 	if (buffer_uptodate(first_bh))
 		goto out;
 	if (!buffer_locked(first_bh))
-		ll_rw_block(READ_SYNC | REQ_META, 1, &first_bh);
+		ll_rw_block(READ_SYNC | REQ_META | REQ_PRIO, 1, &first_bh);
 
 	dblock++;
 	extlen--;
Index: linux-2.6/fs/gfs2/ops_fstype.c
===================================================================
--- linux-2.6.orig/fs/gfs2/ops_fstype.c	2011-08-23 02:29:10.896688465 +0200
+++ linux-2.6/fs/gfs2/ops_fstype.c	2011-08-23 10:18:19.450245409 +0200
@@ -224,7 +224,7 @@ static int gfs2_read_super(struct gfs2_s
 
 	bio->bi_end_io = end_bio_io_page;
 	bio->bi_private = page;
-	submit_bio(READ_SYNC | REQ_META, bio);
+	submit_bio(READ_SYNC | REQ_META | REQ_PRIO, bio);
 	wait_on_page_locked(page);
 	bio_put(bio);
 	if (!PageUptodate(page)) {
Index: linux-2.6/fs/gfs2/quota.c
===================================================================
--- linux-2.6.orig/fs/gfs2/quota.c	2011-08-23 10:18:18.916914965 +0200
+++ linux-2.6/fs/gfs2/quota.c	2011-08-23 10:18:19.450245409 +0200
@@ -709,7 +709,7 @@ get_a_page:
 		set_buffer_uptodate(bh);
 
 	if (!buffer_uptodate(bh)) {
-		ll_rw_block(READ | REQ_META, 1, &bh);
+		ll_rw_block(READ | REQ_META | REQ_PRIO, 1, &bh);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh))
 			goto unlock_out;
Index: linux-2.6/include/linux/blk_types.h
===================================================================
--- linux-2.6.orig/include/linux/blk_types.h	2011-08-23 02:29:10.903355095 +0200
+++ linux-2.6/include/linux/blk_types.h	2011-08-23 10:18:45.196772595 +0200
@@ -124,6 +124,7 @@ enum rq_flag_bits {
 
 	__REQ_SYNC,		/* request is sync (sync write or read) */
 	__REQ_META,		/* metadata io request */
+	__REQ_PRIO,		/* boost priority in cfq */
 	__REQ_DISCARD,		/* request to discard sectors */
 	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
 
@@ -161,14 +162,15 @@ enum rq_flag_bits {
 #define REQ_FAILFAST_DRIVER	(1 << __REQ_FAILFAST_DRIVER)
 #define REQ_SYNC		(1 << __REQ_SYNC)
 #define REQ_META		(1 << __REQ_META)
+#define REQ_PRIO		(1 << __REQ_PRIO)
 #define REQ_DISCARD		(1 << __REQ_DISCARD)
 #define REQ_NOIDLE		(1 << __REQ_NOIDLE)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
-	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_DISCARD | \
-	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
+	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | \
+	 REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
