Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370Ab2CZS62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:58:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933267Ab2CZS5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:57:22 -0400
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
Subject: [PATCH 21/39] autonuma: fix selecting task runqueue
Date: Mon, 26 Mar 2012 19:46:08 +0200
Message-Id: <1332783986-24195-22-git-send-email-aarcange@redhat.com>
In-Reply-To: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hillf Danton <dhillf@gmail.com>

Without coments, the following three hunks, I guess,
======
@@ -2788,6 +2801,7 @@ select_task_rq_fair(struct task_struct *p,
 		goto unlock;
 	}

+	prev_cpu = new_cpu;
 	while (sd) {
 		int load_idx = sd->forkexec_idx;
 		struct sched_group *group;
@@ -2811,6 +2825,7 @@ select_task_rq_fair(struct task_struct *p,
 		if (new_cpu == -1 || new_cpu == cpu) {
 			/* Now try balancing at a lower domain level of cpu */
 			sd = sd->child;
+			new_cpu = prev_cpu;
 			continue;
 		}

@@ -2826,6 +2841,7 @@ select_task_rq_fair(struct task_struct *p,
 		}
 		/* while loop will break here if sd == NULL */
 	}
+	BUG_ON(new_cpu < 0);
 unlock:
 	rcu_read_unlock();

======
were added for certain that selected cpu is valid, based on BUG_ON.

But question raised, why prev_cpu is changed?

Andrea's answer: yes the BUG_ON was introduced to verify the function
wouldn't return -1. This patch fixes the problem too.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 kernel/sched/fair.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 25e9e5b..a8498e0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2769,7 +2769,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		goto unlock;
 	}
 
-	prev_cpu = new_cpu;
 	while (sd) {
 		int load_idx = sd->forkexec_idx;
 		struct sched_group *group;
@@ -2793,7 +2792,10 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		if (new_cpu == -1 || new_cpu == cpu) {
 			/* Now try balancing at a lower domain level of cpu */
 			sd = sd->child;
-			new_cpu = prev_cpu;
+			if (new_cpu == -1) {
+				/* Only for certain that new cpu is valid */
+				new_cpu = prev_cpu;
+			}
 			continue;
 		}
 
