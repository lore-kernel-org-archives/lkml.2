Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956Ab1DPKL4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 06:11:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56476 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688Ab1DPKLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 06:11:49 -0400
Date: Sat, 16 Apr 2011 12:11:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110416101135.GA10889@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Jacob Pan (1):
      x86/mrst: Fix boot crash caused by incorrect pin to irq mapping

Joerg Roedel (1):
      x86, amd: Disable GartTlbWlkErr when BIOS forgets it

KOSAKI Motohiro (1):
      x86, NUMA: Fix fakenuma boot failure

Sebastian Andrzej Siewior (1):
      x86/ce4100: Add reg property to bridges


 arch/x86/include/asm/msr-index.h         |    4 ++++
 arch/x86/kernel/cpu/amd.c                |   19 +++++++++++++++++++
 arch/x86/kernel/smpboot.c                |   23 +++++++++++++++++++++++
 arch/x86/platform/ce4100/falconfalls.dts |    2 ++
 arch/x86/platform/mrst/mrst.c            |   10 +++++-----
 5 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index fd5a1f3..3cce714 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -96,11 +96,15 @@
 #define MSR_IA32_MC0_ADDR		0x00000402
 #define MSR_IA32_MC0_MISC		0x00000403
 
+#define MSR_AMD64_MC0_MASK		0xc0010044
+
 #define MSR_IA32_MCx_CTL(x)		(MSR_IA32_MC0_CTL + 4*(x))
 #define MSR_IA32_MCx_STATUS(x)		(MSR_IA32_MC0_STATUS + 4*(x))
 #define MSR_IA32_MCx_ADDR(x)		(MSR_IA32_MC0_ADDR + 4*(x))
 #define MSR_IA32_MCx_MISC(x)		(MSR_IA32_MC0_MISC + 4*(x))
 
+#define MSR_AMD64_MCx_MASK(x)		(MSR_AMD64_MC0_MASK + (x))
+
 /* These are consecutive and not in the normal 4er MCE bank block */
 #define MSR_IA32_MC0_CTL2		0x00000280
 #define MSR_IA32_MCx_CTL2(x)		(MSR_IA32_MC0_CTL2 + (x))
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 3ecece0..3532d3b 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -615,6 +615,25 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	/* As a rule processors have APIC timer running in deep C states */
 	if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
 		set_cpu_cap(c, X86_FEATURE_ARAT);
+
+	/*
+	 * Disable GART TLB Walk Errors on Fam10h. We do this here
+	 * because this is always needed when GART is enabled, even in a
+	 * kernel which has no MCE support built in.
+	 */
+	if (c->x86 == 0x10) {
+		/*
+		 * BIOS should disable GartTlbWlk Errors themself. If
+		 * it doesn't do it here as suggested by the BKDG.
+		 *
+		 * Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=33012
+		 */
+		u64 mask;
+
+		rdmsrl(MSR_AMD64_MCx_MASK(4), mask);
+		mask |= (1 << 10);
+		wrmsrl(MSR_AMD64_MCx_MASK(4), mask);
+	}
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c2871d3..8ed8908 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -312,6 +312,26 @@ void __cpuinit smp_store_cpu_info(int id)
 		identify_secondary_cpu(c);
 }
 
+static void __cpuinit check_cpu_siblings_on_same_node(int cpu1, int cpu2)
+{
+	int node1 = early_cpu_to_node(cpu1);
+	int node2 = early_cpu_to_node(cpu2);
+
+	/*
+	 * Our CPU scheduler assumes all logical cpus in the same physical cpu
+	 * share the same node. But, buggy ACPI or NUMA emulation might assign
+	 * them to different node. Fix it.
+	 */
+	if (node1 != node2) {
+		pr_warning("CPU %d in node %d and CPU %d in node %d are in the same physical CPU. forcing same node %d\n",
+			   cpu1, node1, cpu2, node2, node2);
+
+		numa_remove_cpu(cpu1);
+		numa_set_node(cpu1, node2);
+		numa_add_cpu(cpu1);
+	}
+}
+
 static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
 {
 	cpumask_set_cpu(cpu1, cpu_sibling_mask(cpu2));
@@ -320,6 +340,7 @@ static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
 	cpumask_set_cpu(cpu2, cpu_core_mask(cpu1));
 	cpumask_set_cpu(cpu1, cpu_llc_shared_mask(cpu2));
 	cpumask_set_cpu(cpu2, cpu_llc_shared_mask(cpu1));
+	check_cpu_siblings_on_same_node(cpu1, cpu2);
 }
 
 
