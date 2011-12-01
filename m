Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab1LATFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 14:05:00 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:46708 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab1LATE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 14:04:59 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+P3eMyyz0grxqsaep3wFqG
Date: Thu, 1 Dec 2011 11:04:55 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2a/5] Remove unsafe clock values from omap1_defconfig
Message-ID: <20111201190455.GV31337@atomide.com>
References: <20111128174508.GO31337@atomide.com>
 <201112011054.09878.jkrzyszt@tis.icnet.pl>
 <20111201171758.GT31337@atomide.com>
 <201112011938.36706.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112011938.36706.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111201 10:04]:
> On Thursday 01 of December 2011 at 18:17:58, Tony Lindgren wrote:
> > 
> > --- a/arch/arm/mach-omap1/clock_data.c
> > +++ b/arch/arm/mach-omap1/clock_data.c
> > @@ -927,7 +927,7 @@ int __init omap1_clk_init(void)
> >  
> >  void __init omap1_clk_late_init(void)
> >  {
> > -	if (ck_dpll1.rate >= OMAP1_DPLL1_SANE_VALUE)
> > +	if (ck_dpll1.rate > OMAP1_DPLL1_SANE_VALUE)
> >  		return;
> >  
> >  	/* Find the highest supported frequency and enable it */
> 
> This change really makes sense to me, however, knowing the initial 
> (bootloader selected) clock rate my board boots at, which is 
> unfortunately raw 12 MHz, I would be surprised if that helped.

OK, that's not it then. BTW, we should be able to drop that test once
we have your patches applied.
 
> Before e9b7086b80c4d9e354f4edc9e280ae85a60df408, 
> omap1_select_table_rate() was returning the rate selected with .config 
> because it was called early, with ck_dpll1_p->rate uninitialized. Now it 
> is not, and returns nothing, resulting in 60 MHz default. Then, the only 
> way I can see to correct the problem is something like patch 3/5, which 
> you are justifiably affraid of of always switching to 216 MHz with 
> omap1_defconfig.

Ah, you got it! That's what causes the regression. How about the following
fix for the -rc cycle then?

Tony


From: Tony Lindgren <tony@atomide.com>
Date: Thu, 1 Dec 2011 11:00:11 -0800
Subject: [PATCH] ARM: OMAP1: Fix reprogramming of DPLL1 for systems that boot at rates below 60MHz

Commit e9b7086b80c4d9e354f4edc9e280ae85a60df408 (ARM: OMAP: Fix
reprogramming of dpll1 rate) fixed a regression for systems that
did not rely on bootloader set rates.

However, it also introduced a new problem where the rates selected
in .config would not take affect as omap1_select_table_rate
currently refuses to reprogram DPLL1 if it's already initialized.

This was not a problem earlier, as the reprogramming was done
earlier with ck_dpll1_p->rate uninitialized.

Fix this by forcing the reprogramming on systems booting at rates
below 60MHz. Note that the long term fix is to make the rates
SoC specific later on.

Thanks for Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> for figuring
this one out.

Reported-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap1/clock_data.c b/arch/arm/mach-omap1/clock_data.c
index 1297bb5..3f30561 100644
--- a/arch/arm/mach-omap1/clock_data.c
+++ b/arch/arm/mach-omap1/clock_data.c
@@ -930,6 +930,9 @@ void __init omap1_clk_late_init(void)
 	if (ck_dpll1.rate >= OMAP1_DPLL1_SANE_VALUE)
 		return;
 
+	/* System booting at unusable rate, force reprogramming of DPLL1 */
+	ck_dpll1_p->rate = 0;
+
 	/* Find the highest supported frequency and enable it */
 	if (omap1_select_table_rate(&virtual_ck_mpu, ~0)) {
 		pr_err("System frequencies not set, using default. Check your config.\n");
