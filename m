Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab1IAVR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 17:17:57 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15832 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962Ab1IAVRz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 17:17:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 01 Sep 2011 14:17:51 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>, Barry Song <21cnbao@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 1 Sep 2011 14:17:50 -0700
Subject: RE: [PATCH 1/4 v6] drivers: create a pin control subsystem v6
Thread-Topic: [PATCH 1/4 v6] drivers: create a pin control subsystem v6
Thread-Index: AcxoijDoATSUUx4LQPOQNJCCgbJpMAAV16KA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B327A3FD@HQMAIL01.nvidia.com>
References: <1314869536-5495-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1314869536-5495-1-git-send-email-linus.walleij@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Thursday, September 01, 2011 3:32 AM:
> This creates a subsystem for handling of pin control devices.
> These are devices that control different aspects of package
> pins.

Overall, I think this is beginning to look very good. Thanks for taking
care of my requests.

I want to check one thing: A given pin can be in multiple pin groups at
once. This will be important when biasing/... is added, since Tegra will
then having 2 sets of overlapping pin groups that cover all/most pins;
one set for muxing and one for biasing etc. Each pin will be in one of
the mux groups and one of the bias groups. I'm pretty sure this is the
case, but just wanted to double-check.

As you already acknowledge, one missing feature is handling multiple map
entries for each pinmux_get()/enable().

My final area of contention is the GPIO-specific APIs and mapping.

The only thing pinmux allows you to do with the GPIO ranges are
request_gpio and free_gpio. Some thoughts:

* These only exist to prevent an explosion in the number of functions. I
don't think we need these APIs to avoid this; see my discussion below.

* These APIs don't work in the same way as mapping table entries; what
if switching a controller between two sets of pins also required
using a different GPIO; I might want to put the equivalent of
request_gpio and free_gpio into the mapping table. This can only be done
if we represent GPIOs as just another function, rather than special-
casing them.

* If we get rid of the GPIO APIs, we can then get rid of the GPIO ranges
too, which cuts out a lot of code.

I would imagine treating GPIOs as just another function. I'll repeat
some text I wrote previously (https://lkml.org/lkml/2011/8/26/298) about
how I see this working:

>SW For reference, here's how I'd imagine modeling those three cases in
>SW pinmux (all based on my earlier comments about the data model I imagine,
>SW rather than what's currently in the pinmux patches):

>SW 1) Have a single function "gpio" that can be applied to any pin that
>SW supports it. The actual GPIO number that gets mux'd onto the pin differs
>SW per pin, and is determine by HW design. But logically, we're connecting
>SW that pin to function "gpio", so we only need one function name for that.

So here, the only issue is that if "GPIO" can be assigned per pin, we'd
need to define a pingroup per pin, even if we had a set of other groups
for muxing. (And a pin would have to be in its per-pin pingroup, and
mux group, which goes back to my very first comment above.) I suppose this
might end up being a lot of pingroups. However, this is all data, and
it seems like having large data is better than having large code? Still,
these per-pin groups might end up existing for other functionality like
biasing anyway, depending on HW.

>SW 2) Have a function for each GPIO controller that can be attached to a
>SW pin; "gpioa" or "gpiob". Based on the pin being configured, and which of
>SW those two GPIO functions is selected, the HW determines the specific GPIO
>SW number that's assigned to the pin.

>SW 3) Where the GPIO ID assigned to pins is user-selectable, have a function
>SW per GPIO ID; "gpio1", "gpio2", "gpio3", ... "gpio31". This sounds like
>SW it'd cause a huge explosion in the number of functions; one to represent
>SW each GPIO ID. However, I suspect this won't be too bad in practice, since
>SW there's presumably some practical limit to the amount of muxing logic that
>SW can be applied to each pin in HW, so the set of options won't be too large.

In https://lkml.org/lkml/2011/8/29/74, it sounded like you weren't averse
to the idea of treating GPIOs like any other function.



A number of smaller comments directed at specific parts of the patch
text are below.

> +++ b/Documentation/pinctrl.txt

> +The pin control subsystem will call the .list_groups() function repeatedly
> +beginning on 0 until it returns non-zero to determine legal selectors

Given you said that pingroups are mandatory, I wonder why struct pinctrl_desc
doesn't just have an ngroups field to; that'd save having to iterate over calls
to list_groups to find the total number of groups.

> +Pinmux conventions
> +==================

Just wanted to say that I agree with the description of the data model given
in this section of the docs, with the exceptions listed early in this email.

> +- FUNCTIONS using a certain PIN GROUP on a certain PIN CONTROLLER are provided
> +  on a first-come first-serve basis,

It might be better to say that pins are provided on a first-come first-
serve bases, and hence pin groups too. Function doesn't really come into
it; the function is just how you program the pins/groups after you've
applied first-come first-serve.

> +Pinmux drivers
> +==============
> +
> +It is the responsibility of the pinmux driver to determine whether or not
> +the requested function can actually be enabled, and in that case poke the
> +hardware so that this happens.

Perhaps augment that to make it clear that since the pinmux core handles
mutually exclusive access to pins/groups, what the driver is responsible
for is *just* any additional limitations the HW may impose beyond that
simple constraint.

