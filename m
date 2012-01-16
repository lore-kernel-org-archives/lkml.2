Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab2APS2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:28:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48569 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab2APS2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:28:14 -0500
Date: Mon, 16 Jan 2012 11:28:08 -0700
From: Grant Likely <grant.likely@secretlab.ca>
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
Message-ID: <20120116182808.GG4223@ponder.secretlab.ca>
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
>                         <"default" &pmx_sdhci_active>
>                         <"suspend" &pmx_sdhci_suspend>;
> 
>                 /* 1:n example: */
>                 pinmux =
>                         <"default" &pmx_sdhci_mux_a>
>                         <"default" &pmx_sdhci_pincfg_a>
>                         <"suspend" &pmx_sdhci_mux_a>
>                         <"suspend" &pmx_sdhci_pincfg_a_suspend>;


Yeah, don't do this.  Mixing phandle, string and cell values in a
property gets messy and could become troublesome to parse.  I've
backed away from it in the clk binding.

pinumx-* is better, but I'm not thrilled with it and I avoided that
pattern too for the latest iteration of the clk binding.  I prefer
using a "pinmux" + "pinmux-names" pair of properties when dealing with
an array of like objects (ie. reg, interrupts, clks, etc), but that
might not fit well since each setting has multiple state nodes.

> 
>                 /*
>                  * Alternative: One property for each required state. But,
>                  * how does pinctrl core know which properties to parse?
>                  * Every property named "pinctrl*" seems a little too far-
>                  * reaching. Perhaps if we used vendor-name "pinmux", that'd
>                  * be OK, i.e. pinmux,default and pinmux,suspend?

It isn't actually a vendor name, so don't use a ','.  "pinmux-" prefix
is fine.

g.
