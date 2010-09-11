Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0IKJl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 05:41:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:36831 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab0IKJlY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 05:41:24 -0400
Subject: Re: [tip:perf/core] perf: Rework the PMU methods
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Cree <mcree@orcon.net.nz>
Cc: mingo@redhat.com, dengcheng.zhu@gmail.com, yanmin_zhang@linux.intel.com,
        gorcunov@gmail.com, fweisbec@gmail.com, robert.richter@amd.com,
        ming.m.lin@intel.com, tglx@linutronix.de, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, eranian@googlemail.com,
        will.deacon@arm.com, lethal@linux-sh.org, davem@davemloft.net,
        mingo@elte.hu, linux-alpha@vger.kernel.org
In-Reply-To: <4C8B3AD3.5050309@orcon.net.nz>
References: <new-submission>
	 <tip-a4eaf7f14675cb512d69f0c928055e73d0c6d252@git.kernel.org>
	 <4C8B3AD3.5050309@orcon.net.nz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 11 Sep 2010 11:40:35 +0200
Message-ID: <1284198035.2251.29.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-11 at 20:16 +1200, Michael Cree wrote:
> On 10/09/10 07:50, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  a4eaf7f14675cb512d69f0c928055e73d0c6d252
> > Gitweb:     http://git.kernel.org/tip/a4eaf7f14675cb512d69f0c928055e73d0c6d252
> > Author:     Peter Zijlstra<a.p.zijlstra@chello.nl>
> > AuthorDate: Wed, 16 Jun 2010 14:37:10 +0200
> > Committer:  Ingo Molnar<mingo@elte.hu>
> > CommitDate: Thu, 9 Sep 2010 20:46:30 +0200
> >
> > perf: Rework the PMU methods
> >
> > Replace pmu::{enable,disable,start,stop,unthrottle} with
> > pmu::{add,del,start,stop}, all of which take a flags argument.
> 
> Regarding the new function alpha_pmu_stop() in 
> arch/alpha/kernel/perf_event.c:
> 
> > -static void alpha_pmu_unthrottle(struct perf_event *event)
> > +static void alpha_pmu_stop(struct perf_event *event, int flags)
> >   {
> >   	struct hw_perf_event *hwc =&event->hw;
> >   	struct cpu_hw_events *cpuc =&__get_cpu_var(cpu_hw_events);
> >
> > +	if (!(hwc->state&  PERF_HES_STOPPED)) {
> > +		cpuc->idx_mask&= !(1UL<<hwc->idx);
>                                   ^
> Presumably ones complement (rather than logical not) is meant.

Yes, typo that, sorry.

> 
> > +		hwc->state |= PERF_HES_STOPPED;
> > +	}
> > +
> > +	if ((flags&  PERF_EF_UPDATE)&&  !(hwc->state&  PERF_HES_UPTODATE)) {
> > +		alpha_perf_event_update(event, hwc, hwc->idx, 0);
> > +		hwc->state |= PERF_HES_UPTODATE;
> > +	}
> > +
> > +	if (cpuc->enabled)
> > +		wrperfmon(PERFMON_CMD_ENABLE, (1UL<<hwc->idx));
> 
> By the name of the function (alpha_pmu_stop) I assume that the intent is 
> to stop the specific PMC here.  The above fails to do that.  When 
> wrperfmon() is used with PERFMON_CMD_ENABLE it enables the PMCs with set 
> bits in the second argument.  It does not stop the others.  To do that 
> wrperfmon() must be called with PERFMON_CMD_DISABLE and the 
> corresponding PMC bits set to disable the PMC.

Right, so ->add()/->del() schedule the event onto the pmu and deal with
any resource issues where needed. ->stop()/->start() simply leave the
event on the pmu with all resources in tact, but ensure it doesn't
actually count.

Depending on the PMU there's various ways of achieving that, some PMUs
can't disable counter, for those we simply take a counter reading and
disable the interrupt, and reset the counter to the previous value on
->start again and enable the interrupt.

Or when we can't even disable the interrupt, we program it to the
longest possible period, etc..

Apparently ALPHA can nicely disable things, except I seem to have
misunderstood the way how, I assumed it had an enable register, and
writing a 0 to the idx position would stop it.

Could you provide a patch that makes ALPHA work again, or would you like
me to take another stab at it?
