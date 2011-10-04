Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab1JDSJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 14:09:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34277 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933285Ab1JDSJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 14:09:24 -0400
Date: Tue, 4 Oct 2011 12:09:14 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        paul@pwsan.com, linaro-dev@lists.linaro.org,
        linus.walleij@stericsson.com, patches@linaro.org, eric.miao@linaro.org,
        broonie@opensource.wolfsonmicro.com, magnus.damm@gmail.com,
        amit.kucheria@linaro.org, richard.zhao@linaro.org, dsaxena@linaro.org,
        arnd.bergmann@linaro.org, shawn.guo@freescale.com, skannan@quicinc.com,
        linux@arm.linux.org.uk, jeremy.kerr@canonical.com, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, sboyd@quiinc.com
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Message-ID: <20111004180914.GC2870@ponder.secretlab.ca>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-2-git-send-email-mturquette@ti.com>
 <4E89C3FA.9020206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E89C3FA.9020206@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 09:17:30AM -0500, Rob Herring wrote:
> On 09/22/2011 05:26 PM, Mike Turquette wrote:
> > +	/* Query the hardware for parent and initial rate */
> > +
> > +	if (clk->ops->get_parent)
> > +		/* We don't to lock against prepare/enable here, as
> > +		 * the clock is not yet accessible from anywhere */
> > +		clk->parent = clk->ops->get_parent(clk->hw);
> 
> I don't think this is going to work. This implies that the parent clock
> is already registered. For simple clk trees, that's probably not an
> issue, but for chips with lots of muxing it will be impossible to get
> the order correct for all cases. This is not an issue today as most
> clocks are statically created.
> 
> I think what is needed is a 2 stage init. The 1st stage to create all
> the clocks and a 2nd stage to build the tree once all clocks are created.
> 
> Tracking the parents using struct clk_hw instead would help as long as
> clocks are still statically allocated. However, that won't help for
> devicetree.

I disagree.  Clocks really need to be registered in dependency order.
Even in the deferral case, the driver should hold of actually
registering the clk (note: the struct clk, not the struct device)
until the clocks it depends on are available.

I also agree with the point that there are a lot of SoC clocks that
may not even show up in clkdev, and for pragmatic considerations are
better set up all at once early in the init process (ie. as part of
common SoC setup code, and doesn't change between boards).  That code
should be clue-full enough that it can register its own clocks in the
right order.

g.

