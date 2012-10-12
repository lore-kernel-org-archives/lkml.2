Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676Ab2JLJLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:11:33 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63325 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab2JLJL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:11:29 -0400
Date: Fri, 12 Oct 2012 11:11:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20121012091117.GA31297@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: 301a5cba2887d1f640e6d5184b05a6d7132017d5 sched: Update sched_domains_numa_masks[][] when new cpus are onlined

A CPU hotplug related crash fix and a nohz accounting fixlet.

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      nohz: Fix one jiffy count too far in idle cputime

Tang Chen (2):
      sched: Ensure 'sched_domains_numa_levels' is safe to use in other functions
      sched: Update sched_domains_numa_masks[][] when new cpus are onlined


 kernel/sched/core.c      | 69 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/time/tick-sched.c |  2 +-
 2 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c177472..8322d73 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6122,6 +6122,17 @@ static void sched_init_numa(void)
 	 * numbers.
 	 */
 
+	/*
+	 * Here, we should temporarily reset sched_domains_numa_levels to 0.
+	 * If it fails to allocate memory for array sched_domains_numa_masks[][],
+	 * the array will contain less then 'level' members. This could be
+	 * dangerous when we use it to iterate array sched_domains_numa_masks[][]
+	 * in other functions.
+	 *
+	 * We reset it to 'level' at the end of this function.
+	 */
+	sched_domains_numa_levels = 0;
+
 	sched_domains_numa_masks = kzalloc(sizeof(void *) * level, GFP_KERNEL);
 	if (!sched_domains_numa_masks)
 		return;
@@ -6176,11 +6187,68 @@ static void sched_init_numa(void)
 	}
 
 	sched_domain_topology = tl;
+
+	sched_domains_numa_levels = level;
+}
+
+static void sched_domains_numa_masks_set(int cpu)
+{
+	int i, j;
+	int node = cpu_to_node(cpu);
+
+	for (i = 0; i < sched_domains_numa_levels; i++) {
+		for (j = 0; j < nr_node_ids; j++) {
+			if (node_distance(j, node) <= sched_domains_numa_distance[i])
+				cpumask_set_cpu(cpu, sched_domains_numa_masks[i][j]);
+		}
+	}
+}
+
+static void sched_domains_numa_masks_clear(int cpu)
+{
+	int i, j;
+	for (i = 0; i < sched_domains_numa_levels; i++) {
+		for (j = 0; j < nr_node_ids; j++)
+			cpumask_clear_cpu(cpu, sched_domains_numa_masks[i][j]);
+	}
+}
+
+/*
+ * Update sched_domains_numa_masks[level][node] array when new cpus
+ * are onlined.
+ */
+static int sched_domains_numa_masks_update(struct notifier_block *nfb,
+					   unsigned long action,
+					   void *hcpu)
+{
+	int cpu = (long)hcpu;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_ONLINE:
+		sched_domains_numa_masks_set(cpu);
+		break;
+
+	case CPU_DEAD:
+		sched_domains_numa_masks_clear(cpu);
+		break;
+
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
 }
 #else
 static inline void sched_init_numa(void)
 {
 }
+
+static int sched_domains_numa_masks_update(struct notifier_block *nfb,
+					   unsigned long action,
+					   void *hcpu)
+{
+	return 0;
+}
 #endif /* CONFIG_NUMA */
 
 static int __sdt_alloc(const struct cpumask *cpu_map)
@@ -6629,6 +6697,7 @@ void __init sched_init_smp(void)
 	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
 
+	hotcpu_notifier(sched_domains_numa_masks_update, CPU_PRI_SCHED_ACTIVE);
 	hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
 	hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f423bdd..a402608 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -835,7 +835,7 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 		 */
 		if (ts->tick_stopped) {
 			touch_softlockup_watchdog();
-			if (idle_cpu(cpu))
+			if (is_idle_task(current))
 				ts->idle_jiffies++;
 		}
 		update_process_times(user_mode(regs));
