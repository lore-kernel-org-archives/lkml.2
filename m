Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab2AQTJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:09:56 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14988 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2AQTJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:09:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 17 Jan 2012 11:09:13 -0800
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
Date: Tue, 17 Jan 2012 11:09:12 -0800
Subject: RE: Pinmux bindings proposal
Thread-Topic: Pinmux bindings proposal
Thread-Index: AczSMvpNTKYWSKFeSLCZTyHqrIN5SAB+76JwAEZwauA=
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17801D22DE@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885091DEA@039-SN2MPN1-013.039d.mgd.msft.net>
In-Reply-To: <7FE21149F4667147B645348EC6057885091DEA@039-SN2MPN1-013.039d.mgd.msft.net>
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

Dong Aisheng wrote at Monday, January 16, 2012 5:50 AM:
> Stephen Warren wrote at Saturday, January 14, 2012 4:40 AM:
> > I thought a bit more about pinmux DT bindings. I came up with something that I
> > like well enough, and is pretty similar to the binding that Dong posted recently.
> > I think it'll work for both Tegra's and IMX's needs.
> > Please take a look!
...
> >                 pinmux =
> >                         <"default" &pmx_sdhci_active>
> >                         <"suspend" &pmx_sdhci_suspend>;
...
> >                 /*
> >                  * Alternative: One property for each required state. But,
> >                  * how does pinctrl core know which properties to parse?
> >                  * Every property named "pinctrl*" seems a little too far-
> >                  * reaching. Perhaps if we used vendor-name "pinmux", that'd
> >                  * be OK, i.e. pinmux,default and pinmux,suspend?
> 
> It we support whatever device-defined states, it's meaningless to use one property
> For each required state since pinctrl core does not know the property name the
> customer defined.

Yes, that's the problem. Shawn proposed copying the clock bindings which
I think solves all the issues; see my previous email.
> >                  */
> >                 pinmux = <&pmx_sdhci_active>;
> >                 pinmux-suspend <&pmx_sdhci_suspend>;
> >
> >                 /* 1:n example: */
> >                 pinmux = <&pmx_sdhci_mux_a &pmx_sdhci_pincfg_a>
>
> This looks ok to me since the mux and pincfg usually is 1 to 1.
> And if we do not have a pincfg for a pinmux we can find a way to tell the pinctl
> core, maybe just set pincfg phandle to 0.

Just to be clear, I'll repeat part of my previous response to Shawn:

* Just a further explanation on my original code: I always intended that
* each entry in that list was a full pinmux configuration that could include
* mux and pin configuration settings. Thus, the above is more like:
*
* pinctrl = 
*     <"default" &pmx_sdhci_a>
*     <"default" &pmx_sdhci_overrides>
*
* (overrides rather than explicit separate mux/config; the separate mux
* And config were just an example use case).

So that was a list where the /examples/ had two entries, one for mux and
one for pin config. In general, there could be 1, 2, 3, ... entries and
each could define whatever mux and config entries they wanted.

> >                 pinmux-suspend = <&pmx_sdhci_mux_a &pmx_sdhci_pincfg_a_suspend>;
> >
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
>
> Mandatory for what?

I was thinking that each pin mux configuration node MUST specify at
least some mux settings. However, that may not make sense; it may be
reasonable to specify just pin config settings and no mux settings 
(in a 1:n model in the "override" node).

> 
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
>
> I'm still think how do we construct the pinmux map for such binding.
> The format you're using is:
> <&pmx_controller_phandle muxable_entity_id selected_function>
> For contruct pinmux map, we need to know at least 3 things for a device:
> a) pinctrl device b) function name c) group name.
> For a, we can get it from this binding.
> But for b and c, since they are constants, how to convert to name string?

a) pinctrl device: We can extract this from pmx_controller_phandle;
simply search for a device with the same OF node, and retrieve that
registered device from the pinctrl subsystem. This is how GPIO and IRQ
work.

b) function name: The pinmux_ops for the driver of pmx_controller_phandle
needs a function to convert integer IDs such as TEGRA_PMX_MUX_1 to whatever
function IDs are used by the pinctrl subsystem.

c) group name: This should be handled just like (b).

Also you'll need to know:

struct pinmux_map's .name field. This is the value in the pinctrl-names
property, assuming we're switching to the following syntax:

    pinctrl = <&pmx_sdhci_a_active>, <&pmx_sdhci_a_suspend>;
    pinctrl-names = "default", "suspend";

> >                         /*
> >                          * Pin configuration settings. Optional.
> >                          *
> >                          * Format is <&pmx_controller_phandle muxable_entity_id
> >                          * configuration_option configuration_value>.
> >                          */
> >                         config =
> >                                 <&tegra_pmx TEGRA_PMX_PG_DTA
> > TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> >                                 <&tegra_pmx TEGRA_PMX_PG_DTD
> > TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> >                                 <&tegra_pmx TEGRA_PMX_PG_DTA
> > TEGRA_PMX_CONF_SLEW_RATE 4>
> >                                 <&tegra_pmx TEGRA_PMX_PG_DTD
> > TEGRA_PMX_CONF_SLEW_RATE 8>;
> >                         /*
> >                          * Perhaps allow additional custom properties here to
> >                          * express things we haven't thought of. The pinctrl
> >                          * drivers would be responsible for parsing them.
> >                          */
> >                 };
> >                 pmx_sdhci_standby: {
> >                         mux =
> >                                 <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
> >                                 <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>;
> >                         config =
> >                                 <&tegra_pmx TEGRA_PMX_PG_DTA
> > TEGRA_PMX_CONF_TRISTATE 1>
> >                                 <&tegra_pmx TEGRA_PMX_PG_DTD
> > TEGRA_PMX_CONF_TRISTATE 1>
> >                                 <&tegra_pmx TEGRA_PMX_PG_DTA
> > TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> >                                 <&tegra_pmx TEGRA_PMX_PG_DTD
> > TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> >                                 <&tegra_pmx TEGRA_PMX_PG_DTA
> > TEGRA_PMX_CONF_SLEW_RATE 4>
> >                                 <&tegra_pmx TEGRA_PMX_PG_DTD
> > TEGRA_PMX_CONF_SLEW_RATE 8>;
> >                 };
> >         };
> > };
> >
> > Integer IDs for "muxable entities": Pins on IMX, pin groups on Tegra:
>
> If "muxable entities" is pins on IMX, I'm wondering how we define the predefined
> Functions and groups or if we still need to do that.

