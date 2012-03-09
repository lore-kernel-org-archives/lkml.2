Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab2CITXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:23:11 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43624 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab2CITXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:23:09 -0500
Message-ID: <1331320982.26253.114.camel@work-vm>
Subject: Re: [PATCH] sched, x86: fix overflow in cyc2ns_offset
From: john stultz <johnstul@us.ibm.com>
To: Salman Qazi <sqazi@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>
Date: Fri, 09 Mar 2012 11:23:02 -0800
In-Reply-To: <20120308232303.11660.48285.stgit@dungbeetle.mtv.corp.google.com>
References: <20120308232303.11660.48285.stgit@dungbeetle.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030919-9360-0000-0000-00000466575F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 15:23 -0800, Salman Qazi wrote:
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
> Signed-off-by: Salman Qazi <sqazi@google.com>
> ---
>  arch/x86/kernel/tsc.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index a62c201..ef1dc8e 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -608,6 +608,8 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
>  {
>  	unsigned long long tsc_now, ns_now, *offset;
>  	unsigned long flags, *scale;
> +	unsigned long long quot;
> +	unsigned long long rem;
> 
>  	local_irq_save(flags);
>  	sched_clock_idle_sleep_event();
> @@ -620,7 +622,15 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
> 
>  	if (cpu_khz) {
>  		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
> -		*offset = ns_now - (tsc_now * *scale >> CYC2NS_SCALE_FACTOR);
> +
> +		/*
> +		 * Avoid premature overflow by splitting into quotient
> +		 * and remainder.  See the comment above __cycles_2_ns
> +		 */
> +		quot = (tsc_now >> CYC2NS_SCALE_FACTOR);
> +		rem = tsc_now & ((1ULL << CYC2NS_SCALE_FACTOR) - 1);
> +		*offset = ns_now - (quot * *scale +
> +				    ((rem * *scale) >> CYC2NS_SCALE_FACTOR));
>  	}

This clearly is a needed fix. Thanks for finding it and sending it in.

Although I'm curious if it might be good to encapsulate this code into a
macro that can be reused in both set_cyc2ns_scale and __cycles_2_ns()
(as well as others, I suspect this issue is going to crop up on other
arches at some point too)?

thanks
-john



