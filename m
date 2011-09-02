Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab1IBM73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 08:59:29 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55471 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab1IBM72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 08:59:28 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B327A3FD@HQMAIL01.nvidia.com>
References: <1314869536-5495-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B327A3FD@HQMAIL01.nvidia.com>
Date: Fri, 2 Sep 2011 14:59:25 +0200
Message-ID: <CACRpkdYBaWq3BuXNvMtgaS1nMzU-vArRB9_y5WE3Zqp9idaOuA@mail.gmail.com>
Subject: Re: [PATCH 1/4 v6] drivers: create a pin control subsystem v6
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
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>, Barry Song <21cnbao@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Stephen,

we really make progress now, thanks to your eternal patience with
me :-)

On Thu, Sep 1, 2011 at 11:17 PM, Stephen Warren <swarren@nvidia.com> wrote:

> I want to check one thing: A given pin can be in multiple pin groups at
> once. This will be important when biasing/... is added, since Tegra will
> then having 2 sets of overlapping pin groups that cover all/most pins;
> one set for muxing and one for biasing etc. Each pin will be in one of
> the mux groups and one of the bias groups. I'm pretty sure this is the
> case, but just wanted to double-check.

Yes any pin can be in any number of pin groups.

> As you already acknowledge, one missing feature is handling multiple map
> entries for each pinmux_get()/enable().

It'll be in v7 I hope.

> The only thing pinmux allows you to do with the GPIO ranges are
> request_gpio and free_gpio. Some thoughts:
>
> * These only exist to prevent an explosion in the number of functions. I
> don't think we need these APIs to avoid this; see my discussion below.
>
> * These APIs don't work in the same way as mapping table entries; what
> if switching a controller between two sets of pins also required
> using a different GPIO; I might want to put the equivalent of
> request_gpio and free_gpio into the mapping table. This can only be done
> if we represent GPIOs as just another function, rather than special-
> casing them.

I actually think this usecase will work, as long as these two GPIO
controllers use different ranges in the global GPIO pin space (and
Grant say they should IIRC).

The pinmux core will map the pin to the matching range and pass
it to the driver in this callback:

        int (*gpio_request_enable) (struct pinctrl_dev *pctldev,
                                    struct pinctrl_gpio_range *range,
                                    unsigned offset);

By checking which range you got you know which chip
you want to mux in on the given offset. It's true that this
is orthogonal to other functions however.

> * If we get rid of the GPIO APIs, we can then get rid of the GPIO ranges
> too, which cuts out a lot of code.

That is true.

> I would imagine treating GPIOs as just another function. I'll repeat
> some text I wrote previously (https://lkml.org/lkml/2011/8/26/298) about
> how I see this working:
>
>>SW For reference, here's how I'd imagine modeling those three cases in
>>SW pinmux (all based on my earlier comments about the data model I imagine,
>>SW rather than what's currently in the pinmux patches):
>
>>SW 1) Have a single function "gpio" that can be applied to any pin that
>>SW supports it. The actual GPIO number that gets mux'd onto the pin differs
>>SW per pin, and is determine by HW design. But logically, we're connecting
>>SW that pin to function "gpio", so we only need one function name for that.
>
> So here, the only issue is that if "GPIO" can be assigned per pin, we'd
> need to define a pingroup per pin, even if we had a set of other groups
> for muxing. (And a pin would have to be in its per-pin pingroup, and
> mux group, which goes back to my very first comment above.) I suppose this
> might end up being a lot of pingroups. However, this is all data, and
> it seems like having large data is better than having large code? Still,
> these per-pin groups might end up existing for other functionality like
> biasing anyway, depending on HW.

Hm I have a hard time figuring out how that code would look...
I'm worried that the drivers could get pretty hard to read.

>>SW 2) Have a function for each GPIO controller that can be attached to a
>>SW pin; "gpioa" or "gpiob". Based on the pin being configured, and which of
>>SW those two GPIO functions is selected, the HW determines the specific GPIO
>>SW number that's assigned to the pin.
>
>>SW 3) Where the GPIO ID assigned to pins is user-selectable, have a function
>>SW per GPIO ID; "gpio1", "gpio2", "gpio3", ... "gpio31". This sounds like
>>SW it'd cause a huge explosion in the number of functions; one to represent
>>SW each GPIO ID. However, I suspect this won't be too bad in practice, since
>>SW there's presumably some practical limit to the amount of muxing logic that
>>SW can be applied to each pin in HW, so the set of options won't be too large.
>
> In https://lkml.org/lkml/2011/8/29/74, it sounded like you weren't averse
> to the idea of treating GPIOs like any other function.

