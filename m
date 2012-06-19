Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab2FSMOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:14:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab2FSMOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:14:47 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: prarit@redhat.com, oleg@redhat.com, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, luto@mit.edu,
        suresh.b.siddha@intel.com, avi@redhat.com, imammedo@redhat.com,
        a.p.zijlstra@chello.nl, johnstul@us.ibm.com, arjan@linux.intel.com
Subject: [PATCH 1/2] x86: abort secondary CPU bring-up gracefully if do_boot_cpu timed out on cpu_callin_mask
Date: Tue, 19 Jun 2012 14:14:20 +0200
Message-Id: <1340108061-5128-2-git-send-email-imammedo@redhat.com>
In-Reply-To: <1340108061-5128-1-git-send-email-imammedo@redhat.com>
References: <1340108061-5128-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Master CPU may timeout before cpu_callin_mask is set and cancel
booting CPU, but being onlined CPU still continues to boot, sets
cpu_active_mask (CPU_STARTING notifiers) and spins in
check_tsc_sync_target() for master cpu to arrive. Following attempt
to online another cpu hangs in stop_machine, initiated from here:

smp_callin ->
  smp_store_cpu_info ->
    identify_secondary_cpu ->
      mtrr_ap_init -> set_mtrr_from_inactive_cpu

stop_machine waits on completion of stop_work on all CPUs from
cpu_active_mask including a failed CPU that spins in check_tsc_sync_target().

Issue could be fixed if being onlined CPU continues to boot and calls
notify_cpu_starting(cpuid) only when master CPU waits for it to
come online. If master CPU times out on cpu_callin_mask and goes via
cancel path, the being onlined CPU should gracefully shutdown itself.

Patch introduces cpu_may_complete_boot_mask to notify a being onlined
CPU that it may call notify_cpu_starting(cpuid) and continue to boot
when master CPU goes via normal boot path and going to wait till the
being onlined CPU completes its initialization.

normal boot sequence will look like:
    master CPU1                         being onlined CPU2

 * wait for CPU2 in cpu_callin_mask
---------------------------------------------------------------------
                                        * set CPU2 in cpu_callin_mask
                                        * wait till CPU1 set CPU2 bit
                                        in cpu_may_complete_boot_mask
---------------------------------------------------------------------
 * set CPU2 bit in
   cpu_may_complete_boot_mask
 * return from do_boot_cpu() and
   wait in
     - check_tsc_sync_source() or
     - while (!cpu_online(CPU2))
---------------------------------------------------------------------
                                        * call notify_cpu_starting()
					  and continue CPU2 initialization
					* mark itself as ONLINE
---------------------------------------------------------------------
 * return to _cpu_up and call
   cpu_notify(CPU_ONLINE, ...)

cancel/error path will look like:
    master CPU1                         being onlined CPU2

 * time out on cpu_callin_mask
---------------------------------------------------------------------
                                       * set CPU2 in cpu_callin_mask
                                       * wait till CPU2 is set in
                                         cpu_may_complete_boot_mask or
                                         cleared in cpu_callout_mask
---------------------------------------------------------------------
 * clear CPU2 in cpu_callout_mask
 and return with error
---------------------------------------------------------------------
                                       * do cleanups and play_dead()

Note:
It's safe for being onlined CPU to set cpu_callin_mask before calling
notify_cpu_starting() because master CPU may first wait for being booted
CPU in check_tsc_sync_source() and then it waits in native_cpu_up() till
being booted CPU comes online and only when being booted CPU sets cpu_online_mask
it will exit native_cpu_up() and then call CPU_ONLINE notifiers.

