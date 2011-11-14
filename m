Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1KNToM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 14:44:12 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11667 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab1KNToK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 14:44:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 14 Nov 2011 11:44:06 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 14 Nov 2011 11:44:02 -0800
Subject: RE: [PATCH v2] pinctrl: add a generic pin config interface
Thread-Topic: [PATCH v2] pinctrl: add a generic pin config interface
Thread-Index: AcygTE4BMX1tntNuReaz5Amp49cCVQCtce6Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740805B30@HQMAIL01.nvidia.com>
References: <1321000263-20000-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1321000263-20000-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Friday, November 11, 2011 1:31 AM:
> This add per-pin and per-group pin config interfaces for biasing,
> driving and other such electronic properties. The intention is
> clearly to enumerate all things you can do with pins, hoping that
> these are enumerable.
...
> diff --git a/include/linux/pinctrl/pinconf.h b/include/linux/pinctrl/pinconf.h
...
> + * enum pin_config_param - possible pin configuration parameters

I'm still not entirely convinced that abstracting all these minutiae is
productive.

I assert that drivers should not be directly manipulating configuration
parameters. Instead, they should be requesting some generic named state,
and some board-provided data should be mapping that named state to the set
of configuration values to apply. Assuming that's true, then there doesn't
need to be any generic way of naming/describing what those configuration
values are, since only the SoC-specific pinctrl driver and board-specific
mapping table will ever deal with the individual values.

> + * @PIN_CONFIG_BIAS_DISABLE: disable any pin bias on the pin, a
> + *	transition from say pull-up to pull-down implies that you disable
> + *	pull-up in the process, this setting disables all biasing
> + * @PIN_CONFIG_BIAS_HIGH_IMPEDANCE: the pin will be set to a high impedance
> + *	mode, also know as "third-state" (tristate) or "high-Z" or "floating".
> + *	On output pins this effectively disconnects the pin, which is useful
> + *	if for example some other pin is going to drive the signal connected
> + *	to it for a while. Pins used for input are usually always high
> + *	impedance.
> + * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with high
> + *	impedance to VDD), if the controller supports specifying a certain
> + *	pull-up resistance, this is given as an argument (in Ohms) when
> + *	setting this parameter
> + * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with high
> + *	impedance to GROUND), if the controller supports specifying a certain
> + *	pull-down resistance, this is given as an argument (in Ohms) when
> + *	setting this parameter

I agree that its unlikely to be common to enable both pull-up and pull-
down at the same time, but why should the PIN_CONFIG_ abstraction actively
prohibit it? An Soc could easily be designed with a bit to enable each,
and hence allow enabling both at once. Perhaps with configurable pull
strengths, this could even be used to create a poor-man's A-D converter,
or perhaps it could be used to create a reference voltage for something.

While I admit this /is/ pretty unlikely to happen in practice, this is
one of the reasons I'm not convinced that abstracting all this is a great
idea; if the abstraction isn't general enough, it might prohibit us from
representing unforeseen features in the future.

> + * @PIN_CONFIG_BIAS_HIGH: the pin will be wired high, connected to VDD
> + * @PIN_CONFIG_BIAS_GROUND: the pin will be grounded, connected to GROUND
> + * @PIN_CONFIG_DRIVE_PUSH_PULL: the pin will be driven actively high and
> + *	low, this is the most typical case and is typically achieved with two
> + *	active transistors on the output. If the pin can support different
> + *	drive strengths for push/pull, the strength is given on a custom format
> + *	as argument when setting pins to this mode

If the drive-strength argument is custom, this vastly reduces the
usefulness of creating this single abstraction; sure a driver could
specify PUSH_PULL, but if it then wanted to configure the strength, but
couldn't because there was no standardized way of representing that, it
seems pointless to create the common abstraction for PUSH_PULL in the
first place; what is it achieving? In fact, if a driver just wants to
toggle between PUSH_PULL/OPEN_DRAIN, what value should it provide for
the value if there's no standardization?

> + * @PIN_CONFIG_DRIVE_OPEN_DRAIN: the pin will be driven with open drain (open
> + *	collector) which means it is usually wired with other output ports
> + *	which are then pulled up with an external resistor. If the pin can
> + *	support different drive strengths for the open drain pin, the strength
> + *	is given on a custom format as argument when setting pins to this mode
> + * @PIN_CONFIG_DRIVE_OPEN_SOURCE: the pin will be driven with open drain
> + *	(open emitter) which is the same as open drain mutatis mutandis but

I think it'd be better to spell this out, rather than make non-latin-speakers
go look that up, and still perhaps not know /what/ the appropriate changes to
the description actually are.

> + *	pulled to ground. If the pin can support different drive strengths for
> + *	the open drain pin, the strength is given on a custom format as
> + *	argument when setting pins to this mode
> + * @PIN_CONFIG_DRIVE_OFF: the pin is set to inactive drive mode, off

> + * @PIN_CONFIG_INPUT_SCHMITT: this will configure an input pin to run in
> + *	schmitt-trigger mode. If the schmitt-trigger has adjustable hysteresis,
> + *	the threshold value is given on a custom format as argument when
> + *	setting pins to this mode
> + * @PIN_CONFIG_INPUT_SCHMITT_OFF: disables schmitt-trigger mode

Shouldn't that be just PIN_CONFIG_INPUT_SCHMITT with a boolean parameter
to indicate whether it's enabled?

