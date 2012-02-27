Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2B0KMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:12:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:58097 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab2B0KMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:12:30 -0500
Message-ID: <1330337535.11248.45.camel@twins>
Subject: Re: [PATCH] sched: generalize CONFIG_IRQ_TIME_ACCOUNTING for X86
 and ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
        Yong Zhang <yong.zhang0@gmail.com>, Venki Pallipadi <venki@google.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Venkatesh Pallipadi <venki@google.com>
Date: Mon, 27 Feb 2012 11:12:15 +0100
In-Reply-To: <1329717859-19378-1-git-send-email-dmitry.antipov@linaro.org>
References: <1329717859-19378-1-git-send-email-dmitry.antipov@linaro.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 10:04 +0400, Dmitry Antipov wrote:
> Generalize CONFIG_IRQ_TIME_ACCOUNTING  between X86 and
> ARM, move "noirqtime=" option to common debugging code.
> For a bit of backward compatibility, X86-specific option
> "tsc=noirqtime" is preserved, but issues a warning.
> 
> Suggested-by: Yong Zhang <yong.zhang0@gmail.com>
> Suggested-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Suggested-by: Ingo Molnar <mingo@elte.hu>
> Acked-by: Venkatesh Pallipadi <venki@google.com>
> Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>

Thanks for Cc'ing me (maintainer) and Venki (original author of the
stuff) :-)


> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 7d379a6..9b13f79 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1961,13 +1961,16 @@ extern void sched_clock_idle_wakeup_event(u64 delta_ns);
>  #endif
>  
>  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
> -/*
> - * An i/f to runtime opt-in for irq time accounting based off of sched_clock.
> - * The reason for this explicit opt-in is not to have perf penalty with
> - * slow sched_clocks.
> - */
> -extern void enable_sched_clock_irqtime(void);
> -extern void disable_sched_clock_irqtime(void);
> +extern int sched_clock_irqtime;
> +static inline void enable_sched_clock_irqtime(void)
> +{
> +	if (sched_clock_irqtime == -1)
> +		sched_clock_irqtime = 1;
> +}
> +static inline void disable_sched_clock_irqtime(void)
> +{
> +	sched_clock_irqtime = 0;
> +}
>  #else
>  static inline void enable_sched_clock_irqtime(void) {}
>  static inline void disable_sched_clock_irqtime(void) {}

Please keep them out-of-line, its not a fast path and it avoids having
to expose the state variable.

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 5255c9d..4e7a197 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -757,18 +757,21 @@ static DEFINE_PER_CPU(u64, cpu_hardirq_time);
>  static DEFINE_PER_CPU(u64, cpu_softirq_time);
>  
>  static DEFINE_PER_CPU(u64, irq_start_time);
> -static int sched_clock_irqtime;
>  
> -void enable_sched_clock_irqtime(void)
> -{
> -	sched_clock_irqtime = 1;
> -}
> +/*
> + * -1 if not initialized, 0 if disabled with "noirqtime" kernel option
> + * or after unstable clock was detected, 1 if enabled and active.
> + */

You forgot to explain what you need the tri-state for.

> +__read_mostly int sched_clock_irqtime = -1;
>  
> -void disable_sched_clock_irqtime(void)
> +static int __init irqtime_setup(char *str)
>  {
>  	sched_clock_irqtime = 0;
> +	return 1;
>  }
>  
> +__setup("noirqtime", irqtime_setup);
> +
>  #ifndef CONFIG_64BIT
>  static DEFINE_PER_CPU(seqcount_t, irq_time_seq);

Other than that no real objections.. I guess.