By "predefined", do you mean:

a) Does the DT need to list all the functions and groups.

The answer here is no in general. However, if you want to parameterize
your pinctrl driver's list of known functions and groups, then you can
certainly do this; the pinctrl binding simple doesn't force you to do
this.

b) Does the pinctrl driver need to list all functions and groups to the
pinctrl core?

As the pinctrl subsystem APIs stand right now, the answer here is yes.

I don't think there's really any way around this, although depending on
HW, you can do things like:

1) Instead of defining logical functions (SDHCI1, I2C1, ...) you could
simply define a function for each mux register value (func0, func1, ...)

2) On IMX, you'd define a pin group for each individual pin, since the
HW muxing is at a pin not a group level.

> >     TEGRA_PMX_PG_DTA
> >     TEGRA_PMX_PG_DTD
> >
> > Each individual pinmux driver's bindings needs to define what each integer ID
> > represents.
>
> Does it mean both pinmux driver and soc.dtsi file need define those macros if dtc
> Supports constants?

Yes. As Shawn mentions later, perhaps we can find some way to define
these values in one place, and generate both a .dtsi file and a .h file
from that single list, or generate a .h file from the .dtsi file or vice-
versa.

> > Integer IDs for the "mux functions". Note that these are the raw values written
> > into hardware, not any driver-defined abstraction, and not any kind of "virtual
> > group" that's been invented to make OEMs life easier:
> >
> >     TEGRA_PMX_MUX_0
> >     TEGRA_PMX_MUX_1
> >     ...
> >     TEGRA_PMX_MUX_3 (for Tegra, 7 for IMX)
> >
> > Since these are the raw IDs that go into HW, there's no need to specify each
> > ID's meanings in the binding.
> >
> > Integer IDs for "pin config parameters":
> >
> >     TEGRA_PMX_CONF_TRISTATE
> >     TEGRA_PMX_CONF_DRIVE_STRENGTH
> >     TEGRA_PMX_CONF_SLEW_RATE
> >
> > Each individual pinmux driver's bindings needs to define what each integer ID
> > represents, and what the legal "value"s are for each one.
> >
> > Advantages:
> >
> > * Provides for both mux settings and "pin configuration".
> >
> > * Allows the "pinmux configuration" nodes to be part of the SoC .dtsi
> >   file if desired to provide pre-defined pinmux configurations to
> >   choose from.
> >
> > * Allows the "pinmux configuration" nodes to be part of the per-device
> >   node if you don't want to use pre-defined configurations.
> >
> > * When pre-defined configurations are present, if you need something
> >   custom, you can do it easily.
> >
> > * Can augment pre-defined configurations by listing n nodes for each
> >   "name"d pinmux configuration, e.g. to add one extra pin config
> >   value.
> >
> > * Parsing is still quite simple:
> >   1) Parse "pinmux" property in device node to get phandle.
> >   2) Parse "mux" property in the node reference by the phandle,
> >      splitting into a list of pmx phandle, entity, mux func.
> >   3) For each entry, pass entity, function to the appropriate mux
> >      driver. (For U-Boot, this might mean check that the phandle
> >      points at the expected place, and ignore the entry if not?)
> >  4) Mux driver simply converts "muxable entity" to the register
> >     address, write the "function" value straight to the register.
> >
> > Disadvantages:
> >
> > * If you're not using pre-defined configurations, you still have to dump
> >   all the pinmux configuration into a sub-node of the device node, and
> >   have a property point at it using a phandle. This is slightly more
> >   complex than simply putting the mux/config properties right into the
> >   device node. However, it additionally allows one to have multiple
> >   "name"d configurations (e.g. for suspend) very easily, and isn't overly
> >   complex, so I can live with this.
>
> I don't think the sub-node of the device node is a good place to define
> Custom configurations.
> Putting those things into device node will make its size big and also not look good.
> Since it uses phandle, why not put it under pinctrl device node in board dts file?
> It may also work.

Both you and Shawn have said you don't like allowing the pin configurations
to be sub-nodes of the devices. Can you expand a little more on that? I
mentioned some of my reasons for allowing this in my previous email, so
see that for reference. I guess I have a couple more points to make:

1) It's optional. If everything you need can be represented in pre-
defined/canned pin configuration nodes under the pin controller's node,
you can certainly do that.

2) Putting this in the device's node seems more consistent with existing
bindings, which put all configuration inside the device node: The IRQ
binding places interrupt IDs and configuration (level/edge, high/low)
in the device node. The GPIO binding places GPIO IDs and possible flags
(e.g. inverted/not) in the device node. Etc.

3) I don't think there will be any .dtb size difference at all between
putting the pin configuration in the pin controller node or the device
node; the content of the sub-node will be entirely identical. The same
holds true for the .dts files (when you consider soc.dtsi and board.dts
together).

-- 
nvpublic

