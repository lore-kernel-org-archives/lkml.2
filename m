Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1K3W2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 17:28:42 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:32824 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab1K3W2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 17:28:41 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18mNR1QuTC8e4VpL/iXE3nW
Date: Wed, 30 Nov 2011 14:28:38 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2a/5 v2] ARM: OMAP1: select clock rate by CPU type
Message-ID: <20111130222837.GR31337@atomide.com>
References: <20111128174508.GO31337@atomide.com>
 <1322686675-26855-1-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322686675-26855-1-git-send-email-jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111130 12:23]:
> DPLL1 reprogramming to a different rate is actually blocked inside
> omap1_select_table_rate(), resulting in the defalut rate of 60 MHz
> always used instead of the one selected in .config. OTOH, in
> omap1_defconfig we currently rely on Kconfig options for the supported
> MHz rates in case of boards which boot with dpll1 not set correctly by
> their boot loaders.
> 
> This means that before we allow for reprogramming of dpll1 rate, we
> should prevent from incompatible clock rates being selected, otherwise
> omap1_defconfig will stop booting on boards with imperfect boot loaders,
> as it would always try to change to 216MHz.
> 
> Expand omap1_rate_table with flags for different CPU types and match
> them while selecting clock rates. The idea is stolen from current
> omap24xx clock rate selection algorithm.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> ---
> Hi,
> Since there is no response to patch 2a/5 "Remove unsafe clock values 
> from omap1_defconfig" yet, while rc4 is probably almost out:

Well I'm still wondering what would be the absolute minimal fixe(s)
for the -rc cycle?

Is the problem just that currently with omap1_defconfig boards boot at
the bootloader rate, or at the safe 60MHz unless the .config is changed?
If so, I think that's OK for now as fixing it properly requires what
this patch is doing.
 
> If there are reasons for keeping high clock rates selected in
> omap1_defconfig, and those reasons are more important than fixing bugs
> which prevent some boards from working correctly under 3.2, here is an
> alternative, low intrusive solution which should allow booting from
> omap1_defconfig at correct speeds, selected by CPU type. If the idea is
> acceptable, please review the CPU per clock rate selections I made,
> since I'm not sure about their correctness, perhaps except CK_1510,
> which is based on my own experience with Amstrad Delta. I'll fix that if
> necessary.

Great, this looks like pretty much what I had in mind for the next
merge window! Just one comment below.

 
> @@ -21,38 +22,52 @@ struct mpu_rate omap1_rate_table[] = {
>  	 * armdiv, dspdiv, dspmmu, tcdiv, perdiv, lcddiv
>  	 */
>  #if defined(CONFIG_OMAP_ARM_216MHZ)
> -	{ 216000000, 12000000, 216000000, 0x050d, 0x2910 }, /* 1/1/2/2/2/8 */
> +	{ 216000000, 12000000, 216000000, 0x050d, 0x2910, /* 1/1/2/2/2/8 */
> +			CK_16XX },
>  #endif
>  #if defined(CONFIG_OMAP_ARM_195MHZ)
> -	{ 195000000, 13000000, 195000000, 0x050e, 0x2790 }, /* 1/1/2/2/4/8 */
> +	{ 195000000, 13000000, 195000000, 0x050e, 0x2790, /* 1/1/2/2/4/8 */
> +			CK_7XX|CK_16XX },
>  #endif
>  #if defined(CONFIG_OMAP_ARM_192MHZ)
...

We should also now be able to remove all the CONFIG_OMAP_ARM_XXXMHZ options
too, right?

Regards,

Tony
