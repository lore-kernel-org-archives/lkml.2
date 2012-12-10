Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2LJMTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 07:19:38 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64219 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2LJMTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 07:19:37 -0500
MIME-Version: 1.0
Date: Mon, 10 Dec 2012 20:19:36 +0800
Message-ID: <CAJd=RBCk0eWQqTk-BX8_=aBdYEQnbnf57dHZdcVbWbVY=33OhQ@mail.gmail.com>
Subject: [RFC PATCH] sched: rt: fix selecting runqueue for task to be pushed
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we are trying to push task out, no point to select the last cpu that
the given task executed on, which is fixed by selecting target cpu with
cache affinity concerned, and with SD_WAKE_AFFINE ignored as we are not
handling sleeper.

[based on upstream]

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched/rt.c	Mon Dec 10 19:52:20 2012
+++ b/kernel/sched/rt.c	Mon Dec 10 20:00:16 2012
@@ -1234,7 +1234,7 @@ static void yield_task_rt(struct rq *rq)
 }

 #ifdef CONFIG_SMP
-static int find_lowest_rq(struct task_struct *task);
+static int find_lowest_rq(struct task_struct *task, int pushing);

 static int
 select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
@@ -1283,7 +1283,7 @@ select_task_rq_rt(struct task_struct *p,
 	    (curr->nr_cpus_allowed < 2 ||
 	     curr->prio <= p->prio) &&
 	    (p->nr_cpus_allowed > 1)) {
-		int target = find_lowest_rq(p);
+		int target = find_lowest_rq(p, 0);

 		if (target != -1)
 			cpu = target;
@@ -1473,7 +1473,7 @@ next_idx:

 static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);

-static int find_lowest_rq(struct task_struct *task)
+static int find_lowest_rq(struct task_struct *task, int pushing)
 {
 	struct sched_domain *sd;
 	struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
@@ -1495,6 +1495,12 @@ static int find_lowest_rq(struct task_st
 	 * lowest priority tasks in the system.  Now we want to elect
 	 * the best one based on our affinity and topology.
 	 *
+	 * If we are pushing task out, ignore the last cpu that the
+	 * task executed on.
+	 */
+	if (pushing)
+		goto consult_sd;
+	/*
 	 * We prioritize the last cpu that the task executed on since
 	 * it is most likely cache-hot in that location.
 	 */
@@ -1508,8 +1514,21 @@ static int find_lowest_rq(struct task_st
 	if (!cpumask_test_cpu(this_cpu, lowest_mask))
 		this_cpu = -1; /* Skip this_cpu opt if not among lowest */

+consult_sd:
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
+		if (pushing) {
+			int sel;
+			for_each_cpu_and(sel, lowest_mask,
+					sched_domain_span(sd)) {
+				/* We prefer LLC cpu */
+				if (sel != cpu) {
+					rcu_read_unlock();
+					return sel;
+				}
+			}
+			continue;
+		}
 		if (sd->flags & SD_WAKE_AFFINE) {
 			int best_cpu;

@@ -1533,6 +1552,8 @@ static int find_lowest_rq(struct task_st
 	}
 	rcu_read_unlock();

+	if (pushing)
+		return -1;
 	/*
 	 * And finally, if there were no matches within the domains
 	 * just give the caller *something* to work with from the compatible
@@ -1555,7 +1576,7 @@ static struct rq *find_lock_lowest_rq(st
 	int cpu;

 	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
-		cpu = find_lowest_rq(task);
+		cpu = find_lowest_rq(task, 1);

 		if ((cpu == -1) || (cpu == rq->cpu))
 			break;
--
