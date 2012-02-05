Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205Ab2BEFcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 00:32:20 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13956 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2BEFcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 00:32:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sat, 04 Feb 2012 21:31:52 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng <dongas86@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "ext Tony Lindgren (tony@atomide.com)" <tony@atomide.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Sat, 4 Feb 2012 21:31:49 -0800
Subject: An extremely simplified pinctrl bindings proposal
Thread-Topic: An extremely simplified pinctrl bindings proposal
Thread-Index: Aczjxw71NXxkNWbISfC9bSfK8ynGWg==
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com>
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

Sorry, I haven't had a chance to read any of the pincrl emails from
Friday onwards. However, I thought a bit more about this, and decided
to propose someting much simpler:

Thoughts:

* Defining all the pins, groups, functions, ... takes a lot of space,
  whether it's in static data in pinctrl drivers or in the device tree.
  The lists must also be stored in RAM at runtime.

* It's been very difficult to come up with a generic description of all
  pin controller's capabilities. This is true even irrespective of device
  tree; think pin config where we've agonized over whether we can create
  a standardized list of pin config properties, or need to allow each
  pinctrl driver to define its own set of properties, etc.

* The only real use of the lists is for debugfs. Drivers shouldn't expect
  to directly request specific pinctrl settings, since that would encode
  knowledge of an individual SoC's pin controller. This should be
  abstracted from drivers.

* The data in debugfs could easily be replaced by a raw register dump
  coupled with a SoC-specific script to print out what each register
  means.

My proposal below is to radically simplify the pinctrl subsystem, and
make it little more than a system to execute a list of arbitrary register
writes.

Advantages:

* No need to define any kind of data model for pinctrl.

* No need to store any list of pins/groups/function/parameters/... either
  in static data, in device tree, or at run-time.

* No need to store the the selected board-specific settings anywhere either.

* Completely generic; can handle anything that exists now or in the future.

* Handles pin mux and pin config identically.

* Extremely simple to implement and understand; probably just a few K
  of code and no data. I assume this will be very appealing to those
  interested in using the binding within U-Boot too.

* The lists of register writes can just as easily be provided by board
  files as device tree, so operation should be identical.

Disadvantages:

* Creating the list of register values/masks may be a little painful. If
  we move forward with this, we'd want to strongly push dtc towards
  providing named constants, expressesion, macros, etc. Those dtc features
  would be very useful anyway.

* Lack of high-level semantic meaning to the data; but I assert there's
  little benefit to having that anyway.

  To solve this, write a script to parse each pinctrl driver's regcache
  file and print out all the register meanings.

* This scheme wouldn't represent which device "owns" which pins/groups,
  nor be able to validate that different devices' pinmux settings don't
  conflict.

  I don't think this is a huge issue though, since that's mainly error-
  checking. Any problems should be just as obvious during testing whether
  they cause the HW to fail to operate correctly, or whether they cause
  pinctrl to throw an error. Equally, there are many error conditions
  that pinctrl core wasn't checking for anyway.

Precedent:

* There was previous discussion on using this exact technique for pinmux
  at a previous Linaro Connect:

  http://www.spinics.net/lists/linux-tegra/msg01943.html

* There is an existing binding that works very similarly, for the Mavell
  PHY:

  http://www.gossamer-threads.com/lists/linux/kernel/1305624
  drivers/net/phy/marvell.c

  Explicit mention was made here that a simple list of register writes
  avoiding the complexity of representing a huge number of combinations
  in the device tree.

tegra20.dtsi:

pinmux: pinmux@70000000 {
        compatible = "nvidia,tegra20-pinmux";
        reg = <0x70000014 0x10>  /* Tri-state registers */
              <0x70000080 0x20>  /* Mux registers */
              <0x700000a0 0x14>  /* Pull-up/down registers */
              <0x70000868 0xa8>; /* Pad control registers */

        pinmux_i2c1_spdio_active: pinmux-i2c1-spdio-active {
                reg-init =
                    /* Set pingroup SPDO to function I2C1 */
                    <
                        1          /* Register "bank" in controller */
                        0x8c       /* Register offset */
                        0x000000c0 /* Write bitmask, 0 for whole register */
                        0x00000080 /* Write value */
                    >
                    /* Set pingroup SPDI to function I2C1 */
                    <
                        1          /* Register "bank" in controller */
                        0x8c       /* Register offset */
                        0x00000300 /* Write bitmask, 0 for whole register */
                        0x00000200 /* Write value */
                    >;
        };
        pinmux_i2c1_spdio_suspend: pinmux-i2c1-spdio-suspend {
                ...
        };
};

tegra-seaboard.dts:

i2c@7000c000 {
        /*
         * These are phandles to nodes that containthe reg-init list. Can
         * we have phandles to properties instead? Then we wouldn't need
         * all those nodes which each just contains 1 property.
         */
        pinctrl = <&pinmux_i2c1_spdio_active &pinmux_i2c1_spdio_suspend>;
        pinctrl-names = "active", "suspend";
};

In order to support programming more than one pin controller at once, we
could include the phandle of the pin controller in the "reg-init" property:

somewhere-other-than-under-a-pin-controller {
        pinmux-foo {
                reg-init =
                    <
                        &tegra_pmx /* Pin controller */
                        2          /* Number of entries for this controller */
                    >
                    <
                        1          /* Register "bank" in controller */
                        0x8c       /* Register offset */
                        0x000000c0 /* Write bitmask, 0 for whole register */
                        0x00000080 /* Write value */
                    >
                    <
                        1          /* Register "bank" in controller */
                        0x8c       /* Register offset */
                        0x00000300 /* Write bitmask, 0 for whole register */
                        0x00000200 /* Write value */
                    >
                    <
                        &other_pmx /* Pin controller */
                        1          /* Number of entries for this controller */
                    >
                    <
                        0          /* Register "bank" in controller */
                        0x04       /* Register offset */
                        0x000000ff /* Write bitmask, 0 for whole register */
                        0x0000005a /* Write value */
                    >;
        }
};

When parsing a reg-init property, we know if it contains phandles by:
* If node containing property is a child of a pin controller, the property
  doesn't containt pin controller phandles.
* Otherwise, it does.

What are people's thoughts. Thinking about all the issues involved, this
is certainly the approach I like most right now.

-- 
nvpublic

