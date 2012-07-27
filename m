Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2G0Xze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 19:55:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47011 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab2G0Xz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 19:55:26 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org, peterz@infradead.org,
        mingo@redhat.com, davem@davemloft.net, dougthompson@xmission.com,
        ibm-acpi@hmh.eng.br, cbou@mail.ru, rui.zhang@intel.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/15] workqueue: set delayed_work->timer function on initialization
Date: Fri, 27 Jul 2012 16:54:58 -0700
Message-Id: <1343433308-26614-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343433308-26614-1-git-send-email-tj@kernel.org>
References: <1343433308-26614-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

delayed_work->timer.function is currently initialized during
queue_delayed_work_on().  Export delayed_work_timer_fn() and set
delayed_work timer function during delayed_work initialization
together with other fields.

This ensures the timer function is always valid on an initialized
delayed_work.  This is to help mod_delayed_work() implementation.

To detect delayed_work users which diddle with the internal timer,
trigger WARN if timer function doesn't match on queue.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   13 +++++++++++--
 kernel/workqueue.c        |    7 ++++---
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 278dc5d..ab95fef 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -16,6 +16,7 @@ struct workqueue_struct;
 
 struct work_struct;
 typedef void (*work_func_t)(struct work_struct *work);
+void delayed_work_timer_fn(unsigned long __data);
 
 /*
  * The first word is the work queue pointer and the flags rolled into
@@ -124,12 +125,14 @@ struct execute_work {
 
 #define __DELAYED_WORK_INITIALIZER(n, f) {			\
 	.work = __WORK_INITIALIZER((n).work, (f)),		\
-	.timer = TIMER_INITIALIZER(NULL, 0, 0),			\
+	.timer = TIMER_INITIALIZER(delayed_work_timer_fn,	\
+				0, (unsigned long)&(n)),	\
 	}
 
 #define __DEFERRED_WORK_INITIALIZER(n, f) {			\
 	.work = __WORK_INITIALIZER((n).work, (f)),		\
-	.timer = TIMER_DEFERRED_INITIALIZER(NULL, 0, 0),	\
+	.timer = TIMER_DEFERRED_INITIALIZER(delayed_work_timer_fn, \
+				0, (unsigned long)&(n)),	\
 	}
 
 #define DECLARE_WORK(n, f)					\
@@ -207,18 +210,24 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
 	do {							\
 		INIT_WORK(&(_work)->work, (_func));		\
 		init_timer(&(_work)->timer);			\
+		(_work)->timer.function = delayed_work_timer_fn;\
+		(_work)->timer.data = (unsigned long)(_work);	\
 	} while (0)
 
 #define INIT_DELAYED_WORK_ONSTACK(_work, _func)			\
 	do {							\
 		INIT_WORK_ONSTACK(&(_work)->work, (_func));	\
 		init_timer_on_stack(&(_work)->timer);		\
+		(_work)->timer.function = delayed_work_timer_fn;\
+		(_work)->timer.data = (unsigned long)(_work);	\
 	} while (0)
 
 #define INIT_DELAYED_WORK_DEFERRABLE(_work, _func)		\
 	do {							\
 		INIT_WORK(&(_work)->work, (_func));		\
 		init_timer_deferrable(&(_work)->timer);		\
+		(_work)->timer.function = delayed_work_timer_fn;\
+		(_work)->timer.data = (unsigned long)(_work);	\
 	} while (0)
 
 /**
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 147869a..db8098b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1112,13 +1112,14 @@ bool queue_work(struct workqueue_struct *wq, struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(queue_work);
 
-static void delayed_work_timer_fn(unsigned long __data)
+void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
 	struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
 
 	__queue_work(smp_processor_id(), cwq->wq, &dwork->work);
 }
+EXPORT_SYMBOL_GPL(delayed_work_timer_fn);
 
 /**
  * queue_delayed_work_on - queue work on specific CPU after delay
@@ -1145,6 +1146,8 @@ bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
 		unsigned int lcpu;
 
+		WARN_ON_ONCE(timer->function != delayed_work_timer_fn ||
+			     timer->data != (unsigned long)dwork);
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));
 
@@ -1168,8 +1171,6 @@ bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 		set_work_cwq(work, get_cwq(lcpu, wq), 0);
 
 		timer->expires = jiffies + delay;
-		timer->data = (unsigned long)dwork;
-		timer->function = delayed_work_timer_fn;
 
 		if (unlikely(cpu >= 0))
 			add_timer_on(timer, cpu);
-- 
1.7.7.3

