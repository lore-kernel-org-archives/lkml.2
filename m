Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab2JOQ7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:59:25 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49571 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2JOQ7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:59:22 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/3] tick: Consolidate timekeeping handling code
Date: Mon, 15 Oct 2012 18:59:12 +0200
Message-Id: <1350320354-17214-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1350320354-17214-1-git-send-email-fweisbec@gmail.com>
References: <1350320354-17214-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify the duplicated timekeeping handling code of low and high res tick
sched handlers.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/time/tick-sched.c |   54 ++++++++++++++++++++-------------------------
 1 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a402608..360674c 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -98,6 +98,28 @@ static ktime_t tick_init_jiffy_update(void)
 	return period;
 }
 
+
+static void tick_sched_do_timer(ktime_t now)
+{
+	int cpu = smp_processor_id();
+
+#ifdef CONFIG_NO_HZ
+	/*
+	 * Check if the do_timer duty was dropped. We don't care about
+	 * concurrency: This happens only when the cpu in charge went
+	 * into a long sleep. If two cpus happen to assign themself to
+	 * this duty, then the jiffies update is still serialized by
+	 * xtime_lock.
+	 */
+	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
+		tick_do_timer_cpu = cpu;
+#endif
+
+	/* Check, if the jiffies need an update */
+	if (tick_do_timer_cpu == cpu)
+		tick_do_update_jiffies64(now);
+}
+
 /*
  * NOHZ - aka dynamic tick functionality
  */
@@ -648,24 +670,11 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	struct pt_regs *regs = get_irq_regs();
-	int cpu = smp_processor_id();
 	ktime_t now = ktime_get();
 
 	dev->next_event.tv64 = KTIME_MAX;
 
-	/*
-	 * Check if the do_timer duty was dropped. We don't care about
-	 * concurrency: This happens only when the cpu in charge went
-	 * into a long sleep. If two cpus happen to assign themself to
-	 * this duty, then the jiffies update is still serialized by
-	 * xtime_lock.
-	 */
-	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
-		tick_do_timer_cpu = cpu;
-
-	/* Check, if the jiffies need an update */
-	if (tick_do_timer_cpu == cpu)
-		tick_do_update_jiffies64(now);
+	tick_sched_do_timer(now);
 
 	/*
 	 * When we are idle and the tick is stopped, we have to touch
@@ -802,23 +811,8 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 		container_of(timer, struct tick_sched, sched_timer);
 	struct pt_regs *regs = get_irq_regs();
 	ktime_t now = ktime_get();
-	int cpu = smp_processor_id();
 
-#ifdef CONFIG_NO_HZ
-	/*
-	 * Check if the do_timer duty was dropped. We don't care about
-	 * concurrency: This happens only when the cpu in charge went
-	 * into a long sleep. If two cpus happen to assign themself to
-	 * this duty, then the jiffies update is still serialized by
-	 * xtime_lock.
-	 */
-	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
-		tick_do_timer_cpu = cpu;
-#endif
-
-	/* Check, if the jiffies need an update */
-	if (tick_do_timer_cpu == cpu)
-		tick_do_update_jiffies64(now);
+	tick_sched_do_timer(now);
 
 	/*
 	 * Do not call, when we are not in irq context and have
-- 
1.7.5.4

