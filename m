Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab1DUQHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 12:07:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44169 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab1DUQHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 12:07:02 -0400
Date: Thu, 21 Apr 2011 18:06:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110421160654.GA26822@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
David Rientjes (2):
      Revert "x86, NUMA: Fix fakenuma boot failure"
      x86, numa: Fix cpu nodemasks for NUMA emulation and CONFIG_DEBUG_PER_CPU_MAPS


 arch/x86/include/asm/numa.h  |    2 +-
 arch/x86/kernel/smpboot.c    |   23 -----------------------
 arch/x86/mm/numa.c           |   31 +++++++++++++------------------
 arch/x86/mm/numa_emulation.c |   20 ++++++--------------
 4 files changed, 20 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index 3d4dab4..a50fc9f 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -51,7 +51,7 @@ static inline void numa_remove_cpu(int cpu)		{ }
 #endif	/* CONFIG_NUMA */
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
-struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable);
+void debug_cpumask_set_cpu(int cpu, int node, bool enable);
 #endif
 
 #endif	/* _ASM_X86_NUMA_H */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 8ed8908..c2871d3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -312,26 +312,6 @@ void __cpuinit smp_store_cpu_info(int id)
 		identify_secondary_cpu(c);
 }
 
-static void __cpuinit check_cpu_siblings_on_same_node(int cpu1, int cpu2)
-{
-	int node1 = early_cpu_to_node(cpu1);
-	int node2 = early_cpu_to_node(cpu2);
-
-	/*
-	 * Our CPU scheduler assumes all logical cpus in the same physical cpu
-	 * share the same node. But, buggy ACPI or NUMA emulation might assign
-	 * them to different node. Fix it.
-	 */
-	if (node1 != node2) {
-		pr_warning("CPU %d in node %d and CPU %d in node %d are in the same physical CPU. forcing same node %d\n",
-			   cpu1, node1, cpu2, node2, node2);
-
-		numa_remove_cpu(cpu1);
-		numa_set_node(cpu1, node2);
-		numa_add_cpu(cpu1);
-	}
-}
-
 static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
 {
 	cpumask_set_cpu(cpu1, cpu_sibling_mask(cpu2));
@@ -340,7 +320,6 @@ static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
 	cpumask_set_cpu(cpu2, cpu_core_mask(cpu1));
 	cpumask_set_cpu(cpu1, cpu_llc_shared_mask(cpu2));
 	cpumask_set_cpu(cpu2, cpu_llc_shared_mask(cpu1));
-	check_cpu_siblings_on_same_node(cpu1, cpu2);
 }
 
 
@@ -382,12 +361,10 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
 			cpumask_set_cpu(i, cpu_llc_shared_mask(cpu));
 			cpumask_set_cpu(cpu, cpu_llc_shared_mask(i));
-			check_cpu_siblings_on_same_node(cpu, i);
 		}
 		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
 			cpumask_set_cpu(i, cpu_core_mask(cpu));
 			cpumask_set_cpu(cpu, cpu_core_mask(i));
-			check_cpu_siblings_on_same_node(cpu, i);
 			/*
 			 *  Does this new cpu bringup a new core?
 			 */
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 9559d36..745258d 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -213,53 +213,48 @@ int early_cpu_to_node(int cpu)
 	return per_cpu(x86_cpu_to_node_map, cpu);
 }
 
-struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable)
+void debug_cpumask_set_cpu(int cpu, int node, bool enable)
 {
-	int node = early_cpu_to_node(cpu);
 	struct cpumask *mask;
 	char buf[64];
 
 	if (node == NUMA_NO_NODE) {
 		/* early_cpu_to_node() already emits a warning and trace */
-		return NULL;
+		return;
 	}
 	mask = node_to_cpumask_map[node];
 	if (!mask) {
 		pr_err("node_to_cpumask_map[%i] NULL\n", node);
 		dump_stack();
-		return NULL;
+		return;
 	}
 
+	if (enable)
+		cpumask_set_cpu(cpu, mask);
+	else
+		cpumask_clear_cpu(cpu, mask);
+
 	cpulist_scnprintf(buf, sizeof(buf), mask);
 	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
 		enable ? "numa_add_cpu" : "numa_remove_cpu",
 		cpu, node, buf);
-	return mask;
+	return;
 }
 
 # ifndef CONFIG_NUMA_EMU
-static void __cpuinit numa_set_cpumask(int cpu, int enable)
+static void __cpuinit numa_set_cpumask(int cpu, bool enable)
 {
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
+	debug_cpumask_set_cpu(cpu, early_cpu_to_node(cpu), enable);
 }
 
 void __cpuinit numa_add_cpu(int cpu)
 {
-	numa_set_cpumask(cpu, 1);
+	numa_set_cpumask(cpu, true);
 }
 
 void __cpuinit numa_remove_cpu(int cpu)
 {
-	numa_set_cpumask(cpu, 0);
+	numa_set_cpumask(cpu, false);
 }
 # endif	/* !CONFIG_NUMA_EMU */
 
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index ad091e4..de84cc1 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -454,10 +454,9 @@ void __cpuinit numa_remove_cpu(int cpu)
 		cpumask_clear_cpu(cpu, node_to_cpumask_map[i]);
 }
 #else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
-static void __cpuinit numa_set_cpumask(int cpu, int enable)
+static void __cpuinit numa_set_cpumask(int cpu, bool enable)
 {
-	struct cpumask *mask;
-	int nid, physnid, i;
+	int nid, physnid;
 
 	nid = early_cpu_to_node(cpu);
 	if (nid == NUMA_NO_NODE) {
@@ -467,28 +466,21 @@ static void __cpuinit numa_set_cpumask(int cpu, int enable)
 
 	physnid = emu_nid_to_phys[nid];
 
-	for_each_online_node(i) {
+	for_each_online_node(nid) {
 		if (emu_nid_to_phys[nid] != physnid)
 			continue;
 
-		mask = debug_cpumask_set_cpu(cpu, enable);
-		if (!mask)
-			return;
-
-		if (enable)
-			cpumask_set_cpu(cpu, mask);
-		else
-			cpumask_clear_cpu(cpu, mask);
+		debug_cpumask_set_cpu(cpu, nid, enable);
 	}
 }
 
 void __cpuinit numa_add_cpu(int cpu)
 {
-	numa_set_cpumask(cpu, 1);
+	numa_set_cpumask(cpu, true);
 }
 
 void __cpuinit numa_remove_cpu(int cpu)
 {
-	numa_set_cpumask(cpu, 0);
+	numa_set_cpumask(cpu, false);
 }
 #endif	/* !CONFIG_DEBUG_PER_CPU_MAPS */
