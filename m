Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab0GCIqp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 04:46:45 -0400
Received: from sh.osrg.net ([192.16.179.4]:47300 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab0GCIqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 04:46:43 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: axboe@kernel.dk
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 4/9] osdblk: stop using q->prepare_flush_fn
Date: Sat,  3 Jul 2010 17:45:35 +0900
Message-Id: <1278146740-8731-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 03 Jul 2010 17:46:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use REQ_FLUSH flag instead.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/block/osdblk.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index 819002b..9639565 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -323,7 +323,7 @@ static void osdblk_rq_fn(struct request_queue *q)
 		 * driver-specific, etc.
 		 */
 
-		do_flush = (rq->special == (void *) 0xdeadbeefUL);
+		do_flush = rq->cmd_flags & REQ_FLUSH;
 		do_write = (rq_data_dir(rq) == WRITE);
 
 		if (!do_flush) { /* osd_flush does not use a bio */
@@ -380,14 +380,6 @@ static void osdblk_rq_fn(struct request_queue *q)
 	}
 }
 
-static void osdblk_prepare_flush(struct request_queue *q, struct request *rq)
-{
-	/* add driver-specific marker, to indicate that this request
-	 * is a flush command
-	 */
-	rq->special = (void *) 0xdeadbeefUL;
-}
-
 static void osdblk_free_disk(struct osdblk_device *osdev)
 {
 	struct gendisk *disk = osdev->disk;
@@ -447,7 +439,7 @@ static int osdblk_init_disk(struct osdblk_device *osdev)
 	blk_queue_stack_limits(q, osd_request_queue(osdev->osd));
 
 	blk_queue_prep_rq(q, blk_queue_start_tag);
-	blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH, osdblk_prepare_flush);
+	blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH, NULL);
 
 	disk->queue = q;
 
-- 
1.6.5

