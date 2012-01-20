Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab2ATUvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 15:51:24 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19424 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab2ATUvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 15:51:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 20 Jan 2012 12:51:01 -0800
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
Date: Fri, 20 Jan 2012 12:50:59 -0800
Subject: RE: Pinmux bindings proposal
Thread-Topic: Pinmux bindings proposal
Thread-Index: AczWmTPQSRY5hwwpSO2x+hp/awjxZwBGPsLw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB45E@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <20120116182808.GG4223@ponder.secretlab.ca>
 <20120118141329.GA22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1780DAAEBB@HQMAIL01.nvidia.com>
 <20120119105728.GE22818@atomide.com>
In-Reply-To: <20120119105728.GE22818@atomide.com>
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

Tony wrote at Lindgren:
> * Stephen Warren <swarren@nvidia.com> [120118 11:29]:
> > Tony Lindgren wrote at Wednesday, January 18, 2012 7:13 AM:
> >
> > I'd prefer not to do that for my platforms, for the reason Shawn points
> > out in his reply to yours.
> >
> > However, I believe the bindings I proposed are flexible enough to allow
> > you to do exactly this for your platforms without requiring that everyone
> > do it.
> 
> Well I can easily use one phandle per pinmux controller instance
> instead of one phandle per pin, so let's plan on doing that.
> 
> > Recall my proposal was:
> 
> Yes I think that's pretty close to what I'm using, just few
> minor comments below.
> 
> > pmx_sdhci_standby: pinctrl@0 {
> >     /* Format is <&pmx_controller_phandle muxable_entity_id
> >      * selected_function>.
> >      */
> >     mux =
> >         <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
> >         <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>;
> 
> Assuming this is describing the pins a driver is using, how
> about calling it pins?

It's not always pins.

For a lot of HW it is pins, you're right.

For Tegra20 (and IIRC some other HW), the pin mux HW actually muxes
groups of pins; one register field sets n (1, 2, 3, ...) pins to that
function at once. Hence, the entries are real physical groups.

For some HW that controls the mux per pin, the SoC vendors wish the
pinctrl driver to expose what I call "virtual groups" of pins, e.g. all
the pins that are typically used together as a single I2C or SD/MMC
interface, as a single muxable entity (a group in pinctrl parlance).
In this case, the values listed here will be these group IDs

> That's because you might want to do all the muxing in a
> bootloader, but still need to tell how many pins you're using
> for MMC on a device. So it actually has a wider meaning than just
> mux.

I don't think that affects the name of the property:-)

I see your point about separate ownership of pins/groups and the actual
HW register programming. The pinctrl subsystem doesn't have a concept
of separating those two things at the moment though. I don't think its
unreasonable to still have to write the mux values into the device tree
and even reprogram them to the same value when Linux boots though. Do
you see a problem with that? If there is a problem, we need to fix it
in pinctrl too, irrespective of any device tree work.

> Also, we need to standardize on some name to use for parsing pins
> using of_parse_phandle_with_args, and I suggested #pin-args.

"cells" is the suffix that's typically used rather than "args".

I certainly foresee the need for a #mux-cells and a #config-cells
Property so that pinctrl bindings/nodes can tell the core parser of
the mux/config properties how many cells to pull out for each entry.

In my binding proposal, I original assumed that every controller would
always have group,function for mux and group,param,value for config.
However, having #mux-cells and #config-cells is certainly a better idea.

> >     config =
> >         <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
> >         <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>
> >         <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> >         <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> >         <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
> >         <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
> > };
> 
> Here I don't quite understand how config is different from pins/mux
> above? It seems to set the driver/pull stuff, but why don't you
> just make #pin-args larger and have a wider pin array?

The idea is that "mux" lists each pin/group that the device uses, and
the pin mux selection for it, whereas "config" lists all the other
configuration values that could be applied to a pin; pull-up, pull-down,
tri-state, drive strength, ...

I suppose we could lump all those into a single property like:

pinctrl =
    <MUX &tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
    <MUX &tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>
    <CFG &tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
    <CFG &tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>
    <CFG &tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
    <CFG &tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
    <CFG &tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
    <CFG &tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;

(where e.g. MUX=0, CFG=1, both interpreted by the parsing code in the
core pinctrl subsystem)

However, I'd tend towards keeping them in separate properties, especially
since simple chips won't have any CFG (even on Tegra, 99% of the settings
we make are MUX not CFG) and requiring this MUX value in every mux entry
seems wasteful.

> Something like:
> 
> 	pins =
> 	<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1 TEGRA_PMX_CONF_TRISTATE 1
> 	 &tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1 TEGRA_PMX_CONF_TRISTATE 1>;
> 
> and in the parent set #pin-args to 3.

That doesn't support setting a variable number of config values per pin/
group. Tegra30 has 13 define TEGRA_PMX_CONF_* values, and requiring every
one of those to be set for every pin/group would be a bit unwieldy,
especially since 99% of the time we just rely on the HW defaults, and I
imagine many other SoCs are the same.

> > (Note that I think we've agreed to remove the first cell above, &tegra_pmx,
> > now by requiring such nodes exist as children of the pin controller.)
> 
> Sorry I don't quite follow, can you please maybe repost a complete
> .dts entry for your pin controller and one driver entry?

Yes, I'll try to do that very soon. The change is simple; from:

mux =
    <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
    <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>;


to:

mux =
    <TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
    <TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>;

We can do this by requiring the node that contains the mux property to
be a child of the pin controller node, so the phandle value is always
the node's parent node.

-- 
nvpublic

