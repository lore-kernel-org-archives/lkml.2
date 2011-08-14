Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1HNQDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:03:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:52003 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab1HNQDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:03:08 -0400
Date: Sun, 14 Aug 2011 16:02:17 GMT
From: tip-bot for Hillf Danton <dhillf@gmail.com>
Message-ID: <tip-311e800e16f63d909136a64ed17ca353a160be59@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, dhillf@gmail.com, mgalbraith@gmx.de,
        rostedt@goodmis.org, tglx@linutronix.de, yong.zhang0@gmail.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, dhillf@gmail.com, mgalbraith@gmx.de,
        rostedt@goodmis.org, tglx@linutronix.de, yong.zhang0@gmail.com,
        mingo@elte.hu
In-Reply-To: <1306895385.4791.26.camel@marge.simson.net>
References: <1306895385.4791.26.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, rt: Fix rq->rt.pushable_tasks bug in push_rt_task()
Git-Commit-ID: 311e800e16f63d909136a64ed17ca353a160be59
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:02:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  311e800e16f63d909136a64ed17ca353a160be59
Gitweb:     http://git.kernel.org/tip/311e800e16f63d909136a64ed17ca353a160be59
Author:     Hillf Danton <dhillf@gmail.com>
AuthorDate: Thu, 16 Jun 2011 21:55:20 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:00:48 +0200

sched, rt: Fix rq->rt.pushable_tasks bug in push_rt_task()

Do not call dequeue_pushable_task() when failing to push an eligible
task, as it remains pushable, merely not at this particular moment.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Mike Galbraith <mgalbraith@gmx.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yong Zhang <yong.zhang0@gmail.com>
Link: http://lkml.kernel.org/r/1306895385.4791.26.camel@marge.simson.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_rt.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index e2698c0..8e18945 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1394,6 +1394,7 @@ static int push_rt_task(struct rq *rq)
 {
 	struct task_struct *next_task;
 	struct rq *lowest_rq;
+	int ret = 0;
 
 	if (!rq->rt.overloaded)
 		return 0;
@@ -1426,7 +1427,7 @@ retry:
 	if (!lowest_rq) {
 		struct task_struct *task;
 		/*
-		 * find lock_lowest_rq releases rq->lock
+		 * find_lock_lowest_rq releases rq->lock
 		 * so it is possible that next_task has migrated.
 		 *
 		 * We need to make sure that the task is still on the same
@@ -1436,12 +1437,11 @@ retry:
 		task = pick_next_pushable_task(rq);
 		if (task_cpu(next_task) == rq->cpu && task == next_task) {
 			/*
-			 * If we get here, the task hasn't moved at all, but
-			 * it has failed to push.  We will not try again,
-			 * since the other cpus will pull from us when they
-			 * are ready.
+			 * The task hasn't migrated, and is still the next
+			 * eligible task, but we failed to find a run-queue
+			 * to push it to.  Do not retry in this case, since
+			 * other cpus will pull from us when ready.
 			 */
-			dequeue_pushable_task(rq, next_task);
 			goto out;
 		}
 
@@ -1460,6 +1460,7 @@ retry:
 	deactivate_task(rq, next_task, 0);
 	set_task_cpu(next_task, lowest_rq->cpu);
 	activate_task(lowest_rq, next_task, 0);
+	ret = 1;
 
 	resched_task(lowest_rq->curr);
 
@@ -1468,7 +1469,7 @@ retry:
 out:
 	put_task_struct(next_task);
 
-	return 1;
+	return ret;
 }
 
 static void push_rt_tasks(struct rq *rq)
