Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab0JUNQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:16:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50671 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab0JUNQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:16:48 -0400
Date: Thu, 21 Oct 2010 15:16:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 AMD northbridge changes for v2.6.37
Message-ID: <20101021131633.GA2800@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the x86 AMD northbridge git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-amd-nb-for-linus


out-of-topic modifications in x86-amd-nb-for-linus:
---------------------------------------------------
drivers/char/agp/Kconfig           # 23ac4ae: x86, k8: Rename k8.[ch] to amd_nb
drivers/char/agp/amd64-agp.c       # 23ac4ae: x86, k8: Rename k8.[ch] to amd_nb
                                   # 900f9ac: x86, k8-gart: Decouple handling o
drivers/edac/Kconfig               # 23ac4ae: x86, k8: Rename k8.[ch] to amd_nb
drivers/edac/amd64_edac.c          # 23ac4ae: x86, k8: Rename k8.[ch] to amd_nb
                                   # 900f9ac: x86, k8-gart: Decouple handling o
include/linux/pci_ids.h            # 5c80cc7: x86, amd_nb: Enable GART support 

 Thanks,

	Ingo

------------------>
Andre Przywara (4):
      x86, cpu: Fix renamed, not-yet-shipping AMD CPUID feature bit
      x86, cpu: Update AMD CPUID feature bits
      x86, cpu: Fix allowed CPUID bits for KVM guests
      x86, kvm: add new AMD SVM feature bits

Andreas Herrmann (10):
      x86, AMD: Remove needless CPU family check (for L3 cache info)
      x86, cacheinfo: Fix dependency of AMD L3 CID
      x86, k8-gart: Decouple handling of garts and northbridges
      x86, k8: Rename k8.[ch] to amd_nb.[ch] and CONFIG_K8_NB to CONFIG_AMD_NB
      x86, mtrr: Assume SYS_CFG[Tom2ForceMemTypeWB] exists on all future AMD CPUs
      x86, nmi: Support NMI watchdog on newer AMD CPU families
      x86, amd: Add support for CPUID topology extension of AMD CPUs
      x86, amd: Extract compute unit information for AMD CPUs
      x86, amd: Use compute unit information to determine thread siblings
      x86, amd_nb: Enable GART support for AMD family 0x15 CPUs

Borislav Petkov (1):
      x86, tsc: Remove CPU frequency calibration on AMD


 arch/x86/Kconfig                        |    4 +-
 arch/x86/include/asm/{k8.h => amd_nb.h} |   21 +++++----
 arch/x86/include/asm/cpufeature.h       |   13 +++++-
 arch/x86/include/asm/processor.h        |    2 +
 arch/x86/kernel/Makefile                |    2 +-
 arch/x86/kernel/{k8.c => amd_nb.c}      |   56 +++++++++++++---------
 arch/x86/kernel/aperture_64.c           |    2 +-
 arch/x86/kernel/cpu/amd.c               |   75 +++++++++++++++++++++---------
 arch/x86/kernel/cpu/intel_cacheinfo.c   |   14 +++---
 arch/x86/kernel/cpu/mtrr/cleanup.c      |    2 +-
 arch/x86/kernel/cpu/perfctr-watchdog.c  |    9 ++--
 arch/x86/kernel/cpu/scattered.c         |    6 +++
 arch/x86/kernel/pci-gart_64.c           |   29 ++++++++----
 arch/x86/kernel/setup.c                 |    2 +-
 arch/x86/kernel/smpboot.c               |   28 ++++++++---
 arch/x86/kernel/tsc.c                   |   58 ------------------------
 arch/x86/kvm/x86.c                      |    7 ++-
 arch/x86/mm/k8topology_64.c             |    2 +-
 arch/x86/mm/numa_64.c                   |    2 +-
 drivers/char/agp/Kconfig                |    2 +-
 drivers/char/agp/amd64-agp.c            |   35 ++++++++++-----
 drivers/edac/Kconfig                    |    2 +-
 drivers/edac/amd64_edac.c               |    4 +-
 include/linux/pci_ids.h                 |    1 +
 24 files changed, 208 insertions(+), 170 deletions(-)
 rename arch/x86/include/asm/{k8.h => amd_nb.h} (61%)
 rename arch/x86/kernel/{k8.c => amd_nb.c} (66%)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..7fd41f0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -670,7 +670,7 @@ config GART_IOMMU
 	bool "GART IOMMU support" if EMBEDDED
 	default y
 	select SWIOTLB
-	depends on X86_64 && PCI && K8_NB
+	depends on X86_64 && PCI && AMD_NB
 	---help---
 	  Support for full DMA access of devices with 32bit memory access only
 	  on systems with more than 3GB. This is usually needed for USB,
@@ -2076,7 +2076,7 @@ config OLPC_OPENFIRMWARE
 
 endif # X86_32
 
