Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab2BUCG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 21:06:29 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63257 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab2BUCGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 21:06:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kjwinchester@gmail.com designates 10.229.111.141 as permitted sender) smtp.mail=kjwinchester@gmail.com; dkim=pass header.i=kjwinchester@gmail.com
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] x86: Move per cpu cpu_llc_shared_map to a field in struct cpuinfo_x86
Date: Mon, 20 Feb 2012 22:06:02 -0400
Message-Id: <1329789966-693-2-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329789966-693-1-git-send-email-kjwinchester@gmail.com>
References: <20120217115627.GA25601@elte.hu>
 <1329789966-693-1-git-send-email-kjwinchester@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 141168c36cde ("x86: Simplify code by removing a !SMP #ifdefs from
'struct cpuinfo_x86'") caused the compilation error:

mce_amd.c:(.cpuinit.text+0x4723): undefined reference to 'cpu_llc_shared_map'

by removing an #ifdef CONFIG_SMP around a block containing a reference
to cpu_llc_shared_map.  Rather than replace the #ifdef, move
cpu_llc_shared_map to be a new cpumask_t field llc_shared_map in
struct cpuinfo_x86 and adjust all references to cpu_llc_shared_map.

The size effects on various kernels are as follows:

   text	   data	    bss	    dec	    hex	filename
5281572	 513296	1044480	6839348	 685c34	vmlinux.up
5281572	 513296	1044480	6839348	 685c34	vmlinux.up.patched
5548860	 516792	1110016	7175668	 6d7df4	vmlinux.smp.2
5548837	 516792	1110016	7175645	 6d7ddd	vmlinux.smp.2.patched
5595965	 706840	1310720	7613525	 742c55	vmlinux.smp.max
5595876	 707880	1310720	7614476	 74300c	vmlinux.smp.max.patched

It can be seen that this change has no effect on UP, a minor effect for
SMP with Max 2 CPUs, and a more substantial but still not overly large
effect for MAXSMP.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---
 arch/x86/include/asm/processor.h      |    1 +
 arch/x86/include/asm/smp.h            |    6 ------
 arch/x86/kernel/cpu/intel_cacheinfo.c |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce_amd.c  |    7 ++++---
 arch/x86/kernel/smpboot.c             |   15 ++++++---------
 arch/x86/xen/smp.c                    |    1 -
 6 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 4b81258..0c8b574 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -110,6 +110,7 @@ struct cpuinfo_x86 {
 	/* Index into per_cpu list: */
 	u16			cpu_index;
 	u32			microcode;
+	cpumask_t		llc_shared_map;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
 #define X86_VENDOR_INTEL	0
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 0434c40..f7599d0 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -34,7 +34,6 @@ static inline bool cpu_has_ht_siblings(void)
 DECLARE_PER_CPU(cpumask_var_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
 /* cpus sharing the last level cache: */
-DECLARE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);
 DECLARE_PER_CPU(u16, cpu_llc_id);
 DECLARE_PER_CPU(int, cpu_number);
 
@@ -48,11 +47,6 @@ static inline struct cpumask *cpu_core_mask(int cpu)
 	return per_cpu(cpu_core_map, cpu);
 }
 
-static inline struct cpumask *cpu_llc_shared_mask(int cpu)
-{
-	return per_cpu(cpu_llc_shared_map, cpu);
-}
-
 DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
 DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 73d08ed..a9cd551 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -734,11 +734,11 @@ static int __cpuinit cache_shared_amd_cpu_map_setup(unsigned int cpu, int index)
 	ret = 0;
 	if (index == 3) {
 		ret = 1;
-		for_each_cpu(i, cpu_llc_shared_mask(cpu)) {
+		for_each_cpu(i, &c->llc_shared_map) {
 			if (!per_cpu(ici_cpuid4_info, i))
 				continue;
 			this_leaf = CPUID4_INFO_IDX(i, index);
-			for_each_cpu(sibling, cpu_llc_shared_mask(cpu)) {
+			for_each_cpu(sibling, &c->llc_shared_map) {
 				if (!cpu_online(sibling))
 					continue;
 				set_bit(sibling, this_leaf->shared_cpu_map);
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 786e76a..5e0ec2c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -525,11 +525,12 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 	struct threshold_bank *b = NULL;
 	struct device *dev = mce_device[cpu];
 	char name[32];
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	sprintf(name, "threshold_bank%i", bank);
 
-	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
-		i = cpumask_first(cpu_llc_shared_mask(cpu));
+	if (c->cpu_core_id && shared_bank[bank]) {	/* symlink */
+		i = cpumask_first(&c->llc_shared_map);
 
 		/* first core not up yet */
 		if (cpu_data(i).cpu_core_id)
@@ -548,7 +549,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		if (err)
 			goto out;
 
-		cpumask_copy(b->cpus, cpu_llc_shared_mask(cpu));
+		cpumask_copy(b->cpus, &c->llc_shared_map);
 		per_cpu(threshold_banks, cpu)[bank] = b;
 
 		goto out;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 257049d..1c20aa2 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -127,8 +127,6 @@ EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 DEFINE_PER_CPU(cpumask_var_t, cpu_core_map);
 EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 
-DEFINE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);
-
 /* Per CPU bogomips and other parameters */
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
@@ -337,8 +335,8 @@ static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
 	cpumask_set_cpu(cpu2, cpu_sibling_mask(cpu1));
 	cpumask_set_cpu(cpu1, cpu_core_mask(cpu2));
 	cpumask_set_cpu(cpu2, cpu_core_mask(cpu1));
-	cpumask_set_cpu(cpu1, cpu_llc_shared_mask(cpu2));
-	cpumask_set_cpu(cpu2, cpu_llc_shared_mask(cpu1));
+	cpumask_set_cpu(cpu1, &cpu_data(cpu2).llc_shared_map);
+	cpumask_set_cpu(cpu2, &cpu_data(cpu1).llc_shared_map);
 }
 
 
@@ -367,7 +365,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		cpumask_set_cpu(cpu, cpu_sibling_mask(cpu));
 	}
 
-	cpumask_set_cpu(cpu, cpu_llc_shared_mask(cpu));
+	cpumask_set_cpu(cpu, &c->llc_shared_map);
 
 	if (__this_cpu_read(cpu_info.x86_max_cores) == 1) {
 		cpumask_copy(cpu_core_mask(cpu), cpu_sibling_mask(cpu));
@@ -378,8 +376,8 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 	for_each_cpu(i, cpu_sibling_setup_mask) {
 		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
 		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
-			cpumask_set_cpu(i, cpu_llc_shared_mask(cpu));
-			cpumask_set_cpu(cpu, cpu_llc_shared_mask(i));
+			cpumask_set_cpu(i, &c->llc_shared_map);
+			cpumask_set_cpu(cpu, &cpu_data(i).llc_shared_map);
 		}
 		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
 			cpumask_set_cpu(i, cpu_core_mask(cpu));
@@ -418,7 +416,7 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 	    !(cpu_has(c, X86_FEATURE_AMD_DCM)))
 		return cpu_core_mask(cpu);
 	else
-		return cpu_llc_shared_mask(cpu);
+		return &c->llc_shared_map;
 }
 
 static void impress_friends(void)
@@ -1054,7 +1052,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	for_each_possible_cpu(i) {
 		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
 		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
-		zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
 	}
 	set_cpu_sibling_map(0);
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 501d4e0..b9f7a86 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -225,7 +225,6 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 	for_each_possible_cpu(i) {
 		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
 		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
-		zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
 	}
 	set_cpu_sibling_map(0);
 
-- 
1.7.9

