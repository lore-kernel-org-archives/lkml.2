Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2IXKFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:05:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59251 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab2IXKFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:05:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,474,1344182400"; 
   d="scan'208";a="5907217"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 10/10] workqueue: remove wq->flush_color
Date: Mon, 24 Sep 2012 18:07:12 +0800
Message-Id: <1348481238-6138-11-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:29,
	Serialize complete at 2012/09/24 18:05:29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use wq->first_flusher->flush_color instead.

If current task is the first_flusher, we use @flush_color
or work_next_color(flush_color) directly.

This patch doesn't make any functional difference.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   52 ++++++++++++++++++++--------------------------------
 1 files changed, 20 insertions(+), 32 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d78fe08..e703659 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -248,7 +248,6 @@ struct workqueue_struct {
 
 	struct mutex		flush_mutex;	/* protects wq flushing */
 	int			work_color;	/* F: current work color */
-	int			flush_color;	/* F: current flush color */
 	atomic_t		nr_cwqs_to_flush[WORK_NR_COLORS];
 	struct wq_flusher	*first_flusher;	/* F: first flusher */
 	struct list_head	flusher_queue;	/* F: flush waiters */
@@ -2555,7 +2554,7 @@ static bool workqueue_start_flush(struct workqueue_struct *wq)
 	bool wait = false;
 	unsigned int cpu;
 
-	BUG_ON(next_color == wq->flush_color);
+	BUG_ON(next_color == wq->first_flusher->flush_color);
 	wq->work_color = next_color;
 
 	BUG_ON(atomic_read(&wq->nr_cwqs_to_flush[flush_color]));
@@ -2614,29 +2613,23 @@ void flush_workqueue(struct workqueue_struct *wq)
 	next_color = work_next_color(wq->work_color);
 	this_flusher.flush_color = flush_color;
 
-	if (next_color != wq->flush_color) {
-		/* Color space is not full */
-		if (!wq->first_flusher) {
-			/* no flush in progress, become the first flusher */
-			BUG_ON(wq->flush_color != flush_color);
-
-			wq->first_flusher = &this_flusher;
-
-			if (!workqueue_start_flush(wq)) {
-				/* nothing to flush, done */
-				wq_dec_flusher_ref(wq, flush_color);
-				wq->flush_color = next_color;
-				wq->first_flusher = NULL;
-				goto out_unlock;
-			}
+	if (!wq->first_flusher) {
+		/* no flush in progress, become the first flusher */
+		wq->first_flusher = &this_flusher;
 
+		if (!workqueue_start_flush(wq)) {
+			/* nothing to flush, done */
 			wq_dec_flusher_ref(wq, flush_color);
-		} else {
-			/* wait in queue */
-			BUG_ON(wq->flush_color == this_flusher.flush_color);
-			list_add_tail(&this_flusher.list, &wq->flusher_queue);
-			workqueue_start_flush(wq);
+			wq->first_flusher = NULL;
+			goto out_unlock;
 		}
+
+		wq_dec_flusher_ref(wq, flush_color);
+	} else if (next_color != wq->first_flusher->flush_color) {
+		/* Color space is not full, wait in queue */
+		BUG_ON(wq->first_flusher->flush_color == flush_color);
+		list_add_tail(&this_flusher.list, &wq->flusher_queue);
+		workqueue_start_flush(wq);
 	} else {
 		/*
 		 * Oops, color space is full, queue it without starting flush.
@@ -2663,21 +2656,17 @@ void flush_workqueue(struct workqueue_struct *wq)
 
 	BUG_ON(wq->first_flusher != &this_flusher);
 	BUG_ON(!list_empty(&this_flusher.list));
-	BUG_ON(wq->flush_color != this_flusher.flush_color);
 
 	/* complete all the flushers sharing the current flush color */
 	list_for_each_entry_safe(next, tmp, &wq->flusher_queue, list) {
-		if (next->flush_color != wq->flush_color)
+		if (next->flush_color != flush_color)
 			break;
 		list_del_init(&next->list);
 		complete(&next->done);
 	}
 
-	/* this flush_color is finished, advance by one */
-	wq->flush_color = work_next_color(wq->flush_color);
-
 	if (list_empty(&wq->flusher_queue)) {
-		BUG_ON(wq->flush_color != wq->work_color);
+		BUG_ON(work_next_color(flush_color) != wq->work_color);
 		wq->first_flusher = NULL;
 		goto out_unlock;
 	}
@@ -2686,9 +2675,6 @@ void flush_workqueue(struct workqueue_struct *wq)
 	 * Need to flush more colors.  Make the next flusher
 	 * the new first flusher and arm it.
 	 */
-	BUG_ON(wq->flush_color == wq->work_color);
-	BUG_ON(wq->flush_color != next->flush_color);
-
 	last = list_entry(wq->flusher_queue.prev, struct wq_flusher, list);
 	list_del_init(&next->list);
 	wq->first_flusher = next;
@@ -2698,9 +2684,11 @@ void flush_workqueue(struct workqueue_struct *wq)
 		workqueue_start_flush(wq);
 
 	BUG_ON(work_next_color(last->flush_color) != wq->work_color);
+	BUG_ON(work_next_color(flush_color) != next->flush_color);
+	BUG_ON(next->flush_color == wq->work_color);
 
 	/* arm new first flusher */
-	wq_dec_flusher_ref(wq, wq->flush_color);
+	wq_dec_flusher_ref(wq, next->flush_color);
 
 out_unlock:
 	mutex_unlock(&wq->flush_mutex);
-- 
1.7.4.4

