Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab1FCJ5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 05:57:23 -0400
Received: from mail4.comsite.net ([205.238.176.238]:32163 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1FCJ5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 05:57:21 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
Subject: Re: [tip:sched/urgent] sched: Fix cross-cpu clock sync on remote wakeups
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
X-Patchwork-Id: 844032
Message-Id: <schedulerIPIirqEnter@mdm.bga.com>
In-Reply-To: <1307029711.2497.717.camel@laptop>
References: <1307029711.2497.717.camel@laptop>
	<1306835745.2353.3.camel@twins>
	<tip-f01114cb59d670e9b4f2c335930dd57db96e9360@git.kernel.org>
	<20110531125621.GA24439@gere.osrc.amd.com>
	<1306847516.2353.80.camel@twins>
	<20110601070547.GB3368@liondog.tnic>
	<1306924612.2353.176.camel@twins>
	<20110601155017.GD24028@aftab>
	<BANLkTikT6OT-HDi-DR+_ZWEhfp_CYWJ3Hg@mail.gmail.com>
	<1307019866.2497.675.camel@laptop>
	<20110602142340.GA3356@zhy>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Borislav Petkov <bp@amd64.org>,
        Borislav Petkov <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "markus@trippelsdorf.de" <markus@trippelsdorf.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Fri, 03 Jun 2011 04:57:21 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Jun 2011 about 15:48:31 -0000, Peter Zijlstra wrote:
> On Thu, 2011-06-02 at 22:23 +0800, Yong Zhang wrote:
> > On Thu, Jun 02, 2011 at 03:04:26PM +0200, Peter Zijlstra wrote:
> > > irq_enter() -> tick_check_idle() -> tick_check_nohz() ->
> > > tick_nohz_stop_idle() -> sched_clock_idle_wakeup_event()
> > > 
> > > should update the thing before we run any isrs, right?
> > 
> > Hmmm, you are right.
> > 
> > But smp_reschedule_interrupt() doesn't call irq_enter()/irq_exit(),
> > is that correct?
> 
> Crap.. you're right. And I bet other archs don't do that either. With
> NO_HZ you really need irq_enter() for pretty much all interrupts so I
> was assuming the resched IPI had it, but its been special and never
> really needed it. If it would wake an idle cpu the idle loop exit would
> deal with it, if it interrupted userspace the thing was running and
> NO_HZ wasn't relevant.
> 
> Damn. 
> 
> And yes, the only reason I didn't see this on my dev box was because we
> do indeed set that sched_clock_stable thing on wsm. And I never noticed
> on my desktop because firefox/X/etc. consuming heaps of CPU isn't weird
> at all.
> 
> Adding it to all resched int handlers is of course a possibility but
> would slow down the thing, although with the new code, most users are
> now indeed wakeups (excepting weird and wonderful users like KVM).

[me looks closely at patch and finds early return]

> 
> We could of course add it in sched.c since the logic recurses just
> fine.. its not pretty though.. :/
> 
> Thoughts?


Many architectures already have an irq_enter becuase they have a single
interrupt to the cpu for all external causes including software; they
do the irq_enter before reading from the irq controller to know the
reason for the interrupt.  A quick glance at irq_enter and irq_exit
shows they will do several things twice when nested, even if that
is safe.

Are there really that many calls with the empty list that it makes
sense to avoid and optimize this on x86 while penalizing the several
architectures with a nested irq_enter and exit?  When it also duplicates
sched_ttwu_pending (because it can't be common with the additional tests)?

We said the perf mon callback (now irq_work) had to be under irq_enter.

Can we get some numbers for how often the two cases occur on some
various workloads?

milton

> 
> ---
> kernel/sched.c |   18 +++++++++++++++++-
>  1 files changed, 17 insertions(+), 1 deletions(-)
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 2fe98ed..365ed6b 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2554,7 +2554,23 @@ static void sched_ttwu_pending(void)
>  
>  void scheduler_ipi(void)
>  {
> -	sched_ttwu_pending();
> +	struct rq *rq = this_rq();
> +	struct task_struct *list = xchg(&rq->wake_list, NULL);
> +
> +	if (!list)
> +		return;
> +
> +	irq_enter();
> +	raw_spin_lock(&rq->lock);
> +
> +	while (list) {
> +		struct task_struct *p = list;
> +		list = list->wake_entry;
> +		ttwu_do_activate(rq, p, 0);
> +	}
> +
> +	raw_spin_unlock(&rq->lock);
> +	irq_exit();
>  }
>  
>  static void ttwu_queue_remote(struct task_struct *p, int cpu)
