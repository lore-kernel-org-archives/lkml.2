Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab0JUNMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:12:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43921 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757080Ab0JUNMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:12:49 -0400
Date: Thu, 21 Oct 2010 15:12:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v2.6.37
Message-ID: <20101021131233.GA1887@elte.hu>
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

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-core-for-linus

 Thanks,

	Ingo

------------------>
Christian Dietrich (1):
      sched: Remove unnecessary #ifdef CONFIG_SMP

Dave Young (1):
      sched: Remove unused PF_ALIGNWARN flag

Heiko Carstens (5):
      sched: Merge cpu_to_core_group functions
      sched: Add book scheduling domain
      topology/sysfs: Provide book id and siblings attributes
      topology, s390: Add z11 cpu topology support
      sched: Remove branch hints within context_switch()

Ingo Molnar (1):
      sched: Export account_system_vtime()

Linus Walleij (1):
      sched: Drop all load weight manipulation for RT tasks

Mathieu Desnoyers (1):
      sched: Fix string comparison in /proc/sched_features

Nikhil Rao (4):
      sched: Do not consider SCHED_IDLE tasks to be cache hot
      sched: Set group_imb only a task can be pulled from the busiest cpu
      sched: Force balancing on newidle balance if local group has capacity
      sched: Drop group_capacity to 1 only if local group has extra capacity

Peter Zijlstra (2):
      sched: Unindent labels
      sched: Create special class for stop/migrate work

Steven Rostedt (3):
      sched: Try not to migrate higher priority RT tasks
      sched: Give CPU bound RT tasks preference
      tracing/sched: Add sched_pi_setprio tracepoint

Takuya Yoshikawa (1):
      sched: Comment updates: fix default latency and granularity numbers

Venkatesh Pallipadi (9):
      sched: Increment cache_nice_tries only on periodic lb
      sched: Fix softirq time accounting
      sched: Consolidate account_system_vtime extern declaration
      sched: Add a PF flag for ksoftirqd identification
      sched: Add IRQ_TIME_ACCOUNTING, finer accounting of irq time
      x86: Add IRQ_TIME_ACCOUNTING
      sched: Do not account irq time to current task
      sched: Remove irq time from available CPU power
      sched: Call tick_check_idle before __irq_enter


 Documentation/cputopology.txt       |   23 +++-
 Documentation/kernel-parameters.txt |    4 +
 arch/ia64/include/asm/system.h      |    4 -
 arch/powerpc/include/asm/system.h   |    4 -
 arch/s390/Kconfig                   |    7 +
 arch/s390/include/asm/system.h      |    1 -
 arch/s390/include/asm/topology.h    |   27 +++-
 arch/s390/kernel/topology.c         |  150 +++++++++++-------
 arch/x86/Kconfig                    |   11 ++
 arch/x86/kernel/tsc.c               |    8 +
 drivers/base/topology.c             |   16 ++-
 include/linux/hardirq.h             |    9 +-
 include/linux/sched.h               |   23 ++-
 include/linux/topology.h            |    6 +
 include/trace/events/sched.h        |   29 ++++
 kernel/sched.c                      |  291 +++++++++++++++++++++++++++++------
 kernel/sched_fair.c                 |   76 +++++++--
 kernel/sched_features.h             |    5 +
 kernel/sched_rt.c                   |   40 +++--
 kernel/sched_stoptask.c             |  108 +++++++++++++
 kernel/softirq.c                    |   64 ++++++---
 kernel/stop_machine.c               |    8 +-
 net/sched/cls_cgroup.c              |    2 +-
 23 files changed, 732 insertions(+), 184 deletions(-)
 create mode 100644 kernel/sched_stoptask.c

diff --git a/Documentation/cputopology.txt b/Documentation/cputopology.txt
index f1c5c4bc..902d315 100644
--- a/Documentation/cputopology.txt
+++ b/Documentation/cputopology.txt
@@ -14,25 +14,39 @@ to /proc/cpuinfo.
 	identifier (rather than the kernel's).  The actual value is
 	architecture and platform dependent.
 
-3) /sys/devices/system/cpu/cpuX/topology/thread_siblings:
+3) /sys/devices/system/cpu/cpuX/topology/book_id:
+
+	the book ID of cpuX. Typically it is the hardware platform's
+	identifier (rather than the kernel's).	The actual value is
+	architecture and platform dependent.
+
+4) /sys/devices/system/cpu/cpuX/topology/thread_siblings:
 
 	internel kernel map of cpuX's hardware threads within the same
 	core as cpuX
 
-4) /sys/devices/system/cpu/cpuX/topology/core_siblings:
+5) /sys/devices/system/cpu/cpuX/topology/core_siblings:
 
 	internal kernel map of cpuX's hardware threads within the same
 	physical_package_id.
 
+6) /sys/devices/system/cpu/cpuX/topology/book_siblings:
+
+	internal kernel map of cpuX's hardware threads within the same
+	book_id.
+
 To implement it in an architecture-neutral way, a new source file,
-drivers/base/topology.c, is to export the 4 attributes.
+drivers/base/topology.c, is to export the 4 or 6 attributes. The two book
+related sysfs files will only be created if CONFIG_SCHED_BOOK is selected.
 
 For an architecture to support this feature, it must define some of
 these macros in include/asm-XXX/topology.h:
 #define topology_physical_package_id(cpu)
 #define topology_core_id(cpu)
+#define topology_book_id(cpu)
 #define topology_thread_cpumask(cpu)
 #define topology_core_cpumask(cpu)
+#define topology_book_cpumask(cpu)
 
 The type of **_id is int.
 The type of siblings is (const) struct cpumask *.
@@ -45,6 +59,9 @@ not defined by include/asm-XXX/topology.h:
 3) thread_siblings: just the given CPU
 4) core_siblings: just the given CPU
 
+For architectures that don't support books (CONFIG_SCHED_BOOK) there are no
+default definitions for topology_book_id() and topology_book_cpumask().
+
 Additionally, CPU topology information is provided under
 /sys/devices/system/cpu and includes these files.  The internal
 source for the output is in brackets ("[]").
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 8dd7248..ed05a4a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2435,6 +2435,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			disables clocksource verification at runtime.
 			Used to enable high-resolution timer mode on older
 			hardware, and in virtualized environment.
+			[x86] noirqtime: Do not use TSC to do irq accounting.
+			Used to run time disable IRQ_TIME_ACCOUNTING on any
+			platforms where RDTSC is slow and this accounting
+			can add overhead.
 
 	turbografx.map[2|3]=	[HW,JOY]
 			TurboGraFX parallel port interface
diff --git a/arch/ia64/include/asm/system.h b/arch/ia64/include/asm/system.h
index 9f342a5..dd028f2 100644
--- a/arch/ia64/include/asm/system.h
+++ b/arch/ia64/include/asm/system.h
@@ -272,10 +272,6 @@ void cpu_idle_wait(void);
 
 void default_idle(void);
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void account_system_vtime(struct task_struct *);
-#endif
-
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/powerpc/include/asm/system.h b/arch/powerpc/include/asm/system.h
index 6c294ac..9c3d160 100644
--- a/arch/powerpc/include/asm/system.h
+++ b/arch/powerpc/include/asm/system.h
@@ -542,10 +542,6 @@ extern void reloc_got2(unsigned long);
 
 #define PTRRELOC(x)	((typeof(x)) add_reloc_offset((unsigned long)(x)))
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void account_system_vtime(struct task_struct *);
-#endif
-
 extern struct dentry *powerpc_debugfs_root;
 
 #endif /* __KERNEL__ */
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index f0777a4..74a2f1b 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
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
diff --git a/arch/s390/include/asm/system.h b/arch/s390/include/asm/system.h
index cef6621..38ddd8a 100644
--- a/arch/s390/include/asm/system.h
+++ b/arch/s390/include/asm/system.h
@@ -97,7 +97,6 @@ static inline void restore_access_regs(unsigned int *acrs)
 
 extern void account_vtime(struct task_struct *, struct task_struct *);
 extern void account_tick_vtime(struct task_struct *);
