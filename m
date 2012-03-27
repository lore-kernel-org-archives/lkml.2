Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab2C0PFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:05:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62282 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab2C0PFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:05:37 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <CAOtvUMeTHbW3qJRVndhZ4mZ57xG=XGtef_OinZ=wca2n14OTbw@mail.gmail.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	<CAOtvUMf0Zp9C-jT=ymEo6oyxnsgkvSiGDUs5V_56v4Ai2QyBJQ@mail.gmail.com>
	<CAOtvUMeTHbW3qJRVndhZ4mZ57xG=XGtef_OinZ=wca2n14OTbw@mail.gmail.com>
Date: Tue, 27 Mar 2012 17:05:35 +0200
Message-ID: <CAOtvUMc5Cx8yv6=CcQ6iJzWC0yhPzp+OsH3aU1VFzWOuaKfcww@mail.gmail.com>
Subject: Re: [RFC][PATCH 00/32] Nohz cpusets v2 (adaptive tickless kernel)
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 013aed27b52122bda38ec9719263c0d09e8acf30
Author: Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun Feb 26 15:38:06 2012 +0200

    mm: make vmstat_update periodic run conditional

    vmstat_update runs every second from the work queue to update statistics
    and drain per cpu pages back into the global page allocator.

    This is useful in most circumstances but is wasteful if the CPU doesn't
    actually make any VM activity. This can happen in the situtation that
    the CPU is idle or running a CPU bound long term task (e.g. CPU
    isolation), in which case the periodic vmstate_update timer needlessly
    interrupts the CPU.

    This patch tries to make vmstat_update schedule itself for the next
    round only if there was any work for it to do in the previous run.
    The assumption is that if for a whole second we didn't see any VM
    activity it is reasnoable to assume that the CPU is not using the
    VM because it is idle or runs a long term single CPU bound task.

    CPUs that do keep the vmstat_update periodic work scheduled are
    used to monitor the CPUs that have turned vmstat_update off for
    signs of VM activity and re-schedule the periodic work on them.

    Care is taken to make sure at least one CPU stays with the
    vmstat_update periodic work on always, including in the case
    where the last standing vmstat_update runner is being taken
    offline.

    Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
    Cc: Alessio Igor Bogani <abogani@kernel.org>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Avi Kivity <avi@redhat.com>
    Cc: Chris Metcalf <cmetcalf@tilera.com>
    Cc: Christoph Lameter <cl@linux.com>
    Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
    Cc: Geoff Levand <geoff@infradead.org>
    Cc: Gilad Ben Yossef <gilad@benyossef.com>
    Cc: Ingo Molnar <mingo@kernel.org>
    Cc: Max Krasnyansky <maxk@qualcomm.com>
    Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Stephen Hemminger <shemminger@vyatta.com>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Zen Lin <zen@openhuawei.org>

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 65efb92..67bf202 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -200,7 +200,7 @@ extern void __inc_zone_state(struct zone *, enum
zone_stat_item);
 extern void dec_zone_state(struct zone *, enum zone_stat_item);
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);

-void refresh_cpu_vm_stats(int);
+bool refresh_cpu_vm_stats(int);
 void refresh_zone_stat_thresholds(void);

 int calculate_pressure_threshold(struct zone *zone);
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f600557..a835dc3 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/cpu.h>
+#include <linux/cpumask.h>
 #include <linux/vmstat.h>
 #include <linux/sched.h>
 #include <linux/math64.h>
@@ -434,11 +435,12 @@ EXPORT_SYMBOL(dec_zone_page_state);
  * with the global counters. These could cause remote node cache line
  * bouncing and will have to be only done when necessary.
  */
-void refresh_cpu_vm_stats(int cpu)
+bool refresh_cpu_vm_stats(int cpu)
 {
 	struct zone *zone;
 	int i;
 	int global_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
+	bool vm_activity = false;

 	for_each_populated_zone(zone) {
 		struct per_cpu_pageset *p;
@@ -485,14 +487,21 @@ void refresh_cpu_vm_stats(int cpu)
 		if (p->expire)
 			continue;

-		if (p->pcp.count)
+		if (p->pcp.count) {
+			vm_activity = true;
 			drain_zone_pages(zone, &p->pcp);
+		}
 #endif
 	}

 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
-		if (global_diff[i])
+		if (global_diff[i]) {
 			atomic_long_add(global_diff[i], &vm_stat[i]);
+			vm_activity = true;
+		}
+
+	return vm_activity;
+
 }

 #endif
