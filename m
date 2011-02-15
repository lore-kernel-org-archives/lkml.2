Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab1BOBgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:36:51 -0500
Received: from adelie.canonical.com ([91.189.90.139]:54708 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab1BOBgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:36:49 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
Date: Tue, 15 Feb 2011 09:36:25 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; x86_64; ; )
Cc: Ryan Mallon <ryan@bluewatersys.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
References: <1297233693.242364.862698430999.1.gpush@pororo> <4D52F73A.4010707@bluewatersys.com>
In-Reply-To: <4D52F73A.4010707@bluewatersys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102150936.26110.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

> > +int clk_enable(struct clk *clk)
> > +{
> > +	unsigned long flags;
> > +	int ret = 0;
> > +
> > +	spin_lock_irqsave(&clk->enable_lock, flags);
> 
> 	WARN_ON(clk->prepare_count == 0); ?

Added later, but yes.

> 
> > +	if (clk->enable_count == 0 && clk->ops->enable)
> > +		ret = clk->ops->enable(clk);
> 
> Does it make sense to have a clock with no enable function which still
> returns success from clk_enable? Do we have any platforms which have
> NULL clk_enable functions?

It does, yes. Driver code should be always be calling clk_enable before using 
a clock, regardless of the implementation (which it shouldn't have to care 
abut), and should abort their initialisation if the clk_enable() fails.

Some clocks are always running, so the enable op will be empty. This is not an 
error, so the driver is free to continue.

> I think that for enable/disable at least we should require platforms to
> provide functions and oops if they have failed to do so. In the rare
> case that a platform doesn't need to do anything for enable/disable they
> can just supply empty functions.

Sounds like useless boilerplate - it's not an error to not need 
enable/disable, so I don't see why we need to add extra effort to handle this 
case.

> > +/**
> > + * __clk_get - acquire a reference to a clock
> > + *
> > + * @clk: The clock to refcount
> > + *
> > + * Before a clock is returned from clk_get, this function should be
> > called + * to update any clock-specific refcounting.
> 
> This is a bit misleading. It's not "should be called", it "is called". I
> think you should just remove the documentation for __clk_get/__clk_put
> or move it into clk.c since the functions are only used internally by
> the common clock code.

It'd be nice to remove this from the header, but this means we'll need extern 
prototypes in clkdev.c. Might be a reasonable compromise though.


> > +/**
> > + * clk_prepare - prepare clock for atomic enabling.
> > + *
> > + * @clk: The clock to prepare
> > + *
> > + * Do any blocking initialisation on @clk, allowing the clock to be
> > later + * enabled atomically (via clk_enable). This function may sleep.
> 
> "Possibly blocking" as below?

Yep, will unify these (and spell "possibly" correctly :) )

Cheers,


Jeremy
