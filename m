Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab1BHCzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 21:55:10 -0500
Received: from adelie.canonical.com ([91.189.90.139]:55254 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab1BHCzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 21:55:08 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
Date: Tue, 8 Feb 2011 10:54:57 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
References: <1297058877.800158.458894385837.1.gpush@pororo> <4D50541B.2030405@bluewatersys.com>
In-Reply-To: <4D50541B.2030405@bluewatersys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102081054.58005.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

> > +int clk_prepare(struct clk *clk)
> > +{
> > +	int ret = 0;
> > +
> > +	if (!clk->ops->prepare)
> > +		return 0;
> 
> If there is no ops->prepare function then we never increment
> prepare_count, which means that driver writers can get sloppy if they
> know that ops->prepare is no-op on their platform since they will not
> get warned for omitting clk_prepare.

Yeah, as discussed in other replies, it's probably best that we do the 
counting unconditionally. I've removed these optimisations - I think we'd best 
enforce the checking here, at least at the introduction of this API.
 
> Also, why are the warnings added in a separate patch rather than being
> rolled into this patch?

Just splitting things up; the warnings were the most discussed issue 
previously, so I wanted to separate that discussion from the API side.

> Again, you should still increment enable_count even if ops->enabled is a
> no-op since it provides valuable warnings when clk_enable/disable calls
> are not matched correctly.

Yep, as above.

> > +unsigned long clk_get_rate(struct clk *clk)
> > +{
> > +	if (clk->ops->get_rate)
> > +		return clk->ops->get_rate(clk);
> 
> Possibly we should shadow the clock rate if ops->get_rate is no-op? So
> clock initialisation and clk_set_rate store the rate in the shadow
> field, and then do:
> 
> 	if (clk->ops->get_rate)
> 		return clk->ops->get_rate(clk);
> 	return clk->shadow_rate;
> 
> Because the API is generic, driver writers should reasonably expect that
> clk_get_rate will return something valid without having to know the
> platform implementation details. It may also be worth having a warning
> to let the user know that the returned rate may be approximate.

I'd prefer to require that get_rate is implemented as an op, rather than 
allowing two methods for retrieving the rate of the clock.

> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(clk_get_rate);
> > +
> > +int __clk_get(struct clk *clk)
> > +{
> > +	if (clk->ops->get)
> > +		return clk->ops->get(clk);
> > +	return 1;
> > +}
> > +EXPORT_SYMBOL_GPL(__clk_get);
> > +
> > +void clk_put(struct clk *clk)
> > +{
> > +	if (clk->ops->put)
> > +		clk->ops->put(clk);
> > +}
> > +EXPORT_SYMBOL_GPL(clk_put);
> 
> This has probably been covered, and I have probably missed it, but why
> don't the generic clk_get/put functions do ref-counting? Drivers must
> have matched clk_get/put calls so it should work like enable/prepare
> counting right?

clk_get is used to find a clock; most implementations will not use this for 
refcounting.

However, for the case where clocks are dynamically allocated, we need clk_put 
to do any possible freeing. There's an existing API for this type of reference 
counting (kref), so for the cases where this matters, the clock 
implementations can use that.

> > + * The choice of atomic or non-atomic clock depends on how the clock is
> > enabled. + * Typically, you'll want to use a non-atomic clock. For
> > clocks that need to be + * enabled/disabled in interrupt context, use
> > CLK_ATOMIC. Note that atomic + * clocks with parents will typically
> > cascade enable/disable operations to + * their parent, so the parent of
> > an atomic clock *must* be atomic too.
> 
> This comment seems out of date now that we have the prepare/enable
> semantics?

Yep, will update.

> > + * @unprepare:	Release the clock from its prepared state. This will
> > typically + *		undo any work done in the @prepare callback. Called 
> > with + *		clk->prepare_lock held.
> 
> I think you need to make it more clear the prepare/unprepare must be
> called from a sleepable context.

The documentation on clk_ops is intended for the clock implementor, so it's 
not really the right place to descibe the caller's requirements.

Indeed, the documentation for clk_prepare & clk_unprepare describe the 
caller's requirements for these (and contain the words "This function may 
sleep").

> > + * Typically, drivers will call clk_prepare when a clock may be needed
> > later + * (eg. when a device is opened), and clk_enable when the clock
> > is actually + * required (eg. from an interrupt).
> 
> Drivers _must_ call clk_prepare before clk_enable (not typically)?

This 'typically' is about the actual placement of the clk_prepare and 
clk_enable calls in the driver code, but I will clarify.

> > +/**
> > + * __clk_get - update clock-specific refcounter
> > + *
> > + * @clk: The clock to refcount
> > + *
> > + * Before a clock is returned from clk_get, this function should be
> > called + * to update any clock-specific refcounting.
> > + *
> > + * Returns non-zero on success, zero on failure.
> > + *
> > + * Drivers should not need this function; it is only needed by the
> > + * arch-specific clk_get() implementations.
> > + */
> > +int __clk_get(struct clk *clk);
> 
> I don't understand this. Are architectures supposed to provide a
> function called clk_get? Doesn't this break the whole idea of having a
> common struct clk?

clk_get() is now provided in drivers/clk/clkdev.c; the arch-specific part of 
this comment is old (I'll remove it).

Thanks for taking the time to review, I appreciate it.

Cheers,


Jeremy
