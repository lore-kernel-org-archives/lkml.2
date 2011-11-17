Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab1KQN0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 08:26:32 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33146 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab1KQN0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 08:26:31 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740805B30@HQMAIL01.nvidia.com>
References: <1321000263-20000-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805B30@HQMAIL01.nvidia.com>
Date: Thu, 17 Nov 2011 14:26:29 +0100
Message-ID: <CACRpkdYh7+kL-9iy7+VDC82OAkb+-vLiJcv02pappaTeDUriTg@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: add a generic pin config interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

as usual the most thought-provoking review comments come from nVidia,
many thanks for your time!

On Mon, Nov 14, 2011 at 8:44 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Friday, November 11, 2011 1:31 AM:
>> + * enum pin_config_param - possible pin configuration parameters
>
> I'm still not entirely convinced that abstracting all these minutiae is
> productive.

We'll see where we end up ... I have similar fears about *not* doing
it and ending up with some message passing core of too loose or
none semantics. So bear with me for some patch iterations...

> I assert that drivers should not be directly manipulating configuration
> parameters. Instead, they should be requesting some generic named state,
> and some board-provided data should be mapping that named state to the set
> of configuration values to apply. Assuming that's true, then there doesn't
> need to be any generic way of naming/describing what those configuration
> values are, since only the SoC-specific pinctrl driver and board-specific
> mapping table will ever deal with the individual values.

But that is not about this enum.

This enum is a way to describe states for the pins, which is also
the interface between the pinconf core and the individual drivers,
i.e. even with what you say above these enums are useful for
parameters passed in the functions in struct pinconf_ops.

If I rephrased the above to say that these two functions:

extern int pin_config(struct pinctrl_dev *pctldev, int pin,
                      enum pin_config_param param, unsigned long data);
extern int pin_config_group(struct pinctrl_dev *pctldev, const char *pin_group,
                            enum pin_config_param param, unsigned long data);

Should not be part of the public API available to the drivers and
platforms, then I'm game. That's a very valid point. Fixing that
will require some upfront code (again ... hehe)

I'll post some V3 with this current scheme though, and think about
how to proceed with abstracting the group states and getting
rid of the above for V4.

>> + * @PIN_CONFIG_BIAS_DISABLE: disable any pin bias on the pin, a
>> + *   transition from say pull-up to pull-down implies that you disable
>> + *   pull-up in the process, this setting disables all biasing
>> + * @PIN_CONFIG_BIAS_HIGH_IMPEDANCE: the pin will be set to a high impedance
>> + *   mode, also know as "third-state" (tristate) or "high-Z" or "floating".
>> + *   On output pins this effectively disconnects the pin, which is useful
>> + *   if for example some other pin is going to drive the signal connected
>> + *   to it for a while. Pins used for input are usually always high
>> + *   impedance.
>> + * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with high
>> + *   impedance to VDD), if the controller supports specifying a certain
>> + *   pull-up resistance, this is given as an argument (in Ohms) when
>> + *   setting this parameter
>> + * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with high
>> + *   impedance to GROUND), if the controller supports specifying a certain
>> + *   pull-down resistance, this is given as an argument (in Ohms) when
>> + *   setting this parameter
>
> I agree that its unlikely to be common to enable both pull-up and pull-
> down at the same time, but why should the PIN_CONFIG_ abstraction actively
> prohibit it?

I've read the above and fail to see why that would be prohibited
from the enum alone.

In practice it does not work however since I track the state like this:

struct pin_config {
        enum pin_config_param bias_param;
        unsigned long bias_data;
        (...)
};

I'd opt for leaving it like this and have the first driver that wants
to set multiple bias configs simultaneously refactor it to make
that possible, in the process proving me wrong on the account
that this is not a useful feature.

> An Soc could easily be designed with a bit to enable each,
> and hence allow enabling both at once. Perhaps with configurable pull
> strengths, this could even be used to create a poor-man's A-D converter,
> or perhaps it could be used to create a reference voltage for something.

