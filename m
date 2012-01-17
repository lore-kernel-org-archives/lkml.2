Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab2AQWC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 17:02:26 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38273 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2AQWCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 17:02:25 -0500
Message-ID: <4F15EFEC.1000907@gmail.com>
Date: Tue, 17 Jan 2012 16:02:20 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC v2 7/9] arm/dt: Common plat-versatile support for icst and
 sp804 based system clocks
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca> <1323727329-4989-7-git-send-email-grant.likely@secretlab.ca> <74CDBE0F657A3D45AFBB94109FB122FF17801D2363@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17801D2363@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 03:05 PM, Stephen Warren wrote:
> Grant Likely wrote at Monday, December 12, 2011 3:02 PM:
> ...
>> diff --git a/arch/arm/plat-versatile/clock.c b/arch/arm/plat-versatile/clock.c
> ...
>> +void __init versatile_dt_icst_clk_setup(struct device_node *np)
>> +{
>> +	const struct of_device_id *match;
>> +	struct icst_of_clk *icst;
>> +	const struct icst_params *params;
>> +	u32 ref, vd_range[2], rd_range[2], vco_offset, lock_offset;
>> +	__iomem void * base;
>> +
>> +	/*
>> +	 * Only try to drive clocks that we know how to control.
>> +	 * ie. attached to an ARM Versatile block of system registers
>> +	 */
>> +	if (!of_device_is_compatible(np->parent, "arm,versatile-sys-regs"))
>> +		return;
> ...
>> +	base = of_iomap(np->parent, 0);
> 
> Is this pattern (that of "re-using" a parent node's registers) something
> legitimate that you'd expect to see wide-spread use?
> 

I don't think there is any clear direction for this. Probably doesn't
matter too much because it is typically things closely tied to a
particular SOC. If there's a whole bunch of random bits, it's not likely
to be reused on another SOC. If you can put registers into separate
nodes which are distinct functions even if you have multiple nodes
within a 4KB page you should.

> I ask because Tegra's CAR (Clock And Reset) HW module controls all the
> clocks in the system. The registers for the various clocks are often
> inter-mingled, so it's not possible to give each clock a node with a
> reg property, since they'd all overlap and conflict. Instead, should we
> do something like the following, coupled with the above pattern in the
> per-clock drivers:
> 
> car@60006000 {
>     compatible = "nvidia,tegra20-car";
>     reg = < 0x60006000 0x1000 >;
> 
>     osc@0 {
>         compatible = "nvidia,tegra20-clk-osc";
>     };
>     pll_p@1 {
>         compatible = "nvidia,tegra20-clk-pll";
>         pll_id = <0>;
>     };
>     pll_c@2 {
>         compatible = "nvidia,tegra20-clk-pll";
>         pll_id = <1>;
>     };
>     ...
> };

This is roughly how I'm doing clocks as a sub-node of the clock module.

> 
> Similar, we have many "peripheral" clocks; leaf nodes that are the clocks
> for UART, I2C, SPI, ... that are all controlled in a very similar fashion.
> I can see a couple of alternative ways of representing this:
> 
> a)
> 
> One big node with a ton of clock inputs and outputs:
> 
>     periphclk {
>         compatible = "nvidia,tegra20-clk-periphs";
>         #clock-cells = <1>;
>         /*
>          * This ends up listing almost all clocks in the system;
>          * most are usable as a source for /some/ peripheral clock
>          */
>         clocks = <&pll_p 0> <&pll_c 0> <&pll_m 0 ...>;
>         clock-names = "pll_p", "pll_c", "pll_m", ...;
>         /* And there are maybe 50 of these */
>         clock-output-names = "uart1", "uart2", "i2c1", "i2c2", "spi1", ...;
>     };
> 
> Simon Glass proposed something similar to this on the U-Boot mailing
> list for Tegra's peripheral clocks (since he's working on upstreaming
> Tegra USB support and adding device tree at the same time, and needs
> to parameterize clock IDs in the device tree, since he's not using
> AUXDATA). I'm worried that the huge number of peripheral clocks in the
> above binding would be unwieldy. I'm also unclear how to know which of
> the "clock-names" is the parent for each of the "clock-output-names",
> or if this isn't something the current clock bindings are supports to
> address. Each peripclk is an independent mux, divider, and gate.
> 

Both *-names properties are completely optional. Matching is typically
done by node and phandles rather than name strings. But without names it
is harder to know which clock a number in the cell is referring to as
clocks typically aren't documented that way as opposed to interrupts.

> b)
> 
> A node for each peripheral clock:
> 
>     uart1@0 {
>         compatible = "nvidia,tegra20-clk-uart";
>         clocks = <&pll_p 0>;
>         clock-names = "clk";
>     };
> 
>     uart2@1 {
>         compatible = "nvidia,tegra20-clk-uart";
>         clocks = <&pll_p 0>;
>         clock-names = "clk";
>     };
> 
>     i2s@2 {
>         compatible = "nvidia,tegra20-clk-i2s";
>         clocks = <&audio_clk 0>;
>         clock-names = "clk";
>     };
> 
> etc.
> 
> Thanks for cluing me in!

Either way is fine. I think the former is probably better if there are a
huge number of clocks.

Rob

