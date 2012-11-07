Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab2KGUFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 15:05:45 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41746 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2KGUFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 15:05:43 -0500
Message-ID: <509ABF12.5080804@wwwdotorg.org>
Date: Wed, 07 Nov 2012 13:05:38 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        dwmw2@infradead.org, artem.bityutskiy@linux.intel.com, hs@denx.de,
        nsekhar@ti.com, mikedunn@newsguy.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        gregkh@linuxfoundation.org, hdoyu@nvidia.com, santosh.shilimkar@ti.com
Subject: Re: [RFC v2 PATCH 1/2] memory: davinci - add aemif controller platform
 driver
References: <1352238427-26085-1-git-send-email-m-karicheri2@ti.com> <1352238427-26085-2-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1352238427-26085-2-git-send-email-m-karicheri2@ti.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 02:47 PM, Murali Karicheri wrote:
> This is a platform driver for asynchronous external memory interface
> available on TI SoCs. This driver was previously located inside the
> mach-davinci folder. As this DaVinci IP is re-used across multiple
> family of devices such as c6x, keystone etc, the driver is moved to drivers.
> The driver configures async bus parameters associated with a particular
> chip select. For DaVinci NAND controller driver and driver for other async
> devices such as NOR flash, ASRAM etc, the bus confuguration is
> done by this driver at probe. A set of APIs (set/get) are provided to
> update the values based on specific driver usage.

> diff --git a/Documentation/devicetree/bindings/memory/davinci-aemif.txt b/Documentation/devicetree/bindings/memory/davinci-aemif.txt

> +* Texas Instruments Davinci AEMIF bus interface
> +
> +This file provides information for the davinci-emif device and
> +async bus bindings.
> +
> +Required properties:=
> +- compatible: "ti,davinci-aemif";
> +- #address-cells : Should be either two or three.  The first cell is the
> +                   chipselect number, and the remaining cells are the
> +                   offset into the chipselect.
> +- #size-cells : Either one or two, depending on how large each chipselect
> +                can be.

What about "how large each chipselect can be" determines 2-vs-3
(address) or 1-vs-2 (size) cells? I assume it's 32-vs-64-bit bus? It
might be best to make that explicit.

> +- reg : contains offset/length value for AEMIF control registers space
> +- ranges : Each range corresponds to a single chipselect, and cover

add "s" at the end of that line.

> +           the entire access window as configured.
> +
> +Child device nodes describe the devices connected to IFC such as NOR (e.g.
> +cfi-flash) and NAND (ti,davinci-nand, see Documentation/devicetree/bindings/
> +mtd/davinci-nand.txt). There might be board specific devices like FPGAs.
> +
> +In addition, optional child sub nodes contains bindings for the async bus
> +interface for a given chip select.

Hmmm. That's two different kinds of children, which appear to use
different addressing schemes given the examples below; more on that below.

> +Optional cs node properties:-
> +- compatible: "ti,davinci-cs"
> +
> +  All of the params below in nanoseconds and are optional
> +
> +- ti,davinci-cs-asize - asynchronous data bus width (0 - 8bit, 1 - 16 bit)

Perhaps s/asize/bus-width/? Also, directly using values 8 and 16 would
be a lot more obvious to read than 0 and 1.

> +- ti,davinci-cs-ta - Minimum turn around time
> +- ti,davinci-cs-rhold - read hold width
> +- ti,davinci-cs-rstobe - read strobe width
> +- ti,davinci-cs-rsetup - read setup width
> +- ti,davinci-cs-whold - write hold width
> +- ti,davinci-cs-wstrobe - write strobe width
> +- ti,davinci-cs-wsetup - write setup width

The comments in the examples indicate these are in nS. This should be
mentioned here instead I think.

Does there need to be a specification of bus clock rate? How does the
driver convert nS into number-of-clock-cycles, which I assume is what
the HW would be programmed with?

> +- ti,davinci-cs-ss - enable/disable select strobe (0 - disable, 1 - enable)
> +- ti,davinci-cs-ew - enable/disable extended wait cycles (0 - disable, 1 - enable)

Boolean properties are usually represented as present (on/enabled/1) or
missing (off/disabled/0). Shouldn't these two properties work that way?
I see the comment below:

> +if any of the above parameters are absent, hardware register default or that
> +set by a boot loader are used.

implied they're really tri-state (explicitly off or on, or just not
programmed). However, I think it'd be better if the DT always
represented the complete configuration, since the DT and binding should
be a full description of the HW rather than just the data you expect a
particular Linux driver to need after a particular boot loader has
executed first.

> +Example for aemif, davinci nand and nor flash chip select shown below.
> +
> +aemif@60000000 {
> +	compatible = "ti,davinci-aemif";
> +	#address-cells = <2>;
> +	#size-cells = <1>;
> +	reg = <0x68000000 0x80000>;
> +	ranges = <2 0 0x60000000 0x02000000
> +		  3 0 0x62000000 0x02000000
> +		  4 0 0x64000000 0x02000000
> +		  5 0 0x66000000 0x02000000
> +		  6 0 0x68000000 0x02000000>;
> +
> +	nand_cs:cs2@60000000 {

This node has no reg property, but it needs one if you use a unit
address ("@60000000") in the node name.

The numbering scheme unit address above doesn't seem to match the
addresses provided to child nodes by the ranges property. Perhaps the
node layout you want is:


aemif {
    chip-selects {
        nand_cs:cs2@60000000 {
        };
    };
    devices {
        nand@3,0 {
        }
    };
};

so that the chip-selects and devices nodes can both set appropriate and
different #address-cells and #size-cells?

That does feel a bit wierd though, and I imagine writing the ranges
property in the aemif node would be hard.

Perhaps the chip-select timings should just be written as properties in
the aemif controller, rather than child nodes?

ti,cs-timings =
    < ... > /* 0 */
    < ... > /* 1 */
    < ... > /* 2 */
    ;

with each <...> being a list of n cells in a specific order?

> +		compatible = "ti,davinci-cs";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		/* all timings in nanoseconds */
> +		ti,davinci-cs-ta = <0>;
> +		ti,davinci-cs-rhold = <7>;
> +		ti,davinci-cs-rstrobe = <42>;
> +		ti,davinci-cs-rsetup = <14>;
> +		ti,davinci-cs-whold = <7>;
> +		ti,davinci-cs-wstrobe = <42>;
> +		ti,davinci-cs-wsetup = <14>;
> +	};
...
> +	nand@3,0 {
> +		compatible = "ti,davinci-nand";
> +		reg = <3 0x0 0x807ff
> +			6 0x0 0x8000>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +
> +		.. See Documentation/devicetree/bindings/mtd/davinci-nand.txt
> +	};


