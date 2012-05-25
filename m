Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab2EYIgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:36:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:57436 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab2EYIgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:36:03 -0400
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, pjt@google.com,
        cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1205231757140.28167@chino.kir.corp.google.com>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
	 <alpine.DEB.2.00.1205191922250.24674@chino.kir.corp.google.com>
	 <20120521084046.GB31407@gmail.com>
	 <alpine.DEB.2.00.1205211914100.13682@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1205211932350.13682@chino.kir.corp.google.com>
	 <1337688268.9698.29.camel@twins>  <1337698830.9698.37.camel@twins>
	 <1337788843.9783.14.camel@laptop>
	 <alpine.DEB.2.00.1205231757140.28167@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 10:35:53 +0200
Message-ID: <1337934953.9783.162.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 17:58 -0700, David Rientjes wrote:
> Same divide by zero.  I'd be happy to run a debugging patch if you
> can 
> come up with one.
> 
> $ grep -E 'processor|core|sibling|physical id|apicid|
> cpuid' /proc/cpuinfo | sed 's/processor/\nprocessor/' 

Curious, that looks like a 4 socket 4 core machine without HT. Is this
some Core2 era Xeon setup or so?

What does the node distance table on that thing look like?

cat /sys/devices/system/node/node*/distance

Anyway, could you boot that machine with

CONFIG_SCHED_DEBUG
CONFIG_FTRACE

and the following added to the boot parameters:

 "sched_debug debug ftrace_dump_on_oops ftrace=nop"

that should dump the ftrace buffer (to which the trace_printk() stmts
go) to the console when it explodes.

If you could then send me the complete console output (privately if its
too big)..

NOTE this patch includes the previous patches so you should be able to
apply it to a clean tree.

---
 arch/x86/mm/numa.c  |    6 ++----
 kernel/sched/core.c |   40 +++++++++++++++++++++++++++++++---------
 kernel/sched/fair.c |   50 +++++++++++++++++++++++++++++++++++++++++---------
 lib/vsprintf.c      |    5 +++++
 4 files changed, 79 insertions(+), 22 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 19d3fa0..3f16071 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -751,7 +751,6 @@ int early_cpu_to_node(int cpu)
 void debug_cpumask_set_cpu(int cpu, int node, bool enable)
 {
 	struct cpumask *mask;
-	char buf[64];
 
 	if (node == NUMA_NO_NODE) {
 		/* early_cpu_to_node() already emits a warning and trace */
@@ -769,10 +768,9 @@ void debug_cpumask_set_cpu(int cpu, int node, bool enable)
 	else
 		cpumask_clear_cpu(cpu, mask);
 
-	cpulist_scnprintf(buf, sizeof(buf), mask);
-	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
+	printk(KERN_DEBUG "%s cpu %d node %d: mask now %pc\n",
 		enable ? "numa_add_cpu" : "numa_remove_cpu",
-		cpu, node, buf);
+		cpu, node, mask);
 	return;
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 18eed17..eee020c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5537,9 +5537,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 				  struct cpumask *groupmask)
 {
 	struct sched_group *group = sd->groups;
-	char str[256];
 
-	cpulist_scnprintf(str, sizeof(str), sched_domain_span(sd));
 	cpumask_clear(groupmask);
 
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
@@ -5552,7 +5550,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		return -1;
 	}
 
