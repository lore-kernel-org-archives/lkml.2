Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab2IXRpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:45:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59110 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357Ab2IXRpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:45:08 -0400
Message-ID: <1348508657.11847.114.camel@twins>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Borislav Petkov <bp@alien8.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Mon, 24 Sep 2012 19:44:17 +0200
In-Reply-To: <1348505683.11847.111.camel@twins>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	 <20120924150048.GB11266@suse.de> <1348500647.11847.69.camel@twins>
	 <CA+55aFy5C-gFs6ZU5LyyVN=oxpuoaOpydkbJbhri215QkLx3aA@mail.gmail.com>
	 <1348503163.11847.97.camel@twins>
	 <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
	 <1348505683.11847.111.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 18:54 +0200, Peter Zijlstra wrote:
> But let me try and come up with the list thing, I think we've
> actually got that someplace as well. 

OK, I'm sure the below can be written better, but my brain is gone for
the day...

---
 include/linux/sched.h |   1 +
 kernel/sched/core.c   |   1 +
 kernel/sched/fair.c   | 102 +++++++++++++++++++++++++++++++++++---------------
 3 files changed, 73 insertions(+), 31 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0beac68..d72ea68 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -888,6 +888,7 @@ struct sched_group {
 	atomic_t ref;
 
 	unsigned int group_weight;
+	int group_first;
 	struct sched_group_power *sgp;
 
 	/*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b38f00e..1177eb1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5781,6 +5781,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 
 	do {
 		sg->group_weight = cpumask_weight(sched_group_cpus(sg));
+		sg->group_first = cpumask_first(sched_group_cpus(sg));
 		sg = sg->next;
 	} while (sg != sd->groups);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6b800a1..601bc38 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2634,50 +2634,90 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
  */
 static int select_idle_sibling(struct task_struct *p, int target)
 {
-	int cpu = smp_processor_id();
-	int prev_cpu = task_cpu(p);
-	struct sched_domain *sd;
-	struct sched_group *sg;
-	int i;
+	struct sched_domain *sd_smt, *sd_llc;
+	struct sched_group *sg_smt, *sg_llc;
 
 	/*
-	 * If the task is going to be woken-up on this cpu and if it is
-	 * already idle, then it is the right target.
+	 * Of the target is idle, easy peasy, we're done.
 	 */
-	if (target == cpu && idle_cpu(cpu))
-		return cpu;
+	if (idle_cpu(target))
+		return target;
 
 	/*
-	 * If the task is going to be woken-up on the cpu where it previously
-	 * ran and if it is currently idle, then it the right target.
+	 * Otherwise, see if there's an idle core in the cache domain.
 	 */
-	if (target == prev_cpu && idle_cpu(prev_cpu))
-		return prev_cpu;
+	sd_llc = rcu_dereference(per_cpu(sd_llc, target));
+	sg_llc = sd_llc->groups;
+	do {
+		int candidate = -1;
+
+		sd_smt = rcu_dereference(per_cpu(sd_llc, sg_llc->group_first));
+		for_each_lower_domain(sd_smt) {
+			if (sd_smt->flags & SD_SHARE_CPUPOWER) /* aka. SMT */
+				break;
+		}
+
+		if (!sd_smt) {
+			int cpu = sg_llc->group_first; /* Assume singleton group */
+
+			if (!idle_cpu(cpu))
+				goto next_llc;
+
+			if (!cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
+				goto next_llc;
+
+			return cpu;
+		}
+
+		sg_smt = sd_smt->groups;
+		do {
+			int cpu = sg_smt->group_first; /* Assume singleton group */
+
+			if (!idle_cpu(cpu)) /* core is not idle, skip to next core */
+				goto next_llc;
+
+			if (!cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
+				goto next_smt;
+
+			if (candidate < 0)
+				candidate = cpu;
+
+next_smt:
+			sg_smt = sg_smt->next;
+		} while (sg_smt != sd_smt->groups);
+
+		if (candidate >= 0)
+			return candidate;
+
+next_llc:
+		sg_llc = sg_llc->next;
+	} while (sg_llc != sd_llc->groups);
 
 	/*
-	 * Otherwise, iterate the domains and find an elegible idle cpu.
+	 * Failing that, see if there's an idle SMT sibling.
 	 */
-	sd = rcu_dereference(per_cpu(sd_llc, target));
-	for_each_lower_domain(sd) {
-		sg = sd->groups;
+	sd_smt = rcu_dereference(per_cpu(sd_llc, target));
+	for_each_lower_domain(sd_smt) {
+		if (sd_smt->flags & SD_SHARE_CPUPOWER) /* aka. SMT */
+			break;
+	}
+
+	if (sd_smt) {
+		sg_smt = sd_smt->groups;
 		do {
-			if (!cpumask_intersects(sched_group_cpus(sg),
-						tsk_cpus_allowed(p)))
-				goto next;
+			int cpu = sg_smt->group_first; /* Assume singleton group */
 
-			for_each_cpu(i, sched_group_cpus(sg)) {
-				if (!idle_cpu(i))
-					goto next;
-			}
+			if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)) &&
+			    idle_cpu(cpu))
+				return cpu;
 
-			target = cpumask_first_and(sched_group_cpus(sg),
-					tsk_cpus_allowed(p));
-			goto done;
-next:
-			sg = sg->next;
-		} while (sg != sd->groups);
+			sg_smt = sg_smt->next;
+		} while (sg_smt != sd_smt->groups);
 	}
-done:
+
+	/*
+	 * OK, no idle siblings of any kind, take what we started with.
+	 */
 	return target;
 }
 

