Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1EYKvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 06:51:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:46696 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab1EYKvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 06:51:11 -0400
Date: Wed, 25 May 2011 12:51:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kasper Pedersen <kkp2010@kasperkp.dk>
cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John Stultz <johnstul@us.ibm.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH v3] x86: tsc: make TSC calibration immune to interrupts
In-Reply-To: <4DDC0B4F.6060202@kasperkp.dk>
Message-ID: <alpine.LFD.2.02.1105251243330.3078@ionos>
References: <4DDC0B4F.6060202@kasperkp.dk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is safe to use the first value that passes SMI_TRESHOLD
> for the initial calibration: As long as tsc_khz is above
> 100MHz, SMI_TRESHOLD represents less than 1% of error.
> 
> The 8 additional samples costs us 28 microseconds in startup
> time.

That's a good reason to avoid the whole conditional thing and just do
the best of 5 always.
 
>  /*
>   * Read TSC and the reference counters. Take care of SMI disturbance
>   */
> -static u64 tsc_read_refs(u64 *p, int hpet)
> +static u64 tsc_read_refs(u64 *p, int hpet, int find_best)
>  {
> -	u64 t1, t2;
> +	u64 t1, t2, tp, best_uncertainty, uncertainty, best_t2;
>  	int i;
> +	unsigned long flags;
>  
> -	for (i = 0; i < MAX_RETRIES; i++) {
> +	best_uncertainty = SMI_TRESHOLD;
> +	best_t2 = 0;
> +	for (i = 0; i < BESTOF_SAMPLES; i++) {
> +		local_irq_save(flags);
>  		t1 = get_cycles();
>  		if (hpet)
> -			*p = hpet_readl(HPET_COUNTER) & 0xFFFFFFFF;
> +			tp = hpet_readl(HPET_COUNTER) & 0xFFFFFFFF;
>  		else
> -			*p = acpi_pm_read_early();
> +			tp = acpi_pm_read_early();
>  		t2 = get_cycles();
> -		if ((t2 - t1) < SMI_TRESHOLD)
> -			return t2;
> +		local_irq_restore(flags);
> +		uncertainty = t2 - t1;
> +		if (uncertainty < best_uncertainty) {
> +			best_uncertainty = uncertainty;
> +			best_t2 = t2;
> +			*p = tp;
> +			if (!find_best)
> +				break;
> +		}
>  	}
> +	if (best_uncertainty < SMI_TRESHOLD)
> +		return best_t2;
> +
> +	*p = tp;

The value is completely uninteresting when we return ULLONG_MAX.

Thanks,

	tglx
