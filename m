Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab2EAACF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:02:05 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:37990 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617Ab2EAAB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:01:59 -0400
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
Subject: [PATCH 12/41] nohz/cpuset: Wake up adaptive nohz CPU when a timer gets enqueued
Date: Tue,  1 May 2012 01:54:46 +0200
Message-Id: <1335830115-14335-13-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wake up a CPU when a timer list timer is enqueued there and
the CPU is in adaptive nohz mode. Sending an IPI to it makes
it reconsidering the next timer to program on top of recent
updates.

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
 include/linux/sched.h |    4 ++--
 kernel/sched/core.c   |   24 +++++++++++++++++++++++-
 kernel/timer.c        |    2 +-
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index dd5df2a..2cf5d9b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1992,9 +1992,9 @@ static inline void idle_task_exit(void) {}
 #endif
 
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
-extern void wake_up_idle_cpu(int cpu);
+extern void wake_up_nohz_cpu(int cpu);
 #else
-static inline void wake_up_idle_cpu(int cpu) { }
+static inline void wake_up_nohz_cpu(int cpu) { }
 #endif
 
 extern unsigned int sysctl_sched_latency;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4f80a81..ba9e4d4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -576,7 +576,7 @@ unlock:
  * account when the CPU goes back to idle and evaluates the timer
  * wheel for the next timer event.
  */
-void wake_up_idle_cpu(int cpu)
+static void wake_up_idle_cpu(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 
@@ -606,6 +606,28 @@ void wake_up_idle_cpu(int cpu)
 		smp_send_reschedule(cpu);
 }
 
+static bool wake_up_cpuset_nohz_cpu(int cpu)
+{
+#ifdef CONFIG_CPUSETS_NO_HZ
+	/*
+	 * FIXME: We need to ensure that updates
+	 * on cpu_adaptive_nohz_ref are visible right
+	 * away.
+	 */
+	if (cpuset_cpu_adaptive_nohz(cpu)) {
+		smp_cpuset_update_nohz(cpu);
+		return true;
+	}
+#endif
+	return false;
+}
+
+void wake_up_nohz_cpu(int cpu)
+{
+	if (!wake_up_cpuset_nohz_cpu(cpu))
+		wake_up_idle_cpu(cpu);
+}
+
 static inline bool got_nohz_idle_kick(void)
 {
 	int cpu = smp_processor_id();
diff --git a/kernel/timer.c b/kernel/timer.c
index a297ffc..c203297 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -926,7 +926,7 @@ void add_timer_on(struct timer_list *timer, int cpu)
 	 * makes sure that a CPU on the way to idle can not evaluate
 	 * the timer wheel.
 	 */
-	wake_up_idle_cpu(cpu);
+	wake_up_nohz_cpu(cpu);
 	spin_unlock_irqrestore(&base->lock, flags);
 }
 EXPORT_SYMBOL_GPL(add_timer_on);
-- 
1.7.5.4

