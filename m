Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1AJIkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 03:40:14 -0500
Received: from www.tglx.de ([62.245.132.106]:46359 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab1AJIkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 03:40:11 -0500
Date: Mon, 10 Jan 2011 09:36:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pierre Tardy <pierre.tardy@intel.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@stusta.de>,
        Andrew Morton <akpm@osdl.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
        Roman Zippel <zippel@linux-m68k.org>, Andi Kleen <ak@suse.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] lapic-timer: increase the max_delta to 31 bits
In-Reply-To: <1294327409-19426-1-git-send-email-pierre.tardy@intel.com>
Message-ID: <alpine.LFD.2.00.1101100932400.12146@localhost6.localdomain6>
References: <1294327409-19426-1-git-send-email-pierre.tardy@intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011, Pierre Tardy wrote:

> Latest atom socs(penwell) does not have hpet timer.
> 
> As their local APIC timer is clocked at 400KHZ, and the current code
> limit their Initial Counter register to 23 bits, they cannot sleep
> more than 1.34 seconds which leads to ~2 spurious wakeup per second (1 per thread)
> 
> These SOCs support 32bit timer so we change the max_delta to at least 31bits.
> So we can at least sleep for 300 seconds.
> 
> We could not find any previous chip errata where lapic would only have 23 bit precision
> As powertop is suggesting to activate HPET to "sleep longer", this could mean this problem is
> already known.

I have no idea why I put this limit there back then. If there is no
erratum then there is no reason to keep it.

Acked-by: Thomas Gleixner <tglx@linutronix.de>

 
> Problem is here since very first implementation of lapic timer as a clock event
> e9e2cdb [PATCH] clockevents: i386 drivers
> cc contributors of the first patch and x86 maintainers
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 7821813..c031f1d 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -684,7 +684,7 @@ static int __init calibrate_APIC_clock(void)
>  	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
>  				       lapic_clockevent.shift);
>  	lapic_clockevent.max_delta_ns =
> -		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
> +		clockevent_delta2ns(0x7FFFFFFF, &lapic_clockevent);
>  	lapic_clockevent.min_delta_ns =
>  		clockevent_delta2ns(0xF, &lapic_clockevent);
>  
> -- 
> 1.7.0.4
> 
> ---------------------------------------------------------------------
> Intel Corporation SAS (French simplified joint stock company)
> Registered headquarters: "Les Montalets"- 2, rue de Paris, 
> 92196 Meudon Cedex, France
> Registration Number:  302 456 199 R.C.S. NANTERRE
> Capital: 4,572,000 Euros
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
> 
