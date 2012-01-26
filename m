Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2AZRmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:42:25 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:41553 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176Ab2AZRmX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:42:23 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
Date: Thu, 26 Jan 2012 09:42:22 -0800
X-Google-Sender-Auth: 6TAjn1he9XfwrG4nCMhdqKOkVn8
Message-ID: <CAPnjgZ3Xhebn1x1A-Vdy78DWbDd=cp0AK6tL-R1SRzS4GdF97g@mail.gmail.com>
Subject: Re: Pinmux bindings proposal V2
From: Simon Glass <sjg@chromium.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>, Dong Aisheng <dongas86@gmail.com>,
        "Shawn Guo (shawn.guo@linaro.org)" <shawn.guo@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Jan 20, 2012 at 2:22 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Here's V2 of my pinmux binding proposal, after incorporating some feedback
> from Shawn Guo and Dong Aisheng. Main changes:
>
> 1) Require the "pin config" nodes the be children of the pinmux controller
>   node, rather than allowing them to alternatively be children of the
>   device node that's using them. This allows removal of the pin controller
>   phandle as the first entry in each specifier.
>
> 2) Add explicit #pinmux-cells and #pinconfig-cells properties to the pin
>   controller, so that pin controllers can define the layout of their mux
>   and configuration specifiers.
>
> 3) Don't document a "1:1" model; only document a "1:n" model, whereby each
>   named state for a device node can refer to multiple pin configuration
>   nodes. This allows:
>
>   a) A device to use multiple configuration nodes from a single pin
>      controller. For example, one may specify a very common subset of
>      the configuration for a particular device, and another may specify
>      a few board-specific tweaks on top of that.
>
>   b) A single device to specify configurations for multiple pin
>      controllers.
>
> TODO: I should write a real binding document for this, rather than simply
> providing a commented example.
>
> Note: I've used named constants below just to make this easier to read.
> We still don't have a solution to actually use named constants in dtc yet.
>
> tegra20.dtsi:
>
> / {
>        /*
>         * The SoC .dtsi file will define the basic properties of each HW
>         * module; compatible, reg, interrupts, ... There's no change here
>         * relative to normal practice.
>         */
>        tegra_pmx: pinmux@70000000 {
>                compatible = "nvidia,tegra20-pinmux";
>                reg = <0x70000014 0x10   /* Tri-state registers */
>                       0x70000080 0x20   /* Mux registers */
>                       0x700000a0 0x14   /* Pull-up/down registers */
>                       0x70000868 0xa8>; /* Pad control registers */
>                /*
>                 * Common pin control bindings specify that these properties
>                 * must exist in a pin controller. Each individual pin
>                 * controller's bindings specify the values.
>                 */
>                #pinmux-cells = <2>;
>                #pinconfig-cells = <3>;
>        };
>
>        sdhci@c8000200 {
>                compatible = "nvidia,tegra20-sdhci";
>                reg = <0xc8000200 0x200>;
>                interrupts = <0 15 0x04>;
>        };
> };
>
> tegra20.dtis or tegra-harmony.dts:
>
> /{
>        /*
>         * The pin controller node will contain child nodes that define
>         * various subsets of the overall pin state.
>         *
>         * These nodes may be defined in the SoC .dtsi file if the vendor
>         * wants to provide a set of common configurations for customers
>         * or users to pick from.
>         *
>         * These nodes may be defined in the board .dts file too; e.g. if
>         * a particular board uses a configuration that isn't in the set
>         * of provided common options, or the SoC vendor simply chose not
>         * to provide a set of common options.
>         */
>        &tegra_pmx {
>                /*
>                 * There are (may be) many of these pin configuration child
>                 * nodes. Each is referenced by phandle from device nodes.
>                 *
>                 * Below I've shown an example of an SDHCI controller. There
>                 * is a set of common settings in node pmx_sdhci. The slight
>                 * differences between active and standby states are in nodes
>                 * pmc_sdhci_active and pmx_sdhci_suspend.
>                 *
>                 * Note though the the 3-node split is just an example; you
>                 * could easily have a single node for devices that don't
>                 * need separate active/suspend state, or many more nodes
>                 * for a device with a more complex set of shared settings
>                 * or that uses more states.
>                 */
>                pmx_sdhci: pinconfig-sdhci {
>                        /*
>                         * The mux property is a list of muxable entities
>                         * and the mux function to select for it. The number
>                         * of cells in each entry is the pin controller's
>                         * #pinmux-cells property. The pin controller's
>                         * binding defines what the cells mean. The pinctrl
>                         * driver is responsible for mapping this data to
>                         * the (group, function) pair required to fill in
>                         * the pinctrl subsystem's pinmux mapping table.
>                         */
>                        mux =
>                                <TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_SDIO1>
>                                <TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_SDIO1>;
>                        /*
>                         * The config property is a list of muxable entities
>                         * and individual configuration setting. The number
>                         * of cells in each entry is the pin controller's
>                         * #pinconfig-cells property. The pin controller's
>                         * binding defines what the cells mean. The pinctrl
>                         * driver is responsible for mapping this data to
>                         * the (group, config) pair required to fill in
>                         * the pinctrl subsystem's pin configuration table.
>                         */
>                        config =
>                                <TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
>                                <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
>                                <TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
>                                <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
>                };
>                pmx_sdhci_active: pinconfig-sdhci-active {
>                        /*
>                         * In each of these nodes, both the mux and config
>                         * properties are optional. This node represents the
>                         * additions to pmx_sdhci that are specific to an
>                         * active state. In this case, only pin configuration
>                         * settings are different.
>                         */
>                        config =
>                                <TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 0>
>                                <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 0>;
>                };
>                pmx_sdhci_standby: pinconfig-sdhci-standby {
>                        config =
>                                <TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
>                                <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>;
>                };
>                /*
>                 * ... continuing from the comment in pmx_sdhci_active:
>                 *
>                 * However, one could imagine representing GPIO as a regular
>                 * pinmux function, and have a board .dts file create an
>                 * extra node to represent that, and hence containing just
>                 * a mux property:
>                 */
>                pmx_sdhci_harmony: pinconfig-sdhci-harmony {
>                        mux = <TEGRA_PMX_PIN_GPIO_PA1 TEGRA_PMX_MUX_GPIO>;
>                };
>        };
> };
>
> tegra-harmony.dts:
>
> /{
>        sdhci@c8000200 {
>                /*
>                 * Each device node contains a few properties to describe
>                 * the named pinmux states that are available to it.
>                 *
>                 * The binding for the device node specifies the state names
>                 * that must be described; common examples such as "default"
>                 * or "active" and "suspend" may be universal, but the IO
>                 * protocol that a device supports may demand that more
>                 * states be defined, such as "active-12mhz", "active-50mhz",
>                 * "suspend". Drivers request these named states e.g. using
>                 * pinctrl's pinmux_get("state_name") API.
>                 *
>                 * pinctrl-names lists the available state names.
>                 *
>                 * Unlike the common clock binding, I assume here that states
>                 * are always requested by name. If we don't like that idea,
>                 * we'd could make this property optional, and add a new API
>                 * pinmux_get(state_id) to the pinctrl subsystem.
>                 */
>                pinctrl-names = "active", "suspend";
>                /*
>                 * pinctrl-entries contains a single cell for each state name
>                 * in pinctrl-names. It defines how many entries are present
>                 * in property "pinctrl" for the given named state.
>                 *
>                 * Here, state "active" covers 2 entries (0 and 1) in pinctrl,
>                 * and state "suspend" covers 2 more entries (2 and 3) in
>                 * pinctrl.
>                 */
>                pinctrl-entries = <2 2>;
>                /*
>                 * pinctrl contains a list of phandles. Each refers to one of
>                 * the pin config nodes within the pin controller. So, to set
>                 * up state "active", nodes pmx_sdhci and pmx_sdhci_active
>                 * must both be programmed. To set up state "suspend", nodes
>                 * pmx_sdhci and pmx_sdhci_standby must be programmed.
>                 */
>                pinctrl = <&pmx_sdhci> <&pmx_sdhci_active>
>                          <&pmx_sdhci> <&pmx_sdhci_standby>;
>        };
> };
>
> --
> nvpublic
>

