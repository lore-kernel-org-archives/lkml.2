Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab1HOPxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:53:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46598 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab1HOPxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:46 -0400
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
Subject: [PATCH 19/32] nohz/cpuset: Restart tick when nohz flag is cleared on cpuset
Date: Mon, 15 Aug 2011 17:52:16 +0200
Message-Id: <1313423549-27093-20-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Issue an IPI to restart the tick on a CPU that belongs
to a cpuset when its nohz flag gets cleared.

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
 include/linux/cpuset.h |    1 +
 kernel/cpuset.c        |   21 +++++++++++++++++++++
 kernel/sched.c         |    8 ++++++++
 3 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 799b9a4..7f9d78d 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -265,6 +265,7 @@ static inline bool cpuset_adaptive_nohz(void)
 }
 
 extern void cpuset_update_nohz(void);
+extern void cpuset_exit_nohz_interrupt(void *unused);
 #else
 static inline void cpuset_update_nohz(void) { }
 
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3135096..ee3b0d0 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1199,6 +1199,14 @@ static void cpuset_change_flag(struct task_struct *tsk,
 
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
@@ -1212,6 +1220,19 @@ static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
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
+			 */
+			smp_mb();
+			cpu_exit_nohz(cpu);
+		}
 	}
 }
 #else
diff --git a/kernel/sched.c b/kernel/sched.c
index 78ea0a5..75378be 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2513,6 +2513,14 @@ void cpuset_update_nohz(void)
 		cpuset_nohz_restart_tick();
 }
 
+void cpuset_exit_nohz_interrupt(void *unused)
+{
+	if (!tick_nohz_adaptive_mode())
+		return;
+
+	cpuset_nohz_restart_tick();
+}
+
 static void cpuset_nohz_task_switch(struct task_struct *next)
 {
 	int cpu = smp_processor_id();
-- 
1.7.5.4

