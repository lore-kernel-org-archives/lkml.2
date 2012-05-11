Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030264Ab2EKLMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:12:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35206 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759501Ab2EKLMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:12:13 -0400
Message-ID: <1336734684.1017.13.camel@twins>
Subject: Re: [tip:sched/core] x86/numa: Check for nonsensical topologies on
 real hw as well
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Fri, 11 May 2012 13:11:24 +0200
In-Reply-To: <CA+1xoqfygHVK8hXqSOrZtudE57ZFut52Ptus9zwgBAJxH-VL_g@mail.gmail.com>
References: <tip-re15l0jqjtpz709oxozt2zoh@git.kernel.org>
	 <CAE9FiQVu7KP=rabe5_jYZyEGpW7sv6wkK9wumJfW1vk2=+cYKA@mail.gmail.com>
	 <1336650578.27020.94.camel@laptop> <1336651704.27020.100.camel@laptop>
	 <1336658058.2527.119.camel@twins>
	 <CA+1xoqfygHVK8hXqSOrZtudE57ZFut52Ptus9zwgBAJxH-VL_g@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 13:00 +0200, Sasha Levin wrote:
> On Thu, May 10, 2012 at 3:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > OK here's one that compiles and boots without silly warnings on a WSM-EP
> >
> >
> > ---
> 
> I've tried Ingo's original patch on a KVM guest that has
> 'numa=fake=10', and saw two of these warnings mentioned above show up.
> 
> I've tried applying Peter's patch on top, but now I get 24 such
> warnings instead.

Yeah, I should probably make that WARN_ONCE()

---
Subject: x86: Rewrite set_cpu_sibling_map
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri May 11 13:05:59 CEST 2012

Commit ad7687dde ("x86/numa: Check for nonsensical topologies on real
hw as well") is broken in that the condition can trigger for valid
setups but only changes the end result for invalid setups with no real
means of discerning between those.

Rewrite set_cpu_sibling_map() to make the code clearer and make sure
to only warn when the check changes the end result.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/smpboot.c |  116 ++++++++++++++++++++++++++--------------------
 1 file changed, 68 insertions(+), 48 deletions(-)

--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -299,70 +299,90 @@ void __cpuinit smp_store_cpu_info(int id
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
-			if (cpu_to_node(cpu) != cpu_to_node(i)) {
-				WARN_ONCE(1, "sched: CPU #%d's thread-sibling CPU #%d not on the same node! [node %d != %d]. Ignoring sibling dependency.\n", cpu, i, cpu_to_node(cpu), cpu_to_node(i));
-				continue;
-			}
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
-		if (cpu_to_node(cpu) != cpu_to_node(i)) {
-			WARN_ONCE(1, "sched: CPU #%d's core-sibling CPU #%d not on the same node! [node %d != %d]. Ignoring sibling dependency.\n", cpu, i, cpu_to_node(cpu), cpu_to_node(i));
-			continue;
-		}
-
-		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
-		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
-			cpumask_set_cpu(i, cpu_llc_shared_mask(cpu));
-			cpumask_set_cpu(cpu, cpu_llc_shared_mask(i));
-		}
-
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

