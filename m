Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1K1RpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:45:15 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55089 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1K1RpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:45:13 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18+EtkX2vfeyPLf4AU1ROrN
Date: Mon, 28 Nov 2011 09:45:09 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] ARM: OMAP1: Fix dpll1 default rate reprogramming
 method
Message-ID: <20111128174508.GO31337@atomide.com>
References: <1322364751-29980-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <1322364751-29980-2-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322364751-29980-2-git-send-email-jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111126 19:06]:
> According to comments in omap1_select_table_rate(), reprogramming dpll1
> is tricky, and should always be done from SRAM.
> 
> While being at it, move OMAP730 special case handling inside
> omap_sram_reprogram_clock().
> 
> Created on top of omap-fixes, not yet in mainline as of 3.2-rc3.
> Tested on Amstrad Delta.

Thanks for looking into these issues. For most of this we should plan on
getting them done for the next merge window because we currently rely
on Kconfig options for the supported MHz rates. This means that with
this change omap1_defconfig will stop booting on most systems as it
would try to change to 216MHz. To fix that issue we should allow the
boards to set the supported rates before applying this patch.

Regards,

Tony
 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> ---
>  arch/arm/mach-omap1/clock.c      |    6 +-----
>  arch/arm/mach-omap1/clock_data.c |    7 +++++--
>  arch/arm/plat-omap/sram.c        |    3 +++
>  3 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/mach-omap1/clock.c b/arch/arm/mach-omap1/clock.c
> index 84ef704..3899176 100644
> --- a/arch/arm/mach-omap1/clock.c
> +++ b/arch/arm/mach-omap1/clock.c
> @@ -215,12 +215,8 @@ int omap1_select_table_rate(struct clk *clk, unsigned long rate)
>  	/*
>  	 * In most cases we should not need to reprogram DPLL.
>  	 * Reprogramming the DPLL is tricky, it must be done from SRAM.
> -	 * (on 730, bit 13 must always be 1)
>  	 */
> -	if (cpu_is_omap7xx())
> -		omap_sram_reprogram_clock(ptr->dpllctl_val, ptr->ckctl_val | 0x2000);
> -	else
> -		omap_sram_reprogram_clock(ptr->dpllctl_val, ptr->ckctl_val);
> +	omap_sram_reprogram_clock(ptr->dpllctl_val, ptr->ckctl_val);
>  
>  	/* XXX Do we need to recalculate the tree below DPLL1 at this point? */
>  	ck_dpll1_p->rate = ptr->pll_rate;
> diff --git a/arch/arm/mach-omap1/clock_data.c b/arch/arm/mach-omap1/clock_data.c
> index 1297bb5..4550415 100644
> --- a/arch/arm/mach-omap1/clock_data.c
> +++ b/arch/arm/mach-omap1/clock_data.c
> @@ -23,6 +23,7 @@
>  #include <plat/clock.h>
>  #include <plat/cpu.h>
>  #include <plat/clkdev_omap.h>
> +#include <plat/sram.h>	/* for omap_sram_reprogram_clock() */
>  #include <plat/usb.h>   /* for OTG_BASE */
>  
>  #include "clock.h"
> @@ -933,8 +934,10 @@ void __init omap1_clk_late_init(void)
>  	/* Find the highest supported frequency and enable it */
>  	if (omap1_select_table_rate(&virtual_ck_mpu, ~0)) {
>  		pr_err("System frequencies not set, using default. Check your config.\n");
> -		omap_writew(0x2290, DPLL_CTL);
> -		omap_writew(cpu_is_omap7xx() ? 0x3005 : 0x1005, ARM_CKCTL);
> +		/*
> +		 * Reprogramming the DPLL is tricky, it must be done from SRAM.
> +		 */
> +		omap_sram_reprogram_clock(0x2290, 0x1005);
>  		ck_dpll1.rate = OMAP1_DPLL1_SANE_VALUE;
>  	}
>  	propagate_rate(&ck_dpll1);
> diff --git a/arch/arm/plat-omap/sram.c b/arch/arm/plat-omap/sram.c
> index 8b28664..312bee8 100644
> --- a/arch/arm/plat-omap/sram.c
> +++ b/arch/arm/plat-omap/sram.c
> @@ -224,6 +224,9 @@ static void (*_omap_sram_reprogram_clock)(u32 dpllctl, u32 ckctl);
>  void omap_sram_reprogram_clock(u32 dpllctl, u32 ckctl)
>  {
>  	BUG_ON(!_omap_sram_reprogram_clock);
> +	/* On 730, bit 13 must always be 1 */
> +	if (cpu_is_omap7xx())
> +		ckctl |= 0x2000;
>  	_omap_sram_reprogram_clock(dpllctl, ckctl);
>  }
>  
> -- 
> 1.7.3.4
> 
