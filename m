Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003Ab2EVSXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:23:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39925 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2EVSXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 14:23:18 -0400
Date: Tue, 22 May 2012 20:23:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v3.5
Message-ID: <20120522182311.GA20282@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-core-for-linus

   HEAD: 1c2927f18576d65631d8e0ddd19e1d023183222e sched: Taint kernel with TAINT_WARN after sleep-in-atomic bug

The biggest change is the cleanup/simplification of the 
load-balancer: instead of the current practice of architectures 
twiddling scheduler internal data structures and providing the 
scheduler domains in colorfully inconsistent ways, we now have 
generic scheduler code in kernel/sched/core.c:sched_init_numa() 
that looks at the architecture's node_distance() parameters and 
(while not fully trusting it) deducts a NUMA topology from it.

This inevitably changes balancing behavior - hopefully for the 
better.

There are various smaller optimizations, cleanups and fixlets as 
well.

 Thanks,

	Ingo

------------------>
Hiroshi Shimamoto (1):
      sched: Update documentation and comments

Ingo Molnar (1):
      x86/numa: Check for nonsensical topologies on real hw as well

Kirill Tkhai (1):
      sched_rt: Avoid unnecessary dequeue and enqueue of pushable tasks in set_cpus_allowed_rt()

Konstantin Khlebnikov (1):
      sched: Taint kernel with TAINT_WARN after sleep-in-atomic bug

Peter Zijlstra (15):
      x86/numa: Allow specifying node_distance() for numa=fake
      x86/numa: Hard partition cpu topology masks on node boundaries
      sched: Change rq->nr_running to unsigned int
      sched/fair: Let minimally loaded cpu balance the group
      sched/fair: Add some serialization to the sched_domain load-balance walk
      sched/fair: Propagate 'struct lb_env' usage into find_busiest_group
      sched/numa: Rewrite the CONFIG_NUMA sched domain support
      sched/numa: Fix the new NUMA topology bits
      sched/x86: Rewrite set_cpu_sibling_map()
      sched/fair: Revert sched-domain iteration breakage
      sched/numa: Don't scale the imbalance
      sched/nohz: Fix rq->cpu_load[] calculations
      sched/fair: Improve the ->group_imb logic
      sched/debug: Fix printing large integers on 32-bit platforms
      sched: Remove stale power aware scheduling remnants and dysfunctional knobs

Srivatsa S. Bhat (1):
      x86/sched: Make mwait_usable() heed to "idle=" kernel parameters properly


 Documentation/ABI/testing/sysfs-devices-system-cpu |  25 --
 Documentation/scheduler/sched-design-CFS.txt       |   6 +-
 Documentation/scheduler/sched-domains.txt          |   4 -
 arch/ia64/include/asm/topology.h                   |  25 --
 arch/mips/include/asm/mach-ip27/topology.h         |  17 -
 arch/powerpc/include/asm/topology.h                |  36 --
 arch/sh/include/asm/topology.h                     |  25 --
 arch/sparc/include/asm/topology_64.h               |  19 -
 arch/tile/include/asm/topology.h                   |  26 --
 arch/x86/include/asm/topology.h                    |  38 --
 arch/x86/kernel/process.c                          |   8 +
 arch/x86/kernel/smpboot.c                          | 108 +++--
 arch/x86/mm/numa_emulation.c                       |   8 +-
 drivers/base/cpu.c                                 |   4 -
 include/linux/cpu.h                                |   2 -
 include/linux/sched.h                              |  49 +--
 include/linux/topology.h                           |  42 --
 kernel/sched/core.c                                | 420 ++++++++++---------
 kernel/sched/debug.c                               |  12 +-
 kernel/sched/fair.c                                | 462 +++++----------------
 kernel/sched/idle_task.c                           |   2 +-
 kernel/sched/rt.c                                  |  56 ++-
 kernel/sched/sched.h                               |   8 +-
 tools/power/cpupower/man/cpupower-set.1            |   9 -
 tools/power/cpupower/utils/helpers/sysfs.c         |  35 +-
 25 files changed, 441 insertions(+), 1005 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index e7be75b..5dab364 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -9,31 +9,6 @@ Description:
 
 		/sys/devices/system/cpu/cpu#/
 
-What:		/sys/devices/system/cpu/sched_mc_power_savings
-		/sys/devices/system/cpu/sched_smt_power_savings
-Date:		June 2006
-Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
-Description:	Discover and adjust the kernel's multi-core scheduler support.
-
-		Possible values are:
-
-		0 - No power saving load balance (default value)
-		1 - Fill one thread/core/package first for long running threads
-		2 - Also bias task wakeups to semi-idle cpu package for power
-		    savings
-
-		sched_mc_power_savings is dependent upon SCHED_MC, which is
-		itself architecture dependent.
-
-		sched_smt_power_savings is dependent upon SCHED_SMT, which
-		is itself architecture dependent.
-
-		The two files are independent of each other. It is possible
-		that one file may be present without the other.
-
-		Introduced by git commit 5c45bf27.
-
-
 What:		/sys/devices/system/cpu/kernel_max
 		/sys/devices/system/cpu/offline
 		/sys/devices/system/cpu/online
diff --git a/Documentation/scheduler/sched-design-CFS.txt b/Documentation/scheduler/sched-design-CFS.txt
index 91ecff0..d529e02d 100644
--- a/Documentation/scheduler/sched-design-CFS.txt
+++ b/Documentation/scheduler/sched-design-CFS.txt
@@ -130,7 +130,7 @@ CFS implements three scheduling policies:
     idle timer scheduler in order to avoid to get into priority
     inversion problems which would deadlock the machine.
 
-SCHED_FIFO/_RR are implemented in sched_rt.c and are as specified by
+SCHED_FIFO/_RR are implemented in sched/rt.c and are as specified by
 POSIX.
 
 The command chrt from util-linux-ng 2.13.1.1 can set all of these except
@@ -145,9 +145,9 @@ Classes," an extensible hierarchy of scheduler modules.  These modules
 encapsulate scheduling policy details and are handled by the scheduler core
 without the core code assuming too much about them.
 
-sched_fair.c implements the CFS scheduler described above.
+sched/fair.c implements the CFS scheduler described above.
 
-sched_rt.c implements SCHED_FIFO and SCHED_RR semantics, in a simpler way than
+sched/rt.c implements SCHED_FIFO and SCHED_RR semantics, in a simpler way than
 the previous vanilla scheduler did.  It uses 100 runqueues (for all 100 RT
 priority levels, instead of 140 in the previous scheduler) and it needs no
 expired array.
diff --git a/Documentation/scheduler/sched-domains.txt b/Documentation/scheduler/sched-domains.txt
index b7ee379..443f0c7 100644
--- a/Documentation/scheduler/sched-domains.txt
+++ b/Documentation/scheduler/sched-domains.txt
@@ -61,10 +61,6 @@ The implementor should read comments in include/linux/sched.h:
 struct sched_domain fields, SD_FLAG_*, SD_*_INIT to get an idea of
 the specifics and what to tune.
 
-For SMT, the architecture must define CONFIG_SCHED_SMT and provide a
-cpumask_t cpu_sibling_map[NR_CPUS], where cpu_sibling_map[i] is the mask of
-all "i"'s siblings as well as "i" itself.
-
 Architectures may retain the regular override the default SD_*_INIT flags
 while using the generic domain builder in kernel/sched.c if they wish to
 retain the traditional SMT->SMP->NUMA topology (or some subset of that). This
diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index 09f6467..a2496e4 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -70,31 +70,6 @@ void build_cpu_to_node_map(void);
 	.nr_balance_failed	= 0,			\
 }
 
-/* sched_domains SD_NODE_INIT for IA64 NUMA machines */
-#define SD_NODE_INIT (struct sched_domain) {		\
-	.parent			= NULL,			\
-	.child			= NULL,			\
-	.groups			= NULL,			\
-	.min_interval		= 8,			\
-	.max_interval		= 8*(min(num_online_cpus(), 32U)), \
-	.busy_factor		= 64,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 2,			\
-	.busy_idx		= 3,			\
-	.idle_idx		= 2,			\
-	.newidle_idx		= 0,			\
-	.wake_idx		= 0,			\
-	.forkexec_idx		= 0,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_NEWIDLE	\
-				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_FORK	\
-				| SD_SERIALIZE,		\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 64,			\
-	.nr_balance_failed	= 0,			\
-}
-
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_SMP
diff --git a/arch/mips/include/asm/mach-ip27/topology.h b/arch/mips/include/asm/mach-ip27/topology.h
index 1b1a7d1..b2cf641 100644
--- a/arch/mips/include/asm/mach-ip27/topology.h
+++ b/arch/mips/include/asm/mach-ip27/topology.h
@@ -36,23 +36,6 @@ extern unsigned char __node_distances[MAX_COMPACT_NODES][MAX_COMPACT_NODES];
 
 #define node_distance(from, to)	(__node_distances[(from)][(to)])
 
-/* sched_domains SD_NODE_INIT for SGI IP27 machines */
-#define SD_NODE_INIT (struct sched_domain) {		\
-	.parent			= NULL,			\
-	.child			= NULL,			\
-	.groups			= NULL,			\
-	.min_interval		= 8,			\
-	.max_interval		= 32,			\
-	.busy_factor		= 32,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 1,			\
-	.flags			= SD_LOAD_BALANCE |	\
-				  SD_BALANCE_EXEC,	\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
-}
-
 #include <asm-generic/topology.h>
 
 #endif /* _ASM_MACH_TOPOLOGY_H */
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index c971858..852ed1b 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -18,12 +18,6 @@ struct device_node;
  */
 #define RECLAIM_DISTANCE 10
 
-/*
- * Avoid creating an extra level of balancing (SD_ALLNODES) on the largest
- * POWER7 boxes which have a maximum of 32 nodes.
- */
-#define SD_NODES_PER_DOMAIN 32
-
 #include <asm/mmzone.h>
 
 static inline int cpu_to_node(int cpu)
@@ -51,36 +45,6 @@ static inline int pcibus_to_node(struct pci_bus *bus)
 				 cpu_all_mask :				\
 				 cpumask_of_node(pcibus_to_node(bus)))
 
