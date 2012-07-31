Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab2GaGPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:15:08 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34590 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab2GaGPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:15:07 -0400
From: Pekka Enberg <penberg@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH] sched: Document schedule() entry points
Date: Tue, 31 Jul 2012 09:15:00 +0300
Message-Id: <1343715300-6315-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a comment on top of the schedule() function to explain
to scheduler newbies how the main scheduler function is entered.

Explained-by: Ingo Molnar <mingo@kernel.org>
Explained-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 kernel/sched/core.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 468bdd4..9f31bbd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3361,6 +3361,40 @@ pick_next_task(struct rq *rq)
 
 /*
  * __schedule() is the main scheduler function.
+ *
+ * The main means of driving the scheduler and thus entering this function are:
+ *
+ *   1. Explicit blocking: mutex, semaphore, waitqueue, etc.
+ *
+ *   2. TIF_NEED_RESCHED flag is checked on interrupt and userspace return
+ *      paths. For example, see arch/x86/entry_64.S.
+ *
+ *      To drive preemption between tasks, the scheduler sets the flag is set
+ *      in timer interrupt handler scheduler_tick().
+ *
+ *   3. Wakeups don't really cause entry into schedule(). They add a
+ *      task to the run-queue and that's it.
+ *
+ *      Now, if the new task added to the run-queue preempts the current
+ *      task, then the wakeup sets TIF_NEED_RESCHED and schedule() gets
+ *      called on the nearest possible occasion:
+ *
+ *       - If the kernel is preemptible (CONFIG_PREEMPT=y):
+ *
+ *         - in syscall or exception context, at the next outmost
+ *           preempt_enable(). (this might be as soon as the wake_up()'s
+ *           spin_unlock()!)
+ *
+ *         - in IRQ context, return from interrupt-handler to
+ *           preemptible context
+ *
+ *       - If the kernel is not preemptible (CONFIG_PREEMPT is not set)
+ *         then at the next:
+ *
+ *          - cond_resched() call
+ *          - explicit schedule() call
+ *          - return from syscall or exception to user-space
+ *          - return from interrupt-handler to user-space
  */
 static void __sched __schedule(void)
 {
-- 
1.7.7.6

