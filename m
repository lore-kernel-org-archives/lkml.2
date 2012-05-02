Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab2EBKDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:03:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33531 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab2EBKDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:03:05 -0400
Date: Wed, 2 May 2012 11:02:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
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
Message-ID: <20120502100225.GB24211@n2100.arm.linux.org.uk>
References: <1335419936-10881-1-git-send-email-skannan@codeaurora.org> <20120502095816.GG20478@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502095816.GG20478@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 11:58:16AM +0200, Sascha Hauer wrote:
> > diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
> > index 6e58f11..8e97491 100644
> > --- a/drivers/clk/clk-mux.c
> > +++ b/drivers/clk/clk-mux.c
> > @@ -95,6 +95,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
> >  {
> >  	struct clk_mux *mux;
> >  	struct clk *clk;
> > +	struct clk_init_data init;
> >  
> >  	/* allocate the mux */
> >  	mux = kzalloc(sizeof(struct clk_mux), GFP_KERNEL);
> > @@ -103,6 +104,12 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
> >  		return ERR_PTR(-ENOMEM);
> >  	}
> >  
> > +	init.name = name;
> > +	init.ops = &clk_mux_ops;
> > +	init.flags = flags;
> > +	init.parent_names = parent_names;
> > +	init.num_parents = num_parents;
> > +
> >  	/* struct clk_mux assignments */
> >  	mux->reg = reg;
> >  	mux->shift = shift;
> > @@ -110,8 +117,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
> >  	mux->flags = clk_mux_flags;
> >  	mux->lock = lock;
> 
> There is a mux->hw.init = &init missing here.

What happens to mux->hw.init long term?  Because once this function
returns, that pointer will no longer be valid.  It would be a good
idea to NULL it out in clk_register() once its done with, to ensure
that no one comes up with the idea of using it later.
