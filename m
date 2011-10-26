Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329Ab1JZPWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:22:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35333 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933026Ab1JZPWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:22:49 -0400
Date: Wed, 26 Oct 2011 17:21:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu changes for v3.2
Message-ID: <20111026152108.GA28385@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpu-for-linus

Please have a good look at:

   dfb09f9b7ab0: x86, amd: Avoid cache aliasing penalties on AMD family 15h

As it changes the MM allocation layout in a CPU family dependent 
fashion.

 Thanks,

	Ingo

------------------>
Borislav Petkov (4):
      x86, amd: Avoid cache aliasing penalties on AMD family 15h
      x86: Add a BSP cpu_dev helper
      x86, amd: Move BSP code to cpu_dev helper
      x86-32, amd: Move va_align definition to unbreak 32-bit build

Frank Arnold (1):
      x86: cache_info: Update calculation of AMD L3 cache indices

H. Peter Anvin (1):
      x86, msr: Fix typo in ENERGY_PERF_BIAS_POWERSAVE

Len Brown (2):
      x86, intel, power: Initialize MSR_IA32_ENERGY_PERF_BIAS
      x86, intel, power: Correct the MSR_IA32_ENERGY_PERF_BIAS message

Stephen Rothwell (2):
      x86, amd: Include elf.h explicitly, prepare the code for the module.h split
      x86, amd: Include linux/elf.h since we use stuff from asm/elf.h

Thomas Gleixner (3):
      x86: cache_info: Remove bogus free of amd_l3_cache data
      x86: cache_info: Kill the moronic shadow struct
      x86: cache_info: Kill the atomic allocation in amd_init_l3_cache()


 Documentation/kernel-parameters.txt   |   13 ++++
 arch/x86/include/asm/amd_nb.h         |    6 ++
 arch/x86/include/asm/elf.h            |   31 ++++++++
 arch/x86/include/asm/msr-index.h      |    3 +
 arch/x86/kernel/cpu/amd.c             |   47 ++++++++-----
 arch/x86/kernel/cpu/common.c          |    3 +
 arch/x86/kernel/cpu/cpu.h             |    1 +
 arch/x86/kernel/cpu/intel.c           |   18 +++++
 arch/x86/kernel/cpu/intel_cacheinfo.c |  127 ++++++++++++---------------------
 arch/x86/kernel/sys_x86_64.c          |   78 +++++++++++++++++++-
 arch/x86/mm/mmap.c                    |   20 +----
 arch/x86/vdso/vma.c                   |    9 +++
 12 files changed, 240 insertions(+), 116 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index aa47be7..af73c03 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -299,6 +299,19 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			behaviour to be specified.  Bit 0 enables warnings,
 			bit 1 enables fixups, and bit 2 sends a segfault.
 
+	align_va_addr=	[X86-64]
+			Align virtual addresses by clearing slice [14:12] when
+			allocating a VMA at process creation time. This option
+			gives you up to 3% performance improvement on AMD F15h
+			machines (where it is enabled by default) for a
+			CPU-intensive style benchmark, and it can vary highly in
+			a microbenchmark depending on workload and compiler.
+
+			1: only for 32-bit processes
+			2: only for 64-bit processes
+			on: enable for both 32- and 64-bit processes
+			off: disable for both 32- and 64-bit processes
+
 	amd_iommu=	[HW,X86-84]
 			Pass parameters to the AMD IOMMU driver in the system.
 			Possible values are:
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 67f87f2..8e41071 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -19,9 +19,15 @@ extern int amd_numa_init(void);
 extern int amd_get_subcaches(int);
 extern int amd_set_subcaches(int, int);
 
