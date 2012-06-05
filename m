Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab2FEOa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 10:30:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:55114 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752084Ab2FEOa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 10:30:26 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19bTQdh3x9bJfK8TgHxMSbgk+XxYhrCJyyWWqb/7R
	ga51LMZB33Krbf
Message-ID: <1338906621.6110.30.camel@marge.simpson.net>
Subject: Re: [rfc][patch] select_idle_sibling() inducing bouncing on westmere
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Arjan Van De Ven <arjan@linux.intel.com>
Date: Tue, 05 Jun 2012 16:30:21 +0200
In-Reply-To: <1337865431.9783.148.camel@laptop>
References: <1337857490.7300.19.camel@marge.simpson.net>
	 <1337865431.9783.148.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 15:17 +0200, Peter Zijlstra wrote:

> For power7 with 4 smt it would end up as 1230 I guess.

Ok, so I still don't have a POWER7 w. SMT enabled to play with, so just
wired up all buddies cross wise.  What's good for the goose is good for
the gander and such.

Oh yeah, alert: barrier impaired^Wchallenged^Wmoron :) 

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
 kernel/sched/core.c   |   35 ++++++++++++++++++++++++++++++++++-
 kernel/sched/fair.c   |   27 +++++++--------------------
 3 files changed, 42 insertions(+), 21 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -944,6 +944,7 @@ struct sched_domain {
 	unsigned int smt_gain;
 	int flags;			/* See SD_* */
 	int level;
+	int idle_buddy;			/* cpu assigned to select_idle_sibling() */
 
 	/* Runtime fields. */
 	unsigned long last_balance;	/* init to jiffies. units in jiffies */
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5914,6 +5914,11 @@ static void destroy_sched_domains(struct
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
@@ -5929,8 +5934,36 @@ static void update_domain_cache(int cpu)
 	int id = cpu;
 
 	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
-	if (sd)
+	if (sd) {
+		struct sched_domain *tmp = sd;
+		struct sched_group *sg, *prev;
+		int right;
+
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
+				right = 0;
+
+			sg = right? sg->next : prev;
+			tmp->idle_buddy = cpumask_first(sched_group_cpus(sg));
+			smp_wmb();
+		} while ((tmp = tmp->child));
+
 		id = cpumask_first(sched_domain_span(sd));
+	}
 
 	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
 	per_cpu(sd_llc_id, cpu) = id;
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2642,7 +2642,6 @@ static int select_idle_sibling(struct ta
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	struct sched_domain *sd;
-	struct sched_group *sg;
 	int i;
 
 	/*
@@ -2660,29 +2659,17 @@ static int select_idle_sibling(struct ta
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
+		smp_rmb();
+		i = sd->idle_buddy;
+		if (idle_cpu(i))
+			return i;
 	}
-done:
+
 	return target;
 }
 


