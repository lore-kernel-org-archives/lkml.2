Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab2G0XzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 19:55:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47011 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab2G0XzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 19:55:18 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org, peterz@infradead.org,
        mingo@redhat.com, davem@davemloft.net, dougthompson@xmission.com,
        ibm-acpi@hmh.eng.br, cbou@mail.ru, rui.zhang@intel.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/15] workqueue: reorder queueing functions so that _on() variants are on top
Date: Fri, 27 Jul 2012 16:54:54 -0700
Message-Id: <1343433308-26614-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343433308-26614-1-git-send-email-tj@kernel.org>
References: <1343433308-26614-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, queue/schedule[_delayed]_work_on() are located below the
counterpart without the _on postifx even though the latter is usually
implemented using the former.  Swap them.

This is cleanup and doesn't cause any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   13 +++--
 kernel/workqueue.c        |  124 ++++++++++++++++++++++----------------------
 2 files changed, 69 insertions(+), 68 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index af15545..5970342 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -365,23 +365,24 @@ __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
-extern int queue_work(struct workqueue_struct *wq, struct work_struct *work);
 extern int queue_work_on(int cpu, struct workqueue_struct *wq,
 			struct work_struct *work);
-extern int queue_delayed_work(struct workqueue_struct *wq,
-			struct delayed_work *work, unsigned long delay);
+extern int queue_work(struct workqueue_struct *wq, struct work_struct *work);
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
+extern int queue_delayed_work(struct workqueue_struct *wq,
+			struct delayed_work *work, unsigned long delay);
 
 extern void flush_workqueue(struct workqueue_struct *wq);
 extern void drain_workqueue(struct workqueue_struct *wq);
 extern void flush_scheduled_work(void);
 
-extern int schedule_work(struct work_struct *work);
 extern int schedule_work_on(int cpu, struct work_struct *work);
