Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab1C2VTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 17:19:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:43422 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab1C2VTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 17:19:37 -0400
Subject: Re: [PATCH V2] POWER: perf_event: Skip updating kernel counters if
 register value shrinks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Eric B Munson <emunson@mgebm.net>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, anton@samba.org, stable@kernel.org
In-Reply-To: <1301410302-7270-1-git-send-email-emunson@mgebm.net>
References: <1301410302-7270-1-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 08:14:57 +1100
Message-ID: <1301433297.2402.691.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

\
> diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
> index 97e0ae4..0a5178f 100644
> --- a/arch/powerpc/kernel/perf_event.c
> +++ b/arch/powerpc/kernel/perf_event.c
> @@ -416,6 +416,15 @@ static void power_pmu_read(struct perf_event *event)
>  		prev = local64_read(&event->hw.prev_count);
>  		barrier();
>  		val = read_pmc(event->hw.idx);
> +		/*
> +		 * POWER7 can roll back counter values, if the new value is
> +		 * smaller than the previous value it will cause the delta
> +		 * and the counter to have bogus values.  If this is the
> +		 * case skip updating anything until the counter grows again.
> +		 * This can lead to a small lack of precision in the counters.
> +		 */
> +		if (val < prev)
> +			return;
>  	} while (local64_cmpxchg(&event->hw.prev_count, prev, val) != prev);

So if the counters can rollover, the above is still wrong... prev could
be ffffffff and val could be 1 ... for example. In this case you really
need to substract and get the sign of the result I'd think...

Cheers,
Ben.

>  	/* The counters are only 32 bits wide */
> @@ -439,7 +448,8 @@ static void freeze_limited_counters(struct cpu_hw_events *cpuhw,
>  				    unsigned long pmc5, unsigned long pmc6)
>  {
>  	struct perf_event *event;
> -	u64 val, prev, delta;
> +	u64 val, prev;
> +	s32 delta;
>  	int i;
>  
>  	for (i = 0; i < cpuhw->n_limited; ++i) {
> @@ -449,8 +459,13 @@ static void freeze_limited_counters(struct cpu_hw_events *cpuhw,
>  		val = (event->hw.idx == 5) ? pmc5 : pmc6;
>  		prev = local64_read(&event->hw.prev_count);
>  		event->hw.idx = 0;
> -		delta = (val - prev) & 0xfffffffful;
> -		local64_add(delta, &event->count);
> +		/*
> +		 * The PerfMon registers are only 32 bits wide so the
> +		 * delta should not overflow.
> +		 */
> +		delta = val - prev;
> +		if (delta > 0)
> +			local64_add(delta, &event->count);
>  	}
>  }
>  
> @@ -458,14 +473,16 @@ static void thaw_limited_counters(struct cpu_hw_events *cpuhw,
>  				  unsigned long pmc5, unsigned long pmc6)
>  {
>  	struct perf_event *event;
> -	u64 val;
> +	u64 val, prev;
>  	int i;
>  
>  	for (i = 0; i < cpuhw->n_limited; ++i) {
>  		event = cpuhw->limited_counter[i];
>  		event->hw.idx = cpuhw->limited_hwidx[i];
>  		val = (event->hw.idx == 5) ? pmc5 : pmc6;
> -		local64_set(&event->hw.prev_count, val);
> +		prev = local64_read(&event->hw.prev_count);
> +		if (val > prev)
> +			local64_set(&event->hw.prev_count, val);
>  		perf_event_update_userpage(event);
>  	}
>  }
> @@ -1187,7 +1204,8 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
>  			       struct pt_regs *regs, int nmi)
>  {
>  	u64 period = event->hw.sample_period;
> -	s64 prev, delta, left;
> +	s64 prev, left;
> +	s32 delta;
>  	int record = 0;
>  
>  	if (event->hw.state & PERF_HES_STOPPED) {
> @@ -1197,7 +1215,9 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
>  
>  	/* we don't have to worry about interrupts here */
>  	prev = local64_read(&event->hw.prev_count);
> -	delta = (val - prev) & 0xfffffffful;
> +	delta = val - prev;
> +	if (delta < 0)
> +		delta = 0;
>  	local64_add(delta, &event->count);
>  
>  	/*


