Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab1LAJ7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:59:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1LAJ7r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 04:59:47 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF174FDAFF07@HQMAIL01.nvidia.com>
References: <1322160370-27677-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174FDAFF07@HQMAIL01.nvidia.com>
Date: Thu, 1 Dec 2011 10:59:47 +0100
Message-ID: <CACRpkdae2H1BDcCvdJ3RE8QarE6yKwUkyaVh6iwb_1VvrOi-4g@mail.gmail.com>
Subject: Re: [PATCH 1/2 v4] pinctrl: add a pin config interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 8:19 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Thursday, November 24, 2011 11:46 AM:

>> @@ -315,6 +317,7 @@ int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
>>       return -EINVAL;
>>  }
>>
>> +
>
> That's probably an accident?

Yes, fixed it.

>> +/**
>> + * pin_config_get() - get the configuration of a single pin parameter
>> + * @pctldev: pin controller device for this pin
>> + * @pin: pin to get the config for
>> + * @config: this config tuple will be filled in with the setting for
>> + *   the requested parameter, so the .param part of this setting must
>> + *   me set when calling the function
>
> I don't like muxing the param and value together in a single parameter;
> it requires a bunch of bit-shifting to create them, modify the value
> here, and extract values. Why not just have "param" and "value" function
> parameters like the old patches?

Because since we move to the concept of the core not knowing what
it is passing around, it is better to just have an unsigned long and let
the driver and its board file/device tree decide what to do with it.

Since I don't have any enum for the param anymore, it would
just be another unsigned long, so what's the point?

Either the core knows the params (as was proposed earlier and
is now optional) or it knows nothing, in which case an opaque
unsigned long should fit the bill. Passing two unsigned longs
with undefined semantics is just sort of half-guessing what drivers
need I don't like the looks of that.

The opaque unsigned long passed here can be cast to anything,
just like we do with interrupts. Could be void * but that is more a
matter of taste. unsigned long is nice for implementations that
just want to cast that to some enum (like the patch to the
in-tree driver).

In the driver for the situation you want:

<mach/my-config.h>:

struct my_config {
   enum my_param;
   unsigned long my_value;
};

pinctrl/my-driver.c:

#include <mach/my-config.h>

int foo_pin_config_get(struct pinctrl_dev *pctldev,
                        unsigned pin,
                        unsigned long *config)
{
        struct my_config *conf = (struct my_config *) *config;
        ...
}


int foo_pin_config_set(struct pinctrl_dev *pctldev,
                        unsigned pin,
                        unsigned long config)
{
        struct my_config *conf = (struct my_config *) config;
        ...
}

In the U300 pinmux driver the split between parameter and
argument is unnecessary so it just casts (assigns really) the
unsigned long config to it's enum, and pass it along. Thus it
gets really slim without needing to pass around an ununsed
unsigned long to all functions.

Driver that want complex arguments can still pass them around
per above.

Will this work for you?

> In the description of @config, there is no ".param part of this setting"
> since this isn't a struct in this version of the patch.

Thanks, taking it out.

>> +int pin_config_get(struct pinctrl_dev *pctldev, int pin,
>> +                       unsigned long *config)
> ...
>> +     ret = ops->pin_config_get(pctldev, pin, config);
>> +     /*
>> +      * -EINVAL is OK, it means the setting is not active right now
>
> That doesn't really make sense; given it's a param/value thing, a
> particular param can't be "not active"; it has a particular value or
> not.

Yeah that's generic pin config semantics, I'll take it out, remove the
debug print and put it in the generic config documentation.

> There's no pin_config_group_get()?

I've added it for symmetry, but will that work in practice?

Say you pin_config_group_get() and pins have wildly different
settings, what do you return?

Since it's now up to the driver I've added it, I just want to
make sure there is a solid use case for it.

>> +      * -ENOTSUPP just means that setting is not available and is also OK
>> +      */
>> +     if (ret == -EINVAL || ret == -ENOTSUPP)
>> +             return ret;
>> +     if (ret) {
>> +             dev_err(&pctldev->dev,
>> +                     "unable to get pin configuration on pin %d\n", pin);
>
> This is always true; why make the dev_err() conditional at all? Especially
> attempts to retrieve unsupported parameters should be logged.

This hunk is taken out per above.

>> +int pin_config_group(struct pinctrl_dev *pctldev, const char *pin_group,
>> +                  unsigned long config)
> ...
>> +     /*
>> +      * If the controller cannot handle entire groups, we configure each pin
>> +      * individually.
>> +      */
>
> I don't really like the automatic fallback; a particular param is either
> valid for a group or a pin, and the user really should be setting it on
> the appropriate one. Still, for drivers where the fallback never makes
> sense, we can just never return -EAGAIN, so can disable this if we want,
> so I guess it's fine.

Yep, the fallback is not automatic as you say, drivers have to request
the fallback by returning -EAGAIN, which they are unlikely to do
by chance.

>> +int pinconf_check_ops(const struct pinconf_ops *ops)
>> +{
>> +     /* We must be able to read out pin status */
>> +     if (!ops->pin_config_get)
>> +             return -EINVAL;
>
> What if there are no per-pin configuration parameters?

Yes and another case for adding ops->pin_config_group_get()
so now it looks like this:

	if (!ops->pin_config_get && !ops->pin_config_group_get)
		return -EINVAL;

> ... [debugfs code]
>> +#else
>> +
>> +#endif
>
> Should there be something inside the #else? If not, perhaps just write
> #endif without #else?

True! The stuf in pin pinconf.h.

>> diff --git a/include/linux/pinctrl/pinconf.h b/include/linux/pinctrl/pinconf.h
>
>> +extern int pin_config_get(struct pinctrl_dev *pctldev, int pin,
>> +                       unsigned long *config);
>> +extern int pin_config_set(struct pinctrl_dev *pctldev, int pin,
>> +                       unsigned long config);
>> +extern int pin_config_group(struct pinctrl_dev *pctldev, const char *pin_group,
>> +                         unsigned long config);
>
> I don't really like exposing these as public APIs; I don't see any need
> for drivers to be explicitly configuring pins, just like they don't
> explicitly request a particular mux option, but rather there's a mapping
> table which determines the configuration the device needs. I think pin
> config options should be included in the mapping table, or a parallel
> pin config table.

I know this, but we need this as a foundation for the driver interface.
Without something like this we cannot test the patch set in isolation
and develop in steps.

> Still, this patch will give me what I need to implement the pin config
> part of the Tegra pinctrl driver, so I won't push back too hard on this
> for now, but I think eventually these APIs will just go away.

If there are no in-kernel users at some point later down the road
they can be deleted.

If there are in-kernel users ... they may be useful.

>> +static inline int pin_config_get(struct pinctrl_dev *pctldev, int pin,
>> +                              unsigned long *config)
>> +{
>> +     return 0;
>> +}
>
> Shouldn't at least pin_config_get() return an error. It seems like both
> pin_config_set() and pin_config_group() don't do what they're asked, so
> they should also return an error. gpiolib takes that approach; e.g.
> gpio_direction_input() fails in the dummy case.

We already allow say pinmux_enable() to succeed if pinmux
is compiled out.

My idea was that it would be good for debugging to say disable
the pinctrl altogether, then leave pins in their power-on state
and no calls into the framework will even touch them, so you
can see what happens. (This I think is partly the intention of the
clk and regulator stubs.)

Having this return errors will make such binaries with pinconf
compiled-out just not boot if the error codes are handled
correctly, which is not very helpful.

Maybe I'm getting this all wrong?

I'll send a v5 patchset as soon as I've reviewed the comments
on the other patch.

Thanks!
Linus Walleij
