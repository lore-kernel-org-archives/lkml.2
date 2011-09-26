Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127Ab1IZEnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 00:43:37 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35674 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab1IZEng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 00:43:36 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -for-next 1/2] block: introduce BIO_IN_FLIGHT flag
Date: Mon, 26 Sep 2011 13:43:29 +0900
Message-Id: <1317012210-4309-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BIO_IN_FLIGHT flag is used for tracing block I/O completion.
This patch fixes tracing bio-based devices - except DM which
inserts completion tracepoint explicitly - that could not be
traced such event using blktrace.

It won't affect tracing normal (request-based) disk devices
and nested bio handling paths.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 block/blk-core.c          |    5 +++++
 fs/bio.c                  |    9 +++++++++
 include/linux/blk_types.h |    1 +
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a99514191ce2..d8005ffc480d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -162,6 +162,9 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 	if (unlikely(rq->cmd_flags & REQ_QUIET))
 		set_bit(BIO_QUIET, &bio->bi_flags);
 
+	/* completion event was already reported in blk_update_request */
+	clear_bit(BIO_IN_FLIGHT, &bio->bi_flags);
+
 	bio->bi_size -= nbytes;
 	bio->bi_sector += (nbytes >> 9);
 
@@ -1571,6 +1574,8 @@ void generic_make_request(struct bio *bio)
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 
+		set_bit(BIO_IN_FLIGHT, &bio->bi_flags);
+
 		q->make_request_fn(q, bio);
 
 		bio = bio_list_pop(current->bio_list);
diff --git a/fs/bio.c b/fs/bio.c
index 9bfade8a609b..c510e93b6312 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1447,6 +1447,15 @@ void bio_endio(struct bio *bio, int error)
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
+	if (test_bit(BIO_IN_FLIGHT, &bio->bi_flags)) {
+		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+
+		trace_block_bio_complete(q, bio, error);
+
+		/* prevent duplicated completion event report */
+		clear_bit(BIO_IN_FLIGHT, &bio->bi_flags);
+	}
+
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 71fc53bb8f1c..146295babc98 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -98,6 +98,7 @@ struct bio {
 #define BIO_FS_INTEGRITY 10	/* fs owns integrity data, not block layer */
 #define BIO_QUIET	11	/* Make BIO Quiet */
 #define BIO_MAPPED_INTEGRITY 12/* integrity metadata has been remapped */
+#define BIO_IN_FLIGHT	13	/* report I/O completion event */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
-- 
1.7.6