@@ -361,10 +382,12 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
 			cpumask_set_cpu(i, cpu_llc_shared_mask(cpu));
 			cpumask_set_cpu(cpu, cpu_llc_shared_mask(i));
+			check_cpu_siblings_on_same_node(cpu, i);
 		}
 		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
 			cpumask_set_cpu(i, cpu_core_mask(cpu));
 			cpumask_set_cpu(cpu, cpu_core_mask(i));
+			check_cpu_siblings_on_same_node(cpu, i);
 			/*
 			 *  Does this new cpu bringup a new core?
 			 */
diff --git a/arch/x86/platform/ce4100/falconfalls.dts b/arch/x86/platform/ce4100/falconfalls.dts
index dc701ea..2d6d226 100644
--- a/arch/x86/platform/ce4100/falconfalls.dts
+++ b/arch/x86/platform/ce4100/falconfalls.dts
@@ -74,6 +74,7 @@
 				compatible = "intel,ce4100-pci", "pci";
 				device_type = "pci";
 				bus-range = <1 1>;
+				reg = <0x0800 0x0 0x0 0x0 0x0>;
 				ranges = <0x2000000 0 0xdffe0000 0x2000000 0 0xdffe0000 0 0x1000>;
 
 				interrupt-parent = <&ioapic2>;
@@ -412,6 +413,7 @@
 				#address-cells = <2>;
 				#size-cells = <1>;
 				compatible = "isa";
+				reg = <0xf800 0x0 0x0 0x0 0x0>;
 				ranges = <1 0 0 0 0 0x100>;
 
 				rtc@70 {
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 5c0207b..275dbc1 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -97,11 +97,11 @@ static int __init sfi_parse_mtmr(struct sfi_table_header *table)
 			pentry->freq_hz, pentry->irq);
 			if (!pentry->irq)
 				continue;
-			mp_irq.type = MP_IOAPIC;
+			mp_irq.type = MP_INTSRC;
 			mp_irq.irqtype = mp_INT;
 /* triggering mode edge bit 2-3, active high polarity bit 0-1 */
 			mp_irq.irqflag = 5;
-			mp_irq.srcbus = 0;
+			mp_irq.srcbus = MP_BUS_ISA;
 			mp_irq.srcbusirq = pentry->irq;	/* IRQ */
 			mp_irq.dstapic = MP_APIC_ALL;
 			mp_irq.dstirq = pentry->irq;
@@ -168,10 +168,10 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
 	for (totallen = 0; totallen < sfi_mrtc_num; totallen++, pentry++) {
 		pr_debug("RTC[%d]: paddr = 0x%08x, irq = %d\n",
 			totallen, (u32)pentry->phys_addr, pentry->irq);
-		mp_irq.type = MP_IOAPIC;
+		mp_irq.type = MP_INTSRC;
 		mp_irq.irqtype = mp_INT;
 		mp_irq.irqflag = 0xf;	/* level trigger and active low */
-		mp_irq.srcbus = 0;
+		mp_irq.srcbus = MP_BUS_ISA;
 		mp_irq.srcbusirq = pentry->irq;	/* IRQ */
 		mp_irq.dstapic = MP_APIC_ALL;
 		mp_irq.dstirq = pentry->irq;
@@ -282,7 +282,7 @@ void __init x86_mrst_early_setup(void)
 	/* Avoid searching for BIOS MP tables */
 	x86_init.mpparse.find_smp_config = x86_init_noop;
 	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
-
+	set_bit(MP_BUS_ISA, mp_bus_not_pci);
 }
 
 /*
