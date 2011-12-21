Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1LULlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:41:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33953 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab1LULls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:41:48 -0500
Date: Wed, 21 Dec 2011 03:41:09 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-518cd62341786aa4e3839810832af2fbc0de1ea4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, dave.kleikamp@oracle.com, efault@gmx.de,
        chris.mason@oracle.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        chris.mason@oracle.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        dave.kleikamp@oracle.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1323338531.17673.7.camel@twins>
References: <1323338531.17673.7.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Only queue remote wakeups when crossing cache boundaries
Git-Commit-ID: 518cd62341786aa4e3839810832af2fbc0de1ea4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 03:41:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  518cd62341786aa4e3839810832af2fbc0de1ea4
Gitweb:     http://git.kernel.org/tip/518cd62341786aa4e3839810832af2fbc0de1ea4
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 7 Dec 2011 15:07:31 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 10:34:44 +0100

sched: Only queue remote wakeups when crossing cache boundaries

Mike reported a 13% drop in netperf TCP_RR performance due to the
new remote wakeup code. Suresh too noticed some performance issues
with it.

Reducing the IPIs to only cross cache domains solves the observed
performance issues.

Reported-by: Suresh Siddha <suresh.b.siddha@intel.com>
Reported-by: Mike Galbraith <efault@gmx.de>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Link: http://lkml.kernel.org/r/1323338531.17673.7.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c  |   34 +++++++++++++++++++++++++++++++++-
 kernel/sched/fair.c  |   24 +-----------------------
 kernel/sched/sched.h |   42 ++++++++++++++++++++++++++++++++++++------
 3 files changed, 70 insertions(+), 30 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index cdf51a2..dba878c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1511,6 +1511,11 @@ static int ttwu_activate_remote(struct task_struct *p, int wake_flags)
 
 }
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
+
+static inline int ttwu_share_cache(int this_cpu, int that_cpu)
+{
+	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
+}
 #endif /* CONFIG_SMP */
 
 static void ttwu_queue(struct task_struct *p, int cpu)
@@ -1518,7 +1523,7 @@ static void ttwu_queue(struct task_struct *p, int cpu)
 	struct rq *rq = cpu_rq(cpu);
 
 #if defined(CONFIG_SMP)
-	if (sched_feat(TTWU_QUEUE) && cpu != smp_processor_id()) {
+	if (sched_feat(TTWU_QUEUE) && !ttwu_share_cache(smp_processor_id(), cpu)) {
 		sched_clock_cpu(cpu); /* sync clocks x-cpu */
 		ttwu_queue_remote(p, cpu);
 		return;
@@ -5744,6 +5749,31 @@ static void destroy_sched_domains(struct sched_domain *sd, int cpu)
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
@@ -5782,6 +5812,8 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	tmp = rq->sd;
 	rcu_assign_pointer(rq->sd, sd);
 	destroy_sched_domains(tmp, cpu);
+
+	update_top_cache_domain(cpu);
 }
 
 /* cpus with isolated domains */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a4d2b7a..2237ffe 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2644,28 +2644,6 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
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
@@ -2696,7 +2674,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	 */
 	rcu_read_lock();
 
-	sd = highest_flag_domain(target, SD_SHARE_PKG_RESOURCES);
+	sd = rcu_dereference(per_cpu(sd_llc, target));
 	for_each_lower_domain(sd) {
 		sg = sd->groups;
 		do {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d8d3613..98c0c26 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
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
