Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab1GCN6s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 09:58:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61248 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab1GCN6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 09:58:42 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/7] fail_make_request: cleanup should_fail_request
Date: Sun,  3 Jul 2011 22:59:48 +0900
Message-Id: <1309701588-16588-8-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309701588-16588-1-git-send-email-akinobu.mita@gmail.com>
References: <1309701588-16588-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes should_fail_request() to more usable wrapper function of
should_fail(). It can avoid putting #ifdef CONFIG_FAIL_MAKE_REQUEST in
the middle of a function.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d2f8f40..f7c34f5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1357,14 +1357,9 @@ static int __init setup_fail_make_request(char *str)
 }
 __setup("fail_make_request=", setup_fail_make_request);
 
-static int should_fail_request(struct bio *bio)
+static bool should_fail_request(struct hd_struct *part, unsigned int bytes)
 {
-	struct hd_struct *part = bio->bi_bdev->bd_part;
-
-	if (part_to_disk(part)->part0.make_it_fail || part->make_it_fail)
-		return should_fail(&fail_make_request, bio->bi_size);
-
-	return 0;
+	return part->make_it_fail && should_fail(&fail_make_request, bytes);
 }
 
 static int __init fail_make_request_debugfs(void)
@@ -1377,9 +1372,10 @@ late_initcall(fail_make_request_debugfs);
 
 #else /* CONFIG_FAIL_MAKE_REQUEST */
 
-static inline int should_fail_request(struct bio *bio)
+static inline bool should_fail_request(struct hd_struct *part,
+					unsigned int bytes)
 {
-	return 0;
+	return false;
 }
 
 #endif /* CONFIG_FAIL_MAKE_REQUEST */
@@ -1462,6 +1458,7 @@ static inline void __generic_make_request(struct bio *bio)
 	old_dev = 0;
 	do {
 		char b[BDEVNAME_SIZE];
+		struct hd_struct *part;
 
 		q = bdev_get_queue(bio->bi_bdev);
 		if (unlikely(!q)) {
@@ -1485,7 +1482,10 @@ static inline void __generic_make_request(struct bio *bio)
 		if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
 			goto end_io;
 
-		if (should_fail_request(bio))
+		part = bio->bi_bdev->bd_part;
+		if (should_fail_request(part, bio->bi_size) ||
+		    should_fail_request(&part_to_disk(part)->part0,
+					bio->bi_size))
 			goto end_io;
 
 		/*
@@ -1700,11 +1700,9 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 	if (blk_rq_check_limits(q, rq))
 		return -EIO;
 
-#ifdef CONFIG_FAIL_MAKE_REQUEST
-	if (rq->rq_disk && rq->rq_disk->part0.make_it_fail &&
-	    should_fail(&fail_make_request, blk_rq_bytes(rq)))
+	if (rq->rq_disk &&
+	    should_fail_request(&rq->rq_disk->part0, blk_rq_bytes(rq)))
 		return -EIO;
-#endif
 
 	spin_lock_irqsave(q->queue_lock, flags);
 
-- 
1.7.4.4

