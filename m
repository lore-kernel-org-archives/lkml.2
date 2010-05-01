Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab0EAANX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 20:13:23 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48285 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757546Ab0EAANU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 20:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XedAzwoJYPsrlDaPkDxUZXQ+TlViwj1EBpIE0Cl21CkF6BUwhjouS0agrl+E67SBe1
         DYKIqSfFNO/rTeVjiSBE1qrltrgGyLNqebGP7z4osrOjMBOWynA/15oamHIX+bqgl0TZ
         QWMip8Xn6g6SYAiMoTaGAylv0bGgKWHmZksG0=
Date: Fri, 30 Apr 2010 16:13:16 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Bcache: version 4
Message-ID: <20100501001315.GC31135@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to prevent a use/free race, bcache needs to know either when a
read has been queued or when it's been finished. Since we're called from
__generic_make_request, the recursion-to-iteration trick prevents us
from doing the former. But cache hits do no allocation in the fast path;
to decrement a bucket's reference count when the bio's been completed,
we'd have to save and replace bi_end_io, which means we'd be forced to
do an allocation per bio processed - greatly annoying.

The technically least bad solution I could come up with was to subvert
generic_make_request; I call __generic_make_request directly, and when
that returns a read's on the request queue, and it's my understanding
discard bios won't get reordered so we're in the clear.

I do feel rather dirty for writing it, but it's the best I've come up
with.  Stack usage obviously could be an issue, and right now it is -
but that's fixable, I just haven't yet decided what I'm going to do with
the one struct I am putting on the stack just yet. But the additional
stack usage should be only a couple pointers total, once I'm done.

The other callback I put in __generic_make_request seems to me something
that would be useful to make generic eventually - I can think of a few
things that'd be really useful to have and would need a callback right
there. But I'm of the opinion that that should wait until other users
exist.

The other main thing I did was implemented a generic mechanism for
completion of split bios; it seemed to me that getting that right (in
particular error handling) is subtle enough that there really ought to
be a clear mechanism.  It guarantees that however many times a bio is
split the completion callback is only called once, and if there was an
error it is returned; to split a bio, you just point bi_private at the
parent bio, increment the parent's remaining count, and set the
BIO_SPLIT flag on the new bio. I've a function that does and can split
an arbitrary number of sectors off an arbitrary bio (bio_split_front in
bcache.c);  once this code's been tested I'll look to see what else can
use it.

block device->bd_cache_identifier needs to die, just as soon as I figure
out how to pin a struct block device or a struct gendisk without being
the exclusive owner. Most of the block layer has been really easy to
follow, but that part is just terrifying and looks ancient.

 block/blk-core.c       |   10 +++++++---
 fs/bio.c               |   27 +++++++++++++++++++++++++--
 include/linux/bio.h    |    3 +++
 include/linux/blkdev.h |    1 +
 include/linux/fs.h     |    5 +++++
 5 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9fe174d..b48d2d5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1401,11 +1401,11 @@ static inline int bio_check_eod(struct bio *bio, unsigned int nr_sectors)
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
 
@@ -1478,7 +1478,10 @@ static inline void __generic_make_request(struct bio *bio)
 
 		trace_block_bio_queue(q, bio);
 
-		ret = q->make_request_fn(q, bio);
+		if (bio->bi_bdev->bd_cache_fn)
+			ret = bio->bi_bdev->bd_cache_fn(q, bio);
+		if (ret)
+			ret = q->make_request_fn(q, bio);
 	} while (ret);
 
 	return;
@@ -1486,6 +1489,7 @@ static inline void __generic_make_request(struct bio *bio)
 end_io:
 	bio_endio(bio, err);
 }
+EXPORT_SYMBOL_GPL(__generic_make_request);
 
 /*
  * We only want one ->make_request_fn to be active at a time,
diff --git a/fs/bio.c b/fs/bio.c
index e7bf6ca..397b60d 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -257,6 +257,7 @@ void bio_init(struct bio *bio)
 	bio->bi_flags = 1 << BIO_UPTODATE;
 	bio->bi_comp_cpu = -1;
 	atomic_set(&bio->bi_cnt, 1);
+	atomic_set(&bio->bi_remaining, 1);
 }
 EXPORT_SYMBOL(bio_init);
 
@@ -1422,13 +1423,35 @@ EXPORT_SYMBOL(bio_flush_dcache_pages);
  **/
 void bio_endio(struct bio *bio, int error)
 {
+	struct bio *p;
+	bio_end_io_t *f = NULL;
+	int r = atomic_sub_return(1, &bio->bi_remaining);
+	smp_mb__after_atomic_dec();
+
 	if (error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
-	if (bio->bi_end_io)
-		bio->bi_end_io(bio, error);
+	if (!error && r > 0)
+		return;
+
+	WARN(r < 0, "bio incorrectly initialized");
+
+	if (!test_bit(BIO_SPLIT, &bio->bi_flags)) {
+		if (r > 0)
+			xchg(&f, bio->bi_end_io);
+		else
+			f = bio->bi_end_io;
+
+		if (f)
+			f(bio, error);
+	} else {
+		p = bio->bi_private;
+		if (r <= 0)
+			bio_put(bio);
+		bio_endio(p, error);
+	}
 }
 EXPORT_SYMBOL(bio_endio);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7fc5606..ae17296 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -94,6 +94,8 @@ struct bio {
 
 	struct bio_vec		*bi_io_vec;	/* the actual vec list */
 
+	atomic_t		bi_remaining;	/* split count */
+
 	bio_end_io_t		*bi_end_io;
 
 	void			*bi_private;
@@ -126,6 +128,7 @@ struct bio {
 #define BIO_NULL_MAPPED 9	/* contains invalid user pages */
 #define BIO_FS_INTEGRITY 10	/* fs owns integrity data, not block layer */
 #define BIO_QUIET	11	/* Make BIO Quiet */
+#define BIO_SPLIT	12	/* bi_private points to parent bio */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6690e8b..0017cf7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -768,6 +768,7 @@ static inline void rq_flush_dcache_pages(struct request *rq)
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 extern void register_disk(struct gendisk *dev);
+extern void __generic_make_request(struct bio *bio);
 extern void generic_make_request(struct bio *bio);
 extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_put_request(struct request *);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 44f35ae..b4eb99b 100644
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
@@ -664,6 +666,9 @@ struct block_device {
 	int			bd_invalidated;
 	struct gendisk *	bd_disk;
 	struct list_head	bd_list;
+
+	int (*bd_cache_fn)(struct request_queue *q, struct bio *bio);
+	char			bd_cache_identifier;
 	/*
 	 * Private data.  You must have bd_claim'ed the block_device
 	 * to use this.  NOTE:  bd_claim allows an owner to claim
