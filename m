Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab0GCIq6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 04:46:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:47320 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928Ab0GCIqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 04:46:54 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: axboe@kernel.dk
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH 6/9] dm: stop using q->prepare_flush_fn
Date: Sat,  3 Jul 2010 17:45:37 +0900
Message-Id: <1278146740-8731-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 03 Jul 2010 17:46:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use REQ_FLUSH flag instead.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d6f77ba..00c8105 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1455,20 +1455,9 @@ static int dm_request(struct request_queue *q, struct bio *bio)
 	return _dm_request(q, bio);
 }
 
-/*
- * Mark this request as flush request, so that dm_request_fn() can
- * recognize.
- */
-static void dm_rq_prepare_flush(struct request_queue *q, struct request *rq)
-{
-	rq->cmd_type = REQ_TYPE_LINUX_BLOCK;
-	rq->cmd[0] = REQ_LB_OP_FLUSH;
-}
-
 static bool dm_rq_is_flush_request(struct request *rq)
 {
-	if (rq->cmd_type == REQ_TYPE_LINUX_BLOCK &&
-	    rq->cmd[0] == REQ_LB_OP_FLUSH)
+	if (rq->cmd_flags & REQ_FLUSH)
 		return true;
 	else
 		return false;
@@ -1912,8 +1901,7 @@ static struct mapped_device *alloc_dev(int minor)
 	blk_queue_softirq_done(md->queue, dm_softirq_done);
 	blk_queue_prep_rq(md->queue, dm_prep_fn);
 	blk_queue_lld_busy(md->queue, dm_lld_busy);
-	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH,
-			  dm_rq_prepare_flush);
+	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH, NULL);
 
 	md->disk = alloc_disk(1);
 	if (!md->disk)
-- 
1.6.5

