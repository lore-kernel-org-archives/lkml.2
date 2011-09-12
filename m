Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab1ILNmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 09:42:05 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37110
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755885Ab1ILNmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 09:42:03 -0400
Date: Mon, 12 Sep 2011 09:42:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/2] block: refactor generic_make_request
Message-ID: <20110912134202.GA22953@infradead.org>
References: <20110911145053.GA28996@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110911145053.GA28996@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all the checks performed on a bio into a new helper, and call it as
soon as bio is submitted even if it is a re-submission from ->make_request.

We explicitly mark the new helper as beeing non-inlined as the stack
usage for printing the block device name in the failure case is quite
high and this a patch where we have to be extremely conservative about
stack usage.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2011-09-08 12:07:09.943065855 +0200
+++ linux-2.6/block/blk-core.c	2011-09-08 12:08:23.463277870 +0200
@@ -1412,31 +1412,8 @@ static inline int bio_check_eod(struct b
 	return 0;
 }
 
-/**
- * generic_make_request - hand a buffer to its device driver for I/O
- * @bio:  The bio describing the location in memory and on the device.
- *
- * generic_make_request() is used to make I/O requests of block
- * devices. It is passed a &struct bio, which describes the I/O that needs
- * to be done.
- *
- * generic_make_request() does not return any status.  The
- * success/failure status of the request, along with notification of
- * completion, is delivered asynchronously through the bio->bi_end_io
- * function described (one day) else where.
- *
- * The caller of generic_make_request must make sure that bi_io_vec
- * are set to describe the memory buffer, and that bi_dev and bi_sector are
- * set to describe the device address, and the
- * bi_end_io and optionally bi_private are set to describe how
- * completion notification should be signaled.
- *
- * generic_make_request and the drivers it calls may use bi_next if this
- * bio happens to be merged with someone else, and may change bi_dev and
- * bi_sector for remaps as it sees fit.  So the values of these fields
- * should NOT be depended on after the call to generic_make_request.
- */
-static inline void __generic_make_request(struct bio *bio)
+static noinline_for_stack bool
+generic_make_request_checks(struct bio *bio)
 {
 	struct request_queue *q;
 	int nr_sectors = bio_sectors(bio);
@@ -1515,35 +1492,62 @@ static inline void __generic_make_reques
 
 	/* if bio = NULL, bio has been throttled and will be submitted later. */
 	if (!bio)
-		return;
+		return false;
+
 	trace_block_bio_queue(q, bio);
-	q->make_request_fn(q, bio);
-	return;
+	return true;
 
 end_io:
 	bio_endio(bio, err);
+	return false;
 }
 
-/*
- * We only want one ->make_request_fn to be active at a time,
- * else stack usage with stacked devices could be a problem.
- * So use current->bio_list to keep a list of requests
- * submited by a make_request_fn function.
- * current->bio_list is also used as a flag to say if
- * generic_make_request is currently active in this task or not.
- * If it is NULL, then no make_request is active.  If it is non-NULL,
- * then a make_request is active, and new requests should be added
- * at the tail
+/**
+ * generic_make_request - hand a buffer to its device driver for I/O
+ * @bio:  The bio describing the location in memory and on the device.
+ *
+ * generic_make_request() is used to make I/O requests of block
+ * devices. It is passed a &struct bio, which describes the I/O that needs
+ * to be done.
+ *
+ * generic_make_request() does not return any status.  The
+ * success/failure status of the request, along with notification of
+ * completion, is delivered asynchronously through the bio->bi_end_io
+ * function described (one day) else where.
+ *
+ * The caller of generic_make_request must make sure that bi_io_vec
+ * are set to describe the memory buffer, and that bi_dev and bi_sector are
+ * set to describe the device address, and the
+ * bi_end_io and optionally bi_private are set to describe how
+ * completion notification should be signaled.
+ *
+ * generic_make_request and the drivers it calls may use bi_next if this
+ * bio happens to be merged with someone else, and may resubmit the bio to
+ * a lower device by calling into generic_make_request recursively, which
+ * means the bio should NOT be touched after the call to ->make_request_fn.
  */
 void generic_make_request(struct bio *bio)
 {
 	struct bio_list bio_list_on_stack;
 
+	if (!generic_make_request_checks(bio))
+		return;
+
+	/*
+	 * We only want one ->make_request_fn to be active at a time, else
+	 * stack usage with stacked devices could be a problem.  So use
+	 * current->bio_list to keep a list of requests submited by a
+	 * make_request_fn function.  current->bio_list is also used as a
+	 * flag to say if generic_make_request is currently active in this
+	 * task or not.  If it is NULL, then no make_request is active.  If
+	 * it is non-NULL, then a make_request is active, and new requests
+	 * should be added at the tail
+	 */
 	if (current->bio_list) {
-		/* make_request is active */
 		bio_list_add(current->bio_list, bio);
 		return;
 	}
+
 	/* following loop may be a bit non-obvious, and so deserves some
 	 * explanation.
 	 * Before entering the loop, bio->bi_next is NULL (as all callers
@@ -1557,16 +1561,15 @@ void generic_make_request(struct bio *bi
 	 * from the top.  In this case we really did just take the bio
 	 * of the top of the list (no pretending) and so remove it from
 	 * bio_list, and call into __generic_make_request again.
-	 *
-	 * The loop was structured like this to make only one call to
-	 * __generic_make_request (which is important as it is large and
-	 * inlined) and to keep the structure simple.
 	 */
 	BUG_ON(bio->bi_next);
 	bio_list_init(&bio_list_on_stack);
 	current->bio_list = &bio_list_on_stack;
 	do {
-		__generic_make_request(bio);
+		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+
+		q->make_request_fn(q, bio);
+
 		bio = bio_list_pop(current->bio_list);
 	} while (bio);
 	current->bio_list = NULL; /* deactivate */