-extern int schedule_delayed_work(struct delayed_work *work, unsigned long delay);
+extern int schedule_work(struct work_struct *work);
 extern int schedule_delayed_work_on(int cpu, struct delayed_work *work,
-					unsigned long delay);
+				    unsigned long delay);
+extern int schedule_delayed_work(struct delayed_work *work,
+				 unsigned long delay);
 extern int schedule_on_each_cpu(work_func_t func);
 extern int keventd_up(void);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 692d976..07d309e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1053,27 +1053,6 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 }
 
 /**
- * queue_work - queue work on a workqueue
- * @wq: workqueue to use
- * @work: work to queue
- *
- * Returns 0 if @work was already on a queue, non-zero otherwise.
- *
- * We queue the work to the CPU on which it was submitted, but if the CPU dies
- * it can be processed by another CPU.
- */
-int queue_work(struct workqueue_struct *wq, struct work_struct *work)
-{
-	int ret;
-
-	ret = queue_work_on(get_cpu(), wq, work);
-	put_cpu();
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(queue_work);
-
-/**
  * queue_work_on - queue work on specific cpu
  * @cpu: CPU number to execute work on
  * @wq: workqueue to use
@@ -1097,31 +1076,34 @@ queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(queue_work_on);
 
-static void delayed_work_timer_fn(unsigned long __data)
-{
-	struct delayed_work *dwork = (struct delayed_work *)__data;
-	struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
-
-	__queue_work(smp_processor_id(), cwq->wq, &dwork->work);
-}
-
 /**
- * queue_delayed_work - queue work on a workqueue after delay
+ * queue_work - queue work on a workqueue
  * @wq: workqueue to use
- * @dwork: delayable work to queue
- * @delay: number of jiffies to wait before queueing
+ * @work: work to queue
  *
  * Returns 0 if @work was already on a queue, non-zero otherwise.
+ *
+ * We queue the work to the CPU on which it was submitted, but if the CPU dies
+ * it can be processed by another CPU.
  */
-int queue_delayed_work(struct workqueue_struct *wq,
-			struct delayed_work *dwork, unsigned long delay)
+int queue_work(struct workqueue_struct *wq, struct work_struct *work)
 {
-	if (delay == 0)
-		return queue_work(wq, &dwork->work);
+	int ret;
 
-	return queue_delayed_work_on(-1, wq, dwork, delay);
+	ret = queue_work_on(get_cpu(), wq, work);
+	put_cpu();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(queue_work);
+
+static void delayed_work_timer_fn(unsigned long __data)
+{
+	struct delayed_work *dwork = (struct delayed_work *)__data;
+	struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
+
+	__queue_work(smp_processor_id(), cwq->wq, &dwork->work);
 }
-EXPORT_SYMBOL_GPL(queue_delayed_work);
 
 /**
  * queue_delayed_work_on - queue work on specific CPU after delay
@@ -1179,6 +1161,24 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
 /**
+ * queue_delayed_work - queue work on a workqueue after delay
+ * @wq: workqueue to use
+ * @dwork: delayable work to queue
+ * @delay: number of jiffies to wait before queueing
+ *
+ * Returns 0 if @work was already on a queue, non-zero otherwise.
+ */
+int queue_delayed_work(struct workqueue_struct *wq,
+			struct delayed_work *dwork, unsigned long delay)
+{
+	if (delay == 0)
+		return queue_work(wq, &dwork->work);
+
+	return queue_delayed_work_on(-1, wq, dwork, delay);
+}
+EXPORT_SYMBOL_GPL(queue_delayed_work);
+
+/**
  * worker_enter_idle - enter idle state
  * @worker: worker which is entering idle state
  *
@@ -2877,6 +2877,19 @@ bool cancel_delayed_work_sync(struct delayed_work *dwork)
 }
 EXPORT_SYMBOL(cancel_delayed_work_sync);
 
+/*
+ * schedule_work_on - put work task on a specific cpu
+ * @cpu: cpu to put the work task on
+ * @work: job to be done
+ *
+ * This puts a job on a specific cpu
+ */
+int schedule_work_on(int cpu, struct work_struct *work)
+{
+	return queue_work_on(cpu, system_wq, work);
+}
+EXPORT_SYMBOL(schedule_work_on);
+
 /**
  * schedule_work - put work task in global workqueue
  * @work: job to be done
@@ -2894,18 +2907,21 @@ int schedule_work(struct work_struct *work)
 }
 EXPORT_SYMBOL(schedule_work);
 
-/*
- * schedule_work_on - put work task on a specific cpu
- * @cpu: cpu to put the work task on
- * @work: job to be done
+/**
+ * schedule_delayed_work_on - queue work in global workqueue on CPU after delay
+ * @cpu: cpu to use
+ * @dwork: job to be done
+ * @delay: number of jiffies to wait
  *
- * This puts a job on a specific cpu
+ * After waiting for a given time this puts a job in the kernel-global
+ * workqueue on the specified CPU.
  */
-int schedule_work_on(int cpu, struct work_struct *work)
+int schedule_delayed_work_on(int cpu,
+			struct delayed_work *dwork, unsigned long delay)
 {
-	return queue_work_on(cpu, system_wq, work);
+	return queue_delayed_work_on(cpu, system_wq, dwork, delay);
 }
-EXPORT_SYMBOL(schedule_work_on);
+EXPORT_SYMBOL(schedule_delayed_work_on);
 
 /**
  * schedule_delayed_work - put work task in global workqueue after delay
@@ -2923,22 +2939,6 @@ int schedule_delayed_work(struct delayed_work *dwork,
 EXPORT_SYMBOL(schedule_delayed_work);
 
 /**
- * schedule_delayed_work_on - queue work in global workqueue on CPU after delay
- * @cpu: cpu to use
- * @dwork: job to be done
- * @delay: number of jiffies to wait
- *
- * After waiting for a given time this puts a job in the kernel-global
- * workqueue on the specified CPU.
- */
-int schedule_delayed_work_on(int cpu,
-			struct delayed_work *dwork, unsigned long delay)
-{
-	return queue_delayed_work_on(cpu, system_wq, dwork, delay);
-}
-EXPORT_SYMBOL(schedule_delayed_work_on);
-
-/**
  * schedule_on_each_cpu - execute a function synchronously on each online CPU
  * @func: the function to call
  *
-- 
1.7.7.3