Right now I have resorted to the diplomatic solution of actually
supporting both.

pinmux_request_gpio() will request a gpio pin named
"gpioN" where N is the global GPIO number.

This fragment from pinmux.c sort of specifies it:

        if (gpio && ops->gpio_request_enable)
                /* This requests and enables a single GPIO pin */
                status = ops->gpio_request_enable(pctldev, gpio_range, pin);
        else if (ops->request)
                status = ops->request(pctldev, pin);
        else
                status = 0;

So if the driver doesn't implement the quick ->gpio_request_enable()
the second else-clause will attempt to get the function "gpioN".

So if the driver just wants to present a single function per pin instead,
it can readily do so, but it must still specify which GPIO ranges it
supports.

So I think what you quote below is already possible. It's just that
I support the other shortcut too.

>> +++ b/Documentation/pinctrl.txt
>
>> +The pin control subsystem will call the .list_groups() function repeatedly
>> +beginning on 0 until it returns non-zero to determine legal selectors
>
> Given you said that pingroups are mandatory, I wonder why struct pinctrl_desc
> doesn't just have an ngroups field to; that'd save having to iterate over calls
> to list_groups to find the total number of groups.

This is mainly keeping to the design pattern from the regulators.
It has the upside that you can dynamically add/remove pin groups
at runtime, and I bet someone will have a usecase for that one day...

For regulators some voltages go away under some conditions say,
I can easily imagine SoCs where some pins groups disappear when
you go to sleep but others are always-on and so on. So it's
pretty open-ended I think.

>> +Pinmux conventions
>> +==================
>
> Just wanted to say that I agree with the description of the data model given
> in this section of the docs, with the exceptions listed early in this email.

:-)

>> +- FUNCTIONS using a certain PIN GROUP on a certain PIN CONTROLLER are provided
>> +  on a first-come first-serve basis,
>
> It might be better to say that pins are provided on a first-come first-
> serve bases, and hence pin groups too. Function doesn't really come into
> it; the function is just how you program the pins/groups after you've
> applied first-come first-serve.

OK I've rewritten this:

"PINS for a certain FUNCTION using a certain PIN GROUP on a certain
  PIN CONTROLLER are provided on a first-come first-serve basis,"
(etc)

>> +Pinmux drivers
>> +==============
>> +
>> +It is the responsibility of the pinmux driver to determine whether or not
>> +the requested function can actually be enabled, and in that case poke the
>> +hardware so that this happens.
>
> Perhaps augment that to make it clear that since the pinmux core handles
> mutually exclusive access to pins/groups, what the driver is responsible
> for is *just* any additional limitations the HW may impose beyond that
> simple constraint.

Now rewritten like this:

"The pinmux core takes care of preventing conflicts on pins and calling
the pin controller driver to execute different settings.

It is the responsibility of the pinmux driver to impose further restrictions
(say for example infer electronic limitations due to load etc) to determine
whether or not the requested function can actually be allowed, and in case it
is possible to perform the requested mux setting, poke the hardware so that
this happens."