+struct amd_l3_cache {
+	unsigned indices;
+	u8	 subcaches[4];
+};
+
 struct amd_northbridge {
 	struct pci_dev *misc;
 	struct pci_dev *link;
+	struct amd_l3_cache l3_cache;
 };
 
 struct amd_northbridge_info {
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index f2ad216..5f962df 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -4,6 +4,7 @@
 /*
  * ELF register definitions..
  */
+#include <linux/thread_info.h>
 
 #include <asm/ptrace.h>
 #include <asm/user.h>
@@ -320,4 +321,34 @@ extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
 extern unsigned long arch_randomize_brk(struct mm_struct *mm);
 #define arch_randomize_brk arch_randomize_brk
 
+/*
+ * True on X86_32 or when emulating IA32 on X86_64
+ */
+static inline int mmap_is_ia32(void)
+{
+#ifdef CONFIG_X86_32
+	return 1;
+#endif
+#ifdef CONFIG_IA32_EMULATION
+	if (test_thread_flag(TIF_IA32))
+		return 1;
+#endif
+	return 0;
+}
+
+/* The first two values are special, do not change. See align_addr() */
+enum align_flags {
+	ALIGN_VA_32	= BIT(0),
+	ALIGN_VA_64	= BIT(1),
+	ALIGN_VDSO	= BIT(2),
+	ALIGN_TOPDOWN	= BIT(3),
+};
+
+struct va_alignment {
+	int flags;
+	unsigned long mask;
+} ____cacheline_aligned;
+
+extern struct va_alignment va_align;
+extern unsigned long align_addr(unsigned long, struct file *, enum align_flags);
 #endif /* _ASM_X86_ELF_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 485b4f1..d96bdb2 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -259,6 +259,9 @@
 #define MSR_IA32_TEMPERATURE_TARGET	0x000001a2
 
 #define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0
+#define ENERGY_PERF_BIAS_PERFORMANCE	0
+#define ENERGY_PERF_BIAS_NORMAL		6
+#define ENERGY_PERF_BIAS_POWERSAVE	15
 
 #define MSR_IA32_PACKAGE_THERM_STATUS		0x000001b1
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index b13ed39..13c6ec8 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1,5 +1,6 @@
 #include <linux/init.h>
 #include <linux/bitops.h>
+#include <linux/elf.h>
 #include <linux/mm.h>
 
 #include <linux/io.h>
@@ -410,6 +411,34 @@ static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
 #endif
 }
 
+static void __cpuinit bsp_init_amd(struct cpuinfo_x86 *c)
+{
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
+
+	if (c->x86 == 0x15) {
+		unsigned long upperbit;
+		u32 cpuid, assoc;
+
+		cpuid	 = cpuid_edx(0x80000005);
+		assoc	 = cpuid >> 16 & 0xff;
+		upperbit = ((cpuid >> 24) << 10) / assoc;
+
+		va_align.mask	  = (upperbit - 1) & PAGE_MASK;
+		va_align.flags    = ALIGN_VA_32 | ALIGN_VA_64;
+	}
+}
+
 static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
 	early_init_amd_mc(c);
@@ -441,23 +470,6 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
 	}
 #endif
-
-	/* We need to do the following only once */
-	if (c != &boot_cpu_data)
-		return;
-
-	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
-
-		if (c->x86 > 0x10 ||
-		    (c->x86 == 0x10 && c->x86_model >= 0x2)) {
-			u64 val;
-
-			rdmsrl(MSR_K7_HWCR, val);
-			if (!(val & BIT(24)))
-				printk(KERN_WARNING FW_BUG "TSC doesn't count "
-					"with P0 frequency!\n");
-		}
-	}
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
@@ -679,6 +691,7 @@ static const struct cpu_dev __cpuinitconst amd_cpu_dev = {
 	.c_size_cache	= amd_size_cache,
 #endif
 	.c_early_init   = early_init_amd,
+	.c_bsp_init	= bsp_init_amd,
 	.c_init		= init_amd,
 	.c_x86_vendor	= X86_VENDOR_AMD,
 };
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 22a073d..8ed394a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -681,6 +681,9 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 	filter_cpuid_features(c, false);
 
 	setup_smep(c);