v3:
  - added missing remove_siblinginfo() on 'die' error path.
  - added explanation why it's ok to set cpu_callin_mask before calling
    CPU_STARTING notifiers
  - being booted CPU will wait for master CPU without timeouts

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/include/asm/cpumask.h |    1 +
 arch/x86/kernel/cpu/common.c   |    2 ++
 arch/x86/kernel/smpboot.c      |   34 ++++++++++++++++++++++++++++++++--
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpumask.h b/arch/x86/include/asm/cpumask.h
index 61c852f..eacd269 100644
--- a/arch/x86/include/asm/cpumask.h
+++ b/arch/x86/include/asm/cpumask.h
@@ -7,6 +7,7 @@ extern cpumask_var_t cpu_callin_mask;
 extern cpumask_var_t cpu_callout_mask;
 extern cpumask_var_t cpu_initialized_mask;
 extern cpumask_var_t cpu_sibling_setup_mask;
+extern cpumask_var_t cpu_may_complete_boot_mask;
 
 extern void setup_cpu_local_masks(void);
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6b9333b..16984f1 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -48,6 +48,7 @@
 cpumask_var_t cpu_initialized_mask;
 cpumask_var_t cpu_callout_mask;
 cpumask_var_t cpu_callin_mask;
+cpumask_var_t cpu_may_complete_boot_mask;
 
 /* representing cpus for which sibling maps can be computed */
 cpumask_var_t cpu_sibling_setup_mask;
@@ -59,6 +60,7 @@ void __init setup_cpu_local_masks(void)
 	alloc_bootmem_cpumask_var(&cpu_callin_mask);
 	alloc_bootmem_cpumask_var(&cpu_callout_mask);
 	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
+	alloc_bootmem_cpumask_var(&cpu_may_complete_boot_mask);
 }
 
 static void __cpuinit default_init(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7bd8a08..95948b9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -122,6 +122,8 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 atomic_t init_deasserted;
 
+static void remove_siblinginfo(int cpu);
+
 /*
  * Report back to the Boot Processor.
  * Running on AP.
@@ -218,12 +220,37 @@ static void __cpuinit smp_callin(void)
 	set_cpu_sibling_map(raw_smp_processor_id());
 	wmb();
 
-	notify_cpu_starting(cpuid);
-
 	/*
 	 * Allow the master to continue.
 	 */
 	cpumask_set_cpu(cpuid, cpu_callin_mask);
+
+	/*
+	 * Wait for signal from master CPU to continue or abort.
+	 */
+	while (!cpumask_test_cpu(cpuid, cpu_may_complete_boot_mask) &&
+		cpumask_test_cpu(cpuid, cpu_callout_mask)) {
+		cpu_relax();
+	}
+
+	/* die if master cancelled cpu_up */
+	if (!cpumask_test_cpu(cpuid, cpu_may_complete_boot_mask))
+		goto die;
+
+	notify_cpu_starting(cpuid);
+	return;
+
+die:
+#ifdef CONFIG_HOTPLUG_CPU
+	numa_remove_cpu(cpuid);
+	remove_siblinginfo(cpuid);
+	clear_local_APIC();
+	/* was set by cpu_init() */
+	cpumask_clear_cpu(cpuid, cpu_initialized_mask);
+	cpumask_clear_cpu(cpuid, cpu_callin_mask);
+	play_dead();
+#endif
+	panic("%s: Failed to online CPU%d!\n", __func__, cpuid);
 }
 
 /*
@@ -752,6 +779,8 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 		}
 
 		if (cpumask_test_cpu(cpu, cpu_callin_mask)) {
+			/* Signal AP that it may continue to boot */
+			cpumask_set_cpu(cpu, cpu_may_complete_boot_mask);
 			print_cpu_msr(&cpu_data(cpu));
 			pr_debug("CPU%d: has booted.\n", cpu);
 		} else {
@@ -1225,6 +1254,7 @@ static void __ref remove_cpu_from_maps(int cpu)
 	cpumask_clear_cpu(cpu, cpu_callin_mask);
 	/* was set by cpu_init() */
 	cpumask_clear_cpu(cpu, cpu_initialized_mask);
+	cpumask_clear_cpu(cpu, cpu_may_complete_boot_mask);
 	numa_remove_cpu(cpu);
 }
 
-- 
1.7.1