-extern void account_system_vtime(struct task_struct *);
 
 #ifdef CONFIG_PFAULT
 extern void pfault_irq_init(void);
diff --git a/arch/s390/include/asm/topology.h b/arch/s390/include/asm/topology.h
index 831bd03..051107a 100644
--- a/arch/s390/include/asm/topology.h
+++ b/arch/s390/include/asm/topology.h
@@ -3,15 +3,32 @@
 
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
+
+#endif /* CONFIG_SCHED_BOOK */
 
 int topology_set_cpu_management(int fc);
 void topology_schedule_update(void);
@@ -30,6 +47,8 @@ static inline void s390_init_cpu_topology(void)
 };
 #endif
 
+#define SD_BOOK_INIT	SD_CPU_INIT
+
 #include <asm-generic/topology.h>
 
 #endif /* _ASM_S390_TOPOLOGY_H */
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index bcef007..13559c9 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
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
@@ -74,38 +73,37 @@ static DECLARE_WORK(topology_work, topology_work_fn);
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
 
@@ -117,23 +115,35 @@ static void add_cpus_to_core(struct tl_cpu *tl_cpu, struct core_info *core)
 
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
@@ -146,29 +156,36 @@ static union tl_entry *next_tle(union tl_entry *tle)
 
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
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..f4c70c2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -795,6 +795,17 @@ config SCHED_MC
 	  making when dealing with multi-core CPU chips at a cost of slightly
 	  increased overhead in some places. If unsure say N here.
 
+config IRQ_TIME_ACCOUNTING
+	bool "Fine granularity task level IRQ time accounting"
+	default n
+	---help---
+	  Select this option to enable fine granularity task irq time
+	  accounting. This is done by reading a timestamp on each
+	  transitions between softirq and hardirq state, so there can be a
+	  small performance impact.
+
+	  If in doubt, say N here.
+
 source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 26a863a..a1c2cd7 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -104,10 +104,14 @@ int __init notsc_setup(char *str)
 
 __setup("notsc", notsc_setup);
 
+static int no_sched_irq_time;
+
 static int __init tsc_setup(char *str)
 {
 	if (!strcmp(str, "reliable"))
 		tsc_clocksource_reliable = 1;
+	if (!strncmp(str, "noirqtime", 9))
+		no_sched_irq_time = 1;
 	return 1;
 }
 
@@ -801,6 +805,7 @@ void mark_tsc_unstable(char *reason)
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
 		sched_clock_stable = 0;
+		disable_sched_clock_irqtime();
 		printk(KERN_INFO "Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
 		if (clocksource_tsc.mult)
@@ -987,6 +992,9 @@ void __init tsc_init(void)
 	/* now allow native_sched_clock() to use rdtsc */
 	tsc_disabled = 0;
 
+	if (!no_sched_irq_time)
+		enable_sched_clock_irqtime();
+
 	lpj = ((u64)tsc_khz * 1000);
 	do_div(lpj, HZ);
 	lpj_fine = lpj;
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index 9fc630c..f6f37a0 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -45,7 +45,8 @@ static ssize_t show_##name(struct sys_device *dev,		\
 	return sprintf(buf, "%d\n", topology_##name(cpu));	\
 }
 
-#if defined(topology_thread_cpumask) || defined(topology_core_cpumask)
+#if defined(topology_thread_cpumask) || defined(topology_core_cpumask) || \
+    defined(topology_book_cpumask)
 static ssize_t show_cpumap(int type, const struct cpumask *mask, char *buf)
 {
 	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
@@ -114,6 +115,14 @@ define_siblings_show_func(core_cpumask);
 define_one_ro_named(core_siblings, show_core_cpumask);
 define_one_ro_named(core_siblings_list, show_core_cpumask_list);
 
+#ifdef CONFIG_SCHED_BOOK
+define_id_show_func(book_id);
+define_one_ro(book_id);
+define_siblings_show_func(book_cpumask);
+define_one_ro_named(book_siblings, show_book_cpumask);
+define_one_ro_named(book_siblings_list, show_book_cpumask_list);
+#endif
+
 static struct attribute *default_attrs[] = {
 	&attr_physical_package_id.attr,
 	&attr_core_id.attr,
@@ -121,6 +130,11 @@ static struct attribute *default_attrs[] = {
 	&attr_thread_siblings_list.attr,
 	&attr_core_siblings.attr,
 	&attr_core_siblings_list.attr,
+#ifdef CONFIG_SCHED_BOOK
+	&attr_book_id.attr,
+	&attr_book_siblings.attr,
+	&attr_book_siblings_list.attr,
+#endif
 	NULL
 };
 
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index d5b3876..ff43e92 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -64,6 +64,8 @@
 #define HARDIRQ_OFFSET	(1UL << HARDIRQ_SHIFT)
 #define NMI_OFFSET	(1UL << NMI_SHIFT)
 
+#define SOFTIRQ_DISABLE_OFFSET	(2 * SOFTIRQ_OFFSET)
+
 #ifndef PREEMPT_ACTIVE
 #define PREEMPT_ACTIVE_BITS	1
 #define PREEMPT_ACTIVE_SHIFT	(NMI_SHIFT + NMI_BITS)
@@ -82,10 +84,13 @@
 /*
  * Are we doing bottom half or hardware interrupt processing?
  * Are we in a softirq context? Interrupt context?
+ * in_softirq - Are we currently processing softirq or have bh disabled?
+ * in_serving_softirq - Are we currently processing softirq?
  */
 #define in_irq()		(hardirq_count())
 #define in_softirq()		(softirq_count())
 #define in_interrupt()		(irq_count())
+#define in_serving_softirq()	(softirq_count() & SOFTIRQ_OFFSET)
 
 /*
  * Are we in NMI context?
@@ -132,10 +137,12 @@ extern void synchronize_irq(unsigned int irq);
 
 struct task_struct;
 
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+#if !defined(CONFIG_VIRT_CPU_ACCOUNTING) && !defined(CONFIG_IRQ_TIME_ACCOUNTING)
 static inline void account_system_vtime(struct task_struct *tsk)
 {
 }
+#else
+extern void account_system_vtime(struct task_struct *tsk);
 #endif
 
 #if defined(CONFIG_NO_HZ)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1e2a6db..2cca9a9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -875,6 +875,7 @@ enum sched_domain_level {
 	SD_LV_NONE = 0,
 	SD_LV_SIBLING,
 	SD_LV_MC,
+	SD_LV_BOOK,
 	SD_LV_CPU,
 	SD_LV_NODE,
 	SD_LV_ALLNODES,
@@ -1681,8 +1682,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 /*
  * Per process flags
  */
-#define PF_ALIGNWARN	0x00000001	/* Print alignment warning msgs */
-					/* Not implemented yet, only for 486*/
+#define PF_KSOFTIRQD	0x00000001	/* I am ksoftirqd */
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
@@ -1826,6 +1826,19 @@ extern void sched_clock_idle_sleep_event(void);
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
 #endif
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+/*
+ * An i/f to runtime opt-in for irq time accounting based off of sched_clock.
+ * The reason for this explicit opt-in is not to have perf penalty with
+ * slow sched_clocks.
+ */
+extern void enable_sched_clock_irqtime(void);
+extern void disable_sched_clock_irqtime(void);
+#else
+static inline void enable_sched_clock_irqtime(void) {}
+static inline void disable_sched_clock_irqtime(void) {}
+#endif
+
 extern unsigned long long
 task_sched_runtime(struct task_struct *task);
 extern unsigned long long thread_group_sched_runtime(struct task_struct *task);
@@ -2367,9 +2380,9 @@ extern int __cond_resched_lock(spinlock_t *lock);
 
 extern int __cond_resched_softirq(void);
 
-#define cond_resched_softirq() ({				\
-	__might_sleep(__FILE__, __LINE__, SOFTIRQ_OFFSET);	\
-	__cond_resched_softirq();				\
+#define cond_resched_softirq() ({					\
+	__might_sleep(__FILE__, __LINE__, SOFTIRQ_DISABLE_OFFSET);	\
+	__cond_resched_softirq();					\
 })
 
 /*
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 64e084f..b91a40e 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -201,6 +201,12 @@ int arch_update_cpu_topology(void);
 	.balance_interval	= 64,					\
 }
 
+#ifdef CONFIG_SCHED_BOOK
+#ifndef SD_BOOK_INIT
+#error Please define an appropriate SD_BOOK_INIT in include/asm/topology.h!!!
+#endif
+#endif /* CONFIG_SCHED_BOOK */
+
 #ifdef CONFIG_NUMA
 #ifndef SD_NODE_INIT
 #error Please define an appropriate SD_NODE_INIT in include/asm/topology.h!!!
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 9208c92..f633478 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -362,6 +362,35 @@ TRACE_EVENT(sched_stat_runtime,
 			(unsigned long long)__entry->vruntime)
 );
 
