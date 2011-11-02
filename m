Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1KBI5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 04:57:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20701 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab1KBI5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 04:57:04 -0400
X-AuditID: cbfee61b-b7b7fae000005864-97-4eb105de3035
From: Chanho Park <chanho61.park@samsung.com>
To: "'Stephen Warren'" <swarren@nvidia.com>, linus.walleij@linaro.org,
        Barry.Song@csr.com, Rongjun.Ying@csr.com
Cc: linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
References: <1319780504-23816-1-git-send-email-chanho61.park@samsung.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173EDAB4A3@HQMAIL01.nvidia.com>
In-reply-to: <74CDBE0F657A3D45AFBB94109FB122FF173EDAB4A3@HQMAIL01.nvidia.com>
Subject: RE: [PATCHv2] drivers: pinctrl: add a pin_base for sparse gpio-ranges
Date: Wed, 02 Nov 2011 17:56:23 +0900
Message-id: <02cf01cc993d$4c484040$e4d8c0c0$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyVNFBDOoY5pCHKTR66b0hPKmt/PQAVSm+AAOymfuA=
Content-language: ko
X-OriginalArrivalTime: 02 Nov 2011 08:56:49.0067 (UTC)
 FILETIME=[5B4C17B0:01CC993D]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Stephen Warren
> Sent: Saturday, October 29, 2011 1:13 AM
> To: Chanho Park; linus.walleij@linaro.org; Barry.Song@csr.com;
> Rongjun.Ying@csr.com
> Cc: linux-kernel@vger.kernel.org; Kyungmin Park
> Subject: RE: [PATCHv2] drivers: pinctrl: add a pin_base for sparse gpio-
> ranges
> 
> Chanho Park wrote at Thursday, October 27, 2011 11:42 PM:
> > This patch enables mapping a base offset of gpio ranges with
> > a pin offset even if does'nt matched. A "base" of pinctrl_gpio_range
> > means a start offset of gpio. However, we cannot convert gpio to pin
> > number for sparse gpio ranges just only using a gpio base offset.
> > We can convert a gpio to real pin number using a new pin_base
> > (which means a base pin offset of requested gpio range).
> > If the pin_base is not specified explicitly, the controller sybsystem
> > makes to equal with gpio's base offset. Now, a pinctrl subsystem passes
> > the pin number to the driver instead a offset.
> 
> ...
> > diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> ...
> > -For example: if a user issues pinctrl_gpio_set_foo(50), the pin control
> > -subsystem will find that the second range on this pin controller
> matches,
> > -subtract the base 48 and call the
> > -pinctrl_driver_gpio_set_foo(pinctrl, range, 2) where the latter
> function has
> > -this signature:
> > -
> > -int pinctrl_driver_gpio_set_foo(struct pinctrl_dev *pctldev,
> > -    struct pinctrl_gpio_range *rangeid,
> > -    unsigned offset);
> > -
> > -Now the driver knows that we want to do some GPIO-specific operation on
> the
> > -second GPIO range handled by "chip b", at offset 2 in that specific
> range.
> > -
> > -(If the GPIO subsystem is ever refactored to use a local per-GPIO
> controller
> > -pin space, this mapping will need to be augmented accordingly.)
> > -
> > -
> 
> struct pinmux_ops.gpio_request_enable's documentation states that:
> 
>  * @gpio_request_enable: requests and enables GPIO on a certain pin.
>  *      Implement this only if you can mux every pin individually as GPIO.
> The
>  *      affected GPIO range is passed along with an offset into that
>  *      specific GPIO range - function selectors and pin groups are
> orthogonal
>  *      to this, the core will however make sure the pins do not collide
> 
> You'll need to update that documentation now that the final parameter is
> a pin number, not an offset into the range.

I'll update it. Thx.

> 
> That said, I wonder why there's a need to change this function's
> parameters;
> you could modify pin_request() to perform the calculation, and then not
> need to change any of the drivers:
> 
> -	if (gpio_range && ops->gpio_request_enable)
> -		/* This requests and enables a single GPIO pin */
> -		status = ops->gpio_request_enable(pctldev, gpio_range, pin);
> +	if (gpio_range && ops->gpio_request_enable)
> +		/* This requests and enables a single GPIO pin */
> +		status = ops->gpio_request_enable(pctldev, gpio_range,
> +								pin - range-
> >pin_base);

A ops->request function requires "pin" number instead "offset".
I saw the pinmux core driver uses "pin" number all over the place
except the gpio_request_enable.
I think we use "pin" number instead "offset" for consistency.

> 
> ...
> > diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> > index a13354e..4d9fc44 100644
> > --- a/drivers/pinctrl/core.c
> > +++ b/drivers/pinctrl/core.c
> > @@ -261,11 +261,15 @@ int pinctrl_get_device_gpio_range(unsigned gpio,
> >   *
> >   * This adds a range of GPIOs to be handled by a certain pin
controller.
> Call
> >   * this to register handled ranges after registering your pin
> controller.
> > + * If a pin_base offset is not specified explicitly,
> > + * it is equal to a gpio base offset.
> >   */
> >  void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
> >  			    struct pinctrl_gpio_range *range)
> >  {
> >  	mutex_lock(&pctldev->gpio_ranges_lock);
> > +	if (!range->pin_base)
> > +		range->pin_base = range->base;
> 
> This doesn't seem right; what if we really want a range with a pin_base
> of zero, yet a non-zero "base". I think we'd be better off just requiring
> all GPIO ranges to specify both values.

Oh, I was wrong. I'll remove and assign it explicitly.
Thank you for your review :)

> 
> --
> nvpublic
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

