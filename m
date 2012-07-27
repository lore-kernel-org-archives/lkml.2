Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab2G0X6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 19:58:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47011 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab2G0XzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 19:55:20 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org, peterz@infradead.org,
        mingo@redhat.com, davem@davemloft.net, dougthompson@xmission.com,
        ibm-acpi@hmh.eng.br, cbou@mail.ru, rui.zhang@intel.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/15] workqueue: make queueing functions return bool
Date: Fri, 27 Jul 2012 16:54:55 -0700
Message-Id: <1343433308-26614-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343433308-26614-1-git-send-email-tj@kernel.org>
References: <1343433308-26614-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All queueing functions return 1 on success, 0 if the work item was
already pending.  Update them to return bool instead.  This signifies
better that they don't return 0 / -errno.

This is cleanup and doesn't cause any functional difference.

While at it, fix comment opening for schedule_work_on().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   20 +++++++++---------
 kernel/workqueue.c        |   47 ++++++++++++++++++++++-----------------------
 2 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 5970342..278dc5d 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -365,24 +365,24 @@ __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
-extern int queue_work_on(int cpu, struct workqueue_struct *wq,
+extern bool queue_work_on(int cpu, struct workqueue_struct *wq,
 			struct work_struct *work);
-extern int queue_work(struct workqueue_struct *wq, struct work_struct *work);
-extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
+extern bool queue_work(struct workqueue_struct *wq, struct work_struct *work);
+extern bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
-extern int queue_delayed_work(struct workqueue_struct *wq,
+extern bool queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
 
 extern void flush_workqueue(struct workqueue_struct *wq);
 extern void drain_workqueue(struct workqueue_struct *wq);
 extern void flush_scheduled_work(void);
 
-extern int schedule_work_on(int cpu, struct work_struct *work);
-extern int schedule_work(struct work_struct *work);
-extern int schedule_delayed_work_on(int cpu, struct delayed_work *work,
-				    unsigned long delay);
-extern int schedule_delayed_work(struct delayed_work *work,
-				 unsigned long delay);
+extern bool schedule_work_on(int cpu, struct work_struct *work);
+extern bool schedule_work(struct work_struct *work);
+extern bool schedule_delayed_work_on(int cpu, struct delayed_work *work,
+				     unsigned long delay);
+extern bool schedule_delayed_work(struct delayed_work *work,
+				  unsigned long delay);
 extern int schedule_on_each_cpu(work_func_t func);
 extern int keventd_up(void);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 07d309e..70f95ab 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1058,19 +1058,19 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
  * @wq: workqueue to use
  * @work: work to queue
  *
- * Returns 0 if @work was already on a queue, non-zero otherwise.
+ * Returns %false if @work was already on a queue, %true otherwise.
  *
  * We queue the work to a specific CPU, the caller must ensure it
  * can't go away.
  */
-int
-queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
+bool queue_work_on(int cpu, struct workqueue_struct *wq,
+		   struct work_struct *work)
 {
-	int ret = 0;
+	bool ret = false;
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
 		__queue_work(cpu, wq, work);
-		ret = 1;
+		ret = true;
 	}
 	return ret;
 }
@@ -1081,14 +1081,14 @@ EXPORT_SYMBOL_GPL(queue_work_on);
  * @wq: workqueue to use
  * @work: work to queue
  *
- * Returns 0 if @work was already on a queue, non-zero otherwise.
+ * Returns %false if @work was already on a queue, %true otherwise.
  *
  * We queue the work to the CPU on which it was submitted, but if the CPU dies
  * it can be processed by another CPU.
  */
-int queue_work(struct workqueue_struct *wq, struct work_struct *work)
+bool queue_work(struct workqueue_struct *wq, struct work_struct *work)
 {
-	int ret;
+	bool ret;
 
 	ret = queue_work_on(get_cpu(), wq, work);
 	put_cpu();
@@ -1112,14 +1112,14 @@ static void delayed_work_timer_fn(unsigned long __data)
  * @dwork: work to queue
  * @delay: number of jiffies to wait before queueing
  *
- * Returns 0 if @work was already on a queue, non-zero otherwise.
+ * Returns %false if @work was already on a queue, %true otherwise.
  */
-int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
-			struct delayed_work *dwork, unsigned long delay)
+bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
+			   struct delayed_work *dwork, unsigned long delay)
 {
-	int ret = 0;
 	struct timer_list *timer = &dwork->timer;
 	struct work_struct *work = &dwork->work;
+	bool ret = false;
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
 		unsigned int lcpu;
@@ -1154,7 +1154,7 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			add_timer_on(timer, cpu);
 		else
 			add_timer(timer);
-		ret = 1;
+		ret = true;
 	}
 	return ret;
 }
@@ -1166,9 +1166,9 @@ EXPORT_SYMBOL_GPL(queue_delayed_work_on);
  * @dwork: delayable work to queue
  * @delay: number of jiffies to wait before queueing
  *
- * Returns 0 if @work was already on a queue, non-zero otherwise.
+ * Returns %false if @work was already on a queue, %true otherwise.
  */
-int queue_delayed_work(struct workqueue_struct *wq,
+bool queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *dwork, unsigned long delay)
 {
 	if (delay == 0)
@@ -2877,14 +2877,14 @@ bool cancel_delayed_work_sync(struct delayed_work *dwork)
 }
 EXPORT_SYMBOL(cancel_delayed_work_sync);
 
-/*
+/**
  * schedule_work_on - put work task on a specific cpu
  * @cpu: cpu to put the work task on
  * @work: job to be done
  *
  * This puts a job on a specific cpu
  */
-int schedule_work_on(int cpu, struct work_struct *work)
+bool schedule_work_on(int cpu, struct work_struct *work)
 {
 	return queue_work_on(cpu, system_wq, work);
 }
@@ -2894,14 +2894,14 @@ EXPORT_SYMBOL(schedule_work_on);
  * schedule_work - put work task in global workqueue
  * @work: job to be done
  *
- * Returns zero if @work was already on the kernel-global workqueue and
- * non-zero otherwise.
+ * Returns %false if @work was already on the kernel-global workqueue and
+ * %true otherwise.
  *
  * This puts a job in the kernel-global workqueue if it was not already
  * queued and leaves it in the same position on the kernel-global
  * workqueue otherwise.
  */
-int schedule_work(struct work_struct *work)
+bool schedule_work(struct work_struct *work)
 {
 	return queue_work(system_wq, work);
 }
@@ -2916,8 +2916,8 @@ EXPORT_SYMBOL(schedule_work);
  * After waiting for a given time this puts a job in the kernel-global
  * workqueue on the specified CPU.
  */
-int schedule_delayed_work_on(int cpu,
-			struct delayed_work *dwork, unsigned long delay)
+bool schedule_delayed_work_on(int cpu, struct delayed_work *dwork,
+			      unsigned long delay)
 {
 	return queue_delayed_work_on(cpu, system_wq, dwork, delay);
 }
@@ -2931,8 +2931,7 @@ EXPORT_SYMBOL(schedule_delayed_work_on);
  * After waiting for a given time this puts a job in the kernel-global
  * workqueue.
  */
-int schedule_delayed_work(struct delayed_work *dwork,
-					unsigned long delay)
+bool schedule_delayed_work(struct delayed_work *dwork, unsigned long delay)
 {
 	return queue_delayed_work(system_wq, dwork, delay);
 }
-- 
1.7.7.3

