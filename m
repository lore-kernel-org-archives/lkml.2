Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab2AWUN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:13:26 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:56795 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2AWUNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:13:24 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18oSESkZizFp85OAG8Fb8f4
Date: Mon, 23 Jan 2012 12:13:12 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
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
Subject: Re: Pinmux bindings proposal
Message-ID: <20120123201304.GB4420@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <20120116182808.GG4223@ponder.secretlab.ca>
 <20120118141329.GA22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1780DAAEBB@HQMAIL01.nvidia.com>
 <20120119105728.GE22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1780DAB45E@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB45E@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@nvidia.com> [120120 12:20]:
> Tony wrote at Lindgren:
> > * Stephen Warren <swarren@nvidia.com> [120118 11:29]:
> > > Tony Lindgren wrote at Wednesday, January 18, 2012 7:13 AM:
> > 
> > Assuming this is describing the pins a driver is using, how
> > about calling it pins?
> 
> It's not always pins.
> 
> For a lot of HW it is pins, you're right.
> 
> For Tegra20 (and IIRC some other HW), the pin mux HW actually muxes
> groups of pins; one register field sets n (1, 2, 3, ...) pins to that
> function at once. Hence, the entries are real physical groups.

OK fair enough, mux instead of pins works fine for me.
 
> For some HW that controls the mux per pin, the SoC vendors wish the
> pinctrl driver to expose what I call "virtual groups" of pins, e.g. all
> the pins that are typically used together as a single I2C or SD/MMC
> interface, as a single muxable entity (a group in pinctrl parlance).
> In this case, the values listed here will be these group IDs

For the virtual groups, do you also want to specify them separate
in the .dts files?

IMHO we should let device tree take care of that as it already
allows specifying the pins for each device entry. Then the
dynamically generated group name can be nc->full_name of the
device.

But other than that, I don't know if there's need to specify
pingroups in the .dts files outside the device node using the
pins?
 
> > That's because you might want to do all the muxing in a
> > bootloader, but still need to tell how many pins you're using
> > for MMC on a device. So it actually has a wider meaning than just
> > mux.
> 
> I don't think that affects the name of the property:-)

Yes mux for the name works fine there too.
 
> I see your point about separate ownership of pins/groups and the actual
> HW register programming. The pinctrl subsystem doesn't have a concept
> of separating those two things at the moment though. I don't think its
> unreasonable to still have to write the mux values into the device tree
> and even reprogram them to the same value when Linux boots though. Do
> you see a problem with that? If there is a problem, we need to fix it
> in pinctrl too, irrespective of any device tree work.

Yeah I think we can handle some pinmuxing cases automatically.
But basically we need to support also the following typical cases:

1. Static muxing in bootloader only and no mux entries in the .dts files

2. Init time only muxing based on the entries in .dts files

3. Dynamic remuxing of pins for the pins specified in the .dts files

For the last one we need to do some extra work to avoid wasting memory,
and need some pin specific flag to describe if the pin is init time only
or dynamic.

> > Also, we need to standardize on some name to use for parsing pins
> > using of_parse_phandle_with_args, and I suggested #pin-args.
> 
> "cells" is the suffix that's typically used rather than "args".

OK
 
> I certainly foresee the need for a #mux-cells and a #config-cells
> Property so that pinctrl bindings/nodes can tell the core parser of
> the mux/config properties how many cells to pull out for each entry.
> 
> In my binding proposal, I original assumed that every controller would
> always have group,function for mux and group,param,value for config.
> However, having #mux-cells and #config-cells is certainly a better idea.
> 
> > >     config =
> > >         <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
> > >         <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>
> > >         <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > >         <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > >         <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
> > >         <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
> > > };
> > 
> > Here I don't quite understand how config is different from pins/mux
> > above? It seems to set the driver/pull stuff, but why don't you
> > just make #pin-args larger and have a wider pin array?
> 
> The idea is that "mux" lists each pin/group that the device uses, and
> the pin mux selection for it, whereas "config" lists all the other
> configuration values that could be applied to a pin; pull-up, pull-down,
> tri-state, drive strength, ...
> 
> I suppose we could lump all those into a single property like:
> 
> pinctrl =
>     <MUX &tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
>     <MUX &tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>
>     <CFG &tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
>     <CFG &tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>
>     <CFG &tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
>     <CFG &tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
>     <CFG &tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
>     <CFG &tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
> 
> (where e.g. MUX=0, CFG=1, both interpreted by the parsing code in the
> core pinctrl subsystem)
> 
> However, I'd tend towards keeping them in separate properties, especially
> since simple chips won't have any CFG (even on Tegra, 99% of the settings
> we make are MUX not CFG) and requiring this MUX value in every mux entry
> seems wasteful.
> 
> > Something like:
> > 
> > 	pins =
> > 	<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1 TEGRA_PMX_CONF_TRISTATE 1
> > 	 &tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1 TEGRA_PMX_CONF_TRISTATE 1>;
> > 
> > and in the parent set #pin-args to 3.
> 
> That doesn't support setting a variable number of config values per pin/
> group. Tegra30 has 13 define TEGRA_PMX_CONF_* values, and requiring every
> one of those to be set for every pin/group would be a bit unwieldy,
> especially since 99% of the time we just rely on the HW defaults, and I
> imagine many other SoCs are the same.

But aren't these 13 defines for TEGRA_PMX_CONF_* just bit offsets in some
register?

If so, why don't you just have one register to define the values? Then when
the preprocessing of .dts files works, you can use defines there?

Even if you had multiple registers per pin(group), you just need the
phandle and value for each register?
 
> > > (Note that I think we've agreed to remove the first cell above, &tegra_pmx,
> > > now by requiring such nodes exist as children of the pin controller.)
> > 
> > Sorry I don't quite follow, can you please maybe repost a complete
> > .dts entry for your pin controller and one driver entry?
> 
> Yes, I'll try to do that very soon. The change is simple; from:
> 
> mux =
>     <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
>     <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>;
> 
> 
> to:
> 
> mux =
>     <TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
>     <TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>;
> 
> We can do this by requiring the node that contains the mux property to
> be a child of the pin controller node, so the phandle value is always
> the node's parent node.

Ah I see. I don't think we can leave out the phandle as that will
not work for mixing pins from multiple pin controller instances.

Regards,

Tony
