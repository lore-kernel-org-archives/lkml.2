Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab0FRHPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 03:15:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:41267 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab0FRHPr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 03:15:47 -0400
Subject: Re: [RFC][PATCH 8/8] perf: Rework the PMU methods
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100618042143.GE5345@nowhere>
References: <20100616160027.590430763@chello.nl>
	 <20100616160238.721536975@chello.nl>  <20100618042143.GE5345@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Jun 2010 09:15:38 +0200
Message-ID: <1276845338.27822.1450.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 06:21 +0200, Frederic Weisbecker wrote:
> On Wed, Jun 16, 2010 at 06:00:35PM +0200, Peter Zijlstra wrote:
> > -static void x86_pmu_stop(struct perf_event *event)
> > +static void x86_pmu_stop(struct perf_event *event, int flags)
> >  {
> > -	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> > -	struct hw_perf_event *hwc = &event->hw;
> > -	int idx = hwc->idx;
> > -
> >  	if (!__test_and_clear_bit(idx, cpuc->active_mask))
> > -		return;
> 
> 
> 
> Do you still need active_mask now that you have HES_STOPPED?

there still were some users, but yeah, we cuold probably clean that up,
bit since the patch is large enough as is, I didn't attempt that.

> > +static void perf_swevent_start(struct perf_event *event, int flags)
> > +{
> > +	event->hw.state = 0;
> > +}
> > +
> > +static void perf_swevent_stop(struct perf_event *event, int flags)
> >  {
> > +	event->hw.state = 1;
> >  }
> 
> 
> So, instead of doing this and add yet another check in the fast path,
> what about just playing with the hlist insertion and deletion?

I wanted to avoid too much trickery, first make a simple one work, then
try something fancy.

> It would be nice to have a PERF_EF_STOP as well in ->del, so that
> each pmu don't need to maintain an internal state.

You have to track it since we can stop the thing outselves without the
caller knowing.

> >  }
> >  #endif
> > @@ -4591,12 +4582,12 @@ static void perf_swevent_start_hrtimer(s
> >  	if (hwc->sample_period) {
> >  		u64 period;
> >  
> > -		if (hwc->remaining) {
> > -			if (hwc->remaining < 0)
> > +		if (hwc->period_left) {
> > +			if (hwc->period_left < 0)
> >  				period = 10000;
> >  			else
> > -				period = hwc->remaining;
> > -			hwc->remaining = 0;
> > +				period = hwc->period_left;
> > +			hwc->period_left = 0;
> 
> 
> 
> If remaining can be replaced by period_left, it should probably be done
> in another patch.

true.
