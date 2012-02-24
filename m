Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab2BXRcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:32:24 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15116 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab2BXRcW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:32:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 24 Feb 2012 09:32:06 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 24 Feb 2012 09:32:07 -0800
Subject: RE: [PATCH 1/3] pinctrl: Introduce PINCTRL_STATE_DEFAULT define,
 and use it
Thread-Topic: [PATCH 1/3] pinctrl: Introduce PINCTRL_STATE_DEFAULT define,
 and use it
Thread-Index: Aczywkg/3ded0V+eSDecGy03y6OOuAAVsf/A
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCC8F@HQMAIL01.nvidia.com>
References: <1330041880-12406-1-git-send-email-swarren@nvidia.com>
 <20120224032451.GA25789@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCC1F@HQMAIL01.nvidia.com>
 <20120224070952.GD25789@shlinux2.ap.freescale.net>
In-Reply-To: <20120224070952.GD25789@shlinux2.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dong Aisheng wrote at Friday, February 24, 2012 12:10 AM:
> On Thu, Feb 23, 2012 at 09:26:14PM -0800, Stephen Warren wrote:
> > Dong Aisheng wrote at Thursday, February 23, 2012 8:25 PM:
> > > On Fri, Feb 24, 2012 at 08:04:38AM +0800, Stephen Warren wrote:
> > > > This provides a single centralized name for the default state.
> > > >
> > > > Update PIN_MAP_* macros to use this state name, instead of requiring the
> > > > user to pass a state name in.
> > ...
> > > > diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> > ...
> > > > -       PIN_MAP("I2CMAP", "pinctrl-foo", "i2c0", "foo-i2c.0"),
> > > > +	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0", "foo-i2c.0"),
> > >
> > > To keep align with the following
> > > PIN_MAP_SYS_HOG("pinmux-u300", "power"),
> > > Maybe PIN_MAP("pinctrl-foo", "i2c0", "foo-i2c.0") is better, right?
> > >
> > > And we may want to add a PIN_MAP_STAT macro, as well as PIN_MAP_SYS_HOG_STAT.
> >
> > I don't think so.
> >
> > PIN_MAP_SYS_HOG hard-codes the state name inside the macro because its
> > sole purpose is to support drivers/pinctrl/core.c's pinctrl_get() call
> > for pin hogging purposes, so that state name is always "default", or
> > rather, PINCTRL_STATE_DEFAULT.
> 
> I'm considering that we may also need to support multi states for system hog
> functions, do you agree?

Well, I don't think that'd be hogging; to my mind, hogging is specifically 
setting up PINCTRL_STATE_DEFAULT when a pin controller is registered.

But yes, I can see that the pinctrl core might want to use other state
names for a pin controller, e.g. for suspend/resume, when unregistering
the pin controller driver, etc.

That's exactly why in the mapping table rework patch I posted, I wrote
a single all-encompassing table entry macro that'd work for all these
situations, without the need to create a ton of special-case macros.

Still, I suppose now I've already enhanced that patch to support a few
special case macros, I can add yet more. But, please can I defer this
to that later patch rather than this one, since I'm already reworking
all the macros there to support the enhanced mapping table format for
pin config too?

> > BTW, did you have any further thoughts on (not) allowing NULL state names?
> > I'd like to repost the final version of that patch, or rework it so that
> > the code actually does allow NULL state names ASAP (i.e. early Friday for
> > me), since it blocks some of the later patches in the series. Thanks.
>
> Personally i wish to support NULL state name.
> But if it really can't, i can also accept no NULL state names.

OK, can I take that as an ACK for my patch that completely removes the
partial support for them ("Assume map table entries can't have a NULL
name filed")?

> You mentioned it may cause many problems on DT side to support NULL state.
> I'm still thinking the problems we're facing for dt and if we can fix it.
> 
> Thinking the model we discussed in Linaro connect:
> sdhci@c8000200 {
> 	pinctrl-0 = <&pmx_sdhci &pmx_sdhci_active>;
> 	pinctrl-1 = <&pmx_sdhci &pmx_sdhci_standby>;
> 	/* An optional list of state names; depends on SDHCI driver */
> 	pinctrl-names = "active", "suspend";
> };
> The orginally purpose will convert the id of pinctrl-0 (eg. it's '0' here)
> to be the state name if no pincgtrl-names property defined.
> I'm wondering can we not use that id, just treat this case as no state names?
> If that we can allow dt to define null state names.
> And it's easy for map writers to write such map.
> 
> But i do not know how much troubles it will be caused in implementation since
> you're writing all these code.
> 
> What do you think of it?

That sure seems like adding a special-case to the device tree parsing
code solely to provide justification for a special case in the mapping
table processing code.

My root issue here: Why do we want a NULL name field? It serves no
benefit that I can see, slightly complicates the code, obscures information
in device drivers (since they aren't requesting a particular state name)
and the pinctrl debugfs files (since we have these unnamed states, so
people need to know what that means), etc.

Given I've agreed to make macros that set .name = PINCTRL_STATE_DEFAULT
so that no mapping table author will need to do this, I don't think that
having .name=PINCTRL_STATE_DEFAULT is going to save anything either.

-- 
nvpublic