OK the day someone needs to do this it can be refactored,
I don't think this needs to be part of the upfront design.
At that point drivers/staging/iio/adc will probably be available
in drivers/* and it can be modelled using the proper abstraction
for these registers anyway.

> While I admit this /is/ pretty unlikely to happen in practice, this is
> one of the reasons I'm not convinced that abstracting all this is a great
> idea; if the abstraction isn't general enough, it might prohibit us from
> representing unforeseen features in the future.

There will always be unforeseen use cases, what I want to avoid
is coding something that is hard to amend for new use cases
down the road. What I want to make sure is that we have an
API that can support what we have in the kernel today, and
avoid lock-ins where possible.

>> + * @PIN_CONFIG_BIAS_HIGH: the pin will be wired high, connected to VDD
>> + * @PIN_CONFIG_BIAS_GROUND: the pin will be grounded, connected to GROUND
>> + * @PIN_CONFIG_DRIVE_PUSH_PULL: the pin will be driven actively high and
>> + *   low, this is the most typical case and is typically achieved with two
>> + *   active transistors on the output. If the pin can support different
>> + *   drive strengths for push/pull, the strength is given on a custom format
>> + *   as argument when setting pins to this mode
>
> If the drive-strength argument is custom, this vastly reduces the
> usefulness of creating this single abstraction; sure a driver could
> specify PUSH_PULL, but if it then wanted to configure the strength, but
> couldn't because there was no standardized way of representing that, it
> seems pointless to create the common abstraction for PUSH_PULL in the
> first place; what is it achieving? In fact, if a driver just wants to
> toggle between PUSH_PULL/OPEN_DRAIN, what value should it provide for
> the value if there's no standardization?

As discussed in the other thread with Thomas the way this is done
for most systems is in drive stage multiples vs nominal load
impedance (usually capacitive, but we don't need to specify that) for one drive
stage as described in this forum thread:
http://www.edaboard.com/thread74140.html

Which means the argument should be number of drive stages.

So I'll just standardize on that and see if it sticks. For something like
push/pull CMOS or TTL totempole it seems to hit the nail on the head
atleast, if the electronics people come up with more exotic drive stages
it should probably not use the push/pull denominator anyway.

So, point taken. Will standardize.

>> + * @PIN_CONFIG_DRIVE_OPEN_DRAIN: the pin will be driven with open drain (open
>> + *   collector) which means it is usually wired with other output ports
>> + *   which are then pulled up with an external resistor. If the pin can
>> + *   support different drive strengths for the open drain pin, the strength
>> + *   is given on a custom format as argument when setting pins to this mode
>> + * @PIN_CONFIG_DRIVE_OPEN_SOURCE: the pin will be driven with open drain
>> + *   (open emitter) which is the same as open drain mutatis mutandis but
>
> I think it'd be better to spell this out, rather than make non-latin-speakers
> go look that up, and still perhaps not know /what/ the appropriate changes to
> the description actually are.

OK. I was too infatuated with my own language games...
I guess for the intended audience using the form of s/foo/bar/g is more
understandable, but I'll spell it out.

>> + * @PIN_CONFIG_INPUT_SCHMITT: this will configure an input pin to run in
>> + *   schmitt-trigger mode. If the schmitt-trigger has adjustable hysteresis,
>> + *   the threshold value is given on a custom format as argument when
>> + *   setting pins to this mode
>> + * @PIN_CONFIG_INPUT_SCHMITT_OFF: disables schmitt-trigger mode
>
> Shouldn't that be just PIN_CONFIG_INPUT_SCHMITT with a boolean parameter
> to indicate whether it's enabled?

To match the PIN_CONFIG_DRIVE_OFF this is more logical I think,
there is no shortage of enums.

>> + * @PIN_CONFIG_SLEW_RATE_RISING: this will configure the slew rate for rising
>> + *   signals on the pin. The argument gives the rise time in nanoseconds.
>> + *   You may want to adjust slew rates so that signal edges don't get too
>> + *   steep, causing disturbances in surrounding electronics for example.
>> + * @PIN_CONFIG_SLEW_RATE_FALLING: this will configure the slew rate for falling
>> + *   signals on the pin. The argument gives the fall time in nanoseconds
>
> In order to specify rates, you'd also need to define what load capacitance
> was being driven; rate isn't an independent value. I wonder if a standard
> load inductance would also need to be specified.
>
> Tegra's slew rates are not specified in nanoSeconds. Now it may be that
> for a given load capacitance, each rate does indeed map to a specific
> rise time. However, the documentation isn't written that way. Getting the
> documentation changed to specify times simply isn't going to happen; it's
> hard enough to just get the documentation in the first place for some of
> the pinmux stuff. In fact, even calculating what those times are probably
> isn't possible right now (for me at least, and the low-level pad designers
> probably have better things to do).

OK so how is the slew rate specified in the specs you have?
Is it just some magic number? If it turns out all platforms only have
unspecified magic numbers for slew rate settings we'd better
just leave this argument as custom then.

>> + * @PIN_CONFIG_LOAD_CAPACITANCE: some pins have inductive characteristics and
>
> That should say "capacitive"; inductance is something else AIUI.

No actually not. See below:

>> + *   will deform waveforms when signals are transmitted on them, by
>> + *   applying a load capacitance, the waveform can be rectified. The
>> + *   argument gives the load capacitance in picofarad (pF)

So the pin (or the wire connected to it) has inductive properties,
and you compensate by adding load capacitance.

I'll reword to make this clear...

>> + * @PIN_CONFIG_LOW_POWER_MODE: this will configure the pin for low power
>> + *   operation
>> + * @PIN_CONFIG_NORMAL_POWER_MODE: returns pin from low power mode
>
> Is this meant to represent Tegra's "low power mode" configuration? That's
> a four-level value on Tegra,

OK I added that the argument to low power mode can contain a custom power
state enumerator.

> so having two PIN_CONFIG values doesn't make
> sense; we'd have to use the value for e.g. LOW_POWER_MODE to represent the
> desired HW value, and ignore NORMAL_POWER_MODE, I think.

NORMAL_POWER_MODE is intended to return the pin from any low-power
mode in analogy with say BIAS_DISABLE or DRIVE_OFF, SCHMITT_OFF
so it's to make the code symmetric and readable, not to make the minimal
number of enumerators. I think this is better syntax than say, specifying that a
zero argument to LOW_POWER_MODE means "low power mode off"

>> +/**
>> + * struct pin_config - configuration state holder for a single config of a pin
>> + * @bias_param: bias configuration parameter
>> + * @bias_data: configuration data for the parameter
>> + * @schmitt: input is in schmitt-trigger mode
>> + * @slewrate_rising: rising edge slew rate
>> + * @slewrate_falling: falling edge slew rate
>> + * @load_capacitance: load capacitane of the pin
>> + * @power_source: selected power source for the pin
>> + * @low_power: pin is in low power mode
>> + * @wakeup: pin will wake up system when sleeping
>> + *
>> + * This holds one configuration item for one pin, a pin may have several such
>> + * configurations since it may be configured for several non-conflicting modes
>> + * simultaneously.
>> + */
>> +struct pin_config {
>> +     enum pin_config_param bias_param;
>> +     unsigned long bias_data;
>> +     enum pin_config_param drive_param;
>> +     unsigned long drive_data;
>> +     bool schmitt;
>> +     unsigned long slewrate_rising;
>> +     unsigned long slewrate_falling;
>> +     unsigned long load_capacitance;
>> +     unsigned long power_source;
>> +     bool low_power;
>> +     bool wakeup;
>> +};
>
> Not all SoCs support all those options. On Tegra, different groups
> support different subsets of those options. In the pin_get_initial_config()
> API below, how does a pinctrl driver indicate unknown or not-applicable
> for individual fields?

