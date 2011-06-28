Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab1F1I5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 04:57:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59701 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab1F1Iz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 04:55:29 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH/RFC] block: add blktrace complete tracepoint in bio_endio()
Date: Tue, 28 Jun 2011 17:55:22 +0900
Message-Id: <1309251322-9821-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently bio-based drivers lack blktrace's completion notification
because the notification will be sent only in request completion path
(blk_update_request) and they never use requests.

This patch adds bio completion tracepoint in bio_endio() so that bio-
based drivers can be tracked. Also introduce __bio_endio() which keeps
original behavior (w/o trace) to be called from the request completion
path and error path of generic_make_request(). It should not affect
normal request-based drivers.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 block/blk-core.c |    6 ++++--
 fs/bio.c         |   18 ++++++++++++++++++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d2f8f4049abd..69d66ea6f083 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -147,6 +147,8 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 }
 EXPORT_SYMBOL(blk_rq_init);
 
+extern void __bio_endio(struct bio *bio, int error);
+
 static void req_bio_endio(struct request *rq, struct bio *bio,
 			  unsigned int nbytes, int error)
 {
@@ -172,7 +174,7 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 
 	/* don't actually finish bio if it's part of flush sequence */
 	if (bio->bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ))
-		bio_endio(bio, error);
+		__bio_endio(bio, error);
 }
 
 void blk_dump_rq_flags(struct request *rq, char *msg)
@@ -1545,7 +1547,7 @@ static inline void __generic_make_request(struct bio *bio)
 	return;
 
 end_io:
-	bio_endio(bio, err);
+	__bio_endio(bio, err);
 }
 
 /*
diff --git a/fs/bio.c b/fs/bio.c
index 9bfade8a609b..6a0346f8bd69 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1426,6 +1426,20 @@ void bio_flush_dcache_pages(struct bio *bi)
 EXPORT_SYMBOL(bio_flush_dcache_pages);
 #endif
 
+/*
+ * Same as bio_endio() below but no trace.
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
+
 /**
  * bio_endio - end I/O on a bio
  * @bio:	bio
@@ -1442,11 +1456,15 @@ EXPORT_SYMBOL(bio_flush_dcache_pages);
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
-- 
1.7.6

