Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab1KPBLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 20:11:04 -0500
Received: from mga14.intel.com ([143.182.124.37]:59801 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756943Ab1KPBLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 20:11:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,517,1315206000"; 
   d="scan'208";a="37510876"
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>
Date: Tue, 15 Nov 2011 17:14:22 -0800
In-Reply-To: <1321350377.1421.55.camel@twins>
References: <1321350377.1421.55.camel@twins>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 01:46 -0800, Peter Zijlstra wrote:
> @@ -2346,25 +2347,38 @@ static int select_idle_sibling(struct ta
>  	 * Otherwise, iterate the domains and find an elegible idle cpu.
>  	 */
>  	rcu_read_lock();
> +again:
>  	for_each_domain(target, sd) {
> -		if (!(sd->flags & SD_SHARE_PKG_RESOURCES))
> -			break;
> +		if (!smt && (sd->flags & SD_SHARE_CPUPOWER))
> +			continue;
>  
> -		for_each_cpu_and(i, sched_domain_span(sd), tsk_cpus_allowed(p)) {
> -			if (idle_cpu(i)) {
> -				target = i;
> -				break;
> +		if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
> +			if (!smt) {
> +				smt = 1;
> +				goto again;
>  			}
> +			break;
>  		}

It looks like you will be checking the core domain twice (with smt == 0
and smt == 1) if there are no idle siblings.

How about this patch which is more self explanatory?
---

Avoid select_idle_sibling() from picking a sibling thread if there's
an idle core that shares cache.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched.c      |    2 +
 kernel/sched_fair.c |   54 +++++++++++++++++++++++++++++++++++---------------
 2 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0e9344a..4b0bc6a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -734,6 +734,8 @@ static inline int cpu_of(struct rq *rq)
 #define for_each_domain(cpu, __sd) \
 	for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
 
+#define for_each_lower_domain(sd) for (; sd; sd = sd->child)
+
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
 #define this_rq()		(&__get_cpu_var(runqueues))
 #define task_rq(p)		cpu_rq(task_cpu(p))
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5c9e679..cb7a5ef 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2241,6 +2241,25 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 	return idlest;
 }
 
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
+	struct sched_domain *sd;
+
+	for_each_domain(cpu, sd)
+		if (!(sd->flags & flag))
+			return sd->child;
+	return NULL;
+}
+
 /*
  * Try and locate an idle CPU in the sched_domain.
  */
@@ -2249,6 +2268,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	struct sched_domain *sd;
+	struct sched_group *sg;
 	int i;
 
 	/*
@@ -2269,25 +2289,27 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
 	rcu_read_lock();
-	for_each_domain(target, sd) {
-		if (!(sd->flags & SD_SHARE_PKG_RESOURCES))
-			break;
+	sd = highest_flag_domain(target, SD_SHARE_PKG_RESOURCES);
+	for_each_lower_domain(sd) {
+		sg = sd->groups;
+		do {
+			if (!cpumask_intersects(sched_group_cpus(sg),
+						tsk_cpus_allowed(p)))
+				goto next;
 
-		for_each_cpu_and(i, sched_domain_span(sd), tsk_cpus_allowed(p)) {
-			if (idle_cpu(i)) {
-				target = i;
-				break;
+			for_each_cpu(i, sched_group_cpus(sg)) {
+				if (!idle_cpu(i))
+					goto next;
 			}
-		}
 
-		/*
-		 * Lets stop looking for an idle sibling when we reached
-		 * the domain that spans the current cpu and prev_cpu.
-		 */
-		if (cpumask_test_cpu(cpu, sched_domain_span(sd)) &&
-		    cpumask_test_cpu(prev_cpu, sched_domain_span(sd)))
-			break;
+			target = cpumask_first_and(sched_group_cpus(sg),
+					tsk_cpus_allowed(p));
+			goto done;
+next:
+			sg = sg->next;
+		} while (sg != sd->groups);
 	}
+done:
 	rcu_read_unlock();
 
 	return target;


