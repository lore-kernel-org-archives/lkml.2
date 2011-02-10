Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab1BJMag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:30:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab1BJMYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:24:47 -0500
From: stable-bot for Steven Rostedt <srostedt@redhat.com>
Date: Thu, 10 Feb 2011 10:21:08 +0100
Subject: [PATCH 06/28] sched: Give CPU bound RT tasks preference
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340643.5512.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: b3bc211cfe7d5fe94b310480d78e00bea96fbf2a upstream
Aauthor: Steven Rostedt <srostedt@redhat.com>
AuthorDate: Mon Sep 20 22:40:04 2010 -0400

If a high priority task is waking up on a CPU that is running a
lower priority task that is bound to a CPU, see if we can move the
high RT task to another CPU first. Note, if all other CPUs are
running higher priority tasks than the CPU bounded current task,
then it will be preempted regardless.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gregory Haskins <ghaskins@novell.com>
LKML-Reference: <20100921024138.888922071@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_rt.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index d2d481f..3782369 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -965,7 +965,8 @@ select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
 	 * For equal prio tasks, we just let the scheduler sort it out.
 	 */
 	if (unlikely(rt_task(rq->curr)) &&
-	    rq->curr->prio < p->prio &&
+	    (rq->curr->rt.nr_cpus_allowed < 2 ||
+	     rq->curr->prio < p->prio) &&
 	    (p->rt.nr_cpus_allowed > 1)) {
 		int cpu = find_lowest_rq(p);
 
@@ -1493,9 +1494,10 @@ static void task_woken_rt(struct rq *rq, struct task_struct *p)
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
1.7.4


