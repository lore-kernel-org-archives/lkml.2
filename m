Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab1I0Vc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:32:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40119 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab1I0Vc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:32:26 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=nQprncItfQAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=Fc3CewhUazVnC09OsnUA:9 a=yhCITUyxZqCtgQIjo74A:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH v2 3/3][RT] sched: Have migrate_disable ignore bounded
 threads
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <htejun@gmail.com>
Date: Tue, 27 Sep 2011 17:32:25 -0400
In-Reply-To: <20110927124423.567944215@goodmis.org>
References: <20110927124022.484200394@goodmis.org>
	 <20110927124423.567944215@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317159146.26514.57.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 08:40 -0400, Steven Rostedt wrote:
> plain text document attachment
> (peterz-migrate-disable-thread-bound.patch)
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>


Thomas,

Hold off on this patch until we get the kworker/u straighten out. I'm
retesting with the following change:

@@ -1383,7 +1384,7 @@ static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
        if (bind && !on_unbound_cpu)
                kthread_bind(worker->task, gcwq->cpu);
        else {
-               worker->task->flags |= PF_THREAD_BOUND;
+//             worker->task->flags |= PF_THREAD_BOUND;
                if (on_unbound_cpu)
                        worker->flags |= WORKER_UNBOUND;
        }

So far, so good.

-- Steve

> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Index: linux-rt.git/kernel/sched.c
> ===================================================================
> --- linux-rt.git.orig/kernel/sched.c
> +++ linux-rt.git/kernel/sched.c
> @@ -4247,7 +4247,7 @@ void migrate_disable(void)
>  {
>  	struct task_struct *p = current;
>  
> -	if (in_atomic()) {
> +	if (in_atomic() || p->flags & PF_THREAD_BOUND) {
>  #ifdef CONFIG_SCHED_DEBUG
>  		p->migrate_disable_atomic++;
>  #endif
> @@ -4278,7 +4278,7 @@ void migrate_enable(void)
>  	unsigned long flags;
>  	struct rq *rq;
>  
> -	if (in_atomic()) {
> +	if (in_atomic() || p->flags & PF_THREAD_BOUND) {
>  #ifdef CONFIG_SCHED_DEBUG
>  		p->migrate_disable_atomic--;
>  #endif
> @@ -4299,26 +4299,21 @@ void migrate_enable(void)
>  
>  	if (unlikely(migrate_disabled_updated(p))) {
>  		/*
> -		 * See comment in update_migrate_disable() about locking.
> +		 * Undo whatever update_migrate_disable() did, also see there
> +		 * about locking.
>  		 */
>  		rq = this_rq();
>  		raw_spin_lock_irqsave(&rq->lock, flags);
> -		mask = tsk_cpus_allowed(p);
> +
>  		/*
>  		 * Clearing migrate_disable causes tsk_cpus_allowed to
>  		 * show the tasks original cpu affinity.
>  		 */
>  		p->migrate_disable = 0;
> -
> -		WARN_ON(!cpumask_test_cpu(smp_processor_id(), mask));
> -
> -		if (unlikely(!cpumask_equal(&p->cpus_allowed, mask))) {
> -			/* Get the mask now that migration is enabled */
> -			mask = tsk_cpus_allowed(p);
> -			if (p->sched_class->set_cpus_allowed)
> -				p->sched_class->set_cpus_allowed(p, mask);
> -			p->rt.nr_cpus_allowed = cpumask_weight(mask);
> -		}
> +		mask = tsk_cpus_allowed(p);
> +		if (p->sched_class->set_cpus_allowed)
> +			p->sched_class->set_cpus_allowed(p, mask);
> +		p->rt.nr_cpus_allowed = cpumask_weight(mask);
>  		raw_spin_unlock_irqrestore(&rq->lock, flags);
>  	} else
>  		p->migrate_disable = 0;


