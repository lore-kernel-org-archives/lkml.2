Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab2LKKvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 05:51:19 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40784 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab2LKKvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 05:51:18 -0500
Date: Tue, 11 Dec 2012 11:51:13 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu changes for v3.8
Message-ID: <20121211105112.GA25963@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpu-for-linus

   HEAD: 27d3a8a26ada7660116fdd6830096008c063ee96 x86, cacheinfo: Base cache sharing info on CPUID 0x8000001d on AMD

These changes improve topology discovery on AMD CPUs.

Right now this feeds information displayed in 
/sys/devices/system/cpu/cpuX/cache/indexY/* - but in the future 
we could use this to set up a better scheduling topology.

Thanks,

	Ingo

------------------>
Andreas Herrmann (4):
      x86: Add cpu_has_topoext
      x86, cacheinfo: Determine number of cache leafs using CPUID 0x8000001d on AMD
      x86, cacheinfo: Make use of CPUID 0x8000001d for cache information on AMD
      x86, cacheinfo: Base cache sharing info on CPUID 0x8000001d on AMD


 arch/x86/include/asm/cpufeature.h     |  1 +
 arch/x86/include/asm/processor.h      |  2 +-
 arch/x86/kernel/cpu/amd.c             |  9 +----
 arch/x86/kernel/cpu/intel_cacheinfo.c | 75 +++++++++++++++++++++++++----------
 arch/x86/kernel/smpboot.c             |  2 +-
 5 files changed, 60 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 8c297aa..c22a492 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -311,6 +311,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_cx8		boot_cpu_has(X86_FEATURE_CX8)
 #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
+#define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index ad1fc85..db0d8c3 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -187,7 +187,7 @@ extern void print_cpu_info(struct cpuinfo_x86 *);
 void print_cpu_msr(struct cpuinfo_x86 *);
 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
-extern unsigned short num_cache_leaves;
+extern void init_amd_cacheinfo(struct cpuinfo_x86 *c);
 
 extern void detect_extended_topology(struct cpuinfo_x86 *c);
 extern void detect_ht(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f7e98a2..a8538e6 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -304,7 +304,7 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 	int cpu = smp_processor_id();
 
 	/* get information required for multi-node processors */
