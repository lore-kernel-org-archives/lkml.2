Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab2EJMF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:05:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49393 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759295Ab2EJMFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:05:46 -0400
Subject: Re: [tip:sched/core] x86/numa: Check for nonsensical topologies on
 real hw as well
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <CAE9FiQVu7KP=rabe5_jYZyEGpW7sv6wkK9wumJfW1vk2=+cYKA@mail.gmail.com>
References: <tip-re15l0jqjtpz709oxozt2zoh@git.kernel.org>
	 <CAE9FiQVu7KP=rabe5_jYZyEGpW7sv6wkK9wumJfW1vk2=+cYKA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 May 2012 13:49:38 +0200
Message-ID: <1336650578.27020.94.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 15:48 -0700, Yinghai Lu wrote:
> get wrong warning on system without using numa emu.

Oops yeah, that condition is quite possible to hit, its just that with a
sane topology the end result doesn't change..

How about we do something like this

---
 arch/x86/kernel/smpboot.c |  114 +++++++++++++++++++++++++++------------------
 1 file changed, 68 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index e543e02..2552463 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -299,70 +299,92 @@ void __cpuinit smp_store_cpu_info(int id)
 		identify_secondary_cpu(c);
 }
 
-static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
+static bool __cpuinit topology_sane(int cpu1, int cpu2, const char *name)
 {
-	cpumask_set_cpu(cpu1, cpu_sibling_mask(cpu2));
-	cpumask_set_cpu(cpu2, cpu_sibling_mask(cpu1));
-	cpumask_set_cpu(cpu1, cpu_core_mask(cpu2));
-	cpumask_set_cpu(cpu2, cpu_core_mask(cpu1));
-	cpumask_set_cpu(cpu1, cpu_llc_shared_mask(cpu2));
-	cpumask_set_cpu(cpu2, cpu_llc_shared_mask(cpu1));
+	return WARN(cpu_to_node(cpu1) != cpu_to_node(cpu2),
+		"sched: CPU #%d's %s-sibling CPU #%d is not on the same node! "
+		"[node: %d != %d]. Ignoring siblings dependency.\n",
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
+	if (!topology_sane(c->cpu_index, o->cpu_index, "smt"))
+		return false;
+
+	if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
+		if (c->phys_proc_id == o->phys_proc_id &&
+		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i) &&
+		    c->compute_unit_id == o->compute_unit_id)
+			return true;
+
+	} else if (c->phys_proc_id == o->phys_proc_id &&
+		   c->cpu_core_id == o->cpu_core_id) {
+		return true;
+	}
 
-	cpumask_set_cpu(cpu, cpu_sibling_setup_mask);
+	return false;
+}
 
-	if (smp_num_siblings > 1) {
-		for_each_cpu(i, cpu_sibling_setup_mask) {
-			struct cpuinfo_x86 *o = &cpu_data(i);
+static bool __cpuinit match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+{
+	if (!topology_sane(c->cpu_index, o->cpu_index, "llc"))
+		return false;
 
-			if (cpu_to_node(cpu) != cpu_to_node(i)) {
-				WARN_ONCE(1, "sched: CPU #%d's thread-sibling CPU #%d not on the same node! [node %d != %d]. Ignoring sibling dependency.\n", cpu, i, cpu_to_node(cpu), cpu_to_node(i));
-				continue;
-			}
+	if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
+	    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i))
+		return true;
 
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
+	return false;
+}
+
+static bool __cpuinit match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+{
+	if (!topology_sane(c->cpu_index, o->cpu_index, "mc"))
+		return false;
+
+	if (c->phys_proc_id == cpu_data(i).phys_proc_id)
+		return true;
+
+	return false;
+}
 
-	cpumask_set_cpu(cpu, cpu_llc_shared_mask(cpu));
+void __cpuinit set_cpu_sibling_map(int cpu)
+{
+	bool has_mc = boot_cpu_data.x86_max_cores > 1;
+	bool has_smt = smp_num_siblings > 1;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	struct cpuinfo_x86 *o;
+	int i;
 
-	if (__this_cpu_read(cpu_info.x86_max_cores) == 1) {
-		cpumask_copy(cpu_core_mask(cpu), cpu_sibling_mask(cpu));
+	cpumask_set_cpu(cpu, cpu_sibling_setup_mask);
+
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
+			link_mask(siblings, cpu, i);
+
+		if ((i == cpu) || (has_mc && match_llc(c, o)))
+			link_mask(llc_shared, cpu, i);
+
+		if ((i == cpu) || (has_mc && match_cpu(c, o))) {
+			link_mask(core, cpu, i);
 
-		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
-			cpumask_set_cpu(i, cpu_core_mask(cpu));
-			cpumask_set_cpu(cpu, cpu_core_mask(i));
 			/*
 			 *  Does this new cpu bringup a new core?
 			 */


