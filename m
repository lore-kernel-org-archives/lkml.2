Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab2AXSAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 13:00:30 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40264 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab2AXSAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 13:00:04 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3/3] timer: Fix bad idle check on irq entry
Date: Tue, 24 Jan 2012 18:59:44 +0100
Message-Id: <1327427984-23282-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327427984-23282-1-git-send-email-fweisbec@gmail.com>
References: <1327427984-23282-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idle_cpu() is called on irq entry to guess if
we need to call tick_check_idle(). This way we can
catch up with jiffies if the tick was stopped, stop
accounting idle time during the interrupt and maintain
the sched clock if it is unstable.

But if we are going to exit the idle loop to schedule
a new task (ie: if we have a task in the runqueue or a
remotely enqueued ttwu to perform), the idle_cpu() check
will return 0 such that we miss the call to tick_check_idle()
for all interrupts happening before we schedule the new task.

As a result these interrupts and the softirqs coming
along may deal with stale jiffies values, bad sched clock
values, and won't substract their time from the idle time
accounting.

Fix this with using is_idle_task() instead that strictly
checks that we are running the idle task, without caring
about the fact we are going to schedule a task soon.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Stultz <john.stultz@linaro.org>
---
 kernel/softirq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 4eb3a0f..5ace266 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -297,7 +297,7 @@ void irq_enter(void)
 	int cpu = smp_processor_id();
 
 	rcu_irq_enter();
-	if (idle_cpu(cpu) && !in_interrupt()) {
+	if (is_idle_task(current) && !in_interrupt()) {
 		/*
 		 * Prevent raise_softirq from needlessly waking up ksoftirqd
 		 * here, as softirq will be serviced on return from interrupt.
-- 
1.7.5.4

