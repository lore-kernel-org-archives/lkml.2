Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1HOPxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:53:35 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58289 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab1HOPxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:33 -0400
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
Subject: [PATCH 16/32] nohz/cpuset: Wake up adaptive nohz CPU when a timer gets enqueued
Date: Mon, 15 Aug 2011 17:52:13 +0200
Message-Id: <1313423549-27093-17-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wake up a CPU when a timer list timer is enqueued there and
the CPU is in adaptive nohz mode. Sending an IPI to it makes
it reconsidering the next timer to program on top of recent
updates.

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
 include/linux/sched.h    |    4 ++--
 kernel/sched.c           |   33 ++++++++++++++++++++++++++++++++-
 kernel/time/tick-sched.c |    5 ++++-
 kernel/timer.c           |    2 +-
 4 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 53a95b5..5ff0764 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1947,9 +1947,9 @@ static inline void idle_task_exit(void) {}
 #endif
 
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
-extern void wake_up_idle_cpu(int cpu);
+extern void wake_up_nohz_cpu(int cpu);
 #else
-static inline void wake_up_idle_cpu(int cpu) { }
+static inline void wake_up_nohz_cpu(int cpu) { }
 #endif
 
 extern unsigned int sysctl_sched_latency;
diff --git a/kernel/sched.c b/kernel/sched.c
index 9b6b8eb..8bf8280 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1234,7 +1234,7 @@ unlock:
  * account when the CPU goes back to idle and evaluates the timer
  * wheel for the next timer event.
  */
-void wake_up_idle_cpu(int cpu)
+static void wake_up_idle_cpu(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 
@@ -1264,6 +1264,37 @@ void wake_up_idle_cpu(int cpu)
 		smp_send_reschedule(cpu);
 }
 
+
+static bool wake_up_cpuset_nohz_cpu(int cpu)
+{
+#ifdef CONFIG_CPUSETS_NO_HZ
+	/* Ensure task_nohz_mode update is visible */
+	smp_rmb();
+	/*
+	 * Even if task_nohz_mode is set concurrently, what
+	 * matters is that by the time we do that check, we know
+	 * that the CPU has not reached tick_nohz_stop_sched_tick().
+	 * As we are holding the base->lock and that lock needs
+	 * to be taken by tick_nohz_stop_sched_tick() we know
+	 * we are preceding it and it will see our update
+	 * synchronously. Thus we know we don't need to send an
+	 * IPI to that CPU.
+	 */
+	if (per_cpu(task_nohz_mode, cpu)) {
+		smp_cpuset_update_nohz(cpu);
+		return true;
+	}
+#endif
+
+	return false;
+}
+
+void wake_up_nohz_cpu(int cpu)
+{
+	if (!wake_up_cpuset_nohz_cpu(cpu))
+		wake_up_idle_cpu(cpu);
+}
+
 #endif /* CONFIG_NO_HZ */
 
 static u64 sched_avg_period(void)
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index fb97cd0..9e450d8 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -767,8 +767,11 @@ static void tick_nohz_cpuset_stop_tick(int user)
 	if (!cpuset_adaptive_nohz() || tick_nohz_adaptive_mode())
 		return;
 
-	if (cpuset_nohz_can_stop_tick())
+	if (cpuset_nohz_can_stop_tick()) {
 		__get_cpu_var(task_nohz_mode) = 1;
+		/* Nohz mode must be visible to wake_up_nohz_cpu() */
+		smp_wmb();
+	}
 }
 
 /*
diff --git a/kernel/timer.c b/kernel/timer.c
index 8cff361..8cdbd48 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -880,7 +880,7 @@ void add_timer_on(struct timer_list *timer, int cpu)
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

