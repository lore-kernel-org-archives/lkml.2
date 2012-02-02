Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab2BBShX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 13:37:23 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3450 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab2BBShV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 13:37:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 02 Feb 2012 10:36:55 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
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
Date: Thu, 2 Feb 2012 10:36:54 -0800
Subject: RE: Pinmux bindings proposal V2
Thread-Topic: Pinmux bindings proposal V2
Thread-Index: Aczg7QqTuRgNpjijQ3aam7wsf6bzzAA6twgg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178E124AC5@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <20120201143530.GA2203@S2101-09.ap.freescale.net>
In-Reply-To: <20120201143530.GA2203@S2101-09.ap.freescale.net>
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

Shawn Guo wrote at Wednesday, February 01, 2012 7:36 AM:
...
> I had a talk with Dong about this binding, and we think that it should
> work well for imx if we have a couple of small pieces added.
> 
> On Fri, Jan 20, 2012 at 02:22:20PM -0800, Stephen Warren wrote:
> ...
> >                 pmx_sdhci: pinconfig-sdhci {
> >                         /*
> >                          * The mux property is a list of muxable entities
> >                          * and the mux function to select for it. The number
> >                          * of cells in each entry is the pin controller's
> >                          * #pinmux-cells property. The pin controller's
> >                          * binding defines what the cells mean. The pinctrl
> >                          * driver is responsible for mapping this data to
> >                          * the (group, function) pair required to fill in
> >                          * the pinctrl subsystem's pinmux mapping table.
> >                          */
> >                         mux =
> >                                 <TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_SDIO1>
> >                                 <TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_SDIO1>;
> 
> We need a property like 'mux-unit' whose value can be either 'pin' or
> 'pingroup' to reflect something you mentioned as muxable entity.

I'm not sure I agree; see below.

> The reason behind this is the DT logic inside pinctrl core needs to
> know how the pinmux_map should be constructed from device tree.

As a general statement, yes.

> In tegra case, the 'mux-unit' is 'pingroup', the core should construct
> pinmux_map entry for each row/element of 'mux'.

Yes.

> In imx case, the 'mux-unit' will be 'pin',

OK.

Just a note: Tegra30 also has per-pin muxability. Only Tegra20 muxes pins
in groups. (although Tegra30 does some if its pin configuration in groups)

> and we would expect core construct only
> one pinmux_map entry there, with all the pins listed in 'mux' composing
> the group that pinmux_map needs.

This is where I disagree.

If the pinmux_map should only contain a single entry, wouldn't the DT
mux property only contain a single entry?

The reason being that if there's a single entry in the pinmux_map, the
group name used in that entry must be a group that's supported directly
by the pinctrl driver (that's just the way pinctrl works). As such, why
not just write the device tree in terms of those groups?

The only way I can see this not being true is if your pinctrl driver is
also parsing these mux properties, and dynamically creating the groups
that it exposes based on the list of pins in the mux property. However,
that seems like the wrong approach; If you're dynamically defining groups
in DT, I'd expect separate explicit driver-specific properties/nodes to
define those groups, such that the pinctrl core's processing of the mux
property to be identical in all cases.

i.e. instead of what your "mux-unit" proposal:

    pmx_sdhci: pinconfig-sdhci {
        mux =
            <TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_SDIO1>
            <TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_SDIO1>;
        mux-unit = "pingroup";
        mux-name = "sdio-config-1";
    };

I'd expect something more like:

    /* Standardized pinctrl properties */
    pmx_sdhci: pinconfig-sdhci {
        mux = <IMX_PG_SDIO_CFG_1 IMX_MUX_SDIO1>;
    };

    /*
     * Driver-specific properties which tell the driver which potentially
     * board-specific pin-groups to implement.
     */
    imx-pingroup-sdio-cfg-1 {
        id = <IMX_PG_SDIO_CFG_1>;
        pins = <IMX_PIN_SDIO1_CLK IMX_PIN_SDIO1_CMD IMX_PIN_SDIO1_DAT0...>;
    };

Does that make sense?

> And in case of 'mux-unit' is 'pin', we would need one more property
> 'mux-name' to present the group name.  Then we have all the pieces to
> construct pinmux_map for cases like imx, where we do not define all
> those functions, groups in pinctrl driver at all.

-- 
nvpublic

