Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab2KNCiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 21:38:18 -0500
Received: from mga14.intel.com ([143.182.124.37]:3412 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493Ab2KNCdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 21:33:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,247,1352102400"; 
   d="scan'208";a="217413910"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Arjan Dan De Ven" <arjan@linux.intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v10 04/14] x86, hotplug: Support functions for CPU0 online/offline
Date: Tue, 13 Nov 2012 11:32:41 -0800
Message-Id: <1352835171-3958-5-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1352835171-3958-1-git-send-email-fenghua.yu@intel.com>
References: <1352835171-3958-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Add smp_store_boot_cpu_info() to store cpu info for BSP during boot time.

Now smp_store_cpu_info() stores cpu info for bringing up BSP or AP after
it's offline.

Continue to online CPU0 in native_cpu_up().

Continue to offline CPU0 in native_cpu_disable().

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
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
index c80a33b..c297907 100644
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
@@ -795,7 +806,7 @@ int __cpuinit native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 
 	pr_debug("++++++++++++++++++++=_---CPU UP  %u\n", cpu);
 
-	if (apicid == BAD_APICID || apicid == boot_cpu_physical_apicid ||
+	if (apicid == BAD_APICID ||
 	    !physid_isset(apicid, phys_cpu_present_map) ||
 	    !apic->apic_id_valid(apicid)) {
 		pr_err("%s: bad cpu %d\n", __func__, cpu);
@@ -990,7 +1001,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	/*
 	 * Setup boot CPU information
 	 */
-	smp_store_cpu_info(0); /* Final full version of the data */
+	smp_store_boot_cpu_info(); /* Final full version of the data */
 	cpumask_copy(cpu_callin_mask, cpumask_of(0));
 	mb();
 
@@ -1214,19 +1225,6 @@ void cpu_disable_common(void)
 
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
-- 
1.7.2

