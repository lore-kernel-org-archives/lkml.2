Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2DXSye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 14:54:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33970 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab2DXSyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 14:54:33 -0400
Message-ID: <1335293623.28150.216.camel@twins>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Tue, 24 Apr 2012 20:53:43 +0200
In-Reply-To: <1335293456.28106.145.camel@gandalf.stny.rr.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
	 <1334162018.23924.268.camel@gandalf.stny.rr.com>
	 <1335273316.28150.194.camel@twins>
	 <1335293456.28106.145.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 14:50 -0400, Steven Rostedt wrote:
> > Something like so: https://lkml.org/lkml/2012/2/16/487 ?
> 
> But it still does the same thing:
> 
> +static struct task_struct *
> +pick_next_task_rt(struct rq *rq, struct task_struct *prev)
>  {
> -       struct task_struct *p = _pick_next_task_rt(rq);
> +       struct task_struct *p;
> +       struct rt_rq *rt_rq = &rq->rt;
> +
> +       if (!rt_rq->rt_nr_running)
> +               return NULL;
> +
> +       if (rt_rq_throttled(rt_rq))
> +               return NULL;
> +
> +       if (prev)
> +               prev->sched_class->put_prev_task(rq, prev);
> +
> +       p = _pick_next_task_rt(rq);
> 
> Now if we can do the _pick_next_task_rt() before put_prev_task(), and
> only do the put_prev_task() if p != prev, then that would be something.

Well that's up to the implementation of pick_next_task_rt() that
conversion is just a minimal make it work thing.

But the generic changes that patch carries should allow you to do what
you want, right?
