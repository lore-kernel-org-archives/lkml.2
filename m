Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab0HLRYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 13:24:54 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:41939 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146Ab0HLRYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 13:24:50 -0400
Message-Id: <20100812172625.511427562@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Thu, 12 Aug 2010 19:25:49 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RFC 5/5] [PATCH] topology: add z196 cpu topology support
References: <20100812172544.655648128@de.ibm.com>
Content-Disposition: inline; filename=05-topology-z196.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Use the extended cpu topology information that z196 machines provide
in order to make use of the new book scheduling domain.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 arch/s390/Kconfig                |    7 +
 arch/s390/include/asm/topology.h |   28 ++++++-
 arch/s390/kernel/topology.c      |  150 ++++++++++++++++++++++++---------------
 3 files changed, 124 insertions(+), 61 deletions(-)

diff -urpN linux-2.6/arch/s390/include/asm/topology.h linux-2.6-patched/arch/s390/include/asm/topology.h
--- linux-2.6/arch/s390/include/asm/topology.h	2010-08-11 13:47:13.000000000 +0200
+++ linux-2.6-patched/arch/s390/include/asm/topology.h	2010-08-11 13:47:24.000000000 +0200
@@ -3,15 +3,33 @@
 
 #include <linux/cpumask.h>
 
-#define mc_capable()	(1)
-
-const struct cpumask *cpu_coregroup_mask(unsigned int cpu);
-
 extern unsigned char cpu_core_id[NR_CPUS];
 extern cpumask_t cpu_core_map[NR_CPUS];
 
+static inline const struct cpumask *cpu_coregroup_mask(unsigned int cpu)
+{
+	return &cpu_core_map[cpu];
+}
+
 #define topology_core_id(cpu)		(cpu_core_id[cpu])
 #define topology_core_cpumask(cpu)	(&cpu_core_map[cpu])
+#define mc_capable()			(1)
+
+#ifdef CONFIG_SCHED_BOOK
+
+extern unsigned char cpu_book_id[NR_CPUS];
+extern cpumask_t cpu_book_map[NR_CPUS];
+
+static inline const struct cpumask *cpu_book_mask(unsigned int cpu)
+{
+	return &cpu_book_map[cpu];
+}
+
+#define topology_book_id(cpu)		(cpu_book_id[cpu])
+#define topology_book_cpumask(cpu)	(&cpu_book_map[cpu])
+#define book_capable()			(1)
+
+#endif /* CONFIG_SCHED_BOOK */
 
 int topology_set_cpu_management(int fc);
 void topology_schedule_update(void);
@@ -30,6 +48,8 @@ static inline void s390_init_cpu_topolog
 };
 #endif
 
+#define SD_BOOK_INIT	SD_CPU_INIT
+
 #include <asm-generic/topology.h>
 
 #endif /* _ASM_S390_TOPOLOGY_H */
diff -urpN linux-2.6/arch/s390/Kconfig linux-2.6-patched/arch/s390/Kconfig
--- linux-2.6/arch/s390/Kconfig	2010-08-11 13:47:13.000000000 +0200
+++ linux-2.6-patched/arch/s390/Kconfig	2010-08-11 13:47:24.000000000 +0200
@@ -198,6 +198,13 @@ config HOTPLUG_CPU
 	  can be controlled through /sys/devices/system/cpu/cpu#.
 	  Say N if you want to disable CPU hotplug.
 
+config SCHED_BOOK
+	bool "Book scheduler support"
+	depends on SMP
+	help
+	  Book scheduler support improves the CPU scheduler's decision making
+	  when dealing with machines that have several books.
+
 config MATHEMU
 	bool "IEEE FPU emulation"
 	depends on MARCH_G5
diff -urpN linux-2.6/arch/s390/kernel/topology.c linux-2.6-patched/arch/s390/kernel/topology.c
--- linux-2.6/arch/s390/kernel/topology.c	2010-08-02 00:11:14.000000000 +0200
+++ linux-2.6-patched/arch/s390/kernel/topology.c	2010-08-11 13:47:24.000000000 +0200
@@ -57,8 +57,8 @@ struct tl_info {
 	union tl_entry tle[0];
 };
 