I have been through this carefully and thought about how this might be
implemented. Your example has really helped me to understand this
properly, as the 70-email-long thread was a huge amount of reading.

So I have the following comments in general:

1. It doesn't seem to make full use of the device tree format. For example,

   <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>

would be better as something like

    drive-strength = <5>;

if we could arrange it. It also reduces the need for these
TEGRA_PMX_CONF_DRIVE_STRENGTH defines.

2. The TEGRA_PMX_ prefix on everything seems unnecessary to me and
makes it harder to read and more long-winded. Other SOCs will not
include the same header, I think. Can we just drop this?

3. To me, the pinctrl-entries following by pinctrl also does not make
great use of the device tree. It seems to me that this:

pinctrl-entries = <2 2>;
pinctrl = <&pmx_sdhci> <&pmx_sdhci_active>
         <&pmx_sdhci> <&pmx_sdhci_standby>;

where you say:
>                 * Here, state "active" covers 2 entries (0 and 1) in pinctrl,
>                 * and state "suspend" covers 2 more entries (2 and 3) in
>                 * pinctrl.

might be better as something like:

state-active {
       mux =  <&pmx_sdhci> <&pmx_sdhci_active>;
};

state-standby {
       mux =  <&pmx_sdhci> <&pmx_sdhci_standby>;
};

