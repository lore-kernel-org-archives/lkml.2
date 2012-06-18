Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab2FRIIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:08:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:47738 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab2FRIIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:08:31 -0400
Date: Mon, 18 Jun 2012 10:08:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 5/5] infiniband: ehca: Use hotplug thread
 infrastructure
In-Reply-To: <87y5nlyvwn.fsf@rustcorp.com.au>
Message-ID: <alpine.LFD.2.02.1206181003240.3086@ionos>
References: <20120613102823.373180763@linutronix.de> <20120613105815.416416492@linutronix.de> <87y5nlyvwn.fsf@rustcorp.com.au>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012, Rusty Russell wrote:

> On Wed, 13 Jun 2012 11:00:56 -0000, Thomas Gleixner <tglx@linutronix.de> wrote:
> > @@ -662,10 +663,15 @@ static inline int find_next_online_cpu(s
> >  		ehca_dmp(cpu_online_mask, cpumask_size(), "");
> >  
> >  	spin_lock_irqsave(&pool->last_cpu_lock, flags);
> > -	cpu = cpumask_next(pool->last_cpu, cpu_online_mask);
> > -	if (cpu >= nr_cpu_ids)
> > -		cpu = cpumask_first(cpu_online_mask);
> > -	pool->last_cpu = cpu;
> > +	while (1) {
> > +		cpu = cpumask_next(pool->last_cpu, cpu_online_mask);
> > +		if (cpu >= nr_cpu_ids)
> > +			cpu = cpumask_first(cpu_online_mask);
> > +		pool->last_cpu = cpu;
> > +		/* Might be on the way out */
> > +		if (per_cpu_ptr(pool->cpu_comp_tasks, cpu)->active)
> > +			break;
> > +	}
> 
> Heh, isn't this what we used to call a "do while" loop? :)

Yep :)
 
> Your infrastructure is a really weird mix.  On the one hand, it's a set
> of callbacks: setup, cleanup, park, unpark.  Cool.
> 
> On the other hand, instead of a 'run' callback, you've got a thread_fn,
> which has to loop and call smpboot_thread_check_parking().
> 
> If you just had the thread_fn, it'd be trivial to follow program flow.
> If you just had the callbacks, it'd still be pretty easy, though it
> seems like a little too much help.

The reason why I moved stuff into the callbacks and have the state
machine inside of smpboot_check_kthread_parking() is that every user
has to do that. i.e. keep track of the state so you wont
setup/teardown stuff twice.

Now look at that function and copy it into all users of the park
infrastructure. Not pretty. I had it that way and it was fugly as
hell. That's why I came up with the callbacks and the generic state
machine.
 
> As it is, we have Paul doing setup stuff inside his thread_fn:
> 
>      +	trace_rcu_utilization("Start CPU kthread@unpark");
>      +	sp.sched_priority = RCU_KTHREAD_PRIO;
>      +	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);

I fixed that already :)
 
Thanks,

	tglx
