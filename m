Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621Ab1D1POP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:14:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54168 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296Ab1D1POL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:14:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH] sparc: convert old cpumask API into new one
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20110429001547.3D6C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri, 29 Apr 2011 00:14:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt new API. Almost change is trivial, most important change are to
remove following like =operator.

 cpumask_t cpu_mask = *mm_cpumask(mm);
 cpus_allowed = current->cpus_allowed;

Because cpumask_var_t is =operator unsafe. These usage might prevent
kernel core improvement.

No functional change.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/include/asm/smp_32.h  |   12 ++++----
 arch/sparc/kernel/cpumap.c       |    4 +-
 arch/sparc/kernel/ds.c           |   14 ++++----
 arch/sparc/kernel/irq_64.c       |    6 ++--
 arch/sparc/kernel/leon_smp.c     |   20 ++++++------
 arch/sparc/kernel/mdesc.c        |    2 +-
 arch/sparc/kernel/of_device_64.c |    3 +-
 arch/sparc/kernel/pci_msi.c      |    3 +-
 arch/sparc/kernel/smp_32.c       |   51 +++++++++++++++++++--------------
 arch/sparc/kernel/smp_64.c       |   58 +++++++++++++++++++-------------------
 arch/sparc/kernel/sun4d_smp.c    |   12 ++++----
 arch/sparc/kernel/sun4m_smp.c    |   12 ++++----
 arch/sparc/kernel/sysfs.c        |    3 +-
 arch/sparc/kernel/us2e_cpufreq.c |    4 +-
 arch/sparc/kernel/us3_cpufreq.c  |    4 +-
 arch/sparc/mm/init_64.c          |   14 ++++----
 16 files changed, 116 insertions(+), 106 deletions(-)

diff --git a/arch/sparc/include/asm/smp_32.h b/arch/sparc/include/asm/smp_32.h
index d82d7f4..dd7a6be 100644
--- a/arch/sparc/include/asm/smp_32.h
+++ b/arch/sparc/include/asm/smp_32.h
@@ -61,17 +61,17 @@ BTFIXUPDEF_BLACKBOX(load_current)
 
 #define smp_cross_call(func,mask,arg1,arg2,arg3,arg4) BTFIXUP_CALL(smp_cross_call)(func,mask,arg1,arg2,arg3,arg4)
 
-static inline void xc0(smpfunc_t func) { smp_cross_call(func, cpu_online_map, 0, 0, 0, 0); }
+static inline void xc0(smpfunc_t func) { smp_cross_call(func, *cpu_online_mask, 0, 0, 0, 0); }
 static inline void xc1(smpfunc_t func, unsigned long arg1)
-{ smp_cross_call(func, cpu_online_map, arg1, 0, 0, 0); }
+{ smp_cross_call(func, *cpu_online_mask, arg1, 0, 0, 0); }
 static inline void xc2(smpfunc_t func, unsigned long arg1, unsigned long arg2)
-{ smp_cross_call(func, cpu_online_map, arg1, arg2, 0, 0); }
+{ smp_cross_call(func, *cpu_online_mask, arg1, arg2, 0, 0); }
 static inline void xc3(smpfunc_t func, unsigned long arg1, unsigned long arg2,
 			   unsigned long arg3)
-{ smp_cross_call(func, cpu_online_map, arg1, arg2, arg3, 0); }
+{ smp_cross_call(func, *cpu_online_mask, arg1, arg2, arg3, 0); }
 static inline void xc4(smpfunc_t func, unsigned long arg1, unsigned long arg2,
 			   unsigned long arg3, unsigned long arg4)
