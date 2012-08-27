Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2H0RKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:10:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34430 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2H0RKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:10:12 -0400
Date: Mon, 27 Aug 2012 10:10:00 -0700
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-aa21d3b5aa1ac0b8018c8a615bbc623045545bb6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1345916488-8355-5-git-send-email-fenghua.yu@intel.com>
References: <1345916488-8355-5-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/bsp-hotplug] x86, hotplug:
  Support functions for CPU0 online/offline
Git-Commit-ID: aa21d3b5aa1ac0b8018c8a615bbc623045545bb6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 10:10:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa21d3b5aa1ac0b8018c8a615bbc623045545bb6
Gitweb:     http://git.kernel.org/tip/aa21d3b5aa1ac0b8018c8a615bbc623045545bb6
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Sat, 25 Aug 2012 10:41:20 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 25 Aug 2012 19:26:04 -0700

x86, hotplug: Support functions for CPU0 online/offline

Add smp_store_boot_cpu_info() to store cpu info for BSP during boot time.

Now smp_store_cpu_info() stores cpu info for bringing up BSP or AP after
it's offline.

Continue to online CPU0 in native_cpu_up().

Continue to offline CPU0 in native_cpu_disable().

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1345916488-8355-5-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/smp.h |    1 +
 arch/x86/kernel/smpboot.c  |   38 ++++++++++++++++++--------------------
 2 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 4f19a15..b073aae 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -166,6 +166,7 @@ void native_send_call_func_ipi(const struct cpumask *mask);
 void native_send_call_func_single_ipi(int cpu);
 void x86_idle_thread_init(unsigned int cpu, struct task_struct *idle);
 
+void smp_store_boot_cpu_info(void);
 void smp_store_cpu_info(int id);
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7c5a8c3..58439fe 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -125,8 +125,8 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 atomic_t init_deasserted;
 
 /*
- * Report back to the Boot Processor.
- * Running on AP.
+ * Report back to the Boot Processor during boot time or to the caller processor
+ * during CPU online.
  */
 static void __cpuinit smp_callin(void)
 {
@@ -279,19 +279,30 @@ notrace static void __cpuinit start_secondary(void *unused)
 	cpu_idle();
 }
 
+void __init smp_store_boot_cpu_info(void)
+{
+	int id = 0; /* CPU 0 */
+	struct cpuinfo_x86 *c = &cpu_data(id);
+
+	*c = boot_cpu_data;
+	c->cpu_index = id;
+}
+
 /*
  * The bootstrap kernel entry code has set these up. Save them for
  * a given CPU
  */
-
 void __cpuinit smp_store_cpu_info(int id)
 {
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
 	*c = boot_cpu_data;
 	c->cpu_index = id;
-	if (id != 0)
-		identify_secondary_cpu(c);
+	/*
+	 * During boot time, CPU0 has this setup already. Save the info when
+	 * bringing up AP or offlined CPU0.
+	 */
+	identify_secondary_cpu(c);
 }
 
 static bool __cpuinit
@@ -794,7 +805,7 @@ int __cpuinit native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 
 	pr_debug("++++++++++++++++++++=_---CPU UP  %u\n", cpu);
 
-	if (apicid == BAD_APICID || apicid == boot_cpu_physical_apicid ||
+	if (apicid == BAD_APICID ||
 	    !physid_isset(apicid, phys_cpu_present_map) ||
 	    !apic->apic_id_valid(apicid)) {
 		pr_err("%s: bad cpu %d\n", __func__, cpu);
@@ -989,7 +1000,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	/*
 	 * Setup boot CPU information
 	 */
-	smp_store_cpu_info(0); /* Final full version of the data */
+	smp_store_boot_cpu_info(); /* Final full version of the data */
 	cpumask_copy(cpu_callin_mask, cpumask_of(0));
 	mb();
 
@@ -1227,19 +1238,6 @@ void cpu_disable_common(void)
 
 int native_cpu_disable(void)
 {
-	int cpu = smp_processor_id();
-
-	/*
-	 * Perhaps use cpufreq to drop frequency, but that could go
-	 * into generic code.
-	 *
-	 * We won't take down the boot processor on i386 due to some
-	 * interrupts only being able to be serviced by the BSP.
-	 * Especially so if we're not using an IOAPIC	-zwane
-	 */
-	if (cpu == 0)
-		return -EBUSY;
-
 	clear_local_APIC();
 
 	cpu_disable_common();
