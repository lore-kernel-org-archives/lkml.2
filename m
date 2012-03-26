Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab2CZTIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 15:08:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab2CZTIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 15:08:52 -0400
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
Subject: [PATCH 20/39] autonuma: avoid CFS select_task_rq_fair to return -1
Date: Mon, 26 Mar 2012 19:46:07 +0200
Message-Id: <1332783986-24195-21-git-send-email-aarcange@redhat.com>
In-Reply-To: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to avoid -1 retval.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 kernel/sched/fair.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 94340c7..25e9e5b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2769,6 +2769,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		goto unlock;
 	}
 
+	prev_cpu = new_cpu;
 	while (sd) {
 		int load_idx = sd->forkexec_idx;
 		struct sched_group *group;
@@ -2792,6 +2793,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		if (new_cpu == -1 || new_cpu == cpu) {
 			/* Now try balancing at a lower domain level of cpu */
 			sd = sd->child;
+			new_cpu = prev_cpu;
 			continue;
 		}
 
@@ -2810,6 +2812,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 unlock:
 	rcu_read_unlock();
 
+	BUG_ON(new_cpu < 0);
 	return new_cpu;
 }
 #endif /* CONFIG_SMP */
