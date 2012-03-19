Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162212Ab2CSQqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:46:08 -0400
Received: from mail-we0-f194.google.com ([74.125.82.194]:54721 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030659Ab2CSQqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:46:05 -0400
Date: Mon, 19 Mar 2012 17:45:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/debug changes for v3.4
Message-ID: <20120319164556.GA11642@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-debug-for-linus

   HEAD: 943bc7e110f269f88dc92bbf249adbd384d35f1c x86: Fix section warnings


out-of-topic modifications in x86-debug-for-linus:
--------------------------------------------------
drivers/iommu/amd_iommu.c          # 943bc7e: x86: Fix section warnings

 Thanks,

	Ingo

------------------>
Jan Beulich (1):
      x86: Properly _init-annotate NMI selftest code

Mark Wielaard (1):
      x86-64: Fix CFI data for common_interrupt()

Steffen Persvold (1):
      x86: Fix section warnings

Yinghai Lu (1):
      x86/debug: Fix/improve the show_msr=<cpus> debug print out


 arch/x86/include/asm/processor.h |    1 +
 arch/x86/kernel/acpi/boot.c      |    2 +-
 arch/x86/kernel/cpu/common.c     |   14 +++++++-------
 arch/x86/kernel/entry_64.S       |    2 +-
 arch/x86/kernel/nmi_selftest.c   |   37 +++++++++++++++++++------------------
 arch/x86/kernel/smpboot.c        |    5 +++--
 drivers/iommu/amd_iommu.c        |    2 +-
 7 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index aa9088c..8bb062b 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -162,6 +162,7 @@ extern void early_cpu_init(void);
 extern void identify_boot_cpu(void);
 extern void identify_secondary_cpu(struct cpuinfo_x86 *);
 extern void print_cpu_info(struct cpuinfo_x86 *);
+void print_cpu_msr(struct cpuinfo_x86 *);
 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index ce664f3..406ed77 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -593,7 +593,7 @@ void __init acpi_set_irq_model_ioapic(void)
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 #include <acpi/processor.h>
 
-static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
+static void __cpuinitdata acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
 {
 #ifdef CONFIG_ACPI_NUMA
 	int nid;
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d43cad7..8b6a3bb 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -933,7 +933,7 @@ static const struct msr_range msr_range_array[] __cpuinitconst = {
 	{ 0xc0011000, 0xc001103b},
 };
 
-static void __cpuinit print_cpu_msr(void)
+static void __cpuinit __print_cpu_msr(void)
 {
 	unsigned index_min, index_max;
 	unsigned index;
@@ -997,13 +997,13 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 	else
 		printk(KERN_CONT "\n");
 
-#ifdef CONFIG_SMP
+	__print_cpu_msr();
+}
+
+void __cpuinit print_cpu_msr(struct cpuinfo_x86 *c)
+{
 	if (c->cpu_index < show_msr)
-		print_cpu_msr();
-#else
-	if (show_msr)
-		print_cpu_msr();
-#endif
+		__print_cpu_msr();
 }
 
 static __init int setup_disablecpuid(char *arg)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 3fe8239..54be36b 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -813,7 +813,7 @@ ret_from_intr:
 
 	/* Restore saved previous stack */
 	popq %rsi
-	CFI_DEF_CFA_REGISTER	rsi
+	CFI_DEF_CFA rsi,SS+8-RBP	/* reg/off reset after def_cfa_expr */
 	leaq ARGOFFSET-RBP(%rsi), %rsp
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET	RBP-ARGOFFSET
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index 0d01a8e..2c39dcd 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -12,6 +12,7 @@
 #include <linux/smp.h>
 #include <linux/cpumask.h>
 #include <linux/delay.h>
+#include <linux/init.h>
 
 #include <asm/apic.h>
 #include <asm/nmi.h>
@@ -20,35 +21,35 @@
 #define FAILURE		1
 #define TIMEOUT		2
 
-static int nmi_fail;
+static int __initdata nmi_fail;
 
 /* check to see if NMI IPIs work on this machine */
-static DECLARE_BITMAP(nmi_ipi_mask, NR_CPUS) __read_mostly;
+static DECLARE_BITMAP(nmi_ipi_mask, NR_CPUS) __initdata;
 
-static int testcase_total;
-static int testcase_successes;
-static int expected_testcase_failures;
-static int unexpected_testcase_failures;
-static int unexpected_testcase_unknowns;
+static int __initdata testcase_total;
+static int __initdata testcase_successes;
+static int __initdata expected_testcase_failures;
+static int __initdata unexpected_testcase_failures;
+static int __initdata unexpected_testcase_unknowns;
 
-static int nmi_unk_cb(unsigned int val, struct pt_regs *regs)
+static int __init nmi_unk_cb(unsigned int val, struct pt_regs *regs)
 {
 	unexpected_testcase_unknowns++;
 	return NMI_HANDLED;
 }
 
-static void init_nmi_testsuite(void)
+static void __init init_nmi_testsuite(void)
 {
 	/* trap all the unknown NMIs we may generate */
 	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk");
 }
 
-static void cleanup_nmi_testsuite(void)
+static void __init cleanup_nmi_testsuite(void)
 {
 	unregister_nmi_handler(NMI_UNKNOWN, "nmi_selftest_unk");
 }
 
-static int test_nmi_ipi_callback(unsigned int val, struct pt_regs *regs)
+static int __init test_nmi_ipi_callback(unsigned int val, struct pt_regs *regs)
 {
         int cpu = raw_smp_processor_id();
 
@@ -58,7 +59,7 @@ static int test_nmi_ipi_callback(unsigned int val, struct pt_regs *regs)
         return NMI_DONE;
 }
 
-static void test_nmi_ipi(struct cpumask *mask)
+static void __init test_nmi_ipi(struct cpumask *mask)
 {
 	unsigned long timeout;
 
@@ -86,7 +87,7 @@ static void test_nmi_ipi(struct cpumask *mask)
 	return;
 }
 
-static void remote_ipi(void)
+static void __init remote_ipi(void)
 {
 	cpumask_copy(to_cpumask(nmi_ipi_mask), cpu_online_mask);
 	cpumask_clear_cpu(smp_processor_id(), to_cpumask(nmi_ipi_mask));
@@ -94,19 +95,19 @@ static void remote_ipi(void)
 		test_nmi_ipi(to_cpumask(nmi_ipi_mask));
 }
 
-static void local_ipi(void)
+static void __init local_ipi(void)
 {
 	cpumask_clear(to_cpumask(nmi_ipi_mask));
 	cpumask_set_cpu(smp_processor_id(), to_cpumask(nmi_ipi_mask));
 	test_nmi_ipi(to_cpumask(nmi_ipi_mask));
 }
 
-static void reset_nmi(void)
+static void __init reset_nmi(void)
 {
 	nmi_fail = 0;
 }
 
-static void dotest(void (*testcase_fn)(void), int expected)
+static void __init dotest(void (*testcase_fn)(void), int expected)
 {
 	testcase_fn();
 	/*
@@ -131,12 +132,12 @@ static void dotest(void (*testcase_fn)(void), int expected)
 	reset_nmi();
 }
 
-static inline void print_testname(const char *testname)
+static inline void __init print_testname(const char *testname)
 {
 	printk("%12s:", testname);
 }
 
-void nmi_selftest(void)
+void __init nmi_selftest(void)
 {
 	init_nmi_testsuite();
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 66d250c..257049d 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -791,9 +791,10 @@ do_rest:
 			schedule();
 		}
 
-		if (cpumask_test_cpu(cpu, cpu_callin_mask))
+		if (cpumask_test_cpu(cpu, cpu_callin_mask)) {
+			print_cpu_msr(&cpu_data(cpu));
 			pr_debug("CPU%d: has booted.\n", cpu);
-		else {
+		} else {
 			boot_error = 1;
 			if (*(volatile u32 *)TRAMPOLINE_SYM(trampoline_status)
 			    == 0xA5A5A5A5)
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index f75e060..ae2ec92 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2804,7 +2804,7 @@ static int amd_iommu_dma_supported(struct device *dev, u64 mask)
  * we don't need to preallocate the protection domains anymore.
  * For now we have to.
  */
-static void prealloc_protection_domains(void)
+static void __init prealloc_protection_domains(void)
 {
 	struct iommu_dev_data *dev_data;
 	struct dma_ops_domain *dma_dom;
