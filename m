Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab1GOOmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:42:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43789 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab1GOOmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:42:36 -0400
MIME-Version: 1.0
Date: Fri, 15 Jul 2011 22:42:34 +0800
Message-ID: <CAJd=RBCVy6SCpdamCghNCysVi_aEpdkhngkOYj+-VrU8h38gkA@mail.gmail.com>
Subject: [RFC] sched: clean up RT task_woken
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven

Cleanup is made for task_woken_rt(), as the following

#1 p->rt.nr_cpus_allowed > 1
Since @rq is checked to has pushable tasks, @p is covered by the check.
And if only @p is considered to be pushed, @p may be not the highest next.

#2 rt_task(rq->curr)
Since curr is checked not to be rescheduled, curr must be RT task.

#3 rq->curr->rt.nr_cpus_allowed < 2
Since running task is never pushed even if pushable.

#4 rq->curr->prio < p->prio
Since curr is checked not to be rescheduled.


Hillf
---
 kernel/sched_rt.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 97540f0..7e6349f 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1577,11 +1577,7 @@ static void task_woken_rt(struct rq *rq, struct
task_struct *p)
 {
 	if (!task_running(rq, p) &&
 	    !test_tsk_need_resched(rq->curr) &&
-	    has_pushable_tasks(rq) &&
-	    p->rt.nr_cpus_allowed > 1 &&
-	    rt_task(rq->curr) &&
-	    (rq->curr->rt.nr_cpus_allowed < 2 ||
-	     rq->curr->prio < p->prio))
+	    has_pushable_tasks(rq))
 		push_rt_tasks(rq);
 }
