Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab2HCRq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:46:58 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34680 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab2HCRoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:44:18 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org, peterz@infradead.org,
        mingo@redhat.com, davem@davemloft.net, dougthompson@xmission.com,
        ibm-acpi@hmh.eng.br, cbou@mail.ru, rui.zhang@intel.com,
        tomi.valkeinen@ti.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/14] workqueue: unify local CPU queueing handling
Date: Fri,  3 Aug 2012 10:43:51 -0700
Message-Id: <1344015839-21800-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344015839-21800-1-git-send-email-tj@kernel.org>
References: <1344015839-21800-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Queueing functions have been using different methods to determine the
local CPU.

* queue_work() superflously uses get/put_cpu() to acquire and hold the
  local CPU across queue_work_on().

* delayed_work_timer_fn() uses smp_processor_id().

* queue_delayed_work() calls queue_delayed_work_on() with -1 @cpu
  which is interpreted as the local CPU.

* flush_delayed_work[_sync]() were using raw_smp_processor_id().

* __queue_work() interprets %WORK_CPU_UNBOUND as local CPU if the
  target workqueue is bound one but nobody uses this.

This patch converts all functions to uniformly use %WORK_CPU_UNBOUND
to indicate local CPU and use the local binding feature of
__queue_work().  unlikely() is dropped from %WORK_CPU_UNBOUND handling
in __queue_work().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5539238..ce60bb5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1003,7 +1003,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	if (!(wq->flags & WQ_UNBOUND)) {
 		struct global_cwq *last_gcwq;
 
-		if (unlikely(cpu == WORK_CPU_UNBOUND))
+		if (cpu == WORK_CPU_UNBOUND)
 			cpu = raw_smp_processor_id();
 
 		/*
@@ -1103,12 +1103,7 @@ EXPORT_SYMBOL_GPL(queue_work_on);
  */
 bool queue_work(struct workqueue_struct *wq, struct work_struct *work)
 {
-	bool ret;
-
-	ret = queue_work_on(get_cpu(), wq, work);
-	put_cpu();
-
-	return ret;
+	return queue_work_on(WORK_CPU_UNBOUND, wq, work);
 }
 EXPORT_SYMBOL_GPL(queue_work);
 
@@ -1118,7 +1113,7 @@ void delayed_work_timer_fn(unsigned long __data)
 	struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
 
 	local_irq_disable();
-	__queue_work(smp_processor_id(), cwq->wq, &dwork->work);
+	__queue_work(WORK_CPU_UNBOUND, cwq->wq, &dwork->work);
 	local_irq_enable();
 }
 EXPORT_SYMBOL_GPL(delayed_work_timer_fn);
@@ -1172,7 +1167,7 @@ bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 
 		timer->expires = jiffies + delay;
 
-		if (unlikely(cpu >= 0))
+		if (unlikely(cpu != WORK_CPU_UNBOUND))
 			add_timer_on(timer, cpu);
 		else
 			add_timer(timer);
@@ -1198,7 +1193,7 @@ bool queue_delayed_work(struct workqueue_struct *wq,
 	if (delay == 0)
 		return queue_work(wq, &dwork->work);
 
-	return queue_delayed_work_on(-1, wq, dwork, delay);
+	return queue_delayed_work_on(WORK_CPU_UNBOUND, wq, dwork, delay);
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work);
 
@@ -2868,7 +2863,7 @@ bool flush_delayed_work(struct delayed_work *dwork)
 {
 	local_irq_disable();
 	if (del_timer_sync(&dwork->timer))
-		__queue_work(raw_smp_processor_id(),
+		__queue_work(WORK_CPU_UNBOUND,
 			     get_work_cwq(&dwork->work)->wq, &dwork->work);
 	local_irq_enable();
 	return flush_work(&dwork->work);
@@ -2891,7 +2886,7 @@ bool flush_delayed_work_sync(struct delayed_work *dwork)
 {
 	local_irq_disable();
 	if (del_timer_sync(&dwork->timer))
-		__queue_work(raw_smp_processor_id(),
+		__queue_work(WORK_CPU_UNBOUND,
 			     get_work_cwq(&dwork->work)->wq, &dwork->work);
 	local_irq_enable();
 	return flush_work_sync(&dwork->work);
-- 
1.7.7.3

