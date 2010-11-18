Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab0KROMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:12:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757681Ab0KROMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:12:31 -0500
Date: Thu, 18 Nov 2010 15:05:15 +0100
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
Subject: Re: [PATCH] sched: Simplify cpu-hot-unplug task migration
Message-ID: <20101118140515.GA29303@redhat.com>
References: <1289490202.2084.140.camel@laptop> <20101111163242.GA5697@redhat.com> <1289673355.2109.79.camel@laptop> <20101113195857.GA11411@redhat.com> <1289680291.2109.244.camel@laptop> <1289681497.2109.270.camel@laptop> <1289691081.2109.452.camel@laptop> <1289851597.2109.547.camel@laptop> <20101117192713.GA11910@redhat.com> <1290022954.2109.1217.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290022954.2109.1217.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17, Peter Zijlstra wrote:
>
> On Wed, 2010-11-17 at 20:27 +0100, Oleg Nesterov wrote:
>
> > > -static void migrate_dead_tasks(unsigned int dead_cpu)
> > > -{
> > > -	struct rq *rq = cpu_rq(dead_cpu);
> > > -	struct task_struct *next;
> > > +	rq->stop = NULL;
> >
> > (or we could do current->state = TASK_INTERRUPTIPLE, afaics)
>
> Ah, you missed a patch that made pick_next_task_stop() look like:
>
> static struct task_struct *pick_next_task_stop(struct rq *rq)
> {
>         struct task_struct *stop = rq->stop;
>
>         if (stop && stop->se.on_rq)

Yes, thanks.

> > >  	for ( ; ; ) {
> > > -		if (!rq->nr_running)
> > > +		/*
> > > +		 * There's this thread running, bail when that's the only
> > > +		 * remaining thread.
> > > +		 */
> > > +		if (rq->nr_running == 1)
> > >  			break;
> >
> > I was very much confused, and I was going to say this is wrong.
> > However, now I think this is correct, just the comment is not
> > right.
> >
> > There is another running thread we should not migrate, rq->idle.
> > If nothing else, dequeue_task_idle() should be never called.
>
> In fact, dequeue_task_idle() will yell if you try that ;-)
>
> > But, if I understand correctly, ->nr_running does not account
> > the idle thread, and this is what makes this correct.
> >
> > Correct?
>
> Right, I can add: (the idle thread is not counted in nr_running), if
> that makes things clearer for you; however its a quite fundamental
> property,

Yes, I see now.

OK, this also explains my previous questions. I greatly misunderstood
this "small detail", starting from your initial patch. Every time I
thought you are trying to migrate rq->idle as well.

Thanks Peter. Only one question,

> @@ -253,9 +246,12 @@ static int __ref _cpu_down(unsigned int
>  	}
>  	BUG_ON(cpu_online(cpu));
>
> -	/* Wait for it to sleep (leaving idle task). */
> -	while (!idle_cpu(cpu))
> -		yield();
> +	/*
> +	 * The migration_call() CPU_DYING callback will have removed all
> +	 * runnable tasks from the cpu, there's only the idle task left now
> +	 * that the migration thread is done doing the stop_machine thing.
> +	 */
> +	BUG_ON(!idle_cpu(cpu));

I am not sure.

Yes, we know for sure rhat the only runnable task is rq->idle.
But only after migration thread calls schedule() and switches to the
idle thread.

However, I see nothing which can guarantee this. Migration thread
running on the dead cpu wakes up the caller of stop_cpus() before
it calls schedule(), _cpu_down() can check rq->curr before it was
changed.

No?



Hmm. In fact, I think it is possible that cpu_stopper_thread() can
have more cpu_stop_work's queued when __stop_machine() returns.
This has nothing to do with this patch, but I think it makes sense
to clear stopper->enabled at CPU_DYING stage as well (of course,
this needs a separate patch).

Oleg.

