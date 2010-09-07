Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab0IGRHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 13:07:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43123 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881Ab0IGRHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 13:07:45 -0400
Subject: Re: [RFC][PATCH 13/19] perf: Per cpu-context rotation timer
From: Peter Zijlstra <peterz@infradead.org>
To: paulus <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>,
        Robert Richter <robert.richter@amd.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Yanmin <yanmin_zhang@linux.intel.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, tglx <tglx@linutronix.de>
In-Reply-To: <20100907165011.939993481@chello.nl>
References: <20100907164633.879932949@chello.nl>
	 <20100907165011.939993481@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Sep 2010 19:07:27 +0200
Message-ID: <1283879247.1930.1629.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-07 at 18:46 +0200, Peter Zijlstra wrote:

> @@ -5904,6 +5930,9 @@ static void __init perf_event_init_all_c
>  
>                 cpuctx = &per_cpu(perf_cpu_context, cpu);
>                 __perf_event_init_context(&cpuctx->ctx, NULL);
> +               cpuctx->timer_interval = TICK_NSEC;
> +               hrtimer_init(&cpuctx->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +               cpuctx->timer.function = perf_event_context_tick;
>         }

> +static void perf_pmu_rotate_start(struct pmu *pmu)
> +{
> +       struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
> +
> +       if (hrtimer_active(&cpuctx->timer))
> +               return;
> +
> +       __hrtimer_start_range_ns(&cpuctx->timer,
> +                       ns_to_ktime(cpuctx->timer_interval), 0,
> +                       HRTIMER_MODE_REL, 0);
>  } 

This probably wants a fuzz factor that lets it fold into the tick we
already have. Thomas what's the easiest way to do that, give it a soft
limit of 1ns and hardlimit of TICK_NSEC?


