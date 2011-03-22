Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab1CVURo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:17:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7389 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab1CVURn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:17:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=eQv7YAZ2ZjSnWPmRyxG4ycYoj9D67mIJ9SQtJ0cbgK+Ek9mjZwCl2pQ983HFl/9HS
	nKDlaTJsSn4X5qF356atQ==
From: Justin TerAvest <teravest@google.com>
To: vgoyal@redhat.com, jaxboe@fusionio.com
Cc: linux-kernel@vger.kernel.org, Justin TerAvest <teravest@google.com>
Subject: [PATCH 1/2] cfq-iosched: Don't set active queue in preempt
Date: Tue, 22 Mar 2011 13:17:29 -0700
Message-Id: <1300825050-11371-2-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1300825050-11371-1-git-send-email-teravest@google.com>
References: <1300825050-11371-1-git-send-email-teravest@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "Add unaccounted time to timeslice_used" changed the behavior of
cfq_preempt_queue to set cfqq active. Vivek pointed out that other
preemption rules might get involved, so we shouldn't manually set which
queue is active.

This cleans up the code to just clear the queue stats at preemption
time.

Signed-off-by: Justin TerAvest <teravest@google.com>
---
 block/cfq-iosched.c |   39 +++++++++++++++++++++++----------------
 1 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 12e380b..69208d7 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1620,27 +1620,33 @@ static inline void cfq_del_timer(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	cfq_blkiocg_update_idle_time_stats(&cfqq->cfqg->blkg);
 }
 
+static void cfq_clear_queue_stats(struct cfq_data *cfqd,
+				  struct cfq_queue *cfqq)
+{
+	cfq_blkiocg_update_avg_queue_size_stats(&cfqq->cfqg->blkg);
+	cfqq->slice_start = 0;
+	cfqq->dispatch_start = jiffies;
+	cfqq->allocated_slice = 0;
+	cfqq->slice_end = 0;
+	cfqq->slice_dispatch = 0;
+	cfqq->nr_sectors = 0;
+
+	cfq_clear_cfqq_wait_request(cfqq);
+	cfq_clear_cfqq_must_dispatch(cfqq);
+	cfq_clear_cfqq_must_alloc_slice(cfqq);
+	cfq_clear_cfqq_fifo_expire(cfqq);
+	cfq_mark_cfqq_slice_new(cfqq);
+
+	cfq_del_timer(cfqd, cfqq);
+}
+
 static void __cfq_set_active_queue(struct cfq_data *cfqd,
 				   struct cfq_queue *cfqq)
 {
 	if (cfqq) {
 		cfq_log_cfqq(cfqd, cfqq, "set_active wl_prio:%d wl_type:%d",
 				cfqd->serving_prio, cfqd->serving_type);
-		cfq_blkiocg_update_avg_queue_size_stats(&cfqq->cfqg->blkg);
-		cfqq->slice_start = 0;
-		cfqq->dispatch_start = jiffies;
-		cfqq->allocated_slice = 0;
-		cfqq->slice_end = 0;
-		cfqq->slice_dispatch = 0;
-		cfqq->nr_sectors = 0;
-
-		cfq_clear_cfqq_wait_request(cfqq);
-		cfq_clear_cfqq_must_dispatch(cfqq);
-		cfq_clear_cfqq_must_alloc_slice(cfqq);
-		cfq_clear_cfqq_fifo_expire(cfqq);
-		cfq_mark_cfqq_slice_new(cfqq);
-
-		cfq_del_timer(cfqd, cfqq);
+		cfq_clear_queue_stats(cfqd, cfqq);
 	}
 
 	cfqd->active_queue = cfqq;
@@ -3332,7 +3338,8 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	BUG_ON(!cfq_cfqq_on_rr(cfqq));
 
 	cfq_service_tree_add(cfqd, cfqq, 1);
-	__cfq_set_active_queue(cfqd, cfqq);
+
+	cfq_clear_queue_stats(cfqd, cfqq);
 }
 
 /*
-- 
1.7.3.1

