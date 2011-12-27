Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab1L0O2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:28:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59823 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab1L0O2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:28:49 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] block: introduce BIO_IN_FLIGHT flag
Date: Tue, 27 Dec 2011 23:28:32 +0900
Message-Id: <1324996113-1837-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1324996113-1837-1-git-send-email-namhyung@gmail.com>
References: <1324996113-1837-1-git-send-email-namhyung@gmail.com>
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
 fs/bio.c                  |    7 +++++++
 include/linux/blk_types.h |    1 +
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1b4fd93af2c0..f61310323954 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -165,6 +165,9 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 	if (unlikely(rq->cmd_flags & REQ_QUIET))
 		set_bit(BIO_QUIET, &bio->bi_flags);
 
+	/* completion event was already reported in blk_update_request */
+	clear_bit(BIO_IN_FLIGHT, &bio->bi_flags);
+
 	bio->bi_size -= nbytes;
 	bio->bi_sector += (nbytes >> 9);
 
@@ -1662,6 +1665,8 @@ void generic_make_request(struct bio *bio)
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 
+		set_bit(BIO_IN_FLIGHT, &bio->bi_flags);
+
 		q->make_request_fn(q, bio);
 
 		bio = bio_list_pop(current->bio_list);
diff --git a/fs/bio.c b/fs/bio.c
index b1fe82cf88cf..10fb7a1d74ba 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1447,6 +1447,13 @@ void bio_endio(struct bio *bio, int error)
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
+	if (test_bit(BIO_IN_FLIGHT, &bio->bi_flags)) {
+		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+
+		trace_block_bio_complete(q, bio, error);
+		clear_bit(BIO_IN_FLIGHT, &bio->bi_flags);
+	}
+
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4053cbd4490e..0b9aecd40ac5 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -95,6 +95,7 @@ struct bio {
 #define BIO_FS_INTEGRITY 9	/* fs owns integrity data, not block layer */
 #define BIO_QUIET	10	/* Make BIO Quiet */
 #define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
+#define BIO_IN_FLIGHT	12	/* report I/O completion event */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
-- 
1.7.6

