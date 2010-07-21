Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab0GURWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:22:10 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:37390
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126Ab0GURV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:21:58 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L5X431-02-2Z9-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 7/7] x86: removing boot_cpu_id variable
Date: Wed, 21 Jul 2010 19:03:58 +0200
Message-ID: <1279731838-1522-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

boot_cpu_id is there for historical reasons and was renamed to
boot_cpu_physical_apicid in patch:

 c70dcb7 x86: change boot_cpu_id to boot_cpu_physical_apicid

However, there are some remaining occurrences of boot_cpu_id that are
never touched in the kernel and thus its value is always 0.

This patch removes boot_cpu_id at all.

Signed-off-by: Robert Richter <robert.richter@amd.com>
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
 arch/x86/kernel/setup_percpu.c   |    4 ++--
 arch/x86/mm/k8topology_64.c      |    6 +++---
 11 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/apb_timer.h b/arch/x86/include/asm/apb_timer.h
index c74a2ee..d15d185 100644
--- a/arch/x86/include/asm/apb_timer.h
+++ b/arch/x86/include/asm/apb_timer.h
@@ -54,7 +54,6 @@ extern struct clock_event_device *global_clock_event;
 extern unsigned long apbt_quick_calibrate(void);
 extern int arch_setup_apbt_irqs(int irq, int trigger, int mask, int cpu);
 extern void apbt_setup_secondary_clock(void);
-extern unsigned int boot_cpu_id;
 extern int disable_apbt_percpu;
 
 extern struct sfi_timer_table_entry *sfi_get_mtmr(int hint);
diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index b185091..4fab24d 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -32,6 +32,5 @@ extern void arch_unregister_cpu(int);
 
 DECLARE_PER_CPU(int, cpu_state);
 
-extern unsigned int boot_cpu_id;
 
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index a353475..8e5b862 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -367,7 +367,7 @@ void apbt_setup_secondary_clock(void)
 
 	/* Don't register boot CPU clockevent */
 	cpu = smp_processor_id();
-	if (cpu == boot_cpu_id)
+	if (!cpu)
 		return;
 	/*
 	 * We need to calculate the scaled math multiplication factor for
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 33f3563..6b7c1df 100644
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
index 12b9cff..2eb3a89 100644
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
index 94c36c7..0b64950 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -664,7 +664,7 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
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
index 8e1aac8..31c8c36 100644
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
index b4ae4ac..7b2a713 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -124,7 +124,6 @@ unsigned long max_pfn_mapped;
 RESERVE_BRK(dmi_alloc, 65536);
 #endif
 
-unsigned int boot_cpu_id __read_mostly;
 
 static __initdata unsigned long _brk_start = (unsigned long)__brk_base;
 unsigned long _brk_end = (unsigned long)__brk_base;
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index de3b63a..7260dc4 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -244,7 +244,7 @@ void __init setup_per_cpu_areas(void)
 		 * Up to this point, the boot CPU has been using .init.data
 		 * area.  Reload any changed state for the boot CPU.
 		 */
-		if (cpu == boot_cpu_id)
+		if (!cpu)
 			switch_to_new_gdt(cpu);
 	}
 
@@ -262,7 +262,7 @@ void __init setup_per_cpu_areas(void)
 	 * make sure boot cpu numa_node is right, when boot cpu is on the
 	 * node that doesn't have mem installed
 	 */
-	set_cpu_numa_node(boot_cpu_id, early_cpu_to_node(boot_cpu_id));
+	set_cpu_numa_node(0, early_cpu_to_node(0));
 #endif
 
 	/* Setup node to cpumask map */
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
-- 
1.7.1.1