which means that we don't need to represent a 2-dimensional array in a
single property, which seems error-prone and complicated. In general I
wonder if we can make more use of hierarchy. This might help it be
more extensible in future also.

4. Your example for different 'states' is clear, but I'm not sure if
you are intending to handling actual different pin assignments in
these 'states'. To me this is the big point: does SDIO1 come out pin
groups DTA and DTC; or does it come out pin groups SLXA-D. That's what
the boards want to select. I think the state side of it may be best as
a separate thing, which drivers may even just handle themselves if
they are basic implementations. Or they may just want to implement the
active state (U-Boot).

5. My previous email suggested that the SOC define several possible
options for each peripheral so that the board vendor can just select
them from a menu. All the device tree complexity would then live in
the SOC file (tegra20.dtsi in this case) and very little in the board
file. I still think that is a worthwhile goal. You have this in there,
but I feel it could be simplified further, to a single phandle
perhaps.

6. Looking ahead I imagine that the pinmux nodes will become large. I
don't know how large but looking at some of the kernel bindings for TI
I do get a little alarmed. Board vendors may wish to try to cut down
the size of the device tree blob, particularly for use in the boot
loader. With the binding in your email I think that would be hard to
do. In particular if people know that standby is not being used in the
boot loader, I think they would need to do things like change:

pinctrl-entries = <2 2>;
pinctrl = <&pmx_sdhci> <&pmx_sdhci_active>
         <&pmx_sdhci> <&pmx_sdhci_standby>;

to:

pinctrl-entries = <2>;
pinctrl = <&pmx_sdhci> <&pmx_sdhci_active>;

just so that they can delete the standby nodes and reduce the blob
size. It seems a little messy. For this purpose it would be much nicer
if the board vendor could just remove nodes [please, discussion about
whether board vendors SHOULD do this aside]. If everything is nicely
set up in the device tree hierarchy that would be simpler. For
example, board vendors could remove all the pinmux node that they are
not using (let's say they keep SDIO1 DTA, DTC and SDIO2 SLX but remove
the other SDIO1 and SDIO2 nodes and remove all SDIO3 and SDIO4 nodes).
Even better if one day we have a way of automatically filtering out
these unused nodes when creating the device tree blob for a board -
separate discussion.

7. It would be nice to avoid huge data tables in the code, and keep
these in the device tree where possible. I only mention this because
it keeps coming up in the threads.

So, rather than just provide vague feedback, I though I would try to
modify your binding according to the above, so it is below, for
consideration. I am not entirely happen with having the states under
each pin, but I do think it makes the meaning very clear. The example
pinmux is made up and doesn't correspond properly to Tegra2.


In tegra-harmony.dts:

/ {
	/* Select pin mux for these two SDHCI ports */
	sdhci@c8000200 {
		pinctrl = <&pmx_sdhci1_dta_dtd>;
	};

	sdhci@c8000400 {
		pinctrl = <&pmx_sdhci2_sdb_sdc>;
	};
};

