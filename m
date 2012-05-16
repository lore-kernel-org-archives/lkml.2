Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967149Ab2EPAZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 20:25:17 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:10579
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966208Ab2EPAZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 20:25:15 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 16 May 2012 08:25:01 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Saravana Kannan <skannan@codeaurora.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        <linux-arm-msm@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>
Subject: Re: [PATCH] clk: Fix CLK_SET_RATE_GATE flag validation in
 clk_set_rate().
Message-ID: <20120516002500.GD29393@b20223-02.ap.freescale.net>
References: <1336798797-8724-1-git-send-email-skannan@codeaurora.org>
 <1337114622-11292-1-git-send-email-skannan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1337114622-11292-1-git-send-email-skannan@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 01:43:42PM -0700, Saravana Kannan wrote:
> The clk_set_rate() code shouldn't check the clock's enable count when
> validating CLK_SET_RATE_GATE flag since the enable count could change after
> the validation. Similar to clk_set_parent(), it should instead check the
> prepare count. The prepare count should go to zero only when the end user
> expects the clock to not be enabled in the future. Since the code already
> grabs the prepare count before validation, it's not possible for prepare
> count to change after validation and by association not possible for a well
> behaving end user to enable the clock while the set rate is in progress.
> 
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
Reviewed-by: Richard Zhao <richard.zhao@freescale.com>
> ---
> Please let me know if you don't want me to directly email or CC you in my
> clock related patches. I don't want to spam anyone. Also, let me know if
> you want me add you to my standard list of people to cc in my clock
> patches.
> 
>  drivers/clk/clk.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 09b9112..f5b9d3c 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -903,7 +903,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
>  	if (rate == clk->rate)
>  		goto out;
>  
> -	if ((clk->flags & CLK_SET_RATE_GATE) && __clk_is_enabled(clk)) {
> +	if ((clk->flags & CLK_SET_RATE_GATE) && clk->prepare_count) {
>  		ret = -EBUSY;
>  		goto out;
>  	}
> -- 
> 1.7.8.3
> 
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

