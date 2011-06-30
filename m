Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab1F3MrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:47:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36876 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1F3MrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:47:04 -0400
MIME-Version: 1.0
Date: Thu, 30 Jun 2011 20:47:03 +0800
Message-ID: <BANLkTikH9cdO+bwNN4kGgisP6RCy2Xo-3g@mail.gmail.com>
Subject: [RFC] sched: check RT runqueue overloaded in tick timer
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven

When tick timer runs, runqueue overload is checked. If overloaded and other
CPUs available at the moment, reschedule is fired to allow push logic to move
the pushable tasks somewhere else.

Thanks

Hillf
---
 kernel/sched_rt.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index b03cd89..afd29a3 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1767,10 +1767,10 @@ static void task_tick_rt(struct rq *rq, struct
task_struct *p, int queued)
 	 * FIFO tasks have no timeslices.
 	 */
 	if (p->policy != SCHED_RR)
-		return;
+		goto check_overload;

 	if (--p->rt.time_slice)
-		return;
+		goto check_overload;

 	p->rt.time_slice = DEF_TIMESLICE;

@@ -1782,6 +1782,23 @@ static void task_tick_rt(struct rq *rq, struct
task_struct *p, int queued)
 		requeue_task_rt(rq, p, 0);
 		set_tsk_need_resched(p);
 	}
+
+check_overload:
+#ifdef CONFIG_SMP
+	if (!test_tsk_need_resched(p)) {
+		struct task_struct *t = pick_next_pushable_task(rq);
+		/*
+		 * If @rq overloaded and other CPUs available, reschedule
+		 * @p to allow the push logic to move the pushable tasks
+		 * somewhere else.
+		 *
+		 * It is a pseudo schedule, since @p, without accident, will
+		 * be picked again. If not, fine:)
+		 */
+		if (t && cpupri_find(&rq->rd->cpupri, t, NULL))
+			set_tsk_need_resched(p);
+	}
+#endif
 }

 static void set_curr_task_rt(struct rq *rq)
