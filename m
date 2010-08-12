Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003Ab0HLVEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:04:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:56097 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021Ab0HLVEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:04:04 -0400
Date: Thu, 12 Aug 2010 21:03:44 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1279731838-1522-8-git-send-email-robert.richter@amd.com>
References: <1279731838-1522-8-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, cleanup: Remove obsolete boot_cpu_id variable
Message-ID: <tip-f6e9456c9272bb570df6e217cdbe007e270b1c4e@git.kernel.org>
Git-Commit-ID: f6e9456c9272bb570df6e217cdbe007e270b1c4e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 12 Aug 2010 21:03:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6e9456c9272bb570df6e217cdbe007e270b1c4e
Gitweb:     http://git.kernel.org/tip/f6e9456c9272bb570df6e217cdbe007e270b1c4e
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 21 Jul 2010 19:03:58 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 12 Aug 2010 14:01:38 -0700

x86, cleanup: Remove obsolete boot_cpu_id variable

boot_cpu_id is there for historical reasons and was renamed to
boot_cpu_physical_apicid in patch:

 c70dcb7 x86: change boot_cpu_id to boot_cpu_physical_apicid

However, there are some remaining occurrences of boot_cpu_id that are
never touched in the kernel and thus its value is always 0.

This patch removes boot_cpu_id completely.

Signed-off-by: Robert Richter <robert.richter@amd.com>
LKML-Reference: <1279731838-1522-8-git-send-email-robert.richter@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/apb_timer.h |    1 -
 arch/x86/include/asm/cpu.h       |    1 -
 arch/x86/kernel/apb_timer.c      |    2 +-
 arch/x86/kernel/apic/io_apic.c   |   12 ++++++------
 arch/x86/kernel/cpu/amd.c        |    2 +-
 arch/x86/kernel/cpu/common.c     |    2 +-
 arch/x86/kernel/cpu/intel.c      |    2 +-
 arch/x86/kernel/reboot.c         |    2 +-
 arch/x86/kernel/setup.c          |    1 -
 arch/x86/kernel/setup_percpu.c   |    2 +-
 arch/x86/mm/k8topology_64.c      |    6 +++---
 11 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/apb_timer.h b/arch/x86/include/asm/apb_timer.h
index a69b1ac..2fefa50 100644
--- a/arch/x86/include/asm/apb_timer.h
+++ b/arch/x86/include/asm/apb_timer.h
@@ -54,7 +54,6 @@ extern struct clock_event_device *global_clock_event;
 extern unsigned long apbt_quick_calibrate(void);
 extern int arch_setup_apbt_irqs(int irq, int trigger, int mask, int cpu);
 extern void apbt_setup_secondary_clock(void);
-extern unsigned int boot_cpu_id;
 
 extern struct sfi_timer_table_entry *sfi_get_mtmr(int hint);
 extern void sfi_free_mtmr(struct sfi_timer_table_entry *mtmr);
diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index b185091..4fab24d 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -32,6 +32,5 @@ extern void arch_unregister_cpu(int);
 
 DECLARE_PER_CPU(int, cpu_state);
 
-extern unsigned int boot_cpu_id;
 
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 8dd7780..08f75fb 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -343,7 +343,7 @@ void apbt_setup_secondary_clock(void)
 
 	/* Don't register boot CPU clockevent */
 	cpu = smp_processor_id();