-struct core_info {
-	struct core_info *next;
+struct mask_info {
+	struct mask_info *next;
 	unsigned char id;
 	cpumask_t mask;
 };
@@ -66,7 +66,6 @@ struct core_info {
 static int topology_enabled;
 static void topology_work_fn(struct work_struct *work);
 static struct tl_info *tl_info;
-static struct core_info core_info;
 static int machine_has_topology;
 static struct timer_list topology_timer;
 static void set_topology_timer(void);
@@ -74,38 +73,37 @@ static DECLARE_WORK(topology_work, topol
 /* topology_lock protects the core linked list */
 static DEFINE_SPINLOCK(topology_lock);
 
+static struct mask_info core_info;
 cpumask_t cpu_core_map[NR_CPUS];
 unsigned char cpu_core_id[NR_CPUS];
 
-static cpumask_t cpu_coregroup_map(unsigned int cpu)
+#ifdef CONFIG_SCHED_BOOK
+static struct mask_info book_info;
+cpumask_t cpu_book_map[NR_CPUS];
+unsigned char cpu_book_id[NR_CPUS];
+#endif
+
+static cpumask_t cpu_group_map(struct mask_info *info, unsigned int cpu)
 {
-	struct core_info *core = &core_info;
-	unsigned long flags;
 	cpumask_t mask;
 
 	cpus_clear(mask);
 	if (!topology_enabled || !machine_has_topology)
 		return cpu_possible_map;
-	spin_lock_irqsave(&topology_lock, flags);
-	while (core) {
-		if (cpu_isset(cpu, core->mask)) {
-			mask = core->mask;
+	while (info) {
+		if (cpu_isset(cpu, info->mask)) {
+			mask = info->mask;
 			break;
 		}
-		core = core->next;
+		info = info->next;
 	}
-	spin_unlock_irqrestore(&topology_lock, flags);
 	if (cpus_empty(mask))
 		mask = cpumask_of_cpu(cpu);
 	return mask;
 }
 
-const struct cpumask *cpu_coregroup_mask(unsigned int cpu)
-{
-	return &cpu_core_map[cpu];
-}
-
-static void add_cpus_to_core(struct tl_cpu *tl_cpu, struct core_info *core)
+static void add_cpus_to_mask(struct tl_cpu *tl_cpu, struct mask_info *book,
+			     struct mask_info *core)
 {
 	unsigned int cpu;
 
@@ -117,23 +115,35 @@ static void add_cpus_to_core(struct tl_c
 
 		rcpu = CPU_BITS - 1 - cpu + tl_cpu->origin;
 		for_each_present_cpu(lcpu) {
-			if (cpu_logical_map(lcpu) == rcpu) {
-				cpu_set(lcpu, core->mask);
-				cpu_core_id[lcpu] = core->id;
-				smp_cpu_polarization[lcpu] = tl_cpu->pp;
-			}
+			if (cpu_logical_map(lcpu) != rcpu)
+				continue;
+#ifdef CONFIG_SCHED_BOOK
+			cpu_set(lcpu, book->mask);
+			cpu_book_id[lcpu] = book->id;
+#endif
+			cpu_set(lcpu, core->mask);
+			cpu_core_id[lcpu] = core->id;
+			smp_cpu_polarization[lcpu] = tl_cpu->pp;
 		}
 	}
 }
 
-static void clear_cores(void)
+static void clear_masks(void)
 {
-	struct core_info *core = &core_info;
+	struct mask_info *info;
 
-	while (core) {
-		cpus_clear(core->mask);
-		core = core->next;
+	info = &core_info;
+	while (info) {
+		cpus_clear(info->mask);
+		info = info->next;
+	}
+#ifdef CONFIG_SCHED_BOOK
+	info = &book_info;
+	while (info) {
+		cpus_clear(info->mask);
+		info = info->next;
 	}
+#endif
 }
 
 static union tl_entry *next_tle(union tl_entry *tle)
@@ -146,29 +156,36 @@ static union tl_entry *next_tle(union tl
 
 static void tl_to_cores(struct tl_info *info)
 {
+#ifdef CONFIG_SCHED_BOOK
+	struct mask_info *book = &book_info;
+#else
+	struct mask_info *book = NULL;
+#endif
+	struct mask_info *core = &core_info;
 	union tl_entry *tle, *end;
-	struct core_info *core = &core_info;
+
 
 	spin_lock_irq(&topology_lock);
-	clear_cores();
+	clear_masks();
 	tle = info->tle;
 	end = (union tl_entry *)((unsigned long)info + info->length);
 	while (tle < end) {
 		switch (tle->nl) {
-		case 5:
-		case 4:
-		case 3:
+#ifdef CONFIG_SCHED_BOOK
 		case 2:
+			book = book->next;
+			book->id = tle->container.id;
 			break;
+#endif
 		case 1:
 			core = core->next;
 			core->id = tle->container.id;
 			break;
 		case 0:
-			add_cpus_to_core(&tle->cpu, core);
+			add_cpus_to_mask(&tle->cpu, book, core);
 			break;
 		default:
-			clear_cores();
+			clear_masks();
 			machine_has_topology = 0;
 			goto out;
 		}
@@ -221,10 +238,29 @@ int topology_set_cpu_management(int fc)
 
 static void update_cpu_core_map(void)
 {
+	unsigned long flags;
 	int cpu;
 
-	for_each_possible_cpu(cpu)
-		cpu_core_map[cpu] = cpu_coregroup_map(cpu);
+	spin_lock_irqsave(&topology_lock, flags);
+	for_each_possible_cpu(cpu) {
+		cpu_core_map[cpu] = cpu_group_map(&core_info, cpu);
+#ifdef CONFIG_SCHED_BOOK
+		cpu_book_map[cpu] = cpu_group_map(&book_info, cpu);
+#endif
+	}
+	spin_unlock_irqrestore(&topology_lock, flags);
+}
+
+static void store_topology(struct tl_info *info)
+{
+#ifdef CONFIG_SCHED_BOOK
+	int rc;
+
+	rc = stsi(info, 15, 1, 3);
+	if (rc != -ENOSYS)
+		return;
+#endif
+	stsi(info, 15, 1, 2);
 }
 
 int arch_update_cpu_topology(void)
@@ -238,7 +274,7 @@ int arch_update_cpu_topology(void)
 		topology_update_polarization_simple();
 		return 0;
 	}
-	stsi(info, 15, 1, 2);
+	store_topology(info);
 	tl_to_cores(info);
 	update_cpu_core_map();
 	for_each_online_cpu(cpu) {
@@ -299,12 +335,24 @@ out:
 }
 __initcall(init_topology_update);
 
+static void alloc_masks(struct tl_info *info, struct mask_info *mask, int offset)
+{
+	int i, nr_masks;
+
+	nr_masks = info->mag[NR_MAG - offset];
+	for (i = 0; i < info->mnest - offset; i++)
+		nr_masks *= info->mag[NR_MAG - offset - 1 - i];
+	nr_masks = max(nr_masks, 1);
+	for (i = 0; i < nr_masks; i++) {
+		mask->next = alloc_bootmem(sizeof(struct mask_info));
+		mask = mask->next;
+	}
+}
+
 void __init s390_init_cpu_topology(void)
 {
 	unsigned long long facility_bits;
 	struct tl_info *info;
-	struct core_info *core;
-	int nr_cores;
 	int i;
 
 	if (stfle(&facility_bits, 1) <= 0)
@@ -315,25 +363,13 @@ void __init s390_init_cpu_topology(void)
 
 	tl_info = alloc_bootmem_pages(PAGE_SIZE);
 	info = tl_info;
-	stsi(info, 15, 1, 2);
-
-	nr_cores = info->mag[NR_MAG - 2];
-	for (i = 0; i < info->mnest - 2; i++)
-		nr_cores *= info->mag[NR_MAG - 3 - i];
-
+	store_topology(info);
 	pr_info("The CPU configuration topology of the machine is:");
 	for (i = 0; i < NR_MAG; i++)
 		printk(" %d", info->mag[i]);
 	printk(" / %d\n", info->mnest);
-
-	core = &core_info;
-	for (i = 0; i < nr_cores; i++) {
-		core->next = alloc_bootmem(sizeof(struct core_info));
-		core = core->next;
-		if (!core)
-			goto error;
-	}
-	return;
-error:
-	machine_has_topology = 0;
+	alloc_masks(info, &core_info, 2);
+#ifdef CONFIG_SCHED_BOOK
+	alloc_masks(info, &book_info, 3);
+#endif
 }

