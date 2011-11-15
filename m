Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab1KOXDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 18:03:20 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41164 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524Ab1KOXDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 18:03:15 -0500
Message-ID: <1321398123.2352.29.camel@work-vm>
Subject: Re: [PATCH] sched: avoid unnecessary overflow in sched_clock
From: john stultz <johnstul@us.ibm.com>
To: Salman Qazi <sqazi@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 15 Nov 2011 15:02:03 -0800
In-Reply-To: <20111115221121.7262.88871.stgit@dungbeetle.mtv.corp.google.com>
References: <20111115221121.7262.88871.stgit@dungbeetle.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11111523-6078-0000-0000-0000046F2ABA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 14:12 -0800, Salman Qazi wrote:
> (Added the missing signed-off-by line)
> 
> In hundreds of days, the __cycles_2_ns calculation in sched_clock
> has an overflow.  cyc * per_cpu(cyc2ns, cpu) exceeds 64 bits, causing
> the final value to become zero.  We can solve this without losing
> any precision.
> 
> We can decompose TSC into quotient and remainder of division by the
> scale factor, and then use this to convert TSC into nanoseconds.
> 
> Signed-off-by: Salman Qazi <sqazi@google.com>

Acked-by: John Stultz <johnstul@us.ibm.com>


> ---
>  arch/x86/include/asm/timer.h |   23 ++++++++++++++++++++++-
>  1 files changed, 22 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
> index fa7b917..431793e 100644
> --- a/arch/x86/include/asm/timer.h
> +++ b/arch/x86/include/asm/timer.h
> @@ -32,6 +32,22 @@ extern int no_timer_check;
>   *  (mathieu.desnoyers@polymtl.ca)
>   *
>   *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
> + *
> + * In:
> + *
> + * ns = cycles * cyc2ns_scale / SC
> + *
> + * Although we may still have enough bits to store the value of ns,
> + * in some cases, we may not have enough bits to store cycles * cyc2ns_scale,
> + * leading to an incorrect result.
> + *
> + * To avoid this, we can decompose 'cycles' into quotient and remainder
> + * of division by SC.  Then,
> + *
> + * ns = (quot * SC + rem) * cyc2ns_scale / SC
> + *    = quot * cyc2ns_scale + (rem * cyc2ns_scale) / SC
> + *
> + *			- sqazi@google.com
>   */
> 
>  DECLARE_PER_CPU(unsigned long, cyc2ns);
> @@ -41,9 +57,14 @@ DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
> 
>  static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
>  {
> +	unsigned long long quot;
> +	unsigned long long rem;
>  	int cpu = smp_processor_id();
>  	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
> -	ns += cyc * per_cpu(cyc2ns, cpu) >> CYC2NS_SCALE_FACTOR;
> +	quot = (cyc >> CYC2NS_SCALE_FACTOR);
> +	rem = cyc & ((1ULL << CYC2NS_SCALE_FACTOR) - 1);
> +	ns += quot * per_cpu(cyc2ns, cpu) +
> +		((rem * per_cpu(cyc2ns, cpu)) >> CYC2NS_SCALE_FACTOR);
>  	return ns;
>  }
> 
> 


