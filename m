Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab1LASji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:39:38 -0500
Received: from d1.icnet.pl ([212.160.220.21]:37084 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783Ab1LASjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:39:36 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 2a/5] Remove unsafe clock values from omap1_defconfig
Date: Thu, 1 Dec 2011 19:38:32 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20111128174508.GO31337@atomide.com> <201112011054.09878.jkrzyszt@tis.icnet.pl> <20111201171758.GT31337@atomide.com>
In-Reply-To: <20111201171758.GT31337@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112011938.36706.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 of December 2011 at 18:17:58, Tony Lindgren wrote:
> * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111201 01:20]:
[snip]
> > Perhaps 
> > we should rather think of reverting a few commits which caused all these 
> > problems if fixing them all during rc cycle seems not possible? I 
> > haven't bisected them yet, rather concentrated on providing fixes, but I 
> > can still try to do it, starting back from the original issue 
> > (http://www.spinics.net/lists/linux-omap/msg60052.html), if so decided.
> 
> We can't revert that because the SRAM init has been moved to later for
> map_io. 

Yes, I know that. What I don't know yet is what else should be reverted 
to fix the original issue other than applying  
e9b7086b80c4d9e354f4edc9e280ae85a60df408, which seems to introduce (or 
maybe 'exhibit' is a better word here) more bugs than it fixes.

> But if that patch changed the behaviour on your board, then that's
> the problem we should fix.
> 
> If you're now stuck at 60MHz rate, care to see if the following patch
> makes the kernel behave the same way as before for you?
[snip]
> 
> --- a/arch/arm/mach-omap1/clock_data.c
> +++ b/arch/arm/mach-omap1/clock_data.c
> @@ -927,7 +927,7 @@ int __init omap1_clk_init(void)
>  
>  void __init omap1_clk_late_init(void)
>  {
> -	if (ck_dpll1.rate >= OMAP1_DPLL1_SANE_VALUE)
> +	if (ck_dpll1.rate > OMAP1_DPLL1_SANE_VALUE)
>  		return;
>  
>  	/* Find the highest supported frequency and enable it */

This change really makes sense to me, however, knowing the initial 
(bootloader selected) clock rate my board boots at, which is 
unfortunately raw 12 MHz, I would be surprised if that helped.

Before e9b7086b80c4d9e354f4edc9e280ae85a60df408, 
omap1_select_table_rate() was returning the rate selected with .config 
because it was called early, with ck_dpll1_p->rate uninitialized. Now it 
is not, and returns nothing, resulting in 60 MHz default. Then, the only 
way I can see to correct the problem is something like patch 3/5, which 
you are justifiably affraid of of always switching to 216 MHz with 
omap1_defconfig.

Thanks,
Janusz
