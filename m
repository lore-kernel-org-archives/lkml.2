Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab1FGU27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:28:59 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:40721 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab1FGU24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:28:56 -0400
Subject: Re: [PATCH 4/5] clocksource: Replace vread and fsys_mmio with
 generic arch data
From: john stultz <johnstul@us.ibm.com>
To: Andy Lutomirski <luto@mit.edu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Clemens Ladisch <clemens@ladisch.de>, linux-ia64@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4a233d5b7421ef8f7805139e3eba68c52c2d0d57.1307474707.git.luto@mit.edu>
References: <cover.1307474707.git.luto@mit.edu>
	 <4a233d5b7421ef8f7805139e3eba68c52c2d0d57.1307474707.git.luto@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 13:28:34 -0700
Message-ID: <1307478514.3163.49.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 15:32 -0400, Andy Lutomirski wrote:
> The vread field was bloating struct clocksource everywhere except
> x86_64, and I want to change the way this works on x86_64, so let's
> split it out into per-arch data.
[snip]
> diff --git a/arch/ia64/include/asm/clocksource.h b/arch/ia64/include/asm/clocksource.h
> new file mode 100644
> index 0000000..453f363
> --- /dev/null
> +++ b/arch/ia64/include/asm/clocksource.h
> @@ -0,0 +1,16 @@
> +/* x86-specific clocksource additions */
> +
> +#ifndef _ASM_X86_CLOCKSOURCE_H
> +#define _ASM_X86_CLOCKSOURCE_H
> +
> +#ifdef CONFIG_X86_64

Why do we want X86_64 ifdefs in the ia64 clocksource.h?


> +#define __ARCH_HAS_CLOCKSOURCE_DATA
> +
> +struct arch_clocksource_data {
> +	void *fsys_mmio;        /* used by fsyscall asm code */
> +};
> +
> +#endif /* CONFIG_X86_64 */
> +
> +#endif /* _ASM_X86_CLOCKSOURCE_H */
> diff --git a/arch/ia64/kernel/cyclone.c b/arch/ia64/kernel/cyclone.c
> index f64097b..4826ff9 100644
> --- a/arch/ia64/kernel/cyclone.c
> +++ b/arch/ia64/kernel/cyclone.c
> @@ -115,7 +115,7 @@ int __init init_cyclone_clock(void)
>  	}
>  	/* initialize last tick */
>  	cyclone_mc = cyclone_timer;
> -	clocksource_cyclone.fsys_mmio = cyclone_timer;
> +	clocksource_cyclone.archdata.fsys_mmio = cyclone_timer;
>  	clocksource_register_hz(&clocksource_cyclone, CYCLONE_TIMER_FREQ);
> 
>  	return 0;
> diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
> index 85118df..43920de 100644
> --- a/arch/ia64/kernel/time.c
> +++ b/arch/ia64/kernel/time.c
> @@ -468,7 +468,7 @@ void update_vsyscall(struct timespec *wall, struct timespec *wtm,
>          fsyscall_gtod_data.clk_mask = c->mask;
>          fsyscall_gtod_data.clk_mult = mult;
>          fsyscall_gtod_data.clk_shift = c->shift;
> -        fsyscall_gtod_data.clk_fsys_mmio = c->fsys_mmio;
> +        fsyscall_gtod_data.clk_fsys_mmio = c->archdata.fsys_mmio;
>          fsyscall_gtod_data.clk_cycle_last = c->cycle_last;
> 
>  	/* copy kernel time structures */

Overall this sort of feels a little messy to me. 

While having the ifdefs in the clocksource structure wasn't great, I'm
not super excited about pushing all of this back into arch-specific
code. The hope was that folks like ppc and ia64 would convert over from
their own implementations to using more generic vread() implementations,
or atleast new arches with vdso implementations would make use of it
(possibly even allowing for a generic vdso gettime implementation).

Are there at least some hard numbers that help justify this? Or maybe
could you provide some thoughts on your future plans?

thanks
-john


