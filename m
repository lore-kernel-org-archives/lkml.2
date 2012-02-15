Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab2BOFBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 00:01:19 -0500
Received: from ozlabs.org ([203.10.76.45]:38381 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab2BOFAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 00:00:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Message-ID: <1329281884.26321.rusty@rustcorp.com.au>
Date: Wed, 15 Feb 2012 15:28:04 +1030
Subject: [PATCH 4/12] arch/mips: remove references to cpu_*_map.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

This has been obsolescent for a while; time for the final push.

Also took the chance to get rid of old cpus_* in favor of cpumask_*.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/cavium-octeon/smp.c       |    2 +-
 arch/mips/kernel/mips-mt-fpaff.c    |    2 +-
 arch/mips/kernel/proc.c             |    2 +-
 arch/mips/kernel/smp-bmips.c        |    2 +-
 arch/mips/kernel/smp.c              |   27 ++++++++++++---------------
 arch/mips/kernel/smtc.c             |    2 +-
 arch/mips/mm/c-octeon.c             |    6 +++---
 arch/mips/netlogic/common/smp.c     |    6 +++---
 arch/mips/pmc-sierra/yosemite/smp.c |    6 +++---
 arch/mips/sgi-ip27/ip27-smp.c       |    2 +-
 arch/mips/sibyte/bcm1480/smp.c      |    5 ++---
 arch/mips/sibyte/sb1250/smp.c       |    7 +++----
 12 files changed, 32 insertions(+), 37 deletions(-)

diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
--- a/arch/mips/cavium-octeon/smp.c
+++ b/arch/mips/cavium-octeon/smp.c
@@ -268,7 +268,7 @@ static int octeon_cpu_disable(void)
 
 	spin_lock(&smp_reserve_lock);
 
-	cpu_clear(cpu, cpu_online_map);
+	set_cpu_online(cpu, false);
 	cpu_clear(cpu, cpu_callin_map);
 	local_irq_disable();
 	fixup_irqs();
diff --git a/arch/mips/kernel/mips-mt-fpaff.c b/arch/mips/kernel/mips-mt-fpaff.c
--- a/arch/mips/kernel/mips-mt-fpaff.c
+++ b/arch/mips/kernel/mips-mt-fpaff.c
@@ -173,7 +173,7 @@ asmlinkage long mipsmt_sys_sched_getaffi
 	if (retval)
 		goto out_unlock;
 
-	cpus_and(mask, p->thread.user_cpus_allowed, cpu_possible_map);
+	cpumask_and(&mask, &p->thread.user_cpus_allowed, cpu_possible_mask);
 
 out_unlock:
 	read_unlock(&tasklist_lock);
diff --git a/arch/mips/kernel/proc.c b/arch/mips/kernel/proc.c
--- a/arch/mips/kernel/proc.c
+++ b/arch/mips/kernel/proc.c
@@ -25,7 +25,7 @@ static int show_cpuinfo(struct seq_file 
 	int i;
 
 #ifdef CONFIG_SMP
-	if (!cpu_isset(n, cpu_online_map))
+	if (!cpu_online(n))
 		return 0;
 #endif
 
diff --git a/arch/mips/kernel/smp-bmips.c b/arch/mips/kernel/smp-bmips.c
--- a/arch/mips/kernel/smp-bmips.c
+++ b/arch/mips/kernel/smp-bmips.c
@@ -319,7 +319,7 @@ static int bmips_cpu_disable(void)
 
 	pr_info("SMP: CPU%d is offline\n", cpu);
 
-	cpu_clear(cpu, cpu_online_map);
+	set_cpu_online(cpu, false);
 	cpu_clear(cpu, cpu_callin_map);
 
 	local_flush_tlb_all();
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -148,7 +148,7 @@ static void stop_this_cpu(void *dummy)
 	/*
 	 * Remove this CPU:
 	 */
-	cpu_clear(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), false);
 	for (;;) {
 		if (cpu_wait)
 			(*cpu_wait)();		/* Wait if available. */
@@ -174,7 +174,7 @@ void __init smp_prepare_cpus(unsigned in
 	mp_ops->prepare_cpus(max_cpus);
 	set_cpu_sibling_map(0);
 #ifndef CONFIG_HOTPLUG_CPU
-	init_cpu_present(&cpu_possible_map);
+	init_cpu_present(cpu_possible_mask);
 #endif
 }
 
@@ -248,7 +248,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	while (!cpu_isset(cpu, cpu_callin_map))
 		udelay(100);
 
-	cpu_set(cpu, cpu_online_map);
+	set_cpu_online(cpu, true);
 
 	return 0;
 }
@@ -320,13 +320,12 @@ void flush_tlb_mm(struct mm_struct *mm)
 	if ((atomic_read(&mm->mm_users) != 1) || (current->mm != mm)) {
 		smp_on_other_tlbs(flush_tlb_mm_ipi, mm);
 	} else {
-		cpumask_t mask = cpu_online_map;
 		unsigned int cpu;
 
-		cpu_clear(smp_processor_id(), mask);
-		for_each_cpu_mask(cpu, mask)
-			if (cpu_context(cpu, mm))
+		for_each_online_cpu(cpu) {
+			if (cpu != smp_processor_id() && cpu_context(cpu, mm))
 				cpu_context(cpu, mm) = 0;
+		}
 	}
 	local_flush_tlb_mm(mm);
 
@@ -360,13 +359,12 @@ void flush_tlb_range(struct vm_area_stru
 
 		smp_on_other_tlbs(flush_tlb_range_ipi, &fd);
 	} else {
-		cpumask_t mask = cpu_online_map;
 		unsigned int cpu;
 
-		cpu_clear(smp_processor_id(), mask);
-		for_each_cpu_mask(cpu, mask)
-			if (cpu_context(cpu, mm))
+		for_each_online_cpu(cpu) {
+			if (cpu != smp_processor_id() && cpu_context(cpu, mm))
 				cpu_context(cpu, mm) = 0;
+		}
 	}
 	local_flush_tlb_range(vma, start, end);
 	preempt_enable();
@@ -407,13 +405,12 @@ void flush_tlb_page(struct vm_area_struc
 
 		smp_on_other_tlbs(flush_tlb_page_ipi, &fd);
 	} else {
-		cpumask_t mask = cpu_online_map;
 		unsigned int cpu;
 
-		cpu_clear(smp_processor_id(), mask);
-		for_each_cpu_mask(cpu, mask)
-			if (cpu_context(cpu, vma->vm_mm))
+		for_each_online_cpu(cpu) {
+			if (cpu != smp_processor_id() && cpu_context(cpu, vma->vm_mm))
 				cpu_context(cpu, vma->vm_mm) = 0;
+		}
 	}
 	local_flush_tlb_page(vma, page);
 	preempt_enable();
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -292,7 +292,7 @@ static void smtc_configure_tlb(void)
  * possibly leave some TCs/VPEs as "slave" processors.
  *
  * Use c0_MVPConf0 to find out how many TCs are available, setting up
- * cpu_possible_map and the logical/physical mappings.
+ * cpu_possible_mask and the logical/physical mappings.
  */
 
 int __init smtc_build_cpu_map(int start_cpu_slot)
diff --git a/arch/mips/mm/c-octeon.c b/arch/mips/mm/c-octeon.c
--- a/arch/mips/mm/c-octeon.c
+++ b/arch/mips/mm/c-octeon.c
@@ -81,9 +81,9 @@ static void octeon_flush_icache_all_core
 	if (vma)
 		mask = *mm_cpumask(vma->vm_mm);
 	else
-		mask = cpu_online_map;
-	cpu_clear(cpu, mask);
-	for_each_cpu_mask(cpu, mask)
+		mask = *cpu_online_mask;
+	cpumask_clear(&mask, cpu);
+	for_each_cpu(cpu, &mask)
 		octeon_send_ipi_single(cpu, SMP_ICACHE_FLUSH);
 
 	preempt_enable();
diff --git a/arch/mips/netlogic/common/smp.c b/arch/mips/netlogic/common/smp.c
--- a/arch/mips/netlogic/common/smp.c
+++ b/arch/mips/netlogic/common/smp.c
@@ -165,7 +165,7 @@ void __init nlm_smp_setup(void)
 	cpu_set(boot_cpu, phys_cpu_present_map);
 	__cpu_number_map[boot_cpu] = 0;
 	__cpu_logical_map[0] = boot_cpu;
-	cpu_set(0, cpu_possible_map);
+	set_cpu_possible(0, true);
 
 	num_cpus = 1;
 	for (i = 0; i < NR_CPUS; i++) {
@@ -177,14 +177,14 @@ void __init nlm_smp_setup(void)
 			cpu_set(i, phys_cpu_present_map);
 			__cpu_number_map[i] = num_cpus;
 			__cpu_logical_map[num_cpus] = i;
-			cpu_set(num_cpus, cpu_possible_map);
+			set_cpu_possible(num_cpus, true);
 			++num_cpus;
 		}
 	}
 
 	pr_info("Phys CPU present map: %lx, possible map %lx\n",
 		(unsigned long)phys_cpu_present_map.bits[0],
-		(unsigned long)cpu_possible_map.bits[0]);
+		(unsigned long)cpumask_bits(cpu_possible_mask)[0]);
 
 	pr_info("Detected %i Slave CPU(s)\n", num_cpus);
 	nlm_set_nmi_handler(nlm_boot_secondary_cpus);
