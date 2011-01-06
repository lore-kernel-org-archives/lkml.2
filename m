Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab1AFN5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 08:57:34 -0500
Received: from canuck.infradead.org ([134.117.69.58]:37969 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1AFN5d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 08:57:33 -0500
Subject: Re: [RFC][PATCH 07/18] sched: Drop the rq argument to
 sched_class::select_task_rq()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>
Cc: Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20110104150102.661650041@chello.nl>
References: <20110104145929.772813816@chello.nl>
	 <20110104150102.661650041@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 06 Jan 2011 14:57:40 +0100
Message-ID: <1294322260.2016.332.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 15:59 +0100, Peter Zijlstra wrote:
> Index: linux-2.6/kernel/sched_rt.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_rt.c
> +++ linux-2.6/kernel/sched_rt.c
> @@ -973,11 +973,18 @@ static void yield_task_rt(struct rq *rq)
>  static int find_lowest_rq(struct task_struct *task);
>  
>  static int
> -select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
> +select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
>  {
>         if (sd_flag != SD_BALANCE_WAKE)
>                 return smp_processor_id();
>  
> +#if 0
> +       /*
> +        * XXX without holding rq->lock the below is racy, need to
> +        * rewrite it in a racy but non-dangerous way so that we mostly
> +        * get the benefit of the heuristic but don't crash the kernel
> +        * if we get it wrong ;-)
> +        */
>         /*
>          * If the current task is an RT task, then
>          * try to see if we can wake this RT task up on another
> @@ -1002,6 +1009,7 @@ select_task_rq_rt(struct rq *rq, struct 
>  
>                 return (cpu == -1) ? task_cpu(p) : cpu;
>         }
> +#endif
>  
>         /*
>          * Otherwise, just let it ride on the affined RQ and the 


How about something like so?

---
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -975,18 +975,21 @@ static int find_lowest_rq(struct task_st
 static int
 select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 {
+	struct task_struct *curr;
+	struct rq *rq;
+	int cpu;
+
 	if (sd_flag != SD_BALANCE_WAKE)
 		return smp_processor_id();
 
-#if 0
-	/*
-	 * XXX without holding rq->lock the below is racy, need to
-	 * rewrite it in a racy but non-dangerous way so that we mostly
-	 * get the benefit of the heuristic but don't crash the kernel
-	 * if we get it wrong ;-)
-	 */
+	cpu = task_cpu(p);
+	rq = cpu_rq(cpu);
+
+	rcu_read_lock();
+	curr = rcu_dereference(rq->curr); /* unlocked access */
+
 	/*
-	 * If the current task is an RT task, then
+	 * If the current task on @p's runqueue is an RT task, then
 	 * try to see if we can wake this RT task up on another
 	 * runqueue. Otherwise simply start this RT task
 	 * on its current runqueue.
@@ -1000,22 +1003,25 @@ select_task_rq_rt(struct task_struct *p,
 	 * lock?
 	 *
 	 * For equal prio tasks, we just let the scheduler sort it out.
+	 *
+	 * Otherwise, just let it ride on the affined RQ and the
+	 * post-schedule router will push the preempted task away
+	 *
+	 * This test is optimistic, if we get it wrong the load-balancer
+	 * will have to sort it out.
 	 */
-	if (unlikely(rt_task(rq->curr)) &&
-	    (rq->curr->rt.nr_cpus_allowed < 2 ||
-	     rq->curr->prio < p->prio) &&
+	if (curr && unlikely(rt_task(curr)) &&
+	    (curr->rt.nr_cpus_allowed < 2 ||
+	     curr->prio < p->prio) &&
 	    (p->rt.nr_cpus_allowed > 1)) {
-		int cpu = find_lowest_rq(p);
+		int target = find_lowest_rq(p);
 
-		return (cpu == -1) ? task_cpu(p) : cpu;
+		if (target != -1)
+			cpu = target;
 	}
-#endif
+	rcu_read_unlock();
 
-	/*
-	 * Otherwise, just let it ride on the affined RQ and the
-	 * post-schedule router will push the preempted task away
-	 */
-	return task_cpu(p);
+	return cpu;
 }
 
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)