-config K8_NB
+config AMD_NB
 	def_bool y
 	depends on CPU_SUP_AMD && PCI
 
diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/amd_nb.h
similarity index 61%
rename from arch/x86/include/asm/k8.h
rename to arch/x86/include/asm/amd_nb.h
index af00bd1..c8517f8 100644
--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_X86_K8_H
-#define _ASM_X86_K8_H
+#ifndef _ASM_X86_AMD_NB_H
+#define _ASM_X86_AMD_NB_H
 
 #include <linux/pci.h>
 
@@ -7,24 +7,27 @@ extern struct pci_device_id k8_nb_ids[];
 struct bootnode;
 
 extern int early_is_k8_nb(u32 value);
-extern struct pci_dev **k8_northbridges;
-extern int num_k8_northbridges;
 extern int cache_k8_northbridges(void);
 extern void k8_flush_garts(void);
 extern int k8_get_nodes(struct bootnode *nodes);
 extern int k8_numa_init(unsigned long start_pfn, unsigned long end_pfn);
 extern int k8_scan_nodes(void);
 
-#ifdef CONFIG_K8_NB
-extern int num_k8_northbridges;
+struct k8_northbridge_info {
+	u16 num;
+	u8 gart_supported;
+	struct pci_dev **nb_misc;
+};
+extern struct k8_northbridge_info k8_northbridges;
+
+#ifdef CONFIG_AMD_NB
 
 static inline struct pci_dev *node_to_k8_nb_misc(int node)
 {
-	return (node < num_k8_northbridges) ? k8_northbridges[node] : NULL;
+	return (node < k8_northbridges.num) ? k8_northbridges.nb_misc[node] : NULL;
 }
 
 #else
-#define num_k8_northbridges 0
 
 static inline struct pci_dev *node_to_k8_nb_misc(int node)
 {
@@ -33,4 +36,4 @@ static inline struct pci_dev *node_to_k8_nb_misc(int node)
 #endif
 
 
-#endif /* _ASM_X86_K8_H */
+#endif /* _ASM_X86_AMD_NB_H */
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index c6fbb7b..0450a28 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -152,10 +152,14 @@
 #define X86_FEATURE_3DNOWPREFETCH (6*32+ 8) /* 3DNow prefetch instructions */
 #define X86_FEATURE_OSVW	(6*32+ 9) /* OS Visible Workaround */
 #define X86_FEATURE_IBS		(6*32+10) /* Instruction Based Sampling */
-#define X86_FEATURE_SSE5	(6*32+11) /* SSE-5 */
+#define X86_FEATURE_XOP		(6*32+11) /* extended AVX instructions */
 #define X86_FEATURE_SKINIT	(6*32+12) /* SKINIT/STGI instructions */
 #define X86_FEATURE_WDT		(6*32+13) /* Watchdog timer */
+#define X86_FEATURE_LWP		(6*32+15) /* Light Weight Profiling */
+#define X86_FEATURE_FMA4	(6*32+16) /* 4 operands MAC instructions */
 #define X86_FEATURE_NODEID_MSR	(6*32+19) /* NodeId MSR */
+#define X86_FEATURE_TBM		(6*32+21) /* trailing bit manipulations */
+#define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
@@ -179,6 +183,13 @@
 #define X86_FEATURE_LBRV	(8*32+ 6) /* AMD LBR Virtualization support */
 #define X86_FEATURE_SVML	(8*32+ 7) /* "svm_lock" AMD SVM locking MSR */
 #define X86_FEATURE_NRIPS	(8*32+ 8) /* "nrip_save" AMD SVM next_rip save */
+#define X86_FEATURE_TSCRATEMSR  (8*32+ 9) /* "tsc_scale" AMD TSC scaling support */
+#define X86_FEATURE_VMCBCLEAN   (8*32+10) /* "vmcb_clean" AMD VMCB clean bits support */
+#define X86_FEATURE_FLUSHBYASID (8*32+11) /* AMD flush-by-ASID support */
+#define X86_FEATURE_DECODEASSISTS (8*32+12) /* AMD Decode Assists support */
+#define X86_FEATURE_PAUSEFILTER (8*32+13) /* AMD filtered pause intercept */
+#define X86_FEATURE_PFTHRESHOLD (8*32+14) /* AMD pause filter threshold */
+
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ebx), word 9 */
 #define X86_FEATURE_FSGSBASE	(9*32+ 0) /* {RD/WR}{FS/GS}BASE instructions*/
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 325b7bd..69e80c2 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -110,6 +110,8 @@ struct cpuinfo_x86 {
 	u16			phys_proc_id;
 	/* Core id: */
 	u16			cpu_core_id;
+	/* Compute unit id */
+	u8			compute_unit_id;
 	/* Index into per_cpu list: */
 	u16			cpu_index;
 #endif
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0925676..25dc82d 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -87,7 +87,7 @@ obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_APB_TIMER)		+= apb_timer.o
 
