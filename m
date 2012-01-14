Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2ANG6F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 01:58:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47732 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab2ANG6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 01:58:04 -0500
Date: Sat, 14 Jan 2012 15:09:00 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
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
Message-ID: <20120114070858.GG1810@S2101-09.ap.freescale.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 12:39:42PM -0800, Stephen Warren wrote:
> I thought a bit more about pinmux DT bindings. I came up with something
> that I like well enough, and is pretty similar to the binding that Dong
> posted recently. I think it'll work for both Tegra's and IMX's needs.
> Please take a look!
> 
Thanks for doing this.  It's great we are approaching some level of
agreement on the binding.  I have a few comments below.  Other than
those, this looks like a pretty sensible pinctrl DT binding to me.

> Note: I've used named constants below just to make this easier to read.
> We still don't have a solution to actually use named constants in dtc yet.
> 
> tegra20.dtsi:
> 
> / {
>         tegra_pmx: pinmux@70000000 {
>                 compatible = "nvidia,tegra20-pinmux";
>                 reg = <0x70000014 0x10   /* Tri-state registers */
>                        0x70000080 0x20   /* Mux registers */
>                        0x700000a0 0x14   /* Pull-up/down registers */
>                        0x70000868 0xa8>; /* Pad control registers */
>         };
> 
>         sdhci@c8000200 {
>                 compatible = "nvidia,tegra20-sdhci";
>                 reg = <0xc8000200 0x200>;
>                 interrupts = <0 15 0x04>;
>         };
> };
> 
> tegra-harmony.dts:
> 
> /{
>         sdhci@c8000200 {
>                 cd-gpios = <&gpio 69 0>; /* gpio PI5 */
>                 wp-gpios = <&gpio 57 0>; /* gpio PH1 */
>                 power-gpios = <&gpio 155 0>; /* gpio PT3 */
> 
>                 /*
>                  * A list of named configurations that this device needs.
>                  * Format is a list of <"name" &phandle_of_pmx_configuration>
>                  *
>                  * Multiple "name"s are needed e.g. to support active/suspend,
>                  * or whatever device-defined states are appropriate. The
>                  * device defines which names are needed, just like a device
>                  * defines which regulators, clocks, GPIOs, interrupts, ...
>                  * it needs.
>                  *
>                  * This example shows a 1:1 relation between name and phandle.
>                  * We might want a 1:n relation, so that we can blend multiple
>                  * pre-defined sets of data together, e.g. one pre-defined set
>                  * for the pin mux configuration, another for the pin config
>                  * settings, both being put into the single "default" setting
>                  * for this one device.
>                  *
>                  * A pinmux controller can contain this property too, to
>                  * define "hogged" or "system" pin mux configuration.
>                  *
>                  * Note: Mixing strings and integers in a property seems
>                  * unusual. However, I have seen other bindings floating
>                  * around that are starting to do this...
>                  */
>                 pinmux =

I prefer to have the property named 'pinctrl' than 'pinmux'.

>                         <"default" &pmx_sdhci_active>
>                         <"suspend" &pmx_sdhci_suspend>;
> 
I would rather do something like what clock DT binding proposal is
doing.

		pinctrl = <&pmx_sdhci_active>, <&pmx_sdhci_suspend>;
		pinctrl-names = "default", "suspend";

>                 /* 1:n example: */
>                 pinmux =
>                         <"default" &pmx_sdhci_mux_a>
>                         <"default" &pmx_sdhci_pincfg_a>
>                         <"suspend" &pmx_sdhci_mux_a>
>                         <"suspend" &pmx_sdhci_pincfg_a_suspend>;
> 

I personally do not like the 1:n binding.  To me, any particular pinctrl
configuration, e.g. pmx_sdhci_active, should consist of a pair of pinmux
and pinconf, which should be given by the pmx_sdhci_active node.

>                 /*
>                  * Alternative: One property for each required state. But,
>                  * how does pinctrl core know which properties to parse?
>                  * Every property named "pinctrl*" seems a little too far-
>                  * reaching. Perhaps if we used vendor-name "pinmux", that'd
>                  * be OK, i.e. pinmux,default and pinmux,suspend?
>                  */
>                 pinmux = <&pmx_sdhci_active>;
>                 pinmux-suspend <&pmx_sdhci_suspend>;
> 
>                 /* 1:n example: */
>                 pinmux = <&pmx_sdhci_mux_a &pmx_sdhci_pincfg_a>
>                 pinmux-suspend = <&pmx_sdhci_mux_a &pmx_sdhci_pincfg_a_suspend>;
> 
>                 /*
>                  * The actual definition of the complete state of the
>                  * pinmux as required by some driver.
>                  *
>                  * These can be either directly in the device node, or
>                  * somewhere in tegra20.dtsi in order to provide pre-
>                  * selected/common configurations. Hence, they're referred
>                  * to by phandle above.
>                  */
>                 pmx_sdhci_active: {
>                         /*
>                          * Pin mux settings. Mandatory?
>                          * Not mandatory if the 1:1 mentioned above is
>                          * extended to 1:n.
>                          *
>                          * Format is <&pmx_controller_phandle muxable_entity_id
>                          * selected_function>.
>                          *
>                          * The pmx phandle is required since there may be more
>                          * than one pinmux controller in the system. Even if
>                          * this node is inside the pinmux controller itself, I
>                          * think it's simpler to just always have this field
>                          * present in the binding for consistency.
>                          *

I prefer to just put such nodes inside pinctrl controller itself and
drop those phandles. 

>                          * Alternative: Format is <&pmx_controller_phandle
>                          * pmx_controller_specific_data>. In this case, the
>                          * pmx controller needs to define #pinmux-mux-cells,
>                          * and provide the pinctrl core with a mapping
>                          * function to handle the rest of the data in the
>                          * property. This is how GPIOs and interrupts work.
>                          * However, this will probably interact badly with
>                          * wanting to parse the entire pinmux map early in
>                          * boot, when perhaps the pinctrl core is initialized,
>                          * but the pinctrl driver itself is not.
>                          */
>                         mux =
>                                 <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
>                                 <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>
>                                 /* Syntax example */
>                                 <&foo_pmx FOO_PMX_PG_X FOO_PMX_MUX_0>;
>                         /*
>                          * Pin configuration settings. Optional.
>                          *
I guess pinconf can be optional because some pin/group that have pinmux
setting do not necessarily have pinconf setting?  If that's case,
yes, agreed.

>                          * Format is <&pmx_controller_phandle muxable_entity_id
>                          * configuration_option configuration_value>.
>                          */
>                         config =
>                                 <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
>                                 <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
>                                 <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
>                                 <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
>                         /*
>                          * Perhaps allow additional custom properties here to
>                          * express things we haven't thought of. The pinctrl
>                          * drivers would be responsible for parsing them.
>                          */
>                 };
>                 pmx_sdhci_standby: {
>                         mux =
>                                 <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
>                                 <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>;
>                         config =
>                                 <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
>                                 <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>
>                                 <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
>                                 <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
>                                 <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
>                                 <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
>                 };
>         };
> };
> 
> Integer IDs for "muxable entities": Pins on IMX, pin groups on Tegra:
> 
>     TEGRA_PMX_PG_DTA
>     TEGRA_PMX_PG_DTD
> 
> Each individual pinmux driver's bindings needs to define what each integer
> ID represents.
> 
> Integer IDs for the "mux functions". Note that these are the raw values
> written into hardware, not any driver-defined abstraction, and not any
> kind of "virtual group" that's been invented to make OEMs life easier:
> 
>     TEGRA_PMX_MUX_0
>     TEGRA_PMX_MUX_1
>     ...
>     TEGRA_PMX_MUX_3 (for Tegra, 7 for IMX)
> 
> Since these are the raw IDs that go into HW, there's no need to specify
> each ID's meanings in the binding.
> 
> Integer IDs for "pin config parameters":
> 
>     TEGRA_PMX_CONF_TRISTATE
>     TEGRA_PMX_CONF_DRIVE_STRENGTH
>     TEGRA_PMX_CONF_SLEW_RATE
> 
> Each individual pinmux driver's bindings needs to define what each integer
> ID represents, and what the legal "value"s are for each one.
> 
Agreed on these.  But we really need to push named constants support
for dtc, otherwise the binding is so difficult for engineering.  (We
have a lot of pinconfig parameters on imx)

