Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab2BCIdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 03:33:39 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46935 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab2BCIdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 03:33:37 -0500
Date: Fri, 3 Feb 2012 16:46:04 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Pinmux bindings proposal V2
Message-ID: <20120203084600.GA12508@S2101-09.ap.freescale.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <20120201143530.GA2203@S2101-09.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF178E124AC5@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178E124AC5@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 10:36:54AM -0800, Stephen Warren wrote:
> Shawn Guo wrote at Wednesday, February 01, 2012 7:36 AM:
> ...
> > I had a talk with Dong about this binding, and we think that it should
> > work well for imx if we have a couple of small pieces added.
> > 
> > On Fri, Jan 20, 2012 at 02:22:20PM -0800, Stephen Warren wrote:
> > ...
> > >                 pmx_sdhci: pinconfig-sdhci {
> > >                         /*
> > >                          * The mux property is a list of muxable entities
> > >                          * and the mux function to select for it. The number
> > >                          * of cells in each entry is the pin controller's
> > >                          * #pinmux-cells property. The pin controller's
> > >                          * binding defines what the cells mean. The pinctrl
> > >                          * driver is responsible for mapping this data to
> > >                          * the (group, function) pair required to fill in
> > >                          * the pinctrl subsystem's pinmux mapping table.
> > >                          */
> > >                         mux =
> > >                                 <TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_SDIO1>
> > >                                 <TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_SDIO1>;
> > 
> > We need a property like 'mux-unit' whose value can be either 'pin' or
> > 'pingroup' to reflect something you mentioned as muxable entity.
> 
> I'm not sure I agree; see below.
> 
> > The reason behind this is the DT logic inside pinctrl core needs to
> > know how the pinmux_map should be constructed from device tree.
> 
> As a general statement, yes.
> 
> > In tegra case, the 'mux-unit' is 'pingroup', the core should construct
> > pinmux_map entry for each row/element of 'mux'.
> 
> Yes.
> 
> > In imx case, the 'mux-unit' will be 'pin',
> 
> OK.
> 
> Just a note: Tegra30 also has per-pin muxability. Only Tegra20 muxes pins
> in groups. (although Tegra30 does some if its pin configuration in groups)
> 
> > and we would expect core construct only
> > one pinmux_map entry there, with all the pins listed in 'mux' composing
> > the group that pinmux_map needs.
> 
> This is where I disagree.
> 
So what I read is you disagree how pinctrl core uses property 'mux-unit'
not the property itself.

> If the pinmux_map should only contain a single entry, wouldn't the DT
> mux property only contain a single entry?
> 
So you are saying we should have a pinmux_map for each entry in the
mux property?  I disagree with that.  For imx usdhc example, we have
10 entries in mux property representing 10 pins and their mux values.
What we need is one pinmux_map rather than 10 for just one client
device.

> The reason being that if there's a single entry in the pinmux_map, the
> group name used in that entry must be a group that's supported directly
> by the pinctrl driver (that's just the way pinctrl works). As such, why
> not just write the device tree in terms of those groups?
> 
> The only way I can see this not being true is if your pinctrl driver is
> also parsing these mux properties, and dynamically creating the groups
> that it exposes based on the list of pins in the mux property.

Yes, that's exactly what we are trying to do for imx.

> However,
> that seems like the wrong approach;

Where does it go wrong exactly?

> If you're dynamically defining groups
> in DT, I'd expect separate explicit driver-specific properties/nodes to
> define those groups, such that the pinctrl core's processing of the mux
> property to be identical in all cases.
> 
It's not imx specific.  It's generally useful for any soc that has pin
as the muxable entity.  I think it should be the common part of this
binding and implemented in pinctrl core DT support. 

-- 
Regards,
Shawn
