Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab1ILO23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:28:29 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:60420 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756808Ab1ILO22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:28:28 -0400
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH] sched_rt: Migrate equal priority tasks to available CPUs
Date: Mon, 12 Sep 2011 09:28:04 -0500
Message-Id: <1315837684-18733-1-git-send-email-sbohrer@rgmadvisors.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 43fa5460fe60dea5c610490a1d263415419c60f6 "sched: Try not to
migrate higher priority RT tasks" also introduced a change in behavior
which keeps RT tasks on the same CPU if there is an equal priority RT
task currently running even if there are empty CPUs available.  This can
cause unnecessary wakeup latencies, and can prevent the scheduler from
balancing all RT tasks across the available CPUs.

This change causes an RT task to search for a new CPU if an equal
priority RT task is already running on wakeup.  Lower priority tasks
will still have to wait on higher priority tasks, but the system should
still balance out because there is always the possibility that if there
are both a high and low priority RT tasks on a given CPU that the high
priority task could wakeup while the low priority task is running and
force it to search for a better runqueue.

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
---
 kernel/sched_rt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 10d0182..17f2319 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1038,7 +1038,7 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 	 */
 	if (curr && unlikely(rt_task(curr)) &&
 	    (curr->rt.nr_cpus_allowed < 2 ||
-	     curr->prio < p->prio) &&
+	     curr->prio <= p->prio) &&
 	    (p->rt.nr_cpus_allowed > 1)) {
 		int target = find_lowest_rq(p);
 
@@ -1569,7 +1569,7 @@ static void task_woken_rt(struct rq *rq, struct task_struct *p)
 	    p->rt.nr_cpus_allowed > 1 &&
 	    rt_task(rq->curr) &&
 	    (rq->curr->rt.nr_cpus_allowed < 2 ||
-	     rq->curr->prio < p->prio))
+	     rq->curr->prio <= p->prio))
 		push_rt_tasks(rq);
 }
 
-- 
1.7.6



---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

