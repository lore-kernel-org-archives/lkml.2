Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab1JUD4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 23:56:55 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37297 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab1JUD4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 23:56:52 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, jgarzik@pobox.com, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] block: fix drain_all condition in blk_drain_queue()
Date: Thu, 20 Oct 2011 20:56:39 -0700
Message-Id: <1319169400-15706-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319169400-15706-1-git-send-email-tj@kernel.org>
References: <1319169400-15706-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to drain all requests, blk_drain_queue() checked only
q->rq.count[]; however, this only tracks REQ_ALLOCED requests.  This
patch updates blk_drain_queue() such that it looks at all the counters
and queues so that request_queue is actually empty on completion.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index abf751c..53e36c6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -358,7 +358,8 @@ EXPORT_SYMBOL(blk_put_queue);
 void blk_drain_queue(struct request_queue *q, bool drain_all)
 {
 	while (true) {
-		int nr_rqs;
+		bool drain = false;
+		int i;
 
 		spin_lock_irq(q->queue_lock);
 
@@ -368,14 +369,25 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 
 		__blk_run_queue(q);
 
-		if (drain_all)
-			nr_rqs = q->rq.count[0] + q->rq.count[1];
-		else
-			nr_rqs = q->rq.elvpriv;
+		drain |= q->rq.elvpriv;
+
+		/*
+		 * Unfortunately, requests are queued at and tracked from
+		 * multiple places and there's no single counter which can
+		 * be drained.  Check all the queues and counters.
+		 */
+		if (drain_all) {
+			drain |= !list_empty(&q->queue_head);
+			for (i = 0; i < 2; i++) {
+				drain |= q->rq.count[i];
+				drain |= q->in_flight[i];
+				drain |= !list_empty(&q->flush_queue[i]);
+			}
+		}
 
 		spin_unlock_irq(q->queue_lock);
 
-		if (!nr_rqs)
+		if (!drain)
 			break;
 		msleep(10);
 	}
-- 
1.7.3.1

