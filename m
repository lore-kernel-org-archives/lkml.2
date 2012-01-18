Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab2ARTnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:43:05 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17669 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406Ab2ARTnC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:43:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Jan 2012 11:42:22 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "Shawn Guo (shawn.guo@linaro.org)" <shawn.guo@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Wed, 18 Jan 2012 11:42:20 -0800
Subject: RE: Pinmux bindings proposal
Thread-Topic: Pinmux bindings proposal
Thread-Index: AczSMvpNTKYWSKFeSLCZTyHqrIN5SAB+76JwAEZwauAAGMdXIAAa2F2Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1780DAAEAF@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885091DEA@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17801D22DE@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885093D83@039-SN2MPN1-013.039d.mgd.msft.net>
In-Reply-To: <7FE21149F4667147B645348EC6057885093D83@039-SN2MPN1-013.039d.mgd.msft.net>
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

Dong Aisheng wrote at Wednesday, January 18, 2012 12:24 AM:
> Stephen Warren wrote at Wednesday, January 18, 2012 3:09 AM:
> > Dong Aisheng wrote at Monday, January 16, 2012 5:50 AM:
> > > Stephen Warren wrote at Saturday, January 14, 2012 4:40 AM:
> > > > I thought a bit more about pinmux DT bindings. I came up with
> > > > something that I like well enough, and is pretty similar to the binding that
> > > > Dong posted recently.
...
> > Just to be clear, I'll repeat part of my previous response to Shawn:
> >
> > * Just a further explanation on my original code: I always intended that
> > * each entry in that list was a full pinmux configuration that could include
> > * mux and pin configuration settings. Thus, the above is more like:
> > *
> > * pinctrl =
> > *     <"default" &pmx_sdhci_a>
> > *     <"default" &pmx_sdhci_overrides>
> > *
> > * (overrides rather than explicit separate mux/config; the separate mux
> > * And config were just an example use case).
> >
> > So that was a list where the /examples/ had two entries, one for mux and one for
> > pin config. In general, there could be 1, 2, 3, ... entries and each could
> > define whatever mux and config entries they wanted.
>
> I also read your reply to Shawn's mail.
> I guess you mean the first "default" entry may not sufficient to use, so we allow
> customer defines extra pmx_sdhci_overrides in board.dts to use?
> 
> Personally I did not see big benefits for this way but introduce a bit complexity
> and make the code not clear and not easily to understand.
> Why not define it completely for one pinmux group?

I have already enumeration the reasons. The most relevant one here is
so that if you have a pre-defined pin configuration node that's 99% what
you need, you can use that, and add any custom options on top of it
without cut/pasting the whole thing first.

> I think it also does not meet the current pinctrl subsystem design.
> The group and functions are defined, customer only needs to tell what they want to
> use. For example, in non-dt case, a pinmux map table is enough to use.

Well, we can always change the pinctrl subsystem to suite everyone's needs.

But, I don't see what doesn't fit the existing pinctrl design, at least
for muxing (pin config is still in flux irrespective of device tree...)

Is your issue that with board files, you'd typically register a single
large pinmux mapping table, whereas with this proposed device tree binding,
you end up representing a lot of separate chunks of the table in different
places? When parsing those chunks, you can certainly aggregate them all
into a single table to register with the pinctrl subsystem. That said,
the pinctrl subsystem does allow you to incrementally register more and
more table entries though, so you shouldn't actually have to convert
everything into a single table.

...
> Yes, after looking Linus's patch to support pin states, I'm thinking for pin config
> case we may need such a property or flag to tell which config of state to use by
> default since we support multi states.

I don't think we need an explicit flag. We could either:

a) Say "first entry is the default". IIRC, this is how the pinmux mapping
table works.

Or:

b) The entries are named. For the system-wide pin config table that's
in Linus's latest patch, we can simply define a specific name for the
default, e.g. "default". When I get around to responding to Linus's
pin config patch, I expect to make this comment.

c) The entries are named. Drivers request explicit names for the
pin mux configuration, and can do the same for any separate pin config
requests if they aren't wrapped into a single request. Thus, it's up
to the driver to define what the default name is. I'd pick "default"
myself.

> > b) function name: The pinmux_ops for the driver of pmx_controller_phandle needs
> > a function to convert integer IDs such as TEGRA_PMX_MUX_1 to whatever function
> > IDs are used by the pinctrl subsystem.
>
> No, I guess Tegra can do this since tegra prefers to define functions and groups
> In pinctrl driver.
> But for IMX, we do not have these info before the imx-pinctrl driver gets run and
> Parse the device tree.

The same issue exists for interrupts and GPIO, where parsing a device's
reference to an IRQ/GPIO controller needs that controller to have been
probed first, and the conversion function registered.

For interrupts, this has been solved by explicitly initializing the IRQ
controller very early in boot.

For GPIOs, I'm don't think this has been solved; it works by accident
in most cases.

I think the solution for GPIO and pinmux is to rely on the device probe
deferral patches that Grant posted a while back; defer parsing of the
pinmux properties until after the controller that contains those pin
configuration nodes has been probed (or perhaps force it to be probed
when its node is first encountered?)

> 
> > c) group name: This should be handled just like (b).
> >
> > Also you'll need to know:
> >
> > struct pinmux_map's .name field. This is the value in the pinctrl-names property,
> > assuming we're switching to the following syntax:
> >
> >     pinctrl = <&pmx_sdhci_a_active>, <&pmx_sdhci_a_suspend>;
> >     pinctrl-names = "default", "suspend";
>
> Here the pinctrl-names are representing 'state'.
> Is pinmux_map.name field used for this?

Yes.

...
> > 2) On IMX, you'd define a pin group for each individual pin, since the HW muxing
> > is at a pin not a group level.
>
> Yes, this is what I'm thinking now.
> If we decide to do that, the pin groups concepts of current pinmux subsystem
> Seems does not fit for IMX a lot since each group is only one pin.
> And the functions/groups would be hugh since IMX6Q has 196 pins and each pin may have
> 7 functions.

We should investigate modifying the pinctrl subsystem so that either:

a) The pin mux mapping table can refer to either pins or groups, on a
per controller basis, based on some flag in struct pinctrl_desc.

b) Automatically create a group for each pin where the pinctrl driver
asks it to do so, so the single-pin groups don't all have to be
explicitly enumerated by the pinctrl driver, again based on some flag
in struct pinctrl_desc.

-- 
nvpublic

