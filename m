Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab1KKOJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 09:09:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58515 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab1KKOJI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 09:09:08 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740805421@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17408051C2@HQMAIL01.nvidia.com>
	<CACRpkdY8YXooD5ChHqQnERPPGhk7TgUvL=TodAPY8Jit9eS=fw@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805421@HQMAIL01.nvidia.com>
Date: Fri, 11 Nov 2011 15:09:07 +0100
Message-ID: <CACRpkdaArzSfUVgPo0vVEAUNKwZO7W5yhjJpeEQiFK20RQS2Ag@mail.gmail.com>
Subject: Re: pinctrl discussions @ Linaro Connect, and also requesting GPIOs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 5:33 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Thursday, November 10, 2011 1:40 AM:
>> Stephen Warren <swarren@nvidia.com> wrote:
>> > Many drivers currently call gpio_request(). This is defined /not/ to
>> > perform any pinmux manipulation.
>>
>> Is it?
>>
>> I always though that the GPIO driver could call out to the pinctrl
>> counterpart.
>
> I'd originally thought that too, but when I tried to "fix" gpio_request()
> on Tegra to perform any necessary pinmux actions, it was pointed out that
> Documentation/gpio.txt says:
>
> " Note that requesting a GPIO does NOT cause it to be configured in any
> " way; it just marks that GPIO as in use.  Separate code must handle any
> " pin setup (e.g. controlling which pin the GPIO uses, pullup/pulldown).
>                              ^^^^^^^^^^^^^^^^^^^^^^^

Hm, yeah I see. :-/ You're right of course.

And it is perfectly possible to say, drive a GPIO pin even though it is
not connected anywhere at all, even though it seem strange,
there may be cases where a GPIO is used internally on a chip OR
routed to an external pin, and then this is fully logic.

And it makes the two subsystems mostly orthogonal.

> Given that, it appears that the pinctrl/pinmux API is the way to perform
> that setup, including muxing the GPIO controller onto the pin if required.
> Given the similarity of that mux setup with more general non-GPIO mux
> setup is why I suggested including GPIO muxing in the regular mapping
> table.
>
> (as I think I mentioned) and alternative to a custom GPIO mapping table
> entry would be to remove the GPIO-specific APIs from pinctrl, and have
> all pinctrl drivers only expose GPIO as an additional function available
> on a pin (group). Systems that support N different GPIOs on a pin would
> need to expose GPIO this way anyway.

Yes. It is already possible to use the mapping table like that if
all GPIOs are represented as indvidual functions from the
*driver* (i.e. not using the pinmux_request_gpio() function)
so currently it's a matter of choice.

We already have a goal to do as much as possible of set-up from
platform code, including mapping table, or, even better, by direct
bindings from the device tree (whenever we get that).

The idea with the single GPIO request functions was to make
things simpler and quicker but maybe it's just cluttering the view :-/

What do others think? Shall we just kill
pinmux_[request|free]_gpio() and its driver hooks?

I guess I have to convert a driver with mixed GPIO myself
before I fully understand how to do this the right way...

Yours,
Linus Walleij
