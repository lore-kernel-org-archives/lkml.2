Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab2CLN5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 09:57:03 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41691 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2CLN45 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 09:56:57 -0400
MIME-Version: 1.0
In-Reply-To: <4F57E1DB.3020605@wwwdotorg.org>
References: <1331071509-24661-1-git-send-email-linus.walleij@stericsson.com>
	<4F57E1DB.3020605@wwwdotorg.org>
Date: Mon, 12 Mar 2012 14:56:56 +0100
Message-ID: <CACRpkdY_PV0UvMYCKBnrd1bnfgVSBWhLjFfV4m_i_+jpkc453Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: introduce generic pin config
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 11:31 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 03/06/2012 03:05 PM, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> This is a split-off from the earlier patch set which adds generic
>> pin configuration for the pin controllers that want it. Since
>> we may have a system with mixed generic and custom pin controllers,
>> we pass a boolean in the pin controller ops vtable to indicate
>> if it is generic.
>>
>> ChangeLog v1->v5:
>> - Follow parent patch versioning number system.
>> - Document the semantic meaning of return values from pin config
>>   get functions, so we can iterate over pins and check their
>>   properties from debugfs as part of the generic config code.
>> - Use proper cast functions in the generic debugfs pin config
>>   file.
>> - Expand generic config to optionally cover groups too.
>> ChangeLog v5->v6:
>> - Update to match underlying changes.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
>> diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
> ...
>> +/**
>> + * enum pin_config_param - possible pin configuration parameters
>> + * @PIN_CONFIG_BIAS_DISABLE: disable any pin bias on the pin, a
>> + *     transition from say pull-up to pull-down implies that you disable
>> + *     pull-up in the process, this setting disables all biasing.
>
> What's the use-case for that? It seems like if one state's mapping table
> entry says:
>
> PIN_CONFIG_BIAS_PULL_UP, value

The mapping table only has an unsigned long really, but yes it
might look something like that syntactically speaking (albeit being
compiled into a constant)

> and another state wants to switch to pull-down, it'd be best to just be
> explicit, and say:
>
> PIN_CONFIG_BIAS_PULL_UP, disabled
> PIN_CONFIG_BIAS_PULL_DOWN, value

I tried to avoid ging state-switching capabilities to arguments.
So going put of bias mode is a state changes and thus has its
own enumerator. Conflating parameters and their arguments
is less elegant IMO.

>> + * @PIN_CONFIG_BIAS_HIGH_IMPEDANCE: the pin will be set to a high impedance
>> + *     mode, also know as "third-state" (tristate) or "high-Z" or "floating".
>> + *     On output pins this effectively disconnects the pin, which is useful
>> + *     if for example some other pin is going to drive the signal connected
>> + *     to it for a while. Pins used for input are usually always high
>> + *     impedance.
>
> Isn't this the same as DRIVE_OFF?

Yeah probably, so I'll drop DRIVE_OFF and keeå high impedance, because
it's more precise.

>> + * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with high
>> + *     impedance to VDD), if the controller supports specifying a certain
>> + *     pull-up resistance, this is given as an argument (in Ohms) when
>> + *     setting this parameter.
>> + * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with high
>> + *     impedance to GROUND), if the controller supports specifying a certain
>> + *     pull-down resistance, this is given as an argument (in Ohms) when
>> + *     setting this parameter.
>
> I don't think its a good idea to combine enabling/disabling features
> with configuring values for those features. If an SoC only has on/off
> control for pull-up, and the resistance isn't documented, what value
> does the driver author guess and require as the value here?
>
> Even when multiple pull-up/down strengths are available, it's quite
> plausible they're just documented as "weak" and "strong", and requiring
> someone to go find out what the exact values are rather than just using
> an enum disabled/enabled,weak=0/enabled,strong=1/ is going to be annoying.
>
> In other words, I think we'd be better off with:
>
> PIN_CONFIG_BIAS_PULL_UP = enabled/disabled 0/1
> PIN_CONFIG_BIAS_PULL_DOWN = enabled/disabled 0/1
> PIN_CONFIG_PULL_UP_STRENGTH = enumerated value 0..n-1
> PIN_CONFIG_PULL_DOWN_STRENGTH = enumerated value 0..n-1

Hm! I like the looks of this. I'm going to split them anyway.

But what's wrong with just using Ohms as the parameter?
That's what it's all about in the end is it not?
(The U300 GPIOs are 50 kOhm BTW, clearly specified.)

(Here I'm vaguely remembering some implementers not having a
clue what their enumerators really meant and me being alien to
the concept of incomplete hardware docs.)

I'm taking strength out for adding later, I only need
enable/disable for the U300 driver anyway.

>> + * @PIN_CONFIG_BIAS_HIGH: the pin will be wired high, connected to VDD
>> + * @PIN_CONFIG_BIAS_GROUND: the pin will be grounded, connected to GROUND
>
> Aren't these special cases of pull-up/down, with nominally zero
> resistance? I suppose I could see these having separate control bits
> though, so I suppose having explicit PIN_CONFIG_* values is reasonable.

Hm right, following my own argument above to encode pull up/down
arguments as Ohms I'll just delete them. Can be added back if we
encounter a HW like that.

>> + * @PIN_CONFIG_DRIVE_PUSH_PULL: the pin will be driven actively high and
>> + *     low, this is the most typical case and is typically achieved with two
>> + *     active transistors on the output. If the pin can support different
>> + *     drive strengths for push/pull, the strength is given in the argument
>> + *     as the number of driving stages vs nominal load impedance, so say
>> + *     quadruple driving stages (usually 8 transistors rather than two) will
>> + *     be configured with the 8 passed as argument.
>> + * @PIN_CONFIG_DRIVE_OPEN_DRAIN: the pin will be driven with open drain (open
>> + *     collector) which means it is usually wired with other output ports
>> + *     which are then pulled up with an external resistor. If the pin can
>> + *     support different drive strengths for the open drain pin, the format
>> + *     is the same as for PIN_CONFIG_DRIVE_PUSH_PULL.
>> + * @PIN_CONFIG_DRIVE_OPEN_SOURCE: the pin will be driven with open drain
>> + *     (open emitter) which is the same as open drain but pulled to ground.
>> + *     If the pin can support different drive strengths for the open drain
>> + *     pin, the format is the same as for PIN_CONFIG_DRIVE_PUSH_PULL.
>> + * @PIN_CONFIG_DRIVE_OFF: the pin is set to inactive drive mode, off.
>
> Again, I don't think that explicitly documenting the units (# of
> transistors) here is helpful. Datasheets may just be written in terms of
> weak/normal/strong...

Since I don't need these for this implementation I'll just delete them
and postpone the inclusion to the day we have a hardware that needs
them.

> Again, this mixes selection of drive type with configuring that drive
> type. For example, on some SoCs, PUSH_PULL might have a different set of
> available drive strengths for PUSH and PULL hence need two parameters.

Hm, interesting! But that very fact again underscores the underlying
silicon construct as a number of driver stages.

> Equally, the parameter for OPEN_DRAIN is the same as for PUSH_PULL, so
> why not separate selecting the drive type and setting the drive strength
> so that the setting of the drive strength can be shared between the
> drive types?

OK atleast I'm taking the argument out and replacing with just
enable/disable for now, so we can discuss that separately.

> So, I think this should be:
>
> PIN_CONFIG_DRIVE = push_pull/open_drain/open_source/tristate

Tristate is not a drive mode but equivalent to
BIAS_HIGH_IMPEDANCE.

I'll go for three parameters for each drive mode and the
argument ignored, I'm not copying the schem from pull up/down
with an enable/disable argument since you probably cannot "disable"
push-pull but rather have to set the pin to high impedance or OD, or
OS rather i.e. an implicit state transition, then it's better to have
that explicit.

> PIN_CONFIG_DRIVE_STRENGTH_UP = enumerated value 0..n-1
> PIN_CONFIG_DRIVE_STRENGTH_DOWN = enumerated value 0..n-1

Saving this stuff for later. Let's agree on a starting
point first.

> Note that PIN_CONFIG_SLEW_RATE_* are essentially parameterizations of
> the drive type just like drive strength is, and they're already separate
> config parameters.

True.

>> + * @PIN_CONFIG_SLEW_RATE_RISING: this will configure the slew rate for rising
>> + *     signals on the pin. The argument gives the rise time in fractions
>> + *     compared to maximum rise time, 0 means nominal rise time. If you can
>> + *     control slew rate in 4 steps these will likely be equidistant like
>> + *     1/4, 1/2, 3/4 or full nominal slew rate, which means argument 4 gives
>> + *     you 1/4 of nominal slew rate and the argument 4 has the same meaning
>> + *     as 0 - nominal slew rate (fastest possible, steep edges). You may want
>> + *     to adjust slew rates so that signal edges don't get too steep, causing
>> + *     disturbances in surrounding electronics known as electromagnetic
>> + *     interference (EMI) for example.
>> + * @PIN_CONFIG_SLEW_RATE_FALLING: this will configure the slew rate for falling
>> + *     signals on the pin. The argument gives the fall time in fractions
>> + *     compared to nominal fall time.
>
> The same comment here; I think the value of those two should just be an
> enumeration 0..n-1 to avoid documenting specific units.

I'm taking them out for later discussion alongside the first driver that
need them.

>> + * @PIN_CONFIG_POWER_SOURCE: if the pin can select between different power
>> + *     supplies, the argument to this parameter (on a custom format) tells
>> + *     the driver which alternative power source to use.
>> + * @PIN_CONFIG_LOW_POWER_MODE: this will configure the pin for low power
>> + *     operation, if several modes of operation are supported these can be
>> + *     passed in the argument on a custom form, else just use argument 1
>> + *     to indicate low power mode, argument 0 turns low power mode off.
>
>> + * @PIN_CONFIG_WAKEUP: this will configure an input pin such that if a
>> + *     signal transition arrives at the pin when the pin controller/system
>> + *     is sleeping, it will wake up the system if argument 1 is passed along.
>> + *     Pass argument 0 to turn wakeup enablement off.
>
> Is this something that's controlled at the pinmux level? I would have
> expected it to be controlled by whatever HW input signals were routed to
> - i.e. a GPIO controller could control which GPIO inputs provided
> wakeup, or a USB controller would wake if some bus condition was seen
> etc. I suppose it's possible that a pin controller itself could wake the
> system, but how would the wake reason be mapped to something that could
> interpret that? If co-ordination between e.g. the GPIO driver an pinctrl
> driver is needed to achieve this, shouldn't the GPIO driver call into
> some private API in the pinctrl driver to set this up, similar to how
> pinctrl_gpio_direction_input() works?
>
> Still, if there's a specific reason for this I don't see any need to
> oppose it; it just seems surprising it'd be needed.

No I think it's plain wrong actually.

The struct irq_chip already provides methods for setting pins to
wakeup, so I'm just deleteing this.

There could be a usecase for a complex pin controller that can wake
up the system on a pin which however isn't going to generate an IRQ,
but that sounds backwards to me, and we can add it the day we
need it in that case.

>> + * @PIN_CONFIG_END: this is the last enumerator for pin configurations, if
>> + *     you need to pass in custom configurations to the pin controller, use
>> + *     PIN_CONFIG_END+1 as the base offset.
>> + */
>> +enum pin_config_param {
>> +       PIN_CONFIG_BIAS_DISABLE,
>> +       PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
>> +       PIN_CONFIG_BIAS_PULL_UP,
>> +       PIN_CONFIG_BIAS_PULL_DOWN,
>> +       PIN_CONFIG_BIAS_HIGH,
>> +       PIN_CONFIG_BIAS_GROUND,
>> +       PIN_CONFIG_DRIVE_PUSH_PULL,
>> +       PIN_CONFIG_DRIVE_OPEN_DRAIN,
>> +       PIN_CONFIG_DRIVE_OPEN_SOURCE,
>> +       PIN_CONFIG_DRIVE_OFF,
>> +       PIN_CONFIG_INPUT_SCHMITT,
>> +       PIN_CONFIG_INPUT_DEBOUNCE,
>> +       PIN_CONFIG_SLEW_RATE_RISING,
>> +       PIN_CONFIG_SLEW_RATE_FALLING,
>> +       PIN_CONFIG_POWER_SOURCE,
>> +       PIN_CONFIG_LOW_POWER_MODE,
>> +       PIN_CONFIG_WAKEUP,
>> +       PIN_CONFIG_END,
>> +};
>
> I think this should be given a large static value, e.g. 0x8000. That way
> the value will never change, and hence the values of custom enumerations
> will never change.