+/*
+ * Tracepoint for showing priority inheritance modifying a tasks
+ * priority.
+ */
+TRACE_EVENT(sched_pi_setprio,
+
+	TP_PROTO(struct task_struct *tsk, int newprio),
+
+	TP_ARGS(tsk, newprio),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+		__field( int,	oldprio			)
+		__field( int,	newprio			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid		= tsk->pid;
+		__entry->oldprio	= tsk->prio;
+		__entry->newprio	= newprio;
+	),
+
+	TP_printk("comm=%s pid=%d oldprio=%d newprio=%d",
+			__entry->comm, __entry->pid,
+			__entry->oldprio, __entry->newprio)
+);
+
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */
diff --git a/kernel/sched.c b/kernel/sched.c
index dc85ceb..5998222 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -426,9 +426,7 @@ struct root_domain {
 	 */
 	cpumask_var_t rto_mask;
 	atomic_t rto_count;
-#ifdef CONFIG_SMP
 	struct cpupri cpupri;
-#endif
 };
 
 /*
@@ -437,7 +435,7 @@ struct root_domain {
  */
 static struct root_domain def_root_domain;
 
-#endif
+#endif /* CONFIG_SMP */
 
 /*
  * This is the main, per-CPU runqueue data structure.
@@ -488,11 +486,12 @@ struct rq {
 	 */
 	unsigned long nr_uninterruptible;
 
-	struct task_struct *curr, *idle;
+	struct task_struct *curr, *idle, *stop;
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
 
 	u64 clock;
+	u64 clock_task;
 
 	atomic_t nr_iowait;
 
@@ -520,6 +519,10 @@ struct rq {
 	u64 avg_idle;
 #endif
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+	u64 prev_irq_time;
+#endif
+
 	/* calc_load related fields */
 	unsigned long calc_load_update;
 	long calc_load_active;
@@ -643,10 +646,22 @@ static inline struct task_group *task_group(struct task_struct *p)
 
 #endif /* CONFIG_CGROUP_SCHED */
 
+static u64 irq_time_cpu(int cpu);
+static void sched_irq_time_avg_update(struct rq *rq, u64 irq_time);
+
 inline void update_rq_clock(struct rq *rq)
 {
-	if (!rq->skip_clock_update)
-		rq->clock = sched_clock_cpu(cpu_of(rq));
+	if (!rq->skip_clock_update) {
+		int cpu = cpu_of(rq);
+		u64 irq_time;
+
+		rq->clock = sched_clock_cpu(cpu);
+		irq_time = irq_time_cpu(cpu);
+		if (rq->clock - irq_time > rq->clock_task)
+			rq->clock_task = rq->clock - irq_time;
+
+		sched_irq_time_avg_update(rq, irq_time);
+	}
 }
 
 /*
@@ -723,7 +738,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 		size_t cnt, loff_t *ppos)
 {
 	char buf[64];
-	char *cmp = buf;
+	char *cmp;
 	int neg = 0;
 	int i;
 
@@ -734,6 +749,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 		return -EFAULT;
 
 	buf[cnt] = 0;
+	cmp = strstrip(buf);
 
 	if (strncmp(buf, "NO_", 3) == 0) {
 		neg = 1;
@@ -741,9 +757,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 	}
 
 	for (i = 0; sched_feat_names[i]; i++) {
-		int len = strlen(sched_feat_names[i]);
-
-		if (strncmp(cmp, sched_feat_names[i], len) == 0) {
+		if (strcmp(cmp, sched_feat_names[i]) == 0) {
 			if (neg)
 				sysctl_sched_features &= ~(1UL << i);
 			else
@@ -1840,7 +1854,7 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 
 static const struct sched_class rt_sched_class;
 
-#define sched_class_highest (&rt_sched_class)
+#define sched_class_highest (&stop_sched_class)
 #define for_each_class(class) \
    for (class = sched_class_highest; class; class = class->next)
 
@@ -1858,12 +1872,6 @@ static void dec_nr_running(struct rq *rq)
 
 static void set_load_weight(struct task_struct *p)
 {
-	if (task_has_rt_policy(p)) {
-		p->se.load.weight = 0;
-		p->se.load.inv_weight = WMULT_CONST;
-		return;
-	}
-
 	/*
 	 * SCHED_IDLE tasks get minimal weight:
 	 */
@@ -1917,13 +1925,132 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 	dec_nr_running(rq);
 }
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+
+/*
+ * There are no locks covering percpu hardirq/softirq time.
+ * They are only modified in account_system_vtime, on corresponding CPU
+ * with interrupts disabled. So, writes are safe.
+ * They are read and saved off onto struct rq in update_rq_clock().
+ * This may result in other CPU reading this CPU's irq time and can
+ * race with irq/account_system_vtime on this CPU. We would either get old
+ * or new value (or semi updated value on 32 bit) with a side effect of
+ * accounting a slice of irq time to wrong task when irq is in progress
+ * while we read rq->clock. That is a worthy compromise in place of having
+ * locks on each irq in account_system_time.
+ */
+static DEFINE_PER_CPU(u64, cpu_hardirq_time);
+static DEFINE_PER_CPU(u64, cpu_softirq_time);
+
+static DEFINE_PER_CPU(u64, irq_start_time);
+static int sched_clock_irqtime;
+
+void enable_sched_clock_irqtime(void)
+{
+	sched_clock_irqtime = 1;
+}
+
+void disable_sched_clock_irqtime(void)
+{
+	sched_clock_irqtime = 0;
+}
+
+static u64 irq_time_cpu(int cpu)
+{
+	if (!sched_clock_irqtime)
+		return 0;
+
+	return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
+}
+
+void account_system_vtime(struct task_struct *curr)
+{
+	unsigned long flags;
+	int cpu;
+	u64 now, delta;
+
+	if (!sched_clock_irqtime)
+		return;
+
+	local_irq_save(flags);
+
+	cpu = smp_processor_id();
+	now = sched_clock_cpu(cpu);
+	delta = now - per_cpu(irq_start_time, cpu);
+	per_cpu(irq_start_time, cpu) = now;
+	/*
+	 * We do not account for softirq time from ksoftirqd here.
+	 * We want to continue accounting softirq time to ksoftirqd thread
+	 * in that case, so as not to confuse scheduler with a special task
+	 * that do not consume any time, but still wants to run.
+	 */
+	if (hardirq_count())
+		per_cpu(cpu_hardirq_time, cpu) += delta;
+	else if (in_serving_softirq() && !(curr->flags & PF_KSOFTIRQD))
+		per_cpu(cpu_softirq_time, cpu) += delta;
+
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(account_system_vtime);
+
+static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time)
+{
+	if (sched_clock_irqtime && sched_feat(NONIRQ_POWER)) {
+		u64 delta_irq = curr_irq_time - rq->prev_irq_time;
+		rq->prev_irq_time = curr_irq_time;
+		sched_rt_avg_update(rq, delta_irq);
+	}
+}
+
+#else
+
+static u64 irq_time_cpu(int cpu)
+{
+	return 0;
+}
+
+static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time) { }
+
+#endif
+
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
+#include "sched_stoptask.c"
 #ifdef CONFIG_SCHED_DEBUG
 # include "sched_debug.c"
 #endif
 
