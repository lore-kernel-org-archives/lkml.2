Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab2AQSr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:47:59 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10051 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab2AQSr5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:47:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 17 Jan 2012 10:47:15 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
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
Date: Tue, 17 Jan 2012 10:47:14 -0800
Subject: RE: Pinmux bindings proposal
Thread-Topic: Pinmux bindings proposal
Thread-Index: AczSidzzthsPZDDSR6i3livGD5qy+ACu6jUQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17801D22C7@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <20120114070858.GG1810@S2101-09.ap.freescale.net>
In-Reply-To: <20120114070858.GG1810@S2101-09.ap.freescale.net>
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

Shawn Guo wrote at Saturday, January 14, 2012 12:09 AM:
> On Fri, Jan 13, 2012 at 12:39:42PM -0800, Stephen Warren wrote:
> > I thought a bit more about pinmux DT bindings. I came up with something
> > that I like well enough, and is pretty similar to the binding that Dong
> > posted recently. I think it'll work for both Tegra's and IMX's needs.
> > Please take a look!
...
> > tegra-harmony.dts:
> >
> > /{
> >         sdhci@c8000200 {
> >                 cd-gpios = <&gpio 69 0>; /* gpio PI5 */
> >                 wp-gpios = <&gpio 57 0>; /* gpio PH1 */
> >                 power-gpios = <&gpio 155 0>; /* gpio PT3 */
> >
> >                 /*
> >                  * A list of named configurations that this device needs.
> >                  * Format is a list of <"name" &phandle_of_pmx_configuration>
> >                  *
> >                  * Multiple "name"s are needed e.g. to support active/suspend,
> >                  * or whatever device-defined states are appropriate. The
> >                  * device defines which names are needed, just like a device
> >                  * defines which regulators, clocks, GPIOs, interrupts, ...
> >                  * it needs.
> >                  *
> >                  * This example shows a 1:1 relation between name and phandle.
> >                  * We might want a 1:n relation, so that we can blend multiple
> >                  * pre-defined sets of data together, e.g. one pre-defined set
> >                  * for the pin mux configuration, another for the pin config
> >                  * settings, both being put into the single "default" setting
> >                  * for this one device.
> >                  *
> >                  * A pinmux controller can contain this property too, to
> >                  * define "hogged" or "system" pin mux configuration.
> >                  *
> >                  * Note: Mixing strings and integers in a property seems
> >                  * unusual. However, I have seen other bindings floating
> >                  * around that are starting to do this...
> >                  */
> >                 pinmux =
> 
> I prefer to have the property named 'pinctrl' than 'pinmux'.

Yes. I think I worried that "pinctrl" was a little too tied to the Linux
driver so didn't name it that, but you're right that "pinmux" doesn't
encompass everything this binding covers, so "pinctrl" does seem to be
the right choice.

> >                         <"default" &pmx_sdhci_active>
> >                         <"suspend" &pmx_sdhci_suspend>;
>
> I would rather do something like what clock DT binding proposal is
> doing.
> 
> 		pinctrl = <&pmx_sdhci_active>, <&pmx_sdhci_suspend>;
> 		pinctrl-names = "default", "suspend";

Yes, that's a good idea.

I'm afraid I haven't been following the clock binding discussions at
all, but just started looking at them right after I wrote the email you
were responding to.

> >                 /* 1:n example: */
> >                 pinmux =
> >                         <"default" &pmx_sdhci_mux_a>
> >                         <"default" &pmx_sdhci_pincfg_a>
> >                         <"suspend" &pmx_sdhci_mux_a>
> >                         <"suspend" &pmx_sdhci_pincfg_a_suspend>;
> 
> I personally do not like the 1:n binding.  To me, any particular pinctrl
> configuration, e.g. pmx_sdhci_active, should consist of a pair of pinmux
> and pinconf, which should be given by the pmx_sdhci_active node.

Just a further explanation on my original code: I always intended that
each entry in that list was a full pinmux configuration that could include
mux and pin configuration settings. Thus, the above is more like:

pinctrl = 
    <"default" &pmx_sdhci_a>
    <"default" &pmx_sdhci_overrides>

(overrides rather than explicit separate mux/config; the separate mux
And config were just an example use case).

My thoughts here:

With this binding, we can certainly define a lot of pre-defined/canned
configurations to a set of pins. However, there are so many pin config
options (at least on Tegra) for different aspects of drive strength, slew
rate, ... that I sincerely doubt every single board is going to be able
to use one of those pre-defined/canned *exactly* without changes. The ways
to cope with these small board-specific differences are:

a) Cut/paste the entire pre-defined/canned configuration and tweak it
as necessary. You can do this with the 1:1 model.

b) Use the pre-defined/canned as a base, then modify it to add extra
configuration options, or change existing configuration options, as
appropriate. I think the 1:n model works best for this. Given previous
comments, I'd now propose the following syntax for a 1:n model:


    pinctrl = <&pmx_sdhci_a>, <&pmx_sdhci_overrides>, <&pmx_sdhci_suspend>;
    pinctrl-names = "default", "default", "suspend";

