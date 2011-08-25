Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab1HYKZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 06:25:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:49067 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab1HYKZD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 06:25:03 -0400
Subject: Re: [kernel.org users] [KORG] Panics on master backend
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frank Rowand <frank.rowand@am.sony.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
        hch <hch@infradead.org>, "yong.zhang0" <yong.zhang0@gmail.com>,
        scameron@beardog.cce.hp.com,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Jens Axboe <jaxboe@fusionio.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 25 Aug 2011 12:24:32 +0200
In-Reply-To: <20110824160806.GA12317@redhat.com>
References: <4E53ECEF.7040109@kernel.org> <1314129133.8002.102.camel@twins>
	 <20110824160806.GA12317@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314267872.27911.6.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 18:08 +0200, Oleg Nesterov wrote:
> Looking at the next emails, I guess this is already off-topic, but still...
> 
> On 08/23, Peter Zijlstra wrote:
> >
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -2630,7 +2630,6 @@ static void ttwu_queue_remote(struct task_struct *p, int cpu)
> >  		smp_send_reschedule(cpu);
> >  }
> >
> > -#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
> >  static int ttwu_activate_remote(struct task_struct *p, int wake_flags)
> >  {
> >  	struct rq *rq;
> > @@ -2647,7 +2646,6 @@ static int ttwu_activate_remote(struct task_struct *p, int wake_flags)
> >  	return ret;
> >
> >  }
> > -#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
> >  #endif /* CONFIG_SMP */
> >
> >  static void ttwu_queue(struct task_struct *p, int cpu)
> > @@ -2705,7 +2703,6 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
> >  	 * this task as prev, wait until its done referencing the task.
> >  	 */
> >  	while (p->on_cpu) {
> > -#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
> >  		/*
> >  		 * In case the architecture enables interrupts in
> >  		 * context_switch(), we cannot busy wait, since that
> > @@ -2713,11 +2710,11 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
> >  		 * tries to wake up @prev. So bail and do a complete
> >  		 * remote wakeup.
> >  		 */
> > -		if (ttwu_activate_remote(p, wake_flags))
> > +		if (cpu == smp_processor_id() &&
> 
> I think this needs "task_cpu(p) == smp_processor_id()". We can't trust
> "cpu", task_cpu() was called before ->on_rq check.

Isn't us holding ->pi_lock sufficient to stabilize task_cpu()? If its a
running task the initial ->state check would have failed, and thus its a
proper wakeup when we get here and thus ->pi_lock is serializing things.

> This task_cpu() looks really confusing imho, even if it is fine (afaics).
> Perhaps it makes sense to do
> 
> 	--- x/kernel/sched.c
> 	+++ x/kernel/sched.c
> 	@@ -2694,10 +2694,11 @@ try_to_wake_up(struct task_struct *p, un
> 			goto out;
> 	 
> 		success = 1; /* we're going to change ->state */
> 	-	cpu = task_cpu(p);
> 	 
> 	-	if (p->on_rq && ttwu_remote(p, wake_flags))
> 	+	if (p->on_rq && ttwu_remote(p, wake_flags)) {
> 	+		cpu = task_cpu(p); /* for ttwu_stat() */
> 			goto stat;
> 	+	}
> 	 
> 	 #ifdef CONFIG_SMP
> 		/*

Would result in the same problem as below...

> to make this more clear. Or even the patch below, I dunno.
> 
> Oleg.
> 
> --- x/kernel/sched.c
> +++ x/kernel/sched.c
> @@ -2446,13 +2446,14 @@ static void update_avg(u64 *avg, u64 sam
>  #endif
>  
>  static void
> -ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
> +ttwu_stat(struct task_struct *p, int wake_flags)
>  {
>  #ifdef CONFIG_SCHEDSTATS
>  	struct rq *rq = this_rq();
>  
>  #ifdef CONFIG_SMP
>  	int this_cpu = smp_processor_id();
> +	int cpu = task_cpu(p);
>  
>  	if (cpu == this_cpu) {
>  		schedstat_inc(rq, ttwu_local);
> @@ -2694,7 +2695,6 @@ try_to_wake_up(struct task_struct *p, un
>  		goto out;
>  
>  	success = 1; /* we're going to change ->state */
> -	cpu = task_cpu(p);
>  
>  	if (p->on_rq && ttwu_remote(p, wake_flags))
>  		goto stat;
> @@ -2739,7 +2739,7 @@ try_to_wake_up(struct task_struct *p, un
>  
>  	ttwu_queue(p, cpu);

Both suggestions result in the above cpu possibly being used
uninitialized for SMP=n.

>  stat:
> -	ttwu_stat(p, cpu, wake_flags);
> +	ttwu_stat(p, wake_flags);
>  out:
>  	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
>  
> @@ -2775,7 +2775,7 @@ static void try_to_wake_up_local(struct 
>  		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
>  
>  	ttwu_do_wakeup(rq, p, 0);
> -	ttwu_stat(p, smp_processor_id(), 0);
> +	ttwu_stat(p, 0);
>  out:
>  	raw_spin_unlock(&p->pi_lock);
>  }
