Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934236Ab0EZGy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 02:54:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:51410 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab0EZGyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 02:54:55 -0400
Subject: Re: [RFC PATCH 2/4] x86: Add IRQ_TIME_ACCOUNTING, finer accounting
 of  irq time to task
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Paul Turner <pjt@google.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <AANLkTinPtwSUjMtBRkb96DU4lym8ZNrYwPe_q6rstT4D@mail.gmail.com>
References: <1274746282-21533-1-git-send-email-venki@google.com>
	 <1274746282-21533-2-git-send-email-venki@google.com>
	 <1274746282-21533-3-git-send-email-venki@google.com>
	 <1274769311.5882.96.camel@twins>
	 <AANLkTinPtwSUjMtBRkb96DU4lym8ZNrYwPe_q6rstT4D@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 May 2010 08:54:41 +0200
Message-ID: <1274856881.5882.4467.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 14:40 -0700, Venkatesh Pallipadi wrote:
> On Mon, May 24, 2010 at 11:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2010-05-24 at 17:11 -0700, Venkatesh Pallipadi wrote:
> >> +void account_system_vtime(struct task_struct *tsk)
> >> +{
> >> +       unsigned long flags;
> >> +       int cpu;
> >> +       u64 now;
> >> +
> >> +       local_irq_save(flags);
> >> +       cpu = task_cpu(tsk);
> >> +       now = sched_clock_cpu(cpu);
> >> +       if (hardirq_count())
> >> +               tsk->hi_time += now - per_cpu(irq_start_time, cpu);
> >> +       else if (softirq_count())
> >> +               tsk->si_time += now - per_cpu(irq_start_time, cpu);
> >> +
> >> +       per_cpu(irq_start_time, cpu) = now;
> >> +       local_irq_restore(flags);
> >> +}
> >
> > Right, so this gets called from irq_enter/exit() and __do_softirq().
> >
> > The reason I never pressed onwards with this (I had patches to add IRQ
> > time accounting) is that it sucks terribly for anything falling back to
> > jiffies -- maybe find some smart way to disable the whole call when
> > there's no TSC available, preferably without adding conditionals, using
> > alternatives maybe?
> >
> > I guess you mostly side-stepped that by adding a IRQ_TIME_ACCOUNTING
> > config (but forgot to make it depend on X86_TSC).
> 
> Yes. The TSC dependency is unfortunately not CONFIG time. Even with X86_TSC,
> there is support for tsc_disabled. So, this should be a run time
> conditional or an alternative.

Right.

> > Another thing I dislike about this account_system_vtime() is that its
> > the same call for both IRQ and SoftIRQ, leaving us to add conditionals
> > inside the call to figure out what context we got called from.
> >
> > [ Adedd the s390 and ppc guys who already use this stuff ]
> 
> We can probably add a parameter on from where it is being called. Even
> with that we still need some conditionals to handle hardirq overlapping a
> softirq. That part kind of happens naturally with the current code.

Ah, indeed. Yes that nesting stuff will give some conditionals.

> > Anyway, once we have this, please also add it to sched_rt_avg_update()
> > (which should really be called sched_!fair_avg_update()).
> 
> You mean take out the hi and si time from rt_delta?

No add it in. The thing we do with rt_delta is compute how much time is
not available to sched_fair, so that we can normalize the runqueue
weights across cpus to ensure tasks still get an equal amount of
service.

Currently it only accounts for the time spend running RT tasks, but
ideally it should be everything not running sched_fair which of course
includes all the IRQ overhead.

> > Also, did you measure the overhead of doing this? sched_clock_cpu() adds
> > a cmpxchg64 on all systems that don't have a rock solid TSC (ie. most of
> > todays machines).
> >
> > Another thing that would be real nice is if you could find a way to not
> > make all of this x86 specific.
> 
> Yes. Thats one of the reason I made this based of sched_clock. May be
> we can have a has_fast_sched_clock feature that archs and opt in to that
> enables this with an alternative?

Right, we can already use CONFIG_HACE_UNSTABLE_SCHED_CLOCK and
sched_clock_stable, but we need more.

Also, what will the stats show when we do fallback to jiffies? Simply
not account them and show 0?

> overhead: My initial testing was on reliable TSC system, where sched_clock_cpu()
> takes <50 cycles. So, no noticable overhead there. I still have to run
> this on other platforms, will post the data once I do that.

Right, I guess the Nehalem class desktops with single chips, hopefully
even the laptop chips will have usable TSC, but pretty much all the
Core2 chips out there are iffy.


