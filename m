Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab1FPPHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:07:11 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56981 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab1FPPHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:07:08 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04992C067D@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF04992C067D@HQMAIL01.nvidia.com>
Date: Thu, 16 Jun 2011 17:07:06 +0200
Message-ID: <BANLkTi==jWGxbiW4QZ7SSfAdyShhEgvMig@mail.gmail.com>
Subject: Re: More pinmux feedback, and GPIO vs. pinmux interaction
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 11:48 PM, Stephen Warren <swarren@nvidia.com> wrote:

> Some more thoughts on pinmux:

Thanks!

Keep it coming until you get tired of me :-)

> ========== GPIO/pinmux API interactions
>
> I'd like to understand how the gpio and pinmux subsystems are intended
> to interact.

Mainly I'd like Grant to comment on that a bit. It refers to the (long)
reply I wrote in response to his feeback on these issues with some
open questions in it.

>  Note that requesting a GPIO does NOT cause it to be configured in any
>  way; it just marks that GPIO as in use.  Separate code must handle any
>  pin setup (e.g. controlling which pin the GPIO uses, pullup/pulldown).
>
> Due to this, the current Tegra GPIO driver contains additional non-
> standard functions:
>
> void tegra_gpio_enable(int gpio);
> void tegra_gpio_disable(int gpio);
>
> In some cases, those functions are called by board files at boot time,
> and in other cases by drivers themselves, right before gpio_request().
>
> Is it your intention that such custom functions be replaced by
> pinmux_request_gpio(), and the Tegra pinmux driver's gpio_request_enable
> op should call tegra_gpio_enable?
>
> That seems like the right idea to me.

Yes and no. As you saw in the last iteration I renamed the pinmux
framework "pinctrl" or "pin control". So being such a hopless optimist
I set out to solve all pin controlling in this subsystem. The sales rap
would be something like:

- Do you need to bias your pin to 3.3 V with an 1MOhm resistor?
- Do you want to mux your pin with differetn functions?
- Do you want to set the load capacitance of you pin to 10pF?
- Do you want to drive your pin as open collector?
- Is all or some the above software-controlled in your ASIC?
- Do you despair from the absence of relevant frameworks?

DON'T WORRY!
The pinctrl subsystem is here to save YOU!

However that's a bit of vaporware, since I just implemented the
pin numberspace and pin registration (that is the generic part)
and then the pinmux part. The rest (assorted pin control) is
yet to come.

> ========== pinmux calling GPIO or vice-versa?
>
> Having pinmux call gpio appears to conflict with a couple of things from
> your recent pinmux patchset:
>
>> diff --git a/drivers/Kconfig b/drivers/Kconfig
>> +# pinctrl before gpio - gpio drivers may need it
>> +
>> +source "drivers/pinctrl/Kconfig"
>> +
>>  source "drivers/gpio/Kconfig"
>>
>> diff --git a/drivers/Makefile b/drivers/Makefile
>>...
>> +# GPIO must come after pinctrl as gpios may need to mux pins etc
>> +obj-y                                += pinctrl/
>
> Don't those patches imply that the GPIO controller code is calling into
> the pinmux code to perform muxing, not the other way around?

Yes.

Grant does not seem to like the idea of the gpio subsystem
meddeling with all this stuff anyway, so I intend to take all that
into pinctrl, and then gpio only deal with, well GPIO. Setting
bits quickly and such.

That is, irrespective of the fact that these functions may live
in the same register range, this is a divide between functionality
not hardware blocks.

> ========== When pins get marked as in-used
>
> There seems to be a discrepancy in the way the client APIs work: For
> special functions, the client calls pinmux_get, then later pinmux_enable,
> whereas for GPIOs, the client just calls pinmux_request_gpio. I'm not
> sure of the benefit of having separate pinmux_get and pinmux_enable
> calls; I thought the idea was that a client could:
>
> a = pinmux_get(dev, "funca");
> b = pinmux_get(dev, "funcb");
> pinmux_enable(a);
> ...
> pinmux_disable(a);
> pinmux_enable(b);
> ...
> pinmux_disable(b);
> pinmux_put(b);
> pinmux_put(a);
>
> However, since the pins are marked as reserved/in-use when pinmux_get
> is called rather than pinmux_enable, the code above won't work;

If the two functions share the same pins so they are mutually exclusive,
then yes.

> it'd need to be:
>
> a = pinmux_get(dev, "funca");
> pinmux_enable(a);
> ...
> pinmux_disable(a);
> pinmux_put(a);
> b = pinmux_get(dev, "funcb");
> pinmux_enable(b);
> ...
> pinmux_disable(b);
> pinmux_put(b);
>
> Perhaps pin usage marking should be moved into enable/disable?

Actually no - my idea is that enable/disable shall be fast while
get/put will be allowed to take time. (fastpath vs slowpath if
you like).

The rationale was described I think in the first patch set, that
switching pinmuxes tied to a device will be rare, whereas
enabling/disabling will be common. So get/put will do the
slow lookup of descriptors etc, whereas enable/disable will
typically involve poking some hardware register so it will be fast.

