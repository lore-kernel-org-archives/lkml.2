Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab2FUWNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:13:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50495 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab2FUWNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:13:31 -0400
Message-ID: <4FE39C86.5070901@wwwdotorg.org>
Date: Thu, 21 Jun 2012 16:13:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] pinctrl: Add one-register-per-pin type device tree based
 pinctrl driver
References: <20120611135826.GB12766@atomide.com> <4FDA6FCD.1020605@wwwdotorg.org> <20120615094938.GQ12766@atomide.com> <4FDB6000.5080703@wwwdotorg.org> <20120618055036.GU12766@atomide.com> <20120619135600.GX12766@atomide.com>
In-Reply-To: <20120619135600.GX12766@atomide.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 07:56 AM, Tony Lindgren wrote:
> Hi,
> 
> Below is the pinctrl-single patch updated with hopefully all the Stephen's
> comments addressed. The binding still needs to be looked at, see relevant
> parts of the discussion below.
...
> From: Tony Lindgren <tony@atomide.com>
> Date: Wed, 6 Jun 2012 04:18:18 -0700
> Subject: [PATCH] pinctrl: Add one-register-per-pin type device tree based pinctrl driver
> 
> Add one-register-per-pin type device tree based pinctrl driver.
> 
> Currently this driver only works on omap2+ series of processors,
> where there is either an 8 or 16-bit padconf register for each pin.
> Support for other similar pinmux controllers can be added.
> 
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
> new file mode 100644
> index 0000000..929254c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
> @@ -0,0 +1,106 @@
> +One-register-per-pin type device tree based pinctrl driver
> +
> +Required properties:
> +- compatible : "pinctrl-single"
> +
> +- reg : offset and length of the register set for the mux registers
> +
> +- pinctrl-single,register-width : pinmux register access width in bits
> +
> +- pinctrl-single,function-mask : mask of allowed pinmux function bits
> +  in the pinmux register
> +
> +- pinctrl-single,pinconf-mask : mask of allowed pinconf bits in the
> +  pinmux register; this gets combined with pinconf mask but is a separate
> +  mask to allow the option of setting pinconf separatately from the
> +  function

Given that this binding doesn't allow describing pin configuration at
present, I would simply remove all mention of that property in the
binding documentation. It can be added back if/when that feature is
added. Any future driver using this binding can refuse to allow pin
configuration if that property is missing.

> +- pinctrl-single,function-off : function off mode for disabled state if
> +  available and same for all registers; if not, use a value larger than
> +  function-mask to ignore disabling of registers

Rather than requiring an invalid value in this property, shouldn't the
lack of a valid function-off value be represented by the property not
being present in the DT?

> +This driver assumes that there is only one register for each pin,
> +and uses the common pinctrl bindings as specified in the pinctrl-bindings.txt
> +document in this directory.

At this point in the file, I think you need to mention that you're
switching from describing the top-level device node to describing pin
configuration nodes.

> +The pinctrl register offsets and default values are specified as pairs

I thought we were going to remove "default" here?

> +using pinctrl-single,pins. For example, setting a pin for a device
> +could be done with:
> +
> +	pinctrl-single,pins = <0xdc 0x118>;
> +
> +Where 0xdc is the offset from the pinctrl register base address for the
> +device pinctrl register, and 0x118 contains the desired value of the
> +pinctrl register. See the device example and static board pins example
> +below for more information.

There should be some explanation only the portion of this value covered
by the pinctrl-single,function-mask value is updated in the register.

> +This driver tries to avoid understanding pin and function names because of
> +the extra bloat they would cause especially in the case of a large number
> +of pins. This driver just sets what is specified for the board in the .dts file.
> +Further user space debugging tools can be developed to decipher the pin and
> +function names using debugfs.

There shouldn't be any discussion of a driver here; the binding is a HW
description.

> +Example:

I only reviewed the binding document, not the code.