Currently the fields contain default values until filled in with
wither get_initial_configuration() of by configuration calls.

I've toyed with the idea of adding per-pin capabilities, like a flag
for each supported configuration option as another field of
struct pinctrl_pin_desc say:

struct pinctrl_pin_desc {
	unsigned number;
	const char *name;
#ifdef CONFIG_PINCONF
	enum pin_config_param *supported_params;
	unsigned num_supported_params;
#endif
};

So a controller would declare supported params per pin like:

static enum pin_config_param myparams[] = {
	PIN_CONFIG_BIAS_DISABLE,
	PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
	PIN_CONFIG_DRIVE_PUSH_PULL,
	PIN_CONFIG_DRIVE_OFF,
};

struct pinctrl_pin_desc mypins[] = {
	{
		.number = 1,
		.name = "foo",
		.supported_params = myparams;
		.num_supported_params = ARRAY_SIZE(myparams),
	},
	...
}

I'm a bit hesitant since it may be overdesigned, overkill,
and the little footprint conscience I still have inside me does not like
the idea either and would prefer to trust driver writers to do things
right and return proper errors for illegal configurations without full
constraints on everything.

But it's a loose opinion and I may be wrong. I haven't seen any
other pin config driver in the kernel that tries to prevent you from
doing things you cannot do though.

>> +/**
>> + * struct pinconf_ops - pin config operations, to be implemented by
>> + * pin configuration capable drivers.
>> + * @pin_get_initial_config: called to get the initial config of each pin
>> + *   if you cannot read out the configuration of your pins at startup, just
>> + *   leave this as NULL
>> + * @pin_config: configure an individual pin
>> + * @pin_config_group: configure all pins in a group
>> + * @pin_config_dbg_show: optional debugfs display hook that will provide
>> + *   per-device info for a certain pin in debugfs
>> + */
>> +struct pinconf_ops {
>> +     int (*pin_get_initial_config) (struct pinctrl_dev *pctldev,
>> +                                    struct pin_config *conf,
>> +                                    unsigned pin);
>> +     int (*pin_config) (struct pinctrl_dev *pctldev,
>> +                        const struct pin_config *conf,
>> +                        unsigned pin,
>> +                        enum pin_config_param param,
>> +                        unsigned long data);
>> +     int (*pin_config_group) (struct pinctrl_dev *pctldev,
>> +                              unsigned selector,
>> +                              enum pin_config_param param,
>> +                              unsigned long data);
>> +     void (*pin_config_dbg_show) (struct pinctrl_dev *pctldev,
>> +                                  struct seq_file *s,
>> +                                  unsigned offset);
>> +};
>
> There was some discussion about having to call pin_config_group many
> Times to set up e.g. 5 different parameters on a single group. Should
> pin_config_group accept a list of param/data pairs, or a struct pin_config
> instead? The latter would also need some NA/don't-change indication for
> each field.

struct pin_config was mainly thought of as a state container, bolting
a lot of "changed" fields on it seems kludgy.

So both pin_config() and pin_config_group() should rather take a list
of config params + data.

Which sort of brings the discussion to the point of whether the
passed configuration element should rather be a tuple than two
discrete arguments everywhere. Which folds back into the infrastructure
for providing the per-group state mapping etc described in the beginning
of the mail, since this would likely be the basic configuration atom, so
I need to think a bit about that and try to come up with something we
can use going forward.

Thanks!
Linus Walleij
