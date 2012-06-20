Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab2FTKsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:48:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34480 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2FTKsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:48:30 -0400
Date: Wed, 20 Jun 2012 03:48:13 -0700
From: tip-bot for Mike Galbraith <efault@gmx.de>
Message-ID: <tip-9e7849c1579c93cc3c1926833e23f3d48ddc9bc6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, efault@gmx.de, tglx@linutronix.de
In-Reply-To: <1339471112.7352.32.camel@marge.simpson.net>
References: <1339471112.7352.32.camel@marge.simpson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Improve scalability via 'CPU buddies',
  which withstand random perturbations
Git-Commit-ID: 9e7849c1579c93cc3c1926833e23f3d48ddc9bc6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 03:48:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e7849c1579c93cc3c1926833e23f3d48ddc9bc6
Gitweb:     http://git.kernel.org/tip/9e7849c1579c93cc3c1926833e23f3d48ddc9bc6
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 12 Jun 2012 05:18:32 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Jun 2012 11:45:07 +0200

sched: Improve scalability via 'CPU buddies', which withstand random perturbations

Traversing an entire package is not only expensive, it also leads to tasks
bouncing all over a partially idle and possible quite large package.  Fix
that up by assigning a 'buddy' CPU to try to motivate.  Each buddy may try
to motivate that one other CPU, if it's busy, tough, it may then try its
SMT sibling, but that's all this optimization is allowed to cost.

Sibling cache buddies are cross-wired to prevent bouncing.

4 socket 40 core + SMT Westmere box, single 30 sec tbench runs, higher is better:

 clients     1       2       4        8       16       32       64      128
 ..........................................................................
 pre        30      41     118      645     3769     6214    12233    14312
 post      299     603    1211     2418     4697     6847    11606    14557

A nice increase in performance.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1339471112.7352.32.camel@marge.simpson.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |   39 ++++++++++++++++++++++++++++++++++++++-
 kernel/sched/fair.c   |   28 +++++++---------------------
 3 files changed, 46 insertions(+), 22 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 293e900..9dced2e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -950,6 +950,7 @@ struct sched_domain {
 	unsigned int smt_gain;
 	int flags;			/* See SD_* */
 	int level;
+	int idle_buddy;			/* cpu assigned to select_idle_sibling() */
 
 	/* Runtime fields. */
 	unsigned long last_balance;	/* init to jiffies. units in jiffies */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index eee1908..9bb7d28 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5897,6 +5897,11 @@ static void destroy_sched_domains(struct sched_domain *sd, int cpu)
  * SD_SHARE_PKG_RESOURCE set (Last Level Cache Domain) for this
  * allows us to avoid some pointer chasing select_idle_sibling().
  *
+ * Iterate domains and sched_groups downward, assigning CPUs to be
+ * select_idle_sibling() hw buddy.  Cross-wiring hw makes bouncing
+ * due to random perturbation self canceling, ie sw buddies pull
+ * their counterpart to their CPU's hw counterpart.
+ *
  * Also keep a unique ID per domain (we use the first cpu number in
  * the cpumask of the domain), this allows us to quickly tell if
  * two cpus are in the same cache domain, see cpus_share_cache().
@@ -5912,8 +5917,40 @@ static void update_domain_cache(int cpu)
 	int id = cpu;
 
 	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
-	if (sd)
+	if (sd) {
+		struct sched_domain *tmp = sd;
+		struct sched_group *sg, *prev;
+		bool right;
+
+		/*
+		 * Traverse to first CPU in group, and count hops
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
+			sg = right ? sg->next : prev;
+			tmp->idle_buddy = cpumask_first(sched_group_cpus(sg));
+		} while ((tmp = tmp->child));
+
 		id = cpumask_first(sched_domain_span(sd));
+	}
 
 	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
 	per_cpu(sd_llc_id, cpu) = id;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a397c00..3704ad3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2642,8 +2642,6 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	struct sched_domain *sd;
-	struct sched_group *sg;
-	int i;
 
 	/*
 	 * If the task is going to be woken-up on this cpu and if it is
@@ -2660,29 +2658,17 @@ static int select_idle_sibling(struct task_struct *p, int target)
 		return prev_cpu;
 
 	/*
-	 * Otherwise, iterate the domains and find an elegible idle cpu.
+	 * Otherwise, check assigned siblings to find an elegible idle cpu.
 	 */
 	sd = rcu_dereference(per_cpu(sd_llc, target));
-	for_each_lower_domain(sd) {
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
 
-			target = cpumask_first_and(sched_group_cpus(sg),
-					tsk_cpus_allowed(p));
-			goto done;
-next:
-			sg = sg->next;
-		} while (sg != sd->groups);
+	for_each_lower_domain(sd) {
+		if (!cpumask_test_cpu(sd->idle_buddy, tsk_cpus_allowed(p)))
+			continue;
+		if (idle_cpu(sd->idle_buddy))
+			return sd->idle_buddy;
 	}
-done:
+
 	return target;
 }
 
