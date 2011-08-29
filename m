Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab1H2DuD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 23:50:03 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35432 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab1H2Dtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 23:49:50 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] block: introduce __bio_endio()
Date: Mon, 29 Aug 2011 12:47:36 +0900
Message-Id: <1314589660-2918-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314589660-2918-1-git-send-email-namhyung@gmail.com>
References: <1314589660-2918-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, bio_endio() lacks its completion tracepoint in it,
so that the bio-based devices - except DM which inserted the
tracepoint explicitly - cannot send us such an event when using
blktrace. Adding the tracepoint in the function will fix this.

However, bio_endio() is also used for other ways like some
nested bio-handling path and request-based devices. Simply
adding will result in duplicated event for those cases. Thus
add new __bio_endio() function to do things as before but no
tracepoint. Similarly, __bio_io_error() helper was added too.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 block/blk-core.c    |    4 ++--
 fs/bio.c            |   19 +++++++++++++++++++
 include/linux/bio.h |    2 ++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a60b46cc9da5..62b79692c7e8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -172,7 +172,7 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 
 	/* don't actually finish bio if it's part of flush sequence */
 	if (bio->bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ))
-		bio_endio(bio, error);
+		__bio_endio(bio, error);
 }
 
 void blk_dump_rq_flags(struct request *rq, char *msg)
@@ -1551,7 +1551,7 @@ static inline void __generic_make_request(struct bio *bio)
 	return;
 
 end_io:
-	bio_endio(bio, err);
+	__bio_endio(bio, err);
 }
 
 /*
diff --git a/fs/bio.c b/fs/bio.c
index 9bfade8a609b..9d7403f53efb 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1426,6 +1426,21 @@ void bio_flush_dcache_pages(struct bio *bi)
 EXPORT_SYMBOL(bio_flush_dcache_pages);
 #endif
 
+/*
+ * no-trace version of bio_endio().
+ */
+void __bio_endio(struct bio *bio, int error)
+{
+	if (error)
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+		error = -EIO;
+
+	if (bio->bi_end_io)
+		bio->bi_end_io(bio, error);
+}
+EXPORT_SYMBOL(__bio_endio);
+
 /**
  * bio_endio - end I/O on a bio
  * @bio:	bio
@@ -1442,11 +1457,15 @@ EXPORT_SYMBOL(bio_flush_dcache_pages);
  **/
 void bio_endio(struct bio *bio, int error)
 {
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+
 	if (error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
+	trace_block_bio_complete(q, bio, error);
+
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ce33e6868a2f..453a9bec49b8 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -132,6 +132,7 @@ static inline int bio_has_allocated_vec(struct bio *bio)
 #define BIO_SEG_BOUNDARY(q, b1, b2) \
 	BIOVEC_SEG_BOUNDARY((q), __BVEC_END((b1)), __BVEC_START((b2)))
 
+#define __bio_io_error(bio) __bio_endio((bio), -EIO)
 #define bio_io_error(bio) bio_endio((bio), -EIO)
 
 /*
@@ -217,6 +218,7 @@ extern struct bio *bio_alloc_bioset(gfp_t, int, struct bio_set *);
 extern void bio_put(struct bio *);
 extern void bio_free(struct bio *, struct bio_set *);
 
+extern void __bio_endio(struct bio *, int);
 extern void bio_endio(struct bio *, int);
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
-- 
1.7.6

