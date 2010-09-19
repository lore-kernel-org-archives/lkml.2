Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab0ISMBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 08:01:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:34530 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab0ISMBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 08:01:18 -0400
Subject: Re: [PATCH 2/6] Add IRQ_TIME_ACCOUNTING, finer accounting of CPU
 irq time
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>
In-Reply-To: <1284895291.2275.617.camel@laptop>
References: <1284688596-6731-1-git-send-email-venki@google.com>
	 <1284688596-6731-3-git-send-email-venki@google.com>
	 <1284895291.2275.617.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 19 Sep 2010 14:01:06 +0200
Message-ID: <1284897666.2275.638.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-19 at 13:21 +0200, Peter Zijlstra wrote:
> On Thu, 2010-09-16 at 18:56 -0700, Venkatesh Pallipadi wrote:
> > +void account_system_vtime(struct task_struct *tsk)
> > +{
> > +       unsigned long flags;
> > +       int cpu;
> > +       u64 now, delta;
> > +
> > +       if (!sched_clock_irqtime)
> > +               return;
> > +
> > +       local_irq_save(flags);
> > +
> > +       cpu = task_cpu(tsk);
> > +       now = sched_clock();
> > +       delta = now - per_cpu(irq_start_time, cpu);
> > +       per_cpu(irq_start_time, cpu) = now;
> > +       if (hardirq_count())
> > +               per_cpu(cpu_hardirq_time, cpu) += delta;
> > +       else if (softirq_count())
> > +               per_cpu(cpu_softirq_time, cpu) += delta;
> > +
> > +       local_irq_restore(flags);
> > +} 
> 
> This seems to suggest you count time double if a hardirq hits while
> we're doing softirqs, but being as this is an incomplete api its very
> hard to tell indeed.

OK, so by virtue of calling the same function on _enter and _exit its
not incomplete, just weird.

And it won't account time double, since it uses irq_start_time to
compute deltas between invocations and will attribute that delta to only
one state.

You still do have the problem with local_bh_disable() though, since you
cannot distinguish between having bh disabled and processing softirq.

So a hardirq that hits while you have bh disabled will inflate your
softirq time.

A possible solution is to have local_bh_{disable,enable} {add,sub}
2*SOFTIRQ_OFFSET and have the processing use SOFTIRQ_OFFSET, will need a
bit of a code shuffle though.
