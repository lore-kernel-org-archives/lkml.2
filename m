Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab2LVBAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 20:00:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab2LVBAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:00:07 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ePhhQ-jjglUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=FSxFJ-fzXMMA:10 a=aHx-hnuUDjrVtaKEUHAA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1356138005.5896.120.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH 1/2] sched: Move idle_balance() to post_schedule
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Clark Williams <clark.williams@gmail.com>
Date: Fri, 21 Dec 2012 20:00:05 -0500
In-Reply-To: <20121222005430.997442088@goodmis.org>
References: <20121222003019.433916240@goodmis.org>
	 <20121222005430.997442088@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
So much for saying it was well tested. As my email box is separate from
the development boxes, I didn't copy the write set of patches over. This
patch was tested thoroughly on 40 core and 4 core, but not UP. The UP
had some bugs that were fixed (but not sent :-p)

Here's the correct patch with the UP fixes. The other patch shouldn't be
affected.
---

sched: Move idle_balance() to post_schedule

The idle_balance() code is called to do task load balancing just before
going to idle. This makes sense as the CPU is about to sleep anyway.
But currently it's called in the middle of the scheduler and in a place
that must have interrupts disabled. That means, while the load balancing
is going on, if a task wakes up on this CPU, it wont get to run while
the interrupts are disabled. The idle task doing the balancing will be
clueless about it.

There's no real reason that the idle_balance() needs to be called in the
middle of schedule anyway. The only benefit is that if a task is pulled
to this CPU, it can be scheduled without the need to schedule the idle
task. But load balancing and migrating the task makes a switch to idle
and back negligible.

By using the post_schedule function pointer of the sched class, the
unlikely branch in the hot path of the scheduler can be removed, and
the idle task itself can do the load balancing.

Another advantage of this, is that by moving the idle_balance to the
post_schedule routine, interrupts can now be enabled in the load balance
allowing for interrupts and wakeups to still occur on that CPU while a
balance is taking place. The enabling of interrupts will come as a separate
patch.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-trace.git/kernel/sched/core.c
===================================================================
--- linux-trace.git.orig/kernel/sched/core.c
+++ linux-trace.git/kernel/sched/core.c
@@ -2926,9 +2926,6 @@ need_resched:
 
 	pre_schedule(rq, prev);
 
-	if (unlikely(!rq->nr_running))
-		idle_balance(cpu, rq);
-
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
 	clear_tsk_need_resched(prev);
Index: linux-trace.git/kernel/sched/idle_task.c
===================================================================
--- linux-trace.git.orig/kernel/sched/idle_task.c
+++ linux-trace.git/kernel/sched/idle_task.c
@@ -13,6 +13,11 @@ select_task_rq_idle(struct task_struct *
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
+
+static void post_schedule_idle(struct rq *rq)
+{
+	idle_balance(smp_processor_id(), rq);
+}
 #endif /* CONFIG_SMP */
 /*
  * Idle tasks are unconditionally rescheduled:
@@ -25,6 +30,10 @@ static void check_preempt_curr_idle(stru
 static struct task_struct *pick_next_task_idle(struct rq *rq)
 {
 	schedstat_inc(rq, sched_goidle);
+#ifdef CONFIG_SMP
+	/* Trigger the post schedule to do an idle_balance */
+	rq->post_schedule = 1;
+#endif
 	return rq->idle;
 }
 
@@ -86,6 +95,7 @@ const struct sched_class idle_sched_clas
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_idle,
+	.post_schedule		= post_schedule_idle,
 #endif
 
 	.set_curr_task          = set_curr_task_idle,


