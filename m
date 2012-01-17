Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab2AQTVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:21:52 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14553 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab2AQTVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:21:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 17 Jan 2012 11:21:31 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>
CC: "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
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
Date: Tue, 17 Jan 2012 11:21:30 -0800
Subject: RE: Pinmux bindings proposal
Thread-Topic: Pinmux bindings proposal
Thread-Index: AczU771JEjSuFRn8TD6wxH5wEotIkgAXFH/w
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17801D22EB@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885091DEA@039-SN2MPN1-013.039d.mgd.msft.net>
 <20120117082334.GA31295@S2101-09.ap.freescale.net>
In-Reply-To: <20120117082334.GA31295@S2101-09.ap.freescale.net>
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

Shawn Guo wrote at Tuesday, January 17, 2012 1:24 AM:
> On Mon, Jan 16, 2012 at 12:50:02PM +0000, Dong Aisheng-B29396 wrote:
...
> > >                          * Not mandatory if the 1:1 mentioned above is
> > >                          * extended to 1:n.
> > >                          *
> > >                          * Format is <&pmx_controller_phandle muxable_entity_id
> > >                          * selected_function>.
> > >                          *
> > >                          * The pmx phandle is required since there may be more
> > >                          * than one pinmux controller in the system. Even if
> > >                          * this node is inside the pinmux controller itself, I
> > >                          * think it's simpler to just always have this field
> > >                          * present in the binding for consistency.
> > >                          *
> > >                          * Alternative: Format is <&pmx_controller_phandle
> > >                          * pmx_controller_specific_data>. In this case, the
> > >                          * pmx controller needs to define #pinmux-mux-cells,
> > >                          * and provide the pinctrl core with a mapping
> > >                          * function to handle the rest of the data in the
> > >                          * property. This is how GPIOs and interrupts work.
> > >                          * However, this will probably interact badly with
> > >                          * wanting to parse the entire pinmux map early in
> > >                          * boot, when perhaps the pinctrl core is initialized,
> > >                          * but the pinctrl driver itself is not.
> > >                          */
> > >                         mux =
> > >                                 <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
> > >                                 <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>
> > >                                 /* Syntax example */
> > >                                 <&foo_pmx FOO_PMX_PG_X FOO_PMX_MUX_0>;
> >
> > I'm still think how do we construct the pinmux map for such binding.
> > The format you're using is:
> > <&pmx_controller_phandle muxable_entity_id selected_function>
> > For contruct pinmux map, we need to know at least 3 things for a device:
> > a) pinctrl device b) function name c) group name.
> > For a, we can get it from this binding.
> > But for b and c, since they are constants, how to convert to name string?
> 
> I guess, for function name, it should be retrieved from the client
> device node, and for the group name, it should be retrieved from the
> node here.
>
> For above example, the function name can be picked from sdhci device
> node pinctr-names property I proposed, and the group name can just be
> 'pmx_sdhci_active', which is not a very nice name here and reminds me
> the following point.

I responded directly to Dong's email re: how to map the DT values into
something for pinctrl. The mapping being described here isn't quite
what I had in mind....

> Considering the different pinctrl configurations for the same client
> device usually share the same pinmux and only pinconf varies.  It may
> worth introducing another level phandle reference.  Something like
> the following:

I don't think there's a need for another level of indirection. The 1:n
model I was talking about already handles this, I believe. See below.

> 	pinmux_sdhci: pinmux-sdhci {
> 		mux =
> 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
> 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>;
> 	};
> 
> 	pinconf_sdhci_active: pinconf-sdhci-active {
> 		config =
> 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
> 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
> 	};
> 
> 	pinconf_sdhci_suspend: pinconf-sdhci-suspend {
> 		config =
> 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
> 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>
> 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
> 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
> 	};

Those 3 nodes make sense to me.

> 	pinctrl_sdhci_active: pinctrl-sdhci-active {
> 		pinmux = <&pinmux_sdhci>;
> 		pinconf = <&pinconf_sdhci_active>;
> 	};
> 
> 	pinctrl_sdhci_suspend: pinctrl-sdhci-suspend {
> 		pinmux = <&pinmux_sdhci>;
> 		pinconf = <&pinconf_sdhci_suspend>;
> 	};

I think we can avoid those 2 nodes.

> 	sdhci@c8000200 {
> 		...
> 		pinctrl = <&pinctrl_sdhci_active> <&pinctrl_sdhci_suspend>;
> 		pinctrl-names = "active", "suspend";
> 	};

And rewrite that node as:

sdhci@c8000200 {
    ...
    pinctrl = <&pinmux_sdhci> <&pinconf_sdhci_active>
              <&pinmux_sdhci> <&pinconf_sdhci_suspend>;
    pinctrl-names = "active", "active", "suspend", "suspend";
};

The only slight disadvantage here is that the person constructing the
pinctrl/pinctrl-names properties needs to know to explicitly list both
the separate mux/config phandles for each value in pinctrl-names. Still,
this seems a reasonable compromise; the user is still picking from a
bunch of pre-defined/canned nodes, they simply need to list 2 (or n in
general) of them for each state.

> This will be pretty useful for imx6 usdhc case, which will have 3
> pinctrl configuration for each usdhc device (imx6 has 4 usdhc devices),
> pinctrl-50mhz, pinctrl-100mhz and pinctrl-200mhz.  All these 3 states
> have the exactly same pinmux settings, and only varies on pinconf.

Yes, I definitely agree there's a need for this.

As an aside, I wonder if the following would be any better:

sdhci@c8000200 {
    ...
    pinctrl = <&pinmux_sdhci> <&pinconf_sdhci_active>
              <&pinmux_sdhci> <&pinconf_sdhci_suspend>;
    /* Number of entries in pinctrl for each in pinctrl-names */
    pinctrl-entries = <2 2>;
    pinctrl-names = "active", "suspend";
};

That seems more complex though.

-- 
nvpublic

