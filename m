Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab0ETH2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:28:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50209 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab0ETH2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:28:43 -0400
Subject: Re: [PATCH v2] Make sure timers have migrated before killing
 migration_thread
From: Peter Zijlstra <peterz@infradead.org>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100519121356.GB15237@amitarora.in.ibm.com>
References: <20100519090557.GA15237@amitarora.in.ibm.com>
	 <1274261515.5605.10423.camel@twins>
	 <20100519121356.GB15237@amitarora.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 20 May 2010 09:28:03 +0200
Message-ID: <1274340483.5605.13161.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 17:43 +0530, Amit K. Arora wrote:
> Alternate Solution considered : Another option considered was to
> increase the priority of the hrtimer cpu offline notifier, such that it
> gets to run before scheduler's migration cpu offline notifier. In this
> way we are sure that the timers will get migrated before migration_call
> tries to kill migration_thread. But, this can have some non-obvious
> implications, suggested Srivatsa.


> On Wed, May 19, 2010 at 11:31:55AM +0200, Peter Zijlstra wrote:
> > The other problem is more urgent though, CPU_POST_DEAD runs outside of
> > the hotplug lock and thus the above becomes a race where we could
> > possible kill off the migration thread of a newly brought up cpu:
> > 
> >  cpu0 - down 2
> >  cpu1 - up 2 (allocs a new migration thread, and leaks the old one)
> >  cpu0 - post_down 2 - frees the migration thread -- oops!
> 
> Ok. So, how about adding a check in CPU_UP_PREPARE event handling too ?
> The cpuset_lock will synchronize, and thus avoid race between killing of
> migration_thread in up_prepare and post_dead events. 
> 
> Here is the updated patch. If you don't like this one too, do you mind
> suggesting an alternate approach to tackle the problem ? Thanks !

Right, so this isn't pretty at all..

Ingo, the comment near the migration_notifier says that migration_call
should happen before all else, but can you see anything that would break
if we let the timer migration happen first?

Thomas?

>  Signed-off-by: Amit Arora <aarora@in.ibm.com>
>  Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> --

For everybody who reads this, _please_ use three (3) dashes '-' to
separate the changelog from the patch, and left-align the changelog
(including all tags).

I seem to get more and more people sending patches with 2 dashes and
daft changelogs with whitespace stuffing which break my scripts.

> diff -Nuarp linux-2.6.34.org/kernel/sched.c linux-2.6.34/kernel/sched.c
> --- linux-2.6.34.org/kernel/sched.c	2010-05-18 22:56:21.000000000 -0700
> +++ linux-2.6.34/kernel/sched.c	2010-05-19 04:47:49.000000000 -0700
> @@ -5900,6 +5900,19 @@ migration_call(struct notifier_block *nf
>  
>  	case CPU_UP_PREPARE:
>  	case CPU_UP_PREPARE_FROZEN:
> +		cpuset_lock();
> +		rq = cpu_rq(cpu);
> +		/*
> +		 * Since we now kill migration_thread in CPU_POST_DEAD event,
> +		 * there may be a race here. So, lets cleanup the old
> +		 * migration_thread on the rq, if any.
> +		 */
> +		if (unlikely(rq->migration_thread)) {
> +			kthread_stop(rq->migration_thread);
> +			put_task_struct(rq->migration_thread);
> +			rq->migration_thread = NULL;
> +		}
> +		cpuset_unlock();
>  		p = kthread_create(migration_thread, hcpu, "migration/%d", cpu);
>  		if (IS_ERR(p))
>  			return NOTIFY_BAD;
> @@ -5942,14 +5955,34 @@ migration_call(struct notifier_block *nf
>  		cpu_rq(cpu)->migration_thread = NULL;
>  		break;
>  
> +	case CPU_POST_DEAD:
> +		/*
> +		 * Bring the migration thread down in CPU_POST_DEAD event,
> +		 * since the timers should have got migrated by now and thus
> +		 * we should not see a deadlock between trying to kill the
> +		 * migration thread and the sched_rt_period_timer.
> +		 */
> +		cpuset_lock();
> +		rq = cpu_rq(cpu);
> +		if (likely(rq->migration_thread)) {
> +			/*
> +			 * Its possible that this CPU was onlined (from a
> +			 * different CPU) before we reached here and
> +			 * migration_thread was cleaned-up in the
> +			 * CPU_UP_PREPARE event handling.
> +			 */
> +			kthread_stop(rq->migration_thread);
> +			put_task_struct(rq->migration_thread);
> +			rq->migration_thread = NULL;
> +		}
> +		cpuset_unlock();
> +		break;
> +
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
>  		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
>  		migrate_live_tasks(cpu);
>  		rq = cpu_rq(cpu);
> -		kthread_stop(rq->migration_thread);
> -		put_task_struct(rq->migration_thread);
> -		rq->migration_thread = NULL;
>  		/* Idle task back to normal (off runqueue, low prio) */
>  		raw_spin_lock_irq(&rq->lock);
>  		update_rq_clock(rq);

