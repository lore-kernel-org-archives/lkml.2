Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab0JALp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:45:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33574 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab0JALp0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:45:26 -0400
Subject: Re: [PATCH 3/7] Add IRQ_TIME_ACCOUNTING, finer accounting of irq
 time -v3
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <AANLkTi=r5DX52+735OtGHmJCS38n1P_WxEkKzLVf1E_m@mail.gmail.com>
References: <1285788096-29471-1-git-send-email-venki@google.com>
	 <1285788096-29471-4-git-send-email-venki@google.com>
	 <1285844768.2144.11.camel@laptop>
	 <AANLkTi=r5DX52+735OtGHmJCS38n1P_WxEkKzLVf1E_m@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 01 Oct 2010 13:45:02 +0200
Message-ID: <1285933502.2144.56.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-30 at 09:29 -0700, Venkatesh Pallipadi wrote:
> On Thu, Sep 30, 2010 at 4:06 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2010-09-29 at 12:21 -0700, Venkatesh Pallipadi wrote:
> >> +void account_system_vtime(struct task_struct *curr)
> >> +{
> >> +       unsigned long flags;
> >> +       int cpu;
> >> +       u64 now, delta;
> >> +
> >> +       if (!sched_clock_irqtime)
> >> +               return;
> >> +
> >> +       local_irq_save(flags);
> >> +
> >> +       now = sched_clock();
> >> +       cpu = smp_processor_id();
> >
> > Like said before, that really wants to read like:
> >
> >        cpu = smp_processor_id();
> >        now = sched_clock_cpu(cpu);
> >
> > sched_clock() is raw tsc + ns conversion and can go all over the place.
> 
> sched_clock_cpu() won't really work for here, due to what looks like
> idle and timer tick dependencies. Using sched_clock_cpu(), I end up
> accounting CPU idle time to hardirq due to time captured before the
> handler and after the handler.

huh!?

No, sched_clock_cpu() gives sched_clock() for those few systems that
actually have a usable tsc, for those that don't we use the tick (and
idle hooks) to read GTOD and set up a TICK_NSEC window. We then use TSC
to calculate high res deltas, we filter anything that goes backwards and
anything that exceeds the window.

How does that render it useless for this purpose?

Never use sched_clock(), its crap (just like TSC is).