For example enabling/disabling on many systems need to be
done as part of idling the hardware, and thus it should be
fast since you may need to turn it back on quickly.

> ========== Matched request/free calls for GPIOs
>
> A couple more comments on your recent pinmux patches in light of this:
>
> From pin_request():
>
> +       /*
> +        * If there is no kind of request function for the pin we just assume
> +        * we got it by default and proceed.
> +        */
> +       if (gpio && ops->gpio_request_enable)
> +               /* This requests and enables a single GPIO pin */
> +               status = ops->gpio_request_enable(pmxdev,
> +                                                 pin - pmxdev->desc->base);
> +       else if (ops->request)
> +               status = ops->request(pmxdev,
> +                                     pin - pmxdev->desc->base);
> +       else
> +               status = 0;
>
> a) I feel the default should be to error out, not succeed; the whole
> point of the API is for HW where something must be programmed to enable
> each function. As such, if you don't provide that ops->request* function,
> that seems like an error.

This is designed for the case where the driver avoids to define either
a gpio_request_enable() or a single pin request() callback.

The request() is entirely optional but intended to handle the case
where hardware puts additional restrictons on muxing apart from
pin ovelap (which is already handled by the core). For chips that
do not have any such hardware restrictions you don't implement the
callback and then it succeeds, as there is no restriction.

The issue of HW restrictions on muxing was raised by Grant
only yesterday I think, it's a universal phenomenon, some have
it some don't.

The kerneldoc for request() right now looks like this:

 * @request: called by the core to see if a certain pin can be made available
 *      available for muxing. This is called by the core to acquire the pins
 *      before selecting any actual mux setting across a function. The driver
 *      is allowed to answer "no" by returning a negative error code

Maybe it needs some clarification?

> I think the logic above should be to always call ops->gpio_request_enable
> if (gpio):
>
>        if (gpio)
>                if (ops->gpio_request_enable)
>                        /* This requests and enables a single GPIO pin */
>                        status = ops->gpio_request_enable(pmxdev,
>                                                  pin - pmxdev->desc->base);
>        else
>                status = ops->request(pmxdev,
>                                      pin - pmxdev->desc->base);
>
> (ops->gpio_request_enable could be optional if GPIOs aren't supported on
> any pinmux pins, whereas ops->request isn't optional, and should be checked
> during pinmux_register)

Well the idea is that if you want to reserve individual pins for GPIO
but only need to implement one function for all pins on the mux,
you need only implement ops->request(), this is the case for example
with ux500 - any muxable pin works the same way since *all* muxable
pins can also handle GPIO.

> Also, ops->gpio_request_enable should also be passed the GPIO number,
> so the driver can validate that it's the correct one.

Normally I think the pinmux driver should have no knowledge of
such GPIO stuff.

It's two totally separate number spaces here,
one for pins, one for GPIO:s, I definately don't want to create
cross-dependencies between these two.

The basic assumption is that the pin number request coming in
is sane, that the user knows what it is asking for.

> Often, only
> one value would be legal, but perhaps some pinmuxs allow 1 of N different
> GPIOs to be mapped to some pin, so selection of which GPIO is on par with
> selection of which special function to mux out, yet the driver still
> doesn't want to expose every GPIO possibility as a pinmux "function" due
> to explosion of the number of functions if it did that.
>
> b) When ops->gpio_request_enable is called to request a pin, it'd be nice
> if the core could track this, and specifically call a new ops->gpio_disable
> to free it, rather than the generic ops->free. There are two cases in HW:
>
> b1) "GPIO" is just another special function in a list, e.g. SPI, I2C, GPIO.
> In this case, free for a GPIO needs to either do nothing (the next call to
> request will simply set the desired function), or possibly do something to
> disable the pin in the same way as any other function. This works fine with
> a single free function.
>
> b2) GPIO enable/disable is a separate concept from the pinmuxing; on Tegra
> it'll be implemented by calling tegra_gpio_enable/disable. As such, a
> single free function would require the pinmux driver to store state
> indicating whether ops->free should call tegra_gpio_disable, or whether it
> should do cleanup to the pinmux registers. Since the core is managing GPIO
> vs. function allocation, I think the storing that state in the core makes
> sense.

I understand, I think.

But I don't know if passing the gpio number into the pinmux
driver helps with that. To me it sounds like a reason to keep
then even more strictly separated so the pinmux driver have no
clue whatsoever what it is muxing, it just performs the muxing.

I had this similar usecase (I think from Sascha?) where two slightly
different GPIO blocks (different drive strengths etc) would be alternatively
muxed onto the same pins, on a per-pin basis.

In that case I think it was modeled such that say GPIO pins [0-N]
were considered the same pins [0-N] on the other chip too.
In that case I'd say it would be more clever to say that you have
GPIO pins [0..N] and [N+1...2N], then let the physical pins
behind that be a different issue altogether.

For these cases I generally feel we need actual code to get
somewhere, it might get into too much premature upfront design
otherwise. I think it's better to look at patches here.

> Thanks for reading. Hopefully this email didn't jump about too much.

No problem... The more I read the more I learn.

Thanks,
Linus Walleij
