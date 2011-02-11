Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab1BKSr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:47:57 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46100 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162Ab1BKSr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:47:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Q9j4Zq1TCDZbvqrUPvJ2vOcXYEUYiws7OSqSbk9I4G1N4r8V+1Hsy9WlUrvYdu2cPP
         Ml3AAZeqABiZrTYYq93XubPW4OlSf8qfFX6lPAZ/UpQU7v+Y4sjhNyaaYGdCeLKflK5R
         mw02YrZWMFXmfLjMCroC/dR0w+YyGYfp97CAI=
Message-ID: <4D558454.4090909@gmail.com>
Date: Fri, 11 Feb 2011 11:47:48 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf on 2.6.38-rc4 wedges my box
References: <x49k4h9az25.fsf@segfault.boston.devel.redhat.com>	 <1297373905.5226.31.camel@laptop>  <4D55654F.6090408@gmail.com>	 <1297446806.5226.44.camel@laptop> <1297448589.5226.47.camel@laptop>
In-Reply-To: <1297448589.5226.47.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/11/11 11:23, Peter Zijlstra wrote:
> On Fri, 2011-02-11 at 18:53 +0100, Peter Zijlstra wrote:
>> On Fri, 2011-02-11 at 09:35 -0700, David Ahern wrote:
>>> I'm guessing in your case perf is using hardware cycles for profiling.
>>>
>>> I was able to reproduce the lockup in a VM which uses cpu-clock for
>>> profiling - like Jeff's case. The VM is running Fedora 14 with
>>> 2.6.38-rc4.
>>>
>> Ah, indeed, when I use:
>>
>>   perf record -gfe task-clock -- ./aio-stress -O -o 0 -r 4 -d 32 -b 16 /dev/sdb
>>
>> things did come apart, something like the below cured that problem (but
>> did show the pending softirq thing and triggered something iffy in the
>> backtrace code -- will have to stare at those still)
> 
> So while this doesn't explain these weird things, it should have at
> least one race less -- hrtimer_init() on a possible still running timer
> didn't seem like a very good idea, also since hrtimers are nsec the
> whole freq thing seemed unnecessary.

Solved the lockup with my repro on 2.6.38-rc4.

I did try 2.6.37 earlier today (without this patch), and it locked up
pretty quick as well.

David

> 
> ---
>  kernel/perf_event.c |   37 +++++++++++++++++++++++++++++++++----
>  1 files changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 999835b..08428b3 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -5051,6 +5051,10 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
>  	u64 period;
>  
>  	event = container_of(hrtimer, struct perf_event, hw.hrtimer);
> +
> +	if (event->state < PERF_EVENT_STATE_ACTIVE)
> +		return HRTIMER_NORESTART;
> +
>  	event->pmu->read(event);
>  
>  	perf_sample_data_init(&data, 0);
> @@ -5077,9 +5081,6 @@ static void perf_swevent_start_hrtimer(struct perf_event *event)
>  	if (!is_sampling_event(event))
>  		return;
>  
> -	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> -	hwc->hrtimer.function = perf_swevent_hrtimer;
> -
>  	period = local64_read(&hwc->period_left);
>  	if (period) {
>  		if (period < 0)
> @@ -5102,7 +5103,31 @@ static void perf_swevent_cancel_hrtimer(struct perf_event *event)
>  		ktime_t remaining = hrtimer_get_remaining(&hwc->hrtimer);
>  		local64_set(&hwc->period_left, ktime_to_ns(remaining));
>  
> -		hrtimer_cancel(&hwc->hrtimer);
> +		hrtimer_try_to_cancel(&hwc->hrtimer);
> +	}
> +}
> +
> +static void perf_swevent_init_hrtimer(struct perf_event *event)
> +{
> +	struct hw_perf_event *hwc = &event->hw;
> +
> +	if (!is_sampling_event(event))
> +		return;
> +
> +	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	hwc->hrtimer.function = perf_swevent_hrtimer;
> +
> +	/*
> +	 * Since hrtimers have a fixed rate, we can do a static freq->period
> +	 * mapping and avoid the whole period adjust feedback stuff.
> +	 */
> +	if (event->attr.freq) {
> +		long freq = event->attr.sample_freq;
> +
> +		event->attr.sample_period = NSEC_PER_SEC / freq;
> +		hwc->sample_period = event->attr.sample_period;
> +		local64_set(&hwc->period_left, hwc->sample_period);
> +		event->attr.freq = 0;
>  	}
>  }
>  
> @@ -5158,6 +5183,8 @@ static int cpu_clock_event_init(struct perf_event *event)
>  	if (event->attr.config != PERF_COUNT_SW_CPU_CLOCK)
>  		return -ENOENT;
>  
> +	perf_swevent_init_hrtimer(event);
> +
>  	return 0;
>  }
>  
> @@ -5235,6 +5262,8 @@ static int task_clock_event_init(struct perf_event *event)
>  	if (event->attr.config != PERF_COUNT_SW_TASK_CLOCK)
>  		return -ENOENT;
>  
> +	perf_swevent_init_hrtimer(event);
> +
>  	return 0;
>  }
>  
> 
> 
