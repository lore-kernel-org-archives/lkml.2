Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab1AGPcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:32:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:40638 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab1AGPcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:32:43 -0500
Date: Fri, 7 Jan 2011 15:32:16 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de, rientjes@google.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, rientjes@google.com,
        mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.1012301053590.12995@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1012301053590.12995@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86, numa: Fix CONFIG_DEBUG_PER_CPU_MAPS without NUMA emulation
Message-ID: <tip-d906f0eb2f0e6d1a24c479f69a9c39e7e45c5ae8@git.kernel.org>
Git-Commit-ID: d906f0eb2f0e6d1a24c479f69a9c39e7e45c5ae8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 Jan 2011 15:32:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d906f0eb2f0e6d1a24c479f69a9c39e7e45c5ae8
Gitweb:     http://git.kernel.org/tip/d906f0eb2f0e6d1a24c479f69a9c39e7e45c5ae8
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Thu, 30 Dec 2010 10:54:16 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Jan 2011 14:09:34 +0100

x86, numa: Fix CONFIG_DEBUG_PER_CPU_MAPS without NUMA emulation

"x86, numa: Fake node-to-cpumask for NUMA emulation" broke the
build when CONFIG_DEBUG_PER_CPU_MAPS is set and CONFIG_NUMA_EMU
is not.  This is because it is possible to map a cpu to multiple
nodes when NUMA emulation is used; the patch required a physical
node address table to find those nodes that was only available
when CONFIG_NUMA_EMU was enabled.

This extracts the common debug functionality to its own function
for CONFIG_DEBUG_PER_CPU_MAPS and uses it regardless of whether
CONFIG_NUMA_EMU is set or not.

NUMA emulation will now iterate over the set of possible nodes
for each cpu and call the new debug function whereas only the
cpu's node will be used without NUMA emulation enabled.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <alpine.DEB.2.00.1012301053590.12995@chino.kir.corp.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/numa_64.c |   48 +++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 3d73201..1e72102 100644
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
