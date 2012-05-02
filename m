Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612Ab2EBCJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 22:09:16 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:36445 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758432Ab2EBCJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 22:09:09 -0400
Date: Tue, 1 May 2012 19:04:18 -0700
From: Mike Turquette <mturquette@ti.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH] clk: Use a separate struct for holding init data.
Message-ID: <20120502020418.GF17311@gmail.com>
References: <1335419936-10881-1-git-send-email-skannan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335419936-10881-1-git-send-email-skannan@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120425-22:58, Saravana Kannan wrote:
> Create a struct clk_init_data to hold all data that needs to be passed from
> the platfrom specific driver to the common clock framework during clock
> registration. Add a pointer to this struct inside clk_hw.
> 
> This has several advantages:
> * Completely hides struct clk from many clock platform drivers and static
>   clock initialization code that don't care for static initialization of
>   the struct clks.
> * For platforms that want to do complete static initialization, it removed
>   the need to directly mess with the struct clk's fields while still
>   allowing to statically allocate struct clk. This keeps the code more
>   future proof even if they include clk-private.h.
> * Simplifies the generic clk_register() function and allows adding optional
>   fields in the future without modifying the function signature.
> * Simplifies the static initialization of clocks on all platforms by
>   removing the need for forward delcarations or convoluted macros.
> 
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>

Hi Saravana,

Thanks for the patch.  I've taken it into my clk-next but I have two
points:

1) I'm surprised that you abandoned the approach of exposing the
less-private members of struct clk via struct clk_hw.  Your original
patch did just that, but did not account for static initialization.
This patch seems to have gone in the opposite direction and only
accounts for static initialization.

I'm happy to take the patch as-is, but I did think that there were
merits to your original approach.

2) I did make a modification to your patch where I kept the
DEFINE_CLK_* macros and continued to declare __clk_init in
clk-private.h.  I do want to get rid of both of these in the future but
currently my platform relies on static initialization before the
allocator is available.  Please let me know if this causes a problem for
you.

Platform folks should rebase on top of this if needed.  This should be
the last change to the driver/platform-facing API before 3.5.

Sascha,

Can you resubmit your fixed-factor clock?  I think the registration
function collides with these changes.

Thanks,
Mike
