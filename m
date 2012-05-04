Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500Ab2EDTXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:23:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40457 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab2EDTXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:23:47 -0400
Message-ID: <4FA42CBF.8010906@wwwdotorg.org>
Date: Fri, 04 May 2012 13:23:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pinctrl: Add generic pinctrl-simple driver that supports
 omap2+ padconf
References: <20120502172401.GG3739@atomide.com>
In-Reply-To: <20120502172401.GG3739@atomide.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2012 11:24 AM, Tony Lindgren wrote:
> Add simple pinctrl driver using device tree data.
> 
> Currently this driver only works on omap2+ series of
> processors, where there is either an 8 or 16-bit padconf
> register for each pin. Support for other similar pinmux
> controllers could be added.
> 
> Note that this patch does not yet support pinconf_ops
> or GPIO. Further.
> 
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
> Here's this one finally updated to use the common pinctrl bindings.
> That sure cleaned up a bunch of the nasty things in this driver :)
> Nice job Stephen!

Thanks.

> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-simple.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-simple.txt

> +Required properties:
> +- compatible :  one of:
> +	- "pinctrl-simple"
> +	- "ti,omap2420-padconf"
> +	- "ti,omap2430-padconf"
> +	- "ti,omap3-padconf"
> +	- "ti,omap4-padconf"

I'm in two minds about this.

If this is truly intended to be generic, I would not document any of the
ti compatible values here. Instead, I'd create a binding document for
the TI controllers that basically just says "this uses the bindings in
pinctrl-simple.txt, with the following additions", and list the
compatible values as an addition.

On the other hand, I worry about whether using "pinctrl-simple" here as
the compatible value is going to cause issues:

Certainly, this is a pretty simple driver, and most likely reasonably
generic an applicable to many SoCs. However, it doesn't cover a bunch of
cases that I'd still consider "simple". For example, what if each pin
has a separate mux and pinconf register? There are probably many such
small cases that would add up to something more complex. to cover those
cases, will we be able to extend pinctrl-simple to cover them, and
continue to be backwards compatible, or will we need to create a
binding/driver for pinctrl-simple-1, pinctrl-simple-2, pinctrl-simple-3
each of which covers some different, yet still simple, configuration?

To resolve this, perhaps it would be best to rework this binding and
driver as a set of utility code that other bindings and drivers can
build upon, rather than making it a standalone directly usable driver
and binding.

Honestly, I'm not really sure which way to go here.

> +- reg : offset and length of the register set for the mux registers
> +- #pinctrl-cells : width of the pinctrl array, currently only 2 is supported
> +- pinctrl-simple,register-width : pinmux register access width
> +- pinctrl-simple,function-mask : mask of allowed pinmux function bits
> +- pinctrl-simple,function-off : function off mode for disabled state
> +- pinctrl-simple,pinconf-mask : mask of allowed pinconf bits
> +
> +This driver uses the common pinctrl bindings as specified in
> +pinctrl-bindings.txt document in this directory. The common bindings are used
> +to specify the client device states using pinctrl-0 and pinctrl-names entries.

I think just remove the second sentence there; it's implicit given the
first.

