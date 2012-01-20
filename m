Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab2ATP7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:59:20 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50611 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab2ATP7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:59:19 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdYwx3O42aC8F+DMV1GL0ce62ZhChOQYdbd7-syunsgBOg@mail.gmail.com>
References: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
	<CAJuYYwT+pNdt6G07Gx7TqkpGBQEnmMGxsHSE2mew9qUjO-ES5Q@mail.gmail.com>
	<CACRpkdZS9OVv8osoc5E1KOcqfFnvECnKJzM1kXZ9qNKQMZgB=w@mail.gmail.com>
	<CAJuYYwTP8a4KYDrJ2o9Wmt4jo_DvLviy75T90JnV7Hw10Y+ZXw@mail.gmail.com>
	<CACRpkdYwx3O42aC8F+DMV1GL0ce62ZhChOQYdbd7-syunsgBOg@mail.gmail.com>
Date: Fri, 20 Jan 2012 21:29:18 +0530
Message-ID: <CAJuYYwRar17+nmqOywd=Yyf=shFQnL4R_jz6Lhk8=RrcdCovLA@mail.gmail.com>
Subject: Re: [PATCH v6] pinctrl: add a pin config interface
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 19 January 2012 23:58, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Jan 19, 2012 at 6:55 PM, Thomas Abraham
> <thomas.abraham@linaro.org> wrote:
>> Hi Linus,
>> On 19 January 2012 22:28, Linus Walleij <linus.walleij@linaro.org> wrote:
>>> On Wed, Jan 18, 2012 at 8:16 AM, Thomas Abraham
>>> <thomas.abraham@linaro.org> wrote:
>>>
>>>> In case of runtime pinmuxing, the pin configuration would also be
>>>> required to be setup in some cases. pin_config_set() is suitable to be
>>>> called from the platform code. In case of runtime pinmuxing in driver
>>>> code, is there any way to set the pin config also at runtime in driver
>>>> code?
>>>
>>> Yes that is already possible today with the pin_config_set() and
>>> pin_config_group_set() calls already merged for 3.3.
>>>
>>> However there is no relation between the struct device and these
>>> config settings so I feel that this is a bit hack-ish, but it was
>>> atleast something we could agree upon.
>>
>> Using pin_config_set() from drivers did not seem correct. The concern
>> here is that all there parameters of pin_config_set() are specific to
>> a particular platform. Hence, using it in driver means that the driver
>> will no more be usable across multiple different platforms.
>
> Yes. But drivers can define a callback function into their
> platform data, which in turn has the knowledge of what to do
> for different scenarios, and calls pin_config_set() on the
> pin controller for that system.
>
> But no, it's not elegant :-)

Ok. platform_data is a possibility. So for non-dt driver probe, the
driver would call the platform callback and for dt based driver probe,
we still need to find a suitable way.

>
>> But that was not the case with pinmux_get() and pinmux_put().
>
> True. pinmuxes are completely platform agnostic...
>
> What would be elegant?
>
> pinconf_get() + pinconf_put() doesn't seem right since
> configs are not simple "on or off" states.
>
> So we need something like the named config states, but
> mapped down per device.
>
> How about a driver does this:
>
> ret = pinconf_activate(&dev, "foo");
>
> Where "foo" is a state string like "active", "idle", "sleep",
> "off" and could correspons to preset strings in pinconf.h
> like those found in the other patch

Yes, the ability to set the pinconfig from the driver would be very
helpful for Samsung platforms.


> "[PATCH] pinctrl: pin configuration states" I sent out
> two days ago?
>
> Then we can have both system-wide and per-device
> mapped pin configuration states named by strings.

Ok. Support for both would be nice to have.

>
> Note that pinconf_get()/pinconf_put() is completely
> superfluous in this scheme. Since the configurations are
> stateless settings (not e.g. allocating pins) this is all fine.
>
> Passing the string with a named config indicates that
> the driver knows exactly what it is doing anyway.
>
> Shall I recook pin configuration states like this for
> a try?

Yes, that will be very helpful. Thanks.

It would be easier if pinconf_register_pin_states() need not be called
for each pin state instance. There should be something similar to the
existing pinmux configuration where is no need to explicitly register
a pinmux.

Regards,
Thomas.

>
>> Will
>> there be support added in pinctrl subsystem to allow drivers to
>> configure pin-config settings from drivers and be compatible for
>> multiple platforms?
>
> Please provide feedback on my patch entitled:
> "[PATCH 2/2 v5] pinctrl: introduce generic pin config"
>
> If I get a few ACKs for something like that we have the
> infrastructure for letting drivers config their pins.
>
> Yours,
> Linus Walleij
