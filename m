Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab0LJB6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 20:58:43 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56760 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab0LJB6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 20:58:41 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/2] Add a common struct clk
Date: Fri, 10 Dec 2010 09:58:31 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1291773932.578726.468741339223.1.gpush@pororo> <20101208102150.GJ18244@pengutronix.de>
In-Reply-To: <20101208102150.GJ18244@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012100958.32365.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe

> > +/**
> > + * clk_ops: Callback operations for clocks; these are to be provided by
> > the + * clock implementation, and will be called by drivers through the
> > clk_* API. + *
> > + * @enable:	Enable the clock. This must not return until the clock is
> > + *		generating a valid clock signal, usable by consumer devices.
> > + *		Called with clk->lock held.
> > + *
> > + * @disable:	Disable the clock. Called with clk->lock held.
> > + *
> > + * @get	/ @put:	Called by the core clock code to notify the driver 
about
> 
> I wonder if this is valid kerneldoc.  The tab before / looks (IMHO)
> ugly.

Not valid kernel doc, so I'll fix that up. The tab was unintentional.

> Maybe specify "driver" a bit more to distinguish from "drivers"
> above.  "clk_ops driver"?

This is actually for refcounting for uses by device drivers (ie, not the clock 
provider), I've updated the comment:

/**
 * struct clk_ops -  Callback operations for clocks; these are to be provided
 * by the clock implementation, and will be called by drivers through the
 * clk_* API.
 *
 * @enable:	Enable the clock. This must not return until the clock is
 *		generating a valid clock signal, usable by consumer devices.
 *		Called with clk->lock held.
 *
 * @disable:	Disable the clock. Called with clk->lock held.
 *
 * @get:	     Called by the core clock code to increment the clock's
 *		     refount as clk is passed to device drivers. Optional.
 *
 * @put:	     Called by the core clock code to decrement the clocks's
 *		     refounts as clk is released from device drivers. Optional.
 *
 * For other callbacks, see the corresponding clk_* functions. Parameters and
 * return values are passed directly from/to these API functions, or
 * -ENOSYS is returned if the callback is NULL, see kernel/clk.c for
 * implementation details. All are optional.
 */

> > +/**
> > + * __clk_get - update clock-specific refcounter
> > + *
> > + * @clk: The clock to refcount
> 
> "The clock to update the refcount for"?

I'm using refcount as a verb here; if this isn't clear I can come up with 
something else. Your solution splits the 'clock' and the 'for' which may be 
difficult to parse too. Let me know if you have any other suggestions :)

> I wonder if it's worth to handle parents here, e.g.
> 
> 	if (!clk->enable_count) {
> 		struct clk *parent = clk_get_parent(clk);
> 		if (parent) {
> 			ret = clk_enable(parent);
> 			if (ret)
> 				return ret;
> 		}
> 
> 		ret = clk->ops->enable(clk);
> 		if (likely(!ret))
> 			clk->enable_count++;
> 		else if (parent)
> 			clk_disable(parent);
> 	}
> 
> as they are quite common.

I'm not convinced we should do the parent handling in the core clock code. 
It's fairly easy to do the parent enable/disable in platform code, which 
should have explicit knowledge about whether or not the clock has a parent, 
and the semantics of how the parent/child clocks interact.

However, happy to discuss this further if needs be.

> > +void clk_disable(struct clk *clk)
> > +{
> > +	if (!clk->ops->disable)
> > +		return;
> 
> 	WARN_ON(!clk->enable_count) ?

Yep, good idea. I'll do this check with the lock acquired.

Thanks for the comments, I've updated my tree accordingly (along with some 
other kerneldoc fixups). I'll wait to see if there is any other feedback and 
re-post next week.

Cheers,


Jeremy