+void sched_set_stop_task(int cpu, struct task_struct *stop)
+{
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
+	struct task_struct *old_stop = cpu_rq(cpu)->stop;
+
+	if (stop) {
+		/*
+		 * Make it appear like a SCHED_FIFO task, its something
+		 * userspace knows about and won't get confused about.
+		 *
+		 * Also, it will make PI more or less work without too
+		 * much confusion -- but then, stop work should not
+		 * rely on PI working anyway.
+		 */
+		sched_setscheduler_nocheck(stop, SCHED_FIFO, &param);
+
+		stop->sched_class = &stop_sched_class;
+	}
+
+	cpu_rq(cpu)->stop = stop;
+
+	if (old_stop) {
+		/*
+		 * Reset it back to a normal scheduling class so that
+		 * it can die in pieces.
+		 */
+		old_stop->sched_class = &rt_sched_class;
+	}
+}
+
 /*
  * __normal_prio - return the priority that is based on the static prio
  */
@@ -2003,6 +2130,9 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	if (p->sched_class != &fair_sched_class)
 		return 0;
 
+	if (unlikely(p->policy == SCHED_IDLE))
+		return 0;
+
 	/*
 	 * Buddy candidates are cache hot:
 	 */
@@ -2852,14 +2982,14 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 */
 	arch_start_context_switch(prev);
 
-	if (likely(!mm)) {
+	if (!mm) {
 		next->active_mm = oldmm;
 		atomic_inc(&oldmm->mm_count);
 		enter_lazy_tlb(oldmm, next);
 	} else
 		switch_mm(oldmm, mm, next);
 
-	if (likely(!prev->mm)) {
+	if (!prev->mm) {
 		prev->active_mm = NULL;
 		rq->prev_mm = oldmm;
 	}
@@ -3248,7 +3378,7 @@ static u64 do_task_delta_exec(struct task_struct *p, struct rq *rq)
 
 	if (task_current(rq, p)) {
 		update_rq_clock(rq);
-		ns = rq->clock - p->se.exec_start;
+		ns = rq->clock_task - p->se.exec_start;
 		if ((s64)ns < 0)
 			ns = 0;
 	}
@@ -3397,7 +3527,7 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	tmp = cputime_to_cputime64(cputime);
 	if (hardirq_count() - hardirq_offset)
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
-	else if (softirq_count())
+	else if (in_serving_softirq())
 		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
 	else
 		cpustat->system = cputime64_add(cpustat->system, tmp);
@@ -3723,17 +3853,13 @@ pick_next_task(struct rq *rq)
 			return p;
 	}
 
-	class = sched_class_highest;
-	for ( ; ; ) {
+	for_each_class(class) {
 		p = class->pick_next_task(rq);
 		if (p)
 			return p;
-		/*
-		 * Will never be NULL as the idle class always
-		 * returns a non-NULL p:
-		 */
-		class = class->next;
 	}
+
+	BUG(); /* the idle class will always have a runnable task */
 }
 
 /*
@@ -4358,6 +4484,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 
 	rq = task_rq_lock(p, &flags);
 
+	trace_sched_pi_setprio(p, prio);
 	oldprio = p->prio;
 	prev_class = p->sched_class;
 	on_rq = p->se.on_rq;
@@ -4661,6 +4788,15 @@ recheck:
 	 */
 	rq = __task_rq_lock(p);
 
+	/*
+	 * Changing the policy of the stop threads its a very bad idea
+	 */
+	if (p == rq->stop) {
+		__task_rq_unlock(rq);
+		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		return -EINVAL;
+	}
+
 #ifdef CONFIG_RT_GROUP_SCHED
 	if (user) {
 		/*
@@ -4893,7 +5029,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 
 	cpuset_cpus_allowed(p, cpus_allowed);
 	cpumask_and(new_mask, in_mask, cpus_allowed);
- again:
+again:
 	retval = set_cpus_allowed_ptr(p, new_mask);
 
 	if (!retval) {
@@ -6514,6 +6650,7 @@ struct s_data {
 	cpumask_var_t		nodemask;
 	cpumask_var_t		this_sibling_map;
 	cpumask_var_t		this_core_map;
+	cpumask_var_t		this_book_map;
 	cpumask_var_t		send_covered;
 	cpumask_var_t		tmpmask;
 	struct sched_group	**sched_group_nodes;
@@ -6525,6 +6662,7 @@ enum s_alloc {
 	sa_rootdomain,
 	sa_tmpmask,
 	sa_send_covered,
+	sa_this_book_map,
 	sa_this_core_map,
 	sa_this_sibling_map,
 	sa_nodemask,
@@ -6560,31 +6698,48 @@ cpu_to_cpu_group(int cpu, const struct cpumask *cpu_map,
 #ifdef CONFIG_SCHED_MC
 static DEFINE_PER_CPU(struct static_sched_domain, core_domains);
 static DEFINE_PER_CPU(struct static_sched_group, sched_group_core);
-#endif /* CONFIG_SCHED_MC */
 
-#if defined(CONFIG_SCHED_MC) && defined(CONFIG_SCHED_SMT)
 static int
 cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
 		  struct sched_group **sg, struct cpumask *mask)
 {
 	int group;
-
+#ifdef CONFIG_SCHED_SMT
 	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
 	group = cpumask_first(mask);
+#else
+	group = cpu;
+#endif
 	if (sg)
 		*sg = &per_cpu(sched_group_core, group).sg;
 	return group;
 }
-#elif defined(CONFIG_SCHED_MC)
+#endif /* CONFIG_SCHED_MC */
+
+/*
+ * book sched-domains:
+ */
+#ifdef CONFIG_SCHED_BOOK
+static DEFINE_PER_CPU(struct static_sched_domain, book_domains);
+static DEFINE_PER_CPU(struct static_sched_group, sched_group_book);
+
 static int
-cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
-		  struct sched_group **sg, struct cpumask *unused)
+cpu_to_book_group(int cpu, const struct cpumask *cpu_map,
+		  struct sched_group **sg, struct cpumask *mask)
 {
+	int group = cpu;
+#ifdef CONFIG_SCHED_MC
+	cpumask_and(mask, cpu_coregroup_mask(cpu), cpu_map);
+	group = cpumask_first(mask);
+#elif defined(CONFIG_SCHED_SMT)
+	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
+	group = cpumask_first(mask);
+#endif
 	if (sg)
-		*sg = &per_cpu(sched_group_core, cpu).sg;
-	return cpu;
+		*sg = &per_cpu(sched_group_book, group).sg;
+	return group;
 }
