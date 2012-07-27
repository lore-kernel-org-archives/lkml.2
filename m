Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab2G0Xzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 19:55:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47011 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2G0Xzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 19:55:39 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org, peterz@infradead.org,
        mingo@redhat.com, davem@davemloft.net, dougthompson@xmission.com,
        ibm-acpi@hmh.eng.br, cbou@mail.ru, rui.zhang@intel.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/15] workqueue: reorganize try_to_grab_pending() and __cancel_timer_work()
Date: Fri, 27 Jul 2012 16:55:04 -0700
Message-Id: <1343433308-26614-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343433308-26614-1-git-send-email-tj@kernel.org>
References: <1343433308-26614-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move timer handling from __cancel_work_timer() to
  try_to_grab_pending().

* Make try_to_grab_pending() use -EAGAIN instead of -1 for
  busy-looping and drop the ret local variable.

* Add proper function comment to try_to_grab_pending().

This makes the code a bit easier to understand and will ease further
changes.  This patch doesn't make any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   36 +++++++++++++++++++++++++-----------
 1 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 358779c..a0eb033 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1004,15 +1004,29 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color,
 		complete(&cwq->wq->first_flusher->done);
 }
 
-/*
- * Upon a successful return (>= 0), the caller "owns" WORK_STRUCT_PENDING bit,
- * so this work can't be re-armed in any way.
+/**
+ * try_to_grab_pending - steal work item from worklist
+ * @work: work item to steal
+ *
+ * Try to grab PENDING bit of @work.  This function can handle @work in any
+ * stable state - idle, on timer or on worklist.  Return values are
+ *
+ *  1		if @work was pending and we successfully stole PENDING
+ *  0		if @work was idle and we claimed PENDING
+ *  -EAGAIN	if PENDING couldn't be grabbed at the moment, safe to busy-retry
+ *
+ * On >= 0 return, the caller owns @work's PENDING bit.
  */
-static int try_to_grab_pending(struct work_struct *work)
+static int try_to_grab_pending(struct work_struct *work,
+			       struct timer_list *timer)
 {
 	struct global_cwq *gcwq;
-	int ret = -1;
 
+	/* try to steal the timer if it exists */
+	if (timer && likely(del_timer(timer)))
+		return 1;
+
+	/* try to claim PENDING the normal way */
 	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work)))
 		return 0;
 
@@ -1022,7 +1036,7 @@ static int try_to_grab_pending(struct work_struct *work)
 	 */
 	gcwq = get_work_gcwq(work);
 	if (!gcwq)
-		return ret;
+		return -EAGAIN;
 
 	spin_lock_irq(&gcwq->lock);
 	if (!list_empty(&work->entry)) {
@@ -1038,12 +1052,14 @@ static int try_to_grab_pending(struct work_struct *work)
 			cwq_dec_nr_in_flight(get_work_cwq(work),
 				get_work_color(work),
 				*work_data_bits(work) & WORK_STRUCT_DELAYED);
-			ret = 1;
+
+			spin_unlock_irq(&gcwq->lock);
+			return 1;
 		}
 	}
 	spin_unlock_irq(&gcwq->lock);
 
-	return ret;
+	return -EAGAIN;
 }
 
 /**
@@ -2823,9 +2839,7 @@ static bool __cancel_work_timer(struct work_struct *work,
 	int ret;
 
 	do {
-		ret = (timer && likely(del_timer(timer)));
-		if (!ret)
-			ret = try_to_grab_pending(work);
+		ret = try_to_grab_pending(work, timer);
 		wait_on_work(work);
 	} while (unlikely(ret < 0));
 
-- 
1.7.7.3