-/* sched_domains SD_NODE_INIT for PPC64 machines */
-#define SD_NODE_INIT (struct sched_domain) {				\
-	.min_interval		= 8,					\
-	.max_interval		= 32,					\
-	.busy_factor		= 32,					\
-	.imbalance_pct		= 125,					\
-	.cache_nice_tries	= 1,					\
-	.busy_idx		= 3,					\
-	.idle_idx		= 1,					\
-	.newidle_idx		= 0,					\
-	.wake_idx		= 0,					\
-	.forkexec_idx		= 0,					\
-									\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 0*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 1*SD_WAKE_AFFINE			\
-				| 0*SD_PREFER_LOCAL			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 0*SD_POWERSAVINGS_BALANCE		\
-				| 0*SD_SHARE_PKG_RESOURCES		\
-				| 1*SD_SERIALIZE			\
-				| 0*SD_PREFER_SIBLING			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 1,					\
-}
-
 extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
 
diff --git a/arch/sh/include/asm/topology.h b/arch/sh/include/asm/topology.h
index 88e7340..b0a282d 100644
--- a/arch/sh/include/asm/topology.h
+++ b/arch/sh/include/asm/topology.h
@@ -3,31 +3,6 @@
 
 #ifdef CONFIG_NUMA
 
-/* sched_domains SD_NODE_INIT for sh machines */
-#define SD_NODE_INIT (struct sched_domain) {		\
-	.parent			= NULL,			\
-	.child			= NULL,			\
-	.groups			= NULL,			\
-	.min_interval		= 8,			\
-	.max_interval		= 32,			\
-	.busy_factor		= 32,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 2,			\
-	.busy_idx		= 3,			\
-	.idle_idx		= 2,			\
-	.newidle_idx		= 0,			\
-	.wake_idx		= 0,			\
-	.forkexec_idx		= 0,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_FORK	\
-				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_NEWIDLE	\
-				| SD_SERIALIZE,		\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
-}
-
 #define cpu_to_node(cpu)	((void)(cpu),0)
 #define parent_node(node)	((void)(node),0)
 
diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index 8b9c556..1754390 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -31,25 +31,6 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 	 cpu_all_mask : \
 	 cpumask_of_node(pcibus_to_node(bus)))
 
-#define SD_NODE_INIT (struct sched_domain) {		\
-	.min_interval		= 8,			\
-	.max_interval		= 32,			\
-	.busy_factor		= 32,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 2,			\
-	.busy_idx		= 3,			\
-	.idle_idx		= 2,			\
-	.newidle_idx		= 0, 			\
-	.wake_idx		= 0,			\
-	.forkexec_idx		= 0,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_FORK	\
-				| SD_BALANCE_EXEC	\
-				| SD_SERIALIZE,		\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
-}
-
 #else /* CONFIG_NUMA */
 
 #include <asm-generic/topology.h>
diff --git a/arch/tile/include/asm/topology.h b/arch/tile/include/asm/topology.h
index 6fdd0c8..7a7ce39 100644
--- a/arch/tile/include/asm/topology.h
+++ b/arch/tile/include/asm/topology.h
@@ -78,32 +78,6 @@ static inline const struct cpumask *cpumask_of_node(int node)
 	.balance_interval	= 32,					\
 }
 
-/* sched_domains SD_NODE_INIT for TILE architecture */
-#define SD_NODE_INIT (struct sched_domain) {				\
-	.min_interval		= 16,					\
-	.max_interval		= 512,					\
-	.busy_factor		= 32,					\
-	.imbalance_pct		= 125,					\
-	.cache_nice_tries	= 1,					\
-	.busy_idx		= 3,					\
-	.idle_idx		= 1,					\
-	.newidle_idx		= 2,					\
-	.wake_idx		= 1,					\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 0*SD_WAKE_AFFINE			\
-				| 0*SD_PREFER_LOCAL			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 0*SD_SHARE_PKG_RESOURCES		\
-				| 1*SD_SERIALIZE			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 128,					\
-}
-
 /* By definition, we create nodes based on online memory. */
 #define node_has_online_mem(nid) 1
 
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index b9676ae..095b215 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -92,44 +92,6 @@ extern void setup_node_to_cpumask_map(void);
 
 #define pcibus_to_node(bus) __pcibus_to_node(bus)
 
-#ifdef CONFIG_X86_32
-# define SD_CACHE_NICE_TRIES	1
-# define SD_IDLE_IDX		1
-#else
-# define SD_CACHE_NICE_TRIES	2
-# define SD_IDLE_IDX		2
-#endif
-
-/* sched_domains SD_NODE_INIT for NUMA machines */
-#define SD_NODE_INIT (struct sched_domain) {				\
-	.min_interval		= 8,					\
-	.max_interval		= 32,					\
-	.busy_factor		= 32,					\
-	.imbalance_pct		= 125,					\
-	.cache_nice_tries	= SD_CACHE_NICE_TRIES,			\
-	.busy_idx		= 3,					\
-	.idle_idx		= SD_IDLE_IDX,				\
-	.newidle_idx		= 0,					\
-	.wake_idx		= 0,					\
-	.forkexec_idx		= 0,					\
-									\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 1*SD_WAKE_AFFINE			\
-				| 0*SD_PREFER_LOCAL			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 0*SD_POWERSAVINGS_BALANCE		\
-				| 0*SD_SHARE_PKG_RESOURCES		\
-				| 1*SD_SERIALIZE			\
-				| 0*SD_PREFER_SIBLING			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 1,					\
-}
-
 extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1d92a5a..ad57d83 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -594,9 +594,17 @@ int mwait_usable(const struct cpuinfo_x86 *c)
 {
 	u32 eax, ebx, ecx, edx;
 
+	/* Use mwait if idle=mwait boot option is given */
 	if (boot_option_idle_override == IDLE_FORCE_MWAIT)
 		return 1;
 
+	/*
+	 * Any idle= boot option other than idle=mwait means that we must not
+	 * use mwait. Eg: idle=halt or idle=poll or idle=nomwait
+	 */
+	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
+		return 0;
+
 	if (c->cpuid_level < MWAIT_INFO)
 		return 0;
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6e1e406..256c20c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -315,59 +315,90 @@ void __cpuinit smp_store_cpu_info(int id)
 		identify_secondary_cpu(c);
 }
 
-static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
+static bool __cpuinit
+topology_sane(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o, const char *name)
 {
-	cpumask_set_cpu(cpu1, cpu_sibling_mask(cpu2));
-	cpumask_set_cpu(cpu2, cpu_sibling_mask(cpu1));
-	cpumask_set_cpu(cpu1, cpu_core_mask(cpu2));
-	cpumask_set_cpu(cpu2, cpu_core_mask(cpu1));
-	cpumask_set_cpu(cpu1, cpu_llc_shared_mask(cpu2));
-	cpumask_set_cpu(cpu2, cpu_llc_shared_mask(cpu1));
+	int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
+
+	return !WARN_ONCE(cpu_to_node(cpu1) != cpu_to_node(cpu2),
+		"sched: CPU #%d's %s-sibling CPU #%d is not on the same node! "
+		"[node: %d != %d]. Ignoring dependency.\n",
+		cpu1, name, cpu2, cpu_to_node(cpu1), cpu_to_node(cpu2));
 }
 
