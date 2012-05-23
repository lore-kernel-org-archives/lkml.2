Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965221Ab2EWQAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:00:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35251 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965054Ab2EWQAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:00:50 -0400
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        pjt@google.com, cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <1337698830.9698.37.camel@twins>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
	 <alpine.DEB.2.00.1205191922250.24674@chino.kir.corp.google.com>
	 <20120521084046.GB31407@gmail.com>
	 <alpine.DEB.2.00.1205211914100.13682@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1205211932350.13682@chino.kir.corp.google.com>
	 <1337688268.9698.29.camel@twins>  <1337698830.9698.37.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 May 2012 18:00:43 +0200
Message-ID: <1337788843.9783.14.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 17:00 +0200, Peter Zijlstra wrote:
> /me goes kick his gray cells some more.

OK, does the below make your machine happy? If not, please share the
completely topology setup of that thing (lscpu or similar).

---
Subject: sched: Fix SD_OVERLAP

SD_OVERLAP exists to allow overlapping groups, overlapping groups
appear in NUMA topologies that aren't fully connected.

The typical result of not fully connected NUMA is that each cpu (or
rather node) will have different spans for a particular distance.
However due to how sched domains are traversed -- only the first cpu
in the mask goes one level up -- the next level only cares about the
spans of the cpus that went up.

Due to this two things were observed to be broken:

 - build_overlap_sched_groups() -- since its possible the cpu we're
   building the groups for exists in multiple (or all) groups, the
   selection criteria of the first group didn't ensure there was a cpu
   for which is was true that cpumask_first(span) == cpu. Thus load-
   balancing would terminate.

 - update_group_power() -- assumed that the cpu span of the first
   group of the domain was covered by all groups of the child domain.
   The above explains why this isn't true, so deal with it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/core.c |    7 +++++--
 kernel/sched/fair.c |   25 ++++++++++++++++++++-----
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 18eed17..29217a4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6007,11 +6007,14 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 
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
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index de49ed5..7466b7a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3768,11 +3768,26 @@ void update_group_power(struct sched_domain *sd, int cpu)
 
 	power = 0;
 
-	group = child->groups;
-	do {
-		power += group->sgp->power;
-		group = group->next;
-	} while (group != child->groups);
+	if (child->flags & SD_OVERLAP) {
+		/*
+		 * SD_OVERLAP domains cannot assume that child groups
+		 * span the current group.
+		 */
+
+		for_each_cpu(cpu, sched_group_cpus(sdg))
+			power += power_of(cpu);
+	} else  {
+		/*
+		 * !SD_OVERLAP domains can assume that child groups
+		 * span the current group.
+		 */ 
+
+		group = child->groups;
+		do {
+			power += group->sgp->power;
+			group = group->next;
+		} while (group != child->groups);
+	}
 
 	sdg->sgp->power = power;
 }