> +/* board specific .dts file, such as omap4-sdp.dts */
> +&omap4_pmx_core {
> +
> +	/*
> +	 * map all board specific static pins enabled by the pinctrl driver
> +	 * itself during the boot (or just set them up in the bootloader)
> +	 */
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&board_pins>;
> +
> +	board_pins: pinmux_board_pins {
> +		board_static_pins {

I'd like to see a little more explanation of the node structure here.
I.e. what does each node represent, why are there two levels of nodes, etc.

Given that the "pinctrl-simple,cells" can specify both mux function and
pin configuration for each pin, i.e. everything you need to, I don't see
why you'd ever need two levels of nodes here. I'd expect each "pin
configuration node" (in pinctrl core bindings terminology) to be a
single level:

node {
    pinctrl-simple,cells = <...>;
};

where node is what's references in the pinctrl-0 property by pinctrl
client drivers.

> +			pinctrl-simple,cells = <

"cells" here doesn't seem like the right word. Perhaps "pins" or
"configuration"? "Cell"s to me seems semi-reserved for binding cell
count description, like #gpio-cells, #address-cells, etc.

Also, there's nothing in the free-form text part of this binding
document that says describes the set of properties that need to exist in
these "pin configuration nodes", nor what their content is.

> +				0x6c 0xf	/* CSI21_DX3 OMAP_PIN_OUTPUT | OMAP_MUX_MODE7 */
> +				0x6e 0xf	/* CSI21_DY3 OMAP_PIN_OUTPUT | OMAP_MUX_MODE7 */
> +				0x70 0xf	/* CSI21_DX4 OMAP_PIN_OUTPUT | OMAP_MUX_MODE7 */
> +				0x72 0xf	/* CSI21_DY4 OMAP_PIN_OUTPUT | OMAP_MUX_MODE7 */
> +			>;
> +		};
> +	};
> +
> +
> +	/* map all uart2 pins as a single function */
> +	uart2_pins: pinmux_uart2_pins {
> +		uart2_pins {
> +			pinctrl-simple,cells = <
> +				0xd8 0x118	/* UART2_CTS OMAP_PIN_INPUT_PULLUP | OMAP_MUX_MODE0 */
> +				0xda 0		/* UART2_RTS OMAP_PIN_OUTPUT | OMAP_MUX_MODE0 */
> +				0xdc 0x118	/* UART2_RX OMAP_PIN_INPUT_PULLUP | OMAP_MUX_MODE0 */
> +				0xde 0		/* UART2_TX OMAP_PIN_OUTPUT | OMAP_MUX_MODE0 */
> +			>;
> +		};
> +	};
> +
> +	/* map all uart3 pins as separate functions */
> +	uart3_pins: pinmux_uart3_pins {

>From a binding perspective, I don't see why you'd want to allow two cases:

1) One node with multiple entries in pinctrl-simple,cells
2) Multiple nodes each with a single entry in pinctrl-simple,cells

Why not only allow (1)?

> +		uart3_cts_rctx.uart3_cts_rctx {
> +			pinctrl-simple,cells = <0x100 0x118>;	/* OMAP_PIN_INPUT_PULLUP | OMAP_MUX_MODE0 */
> +             };
> +
> +		uart3_rts_sd.uart3_rts_sd {
> +			pinctrl-simple,cells = <0x102 0>;	/* OMAP_PIN_OUTPUT | OMAP_MUX_MODE0 */
> +		};
> +
> +		uart3_rx_irrx.uart3_rx_irrx {
> +			pinctrl-simple,cells = <0x104 0x100>;	/* OMAP_PIN_INPUT | OMAP_MUX_MODE0 */
> +		};
> +
> +		uart3_tx_irtx.uart3_tx_irtx {
> +			pinctrl-simple,cells = <0x106 0>;	/* OMAP_PIN_OUTPUT | OMAP_MUX_MODE0 */
> +		};
> +	};
> +};

> diff --git a/drivers/pinctrl/pinctrl-simple.c b/drivers/pinctrl/pinctrl-simple.c

> +struct pcs_device {
...
> +	unsigned (*read)(void __iomem *reg);
> +	void (*write)(unsigned val, void __iomem *reg);
> +};

Why not use regmap instead of writing your own:

> +static unsigned __maybe_unused pcs_readb(void __iomem *reg)
> +static unsigned __maybe_unused pcs_readw(void __iomem *reg)
...

regmap recently gained support for memory-mapped IO, so should work for
this. Also, using regmap might allow this binding/driver to be easily
extended to support e.g. I2C-/SPI-based pin controller hardware, since
regmap would handle all the IO details for you.

Supporting these different IO modes might require a little more thought
though. For example, an I2C device's reg refers to its location on the
parent bus, rather than the address of the registers within the device.
We'd probably need to augment parent busses with some method for child
devices to acquire a regmap object for their own IO in order to hide
this from drivers.
