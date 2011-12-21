Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab1LUAj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:39:28 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1200 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab1LUAjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:39:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 20 Dec 2011 16:39:23 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng <b29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Tue, 20 Dec 2011 16:39:23 -0800
Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Topic: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Index: Acy/PPx8DCjD0TfjQL6bVpPiGEgHegAN2gng
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-3-git-send-email-b29396@freescale.com>
In-Reply-To: <1324402840-32451-3-git-send-email-b29396@freescale.com>
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

Dong Aisheng wrote at Tuesday, December 20, 2011 10:41 AM:
> This patch provies a common API for driver to use to register pinmux
> mappings from dts file. It is needed for dt support.

Dong,

Thanks for providing a concrete binding to get discussion started. I had
intended to do this myself, but got side-tracked on other things.

I'll comment exclusively on the documentation in this patch, since any
changes there will require the code to be changed.

> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl.txt
> +The pin control subsystem
> +
> +The pin control subsystem provides a common API to support parsing pinmux
> +mappings data from device tree. Each board dts file should provide a device
> +node of which all the child nodes are the corresponding pinmux mappings.

So, the binding you propose seems very reasonable from the point-of-view
of the Linux pinctrl subsystem. However, it violates basic device tree
philosophy in a few ways. Some background:

Device tree is supposed to be a pure representation of hardware, not the
software that runs on it. This means a couple of things: (a) the nodes
in the DT generally match 1:1 with specific HW on the board (b) the
design of the bindings should be justifiable given HW datasheets without
any reference to specific operating systems or software driver design
(c) the DT should be useful to all operating systems that run on the HW;
there should be no "DT for Linux", "DT for FreeBSD", "DT for Windows".
Hence, I see a few problems with this binding:

a) The binding is documented as being for the pinctrl subsystem, rather
than for pinmux hardware.

b) The top-level node ("imx6q-sabreauto-map" below) is not tied to any
particular piece of hardware (no compatible flag, not reg property etc.)

c) The design of the binding is very much derived from the design of the
pinctrl subsystem's internal data structures. This isn't necessarily bad,
since in general SW data structures might be very closely related to how
HW is put together. In this case though, the binding seems very SW oriented.

> +The required properties for pinmux mapping are:
> +- map-name: the name of this specific map entry
> +- clk-dev-name: the name of the device controlling this specific mapping
> +- funcion: a function in the driver to use for this mapping
> +
> +Optional properties:
> +- group: a certain specific pin group to activate for the function
> +- dev-name: the name of the device using this specific mapping
> +- hog-on-boot: indicate wether hog the mappings(do not need to specify value)
> +
> +Examples:
> +
> +pinmux: imx6q-sabreauto-map {

Here we have an all-encompassing standalone "pinctrl mapping table" node.
If we continue to have such an all-encompassing table, it should really
be part of (a child of) the pinmux HW's node in order to tie it directly
to the HW, rather than standing out as a HW concept. So, perhaps something
more like:

iomuxc@020e0000 {
    compatible = "fsl,imx6-pinmux";
    usage { // I can't think of a good name for the table right now
        sd4 {
        };
        sd3 {
        };
        ...
    };
};

Others have suggested that having this all-encompassing table isn't the
correct approach, and instead, it should be split into chunks that are
co-located with the devices that use the pinmux:

sdhci@1000 {
    compatible = "...";
    regs = <...>;
    pinmux = <&pmx>;
    pinmux-usage = {
        // Some representation of the pins/groups/functions used
        // by just this HW block.
    };
};
sdhci@2000 {
    compatible = "...";
    regs = <...>;
    pinmux = <&pmx>;
    pinmux-usage = {
        // Some representation of the pins/groups/functions used
        // by just this HW block.
    };
};

The latter probably is a little more idiomatic, although I haven't seen
or thought through any details on what goes inside such a "pinmux-usage"
node yet.

> +	map-sd4 {
> +		map-name = "usdhc4";

I don't think that field is needed; I'd suggest just using the name of
the DT node containing the entry (which could be renamed to your desired
names)

> +		ctrl-dev-name = "20e0000.iomuxc";
...
> +		dev-name = "219c000.usdhc";

That name is Linux-specific. Instead of using device names, we should
use phandle references, e.g. see the "dev" property below:

sdhci1: sdhci@1000 {
...
};
sdhci2: sdhci@1000 {
...
};
iomuxc@020e0000 {
    compatible = "fsl,imx6-pinmux";
    usage {
        sd4 {
            dev = <&sdhci1>;
        };
        sd3 {
            dev = <&sdhci2>;
        };
        ...
    };
};

(in the above, your ctrl-dev-name would be implied to be iomuxc@020e0000
since the table is part of that pinctrl device's node)

> +		function = "sd4";

Here it would be nice to use an integer instead. However, putting lots
of opaque integers in the device tree is going to be ripe for mistakes.
It's a real pity that dtc doesn't have a way of doing named integer
constants, so this could be re-written as e.g.:

SoC .dtsi file:

/define/ TEGRA_MUX_FUNC_SD4 234

Board .dts file:

function = <TEGRA_MUX_FUNC_SD4>;

Without that feature, using strings here seems the only reasonable thing
to do.

We also need to consider compatibility and extensibility. A DT binding
is an ABI between the kernel and whatever is providing it, and so we
need to be able to maintain and extend it in a compatible fashion, just
like the user-space syscall ABI. Now it's true that the .dts files are
currently part of the kernel source tree and can be rev'd in sync with
kernel changes, but that may not always be the case moving forward.

In other words, taking a board with an old device tree embedded into
Flash and running a new kernel using that device tree should work just
like running the original kernel did.

There are a couple of current active areas of change in the pinctrl
subsystem that impact this:

* Pin configuration is being added. We probably need to add the data to
configure pin config into the mapping table in the kernel, or some
parallel table.

* Support for pins being in multiple states (active, suspend, unused,
...) is being added to pinctrl. We need to be able to represent this in
DT too.

(and yes I know I wrote that from a Linux pinctrl SW perspective, but
the concepts apply to HW!)

To support this, we may just be able to add more fields to any mapping
table entries e.g. to describe pin config setup alongside mux setup.
It'd probably be a good idea to add some kind of "type" field to the
table entries though, so that we can transparently add new types in
the future, much like compatible does for HW nodes.

iomuxc@020e0000 {
    compatible = "fsl,imx6-pinmux";
    usage {
        sd4 {
            type = <0>; // 0 == mux setting
            dev = <&sdhci1>;
        };
        sd3 {
            type = <0>; // 0 == mux setting
            dev = <&sdhci2>;
        };
        foo {
            type = <1>; // 1 == pin config?
            dev = <&sdhci2>;
            pull-up;
            tri-state;
            ...
        };
        ...
    };
};

-- 
nvpublic