-obj-$(CONFIG_K8_NB)		+= k8.o
+obj-$(CONFIG_AMD_NB)		+= amd_nb.o
 obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
 obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
 
diff --git a/arch/x86/kernel/k8.c b/arch/x86/kernel/amd_nb.c
similarity index 66%
rename from arch/x86/kernel/k8.c
rename to arch/x86/kernel/amd_nb.c
index 0f7bc20..8f6463d 100644
--- a/arch/x86/kernel/k8.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -8,21 +8,19 @@
 #include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <asm/k8.h>
-
-int num_k8_northbridges;
-EXPORT_SYMBOL(num_k8_northbridges);
+#include <asm/amd_nb.h>
 
 static u32 *flush_words;
 
 struct pci_device_id k8_nb_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_MISC) },
 	{}
 };
 EXPORT_SYMBOL(k8_nb_ids);
 
-struct pci_dev **k8_northbridges;
+struct k8_northbridge_info k8_northbridges;
 EXPORT_SYMBOL(k8_northbridges);
 
 static struct pci_dev *next_k8_northbridge(struct pci_dev *dev)
@@ -40,36 +38,45 @@ int cache_k8_northbridges(void)
 	int i;
 	struct pci_dev *dev;
 
-	if (num_k8_northbridges)
+	if (k8_northbridges.num)
 		return 0;
 
 	dev = NULL;
 	while ((dev = next_k8_northbridge(dev)) != NULL)
-		num_k8_northbridges++;
+		k8_northbridges.num++;
+
+	/* some CPU families (e.g. family 0x11) do not support GART */
+	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
+	    boot_cpu_data.x86 == 0x15)
+		k8_northbridges.gart_supported = 1;
 
-	k8_northbridges = kmalloc((num_k8_northbridges + 1) * sizeof(void *),
-				  GFP_KERNEL);
-	if (!k8_northbridges)
+	k8_northbridges.nb_misc = kmalloc((k8_northbridges.num + 1) *
+					  sizeof(void *), GFP_KERNEL);
+	if (!k8_northbridges.nb_misc)
 		return -ENOMEM;
 
