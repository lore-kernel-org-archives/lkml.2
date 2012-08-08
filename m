Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab2HHVj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:39:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59235 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab2HHVib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:38:31 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org, davem@davemloft.net,
        tomi.valkeinen@ti.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/7] workqueue: use irqsafe timer for delayed_work
Date: Wed,  8 Aug 2012 14:37:59 -0700
Message-Id: <1344461882-10149-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344461882-10149-1-git-send-email-tj@kernel.org>
References: <1344461882-10149-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up to now, for delayed_works, try_to_grab_pending() couldn't be used
from IRQ handlers because IRQs may happen while
delayed_work_timer_fn() is in progress leading to indefinite -EAGAIN.

This patch makes delayed_work use the new TIMER_IRQSAFE flag for
delayed_work->timer.  This makes try_to_grab_pending() and thus
mod_delayed_work_on() safe to call from IRQ handlers.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    8 +++++---
 kernel/workqueue.c        |   20 +++++++++++---------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 83755f4..093968e 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -136,7 +136,8 @@ struct execute_work {
 #define __DELAYED_WORK_INITIALIZER(n, f, tflags) {			\
 	.work = __WORK_INITIALIZER((n).work, (f)),			\
 	.timer = __TIMER_INITIALIZER(delayed_work_timer_fn,		\
-			0, (unsigned long)&(n), (tflags)),		\
+				     0, (unsigned long)&(n),		\
+				     (tflags) | TIMER_IRQSAFE),		\
 	}
 
 #define DECLARE_WORK(n, f)						\
@@ -214,7 +215,8 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
 	do {								\
 		INIT_WORK(&(_work)->work, (_func));			\
 		__setup_timer(&(_work)->timer, delayed_work_timer_fn,	\
-			      (unsigned long)(_work), (_tflags));	\
+			      (unsigned long)(_work),			\
+			      (_tflags) | TIMER_IRQSAFE);		\
 	} while (0)
 
 #define __INIT_DELAYED_WORK_ONSTACK(_work, _func, _tflags)		\
@@ -223,7 +225,7 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
 		__setup_timer_on_stack(&(_work)->timer,			\
 				       delayed_work_timer_fn,		\
 				       (unsigned long)(_work),		\
-				       (_tflags));			\
+				       (_tflags) | TIMER_IRQSAFE);	\
 	} while (0)
 
 #define INIT_DELAYED_WORK(_work, _func)					\
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 11723c5..9087599 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1041,16 +1041,14 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color,
  *		for arbitrarily long
  *
  * On >= 0 return, the caller owns @work's PENDING bit.  To avoid getting
- * preempted while holding PENDING and @work off queue, preemption must be
- * disabled on entry.  This ensures that we don't return -EAGAIN while
- * another task is preempted in this function.
+ * interrupted while holding PENDING and @work off queue, irq must be
+ * disabled on entry.  This, combined with delayed_work->timer being
+ * irqsafe, ensures that we return -EAGAIN for finite short period of time.
  *
  * On successful return, >= 0, irq is disabled and the caller is
  * responsible for releasing it using local_irq_restore(*@flags).
  *
- * This function is safe to call from any context other than IRQ handler.
- * An IRQ handler may run on top of delayed_work_timer_fn() which can make
- * this function return -EAGAIN perpetually.
+ * This function is safe to call from any context including IRQ handler.
  */
 static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 			       unsigned long *flags)
@@ -1065,6 +1063,11 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 	if (is_dwork) {
 		struct delayed_work *dwork = to_delayed_work(work);
 
+		/*
+		 * dwork->timer is irqsafe.  If del_timer() fails, it's
+		 * guaranteed that the timer is not queued anywhere and not
+		 * running on the local CPU.
+		 */
 		if (likely(del_timer(&dwork->timer)))
 			return 1;
 	}
@@ -1318,9 +1321,8 @@ void delayed_work_timer_fn(unsigned long __data)
 	struct delayed_work *dwork = (struct delayed_work *)__data;
 	struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
 
-	local_irq_disable();
+	/* should have been called from irqsafe timer with irq already off */
 	__queue_work(dwork->cpu, cwq->wq, &dwork->work);
-	local_irq_enable();
 }
 EXPORT_SYMBOL_GPL(delayed_work_timer_fn);
 
@@ -1429,7 +1431,7 @@ EXPORT_SYMBOL_GPL(queue_delayed_work);
  * Returns %false if @dwork was idle and queued, %true if @dwork was
  * pending and its timer was modified.
  *
- * This function is safe to call from any context other than IRQ handler.
+ * This function is safe to call from any context including IRQ handler.
  * See try_to_grab_pending() for details.
  */
 bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
-- 
1.7.7.3

