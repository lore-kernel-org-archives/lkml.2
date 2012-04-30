Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab2EAADE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:03:04 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:51303 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757706Ab2EAADB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:03:01 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 08/41] nohz: Try not to give the timekeeping duty to an adaptive tickless cpu
Date: Tue,  1 May 2012 01:54:42 +0200
Message-Id: <1335830115-14335-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to give the timekeeing duty to a CPU that doesn't belong
to any nohz cpuset when possible, so that we increase the chance
for these nohz cpusets to run their CPUs out of periodic tick
mode.

[TODO: We need to find a way to ensure there is always one non-nohz
running CPU maintaining the timekeeping duty if every non-idle CPUs are
adaptive tickless]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c |   52 ++++++++++++++++++++++++++++++++++++---------
 1 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 0695e9d..f1142d5 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -20,6 +20,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/cpuset.h>
 
 #include <asm/irq_regs.h>
 
@@ -782,6 +783,45 @@ void tick_check_idle(int cpu)
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
@@ -798,17 +838,7 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
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

