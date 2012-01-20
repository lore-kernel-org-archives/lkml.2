Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2ATWWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 17:22:48 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10075 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab2ATWWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 17:22:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 20 Jan 2012 14:22:21 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "Shawn Guo (shawn.guo@linaro.org)" <shawn.guo@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 20 Jan 2012 14:22:20 -0800
Subject: Pinmux bindings proposal V2
Thread-Topic: Pinmux bindings proposal V2
Thread-Index: AczXwcp/X6O6a0uLRSCwUah9NEGgTw==
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
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

Here's V2 of my pinmux binding proposal, after incorporating some feedback
from Shawn Guo and Dong Aisheng. Main changes:

1) Require the "pin config" nodes the be children of the pinmux controller
   node, rather than allowing them to alternatively be children of the
   device node that's using them. This allows removal of the pin controller
   phandle as the first entry in each specifier.

2) Add explicit #pinmux-cells and #pinconfig-cells properties to the pin
   controller, so that pin controllers can define the layout of their mux
   and configuration specifiers.

3) Don't document a "1:1" model; only document a "1:n" model, whereby each
   named state for a device node can refer to multiple pin configuration
   nodes. This allows:

   a) A device to use multiple configuration nodes from a single pin
      controller. For example, one may specify a very common subset of
      the configuration for a particular device, and another may specify
      a few board-specific tweaks on top of that.

   b) A single device to specify configurations for multiple pin
      controllers.

TODO: I should write a real binding document for this, rather than simply
providing a commented example.

Note: I've used named constants below just to make this easier to read.
We still don't have a solution to actually use named constants in dtc yet.

tegra20.dtsi:

/ {
        /*
         * The SoC .dtsi file will define the basic properties of each HW
         * module; compatible, reg, interrupts, ... There's no change here
         * relative to normal practice.
         */
        tegra_pmx: pinmux@70000000 {
                compatible = "nvidia,tegra20-pinmux";
                reg = <0x70000014 0x10   /* Tri-state registers */
                       0x70000080 0x20   /* Mux registers */
                       0x700000a0 0x14   /* Pull-up/down registers */
                       0x70000868 0xa8>; /* Pad control registers */
                /*
                 * Common pin control bindings specify that these properties
                 * must exist in a pin controller. Each individual pin
                 * controller's bindings specify the values.
                 */
                #pinmux-cells = <2>;
                #pinconfig-cells = <3>;
        };

        sdhci@c8000200 {
                compatible = "nvidia,tegra20-sdhci";
                reg = <0xc8000200 0x200>;
                interrupts = <0 15 0x04>;
        };
};

tegra20.dtis or tegra-harmony.dts:

/{
        /*
         * The pin controller node will contain child nodes that define
         * various subsets of the overall pin state.
         *
         * These nodes may be defined in the SoC .dtsi file if the vendor
         * wants to provide a set of common configurations for customers
         * or users to pick from.
         *
         * These nodes may be defined in the board .dts file too; e.g. if
         * a particular board uses a configuration that isn't in the set
         * of provided common options, or the SoC vendor simply chose not
         * to provide a set of common options.
         */
        &tegra_pmx {
                /*
                 * There are (may be) many of these pin configuration child
                 * nodes. Each is referenced by phandle from device nodes.
                 *
                 * Below I've shown an example of an SDHCI controller. There
                 * is a set of common settings in node pmx_sdhci. The slight
                 * differences between active and standby states are in nodes
                 * pmc_sdhci_active and pmx_sdhci_suspend.
                 *
                 * Note though the the 3-node split is just an example; you
                 * could easily have a single node for devices that don't
                 * need separate active/suspend state, or many more nodes
                 * for a device with a more complex set of shared settings
                 * or that uses more states.
                 */
                pmx_sdhci: pinconfig-sdhci {
                        /*
                         * The mux property is a list of muxable entities
                         * and the mux function to select for it. The number
                         * of cells in each entry is the pin controller's
                         * #pinmux-cells property. The pin controller's
                         * binding defines what the cells mean. The pinctrl
                         * driver is responsible for mapping this data to
                         * the (group, function) pair required to fill in
                         * the pinctrl subsystem's pinmux mapping table.
                         */
                        mux =
                                <TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_SDIO1>
                                <TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_SDIO1>;
                        /*
                         * The config property is a list of muxable entities
                         * and individual configuration setting. The number
                         * of cells in each entry is the pin controller's
                         * #pinconfig-cells property. The pin controller's
                         * binding defines what the cells mean. The pinctrl
                         * driver is responsible for mapping this data to
                         * the (group, config) pair required to fill in
                         * the pinctrl subsystem's pin configuration table.
                         */
                        config =
                                <TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
                                <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
                                <TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
                                <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
                };
                pmx_sdhci_active: pinconfig-sdhci-active {
                        /*
                         * In each of these nodes, both the mux and config
                         * properties are optional. This node represents the
                         * additions to pmx_sdhci that are specific to an
                         * active state. In this case, only pin configuration
                         * settings are different.
                         */
                        config =
                                <TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 0>
                                <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 0>;
                };
                pmx_sdhci_standby: pinconfig-sdhci-standby {
                        config =
                                <TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
                                <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>;
                };
                /*
                 * ... continuing from the comment in pmx_sdhci_active:
                 *
                 * However, one could imagine representing GPIO as a regular
                 * pinmux function, and have a board .dts file create an
                 * extra node to represent that, and hence containing just
                 * a mux property:
                 */
                pmx_sdhci_harmony: pinconfig-sdhci-harmony {
                        mux = <TEGRA_PMX_PIN_GPIO_PA1 TEGRA_PMX_MUX_GPIO>;
                };
        };
};

tegra-harmony.dts:

/{
        sdhci@c8000200 {
                /*
                 * Each device node contains a few properties to describe
                 * the named pinmux states that are available to it.
                 *
                 * The binding for the device node specifies the state names
                 * that must be described; common examples such as "default"
                 * or "active" and "suspend" may be universal, but the IO
                 * protocol that a device supports may demand that more
                 * states be defined, such as "active-12mhz", "active-50mhz",
                 * "suspend". Drivers request these named states e.g. using
                 * pinctrl's pinmux_get("state_name") API.
                 *
                 * pinctrl-names lists the available state names.
                 *
                 * Unlike the common clock binding, I assume here that states
                 * are always requested by name. If we don't like that idea,
                 * we'd could make this property optional, and add a new API
                 * pinmux_get(state_id) to the pinctrl subsystem.
                 */
                pinctrl-names = "active", "suspend";
                /*
                 * pinctrl-entries contains a single cell for each state name
                 * in pinctrl-names. It defines how many entries are present
                 * in property "pinctrl" for the given named state.
                 *
                 * Here, state "active" covers 2 entries (0 and 1) in pinctrl,
                 * and state "suspend" covers 2 more entries (2 and 3) in
                 * pinctrl.
                 */
                pinctrl-entries = <2 2>;
                /*
                 * pinctrl contains a list of phandles. Each refers to one of
                 * the pin config nodes within the pin controller. So, to set
                 * up state "active", nodes pmx_sdhci and pmx_sdhci_active
                 * must both be programmed. To set up state "suspend", nodes
                 * pmx_sdhci and pmx_sdhci_standby must be programmed.
                 */
                pinctrl = <&pmx_sdhci> <&pmx_sdhci_active>
                          <&pmx_sdhci> <&pmx_sdhci_standby>;
        };
};

-- 
nvpublic

