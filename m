Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1HZIfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 04:35:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41669 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab1HZIfD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 04:35:03 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B24A3EDB@HQMAIL01.nvidia.com>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B24A3BC0@HQMAIL01.nvidia.com>
	<CACRpkdaZfG4hiGf8vug3EGMRMc0c92xbj=L_HAQcS27DAXYc4Q@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B24A3EDB@HQMAIL01.nvidia.com>
Date: Fri, 26 Aug 2011 10:35:02 +0200
Message-ID: <CACRpkdbBBaNFETLLcxeCFZoLbdMok7uRi_o-HcbpYdMtRiGFcw@mail.gmail.com>
Subject: Re: [PATCH 1/4 v4] drivers: create a pin control subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        ext Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 9:13 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Thursday, August 25, 2011 4:13 AM:
>
>> So this is radically different in that it requires the pin control
>> system to assume basically that any one pin can be used for
>> any one function.
>
> I think that's the wrong conclusion; 1:many isn't the same as 1:all/any.
> The data model might be structured to allow that, but in practice most
> HW allows 1:some_subset, not 1:all/any. I think this was well-covered in
> some other recent responses in this thread.

OK what I was mainly after was if the data model should
be structured to accept phone-exchange type muxing. If it
does and such a hardware appears - I mean a hardware where
any pin can be muxed anywhere, and given the second point
you make that the pinmux subsystem should expose all possible
combinations, it will lead to a situation where the driver
needs to expose all permutations i.e. (n over k) combinations
per function where n is the number of available pins and k
is the number of pins used by any one function. That would
just explode...

So if we assume that such a hardware does not exist but
the number of permutations of functions will always be limited,
it makes much more sense.

I'll encode this theoretical assumption in
Documentation/pinctrl.txt as I go along.

>> So the data model I'm assuming is:
>>
>> - Pins has a 1..* relation to functions
>> - Functions in general have a 1..1 relation to pins,
>> - Device drivers in general have a 1..1 relation to
>>   functions
>> - Functions with 1..* relation to pins is uncommon
>>   as is 1..* realtions between device drivers and
>>   functions.
>>
>> The latter is the crucial point where I think we have
>> different assumptions.
>
> As a few other replies pointed out, a number of chips do allow the at
> least some logical functions to be mux'd onto different pins. Tegra
> certainly isn't unique in this.

Yeah I get this now... and it's a handful of alternatives for a
few functions, sorry for being such a slow learner.

>> If it holds, it leads to the fact that a pinmux driver
>> will present a few functions for say i2s0 usually only
>> one, maybe two, three, never hundreds.
>
> Certainly I'd assume the number of pins/groups that a given function
> could be mux'd out onto is small, say 1-3. But, certainly not limited
> to just 1 in many cases.

Sure, we're on the same page. So I now need to find a
way to expose a few different localities per function from
the system and all the way to the map, and drop the string
naming system so instead of using spi0-0, spi0-1, spi0-2
I use some tuple like {"spi0", 0}, {"spi0", 1}, {"spi0", 2}
and I call the latter integer something like "locality" or
"position".

> Just a note: There are Tegra-based boards in wide use (in fact, boards
> for which some support is in mainline) that make active use of switching
> the routing of a HW function between different pins at run-time.
> Specifically, switching 1 I2C controller between 2 busses on the board.
>
> In fact, soon after the pinmux system is upstream, I hope we (NVIDIA) will
> be writing and submitting an I2C bus mux driver based on that. In our
> downstream kernels, we do this as custom code in the I2C host driver, but
> I want to move it out into a separate driver that anyone can use.

This is pretty cool and a usecase that I was thinking about. It'll
be fun!

Yours,
Linus Walleij
