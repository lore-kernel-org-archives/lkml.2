Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab2BOQij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:38:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40226 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2BOQih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:38:37 -0500
Message-ID: <1329323900.2293.150.camel@twins>
Subject: Re: oprofile and ARM A9 hardware counter
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ming Lei <ming.lei@canonical.com>
Cc: eranian@gmail.com, "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        David Long <dave.long@linaro.org>, b-cousson@ti.com, mans@mansr.com,
        will.deacon@arm.com, linux-arm <linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 15 Feb 2012 17:38:20 +0100
In-Reply-To: <CACVXFVMx9Zx3ZQr6Q-17x5NVL8iuBJjOjtw39FJiWX=fGkZNZA@mail.gmail.com>
References: <1328578047.1724.17.camel@dave-Dell-System-XPS-L502X>
	 <CAMQu2gwfo5JXAqQaLUNs7C7J3TUhEO2zOcyD0Rk-D_O61Yrfag@mail.gmail.com>
	 <CAMsRxfLNBbQO5XF+EHJqNsnW+s=ay3mjSV5dh=sxdwzktUu03g@mail.gmail.com>
	 <CAMQu2gzfNAwtf1c6jrTZpfGMSqBgBrQKmFTeCFzbvMh9ESBDUg@mail.gmail.com>
	 <CAMsRxfKR1ODH56BtcUT5Dv6qOVEYGVheEcW9ugXsZmLKok==bg@mail.gmail.com>
	 <CAMQu2gwWt6oQPjxc1YHgOoxVkHdck_q78Xf==7ncwRj0_uS-JQ@mail.gmail.com>
	 <CAMQu2gyCPtbNfBa5V8ve2JORN+sDeAY+hvR0g0_9U354JgcuiA@mail.gmail.com>
	 <CAMsRxfJVEgVJoHcaPQbMg5mwz=tZUce4oibDUxtnevSF8bGY9g@mail.gmail.com>
	 <CAMQu2gxVUqDF2HkPD=QeX0N_tUd=9FTd+T+1LHCR0tsCgQxC8Q@mail.gmail.com>
	 <CAMsRxfJH+9MS=Svmh0BvDSb8xqsPe2HPobkeKcn8JO35npjhwQ@mail.gmail.com>
	 <CACVXFVMx9Zx3ZQr6Q-17x5NVL8iuBJjOjtw39FJiWX=fGkZNZA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-08 at 10:24 +0800, Ming Lei wrote:
> 
> On OMAP4, HZ is 128, and perf_rotate_context may set a new sample period(~8ms),
> which is much longer than 1ms in 1000HZ freq mode, so less sample events are
> observed. X86 isn't affected since its HZ is 1000.
> 
> With patch[1], about 10000 sample events can be generated after running
> 'perf record -e cycles  ./noploop 10' and 'perf report -D | tail -20'
> on panda board.


> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 32b48c8..db4faf2 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -2300,14 +2300,12 @@ do {                                    \
>         return div64_u64(dividend, divisor);
>  }
> 
> -static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
> +static void perf_adjust_period(struct perf_event *event, u64 period, u64 count)
>  {
>         struct hw_perf_event *hwc = &event->hw;
> -       s64 period, sample_period;
> +       s64 sample_period;
>         s64 delta;
> 
> -       period = perf_calculate_period(event, nsec, count);
> -
>         delta = (s64)(period - hwc->sample_period);
>         delta = (delta + 7) / 8; /* low pass filter */
> 
> @@ -2363,8 +2361,13 @@ static void perf_ctx_adjust_freq(struct
> perf_event_context *ctx, u64 period)
>                 delta = now - hwc->freq_count_stamp;
>                 hwc->freq_count_stamp = now;
> 
> -               if (delta > 0)
> +               if (delta > 0) {
> +                       period = perf_calculate_period(event, period, delta);
> +
> +                       if (period > 4*hwc->sample_period)
> +                               period = hwc->sample_period;
>                         perf_adjust_period(event, period, delta);
> +               }
>         }
>  }
> 
> @@ -4533,8 +4536,10 @@ static int __perf_event_overflow(struct
> perf_event *event,
> 
>                 hwc->freq_time_stamp = now;
> 
> -               if (delta > 0 && delta < 2*TICK_NSEC)
> +               if (delta > 0 && delta < 2*TICK_NSEC) {
> +                       delta = perf_calculate_period(event, delta, hwc->last_period);
>                         perf_adjust_period(event, delta, hwc->last_period);
> +               }
>         }
> 
>         /* 

So what this patch seems to do is put that filter on period in
perf_ctx_adjust_freq(). Not making sense.. nor can I see a HZ
dependency, perf_ctx_adjust_freq() uses TICK_NSEC as time base.
