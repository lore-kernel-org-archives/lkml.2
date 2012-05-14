Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab2ENNTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:19:04 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61792 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab2ENNTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:19:00 -0400
MIME-Version: 1.0
Date: Mon, 14 May 2012 21:18:59 +0800
Message-ID: <CAJd=RBDAp3URro5FP=tOyuKVSEtAcmT=7GLNTuaZPn+SvJ+0JA@mail.gmail.com>
Subject: [1/3] BFS 420: correct getting rr interval
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tasks, no matter schedule policy and priority, should have the same interval,
which could be tuned with the /proc interface. Here simply feed back the knob.

--- a/kernel/sched/bfs.c	Mon May 14 20:34:42 2012
+++ b/kernel/sched/bfs.c	Mon May 14 20:42:20 2012
@@ -729,25 +729,6 @@ static inline void requeue_task(struct t
 	sched_info_queued(p);
 }

-/*
- * Returns the relative length of deadline all compared to the shortest
- * deadline which is that of nice -20.
- */
-static inline int task_prio_ratio(struct task_struct *p)
-{
-	return prio_ratios[TASK_USER_PRIO(p)];
-}
-
-/*
- * task_timeslice - all tasks of all priorities get the exact same timeslice
- * length. CPU distribution is handled by giving different deadlines to
- * tasks of different priorities. Use 128 as the base value for fast shifts.
- */
-static inline int task_timeslice(struct task_struct *p)
-{
-	return (rr_interval * task_prio_ratio(p) / 128);
-}
-
 #ifdef CONFIG_SMP
 /*
  * qnr is the "queued but not running" count which is the total number of
@@ -4824,7 +4805,7 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
 		goto out_unlock;

 	grq_lock_irqsave(&flags);
-	time_slice = p->policy == SCHED_FIFO ? 0 : MS_TO_NS(task_timeslice(p));
+	time_slice = p->policy == SCHED_FIFO ? 0 : MS_TO_NS(rr_interval);
 	grq_unlock_irqrestore(&flags);

 	rcu_read_unlock();
--
