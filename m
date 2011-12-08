Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab1LHKDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 05:03:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:52658 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab1LHKC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 05:02:56 -0500
Message-ID: <1323338531.17673.7.camel@twins>
Subject: Re: [patch v3 5/6] sched, ttwu_queue: queue remote wakeups only
 when crossing cache domains
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>, Chris Mason <chris.mason@oracle.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Date: Thu, 08 Dec 2011 11:02:11 +0100
In-Reply-To: <1323285644.1984.55.camel@sbsiddha-desk.sc.intel.com>
References: <20111202010731.344451602@sbsiddha-desk.sc.intel.com>
	 <20111202010832.714874234@sbsiddha-desk.sc.intel.com>
	 <1322796864.4755.5.camel@marge.simson.net>
	 <1323275027.32012.114.camel@twins>
	 <1323285644.1984.55.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: sched: Only queue remote wakeups when crossing cache boundaries
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Dec 07 15:07:31 CET 2011

Mike reported a 13% drop in netperf TCP_RR performance due to the new
remote wakeup code. Suresh too noticed some performance issues with
it.

Reducing the IPIs to only cross cache domains solves the observed
performance issues.

Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Reported-by: Suresh Siddha <suresh.b.siddha@intel.com>
Reported-by: Mike Galbraith <efault@gmx.de>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/core.c  |   34 +++++++++++++++++++++++++++++++++-
 kernel/sched/fair.c  |   24 +-----------------------
 kernel/sched/sched.h |   42 ++++++++++++++++++++++++++++++++++++------
 3 files changed, 70 insertions(+), 30 deletions(-)
Index: linux-2.6/kernel/sched/core.c
===================================================================
--- linux-2.6.orig/kernel/sched/core.c
+++ linux-2.6/kernel/sched/core.c
@@ -1511,6 +1511,11 @@ static int ttwu_activate_remote(struct t
 
 }
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
+
+static inline int ttwu_share_cache(int this_cpu, int that_cpu)
+{
+	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
+}
 #endif /* CONFIG_SMP */
 
 static void ttwu_queue(struct task_struct *p, int cpu)
@@ -1518,7 +1523,7 @@ static void ttwu_queue(struct task_struc
 	struct rq *rq = cpu_rq(cpu);
 
 #if defined(CONFIG_SMP)
-	if (sched_feat(TTWU_QUEUE) && cpu != smp_processor_id()) {
+	if (sched_feat(TTWU_QUEUE) && !ttwu_share_cache(smp_processor_id(), cpu)) {
 		sched_clock_cpu(cpu); /* sync clocks x-cpu */
 		ttwu_queue_remote(p, cpu);
 		return;
@@ -5751,6 +5756,31 @@ static void destroy_sched_domains(struct
 }
 
 /*
+ * Keep a special pointer to the highest sched_domain that has
+ * SD_SHARE_PKG_RESOURCE set (Last Level Cache Domain) for this
+ * allows us to avoid some pointer chasing select_idle_sibling().
+ *
+ * Also keep a unique ID per domain (we use the first cpu number in
+ * the cpumask of the domain), this allows us to quickly tell if
+ * two cpus are in the same cache domain, see ttwu_share_cache().
+ */
+DEFINE_PER_CPU(struct sched_domain *, sd_llc);
+DEFINE_PER_CPU(int, sd_llc_id);
+
+static void update_top_cache_domain(int cpu)
+{
+	struct sched_domain *sd;
+	int id = cpu;
+
+	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
+	if (sd)
+		id = cpumask_first(sched_domain_span(sd));
+
+	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
+	per_cpu(sd_llc_id, cpu) = id;
+}
+
+/*
  * Attach the domain 'sd' to 'cpu' as its base domain. Callers must
  * hold the hotplug lock.
  */
@@ -5789,6 +5819,8 @@ cpu_attach_domain(struct sched_domain *s
 	tmp = rq->sd;
 	rcu_assign_pointer(rq->sd, sd);
 	destroy_sched_domains(tmp, cpu);
+
+	update_top_cache_domain(cpu);
 }
 
 /* cpus with isolated domains */
Index: linux-2.6/kernel/sched/fair.c
===================================================================
--- linux-2.6.orig/kernel/sched/fair.c
+++ linux-2.6/kernel/sched/fair.c
@@ -2644,28 +2644,6 @@ find_idlest_cpu(struct sched_group *grou
 	return idlest;
 }
 
-/**
- * highest_flag_domain - Return highest sched_domain containing flag.
- * @cpu:	The cpu whose highest level of sched domain is to
- *		be returned.
- * @flag:	The flag to check for the highest sched_domain
- *		for the given cpu.
- *
- * Returns the highest sched_domain of a cpu which contains the given flag.
- */
-static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
-{
-	struct sched_domain *sd, *hsd = NULL;
-
-	for_each_domain(cpu, sd) {
-		if (!(sd->flags & flag))
-			break;
-		hsd = sd;
-	}
-
-	return hsd;
-}
-
 /*
  * Try and locate an idle CPU in the sched_domain.
  */
@@ -2696,7 +2674,7 @@ static int select_idle_sibling(struct ta
 	 */
 	rcu_read_lock();
 
-	sd = highest_flag_domain(target, SD_SHARE_PKG_RESOURCES);
+	sd = rcu_dereference(per_cpu(sd_llc, target));
 	for_each_lower_domain(sd) {
 		sg = sd->groups;
 		do {
Index: linux-2.6/kernel/sched/sched.h
===================================================================
--- linux-2.6.orig/kernel/sched/sched.h
+++ linux-2.6/kernel/sched/sched.h
@@ -487,6 +487,14 @@ static inline int cpu_of(struct rq *rq)
 
 DECLARE_PER_CPU(struct rq, runqueues);
 
+#define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
+#define this_rq()		(&__get_cpu_var(runqueues))
+#define task_rq(p)		cpu_rq(task_cpu(p))
+#define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
+#define raw_rq()		(&__raw_get_cpu_var(runqueues))
+
+#ifdef CONFIG_SMP
+
 #define rcu_dereference_check_sched_domain(p) \
 	rcu_dereference_check((p), \
 			      lockdep_is_held(&sched_domains_mutex))
@@ -499,15 +507,37 @@ DECLARE_PER_CPU(struct rq, runqueues);
  * preempt-disabled sections.
  */
 #define for_each_domain(cpu, __sd) \
-	for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
+	for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd); \
+			__sd; __sd = __sd->parent)
 
 #define for_each_lower_domain(sd) for (; sd; sd = sd->child)
 
-#define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
-#define this_rq()		(&__get_cpu_var(runqueues))
-#define task_rq(p)		cpu_rq(task_cpu(p))
-#define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
-#define raw_rq()		(&__raw_get_cpu_var(runqueues))
+/**
+ * highest_flag_domain - Return highest sched_domain containing flag.
+ * @cpu:	The cpu whose highest level of sched domain is to
+ *		be returned.
+ * @flag:	The flag to check for the highest sched_domain
+ *		for the given cpu.
+ *
+ * Returns the highest sched_domain of a cpu which contains the given flag.
+ */
+static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
+{
+	struct sched_domain *sd, *hsd = NULL;
+
+	for_each_domain(cpu, sd) {
+		if (!(sd->flags & flag))
+			break;
+		hsd = sd;
+	}
+
+	return hsd;
+}
+
+DECLARE_PER_CPU(struct sched_domain *, sd_llc);
+DECLARE_PER_CPU(int, sd_llc_id);
+
+#endif /* CONFIG_SMP */
 
 #include "stats.h"
 #include "auto_group.h"

