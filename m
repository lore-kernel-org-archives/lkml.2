Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab1KLOnM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 09:43:12 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48779 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab1KLOnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 09:43:10 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdbWjAa5dKEu5caXG8jS2c7Z9ZHtT80Gc2DZYNUTTy3HZw@mail.gmail.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17408051C2@HQMAIL01.nvidia.com>
	<CACRpkdY8YXooD5ChHqQnERPPGhk7TgUvL=TodAPY8Jit9eS=fw@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805421@HQMAIL01.nvidia.com>
	<CACRpkdaArzSfUVgPo0vVEAUNKwZO7W5yhjJpeEQiFK20RQS2Ag@mail.gmail.com>
	<CAJuYYwS465WW-Xp6gk5hzKArTZGzmc6nh+-XR=BPusGfTU=DXw@mail.gmail.com>
	<CACRpkdbWjAa5dKEu5caXG8jS2c7Z9ZHtT80Gc2DZYNUTTy3HZw@mail.gmail.com>
Date: Sat, 12 Nov 2011 20:13:09 +0530
Message-ID: <CAJuYYwTg-4pvvTAngfH6CpDDxKS5PimUYF__kwMA2LJX_hO_Vw@mail.gmail.com>
Subject: Re: pinctrl discussions @ Linaro Connect, and also requesting GPIOs
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2011 19:47, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sat, Nov 12, 2011 at 12:22 PM, Thomas Abraham
> <thomas.abraham@linaro.org> wrote:
>
>> Samsung SoC's use two pin functions out of 4/8/16 pin functions to
>> represent that a pin is used as a gpio. For instance, function 0 means
>> pin is used as a gpio input, and function 1 means pin is used as gpio
>> output. A pin cannot support both input and output mode at the same
>> time.
>>
>> The existing pinmux_[request|free]_gpio() functions can specify that a
>> pin has to be set in gpio function mode, but lack the provision to
>> select input or output mode for the gpio.
>
> OK then this needs fixing if this API is to persist.
>
>> The alternative approach of
>> using pin functions to select gpio-input or gpio-output will be used
>> for samsung pinmux drivers.
>>
>> This means the gpio_direction_[input|output] api's would remain unused
>> on samsung platforms. And existing platforms already using this api
>> will have to be modified to use the pinmux api to select the direction
>> of the gpio pin. And the role of gpio_request will seem redundant when
>> used along with pinmux_get().
>
> This does not seem right. Why should it not use
> gpio_direction_[input|output] to select whether the pin is used
> for input or output like everyone else?

The gpio_direction_[input|output]() internally sets the pin function
(by writing to pin function register) to either gpio input|output.
Since the gpio calls should stop writing to the pin function registers
(since we have pinmux driver now), there should be way for
gpio_direction_[input|output]() to inform pinmux driver to set gpio in
input|output mode.

But this cannot be achieved with existing pinctrl/pinmux api and so
gpio_direction_[input|output]() will not be used and separate pin
function for gpio input/output setup and used in the pinmux driver.

>
> This will just lead to trouble with shared HW blocks where
> one use gpio_direction_[input|output] to select the direction
> while another one will use some pinctrl API.

Yes, that is true. So gpio_direction_[input|output]() would not be
used to setup the gpio direction anymore.

>
> We need one of two things:
>
> 1. pinmux_[request|free]_gpio() to pass direction to the
>  core and driver, or

This approach seems to be better.

>
> 2. A use pattern like this:
>  pmx = pinmux_get(dev, "gpio-1-in");
>  /* Use as input */
>  pinmux_put(pmx);
>  pmx = pinmux_get(dev, "gpio-1-out");
>  /* Use as output */
>  etc
>
> The latter seems hopeless to maintain. So the external call
> pinmux_[request|free]_gpio() needs to be kept around,
> and it needs to be called *internally* by GPIO drivers to set
> up pins, so as to avoid hazzle.
>
> In my opinion atleast...

Yes. I agree with that.

>
> Linus Walleij
>

Thank you LinusW.

Regards,
Thomas.
