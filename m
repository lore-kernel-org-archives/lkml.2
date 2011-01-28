Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab1A1OnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:43:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:53424 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518Ab1A1OnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:43:20 -0500
Date: Fri, 28 Jan 2011 14:42:24 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        penberg@kernel.org, shaohui.zheng@intel.com, tj@kernel.org,
        tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        penberg@kernel.org, shaohui.zheng@intel.com, tj@kernel.org,
        tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
In-Reply-To: <1295789862-25482-16-git-send-email-tj@kernel.org>
References: <1295789862-25482-16-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86: Unify node_to_cpumask_map handling between 32 and 64bit
Message-ID: <tip-de2d9445f1627830ed2ebd00ee9d851986c940b5@git.kernel.org>
Git-Commit-ID: de2d9445f1627830ed2ebd00ee9d851986c940b5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 14:42:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de2d9445f1627830ed2ebd00ee9d851986c940b5
Gitweb:     http://git.kernel.org/tip/de2d9445f1627830ed2ebd00ee9d851986c940b5
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Sun, 23 Jan 2011 14:37:41 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Jan 2011 14:54:10 +0100

x86: Unify node_to_cpumask_map handling between 32 and 64bit

x86_32 has been managing node_to_cpumask_map explicitly from
map_cpu_to_node() and friends in a rather ugly way.  With
previous changes, it's now possible to share the code with
64bit.

* When CONFIG_NUMA_EMU is disabled, numa_add/remove_cpu() are
  implemented in numa.c and shared by 32 and 64bit.  CONFIG_NUMA_EMU
  versions still live in numa_64.c.

  NUMA_EMU's dependency on 64bit is planned to be removed and the
  above should go away together.

* identify_cpu() now calls numa_add_cpu() for 32bit too.  This
  makes the explicit mask management from map_cpu_to_node() unnecessary.

* The whole x86_32 specific map_cpu_to_node() chunk is no longer
  necessary.  Dropped.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: eric.dumazet@gmail.com
Cc: yinghai@kernel.org
Cc: brgerst@gmail.com
Cc: gorcunov@gmail.com
Cc: shaohui.zheng@intel.com
Cc: rientjes@google.com
LKML-Reference: <1295789862-25482-16-git-send-email-tj@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
---
 arch/x86/include/asm/numa.h    |    9 +++++
 arch/x86/include/asm/numa_32.h |    1 -
 arch/x86/include/asm/numa_64.h |    4 --
 arch/x86/kernel/cpu/common.c   |    2 +-
 arch/x86/kernel/smpboot.c      |   47 -------------------------
 arch/x86/mm/numa.c             |   64 +++++++++++++++++++++++++++++++++-
 arch/x86/mm/numa_64.c          |   75 ++++++++--------------------------------
 7 files changed, 87 insertions(+), 115 deletions(-)

diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index 2b21fff..d3964b2 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_NUMA_H
 #define _ASM_X86_NUMA_H
 
+#include <asm/topology.h>
 #include <asm/apicdef.h>
 
 #ifdef CONFIG_NUMA
@@ -33,9 +34,17 @@ static inline void set_apicid_to_node(int apicid, s16 node)
 #ifdef CONFIG_NUMA
 extern void __cpuinit numa_set_node(int cpu, int node);
 extern void __cpuinit numa_clear_node(int cpu);
+extern void __cpuinit numa_add_cpu(int cpu);
+extern void __cpuinit numa_remove_cpu(int cpu);
 #else	/* CONFIG_NUMA */
 static inline void numa_set_node(int cpu, int node)	{ }
 static inline void numa_clear_node(int cpu)		{ }
+static inline void numa_add_cpu(int cpu)		{ }
+static inline void numa_remove_cpu(int cpu)		{ }
 #endif	/* CONFIG_NUMA */
 
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable);
+#endif
+
 #endif	/* _ASM_X86_NUMA_H */
diff --git a/arch/x86/include/asm/numa_32.h b/arch/x86/include/asm/numa_32.h
index cdf8043..bc66031 100644
--- a/arch/x86/include/asm/numa_32.h
+++ b/arch/x86/include/asm/numa_32.h
@@ -4,7 +4,6 @@
 extern int numa_off;
 
 extern int pxm_to_nid(int pxm);
