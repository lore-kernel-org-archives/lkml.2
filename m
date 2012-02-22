Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab2BVBqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:46:06 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39482 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab2BVBqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:46:01 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kjwinchester@gmail.com designates 10.229.135.85 as permitted sender) smtp.mail=kjwinchester@gmail.com; dkim=pass header.i=kjwinchester@gmail.com
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] x86: Move per cpu cpu_core_map to a field in struct cpuinfo_x86
Date: Tue, 21 Feb 2012 21:45:43 -0400
Message-Id: <1329875144-560-5-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329875144-560-1-git-send-email-kjwinchester@gmail.com>
References: <20120221153935.GE2486@x1.osrc.amd.com>
 <1329875144-560-1-git-send-email-kjwinchester@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies the various code paths using this field as it
groups the per-cpu data together.

Acked-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---
 arch/x86/include/asm/processor.h |    5 +++++
 arch/x86/include/asm/smp.h       |    6 ------
 arch/x86/include/asm/topology.h  |    4 ++--
 arch/x86/kernel/cpu/proc.c       |    3 +--
 arch/x86/kernel/smpboot.c        |   35 ++++++++++++++---------------------
 arch/x86/xen/smp.c               |    4 ----
 drivers/cpufreq/acpi-cpufreq.c   |    2 +-
 drivers/cpufreq/powernow-k8.c    |   13 +++----------
 8 files changed, 26 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 266eaee..8bcb7ac 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -115,6 +115,11 @@ struct cpuinfo_x86 {
 	u16			llc_id;
 	/* representing HT siblings of each logical CPU */
 	cpumask_t		sibling_map;
+	/*
+	 * representing all execution threads on a logical CPU, i.e. per
+	 * physical socket
+	 */
+	cpumask_t		core_map;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
 #define X86_VENDOR_INTEL	0
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index b5e7cd2..75aea4d 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -31,14 +31,8 @@ static inline bool cpu_has_ht_siblings(void)
 	return has_siblings;
 }
 
-DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
 DECLARE_PER_CPU(int, cpu_number);
 
-static inline struct cpumask *cpu_core_mask(int cpu)
-{
-	return per_cpu(cpu_core_map, cpu);
-}
-
 DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
 DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 5297acbf..58438a1b 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -160,7 +160,7 @@ extern const struct cpumask *cpu_coregroup_mask(int cpu);
 #ifdef ENABLE_TOPO_DEFINES
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
-#define topology_core_cpumask(cpu)		(per_cpu(cpu_core_map, cpu))
+#define topology_core_cpumask(cpu)		(&cpu_data(cpu).core_map)
 #define topology_thread_cpumask(cpu)		(&cpu_data(cpu).sibling_map)
 
 /* indicates that pointers to the topology cpumask_t maps are valid */
@@ -176,7 +176,7 @@ void x86_pci_root_bus_resources(int bus, struct list_head *resources);
 
 #ifdef CONFIG_SMP
 #define mc_capable()	((boot_cpu_data.x86_max_cores > 1) && \
-			(cpumask_weight(cpu_core_mask(0)) != nr_cpu_ids))
+			(cpumask_weight(&boot_cpu_data.core_map) != nr_cpu_ids))
 #define smt_capable()			(smp_num_siblings > 1)
 #endif
 
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 8022c66..e6e07c2 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -13,8 +13,7 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 #ifdef CONFIG_SMP
 	if (c->x86_max_cores * smp_num_siblings > 1) {
 		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
-		seq_printf(m, "siblings\t: %d\n",
-			   cpumask_weight(cpu_core_mask(cpu)));
+		seq_printf(m, "siblings\t: %d\n", cpumask_weight(&c->core_map));
 		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
 		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
 		seq_printf(m, "apicid\t\t: %d\n", c->apicid);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 991d17b..de23378 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -116,10 +116,6 @@ static struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
 int smp_num_siblings = 1;
 EXPORT_SYMBOL(smp_num_siblings);
 
-/* representing HT and core siblings of each logical CPU */
-DEFINE_PER_CPU(cpumask_var_t, cpu_core_map);
-EXPORT_PER_CPU_SYMBOL(cpu_core_map);
-
 /* Per CPU bogomips and other parameters */
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
@@ -326,8 +322,8 @@ static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
 {
 	cpumask_set_cpu(cpu1, &cpu_data(cpu2).sibling_map);
 	cpumask_set_cpu(cpu2, &cpu_data(cpu1).sibling_map);
-	cpumask_set_cpu(cpu1, cpu_core_mask(cpu2));
-	cpumask_set_cpu(cpu2, cpu_core_mask(cpu1));
+	cpumask_set_cpu(cpu1, &cpu_data(cpu2).core_map);
+	cpumask_set_cpu(cpu2, &cpu_data(cpu1).core_map);
 	cpumask_set_cpu(cpu1, &cpu_data(cpu2).llc_shared_map);
 	cpumask_set_cpu(cpu2, &cpu_data(cpu1).llc_shared_map);
 }
@@ -361,7 +357,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 	cpumask_set_cpu(cpu, &c->llc_shared_map);
 
 	if (__this_cpu_read(cpu_info.x86_max_cores) == 1) {
-		cpumask_copy(cpu_core_mask(cpu), &c->sibling_map);
+		cpumask_copy(&c->core_map, &c->sibling_map);
 		c->booted_cores = 1;
 		return;
 	}
@@ -374,8 +370,8 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 			cpumask_set_cpu(cpu, &o->llc_shared_map);
 		}
 		if (c->phys_proc_id == o->phys_proc_id) {
-			cpumask_set_cpu(i, cpu_core_mask(cpu));
-			cpumask_set_cpu(cpu, cpu_core_mask(i));
+			cpumask_set_cpu(i, &c->core_map);
+			cpumask_set_cpu(cpu, &o->core_map);
 			/*
 			 *  Does this new cpu bringup a new core?
 			 */
@@ -404,11 +400,11 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	/*
 	 * For perf, we return last level cache shared map.
-	 * And for power savings, we return cpu_core_map
+	 * And for power savings, we return core map.
 	 */
 	if ((sched_mc_power_savings || sched_smt_power_savings) &&
 	    !(cpu_has(c, X86_FEATURE_AMD_DCM)))
-		return cpu_core_mask(cpu);
+		return &c->core_map;
 	else
 		return &c->llc_shared_map;
 }
