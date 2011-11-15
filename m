Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1KOJqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 04:46:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:48894 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab1KOJqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 04:46:43 -0500
Subject: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Paul Turner <pjt@google.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>
Date: Tue, 15 Nov 2011 10:46:17 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321350377.1421.55.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 10 Nov 2011 13:01:10 +0100

Avoid select_idle_sibling() from picking a sibling thread if there's
an idle core that shares cache.

Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-smlz1ah4jwood10f7eml9gzk@git.kernel.org
---
 kernel/sched_fair.c |   42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -2326,7 +2326,8 @@ static int select_idle_sibling(struct ta
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	struct sched_domain *sd;
-	int i;
+	struct sched_group *sg;
+	int i, smt = 0;
 
 	/*
 	 * If the task is going to be woken-up on this cpu and if it is
@@ -2346,25 +2347,38 @@ static int select_idle_sibling(struct ta
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
 	rcu_read_lock();
+again:
 	for_each_domain(target, sd) {
-		if (!(sd->flags & SD_SHARE_PKG_RESOURCES))
-			break;
+		if (!smt && (sd->flags & SD_SHARE_CPUPOWER))
+			continue;
 
-		for_each_cpu_and(i, sched_domain_span(sd), tsk_cpus_allowed(p)) {
-			if (idle_cpu(i)) {
-				target = i;
-				break;
+		if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
+			if (!smt) {
+				smt = 1;
+				goto again;
 			}
+			break;
 		}
 
-		/*
-		 * Lets stop looking for an idle sibling when we reached
-		 * the domain that spans the current cpu and prev_cpu.
-		 */
-		if (cpumask_test_cpu(cpu, sched_domain_span(sd)) &&
-		    cpumask_test_cpu(prev_cpu, sched_domain_span(sd)))
-			break;
+		sg = sd->groups;
+		do {
+			if (!cpumask_intersects(sched_group_cpus(sg),
+						tsk_cpus_allowed(p)))
+				goto next;
+
+			for_each_cpu(i, sched_group_cpus(sg)) {
+				if (!idle_cpu(i))
+					goto next;
+			}
+
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

