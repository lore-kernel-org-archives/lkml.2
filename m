Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2CTSK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 14:10:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58723 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2CTSK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 14:10:56 -0400
Date: Tue, 20 Mar 2012 19:10:50 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>, Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] clk: Move init fields from clk to clk_hw
Message-ID: <20120320181050.GN3852@pengutronix.de>
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com>
 <1332214706-675-1-git-send-email-skannan@codeaurora.org>
 <1332214706-675-2-git-send-email-skannan@codeaurora.org>
 <20120320072018.GC32469@S2101-09.ap.freescale.net>
 <cbd6490459b9fd68875fec4a7c7de073.squirrel@www.codeaurora.org>
 <20120320094031.GI3852@pengutronix.de>
 <20120320141811.GF32469@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120320141811.GF32469@S2101-09.ap.freescale.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:37:12 up 129 days,  1:24, 55 users,  load average: 0.10, 0.08,
 0.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 10:18:14PM +0800, Shawn Guo wrote:
> On Tue, Mar 20, 2012 at 10:40:31AM +0100, Sascha Hauer wrote:
> ...
> > I am using these functions and don't need a static array, I just call
> > the functions with the desired parameters.
> > 
> With this patch getting in, you do not have to use them then.  I feel
> a static array will be much more readable than a long list of function
> calls with a long list of hardcoded arguments to each.

I'm also not a fan of long argument lists; a divider like defined in my
tree takes 5 arguments, a gate 4 and a mux 6. While 6 is already at the
border I think it's still acceptable.

What I like in terms of readability is one line per clock which makes
for quite short clock files.

So when we use structs to initialize the clocks we'll probably have
something like this:

static struct clk_divider somediv = {
	.reg = CCM_BASE + 0x14,
	.width = 3,
	.shift = 17,
	.lock = &ccm_lock,
	.hw.parent = "someotherdiv",
	.hw.flags = CLK_SET_RATE_PARENT,
};

This will make a 4000 line file out of a 500 line file. Now when for
some reason struct clk_divider changes we end with big patches. If the
clk core gets a new fancy CLK_ flag which we want to have then again
we end up with big patches. Then there's also the possibility that
someone finds out that .lock and .hw.flags are common to all dividers
and comes up with a #define DEFINE_CLK_DIVIDER again to share common
fields.

All this can be solved when we introduce a small wrapper function and
use it in the clock files:

static inline struct clk *imx_clk_divider(const char *name, const char *parent,
		void __iomem *reg, u8 shift, u8 width)
{
	return clk_register_divider(NULL, name, parent, CLK_SET_RATE_PARENT,
			reg, shift, width, 0, &imx_ccm_lock);
}

It decouples us from the structs used by the clock framework, we can
add our preferred flags and still can share common fields like the lock.

While this was not the intention when I first converted from struct
initializers to function initializers I am confident that it will make
a good job.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
