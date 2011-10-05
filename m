Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935125Ab1JEQzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:55:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:9204 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935077Ab1JEQzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:55:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,492,1312182000"; 
   d="scan'208";a="23558375"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
        "Tony Luck" <tony.luck@intel.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <lenb@kernel.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 5/8] x86, common.c, smpboot.c: Init BSP during BSP online and don't offline BSP if irq is bound to it
Date: Wed,  5 Oct 2011 09:39:16 -0700
Message-Id: <1317832759-10223-6-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

During BSP online, enable x2apic and initialize BSP. Don't offline BSP if
any irq is bound to it.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/processor.h |    1 +
 arch/x86/kernel/cpu/common.c     |   13 ++++++++++---
 arch/x86/kernel/smpboot.c        |   38 +++++++++++++++++++++++++++++++-------
 3 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 0d1171c..d648cae 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -161,6 +161,7 @@ extern struct pt_regs *idle_regs(struct pt_regs *);
 
 extern void early_cpu_init(void);
 extern void identify_boot_cpu(void);
+extern void identify_boot_cpu_online(void);
 extern void identify_secondary_cpu(struct cpuinfo_x86 *);
 extern void print_cpu_info(struct cpuinfo_x86 *);
 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6218439..2ceefb9 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -911,6 +911,14 @@ void __init identify_boot_cpu(void)
 #endif
 }
 
+void __cpuinit identify_boot_cpu_online(void)
+{
+	numa_add_cpu(smp_processor_id());
+#ifdef CONFIG_X86_32
+	enable_sep_cpu();
+#endif
+}
+
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
 {
 	BUG_ON(c == &boot_cpu_data);
@@ -1158,7 +1166,7 @@ void __cpuinit cpu_init(void)
 	oist = &per_cpu(orig_ist, cpu);
 
 #ifdef CONFIG_NUMA
-	if (cpu != 0 && percpu_read(numa_node) == 0 &&
+	if (percpu_read(numa_node) == 0 &&
 	    early_cpu_to_node(cpu) != NUMA_NO_NODE)
 		set_numa_node(early_cpu_to_node(cpu));
 #endif
@@ -1190,8 +1198,7 @@ void __cpuinit cpu_init(void)
 	barrier();
 
 	x86_configure_nx();
-	if (cpu != 0)
-		enable_x2apic();
+	enable_x2apic();
 
 	/*
 	 * set up and load the per-CPU TSS
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9f548cb..cdfa425 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -50,6 +50,7 @@
 #include <linux/tboot.h>
 #include <linux/stackprotector.h>
 #include <linux/gfp.h>
+#include <linux/kernel_stat.h>
 
 #include <asm/acpi.h>
 #include <asm/desc.h>
@@ -136,8 +137,8 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 atomic_t init_deasserted;
 
 /*
- * Report back to the Boot Processor.
- * Running on AP.
+ * Report back to the Boot Processor during boot time or to the caller processor
+ * during CPU online.
  */
 static void __cpuinit smp_callin(void)
 {
@@ -224,6 +225,13 @@ static void __cpuinit smp_callin(void)
 	smp_store_cpu_info(cpuid);
 
 	/*
+	 * This function won't run on the BSP during boot time. It run
+	 * on BSP only when BSP is offlined and onlined again.
+	 */
+	if (cpuid == 0)
+		identify_boot_cpu_online();
+
+	/*
 	 * This must be done before setting cpu_online_mask
 	 * or calling notify_cpu_starting.
 	 */
@@ -839,7 +847,7 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 
 	pr_debug("++++++++++++++++++++=_---CPU UP  %u\n", cpu);
 
-	if (apicid == BAD_APICID || apicid == boot_cpu_physical_apicid ||
+	if (apicid == BAD_APICID ||
 	    !physid_isset(apicid, phys_cpu_present_map)) {
 		printk(KERN_ERR "%s: bad cpu %d\n", __func__, cpu);
 		return -EINVAL;
@@ -1283,12 +1291,28 @@ int native_cpu_disable(void)
 	 * Perhaps use cpufreq to drop frequency, but that could go
 	 * into generic code.
 	 *
-	 * We won't take down the boot processor on i386 due to some
+	 * We won't take down the boot processor on i386 if some
 	 * interrupts only being able to be serviced by the BSP.
-	 * Especially so if we're not using an IOAPIC	-zwane
+	 * Especially so if we're not using an IOAPIC
+	 * -original comment from zwane, changed by fyu
 	 */
-	if (cpu == 0)
-		return -EBUSY;
+	if (cpu == 0) {
+		int i;
+		for (i = 0; i < NR_IRQS; i++) {
+			struct irq_desc *desc = irq_to_desc(i);
+
+			if (!desc)
+				continue;
+
+			if (irqd_irq_disabled(&desc->irq_data))
+				continue;
+
+			if (!irq_can_set_affinity(i)) {
+				pr_debug("irq%d can't move out of BSP\n", i);
+				return -EBUSY;
+			}
+		}
+	}
 
 	clear_local_APIC();
 
-- 
1.6.0.3

