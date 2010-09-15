Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0IOMdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 08:33:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45168 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab0IOMdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 08:33:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KgCWnioi7RaTUxXGf/ClgmJlE/sLcf4muh5KnjYAFH8bhh9mcBGrOChM7stP+ut5G6
         EqxH5p7cSa5SdPikXcpsq4fzYBzunmSeNkPb/shyI4NgPdMEhKwyx+/gL6qemLOMnWQT
         THGO0ZfiVMmR1jI3xgxUYhTUXb6jBnIQZz/7s=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: add assert_spin_locked() to ensure lock is held
Date: Wed, 15 Sep 2010 21:33:27 +0900
Message-Id: <1284554007-13077-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use assert_spin_locked() macro in order to ensure that queue_lock
must be held prior to calling some EXPORTed functions.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 block/blk-core.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 32a1c12..b849064 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -975,6 +975,8 @@ EXPORT_SYMBOL(blk_make_request);
  */
 void blk_requeue_request(struct request_queue *q, struct request *rq)
 {
+	assert_spin_locked(q->queue_lock);
+
 	blk_delete_timer(rq);
 	blk_clear_rq_complete(rq);
 	trace_block_rq_requeue(q, rq);
@@ -1098,6 +1100,8 @@ EXPORT_SYMBOL_GPL(part_round_stats);
  */
 void __blk_put_request(struct request_queue *q, struct request *req)
 {
+	assert_spin_locked(q->queue_lock);
+
 	if (unlikely(!q))
 		return;
 	if (unlikely(--req->ref_count))
@@ -1729,6 +1733,8 @@ unsigned int blk_rq_err_bytes(const struct request *rq)
 	unsigned int bytes = 0;
 	struct bio *bio;
 
+	assert_spin_locked(rq->q->queue_lock);
+
 	if (!(rq->cmd_flags & REQ_MIXED_MERGE))
 		return blk_rq_bytes(rq);
 
@@ -1811,6 +1817,8 @@ struct request *blk_peek_request(struct request_queue *q)
 	struct request *rq;
 	int ret;
 
+	assert_spin_locked(q->queue_lock);
+
 	while ((rq = __elv_next_request(q)) != NULL) {
 		if (!(rq->cmd_flags & REQ_STARTED)) {
 			/*
@@ -1926,6 +1934,8 @@ void blk_dequeue_request(struct request *rq)
  */
 void blk_start_request(struct request *req)
 {
+	assert_spin_locked(req->q->queue_lock);
+
 	blk_dequeue_request(req);
 
 	/*
@@ -1959,6 +1969,8 @@ struct request *blk_fetch_request(struct request_queue *q)
 {
 	struct request *rq;
 
+	assert_spin_locked(q->queue_lock);
+
 	rq = blk_peek_request(q);
 	if (rq)
 		blk_start_request(rq);
-- 
1.7.2.2

