Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab2IXKFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:05:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40596 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab2IXKFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:05:18 -0400
X-IronPort-AV: E=Sophos;i="4.80,474,1344182400"; 
   d="scan'208";a="5907215"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 08/10] workqueue: assign overflowed flushers's flush color when queued
Date: Mon, 24 Sep 2012 18:07:10 +0800
Message-Id: <1348481238-6138-9-git-send-email-laijs@cn.fujitsu.com>
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

wq->work_color is unchanged between overflowed flusher queued on
 ->flusher_overflow and requeued on ->flusher_queue.

So we can assign overflowed flushers's flush color when they are queued
on ->flusher_overflow.

This patch makes the flusher's flush color more clear:
	flusher's flush color is the work color of the WQ
	when flush_workqueue() starts.

Remove an unneeded loop.

This patch doesn't make any functional difference.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index be407e1..f687893 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2613,11 +2613,11 @@ void flush_workqueue(struct workqueue_struct *wq)
 	 */
 	flush_color = wq->work_color;
 	next_color = work_next_color(wq->work_color);
+	this_flusher.flush_color = flush_color;
 
 	if (next_color != wq->flush_color) {
 		/* Color space is not full */
 		BUG_ON(!list_empty(&wq->flusher_overflow));
-		this_flusher.flush_color = flush_color;
 
 		if (!wq->first_flusher) {
 			/* no flush in progress, become the first flusher */
@@ -2643,8 +2643,8 @@ void flush_workqueue(struct workqueue_struct *wq)
 	} else {
 		/*
 		 * Oops, color space is full, wait on overflow queue.
-		 * The next flush completion will assign us
-		 * flush_color and transfer to flusher_queue.
+		 * The next flush completion will start flush for us
+		 * with freed flush color and transfer us to flusher_queue.
 		 */
 		list_add_tail(&this_flusher.list, &wq->flusher_overflow);
 	}
@@ -2684,15 +2684,14 @@ void flush_workqueue(struct workqueue_struct *wq)
 
 	/* one color has been freed, handle overflow queue */
 	if (!list_empty(&wq->flusher_overflow)) {
+		BUG_ON(list_first_entry(&wq->flusher_overflow,
+					struct wq_flusher,
+					list)->flush_color
+		       != wq->work_color);
 		/*
-		 * Assign the same color to all overflowed
-		 * flushers, advance work_color and append to
-		 * flusher_queue.  This is the start-to-wait
-		 * phase for these overflowed flushers.
+		 * start flush with the freed color and append
+		 * overflowed flushers to the flusher_queue.
 		 */
-		list_for_each_entry(tmp, &wq->flusher_overflow, list)
-			tmp->flush_color = wq->work_color;
-
 		list_splice_tail_init(&wq->flusher_overflow,
 				      &wq->flusher_queue);
 		workqueue_start_flush(wq);
-- 
1.7.4.4