-{ smp_cross_call(func, cpu_online_map, arg1, arg2, arg3, arg4); }
+{ smp_cross_call(func, *cpu_online_mask, arg1, arg2, arg3, arg4); }
 
 static inline int smp_call_function(void (*func)(void *info), void *info, int wait)
 {
@@ -82,7 +82,7 @@ static inline int smp_call_function(void (*func)(void *info), void *info, int wa
 static inline int smp_call_function_single(int cpuid, void (*func) (void *info),
 					   void *info, int wait)
 {
-	smp_cross_call((smpfunc_t)func, cpumask_of_cpu(cpuid),
+	smp_cross_call((smpfunc_t)func, *cpumask_of(cpuid),
 		       (unsigned long) info, 0, 0, 0);
 	return 0;
 }
diff --git a/arch/sparc/kernel/cpumap.c b/arch/sparc/kernel/cpumap.c
index 8de64c8..d91fd78 100644
--- a/arch/sparc/kernel/cpumap.c
+++ b/arch/sparc/kernel/cpumap.c
@@ -202,7 +202,7 @@ static struct cpuinfo_tree *build_cpuinfo_tree(void)
 	new_tree->total_nodes = n;
 	memcpy(&new_tree->level, tmp_level, sizeof(tmp_level));
 
-	prev_cpu = cpu = first_cpu(cpu_online_map);
+	prev_cpu = cpu = cpumask_first(cpu_online_mask);
 
 	/* Initialize all levels in the tree with the first CPU */
 	for (level = CPUINFO_LVL_PROC; level >= CPUINFO_LVL_ROOT; level--) {
@@ -381,7 +381,7 @@ static int simple_map_to_cpu(unsigned int index)
 	}
 
 	/* Impossible, since num_online_cpus() <= num_possible_cpus() */
-	return first_cpu(cpu_online_map);
+	return cpumask_first(cpu_online_mask);
 }
 
 static int _map_to_cpu(unsigned int index)
diff --git a/arch/sparc/kernel/ds.c b/arch/sparc/kernel/ds.c
index 3add4de..dd1342c 100644
--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -497,7 +497,7 @@ static void dr_cpu_init_response(struct ds_data *resp, u64 req_num,
 	tag->num_records = ncpus;
 
 	i = 0;
-	for_each_cpu_mask(cpu, *mask) {
+	for_each_cpu(cpu, mask) {
 		ent[i].cpu = cpu;
 		ent[i].result = DR_CPU_RES_OK;
 		ent[i].stat = default_stat;
@@ -534,7 +534,7 @@ static int __cpuinit dr_cpu_configure(struct ds_info *dp,
 	int resp_len, ncpus, cpu;
 	unsigned long flags;
 
-	ncpus = cpus_weight(*mask);
+	ncpus = cpumask_weight(mask);
 	resp_len = dr_cpu_size_response(ncpus);
 	resp = kzalloc(resp_len, GFP_KERNEL);
 	if (!resp)
@@ -547,7 +547,7 @@ static int __cpuinit dr_cpu_configure(struct ds_info *dp,
 	mdesc_populate_present_mask(mask);
 	mdesc_fill_in_cpu_data(mask);
 
-	for_each_cpu_mask(cpu, *mask) {
+	for_each_cpu(cpu, mask) {
 		int err;
 
 		printk(KERN_INFO "ds-%llu: Starting cpu %d...\n",
@@ -593,7 +593,7 @@ static int dr_cpu_unconfigure(struct ds_info *dp,
 	int resp_len, ncpus, cpu;
 	unsigned long flags;
 
-	ncpus = cpus_weight(*mask);
+	ncpus = cpumask_weight(mask);
 	resp_len = dr_cpu_size_response(ncpus);
 	resp = kzalloc(resp_len, GFP_KERNEL);
 	if (!resp)
@@ -603,7 +603,7 @@ static int dr_cpu_unconfigure(struct ds_info *dp,
 			     resp_len, ncpus, mask,
 			     DR_CPU_STAT_UNCONFIGURED);
 
-	for_each_cpu_mask(cpu, *mask) {
+	for_each_cpu(cpu, mask) {
 		int err;
 
 		printk(KERN_INFO "ds-%llu: Shutting down cpu %d...\n",
@@ -649,13 +649,13 @@ static void __cpuinit dr_cpu_data(struct ds_info *dp,
 
 	purge_dups(cpu_list, tag->num_records);
 
-	cpus_clear(mask);
+	cpumask_clear(&mask);
 	for (i = 0; i < tag->num_records; i++) {
 		if (cpu_list[i] == CPU_SENTINEL)
 			continue;
 
 		if (cpu_list[i] < nr_cpu_ids)
-			cpu_set(cpu_list[i], mask);
+			cpumask_set_cpu(cpu_list[i], &mask);
 	}
 
 	if (tag->type == DR_CPU_CONFIGURE)
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index b1d275c..4e78862 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -224,13 +224,13 @@ static int irq_choose_cpu(unsigned int irq, const struct cpumask *affinity)
 	int cpuid;
 
 	cpumask_copy(&mask, affinity);
-	if (cpus_equal(mask, cpu_online_map)) {
+	if (cpumask_equal(&mask, cpu_online_mask)) {
 		cpuid = map_to_cpu(irq);
 	} else {
 		cpumask_t tmp;
 
-		cpus_and(tmp, cpu_online_map, mask);
-		cpuid = cpus_empty(tmp) ? map_to_cpu(irq) : first_cpu(tmp);
+		cpumask_and(&tmp, cpu_online_mask, &mask);
+		cpuid = cpumask_empty(&tmp) ? map_to_cpu(irq) : cpumask_first(&tmp);
 	}
 
 	return cpuid;
diff --git a/arch/sparc/kernel/leon_smp.c b/arch/sparc/kernel/leon_smp.c
index 8f5de4a..3c5014b 100644
--- a/arch/sparc/kernel/leon_smp.c
+++ b/arch/sparc/kernel/leon_smp.c
@@ -104,11 +104,11 @@ void __cpuinit leon_callin(void)
 	atomic_inc(&init_mm.mm_count);
 	current->active_mm = &init_mm;
 
-	while (!cpu_isset(cpuid, smp_commenced_mask))
+	while (!cpumask_test_cpu(cpuid, &smp_commenced_mask))
 		mb();
 
 	local_irq_enable();
-	cpu_set(cpuid, cpu_online_map);
+	set_cpu_online(cpuid, true);
 }
 
 /*
@@ -262,21 +262,21 @@ void __init leon_smp_done(void)
 	local_flush_cache_all();
 
 	/* Free unneeded trap tables */
-	if (!cpu_isset(1, cpu_present_map)) {
+	if (!cpu_present(1)) {
 		ClearPageReserved(virt_to_page(&trapbase_cpu1));
 		init_page_count(virt_to_page(&trapbase_cpu1));
 		free_page((unsigned long)&trapbase_cpu1);
 		totalram_pages++;
 		num_physpages++;
 	}
-	if (!cpu_isset(2, cpu_present_map)) {
+	if (!cpu_present(2)) {
 		ClearPageReserved(virt_to_page(&trapbase_cpu2));
 		init_page_count(virt_to_page(&trapbase_cpu2));
 		free_page((unsigned long)&trapbase_cpu2);
 		totalram_pages++;
 		num_physpages++;
 	}
-	if (!cpu_isset(3, cpu_present_map)) {
+	if (!cpu_present(3)) {
 		ClearPageReserved(virt_to_page(&trapbase_cpu3));
 		init_page_count(virt_to_page(&trapbase_cpu3));
 		free_page((unsigned long)&trapbase_cpu3);
@@ -337,10 +337,10 @@ static void leon_cross_call(smpfunc_t func, cpumask_t mask, unsigned long arg1,
 		{
 			register int i;
 
-			cpu_clear(smp_processor_id(), mask);
-			cpus_and(mask, cpu_online_map, mask);
+			cpumask_clear_cpu(smp_processor_id(), &mask);
+			cpumask_and(&mask, cpu_online_mask, &mask);
 			for (i = 0; i <= high; i++) {
-				if (cpu_isset(i, mask)) {
+				if (cpumask_test_cpu(i, &mask)) {
 					ccall_info.processors_in[i] = 0;
 					ccall_info.processors_out[i] = 0;
 					set_cpu_int(i, LEON3_IRQ_CROSS_CALL);
@@ -354,7 +354,7 @@ static void leon_cross_call(smpfunc_t func, cpumask_t mask, unsigned long arg1,
 
 			i = 0;
 			do {
-				if (!cpu_isset(i, mask))
+				if (!cpumask_test_cpu(i, &mask))
 					continue;
 
 				while (!ccall_info.processors_in[i])
@@ -363,7 +363,7 @@ static void leon_cross_call(smpfunc_t func, cpumask_t mask, unsigned long arg1,
 
 			i = 0;
 			do {
-				if (!cpu_isset(i, mask))
+				if (!cpumask_test_cpu(i, &mask))
 					continue;
 
 				while (!ccall_info.processors_out[i])
diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index 56db064..42f28c7 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -768,7 +768,7 @@ static void * __cpuinit mdesc_iterate_over_cpus(void *(*func)(struct mdesc_handl
 			       cpuid, NR_CPUS);
 			continue;
 		}
-		if (!cpu_isset(cpuid, *mask))
+		if (!cpumask_test_cpu(cpuid, mask))
 			continue;
 #endif
 
diff --git a/arch/sparc/kernel/of_device_64.c b/arch/sparc/kernel/of_device_64.c
index 5c14968..3bb2eac 100644
--- a/arch/sparc/kernel/of_device_64.c
+++ b/arch/sparc/kernel/of_device_64.c
@@ -622,8 +622,9 @@ static unsigned int __init build_one_device_irq(struct platform_device *op,
 out:
 	nid = of_node_to_nid(dp);
 	if (nid != -1) {
-		cpumask_t numa_mask = *cpumask_of_node(nid);
+		cpumask_t numa_mask;
 
+		cpumask_copy(&numa_mask, cpumask_of_node(nid));
 		irq_set_affinity(irq, &numa_mask);
 	}
 
diff --git a/arch/sparc/kernel/pci_msi.c b/arch/sparc/kernel/pci_msi.c
index 30982e9..580651a 100644
--- a/arch/sparc/kernel/pci_msi.c
+++ b/arch/sparc/kernel/pci_msi.c
@@ -284,8 +284,9 @@ static int bringup_one_msi_queue(struct pci_pbm_info *pbm,
 
 	nid = pbm->numa_node;
 	if (nid != -1) {
-		cpumask_t numa_mask = *cpumask_of_node(nid);
+		cpumask_t numa_mask;
 
+		cpumask_copy(&numa_mask, cpumask_of_node(nid));
 		irq_set_affinity(irq, &numa_mask);
 	}
 	err = request_irq(irq, sparc64_msiq_interrupt, 0,
diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index f95690c..e6b74b5 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -149,9 +149,10 @@ void smp_flush_tlb_all(void)
 void smp_flush_cache_mm(struct mm_struct *mm)
 {
 	if(mm->context != NO_CONTEXT) {
-		cpumask_t cpu_mask = *mm_cpumask(mm);
-		cpu_clear(smp_processor_id(), cpu_mask);
-		if (!cpus_empty(cpu_mask))
+		cpumask_t cpu_mask;
+		cpumask_copy(&cpu_mask, mm_cpumask(mm));
+		cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
+		if (!cpumask_empty(&cpu_mask))
 			xc1((smpfunc_t) BTFIXUP_CALL(local_flush_cache_mm), (unsigned long) mm);
 		local_flush_cache_mm(mm);
 	}
@@ -160,9 +161,10 @@ void smp_flush_cache_mm(struct mm_struct *mm)
 void smp_flush_tlb_mm(struct mm_struct *mm)
 {
 	if(mm->context != NO_CONTEXT) {
-		cpumask_t cpu_mask = *mm_cpumask(mm);
-		cpu_clear(smp_processor_id(), cpu_mask);
-		if (!cpus_empty(cpu_mask)) {
+		cpumask_t cpu_mask;
+		cpumask_copy(&cpu_mask, mm_cpumask(mm));
+		cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
+		if (!cpumask_empty(&cpu_mask)) {
 			xc1((smpfunc_t) BTFIXUP_CALL(local_flush_tlb_mm), (unsigned long) mm);
 			if(atomic_read(&mm->mm_users) == 1 && current->active_mm == mm)
 				cpumask_copy(mm_cpumask(mm),
@@ -178,9 +180,10 @@ void smp_flush_cache_range(struct vm_area_struct *vma, unsigned long start,
 	struct mm_struct *mm = vma->vm_mm;
 
 	if (mm->context != NO_CONTEXT) {
-		cpumask_t cpu_mask = *mm_cpumask(mm);
-		cpu_clear(smp_processor_id(), cpu_mask);
-		if (!cpus_empty(cpu_mask))
+		cpumask_t cpu_mask;
+		cpumask_copy(&cpu_mask, mm_cpumask(mm));
+		cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
+		if (!cpumask_empty(&cpu_mask))
 			xc3((smpfunc_t) BTFIXUP_CALL(local_flush_cache_range), (unsigned long) vma, start, end);
 		local_flush_cache_range(vma, start, end);
 	}
@@ -192,9 +195,10 @@ void smp_flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 	struct mm_struct *mm = vma->vm_mm;
 
 	if (mm->context != NO_CONTEXT) {
-		cpumask_t cpu_mask = *mm_cpumask(mm);
-		cpu_clear(smp_processor_id(), cpu_mask);
-		if (!cpus_empty(cpu_mask))
+		cpumask_t cpu_mask;
+		cpumask_copy(&cpu_mask, mm_cpumask(mm));
+		cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
+		if (!cpumask_empty(&cpu_mask))
 			xc3((smpfunc_t) BTFIXUP_CALL(local_flush_tlb_range), (unsigned long) vma, start, end);
 		local_flush_tlb_range(vma, start, end);
 	}
@@ -205,9 +209,10 @@ void smp_flush_cache_page(struct vm_area_struct *vma, unsigned long page)
 	struct mm_struct *mm = vma->vm_mm;
 
 	if(mm->context != NO_CONTEXT) {
-		cpumask_t cpu_mask = *mm_cpumask(mm);
-		cpu_clear(smp_processor_id(), cpu_mask);
-		if (!cpus_empty(cpu_mask))
+		cpumask_t cpu_mask;
+		cpumask_copy(&cpu_mask, mm_cpumask(mm));
+		cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
+		if (!cpumask_empty(&cpu_mask))
 			xc2((smpfunc_t) BTFIXUP_CALL(local_flush_cache_page), (unsigned long) vma, page);
 		local_flush_cache_page(vma, page);
 	}
@@ -218,9 +223,10 @@ void smp_flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
 	struct mm_struct *mm = vma->vm_mm;
 
 	if(mm->context != NO_CONTEXT) {
-		cpumask_t cpu_mask = *mm_cpumask(mm);
-		cpu_clear(smp_processor_id(), cpu_mask);
-		if (!cpus_empty(cpu_mask))
+		cpumask_t cpu_mask;
+		cpumask_copy(&cpu_mask, mm_cpumask(mm));
+		cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
+		if (!cpumask_empty(&cpu_mask))
 			xc2((smpfunc_t) BTFIXUP_CALL(local_flush_tlb_page), (unsigned long) vma, page);
 		local_flush_tlb_page(vma, page);
 	}
@@ -247,9 +253,10 @@ void smp_flush_page_to_ram(unsigned long page)
 
 void smp_flush_sig_insns(struct mm_struct *mm, unsigned long insn_addr)
 {
-	cpumask_t cpu_mask = *mm_cpumask(mm);
-	cpu_clear(smp_processor_id(), cpu_mask);
-	if (!cpus_empty(cpu_mask))
+	cpumask_t cpu_mask;
+	cpumask_copy(&cpu_mask, mm_cpumask(mm));
+	cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
+	if (!cpumask_empty(&cpu_mask))
 		xc2((smpfunc_t) BTFIXUP_CALL(local_flush_sig_insns), (unsigned long) mm, insn_addr);
 	local_flush_sig_insns(mm, insn_addr);
 }
@@ -403,7 +410,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	};
 
 	if (!ret) {
-		cpu_set(cpu, smp_commenced_mask);
+		cpumask_set_cpu(cpu, &smp_commenced_mask);
 		while (!cpu_online(cpu))
 			mb();
 	}
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 9478da7..99cb172 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -121,11 +121,11 @@ void __cpuinit smp_callin(void)
 	/* inform the notifiers about the new cpu */
 	notify_cpu_starting(cpuid);
 
-	while (!cpu_isset(cpuid, smp_commenced_mask))
+	while (!cpumask_test_cpu(cpuid, &smp_commenced_mask))
 		rmb();
 
 	ipi_call_lock_irq();
-	cpu_set(cpuid, cpu_online_map);
+	set_cpu_online(cpuid, true);
 	ipi_call_unlock_irq();
 
 	/* idle thread is expected to have preempt disabled */
@@ -785,7 +785,7 @@ static void xcall_deliver(u64 data0, u64 data1, u64 data2, const cpumask_t *mask
 
 /* Send cross call to all processors mentioned in MASK_P
  * except self.  Really, there are only two cases currently,
- * "&cpu_online_map" and "&mm->cpu_vm_mask".
+ * "cpu_online_mask" and "mm_cpumask(mm)".
  */
 static void smp_cross_call_masked(unsigned long *func, u32 ctx, u64 data1, u64 data2, const cpumask_t *mask)
 {
@@ -797,7 +797,7 @@ static void smp_cross_call_masked(unsigned long *func, u32 ctx, u64 data1, u64 d
 /* Send cross call to all processors except self. */
 static void smp_cross_call(unsigned long *func, u32 ctx, u64 data1, u64 data2)
 {
-	smp_cross_call_masked(func, ctx, data1, data2, &cpu_online_map);
+	smp_cross_call_masked(func, ctx, data1, data2, cpu_online_mask);
 }
 
 extern unsigned long xcall_sync_tick;
@@ -805,7 +805,7 @@ extern unsigned long xcall_sync_tick;
 static void smp_start_sync_tick_client(int cpu)
 {
 	xcall_deliver((u64) &xcall_sync_tick, 0, 0,
-		      &cpumask_of_cpu(cpu));
+		      cpumask_of(cpu));
 }
 
 extern unsigned long xcall_call_function;
@@ -820,7 +820,7 @@ extern unsigned long xcall_call_function_single;
 void arch_send_call_function_single_ipi(int cpu)
 {
 	xcall_deliver((u64) &xcall_call_function_single, 0, 0,
-		      &cpumask_of_cpu(cpu));
+		      cpumask_of(cpu));
 }
 
 void __irq_entry smp_call_function_client(int irq, struct pt_regs *regs)
@@ -918,7 +918,7 @@ void smp_flush_dcache_page_impl(struct page *page, int cpu)
 		}
 		if (data0) {
 			xcall_deliver(data0, __pa(pg_addr),
-				      (u64) pg_addr, &cpumask_of_cpu(cpu));
+				      (u64) pg_addr, cpumask_of(cpu));
 #ifdef CONFIG_DEBUG_DCFLUSH
 			atomic_inc(&dcpage_flushes_xcall);
 #endif
@@ -954,7 +954,7 @@ void flush_dcache_page_all(struct mm_struct *mm, struct page *page)
 	}
 	if (data0) {
 		xcall_deliver(data0, __pa(pg_addr),
-			      (u64) pg_addr, &cpu_online_map);
+			      (u64) pg_addr, cpu_online_mask);
 #ifdef CONFIG_DEBUG_DCFLUSH
 		atomic_inc(&dcpage_flushes_xcall);
 #endif
@@ -1197,32 +1197,32 @@ void __devinit smp_fill_in_sib_core_maps(void)
 	for_each_present_cpu(i) {
 		unsigned int j;
 
-		cpus_clear(cpu_core_map[i]);
+		cpumask_clear(&cpu_core_map[i]);
 		if (cpu_data(i).core_id == 0) {
-			cpu_set(i, cpu_core_map[i]);
+			cpumask_set_cpu(i, &cpu_core_map[i]);
 			continue;
 		}
 
 		for_each_present_cpu(j) {
 			if (cpu_data(i).core_id ==
 			    cpu_data(j).core_id)
-				cpu_set(j, cpu_core_map[i]);
+				cpumask_set_cpu(j, &cpu_core_map[i]);
 		}
 	}
 
 	for_each_present_cpu(i) {
 		unsigned int j;
 
-		cpus_clear(per_cpu(cpu_sibling_map, i));
+		cpumask_clear(&per_cpu(cpu_sibling_map, i));
 		if (cpu_data(i).proc_id == -1) {
-			cpu_set(i, per_cpu(cpu_sibling_map, i));
+			cpumask_set_cpu(i, &per_cpu(cpu_sibling_map, i));
 			continue;
 		}
 
 		for_each_present_cpu(j) {
 			if (cpu_data(i).proc_id ==
 			    cpu_data(j).proc_id)
-				cpu_set(j, per_cpu(cpu_sibling_map, i));
+				cpumask_set_cpu(j, &per_cpu(cpu_sibling_map, i));
 		}
 	}
 }
@@ -1232,10 +1232,10 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	int ret = smp_boot_one_cpu(cpu);
 
 	if (!ret) {
-		cpu_set(cpu, smp_commenced_mask);
-		while (!cpu_isset(cpu, cpu_online_map))
+		cpumask_set_cpu(cpu, &smp_commenced_mask);
+		while (!cpu_online(cpu))
 			mb();
-		if (!cpu_isset(cpu, cpu_online_map)) {
+		if (!cpu_online(cpu)) {
 			ret = -ENODEV;
 		} else {
 			/* On SUN4V, writes to %tick and %stick are
@@ -1269,7 +1269,7 @@ void cpu_play_dead(void)
 				tb->nonresum_mondo_pa, 0);
 	}
 
-	cpu_clear(cpu, smp_commenced_mask);
+	cpumask_clear_cpu(cpu, &smp_commenced_mask);
 	membar_safe("#Sync");
 
 	local_irq_disable();
@@ -1290,13 +1290,13 @@ int __cpu_disable(void)
 	cpuinfo_sparc *c;
 	int i;
 
-	for_each_cpu_mask(i, cpu_core_map[cpu])
-		cpu_clear(cpu, cpu_core_map[i]);
-	cpus_clear(cpu_core_map[cpu]);
+	for_each_cpu(i, &cpu_core_map[cpu])
+		cpumask_clear_cpu(cpu, &cpu_core_map[i]);
+	cpumask_clear(&cpu_core_map[cpu]);
 
-	for_each_cpu_mask(i, per_cpu(cpu_sibling_map, cpu))
-		cpu_clear(cpu, per_cpu(cpu_sibling_map, i));
-	cpus_clear(per_cpu(cpu_sibling_map, cpu));
+	for_each_cpu(i, &per_cpu(cpu_sibling_map, cpu))
+		cpumask_clear_cpu(cpu, &per_cpu(cpu_sibling_map, i));
+	cpumask_clear(&per_cpu(cpu_sibling_map, cpu));
 
 	c = &cpu_data(cpu);
 
@@ -1313,7 +1313,7 @@ int __cpu_disable(void)
 	local_irq_disable();
 
 	ipi_call_lock();
-	cpu_clear(cpu, cpu_online_map);
+	set_cpu_online(cpu, false);
 	ipi_call_unlock();
 
 	cpu_map_rebuild();
@@ -1327,11 +1327,11 @@ void __cpu_die(unsigned int cpu)
 
 	for (i = 0; i < 100; i++) {
 		smp_rmb();
-		if (!cpu_isset(cpu, smp_commenced_mask))
+		if (!cpumask_test_cpu(cpu, &smp_commenced_mask))
 			break;
 		msleep(100);
 	}
-	if (cpu_isset(cpu, smp_commenced_mask)) {
+	if (cpumask_test_cpu(cpu, &smp_commenced_mask)) {
 		printk(KERN_ERR "CPU %u didn't die...\n", cpu);
 	} else {
 #if defined(CONFIG_SUN_LDOMS)
@@ -1341,7 +1341,7 @@ void __cpu_die(unsigned int cpu)
 		do {
 			hv_err = sun4v_cpu_stop(cpu);
 			if (hv_err == HV_EOK) {
-				cpu_clear(cpu, cpu_present_map);
+				set_cpu_present(cpu, false);
 				break;
 			}
 		} while (--limit > 0);
@@ -1362,7 +1362,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
 void smp_send_reschedule(int cpu)
 {
 	xcall_deliver((u64) &xcall_receive_signal, 0, 0,
-		      &cpumask_of_cpu(cpu));
+		      cpumask_of(cpu));
 }
 
 void __irq_entry smp_receive_signal_client(int irq, struct pt_regs *regs)
diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
index 475d50b..3d4185c 100644
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -105,7 +105,7 @@ void __cpuinit smp4d_callin(void)
 
 	local_irq_enable();	/* We don't allow PIL 14 yet */
 
-	while (!cpu_isset(cpuid, smp_commenced_mask))
+	while (!cpumask_test_cpu(cpuid, &smp_commenced_mask))
 		barrier();
 
 	spin_lock_irqsave(&sun4d_imsk_lock, flags);
@@ -239,10 +239,10 @@ static void smp4d_cross_call(smpfunc_t func, cpumask_t mask, unsigned long arg1,
 		{
 			register int i;
 
-			cpu_clear(smp_processor_id(), mask);
-			cpus_and(mask, cpu_online_map, mask);
+			cpumask_clear_cpu(smp_processor_id(), &mask);
+			cpumask_and(&mask, cpu_online_mask, &mask);
 			for (i = 0; i <= high; i++) {
-				if (cpu_isset(i, mask)) {
+				if (cpumask_test_cpu(i, &mask)) {
 					ccall_info.processors_in[i] = 0;
 					ccall_info.processors_out[i] = 0;
 					sun4d_send_ipi(i, IRQ_CROSS_CALL);
@@ -255,7 +255,7 @@ static void smp4d_cross_call(smpfunc_t func, cpumask_t mask, unsigned long arg1,
 
 			i = 0;
 			do {
-				if (!cpu_isset(i, mask))
+				if (!cpumask_test_cpu(i, &mask))
 					continue;
 				while (!ccall_info.processors_in[i])
 					barrier();
@@ -263,7 +263,7 @@ static void smp4d_cross_call(smpfunc_t func, cpumask_t mask, unsigned long arg1,
 
 			i = 0;
 			do {
-				if (!cpu_isset(i, mask))
+				if (!cpumask_test_cpu(i, &mask))
 					continue;
 				while (!ccall_info.processors_out[i])
 					barrier();
diff --git a/arch/sparc/kernel/sun4m_smp.c b/arch/sparc/kernel/sun4m_smp.c
index 5cc7dc5..68e6011 100644
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -70,7 +70,7 @@ void __cpuinit smp4m_callin(void)
 	atomic_inc(&init_mm.mm_count);
 	current->active_mm = &init_mm;
 
-	while (!cpu_isset(cpuid, smp_commenced_mask))
+	while (!cpumask_test_cpu(cpuid, &smp_commenced_mask))
 		mb();
 
 	local_irq_enable();
@@ -199,10 +199,10 @@ static void smp4m_cross_call(smpfunc_t func, cpumask_t mask, unsigned long arg1,
 		{
 			register int i;
 
-			cpu_clear(smp_processor_id(), mask);
-			cpus_and(mask, cpu_online_map, mask);
+			cpumask_clear_cpu(smp_processor_id(), &mask);
+			cpumask_and(&mask, cpu_online_mask, &mask);
 			for (i = 0; i < ncpus; i++) {
-				if (cpu_isset(i, mask)) {
+				if (cpumask_test_cpu(i, &mask)) {
 					ccall_info.processors_in[i] = 0;
 					ccall_info.processors_out[i] = 0;
 					set_cpu_int(i, IRQ_CROSS_CALL);
@@ -218,7 +218,7 @@ static void smp4m_cross_call(smpfunc_t func, cpumask_t mask, unsigned long arg1,
 
 			i = 0;
 			do {
-				if (!cpu_isset(i, mask))
+				if (!cpumask_test_cpu(i, &mask))
 					continue;
 				while (!ccall_info.processors_in[i])
 					barrier();
@@ -226,7 +226,7 @@ static void smp4m_cross_call(smpfunc_t func, cpumask_t mask, unsigned long arg1,
 
 			i = 0;
 			do {
-				if (!cpu_isset(i, mask))
+				if (!cpumask_test_cpu(i, &mask))
 					continue;
 				while (!ccall_info.processors_out[i])
 					barrier();
diff --git a/arch/sparc/kernel/sysfs.c b/arch/sparc/kernel/sysfs.c
index 1eb8b00..7408201 100644
--- a/arch/sparc/kernel/sysfs.c
+++ b/arch/sparc/kernel/sysfs.c
@@ -103,9 +103,10 @@ static unsigned long run_on_cpu(unsigned long cpu,
 			        unsigned long (*func)(unsigned long),
 				unsigned long arg)
 {
-	cpumask_t old_affinity = current->cpus_allowed;
+	cpumask_t old_affinity;
 	unsigned long ret;
 
+	cpumask_copy(&old_affinity, tsk_cpus_allowed(current));
 	/* should return -EINVAL to userspace */
 	if (set_cpus_allowed_ptr(current, cpumask_of(cpu)))
 		return 0;
diff --git a/arch/sparc/kernel/us2e_cpufreq.c b/arch/sparc/kernel/us2e_cpufreq.c
index 8f982b7..531d54f 100644
--- a/arch/sparc/kernel/us2e_cpufreq.c
+++ b/arch/sparc/kernel/us2e_cpufreq.c
@@ -237,7 +237,7 @@ static unsigned int us2e_freq_get(unsigned int cpu)
 	if (!cpu_online(cpu))
 		return 0;
 
-	cpus_allowed = current->cpus_allowed;
+	cpumask_copy(&cpus_allowed, tsk_cpus_allowed(current));
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
 	clock_tick = sparc64_get_clock_tick(cpu) / 1000;
@@ -258,7 +258,7 @@ static void us2e_set_cpu_divider_index(unsigned int cpu, unsigned int index)
 	if (!cpu_online(cpu))
 		return;
 
-	cpus_allowed = current->cpus_allowed;
+	cpumask_copy(&cpus_allowed, tsk_cpus_allowed(current));
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
 	new_freq = clock_tick = sparc64_get_clock_tick(cpu) / 1000;
diff --git a/arch/sparc/kernel/us3_cpufreq.c b/arch/sparc/kernel/us3_cpufreq.c
index f35d1e7..9a8ceb7 100644
--- a/arch/sparc/kernel/us3_cpufreq.c
+++ b/arch/sparc/kernel/us3_cpufreq.c
@@ -85,7 +85,7 @@ static unsigned int us3_freq_get(unsigned int cpu)
 	if (!cpu_online(cpu))
 		return 0;
 
-	cpus_allowed = current->cpus_allowed;
+	cpumask_copy(&cpus_allowed, tsk_cpus_allowed(current));
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
 	reg = read_safari_cfg();
@@ -105,7 +105,7 @@ static void us3_set_cpu_divider_index(unsigned int cpu, unsigned int index)
 	if (!cpu_online(cpu))
 		return;
 
-	cpus_allowed = current->cpus_allowed;
+	cpumask_copy(&cpus_allowed, tsk_cpus_allowed(current));
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
 	new_freq = sparc64_get_clock_tick(cpu) / 1000;
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 2f6ae1d..e10cd03 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -862,7 +862,7 @@ static void init_node_masks_nonnuma(void)
 	for (i = 0; i < NR_CPUS; i++)
 		numa_cpu_lookup_table[i] = 0;
 
-	numa_cpumask_lookup_table[0] = CPU_MASK_ALL;
+	cpumask_setall(&numa_cpumask_lookup_table[0]);
 }
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
@@ -1080,7 +1080,7 @@ static void __init numa_parse_mdesc_group_cpus(struct mdesc_handle *md,
 {
 	u64 arc;
 
-	cpus_clear(*mask);
+	cpumask_clear(mask);
 
 	mdesc_for_each_arc(arc, md, grp, MDESC_ARC_TYPE_BACK) {
 		u64 target = mdesc_arc_target(md, arc);
@@ -1091,7 +1091,7 @@ static void __init numa_parse_mdesc_group_cpus(struct mdesc_handle *md,
 			continue;
 		id = mdesc_get_property(md, target, "id", NULL);
 		if (*id < nr_cpu_ids)
-			cpu_set(*id, *mask);
+			cpumask_set_cpu(*id, mask);
 	}
 }
 
@@ -1153,13 +1153,13 @@ static int __init numa_parse_mdesc_group(struct mdesc_handle *md, u64 grp,
 
 	numa_parse_mdesc_group_cpus(md, grp, &mask);
 
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu(cpu, &mask)
 		numa_cpu_lookup_table[cpu] = index;
-	numa_cpumask_lookup_table[index] = mask;
+	cpumask_copy(&numa_cpumask_lookup_table[index], &mask);
 
 	if (numa_debug) {
 		printk(KERN_INFO "NUMA GROUP[%d]: cpus [ ", index);
-		for_each_cpu_mask(cpu, mask)
+		for_each_cpu(cpu, &mask)
 			printk("%d ", cpu);
 		printk("]\n");
 	}
@@ -1218,7 +1218,7 @@ static int __init numa_parse_jbus(void)
 	index = 0;
 	for_each_present_cpu(cpu) {
 		numa_cpu_lookup_table[cpu] = index;
-		numa_cpumask_lookup_table[index] = cpumask_of_cpu(cpu);
+		cpumask_copy(&numa_cpumask_lookup_table[index], cpumask_of(cpu));
 		node_masks[index].mask = ~((1UL << 36UL) - 1UL);
 		node_masks[index].val = cpu << 36UL;
 
-- 
1.7.3.1