-	printk(KERN_CONT "span %s level %s\n", str, sd->name);
+	printk(KERN_CONT "span %pc level %s\n", sched_domain_span(sd), sd->name);
 
 	if (!cpumask_test_cpu(cpu, sched_domain_span(sd))) {
 		printk(KERN_ERR "ERROR: domain->span does not contain "
@@ -5593,9 +5591,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 
 		cpumask_or(groupmask, groupmask, sched_group_cpus(group));
 
-		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
-
-		printk(KERN_CONT " %s", str);
+		printk(KERN_CONT " %pc", sched_group_cpus(group));
 		if (group->sgp->power != SCHED_POWER_SCALE) {
 			printk(KERN_CONT " (cpu_power = %d)",
 				group->sgp->power);
@@ -6005,13 +6001,18 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		} else
 			cpumask_set_cpu(i, sg_span);
 
+		trace_printk("  group: cpu (%d) span (%pc)\n", cpu, sg_span);
+
 		cpumask_or(covered, covered, sg_span);
 
-		sg->sgp = *per_cpu_ptr(sdd->sgp, cpumask_first(sg_span));
+		sg->sgp = *per_cpu_ptr(sdd->sgp, i);
 		atomic_inc(&sg->sgp->ref);
 
-		if (cpumask_test_cpu(cpu, sg_span))
+		if ((!groups && cpumask_test_cpu(cpu, sg_span)) ||
+			       cpumask_first(sg_span) == cpu) {
+			WARN_ON_ONCE(!cpumask_test_cpu(cpu, sg_span));
 			groups = sg;
+		}
 
 		if (!first)
 			first = sg;
@@ -6125,6 +6126,9 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 		sg = sg->next;
 	} while (sg != sd->groups);
 
+	trace_printk("groups init: cpu (%d) domain (%pc)\n", cpu,
+			sched_domain_span(sd));
+
 	if (cpu != group_first_cpu(sg))
 		return;
 
@@ -6421,6 +6425,7 @@ static void sched_init_numa(void)
 			sched_domains_numa_distance[level++] = next_distance;
 			sched_domains_numa_levels = level;
 			curr_distance = next_distance;
+			trace_printk("numa: found distance: %d\n", next_distance);
 		} else break;
 	}
 	/*
@@ -6446,7 +6451,7 @@ static void sched_init_numa(void)
 			return;
 
 		for (j = 0; j < nr_node_ids; j++) {
-			struct cpumask *mask = kzalloc_node(cpumask_size(), GFP_KERNEL, j);
+			struct cpumask *mask = kzalloc(cpumask_size(), GFP_KERNEL);
 			if (!mask)
 				return;
 
@@ -6458,6 +6463,9 @@ static void sched_init_numa(void)
 
 				cpumask_or(mask, mask, cpumask_of_node(k));
 			}
+
+			trace_printk("numa: level (%d) node (%d) mask (%pc)\n",
+					i, j, mask);
 		}
 	}
 
@@ -6484,6 +6492,8 @@ static void sched_init_numa(void)
 		};
 	}
 
+	trace_printk("numa: %d levels of numa goodness added!\n", j);
+
 	sched_domain_topology = tl;
 }
 #else
@@ -6621,6 +6631,8 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 		sd = NULL;
 		for (tl = sched_domain_topology; tl->init; tl++) {
 			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
+			trace_printk("domain: cpu (%d) span (%pc)\n",
+					i, sched_domain_span(sd));
 			if (tl->flags & SDTL_OVERLAP || sched_feat(FORCE_SD_OVERLAP))
 				sd->flags |= SD_OVERLAP;
 			if (cpumask_equal(cpu_map, sched_domain_span(sd)))
@@ -6636,6 +6648,8 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 	/* Build the groups for the domains */
 	for_each_cpu(i, cpu_map) {
 		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
+			struct sched_group *sg;
+
 			sd->span_weight = cpumask_weight(sched_domain_span(sd));
 			if (sd->flags & SD_OVERLAP) {
 				if (build_overlap_sched_groups(sd, i))
@@ -6644,6 +6658,14 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 				if (build_sched_groups(sd, i))
 					goto error;
 			}
+			
+			sg = sd->groups;
+			do {
+				trace_printk("groups: cpu (%d) domain (%pc) group (%pc)\n",
+						i, sched_domain_span(sd), 
+						sched_group_cpus(sg));
+				sg = sg->next;
+			} while (sg != sd->groups);
 		}
 	}
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index de49ed5..77a48ad 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3697,15 +3697,22 @@ unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
 unsigned long scale_rt_power(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	u64 total, available;
+	u64 total, available, age_stamp, avg;
 
-	total = sched_avg_period() + (rq->clock - rq->age_stamp);
+	/*
+	 * Since we're reading these variables without serialization make sure
+	 * we read them once before doing sanity checks on them.
+	 */
+	age_stamp = ACCESS_ONCE(rq->age_stamp);
+	avg = ACCESS_ONCE(rq->rt_avg);
 
-	if (unlikely(total < rq->rt_avg)) {
+	total = sched_avg_period() + (rq->clock - age_stamp);
+
+	if (unlikely(total < avg)) {
 		/* Ensures that power won't end up being negative */
 		available = 0;
 	} else {
-		available = total - rq->rt_avg;
+		available = total - avg;
 	}
 
 	if (unlikely((s64)total < SCHED_POWER_SCALE))
@@ -3763,18 +3770,43 @@ void update_group_power(struct sched_domain *sd, int cpu)
 
 	if (!child) {
 		update_cpu_power(sd, cpu);
+		trace_printk("power: cpu (%d) : %d\n", cpu, sdg->sgp->power);
 		return;
 	}
 
 	power = 0;
 
-	group = child->groups;
-	do {
-		power += group->sgp->power;
-		group = group->next;
-	} while (group != child->groups);
+	if (child->flags & SD_OVERLAP) {
+		int i;
+		/*
+		 * SD_OVERLAP domains cannot assume that child groups
+		 * span the current group.
+		 */
+
+		for_each_cpu(i, sched_group_cpus(sdg)) {
+			power += power_of(i);
+			trace_printk("power: cpu (%d) cpu (%d) inc (%ld) : %ld\n",
+					cpu, i, power_of(i), power);
+		}
+	} else  {
+		/*
+		 * !SD_OVERLAP domains can assume that child groups
+		 * span the current group.
+		 */ 
+
+		group = child->groups;
+		do {
+			power += group->sgp->power;
+			trace_printk("power: cpu (%d) group (%pc) inc (%d) : %ld\n",
+					cpu, sched_group_cpus(group),
+					group->sgp->power, power);
+			group = group->next;
+		} while (group != child->groups);
+	}
 
 	sdg->sgp->power = power;
+	trace_printk("power: cpu (%d) group (%pc) : %ld\n",
+			cpu, sched_group_cpus(sdg), power);
 }
 
 /*
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index abbabec..3b880ae 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -25,6 +25,7 @@
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
 #include <linux/ioport.h>
+#include <linux/cpumask.h>
 #include <net/addrconf.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
@@ -857,6 +858,7 @@ int kptr_restrict __read_mostly;
  *       correctness of the format string and va_list arguments.
  * - 'K' For a kernel pointer that should be hidden from unprivileged users
  * - 'NF' For a netdev_features_t
+ * - 'c' For a cpumask list
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -941,6 +943,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			return netdev_feature_string(buf, end, ptr, spec);
 		}
 		break;
+	case 'c':
+		return buf + cpulist_scnprintf(buf, end - buf, ptr);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
@@ -1175,6 +1179,7 @@ int format_decode(const char *fmt, struct printf_spec *spec)
  * %pI6c print an IPv6 address as specified by RFC 5952
  * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
  *   case.
+ * %pc print a cpumask as comma-separated list
  * %n is ignored
  *
  * The return value is the number of characters which would