-	if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
+	if (cpu_has_topoext) {
 		u32 eax, ebx, ecx, edx;
 
 		cpuid(0x8000001e, &eax, &ebx, &ecx, &edx);
@@ -643,12 +643,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	detect_ht(c);
 #endif
 
-	if (c->extended_cpuid_level >= 0x80000006) {
-		if (cpuid_edx(0x80000006) & 0xf000)
-			num_cache_leaves = 4;
-		else
-			num_cache_leaves = 3;
-	}
+	init_amd_cacheinfo(c);
 
 	if (c->x86 >= 0xf)
 		set_cpu_cap(c, X86_FEATURE_K8);
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 93c5451..fe9edec 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -538,7 +538,11 @@ __cpuinit cpuid4_cache_lookup_regs(int index,
 	unsigned		edx;
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
-		amd_cpuid4(index, &eax, &ebx, &ecx);
+		if (cpu_has_topoext)
+			cpuid_count(0x8000001d, index, &eax.full,
+				    &ebx.full, &ecx.full, &edx);
+		else
+			amd_cpuid4(index, &eax, &ebx, &ecx);
 		amd_init_l3_cache(this_leaf, index);
 	} else {
 		cpuid_count(4, index, &eax.full, &ebx.full, &ecx.full, &edx);
@@ -557,21 +561,39 @@ __cpuinit cpuid4_cache_lookup_regs(int index,
 	return 0;
 }
 
-static int __cpuinit find_num_cache_leaves(void)
+static int __cpuinit find_num_cache_leaves(struct cpuinfo_x86 *c)
 {
-	unsigned int		eax, ebx, ecx, edx;
+	unsigned int		eax, ebx, ecx, edx, op;
 	union _cpuid4_leaf_eax	cache_eax;
 	int 			i = -1;
 
+	if (c->x86_vendor == X86_VENDOR_AMD)
+		op = 0x8000001d;
+	else
+		op = 4;
+
 	do {
 		++i;
-		/* Do cpuid(4) loop to find out num_cache_leaves */
-		cpuid_count(4, i, &eax, &ebx, &ecx, &edx);
+		/* Do cpuid(op) loop to find out num_cache_leaves */
+		cpuid_count(op, i, &eax, &ebx, &ecx, &edx);
 		cache_eax.full = eax;
 	} while (cache_eax.split.type != CACHE_TYPE_NULL);
 	return i;
 }
 
+void __cpuinit init_amd_cacheinfo(struct cpuinfo_x86 *c)
+{
+
+	if (cpu_has_topoext) {
+		num_cache_leaves = find_num_cache_leaves(c);
+	} else if (c->extended_cpuid_level >= 0x80000006) {
+		if (cpuid_edx(0x80000006) & 0xf000)
+			num_cache_leaves = 4;
+		else
+			num_cache_leaves = 3;
+	}
+}
+
 unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 {
 	/* Cache sizes */
@@ -588,7 +610,7 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 
 		if (is_initialized == 0) {
 			/* Init num_cache_leaves from boot CPU */
-			num_cache_leaves = find_num_cache_leaves();
+			num_cache_leaves = find_num_cache_leaves(c);
 			is_initialized++;
 		}
 
@@ -728,37 +750,50 @@ static DEFINE_PER_CPU(struct _cpuid4_info *, ici_cpuid4_info);
 static int __cpuinit cache_shared_amd_cpu_map_setup(unsigned int cpu, int index)
 {
 	struct _cpuid4_info *this_leaf;
-	int ret, i, sibling;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	int i, sibling;
 
-	ret = 0;
-	if (index == 3) {
-		ret = 1;
-		for_each_cpu(i, cpu_llc_shared_mask(cpu)) {
+	if (cpu_has_topoext) {
+		unsigned int apicid, nshared, first, last;
+
+		if (!per_cpu(ici_cpuid4_info, cpu))
+			return 0;
+
+		this_leaf = CPUID4_INFO_IDX(cpu, index);
+		nshared = this_leaf->base.eax.split.num_threads_sharing + 1;
+		apicid = cpu_data(cpu).apicid;
+		first = apicid - (apicid % nshared);
+		last = first + nshared - 1;
+
+		for_each_online_cpu(i) {
+			apicid = cpu_data(i).apicid;
+			if ((apicid < first) || (apicid > last))
+				continue;
 			if (!per_cpu(ici_cpuid4_info, i))
 				continue;
 			this_leaf = CPUID4_INFO_IDX(i, index);
-			for_each_cpu(sibling, cpu_llc_shared_mask(cpu)) {
-				if (!cpu_online(sibling))
+
+			for_each_online_cpu(sibling) {
+				apicid = cpu_data(sibling).apicid;
+				if ((apicid < first) || (apicid > last))
 					continue;
 				set_bit(sibling, this_leaf->shared_cpu_map);
 			}
 		}
-	} else if ((c->x86 == 0x15) && ((index == 1) || (index == 2))) {
-		ret = 1;
-		for_each_cpu(i, cpu_sibling_mask(cpu)) {
+	} else if (index == 3) {
+		for_each_cpu(i, cpu_llc_shared_mask(cpu)) {
 			if (!per_cpu(ici_cpuid4_info, i))
 				continue;
 			this_leaf = CPUID4_INFO_IDX(i, index);
-			for_each_cpu(sibling, cpu_sibling_mask(cpu)) {
+			for_each_cpu(sibling, cpu_llc_shared_mask(cpu)) {
 				if (!cpu_online(sibling))
 					continue;
 				set_bit(sibling, this_leaf->shared_cpu_map);
 			}
 		}
-	}
+	} else
+		return 0;
 
-	return ret;
+	return 1;
 }
 
 static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c80a33b..732bf5c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -313,7 +313,7 @@ do {									\
 
 static bool __cpuinit match_smt(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 {
-	if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
+	if (cpu_has_topoext) {
 		int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
 
 		if (c->phys_proc_id == o->phys_proc_id &&
