Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab2AWWyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 17:54:31 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8557 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab2AWWya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 17:54:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 23 Jan 2012 14:54:08 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Tony Lindgren <tony@atomide.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Mon, 23 Jan 2012 14:54:06 -0800
Subject: RE: Pinmux bindings proposal
Thread-Topic: Pinmux bindings proposal
Thread-Index: AczaC3PxlqSCeflOTT60z42YuoXN/wAFRCIQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178CB81BFD@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <20120116182808.GG4223@ponder.secretlab.ca>
 <20120118141329.GA22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1780DAAEBB@HQMAIL01.nvidia.com>
 <20120119105728.GE22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1780DAB45E@HQMAIL01.nvidia.com>
 <20120123201304.GB4420@atomide.com>
In-Reply-To: <20120123201304.GB4420@atomide.com>
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

Tony Lindgren wrote at Monday, January 23, 2012 1:13 PM:
> * Stephen Warren <swarren@nvidia.com> [120120 12:20]:
> > Tony wrote at Lindgren:
> > > * Stephen Warren <swarren@nvidia.com> [120118 11:29]:
> > > > Tony Lindgren wrote at Wednesday, January 18, 2012 7:13 AM:
> > >
> > > Assuming this is describing the pins a driver is using, how
> > > about calling it pins?
> >
> > It's not always pins.
> >
> > For a lot of HW it is pins, you're right.
> >
> > For Tegra20 (and IIRC some other HW), the pin mux HW actually muxes
> > groups of pins; one register field sets n (1, 2, 3, ...) pins to that
> > function at once. Hence, the entries are real physical groups.
> 
> OK fair enough, mux instead of pins works fine for me.
> 
> > For some HW that controls the mux per pin, the SoC vendors wish the
> > pinctrl driver to expose what I call "virtual groups" of pins, e.g. all
> > the pins that are typically used together as a single I2C or SD/MMC
> > interface, as a single muxable entity (a group in pinctrl parlance).
> > In this case, the values listed here will be these group IDs
> 
> For the virtual groups, do you also want to specify them separate
> in the .dts files?

/I/ don't want to specify virtual groups at all:-)

It's up to individual pinctrl drivers what groups they define. Equally,
it's up to the drivers whether they define their list of groups as static
data within the driver, or as nodes/properties in the device tree.

Nothing that I put into my binding proposal is in any way related to what
I call virtual groups; the "pin configuration nodes" are simply a listing
of mux or config values for whatever pins or groups the pinctrl driver
happens to expose, whether they're real HW pins/groups or not, and whether
the list they expose came from a static table or not.

> IMHO we should let device tree take care of that as it already
> allows specifying the pins for each device entry. Then the
> dynamically generated group name can be nc->full_name of the
> device.

I don't quite follow that, but I think it's important to allow drivers
flexibility to store their list of pins/groups/functions wherever they
want; mandating that the lists be stored in device tree won't please
everyone.

...
> > I see your point about separate ownership of pins/groups and the actual
> > HW register programming. The pinctrl subsystem doesn't have a concept
> > of separating those two things at the moment though. I don't think its
> > unreasonable to still have to write the mux values into the device tree
> > and even reprogram them to the same value when Linux boots though. Do
> > you see a problem with that? If there is a problem, we need to fix it
> > in pinctrl too, irrespective of any device tree work.
> 
> Yeah I think we can handle some pinmuxing cases automatically.
> But basically we need to support also the following typical cases:
> 
> 1. Static muxing in bootloader only and no mux entries in the .dts files

That's easily handled in the binding I proposed; simply don't put any
mux/config settings into the device tree. Portable drives will still
call pinmux_get(), so there need to be nodes to back that up, but the
list of strings that get applied can be empty if you wish, assuming the
driver doesn't need different configurations at runtime.

> 2. Init time only muxing based on the entries in .dts files

Similar answer to (1).

> 3. Dynamic remuxing of pins for the pins specified in the .dts files

Yes, that's handled by simply putting multiple named configurations into
the device tree.

...
> > > Something like:
> > >
> > > 	pins =
> > > 	<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1 TEGRA_PMX_CONF_TRISTATE 1
> > > 	 &tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1 TEGRA_PMX_CONF_TRISTATE 1>;
> > >
> > > and in the parent set #pin-args to 3.
> >
> > That doesn't support setting a variable number of config values per pin/
> > group. Tegra30 has 13 define TEGRA_PMX_CONF_* values, and requiring every
> > one of those to be set for every pin/group would be a bit unwieldy,
> > especially since 99% of the time we just rely on the HW defaults, and I
> > imagine many other SoCs are the same.
> 
> But aren't these 13 defines for TEGRA_PMX_CONF_* just bit offsets in some
> register?

No.

The same TEGRA_PMX_CONF_* parameter doesn't necessarily exist for all
pins or all groups.

Where it does exist, different pins/groups may store the value in a
different bit number in the/some register based on the group, and the
width of the bit field may vary too.

So, the TEGRA_PMX_CONF_* are just a logical name/ID of the parameter to be
configured, which is then looked up in the table of pins/groups known to
the Tegra pinctrl driver, which also determines the register, bit, and
field size for the combination.

-- 
nvpublic

