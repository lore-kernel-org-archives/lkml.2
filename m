Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab1A2BFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 20:05:44 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:30076 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab1A2BFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 20:05:43 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zzbb2dK1432N98dN78fbkzz1202hzzz2fh2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D4367CA.2030303@am.sony.com>
Date: Fri, 28 Jan 2011 17:05:14 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 14/18] sched: Remove rq->lock from the first half
 of ttwu()
References: <20110104145929.772813816@chello.nl> <20110104150103.012710349@chello.nl>
In-Reply-To: <20110104150103.012710349@chello.nl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/11 06:59, Peter Zijlstra wrote:
> Currently ttwu() does two rq->lock acquisitions, once on the task's
> old rq, holding it over the p->state fiddling and load-balance pass.
> Then it drops the old rq->lock to acquire the new rq->lock.
> 
> By having serialized ttwu(), p->sched_class, p->cpus_allowed with
> p->pi_lock, we can now drop the whole first rq->lock acquisition.
> 
> The p->pi_lock serializing concurrent ttwu() calls protects p->state,
> which we will set to TASK_WAKING to bridge possible p->pi_lock to
> rq->lock gaps and serialize set_task_cpu() calls against
> task_rq_lock().
> 
> The p->pi_lock serialization of p->sched_class allows us to call
> scheduling class methods without holding the rq->lock, and the
> serialization of p->cpus_allowed allows us to do the load-balancing
> bits without races.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c      |   47 +++++++++++++++++++----------------------------
>  kernel/sched_fair.c |    3 +--
>  2 files changed, 20 insertions(+), 30 deletions(-)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2436,69 +2436,60 @@ ttwu_post_activation(struct task_struct 
>   * Returns %true if @p was woken up, %false if it was already running
>   * or @state didn't match @p's state.
>   */
> -static int try_to_wake_up(struct task_struct *p, unsigned int state,
> -			  int wake_flags)
> +static int
> +try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>  {
> -	int cpu, orig_cpu, this_cpu, success = 0;
> +	int cpu, this_cpu, success = 0;
>  	unsigned long flags;
> -	unsigned long en_flags = ENQUEUE_WAKEUP;
>  	struct rq *rq;
>  
>  	this_cpu = get_cpu();
>  
>  	smp_wmb();
>  	raw_spin_lock_irqsave(&p->pi_lock, flags);
> -	rq = __task_rq_lock(p);
>  	if (!(p->state & state))
>  		goto out;
>  
>  	cpu = task_cpu(p);
>  
> -	if (p->on_rq)
> -		goto out_running;
> +	if (p->on_rq) {
> +		rq = __task_rq_lock(p);
> +		if (p->on_rq)
> +			goto out_running;
> +		__task_rq_unlock(rq);
> +	}
>  
> -	orig_cpu = cpu;
>  #ifdef CONFIG_SMP
> -	if (unlikely(task_running(rq, p)))
> -		goto out_activate;

I think this while (p->on_cpu) can lead to a deadlock.  I'll explain at the
bottom of this email.

> +	while (p->on_cpu)
> +		cpu_relax();


>  
>  	p->sched_contributes_to_load = !!task_contributes_to_load(p);
>  	p->state = TASK_WAKING;
>  
> -	if (p->sched_class->task_waking) {
> +	if (p->sched_class->task_waking)
>  		p->sched_class->task_waking(p);
> -		en_flags |= ENQUEUE_WAKING;
> -	}
>  
>  	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
> -	if (cpu != orig_cpu)
> -		set_task_cpu(p, cpu);
> -	__task_rq_unlock(rq);
> +#endif /* CONFIG_SMP */
>  
>  	rq = cpu_rq(cpu);
>  	raw_spin_lock(&rq->lock);
>  
> -	/*
> -	 * We migrated the task without holding either rq->lock, however
> -	 * since the task is not on the task list itself, nobody else
> -	 * will try and migrate the task, hence the rq should match the
> -	 * cpu we just moved it to.
> -	 */
> -	WARN_ON(task_cpu(p) != cpu);
> -	WARN_ON(p->state != TASK_WAKING);
> +#ifdef CONFIG_SMP
> +	if (cpu != task_cpu(p))
> +		set_task_cpu(p, cpu);
>  
>  	if (p->sched_contributes_to_load)
>  		rq->nr_uninterruptible--;
> +#endif
>  
> -out_activate:
> -#endif /* CONFIG_SMP */
> -	activate_task(rq, p, en_flags);
> +	activate_task(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
>  out_running:
>  	ttwu_post_activation(p, rq, wake_flags);
>  	ttwu_stat(rq, p, cpu, wake_flags);
>  	success = 1;
> -out:
>  	__task_rq_unlock(rq);
> +out:
>  	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
>  	put_cpu();

The deadlock can occur if __ARCH_WANT_UNLOCKED_CTXSW and
__ARCH_WANT_INTERRUPTS_ON_CTXSW are defined.

A task sets p->state = TASK_UNINTERRUPTIBLE, then calls schedule().

schedule()
   prev->on_rq = 0
   context_switch()
      prepare_task_switch()
         prepare_lock_switch()
            raw_spin_unlock_irq(&rq->lock)

At this point, a pending interrupt (on this same cpu) is handled.
The interrupt handling results in a call to try_to_wake_up() on the
current process.  The try_to_wake_up() gets into:

   while (p->on_cpu)
      cpu_relax();

and spins forever.  This is because "prev->on_cpu = 0" slightly
after this point at:

   finish_task_switch()
      finish_lock_switch()
         prev->on_cpu = 0


One possible fix would be to get rid of __ARCH_WANT_INTERRUPTS_ON_CTXSW.
I don't suspect the reaction to that suggestion will be very positive...

Another fix might be:

   while (p->on_cpu) {
      if (p == current)
         goto out_activate;
      cpu_relax();
      }

   Then add back in the out_activate label.

I don't know if the second fix is good -- I haven't thought out how
it impacts the later patches in the series.

-Frank

