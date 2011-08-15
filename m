Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab1HOPxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:53:24 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51689 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab1HOPxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:20 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [PATCH 12/32] nohz: Try not to give the timekeeping duty to a cpuset nohz cpu
Date: Mon, 15 Aug 2011 17:52:09 +0200
Message-Id: <1313423549-27093-13-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to give the timekeeing duty to a CPU that doesn't belong
to any nohz cpuset when possible, so that we increase the chance
for these nohz cpusets to run their CPUs out of periodic tick
mode.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 kernel/time/tick-sched.c |   52 ++++++++++++++++++++++++++++++++++++---------
 1 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f5e12da..5f41ef7 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -20,6 +20,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/cpuset.h>
 
 #include <asm/irq_regs.h>
 
@@ -729,6 +730,45 @@ void tick_check_idle(int cpu)
 	tick_check_nohz(cpu);
 }
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+
+/*
+ * Take the timer duty if nobody is taking care of it.
+ * If a CPU already does and and it's in a nohz cpuset,
+ * then take the charge so that it can switch to nohz mode.
+ */
+static void tick_do_timer_check_handler(int cpu)
+{
+	int handler = tick_do_timer_cpu;
+
+	if (unlikely(handler == TICK_DO_TIMER_NONE)) {
+		tick_do_timer_cpu = cpu;
+	} else {
+		if (!cpuset_adaptive_nohz() &&
+		    cpuset_cpu_adaptive_nohz(handler))
+			tick_do_timer_cpu = cpu;
+	}
+}
+
+#else
+
+static void tick_do_timer_check_handler(int cpu)
+{
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
+}
+
+#endif /* CONFIG_CPUSETS_NO_HZ */
+
 /*
  * High resolution timer specific code
  */
@@ -745,17 +785,7 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	ktime_t now = ktime_get();
 	int cpu = smp_processor_id();
 
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
+	tick_do_timer_check_handler(cpu);
 
 	/* Check, if the jiffies need an update */
 	if (tick_do_timer_cpu == cpu)
-- 
1.7.5.4

