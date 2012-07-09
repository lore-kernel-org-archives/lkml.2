Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab2GIMXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:23:33 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49247 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab2GIMXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:23:32 -0400
MIME-Version: 1.0
Date: Mon, 9 Jul 2012 20:23:31 +0800
Message-ID: <CAJd=RBBok=g7WS5EAtE3sQyLtCKfn4h8rxQn9bAsDHnqPq8_mg@mail.gmail.com>
Subject: [patch] BFS 421-1: fix yield_to
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The time slice of local runqueue is bogus but updated in the main
schedule function.

SOB: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched/bfs.c	Mon Jul  9 20:05:00 2012
+++ b/kernel/sched/bfs.c	Mon Jul  9 20:06:00 2012
@@ -4634,21 +4634,16 @@ EXPORT_SYMBOL(yield);
 bool __sched yield_to(struct task_struct *p, bool preempt)
 {
 	unsigned long flags;
-	bool yielded = 0;
+	bool yielded = false;
 	struct rq *rq;

 	rq = this_rq();
 	grq_lock_irqsave(&flags);
 	if (task_running(p) || p->state)
 		goto out_unlock;
-	yielded = 1;
+	yielded = true;
 	if (p->deadline > rq->rq_deadline)
 		p->deadline = rq->rq_deadline;
-	p->time_slice += rq->rq_time_slice;
-	rq->rq_time_slice = 0;
-	if (p->time_slice > timeslice())
-		p->time_slice = timeslice();
-	set_tsk_need_resched(rq->curr);
 out_unlock:
 	grq_unlock_irqrestore(&flags);

--