PIN_CONFIG_END you mean?

> That isn't important for mapping tables/... provided by data in the
> kernel since a recompile would trivially adapt to changes, but it might
> be for device tree; someone might want to represent the raw custom
> pin_config_param enumeration values directly in device tree (so they
> could read an int from device tree and cast it directly to an enum
> pin_config_param without using a lookup table to do the conversion), and
> the meanings of values in device tree need to stay static.
>
> Of course, you could argue that drivers parsing DT and creating mapping
> tables from it must always do an explicit mapping, in which case having
> PIN_CONFIG_END floating is fine.

We can have both. But I will set it to 0x7fff and let 0x8000 be the first
custom parameter...

>> +static inline enum pin_config_param to_config_param(unsigned long config)
>> +{
>> +       return (enum pin_config_param) (config & 0xffffUL);
>> +}
>> +
>> +static inline u16 to_config_argument(unsigned long config)
>> +{
>> +       return (enum pin_config_param) ((config >> 16) & 0xffffUL);
>> +}
>> +
>> +static inline unsigned long to_config_packed(enum pin_config_param param,
>> +                                            u16 argument)
>> +{
>> +       return (argument << 16) | ((unsigned long) param & 0xffffUL);
>> +}
>
> Those function names all have very generic names; shouldn't they be
> name-spaced e.g. pinconfig_to_param()/pinconfig_to_argument()?

