Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab2EKIVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:21:31 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52538 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab2EKIVV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:21:21 -0400
MIME-Version: 1.0
In-Reply-To: <4FAAD721.3070101@wwwdotorg.org>
References: <1336470302-23670-1-git-send-email-linus.walleij@stericsson.com>
	<4FAAD721.3070101@wwwdotorg.org>
Date: Fri, 11 May 2012 10:21:20 +0200
Message-ID: <CACRpkdY0phbf3Ec+A8O4+HvVoWjC4vs9jsNfGzZiLYeCqPrrrQ@mail.gmail.com>
Subject: Re: [PATCH 06/12] pinctrl/nomadik: implement pin configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 10:44 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/08/2012 03:45 AM, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> This implements the pin configuration interface for the
>> Nomadik pin controller.
>>
>> As part of the exercise we add a bit in the pin_cfg_t for
>> the Nomadik pinctrl driver that indicates if the pin should
>> be forced into GPIO mode. This is not done to go behind the
>> back of the GPIO subsystem, but to ensure that default modes
>> can be set by hogs on boot and system suspend/resume states.
>> It was used implicitly by the old code defining all config
>> settings and modes in a single config word but we now have
>> a split between pinmux and pinconf leading to the need to
>> have this.
>
> Yes, I have wondered if we should have always represented the
> GPIO/pinctrl interaction as a pinctrl "function" of "GPIO. There are a
> few gotchas that prevented me moving forward with this though:
>
> 1) On Tegra at least, GPIO-vs-pinmux is actually a bit in the GPIO
> controller, so that mux is after the pinmux's output mux

Nomadik/Ux500 is different. It has the mux before the driver
stage, so we need to driver the GPIO lo/hi by a bit into the
mux, then after the driver stage we can e.g. pull up/down.

> 2) I'm not sure how it'd work when you could mux "GPIO controller A GPIO
> x" or "GPIO controller B pin y" onto the same pinctrl pin

Well pins x and y have a unique number in the GPIO numberspace,
which means they will have two different ranges defined,
and depending on which range you get passed to
.gpio_request_enable() you do different things in the driver.

But with named gpio functions on each pin and just a plain request()
there will be a problem (I guess this is what you're referring to).

Maybe it's simply so that .gpio_request_enable() is a better
idea for this kind of scenario anyway?

> 3) On Tegra at least, special-function muxing is at a per-pingroup
> level, but GPIO muxing is at a per-pin level. So much for regular HW:-(

I think we need to keep concepts separate, and think of the
usecase rather than the fact that the pin has a mode which happens
to be called "gpio", for my usecase that is just a four-letter acronym
with no meaning than that it's a hardware state, it could be named
"drive control" or "frox" or whatever.

Right now it's working pretty well since when I put the pins to sleep
I need to configure them into a mode where I can set the pins to be
biased and in a certain way and with certain wakeup props.

That mode happens to have the name "gpio" and has the
side-effect that if it had been claimed for GPIO it would have been
possible to use the gpiolib interface to drive it high/low etc. But since
the pins are occupied by a device, this isn't possible, gpio_request()
would fail on it.

So this is one of these cases where trying to map physical
properties to logical framework use breaks down, and we have
to rely on the kernel concepts for determining what the pin is
really used for. Just reading a hardware register won't tell us
if it's actually used for GPIO or for some device sleep mode.
Not in this driver atleast.

>> @@ -1561,7 +1562,8 @@ int nmk_gpio_request_enable(struct pinctrl_dev *pctldev,
>>
>>       clk_enable(nmk_chip->clk);
>>       bit = offset % NMK_GPIO_PER_CHIP;
>> -     __nmk_gpio_set_mode_safe(nmk_chip, bit, NMK_GPIO_ALT_GPIO, false);
>> +     /* There is no glitch when converting any pin to GPIO */
>> +     __nmk_gpio_set_mode(nmk_chip, bit, NMK_GPIO_ALT_GPIO);
>
> Was that meant to be squashed into some other earlier change?

Yes, I'll update!

Thanks,
Linus Walleij