+#define link_mask(_m, c1, c2)						\
+do {									\
+	cpumask_set_cpu((c1), cpu_##_m##_mask(c2));			\
+	cpumask_set_cpu((c2), cpu_##_m##_mask(c1));			\
+} while (0)
+
+static bool __cpuinit match_smt(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+{
+	if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
+		int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
+
+		if (c->phys_proc_id == o->phys_proc_id &&
+		    per_cpu(cpu_llc_id, cpu1) == per_cpu(cpu_llc_id, cpu2) &&
+		    c->compute_unit_id == o->compute_unit_id)
+			return topology_sane(c, o, "smt");
+
+	} else if (c->phys_proc_id == o->phys_proc_id &&
+		   c->cpu_core_id == o->cpu_core_id) {
+		return topology_sane(c, o, "smt");
+	}
+
+	return false;
+}
+
+static bool __cpuinit match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+{
+	int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
+
+	if (per_cpu(cpu_llc_id, cpu1) != BAD_APICID &&
+	    per_cpu(cpu_llc_id, cpu1) == per_cpu(cpu_llc_id, cpu2))
+		return topology_sane(c, o, "llc");
+
+	return false;
+}
+
+static bool __cpuinit match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+{
+	if (c->phys_proc_id == o->phys_proc_id)
+		return topology_sane(c, o, "mc");
+
+	return false;
+}
 
 void __cpuinit set_cpu_sibling_map(int cpu)
 {
-	int i;
+	bool has_mc = boot_cpu_data.x86_max_cores > 1;
+	bool has_smt = smp_num_siblings > 1;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	struct cpuinfo_x86 *o;
+	int i;
 
 	cpumask_set_cpu(cpu, cpu_sibling_setup_mask);
 
-	if (smp_num_siblings > 1) {
-		for_each_cpu(i, cpu_sibling_setup_mask) {
-			struct cpuinfo_x86 *o = &cpu_data(i);
-
-			if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
-				if (c->phys_proc_id == o->phys_proc_id &&
-				    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i) &&
-				    c->compute_unit_id == o->compute_unit_id)
-					link_thread_siblings(cpu, i);
-			} else if (c->phys_proc_id == o->phys_proc_id &&
-				   c->cpu_core_id == o->cpu_core_id) {
-				link_thread_siblings(cpu, i);
-			}
-		}
-	} else {
+	if (!has_smt && !has_mc) {
 		cpumask_set_cpu(cpu, cpu_sibling_mask(cpu));
-	}
-
-	cpumask_set_cpu(cpu, cpu_llc_shared_mask(cpu));
-
-	if (__this_cpu_read(cpu_info.x86_max_cores) == 1) {
-		cpumask_copy(cpu_core_mask(cpu), cpu_sibling_mask(cpu));
+		cpumask_set_cpu(cpu, cpu_llc_shared_mask(cpu));
+		cpumask_set_cpu(cpu, cpu_core_mask(cpu));
 		c->booted_cores = 1;
 		return;
 	}
 
 	for_each_cpu(i, cpu_sibling_setup_mask) {
-		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
-		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
-			cpumask_set_cpu(i, cpu_llc_shared_mask(cpu));
-			cpumask_set_cpu(cpu, cpu_llc_shared_mask(i));
-		}
-		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
-			cpumask_set_cpu(i, cpu_core_mask(cpu));
-			cpumask_set_cpu(cpu, cpu_core_mask(i));
+		o = &cpu_data(i);
+
+		if ((i == cpu) || (has_smt && match_smt(c, o)))
+			link_mask(sibling, cpu, i);
+
+		if ((i == cpu) || (has_mc && match_llc(c, o)))
+			link_mask(llc_shared, cpu, i);
+
+		if ((i == cpu) || (has_mc && match_mc(c, o))) {
+			link_mask(core, cpu, i);
+
 			/*
 			 *  Does this new cpu bringup a new core?
 			 */
@@ -398,8 +429,7 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 	 * For perf, we return last level cache shared map.
 	 * And for power savings, we return cpu_core_map
 	 */
-	if ((sched_mc_power_savings || sched_smt_power_savings) &&
-	    !(cpu_has(c, X86_FEATURE_AMD_DCM)))
+	if (!(cpu_has(c, X86_FEATURE_AMD_DCM)))
 		return cpu_core_mask(cpu);
 	else
 		return cpu_llc_shared_mask(cpu);
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index 53489ff..871dd88 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -339,9 +339,11 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 	} else {
 		unsigned long n;
 
-		n = simple_strtoul(emu_cmdline, NULL, 0);
+		n = simple_strtoul(emu_cmdline, &emu_cmdline, 0);
 		ret = split_nodes_interleave(&ei, &pi, 0, max_addr, n);
 	}
+	if (*emu_cmdline == ':')
+		emu_cmdline++;
 
 	if (ret < 0)
 		goto no_emu;
@@ -418,7 +420,9 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 			int physj = emu_nid_to_phys[j];
 			int dist;
 
-			if (physi >= numa_dist_cnt || physj >= numa_dist_cnt)
+			if (get_option(&emu_cmdline, &dist) == 2)
+				;
+			else if (physi >= numa_dist_cnt || physj >= numa_dist_cnt)
 				dist = physi == physj ?
 					LOCAL_DISTANCE : REMOTE_DISTANCE;
 			else
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index adf937b..6345294 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -330,8 +330,4 @@ void __init cpu_dev_init(void)
 		panic("Failed to register CPU subsystem");
 
 	cpu_dev_register_generic();
-
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	sched_create_sysfs_power_savings_entries(cpu_subsys.dev_root);
-#endif
 }
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ee28844..7230bb5 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -36,8 +36,6 @@ extern void cpu_remove_dev_attr(struct device_attribute *attr);
 extern int cpu_add_dev_attr_group(struct attribute_group *attrs);
 extern void cpu_remove_dev_attr_group(struct attribute_group *attrs);
 
-extern int sched_create_sysfs_power_savings_entries(struct device *dev);
-
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
 extern ssize_t arch_cpu_probe(const char *, size_t);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 81a173c..3d64480 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -855,61 +855,14 @@ enum cpu_idle_type {
 #define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
 #define SD_PREFER_LOCAL		0x0040  /* Prefer to keep tasks local to this domain */
 #define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
-#define SD_POWERSAVINGS_BALANCE	0x0100	/* Balance for power savings */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
 
-enum powersavings_balance_level {
-	POWERSAVINGS_BALANCE_NONE = 0,  /* No power saving load balance */
-	POWERSAVINGS_BALANCE_BASIC,	/* Fill one thread/core/package
-					 * first for long running threads
-					 */
-	POWERSAVINGS_BALANCE_WAKEUP,	/* Also bias task wakeups to semi-idle
-					 * cpu package for power savings
-					 */
-	MAX_POWERSAVINGS_BALANCE_LEVELS
-};
-
-extern int sched_mc_power_savings, sched_smt_power_savings;
-
-static inline int sd_balance_for_mc_power(void)
-{
-	if (sched_smt_power_savings)
-		return SD_POWERSAVINGS_BALANCE;
-
-	if (!sched_mc_power_savings)
-		return SD_PREFER_SIBLING;
-
-	return 0;
-}
-
-static inline int sd_balance_for_package_power(void)
-{
-	if (sched_mc_power_savings | sched_smt_power_savings)
-		return SD_POWERSAVINGS_BALANCE;
-
-	return SD_PREFER_SIBLING;
-}
-
 extern int __weak arch_sd_sibiling_asym_packing(void);
 
-/*
- * Optimise SD flags for power savings:
- * SD_BALANCE_NEWIDLE helps aggressive task consolidation and power savings.
- * Keep default SD flags if sched_{smt,mc}_power_saving=0
- */
-
-static inline int sd_power_saving_flags(void)
-{
-	if (sched_mc_power_savings | sched_smt_power_savings)
-		return SD_BALANCE_NEWIDLE;
-
-	return 0;
-}
-
 struct sched_group_power {
 	atomic_t ref;
 	/*
@@ -1950,7 +1903,7 @@ static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
  */
 extern unsigned long long notrace sched_clock(void);
 /*
- * See the comment in kernel/sched_clock.c
+ * See the comment in kernel/sched/clock.c
  */
 extern u64 cpu_clock(int cpu);
 extern u64 local_clock(void);
diff --git a/include/linux/topology.h b/include/linux/topology.h
index e26db03..09558d1 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -70,7 +70,6 @@ int arch_update_cpu_topology(void);
  * Below are the 3 major initializers used in building sched_domains:
  * SD_SIBLING_INIT, for SMT domains
  * SD_CPU_INIT, for SMP domains
- * SD_NODE_INIT, for NUMA domains
  *
  * Any architecture that cares to do any tuning to these values should do so
  * by defining their own arch-specific initializer in include/asm/topology.h.
@@ -99,7 +98,6 @@ int arch_update_cpu_topology(void);
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_SHARE_CPUPOWER			\
-				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
@@ -135,8 +133,6 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| sd_balance_for_mc_power()		\
-				| sd_power_saving_flags()		\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
@@ -168,56 +164,18 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| sd_balance_for_package_power()	\
-				| sd_power_saving_flags()		\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
 }
 #endif
 
-/* sched_domains SD_ALLNODES_INIT for NUMA machines */
-#define SD_ALLNODES_INIT (struct sched_domain) {			\
-	.min_interval		= 64,					\
-	.max_interval		= 64*num_online_cpus(),			\
-	.busy_factor		= 128,					\
-	.imbalance_pct		= 133,					\
-	.cache_nice_tries	= 1,					\
-	.busy_idx		= 3,					\
-	.idle_idx		= 3,					\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 0*SD_BALANCE_EXEC			\
-				| 0*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 0*SD_WAKE_AFFINE			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 0*SD_POWERSAVINGS_BALANCE		\
-				| 0*SD_SHARE_PKG_RESOURCES		\
-				| 1*SD_SERIALIZE			\
-				| 0*SD_PREFER_SIBLING			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 64,					\
-}
-
-#ifndef SD_NODES_PER_DOMAIN
-#define SD_NODES_PER_DOMAIN 16
-#endif
-
 #ifdef CONFIG_SCHED_BOOK
 #ifndef SD_BOOK_INIT
 #error Please define an appropriate SD_BOOK_INIT in include/asm/topology.h!!!
 #endif
 #endif /* CONFIG_SCHED_BOOK */
 
-#ifdef CONFIG_NUMA
-#ifndef SD_NODE_INIT
-#error Please define an appropriate SD_NODE_INIT in include/asm/topology.h!!!
-#endif
-
-#endif /* CONFIG_NUMA */
-
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DECLARE_PER_CPU(int, numa_node);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e5212ae..ab9745f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -692,8 +692,6 @@ int tg_nop(struct task_group *tg, void *data)
 }
 #endif
 
-void update_cpu_load(struct rq *this_rq);
-
 static void set_load_weight(struct task_struct *p)
 {
 	int prio = p->static_prio - MAX_RT_PRIO;
@@ -2486,22 +2484,13 @@ decay_load_missed(unsigned long load, unsigned long missed_updates, int idx)
  * scheduler tick (TICK_NSEC). With tickless idle this will not be called
  * every tick. We fix it up based on jiffies.
  */
-void update_cpu_load(struct rq *this_rq)
+static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
+			      unsigned long pending_updates)
 {
-	unsigned long this_load = this_rq->load.weight;
-	unsigned long curr_jiffies = jiffies;
-	unsigned long pending_updates;
 	int i, scale;
 
 	this_rq->nr_load_updates++;
 
-	/* Avoid repeated calls on same jiffy, when moving in and out of idle */
-	if (curr_jiffies == this_rq->last_load_update_tick)
-		return;
-
-	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
-	this_rq->last_load_update_tick = curr_jiffies;
-
 	/* Update our load: */
 	this_rq->cpu_load[0] = this_load; /* Fasttrack for idx 0 */
 	for (i = 1, scale = 2; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
@@ -2526,9 +2515,45 @@ void update_cpu_load(struct rq *this_rq)
 	sched_avg_update(this_rq);
 }
 
+/*
+ * Called from nohz_idle_balance() to update the load ratings before doing the
+ * idle balance.
+ */
+void update_idle_cpu_load(struct rq *this_rq)
+{
+	unsigned long curr_jiffies = jiffies;
+	unsigned long load = this_rq->load.weight;
+	unsigned long pending_updates;
+
+	/*
+	 * Bloody broken means of dealing with nohz, but better than nothing..
+	 * jiffies is updated by one cpu, another cpu can drift wrt the jiffy
+	 * update and see 0 difference the one time and 2 the next, even though
+	 * we ticked at roughtly the same rate.
+	 *
+	 * Hence we only use this from nohz_idle_balance() and skip this
+	 * nonsense when called from the scheduler_tick() since that's
+	 * guaranteed a stable rate.
+	 */
+	if (load || curr_jiffies == this_rq->last_load_update_tick)
+		return;
+
+	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
+	this_rq->last_load_update_tick = curr_jiffies;
+
+	__update_cpu_load(this_rq, load, pending_updates);
+}
+
+/*
+ * Called from scheduler_tick()
+ */
 static void update_cpu_load_active(struct rq *this_rq)
 {
-	update_cpu_load(this_rq);
+	/*
+	 * See the mess in update_idle_cpu_load().
+	 */
+	this_rq->last_load_update_tick = jiffies;
+	__update_cpu_load(this_rq, this_rq->load.weight, 1);
 
 	calc_load_account_active(this_rq);
 }
@@ -3113,6 +3138,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
 	dump_stack();
+	add_taint(TAINT_WARN);
 }
 
 /*
@@ -5560,7 +5586,8 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 			break;
 		}
 
-		if (cpumask_intersects(groupmask, sched_group_cpus(group))) {
+		if (!(sd->flags & SD_OVERLAP) &&
+		    cpumask_intersects(groupmask, sched_group_cpus(group))) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: repeated CPUs\n");
 			break;
@@ -5898,99 +5925,11 @@ static int __init isolated_cpu_setup(char *str)
 
 __setup("isolcpus=", isolated_cpu_setup);
 
-#ifdef CONFIG_NUMA
-
-/**
- * find_next_best_node - find the next node to include in a sched_domain
- * @node: node whose sched_domain we're building
- * @used_nodes: nodes already in the sched_domain
- *
- * Find the next node to include in a given scheduling domain. Simply
- * finds the closest node not already in the @used_nodes map.
- *
- * Should use nodemask_t.
- */
-static int find_next_best_node(int node, nodemask_t *used_nodes)
-{
-	int i, n, val, min_val, best_node = -1;
-
-	min_val = INT_MAX;
-
-	for (i = 0; i < nr_node_ids; i++) {
-		/* Start at @node */
-		n = (node + i) % nr_node_ids;
-
-		if (!nr_cpus_node(n))
-			continue;
-
-		/* Skip already used nodes */
-		if (node_isset(n, *used_nodes))
-			continue;
-
-		/* Simple min distance search */
-		val = node_distance(node, n);
-
-		if (val < min_val) {
-			min_val = val;
-			best_node = n;
-		}
-	}
-
-	if (best_node != -1)
-		node_set(best_node, *used_nodes);
-	return best_node;
-}
-
-/**
- * sched_domain_node_span - get a cpumask for a node's sched_domain
- * @node: node whose cpumask we're constructing
- * @span: resulting cpumask
- *
- * Given a node, construct a good cpumask for its sched_domain to span. It
- * should be one that prevents unnecessary balancing, but also spreads tasks
- * out optimally.
- */
-static void sched_domain_node_span(int node, struct cpumask *span)
-{
-	nodemask_t used_nodes;
-	int i;
-
-	cpumask_clear(span);
-	nodes_clear(used_nodes);
-
-	cpumask_or(span, span, cpumask_of_node(node));
-	node_set(node, used_nodes);
-
-	for (i = 1; i < SD_NODES_PER_DOMAIN; i++) {
-		int next_node = find_next_best_node(node, &used_nodes);
-		if (next_node < 0)
-			break;
-		cpumask_or(span, span, cpumask_of_node(next_node));
-	}
-}
-
-static const struct cpumask *cpu_node_mask(int cpu)
-{
-	lockdep_assert_held(&sched_domains_mutex);
-
-	sched_domain_node_span(cpu_to_node(cpu), sched_domains_tmpmask);
-
-	return sched_domains_tmpmask;
-}
-
-static const struct cpumask *cpu_allnodes_mask(int cpu)
-{
-	return cpu_possible_mask;
-}
-#endif /* CONFIG_NUMA */
-
 static const struct cpumask *cpu_cpu_mask(int cpu)
 {
 	return cpumask_of_node(cpu_to_node(cpu));
 }
 
