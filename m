Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab0IHJvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 05:51:51 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:54462 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756838Ab0IHJvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 05:51:48 -0400
Date: Wed, 8 Sep 2010 11:50:58 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: "avictor.za@gmail.com" <avictor.za@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabian Godehardt <fg@emlix.com>
Subject: Re: [PATCH] AT91: SAM9G45 - add a separate clock entry for every
 single TC block
Message-ID: <20100908095058.GA3939@game.jcrosoft.org>
References: <201009060548.18521.fg@emlix.com>
 <1283772201-15453-1-git-send-email-nicolas.ferre@atmel.com>
 <AANLkTin+vCsG3FUvX6DTUfFe7ZJpbkYyqw_TLvH9ujrJ@mail.gmail.com>
 <4C8750B8.6000107@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8750B8.6000107@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 6678838249225694060
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:00 Wed 08 Sep     , Nicolas Ferre wrote:
> Le 07/09/2010 21:42, avictor.za@gmail.com :
> > hi,
> > 
> >> +/* One additional fake clock for second TC block */
> >> +static struct clk tcb1_clk = {
> >> +       .name           = "tcb1_clk",
> >> +       .pmc_mask       = 0,
> >> +       .type           = CLK_TYPE_PERIPHERAL,
> >> +       .parent         = &tcb0_clk,
> >> +};
> >> +
> > 
> > Looking at this again...  since type is CLK_TYPE_PERIPHERAL, when you
> > call clk_register() the "parent" is changed to the master clock.
> > 
> > Which means, then later you call clk_enable() the "pmc_mask" is still
> > 0, so 0 gets written (in pmc_periph_mode) to AT91_PMC_PCER.  So the
> > TCB clock won't be enabled.
> > 
> > Or am I missing something?
> 
> You are absolutely right!
> 
> What do you think about this modification of clk_register() function?
> 
> --- a/arch/arm/mach-at91/clock.c
> +++ b/arch/arm/mach-at91/clock.c
> @@ -501,7 +501,8 @@ postcore_initcall(at91_clk_debugfs_init);
>  int __init clk_register(struct clk *clk)
>  {
>         if (clk_is_peripheral(clk)) {
> -               clk->parent = &mck;
> +               if (!clk->parent)
> +                       clk->parent = &mck;
>                 clk->mode = pmc_periph_mode;
>                 list_add_tail(&clk->node, &clocks);
>         }
> 
> It is a very little modification which implements what I had in mind
> while creating a kind of "child peripheral" clock.
so so

but until we switch to clkdev it will solve the issue

Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
