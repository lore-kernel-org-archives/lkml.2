Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2IXKGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:06:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59251 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab2IXKFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:05:15 -0400
X-IronPort-AV: E=Sophos;i="4.80,474,1344182400"; 
   d="scan'208";a="5907211"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 03/10] workqueue: remove while(true)
Date: Mon, 24 Sep 2012 18:07:05 +0800
Message-Id: <1348481238-6138-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:28,
	Serialize complete at 2012/09/24 18:05:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loop count is always=1, remove the "while(true)" and fix the indent.

This patch doesn't make any functional difference.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   86 +++++++++++++++++++++++++---------------------------
 1 files changed, 41 insertions(+), 45 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index acd9e2f..5439fb6 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2617,6 +2617,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 		.flush_color = -1,
 		.done = COMPLETION_INITIALIZER_ONSTACK(this_flusher.done),
 	};
+	struct wq_flusher *next, *tmp;
 	int next_color;
 
 	lock_map_acquire(&wq->lockdep_map);
@@ -2686,59 +2687,54 @@ void flush_workqueue(struct workqueue_struct *wq)
 	BUG_ON(!list_empty(&this_flusher.list));
 	BUG_ON(wq->flush_color != this_flusher.flush_color);
 
-	while (true) {
-		struct wq_flusher *next, *tmp;
-
-		/* complete all the flushers sharing the current flush color */
-		list_for_each_entry_safe(next, tmp, &wq->flusher_queue, list) {
-			if (next->flush_color != wq->flush_color)
-				break;
-			list_del_init(&next->list);
-			complete(&next->done);
-		}
+	/* complete all the flushers sharing the current flush color */
+	list_for_each_entry_safe(next, tmp, &wq->flusher_queue, list) {
+		if (next->flush_color != wq->flush_color)
+			break;
+		list_del_init(&next->list);
+		complete(&next->done);
+	}
 
-		BUG_ON(!list_empty(&wq->flusher_overflow) &&
-		       wq->flush_color != work_next_color(wq->work_color));
+	BUG_ON(!list_empty(&wq->flusher_overflow) &&
+	       wq->flush_color != work_next_color(wq->work_color));
 
-		/* this flush_color is finished, advance by one */
-		wq->flush_color = work_next_color(wq->flush_color);
+	/* this flush_color is finished, advance by one */
+	wq->flush_color = work_next_color(wq->flush_color);
 
-		/* one color has been freed, handle overflow queue */
-		if (!list_empty(&wq->flusher_overflow)) {
-			/*
-			 * Assign the same color to all overflowed
-			 * flushers, advance work_color and append to
-			 * flusher_queue.  This is the start-to-wait
-			 * phase for these overflowed flushers.
-			 */
-			list_for_each_entry(tmp, &wq->flusher_overflow, list)
-				tmp->flush_color = wq->work_color;
+	/* one color has been freed, handle overflow queue */
+	if (!list_empty(&wq->flusher_overflow)) {
+		/*
+		 * Assign the same color to all overflowed
+		 * flushers, advance work_color and append to
+		 * flusher_queue.  This is the start-to-wait
+		 * phase for these overflowed flushers.
+		 */
+		list_for_each_entry(tmp, &wq->flusher_overflow, list)
+			tmp->flush_color = wq->work_color;
 
-			wq->work_color = work_next_color(wq->work_color);
+		wq->work_color = work_next_color(wq->work_color);
 
-			list_splice_tail_init(&wq->flusher_overflow,
-					      &wq->flusher_queue);
-			flush_workqueue_prep_cwqs(wq, -1, wq->work_color);
-		}
+		list_splice_tail_init(&wq->flusher_overflow,
+				      &wq->flusher_queue);
+		flush_workqueue_prep_cwqs(wq, -1, wq->work_color);
+	}
 
-		if (list_empty(&wq->flusher_queue)) {
-			BUG_ON(wq->flush_color != wq->work_color);
-			wq->first_flusher = NULL;
-			break;
-		}
+	if (list_empty(&wq->flusher_queue)) {
+		BUG_ON(wq->flush_color != wq->work_color);
+		wq->first_flusher = NULL;
+		goto out_unlock;
+	}
 
-		/*
-		 * Need to flush more colors.  Make the next flusher
-		 * the new first flusher and arm cwqs.
-		 */
-		BUG_ON(wq->flush_color == wq->work_color);
-		BUG_ON(wq->flush_color != next->flush_color);
+	/*
+	 * Need to flush more colors.  Make the next flusher
+	 * the new first flusher and arm cwqs.
+	 */
+	BUG_ON(wq->flush_color == wq->work_color);
+	BUG_ON(wq->flush_color != next->flush_color);
 
-		list_del_init(&next->list);
-		wq->first_flusher = next;
-		flush_workqueue_prep_cwqs(wq, wq->flush_color, -1);
-		break;
-	}
+	list_del_init(&next->list);
+	wq->first_flusher = next;
+	flush_workqueue_prep_cwqs(wq, wq->flush_color, -1);
 
 out_unlock:
 	mutex_unlock(&wq->flush_mutex);
-- 
1.7.4.4

