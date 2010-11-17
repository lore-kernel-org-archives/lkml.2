Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935424Ab0KQTni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:43:38 -0500
Received: from canuck.infradead.org ([134.117.69.58]:49601 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935246Ab0KQTnh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:43:37 -0500
Subject: Re: [PATCH] sched: Simplify cpu-hot-unplug task migration
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
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
In-Reply-To: <20101117192713.GA11910@redhat.com>
References: <1289486096.2084.123.camel@laptop>
	 <20101111152750.GA2510@redhat.com> <1289490202.2084.140.camel@laptop>
	 <20101111163242.GA5697@redhat.com> <1289673355.2109.79.camel@laptop>
	 <20101113195857.GA11411@redhat.com> <1289680291.2109.244.camel@laptop>
	 <1289681497.2109.270.camel@laptop> <1289691081.2109.452.camel@laptop>
	 <1289851597.2109.547.camel@laptop>  <20101117192713.GA11910@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 20:42:34 +0100
Message-ID: <1290022954.2109.1217.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 20:27 +0100, Oleg Nesterov wrote:
> Peter, sorry for delay.
> 
> I was going to read this patch carefully today, but due to the holiday
> in the Czech Republic I have to drink (too much) beer instead ;)
> 
> This means you should probably ignore my question, but can't resist...
> 
> > -static void migrate_dead_tasks(unsigned int dead_cpu)
> > -{
> > -	struct rq *rq = cpu_rq(dead_cpu);
> > -	struct task_struct *next;
> > +	rq->stop = NULL;
> 
> (or we could do current->state = TASK_INTERRUPTIPLE, afaics)

Ah, you missed a patch that made pick_next_task_stop() look like:

static struct task_struct *pick_next_task_stop(struct rq *rq)
{
        struct task_struct *stop = rq->stop;

        if (stop && stop->se.on_rq)
                return stop;

        return NULL;
}

> >  	for ( ; ; ) {
> > -		if (!rq->nr_running)
> > +		/*
> > +		 * There's this thread running, bail when that's the only
> > +		 * remaining thread.
> > +		 */
> > +		if (rq->nr_running == 1)
> >  			break;
> 
> I was very much confused, and I was going to say this is wrong.
> However, now I think this is correct, just the comment is not
> right.
> 
> There is another running thread we should not migrate, rq->idle.
> If nothing else, dequeue_task_idle() should be never called.

In fact, dequeue_task_idle() will yell if you try that ;-)

> But, if I understand correctly, ->nr_running does not account
> the idle thread, and this is what makes this correct.
> 
> Correct?

Right, I can add: (the idle thread is not counted in nr_running), if
that makes things clearer for you; however its a quite fundamental
property, we don't consider the idle task a proper runnable entity, its
simply the thing we do when there's nothing else to do.
