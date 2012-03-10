Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964790Ab2CJAZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 19:25:50 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:37902 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486Ab2CJAZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 19:25:48 -0500
Message-ID: <1331339140.26253.134.camel@work-vm>
Subject: Re: [PATCH] sched, x86: fix overflow in cyc2ns_offset
From: john stultz <johnstul@us.ibm.com>
To: Salman Qazi <sqazi@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 09 Mar 2012 16:25:40 -0800
In-Reply-To: <20120309235944.12863.28602.stgit@dungbeetle.mtv.corp.google.com>
References: <20120309235944.12863.28602.stgit@dungbeetle.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031000-3352-0000-0000-000003393231
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-09 at 16:00 -0800, Salman Qazi wrote:
> When a machine boots up, the TSC generally gets reset.  However, when
> kexec is used to boot into a kernel, the TSC value would be carried
> over from the previous kernel.  The computation of cycns_offset in
> set_cyc2ns_scale is prone to an overflow, if the machine has been up
> more than 208 days prior to the kexec.  The overflow happens when
> we multiply *scale, even though there is enough room to store the
> final answer.  We fix this issue by decomposing tsc_now into the
> quotient and remainder of division by CYC2NS_SCALE_FACTOR and then
> performing the multiplication separately on the two components.
> 
> Refactor code to share the calculation with the previous
> fix in __cycles_2_ns.

Thanks so much for making it more generic and reusable! But one question
below.

> Signed-off-by: Salman Qazi <sqazi@google.com>
> ---
>  arch/x86/include/asm/timer.h |    8 ++------
>  arch/x86/kernel/tsc.c        |    3 ++-
>  include/linux/kernel.h       |   13 +++++++++++++
>  3 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
> index 431793e..34baa0e 100644
> --- a/arch/x86/include/asm/timer.h
> +++ b/arch/x86/include/asm/timer.h
> @@ -57,14 +57,10 @@ DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
> 
>  static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
>  {
> -	unsigned long long quot;
> -	unsigned long long rem;
>  	int cpu = smp_processor_id();
>  	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
> -	quot = (cyc >> CYC2NS_SCALE_FACTOR);
> -	rem = cyc & ((1ULL << CYC2NS_SCALE_FACTOR) - 1);
> -	ns += quot * per_cpu(cyc2ns, cpu) +
> -		((rem * per_cpu(cyc2ns, cpu)) >> CYC2NS_SCALE_FACTOR);
> +	ns += mult_frac(cyc, per_cpu(cyc2ns, cpu),
> +			(1UL << CYC2NS_SCALE_FACTOR));
>  	return ns;
>  }
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index a62c201..183c592 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -620,7 +620,8 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
> 
>  	if (cpu_khz) {
>  		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
> -		*offset = ns_now - (tsc_now * *scale >> CYC2NS_SCALE_FACTOR);
> +		*offset = ns_now - mult_frac(tsc_now, *scale,
> +					     (1UL << CYC2NS_SCALE_FACTOR));
>  	}
> 
>  	sched_clock_idle_wakeup_event(0);
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index e834342..d801acb 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -85,6 +85,19 @@
>  }							\
>  )
> 
> +/*
> + * Multiplies an integer by a fraction, while avoiding unnecessary
> + * overflow or loss of precision.
> + */
> +#define mult_frac(x, numer, denom)(			\
> +{							\
> +	typeof(x) quot = (x) / (denom);			\
> +	typeof(x) rem  = (x) % (denom);			\
> +	(quot * (numer)) + ((rem * (numer)) / (denom));	\
> +}							\
> +)
> +
> +

So... Sorry, why did you change it from the shifted logic?

I was thinking more like:
mult_shifted_fract(x, mult, shift)
{
	quot = x >> shift;
	rem = x & ((1ULL << shift)-1);
	return quot * mult + (rem * mult) >> shift;
}

Is the compiler really smart enough to avoid the divides?

thanks
-john


