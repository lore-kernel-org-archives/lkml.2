Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2HDDoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 23:44:21 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:49402 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753724Ab2HDDoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 23:44:18 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18PyV5qry8PxYmhL3xy5BmXVB0ylW9VMZfDqJXsZe
	e0mahbW1lOGgSg
Message-ID: <1344051854.6739.19.camel@marge.simpson.net>
Subject: Re: [patch] sched: fix migration thread runtime bogosity
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Sat, 04 Aug 2012 05:44:14 +0200
In-Reply-To: <1344026355.27828.10.camel@twins>
References: <1344001354.17084.28.camel@marge.simpson.net>
	 <1344026355.27828.10.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-03 at 22:39 +0200, Peter Zijlstra wrote:

> Now the question is, how did that stop thing get any time to begin with?
> Are we hotplugging or somesuch sillyness?

Nope, high frequency exec.

> Anyway, I think I like B best, could you re-submit as a proper patch so
> I can press the magic button that queues stuff?

Ok, B it is.  Since that SUSE guy munged my mailboxes again (twit), he
can write the changelog, and take the blame.

-Mike

From: Mike Galbraith <mgalbraith@suse.de>

sched: fix migration thread runtime bogosity

Make stop scheduler class do the same accounting as other classes,

Migration threads can be caught in the act while doing exec balancing,
leading to the below due to use of unmaintained ->se.exec_start.  The
load that triggered this particular instance was an apparently out of
control heavily threaded application that does system monitoring in
what equated to an exec bomb, with one of the VERY frequently migrated
tasks being ps.

%CPU   PID USER     CMD
99.3    45 root     [migration/10]
97.7    53 root     [migration/12]
97.0    57 root     [migration/13]
90.1    49 root     [migration/11]
89.6    65 root     [migration/15]
88.7    17 root     [migration/3]
80.4    37 root     [migration/8]
78.1    41 root     [migration/9]
44.2    13 root     [migration/2]

Signed-off-by: Mike Galbraith <mgalbraith@suse.de>

diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index 7b386e8..da5eb5b 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -27,8 +27,10 @@ static struct task_struct *pick_next_task_stop(struct rq *rq)
 {
 	struct task_struct *stop = rq->stop;
 
-	if (stop && stop->on_rq)
+	if (stop && stop->on_rq) {
+		stop->se.exec_start = rq->clock_task;
 		return stop;
+	}
 
 	return NULL;
 }
@@ -52,6 +54,21 @@ static void yield_task_stop(struct rq *rq)
 
 static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
 {
+	struct task_struct *curr = rq->curr;
+	u64 delta_exec;
+
+	delta_exec = rq->clock_task - curr->se.exec_start;
+	if (unlikely((s64)delta_exec < 0))
+		delta_exec = 0;
+
+	schedstat_set(curr->se.statistics.exec_max,
+			max(curr->se.statistics.exec_max, delta_exec));
+
+	curr->se.sum_exec_runtime += delta_exec;
+	account_group_exec_runtime(curr, delta_exec);
+
+	curr->se.exec_start = rq->clock_task;
+	cpuacct_charge(curr, delta_exec);
 }
 
 static void task_tick_stop(struct rq *rq, struct task_struct *curr, int queued)
@@ -60,6 +77,9 @@ static void task_tick_stop(struct rq *rq, struct task_struct *curr, int queued)
 
 static void set_curr_task_stop(struct rq *rq)
 {
+	struct task_struct *stop = rq->stop;
+
+	stop->se.exec_start = rq->clock_task;
 }
 
 static void switched_to_stop(struct rq *rq, struct task_struct *p)


