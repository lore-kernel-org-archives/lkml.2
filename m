Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2FHNhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:37:54 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50697 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2FHNhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:37:52 -0400
MIME-Version: 1.0
Date: Fri, 8 Jun 2012 21:37:51 +0800
Message-ID: <CAJd=RBDWg9Wa_4s7NBeyXy23wh4CFyKzoF83EBEm1a6w=v+KUw@mail.gmail.com>
Subject: [patch] BFS 421: remove global runqueue lock in running tick
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We simply deschedule current, with no bother grabbing global lock, since IPI,
if triggered by preempt, could not change our result, like no schedule when
preempt enabled.

	preempt_enable_no_resched();
	if (unlikely(need_resched()))
		goto need_resched;


--- a/kernel/sched/bfs.c	Wed Jun  6 21:02:50 2012
+++ b/kernel/sched/bfs.c	Fri Jun  8 21:17:24 2012
@@ -2784,11 +2784,13 @@ static void task_running_tick(struct rq
 	} else if (rq->rq_time_slice >= RESCHED_US)
 			return;

-	/* p->time_slice < RESCHED_US. We only modify task_struct under grq lock */
+	/*
+	 * With irq disabled, current is descheduled without global lock
+	 * held and IPI cared.
+	 */
 	p = rq->curr;
-	grq_lock();
-	set_tsk_need_resched(p);
-	grq_unlock();
+	if (!test_tsk_need_resched(p))
+		set_tsk_need_resched(p);
 }


--
