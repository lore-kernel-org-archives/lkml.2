Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab2AQW7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 17:59:39 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59486 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab2AQW7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 17:59:38 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17801D2363@HQMAIL01.nvidia.com>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
 <1323727329-4989-7-git-send-email-grant.likely@secretlab.ca> <74CDBE0F657A3D45AFBB94109FB122FF17801D2363@HQMAIL01.nvidia.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 17 Jan 2012 15:59:17 -0700
X-Google-Sender-Auth: LLvUXTb3GFsnmRxJuL_GFumcyxE
Message-ID: <CACxGe6skBjDEKwnmYqCFJURBg79CRc=0maSAshUeUf78GLTczA@mail.gmail.com>
Subject: Re: [RFC v2 7/9] arm/dt: Common plat-versatile support for icst and
 sp804 based system clocks
To: Stephen Warren <swarren@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Mike Turquette <mturquette@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 2:05 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Grant Likely wrote at Monday, December 12, 2011 3:02 PM:
> ...
>> diff --git a/arch/arm/plat-versatile/clock.c b/arch/arm/plat-versatile/clock.c
> ...
>> +void __init versatile_dt_icst_clk_setup(struct device_node *np)
>> +{
>> +     const struct of_device_id *match;
>> +     struct icst_of_clk *icst;
>> +     const struct icst_params *params;
>> +     u32 ref, vd_range[2], rd_range[2], vco_offset, lock_offset;
>> +     __iomem void * base;
>> +
>> +     /*
>> +      * Only try to drive clocks that we know how to control.
>> +      * ie. attached to an ARM Versatile block of system registers
>> +      */
>> +     if (!of_device_is_compatible(np->parent, "arm,versatile-sys-regs"))
>> +             return;
> ...
>> +     base = of_iomap(np->parent, 0);
>
> Is this pattern (that of "re-using" a parent node's registers) something
> legitimate that you'd expect to see wide-spread use?

Yes, it is completely legitimate.  In this particular case, the
binding must specifically state that the child node uses the parent
node's reg region, and that would place strict limits on where this
binding can be used.

> I ask because Tegra's CAR (Clock And Reset) HW module controls all the
> clocks in the system. The registers for the various clocks are often
> inter-mingled, so it's not possible to give each clock a node with a
> reg property, since they'd all overlap and conflict. Instead, should we
> do something like the following, coupled with the above pattern in the
> per-clock drivers:
>
> car@60006000 {
>    compatible = "nvidia,tegra20-car";
>    reg = < 0x60006000 0x1000 >;
>
>    osc@0 {
>        compatible = "nvidia,tegra20-clk-osc";
>    };
>    pll_p@1 {
>        compatible = "nvidia,tegra20-clk-pll";
>        pll_id = <0>;
>    };
>    pll_c@2 {
>        compatible = "nvidia,tegra20-clk-pll";
>        pll_id = <1>;
>    };
>    ...
> };

Sure, that's fine.

>
> Similar, we have many "peripheral" clocks; leaf nodes that are the clocks
> for UART, I2C, SPI, ... that are all controlled in a very similar fashion.
> I can see a couple of alternative ways of representing this:
>
> a)
>
> One big node with a ton of clock inputs and outputs:
>
>    periphclk {
>        compatible = "nvidia,tegra20-clk-periphs";
>        #clock-cells = <1>;
>        /*
>         * This ends up listing almost all clocks in the system;
>         * most are usable as a source for /some/ peripheral clock
>         */
>        clocks = <&pll_p 0> <&pll_c 0> <&pll_m 0 ...>;
>        clock-names = "pll_p", "pll_c", "pll_m", ...;
>        /* And there are maybe 50 of these */
>        clock-output-names = "uart1", "uart2", "i2c1", "i2c2", "spi1", ...;
>    };
>
> Simon Glass proposed something similar to this on the U-Boot mailing
> list for Tegra's peripheral clocks (since he's working on upstreaming
> Tegra USB support and adding device tree at the same time, and needs
> to parameterize clock IDs in the device tree, since he's not using
> AUXDATA). I'm worried that the huge number of peripheral clocks in the
> above binding would be unwieldy.

You've got a lot of latitude here.  This is fine, and I think for a
lot of cases, particularly if there is a kind of 'clock nexus' in an
soc, that it is an excellent option.  You can also have one node per
clock, or you can do something in between where clocks get logically
grouped together based on the system design.  It is also true that
there is no need to expose every soc clock in the dts.  Only the leaf
clocks provided to devices need to appear.  Internal intermediary
clocks can, and probably should, be hidden from the devices.

> I'm also unclear how to know which of
> the "clock-names" is the parent for each of the "clock-output-names",
> or if this isn't something the current clock bindings are supports to
> address. Each peripclk is an independent mux, divider, and gate.

The common binding doesn't say anything about this.  It is entirely up
to the specific clock device binding to specify how consumed clocks
map to produced clocks.

>
> b)
>
> A node for each peripheral clock:
>
>    uart1@0 {
>        compatible = "nvidia,tegra20-clk-uart";
>        clocks = <&pll_p 0>;
>        clock-names = "clk";
>    };
>
>    uart2@1 {
>        compatible = "nvidia,tegra20-clk-uart";
>        clocks = <&pll_p 0>;
>        clock-names = "clk";
>    };
>
>    i2s@2 {
>        compatible = "nvidia,tegra20-clk-i2s";
>        clocks = <&audio_clk 0>;
>        clock-names = "clk";
>    };
>
> etc.

My primary worry here is that it will result in an unwieldy number of
nodes in a hurry.

g.
