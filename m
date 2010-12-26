Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab0LZV6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 16:58:19 -0500
Received: from smtp-out.google.com ([216.239.44.51]:19441 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab0LZV6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 16:58:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=WAsvAuh39qMCM33IgVHYb1Wyw1GRjS32o91gvbqa/dLRvYdOUOBX5td+bi62vjHlpy
         Dzjph9iQsbkd/on65t/w==
Date: Sun, 26 Dec 2010 13:58:11 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch] x86, numa: Fix CONFIG_DEBUG_PER_CPU_MAPS without NUMA
 emulation
In-Reply-To: <20101224204513.GB302@elte.hu>
Message-ID: <alpine.DEB.2.00.1012261339070.23173@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1012221700130.3701@chino.kir.corp.google.com> <20101224204513.GB302@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"x86, numa: Fake node-to-cpumask for NUMA emulation" broke the build when
CONFIG_DEBUG_PER_CPU_MAPS is set and CONFIG_NUMA_EMU is not.  This is
because it is possible to map a cpu to multiple nodes when NUMA emulation
is used; the patch required a physical node address table to find those
nodes that was only available when CONFIG_NUMA_EMU was enabled.

This extracts the common debug functionality to its own function for
CONFIG_DEBUG_PER_CPU_MAPS and uses it regardless of whether
CONFIG_NUMA_EMU is set or not.

NUMA emulation will now iterate over the set of possible nodes for each
cpu and call the new debug function whereas only the cpu's node will be
used without NUMA emulation enabled.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/mm/numa_64.c |   48 +++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -833,15 +833,48 @@ void __cpuinit numa_remove_cpu(int cpu)
 #endif /* !CONFIG_NUMA_EMU */
 
 #else /* CONFIG_DEBUG_PER_CPU_MAPS */
+static struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable)
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
 
 /*
  * --------- debug versions of the numa functions ---------
  */
+#ifndef CONFIG_NUMA_EMU
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
+#else
 static void __cpuinit numa_set_cpumask(int cpu, int enable)
 {
 	int node = early_cpu_to_node(cpu);
 	struct cpumask *mask;
-	char buf[64];
 	int i;
 
 	for_each_online_node(i) {
@@ -851,24 +884,17 @@ static void __cpuinit numa_set_cpumask(int cpu, int enable)
 		if (addr < physnodes[node].start ||
 					addr >= physnodes[node].end)
 			continue;
-		mask = node_to_cpumask_map[node];
-		if (mask == NULL) {
-			pr_err("node_to_cpumask_map[%i] NULL\n", i);
-			dump_stack();
+		mask = debug_cpumask_set_cpu(cpu, enable);
+		if (!mask)
 			return;
-		}
 
 		if (enable)
 			cpumask_set_cpu(cpu, mask);
 		else
 			cpumask_clear_cpu(cpu, mask);
-
-		cpulist_scnprintf(buf, sizeof(buf), mask);
-		printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
-			enable ? "numa_add_cpu" : "numa_remove_cpu",
-			cpu, node, buf);
 	}
 }
+#endif /* CONFIG_NUMA_EMU */
 
 void __cpuinit numa_add_cpu(int cpu)
 {