This should be easy to implement; instead of roughly:

prop = get_prop(np, "pinctrl-names");
index = find_index(prop, "default");
handle_pinctrl_prop(np, "pinctrl", index);

something more like:

prop = get_prop(np, "pinctrl-names");
prev = NULL;
while (find_index(prop, "default", &prev))
    handle_pinctrl_prop(np, "pinctrl", index);

...
> >                 /*
> >                  * The actual definition of the complete state of the
> >                  * pinmux as required by some driver.
> >                  *
> >                  * These can be either directly in the device node, or
> >                  * somewhere in tegra20.dtsi in order to provide pre-
> >                  * selected/common configurations. Hence, they're referred
> >                  * to by phandle above.
> >                  */
> >                 pmx_sdhci_active: {
> >                         /*
> >                          * Pin mux settings. Mandatory?
> >                          * Not mandatory if the 1:1 mentioned above is
> >                          * extended to 1:n.
> >                          *
> >                          * Format is <&pmx_controller_phandle muxable_entity_id
> >                          * selected_function>.
> >                          *
> >                          * The pmx phandle is required since there may be more
> >                          * than one pinmux controller in the system. Even if
> >                          * this node is inside the pinmux controller itself, I
> >                          * think it's simpler to just always have this field
> >                          * present in the binding for consistency.
> >                          *
> 
> I prefer to just put such nodes inside pinctrl controller itself and
> drop those phandles.

My rationale here:

Forcing those nodes to be inside the controller node forces us to store
any board-specific custom configurations or overrides in the controller
node too; I'd simply prefer the flexibility to put them anywhere.

Equally, I want SoC vendors to be able to choose whether to use these
pre-defined/canned configuration nodes at all. If you do use them, putting
them into the controller node makes perfect sense. If you don't use them,
putting the pin configuration nodes into the individual device nodes (in
the board.dts file) makes much more sense.

Having each property start with the phandle of the relevant controller
is also far more consistent with the way all the GPIO, IRQ, ... bindings
work.

> >                          * Alternative: Format is <&pmx_controller_phandle
> >                          * pmx_controller_specific_data>. In this case, the
> >                          * pmx controller needs to define #pinmux-mux-cells,
> >                          * and provide the pinctrl core with a mapping
> >                          * function to handle the rest of the data in the
> >                          * property. This is how GPIOs and interrupts work.
> >                          * However, this will probably interact badly with
> >                          * wanting to parse the entire pinmux map early in
> >                          * boot, when perhaps the pinctrl core is initialized,
> >                          * but the pinctrl driver itself is not.
> >                          */
> >                         mux =
> >                                 <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
> >                                 <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>
> >                                 /* Syntax example */
> >                                 <&foo_pmx FOO_PMX_PG_X FOO_PMX_MUX_0>;
> >                         /*
> >                          * Pin configuration settings. Optional.
> >                          *
>
> I guess pinconf can be optional because some pin/group that have pinmux
> setting do not necessarily have pinconf setting?  If that's case,
> yes, agreed.

Yes, that's true.

Also, if you're using the 1:n model I mentioned above, your "base" node
may well have both, but your "override" node may well only need to add
additional pinmux settings, or tweak just a single pin control setting,
so forcing someone to specify both wouldn't work.

Still, I suppose we could just force both properties to be present, but
just write an empty list if one type of setting wasn't needed; at least
this would allow for some amount of error-checking of the node content.

...
> > Integer IDs for "muxable entities": Pins on IMX, pin groups on Tegra:
> >
> >     TEGRA_PMX_PG_DTA
> >     TEGRA_PMX_PG_DTD
> >
> > Each individual pinmux driver's bindings needs to define what each integer
> > ID represents.
...
>
> Agreed on these.  But we really need to push named constants support
> for dtc, otherwise the binding is so difficult for engineering.  (We
> have a lot of pinconfig parameters on imx)

Yes, there is a discussion about this going on.

(Well, it started a good few years back and had a hiatus. There are a lot
of long-term syntax issues to plan out before we can get the basic support
in though, to make sure we don't screw our future selves.)

-- 
nvpublic

