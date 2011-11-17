Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab1KQTE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 14:04:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:61840 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab1KQTE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 14:04:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,528,1315206000"; 
   d="scan'208";a="38357084"
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Date: Thu, 17 Nov 2011 11:08:23 -0800
In-Reply-To: <1321545376.2495.1.camel@laptop>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1321556904.15339.25.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 07:56 -0800, Peter Zijlstra wrote:
> D'0h, indeed.. 
> 
> Something like the below maybe, although I'm certain it all can be
> written much nicer indeed.
> 

Peter, I just noticed that the -tip tree has the original proposed patch
and the new sched/ directory. So updated my cleanup patch accordingly.
Thanks.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: sched: cleanup domain traversal in select_idle_sibling

Instead of going through the scheduler domain hierarchy multiple times
(for giving priority to an idle core over an idle SMT sibling in a busy
core), start with the highest scheduler domain with the SD_SHARE_PKG_RESOURCES
flag and traverse the domain hierarchy down till we find an idle group.

This cleanup also addresses an issue reported by Mike where the recent
changes returned the busy thread even in the presence of an idle SMT
sibling in single socket platforms.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/sched/fair.c  |   38 +++++++++++++++++++++++++-------------
 kernel/sched/sched.h |    2 ++
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cd3b642..537e16a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2642,6 +2642,28 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
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
 /*
  * Try and locate an idle CPU in the sched_domain.
  */
@@ -2651,7 +2673,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	int prev_cpu = task_cpu(p);
 	struct sched_domain *sd;
 	struct sched_group *sg;
-	int i, smt = 0;
+	int i;
 
 	/*
 	 * If the task is going to be woken-up on this cpu and if it is
@@ -2671,19 +2693,9 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
 	rcu_read_lock();
-again:
-	for_each_domain(target, sd) {
-		if (!smt && (sd->flags & SD_SHARE_CPUPOWER))
-			continue;
-
-		if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
-			if (!smt) {
-				smt = 1;
-				goto again;
-			}
-			break;
-		}
 
+	sd = highest_flag_domain(target, SD_SHARE_PKG_RESOURCES);
+	for_each_lower_domain(sd) {
 		sg = sd->groups;
 		do {
 			if (!cpumask_intersects(sched_group_cpus(sg),
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c2e7802..8715055 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -501,6 +501,8 @@ DECLARE_PER_CPU(struct rq, runqueues);
 #define for_each_domain(cpu, __sd) \
 	for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
 
+#define for_each_lower_domain(sd) for (; sd; sd = sd->child)
+
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
 #define this_rq()		(&__get_cpu_var(runqueues))
 #define task_rq(p)		cpu_rq(task_cpu(p))


