Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab1J1QNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 12:13:47 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7452 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1J1QNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 12:13:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 28 Oct 2011 09:13:30 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Chanho Park <chanho61.park@samsung.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "Barry.Song@csr.com" <Barry.Song@csr.com>,
        "Rongjun.Ying@csr.com" <Rongjun.Ying@csr.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Fri, 28 Oct 2011 09:13:28 -0700
Subject: RE: [PATCHv2] drivers: pinctrl: add a pin_base for sparse
 gpio-ranges
Thread-Topic: [PATCHv2] drivers: pinctrl: add a pin_base for sparse
 gpio-ranges
Thread-Index: AcyVNFBDOoY5pCHKTR66b0hPKmt/PQAVSm+A
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173EDAB4A3@HQMAIL01.nvidia.com>
References: <1319780504-23816-1-git-send-email-chanho61.park@samsung.com>
In-Reply-To: <1319780504-23816-1-git-send-email-chanho61.park@samsung.com>
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

Chanho Park wrote at Thursday, October 27, 2011 11:42 PM:
> This patch enables mapping a base offset of gpio ranges with
> a pin offset even if does'nt matched. A "base" of pinctrl_gpio_range
> means a start offset of gpio. However, we cannot convert gpio to pin
> number for sparse gpio ranges just only using a gpio base offset.
> We can convert a gpio to real pin number using a new pin_base
> (which means a base pin offset of requested gpio range).
> If the pin_base is not specified explicitly, the controller sybsystem
> makes to equal with gpio's base offset. Now, a pinctrl subsystem passes
> the pin number to the driver instead a offset.

...
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
...
> -For example: if a user issues pinctrl_gpio_set_foo(50), the pin control
> -subsystem will find that the second range on this pin controller matches,
> -subtract the base 48 and call the
> -pinctrl_driver_gpio_set_foo(pinctrl, range, 2) where the latter function has
> -this signature:
> -
> -int pinctrl_driver_gpio_set_foo(struct pinctrl_dev *pctldev,
> -    struct pinctrl_gpio_range *rangeid,
> -    unsigned offset);
> -
> -Now the driver knows that we want to do some GPIO-specific operation on the
> -second GPIO range handled by "chip b", at offset 2 in that specific range.
> -
> -(If the GPIO subsystem is ever refactored to use a local per-GPIO controller
> -pin space, this mapping will need to be augmented accordingly.)
> -
> -

struct pinmux_ops.gpio_request_enable's documentation states that:

 * @gpio_request_enable: requests and enables GPIO on a certain pin.
 *      Implement this only if you can mux every pin individually as GPIO. The
 *      affected GPIO range is passed along with an offset into that
 *      specific GPIO range - function selectors and pin groups are orthogonal
 *      to this, the core will however make sure the pins do not collide

You'll need to update that documentation now that the final parameter is
a pin number, not an offset into the range.

That said, I wonder why there's a need to change this function's parameters;
you could modify pin_request() to perform the calculation, and then not
need to change any of the drivers:

-	if (gpio_range && ops->gpio_request_enable)
-		/* This requests and enables a single GPIO pin */
-		status = ops->gpio_request_enable(pctldev, gpio_range, pin);
+	if (gpio_range && ops->gpio_request_enable)
+		/* This requests and enables a single GPIO pin */
+		status = ops->gpio_request_enable(pctldev, gpio_range,
+								pin - range->pin_base);

...
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index a13354e..4d9fc44 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -261,11 +261,15 @@ int pinctrl_get_device_gpio_range(unsigned gpio,
>   *
>   * This adds a range of GPIOs to be handled by a certain pin controller. Call
>   * this to register handled ranges after registering your pin controller.
> + * If a pin_base offset is not specified explicitly,
> + * it is equal to a gpio base offset.
>   */
>  void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
>  			    struct pinctrl_gpio_range *range)
>  {
>  	mutex_lock(&pctldev->gpio_ranges_lock);
> +	if (!range->pin_base)
> +		range->pin_base = range->base;

This doesn't seem right; what if we really want a range with a pin_base
of zero, yet a non-zero "base". I think we'd be better off just requiring
all GPIO ranges to specify both values.

-- 
nvpublic

