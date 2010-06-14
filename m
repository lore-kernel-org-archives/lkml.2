Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab0FNQQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:16:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33569 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab0FNQQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:16:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w7fsMgidLQq1w5ojIMBnV1MtPp+mfkxOlrer94sEueDRUwKUlCh0QimQiLh85shAiq
         kuOiY+3mG4KhGJ+EeqJ5UuqFNUduHFMKCok62ymVxjaYYePWRAJugyb4SMlNJYVIf8vI
         OA9ib6aXU+uQs+nH2Wx1DwY5Ro0FNFF6qZZyY=
Date: Mon, 14 Jun 2010 09:15:57 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 2/3] Bcache: Version 5 - hooks
Message-ID: <20100614161557.GA945@moria>
References: <20100614153706.GA31477@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614153706.GA31477@moria>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 block/blk-core.c       |   10 +++++++---
 fs/bio.c               |   26 ++++++++++++++++++++++++++
 include/linux/bio.h    |    3 +++
 include/linux/blkdev.h |    2 ++
 include/linux/fs.h     |    5 +++++
 5 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f84cce4..bee689b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1431,11 +1431,11 @@ static inline int bio_check_eod(struct bio *bio, unsigned int nr_sectors)
  * bi_sector for remaps as it sees fit.  So the values of these fields
  * should NOT be depended on after the call to generic_make_request.
  */
-static inline void __generic_make_request(struct bio *bio)
+inline void __generic_make_request(struct bio *bio)
 {
 	struct request_queue *q;
 	sector_t old_sector;
-	int ret, nr_sectors = bio_sectors(bio);
+	int ret = 1, nr_sectors = bio_sectors(bio);
 	dev_t old_dev;
 	int err = -EIO;
 
@@ -1508,7 +1508,10 @@ static inline void __generic_make_request(struct bio *bio)
 
 		trace_block_bio_queue(q, bio);
 
-		ret = q->make_request_fn(q, bio);
+		if (bio->bi_bdev->bd_cache_fn)
+			ret = bio->bi_bdev->bd_cache_fn(q, bio);
+		if (ret)
+			ret = q->make_request_fn(q, bio);
 	} while (ret);
 
 	return;
@@ -1516,6 +1519,7 @@ static inline void __generic_make_request(struct bio *bio)
 end_io:
 	bio_endio(bio, err);
 }
+EXPORT_SYMBOL_GPL(__generic_make_request);
 
 /*
  * We only want one ->make_request_fn to be active at a time,
diff --git a/fs/bio.c b/fs/bio.c
index e7bf6ca..d86764f 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -257,6 +257,7 @@ void bio_init(struct bio *bio)
 	bio->bi_flags = 1 << BIO_UPTODATE;
 	bio->bi_comp_cpu = -1;
 	atomic_set(&bio->bi_cnt, 1);
+	atomic_set(&bio->bi_remaining, 1);
 }
 EXPORT_SYMBOL(bio_init);
 
@@ -1422,16 +1423,41 @@ EXPORT_SYMBOL(bio_flush_dcache_pages);
  **/
 void bio_endio(struct bio *bio, int error)
 {
+	int old, new;
 	if (error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
+	if (error) {
+		do {
+			old = new = atomic_read(&bio->bi_remaining);
+			if (!(new >> 16))
+				new += -error << 16;
+
+		} while (atomic_cmpxchg(&bio->bi_remaining, old, --new) != old);
+	} else {
+		new = atomic_sub_return(1, &bio->bi_remaining);
+		error = -(new >> 16);
+	}
+
+	if (new & ~(~0 << 16))
+		return;
+	atomic_set(&bio->bi_remaining, 0);
+
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
 EXPORT_SYMBOL(bio_endio);
 
+void bio_split_endio(struct bio *bio, int error)
+{
+	struct bio *p = bio->bi_private;
+	bio_put(bio);
+	bio_endio(p, error);
+}
+EXPORT_SYMBOL(bio_split_endio);
+
 void bio_pair_release(struct bio_pair *bp)
 {
 	if (atomic_dec_and_test(&bp->cnt)) {
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7fc5606..d9c84da 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -94,6 +94,8 @@ struct bio {
 
 	struct bio_vec		*bi_io_vec;	/* the actual vec list */
 
+	atomic_t		bi_remaining;	/* split count */
+
 	bio_end_io_t		*bi_end_io;
 
 	void			*bi_private;
@@ -364,6 +366,7 @@ extern void bio_put(struct bio *);
 extern void bio_free(struct bio *, struct bio_set *);
 
 extern void bio_endio(struct bio *, int);
+extern void bio_split_endio(struct bio *bio, int error);
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 09a8402..8978c29 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -347,6 +347,7 @@ struct request_queue
 	make_request_fn		*make_request_fn;
 	prep_rq_fn		*prep_rq_fn;
 	unplug_fn		*unplug_fn;
+	unplug_fn		*cache_unplug_fn;
 	merge_bvec_fn		*merge_bvec_fn;
 	prepare_flush_fn	*prepare_flush_fn;
 	softirq_done_fn		*softirq_done_fn;
@@ -772,6 +773,7 @@ static inline void rq_flush_dcache_pages(struct request *rq)
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 extern void register_disk(struct gendisk *dev);
+extern void __generic_make_request(struct bio *bio);
 extern void generic_make_request(struct bio *bio);
 extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_put_request(struct request *);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 471e1ff..0c0a04e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -514,6 +514,8 @@ enum positive_aop_returns {
 struct page;
 struct address_space;
 struct writeback_control;
+struct bio;
+struct request_queue;
 
 struct iov_iter {
 	const struct iovec *iov;
@@ -665,6 +667,9 @@ struct block_device {
 	int			bd_invalidated;
 	struct gendisk *	bd_disk;
 	struct list_head	bd_list;
+
+	int (*bd_cache_fn)(struct request_queue *q, struct bio *bio);
+	char			bd_cache_identifier;
 	/*
 	 * Private data.  You must have bd_claim'ed the block_device
 	 * to use this.  NOTE:  bd_claim allows an owner to claim
