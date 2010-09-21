Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab0IUClo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 22:41:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47101 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab0IUClk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 22:41:40 -0400
X-Authority-Analysis: v=1.1 cv=GglhOq9PVtWDmzXFaQc2b9ix+3dKCE90LyQFAZ1FxMQ= c=1 sm=0 a=x8wbd8_hBuYA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=1nSz6Ew-AAAA:8 a=meVymXHHAAAA:8 a=oI6s-JDPRIst2FJeducA:9 a=0di-MFiSnOTJN0DHNNmfGm5uG84A:4 a=jEp0ucaQiEUA:10 a=nj4rVwXhlm8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100921024138.888922071@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 20 Sep 2010 22:40:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Gregory Haskins <ghaskins@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/4] sched: Give CPU bound RT tasks preference
References: <20100921024002.672817629@goodmis.org>
Content-Disposition: inline; filename=0002-sched-Give-CPU-bound-RT-tasks-preference.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If a high priority task is waking up on a CPU that is running a lower
priority task that is bound to a CPU, see if we can move the high RT task to
another CPU first. Note, if all other CPUs are running higher priority
tasks than the CPU bounded current task, then it will be preempted
regardless.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched_rt.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 6a02b38..baef30f 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -971,7 +971,8 @@ select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
 	 * For equal prio tasks, we just let the scheduler sort it out.
 	 */
 	if (unlikely(rt_task(rq->curr)) &&
-	    rq->curr->prio < p->prio &&
+	    (rq->curr->rt.nr_cpus_allowed < 2 ||
+	     rq->curr->prio < p->prio) &&
 	    (p->rt.nr_cpus_allowed > 1)) {
 		int cpu = find_lowest_rq(p);
 
@@ -1491,9 +1492,10 @@ static void task_woken_rt(struct rq *rq, struct task_struct *p)
 	if (!task_running(rq, p) &&
 	    !test_tsk_need_resched(rq->curr) &&
 	    has_pushable_tasks(rq) &&
+	    p->rt.nr_cpus_allowed > 1 &&
 	    rt_task(rq->curr) &&
-	    rq->curr->prio < p->prio &&
-	    p->rt.nr_cpus_allowed > 1)
+	    (rq->curr->rt.nr_cpus_allowed < 2 ||
+	     rq->curr->prio < p->prio))
 		push_rt_tasks(rq);
 }
 
-- 
1.7.1


