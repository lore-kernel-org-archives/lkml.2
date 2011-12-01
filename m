Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1LARMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:12:31 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13521 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab1LARM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:12:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 01 Dec 2011 09:12:22 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>
Date: Thu, 1 Dec 2011 09:12:14 -0800
Subject: RE: [PATCH 1/2 v4] pinctrl: add a pin config interface
Thread-Topic: [PATCH 1/2 v4] pinctrl: add a pin config interface
Thread-Index: AcywD/ZnB3orEOMKQfCtqYEmRmp+dAAO0yDg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174FDB01F1@HQMAIL01.nvidia.com>
References: <1322160370-27677-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174FDAFF07@HQMAIL01.nvidia.com>
 <CACRpkdae2H1BDcCvdJ3RE8QarE6yKwUkyaVh6iwb_1VvrOi-4g@mail.gmail.com>
In-Reply-To: <CACRpkdae2H1BDcCvdJ3RE8QarE6yKwUkyaVh6iwb_1VvrOi-4g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Thursday, December 01, 2011 3:00 AM:
> On Wed, Nov 30, 2011 at 8:19 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Linus Walleij wrote at Thursday, November 24, 2011 11:46 AM:

> >> +/**
> >> + * pin_config_get() - get the configuration of a single pin parameter
> >> + * @pctldev: pin controller device for this pin
> >> + * @pin: pin to get the config for
> >> + * @config: this config tuple will be filled in with the setting for
> >> + *   the requested parameter, so the .param part of this setting must
> >> + *   me set when calling the function
> >
> > I don't like muxing the param and value together in a single parameter;
> > it requires a bunch of bit-shifting to create them, modify the value
> > here, and extract values. Why not just have "param" and "value" function
> > parameters like the old patches?
> 
> Because since we move to the concept of the core not knowing what
> it is passing around, it is better to just have an unsigned long and let
> the driver and its board file/device tree decide what to do with it.
> 
> Since I don't have any enum for the param anymore, it would
> just be another unsigned long, so what's the point?

Well, there is an enum, it's just in the second patch set...

I think directly supporting param/value is a pretty common case, and
seems like it deserves first-class support.

Supporting it wouldn't complicated the "custom struct pointer" case at
all; you'd just hard-code one of the parameters to 0 when calling, and
ignore it when implementing the driver.

Conversely, explicitly supporting param/value would significantly simplify
drivers that do want to use this mechanism, since you wouldn't need any
custom struct types and casting, or all the pack and unpack macros, which
I think will complicated the common case right now.

> >> +int pin_config_get(struct pinctrl_dev *pctldev, int pin,
> >> +                       unsigned long *config)
> > ...
> >> +     ret = ops->pin_config_get(pctldev, pin, config);
> >> +     /*
> >> +      * -EINVAL is OK, it means the setting is not active right now
> >
> > That doesn't really make sense; given it's a param/value thing, a
> > particular param can't be "not active"; it has a particular value or
> > not.
> 
> Yeah that's generic pin config semantics, I'll take it out, remove the
> debug print and put it in the generic config documentation.
> 
> > There's no pin_config_group_get()?
> 
> I've added it for symmetry, but will that work in practice?
> 
> Say you pin_config_group_get() and pins have wildly different
> settings, what do you return?

-ENOTSUPP.

Some parameters can actually be programmed on a per-pin basis. For these,
pin_config_get/set should implement them, and pin_config_group_get/set
should return -ENOTSUPP.

Other parameters are actually set at the group level (with a HW register
that affects n pins at once). For these, pin_config_get/set should return
-ENOTSUPP, and pin_config_group_get/set should return implement them.

> >> +static inline int pin_config_get(struct pinctrl_dev *pctldev, int pin,
> >> +                              unsigned long *config)
> >> +{
> >> +     return 0;
> >> +}
> >
> > Shouldn't at least pin_config_get() return an error. It seems like both
> > pin_config_set() and pin_config_group() don't do what they're asked, so
> > they should also return an error. gpiolib takes that approach; e.g.
> > gpio_direction_input() fails in the dummy case.
> 
> We already allow say pinmux_enable() to succeed if pinmux
> is compiled out.
> 
> My idea was that it would be good for debugging to say disable
> the pinctrl altogether, then leave pins in their power-on state
> and no calls into the framework will even touch them, so you
> can see what happens. (This I think is partly the intention of the
> clk and regulator stubs.)
> 
> Having this return errors will make such binaries with pinconf
> compiled-out just not boot if the error codes are handled
> correctly, which is not very helpful.
> 
> Maybe I'm getting this all wrong?

It seems better to plug in a dummy/stub pinctrl driver for testing
purposes that allow the pinctrl APIs to succeed by default in cases
where there's no implementation, which might end up hiding problems.

-- 
nvpublic