-	if (!num_k8_northbridges) {
-		k8_northbridges[0] = NULL;
+	if (!k8_northbridges.num) {
+		k8_northbridges.nb_misc[0] = NULL;
 		return 0;
 	}
 
-	flush_words = kmalloc(num_k8_northbridges * sizeof(u32), GFP_KERNEL);
-	if (!flush_words) {
-		kfree(k8_northbridges);
-		return -ENOMEM;
+	if (k8_northbridges.gart_supported) {
+		flush_words = kmalloc(k8_northbridges.num * sizeof(u32),
+				      GFP_KERNEL);
+		if (!flush_words) {
+			kfree(k8_northbridges.nb_misc);
+			return -ENOMEM;
+		}
 	}
 
 	dev = NULL;
 	i = 0;
 	while ((dev = next_k8_northbridge(dev)) != NULL) {
-		k8_northbridges[i] = dev;
-		pci_read_config_dword(dev, 0x9c, &flush_words[i++]);
+		k8_northbridges.nb_misc[i] = dev;
+		if (k8_northbridges.gart_supported)
+			pci_read_config_dword(dev, 0x9c, &flush_words[i++]);
 	}
-	k8_northbridges[i] = NULL;
+	k8_northbridges.nb_misc[i] = NULL;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(cache_k8_northbridges);
@@ -93,22 +100,25 @@ void k8_flush_garts(void)
 	unsigned long flags;
 	static DEFINE_SPINLOCK(gart_lock);
 
+	if (!k8_northbridges.gart_supported)
+		return;
+
 	/* Avoid races between AGP and IOMMU. In theory it's not needed
 	   but I'm not sure if the hardware won't lose flush requests
 	   when another is pending. This whole thing is so expensive anyways
 	   that it doesn't matter to serialize more. -AK */
 	spin_lock_irqsave(&gart_lock, flags);
 	flushed = 0;
-	for (i = 0; i < num_k8_northbridges; i++) {
-		pci_write_config_dword(k8_northbridges[i], 0x9c,
+	for (i = 0; i < k8_northbridges.num; i++) {
+		pci_write_config_dword(k8_northbridges.nb_misc[i], 0x9c,
 				       flush_words[i]|1);
 		flushed++;
 	}
-	for (i = 0; i < num_k8_northbridges; i++) {
+	for (i = 0; i < k8_northbridges.num; i++) {
 		u32 w;
 		/* Make sure the hardware actually executed the flush*/
 		for (;;) {
-			pci_read_config_dword(k8_northbridges[i],
+			pci_read_config_dword(k8_northbridges.nb_misc[i],
 					      0x9c, &w);
 			if (!(w & 1))
 				break;
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index a2e0caf..e91e042 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -27,7 +27,7 @@
 #include <asm/gart.h>
 #include <asm/pci-direct.h>
 #include <asm/dma.h>
-#include <asm/k8.h>
+#include <asm/amd_nb.h>
 #include <asm/x86_init.h>
 
 int gart_iommu_aperture;
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ba5f62f..70168ab 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -253,37 +253,51 @@ static int __cpuinit nearby_node(int apicid)
 #endif
 
 /*
- * Fixup core topology information for AMD multi-node processors.
- * Assumption: Number of cores in each internal node is the same.
+ * Fixup core topology information for
+ * (1) AMD multi-node processors
+ *     Assumption: Number of cores in each internal node is the same.
+ * (2) AMD processors supporting compute units
  */
 #ifdef CONFIG_X86_HT
-static void __cpuinit amd_fixup_dcm(struct cpuinfo_x86 *c)
+static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 {
-	unsigned long long value;
-	u32 nodes, cores_per_node;
+	u32 nodes;
+	u8 node_id;
 	int cpu = smp_processor_id();
 
-	if (!cpu_has(c, X86_FEATURE_NODEID_MSR))
-		return;
+	/* get information required for multi-node processors */
+	if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
+		u32 eax, ebx, ecx, edx;
 
-	/* fixup topology information only once for a core */
-	if (cpu_has(c, X86_FEATURE_AMD_DCM))
-		return;
+		cpuid(0x8000001e, &eax, &ebx, &ecx, &edx);
+		nodes = ((ecx >> 8) & 7) + 1;
+		node_id = ecx & 7;
 
-	rdmsrl(MSR_FAM10H_NODE_ID, value);
+		/* get compute unit information */
+		smp_num_siblings = ((ebx >> 8) & 3) + 1;
+		c->compute_unit_id = ebx & 0xff;
+	} else if (cpu_has(c, X86_FEATURE_NODEID_MSR)) {
+		u64 value;
 
-	nodes = ((value >> 3) & 7) + 1;
-	if (nodes == 1)
+		rdmsrl(MSR_FAM10H_NODE_ID, value);
+		nodes = ((value >> 3) & 7) + 1;
+		node_id = value & 7;
+	} else
 		return;
 
-	set_cpu_cap(c, X86_FEATURE_AMD_DCM);
-	cores_per_node = c->x86_max_cores / nodes;
+	/* fixup multi-node processor information */
+	if (nodes > 1) {
+		u32 cores_per_node;
+
+		set_cpu_cap(c, X86_FEATURE_AMD_DCM);
+		cores_per_node = c->x86_max_cores / nodes;
 
-	/* store NodeID, use llc_shared_map to store sibling info */
-	per_cpu(cpu_llc_id, cpu) = value & 7;
+		/* store NodeID, use llc_shared_map to store sibling info */
+		per_cpu(cpu_llc_id, cpu) = node_id;
 
-	/* fixup core id to be in range from 0 to (cores_per_node - 1) */
-	c->cpu_core_id = c->cpu_core_id % cores_per_node;
+		/* core id to be in range from 0 to (cores_per_node - 1) */
+		c->cpu_core_id = c->cpu_core_id % cores_per_node;
+	}
 }
 #endif
 
@@ -304,9 +318,7 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 	c->phys_proc_id = c->initial_apicid >> bits;
 	/* use socket ID also for last level cache */
 	per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
-	/* fixup topology information on multi-node processors */
-	if ((c->x86 == 0x10) && (c->x86_model == 9))
-		amd_fixup_dcm(c);
+	amd_get_topology(c);
 #endif
 }
 
@@ -412,6 +424,23 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
 	}
 #endif
+
+	/* We need to do the following only once */
+	if (c != &boot_cpu_data)
+		return;
+
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
+
+		if (c->x86 > 0x10 ||
+		    (c->x86 == 0x10 && c->x86_model >= 0x2)) {
+			u64 val;
+
+			rdmsrl(MSR_K7_HWCR, val);
+			if (!(val & BIT(24)))
+				printk(KERN_WARNING FW_BUG "TSC doesn't count "
+					"with P0 frequency!\n");
+		}
+	}
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
@@ -523,7 +552,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 #endif
 
 	if (c->extended_cpuid_level >= 0x80000006) {
-		if ((c->x86 >= 0x0f) && (cpuid_edx(0x80000006) & 0xf000))
+		if (cpuid_edx(0x80000006) & 0xf000)
 			num_cache_leaves = 4;
 		else
 			num_cache_leaves = 3;
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 898c2f4..12cd823 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -17,7 +17,7 @@
 
 #include <asm/processor.h>
 #include <linux/smp.h>
-#include <asm/k8.h>
+#include <asm/amd_nb.h>
 #include <asm/smp.h>
 
 #define LVL_1_INST	1
@@ -306,7 +306,7 @@ struct _cache_attr {
 	ssize_t (*store)(struct _cpuid4_info *, const char *, size_t count);
 };
 
-#ifdef CONFIG_CPU_SUP_AMD
+#ifdef CONFIG_AMD_NB
 
 /*
  * L3 cache descriptors
@@ -369,7 +369,7 @@ static void __cpuinit amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf,
 			return;
 
 	/* not in virtualized environments */
-	if (num_k8_northbridges == 0)
+	if (k8_northbridges.num == 0)
 		return;
 
 	/*
@@ -377,7 +377,7 @@ static void __cpuinit amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf,
 	 * never freed but this is done only on shutdown so it doesn't matter.
 	 */
 	if (!l3_caches) {
-		int size = num_k8_northbridges * sizeof(struct amd_l3_cache *);
+		int size = k8_northbridges.num * sizeof(struct amd_l3_cache *);
 
 		l3_caches = kzalloc(size, GFP_ATOMIC);
 		if (!l3_caches)
@@ -556,12 +556,12 @@ static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
 static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
 		show_cache_disable_1, store_cache_disable_1);
 
-#else	/* CONFIG_CPU_SUP_AMD */
+#else	/* CONFIG_AMD_NB */
 static void __cpuinit
 amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf, int index)
 {
 };
-#endif /* CONFIG_CPU_SUP_AMD */
+#endif /* CONFIG_AMD_NB */
 
 static int
 __cpuinit cpuid4_cache_lookup_regs(int index,
@@ -1000,7 +1000,7 @@ static struct attribute *default_attrs[] = {
 
 static struct attribute *default_l3_attrs[] = {
 	DEFAULT_SYSFS_CACHE_ATTRS,
-#ifdef CONFIG_CPU_SUP_AMD
+#ifdef CONFIG_AMD_NB
 	&cache_disable_0.attr,
 	&cache_disable_1.attr,
 #endif
diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index c5f59d0..ac140c7 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -827,7 +827,7 @@ int __init amd_special_default_mtrr(void)
 
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
 		return 0;
-	if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
+	if (boot_cpu_data.x86 < 0xf)
 		return 0;
 	/* In case some hypervisor doesn't pass SYSCFG through: */
 	if (rdmsr_safe(MSR_K8_SYSCFG, &l, &h) < 0)
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index fb329e9..d9f4ff8 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -700,11 +700,10 @@ static void probe_nmi_watchdog(void)
 {
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
-		if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 != 15 &&
-		    boot_cpu_data.x86 != 16 && boot_cpu_data.x86 != 17)
-			return;
-		wd_ops = &k7_wd_ops;
-		break;
+		if (boot_cpu_data.x86 == 6 ||
+		    (boot_cpu_data.x86 >= 0xf && boot_cpu_data.x86 <= 0x15))
+			wd_ops = &k7_wd_ops;
+		return;
 	case X86_VENDOR_INTEL:
 		/* Work around where perfctr1 doesn't have a working enable
 		 * bit as described in the following errata:
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 34b4dad..2c77931 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -43,6 +43,12 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0x8000000a, 0 },
 		{ X86_FEATURE_SVML,		CR_EDX, 2, 0x8000000a, 0 },
 		{ X86_FEATURE_NRIPS,		CR_EDX, 3, 0x8000000a, 0 },
+		{ X86_FEATURE_TSCRATEMSR,	CR_EDX, 4, 0x8000000a, 0 },
+		{ X86_FEATURE_VMCBCLEAN,	CR_EDX, 5, 0x8000000a, 0 },
+		{ X86_FEATURE_FLUSHBYASID,	CR_EDX, 6, 0x8000000a, 0 },
+		{ X86_FEATURE_DECODEASSISTS,	CR_EDX, 7, 0x8000000a, 0 },
+		{ X86_FEATURE_PAUSEFILTER,	CR_EDX,10, 0x8000000a, 0 },
+		{ X86_FEATURE_PFTHRESHOLD,	CR_EDX,12, 0x8000000a, 0 },
 		{ 0, 0, 0, 0, 0 }
 	};
 
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 0f7f130..67e5665 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -39,7 +39,7 @@
 #include <asm/cacheflush.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
-#include <asm/k8.h>
+#include <asm/amd_nb.h>
 #include <asm/x86_init.h>
 
 static unsigned long iommu_bus_base;	/* GART remapping area (physical) */
@@ -560,8 +560,11 @@ static void enable_gart_translations(void)
 {
 	int i;
 
-	for (i = 0; i < num_k8_northbridges; i++) {
-		struct pci_dev *dev = k8_northbridges[i];
+	if (!k8_northbridges.gart_supported)
+		return;
+
+	for (i = 0; i < k8_northbridges.num; i++) {
+		struct pci_dev *dev = k8_northbridges.nb_misc[i];
 
 		enable_gart_translation(dev, __pa(agp_gatt_table));
 	}
@@ -592,10 +595,13 @@ static void gart_fixup_northbridges(struct sys_device *dev)
 	if (!fix_up_north_bridges)
 		return;
 
+	if (!k8_northbridges.gart_supported)
+		return;
+
 	pr_info("PCI-DMA: Restoring GART aperture settings\n");
 
-	for (i = 0; i < num_k8_northbridges; i++) {
-		struct pci_dev *dev = k8_northbridges[i];
+	for (i = 0; i < k8_northbridges.num; i++) {
+		struct pci_dev *dev = k8_northbridges.nb_misc[i];
 
 		/*
 		 * Don't enable translations just yet.  That is the next
@@ -649,8 +655,8 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 
 	aper_size = aper_base = info->aper_size = 0;
 	dev = NULL;
-	for (i = 0; i < num_k8_northbridges; i++) {
-		dev = k8_northbridges[i];
+	for (i = 0; i < k8_northbridges.num; i++) {
+		dev = k8_northbridges.nb_misc[i];
 		new_aper_base = read_aperture(dev, &new_aper_size);
 		if (!new_aper_base)
 			goto nommu;
@@ -718,10 +724,13 @@ static void gart_iommu_shutdown(void)
 	if (!no_agp)
 		return;
 
-	for (i = 0; i < num_k8_northbridges; i++) {
+	if (!k8_northbridges.gart_supported)
+		return;
+
+	for (i = 0; i < k8_northbridges.num; i++) {
 		u32 ctl;
 
-		dev = k8_northbridges[i];
+		dev = k8_northbridges.nb_misc[i];
 		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
 
 		ctl &= ~GARTEN;
@@ -739,7 +748,7 @@ int __init gart_iommu_init(void)
 	unsigned long scratch;
 	long i;
 
-	if (num_k8_northbridges == 0)
+	if (!k8_northbridges.gart_supported)
 		return 0;
 
 #ifndef CONFIG_AGP_AMD64
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c3a4fbb..77eea03 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -107,7 +107,7 @@
 #include <asm/percpu.h>
 #include <asm/topology.h>
 #include <asm/apicdef.h>
-#include <asm/k8.h>
+#include <asm/amd_nb.h>
 #ifdef CONFIG_X86_64
 #include <asm/numa_64.h>
 #endif
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 8b3bfc4..bc2cc44 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -397,6 +397,19 @@ void __cpuinit smp_store_cpu_info(int id)
 		identify_secondary_cpu(c);
 }
 
+static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
+{
+	struct cpuinfo_x86 *c1 = &cpu_data(cpu1);
+	struct cpuinfo_x86 *c2 = &cpu_data(cpu2);
+
+	cpumask_set_cpu(cpu1, cpu_sibling_mask(cpu2));
+	cpumask_set_cpu(cpu2, cpu_sibling_mask(cpu1));
+	cpumask_set_cpu(cpu1, cpu_core_mask(cpu2));
+	cpumask_set_cpu(cpu2, cpu_core_mask(cpu1));
+	cpumask_set_cpu(cpu1, c2->llc_shared_map);
+	cpumask_set_cpu(cpu2, c1->llc_shared_map);
+}
+
 
 void __cpuinit set_cpu_sibling_map(int cpu)
 {
@@ -409,14 +422,13 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		for_each_cpu(i, cpu_sibling_setup_mask) {
 			struct cpuinfo_x86 *o = &cpu_data(i);
 
-			if (c->phys_proc_id == o->phys_proc_id &&
-			    c->cpu_core_id == o->cpu_core_id) {
-				cpumask_set_cpu(i, cpu_sibling_mask(cpu));
-				cpumask_set_cpu(cpu, cpu_sibling_mask(i));
-				cpumask_set_cpu(i, cpu_core_mask(cpu));
-				cpumask_set_cpu(cpu, cpu_core_mask(i));
-				cpumask_set_cpu(i, c->llc_shared_map);
-				cpumask_set_cpu(cpu, o->llc_shared_map);
+			if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
+				if (c->phys_proc_id == o->phys_proc_id &&
+				    c->compute_unit_id == o->compute_unit_id)
+					link_thread_siblings(cpu, i);
+			} else if (c->phys_proc_id == o->phys_proc_id &&
+				   c->cpu_core_id == o->cpu_core_id) {
+				link_thread_siblings(cpu, i);
 			}
 		}
 	} else {
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 26a863a..4496315 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -892,60 +892,6 @@ static void __init init_tsc_clocksource(void)
 	clocksource_register_khz(&clocksource_tsc, tsc_khz);
 }
 
-#ifdef CONFIG_X86_64
-/*
- * calibrate_cpu is used on systems with fixed rate TSCs to determine
- * processor frequency
- */
-#define TICK_COUNT 100000000
-static unsigned long __init calibrate_cpu(void)
-{
-	int tsc_start, tsc_now;
-	int i, no_ctr_free;
-	unsigned long evntsel3 = 0, pmc3 = 0, pmc_now = 0;
-	unsigned long flags;
-
-	for (i = 0; i < 4; i++)
-		if (avail_to_resrv_perfctr_nmi_bit(i))
-			break;
-	no_ctr_free = (i == 4);
-	if (no_ctr_free) {
-		WARN(1, KERN_WARNING "Warning: AMD perfctrs busy ... "
-		     "cpu_khz value may be incorrect.\n");
-		i = 3;
-		rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
-		wrmsrl(MSR_K7_EVNTSEL3, 0);
-		rdmsrl(MSR_K7_PERFCTR3, pmc3);
-	} else {
-		reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-		reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
-	}
-	local_irq_save(flags);
-	/* start measuring cycles, incrementing from 0 */
-	wrmsrl(MSR_K7_PERFCTR0 + i, 0);
-	wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
-	rdtscl(tsc_start);
-	do {
-		rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
-		tsc_now = get_cycles();
-	} while ((tsc_now - tsc_start) < TICK_COUNT);
-
-	local_irq_restore(flags);
-	if (no_ctr_free) {
-		wrmsrl(MSR_K7_EVNTSEL3, 0);
-		wrmsrl(MSR_K7_PERFCTR3, pmc3);
-		wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
-	} else {
-		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
-	}
-
-	return pmc_now * tsc_khz / (tsc_now - tsc_start);
-}
-#else
-static inline unsigned long calibrate_cpu(void) { return cpu_khz; }
-#endif
-
 void __init tsc_init(void)
 {
 	u64 lpj;
@@ -964,10 +910,6 @@ void __init tsc_init(void)
 		return;
 	}
 
-	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
-			(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
-		cpu_khz = calibrate_cpu();
-
 	printk("Detected %lu.%03lu MHz processor.\n",
 			(unsigned long)cpu_khz / 1000,
 			(unsigned long)cpu_khz % 1000);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3a09c62..6c2ecf0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1991,13 +1991,14 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		0 /* Reserved */ | F(CX16) | 0 /* xTPR Update, PDCM */ |
 		0 /* Reserved, DCA */ | F(XMM4_1) |
 		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
-		0 /* Reserved, AES */ | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX);
+		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
+		F(F16C);
 	/* cpuid 0x80000001.ecx */
 	const u32 kvm_supported_word6_x86_features =
 		F(LAHF_LM) | F(CMP_LEGACY) | F(SVM) | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
-		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(SSE5) |
-		0 /* SKINIT */ | 0 /* WDT */;
+		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(XOP) |
+		0 /* SKINIT, WDT, LWP */ | F(FMA4) | F(TBM);
 
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index 970ed57..ab75b18 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -22,7 +22,7 @@
 #include <asm/numa.h>
 #include <asm/mpspec.h>
 #include <asm/apic.h>
-#include <asm/k8.h>
+#include <asm/amd_nb.h>
 
 static struct bootnode __initdata nodes[8];
 static nodemask_t __initdata nodes_parsed = NODE_MASK_NONE;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index a7bcc23..4962f1a 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -18,7 +18,7 @@
 #include <asm/dma.h>
 #include <asm/numa.h>
 #include <asm/acpi.h>
-#include <asm/k8.h>
+#include <asm/amd_nb.h>
 
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
index 4b66c69..5ddf67e 100644
--- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -57,7 +57,7 @@ config AGP_AMD
 
 config AGP_AMD64
 	tristate "AMD Opteron/Athlon64 on-CPU GART support"
-	depends on AGP && X86 && K8_NB
+	depends on AGP && X86 && AMD_NB
 	help
 	  This option gives you AGP support for the GLX component of
 	  X using the on-CPU northbridge of the AMD Athlon64/Opteron CPUs.
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 70312da..4d6087c 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -15,7 +15,7 @@
 #include <linux/mmzone.h>
 #include <asm/page.h>		/* PAGE_SIZE */
 #include <asm/e820.h>
-#include <asm/k8.h>
+#include <asm/amd_nb.h>
 #include <asm/gart.h>
 #include "agp.h"
 
@@ -124,7 +124,7 @@ static int amd64_fetch_size(void)
 	u32 temp;
 	struct aper_size_info_32 *values;
 
-	dev = k8_northbridges[0];
+	dev = k8_northbridges.nb_misc[0];
 	if (dev==NULL)
 		return 0;
 
@@ -181,10 +181,14 @@ static int amd_8151_configure(void)
 	unsigned long gatt_bus = virt_to_phys(agp_bridge->gatt_table_real);
 	int i;
 
+	if (!k8_northbridges.gart_supported)
+		return 0;
+
 	/* Configure AGP regs in each x86-64 host bridge. */
-        for (i = 0; i < num_k8_northbridges; i++) {
+	for (i = 0; i < k8_northbridges.num; i++) {
 		agp_bridge->gart_bus_addr =
-				amd64_configure(k8_northbridges[i], gatt_bus);
+				amd64_configure(k8_northbridges.nb_misc[i],
+						gatt_bus);
 	}
 	k8_flush_garts();
 	return 0;
@@ -195,8 +199,12 @@ static void amd64_cleanup(void)
 {
 	u32 tmp;
 	int i;
-        for (i = 0; i < num_k8_northbridges; i++) {
-		struct pci_dev *dev = k8_northbridges[i];
+
+	if (!k8_northbridges.gart_supported)
+		return;
+
+	for (i = 0; i < k8_northbridges.num; i++) {
+		struct pci_dev *dev = k8_northbridges.nb_misc[i];
 		/* disable gart translation */
 		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &tmp);
 		tmp &= ~AMD64_GARTEN;
@@ -319,16 +327,19 @@ static __devinit int fix_northbridge(struct pci_dev *nb, struct pci_dev *agp,
 	return 0;
 }
 
-static __devinit int cache_nbs (struct pci_dev *pdev, u32 cap_ptr)
+static __devinit int cache_nbs(struct pci_dev *pdev, u32 cap_ptr)
 {
 	int i;
 
 	if (cache_k8_northbridges() < 0)
 		return -ENODEV;
 
+	if (!k8_northbridges.gart_supported)
+		return -ENODEV;
+
 	i = 0;
-	for (i = 0; i < num_k8_northbridges; i++) {
-		struct pci_dev *dev = k8_northbridges[i];
+	for (i = 0; i < k8_northbridges.num; i++) {
+		struct pci_dev *dev = k8_northbridges.nb_misc[i];
 		if (fix_northbridge(dev, pdev, cap_ptr) < 0) {
 			dev_err(&dev->dev, "no usable aperture found\n");
 #ifdef __x86_64__
@@ -405,7 +416,8 @@ static int __devinit uli_agp_init(struct pci_dev *pdev)
 	}
 
 	/* shadow x86-64 registers into ULi registers */
-	pci_read_config_dword (k8_northbridges[0], AMD64_GARTAPERTUREBASE, &httfea);
+	pci_read_config_dword (k8_northbridges.nb_misc[0], AMD64_GARTAPERTUREBASE,
+			       &httfea);
 
 	/* if x86-64 aperture base is beyond 4G, exit here */
 	if ((httfea & 0x7fff) >> (32 - 25)) {
@@ -472,7 +484,8 @@ static int nforce3_agp_init(struct pci_dev *pdev)
 	pci_write_config_dword(dev1, NVIDIA_X86_64_1_APSIZE, tmp);
 
 	/* shadow x86-64 registers into NVIDIA registers */
-	pci_read_config_dword (k8_northbridges[0], AMD64_GARTAPERTUREBASE, &apbase);
+	pci_read_config_dword (k8_northbridges.nb_misc[0], AMD64_GARTAPERTUREBASE,
+			       &apbase);
 
 	/* if x86-64 aperture base is beyond 4G, exit here */
 	if ( (apbase & 0x7fff) >> (32 - 25) ) {
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 70bb350..734e2e0 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -66,7 +66,7 @@ config EDAC_MCE
 
 config EDAC_AMD64
 	tristate "AMD64 (Opteron, Athlon64) K8, F10h, F11h"
-	depends on EDAC_MM_EDAC && K8_NB && X86_64 && PCI && EDAC_DECODE_MCE
+	depends on EDAC_MM_EDAC && AMD_NB && X86_64 && PCI && EDAC_DECODE_MCE
 	help
 	  Support for error detection and correction on the AMD 64
 	  Families of Memory Controllers (K8, F10h and F11h)
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index e7d5d6b..09fcc52 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1,5 +1,5 @@
 #include "amd64_edac.h"
-#include <asm/k8.h>
+#include <asm/amd_nb.h>
 
 static struct edac_pci_ctl_info *amd64_ctl_pci;
 
@@ -2927,7 +2927,7 @@ static int __init amd64_edac_init(void)
 	 * to finish initialization of the MC instances.
 	 */
 	err = -ENODEV;
-	for (nb = 0; nb < num_k8_northbridges; nb++) {
+	for (nb = 0; nb < k8_northbridges.num; nb++) {
 		if (!pvt_lookup[nb])
 			continue;
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 10d3330..edc0279 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -514,6 +514,7 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_DRAM	0x1302
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
+#define PCI_DEVICE_ID_AMD_15H_NB_MISC	0x1603
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
 #define PCI_DEVICE_ID_AMD_SCSI		0x2020
