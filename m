Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab2ELRdy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 13:33:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab2ELRdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 13:33:52 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rob@landley.net, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        luto@mit.edu, suresh.b.siddha@intel.com, avi@redhat.com,
        a.p.zijlstra@chello.nl, johnstul@us.ibm.com, arjan@linux.intel.com
Subject: [RFC] [x86]: abort secondary cpu bringup gracefully
Date: Sat, 12 May 2012 21:32:09 +0200
Message-Id: <1336851129-7821-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <alpine.LFD.2.02.1205112256220.3231@ionos>
References: <alpine.LFD.2.02.1205112256220.3231@ionos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thomas,
  Is this what you've meant?

Master cpu may timeout before cpu_callin_mask is set and decide to
abort cpu boot but being onlined cpu will continue to boot, set
cpu_active_mask and wait in check_tsc_sync_target() for master cpu
to arrive, that will never happen because master cpu aborted boot
proccess. Following attempt to online next cpu will hang in
stop_machine because it will wait on comletion of stop_work on all
cpus from cpu_active_mask and that will never happen because first
failed cpu spins in check_tsc_sync_target().

Introduce cpu_may_complete_boot_mask which will be set by master cpu
if it goes via normal boot path and decides to continue cpu bring up.
Being onlined cpu will continue to boot only if master cpu confirms
via cpu_may_complete_boot_mask its intention not to abort cpu bring up.
Otherwise being onlined cpu will gracefully die.

In addition if being onlined cpu timed-out waiting on cpu_callout_mask,
it should not panic but rather die.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/include/asm/cpumask.h |    1 +
 arch/x86/kernel/cpu/common.c   |    2 ++
 arch/x86/kernel/smpboot.c      |   34 +++++++++++++++++++++++++++++++---
 3 files changed, 34 insertions(+), 3 deletions(-)

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
index cf79302..50e91cb 100644
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
index 6e1e406..b33149f 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -187,8 +187,9 @@ static void __cpuinit smp_callin(void)
 	}
 
 	if (!time_before(jiffies, timeout)) {
-		panic("%s: CPU%d started up but did not get a callout!\n",
+		pr_debug("%s: CPU%d started up but did not get a callout!\n",
 		      __func__, cpuid);
+		goto die;
 	}
 
 	/*
@@ -232,12 +233,36 @@ static void __cpuinit smp_callin(void)
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
+	 * Wait for master to continue.
+	 */
+	for (timeout = 0; timeout < 50000; timeout++) {
+		if (cpumask_test_cpu(cpuid, cpu_may_complete_boot_mask))
+			break;
+
+		if (!cpumask_test_cpu(cpuid, cpu_callout_mask))
+			break;
+
+		udelay(100);
+	}
+
+	if (!cpumask_test_cpu(cpuid, cpu_may_complete_boot_mask))
+		goto die;
+
+	notify_cpu_starting(cpuid);
+	return;
+
+die:
+	/* was set by cpu_init() */
+	cpumask_clear_cpu(smp_processor_id(), cpu_initialized_mask);
+	cpumask_clear_cpu(smp_processor_id(), cpu_callin_mask);
+	clear_local_APIC();
+	play_dead();
 }
 
 /*
@@ -774,6 +799,8 @@ do_rest:
 		}
 
 		if (cpumask_test_cpu(cpu, cpu_callin_mask)) {
+			/* Signal AP that it may continue to boot */
+			cpumask_set_cpu(cpu, cpu_may_complete_boot_mask);
 			print_cpu_msr(&cpu_data(cpu));
 			pr_debug("CPU%d: has booted.\n", cpu);
 		} else {
@@ -1250,6 +1277,7 @@ static void __ref remove_cpu_from_maps(int cpu)
 	cpumask_clear_cpu(cpu, cpu_callin_mask);
 	/* was set by cpu_init() */
 	cpumask_clear_cpu(cpu, cpu_initialized_mask);
+	cpumask_clear_cpu(cpu, cpu_may_complete_boot_mask);
 	numa_remove_cpu(cpu);
 }
 
-- 
1.7.1

