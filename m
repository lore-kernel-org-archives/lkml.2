Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab2D3X4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 19:56:34 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62757 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab2D3X4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 19:56:33 -0400
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
Subject: [PATCH 14/41] nohz/cpuset: Restart tick when nohz flag is cleared on cpuset
Date: Tue,  1 May 2012 01:54:48 +0200
Message-Id: <1335830115-14335-15-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Issue an IPI to restart the tick on a CPU that belongs
to a cpuset when its nohz flag gets cleared.

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
 include/linux/cpuset.h   |    2 ++
 kernel/cpuset.c          |   23 +++++++++++++++++++++++
 kernel/time/tick-sched.c |    8 ++++++++
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 5510708..89ef5f3 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -263,6 +263,8 @@ static inline bool cpuset_adaptive_nohz(void)
 
 	return false;
 }
+
+extern void cpuset_exit_nohz_interrupt(void *unused);
 #else
 static inline bool cpuset_cpu_adaptive_nohz(int cpu) { return false; }
 static inline bool cpuset_adaptive_nohz(void) { return false; }
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 5a28cf8..00864a0 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1221,6 +1221,14 @@ static void cpuset_change_flag(struct task_struct *tsk,
 
 DEFINE_PER_CPU(int, cpu_adaptive_nohz_ref);
 
+static void cpu_exit_nohz(int cpu)
+{
+	preempt_disable();
+	smp_call_function_single(cpu, cpuset_exit_nohz_interrupt,
+				 NULL, true);
+	preempt_enable();
+}
+
 static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
 {
 	int cpu;
@@ -1234,6 +1242,21 @@ static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
 			per_cpu(cpu_adaptive_nohz_ref, cpu) += 1;
 		else
 			per_cpu(cpu_adaptive_nohz_ref, cpu) -= 1;
+
+		val = per_cpu(cpu_adaptive_nohz_ref, cpu);
+
+		if (!val) {
+			/*
+			 * The update to cpu_adaptive_nohz_ref must be
+			 * visible right away. So that once we restart the tick
+			 * from the IPI, it won't be stopped again due to cache
+			 * update lag.
+			 * FIXME: We probably need more to ensure this value is really
+			 * visible right away.
+			 */
+			smp_mb();
+			cpu_exit_nohz(cpu);
+		}
 	}
 }
 #else
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index fc35d41..fe31add 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -875,6 +875,14 @@ void tick_nohz_check_adaptive(void)
 	}
 }
 
+void cpuset_exit_nohz_interrupt(void *unused)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	if (ts->tick_stopped && !is_idle_task(current))
+		tick_nohz_restart_adaptive();
+}
+
 void tick_nohz_post_schedule(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
-- 
1.7.5.4

