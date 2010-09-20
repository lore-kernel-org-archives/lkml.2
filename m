Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0ITH1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 03:27:45 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:42079 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab0ITH1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 03:27:44 -0400
Date: Mon, 20 Sep 2010 09:27:34 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH 2/6] Add IRQ_TIME_ACCOUNTING, finer accounting of CPU
 irq time
Message-ID: <20100920092734.3f46af9f@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1284897666.2275.638.camel@laptop>
References: <1284688596-6731-1-git-send-email-venki@google.com>
	<1284688596-6731-3-git-send-email-venki@google.com>
	<1284895291.2275.617.camel@laptop>
	<1284897666.2275.638.camel@laptop>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Sep 2010 14:01:06 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, 2010-09-19 at 13:21 +0200, Peter Zijlstra wrote:
> > On Thu, 2010-09-16 at 18:56 -0700, Venkatesh Pallipadi wrote:
> > > +void account_system_vtime(struct task_struct *tsk)
> > > +{
> > > +       unsigned long flags;
> > > +       int cpu;
> > > +       u64 now, delta;
> > > +
> > > +       if (!sched_clock_irqtime)
> > > +               return;
> > > +
> > > +       local_irq_save(flags);
> > > +
> > > +       cpu = task_cpu(tsk);
> > > +       now = sched_clock();
> > > +       delta = now - per_cpu(irq_start_time, cpu);
> > > +       per_cpu(irq_start_time, cpu) = now;
> > > +       if (hardirq_count())
> > > +               per_cpu(cpu_hardirq_time, cpu) += delta;
> > > +       else if (softirq_count())
> > > +               per_cpu(cpu_softirq_time, cpu) += delta;
> > > +
> > > +       local_irq_restore(flags);
> > > +} 
> > 
> > This seems to suggest you count time double if a hardirq hits while
> > we're doing softirqs, but being as this is an incomplete api its very
> > hard to tell indeed.
> 
> OK, so by virtue of calling the same function on _enter and _exit its
> not incomplete, just weird.

That is the same with CONFIG_VIRT_CPU_ACCOUNTING=y. irq_enter/irq_exit
call account_system_vtime, the function then uses the preempt/softirq/
hardirq counter to find out which context is currently active.

> And it won't account time double, since it uses irq_start_time to
> compute deltas between invocations and will attribute that delta to only
> one state.

irq_start_time is a bit misleading, it is a time stamp of the last update.
The confusing part (which deserves a comment) is the fact that the delta
is not added to anything if hardirq_count and softirq_count are zero.

> You still do have the problem with local_bh_disable() though, since you
> cannot distinguish between having bh disabled and processing softirq.
> 
> So a hardirq that hits while you have bh disabled will inflate your
> softirq time.
> 
> A possible solution is to have local_bh_{disable,enable} {add,sub}
> 2*SOFTIRQ_OFFSET and have the processing use SOFTIRQ_OFFSET, will need a
> bit of a code shuffle though.

Hmm, that bug is valid for CONFIG_VIRT_CPU_ACCOUNTING=y as well.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

