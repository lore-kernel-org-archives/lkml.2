Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab1KRXlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:41:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53474 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab1KRXlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:41:45 -0500
Date: Fri, 18 Nov 2011 15:40:42 -0800
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-4dcfe1025b513c2c1da5bf5586adb0e80148f612@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, peterz@infradead.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, efault@gmx.de,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1321350377.1421.55.camel@twins>
References: <1321350377.1421.55.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Avoid SMT siblings in select_idle_sibling() if possible
Git-Commit-ID: 4dcfe1025b513c2c1da5bf5586adb0e80148f612
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:40:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4dcfe1025b513c2c1da5bf5586adb0e80148f612
Gitweb:     http://git.kernel.org/tip/4dcfe1025b513c2c1da5bf5586adb0e80148f612
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 10 Nov 2011 13:01:10 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Nov 2011 08:43:43 +0100

sched: Avoid SMT siblings in select_idle_sibling() if possible

Avoid select_idle_sibling() from picking a sibling thread if there's
an idle core that shares cache.

This fixes SMT balancing in the increasingly common case where there's
a shared cache core available to balance to.

Tested-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1321350377.1421.55.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   42 ++++++++++++++++++++++++++++--------------
 1 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 7e51b5b..ba0e1f4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2326,7 +2326,8 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	struct sched_domain *sd;
-	int i;
+	struct sched_group *sg;
+	int i, smt = 0;
 
 	/*
 	 * If the task is going to be woken-up on this cpu and if it is
@@ -2346,25 +2347,38 @@ static int select_idle_sibling(struct task_struct *p, int target)
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
