Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab2EDGvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 02:51:08 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34136 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2EDGvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 02:51:06 -0400
Date: Fri, 4 May 2012 08:50:59 +0200
From: Domenico Andreoli <cavokz@gmail.com>
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
Message-ID: <20120504065059.GA16265@glitch>
Mail-Followup-To: Saravana Kannan <skannan@codeaurora.org>,
	Mike Turquette <mturquette@linaro.org>,
	Arnd Bergman <arnd.bergmann@linaro.org>,
	linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
	Paul Walmsley <paul@pwsan.com>,
	Russell King <linux@arm.linux.org.uk>,
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
References: <1335419936-10881-1-git-send-email-skannan@codeaurora.org>
 <20120503230308.GA13016@glitch>
 <4FA32CDC.3070005@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA32CDC.3070005@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 06:11:56PM -0700, Saravana Kannan wrote:
> On 05/03/2012 04:03 PM, Domenico Andreoli wrote:
> >On Wed, Apr 25, 2012 at 10:58:56PM -0700, Saravana Kannan wrote:
> >>
> >>diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> >>index 90627e4..8ea11b4 100644
> >>--- a/drivers/clk/clk-divider.c
> >>+++ b/drivers/clk/clk-divider.c
> >>@@ -167,6 +167,7 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
> >>  {
> >>  	struct clk_divider *div;
> >>  	struct clk *clk;
> >>+	struct clk_init_data init;
> >>
> >>  	/* allocate the divider */
> >>  	div = kzalloc(sizeof(struct clk_divider), GFP_KERNEL);
> >>@@ -175,19 +176,22 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
> >>  		return ERR_PTR(-ENOMEM);
> >>  	}
> >>
> >>+	init.name = name;
> >>+	init.ops =&clk_divider_ops;
> >>+	init.flags = flags;
> >>+	init.parent_names = (parent_name ?&parent_name: NULL);
> >>+	init.num_parents = (parent_name ? 1 : 0);
> >>+
> >>  	/* struct clk_divider assignments */
> >>  	div->reg = reg;
> >>  	div->shift = shift;
> >>  	div->width = width;
> >>  	div->flags = clk_divider_flags;
> >>  	div->lock = lock;
> >>+	div->hw.init =&init;
> >>
> >>  	/* register the clock */
> >>-	clk = clk_register(dev, name,
> >>-			&clk_divider_ops,&div->hw,
> >>-			(parent_name ?&parent_name: NULL),
> >>-			(parent_name ? 1 : 0),
> >>-			flags);
> >>+	clk = clk_register(dev,&div->hw);
> >>
> >>  	if (IS_ERR(clk))
> >>  		kfree(div);
> >
> >I would prefer to rip the parent _settings_ configuration out of
> >clk_register(). It's optional right? And passing a single parent is a
> >common case.
> >
> >Three cases:
> >
> >   1) one parent:
> >      __clk_register_parent(clk, parent_name);
> >      clk_register(dev, name,&ops, flags);
> >
> >   2) many parents:
> >      __clk_register_parents(clk, parent_names, num_parents);
> >      clk_register(dev, name,&ops, flags);
> >
> >   3) no parents:
> >      clk_register(dev, name,&ops, flags);
> >
> >You may also want to move the whole parent initialization into
> >__clk_register_parents() and call it after clk_register(), it would
> >simplify some error paths.
> >
> >This pattern could be used also with other common clocks registration
> >functions (fixed rate, divider, mux, etc) that may have complex
> >initializations and/or optional parameters that cannot go all on the
> >same function call.
> 
> Please no. If anything, make those other register functions go in
> the direction of clk_register(). Have a long list of params to a
> function and then having it fill up a structure just makes the code
> less readable. Why would that be any better than having the whole
> structure statically declared or the whole structure dynamically
> populated (by device tree) and then calling clk_register()?
> 
> Take about 50 clocks with 3 parents each and try to register them in
> the way you suggested and in a way how clk_register() in this patch
> will need you to declare them statically. Compare the two and see
> which would be more readable.

I was not thinking at the static initialization at all (but I was
forgetting that clk does not yet exist before the invocation of
clk_register).

For a few hours I was convinced that moving the parent initialization
stuff in a separate function would have allowed also to ditch the (IMHO)
horrible whole name caching (whose purpose is... allowing to register
clock with a parent not yet known to the clock subsystem?)

Unfortunately the whole idea is quite invasive and the benefits
debatable, it's simply too late to speak.

Thanks anyway.

Domenico
