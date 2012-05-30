Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2E3Nkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 09:40:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38461 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab2E3Nku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 09:40:50 -0400
Date: Wed, 30 May 2012 06:40:35 -0700
From: tip-bot for Colin Cross <ccross@android.com>
Message-ID: <tip-454c79999f7eaedcdf4c15c449e43902980cbdf5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, ccross@android.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ccross@android.com, tglx@linutronix.de
In-Reply-To: <1337229266-15798-1-git-send-email-ccross@android.com>
References: <1337229266-15798-1-git-send-email-ccross@android.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/rt: Fix SCHED_RR across cgroups
Git-Commit-ID: 454c79999f7eaedcdf4c15c449e43902980cbdf5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 06:40:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  454c79999f7eaedcdf4c15c449e43902980cbdf5
Gitweb:     http://git.kernel.org/tip/454c79999f7eaedcdf4c15c449e43902980cbdf5
Author:     Colin Cross <ccross@android.com>
AuthorDate: Wed, 16 May 2012 21:34:23 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 30 May 2012 14:02:25 +0200

sched/rt: Fix SCHED_RR across cgroups

task_tick_rt() has an optimization to only reschedule SCHED_RR tasks
if they were the only element on their rq.  However, with cgroups
a SCHED_RR task could be the only element on its per-cgroup rq but
still be competing with other SCHED_RR tasks in its parent's
cgroup.  In this case, the SCHED_RR task in the child cgroup would
never yield at the end of its timeslice.  If the child cgroup
rt_runtime_us was the same as the parent cgroup rt_runtime_us,
the task in the parent cgroup would starve completely.

Modify task_tick_rt() to check that the task is the only task on its
rq, and that the each of the scheduling entities of its ancestors
is also the only entity on its rq.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337229266-15798-1-git-send-email-ccross@android.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 295da73..2a4e8df 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1985,6 +1985,8 @@ static void watchdog(struct rq *rq, struct task_struct *p)
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 {
+	struct sched_rt_entity *rt_se = &p->rt;
+
 	update_curr_rt(rq);
 
 	watchdog(rq, p);
@@ -2002,12 +2004,15 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 	p->rt.time_slice = RR_TIMESLICE;
 
 	/*
-	 * Requeue to the end of queue if we are not the only element
-	 * on the queue:
+	 * Requeue to the end of queue if we (and all of our ancestors) are the
+	 * only element on the queue
 	 */
-	if (p->rt.run_list.prev != p->rt.run_list.next) {
-		requeue_task_rt(rq, p, 0);
-		set_tsk_need_resched(p);
+	for_each_sched_rt_entity(rt_se) {
+		if (rt_se->run_list.prev != rt_se->run_list.next) {
+			requeue_task_rt(rq, p, 0);
+			set_tsk_need_resched(p);
+			return;
+		}
 	}
 }
 
