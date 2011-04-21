Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1DUMLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 08:11:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:37112 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab1DUMLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 08:11:08 -0400
Date: Thu, 21 Apr 2011 12:10:16 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Message-ID: <tip-7a6c6547825a2324faa76cff856db11d78de075e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, herrmann.der.user@googlemail.com,
        tj@kernel.org, tglx@linutronix.de, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, herrmann.der.user@googlemail.com,
        tj@kernel.org, tglx@linutronix.de, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.1104201918470.12634@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104201918470.12634@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, numa: Fix cpu nodemasks for NUMA emulation and CONFIG_DEBUG_PER_CPU_MAPS
Git-Commit-ID: 7a6c6547825a2324faa76cff856db11d78de075e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Apr 2011 12:10:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a6c6547825a2324faa76cff856db11d78de075e
Gitweb:     http://git.kernel.org/tip/7a6c6547825a2324faa76cff856db11d78de075e
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Wed, 20 Apr 2011 19:19:13 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Apr 2011 11:31:00 +0200

x86, numa: Fix cpu nodemasks for NUMA emulation and CONFIG_DEBUG_PER_CPU_MAPS

The cpu<->node mappings under CONFIG_DEBUG_PER_CPU_MAPS=y
when NUMA emulation is enabled is currently broken because it does
not iterate through every emulated node and bind cpus that have
affinity to it.

NUMA emulation should bind each cpu to every local node to
accurately represent the true NUMA topology of the underlying
machine.

debug_cpumask_set_cpu() needs to be fixed at the same time so
that the debugging information that it emits shows the new
cpumask of the node being assigned when the cpu is being added
or removed.

It can now take responsibility of setting or clearing the cpu
itself to remove the need for duplicate code.

Also change its last parameter, "enable", to have the correct bool
type since it can only be true or false.

 -v2: Fix the return statements, by Kosaki Motohiro

Acked-and-Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.00.1104201918470.12634@chino.kir.corp.google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/numa.h  |    2 +-
 arch/x86/mm/numa.c           |   31 +++++++++++++------------------
 arch/x86/mm/numa_emulation.c |   20 ++++++--------------
 3 files changed, 20 insertions(+), 33 deletions(-)

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
