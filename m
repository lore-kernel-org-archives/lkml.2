Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab0IHMa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 08:30:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab0IHM3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 08:29:47 -0400
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org
Cc: peterz@infradead.org, Sven-Thorsten Dietrich <sdietrich@novell.com>,
        Michael Galbraith <MGalbraith@novell.com>,
        Jan Blunck <jblunck@suse.de>
Subject: [RFC 3/4] Disable scheduler tick when we are running SCHED_FIFO tasks
Date: Wed,  8 Sep 2010 14:29:23 +0200
Message-Id: <1283948964-6418-4-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1283948964-6418-1-git-send-email-jblunck@suse.de>
References: <1283948964-6418-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is disabling the scheduler tick to go off when there is a task
with SCHED_FIFO policy running. Since these tasks are not timesliced anyway
we only care about timers, softirqs and such stuff just like when we disable
the tick during idle periods.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 kernel/sched_rt.c        |   23 +++++++++++++++++++++++
 kernel/softirq.c         |    5 +++++
 kernel/time/tick-sched.c |    7 ++++---
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 8afb953..3879ca1 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1095,6 +1095,13 @@ static struct task_struct *pick_next_task_rt(struct rq *rq)
 	rq->post_schedule = has_pushable_tasks(rq);
 #endif
 
+	if (p) {
+		/* Disable sched_tick in post_schedule later */
+		if (unlikely(rt_task(p)) && !(p->flags & PF_KTHREAD) &&
+			(p->policy == SCHED_FIFO))
+			rq->post_schedule = 1;
+	}
+
 	return p;
 }
 
@@ -1475,11 +1482,27 @@ static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 	/* Try to pull RT tasks here if we lower this rq's prio */
 	if (unlikely(rt_task(prev)) && rq->rt.highest_prio.curr > prev->prio)
 		pull_rt_task(rq);
+
+	/* Enable sched_tick again before we schedule */
+	if (unlikely(rt_task(prev)) && !(prev->flags & PF_KTHREAD) &&
+		(prev->policy == SCHED_FIFO)) {
+		tick_nohz_restart_sched_tick();
+
+		/* Disable tick in post_schedule if we don't switch */
+		rq->post_schedule = 1;
+	}
 }
 
 static void post_schedule_rt(struct rq *rq)
 {
 	push_rt_tasks(rq);
+
+	/* Disable tick if we are a FIFO task */
+	if (unlikely(rt_task(rq->curr)) &&
+	    unlikely(!local_softirq_pending()) &&
+	    !(rq->curr->flags & PF_KTHREAD) &&
+	    (rq->curr->policy == SCHED_FIFO))
+		tick_nohz_stop_sched_tick(1);
 }
 
 /*
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 07b4f1b..ff05f6a 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -307,6 +307,11 @@ void irq_exit(void)
 	/* Make sure that timer wheel updates are propagated */
 	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
 		tick_nohz_stop_sched_tick(0);
+
+	/* Disable tick if the current task is FIFO */
+	if (unlikely(rt_task(current) && !(current->flags & PF_KTHREAD) &&
+			current->policy == SCHED_FIFO))
+		tick_nohz_stop_sched_tick(1);
 #endif
 	preempt_enable_no_resched();
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 81b7398..567110d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -520,9 +520,10 @@ void tick_nohz_restart_sched_tick(void)
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	unsigned long ticks;
 #endif
+	unsigned long flags;
 	ktime_t now;
 
-	local_irq_disable();
+	local_irq_save(flags);
 	if (ts->idle_active || (ts->inidle && ts->tick_stopped))
 		now = ktime_get();
 
@@ -531,7 +532,7 @@ void tick_nohz_restart_sched_tick(void)
 
 	if (!ts->inidle || !ts->tick_stopped) {
 		ts->inidle = 0;
-		local_irq_enable();
+		local_irq_restore(flags);
 		return;
 	}
 
@@ -567,7 +568,7 @@ void tick_nohz_restart_sched_tick(void)
 
 	tick_nohz_restart(ts, now);
 
-	local_irq_enable();
+	local_irq_restore(flags);
 }
 
 static int tick_nohz_reprogram(struct tick_sched *ts, ktime_t now)
-- 
1.6.4.2