diff --git a/arch/mips/pmc-sierra/yosemite/smp.c b/arch/mips/pmc-sierra/yosemite/smp.c
--- a/arch/mips/pmc-sierra/yosemite/smp.c
+++ b/arch/mips/pmc-sierra/yosemite/smp.c
@@ -155,10 +155,10 @@ static void __init yos_smp_setup(void)
 {
 	int i;
 
-	cpus_clear(cpu_possible_map);
+	init_cpu_possible(cpu_none_mask);
 
 	for (i = 0; i < 2; i++) {
-		cpu_set(i, cpu_possible_map);
+		set_cpu_possible(i, true);
 		__cpu_number_map[i]	= i;
 		__cpu_logical_map[i]	= i;
 	}
@@ -169,7 +169,7 @@ static void __init yos_prepare_cpus(unsi
 	/*
 	 * Be paranoid.  Enable the IPI only if we're really about to go SMP.
 	 */
-	if (cpus_weight(cpu_possible_map))
+	if (num_possible_cpus())
 		set_c0_status(STATUSF_IP5);
 }
 
diff --git a/arch/mips/sgi-ip27/ip27-smp.c b/arch/mips/sgi-ip27/ip27-smp.c
--- a/arch/mips/sgi-ip27/ip27-smp.c
+++ b/arch/mips/sgi-ip27/ip27-smp.c
@@ -76,7 +76,7 @@ static int do_cpumask(cnodeid_t cnode, n
 			/* Only let it join in if it's marked enabled */
 			if ((acpu->cpu_info.flags & KLINFO_ENABLE) &&
 			    (tot_cpus_found != NR_CPUS)) {
-				cpu_set(cpuid, cpu_possible_map);
+				set_cpu_possible(cpuid, true);
 				alloc_cpupda(cpuid, tot_cpus_found);
 				cpus_found++;
 				tot_cpus_found++;
diff --git a/arch/mips/sibyte/bcm1480/smp.c b/arch/mips/sibyte/bcm1480/smp.c
--- a/arch/mips/sibyte/bcm1480/smp.c
+++ b/arch/mips/sibyte/bcm1480/smp.c
@@ -147,14 +147,13 @@ static void __init bcm1480_smp_setup(voi
 {
 	int i, num;
 
-	cpus_clear(cpu_possible_map);
-	cpu_set(0, cpu_possible_map);
+	init_cpu_possible(cpumask_of(0));
 	__cpu_number_map[0] = 0;
 	__cpu_logical_map[0] = 0;
 
 	for (i = 1, num = 0; i < NR_CPUS; i++) {
 		if (cfe_cpu_stop(i) == 0) {
-			cpu_set(i, cpu_possible_map);
+			set_cpu_possible(i, true);
 			__cpu_number_map[i] = ++num;
 			__cpu_logical_map[num] = i;
 		}
diff --git a/arch/mips/sibyte/sb1250/smp.c b/arch/mips/sibyte/sb1250/smp.c
--- a/arch/mips/sibyte/sb1250/smp.c
+++ b/arch/mips/sibyte/sb1250/smp.c
@@ -126,7 +126,7 @@ static void __cpuinit sb1250_boot_second
 
 /*
  * Use CFE to find out how many CPUs are available, setting up
- * cpu_possible_map and the logical/physical mappings.
+ * cpu_possible_mask and the logical/physical mappings.
  * XXXKW will the boot CPU ever not be physical 0?
  *
  * Common setup before any secondaries are started
@@ -135,14 +135,13 @@ static void __init sb1250_smp_setup(void
 {
 	int i, num;
 
-	cpus_clear(cpu_possible_map);
-	cpu_set(0, cpu_possible_map);
+	init_cpu_possible(cpumask_of(0));
 	__cpu_number_map[0] = 0;
 	__cpu_logical_map[0] = 0;
 
 	for (i = 1, num = 0; i < NR_CPUS; i++) {
 		if (cfe_cpu_stop(i) == 0) {
-			cpu_set(i, cpu_possible_map);
+			set_cpu_possible(i, true);
 			__cpu_number_map[i] = ++num;
 			__cpu_logical_map[num] = i;
 		}

