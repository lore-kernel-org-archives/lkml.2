Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab1HOP6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:58:24 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58289 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab1HOPxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:17 -0400
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
Subject: [PATCH 11/32] cpuset: Set up interface for nohz flag
Date: Mon, 15 Aug 2011 17:52:08 +0200
Message-Id: <1313423549-27093-12-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare the interface to implement the nohz cpuset flag.
This flag, once set, will tell the system to try to
shutdown the periodic timer tick when possible.

We use here a per cpu refcounter. As long as a CPU
is contained into at least one cpuset that has the
nohz flag set, it is part of the set of CPUs that
run into adaptive nohz mode.

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
 arch/Kconfig           |    3 ++
 include/linux/cpuset.h |   22 ++++++++++++++++++++
 init/Kconfig           |    8 +++++++
 kernel/cpuset.c        |   52 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 341ac95..5fe21c4 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -172,6 +172,9 @@ config HAVE_ARCH_JUMP_LABEL
 	bool
 
 config HAVE_ARCH_MUTEX_CPU_RELAX
+       bool
+
+config HAVE_CPUSETS_NO_HZ
 	bool
 
 config HAVE_RCU_TABLE_FREE
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index e9eaec5..62e5d5a 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -244,4 +244,26 @@ static inline void put_mems_allowed(void)
 
 #endif /* !CONFIG_CPUSETS */
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+
+DECLARE_PER_CPU(int, cpu_adaptive_nohz_ref);
+
+static inline bool cpuset_cpu_adaptive_nohz(int cpu)
+{
+	if (per_cpu(cpu_adaptive_nohz_ref, cpu) > 0)
+		return true;
+
+	return false;
+}
+
+static inline bool cpuset_adaptive_nohz(void)
+{
+	if (__get_cpu_var(cpu_adaptive_nohz_ref) > 0)
+		return true;
+
+	return false;
+}
+
+#endif /* CONFIG_CPUSETS_NO_HZ */
+
 #endif /* _LINUX_CPUSET_H */
diff --git a/init/Kconfig b/init/Kconfig
index 3cf7855..0cb591a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -624,6 +624,14 @@ config PROC_PID_CPUSET
 	depends on CPUSETS
 	default y
 
+config CPUSETS_NO_HZ
+       bool "Tickless cpusets"
+       depends on CPUSETS && HAVE_CPUSETS_NO_HZ
+       help
+         This options let you apply a nohz property to a cpuset such
+	 that the periodic timer tick tries to be avoided when possible on
+	 the concerned CPUs.
+
 config CGROUP_CPUACCT
 	bool "Simple CPU accounting cgroup subsystem"
 	help
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 9c9b754..3135096 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -132,6 +132,7 @@ typedef enum {
 	CS_SCHED_LOAD_BALANCE,
 	CS_SPREAD_PAGE,
 	CS_SPREAD_SLAB,
+	CS_ADAPTIVE_NOHZ,
 } cpuset_flagbits_t;
 
 /* convenient tests for these bits */
@@ -170,6 +171,11 @@ static inline int is_spread_slab(const struct cpuset *cs)
 	return test_bit(CS_SPREAD_SLAB, &cs->flags);
 }
 
+static inline int is_adaptive_nohz(const struct cpuset *cs)
+{
+	return test_bit(CS_ADAPTIVE_NOHZ, &cs->flags);
+}
+
 static struct cpuset top_cpuset = {
 	.flags = ((1 << CS_CPU_EXCLUSIVE) | (1 << CS_MEM_EXCLUSIVE)),
 };
@@ -1189,6 +1195,31 @@ static void cpuset_change_flag(struct task_struct *tsk,
 	cpuset_update_task_spread_flag(cgroup_cs(scan->cg), tsk);
 }
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+
+DEFINE_PER_CPU(int, cpu_adaptive_nohz_ref);
+
+static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
+{
+	int cpu;
+	int val;
+
+	if (is_adaptive_nohz(old_cs) == is_adaptive_nohz(cs))
+		return;
+
+	for_each_cpu(cpu, cs->cpus_allowed) {
+		if (is_adaptive_nohz(cs))
+			per_cpu(cpu_adaptive_nohz_ref, cpu) += 1;
+		else
+			per_cpu(cpu_adaptive_nohz_ref, cpu) -= 1;
+	}
+}
+#else
+static inline void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
+{
+}
+#endif
+
 /*
  * update_tasks_flags - update the spread flags of tasks in the cpuset.
  * @cs: the cpuset in which each task's spread flags needs to be changed
@@ -1254,6 +1285,8 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	spread_flag_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
 			|| (is_spread_page(cs) != is_spread_page(trialcs)));
 
+	update_nohz_cpus(cs, trialcs);
+
 	mutex_lock(&callback_mutex);
 	cs->flags = trialcs->flags;
 	mutex_unlock(&callback_mutex);
@@ -1472,6 +1505,7 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_ADAPTIVE_NOHZ,
 } cpuset_filetype_t;
 
 static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
@@ -1511,6 +1545,11 @@ static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
 	case FILE_SPREAD_SLAB:
 		retval = update_flag(CS_SPREAD_SLAB, cs, val);
 		break;
+#ifdef CONFIG_CPUSETS_NO_HZ
+	case FILE_ADAPTIVE_NOHZ:
+		retval = update_flag(CS_ADAPTIVE_NOHZ, cs, val);
+		break;
+#endif
 	default:
 		retval = -EINVAL;
 		break;
@@ -1670,6 +1709,10 @@ static u64 cpuset_read_u64(struct cgroup *cont, struct cftype *cft)
 		return is_spread_page(cs);
 	case FILE_SPREAD_SLAB:
 		return is_spread_slab(cs);
+#ifdef CONFIG_CPUSETS_NO_HZ
+	case FILE_ADAPTIVE_NOHZ:
+		return is_adaptive_nohz(cs);
+#endif
 	default:
 		BUG();
 	}
@@ -1778,6 +1821,15 @@ static struct cftype files[] = {
 		.write_u64 = cpuset_write_u64,
 		.private = FILE_SPREAD_SLAB,
 	},
+
+#ifdef CONFIG_CPUSETS_NO_HZ
+	{
+		.name = "adaptive_nohz",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_ADAPTIVE_NOHZ,
+	},
+#endif
 };
 
 static struct cftype cft_memory_pressure_enabled = {
-- 
1.7.5.4

