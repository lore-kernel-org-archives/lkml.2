Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933743Ab1ETNZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:25:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:36036 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932947Ab1ETNZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:25:29 -0400
Date: Fri, 20 May 2011 15:25:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Jeremy Kerr <jeremy.kerr@canonical.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/4] clk: Add a generic clock infrastructure
In-Reply-To: <20110520115936.GA10931@pengutronix.de>
Message-ID: <alpine.LFD.2.02.1105201521560.3078@ionos>
References: <1305876469.325655.313573683829.0.gpush@pororo> <1305876469.326305.518470530485.1.gpush@pororo> <20110520115936.GA10931@pengutronix.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011, Sascha Hauer wrote:

> Hi Jeremy,
> 
> Nice to see progress in this area :)
> 
> On Fri, May 20, 2011 at 03:27:49PM +0800, Jeremy Kerr wrote:
> > +
> > +struct clk *clk_register(struct clk_hw_ops *ops, struct clk_hw *hw,
> > +		const char *name)
> > +{
> > +	struct clk *clk;
> > +
> > +	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
> > +	if (!clk)
> > +		return NULL;
> > +
> > +	clk->name = name;
> > +	clk->ops = ops;
> > +	clk->hw = hw;
> > +	hw->clk = clk;
> 
> is it worth to add a CLK_REGISTERED flag here? Up to now clocks do not
> have to be registered at all and the registering might be forgotten for
> some clocks. I suppose funny things can happen when we operate on
> unregistered clocks.

No, because not registered clocks are not accessible :)

 > +
> > +	/* Query the hardware for parent and initial rate */
> > +
> > +	if (clk->ops->get_parent)
> > +		/* We don't to lock against prepare/enable here, as
> > +		 * the clock is not yet accessible from anywhere */
> > +		clk->parent = clk->ops->get_parent(clk->hw);
> > +
> > +	if (clk->ops->recalc_rate)
> > +		clk->rate = clk->ops->recalc_rate(clk->hw);
> 
> This implicitely requires that we never register a clock before its
> parent is registered. This makes perfect sense but I think we should
> catch it here when the user tries to register a clock with a not yet
> registered parent.

We can agree on that, but we can make it more clever than that.
 
> > +
> > +
> > +	return clk;
> > +}
> > +EXPORT_SYMBOL_GPL(clk_register);
> 
> BTW we planned to let the linker do the job of registering static
> clocks, but this is only convenience and can be added later.

Right, you just need a helper function which runs through the list of
static stuff.

