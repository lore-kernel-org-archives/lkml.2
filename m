Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab1L2IUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 03:20:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:37387 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1L2IUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 03:20:04 -0500
Message-ID: <4EFC22B0.5080406@kernel.dk>
Date: Thu, 29 Dec 2011 09:20:00 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block IO patches for 3.2-rc
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A trivial patch and two bug fixes that should make it
into 3.2 final:

- Fix a regression introduced when shrinking the tag
  queue depth dynamically on a device using the block
  layer tagging.

- Fix a potential oops/crash on an edge merge case
  of CFQ cfqq queues.

- Trivial cleanup.

Please pull!


  git://git.kernel.dk/linux-block.git for-linus

Dan Williams (1):
      block: fix blk_queue_end_tag()

Shaohua Li (1):
      block, cfq: fix empty queue crash caused by request merge

majianpeng (1):
      block: re-use existing 'reading' variable instead of checking direction again

 block/blk-map.c     |    2 +-
 block/blk-tag.c     |   13 ++-----------
 block/cfq-iosched.c |   12 ++++++++++++
 3 files changed, 15 insertions(+), 12 deletions(-)


diff --git a/block/blk-map.c b/block/blk-map.c
index 164cd00..623e1cd 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -311,7 +311,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	if (rq_data_dir(rq) == WRITE)
+	if (!reading)
 		bio->bi_rw |= REQ_WRITE;
 
 	if (do_copy)
diff --git a/block/blk-tag.c b/block/blk-tag.c
index e74d6d1..4af6f5c 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -282,18 +282,9 @@ EXPORT_SYMBOL(blk_queue_resize_tags);
 void blk_queue_end_tag(struct request_queue *q, struct request *rq)
 {
 	struct blk_queue_tag *bqt = q->queue_tags;
-	int tag = rq->tag;
+	unsigned tag = rq->tag; /* negative tags invalid */
 
-	BUG_ON(tag == -1);
-
-	if (unlikely(tag >= bqt->max_depth)) {
-		/*
-		 * This can happen after tag depth has been reduced.
-		 * But tag shouldn't be larger than real_max_depth.
-		 */
-		WARN_ON(tag >= bqt->real_max_depth);
-		return;
-	}
+	BUG_ON(tag >= bqt->real_max_depth);
 
 	list_del_init(&rq->queuelist);
 	rq->cmd_flags &= ~REQ_QUEUED;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4c12869..3548705 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1655,6 +1655,8 @@ cfq_merged_requests(struct request_queue *q, struct request *rq,
 		    struct request *next)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
+	struct cfq_data *cfqd = q->elevator->elevator_data;
+
 	/*
 	 * reposition in fifo if next is older than rq
 	 */
@@ -1669,6 +1671,16 @@ cfq_merged_requests(struct request_queue *q, struct request *rq,
 	cfq_remove_request(next);
 	cfq_blkiocg_update_io_merged_stats(&(RQ_CFQG(rq))->blkg,
 					rq_data_dir(next), rq_is_sync(next));
+
+	cfqq = RQ_CFQQ(next);
+	/*
+	 * all requests of this queue are merged to other queues, delete it
+	 * from the service tree. If it's the active_queue,
+	 * cfq_dispatch_requests() will choose to expire it or do idle
+	 */
+	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list) &&
+	    cfqq != cfqd->active_queue)
+		cfq_del_cfqq_rr(cfqd, cfqq);
 }
 
 static int cfq_allow_merge(struct request_queue *q, struct request *rq,

-- 
Jens Axboe