In tegra20.dtsi:

/ {
	&tegra_pmx {
		#address-cells = <1>;
		#size-cells = <0>;

		/*
		 * This is the first option for SDIO1. It comes out
		 * on pin groups DTA and DTD. Boards can simply use this
		 * phandle in the driver node to get this option. Any options
		 * not used could potentially be dropped from the device tree
		 * blob for space-constrained boot loaders.
		 */
		pmx_sdhci1_dta_dtd: sdhci1-dta-dtd@0 {
			#address-cells = <1>;
			#size-cells = <0>;
			reg = <0>;
			label = "SDIO1 on DTA, DTD (4-bit)";

			/*
			 * Here are the pin groups needed for this option.
			 * First DTA, then DTD.
			 */
			pmx@dta {
				reg = <PG_DTA>;
				mux = <PMX_MUX_SDIO1>;
				drive-strengh = <5>;
				slew-rate = <4>;

				/*
				 * We support two states here, active
				 * and standby. Properties in these child
				 * nodes can override the ones at this level.
				 * Drivers can move between states just by
				 * making the changes in these nodes.
				 */
				state-active {
					reg = <PMX_CONF_ACTIVE>;
					tristate = <0>;
				};
				state-standby {
					reg = <PMX_CONF_STANDBY>;
					tristate = <1>;
					drive-strengh = <2>;
				};
			};
			pmx@dtd {
				reg = <PG_DTD>;
				mux = <PMX_MUX_SDIO1>;
				slew-rate = <8>;
				pmx-active {
					reg = <PMX_CONF_ACTIVE>;
					tristate = <0>;
					drive-strengh = <5>;
				};
				pmx-standby {
					reg = <PMX_CONF_STANDBY>;
					tristate = <1>;
					drive-strengh = <2>;
				};
			};
		};

		/*
		 * This is the second option for SDIO1. It comes out
		 * on four SLX pins and supports 8-bit data.
		 */
		pmx_sdhci_slx: sdhci-slx@1 {
			#address-cells = <1>;
			#size-cells = <0>;
			reg = <1>;
			label = "SDIO1 on SLXA, C, D, X (8-bit)";
			pmx@slxa {
				reg = <PG_SLXA>;
				mux = <PMX_MUX_SDIO1>;
				drive-strengh = <5>;
				slew-rate = <4>;
				state-active {
					reg = <PMX_CONF_ACTIVE>;
					tristate = <0>;
				};
				state-standby {
					reg = <PMX_CONF_STANDBY>;
					tristate = <1>;
				};
			}
			pmx@slxb {
				reg = <PG_SLXB>;
				mux = <PMX_MUX_SDIO1>;
				drive-strengh = <5>;
				slew-rate = <4>;
				state-active {
					reg = <PMX_CONF_ACTIVE>;
					tristate = <0>;
				};
				state-standby {
					reg = <PMX_CONF_STANDBY>;
					tristate = <1>;
				};
			}
			pmx@slxc {
				reg = <PG_SLXC>;
				mux = <PMX_MUX_SDIO1>;
				drive-strengh = <5>;
				slew-rate = <4>;
				state-active {
					reg = <PMX_CONF_ACTIVE>;
					tristate = <0>;
				};
				state-standby {
					reg = <PMX_CONF_STANDBY>;
					tristate = <1>;
				};
			}
			pmx@slxd {
				reg = <PG_SLXD>;
				mux = <PMX_MUX_SDIO1>;
				drive-strengh = <5>;
				slew-rate = <4>;
				state-active {
					reg = <PMX_CONF_ACTIVE>;
					tristate = <0>;
				};
				state-standby {
					reg = <PMX_CONF_STANDBY>;
					tristate = <1>;
				};
			};
		};

		/*
		 * This is the first option for SDIO2...
		 */
		pmx_sdhci2_sdb_sdc: sdhci2-sdb-sdc@0 {
			#address-cells = <1>;
			#size-cells = <0>;
			reg = <0>;
			label = "SDIO2 on SDB, SDC (4-bit)";
			...
		...
		};
	};
};


Regards,
Simon