-#endif
+#endif /* CONFIG_SCHED_BOOK */
 
 static DEFINE_PER_CPU(struct static_sched_domain, phys_domains);
 static DEFINE_PER_CPU(struct static_sched_group, sched_group_phys);
@@ -6594,7 +6749,10 @@ cpu_to_phys_group(int cpu, const struct cpumask *cpu_map,
 		  struct sched_group **sg, struct cpumask *mask)
 {
 	int group;
-#ifdef CONFIG_SCHED_MC
+#ifdef CONFIG_SCHED_BOOK
+	cpumask_and(mask, cpu_book_mask(cpu), cpu_map);
+	group = cpumask_first(mask);
+#elif defined(CONFIG_SCHED_MC)
 	cpumask_and(mask, cpu_coregroup_mask(cpu), cpu_map);
 	group = cpumask_first(mask);
 #elif defined(CONFIG_SCHED_SMT)
@@ -6855,6 +7013,9 @@ SD_INIT_FUNC(CPU)
 #ifdef CONFIG_SCHED_MC
  SD_INIT_FUNC(MC)
 #endif
+#ifdef CONFIG_SCHED_BOOK
+ SD_INIT_FUNC(BOOK)
+#endif
 
 static int default_relax_domain_level = -1;
 
@@ -6904,6 +7065,8 @@ static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 		free_cpumask_var(d->tmpmask); /* fall through */
 	case sa_send_covered:
 		free_cpumask_var(d->send_covered); /* fall through */
+	case sa_this_book_map:
+		free_cpumask_var(d->this_book_map); /* fall through */
 	case sa_this_core_map:
 		free_cpumask_var(d->this_core_map); /* fall through */
 	case sa_this_sibling_map:
@@ -6950,8 +7113,10 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 		return sa_nodemask;
 	if (!alloc_cpumask_var(&d->this_core_map, GFP_KERNEL))
 		return sa_this_sibling_map;
-	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
+	if (!alloc_cpumask_var(&d->this_book_map, GFP_KERNEL))
 		return sa_this_core_map;
+	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
+		return sa_this_book_map;
 	if (!alloc_cpumask_var(&d->tmpmask, GFP_KERNEL))
 		return sa_send_covered;
 	d->rd = alloc_rootdomain();
@@ -7009,6 +7174,23 @@ static struct sched_domain *__build_cpu_sched_domain(struct s_data *d,
 	return sd;
 }
 
+static struct sched_domain *__build_book_sched_domain(struct s_data *d,
+	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+	struct sched_domain *parent, int i)
+{
+	struct sched_domain *sd = parent;
+#ifdef CONFIG_SCHED_BOOK
+	sd = &per_cpu(book_domains, i).sd;
+	SD_INIT(sd, BOOK);
+	set_domain_attribute(sd, attr);
+	cpumask_and(sched_domain_span(sd), cpu_map, cpu_book_mask(i));
+	sd->parent = parent;
+	parent->child = sd;
+	cpu_to_book_group(i, cpu_map, &sd->groups, d->tmpmask);
+#endif
+	return sd;
+}
+
 static struct sched_domain *__build_mc_sched_domain(struct s_data *d,
 	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
 	struct sched_domain *parent, int i)
@@ -7066,6 +7248,15 @@ static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
 						d->send_covered, d->tmpmask);
 		break;
 #endif
+#ifdef CONFIG_SCHED_BOOK
+	case SD_LV_BOOK: /* set up book groups */
+		cpumask_and(d->this_book_map, cpu_map, cpu_book_mask(cpu));
+		if (cpu == cpumask_first(d->this_book_map))
+			init_sched_build_groups(d->this_book_map, cpu_map,
+						&cpu_to_book_group,
+						d->send_covered, d->tmpmask);
+		break;
+#endif
 	case SD_LV_CPU: /* set up physical groups */
 		cpumask_and(d->nodemask, cpumask_of_node(cpu), cpu_map);
 		if (!cpumask_empty(d->nodemask))
@@ -7113,12 +7304,14 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
 		sd = __build_numa_sched_domains(&d, cpu_map, attr, i);
 		sd = __build_cpu_sched_domain(&d, cpu_map, attr, sd, i);
+		sd = __build_book_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
 	}
 
 	for_each_cpu(i, cpu_map) {
 		build_sched_groups(&d, SD_LV_SIBLING, cpu_map, i);
+		build_sched_groups(&d, SD_LV_BOOK, cpu_map, i);
 		build_sched_groups(&d, SD_LV_MC, cpu_map, i);
 	}
 
@@ -7149,6 +7342,12 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		init_sched_groups_power(i, sd);
 	}
 #endif
+#ifdef CONFIG_SCHED_BOOK
+	for_each_cpu(i, cpu_map) {
+		sd = &per_cpu(book_domains, i).sd;
+		init_sched_groups_power(i, sd);
+	}
+#endif
 
 	for_each_cpu(i, cpu_map) {
 		sd = &per_cpu(phys_domains, i).sd;
@@ -7174,6 +7373,8 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		sd = &per_cpu(cpu_domains, i).sd;
 #elif defined(CONFIG_SCHED_MC)
 		sd = &per_cpu(core_domains, i).sd;
+#elif defined(CONFIG_SCHED_BOOK)
+		sd = &per_cpu(book_domains, i).sd;
 #else
 		sd = &per_cpu(phys_domains, i).sd;
 #endif
@@ -8078,9 +8279,9 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 
 	return 1;
 
- err_free_rq:
+err_free_rq:
 	kfree(cfs_rq);
- err:
+err:
 	return 0;
 }
 
@@ -8168,9 +8369,9 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 
 	return 1;
 
- err_free_rq:
+err_free_rq:
 	kfree(rt_rq);
- err:
+err:
 	return 0;
 }
 
@@ -8528,7 +8729,7 @@ static int tg_set_bandwidth(struct task_group *tg,
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 	}
 	raw_spin_unlock_irq(&tg->rt_bandwidth.rt_runtime_lock);
- unlock:
+unlock:
 	read_unlock(&tasklist_lock);
 	mutex_unlock(&rt_constraints_mutex);
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index db3f674..74cccfa 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -25,7 +25,7 @@
 
 /*
  * Targeted preemption latency for CPU-bound tasks:
- * (default: 5ms * (1 + ilog(ncpus)), units: nanoseconds)
+ * (default: 6ms * (1 + ilog(ncpus)), units: nanoseconds)
  *
  * NOTE: this latency value is not the same as the concept of
  * 'timeslice length' - timeslices in CFS are of variable length
@@ -52,7 +52,7 @@ enum sched_tunable_scaling sysctl_sched_tunable_scaling
 
 /*
  * Minimal preemption granularity for CPU-bound tasks:
- * (default: 2 msec * (1 + ilog(ncpus)), units: nanoseconds)
+ * (default: 0.75 msec * (1 + ilog(ncpus)), units: nanoseconds)
  */
 unsigned int sysctl_sched_min_granularity = 750000ULL;
 unsigned int normalized_sysctl_sched_min_granularity = 750000ULL;
