Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab1LEN0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:26:47 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62955 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab1LEN0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:26:44 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF174FDB01F1@HQMAIL01.nvidia.com>
References: <1322160370-27677-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174FDAFF07@HQMAIL01.nvidia.com>
	<CACRpkdae2H1BDcCvdJ3RE8QarE6yKwUkyaVh6iwb_1VvrOi-4g@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174FDB01F1@HQMAIL01.nvidia.com>
Date: Mon, 5 Dec 2011 14:26:43 +0100
Message-ID: <CACRpkdaprxtzkby6McYd=wZ2xUQN2-8JmtBhoCfLbC38h-8cRw@mail.gmail.com>
Subject: Re: [PATCH 1/2 v4] pinctrl: add a pin config interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 6:12 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Thursday, December 01, 2011 3:00 AM:

>> since we move to the concept of the core not knowing what
>> it is passing around, it is better to just have an unsigned long and let
>> the driver and its board file/device tree decide what to do with it.
>>
>> Since I don't have any enum for the param anymore, it would
>> just be another unsigned long, so what's the point?
>
> Well, there is an enum, it's just in the second patch set...

That's optional as it is now. (Oh maybe I should be commenting
on v5, well... sorry for revising too quickly.)

> I think directly supporting param/value is a pretty common case, and
> seems like it deserves first-class support.

Not for the in-kernel U300 and SIRF drivers, and I have only
vague ideas of the non-written drivers yet.

> Supporting it wouldn't complicated the "custom struct pointer" case at
> all; you'd just hard-code one of the parameters to 0 when calling, and
> ignore it when implementing the driver.

Yes true, I did it like that before, but it doesn't look elegant.
I feel more at home with the either/or approach. So either it's this
simple unsigned long being passed around and that is opaque,
if we start passing around two things ... it's somewhat like the
same reason we pass around some struct * and use
countainer_of() to derive containing structs, isntead of passing
a lot of things around. Some of the refactorings around e.g.
IRQ handlers have been to remove extraneous parameters.

So it feels like something of an antipattern, it doesn't look
good to pass around two unknown things when you can
do with one.

> Conversely, explicitly supporting param/value would significantly simplify
> drivers that do want to use this mechanism, since you wouldn't need any
> custom struct types and casting, or all the pack and unpack macros, which
> I think will complicated the common case right now.

I have patches for the U300 in-kernel driver using this
mechanism and it doesn't look complicated I think.

>> Say you pin_config_group_get() and pins have wildly different
>> settings, what do you return?
>
> -ENOTSUPP.

Yeah OK. It's there in V5 so enjoy!

>> Having this return errors will make such binaries with pinconf
>> compiled-out just not boot if the error codes are handled
>> correctly, which is not very helpful.
>
> It seems better to plug in a dummy/stub pinctrl driver for testing
> purposes that allow the pinctrl APIs to succeed by default in cases
> where there's no implementation, which might end up hiding problems.

Hm. That doesn't quite match e.g. the way regulators supply
regulator stubs and dummies. The options for regulators are:

- Compile it out - everything returns success (no NULL etc)

- Compile it in - non-existing regulators will result in
  error codes.

- enable dummy regulators, then you can compile it in,
  and still get dummies for non-existing regulators e.g.
  and (typically) proceed to boot.

I would really not like to deviate from how regulator works
here, but keep the workings the same. So dummies can be
done, but they are for the case when pin control is enabled
but not fully implemented.

Would be good to have Marks input on this... he has more
experience with that kind of stuff.

Yours,
Linus Walleij
