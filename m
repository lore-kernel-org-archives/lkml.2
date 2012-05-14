Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab2ENNox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:44:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56573 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab2ENNov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:44:51 -0400
Date: Mon, 14 May 2012 06:44:39 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-klcwahu3gx467uhfiqjyhdcs@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/x86: Rewrite set_cpu_sibling_map()
Git-Commit-ID: 316ad248307fba13be40f01e92a22b89457c32bc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 14 May 2012 06:44:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  316ad248307fba13be40f01e92a22b89457c32bc
Gitweb:     http://git.kernel.org/tip/316ad248307fba13be40f01e92a22b89457c32bc
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 11 May 2012 13:05:59 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 14 May 2012 15:05:25 +0200

sched/x86: Rewrite set_cpu_sibling_map()

Commit ad7687dde ("x86/numa: Check for nonsensical topologies on real
hw as well") is broken in that the condition can trigger for valid
setups but only changes the end result for invalid setups with no real
means of discerning between those.

Rewrite set_cpu_sibling_map() to make the code clearer and make sure
to only warn when the check changes the end result.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-klcwahu3gx467uhfiqjyhdcs@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smpboot.c |  116 ++++++++++++++++++++++++++------------------
 1 files changed, 68 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7c53d96..e84c1bb 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -315,70 +315,90 @@ void __cpuinit smp_store_cpu_info(int id)
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
 
-void __cpuinit set_cpu_sibling_map(int cpu)
+static bool __cpuinit match_smt(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 {
-	int i;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
+		int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
 
-	cpumask_set_cpu(cpu, cpu_sibling_setup_mask);
+		if (c->phys_proc_id == o->phys_proc_id &&
+		    per_cpu(cpu_llc_id, cpu1) == per_cpu(cpu_llc_id, cpu2) &&
+		    c->compute_unit_id == o->compute_unit_id)
+			return topology_sane(c, o, "smt");
 
-	if (smp_num_siblings > 1) {
-		for_each_cpu(i, cpu_sibling_setup_mask) {
-			struct cpuinfo_x86 *o = &cpu_data(i);
+	} else if (c->phys_proc_id == o->phys_proc_id &&
+		   c->cpu_core_id == o->cpu_core_id) {
+		return topology_sane(c, o, "smt");
+	}
 
-			if (cpu_to_node(cpu) != cpu_to_node(i)) {
-				WARN_ONCE(1, "sched: CPU #%d's thread-sibling CPU #%d not on the same node! [node %d != %d]. Ignoring sibling dependency.\n", cpu, i, cpu_to_node(cpu), cpu_to_node(i));
-				continue;
-			}
+	return false;
+}
 
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
-		cpumask_set_cpu(cpu, cpu_sibling_mask(cpu));
-	}
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
+
+void __cpuinit set_cpu_sibling_map(int cpu)
+{
+	bool has_mc = boot_cpu_data.x86_max_cores > 1;
+	bool has_smt = smp_num_siblings > 1;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	struct cpuinfo_x86 *o;
+	int i;
 
-	cpumask_set_cpu(cpu, cpu_llc_shared_mask(cpu));
+	cpumask_set_cpu(cpu, cpu_sibling_setup_mask);
 
-	if (__this_cpu_read(cpu_info.x86_max_cores) == 1) {
-		cpumask_copy(cpu_core_mask(cpu), cpu_sibling_mask(cpu));
+	if (!has_smt && !has_mc) {
+		cpumask_set_cpu(cpu, cpu_sibling_mask(cpu));
+		cpumask_set_cpu(cpu, cpu_llc_shared_mask(cpu));
+		cpumask_set_cpu(cpu, cpu_core_mask(cpu));
 		c->booted_cores = 1;
 		return;
 	}
 
 	for_each_cpu(i, cpu_sibling_setup_mask) {
-		if (cpu_to_node(cpu) != cpu_to_node(i)) {
-			WARN_ONCE(1, "sched: CPU #%d's core-sibling CPU #%d not on the same node! [node %d != %d]. Ignoring sibling dependency.\n", cpu, i, cpu_to_node(cpu), cpu_to_node(i));
-			continue;
-		}
+		o = &cpu_data(i);
 
-		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
-		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
-			cpumask_set_cpu(i, cpu_llc_shared_mask(cpu));
-			cpumask_set_cpu(cpu, cpu_llc_shared_mask(i));
-		}
+		if ((i == cpu) || (has_smt && match_smt(c, o)))
+			link_mask(sibling, cpu, i);
+
+		if ((i == cpu) || (has_mc && match_llc(c, o)))
+			link_mask(llc_shared, cpu, i);
+
+		if ((i == cpu) || (has_mc && match_mc(c, o))) {
+			link_mask(core, cpu, i);
 
-		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
-			cpumask_set_cpu(i, cpu_core_mask(cpu));
-			cpumask_set_cpu(cpu, cpu_core_mask(i));
 			/*
 			 *  Does this new cpu bringup a new core?
 			 */
