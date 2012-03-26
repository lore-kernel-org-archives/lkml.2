Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2CZTJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 15:09:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab2CZTJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 15:09:14 -0400
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
Subject: [PATCH 24/39] autonuma: fix finding idlest cpu
Date: Mon, 26 Mar 2012 19:46:11 +0200
Message-Id: <1332783986-24195-25-git-send-email-aarcange@redhat.com>
In-Reply-To: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hillf Danton <dhillf@gmail.com>

If autonuma not enabled, no cpu is selected, which is behavior change.
We have to fix it.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 kernel/sched/fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 166168d..bf109cc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2619,11 +2619,11 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 
 	/* Traverse only the allowed CPUs */
 	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
-		if (task_autonuma_cpu(p, i))
-			continue;
 		load = weighted_cpuload(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
+			if (!task_autonuma_cpu(p, i))
+				continue;
 			min_load = load;
 			idlest = i;
 		}
