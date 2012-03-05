Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab2CEJxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 04:53:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44152 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387Ab2CEJxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 04:53:38 -0500
Date: Mon, 5 Mar 2012 08:38:36 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Paul Walmsley <paul@pwsan.com>,
        linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 3/4] clk: introduce the common clock framework
Message-ID: <20120305073836.GU3852@pengutronix.de>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-4-git-send-email-mturquette@linaro.org>
 <20120303133158.GA26882@pengutronix.de>
 <CAJOA=zNFNEHxBDhRDdvm7DYR83R0LJjsp_AT3BoG+nL+iN5_tw@mail.gmail.com>
 <20120304115201.GB26882@pengutronix.de>
 <CAJOA=zP8d8wm==7=svOzh03Ft-1_LV71q0mA6Pncrh5vQSWGEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJOA=zP8d8wm==7=svOzh03Ft-1_LV71q0mA6Pncrh5vQSWGEA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:20:00 up 113 days, 15:07, 16 users,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2012 at 04:12:21PM -0800, Turquette, Mike wrote:
> >>
> >> I believe this patch already does what you suggest, but I might be
> >> missing your point.
> >
> > In include/linux/clk-private.h you expose struct clk outside the core.
> > This has to be done to make static initializers possible. There is a big
> > warning in this file that it must not be included from files implementing
> > struct clk_ops. You can simply avoid this warning by declaring struct clk
> > with only a single member:
> >
> > include/linux/clk.h:
> >
> > struct clk {
> >        struct clk_internal *internal;
> > };
> >
> > This way everybody knows struct clk (thus can embed it in their static
> > initializers), but doesn't know anything about the internal members. Now
> > in drivers/clk/clk.c you declare struct clk_internal exactly like struct
> > clk was declared before:
> >
> > struct clk_internal {
> >        const char              *name;
> >        const struct clk_ops    *ops;
> >        struct clk_hw           *hw;
> >        struct clk              *parent;
> >        char                    **parent_names;
> >        struct clk              **parents;
> >        u8                      num_parents;
> >        unsigned long           rate;
> >        unsigned long           flags;
> >        unsigned int            enable_count;
> >        unsigned int            prepare_count;
> >        struct hlist_head       children;
> >        struct hlist_node       child_node;
> >        unsigned int            notifier_count;
> > #ifdef CONFIG_COMMON_CLK_DEBUG
> >        struct dentry           *dentry;
> > #endif
> > };
> >
> > An instance of struct clk_internal will be allocated in
> > __clk_init/clk_register. Now the private data stays completely inside
> > the core and noone can abuse it.
> 
> Hi Sascha,
> 
> I see the disconnect here.  For OMAP (and possibly other platforms) at
> least some clock data is necessary during early boot, before the
> regular allocation methods are available (timers for instance).

We had this problem on i.MX aswell. It turned out that the timer clock
is the only clock that is needed so early. We solved this by moving the
clock init to the system timer init function.

> Due
> to this my idea of static initialization was to take care of
> everything that would normally require an allocator, which includes
> the internals of struct clk; thus exposing struct clk is useful here
> as you can still use the clock framework during very early boot.  Your
> method above doesn't satisfy this requirement.  I'm not sure what the
> purpose would be of statically allocating your version of struct clk,
> which will ultimately need to allocate memory for the clock internals
> anyways.  Can you elaborate the benefit of this approach over just
> using the clk_foo_register functions?

As said the benefit is that you do not have to expose the internal
layout of struct clk outside the clock framework. Note that in the
file you referenced here:

http://git.linaro.org/gitweb?p=people/mturquette/linux.git;a=blob;f=arch/arm/mach-omap2/clock44xx_data.c;h=7f833a7b2dca84a52c2bd1e7c8d9cfe560771258;hb=v3.3-rc5-clkv5-omap#l205

You violate what you have in a comment above clk-private.h:

/* __clk_init is only exposed via clk-private.h and is intended for use with
 * very large numbers of clocks that need to be statically initialized. It is
 * a layering violation to include clk-private.h from any code which implements
 * a clock's .ops; as such any statically initialized clock data MUST be in
 * separate C file from the logic that implements it's operations.
 */

Well, the file is work in progress, you probably fix this before sending
it out, but I bet people will include clk-private.h and nobody else
notices it.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