-extern void numa_remove_cpu(int cpu);
 
 #ifdef CONFIG_NUMA
 extern int __cpuinit numa_cpu_node(int apicid);
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 6ead9f3..123f185 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -30,8 +30,6 @@ extern void setup_node_bootmem(int nodeid, unsigned long start,
 
 extern void __init init_cpu_to_node(void);
 extern int __cpuinit numa_cpu_node(int cpu);
-extern void __cpuinit numa_add_cpu(int cpu);
-extern void __cpuinit numa_remove_cpu(int cpu);
 
 #ifdef CONFIG_NUMA_EMU
 #define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
@@ -41,8 +39,6 @@ void numa_emu_cmdline(char *);
 #else
 static inline void init_cpu_to_node(void)		{ }
 static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
-static inline void numa_add_cpu(int cpu, int node)	{ }
-static inline void numa_remove_cpu(int cpu)		{ }
 #endif
 
 #endif /* _ASM_X86_NUMA_64_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 1d59834..a2559c3 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -869,7 +869,7 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 
 	select_idle_routine(c);
 
-#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+#ifdef CONFIG_NUMA
 	numa_add_cpu(smp_processor_id());
 #endif
 }
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2c20382..522b217 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -132,49 +132,6 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 atomic_t init_deasserted;
 
-#if defined(CONFIG_NUMA) && defined(CONFIG_X86_32)
-/* set up a mapping between cpu and node. */
-static void map_cpu_to_node(int cpu, int node)
-{
-	printk(KERN_INFO "Mapping cpu %d to node %d\n", cpu, node);
-	cpumask_set_cpu(cpu, node_to_cpumask_map[node]);
-}
-
-/* undo a mapping between cpu and node. */
-static void unmap_cpu_to_node(int cpu)
-{
-	int node;
-
-	printk(KERN_INFO "Unmapping cpu %d from all nodes\n", cpu);
-	for (node = 0; node < MAX_NUMNODES; node++)
-		cpumask_clear_cpu(cpu, node_to_cpumask_map[node]);
-}
-#else /* !(CONFIG_NUMA && CONFIG_X86_32) */
-#define map_cpu_to_node(cpu, node)	({})
-#define unmap_cpu_to_node(cpu)	({})
-#endif
-
-#ifdef CONFIG_X86_32
-static void map_cpu_to_logical_apicid(void)
-{
-	int cpu = smp_processor_id();
-	int node;
-
-	node = numa_cpu_node(cpu);
-	if (!node_online(node))
-		node = first_online_node;
-
-	map_cpu_to_node(cpu, node);
-}
-
-void numa_remove_cpu(int cpu)
-{
-	unmap_cpu_to_node(cpu);
-}
-#else
-#define map_cpu_to_logical_apicid()  do {} while (0)
-#endif
-
 /*
  * Report back to the Boot Processor.
  * Running on AP.
@@ -242,7 +199,6 @@ static void __cpuinit smp_callin(void)
 		apic->smp_callin_clear_local_apic();
 	setup_local_APIC();
 	end_local_APIC_setup();
-	map_cpu_to_logical_apicid();
 
 	/*
 	 * Need to setup vector mappings before we enable interrupts.
@@ -943,7 +899,6 @@ static __init void disable_smp(void)
 		physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
 	else
 		physid_set_mask_of_physid(0, &phys_cpu_present_map);
-	map_cpu_to_logical_apicid();
 	cpumask_set_cpu(0, cpu_sibling_mask(0));
 	cpumask_set_cpu(0, cpu_core_mask(0));
 }
@@ -1120,8 +1075,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 	end_local_APIC_setup();
 
-	map_cpu_to_logical_apicid();
-
 	if (apic->setup_portio_remap)
 		apic->setup_portio_remap();
 
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 187810b..75abecb 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -99,7 +99,21 @@ void __init setup_node_to_cpumask_map(void)
 	pr_debug("Node to cpumask map for %d nodes\n", nr_node_ids);
 }
 
-#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+#ifndef CONFIG_DEBUG_PER_CPU_MAPS
+
+# ifndef CONFIG_NUMA_EMU
+void __cpuinit numa_add_cpu(int cpu)
+{
+	cpumask_set_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
+}
+
+void __cpuinit numa_remove_cpu(int cpu)
+{
+	cpumask_clear_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
+}
+# endif	/* !CONFIG_NUMA_EMU */
+
+#else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
 
 int __cpu_to_node(int cpu)
 {
@@ -131,6 +145,52 @@ int early_cpu_to_node(int cpu)
 	return per_cpu(x86_cpu_to_node_map, cpu);
 }
 
+struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable)
+{
+	int node = early_cpu_to_node(cpu);
+	struct cpumask *mask;
+	char buf[64];
+
+	mask = node_to_cpumask_map[node];
+	if (!mask) {
+		pr_err("node_to_cpumask_map[%i] NULL\n", node);
+		dump_stack();
+		return NULL;
+	}
+
+	cpulist_scnprintf(buf, sizeof(buf), mask);
+	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
+		enable ? "numa_add_cpu" : "numa_remove_cpu",
+		cpu, node, buf);
+	return mask;
+}
+
+# ifndef CONFIG_NUMA_EMU
+static void __cpuinit numa_set_cpumask(int cpu, int enable)
+{
+	struct cpumask *mask;
+
+	mask = debug_cpumask_set_cpu(cpu, enable);
+	if (!mask)
+		return;
+
+	if (enable)
+		cpumask_set_cpu(cpu, mask);
+	else
+		cpumask_clear_cpu(cpu, mask);
+}
+
+void __cpuinit numa_add_cpu(int cpu)
+{
+	numa_set_cpumask(cpu, 1);
+}
+
+void __cpuinit numa_remove_cpu(int cpu)
+{
+	numa_set_cpumask(cpu, 0);
+}
+# endif	/* !CONFIG_NUMA_EMU */
+
 /*
  * Returns a pointer to the bitmask of CPUs on Node 'node'.
  */
@@ -154,4 +214,4 @@ const struct cpumask *cpumask_of_node(int node)
 }
 EXPORT_SYMBOL(cpumask_of_node);
 
-#endif	/* CONFIG_DEBUG_PER_CPU_MAPS */
+#endif	/* !CONFIG_DEBUG_PER_CPU_MAPS */
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index f545940..14664f5 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -726,19 +726,18 @@ int __cpuinit numa_cpu_node(int cpu)
 	return NUMA_NO_NODE;
 }
 
-#ifndef CONFIG_DEBUG_PER_CPU_MAPS
-
-#ifndef CONFIG_NUMA_EMU
-void __cpuinit numa_add_cpu(int cpu)
-{
-	cpumask_set_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
-}
-
-void __cpuinit numa_remove_cpu(int cpu)
-{
-	cpumask_clear_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
-}
-#else
+/*
+ * UGLINESS AHEAD: Currently, CONFIG_NUMA_EMU is 64bit only and makes use
+ * of 64bit specific data structures.  The distinction is artificial and
+ * should be removed.  numa_{add|remove}_cpu() are implemented in numa.c
+ * for both 32 and 64bit when CONFIG_NUMA_EMU is disabled but here when
+ * enabled.
+ *
+ * NUMA emulation is planned to be made generic and the following and other
+ * related code should be moved to numa.c.
+ */
+#ifdef CONFIG_NUMA_EMU
+# ifndef CONFIG_DEBUG_PER_CPU_MAPS
 void __cpuinit numa_add_cpu(int cpu)
 {
 	unsigned long addr;
@@ -778,47 +777,7 @@ void __cpuinit numa_remove_cpu(int cpu)
 	for_each_online_node(i)
 		cpumask_clear_cpu(cpu, node_to_cpumask_map[i]);
 }
-#endif /* !CONFIG_NUMA_EMU */
-
-#else /* CONFIG_DEBUG_PER_CPU_MAPS */
-static struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable)
-{
-	int node = early_cpu_to_node(cpu);
-	struct cpumask *mask;
-	char buf[64];
-
-	mask = node_to_cpumask_map[node];
-	if (!mask) {
-		pr_err("node_to_cpumask_map[%i] NULL\n", node);
-		dump_stack();
-		return NULL;
-	}
-
-	cpulist_scnprintf(buf, sizeof(buf), mask);
-	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
-		enable ? "numa_add_cpu" : "numa_remove_cpu",
-		cpu, node, buf);
-	return mask;
-}
-
-/*
- * --------- debug versions of the numa functions ---------
- */
-#ifndef CONFIG_NUMA_EMU
-static void __cpuinit numa_set_cpumask(int cpu, int enable)
-{
-	struct cpumask *mask;
-
-	mask = debug_cpumask_set_cpu(cpu, enable);
-	if (!mask)
-		return;
-
-	if (enable)
-		cpumask_set_cpu(cpu, mask);
-	else
-		cpumask_clear_cpu(cpu, mask);
-}
-#else
+# else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
 static void __cpuinit numa_set_cpumask(int cpu, int enable)
 {
 	int node = early_cpu_to_node(cpu);
@@ -842,7 +801,6 @@ static void __cpuinit numa_set_cpumask(int cpu, int enable)
 			cpumask_clear_cpu(cpu, mask);
 	}
 }
-#endif /* CONFIG_NUMA_EMU */
 
 void __cpuinit numa_add_cpu(int cpu)
 {
@@ -853,8 +811,5 @@ void __cpuinit numa_remove_cpu(int cpu)
 {
 	numa_set_cpumask(cpu, 0);
 }
-/*
- * --------- end of debug versions of the numa functions ---------
- */
-
-#endif /* CONFIG_DEBUG_PER_CPU_MAPS */
+# endif	/* !CONFIG_DEBUG_PER_CPU_MAPS */
+#endif	/* CONFIG_NUMA_EMU */