-int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
-
 struct sd_data {
 	struct sched_domain **__percpu sd;
 	struct sched_group **__percpu sg;
@@ -6020,6 +5959,7 @@ struct sched_domain_topology_level {
 	sched_domain_init_f init;
 	sched_domain_mask_f mask;
 	int		    flags;
+	int		    numa_level;
 	struct sd_data      data;
 };
 
@@ -6211,10 +6151,6 @@ sd_init_##type(struct sched_domain_topology_level *tl, int cpu) 	\
 }
 
 SD_INIT_FUNC(CPU)
-#ifdef CONFIG_NUMA
- SD_INIT_FUNC(ALLNODES)
- SD_INIT_FUNC(NODE)
-#endif
 #ifdef CONFIG_SCHED_SMT
  SD_INIT_FUNC(SIBLING)
 #endif
@@ -6336,15 +6272,184 @@ static struct sched_domain_topology_level default_topology[] = {
 	{ sd_init_BOOK, cpu_book_mask, },
 #endif
 	{ sd_init_CPU, cpu_cpu_mask, },
-#ifdef CONFIG_NUMA
-	{ sd_init_NODE, cpu_node_mask, SDTL_OVERLAP, },
-	{ sd_init_ALLNODES, cpu_allnodes_mask, },
-#endif
 	{ NULL, },
 };
 
 static struct sched_domain_topology_level *sched_domain_topology = default_topology;
 
