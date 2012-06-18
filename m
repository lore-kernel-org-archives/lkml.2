Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab2FRG6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:58:01 -0400
Received: from ozlabs.org ([203.10.76.45]:38695 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab2FRG57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:57:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 5/5] infiniband: ehca: Use hotplug thread infrastructure
In-Reply-To: <20120613105815.416416492@linutronix.de>
References: <20120613102823.373180763@linutronix.de> <20120613105815.416416492@linutronix.de>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 18 Jun 2012 16:00:16 +0930
Message-ID: <87y5nlyvwn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012 11:00:56 -0000, Thomas Gleixner <tglx@linutronix.de> wrote:
> @@ -662,10 +663,15 @@ static inline int find_next_online_cpu(s
>  		ehca_dmp(cpu_online_mask, cpumask_size(), "");
>  
>  	spin_lock_irqsave(&pool->last_cpu_lock, flags);
> -	cpu = cpumask_next(pool->last_cpu, cpu_online_mask);
> -	if (cpu >= nr_cpu_ids)
> -		cpu = cpumask_first(cpu_online_mask);
> -	pool->last_cpu = cpu;
> +	while (1) {
> +		cpu = cpumask_next(pool->last_cpu, cpu_online_mask);
> +		if (cpu >= nr_cpu_ids)
> +			cpu = cpumask_first(cpu_online_mask);
> +		pool->last_cpu = cpu;
> +		/* Might be on the way out */
> +		if (per_cpu_ptr(pool->cpu_comp_tasks, cpu)->active)
> +			break;
> +	}

Heh, isn't this what we used to call a "do while" loop? :)

Your infrastructure is a really weird mix.  On the one hand, it's a set
of callbacks: setup, cleanup, park, unpark.  Cool.

On the other hand, instead of a 'run' callback, you've got a thread_fn,
which has to loop and call smpboot_thread_check_parking().

If you just had the thread_fn, it'd be trivial to follow program flow.
If you just had the callbacks, it'd still be pretty easy, though it
seems like a little too much help.

As it is, we have Paul doing setup stuff inside his thread_fn:

     +	trace_rcu_utilization("Start CPU kthread@unpark");
     +	sp.sched_priority = RCU_KTHREAD_PRIO;
     +	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);

I'm just not sure this complexity wins us anything.  Why not
just let people "register_percpu_kthread" and make the thread_fn
identical to normal kthread fns:

        while (!kthread_should_stop()) {
                if (kthread_should_park()) {
                        kthread_parkme();
                        continue;
                }

Maybe implement a 'bool kthread_stop_or_park()' helper.

I'll whip up a patch on top of yours if you don't think it's crazy...

Cheers,
Rusty.
