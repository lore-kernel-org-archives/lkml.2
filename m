Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab0EKNqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 09:46:37 -0400
Received: from www.tglx.de ([62.245.132.106]:46520 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186Ab0EKNqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 09:46:34 -0400
Date: Tue, 11 May 2010 15:46:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Alek Du <alek.du@intel.com>, Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Jacob Pan <jacob.jun.pan@intel.com>
Subject: Re: [PATCH 3/8] x86/apic: allow use of lapic timer early calibration
 result
In-Reply-To: <1273254108-3234-4-git-send-email-jacob.jun.pan@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1005111514471.3401@localhost.localdomain>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273254108-3234-4-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 May 2010, Jacob Pan wrote:

> From: Jacob Pan <jacob.jun.pan@intel.com>
> 
> lapic timer calibration can be combined with tsc in platform specific
> calibration functions. if such calibration result is obtained early,
> we can skip the redundent calibration loops.

I'd rather move lapic calibration into TSC calibration in general as
we do the same thing twice for no good reason.

That needs some code restructuring, but that's worth it.

> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

Hehe. So you handed the patch to yourself :)

> ---
>  arch/x86/kernel/apic/apic.c |   21 ++++++++++++++++++++-
>  1 files changed, 20 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index e5a4a1e..8ef56ac 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -175,7 +175,7 @@ static struct resource lapic_resource = {
>  	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
>  };
>  
> -static unsigned int calibration_result;
> +unsigned int calibration_result;

Aside of my general objection it'd be not a good idea to make this
global w/o renaming it to something sensible like
lapic_timer_frequency.
  
>  static int lapic_next_event(unsigned long delta,
>  			    struct clock_event_device *evt);
> @@ -597,6 +597,25 @@ static int __init calibrate_APIC_clock(void)
>  	long delta, deltatsc;
>  	int pm_referenced = 0;
>  
> +	/**
> +	 * check if lapic timer has already been calibrated by platform
> +	 * specific routine, such as tsc calibration code. if so, we just fill
> +	 * in the clockevent structure and return.
> +	 */
> +	if (calibration_result) {
> +		apic_printk(APIC_VERBOSE, "lapic timer already calibrated %d\n",
> +				calibration_result);
> +		lapic_clockevent.mult = div_sc(calibration_result/APIC_DIVISOR,
> +					TICK_NSEC, lapic_clockevent.shift);
> +		lapic_clockevent.max_delta_ns =
> +			clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
> +		lapic_clockevent.min_delta_ns =
> +			clockevent_delta2ns(0xF, &lapic_clockevent);
> +		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
> +		return 0;

  Grr. I hate duplicated code.

> +	}
> +
>  	local_irq_disable();
>  
>  	/* Replace the global interrupt handler */
> -- 
> 1.6.3.3
> 
