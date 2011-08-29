Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab1H2Id6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 04:33:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41670 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab1H2Idx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 04:33:53 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B24A4113@HQMAIL01.nvidia.com>
References: <1313747619-32222-1-git-send-email-linus.walleij@stericsson.com>
	<CAGsJ_4z7s-ibmUuR1DA6Jps030dRrnE8M0dUWHoMhMPFtyyY_A@mail.gmail.com>
	<CACRpkdb4-0TfO-viUoZyW3VoLnVuo2ztHTX=8Hef3_RYWB52vg@mail.gmail.com>
	<CAGsJ_4yEXEajH1JyNjnYE0hg13Fgd7bdiMNFs2fp6Ou=h_9N9g@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B24A4113@HQMAIL01.nvidia.com>
Date: Mon, 29 Aug 2011 10:33:52 +0200
Message-ID: <CACRpkdY93J-dSx+TM+RpQgSx09Mq-d3mwe-Scd_6GUhccMo-kg@mail.gmail.com>
Subject: Re: [PATCH 0/4 v4] pin controller subsystem v4
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Barry Song <21cnbao@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 7:12 PM, Stephen Warren <swarren@nvidia.com> wrote:
> [Barry]
>> static int xxx_gpio_request(struct gpio_chip *chip, unsigned offset)
>> {
>>         int ret = 0;
>>
>>         ret = pinmux_request_gpio(chip->base + offset);
>>         if (ret)
>>                 goto out;
>>         .....
>> out:
>>         return ret;
>> }
>
> I would have expected this to work the other way around; "gpio" is just
> another function that can be assigned to a pin.

That's basically how it work internally, what I noticed is that GPIO
requests seem to come in single pins (not groups) so there is
a special function to request a pin by passing in the number from
the GPIO pinspace and this optionally propagates all the way
to the driver if there is a quick way to request this pin to be
muxed in as GPIO.

> 1) Pin is SF or a particular GPIO.
>
> 2) Pin is SF or a particular GPIO from GPIO controller A, or a particular
>   GPIO from controller B
>
> 3) Pin is SF, or one of a number of user-selectable GPIOs.
>
> Case (1) is covered by the code quoted above from earlier in the thread.
> Cases (2) and (3) can't be covered by that code, and according to comments
> in earlier replies, both actually exist in real HW.

I think we can handle this quite well conceptually, but I don't
know if we have the proper interaction with the drivers yet,
so let's rinse and repeat a bit here.

I'll post v5 today with your proposed changes
(if you recognize them...)

> 1) Have a single function "gpio" that can be applied to any pin that
> supports it. The actual GPIO number that gets mux'd onto the pin differs
> per pin, and is determine by HW design. But logically, we're connecting
> that pin to function "gpio", so we only need one function name for that.

Actually I think the new code can do this, one function "gpio" with
multiple what I call "positions", so "gpio" can be on pin {1, 5, 95, ..}

> 2) Have a function for each GPIO controller that can be attached to a
> pin; "gpioa" or "gpiob". Based on the pin being configured, and which of
> those two GPIO functions is selected, the HW determines the specific GPIO
> number that's assigned to the pin.

Should also work now with functions and positions per function
I hope.

> 3) Where the GPIO ID assigned to pins is user-selectable, have a function
> per GPIO ID; "gpio1", "gpio2", "gpio3", ... "gpio31". This sounds like
> it'd cause a huge explosion in the number of functions; one to represent
> each GPIO ID. However, I suspect this won't be too bad in practice, since
> there's presumably some practical limit to the amount of muxing logic that
> can be applied to each pin in HW, so the set of options won't be too large.

What happens right now is that the pinmux core system names the
pin as taken by "gpioN" where N is the number from the GPIOlib number
space.

However that is just a name, not a function, and we have this special
callback to the driver to mux in a single pin for GPIO.

So what I need to do to support this is to support machine mappings for
the GPIOs as function with positions which currently not available.

Lemme see what I can do about that in v6.

> If the set of GPIO IDs that can be assigned to any particular pin is a subset
> of the whole GPIO number space, e.g.:
>
> pina: gpio1, gpio2, gpio3, gpio4
> pinb: gpio2, gpio3, gpio4, gpio5
> pinc: gpio3, gpio4, gpio5, gpio6
>
> ... then I imagine HW has already defined an enumerator gpioa, gpiob, gpioc,
> gpiod and a mapping from those to the specific GPIO ID that each means when
> assigned to a given pin, so those gpioa/b/c/d values could be used as the
> function exposed by the pinmux driver.

Yep should be possible to make it work that way. Just need a way
to map that for the machine.

Yours,
Linus Walleij