+
+	if (this_cpu->c_bsp_init)
+		this_cpu->c_bsp_init(c);
 }
 
 void __init early_cpu_init(void)
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index e765633..1b22dcc 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -18,6 +18,7 @@ struct cpu_dev {
 	struct		cpu_model_info c_models[4];
 
 	void            (*c_early_init)(struct cpuinfo_x86 *);
+	void		(*c_bsp_init)(struct cpuinfo_x86 *);
 	void		(*c_init)(struct cpuinfo_x86 *);
 	void		(*c_identify)(struct cpuinfo_x86 *);
 	unsigned int	(*c_size_cache)(struct cpuinfo_x86 *, unsigned int);
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1edf5ba..ed6086e 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -456,6 +456,24 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 	if (cpu_has(c, X86_FEATURE_VMX))
 		detect_vmx_virtcap(c);
+
+	/*
+	 * Initialize MSR_IA32_ENERGY_PERF_BIAS if BIOS did not.
+	 * x86_energy_perf_policy(8) is available to change it at run-time
+	 */
+	if (cpu_has(c, X86_FEATURE_EPB)) {
+		u64 epb;
+
+		rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
+		if ((epb & 0xF) == ENERGY_PERF_BIAS_PERFORMANCE) {
+			printk_once(KERN_WARNING "ENERGY_PERF_BIAS:"
+				" Set to 'normal', was 'performance'\n"
+				"ENERGY_PERF_BIAS: View and update with"
+				" x86_energy_perf_policy(8)\n");
+			epb = (epb & ~0xF) | ENERGY_PERF_BIAS_NORMAL;
+			wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
+		}
+	}
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index c105c53..a3b0811 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -151,28 +151,17 @@ union _cpuid4_leaf_ecx {
 	u32 full;
 };
 
-struct amd_l3_cache {
-	struct	 amd_northbridge *nb;
-	unsigned indices;
-	u8	 subcaches[4];
-};
-
-struct _cpuid4_info {
+struct _cpuid4_info_regs {
 	union _cpuid4_leaf_eax eax;
 	union _cpuid4_leaf_ebx ebx;
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
-	struct amd_l3_cache *l3;
-	DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
+	struct amd_northbridge *nb;
 };
 
-/* subset of above _cpuid4_info w/o shared_cpu_map */
-struct _cpuid4_info_regs {
-	union _cpuid4_leaf_eax eax;
-	union _cpuid4_leaf_ebx ebx;
-	union _cpuid4_leaf_ecx ecx;
-	unsigned long size;
-	struct amd_l3_cache *l3;
+struct _cpuid4_info {
+	struct _cpuid4_info_regs base;
+	DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
 };
 
 unsigned short			num_cache_leaves;
@@ -314,16 +303,23 @@ struct _cache_attr {
 /*
  * L3 cache descriptors
  */
-static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
+static void __cpuinit amd_calc_l3_indices(struct amd_northbridge *nb)
 {
+	struct amd_l3_cache *l3 = &nb->l3_cache;
 	unsigned int sc0, sc1, sc2, sc3;
 	u32 val = 0;
 
-	pci_read_config_dword(l3->nb->misc, 0x1C4, &val);
+	pci_read_config_dword(nb->misc, 0x1C4, &val);
 
 	/* calculate subcache sizes */
 	l3->subcaches[0] = sc0 = !(val & BIT(0));
 	l3->subcaches[1] = sc1 = !(val & BIT(4));
+
+	if (boot_cpu_data.x86 == 0x15) {
+		l3->subcaches[0] = sc0 += !(val & BIT(1));
+		l3->subcaches[1] = sc1 += !(val & BIT(5));
+	}
+
 	l3->subcaches[2] = sc2 = !(val & BIT(8))  + !(val & BIT(9));
 	l3->subcaches[3] = sc3 = !(val & BIT(12)) + !(val & BIT(13));
 
@@ -333,33 +329,16 @@ static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
 static void __cpuinit amd_init_l3_cache(struct _cpuid4_info_regs *this_leaf,
 					int index)
 {
-	static struct amd_l3_cache *__cpuinitdata l3_caches;
 	int node;
 
 	/* only for L3, and not in virtualized environments */
-	if (index < 3 || amd_nb_num() == 0)
+	if (index < 3)
 		return;
 
-	/*
-	 * Strictly speaking, the amount in @size below is leaked since it is
-	 * never freed but this is done only on shutdown so it doesn't matter.
-	 */
-	if (!l3_caches) {
-		int size = amd_nb_num() * sizeof(struct amd_l3_cache);
-
-		l3_caches = kzalloc(size, GFP_ATOMIC);
-		if (!l3_caches)
-			return;
-	}
-
 	node = amd_get_nb_id(smp_processor_id());
-
-	if (!l3_caches[node].nb) {
-		l3_caches[node].nb = node_to_amd_nb(node);
-		amd_calc_l3_indices(&l3_caches[node]);
-	}
-
-	this_leaf->l3 = &l3_caches[node];
+	this_leaf->nb = node_to_amd_nb(node);
+	if (this_leaf->nb && !this_leaf->nb->l3_cache.indices)
+		amd_calc_l3_indices(this_leaf->nb);
 }
 
 /*
@@ -369,11 +348,11 @@ static void __cpuinit amd_init_l3_cache(struct _cpuid4_info_regs *this_leaf,
  *
  * @returns: the disabled index if used or negative value if slot free.
  */
-int amd_get_l3_disable_slot(struct amd_l3_cache *l3, unsigned slot)
+int amd_get_l3_disable_slot(struct amd_northbridge *nb, unsigned slot)
 {
 	unsigned int reg = 0;
 
-	pci_read_config_dword(l3->nb->misc, 0x1BC + slot * 4, &reg);
+	pci_read_config_dword(nb->misc, 0x1BC + slot * 4, &reg);
 
 	/* check whether this slot is activated already */
 	if (reg & (3UL << 30))
@@ -387,11 +366,10 @@ static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 {
 	int index;
 
-	if (!this_leaf->l3 ||
-	    !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
+	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
 		return -EINVAL;
 
-	index = amd_get_l3_disable_slot(this_leaf->l3, slot);
+	index = amd_get_l3_disable_slot(this_leaf->base.nb, slot);
 	if (index >= 0)
 		return sprintf(buf, "%d\n", index);
 
@@ -408,7 +386,7 @@ show_cache_disable_##slot(struct _cpuid4_info *this_leaf, char *buf,	\
 SHOW_CACHE_DISABLE(0)
 SHOW_CACHE_DISABLE(1)
 
-static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
+static void amd_l3_disable_index(struct amd_northbridge *nb, int cpu,
 				 unsigned slot, unsigned long idx)
 {
 	int i;
@@ -421,10 +399,10 @@ static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
 	for (i = 0; i < 4; i++) {
 		u32 reg = idx | (i << 20);
 
-		if (!l3->subcaches[i])
+		if (!nb->l3_cache.subcaches[i])
 			continue;
 
-		pci_write_config_dword(l3->nb->misc, 0x1BC + slot * 4, reg);
+		pci_write_config_dword(nb->misc, 0x1BC + slot * 4, reg);
 
 		/*
 		 * We need to WBINVD on a core on the node containing the L3
@@ -434,7 +412,7 @@ static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
 		wbinvd_on_cpu(cpu);
 
 		reg |= BIT(31);
-		pci_write_config_dword(l3->nb->misc, 0x1BC + slot * 4, reg);
+		pci_write_config_dword(nb->misc, 0x1BC + slot * 4, reg);
 	}
 }
 
@@ -448,24 +426,24 @@ static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
  *
  * @return: 0 on success, error status on failure
  */
-int amd_set_l3_disable_slot(struct amd_l3_cache *l3, int cpu, unsigned slot,
+int amd_set_l3_disable_slot(struct amd_northbridge *nb, int cpu, unsigned slot,
 			    unsigned long index)
 {
 	int ret = 0;
 
 	/*  check if @slot is already used or the index is already disabled */
-	ret = amd_get_l3_disable_slot(l3, slot);
+	ret = amd_get_l3_disable_slot(nb, slot);
 	if (ret >= 0)
 		return -EINVAL;
 
-	if (index > l3->indices)
+	if (index > nb->l3_cache.indices)
 		return -EINVAL;
 
 	/* check whether the other slot has disabled the same index already */
-	if (index == amd_get_l3_disable_slot(l3, !slot))
+	if (index == amd_get_l3_disable_slot(nb, !slot))
 		return -EINVAL;
 
-	amd_l3_disable_index(l3, cpu, slot, index);
+	amd_l3_disable_index(nb, cpu, slot, index);
 
 	return 0;
 }
@@ -480,8 +458,7 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!this_leaf->l3 ||
-	    !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
+	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
 		return -EINVAL;
 
 	cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
@@ -489,7 +466,7 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	if (strict_strtoul(buf, 10, &val) < 0)
 		return -EINVAL;
 
-	err = amd_set_l3_disable_slot(this_leaf->l3, cpu, slot, val);
+	err = amd_set_l3_disable_slot(this_leaf->base.nb, cpu, slot, val);
 	if (err) {
 		if (err == -EEXIST)
 			printk(KERN_WARNING "L3 disable slot %d in use!\n",
@@ -518,7 +495,7 @@ static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
 static ssize_t
 show_subcaches(struct _cpuid4_info *this_leaf, char *buf, unsigned int cpu)
 {
-	if (!this_leaf->l3 || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
 		return -EINVAL;
 
 	return sprintf(buf, "%x\n", amd_get_subcaches(cpu));
@@ -533,7 +510,7 @@ store_subcaches(struct _cpuid4_info *this_leaf, const char *buf, size_t count,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!this_leaf->l3 || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
 		return -EINVAL;
 
 	if (strict_strtoul(buf, 16, &val) < 0)
@@ -769,7 +746,7 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
 		return;
 	}
 	this_leaf = CPUID4_INFO_IDX(cpu, index);
-	num_threads_sharing = 1 + this_leaf->eax.split.num_threads_sharing;
+	num_threads_sharing = 1 + this_leaf->base.eax.split.num_threads_sharing;
 
 	if (num_threads_sharing == 1)
 		cpumask_set_cpu(cpu, to_cpumask(this_leaf->shared_cpu_map));
@@ -820,29 +797,19 @@ static void __cpuinit free_cache_attributes(unsigned int cpu)
 	for (i = 0; i < num_cache_leaves; i++)
 		cache_remove_shared_cpu_map(cpu, i);
 
-	kfree(per_cpu(ici_cpuid4_info, cpu)->l3);
 	kfree(per_cpu(ici_cpuid4_info, cpu));
 	per_cpu(ici_cpuid4_info, cpu) = NULL;
 }
 
-static int
-__cpuinit cpuid4_cache_lookup(int index, struct _cpuid4_info *this_leaf)
-{
-	struct _cpuid4_info_regs *leaf_regs =
-		(struct _cpuid4_info_regs *)this_leaf;
-
-	return cpuid4_cache_lookup_regs(index, leaf_regs);
-}
-
 static void __cpuinit get_cpu_leaves(void *_retval)
 {
 	int j, *retval = _retval, cpu = smp_processor_id();
 
 	/* Do cpuid and store the results */
 	for (j = 0; j < num_cache_leaves; j++) {
-		struct _cpuid4_info *this_leaf;
-		this_leaf = CPUID4_INFO_IDX(cpu, j);
-		*retval = cpuid4_cache_lookup(j, this_leaf);
+		struct _cpuid4_info *this_leaf = CPUID4_INFO_IDX(cpu, j);
+
+		*retval = cpuid4_cache_lookup_regs(j, &this_leaf->base);
 		if (unlikely(*retval < 0)) {
 			int i;
 
@@ -900,16 +867,16 @@ static ssize_t show_##file_name(struct _cpuid4_info *this_leaf, char *buf, \
 	return sprintf(buf, "%lu\n", (unsigned long)this_leaf->object + val); \
 }
 
-show_one_plus(level, eax.split.level, 0);
-show_one_plus(coherency_line_size, ebx.split.coherency_line_size, 1);
-show_one_plus(physical_line_partition, ebx.split.physical_line_partition, 1);
-show_one_plus(ways_of_associativity, ebx.split.ways_of_associativity, 1);
-show_one_plus(number_of_sets, ecx.split.number_of_sets, 1);
+show_one_plus(level, base.eax.split.level, 0);
+show_one_plus(coherency_line_size, base.ebx.split.coherency_line_size, 1);
+show_one_plus(physical_line_partition, base.ebx.split.physical_line_partition, 1);
+show_one_plus(ways_of_associativity, base.ebx.split.ways_of_associativity, 1);
+show_one_plus(number_of_sets, base.ecx.split.number_of_sets, 1);
 
 static ssize_t show_size(struct _cpuid4_info *this_leaf, char *buf,
 			 unsigned int cpu)
 {
-	return sprintf(buf, "%luK\n", this_leaf->size / 1024);
+	return sprintf(buf, "%luK\n", this_leaf->base.size / 1024);
 }
 
 static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
@@ -946,7 +913,7 @@ static inline ssize_t show_shared_cpu_list(struct _cpuid4_info *leaf, char *buf,
 static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf,
 			 unsigned int cpu)
 {
-	switch (this_leaf->eax.split.type) {
+	switch (this_leaf->base.eax.split.type) {
 	case CACHE_TYPE_DATA:
 		return sprintf(buf, "Data\n");
 	case CACHE_TYPE_INST:
@@ -1135,7 +1102,7 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 
 		ktype_cache.default_attrs = default_attrs;
 #ifdef CONFIG_AMD_NB
-		if (this_leaf->l3)
+		if (this_leaf->base.nb)
 			ktype_cache.default_attrs = amd_l3_attrs();
 #endif
 		retval = kobject_init_and_add(&(this_object->kobj),
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index ff14a50..0514890 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -14,10 +14,73 @@
 #include <linux/personality.h>
 #include <linux/random.h>
 #include <linux/uaccess.h>
+#include <linux/elf.h>
 
 #include <asm/ia32.h>
 #include <asm/syscalls.h>
 
+/*
+ * Align a virtual address to avoid aliasing in the I$ on AMD F15h.
+ *
+ * @flags denotes the allocation direction - bottomup or topdown -
+ * or vDSO; see call sites below.
+ */
+unsigned long align_addr(unsigned long addr, struct file *filp,
+			 enum align_flags flags)
+{
+	unsigned long tmp_addr;
+
+	/* handle 32- and 64-bit case with a single conditional */
+	if (va_align.flags < 0 || !(va_align.flags & (2 - mmap_is_ia32())))
+		return addr;
+
+	if (!(current->flags & PF_RANDOMIZE))
+		return addr;
+
+	if (!((flags & ALIGN_VDSO) || filp))
+		return addr;
+
+	tmp_addr = addr;
+
+	/*
+	 * We need an address which is <= than the original
+	 * one only when in topdown direction.
+	 */
+	if (!(flags & ALIGN_TOPDOWN))
+		tmp_addr += va_align.mask;
+
+	tmp_addr &= ~va_align.mask;
+
+	return tmp_addr;
+}
+
+static int __init control_va_addr_alignment(char *str)
+{
+	/* guard against enabling this on other CPU families */
+	if (va_align.flags < 0)
+		return 1;
+
+	if (*str == 0)
+		return 1;
+
+	if (*str == '=')
+		str++;
+
+	if (!strcmp(str, "32"))
+		va_align.flags = ALIGN_VA_32;
+	else if (!strcmp(str, "64"))
+		va_align.flags = ALIGN_VA_64;
+	else if (!strcmp(str, "off"))
+		va_align.flags = 0;
+	else if (!strcmp(str, "on"))
+		va_align.flags = ALIGN_VA_32 | ALIGN_VA_64;
+	else
+		return 0;
+
+	return 1;
+}
+__setup("align_va_addr", control_va_addr_alignment);
+
 SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
 		unsigned long, prot, unsigned long, flags,
 		unsigned long, fd, unsigned long, off)
@@ -92,6 +155,9 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	start_addr = addr;
 
 full_search:
+
+	addr = align_addr(addr, filp, 0);
+
 	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
 		/* At this point:  (!vma || addr < vma->vm_end). */
 		if (end - len < addr) {
@@ -117,6 +183,7 @@ full_search:
 			mm->cached_hole_size = vma->vm_start - addr;
 
 		addr = vma->vm_end;
+		addr = align_addr(addr, filp, 0);
 	}
 }
 
@@ -161,10 +228,13 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 
 	/* make sure it can fit in the remaining address space */
 	if (addr > len) {
-		vma = find_vma(mm, addr-len);
-		if (!vma || addr <= vma->vm_start)
+		unsigned long tmp_addr = align_addr(addr - len, filp,
+						    ALIGN_TOPDOWN);
+
+		vma = find_vma(mm, tmp_addr);
+		if (!vma || tmp_addr + len <= vma->vm_start)
 			/* remember the address as a hint for next time */
-			return mm->free_area_cache = addr-len;
+			return mm->free_area_cache = tmp_addr;
 	}
 
 	if (mm->mmap_base < len)
@@ -173,6 +243,8 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	addr = mm->mmap_base-len;
 
 	do {
+		addr = align_addr(addr, filp, ALIGN_TOPDOWN);
+
 		/*
 		 * Lookup failure means no vma is above this address,
 		 * else if new region fits below vma->vm_start,
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 1dab519..4b5ba85 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -31,6 +31,10 @@
 #include <linux/sched.h>
 #include <asm/elf.h>
 
+struct __read_mostly va_alignment va_align = {
+	.flags = -1,
+};
+
 static unsigned int stack_maxrandom_size(void)
 {
 	unsigned int max = 0;
@@ -42,7 +46,6 @@ static unsigned int stack_maxrandom_size(void)
 	return max;
 }
 
-
 /*
  * Top of mmap area (just below the process stack).
  *
@@ -51,21 +54,6 @@ static unsigned int stack_maxrandom_size(void)
 #define MIN_GAP (128*1024*1024UL + stack_maxrandom_size())
 #define MAX_GAP (TASK_SIZE/6*5)
 
-/*
- * True on X86_32 or when emulating IA32 on X86_64
- */
-static int mmap_is_ia32(void)
-{
-#ifdef CONFIG_X86_32
-	return 1;
-#endif
-#ifdef CONFIG_IA32_EMULATION
-	if (test_thread_flag(TIF_IA32))
-		return 1;
-#endif
-	return 0;
-}
-
 static int mmap_is_legacy(void)
 {
 	if (current->personality & ADDR_COMPAT_LAYOUT)
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 7abd2be..caa42ce 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -69,6 +69,15 @@ static unsigned long vdso_addr(unsigned long start, unsigned len)
 	addr = start + (offset << PAGE_SHIFT);
 	if (addr >= end)
 		addr = end;
+
+	/*
+	 * page-align it here so that get_unmapped_area doesn't
+	 * align it wrongfully again to the next page. addr can come in 4K
+	 * unaligned here as a result of stack start randomization.
+	 */
+	addr = PAGE_ALIGN(addr);
+	addr = align_addr(addr, NULL, ALIGN_VDSO);
+
 	return addr;
 }
 
