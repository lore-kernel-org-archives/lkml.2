Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1DSWAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 18:00:25 -0400
Received: from linux-sh.org ([111.68.239.195]:36840 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab1DSWAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 18:00:24 -0400
Date: Wed, 20 Apr 2011 06:59:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@suse.de>
Subject: Re: [Update][PATCH 7/9] PM / Runtime: Add generic clock manipulation rountines for runtime PM
Message-ID: <20110419215944.GA10031@linux-sh.org>
References: <201104130205.26988.rjw@sisk.pl> <201104170143.28980.rjw@sisk.pl> <20110418081809.GA32457@linux-sh.org> <201104182157.28373.rjw@sisk.pl> <201104130205.26988.rjw@sisk.pl> <201104182159.54316.rjw@sisk.pl> <BANLkTimZpXAH7uGTDmYJSJJWgX=H5md0JQ@mail.gmail.com> <201104192342.26670.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104182157.28373.rjw@sisk.pl> <201104192342.26670.rjw@sisk.pl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 11:42:26PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, April 19, 2011, Magnus Damm wrote:
> > Do you have any plans to add support for multiple clocks per struct
> > device? I had some plans to play around with that myself, but if we're
> > moving the code to a common place then this obviously becomes a bit
> > more complicated.
> > 
> > It's rather common that each hardware block in an SoC is connected to
> > more than a single clock. This needs to be managed by software
> > somehow.
> > 
> > So if the plan is to make to the code generic, how about allowing the
> > architecture to associate clocks with each struct device somehow?
> 
> Hmm.  For now, my patchset generally reorganizes the existing code without
> adding new functionality.  Of course, it is possible to add new functionality
> on top of it, but I'd prefer to focus on the "real" power domains support
> first (which I think should be done in a generic way too).
> 
Multiple clocks is not new functionality, it's the common case for the
bulk of the platforms, and something that is already presently handled.

> The plan is to share as much code as it makes sense between platforms and
> architectures.

An admirable plan, but the framework needs to be able to provide at least
the current required level of functionality in order for it to be
adopted, too.

On Mon, Apr 18, 2011 at 09:57:28PM +0200, Rafael J. Wysocki wrote:
> @@ -24,23 +24,18 @@
>  #ifdef CONFIG_PM_RUNTIME
>  static int omap1_pm_runtime_suspend(struct device *dev)
>  {
> -	struct clk *iclk, *fclk;
> -	int ret = 0;
> +	int ret;
>  
>  	dev_dbg(dev, "%s\n", __func__);
>  
>  	ret = pm_generic_runtime_suspend(dev);
> +	if (ret)
> +		return ret;
>  
> -	fclk = clk_get(dev, "fck");
> -	if (!IS_ERR(fclk)) {
> -		clk_disable(fclk);
> -		clk_put(fclk);
> -	}
> -
> -	iclk = clk_get(dev, "ick");
> -	if (!IS_ERR(iclk)) {
> -		clk_disable(iclk);
> -		clk_put(iclk);
> +	ret = pm_runtime_clock_suspend(dev);
> +	if (ret) {
> +		pm_generic_runtime_resume(dev);
> +		return ret;
>  	}
>  
>  	return 0;

The before and after changes here are not functionally equivalent. You've
gone from an explicit multi-clock scheme to a single encapsulated one via
pm_runtime_clock_suspend().

Almost every single SH IP block is likewise abstracted in to a function
and interface clock, and OMAP and others are where we modelled this
abstraction on top of in the first place, so there are certainly users
there too.
