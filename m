Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881Ab2HHQlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:41:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33735 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758837Ab2HHQlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:41:37 -0400
Date: Wed, 8 Aug 2012 09:41:32 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH wq/for-3.7] workqueue: fix CPU binding of
 flush_delayed_work[_sync]()
Message-ID: <20120808164132.GB2985@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8fcd63664f1185361d00be4fe2decc2b9da8330e Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 8 Aug 2012 09:38:42 -0700

delayed_work encodes the workqueue to use and the last CPU in
delayed_work->work.data while it's on timer.  The target CPU is
implicitly recorded as the CPU the timer is queued on and
delayed_work_timer_fn() queues delayed_work->work to the CPU it is
running on.

Unfortunately, this leaves flush_delayed_work[_sync]() no way to find
out which CPU the delayed_work was queued for when they try to
re-queue after killing the timer.  Currently, it chooses the local CPU
flush is running on.  This can unexpectedly move a delayed_work queued
on a specific CPU to another CPU and lead to subtle errors.

There isn't much point in trying to save several bytes in struct
delayed_work, which is already close to a hundred bytes on 64bit with
all debug options turned off.  This patch adds delayed_work->cpu to
remember the CPU it's queued for.

Note that if the timer is migrated during CPU down, the work item
could be queued to the downed global_cwq after this change.  As a
detached global_cwq behaves like an unbound one, this doesn't change
much for the delayed_work.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
While this is a fix, I don't think any current user is affected.  I'll
route this through wq/for-3.7.

Thanks.

 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |    7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 2000030..b14d5d5 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -102,6 +102,7 @@ struct work_struct {
 struct delayed_work {
 	struct work_struct work;
 	struct timer_list timer;
+	int cpu;
 };
 
 static inline struct delayed_work *to_delayed_work(struct work_struct *work)
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 41ae2c0..11723c5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1319,7 +1319,7 @@ void delayed_work_timer_fn(unsigned long __data)
 	struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
 
 	local_irq_disable();
-	__queue_work(WORK_CPU_UNBOUND, cwq->wq, &dwork->work);
+	__queue_work(dwork->cpu, cwq->wq, &dwork->work);
 	local_irq_enable();
 }
 EXPORT_SYMBOL_GPL(delayed_work_timer_fn);
@@ -1356,6 +1356,7 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 
 	set_work_cwq(work, get_cwq(lcpu, wq), 0);
 
+	dwork->cpu = cpu;
 	timer->expires = jiffies + delay;
 
 	if (unlikely(cpu != WORK_CPU_UNBOUND))
@@ -2997,7 +2998,7 @@ bool flush_delayed_work(struct delayed_work *dwork)
 {
 	local_irq_disable();
 	if (del_timer_sync(&dwork->timer))
-		__queue_work(WORK_CPU_UNBOUND,
+		__queue_work(dwork->cpu,
 			     get_work_cwq(&dwork->work)->wq, &dwork->work);
 	local_irq_enable();
 	return flush_work(&dwork->work);
@@ -3020,7 +3021,7 @@ bool flush_delayed_work_sync(struct delayed_work *dwork)
 {
 	local_irq_disable();
 	if (del_timer_sync(&dwork->timer))
-		__queue_work(WORK_CPU_UNBOUND,
+		__queue_work(dwork->cpu,
 			     get_work_cwq(&dwork->work)->wq, &dwork->work);
 	local_irq_enable();
 	return flush_work_sync(&dwork->work);
-- 
1.7.7.3