>> +The driver will for all calls be provided an offset pin number into its own
>> +pin range. If you have 2 chips with 8x8 pins, the first chips pins will have
>> +numbers 0 thru 63 and the second one pins 64 thru 127, but the driver for the
>> +second chip will be passed numbers in the range 0 thru 63 anyway, base offset
>> +subtracted.
>
> Given the move to separate names-spaces per chip, that description isn't
> quite right.

Good catch! I just deleted the paragraph.

>> +Now the able reader will say: "wait - the driver needs to make sure it
>> +can set this and that bit at the same time, because else it will collide
>> +and wreak havoc in my electronics, and make sure noone else is using the
>> +other setting that it's incompatible with".
>
> Maybe you want that paragraph (and some following it) to be before the
> first paragraph in this section, so as to more easily fix the issue I
> pointed out in the current first paragraph?

The first paragraph covers it, I'll delete this, it was some
attempt at being educational, it doesn't work so cutting it.

>> +Pinmux board/machine configuration
>> +==================================
> ...
>> +static struct pinmux_map pmx_mapping[] = {
>> +     {
>> +             .ctrl_dev_name = "pinctrl.0",
>> +             .function = "spi0",
>> +             .position = 1,
>
> This example also needs updating for ".group".

I just deleted .position since specifying group is
not mandatory (in that case the first group will be
used), then I added an extra snippet for a function
with several groups like this:

"As it is possible to map a function to different groups of pins an optional
.group can be specified like this:

...
{
	.ctrl_dev_name = "pinctrl.0",
	.function = "spi0",
	.group = "A",
	.dev_name = "foo-spi.0",
},
{
	.ctrl_dev_name = "pinctrl.0",
	.function = "spi0",
	.group = "B",
	.dev_name = "foo-spi.0",
},
..."

>> +Runtime pinmuxing
>> +=================
> ...
>> +static struct pinmux_map pmx_mapping[] = {
>> +     {
>> +             .name = "spi0-pos-A",
>> +             .ctrl_dev_name = "pinctrl.0",
>> +             .function = "spi0",
>> +             .position = 0,
>
> This example also needs updating for ".group".

Fixed it!

(Also fixed some other cruft in the documentation I'd missed, like
the entire example implementation...)

>> diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
>
>> +struct pin_desc {
>> +     struct pinctrl_dev *pctldev;
>> +     char    name[16];
>> +     /* These fields only added when supporting pinmux drivers */
>> +#ifdef CONFIG_PINMUX
>> +     bool    mux_requested;
>> +     char    mux_function[16];
>> +#endif
>> +};
>
> If the API supports assigning functions to pingroups not pins, then shouldn't
> those two ifdef'd fields be part of the pingroup, not the pin?

It's a consequence of the fact that GPIO pins need not be
one-pin groups. If they were, what you're saying would be
true.

> Shouldn't mux_function should be a "const char *" rather than being copied?

Also a side effect of GPIO: when requesting a GPIO
function name is just made up on the fly like this:

snprintf(gpiostr, 15, "%s:%d", range->name, gpio);

So in order to remember this name we have to copy it.

If that wasn't the case we would store the unsigned int
representing the function enumerator and another
unsigned int representing the group enumerator.

>> diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
>
>> +/**
>> + * struct pinmux_map - boards/machines shall provide this map for devices
>> + * @name: the name of this specific map entry for the particular machine.
>> + *   This is the second parameter passed to pinmux_get() when you want
>> + *   to have several mappings to the same device
>> + * @ctrl_dev: the pin control device to be used by this mapping, may be NULL
>> + *   if you provide .ctrl_dev_name instead (this is more common)
>> + * @ctrl_dev_name: the name of the device controlling this specific mapping,
>> + *   the name must be the same as in your struct device*
>
> May be NULL if you provide ctrl_dev?

Yep fixed it.

>> + * @function: a function in the driver to use for this mapping, the driver
>> + *   will lookup the function referenced by this ID on the specified
>> + *   pin control device
>> + * @group: sometimes a function can map to different pin groups, so this
>> + *   selects a certain specific pin group to activate for the function, if
>> + *   left as NULL, the first applicable group will be used
>
> Should we specify that if this is NULL, the pinmux core will error out unless
> there's only a single pingroup associated with that function?

Currently the semantics is that it will take the first one, half-guessing that
this would be useful if there is a default group that 95% of the machines
will use.

Maybe this is not true.

As it is now it will issue a debug print stating that there were several
groups and it chose the first one.

>> + * @dev: the device using this specific mapping, may be NULL if you provide
>> + *   .dev_name instead (this is more common)
>> + * @dev_name: the name of the device using this specific mapping, the name
>> + *   must be the same as in your struct device*
>
> May be NULL if dev supplied?

Yep. Fixed it.

>> diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
>
>> +struct pinctrl_pin_desc {
>> +     unsigned number;
>> +     const char *name;
>> +};
>
> I guess the number field is required to support sparse numbering of pins.
> If we didn't need sparse numbering, we could assume pins were numbered
> 0..n just like functions/groups, and remove the number field, which might
> make initializing the driver's array of pins a little easier.

Yes this has been added to support sparse pins and it's designed
to be close to how sparse IRQs are handled.

>> +struct pinctrl_gpio_range {
>> +     const char name[16];
>
> Why not "const char *name"?

Yeah why not. I changed it...

>> +     unsigned int id;
>> +     unsigned int base;
>> +     unsigned int npins;
>> +     struct gpio_chip *gc;
>
> That might be hard to initialize; can this be optionally be specified by
> name too?

It's just a void * actually, it's not necessary to use this pointer for
anything, the core does not use it. I think it was Jamie that
requested it to be added so you could optionally keep track of
the gpio_chip.

>> +/**
>> + * struct pinctrl_dev - pin control class device
> ...
>> + * This should be dereferenced and used by the pin controller core ONLY
>> + */
>
> If this is internal; perhaps the definition should be in an internal header?
> There's no need for clients to know anything other than "struct pinctrl_dev"
> since all the APIs use pointers to it, right?

Indeed. The only hindrance was the two static inlines just below
dereferencing members directly. So I made them into real exported
functions and privatized the struct to "core.h".

>> diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
>
>> +/**
>> + * struct pinmux_ops - pinmux operations, to be implemented by pin controller
>> + * drivers that support pinmuxing
>> + * @request: called by the core to see if a certain pin can be made available
>> + *   available for muxing. This is called by the core to acquire the pins
>> + *   before selecting any actual mux setting across a function. The driver
>> + *   is allowed to answer "no" by returning a negative error code
>> + * @free: the reverse function of the request() callback, frees a pin after
>> + *   being requested
>
> Shouldn't request/free be for a pingroup, not a pin, since that's what
> functions are assigned to? Also, the function should be passed, since
> some restrictions these functions might need to check for might depend
> on what the pin/group will be used for.

This is not for checking anything on function or group level.
It's exclusively for things that need to be on a per-pin level, so any
pin can deny being selected for muxing at any time.

So what you're saying is that you need a function to check
also on group level as part of the pinmux_get() sematics?

We can add that and have two optional checks: @request_pin()
on pin level and say @request_function_and_group() on the
group+function level, would that work for your scenarios?

> When the core is modified to support applying n entries in the mapping
> table for each pinmux_get() call, how will request/free be aware of the
> partial pending state?

That is like answering how code I haven't yet written will
look like... The easiest answer is to implement it I think,
then you can check if it looks sane.

> HW, and any SW cache of programmed HW state, will contain all state before
> any of the n entries are applied. Some HW restrictions might apply only
> once all all the n map entries are known/applied.

So I take it that when I implement muxing of several maps
per function, you need a group+function-level request callback,
so I'll try to remember to add that.

Thanks!
Linus Walleij
