Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760769Ab2EIUQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:16:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59521 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759743Ab2EIUQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:16:17 -0400
Message-ID: <4FAAD08D.1050806@wwwdotorg.org>
Date: Wed, 09 May 2012 14:16:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pinctrl: Add generic pinctrl-simple driver that supports
 omap2+ padconf
References: <20120502172401.GG3739@atomide.com> <4FA42CBF.8010906@wwwdotorg.org> <20120504215758.GV5613@atomide.com>
In-Reply-To: <20120504215758.GV5613@atomide.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 03:57 PM, Tony Lindgren wrote:
> * Stephen Warren <swarren@wwwdotorg.org> [120504 12:27]:
>> On 05/02/2012 11:24 AM, Tony Lindgren wrote:
>>
>>> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-simple.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-simple.txt
...
>> On the other hand, I worry about whether using "pinctrl-simple" here as
>> the compatible value is going to cause issues:
>>
>> Certainly, this is a pretty simple driver, and most likely reasonably
>> generic an applicable to many SoCs. However, it doesn't cover a bunch of
>> cases that I'd still consider "simple". For example, what if each pin
>> has a separate mux and pinconf register? There are probably many such
>> small cases that would add up to something more complex. to cover those
>> cases, will we be able to extend pinctrl-simple to cover them, and
>> continue to be backwards compatible, or will we need to create a
>> binding/driver for pinctrl-simple-1, pinctrl-simple-2, pinctrl-simple-3
>> each of which covers some different, yet still simple, configuration?
> 
> Yes getting the binding right is the critical part here, everything else
> can be added as needed. I was thinking about using separate properties
> for auxilary registers, but now thinking about it a bit more, it may not
> be sufficient.
> 
> How about we make some of these properties into arrays? For example:
> 
> #pinctrl-cells = 6;
> pinctrl-simple,function-mask = <0x0000ffff 0x0000ffff 0xffff0000>;
> pinctrl-simple,function-off = <0x7 0x7 0x70000>;
> pinctrl-simple,pinconf-mask = <0xffff0000 0xffff0000 0x0000ffff>;

I'm not sure what the 3 entries in the array are meant to describe?

> Then for handling the set/clear bits case of registers, we could do that
> automatically if both masks are 0 for some registers. We actually have
> that for some omap1 where there are three registers per mux with bits
> to set or clear. And these bits are not the same across all registers..

>>> +				0x6c 0xf	/* CSI21_DX3 OMAP_PIN_OUTPUT | OMAP_MUX_MODE7 */
>>> +				0x6e 0xf	/* CSI21_DY3 OMAP_PIN_OUTPUT | OMAP_MUX_MODE7 */
>>> +				0x70 0xf	/* CSI21_DX4 OMAP_PIN_OUTPUT | OMAP_MUX_MODE7 */
>>> +				0x72 0xf	/* CSI21_DY4 OMAP_PIN_OUTPUT | OMAP_MUX_MODE7 */
>>> +			>;
>>> +		};
>>> +	};
>>> +
>>> +
>>> +	/* map all uart2 pins as a single function */
>>> +	uart2_pins: pinmux_uart2_pins {
>>> +		uart2_pins {
>>> +			pinctrl-simple,cells = <
>>> +				0xd8 0x118	/* UART2_CTS OMAP_PIN_INPUT_PULLUP | OMAP_MUX_MODE0 */
>>> +				0xda 0		/* UART2_RTS OMAP_PIN_OUTPUT | OMAP_MUX_MODE0 */
>>> +				0xdc 0x118	/* UART2_RX OMAP_PIN_INPUT_PULLUP | OMAP_MUX_MODE0 */
>>> +				0xde 0		/* UART2_TX OMAP_PIN_OUTPUT | OMAP_MUX_MODE0 */
>>> +			>;
>>> +		};
>>> +	};
>>> +
>>> +	/* map all uart3 pins as separate functions */
>>> +	uart3_pins: pinmux_uart3_pins {
>>
>> From a binding perspective, I don't see why you'd want to allow two cases:
>>
>> 1) One node with multiple entries in pinctrl-simple,cells
>> 2) Multiple nodes each with a single entry in pinctrl-simple,cells
>>
>> Why not only allow (1)?
> 
> Because we need to specify GPIO for some pins. There may be additional flags

What do you mean by "specify GPIO"?

Nothing in this pinctrl-simple binding seems to imply that it's also a
GPIO controller.

If "GPIO" is one of the functions that can be mux'd onto a pin, then I'd
expect that to be represented in exactly the same way as any other
function that could be mux'd onto the pin.

So, I'm not sure what GPIO-related information you want to represent.

> too, we do have external DMA request lines for few pins available.. I'm not
> saying pinctrl fwk should know about that, but it's a similar mapping of pins
> to GPIO lines.

Aren't DMA request lines also just another function that can be mux'd
onto a pin?