> +The driver will for all calls be provided an offset pin number into its own
> +pin range. If you have 2 chips with 8x8 pins, the first chips pins will have
> +numbers 0 thru 63 and the second one pins 64 thru 127, but the driver for the
> +second chip will be passed numbers in the range 0 thru 63 anyway, base offset
> +subtracted.

Given the move to separate names-spaces per chip, that description isn't
quite right.

> +Now the able reader will say: "wait - the driver needs to make sure it
> +can set this and that bit at the same time, because else it will collide
> +and wreak havoc in my electronics, and make sure noone else is using the
> +other setting that it's incompatible with".

Maybe you want that paragraph (and some following it) to be before the
first paragraph in this section, so as to more easily fix the issue I
pointed out in the current first paragraph?

> +Pinmux board/machine configuration
> +==================================
...
> +static struct pinmux_map pmx_mapping[] = {
> +	{
> +		.ctrl_dev_name = "pinctrl.0",
> +		.function = "spi0",
> +		.position = 1,

This example also needs updating for ".group".

> +Runtime pinmuxing
> +=================
...
> +static struct pinmux_map pmx_mapping[] = {
> +	{
> +		.name = "spi0-pos-A",
> +		.ctrl_dev_name = "pinctrl.0",
> +		.function = "spi0",
> +		.position = 0,

This example also needs updating for ".group".

> diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h

> +struct pin_desc {
> +	struct pinctrl_dev *pctldev;
> +	char	name[16];
> +	/* These fields only added when supporting pinmux drivers */
> +#ifdef CONFIG_PINMUX
> +	bool	mux_requested;
> +	char	mux_function[16];
> +#endif
> +};

If the API supports assigning functions to pingroups not pins, then shouldn't
those two ifdef'd fields be part of the pingroup, not the pin?

Shouldn't mux_function should be a "const char *" rather than being copied?

> diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h

> +/**
> + * struct pinmux_map - boards/machines shall provide this map for devices
> + * @name: the name of this specific map entry for the particular machine.
> + *	This is the second parameter passed to pinmux_get() when you want
> + *	to have several mappings to the same device
> + * @ctrl_dev: the pin control device to be used by this mapping, may be NULL
> + *	if you provide .ctrl_dev_name instead (this is more common)
> + * @ctrl_dev_name: the name of the device controlling this specific mapping,
> + *	the name must be the same as in your struct device*

May be NULL if you provide ctrl_dev?

> + * @function: a function in the driver to use for this mapping, the driver
> + *	will lookup the function referenced by this ID on the specified
> + *	pin control device
> + * @group: sometimes a function can map to different pin groups, so this
> + *	selects a certain specific pin group to activate for the function, if
> + *	left as NULL, the first applicable group will be used

Should we specify that if this is NULL, the pinmux core will error out unless
there's only a single pingroup associated with that function?

> + * @dev: the device using this specific mapping, may be NULL if you provide
> + *	.dev_name instead (this is more common)
> + * @dev_name: the name of the device using this specific mapping, the name
> + *	must be the same as in your struct device*

May be NULL if dev supplied?

> + */
> +struct pinmux_map {
> +	const char *name;
> +	struct device *ctrl_dev;
> +	const char *ctrl_dev_name;
> +	const char *function;
> +	const char *group;
> +	struct device *dev;
> +	const char *dev_name;
> +};

> diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h

> +struct pinctrl_pin_desc {
> +	unsigned number;
> +	const char *name;
> +};

I guess the number field is required to support sparse numbering of pins.
If we didn't need sparse numbering, we could assume pins were numbered
0..n just like functions/groups, and remove the number field, which might
make initializing the driver's array of pins a little easier.

> +struct pinctrl_gpio_range {
> +	const char name[16];

Why not "const char *name"?

> +	unsigned int id;
> +	unsigned int base;
> +	unsigned int npins;
> +	struct gpio_chip *gc;

That might be hard to initialize; can this be optionally be specified by
name too?

> +/**
> + * struct pinctrl_dev - pin control class device
...
> + * This should be dereferenced and used by the pin controller core ONLY
> + */

If this is internal; perhaps the definition should be in an internal header?
There's no need for clients to know anything other than "struct pinctrl_dev"
since all the APIs use pointers to it, right?

> diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h

> +/**
> + * struct pinmux_ops - pinmux operations, to be implemented by pin controller
> + * drivers that support pinmuxing
> + * @request: called by the core to see if a certain pin can be made available
> + *	available for muxing. This is called by the core to acquire the pins
> + *	before selecting any actual mux setting across a function. The driver
> + *	is allowed to answer "no" by returning a negative error code
> + * @free: the reverse function of the request() callback, frees a pin after
> + *	being requested

Shouldn't request/free be for a pingroup, not a pin, since that's what
functions are assigned to? Also, the function should be passed, since
some restrictions these functions might need to check for might depend
on what the pin/group will be used for.

When the core is modified to support applying n entries in the mapping
table for each pinmux_get() call, how will request/free be aware of the
partial pending state?

HW, and any SW cache of programmed HW state, will contain all state before
any of the n entries are applied. Some HW restrictions might apply only
once all all the n map entries are known/applied.

Note: I didn't review any of the .c files.

-- 
nvpublic

