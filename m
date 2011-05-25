Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab1EYLoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 07:44:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:53706 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab1EYLoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 07:44:01 -0400
Date: Wed, 25 May 2011 13:43:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Colin Cross <ccross@google.com>
cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/4] clk: Add a generic clock infrastructure
In-Reply-To: <BANLkTinmRt_fv1oJwFuJQ34aAky_5SB4Rw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1105251324500.3078@ionos>
References: <1305876469.325655.313573683829.0.gpush@pororo> <1305876469.326305.518470530485.1.gpush@pororo> <BANLkTin2Ho-Ce-4RurtHfAST7hqTLDrJ+g@mail.gmail.com> <20110524070236.GB22096@pengutronix.de> <BANLkTinmRt_fv1oJwFuJQ34aAky_5SB4Rw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1286234412-1306323837=:3078"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1286234412-1306323837=:3078
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 24 May 2011, Colin Cross wrote:
> On Tue, May 24, 2011 at 12:02 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >> > +       struct clk              *parent;
> >>
> >> Storing the list of possible parents at this level can help abstract
> >> some common code from mux ops if you pass the index into the list of
> >> the new parent into the op - most mux ops only need to know which of
> >> their mux inputs needs to be enabled.
> >
> > Please don't. Only muxes have more than one possible parent, so this
> > should be handled there.
> 
> The cost is one pointer per clock that is not actually a mux, and the
> benefit is that you can move a very common search loop out of every
> mux implementation into the framework.  It also lets you determine
> which clocks are connected, which becomes necessary if you try to do
> per-tree locking or sysfs controls for clocks.

We can be more clever than storing the world and some more in the
internal implementation.

struct clk should be just the basic data structure to hold the
information which is shared by all clk types. The way I see it is:

struct clk {
       struct clk_ops *ops;
       struct clk_data *data;
       void *hwdata;
       unsigned long flags;
       ....
};

Now have

struct clk_data {
       union {
       	     struct clk_divider_data;
	     struct clk_mux_data;
	     struct clk_pll_data;
	     .....
       };
};

Now on registration time you tell the core which type you are handing
in. struct clk_mux_data would contain the list of possible parent
clocks and clk_pll_data the possible multiplier values (linear or
table based). Same for dividers. Now the core can do the evaluation of
clock rate settings or parents and hand in the index or the linear
range value into ops->set_rate/set_parent. And with the information
available to the core you can do even complex settings which involve
selecting the proper pll for your pixelclock example below.

> > I hope we can avoid that. The decision of the best parent should be left
> > up to the user. Doing this in the mux/divider implementation would
> > torpedo attempts to implement generic building blocks.
> 
> I agree it would be nice, but it does push some knowledge of the clock
> tree into device drivers.  For example, on Tegra the display driver
> may need to change the source pll of the display clock to get the
> required pclk, which requires passing all the possible parents of the
> display clock into the display driver.  If this is a common usage
> pattern, there needs to be a hook in the ops to allow the clock or
> clock chip to make a more global decision.

No, we really dont want to have that knowledge at the driver level. A
driver should just say: Enable "pixelclk" at rate X.

So then a mapper converts pixelclk to the particular clock on the SoC
it's running on and the clk framework level needs to figure out how to
achieve that by looking at the full chain down from the clk gate which
feeds the pixelclk. We don't want drivers to be aware about that at
all. They simply do not care and that's a preliminary for making
drivers usable on different SoC incarnations.
 
Thanks,

	tglx
--8323328-1286234412-1306323837=:3078--
