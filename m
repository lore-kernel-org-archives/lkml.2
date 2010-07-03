Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab0GCIqs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 04:46:48 -0400
Received: from sh.osrg.net ([192.16.179.4]:47309 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab0GCIqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 04:46:43 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: axboe@kernel.dk
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 2/9] block: permit PREFLUSH and POSTFLUSH without prepare_flush_fn
Date: Sat,  3 Jul 2010 17:45:33 +0900
Message-Id: <1278146740-8731-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 03 Jul 2010 17:46:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is preparation for removing q->prepare_flush_fn.

Temporarily, blk_queue_ordered() permits QUEUE_ORDERED_DO_PREFLUSH and
QUEUE_ORDERED_DO_POSTFLUSH without prepare_flush_fn.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-barrier.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index a348242..7ce0a32 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -25,12 +25,6 @@
 int blk_queue_ordered(struct request_queue *q, unsigned ordered,
 		      prepare_flush_fn *prepare_flush_fn)
 {
-	if (!prepare_flush_fn && (ordered & (QUEUE_ORDERED_DO_PREFLUSH |
-					     QUEUE_ORDERED_DO_POSTFLUSH))) {
-		printk(KERN_ERR "%s: prepare_flush_fn required\n", __func__);
-		return -EINVAL;
-	}
-
 	if (ordered != QUEUE_ORDERED_NONE &&
 	    ordered != QUEUE_ORDERED_DRAIN &&
 	    ordered != QUEUE_ORDERED_DRAIN_FLUSH &&
@@ -146,7 +140,8 @@ static void queue_flush(struct request_queue *q, unsigned which)
 	rq->cmd_flags = REQ_HARDBARRIER | REQ_FLUSH;
 	rq->rq_disk = q->bar_rq.rq_disk;
 	rq->end_io = end_io;
-	q->prepare_flush_fn(q, rq);
+	if (q->prepare_flush_fn)
+		q->prepare_flush_fn(q, rq);
 
 	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 }
-- 
1.6.5

