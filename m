Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab2IXKFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:05:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59251 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753494Ab2IXKFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:05:16 -0400
X-IronPort-AV: E=Sophos;i="4.80,474,1344182400"; 
   d="scan'208";a="5907214"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 07/10] workqueue: simplify flush_workqueue_prep_cwqs()
Date: Mon, 24 Sep 2012 18:07:09 +0800
Message-Id: <1348481238-6138-8-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:28,
	Serialize complete at 2012/09/24 18:05:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the advance of wq->work_color into flush_workqueue_prep_cwqs()
and rename flush_workqueue_prep_cwqs() to workqueue_start_flush(),
It will simplify the caller.

Since the @flush_color and @work_color can't be -1, so we remove
the test in workqueue_start_flush() and fix the indent.

Since the @flush_color is always equals to wq->work_color(before advance),
so we remove the @flush_color argument. @flush_color becomes a
local variable.

Since the @work_color is always equals to work_next_color(flush_color),
so we remove the @work_color argument. @work_color is renamed to
@next_color and becomes a local variable

This patch doesn't make any functional difference.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   69 +++++++++++++++++++--------------------------------
 1 files changed, 26 insertions(+), 43 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 803a22c..be407e1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2531,40 +2531,37 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 }
 
 /**
- * flush_workqueue_prep_cwqs - prepare cwqs for workqueue flushing
+ * workqueue_start_flush - start workqueue flushing
  * @wq: workqueue being flushed
- * @flush_color: new flush color, < 0 for no-op
- * @work_color: new work color, < 0 for no-op
  *
- * Prepare cwqs for workqueue flushing.
+ * Start a new flush color and prepare cwqs for workqueue flushing.
  *
- * The caller should have initialized @wq->first_flusher prior to
- * calling this function with non-negative @flush_color.  If
- * @flush_color is negative, no flush color update is done and %false
- * is returned.
+ * Called with color space is not full.  The current work_color
+ * becomes new flush_color and work_color is advanced by one.
+ * All cwq's work_color are set to new work_color(advanced by one).
  *
- * If @work_color is non-negative, all cwqs should have the same
- * work_color which is previous to @work_color and all will be
- * advanced to @work_color.
+ * The caller should have initialized @wq->first_flusher prior to
+ * calling this function.
  *
  * CONTEXT:
  * mutex_lock(wq->flush_mutex).
  *
  * RETURNS:
- * %true if @flush_color >= 0 and there's something to flush.  %false
- * otherwise.
+ * %true if there's some cwqs to flush.  %false otherwise.
  */
-static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
-				      int flush_color, int work_color)
+static bool workqueue_start_flush(struct workqueue_struct *wq)
 {
+	int flush_color = wq->work_color;
+	int next_color = work_next_color(wq->work_color);
 	bool wait = false;
 	unsigned int cpu;
 
-	if (flush_color >= 0) {
-		BUG_ON(atomic_read(&wq->nr_cwqs_to_flush[flush_color]));
-		/* this ref is held by first flusher */
-		atomic_set(&wq->nr_cwqs_to_flush[flush_color], 1);
-	}
+	BUG_ON(next_color == wq->flush_color);
+	wq->work_color = next_color;
+
+	BUG_ON(atomic_read(&wq->nr_cwqs_to_flush[flush_color]));
+	/* this ref is held by first flusher */
+	atomic_set(&wq->nr_cwqs_to_flush[flush_color], 1);
 
 	for_each_cwq_cpu(cpu, wq) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
@@ -2572,17 +2569,13 @@ static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
 
 		spin_lock_irq(&gcwq->lock);
 
-		if (flush_color >= 0) {
-			if (cwq->nr_in_flight[flush_color]) {
-				atomic_inc(&wq->nr_cwqs_to_flush[flush_color]);
-				wait = true;
-			}
+		if (cwq->nr_in_flight[flush_color]) {
+			atomic_inc(&wq->nr_cwqs_to_flush[flush_color]);
+			wait = true;
 		}
 
-		if (work_color >= 0) {
-			BUG_ON(work_color != work_next_color(cwq->work_color));
-			cwq->work_color = work_color;
-		}
+		BUG_ON(next_color != work_next_color(cwq->work_color));
+		cwq->work_color = next_color;
 
 		spin_unlock_irq(&gcwq->lock);
 	}
@@ -2622,14 +2615,9 @@ void flush_workqueue(struct workqueue_struct *wq)
 	next_color = work_next_color(wq->work_color);
 
 	if (next_color != wq->flush_color) {
-		/*
-		 * Color space is not full.  The current work_color
-		 * becomes our flush_color and work_color is advanced
-		 * by one.
-		 */
+		/* Color space is not full */
 		BUG_ON(!list_empty(&wq->flusher_overflow));
 		this_flusher.flush_color = flush_color;
-		wq->work_color = next_color;
 
 		if (!wq->first_flusher) {
 			/* no flush in progress, become the first flusher */
@@ -2637,8 +2625,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 
 			wq->first_flusher = &this_flusher;
 
-			if (!flush_workqueue_prep_cwqs(wq, flush_color,
-						       wq->work_color)) {
+			if (!workqueue_start_flush(wq)) {
 				/* nothing to flush, done */
 				wq_dec_flusher_ref(wq, flush_color);
 				wq->flush_color = next_color;
@@ -2651,8 +2638,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 			/* wait in queue */
 			BUG_ON(wq->flush_color == this_flusher.flush_color);
 			list_add_tail(&this_flusher.list, &wq->flusher_queue);
-			flush_workqueue_prep_cwqs(wq, flush_color,
-						  wq->work_color);
+			workqueue_start_flush(wq);
 		}
 	} else {
 		/*
@@ -2707,12 +2693,9 @@ void flush_workqueue(struct workqueue_struct *wq)
 		list_for_each_entry(tmp, &wq->flusher_overflow, list)
 			tmp->flush_color = wq->work_color;
 
-		flush_color = wq->work_color;
-		wq->work_color = work_next_color(wq->work_color);
-
 		list_splice_tail_init(&wq->flusher_overflow,
 				      &wq->flusher_queue);
-		flush_workqueue_prep_cwqs(wq, flush_color, wq->work_color);
+		workqueue_start_flush(wq);
 	}
 
 	if (list_empty(&wq->flusher_queue)) {
-- 
1.7.4.4

