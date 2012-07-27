Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab2G0Xzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 19:55:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47011 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2G0Xzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 19:55:37 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org, peterz@infradead.org,
        mingo@redhat.com, davem@davemloft.net, dougthompson@xmission.com,
        ibm-acpi@hmh.eng.br, cbou@mail.ru, rui.zhang@intel.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/15] workqueue: factor out __queue_delayed_work() from queue_delayed_work_on()
Date: Fri, 27 Jul 2012 16:55:03 -0700
Message-Id: <1343433308-26614-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343433308-26614-1-git-send-email-tj@kernel.org>
References: <1343433308-26614-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to prepare for mod_delayed_work[_on]() and doesn't cause any
functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   74 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 58b42b2..358779c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1259,6 +1259,46 @@ void delayed_work_timer_fn(unsigned long __data)
 }
 EXPORT_SYMBOL_GPL(delayed_work_timer_fn);
 
+static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
+				struct delayed_work *dwork, unsigned long delay)
+{
+	struct timer_list *timer = &dwork->timer;
+	struct work_struct *work = &dwork->work;
+	unsigned int lcpu;
+
+	WARN_ON_ONCE(timer->function != delayed_work_timer_fn ||
+		     timer->data != (unsigned long)dwork);
+	BUG_ON(timer_pending(timer));
+	BUG_ON(!list_empty(&work->entry));
+
+	timer_stats_timer_set_start_info(&dwork->timer);
+
+	/*
+	 * This stores cwq for the moment, for the timer_fn.  Note that the
+	 * work's gcwq is preserved to allow reentrance detection for
+	 * delayed works.
+	 */
+	if (!(wq->flags & WQ_UNBOUND)) {
+		struct global_cwq *gcwq = get_work_gcwq(work);
+
+		if (gcwq && gcwq->cpu != WORK_CPU_UNBOUND)
+			lcpu = gcwq->cpu;
+		else
+			lcpu = raw_smp_processor_id();
+	} else {
+		lcpu = WORK_CPU_UNBOUND;
+	}
+
+	set_work_cwq(work, get_cwq(lcpu, wq), 0);
+
+	timer->expires = jiffies + delay;
+
+	if (unlikely(cpu != WORK_CPU_UNBOUND))
+		add_timer_on(timer, cpu);
+	else
+		add_timer(timer);
+}
+
 /**
  * queue_delayed_work_on - queue work on specific CPU after delay
  * @cpu: CPU number to execute work on
@@ -1273,7 +1313,6 @@ EXPORT_SYMBOL_GPL(delayed_work_timer_fn);
 bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			   struct delayed_work *dwork, unsigned long delay)
 {
-	struct timer_list *timer = &dwork->timer;
 	struct work_struct *work = &dwork->work;
 	bool ret = false;
 
@@ -1287,38 +1326,7 @@ bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	preempt_disable();
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
-		unsigned int lcpu;
-
-		WARN_ON_ONCE(timer->function != delayed_work_timer_fn ||
-			     timer->data != (unsigned long)dwork);
-		BUG_ON(timer_pending(timer));
-		BUG_ON(!list_empty(&work->entry));
-
-		timer_stats_timer_set_start_info(&dwork->timer);
-
-		/*
-		 * This stores cwq for the moment, for the timer_fn.
-		 * Note that the work's gcwq is preserved to allow
-		 * reentrance detection for delayed works.
-		 */
-		if (!(wq->flags & WQ_UNBOUND)) {
-			struct global_cwq *gcwq = get_work_gcwq(work);
-
-			if (gcwq && gcwq->cpu != WORK_CPU_UNBOUND)
-				lcpu = gcwq->cpu;
-			else
-				lcpu = raw_smp_processor_id();
-		} else
-			lcpu = WORK_CPU_UNBOUND;
-
-		set_work_cwq(work, get_cwq(lcpu, wq), 0);
-
-		timer->expires = jiffies + delay;
-
-		if (unlikely(cpu != WORK_CPU_UNBOUND))
-			add_timer_on(timer, cpu);
-		else
-			add_timer(timer);
+		__queue_delayed_work(cpu, wq, dwork, delay);
 		ret = true;
 	}
 
-- 
1.7.7.3

