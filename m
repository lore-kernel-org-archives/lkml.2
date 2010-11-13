Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab0KMUGf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 15:06:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478Ab0KMUGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 15:06:34 -0500
Date: Sat, 13 Nov 2010 20:58:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Raistlin <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 06/22] sched: SCHED_DEADLINE handles spacial
	kthreads
Message-ID: <20101113195857.GA11411@redhat.com>
References: <1288333128.8661.137.camel@Palantir> <1288333876.8661.147.camel@Palantir> <1289486096.2084.123.camel@laptop> <20101111152750.GA2510@redhat.com> <1289490202.2084.140.camel@laptop> <20101111163242.GA5697@redhat.com> <1289673355.2109.79.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289673355.2109.79.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13, Peter Zijlstra wrote:
>
> Something like so?.. hasn't even seen a compiler yet but one's got to do
> something to keep the worst bore of saturday night telly in check ;-)

Yes, I _think_ this all can work (and imho makes a lot of sense
if it works).

quick and dirty review below ;)

>  struct take_cpu_down_param {
> -	struct task_struct *caller;
>  	unsigned long mod;
>  	void *hcpu;
>  };
> @@ -208,11 +207,6 @@ static int __ref take_cpu_down(void *_pa
>
>  	cpu_notify(CPU_DYING | param->mod, param->hcpu);
>
> -	if (task_cpu(param->caller) == cpu)
> -		move_task_off_dead_cpu(cpu, param->caller);
> -	/* Force idle task to run as soon as we yield: it should
> -	   immediately notice cpu is offline and die quickly. */
> -	sched_idle_next();

Yes. but we should remove "while (!idle_cpu(cpu))" from _cpu_down().

> @@ -2381,18 +2381,15 @@ static int select_fallback_rq(int cpu, s
>  		return dest_cpu;
>
>  	/* No more Mr. Nice Guy. */
> -	if (unlikely(dest_cpu >= nr_cpu_ids)) {
> -		dest_cpu = cpuset_cpus_allowed_fallback(p);
> -		/*
> -		 * Don't tell them about moving exiting tasks or
> -		 * kernel threads (both mm NULL), since they never
> -		 * leave kernel.
> -		 */
> -		if (p->mm && printk_ratelimit()) {
> -			printk(KERN_INFO "process %d (%s) no "
> -			       "longer affine to cpu%d\n",
> -			       task_pid_nr(p), p->comm, cpu);
> -		}
> +	dest_cpu = cpuset_cpus_allowed_fallback(p);
> +	/*
> +	 * Don't tell them about moving exiting tasks or
> +	 * kernel threads (both mm NULL), since they never
> +	 * leave kernel.
> +	 */
> +	if (p->mm && printk_ratelimit()) {
> +		printk(KERN_INFO "process %d (%s) no longer affine to cpu%d\n",
> +				task_pid_nr(p), p->comm, cpu);
>  	}

Hmm. I was really puzzled until I realized this is just cleanup,
we can't reach this point if dest_cpu < nr_cpu_ids.

> +static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
>  {
>  	struct rq *rq = cpu_rq(dead_cpu);
> +	int needs_cpu, uninitialized_var(dest_cpu);
>
> -	/* Must be exiting, otherwise would be on tasklist. */
> -	BUG_ON(!p->exit_state);
> -
> -	/* Cannot have done final schedule yet: would have vanished. */
> -	BUG_ON(p->state == TASK_DEAD);
> -
> -	get_task_struct(p);
> +	needs_cpu = (task_cpu(p) == dead_cpu) && (p->state != TASK_WAKING);
> +	if (needs_cpu)
> +		dest_cpu = select_fallback_rq(dead_cpu, p);
> +	raw_spin_unlock(&rq->lock);

Probably we do not need any checks. This task was picked by
->pick_next_task(), it should have task_cpu(p) == dead_cpu ?

But. I think there is a problem. We should not migrate current task,
stop thread, which does the migrating. At least, sched_stoptask.c
doesn't implement ->enqueue_task() and we can never wake it up later
for kthread_stop().

Perhaps migrate_tasks() should do for_each_class() by hand to
ignore stop_sched_class. But then _cpu_down() should somewhow
ensure the stop thread on the dead CPU is already parked in
schedule().

> -	case CPU_DYING_FROZEN:
>  		/* Update our root-domain */
>  		raw_spin_lock_irqsave(&rq->lock, flags);
>  		if (rq->rd) {
>  			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
>  			set_rq_offline(rq);
>  		}
> +		migrate_tasks(cpu);
> +		BUG_ON(rq->nr_running != 0);
>  		raw_spin_unlock_irqrestore(&rq->lock, flags);

Probably we don't really need rq->lock. All cpus run stop threads.

I am not sure about rq->idle, perhaps it should be deactivated.
I don't think we should migrate it.


What I never understood is the meaning of play_dead/etc. If we
remove sched_idle_next(), who will do that logic? And how the
idle thread can call idle_task_exit() ?

Oleg.

