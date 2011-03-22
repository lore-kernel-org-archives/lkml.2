Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1CVWO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:14:26 -0400
Received: from smtp-out.google.com ([74.125.121.67]:38675 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab1CVWOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:14:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=mCbEE7NIwj7QixvVbay6BTQOk2iaaJFO9kPW1HlCl5KPNEaMt8onkbuZrwcJngLmq
	8pWXU+4S7EeWyJUpf8Ivg==
From: Justin TerAvest <teravest@google.com>
To: jaxboe@fusionio.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, Justin TerAvest <teravest@google.com>
Subject: [PATCH] cfq-iosched: Don't clear queue stats when preempt.
Date: Tue, 22 Mar 2011 15:14:12 -0700
Message-Id: <1300832052-404-1-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous commit "cfq-iosched: Don't set active queue in preempt" wrongly
cleared stats for preempting queues when it shouldn't have, because when
we choose a queue to preempt, it still isn't necessarily scheduled next.

Thanks to Vivek Goyal for figuring this out and understanding how the
preemption code works.

Signed-off-by: Justin TerAvest <teravest@google.com>
---
 block/cfq-iosched.c |   38 +++++++++++++++-----------------------
 1 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 69208d7..efa1f30 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1620,33 +1620,27 @@ static inline void cfq_del_timer(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	cfq_blkiocg_update_idle_time_stats(&cfqq->cfqg->blkg);
 }
 
-static void cfq_clear_queue_stats(struct cfq_data *cfqd,
-				  struct cfq_queue *cfqq)
-{
-	cfq_blkiocg_update_avg_queue_size_stats(&cfqq->cfqg->blkg);
-	cfqq->slice_start = 0;
-	cfqq->dispatch_start = jiffies;
-	cfqq->allocated_slice = 0;
-	cfqq->slice_end = 0;
-	cfqq->slice_dispatch = 0;
-	cfqq->nr_sectors = 0;
-
-	cfq_clear_cfqq_wait_request(cfqq);
-	cfq_clear_cfqq_must_dispatch(cfqq);
-	cfq_clear_cfqq_must_alloc_slice(cfqq);
-	cfq_clear_cfqq_fifo_expire(cfqq);
-	cfq_mark_cfqq_slice_new(cfqq);
-
-	cfq_del_timer(cfqd, cfqq);
-}
-
 static void __cfq_set_active_queue(struct cfq_data *cfqd,
 				   struct cfq_queue *cfqq)
 {
 	if (cfqq) {
 		cfq_log_cfqq(cfqd, cfqq, "set_active wl_prio:%d wl_type:%d",
 				cfqd->serving_prio, cfqd->serving_type);
-		cfq_clear_queue_stats(cfqd, cfqq);
+		cfq_blkiocg_update_avg_queue_size_stats(&cfqq->cfqg->blkg);
+		cfqq->slice_start = 0;
+		cfqq->dispatch_start = jiffies;
+		cfqq->allocated_slice = 0;
+		cfqq->slice_end = 0;
+		cfqq->slice_dispatch = 0;
+		cfqq->nr_sectors = 0;
+
+		cfq_clear_cfqq_wait_request(cfqq);
+		cfq_clear_cfqq_must_dispatch(cfqq);
+		cfq_clear_cfqq_must_alloc_slice(cfqq);
+		cfq_clear_cfqq_fifo_expire(cfqq);
+		cfq_mark_cfqq_slice_new(cfqq);
+
+		cfq_del_timer(cfqd, cfqq);
 	}
 
 	cfqd->active_queue = cfqq;
@@ -3338,8 +3332,6 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	BUG_ON(!cfq_cfqq_on_rr(cfqq));
 
 	cfq_service_tree_add(cfqd, cfqq, 1);
-
-	cfq_clear_queue_stats(cfqd, cfqq);
 }
 
 /*
-- 
1.7.3.1

