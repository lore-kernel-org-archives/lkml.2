Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab1LATXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 14:23:53 -0500
Received: from d1.icnet.pl ([212.160.220.21]:42268 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199Ab1LATXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 14:23:52 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 2a/5] Remove unsafe clock values from omap1_defconfig
Date: Thu, 1 Dec 2011 20:23:04 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20111128174508.GO31337@atomide.com> <201112011938.36706.jkrzyszt@tis.icnet.pl> <20111201190455.GV31337@atomide.com>
In-Reply-To: <20111201190455.GV31337@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112012023.04635.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 of December 2011 at 20:04:55, Tony Lindgren wrote:
> 
> From: Tony Lindgren <tony@atomide.com>
> Date: Thu, 1 Dec 2011 11:00:11 -0800
> Subject: [PATCH] ARM: OMAP1: Fix reprogramming of DPLL1 for systems that boot at rates below 60MHz
> 
> Commit e9b7086b80c4d9e354f4edc9e280ae85a60df408 (ARM: OMAP: Fix
> reprogramming of dpll1 rate) fixed a regression for systems that
> did not rely on bootloader set rates.
> 
> However, it also introduced a new problem where the rates selected
> in .config would not take affect as omap1_select_table_rate
> currently refuses to reprogram DPLL1 if it's already initialized.
> 
> This was not a problem earlier, as the reprogramming was done
> earlier with ck_dpll1_p->rate uninitialized.
> 
> Fix this by forcing the reprogramming on systems booting at rates
> below 60MHz. Note that the long term fix is to make the rates
> SoC specific later on.
> 
> Thanks for Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> for figuring
> this one out.
> 
> Reported-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Acked-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

However, this way or another, we are back to your mentioned problem of 
omap1_defconfig always switching to 216 MHz, I'm afraid. Then, 2a/5 v1 
"Remove unsafe clock values from omap1_defconfig" can still be helpful.

Anyway, I'm resending (refreshed) 2/5 and 5/5 as rc fixes as you 
suggested before, 1/5 "ARM: OMAP1: Fix dpll1 default rate reprogramming 
method" intended for next, and 2a/5 v2 "ARM: OMAP1: select clock rate by 
CPU type" also for next but as an RFC. 

Thanks,
Janusz

> 
> diff --git a/arch/arm/mach-omap1/clock_data.c b/arch/arm/mach-omap1/clock_data.c
> index 1297bb5..3f30561 100644
> --- a/arch/arm/mach-omap1/clock_data.c
> +++ b/arch/arm/mach-omap1/clock_data.c
> @@ -930,6 +930,9 @@ void __init omap1_clk_late_init(void)
>  	if (ck_dpll1.rate >= OMAP1_DPLL1_SANE_VALUE)
>  		return;
>  
> +	/* System booting at unusable rate, force reprogramming of DPLL1 */
> +	ck_dpll1_p->rate = 0;
> +
>  	/* Find the highest supported frequency and enable it */
>  	if (omap1_select_table_rate(&virtual_ck_mpu, ~0)) {
>  		pr_err("System frequencies not set, using default. Check your config.\n");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