> + * @PIN_CONFIG_SLEW_RATE_RISING: this will configure the slew rate for rising
> + *	signals on the pin. The argument gives the rise time in nanoseconds.
> + *	You may want to adjust slew rates so that signal edges don't get too
> + *	steep, causing disturbances in surrounding electronics for example.
> + * @PIN_CONFIG_SLEW_RATE_FALLING: this will configure the slew rate for falling
> + *	signals on the pin. The argument gives the fall time in nanoseconds

In order to specify rates, you'd also need to define what load capacitance
was being driven; rate isn't an independent value. I wonder if a standard
load inductance would also need to be specified.

Tegra's slew rates are not specified in nanoSeconds. Now it may be that
for a given load capacitance, each rate does indeed map to a specific
rise time. However, the documentation isn't written that way. Getting the
documentation changed to specify times simply isn't going to happen; it's
hard enough to just get the documentation in the first place for some of
the pinmux stuff. In fact, even calculating what those times are probably
isn't possible right now (for me at least, and the low-level pad designers
probably have better things to do).

> + * @PIN_CONFIG_LOAD_CAPACITANCE: some pins have inductive characteristics and

That should say "capacitive"; inductance is something else AIUI.

> + *	will deform waveforms when signals are transmitted on them, by
> + *	applying a load capacitance, the waveform can be rectified. The
> + *	argument gives the load capacitance in picofarad (pF)

> + * @PIN_CONFIG_POWER_SOURCE: if the pin can select between different power
> + *	supplies, the argument to this parameter (on a custom format) tells
> + *	the driver which alternative power source to use

> + * @PIN_CONFIG_LOW_POWER_MODE: this will configure the pin for low power
> + *	operation
> + * @PIN_CONFIG_NORMAL_POWER_MODE: returns pin from low power mode

Is this meant to represent Tegra's "low power mode" configuration? That's
a four-level value on Tegra, so having two PIN_CONFIG values doesn't make
sense; we'd have to use the value for e.g. LOW_POWER_MODE to represent the
desired HW value, and ignore NORMAL_POWER_MODE, I think.

> + * @PIN_CONFIG_WAKEUP_ENABLE: this will configure an input pin such that if a
> + *	signal transition arrives at the pin when the pin controller/system
> + *	is sleeping, it will wake up the system
> + * @PIN_CONFIG_WAKEUP_DISABLE: will disable a pin from the wakeup enable state
> + *	set by the previous parameter
> + * @PIN_CONFIG_END: this is the last enumerator for pin configurations, if
> + *	you need to pass in custom configurations to the pin controller, use
> + *	PIN_CONFIG_END+1 as the base offset
> + */
> +enum pin_config_param {
> +	PIN_CONFIG_BIAS_DISABLE,
...
> +	PIN_CONFIG_END,
> +};
> +
> +/**
> + * struct pin_config - configuration state holder for a single config of a pin
> + * @bias_param: bias configuration parameter
> + * @bias_data: configuration data for the parameter
> + * @schmitt: input is in schmitt-trigger mode
> + * @slewrate_rising: rising edge slew rate
> + * @slewrate_falling: falling edge slew rate
> + * @load_capacitance: load capacitane of the pin
> + * @power_source: selected power source for the pin
> + * @low_power: pin is in low power mode
> + * @wakeup: pin will wake up system when sleeping
> + *
> + * This holds one configuration item for one pin, a pin may have several such
> + * configurations since it may be configured for several non-conflicting modes
> + * simultaneously.
> + */
> +struct pin_config {
> +	enum pin_config_param bias_param;
> +	unsigned long bias_data;
> +	enum pin_config_param drive_param;
> +	unsigned long drive_data;
> +	bool schmitt;
> +	unsigned long slewrate_rising;
> +	unsigned long slewrate_falling;
> +	unsigned long load_capacitance;
> +	unsigned long power_source;
> +	bool low_power;
> +	bool wakeup;
> +};

Not all SoCs support all those options. On Tegra, different groups
support different subsets of those options. In the pin_get_initial_config()
API below, how does a pinctrl driver indicate unknown or not-applicable
for individual fields?

> +/**
> + * struct pinconf_ops - pin config operations, to be implemented by
> + * pin configuration capable drivers.
> + * @pin_get_initial_config: called to get the initial config of each pin
> + *	if you cannot read out the configuration of your pins at startup, just
> + *	leave this as NULL
> + * @pin_config: configure an individual pin
> + * @pin_config_group: configure all pins in a group
> + * @pin_config_dbg_show: optional debugfs display hook that will provide
> + *	per-device info for a certain pin in debugfs
> + */
> +struct pinconf_ops {
> +	int (*pin_get_initial_config) (struct pinctrl_dev *pctldev,
> +				       struct pin_config *conf,
> +				       unsigned pin);
> +	int (*pin_config) (struct pinctrl_dev *pctldev,
> +			   const struct pin_config *conf,
> +			   unsigned pin,
> +			   enum pin_config_param param,
> +			   unsigned long data);
> +	int (*pin_config_group) (struct pinctrl_dev *pctldev,
> +				 unsigned selector,
> +				 enum pin_config_param param,
> +				 unsigned long data);
> +	void (*pin_config_dbg_show) (struct pinctrl_dev *pctldev,
> +				     struct seq_file *s,
> +				     unsigned offset);
> +};

There was some discussion about having to call pin_config_group many
Times to set up e.g. 5 different parameters on a single group. Should
pin_config_group accept a list of param/data pairs, or a struct pin_config
instead? The latter would also need some NA/don't-change indication for
each field.

-- 
nvpublic

