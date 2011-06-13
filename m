Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1FMRMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 13:12:41 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3480 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab1FMRMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:12:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 13 Jun 2011 10:12:24 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Date: Mon, 13 Jun 2011 10:12:22 -0700
Subject: RE: [RFC] (early draft) dt: Linux dt usage model documentation
Thread-Topic: [RFC] (early draft) dt: Linux dt usage model documentation
Thread-Index: AcwpzlWRvSnvkH71SnC634TBZlVK2wAGsSig
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04992C01C8@HQMAIL01.nvidia.com>
References: <20110613132935.16600.94753.stgit@ponder>
In-Reply-To: <20110613132935.16600.94753.stgit@ponder>
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

Grant Likely wrote at Monday, June 13, 2011 7:32 AM:
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> Hey all,
> 
> This is an early draft of the usage model document for the device
> tree, but I wanted to get it out there for feedback, and so that some
> of the Linaro engineers could get started on migrating board ports.

This looks great. I'll certainly raise awareness of this documentation
within NVIDIA. I'd written a few brief internal notes on this topic, but
yours is much more complete.

As far as the content goes, it all looks good to me. Of course, I'm already
somewhat familiar with DT...

So, unfortunately, almost all I have to contribute to below are some nit-
pick typos etc.

...
> +The "Open Firmware Device Tree", or simply Device Tree (DT), is a data
> +structure and language for describing hardware.  More specifically, it
> +is an description of hardware that is readable by an operating system
      ^^ a

...
> +<h2>History</h2>

Should the HTML tags be here?

...
> +In the majority of cases, the machine identity is irrelevant, and the
> +kernel will instead select setup code based on the machines core

machine's

...
> +The reasoning behind this scheme is the observation that in the majority
> +of cases, a single machine_desc can support a large number of boards
> +if that all use the same SoC, or same family of SoCs.  However,
      ^^^^ they (or delete "if")

...
> +Instead, the compatible list allows a generic machine_desc to provide
> +support for a wide common set of boards by specifying "less
> +compatible" value in the dt_compat list.  In the example above,
> +generic board support can claim compatibility with "ti,omap3" or
> +"ti,omap3450".  If a bug was discovered on the original beagleboard
> +that required special workaround code during early boot, then a new
> +machine_desc could be added which implements the workarounds and only
> +matches on "ti,beagleboard".

The exact example above is "ti,omap3-beagleboard".

...
> +Most of this data is contained in the /chosen node, and when booting
> +Linux it will look something like this:
> +
> +	chosen {
> +		bootargs = "console=ttyS0,115200 loglevel=8";
> +		initrd-start = &lt;0xc8000000&gt;;
> +		initrd-end = &lt;0xc8200000&gt;;

HTML conversion issue here too.

...
> +The simplest case is when .init_machine() is only responsible for
> +registering a block of platform_devices.  Platform devices are concept

are *a* concept

> +About now is a good time to lay out an example.  Here is part of the
> +device tree for the NVIDIA Tegra board.
...
> +	sound {
> +		compatible = "nvidia,harmony-sound";
> +		i2s-controller = <&i2s-1>;
> +		i2s-codec = <&wm8903>;
> +	};

I'm not sure if the bindings for ASoC devices are agreed upon well enough
yet to include that part of the example?

...
> +In the Tegra example, this accounts for the /soc and /sound nodes, but
> +what about the children of the soc node?  Shouldn't they be registered
> +as platform devices too?  For Linux DT support, the generic behaviour
> +is for child devices to be registered by the parent's device driver at
> +driver .probe() time.  So, an i2c bus device driver will register a
see right margin:                                                    ^^ an?

...
> +i2c_client for each child node, an spi bus driver will register
> +it's spi_device children, and similarly for other bus_types.
   ^^ its

> +It turns out that registering children of certain platform_devices as
> +more platform_devices is a common pattern, and the device tree support
> +code reflects that.  The second argument to of_platform_populate() is
> +an of_device_id table, and any node that matches an entry in that
> +table will also get it's child nodes registered.  In the tegra case,
> +the code can look something like this:
> +
> +static struct of_device_id harmony_bus_ids[] __initdata = {
> +	{ .compatible = "simple-bus", },
> +	{}
> +};
> +
> +static void __init harmony_init_machine(void)
> +{
> +	/* ... */
> +	of_platform_populate(NULL, harmony_bus_ids, NULL);
> +}
> +
> +"simple-bus" is defined in the ePAPR 1.0 specification as a property
> +meaning a simple memory mapped bus, so the of_platform_populate() code
> +could be written to just assume simple-bus compatible nodes will
> +always be traversed.  However, we pass it in as an argument so that
> +board support code can always override the default behaviour.

An example for I2C drivers enumerating their I2C child devices might be
educational, so as to push the description of the DT enumeration model
all the way through the entire tree.

...

-- 
nvpublic

