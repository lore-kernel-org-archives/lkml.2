Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab1CVWfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:35:32 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44897 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1CVWf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:35:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=vKGeoCk7fHaZc/gu/4cnO2+l42PJ7GW9U/SxovPC9hJPj+DWxXl5f+Y5lvYLlHKgw
	6pBLpyPEhDt3He5A+uxHA==
From: Justin TerAvest <teravest@google.com>
To: jaxboe@fusionio.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, Justin TerAvest <teravest@google.com>
Subject: [PATCH v2] cfq-iosched: Don't clear queue stats when preempt.
Date: Tue, 22 Mar 2011 15:35:18 -0700
Message-Id: <1300833318-1072-1-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For v2, I added back lines to cfq_preempt_queue() that were removed
during updates for accounting unaccounted_time. Thanks for pointing out
that I'd missed these, Vivek.

Previous commit "cfq-iosched: Don't set active queue in preempt" wrongly
cleared stats for preempting queues when it shouldn't have, because when
we choose a queue to preempt, it still isn't necessarily scheduled next.

Thanks to Vivek Goyal for figuring this out and understanding how the
preemption code works.

Signed-off-by: Justin TerAvest <teravest@google.com>
---
 block/cfq-iosched.c |   39 +++++++++++++++++----------------------
 1 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 69208d7..fea1b5a 100644
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
@@ -3339,7 +3333,8 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 
 	cfq_service_tree_add(cfqd, cfqq, 1);
 
-	cfq_clear_queue_stats(cfqd, cfqq);
+	cfqq->slice_end = 0;
+	cfq_mark_cfqq_slice_new(cfqq);
 }
 
 /*
-- 
1.7.3.1

