Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab1DUCTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:19:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:34936 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab1DUCTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:19:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=EoUFk/83W9gYTUURFzcAaESX3GjhpW5JuXu33VGrz+DaS/XcsSfUfOTmllRHgcdrCK
         I0c0d3mvDEayxET6zbMQ==
Date: Wed, 20 Apr 2011 19:19:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
cc: Andreas Herrmann <herrmann.der.user@googlemail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        x86@kernel.org
Subject: [patch 2/2] x86, numa: Fix cpu nodemasks for NUMA emulation and
 CONFIG_DEBUG_PER_CPU_MAPS
In-Reply-To: <alpine.DEB.2.00.1104201918110.12634@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1104201918470.12634@chino.kir.corp.google.com>
References: <BANLkTin1=uPcyBgy9S_2TJASk8qTkeueEA@mail.gmail.com> <20110420153907.GA9000@alberich.amd.com> <alpine.DEB.2.00.1104201722540.15906@chino.kir.corp.google.com> <alpine.DEB.2.00.1104201918110.12634@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu nodemasks under CONFIG_DEBUG_PER_CPU_MAPS when NUMA emulation is 
enabled is currently broken because it does not iterate through every 
emulated node and bind cpus that have affinity to it.  NUMA emulation 
should bind each cpu to every local node to accurately represent the true 
NUMA topology of the underlying machine.

debug_cpumask_set_cpu() needs to be fixed at the same time so that the 
debugging information that it emits shows the new cpumask of the node 
being assigned when the cpu is being added or removed.  It can now take 
responsibility of setting or clearing the cpu itself to remove the need 
for duplicate code.

Also changes its last formal, "enable", to have the correct bool type 
since it can only be true or false.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/numa.h  |    2 +-
 arch/x86/mm/numa.c           |   27 +++++++++++----------------
 arch/x86/mm/numa_emulation.c |   20 ++++++--------------
 3 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -51,7 +51,7 @@ static inline void numa_remove_cpu(int cpu)		{ }
 #endif	/* CONFIG_NUMA */
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
-struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable);
+void debug_cpumask_set_cpu(int cpu, int node, bool enable);
 #endif
 
 #endif	/* _ASM_X86_NUMA_H */
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -213,9 +213,8 @@ int early_cpu_to_node(int cpu)
 	return per_cpu(x86_cpu_to_node_map, cpu);
 }
 
-struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable)
+void debug_cpumask_set_cpu(int cpu, int node, bool enable)
 {
-	int node = early_cpu_to_node(cpu);
 	struct cpumask *mask;
 	char buf[64];
 
@@ -227,9 +226,14 @@ struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable)
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
@@ -238,28 +242,19 @@ struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable)
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
