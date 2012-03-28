Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845Ab2C1Wso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:48:44 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:55042 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758801Ab2C1Wsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:48:37 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/5] x86: Move per cpu cpu_llc_shared_map to a field in struct cpuinfo_x86
Date: Wed, 28 Mar 2012 19:43:03 -0300
Message-Id: <1332974587-15452-2-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1332974587-15452-1-git-send-email-kjwinchester@gmail.com>
References: <20120227115905.GB9943@elte.hu>
 <1332974587-15452-1-git-send-email-kjwinchester@gmail.com>
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

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---
 arch/x86/include/asm/processor.h     |    2 ++
 arch/x86/include/asm/smp.h           |    4 +---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    2 --
 arch/x86/kernel/smpboot.c            |    3 ---
 arch/x86/xen/smp.c                   |    1 -
 5 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 4bc23ed..25c2598 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -110,6 +110,8 @@ struct cpuinfo_x86 {
 	/* Index into per_cpu list: */
 	u16			cpu_index;
 	u32			microcode;
+	/* CPUs sharing the last level cache: */
+	cpumask_t		llc_shared_map;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
 #define X86_VENDOR_INTEL	0
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 0434c40..b6e034e 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -33,8 +33,6 @@ static inline bool cpu_has_ht_siblings(void)
 
 DECLARE_PER_CPU(cpumask_var_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
-/* cpus sharing the last level cache: */
-DECLARE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);
 DECLARE_PER_CPU(u16, cpu_llc_id);
 DECLARE_PER_CPU(int, cpu_number);
 
@@ -50,7 +48,7 @@ static inline struct cpumask *cpu_core_mask(int cpu)
 
 static inline struct cpumask *cpu_llc_shared_mask(int cpu)
 {
-	return per_cpu(cpu_llc_shared_map, cpu);
+	return &cpu_data(cpu).llc_shared_map;
 }
 
 DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 99b5717..a4bf9d2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -528,7 +528,6 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 	sprintf(name, "threshold_bank%i", bank);
 
-#ifdef CONFIG_SMP
 	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
 		i = cpumask_first(cpu_llc_shared_mask(cpu));
 
@@ -554,7 +553,6 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 		goto out;
 	}
-#endif
 
 	b = kzalloc(sizeof(struct threshold_bank), GFP_KERNEL);
 	if (!b) {
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index e578a79..9d85044 100644
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
@@ -1039,7 +1037,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	for_each_possible_cpu(i) {
 		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
 		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
-		zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
 	}
 	set_cpu_sibling_map(0);
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 02900e8..df3d5cb 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -231,7 +231,6 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 	for_each_possible_cpu(i) {
 		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
 		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
-		zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
 	}
 	set_cpu_sibling_map(0);
 
-- 
1.7.9.5

