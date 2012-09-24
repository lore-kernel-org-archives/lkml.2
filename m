Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab2IXUfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:35:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39278 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874Ab2IXUfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:35:41 -0400
Date: Mon, 24 Sep 2012 21:35:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] Introduce devm_clk_register()
Message-ID: <20120924203524.GH26454@n2100.arm.linux.org.uk>
References: <1348034730-16473-1-git-send-email-sboyd@codeaurora.org> <20120922100604.GI15609@n2100.arm.linux.org.uk> <5060C09A.6080706@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5060C09A.6080706@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 01:20:42PM -0700, Stephen Boyd wrote:
> On 09/22/12 03:06, Russell King - ARM Linux wrote:
> > On Tue, Sep 18, 2012 at 11:05:27PM -0700, Stephen Boyd wrote:
> >> The first patch in this series fixes error checking in the wm831x clock
> >> driver and is here to prevent context conflicts in the third patch.
> >> I split it out in case it needed to merge sooner rather than later.
> >>
> >> The goal of this series is to add devm_clk_register() so I can use it in
> >> some MSM clock code I'm sending out in the near future. The second 
> >> patch adds the API and the third patch moves over an existing user of
> >> clk_unregister() to the devm API.
> > Can we guarantee that the clocks are unused when the module is removed?
> > If we can't make that guarantee, then devm_* should not be used here,
> > and instead there should be refcounting done in the clocks (that's what
> > the __clk_get() and __clk_put() hooks are there for.)
> 
> We could guarantee that when clk_unregister() is actually implemented.
> __clk_get() would need to forward a call to the module providing the
> clock via try_module_get(). Similarly we would call module_put() in
> __clk_put(). That would prevent unbinding the driver from the device via
> module removal.

Strangely enough... mach-integrator's clkdev.h... precisely because it
has a module which may provide a clock.

static inline int __clk_get(struct clk *clk)
{
        return try_module_get(clk->owner);
}

static inline void __clk_put(struct clk *clk)
{
        module_put(clk->owner);
}

