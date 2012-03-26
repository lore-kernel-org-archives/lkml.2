Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab2CZSLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:11:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933232Ab2CZSLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:11:41 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 26/39] autonuma: select_idle_sibling cleanup target assignment
Date: Mon, 26 Mar 2012 19:46:13 +0200
Message-Id: <1332783986-24195-27-git-send-email-aarcange@redhat.com>
In-Reply-To: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the code without reusing the cpu variable to simplify
readibility.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 kernel/sched/fair.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0d2fe26..693adc5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2642,6 +2642,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	struct sched_domain *sd;
 	struct sched_group *sg;
 	int i;
+	bool idle_target;
 
 	/*
 	 * If the task is going to be woken-up on this cpu and if it is
@@ -2661,6 +2662,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	/*
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
+	idle_target = false;
 	sd = rcu_dereference(per_cpu(sd_llc, target));
 	for_each_lower_domain(sd) {
 		sg = sd->groups;
@@ -2674,7 +2676,6 @@ static int select_idle_sibling(struct task_struct *p, int target)
 					goto next;
 			}
 
-			cpu = -1;
 			for_each_cpu_and(i, sched_group_cpus(sg),
 						tsk_cpus_allowed(p)) {
 				/* Find autonuma cpu only in idle group */
@@ -2682,10 +2683,11 @@ static int select_idle_sibling(struct task_struct *p, int target)
 					target = i;
 					goto done;
 				}
-				if (cpu == -1)
-					cpu = i;
+				if (!idle_target) {
+					idle_target = true;
+					target = i;
+				}
 			}
-			target = cpu;
 next:
 			sg = sg->next;
 		} while (sg != sd->groups);