+#ifdef CONFIG_NUMA
+
+static int sched_domains_numa_levels;
+static int sched_domains_numa_scale;
+static int *sched_domains_numa_distance;
+static struct cpumask ***sched_domains_numa_masks;
+static int sched_domains_curr_level;
+
+static inline int sd_local_flags(int level)
+{
+	if (sched_domains_numa_distance[level] > REMOTE_DISTANCE)
+		return 0;
+
+	return SD_BALANCE_EXEC | SD_BALANCE_FORK | SD_WAKE_AFFINE;
+}
+
+static struct sched_domain *
+sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
+{
+	struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);
+	int level = tl->numa_level;
+	int sd_weight = cpumask_weight(
+			sched_domains_numa_masks[level][cpu_to_node(cpu)]);
+
+	*sd = (struct sched_domain){
+		.min_interval		= sd_weight,
+		.max_interval		= 2*sd_weight,
+		.busy_factor		= 32,
+		.imbalance_pct		= 125,
+		.cache_nice_tries	= 2,
+		.busy_idx		= 3,
+		.idle_idx		= 2,
+		.newidle_idx		= 0,
+		.wake_idx		= 0,
+		.forkexec_idx		= 0,
+
+		.flags			= 1*SD_LOAD_BALANCE
+					| 1*SD_BALANCE_NEWIDLE
+					| 0*SD_BALANCE_EXEC
+					| 0*SD_BALANCE_FORK
+					| 0*SD_BALANCE_WAKE
+					| 0*SD_WAKE_AFFINE
+					| 0*SD_PREFER_LOCAL
+					| 0*SD_SHARE_CPUPOWER
+					| 0*SD_SHARE_PKG_RESOURCES
+					| 1*SD_SERIALIZE
+					| 0*SD_PREFER_SIBLING
+					| sd_local_flags(level)
+					,
+		.last_balance		= jiffies,
+		.balance_interval	= sd_weight,
+	};
+	SD_INIT_NAME(sd, NUMA);
+	sd->private = &tl->data;
+
+	/*
+	 * Ugly hack to pass state to sd_numa_mask()...
+	 */
+	sched_domains_curr_level = tl->numa_level;
+
+	return sd;
+}
+
+static const struct cpumask *sd_numa_mask(int cpu)
+{
+	return sched_domains_numa_masks[sched_domains_curr_level][cpu_to_node(cpu)];
+}
+
+static void sched_init_numa(void)
+{
+	int next_distance, curr_distance = node_distance(0, 0);
+	struct sched_domain_topology_level *tl;
+	int level = 0;
+	int i, j, k;
+
+	sched_domains_numa_scale = curr_distance;
+	sched_domains_numa_distance = kzalloc(sizeof(int) * nr_node_ids, GFP_KERNEL);
+	if (!sched_domains_numa_distance)
+		return;
+
+	/*
+	 * O(nr_nodes^2) deduplicating selection sort -- in order to find the
+	 * unique distances in the node_distance() table.
+	 *
+	 * Assumes node_distance(0,j) includes all distances in
+	 * node_distance(i,j) in order to avoid cubic time.
+	 *
+	 * XXX: could be optimized to O(n log n) by using sort()
+	 */
+	next_distance = curr_distance;
+	for (i = 0; i < nr_node_ids; i++) {
+		for (j = 0; j < nr_node_ids; j++) {
+			int distance = node_distance(0, j);
+			if (distance > curr_distance &&
+					(distance < next_distance ||
+					 next_distance == curr_distance))
+				next_distance = distance;
+		}
+		if (next_distance != curr_distance) {
+			sched_domains_numa_distance[level++] = next_distance;
+			sched_domains_numa_levels = level;
+			curr_distance = next_distance;
+		} else break;
+	}
+	/*
+	 * 'level' contains the number of unique distances, excluding the
+	 * identity distance node_distance(i,i).
+	 *
+	 * The sched_domains_nume_distance[] array includes the actual distance
+	 * numbers.
+	 */
+
+	sched_domains_numa_masks = kzalloc(sizeof(void *) * level, GFP_KERNEL);
+	if (!sched_domains_numa_masks)
+		return;
+
+	/*
+	 * Now for each level, construct a mask per node which contains all
+	 * cpus of nodes that are that many hops away from us.
+	 */
+	for (i = 0; i < level; i++) {
+		sched_domains_numa_masks[i] =
+			kzalloc(nr_node_ids * sizeof(void *), GFP_KERNEL);
+		if (!sched_domains_numa_masks[i])
+			return;
+
+		for (j = 0; j < nr_node_ids; j++) {
+			struct cpumask *mask = kzalloc_node(cpumask_size(), GFP_KERNEL, j);
+			if (!mask)
+				return;
+
+			sched_domains_numa_masks[i][j] = mask;
+
+			for (k = 0; k < nr_node_ids; k++) {
+				if (node_distance(j, k) > sched_domains_numa_distance[i])
+					continue;
+
+				cpumask_or(mask, mask, cpumask_of_node(k));
+			}
+		}
+	}
+
+	tl = kzalloc((ARRAY_SIZE(default_topology) + level) *
+			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
+	if (!tl)
+		return;
+
+	/*
+	 * Copy the default topology bits..
+	 */
+	for (i = 0; default_topology[i].init; i++)
+		tl[i] = default_topology[i];
+
+	/*
+	 * .. and append 'j' levels of NUMA goodness.
+	 */
+	for (j = 0; j < level; i++, j++) {
+		tl[i] = (struct sched_domain_topology_level){
+			.init = sd_numa_init,
+			.mask = sd_numa_mask,
+			.flags = SDTL_OVERLAP,
+			.numa_level = j,
+		};
+	}
+
+	sched_domain_topology = tl;
+}
+#else
+static inline void sched_init_numa(void)
+{
+}
+#endif /* CONFIG_NUMA */
+
 static int __sdt_alloc(const struct cpumask *cpu_map)
 {
 	struct sched_domain_topology_level *tl;
@@ -6712,97 +6817,6 @@ match2:
 	mutex_unlock(&sched_domains_mutex);
 }
 
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-static void reinit_sched_domains(void)
-{
-	get_online_cpus();
-
-	/* Destroy domains first to force the rebuild */
-	partition_sched_domains(0, NULL, NULL);
-
-	rebuild_sched_domains();
-	put_online_cpus();
-}
-
-static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
-{
-	unsigned int level = 0;
-
-	if (sscanf(buf, "%u", &level) != 1)
-		return -EINVAL;
-
-	/*
-	 * level is always be positive so don't check for
-	 * level < POWERSAVINGS_BALANCE_NONE which is 0
-	 * What happens on 0 or 1 byte write,
-	 * need to check for count as well?
-	 */
-
-	if (level >= MAX_POWERSAVINGS_BALANCE_LEVELS)
-		return -EINVAL;
-
-	if (smt)
-		sched_smt_power_savings = level;
-	else
-		sched_mc_power_savings = level;
-
-	reinit_sched_domains();
-
-	return count;
-}
-
-#ifdef CONFIG_SCHED_MC
-static ssize_t sched_mc_power_savings_show(struct device *dev,
-					   struct device_attribute *attr,
-					   char *buf)
-{
-	return sprintf(buf, "%u\n", sched_mc_power_savings);
-}
-static ssize_t sched_mc_power_savings_store(struct device *dev,
-					    struct device_attribute *attr,
-					    const char *buf, size_t count)
-{
-	return sched_power_savings_store(buf, count, 0);
-}
-static DEVICE_ATTR(sched_mc_power_savings, 0644,
-		   sched_mc_power_savings_show,
-		   sched_mc_power_savings_store);
-#endif
-
-#ifdef CONFIG_SCHED_SMT
-static ssize_t sched_smt_power_savings_show(struct device *dev,
-					    struct device_attribute *attr,
-					    char *buf)
-{
-	return sprintf(buf, "%u\n", sched_smt_power_savings);
-}
-static ssize_t sched_smt_power_savings_store(struct device *dev,
-					    struct device_attribute *attr,
-					     const char *buf, size_t count)
-{
-	return sched_power_savings_store(buf, count, 1);
-}
-static DEVICE_ATTR(sched_smt_power_savings, 0644,
-		   sched_smt_power_savings_show,
-		   sched_smt_power_savings_store);
-#endif
-
-int __init sched_create_sysfs_power_savings_entries(struct device *dev)
-{
-	int err = 0;
-
-#ifdef CONFIG_SCHED_SMT
-	if (smt_capable())
-		err = device_create_file(dev, &dev_attr_sched_smt_power_savings);
-#endif
-#ifdef CONFIG_SCHED_MC
-	if (!err && mc_capable())
-		err = device_create_file(dev, &dev_attr_sched_mc_power_savings);
-#endif
-	return err;
-}
-#endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
-
 /*
  * Update cpusets according to cpu_active mask.  If cpusets are
  * disabled, cpuset_update_active_cpus() becomes a simple wrapper
@@ -6840,6 +6854,8 @@ void __init sched_init_smp(void)
 	alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
 	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
 
+	sched_init_numa();
+
 	get_online_cpus();
 	mutex_lock(&sched_domains_mutex);
 	init_sched_domains(cpu_active_mask);
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 09acaa1..6f79596 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -202,7 +202,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			SPLIT_NS(spread0));
 	SEQ_printf(m, "  .%-30s: %d\n", "nr_spread_over",
 			cfs_rq->nr_spread_over);
-	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
+	SEQ_printf(m, "  .%-30s: %d\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
@@ -260,8 +260,14 @@ static void print_cpu(struct seq_file *m, int cpu)
 	SEQ_printf(m, "\ncpu#%d\n", cpu);
 #endif
 
-#define P(x) \
-	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rq->x))
+#define P(x)								\
+do {									\
+	if (sizeof(rq->x) == 4)						\
+		SEQ_printf(m, "  .%-30s: %ld\n", #x, (long)(rq->x));	\
+	else								\
+		SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rq->x));\
+} while (0)
+
 #define PN(x) \
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", #x, SPLIT_NS(rq->x))
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e955364..940e6d1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2721,7 +2721,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		 * If power savings logic is enabled for a domain, see if we
 		 * are not overloaded, if so, don't balance wider.
 		 */
-		if (tmp->flags & (SD_POWERSAVINGS_BALANCE|SD_PREFER_LOCAL)) {
+		if (tmp->flags & (SD_PREFER_LOCAL)) {
 			unsigned long power = 0;
 			unsigned long nr_running = 0;
 			unsigned long capacity;
@@ -2734,9 +2734,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 
 			capacity = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
 
-			if (tmp->flags & SD_POWERSAVINGS_BALANCE)
-				nr_running /= 2;
-
 			if (nr_running < capacity)
 				want_sd = 0;
 		}
@@ -3082,7 +3079,7 @@ struct lb_env {
 	struct rq		*dst_rq;
 
 	enum cpu_idle_type	idle;
-	long			load_move;
+	long			imbalance;
 	unsigned int		flags;
 
 	unsigned int		loop;
@@ -3218,7 +3215,7 @@ static unsigned long task_h_load(struct task_struct *p);
 static const unsigned int sched_nr_migrate_break = 32;
 
 /*
- * move_tasks tries to move up to load_move weighted load from busiest to
+ * move_tasks tries to move up to imbalance weighted load from busiest to
  * this_rq, as part of a balancing operation within domain "sd".
  * Returns 1 if successful and 0 otherwise.
  *
@@ -3231,7 +3228,7 @@ static int move_tasks(struct lb_env *env)
 	unsigned long load;
 	int pulled = 0;
 
-	if (env->load_move <= 0)
+	if (env->imbalance <= 0)
 		return 0;
 
 	while (!list_empty(tasks)) {
@@ -3257,7 +3254,7 @@ static int move_tasks(struct lb_env *env)
 		if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
 			goto next;
 
-		if ((load / 2) > env->load_move)
+		if ((load / 2) > env->imbalance)
 			goto next;
 
 		if (!can_migrate_task(p, env))
@@ -3265,7 +3262,7 @@ static int move_tasks(struct lb_env *env)
 
 		move_task(p, env);
 		pulled++;
-		env->load_move -= load;
+		env->imbalance -= load;
 
 #ifdef CONFIG_PREEMPT
 		/*
@@ -3281,7 +3278,7 @@ static int move_tasks(struct lb_env *env)
 		 * We only want to steal up to the prescribed amount of
 		 * weighted load.
 		 */
-		if (env->load_move <= 0)
+		if (env->imbalance <= 0)
 			break;
 
 		continue;
@@ -3435,14 +3432,6 @@ struct sd_lb_stats {
 	unsigned int  busiest_group_weight;
 
 	int group_imb; /* Is there imbalance in this sd */
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	int power_savings_balance; /* Is powersave balance needed for this sd */
-	struct sched_group *group_min; /* Least loaded group in sd */
-	struct sched_group *group_leader; /* Group which relieves group_min */
-	unsigned long min_load_per_task; /* load_per_task in group_min */
-	unsigned long leader_nr_running; /* Nr running of group_leader */
-	unsigned long min_nr_running; /* Nr running of group_min */
-#endif
 };
 
 /*
@@ -3486,148 +3475,6 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
 	return load_idx;
 }
 
-
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-/**
- * init_sd_power_savings_stats - Initialize power savings statistics for
- * the given sched_domain, during load balancing.
- *
- * @sd: Sched domain whose power-savings statistics are to be initialized.
- * @sds: Variable containing the statistics for sd.
- * @idle: Idle status of the CPU at which we're performing load-balancing.
- */
-static inline void init_sd_power_savings_stats(struct sched_domain *sd,
-	struct sd_lb_stats *sds, enum cpu_idle_type idle)
-{
-	/*
-	 * Busy processors will not participate in power savings
-	 * balance.
-	 */
-	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
-		sds->power_savings_balance = 0;
-	else {
-		sds->power_savings_balance = 1;
-		sds->min_nr_running = ULONG_MAX;
-		sds->leader_nr_running = 0;
-	}
-}
-
-/**
- * update_sd_power_savings_stats - Update the power saving stats for a
- * sched_domain while performing load balancing.
- *
- * @group: sched_group belonging to the sched_domain under consideration.
- * @sds: Variable containing the statistics of the sched_domain
- * @local_group: Does group contain the CPU for which we're performing
- * 		load balancing ?
- * @sgs: Variable containing the statistics of the group.
- */
-static inline void update_sd_power_savings_stats(struct sched_group *group,
-	struct sd_lb_stats *sds, int local_group, struct sg_lb_stats *sgs)
-{
-
-	if (!sds->power_savings_balance)
-		return;
-
-	/*
-	 * If the local group is idle or completely loaded
-	 * no need to do power savings balance at this domain
-	 */
-	if (local_group && (sds->this_nr_running >= sgs->group_capacity ||
-				!sds->this_nr_running))
-		sds->power_savings_balance = 0;
-
-	/*
-	 * If a group is already running at full capacity or idle,
-	 * don't include that group in power savings calculations
-	 */
-	if (!sds->power_savings_balance ||
-		sgs->sum_nr_running >= sgs->group_capacity ||
-		!sgs->sum_nr_running)
-		return;
-
-	/*
-	 * Calculate the group which has the least non-idle load.
-	 * This is the group from where we need to pick up the load
-	 * for saving power
-	 */
-	if ((sgs->sum_nr_running < sds->min_nr_running) ||
-	    (sgs->sum_nr_running == sds->min_nr_running &&
-	     group_first_cpu(group) > group_first_cpu(sds->group_min))) {
-		sds->group_min = group;
-		sds->min_nr_running = sgs->sum_nr_running;
-		sds->min_load_per_task = sgs->sum_weighted_load /
-						sgs->sum_nr_running;
-	}
-
-	/*
-	 * Calculate the group which is almost near its
-	 * capacity but still has some space to pick up some load
-	 * from other group and save more power
-	 */
-	if (sgs->sum_nr_running + 1 > sgs->group_capacity)
-		return;
-
-	if (sgs->sum_nr_running > sds->leader_nr_running ||
-	    (sgs->sum_nr_running == sds->leader_nr_running &&
-	     group_first_cpu(group) < group_first_cpu(sds->group_leader))) {
-		sds->group_leader = group;
-		sds->leader_nr_running = sgs->sum_nr_running;
-	}
-}
-
-/**
- * check_power_save_busiest_group - see if there is potential for some power-savings balance
- * @sds: Variable containing the statistics of the sched_domain
- *	under consideration.
- * @this_cpu: Cpu at which we're currently performing load-balancing.
- * @imbalance: Variable to store the imbalance.
- *
- * Description:
- * Check if we have potential to perform some power-savings balance.
- * If yes, set the busiest group to be the least loaded group in the
- * sched_domain, so that it's CPUs can be put to idle.
- *
- * Returns 1 if there is potential to perform power-savings balance.
- * Else returns 0.
- */
-static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
-					int this_cpu, unsigned long *imbalance)
-{
-	if (!sds->power_savings_balance)
-		return 0;
-
-	if (sds->this != sds->group_leader ||
-			sds->group_leader == sds->group_min)
-		return 0;
-
-	*imbalance = sds->min_load_per_task;
-	sds->busiest = sds->group_min;
-
-	return 1;
-
-}
-#else /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
-static inline void init_sd_power_savings_stats(struct sched_domain *sd,
-	struct sd_lb_stats *sds, enum cpu_idle_type idle)
-{
-	return;
-}
-
-static inline void update_sd_power_savings_stats(struct sched_group *group,
-	struct sd_lb_stats *sds, int local_group, struct sg_lb_stats *sgs)
-{
-	return;
-}
-
-static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
-					int this_cpu, unsigned long *imbalance)
-{
-	return 0;
-}
-#endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
-
-
 unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
 {
 	return SCHED_POWER_SCALE;
@@ -3765,24 +3612,22 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @sd: The sched_domain whose statistics are to be updated.
  * @group: sched_group whose statistics are to be updated.
- * @this_cpu: Cpu for which load balance is currently performed.
- * @idle: Idle status of this_cpu
  * @load_idx: Load index of sched_domain of this_cpu for load calc.
  * @local_group: Does group contain this_cpu.
  * @cpus: Set of cpus considered for load balancing.
  * @balance: Should we balance.
  * @sgs: variable to hold the statistics for this group.
  */
-static inline void update_sg_lb_stats(struct sched_domain *sd,
-			struct sched_group *group, int this_cpu,
-			enum cpu_idle_type idle, int load_idx,
+static inline void update_sg_lb_stats(struct lb_env *env,
+			struct sched_group *group, int load_idx,
 			int local_group, const struct cpumask *cpus,
 			int *balance, struct sg_lb_stats *sgs)
 {
-	unsigned long load, max_cpu_load, min_cpu_load, max_nr_running;
-	int i;
+	unsigned long nr_running, max_nr_running, min_nr_running;
+	unsigned long load, max_cpu_load, min_cpu_load;
 	unsigned int balance_cpu = -1, first_idle_cpu = 0;
 	unsigned long avg_load_per_task = 0;
+	int i;
 
 	if (local_group)
 		balance_cpu = group_first_cpu(group);
@@ -3791,10 +3636,13 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	max_cpu_load = 0;
 	min_cpu_load = ~0UL;
 	max_nr_running = 0;
+	min_nr_running = ~0UL;
 
 	for_each_cpu_and(i, sched_group_cpus(group), cpus) {
 		struct rq *rq = cpu_rq(i);
 
+		nr_running = rq->nr_running;
+
 		/* Bias balancing toward cpus of our domain */
 		if (local_group) {
 			if (idle_cpu(i) && !first_idle_cpu) {
@@ -3805,16 +3653,19 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 			load = target_load(i, load_idx);
 		} else {
 			load = source_load(i, load_idx);
-			if (load > max_cpu_load) {
+			if (load > max_cpu_load)
 				max_cpu_load = load;
-				max_nr_running = rq->nr_running;
-			}
 			if (min_cpu_load > load)
 				min_cpu_load = load;
+
+			if (nr_running > max_nr_running)
+				max_nr_running = nr_running;
+			if (min_nr_running > nr_running)
+				min_nr_running = nr_running;
 		}
 
 		sgs->group_load += load;
-		sgs->sum_nr_running += rq->nr_running;
+		sgs->sum_nr_running += nr_running;
 		sgs->sum_weighted_load += weighted_cpuload(i);
 		if (idle_cpu(i))
 			sgs->idle_cpus++;
@@ -3827,14 +3678,14 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	 * to do the newly idle load balance.
 	 */
 	if (local_group) {
-		if (idle != CPU_NEWLY_IDLE) {
-			if (balance_cpu != this_cpu) {
+		if (env->idle != CPU_NEWLY_IDLE) {
+			if (balance_cpu != env->dst_cpu) {
 				*balance = 0;
 				return;
 			}
-			update_group_power(sd, this_cpu);
+			update_group_power(env->sd, env->dst_cpu);
 		} else if (time_after_eq(jiffies, group->sgp->next_update))
-			update_group_power(sd, this_cpu);
+			update_group_power(env->sd, env->dst_cpu);
 	}
 
 	/* Adjust by relative CPU power of the group */
@@ -3852,13 +3703,14 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	if (sgs->sum_nr_running)
 		avg_load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
-	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task && max_nr_running > 1)
+	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task &&
+	    (max_nr_running - min_nr_running) > 1)
 		sgs->group_imb = 1;
 
 	sgs->group_capacity = DIV_ROUND_CLOSEST(group->sgp->power,
 						SCHED_POWER_SCALE);
 	if (!sgs->group_capacity)
-		sgs->group_capacity = fix_small_capacity(sd, group);
+		sgs->group_capacity = fix_small_capacity(env->sd, group);
 	sgs->group_weight = group->group_weight;
 
 	if (sgs->group_capacity > sgs->sum_nr_running)
@@ -3876,11 +3728,10 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
  * Determine if @sg is a busier group than the previously selected
  * busiest group.
  */
-static bool update_sd_pick_busiest(struct sched_domain *sd,
+static bool update_sd_pick_busiest(struct lb_env *env,
 				   struct sd_lb_stats *sds,
 				   struct sched_group *sg,
-				   struct sg_lb_stats *sgs,
-				   int this_cpu)
+				   struct sg_lb_stats *sgs)
 {
 	if (sgs->avg_load <= sds->max_load)
 		return false;
@@ -3896,8 +3747,8 @@ static bool update_sd_pick_busiest(struct sched_domain *sd,
 	 * numbered CPUs in the group, therefore mark all groups
 	 * higher than ourself as busy.
 	 */
-	if ((sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running &&
-	    this_cpu < group_first_cpu(sg)) {
+	if ((env->sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running &&
+	    env->dst_cpu < group_first_cpu(sg)) {
 		if (!sds->busiest)
 			return true;
 
@@ -3917,28 +3768,27 @@ static bool update_sd_pick_busiest(struct sched_domain *sd,
  * @balance: Should we balance.
  * @sds: variable to hold the statistics for this sched_domain.
  */
-static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
-			enum cpu_idle_type idle, const struct cpumask *cpus,
-			int *balance, struct sd_lb_stats *sds)
+static inline void update_sd_lb_stats(struct lb_env *env,
+				      const struct cpumask *cpus,
+				      int *balance, struct sd_lb_stats *sds)
 {
-	struct sched_domain *child = sd->child;
-	struct sched_group *sg = sd->groups;
+	struct sched_domain *child = env->sd->child;
+	struct sched_group *sg = env->sd->groups;
 	struct sg_lb_stats sgs;
 	int load_idx, prefer_sibling = 0;
 
 	if (child && child->flags & SD_PREFER_SIBLING)
 		prefer_sibling = 1;
 
-	init_sd_power_savings_stats(sd, sds, idle);
-	load_idx = get_sd_load_idx(sd, idle);
+	load_idx = get_sd_load_idx(env->sd, env->idle);
 
 	do {
 		int local_group;
 
-		local_group = cpumask_test_cpu(this_cpu, sched_group_cpus(sg));
+		local_group = cpumask_test_cpu(env->dst_cpu, sched_group_cpus(sg));
 		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(sd, sg, this_cpu, idle, load_idx,
-				local_group, cpus, balance, &sgs);
+		update_sg_lb_stats(env, sg, load_idx, local_group,
+				   cpus, balance, &sgs);
 
 		if (local_group && !(*balance))
 			return;
@@ -3966,7 +3816,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			sds->this_load_per_task = sgs.sum_weighted_load;
 			sds->this_has_capacity = sgs.group_has_capacity;
 			sds->this_idle_cpus = sgs.idle_cpus;
-		} else if (update_sd_pick_busiest(sd, sds, sg, &sgs, this_cpu)) {
+		} else if (update_sd_pick_busiest(env, sds, sg, &sgs)) {
 			sds->max_load = sgs.avg_load;
 			sds->busiest = sg;
 			sds->busiest_nr_running = sgs.sum_nr_running;
@@ -3978,9 +3828,8 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			sds->group_imb = sgs.group_imb;
 		}
 
-		update_sd_power_savings_stats(sg, sds, local_group, &sgs);
 		sg = sg->next;
-	} while (sg != sd->groups);
+	} while (sg != env->sd->groups);
 }
 
 /**
@@ -4008,24 +3857,23 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
  * @this_cpu: The cpu at whose sched_domain we're performing load-balance.
  * @imbalance: returns amount of imbalanced due to packing.
  */
-static int check_asym_packing(struct sched_domain *sd,
-			      struct sd_lb_stats *sds,
-			      int this_cpu, unsigned long *imbalance)
+static int check_asym_packing(struct lb_env *env, struct sd_lb_stats *sds)
 {
 	int busiest_cpu;
 
-	if (!(sd->flags & SD_ASYM_PACKING))
+	if (!(env->sd->flags & SD_ASYM_PACKING))
 		return 0;
 
 	if (!sds->busiest)
 		return 0;
 
 	busiest_cpu = group_first_cpu(sds->busiest);
-	if (this_cpu > busiest_cpu)
+	if (env->dst_cpu > busiest_cpu)
 		return 0;
 
-	*imbalance = DIV_ROUND_CLOSEST(sds->max_load * sds->busiest->sgp->power,
-				       SCHED_POWER_SCALE);
+	env->imbalance = DIV_ROUND_CLOSEST(
+		sds->max_load * sds->busiest->sgp->power, SCHED_POWER_SCALE);
+
 	return 1;
 }
 
@@ -4037,8 +3885,8 @@ static int check_asym_packing(struct sched_domain *sd,
  * @this_cpu: The cpu at whose sched_domain we're performing load-balance.
  * @imbalance: Variable to store the imbalance.
  */
-static inline void fix_small_imbalance(struct sd_lb_stats *sds,
-				int this_cpu, unsigned long *imbalance)
+static inline
+void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 {
 	unsigned long tmp, pwr_now = 0, pwr_move = 0;
 	unsigned int imbn = 2;
@@ -4049,9 +3897,10 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 		if (sds->busiest_load_per_task >
 				sds->this_load_per_task)
 			imbn = 1;
-	} else
+	} else {
 		sds->this_load_per_task =
-			cpu_avg_load_per_task(this_cpu);
+			cpu_avg_load_per_task(env->dst_cpu);
+	}
 
 	scaled_busy_load_per_task = sds->busiest_load_per_task
 					 * SCHED_POWER_SCALE;
@@ -4059,7 +3908,7 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 
 	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
 			(scaled_busy_load_per_task * imbn)) {
-		*imbalance = sds->busiest_load_per_task;
+		env->imbalance = sds->busiest_load_per_task;
 		return;
 	}
 
@@ -4096,18 +3945,16 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 
 	/* Move if we gain throughput */
 	if (pwr_move > pwr_now)
-		*imbalance = sds->busiest_load_per_task;
+		env->imbalance = sds->busiest_load_per_task;
 }
 
 /**
  * calculate_imbalance - Calculate the amount of imbalance present within the
  *			 groups of a given sched_domain during load balance.
+ * @env: load balance environment
  * @sds: statistics of the sched_domain whose imbalance is to be calculated.
- * @this_cpu: Cpu for which currently load balance is being performed.
- * @imbalance: The variable to store the imbalance.
  */
-static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
-		unsigned long *imbalance)
+static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 {
 	unsigned long max_pull, load_above_capacity = ~0UL;
 
@@ -4123,8 +3970,8 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 	 * its cpu_power, while calculating max_load..)
 	 */
 	if (sds->max_load < sds->avg_load) {
-		*imbalance = 0;
-		return fix_small_imbalance(sds, this_cpu, imbalance);
+		env->imbalance = 0;
+		return fix_small_imbalance(env, sds);
 	}
 
 	if (!sds->group_imb) {
@@ -4152,7 +3999,7 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
 
 	/* How much load to actually move to equalise the imbalance */
-	*imbalance = min(max_pull * sds->busiest->sgp->power,
+	env->imbalance = min(max_pull * sds->busiest->sgp->power,
 		(sds->avg_load - sds->this_load) * sds->this->sgp->power)
 			/ SCHED_POWER_SCALE;
 
@@ -4162,8 +4009,8 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 	 * a think about bumping its value to force at least one task to be
 	 * moved
 	 */
-	if (*imbalance < sds->busiest_load_per_task)
-		return fix_small_imbalance(sds, this_cpu, imbalance);
+	if (env->imbalance < sds->busiest_load_per_task)
+		return fix_small_imbalance(env, sds);
 
 }
 
@@ -4194,9 +4041,7 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
  *		   put to idle by rebalancing its tasks onto our group.
  */
 static struct sched_group *
-find_busiest_group(struct sched_domain *sd, int this_cpu,
-		   unsigned long *imbalance, enum cpu_idle_type idle,
-		   const struct cpumask *cpus, int *balance)
+find_busiest_group(struct lb_env *env, const struct cpumask *cpus, int *balance)
 {
 	struct sd_lb_stats sds;
 
@@ -4206,7 +4051,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	 * Compute the various statistics relavent for load balancing at
 	 * this level.
 	 */
-	update_sd_lb_stats(sd, this_cpu, idle, cpus, balance, &sds);
+	update_sd_lb_stats(env, cpus, balance, &sds);
 
 	/*
 	 * this_cpu is not the appropriate cpu to perform load balancing at
@@ -4215,8 +4060,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (!(*balance))
 		goto ret;
 
-	if ((idle == CPU_IDLE || idle == CPU_NEWLY_IDLE) &&
-	    check_asym_packing(sd, &sds, this_cpu, imbalance))
+	if ((env->idle == CPU_IDLE || env->idle == CPU_NEWLY_IDLE) &&
+	    check_asym_packing(env, &sds))
 		return sds.busiest;
 
 	/* There is no busy sibling group to pull tasks from */
@@ -4234,7 +4079,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		goto force_balance;
 
 	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
-	if (idle == CPU_NEWLY_IDLE && sds.this_has_capacity &&
+	if (env->idle == CPU_NEWLY_IDLE && sds.this_has_capacity &&
 			!sds.busiest_has_capacity)
 		goto force_balance;
 
@@ -4252,7 +4097,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (sds.this_load >= sds.avg_load)
 		goto out_balanced;
 
-	if (idle == CPU_IDLE) {
+	if (env->idle == CPU_IDLE) {
 		/*
 		 * This cpu is idle. If the busiest group load doesn't
 		 * have more tasks than the number of available cpu's and
@@ -4267,34 +4112,27 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 * In the CPU_NEWLY_IDLE, CPU_NOT_IDLE cases, use
 		 * imbalance_pct to be conservative.
 		 */
-		if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
+		if (100 * sds.max_load <= env->sd->imbalance_pct * sds.this_load)
 			goto out_balanced;
 	}
 
 force_balance:
 	/* Looks like there is an imbalance. Compute it */
-	calculate_imbalance(&sds, this_cpu, imbalance);
+	calculate_imbalance(env, &sds);
 	return sds.busiest;
 
 out_balanced:
-	/*
-	 * There is no obvious imbalance. But check if we can do some balancing
-	 * to save power.
-	 */
-	if (check_power_save_busiest_group(&sds, this_cpu, imbalance))
-		return sds.busiest;
 ret:
-	*imbalance = 0;
+	env->imbalance = 0;
 	return NULL;
 }
 
 /*
  * find_busiest_queue - find the busiest runqueue among the cpus in group.
  */
-static struct rq *
-find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
-		   enum cpu_idle_type idle, unsigned long imbalance,
-		   const struct cpumask *cpus)
+static struct rq *find_busiest_queue(struct lb_env *env,
+				     struct sched_group *group,
+				     const struct cpumask *cpus)
 {
 	struct rq *busiest = NULL, *rq;
 	unsigned long max_load = 0;
@@ -4307,7 +4145,7 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 		unsigned long wl;
 
 		if (!capacity)
-			capacity = fix_small_capacity(sd, group);
+			capacity = fix_small_capacity(env->sd, group);
 
 		if (!cpumask_test_cpu(i, cpus))
 			continue;
@@ -4319,7 +4157,7 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 		 * When comparing with imbalance, use weighted_cpuload()
 		 * which is not scaled with the cpu power.
 		 */
-		if (capacity && rq->nr_running == 1 && wl > imbalance)
+		if (capacity && rq->nr_running == 1 && wl > env->imbalance)
 			continue;
 
 		/*
@@ -4348,40 +4186,19 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 /* Working cpumask for load_balance and load_balance_newidle. */
 DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
 
-static int need_active_balance(struct sched_domain *sd, int idle,
-			       int busiest_cpu, int this_cpu)
+static int need_active_balance(struct lb_env *env)
 {
-	if (idle == CPU_NEWLY_IDLE) {
+	struct sched_domain *sd = env->sd;
+
+	if (env->idle == CPU_NEWLY_IDLE) {
 
 		/*
 		 * ASYM_PACKING needs to force migrate tasks from busy but
 		 * higher numbered CPUs in order to pack all tasks in the
 		 * lowest numbered CPUs.
 		 */
-		if ((sd->flags & SD_ASYM_PACKING) && busiest_cpu > this_cpu)
+		if ((sd->flags & SD_ASYM_PACKING) && env->src_cpu > env->dst_cpu)
 			return 1;
-
-		/*
-		 * The only task running in a non-idle cpu can be moved to this
-		 * cpu in an attempt to completely freeup the other CPU
-		 * package.
-		 *
-		 * The package power saving logic comes from
-		 * find_busiest_group(). If there are no imbalance, then
-		 * f_b_g() will return NULL. However when sched_mc={1,2} then
-		 * f_b_g() will select a group from which a running task may be
-		 * pulled to this cpu in order to make the other package idle.
-		 * If there is no opportunity to make a package idle and if
-		 * there are no imbalance, then f_b_g() will return NULL and no
-		 * action will be taken in load_balance_newidle().
-		 *
-		 * Under normal task pull operation due to imbalance, there
-		 * will be more than one task in the source run queue and
-		 * move_tasks() will succeed.  ld_moved will be true and this
-		 * active balance code will not be triggered.
-		 */
-		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
-			return 0;
 	}
 
 	return unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2);
@@ -4399,7 +4216,6 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 {
 	int ld_moved, active_balance = 0;
 	struct sched_group *group;
-	unsigned long imbalance;
 	struct rq *busiest;
 	unsigned long flags;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
@@ -4417,8 +4233,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	schedstat_inc(sd, lb_count[idle]);
 
 redo:
-	group = find_busiest_group(sd, this_cpu, &imbalance, idle,
-				   cpus, balance);
+	group = find_busiest_group(&env, cpus, balance);
 
 	if (*balance == 0)
 		goto out_balanced;
@@ -4428,7 +4243,7 @@ redo:
 		goto out_balanced;
 	}
 
-	busiest = find_busiest_queue(sd, group, idle, imbalance, cpus);
+	busiest = find_busiest_queue(&env, group, cpus);
 	if (!busiest) {
 		schedstat_inc(sd, lb_nobusyq[idle]);
 		goto out_balanced;
@@ -4436,7 +4251,7 @@ redo:
 
 	BUG_ON(busiest == this_rq);
 
-	schedstat_add(sd, lb_imbalance[idle], imbalance);
+	schedstat_add(sd, lb_imbalance[idle], env.imbalance);
 
 	ld_moved = 0;
 	if (busiest->nr_running > 1) {
@@ -4447,10 +4262,9 @@ redo:
 		 * correctly treated as an imbalance.
 		 */
 		env.flags |= LBF_ALL_PINNED;
-		env.load_move	= imbalance;
-		env.src_cpu	= busiest->cpu;
-		env.src_rq	= busiest;
-		env.loop_max	= min_t(unsigned long, sysctl_sched_nr_migrate, busiest->nr_running);
+		env.src_cpu   = busiest->cpu;
+		env.src_rq    = busiest;
+		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
 
 more_balance:
 		local_irq_save(flags);
@@ -4492,7 +4306,7 @@ more_balance:
 		if (idle != CPU_NEWLY_IDLE)
 			sd->nr_balance_failed++;
 
-		if (need_active_balance(sd, idle, cpu_of(busiest), this_cpu)) {
+		if (need_active_balance(&env)) {
 			raw_spin_lock_irqsave(&busiest->lock, flags);
 
 			/* don't kick the active_load_balance_cpu_stop,
@@ -4519,10 +4333,11 @@ more_balance:
 			}
 			raw_spin_unlock_irqrestore(&busiest->lock, flags);
 
-			if (active_balance)
+			if (active_balance) {
 				stop_one_cpu_nowait(cpu_of(busiest),
 					active_load_balance_cpu_stop, busiest,
 					&busiest->active_balance_work);
+			}
 
 			/*
 			 * We've kicked active balancing, reset the failure
@@ -4703,104 +4518,15 @@ static struct {
 	unsigned long next_balance;     /* in jiffy units */
 } nohz ____cacheline_aligned;
 
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-/**
- * lowest_flag_domain - Return lowest sched_domain containing flag.
- * @cpu:	The cpu whose lowest level of sched domain is to
- *		be returned.
- * @flag:	The flag to check for the lowest sched_domain
- *		for the given cpu.
- *
- * Returns the lowest sched_domain of a cpu which contains the given flag.
- */
-static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
-{
-	struct sched_domain *sd;
-
-	for_each_domain(cpu, sd)
-		if (sd->flags & flag)
-			break;
-
-	return sd;
-}
-
-/**
- * for_each_flag_domain - Iterates over sched_domains containing the flag.
- * @cpu:	The cpu whose domains we're iterating over.
- * @sd:		variable holding the value of the power_savings_sd
- *		for cpu.
- * @flag:	The flag to filter the sched_domains to be iterated.
- *
- * Iterates over all the scheduler domains for a given cpu that has the 'flag'
- * set, starting from the lowest sched_domain to the highest.
- */
-#define for_each_flag_domain(cpu, sd, flag) \
-	for (sd = lowest_flag_domain(cpu, flag); \
-		(sd && (sd->flags & flag)); sd = sd->parent)
-
-/**
- * find_new_ilb - Finds the optimum idle load balancer for nomination.
- * @cpu:	The cpu which is nominating a new idle_load_balancer.
- *
- * Returns:	Returns the id of the idle load balancer if it exists,
- *		Else, returns >= nr_cpu_ids.
- *
- * This algorithm picks the idle load balancer such that it belongs to a
- * semi-idle powersavings sched_domain. The idea is to try and avoid
- * completely idle packages/cores just for the purpose of idle load balancing
- * when there are other idle cpu's which are better suited for that job.
- */
-static int find_new_ilb(int cpu)
+static inline int find_new_ilb(int call_cpu)
 {
 	int ilb = cpumask_first(nohz.idle_cpus_mask);
-	struct sched_group *ilbg;
-	struct sched_domain *sd;
-
-	/*
-	 * Have idle load balancer selection from semi-idle packages only
-	 * when power-aware load balancing is enabled
-	 */
-	if (!(sched_smt_power_savings || sched_mc_power_savings))
-		goto out_done;
-
-	/*
-	 * Optimize for the case when we have no idle CPUs or only one
-	 * idle CPU. Don't walk the sched_domain hierarchy in such cases
-	 */
-	if (cpumask_weight(nohz.idle_cpus_mask) < 2)
-		goto out_done;
-
-	rcu_read_lock();
-	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
-		ilbg = sd->groups;
-
-		do {
-			if (ilbg->group_weight !=
-				atomic_read(&ilbg->sgp->nr_busy_cpus)) {
-				ilb = cpumask_first_and(nohz.idle_cpus_mask,
-							sched_group_cpus(ilbg));
-				goto unlock;
-			}
-
-			ilbg = ilbg->next;
-
-		} while (ilbg != sd->groups);
-	}
-unlock:
-	rcu_read_unlock();
 
-out_done:
 	if (ilb < nr_cpu_ids && idle_cpu(ilb))
 		return ilb;
 
 	return nr_cpu_ids;
 }
-#else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
-static inline int find_new_ilb(int call_cpu)
-{
-	return nr_cpu_ids;
-}
-#endif
 
 /*
  * Kick a CPU to do the nohz balancing, if it is time for it. We pick the
@@ -5023,7 +4749,7 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 
 		raw_spin_lock_irq(&this_rq->lock);
 		update_rq_clock(this_rq);
-		update_cpu_load(this_rq);
+		update_idle_cpu_load(this_rq);
 		raw_spin_unlock_irq(&this_rq->lock);
 
 		rebalance_domains(balance_cpu, CPU_IDLE);
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 91b4c95..b44d604 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -4,7 +4,7 @@
  * idle-task scheduling class.
  *
  * (NOTE: these are not related to SCHED_IDLE tasks which are
- *  handled in sched_fair.c)
+ *  handled in sched/fair.c)
  */
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 44af55e..c5565c3 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1803,44 +1803,40 @@ static void task_woken_rt(struct rq *rq, struct task_struct *p)
 static void set_cpus_allowed_rt(struct task_struct *p,
 				const struct cpumask *new_mask)
 {
-	int weight = cpumask_weight(new_mask);
+	struct rq *rq;
+	int weight;
 
 	BUG_ON(!rt_task(p));
 
-	/*
-	 * Update the migration status of the RQ if we have an RT task
-	 * which is running AND changing its weight value.
-	 */
-	if (p->on_rq && (weight != p->rt.nr_cpus_allowed)) {
-		struct rq *rq = task_rq(p);
-
-		if (!task_current(rq, p)) {
-			/*
-			 * Make sure we dequeue this task from the pushable list
-			 * before going further.  It will either remain off of
-			 * the list because we are no longer pushable, or it
-			 * will be requeued.
-			 */
-			if (p->rt.nr_cpus_allowed > 1)
-				dequeue_pushable_task(rq, p);
+	if (!p->on_rq)
+		return;
 
-			/*
-			 * Requeue if our weight is changing and still > 1
-			 */
-			if (weight > 1)
-				enqueue_pushable_task(rq, p);
+	weight = cpumask_weight(new_mask);
 
-		}
+	/*
+	 * Only update if the process changes its state from whether it
+	 * can migrate or not.
+	 */
+	if ((p->rt.nr_cpus_allowed > 1) == (weight > 1))
+		return;
 
-		if ((p->rt.nr_cpus_allowed <= 1) && (weight > 1)) {
-			rq->rt.rt_nr_migratory++;
-		} else if ((p->rt.nr_cpus_allowed > 1) && (weight <= 1)) {
-			BUG_ON(!rq->rt.rt_nr_migratory);
-			rq->rt.rt_nr_migratory--;
-		}
+	rq = task_rq(p);
 
-		update_rt_migration(&rq->rt);
+	/*
+	 * The process used to be able to migrate OR it can now migrate
+	 */
+	if (weight <= 1) {
+		if (!task_current(rq, p))
+			dequeue_pushable_task(rq, p);
+		BUG_ON(!rq->rt.rt_nr_migratory);
+		rq->rt.rt_nr_migratory--;
+	} else {
+		if (!task_current(rq, p))
+			enqueue_pushable_task(rq, p);
+		rq->rt.rt_nr_migratory++;
 	}
+
+	update_rt_migration(&rq->rt);
 }
 
 /* Assumes rq->lock is held */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fb3acba..ba9dccf 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -201,7 +201,7 @@ struct cfs_bandwidth { };
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
 	struct load_weight load;
-	unsigned long nr_running, h_nr_running;
+	unsigned int nr_running, h_nr_running;
 
 	u64 exec_clock;
 	u64 min_vruntime;
@@ -279,7 +279,7 @@ static inline int rt_bandwidth_enabled(void)
 /* Real-Time classes' related field in a runqueue: */
 struct rt_rq {
 	struct rt_prio_array active;
-	unsigned long rt_nr_running;
+	unsigned int rt_nr_running;
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	struct {
 		int curr; /* highest queued rt task prio */
@@ -353,7 +353,7 @@ struct rq {
 	 * nr_running and cpu_load should be in the same cacheline because
 	 * remote CPUs use both these fields when doing load calculation.
 	 */
-	unsigned long nr_running;
+	unsigned int nr_running;
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
 	unsigned long last_load_update_tick;
@@ -876,7 +876,7 @@ extern void resched_cpu(int cpu);
 extern struct rt_bandwidth def_rt_bandwidth;
 extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime);
 
-extern void update_cpu_load(struct rq *this_rq);
+extern void update_idle_cpu_load(struct rq *this_rq);
 
 #ifdef CONFIG_CGROUP_CPUACCT
 #include <linux/cgroup.h>
diff --git a/tools/power/cpupower/man/cpupower-set.1 b/tools/power/cpupower/man/cpupower-set.1
index c4954a9..9dbd536 100644
--- a/tools/power/cpupower/man/cpupower-set.1
+++ b/tools/power/cpupower/man/cpupower-set.1
@@ -85,15 +85,6 @@ Possible values are:
 savings
 .RE
 
-sched_mc_power_savings is dependent upon SCHED_MC, which is
-itself architecture dependent.
-
-sched_smt_power_savings is dependent upon SCHED_SMT, which
-is itself architecture dependent.
-
-The two files are independent of each other. It is possible
-that one file may be present without the other.
-
 .SH "SEE ALSO"
 cpupower-info(1), cpupower-monitor(1), powertop(1)
 .PP
diff --git a/tools/power/cpupower/utils/helpers/sysfs.c b/tools/power/cpupower/utils/helpers/sysfs.c
index c634302..96e28c1 100644
--- a/tools/power/cpupower/utils/helpers/sysfs.c
+++ b/tools/power/cpupower/utils/helpers/sysfs.c
@@ -362,22 +362,7 @@ char *sysfs_get_cpuidle_driver(void)
  */
 int sysfs_get_sched(const char *smt_mc)
 {
-	unsigned long value;
-	char linebuf[MAX_LINE_LEN];
-	char *endp;
-	char path[SYSFS_PATH_MAX];
-
-	if (strcmp("mc", smt_mc) && strcmp("smt", smt_mc))
-		return -EINVAL;
-
-	snprintf(path, sizeof(path),
-		PATH_TO_CPU "sched_%s_power_savings", smt_mc);
-	if (sysfs_read_file(path, linebuf, MAX_LINE_LEN) == 0)
-		return -1;
-	value = strtoul(linebuf, &endp, 0);
-	if (endp == linebuf || errno == ERANGE)
-		return -1;
-	return value;
+	return -ENODEV;
 }
 
 /*
@@ -388,21 +373,5 @@ int sysfs_get_sched(const char *smt_mc)
  */
 int sysfs_set_sched(const char *smt_mc, int val)
 {
-	char linebuf[MAX_LINE_LEN];
-	char path[SYSFS_PATH_MAX];
-	struct stat statbuf;
-
-	if (strcmp("mc", smt_mc) && strcmp("smt", smt_mc))
-		return -EINVAL;
-
-	snprintf(path, sizeof(path),
-		PATH_TO_CPU "sched_%s_power_savings", smt_mc);
-	sprintf(linebuf, "%d", val);
-
-	if (stat(path, &statbuf) != 0)
-		return -ENODEV;
-
-	if (sysfs_write_file(path, linebuf, MAX_LINE_LEN) == 0)
-		return -1;
-	return 0;
+	return -ENODEV;
 }
