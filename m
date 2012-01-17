Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994Ab2AQBX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 20:23:27 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62587 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab2AQBX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 20:23:26 -0500
X-AuditID: 9c930179-b7b98ae000000791-74-4f14cd89c681
From: Namhyung Kim <namhyung.kim@lge.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/3] block: add missing block_bio_complete() tracepoint
Date: Tue, 17 Jan 2012 10:32:06 +0900
Message-Id: <1326763928-1972-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9.rc1.dirty
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The block_bio_complete() TP has been missed so long,
so that bio-based drivers haven't been able to trace
its IO behavior. Add it.

In some rare cases, such as loop_switch, @bio->bi_bdev
can be NULL. Thus convert it to TRACE_EVENT_CONDITION()
as Steven suggested.

>From now on, request-based drivers will also get
BLK_TA_COMPLETEs for all bio's in requests. This needs
to be handled in userland properly.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 fs/bio.c                     |    2 ++
 include/trace/events/block.h |    4 +++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index b1fe82cf88cf..14c03eaf384e 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1447,6 +1447,8 @@ void bio_endio(struct bio *bio, int error)
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
+	trace_block_bio_complete(bdev_get_queue(bio->bi_bdev), bio, error);
+
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 05c5e61f0a7c..96955f4828b3 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -213,12 +213,14 @@ TRACE_EVENT(block_bio_bounce,
  * This tracepoint indicates there is no further work to do on this
  * block IO operation @bio.
  */
-TRACE_EVENT(block_bio_complete,
+TRACE_EVENT_CONDITION(block_bio_complete,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio, int error),
 
 	TP_ARGS(q, bio, error),
 
+	TP_CONDITION(bio->bi_bdev != NULL),
+
 	TP_STRUCT__entry(
 		__field( dev_t,		dev		)
 		__field( sector_t,	sector		)
-- 
1.7.9.rc1.dirty