@@ -907,7 +903,7 @@ static __init void disable_smp(void)
 	else
 		physid_set_mask_of_physid(0, &phys_cpu_present_map);
 	cpumask_set_cpu(0, &cpu_data(0).sibling_map);
-	cpumask_set_cpu(0, cpu_core_mask(0));
+	cpumask_set_cpu(0, &cpu_data(0).core_map);
 }
 
 /*
@@ -1030,8 +1026,6 @@ static void __init smp_cpu_index_default(void)
  */
 void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
-	unsigned int i;
-
 	preempt_disable();
 	smp_cpu_index_default();
 
@@ -1043,9 +1037,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	mb();
 
 	current_thread_info()->cpu = 0;  /* needed? */
-	for_each_possible_cpu(i) {
-		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
-	}
 	set_cpu_sibling_map(0);
 
 
@@ -1233,19 +1224,21 @@ static void remove_siblinginfo(int cpu)
 	int sibling;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
-	for_each_cpu(sibling, cpu_core_mask(cpu)) {
-		cpumask_clear_cpu(cpu, cpu_core_mask(sibling));
+	for_each_cpu(sibling, &c->core_map) {
+		struct cpuinfo_x86 *o = &cpu_data(sibling);
+
+		cpumask_clear_cpu(cpu, &o->core_map);
 		/*/
 		 * last thread sibling in this cpu core going down
 		 */
 		if (cpumask_weight(&c->sibling_map) == 1)
-			cpu_data(sibling).booted_cores--;
+			o->booted_cores--;
 	}
 
 	for_each_cpu(sibling, &c->sibling_map)
 		cpumask_clear_cpu(cpu, &c->sibling_map);
 	cpumask_clear(&c->sibling_map);
-	cpumask_clear(cpu_core_mask(cpu));
+	cpumask_clear(&c->core_map);
 	c->phys_proc_id = 0;
 	c->cpu_core_id = 0;
 	cpumask_clear_cpu(cpu, cpu_sibling_setup_mask);
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 00f32c0..d1792ec 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -206,7 +206,6 @@ static void __init xen_smp_prepare_boot_cpu(void)
 static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 {
 	unsigned cpu;
-	unsigned int i;
 
 	if (skip_ioapic_setup) {
 		char *m = (max_cpus == 0) ?
@@ -222,9 +221,6 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 	smp_store_cpu_info(0);
 	cpu_data(0).x86_max_cores = 1;
 
-	for_each_possible_cpu(i) {
-		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
-	}
 	set_cpu_sibling_map(0);
 
 	if (xen_smp_intr_init(0))
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 56c6c6b..152af7f 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -557,7 +557,7 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	dmi_check_system(sw_any_bug_dmi_table);
 	if (bios_with_sw_any_bug && cpumask_weight(policy->cpus) == 1) {
 		policy->shared_type = CPUFREQ_SHARED_TYPE_ALL;
-		cpumask_copy(policy->cpus, cpu_core_mask(cpu));
+		cpumask_copy(policy->cpus, &c->core_map);
 	}
 #endif
 
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 8f9b2ce..da0767c 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -66,13 +66,6 @@ static struct msr __percpu *msrs;
 
 static struct cpufreq_driver cpufreq_amd64_driver;
 
-#ifndef CONFIG_SMP
-static inline const struct cpumask *cpu_core_mask(int cpu)
-{
-	return cpumask_of(0);
-}
-#endif
-
 /* Return a frequency in MHz, given an input fid */
 static u32 find_freq_from_fid(u32 fid)
 {
@@ -715,7 +708,7 @@ static int fill_powernow_table(struct powernow_k8_data *data,
 
 	pr_debug("cfid 0x%x, cvid 0x%x\n", data->currfid, data->currvid);
 	data->powernow_table = powernow_table;
-	if (cpumask_first(cpu_core_mask(data->cpu)) == data->cpu)
+	if (cpumask_first(&cpu_data(data->cpu).core_map) == data->cpu)
 		print_basics(data);
 
 	for (j = 0; j < data->numps; j++)
@@ -884,7 +877,7 @@ static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
 	powernow_table[data->acpi_data.state_count].index = 0;
 	data->powernow_table = powernow_table;
 
-	if (cpumask_first(cpu_core_mask(data->cpu)) == data->cpu)
+	if (cpumask_first(&cpu_data(data->cpu).core_map) == data->cpu)
 		print_basics(data);
 
 	/* notify BIOS that we exist */
@@ -1326,7 +1319,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	if (cpu_family == CPU_HW_PSTATE)
 		cpumask_copy(pol->cpus, cpumask_of(pol->cpu));
 	else
-		cpumask_copy(pol->cpus, cpu_core_mask(pol->cpu));
+		cpumask_copy(pol->cpus, &c->core_map);
 	data->available_cores = pol->cpus;
 
 	if (cpu_family == CPU_HW_PSTATE)
-- 
1.7.9

