Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2ENJL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:11:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949Ab2ENJL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:11:28 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, luto@mit.edu, suresh.b.siddha@intel.com,
        avi@redhat.com, imammedo@redhat.com, a.p.zijlstra@chello.nl,
        johnstul@us.ibm.com, arjan@linux.intel.com
Subject: [RFC v2] [x86]: abort secondary cpu bringup gracefully
Date: Mon, 14 May 2012 13:09:29 +0200
Message-Id: <1336993769-15272-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <27b5952f-0f5f-418a-9e22-e6ea12980eee@zmail16.collab.prod.int.phx2.redhat.com>
References: <27b5952f-0f5f-418a-9e22-e6ea12980eee@zmail16.collab.prod.int.phx2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to cc v1 to tglx, so reposting fixed v2.

Thomas,
  is patch below what you've meant?

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

Reason for moving setting cpu_callin_mask before is that one of
CPU_STARTING notfiers sets cpu_active_mask before it is known for sure
that cpu may continue to boot. And that may lead to soft lookups in
stop_machine when next cpu is booted but failed one haven't completed
cpu_*_mask cleaups yet.

It's ok for being onlined cpu to set cpu_callin_mask before calling
CPU_STARTING notifiers because master cpu may first wait on being
booted cpu in check_tsc_sync_source() and after that it waits in
native_cpu_up() till being booted cpu comes online and only when
being booted cpu sets cpu_online_mask it will exit native_cpu_up()
and then call CPU_ONLINE notifiers. So call sequence looks like this:

    CPU1                            CPU2

  wait till CPU2 sets
  cpu_callin_mask
 -------------------------------------------------
                                    set cpu_callin_mask
                                    wait till CPU1 sets
                                    cpu_may_complete_boot_mask
 -------------------------------------------------
  got ack from CPU2 via
  cpu_callin_mask

  set cpu_may_complete_boot_mask
  exit do_boot_cpu and return into
  native_cpu_up()

  in native_cpu_up() CPU1 may spin first in
  check_tsc_sync_source()
  and then wait till CPU2 will set
  cpu_online_mask:

        while (!cpu_online(cpu)) {
                cpu_relax();
                touch_nmi_watchdog();
        }
 -------------------------------------------------
                                     got ack from CPU1 via
                                     cpu_may_complete_boot_mask

                                     call CPU_STARTING notifiers
                                     ...
                                     call check_tsc_sync_target()
                                     set cpu_online_mask
 -------------------------------------------------
  got ack from CPU2 that it
  is online, return from native_cpu_up()

  call CPU_ONLINE notifiers
 ----

In addition if being onlined cpu timed-out waiting on cpu_callout_mask,
it should not panic but rather die.

v2:
  - added missing remove_siblinginfo() on 'die' error path.
  - added explanation why it's ok to set cpu_callin_mask before calling
    CPU_STARTING notifiers

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/include/asm/cpumask.h |    1 +
 arch/x86/kernel/cpu/common.c   |    2 ++
 arch/x86/kernel/smpboot.c      |   39 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 39 insertions(+), 3 deletions(-)

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
index 6e1e406..b419e2e 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -136,6 +136,10 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 atomic_t init_deasserted;
 
+#ifdef CONFIG_HOTPLUG_CPU
+static void remove_siblinginfo(int cpu);
+#endif
+
 /*
  * Report back to the Boot Processor.
  * Running on AP.
@@ -187,8 +191,9 @@ static void __cpuinit smp_callin(void)
 	}
 
 	if (!time_before(jiffies, timeout)) {
-		panic("%s: CPU%d started up but did not get a callout!\n",
+		pr_debug("%s: CPU%d started up but did not get a callout!\n",
 		      __func__, cpuid);
+		goto die;
 	}
 
 	/*
@@ -232,12 +237,37 @@ static void __cpuinit smp_callin(void)
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
+	remove_siblinginfo(cpuid);
+	cpumask_clear_cpu(smp_processor_id(), cpu_callin_mask);
+	clear_local_APIC();
+	play_dead();
 }
 
 /*
@@ -774,6 +804,8 @@ do_rest:
 		}
 
 		if (cpumask_test_cpu(cpu, cpu_callin_mask)) {
+			/* Signal AP that it may continue to boot */
+			cpumask_set_cpu(cpu, cpu_may_complete_boot_mask);
 			print_cpu_msr(&cpu_data(cpu));
 			pr_debug("CPU%d: has booted.\n", cpu);
 		} else {
@@ -1250,6 +1282,7 @@ static void __ref remove_cpu_from_maps(int cpu)
 	cpumask_clear_cpu(cpu, cpu_callin_mask);
 	/* was set by cpu_init() */
 	cpumask_clear_cpu(cpu, cpu_initialized_mask);
+	cpumask_clear_cpu(cpu, cpu_may_complete_boot_mask);
 	numa_remove_cpu(cpu);
 }
 
-- 
1.7.1

