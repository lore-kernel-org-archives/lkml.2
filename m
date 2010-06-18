Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310Ab0FREVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 00:21:47 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38081 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab0FREVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 00:21:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NTRlcMHS1SkqIIAKytta+S3OjpN+7gC9NibJSjczZJ1w4jhS55J8iIImsGA0nB5AqG
         HQN55qBizTpO+ZcYDLBWGTilzakvgpUv3AGC9uq7wtSa4COTepvbixRONkpxF4MGRIew
         gpfTAu5qUyfSXogjsSokMzKJVrkKC01qkLf34=
Date: Fri, 18 Jun 2010 06:21:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 8/8] perf: Rework the PMU methods
Message-ID: <20100618042143.GE5345@nowhere>
References: <20100616160027.590430763@chello.nl> <20100616160238.721536975@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616160238.721536975@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 06:00:35PM +0200, Peter Zijlstra wrote:
> -static void x86_pmu_stop(struct perf_event *event)
> +static void x86_pmu_stop(struct perf_event *event, int flags)
>  {
> -	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> -	struct hw_perf_event *hwc = &event->hw;
> -	int idx = hwc->idx;
> -
>  	if (!__test_and_clear_bit(idx, cpuc->active_mask))
> -		return;



Do you still need active_mask now that you have HES_STOPPED?



> @@ -4069,6 +4051,9 @@ static int perf_swevent_match(struct per
>  				struct perf_sample_data *data,
>  				struct pt_regs *regs)
>  {
> +	if (event->hw.state)
> +		return 0;
> +
>  	if (event->attr.type != type)
>  		return 0;
>  
> @@ -4211,7 +4196,7 @@ static void perf_swevent_read(struct per
>  {
>  }
>  
> -static int perf_swevent_enable(struct perf_event *event)
> +static int perf_swevent_add(struct perf_event *event, int flags)
>  {
>  	struct hw_perf_event *hwc = &event->hw;
>  	struct perf_cpu_context *cpuctx;
> @@ -4224,6 +4209,8 @@ static int perf_swevent_enable(struct pe
>  		perf_swevent_set_period(event);
>  	}
>  
> +	hwc->state = !(flags & PERF_EF_START);
> +
>  	head = find_swevent_head(cpuctx, event);
>  	if (WARN_ON_ONCE(!head))
>  		return -EINVAL;
> @@ -4233,13 +4220,19 @@ static int perf_swevent_enable(struct pe
>  	return 0;
>  }
>  
> -static void perf_swevent_disable(struct perf_event *event)
> +static void perf_swevent_del(struct perf_event *event, int flags)
>  {
>  	hlist_del_rcu(&event->hlist_entry);
>  }
>  
> -static void perf_swevent_void(struct perf_event *event)
> +static void perf_swevent_start(struct perf_event *event, int flags)
> +{
> +	event->hw.state = 0;
> +}
> +
> +static void perf_swevent_stop(struct perf_event *event, int flags)
>  {
> +	event->hw.state = 1;
>  }


So, instead of doing this and add yet another check in the fast path,
what about just playing with the hlist insertion and deletion?

And if we have PERF_EF_RELOAD in start or PERF_EF_UPDATE in stop,
we simply do nothing, as we know it's just about updating the counter
or reset the interrupt, things that software events just don't care.

And in ->add, you can also do nothing if PERF_EF_START.

It would be nice to have a PERF_EF_STOP as well in ->del, so that
each pmu don't need to maintain an internal state.
If we assume the generic code will never imbalance add/start/stop/del,
or call start after add(PERF_EF_START), or things like this, pmus
like this don't need to ever touch event->hw.state. It's only
necessary for hardware events that call their start/stop internally.


>  static inline void perf_tp_register(void)
> @@ -4546,7 +4537,7 @@ void perf_bp_event(struct perf_event *bp
>  
>  	perf_sample_data_init(&sample, bp->attr.bp_addr);
>  
> -	if (!perf_exclude_event(bp, regs))
> +	if (!bp->hw.state && !perf_exclude_event(bp, regs))
>  		perf_swevent_add(bp, 1, 1, &sample, regs);



Same thing here, and same for trace events.



>  }
>  #endif
> @@ -4591,12 +4582,12 @@ static void perf_swevent_start_hrtimer(s
>  	if (hwc->sample_period) {
>  		u64 period;
>  
> -		if (hwc->remaining) {
> -			if (hwc->remaining < 0)
> +		if (hwc->period_left) {
> +			if (hwc->period_left < 0)
>  				period = 10000;
>  			else
> -				period = hwc->remaining;
> -			hwc->remaining = 0;
> +				period = hwc->period_left;
> +			hwc->period_left = 0;



If remaining can be replaced by period_left, it should probably be done
in another patch.

