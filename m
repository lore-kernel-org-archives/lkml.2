Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab2G0X5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 19:57:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47011 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab2G0Xzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 19:55:31 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org, peterz@infradead.org,
        mingo@redhat.com, davem@davemloft.net, dougthompson@xmission.com,
        ibm-acpi@hmh.eng.br, cbou@mail.ru, rui.zhang@intel.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/15] workqueue: fix zero @delay handling of queue_delayed_work_on()
Date: Fri, 27 Jul 2012 16:55:00 -0700
Message-Id: <1343433308-26614-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343433308-26614-1-git-send-email-tj@kernel.org>
References: <1343433308-26614-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If @delay is zero and the dealyed_work is idle, queue_delayed_work()
queues it for immediate execution; however, queue_delayed_work_on()
lacks this logic and always goes through timer regardless of @delay.

This patch moves 0 @delay handling logic from queue_delayed_work() to
queue_delayed_work_on() so that both functions behave the same.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4beb9bf..e3383e8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1123,7 +1123,9 @@ EXPORT_SYMBOL_GPL(delayed_work_timer_fn);
  * @dwork: work to queue
  * @delay: number of jiffies to wait before queueing
  *
- * Returns %false if @work was already on a queue, %true otherwise.
+ * Returns %false if @work was already on a queue, %true otherwise.  If
+ * @delay is zero and @dwork is idle, it will be scheduled for immediate
+ * execution.
  */
 bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			   struct delayed_work *dwork, unsigned long delay)
@@ -1132,6 +1134,9 @@ bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	struct work_struct *work = &dwork->work;
 	bool ret = false;
 
+	if (!delay)
+		return queue_work_on(cpu, wq, &dwork->work);
+
 	/*
 	 * We shouldn't get preempted between claiming PENDING and adding
 	 * timer.  Read the comment in __queue_work() for details.
@@ -1185,14 +1190,11 @@ EXPORT_SYMBOL_GPL(queue_delayed_work_on);
  * @dwork: delayable work to queue
  * @delay: number of jiffies to wait before queueing
  *
- * Returns %false if @work was already on a queue, %true otherwise.
+ * Equivalent to queue_delayed_work_on() but tries to use the local CPU.
  */
 bool queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *dwork, unsigned long delay)
 {
-	if (delay == 0)
-		return queue_work(wq, &dwork->work);
-
 	return queue_delayed_work_on(WORK_CPU_UNBOUND, wq, dwork, delay);
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work);
-- 
1.7.7.3

