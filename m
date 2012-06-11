Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab2FKRz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 13:55:57 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:60482 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751861Ab2FKRzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 13:55:55 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18WYt5hJ0kWZsWmWyVkgQxxp+vjfCAbu3AjzBaFJ/
	KNRTCmYWl39f9y
Message-ID: <1339437349.7358.57.camel@marge.simpson.net>
Subject: Re: [patch v3] sched: fix select_idle_sibling() induced bouncing
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Arjan Van De Ven <arjan@linux.intel.com>
Date: Mon, 11 Jun 2012 19:55:49 +0200
In-Reply-To: <1339435331.31548.19.camel@twins>
References: <1337857490.7300.19.camel@marge.simpson.net>
	 <1337865431.9783.148.camel@laptop>
	 <1338906621.6110.30.camel@marge.simpson.net>
	 <1339433835.7358.30.camel@marge.simpson.net>
	 <1339435331.31548.19.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 19:22 +0200, Peter Zijlstra wrote: 
> On Mon, 2012-06-11 at 18:57 +0200, Mike Galbraith wrote:
> 
> > Traversing an entire package is not only expensive, it also leads to tasks
> > bouncing all over a partially idle and possible quite large package.  Fix
> > that up by assigning a 'buddy' CPU to try to motivate.  Each buddy may try
> > to motivate that one other CPU, if it's busy, tough, it may then try it's
> > SMT sibling, but that's all this optimization is allowed to cost.
> > 
> > Sibling cache buddies are cross-wired to prevent bouncing.
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> The patch could do with a little comment on how you achieve the
> cross-wiring because staring at the code I go cross-eyed again ;-)

Like below?

> Anyway, I think I'll grab it since nobody seems to have any objections
> and the numbers seem good.
> 
> PJT any progress on your load-tracking stuff? Arjan is interested in the
> avg runtime estimation it has to make the whole wake an idle thing
> conditional on.

That would come in handy.  As would a way to know just how much pain
fast movers can generate.  Opteron seem to have a funny definition of
shared cache.  tbench hates the things with select_idle_sibling()
active, Intel otoh tickles it pink.  On Opteron, you'd better pray
there's enough execution time to make select_idle_sibling() pay off. 

sched: fix select_idle_sibling() induced bouncing

Traversing an entire package is not only expensive, it also leads to tasks
bouncing all over a partially idle and possible quite large package.  Fix
that up by assigning a 'buddy' CPU to try to motivate.  Each buddy may try
to motivate that one other CPU, if it's busy, tough, it may then try it's
SMT sibling, but that's all this optimization is allowed to cost.

Sibling cache buddies are cross-wired to prevent bouncing.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |   39 ++++++++++++++++++++++++++++++++++++++-
 kernel/sched/fair.c   |   28 +++++++---------------------
 3 files changed, 46 insertions(+), 22 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -955,6 +955,7 @@ struct sched_domain {
 	unsigned int smt_gain;
 	int flags;			/* See SD_* */
 	int level;
+	int idle_buddy;			/* cpu assigned to select_idle_sibling() */
 
 	/* Runtime fields. */
 	unsigned long last_balance;	/* init to jiffies. units in jiffies */
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5928,6 +5928,11 @@ static void destroy_sched_domains(struct
  * SD_SHARE_PKG_RESOURCE set (Last Level Cache Domain) for this
  * allows us to avoid some pointer chasing select_idle_sibling().
  *
+ * Iterate domains and sched_groups upward, assigning CPUs to be
+ * select_idle_sibling() hw buddy.  Cross-wiring hw makes bouncing
+ * due to random perturbation self canceling, ie sw buddies pull
+ * their counterpart to their CPU's hw counterpart.
+ *
  * Also keep a unique ID per domain (we use the first cpu number in
  * the cpumask of the domain), this allows us to quickly tell if
  * two cpus are in the same cache domain, see cpus_share_cache().
@@ -5943,8 +5948,40 @@ static void update_domain_cache(int cpu)
 	int id = cpu;
 
 	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
-	if (sd)
+	if (sd) {
+		struct sched_domain *tmp = sd;
+		struct sched_group *sg, *prev;
+		bool right;
+
+		/*
+		 * Traversse to first CPU in group, and count hops
+		 * to cpu from there, switching direction on each
+		 * hop, never ever pointing the last CPU rightward.
+		 */
+		do {
+			id = cpumask_first(sched_domain_span(tmp));
+			prev = sg = tmp->groups;
+			right = 1;
+
+			while (cpumask_first(sched_group_cpus(sg)) != id)
+				sg = sg->next;
+
+			while (!cpumask_test_cpu(cpu, sched_group_cpus(sg))) {
+				prev = sg;
+				sg = sg->next;
+				right = !right;
+			}
+
+			/* A CPU went down, never point back to domain start. */
+			if (right && cpumask_first(sched_group_cpus(sg->next)) == id)
+				right = false;
+
+			sg = right? sg->next : prev;
+			tmp->idle_buddy = cpumask_first(sched_group_cpus(sg));
+		} while ((tmp = tmp->child));
+
 		id = cpumask_first(sched_domain_span(sd));
+	}
 
 	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
 	per_cpu(sd_llc_id, cpu) = id;
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2642,8 +2642,6 @@ static int select_idle_sibling(struct ta
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	struct sched_domain *sd;
-	struct sched_group *sg;
-	int i;
 
 	/*
 	 * If the task is going to be woken-up on this cpu and if it is
@@ -2660,29 +2658,17 @@ static int select_idle_sibling(struct ta
 		return prev_cpu;
 
 	/*
-	 * Otherwise, iterate the domains and find an elegible idle cpu.
+	 * Otherwise, check assigned siblings to find an elegible idle cpu.
 	 */
 	sd = rcu_dereference(per_cpu(sd_llc, target));
+
 	for_each_lower_domain(sd) {
-		sg = sd->groups;
-		do {
-			if (!cpumask_intersects(sched_group_cpus(sg),
-						tsk_cpus_allowed(p)))
-				goto next;
-
-			for_each_cpu(i, sched_group_cpus(sg)) {
-				if (!idle_cpu(i))
-					goto next;
-			}
-
-			target = cpumask_first_and(sched_group_cpus(sg),
-					tsk_cpus_allowed(p));
-			goto done;
-next:
-			sg = sg->next;
-		} while (sg != sd->groups);
+		if (!cpumask_test_cpu(sd->idle_buddy, tsk_cpus_allowed(p)))
+			continue;
+		if (idle_cpu(sd->idle_buddy))
+			return sd->idle_buddy;
 	}
-done:
+
 	return target;
 }
 


