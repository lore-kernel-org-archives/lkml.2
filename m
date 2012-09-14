Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab2INNlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:41:19 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46245 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2INNlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:41:17 -0400
MIME-Version: 1.0
In-Reply-To: <505205B1.4080708@wwwdotorg.org>
References: <1347519686-10170-1-git-send-email-linus.walleij@stericsson.com>
	<505205B1.4080708@wwwdotorg.org>
Date: Fri, 14 Sep 2012 15:41:15 +0200
Message-ID: <CACRpkdYy3KLMFYxgO=MnJTRwQs6hJ0u9=7a3HTg+WkYuPVeKcQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: document semantics vs GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 6:11 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 09/13/2012 01:01 AM, Linus Walleij wrote:

>> +Here we first request a certain pin state and then request GPIO 14 to be
>> +used. If you're using the subsystems orthogonally like this, always get
>> +your pinctrl handle and select the desired pinctrl state BEFORE requesting
>> +the GPIO. This is a semantic convention to avoid situations that can be
>> +electrically unpleasant, you will certainly want to mux in and bias pins
>> +in a certain way before the GPIO subsystems starts to deal with them.
>
> I'm not 100% certain that all HW will work best by first programming
> pinctrl then programming GPIO. For example of strangeness, Tegra's GPIO
> controller has a bit per-pin which overrides the pinmux's mux function
> to enable GPIOs, yet the pinctrl's tri-state overrides the GPIO's
> input/output control. I imagine HW engineers can come up with even more
> bizarre schemes that might in some cases require the reverse order).
>
> However, I suppose what you've documented is likely common and it'd be
> good to recommend a default order between the two APIs. I might whittle
> out the part that justifies the order from a HW glitching perspective
> though.

Yeah. I think I'm on the safe side since I wrote "should" rather than "must",
I have understood that some standardization people pay a lot of attention
to which of these two words is used... "should" is possible to break but
only for good reasons. But I diplomatized the language a bit more.

>> +The above can be hidden: using pinctrl hogs, the driver may be setting
>
> s/the driver/the pinctrl driver/ I think.

OK

>> +up the config and muxing for the pins when the pinctrl driver is probing,
>> +nevertheless orthogonal to the GPIO subsystem.
>> +
>> +But there are also situations where it makes sense for the GPIO subsystem
>> +to communicate directly with with the pinctrl subsystem, using the latter
>> +as a back-end. This is when the GPIO driver may call out to the functions
>> +described in the section "Pin control interaction with the GPIO subsystem"
>> +above. This only involves per-pin multiplexing, and will be completely
>> +hidden behind the gpio_*() function namespace. In this case, the driver
>> +need not interact with the pin control subsystem at all.
>
> I think it makes sense to more strongly recommend that for GPIO muxing,
> the GPIO driver always call into the pinctrl subsystem (if needed by the
> HW) to perform that muxing, so that standalone gpio_direction_*() always
> work without any use of pinctrl; the interaction between the two should
> only be required if pin configuration (not just pin muxing) is also
> required.

OK I will make it a MUST and see if someone yells back at me :-)

It so happens that the OMAP driver does not implement it for
now... but we can then require it for new drivers.

Linus Walleij
