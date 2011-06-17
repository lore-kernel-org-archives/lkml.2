Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab1FQB73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:59:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60224 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906Ab1FQB7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:59:20 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=0MSzRat0NCgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=YBXsO_p9AAAA:8 a=meVymXHHAAAA:8 a=H0WPwCuUaOCX07Hx6E0A:9 a=oXyNN2YfI6mDUnGrRzoA:7 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=_RhRFcbxBZMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110617015919.136959032@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 16 Jun 2011 21:55:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Yong Zhang <yong.zhang0@gmail.com>, Hillf Danton <dhillf@gmail.com>,
        Mike Galbraith <mgalbraith@gmx.de>
Subject: [RFC][PATCH 4/7] sched, rt: Fix rq->rt.pushable_tasks bug in push_rt_task()
References: <20110617015516.301117218@goodmis.org>
Content-Disposition: inline; filename=0004-sched-rt-Fix-rq-rt.pushable_tasks-bug-in-push_rt_tas.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hillf Danton <dhillf@gmail.com>

Do not call dequeue_pushable_task() when failing to push an eligible
task, as it remains pushable, merely not at this particular moment.

Cc: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Mike Galbraith <mgalbraith@gmx.de>
Link: http://lkml.kernel.org/r/1306895385.4791.26.camel@marge.simson.net
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched_rt.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a6f1f64..7737d41 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1378,6 +1378,7 @@ static int push_rt_task(struct rq *rq)
 {
 	struct task_struct *next_task;
 	struct rq *lowest_rq;
+	int ret = 0;
 
 	if (!rq->rt.overloaded)
 		return 0;
@@ -1410,7 +1411,7 @@ retry:
 	if (!lowest_rq) {
 		struct task_struct *task;
 		/*
-		 * find lock_lowest_rq releases rq->lock
+		 * find_lock_lowest_rq releases rq->lock
 		 * so it is possible that next_task has migrated.
 		 *
 		 * We need to make sure that the task is still on the same
@@ -1420,12 +1421,11 @@ retry:
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
 
@@ -1444,6 +1444,7 @@ retry:
 	deactivate_task(rq, next_task, 0);
 	set_task_cpu(next_task, lowest_rq->cpu);
 	activate_task(lowest_rq, next_task, 0);
+	ret = 1;
 
 	resched_task(lowest_rq->curr);
 
@@ -1452,7 +1453,7 @@ retry:
 out:
 	put_task_struct(next_task);
 
-	return 1;
+	return ret;
 }
 
 static void push_rt_tasks(struct rq *rq)
-- 
1.7.4.4