-	if (cpu == boot_cpu_id)
+	if (!cpu)
 		return;
 	/*
 	 * We need to calculate the scaled math multiplication factor for
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4dc0084..8884928 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -162,7 +162,7 @@ int __init arch_early_irq_init(void)
 
 	cfg = irq_cfgx;
 	count = ARRAY_SIZE(irq_cfgx);
-	node= cpu_to_node(boot_cpu_id);
+	node = cpu_to_node(0);
 
 	for (i = 0; i < count; i++) {
 		desc = irq_to_desc(i);
@@ -1483,7 +1483,7 @@ static void __init setup_IO_APIC_irqs(void)
 	int notcon = 0;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
-	int node = cpu_to_node(boot_cpu_id);
+	int node = cpu_to_node(0);
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
@@ -1548,7 +1548,7 @@ static void __init setup_IO_APIC_irqs(void)
 void setup_IO_APIC_irq_extra(u32 gsi)
 {
 	int apic_id = 0, pin, idx, irq;
-	int node = cpu_to_node(boot_cpu_id);
+	int node = cpu_to_node(0);
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
 
@@ -2925,7 +2925,7 @@ static inline void __init check_timer(void)
 {
 	struct irq_desc *desc = irq_to_desc(0);
 	struct irq_cfg *cfg = desc->chip_data;
-	int node = cpu_to_node(boot_cpu_id);
+	int node = cpu_to_node(0);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
 	int no_pin1 = 0;
@@ -3279,7 +3279,7 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 
 int create_irq(void)
 {
-	int node = cpu_to_node(boot_cpu_id);
+	int node = cpu_to_node(0);
 	unsigned int irq_want;
 	int irq;
 
@@ -3901,7 +3901,7 @@ static int __io_apic_set_pci_routing(struct device *dev, int irq,
 	if (dev)
 		node = dev_to_node(dev);
 	else
-		node = cpu_to_node(boot_cpu_id);
+		node = cpu_to_node(0);
 
 	desc = irq_to_desc_alloc_node(irq, node);
 	if (!desc) {
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 60a57b1..3a7c852 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -148,7 +148,7 @@ static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
 	/* calling is from identify_secondary_cpu() ? */
-	if (c->cpu_index == boot_cpu_id)
+	if (!c->cpu_index)
 		return;
 
 	/*
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 490dac6..787b3c7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -665,7 +665,7 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 		this_cpu->c_early_init(c);
 
 #ifdef CONFIG_SMP
-	c->cpu_index = boot_cpu_id;
+	c->cpu_index = 0;
 #endif
 	filter_cpuid_features(c, false);
 }
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 85f69cd..3a683ea 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -169,7 +169,7 @@ static void __cpuinit intel_smp_check(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
 	/* calling is from identify_secondary_cpu() ? */
-	if (c->cpu_index == boot_cpu_id)
+	if (!c->cpu_index)
 		return;
 
 	/*
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index e3af342..7a4cf14 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -84,7 +84,7 @@ static int __init reboot_setup(char *str)
 			}
 				/* we will leave sorting out the final value
 				   when we are ready to reboot, since we might not
-				   have set up boot_cpu_id or smp_num_cpu */
+				   have detected BSP APIC ID or smp_num_cpu */
 			break;
 #endif /* CONFIG_SMP */
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b008e78..dede5c4 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -125,7 +125,6 @@ unsigned long max_pfn_mapped;
 RESERVE_BRK(dmi_alloc, 65536);
 #endif
 
-unsigned int boot_cpu_id __read_mostly;
 
 static __initdata unsigned long _brk_start = (unsigned long)__brk_base;
 unsigned long _brk_end = (unsigned long)__brk_base;
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index a60df9a..2335c15 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -253,7 +253,7 @@ void __init setup_per_cpu_areas(void)
 		 * Up to this point, the boot CPU has been using .init.data
 		 * area.  Reload any changed state for the boot CPU.
 		 */
-		if (cpu == boot_cpu_id)
+		if (!cpu)
 			switch_to_new_gdt(cpu);
 	}
 
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index 970ed57..240f864 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -54,8 +54,8 @@ static __init int find_northbridge(void)
 static __init void early_get_boot_cpu_id(void)
 {
 	/*
-	 * need to get boot_cpu_id so can use that to create apicid_to_node
-	 * in k8_scan_nodes()
+	 * need to get the APIC ID of the BSP so can use that to
+	 * create apicid_to_node in k8_scan_nodes()
 	 */
 #ifdef CONFIG_X86_MPPARSE
 	/*
@@ -212,7 +212,7 @@ int __init k8_scan_nodes(void)
 	bits = boot_cpu_data.x86_coreid_bits;
 	cores = (1<<bits);
 	apicid_base = 0;
-	/* need to get boot_cpu_id early for system with apicid lifting */
+	/* get the APIC ID of the BSP early for systems with apicid lifting */
 	early_get_boot_cpu_id();
 	if (boot_cpu_physical_apicid > 0) {
 		pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
