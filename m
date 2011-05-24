Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab1EXWnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 18:43:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:46899 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab1EXWnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 18:43:08 -0400
Date: Wed, 25 May 2011 00:43:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        johnstul@us.ibm.com, hch@infradead.org,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] Clocksource: Move the Hyper-V clocksource driver
 out of staging
In-Reply-To: <1306272773-4572-1-git-send-email-kys@microsoft.com>
Message-ID: <alpine.LFD.2.02.1105250015360.3078@ionos>
References: <1306272773-4572-1-git-send-email-kys@microsoft.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, K. Y. Srinivasan wrote:
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -595,6 +595,9 @@ config X86_CYCLONE_TIMER
>  	def_bool y
>  	depends on X86_32_NON_STANDARD
>  
> +config HYPERV_CLKSRC
> +	def_bool y

Errm, why do we need another random config switch for every other
feature of hyperv?

> +#include <linux/clocksource.h>
> +#include <linux/time.h>

Why do you need time.h?

> +#include <asm/hyperv.h>
> +#include <asm/mshyperv.h>
> +#include <asm/hypervisor.h>

Can we please have one sensible asm/hyperwtf.h include for all of this ?

> +
> +static cycle_t read_hv_clock(struct clocksource *arg)
> +{
> +	cycle_t current_tick;
> +	/*
> +	 * Read the partition counter to get the current tick count. This count
> +	 * is set to 0 when the partition is created and is incremented in
> +	 * 100 nanosecond units.
> +	 */

Please move that comment above the function. That's really irritating
to read.

> +	rdmsrl(HV_X64_MSR_TIME_REF_COUNT, current_tick);
> +	return current_tick;
> +}
> +
> +static struct clocksource hyperv_cs = {
> +	.name           = "hyperv_clocksource",
> +	.rating         = 400, /* use this when running on Hyperv*/

That tail comment is pretty useless.

> +	.read           = read_hv_clock,
> +	.mask           = CLOCKSOURCE_MASK(64),
> +};
> +
> +static int __init init_hv_clocksource(void)
> +{
> +	unsigned long	hv_period = 100; /* 100 ns granularity clocksource */

  unsigned long period_ns = 100;

would make the horrible tail comment go away and make it obvious to
the reader what the variable is for. Also please stop adding extra
useless noise to local variables by adding hv_ or whatever the heck to
them.

> +	u32		hv_freq;

Newline between declarations and code please.

> +	if ((x86_hyper != &x86_hyper_ms_hyperv) ||
> +		!(ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE))
> +		return -ENODEV;
> +
> +	hv_freq = NSEC_PER_SEC;
> +	do_div(hv_freq, hv_period);

ROTFL. Do you really need runtime evaluation of 10^9/10^2 ?

#define HV_CLK_FREQ	(NSEC_PER_SEC/100)

would solve that problem with 5 lines less source code and a even
larger reduction of binary size.

> +
> +	printk(KERN_INFO "Registering Hyper-V clock source\n");

How is that interesting ?

> +	return clocksource_register_hz(&hyperv_cs, hv_freq);
> +}

And if you remove that useless stuff then the ten remaining lines
should go to arch/x86/ into a file which will contain more than those
ten lines. It's pretty unlikely that anything else than MSHV will
reuse that code.

Thanks,

	tglx