@@ -519,7 +519,7 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 static void update_curr(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *curr = cfs_rq->curr;
-	u64 now = rq_of(cfs_rq)->clock;
+	u64 now = rq_of(cfs_rq)->clock_task;
 	unsigned long delta_exec;
 
 	if (unlikely(!curr))
@@ -602,7 +602,7 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	/*
 	 * We are starting a new run period:
 	 */
-	se->exec_start = rq_of(cfs_rq)->clock;
+	se->exec_start = rq_of(cfs_rq)->clock_task;
 }
 
 /**************************************************
@@ -1764,6 +1764,10 @@ static void pull_task(struct rq *src_rq, struct task_struct *p,
 	set_task_cpu(p, this_cpu);
 	activate_task(this_rq, p, 0);
 	check_preempt_curr(this_rq, p, 0);
+
+	/* re-arm NEWIDLE balancing when moving tasks */
+	src_rq->avg_idle = this_rq->avg_idle = 2*sysctl_sched_migration_cost;
+	this_rq->idle_stamp = 0;
 }
 
 /*
@@ -1798,7 +1802,7 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 	 * 2) too many balance attempts have failed.
 	 */
 
-	tsk_cache_hot = task_hot(p, rq->clock, sd);
+	tsk_cache_hot = task_hot(p, rq->clock_task, sd);
 	if (!tsk_cache_hot ||
 		sd->nr_balance_failed > sd->cache_nice_tries) {
 #ifdef CONFIG_SCHEDSTATS
@@ -2030,12 +2034,14 @@ struct sd_lb_stats {
 	unsigned long this_load;
 	unsigned long this_load_per_task;
 	unsigned long this_nr_running;
+	unsigned long this_has_capacity;
 
 	/* Statistics of the busiest group */
 	unsigned long max_load;
 	unsigned long busiest_load_per_task;
 	unsigned long busiest_nr_running;
 	unsigned long busiest_group_capacity;
+	unsigned long busiest_has_capacity;
 
 	int group_imb; /* Is there imbalance in this sd */
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
@@ -2058,6 +2064,7 @@ struct sg_lb_stats {
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long group_capacity;
 	int group_imb; /* Is there an imbalance in the group ? */
+	int group_has_capacity; /* Is there extra capacity in the group? */
 };
 
 /**
@@ -2268,7 +2275,13 @@ unsigned long scale_rt_power(int cpu)
 	u64 total, available;
 
 	total = sched_avg_period() + (rq->clock - rq->age_stamp);
-	available = total - rq->rt_avg;
+
+	if (unlikely(total < rq->rt_avg)) {
+		/* Ensures that power won't end up being negative */
+		available = 0;
+	} else {
+		available = total - rq->rt_avg;
+	}
 
 	if (unlikely((s64)total < SCHED_LOAD_SCALE))
 		total = SCHED_LOAD_SCALE;
@@ -2378,7 +2391,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 			int local_group, const struct cpumask *cpus,
 			int *balance, struct sg_lb_stats *sgs)
 {
-	unsigned long load, max_cpu_load, min_cpu_load;
+	unsigned long load, max_cpu_load, min_cpu_load, max_nr_running;
 	int i;
 	unsigned int balance_cpu = -1, first_idle_cpu = 0;
 	unsigned long avg_load_per_task = 0;
@@ -2389,6 +2402,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	/* Tally up the load of all CPUs in the group */
 	max_cpu_load = 0;
 	min_cpu_load = ~0UL;
+	max_nr_running = 0;
 
 	for_each_cpu_and(i, sched_group_cpus(group), cpus) {
 		struct rq *rq = cpu_rq(i);
@@ -2406,8 +2420,10 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 			load = target_load(i, load_idx);
 		} else {
 			load = source_load(i, load_idx);
-			if (load > max_cpu_load)
+			if (load > max_cpu_load) {
 				max_cpu_load = load;
+				max_nr_running = rq->nr_running;
+			}
 			if (min_cpu_load > load)
 				min_cpu_load = load;
 		}
@@ -2447,13 +2463,15 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	if (sgs->sum_nr_running)
 		avg_load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
-	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
+	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task && max_nr_running > 1)
 		sgs->group_imb = 1;
 
-	sgs->group_capacity =
-		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
+	sgs->group_capacity = DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
 	if (!sgs->group_capacity)
 		sgs->group_capacity = fix_small_capacity(sd, group);
+
+	if (sgs->group_capacity > sgs->sum_nr_running)
+		sgs->group_has_capacity = 1;
 }
 
 /**
@@ -2542,9 +2560,14 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 		/*
 		 * In case the child domain prefers tasks go to siblings
 		 * first, lower the sg capacity to one so that we'll try
-		 * and move all the excess tasks away.
+		 * and move all the excess tasks away. We lower the capacity
+		 * of a group only if the local group has the capacity to fit
+		 * these excess tasks, i.e. nr_running < group_capacity. The
+		 * extra check prevents the case where you always pull from the
+		 * heaviest group when it is already under-utilized (possible
+		 * with a large weight task outweighs the tasks on the system).
 		 */
-		if (prefer_sibling)
+		if (prefer_sibling && !local_group && sds->this_has_capacity)
 			sgs.group_capacity = min(sgs.group_capacity, 1UL);
 
 		if (local_group) {
@@ -2552,12 +2575,14 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			sds->this = sg;
 			sds->this_nr_running = sgs.sum_nr_running;
 			sds->this_load_per_task = sgs.sum_weighted_load;
+			sds->this_has_capacity = sgs.group_has_capacity;
 		} else if (update_sd_pick_busiest(sd, sds, sg, &sgs, this_cpu)) {
 			sds->max_load = sgs.avg_load;
 			sds->busiest = sg;
 			sds->busiest_nr_running = sgs.sum_nr_running;
 			sds->busiest_group_capacity = sgs.group_capacity;
 			sds->busiest_load_per_task = sgs.sum_weighted_load;
+			sds->busiest_has_capacity = sgs.group_has_capacity;
 			sds->group_imb = sgs.group_imb;
 		}
 
@@ -2754,6 +2779,7 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 		return fix_small_imbalance(sds, this_cpu, imbalance);
 
 }
+
 /******* find_busiest_group() helpers end here *********************/
 
 /**
@@ -2805,6 +2831,11 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	 * 4) This group is more busy than the avg busieness at this
 	 *    sched_domain.
 	 * 5) The imbalance is within the specified limit.
+	 *
+	 * Note: when doing newidle balance, if the local group has excess
+	 * capacity (i.e. nr_running < group_capacity) and the busiest group
+	 * does not have any capacity, we force a load balance to pull tasks
+	 * to the local group. In this case, we skip past checks 3, 4 and 5.
 	 */
 	if (!(*balance))
 		goto ret;
@@ -2816,6 +2847,11 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
+	/*  SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
+	if (idle == CPU_NEWLY_IDLE && sds.this_has_capacity &&
+			!sds.busiest_has_capacity)
+		goto force_balance;
+
 	if (sds.this_load >= sds.max_load)
 		goto out_balanced;
 
@@ -2827,6 +2863,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
 		goto out_balanced;
 
+force_balance:
 	/* Looks like there is an imbalance. Compute it */
 	calculate_imbalance(&sds, this_cpu, imbalance);
 	return sds.busiest;