Yep, I'll fix.

> Shouldn't to_config_packed() either be removed, or rewritten to use
> PIN_CONF_PACKED() to remove the duplication?

Ah. The latter was for tables so needed to be compile-time
resolvable. Didn't see the duplication. Will move the macro
above the function and use the macro in the static inline!

>> diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
>
>> +void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
>> +                             struct seq_file *s, unsigned pin)
> ...
>> +               /* We want to check out this parameter */
>> +               config = to_config_packed(conf_items[i].param, 0);
>> +               ret = pin_config_get_for_pin(pctldev, pin, &config);
>> +               /* These are legal errors */
>> +               if (ret == -EINVAL || ret == -ENOTSUPP)
>> +                       continue;
>
> What's the meaning of -EINVAL and -ENOTSUPP in this context? I don't
> understand why you'd need two "legal errors" rather than just -ENOTSUPP.

The reasoning is that -ENOTSUPP cannot be done by this
pin controller at all while -EINVAL is returned when the pin controller
does support the parameter, bit it has no meaning right now.

For example the pin controller might not support pull down
at all and then returns -ENOTSUPP for any attempt to read that
code.

However it might be that it does support pull-down, but right now
it is in output (drive) mode so there is nothing relevant to say
about pull-down right now.

I gave these two different error codes so we could tell them
apart, semantically speaking, practically you can write code doing
the same thing with just -ENOTSUPP but then this return code
means one of two things and you don't know which one it is.

The use cases in debugfs is:

(A) Show all settings right now (current implementation)
   iterate/skip over all error codes like above

(B) Show all *possible* settings (can be added if we can
  tell these two apart) show "available" for anything
  -EINVAL but do not show at all anything reporting
  -ENOTSUPP.

I think I had this documented at some point and it got lost..
will reinsert it somewhere.

> ...
>> +               seq_puts(s, conf_items[i].display);
>> +               /* Print unit if available */
>> +               if (conf_items[i].format && to_config_argument(config) != 0)
>> +                       seq_printf(s, " (%u %s)", to_config_argument(config),
>> +                                  conf_items[i].format);
>
> Wouldn't you always want to dump the value, or if not, wouldn't you only
> want to print conf_items[i].display if you're going to print the value too?

We have some parameters where the value is meaningless so
we don't want to show these at all.

Let me post v7 so we can discuss from there.

Yours,
Linus Walleij