Regards,
Shawn

> Advantages:
> 
> * Provides for both mux settings and "pin configuration".
> 
> * Allows the "pinmux configuration" nodes to be part of the SoC .dtsi
>   file if desired to provide pre-defined pinmux configurations to
>   choose from.
> 
> * Allows the "pinmux configuration" nodes to be part of the per-device
>   node if you don't want to use pre-defined configurations.
> 
> * When pre-defined configurations are present, if you need something
>   custom, you can do it easily.
> 
> * Can augment pre-defined configurations by listing n nodes for each
>   "name"d pinmux configuration, e.g. to add one extra pin config
>   value.
> 
> * Parsing is still quite simple:
>   1) Parse "pinmux" property in device node to get phandle.
>   2) Parse "mux" property in the node reference by the phandle,
>      splitting into a list of pmx phandle, entity, mux func.
>   3) For each entry, pass entity, function to the appropriate mux
>      driver. (For U-Boot, this might mean check that the phandle
>      points at the expected place, and ignore the entry if not?)
>  4) Mux driver simply converts "muxable entity" to the register
>     address, write the "function" value straight to the register.
> 
> Disadvantages:
> 
> * If you're not using pre-defined configurations, you still have to dump
>   all the pinmux configuration into a sub-node of the device node, and
>   have a property point at it using a phandle. This is slightly more
>   complex than simply putting the mux/config properties right into the
>   device node. However, it additionally allows one to have multiple
>   "name"d configurations (e.g. for suspend) very easily, and isn't overly
>   complex, so I can live with this.
> 
> Changes to pinctrl subsystem:
> 
> Very little, I think:
> 
> * Need to pass raw function IDs through to the driver instead of the driver
>   defining some logical table. Actually, this is just a change to individual
>   drivers, since they can define the functions "func0", "func1", ... "funcn"
>   as I mentioned before.
> 
> * Need to add the code to actually parse this of course.
> 
> One additional thought: If dtc does grow named constants, we can provide
> HW-function-based names for the mux functions, e.g.:
> 
> TEGRA_PMX_DTA_RSVD0 0
> TEGRA_PMX_DTA_SDIO2 1
> TEGRA_PMX_DTA_VI    2
> TEGRA_PMX_DTA_RSVD3 3
> 
> TEGRA_PMX_DTF_I2C3  0
> TEGRA_PMX_DTF_RSVD1 1
> TEGRA_PMX_DTF_VI    2
> TEGRA_PMX_DTF_RSVD3 3
> ...
> 
> That'd allow the .dts to include functionality-based named for the mux
> function selection, but the .dtb to still include the raw HW mux field
> values. And this is something completely within the control of the SoC
> .dtsi file; if you don't like it, you don't have to do it.