@@ -3031,7 +3068,14 @@ redo:
 
 	if (!ld_moved) {
 		schedstat_inc(sd, lb_failed[idle]);
-		sd->nr_balance_failed++;
+		/*
+		 * Increment the failure counter only on periodic balance.
+		 * We do not want newidle balance, which can be very
+		 * frequent, pollute the failure counter causing
+		 * excessive cache_hot migrations and active balances.
+		 */
+		if (idle != CPU_NEWLY_IDLE)
+			sd->nr_balance_failed++;
 
 		if (need_active_balance(sd, sd_idle, idle, cpu_of(busiest),
 					this_cpu)) {
@@ -3153,10 +3197,8 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
-		if (pulled_task) {
-			this_rq->idle_stamp = 0;
+		if (pulled_task)
 			break;
-		}
 	}
 
 	raw_spin_lock(&this_rq->lock);
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 83c66e8..185f920 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -61,3 +61,8 @@ SCHED_FEAT(ASYM_EFF_LOAD, 1)
  * release the lock. Decreases scheduling overhead.
  */
 SCHED_FEAT(OWNER_SPIN, 1)
+
+/*
+ * Decrement CPU power based on irq activity
+ */
+SCHED_FEAT(NONIRQ_POWER, 1)
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index d10c80e..bea7d79 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -609,7 +609,7 @@ static void update_curr_rt(struct rq *rq)
 	if (!task_has_rt_policy(curr))
 		return;
 
-	delta_exec = rq->clock - curr->se.exec_start;
+	delta_exec = rq->clock_task - curr->se.exec_start;
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 
@@ -618,7 +618,7 @@ static void update_curr_rt(struct rq *rq)
 	curr->se.sum_exec_runtime += delta_exec;
 	account_group_exec_runtime(curr, delta_exec);
 
-	curr->se.exec_start = rq->clock;
+	curr->se.exec_start = rq->clock_task;
 	cpuacct_charge(curr, delta_exec);
 
 	sched_rt_avg_update(rq, delta_exec);
@@ -960,18 +960,19 @@ select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
 	 * runqueue. Otherwise simply start this RT task
 	 * on its current runqueue.
 	 *
-	 * We want to avoid overloading runqueues. Even if
-	 * the RT task is of higher priority than the current RT task.
-	 * RT tasks behave differently than other tasks. If
-	 * one gets preempted, we try to push it off to another queue.
-	 * So trying to keep a preempting RT task on the same
-	 * cache hot CPU will force the running RT task to
-	 * a cold CPU. So we waste all the cache for the lower
-	 * RT task in hopes of saving some of a RT task
-	 * that is just being woken and probably will have
-	 * cold cache anyway.
+	 * We want to avoid overloading runqueues. If the woken
+	 * task is a higher priority, then it will stay on this CPU
+	 * and the lower prio task should be moved to another CPU.
+	 * Even though this will probably make the lower prio task
+	 * lose its cache, we do not want to bounce a higher task
+	 * around just because it gave up its CPU, perhaps for a
+	 * lock?
+	 *
+	 * For equal prio tasks, we just let the scheduler sort it out.
 	 */
 	if (unlikely(rt_task(rq->curr)) &&
+	    (rq->curr->rt.nr_cpus_allowed < 2 ||
+	     rq->curr->prio < p->prio) &&
 	    (p->rt.nr_cpus_allowed > 1)) {
 		int cpu = find_lowest_rq(p);
 
@@ -1074,7 +1075,7 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 	} while (rt_rq);
 
 	p = rt_task_of(rt_se);
-	p->se.exec_start = rq->clock;
+	p->se.exec_start = rq->clock_task;
 
 	return p;
 }
@@ -1139,7 +1140,7 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 	for_each_leaf_rt_rq(rt_rq, rq) {
 		array = &rt_rq->active;
 		idx = sched_find_first_bit(array->bitmap);
- next_idx:
+next_idx:
 		if (idx >= MAX_RT_PRIO)
 			continue;
 		if (next && next->prio < idx)
@@ -1315,7 +1316,7 @@ static int push_rt_task(struct rq *rq)
 	if (!next_task)
 		return 0;
 
- retry:
+retry:
 	if (unlikely(next_task == rq->curr)) {
 		WARN_ON(1);
 		return 0;
@@ -1463,7 +1464,7 @@ static int pull_rt_task(struct rq *this_rq)
 			 * but possible)
 			 */
 		}
- skip:
+skip:
 		double_unlock_balance(this_rq, src_rq);
 	}
 
@@ -1491,7 +1492,10 @@ static void task_woken_rt(struct rq *rq, struct task_struct *p)
 	if (!task_running(rq, p) &&
 	    !test_tsk_need_resched(rq->curr) &&
 	    has_pushable_tasks(rq) &&
-	    p->rt.nr_cpus_allowed > 1)
+	    p->rt.nr_cpus_allowed > 1 &&
+	    rt_task(rq->curr) &&
+	    (rq->curr->rt.nr_cpus_allowed < 2 ||
+	     rq->curr->prio < p->prio))
 		push_rt_tasks(rq);
 }
 
@@ -1709,7 +1713,7 @@ static void set_curr_task_rt(struct rq *rq)
 {
 	struct task_struct *p = rq->curr;
 
-	p->se.exec_start = rq->clock;
+	p->se.exec_start = rq->clock_task;
 
 	/* The running task is never eligible for pushing */
 	dequeue_pushable_task(rq, p);
diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
new file mode 100644
index 0000000..45bddc0
--- /dev/null
+++ b/kernel/sched_stoptask.c
@@ -0,0 +1,108 @@
+/*
+ * stop-task scheduling class.
+ *
+ * The stop task is the highest priority task in the system, it preempts
+ * everything and will be preempted by nothing.
+ *
+ * See kernel/stop_machine.c
+ */
+
+#ifdef CONFIG_SMP
+static int
+select_task_rq_stop(struct rq *rq, struct task_struct *p,
+		    int sd_flag, int flags)
+{
+	return task_cpu(p); /* stop tasks as never migrate */
+}
+#endif /* CONFIG_SMP */
+
+static void
+check_preempt_curr_stop(struct rq *rq, struct task_struct *p, int flags)
+{
+	resched_task(rq->curr); /* we preempt everything */
+}
+
+static struct task_struct *pick_next_task_stop(struct rq *rq)
+{
+	struct task_struct *stop = rq->stop;
+
+	if (stop && stop->state == TASK_RUNNING)
+		return stop;
+
+	return NULL;
+}
+
+static void
+enqueue_task_stop(struct rq *rq, struct task_struct *p, int flags)
+{
+}
+
+static void
+dequeue_task_stop(struct rq *rq, struct task_struct *p, int flags)
+{
+}
+
+static void yield_task_stop(struct rq *rq)
+{
+	BUG(); /* the stop task should never yield, its pointless. */
+}
+
+static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
+{
+}
+
+static void task_tick_stop(struct rq *rq, struct task_struct *curr, int queued)
+{
+}
+
+static void set_curr_task_stop(struct rq *rq)
+{
+}
+
+static void switched_to_stop(struct rq *rq, struct task_struct *p,
+			     int running)
+{
+	BUG(); /* its impossible to change to this class */
+}
+
+static void prio_changed_stop(struct rq *rq, struct task_struct *p,
+			      int oldprio, int running)
+{
+	BUG(); /* how!?, what priority? */
+}
+
+static unsigned int
+get_rr_interval_stop(struct rq *rq, struct task_struct *task)
+{
+	return 0;
+}
+
+/*
+ * Simple, special scheduling class for the per-CPU stop tasks:
+ */
+static const struct sched_class stop_sched_class = {
+	.next			= &rt_sched_class,
+
+	.enqueue_task		= enqueue_task_stop,
+	.dequeue_task		= dequeue_task_stop,
+	.yield_task		= yield_task_stop,
+
+	.check_preempt_curr	= check_preempt_curr_stop,
+
+	.pick_next_task		= pick_next_task_stop,
+	.put_prev_task		= put_prev_task_stop,
+
+#ifdef CONFIG_SMP
+	.select_task_rq		= select_task_rq_stop,
+#endif
+
+	.set_curr_task          = set_curr_task_stop,
+	.task_tick		= task_tick_stop,
+
+	.get_rr_interval	= get_rr_interval_stop,
+
+	.prio_changed		= prio_changed_stop,
+	.switched_to		= switched_to_stop,
+
+	/* no .task_new for stop tasks */
+};
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 07b4f1b..79ee8f1 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -77,11 +77,21 @@ void wakeup_softirqd(void)
 }
 
 /*
+ * preempt_count and SOFTIRQ_OFFSET usage:
+ * - preempt_count is changed by SOFTIRQ_OFFSET on entering or leaving
+ *   softirq processing.
+ * - preempt_count is changed by SOFTIRQ_DISABLE_OFFSET (= 2 * SOFTIRQ_OFFSET)
+ *   on local_bh_disable or local_bh_enable.
+ * This lets us distinguish between whether we are currently processing
+ * softirq and whether we just have bh disabled.
+ */
+
+/*
  * This one is for softirq.c-internal use,
  * where hardirqs are disabled legitimately:
  */
 #ifdef CONFIG_TRACE_IRQFLAGS
