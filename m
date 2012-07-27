Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab2G0Xzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 19:55:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47011 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2G0Xzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 19:55:43 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org, peterz@infradead.org,
        mingo@redhat.com, davem@davemloft.net, dougthompson@xmission.com,
        ibm-acpi@hmh.eng.br, cbou@mail.ru, rui.zhang@intel.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/15] workqueue: implement mod_delayed_work[_on]()
Date: Fri, 27 Jul 2012 16:55:06 -0700
Message-Id: <1343433308-26614-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343433308-26614-1-git-send-email-tj@kernel.org>
References: <1343433308-26614-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueue was lacking a mechanism to modify the timeout of an already
pending delayed_work.  delayed_work users have been working around
this using several methods - using an explicit timer + work item,
messing directly with delayed_work->timer, and canceling before
re-queueing, all of which are error-prone and/or ugly.

This patch implements mod_delayed_work[_on]() which behaves similarly
to mod_timer() - if the delayed_work is idle, it's queued with the
given delay; otherwise, its timeout is modified to the new value.
Zero @delay guarantees immediate execution.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
 include/linux/workqueue.h |    4 +++
 kernel/workqueue.c        |   51 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 5f4aeaa..2000030 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -390,6 +390,10 @@ extern bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
 extern bool queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
+extern bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
+			struct delayed_work *dwork, unsigned long delay);
+extern bool mod_delayed_work(struct workqueue_struct *wq,
+			struct delayed_work *dwork, unsigned long delay);
 
 extern void flush_workqueue(struct workqueue_struct *wq);
 extern void drain_workqueue(struct workqueue_struct *wq);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c90f00e..3839203 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1399,6 +1399,57 @@ bool queue_delayed_work(struct workqueue_struct *wq,
 EXPORT_SYMBOL_GPL(queue_delayed_work);
 
 /**
+ * mod_delayed_work_on - modify delay of or queue a delayed work on specific CPU
+ * @cpu: CPU number to execute work on
+ * @wq: workqueue to use
+ * @dwork: work to queue
+ * @delay: number of jiffies to wait before queueing
+ *
+ * If @dwork is idle, equivalent to queue_delayed_work_on(); otherwise,
+ * modify @dwork's timer so that it expires after @delay.  If @delay is
+ * zero, @work is guaranteed to be scheduled immediately regardless of its
+ * current state.
+ *
+ * Returns %false if @dwork was idle and queued, %true if @dwork was
+ * pending and its timer was modified.
+ */
+bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
+			 struct delayed_work *dwork, unsigned long delay)
+{
+	int ret;
+
+	preempt_disable();
+
+	do {
+		ret = try_to_grab_pending(&dwork->work, &dwork->timer);
+	} while (unlikely(ret == -EAGAIN));
+
+	if (likely(ret >= 0))
+		__queue_delayed_work(cpu, wq, dwork, delay);
+
+	preempt_enable();
+
+	/* -ENOENT from try_to_grab_pending() becomes %true */
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mod_delayed_work_on);
+
+/**
+ * mod_delayed_work - modify delay of or queue a delayed work
+ * @wq: workqueue to use
+ * @dwork: work to queue
+ * @delay: number of jiffies to wait before queueing
+ *
+ * mod_delayed_work_on() on local CPU.
+ */
+bool mod_delayed_work(struct workqueue_struct *wq, struct delayed_work *dwork,
+		      unsigned long delay)
+{
+	return mod_delayed_work_on(WORK_CPU_UNBOUND, wq, dwork, delay);
+}
+EXPORT_SYMBOL_GPL(mod_delayed_work);
+
+/**
  * worker_enter_idle - enter idle state
  * @worker: worker which is entering idle state
  *
-- 
1.7.7.3