@@ -1141,22 +1150,73 @@ static const struct file_operations
proc_vmstat_file_operations = {
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
 int sysctl_stat_interval __read_mostly = HZ;
+static struct cpumask vmstat_off_cpus;
+static DEFINE_MUTEX(vmstat_off_lock);

-static void vmstat_update(struct work_struct *w)
+static inline bool need_vmstat(int cpu)
 {
-	refresh_cpu_vm_stats(smp_processor_id());
-	schedule_delayed_work(&__get_cpu_var(vmstat_work),
-		round_jiffies_relative(sysctl_stat_interval));
+	struct zone *zone;
+	int i;
+
+	for_each_populated_zone(zone) {
+		struct per_cpu_pageset *p;
+
+		p = per_cpu_ptr(zone->pageset, cpu);
+
+		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
+			if (p->vm_stat_diff[i])
+				return true;
+
+		if (zone_to_nid(zone) != numa_node_id() && p->pcp.count)
+			return true;
+	}
+
+	return false;
 }

-static void __cpuinit start_cpu_timer(int cpu)
+static void vmstat_update(struct work_struct *w);
+
+static void start_cpu_timer(int cpu)
 {
 	struct delayed_work *work = &per_cpu(vmstat_work, cpu);

-	INIT_DELAYED_WORK_DEFERRABLE(work, vmstat_update);
+	cpumask_clear_cpu(cpu, &vmstat_off_cpus);
 	schedule_delayed_work_on(cpu, work, __round_jiffies_relative(HZ, cpu));
 }

+static void __cpuinit setup_cpu_timer(int cpu)
+{
+	struct delayed_work *work = &per_cpu(vmstat_work, cpu);
+
+	INIT_DELAYED_WORK_DEFERRABLE(work, vmstat_update);
+	start_cpu_timer(cpu);
+}
+
+static void vmstat_update(struct work_struct *w)
+{
+	int cpu, this_cpu = smp_processor_id();
+	int sleepy_cpu_counter = 0;
+	static spinlock_t lock;
+
+	if(spin_trylock(&lock)) {
+
+		for_each_cpu_and(cpu, &vmstat_off_cpus, cpu_online_mask)
+			if (need_vmstat(cpu))
+				start_cpu_timer(cpu);
+			else
+				sleepy_cpu_counter++;
+
+		spin_unlock(&lock);
+	}
+
+	if (likely(refresh_cpu_vm_stats(this_cpu) ||
+		(sleepy_cpu_counter >= num_online_cpus())))
+			schedule_delayed_work(&__get_cpu_var(vmstat_work),
+				round_jiffies_relative(sysctl_stat_interval));
+	else
+		cpumask_set_cpu(this_cpu, &vmstat_off_cpus);
+}
+
 /*
  * Use the cpu notifier to insure that the thresholds are recalculated
  * when necessary.
@@ -1165,23 +1225,27 @@ static int __cpuinit
vmstat_cpuup_callback(struct notifier_block *nfb,
 		unsigned long action,
 		void *hcpu)
 {
+	long this_cpu = smp_processor_id();
 	long cpu = (long)hcpu;

 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		refresh_zone_stat_thresholds();
-		start_cpu_timer(cpu);
+		setup_cpu_timer(cpu);
 		node_set_state(cpu_to_node(cpu), N_CPU);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
-		cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
-		per_cpu(vmstat_work, cpu).work.func = NULL;
+		if (!cpumask_test_cpu(cpu, &vmstat_off_cpus)) {
+			cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
+			per_cpu(vmstat_work, cpu).work.func = NULL;
+		} else if (cpumask_test_cpu(this_cpu, &vmstat_off_cpus))
+			start_cpu_timer(this_cpu);
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
-		start_cpu_timer(cpu);
+		setup_cpu_timer(cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
@@ -1205,7 +1269,7 @@ static int __init setup_vmstat(void)
 	register_cpu_notifier(&vmstat_notifier);

 	for_each_online_cpu(cpu)
-		start_cpu_timer(cpu);
+		setup_cpu_timer(cpu);
 #endif
 #ifdef CONFIG_PROC_FS
 	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