-static void __local_bh_disable(unsigned long ip)
+static void __local_bh_disable(unsigned long ip, unsigned int cnt)
 {
 	unsigned long flags;
 
@@ -95,32 +105,43 @@ static void __local_bh_disable(unsigned long ip)
 	 * We must manually increment preempt_count here and manually
 	 * call the trace_preempt_off later.
 	 */
-	preempt_count() += SOFTIRQ_OFFSET;
+	preempt_count() += cnt;
 	/*
 	 * Were softirqs turned off above:
 	 */
-	if (softirq_count() == SOFTIRQ_OFFSET)
+	if (softirq_count() == cnt)
 		trace_softirqs_off(ip);
 	raw_local_irq_restore(flags);
 
-	if (preempt_count() == SOFTIRQ_OFFSET)
+	if (preempt_count() == cnt)
 		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
 }
 #else /* !CONFIG_TRACE_IRQFLAGS */
-static inline void __local_bh_disable(unsigned long ip)
+static inline void __local_bh_disable(unsigned long ip, unsigned int cnt)
 {
-	add_preempt_count(SOFTIRQ_OFFSET);
+	add_preempt_count(cnt);
 	barrier();
 }
 #endif /* CONFIG_TRACE_IRQFLAGS */
 
 void local_bh_disable(void)
 {
-	__local_bh_disable((unsigned long)__builtin_return_address(0));
+	__local_bh_disable((unsigned long)__builtin_return_address(0),
+				SOFTIRQ_DISABLE_OFFSET);
 }
 
 EXPORT_SYMBOL(local_bh_disable);
 
+static void __local_bh_enable(unsigned int cnt)
+{
+	WARN_ON_ONCE(in_irq());
+	WARN_ON_ONCE(!irqs_disabled());
+
+	if (softirq_count() == cnt)
+		trace_softirqs_on((unsigned long)__builtin_return_address(0));
+	sub_preempt_count(cnt);
+}
+
 /*
  * Special-case - softirqs can safely be enabled in
  * cond_resched_softirq(), or by __do_softirq(),
@@ -128,12 +149,7 @@ EXPORT_SYMBOL(local_bh_disable);
  */
 void _local_bh_enable(void)
 {
-	WARN_ON_ONCE(in_irq());
-	WARN_ON_ONCE(!irqs_disabled());
-
-	if (softirq_count() == SOFTIRQ_OFFSET)
-		trace_softirqs_on((unsigned long)__builtin_return_address(0));
-	sub_preempt_count(SOFTIRQ_OFFSET);
+	__local_bh_enable(SOFTIRQ_DISABLE_OFFSET);
 }
 
 EXPORT_SYMBOL(_local_bh_enable);
@@ -147,13 +163,13 @@ static inline void _local_bh_enable_ip(unsigned long ip)
 	/*
 	 * Are softirqs going to be turned on now:
 	 */
-	if (softirq_count() == SOFTIRQ_OFFSET)
+	if (softirq_count() == SOFTIRQ_DISABLE_OFFSET)
 		trace_softirqs_on(ip);
 	/*
 	 * Keep preemption disabled until we are done with
 	 * softirq processing:
  	 */
- 	sub_preempt_count(SOFTIRQ_OFFSET - 1);
+	sub_preempt_count(SOFTIRQ_DISABLE_OFFSET - 1);
 
 	if (unlikely(!in_interrupt() && local_softirq_pending()))
 		do_softirq();
@@ -198,7 +214,8 @@ asmlinkage void __do_softirq(void)
 	pending = local_softirq_pending();
 	account_system_vtime(current);
 
-	__local_bh_disable((unsigned long)__builtin_return_address(0));
+	__local_bh_disable((unsigned long)__builtin_return_address(0),
+				SOFTIRQ_OFFSET);
 	lockdep_softirq_enter();
 
 	cpu = smp_processor_id();
@@ -245,7 +262,7 @@ restart:
 	lockdep_softirq_exit();
 
 	account_system_vtime(current);
-	_local_bh_enable();
+	__local_bh_enable(SOFTIRQ_OFFSET);
 }
 
 #ifndef __ARCH_HAS_DO_SOFTIRQ
@@ -279,10 +296,16 @@ void irq_enter(void)
 
 	rcu_irq_enter();
 	if (idle_cpu(cpu) && !in_interrupt()) {
-		__irq_enter();
+		/*
+		 * Prevent raise_softirq from needlessly waking up ksoftirqd
+		 * here, as softirq will be serviced on return from interrupt.
+		 */
+		local_bh_disable();
 		tick_check_idle(cpu);
-	} else
-		__irq_enter();
+		_local_bh_enable();
+	}
+
+	__irq_enter();
 }
 
 #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
@@ -696,6 +719,7 @@ static int run_ksoftirqd(void * __bind_cpu)
 {
 	set_current_state(TASK_INTERRUPTIBLE);
 
+	current->flags |= PF_KSOFTIRQD;
 	while (!kthread_should_stop()) {
 		preempt_disable();
 		if (!local_softirq_pending()) {
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 4372ccb..090c288 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -287,11 +287,12 @@ repeat:
 	goto repeat;
 }
 
+extern void sched_set_stop_task(int cpu, struct task_struct *stop);
+
 /* manage stopper for a cpu, mostly lifted from sched migration thread mgmt */
 static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 					   unsigned long action, void *hcpu)
 {
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
 	unsigned int cpu = (unsigned long)hcpu;
 	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
 	struct task_struct *p;
@@ -304,13 +305,13 @@ static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 				   cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 		get_task_struct(p);
+		kthread_bind(p, cpu);
+		sched_set_stop_task(cpu, p);
 		stopper->thread = p;
 		break;
 
 	case CPU_ONLINE:
-		kthread_bind(stopper->thread, cpu);
 		/* strictly unnecessary, as first user will wake it */
 		wake_up_process(stopper->thread);
 		/* mark enabled */
@@ -325,6 +326,7 @@ static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 	{
 		struct cpu_stop_work *work;
 
+		sched_set_stop_task(cpu, NULL);
 		/* kill the stopper */
 		kthread_stop(stopper->thread);
 		/* drain remaining works */
diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index 78ef2c5..37dff78 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -123,7 +123,7 @@ static int cls_cgroup_classify(struct sk_buff *skb, struct tcf_proto *tp,
 	 * calls by looking at the number of nested bh disable calls because
 	 * softirqs always disables bh.
 	 */
-	if (softirq_count() != SOFTIRQ_OFFSET) {
+	if (in_serving_softirq()) {
 		/* If there is an sk_classid we'll use that. */
 		if (!skb->sk)
 			return -1;
