Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab0IUOPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:15:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:46541 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873Ab0IUOPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:15:23 -0400
Date: Tue, 21 Sep 2010 14:14:52 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, rostedt@goodmis.org, srostedt@redhat.com,
        tglx@linutronix.de, ghaskins@novell.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, rostedt@goodmis.org, srostedt@redhat.com,
        tglx@linutronix.de, ghaskins@novell.com, mingo@elte.hu
In-Reply-To: <20100921024138.888922071@goodmis.org>
References: <20100921024138.888922071@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Give CPU bound RT tasks preference
Message-ID: <tip-b3bc211cfe7d5fe94b310480d78e00bea96fbf2a@git.kernel.org>
Git-Commit-ID: b3bc211cfe7d5fe94b310480d78e00bea96fbf2a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Sep 2010 14:14:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3bc211cfe7d5fe94b310480d78e00bea96fbf2a
Gitweb:     http://git.kernel.org/tip/b3bc211cfe7d5fe94b310480d78e00bea96fbf2a
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Mon, 20 Sep 2010 22:40:04 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Sep 2010 13:57:12 +0200

sched: Give CPU bound RT tasks preference

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
 
