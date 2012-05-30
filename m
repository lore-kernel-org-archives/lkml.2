Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab2E3NiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 09:38:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38419 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab2E3NiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 09:38:19 -0400
Date: Wed, 30 May 2012 06:37:59 -0700
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-74a5ce20e6eeeb3751340b390e7ac1d1d07bbf55@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
        rientjes@google.com
In-Reply-To: <1337788843.9783.14.camel@laptop>
References: <1337788843.9783.14.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix SD_OVERLAP
Git-Commit-ID: 74a5ce20e6eeeb3751340b390e7ac1d1d07bbf55
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 06:38:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74a5ce20e6eeeb3751340b390e7ac1d1d07bbf55
Gitweb:     http://git.kernel.org/tip/74a5ce20e6eeeb3751340b390e7ac1d1d07bbf55
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 23 May 2012 18:00:43 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 30 May 2012 14:02:24 +0200

sched: Fix SD_OVERLAP

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
Cc: David Rientjes <rientjes@google.com>
Link: http://lkml.kernel.org/r/1337788843.9783.14.camel@laptop
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |    7 +++++--
 kernel/sched/fair.c |   25 ++++++++++++++++++++-----
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5573361..3a69374 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6030,11 +6030,14 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 
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
index 940e6d1..f0380d4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3574,11 +3574,26 @@ void update_group_power(struct sched_domain *sd, int cpu)
 
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
