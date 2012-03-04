Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2CDLwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 06:52:18 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54704 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab2CDLwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 06:52:16 -0500
Date: Sun, 4 Mar 2012 12:52:01 +0100
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
Message-ID: <20120304115201.GB26882@pengutronix.de>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-4-git-send-email-mturquette@linaro.org>
 <20120303133158.GA26882@pengutronix.de>
 <CAJOA=zNFNEHxBDhRDdvm7DYR83R0LJjsp_AT3BoG+nL+iN5_tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJOA=zNFNEHxBDhRDdvm7DYR83R0LJjsp_AT3BoG+nL+iN5_tw@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:01:10 up 112 days, 18:48, 17 users,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2012 at 09:14:43AM -0800, Turquette, Mike wrote:
> On Sat, Mar 3, 2012 at 5:31 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Sat, Mar 03, 2012 at 12:29:00AM -0800, Mike Turquette wrote:
> >> The common clock framework defines a common struct clk useful across
> >> most platforms as well as an implementation of the clk api that drivers
> >> can use safely for managing clocks.
> >>
> >> The net result is consolidation of many different struct clk definitions
> >> and platform-specific clock framework implementations.
> >>
> >> This patch introduces the common struct clk, struct clk_ops and an
> >> implementation of the well-known clock api in include/clk/clk.h.
> >> Platforms may define their own hardware-specific clock structure and
> >> their own clock operation callbacks, so long as it wraps an instance of
> >> struct clk_hw.
> >>
> >> See Documentation/clk.txt for more details.
> >>
> >> This patch is based on the work of Jeremy Kerr, which in turn was based
> >> on the work of Ben Herrenschmidt.
> >>
> >> +
> >> +/**
> >> + * struct clk_hw - handle for traversing from a struct clk to its corresponding
> >> + * hardware-specific structure.  struct clk_hw should be declared within struct
> >> + * clk_foo and then referenced by the struct clk instance that uses struct
> >> + * clk_foo's clk_ops
> >> + *
> >> + * clk: pointer to the struct clk instance that points back to this struct
> >> + * clk_hw instance
> >> + */
> >> +struct clk_hw {
> >> +     struct clk *clk;
> >> +};
> >
> > The reason for doing this is that struct clk should be an opaque cookie
> > for both drivers and implementers of clocks. I recently had the idea whether
> > the roles of these two structs could be swapped. So instead of the above we
> > could do:
> >
> > struct clk {
> >        struct clk_hw *hw;
> > }
> 
> Firstly, struct clk is an opaque cookie for both drivers and
> implementers of clocks with this patchset.
> 
> Secondly, struct clk does indeed have a pointer to struct clk_hw.
> Refer to include/linux/clk-private.h in this patch.
> 
> The reference is cyclical.  A reference to struct clk can navigate to
> struct clk_foo via container_of (usually something like "#define
> to_clk_foo(_hw) container_of(_hw, struct clk_foo, hw)" where struct
> clk's pointer to it's .hw member is passed into one of the struct
> clk_ops callbacks.
> 
> Likewise if struct clk_foo needs the struct clk ptr for any reason
> then it can get it from foo->hw->clk.
> 
> I believe this patch already does what you suggest, but I might be
> missing your point.

In include/linux/clk-private.h you expose struct clk outside the core.
This has to be done to make static initializers possible. There is a big
warning in this file that it must not be included from files implementing
struct clk_ops. You can simply avoid this warning by declaring struct clk
with only a single member:

include/linux/clk.h:

struct clk {
	struct clk_internal *internal;
};

This way everybody knows struct clk (thus can embed it in their static
initializers), but doesn't know anything about the internal members. Now
in drivers/clk/clk.c you declare struct clk_internal exactly like struct
clk was declared before:

struct clk_internal {
	const char		*name;
	const struct clk_ops	*ops;
	struct clk_hw		*hw;
	struct clk		*parent;
	char			**parent_names;
	struct clk		**parents;
	u8			num_parents;
	unsigned long		rate;
	unsigned long		flags;
	unsigned int		enable_count;
	unsigned int		prepare_count;
	struct hlist_head	children;
	struct hlist_node	child_node;
	unsigned int		notifier_count;
#ifdef CONFIG_COMMON_CLK_DEBUG
	struct dentry		*dentry;
#endif
};

An instance of struct clk_internal will be allocated in
__clk_init/clk_register. Now the private data stays completely inside
the core and noone can abuse it.

With this __clk_init could be something like:

struct clk_initializer {
	const char		*name;
	const struct clk_ops	*ops;
	char			**parent_names;
	u8			num_parents;
	unsigned long		flags;
	struct clk		*clk;
};

void __clk_init(struct device *dev, struct clk_initializer *init);

I hope I made my intention a bit clearer.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
