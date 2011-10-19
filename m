Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab1JSXEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:04:39 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16301 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab1JSXEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:04:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 19 Oct 2011 16:04:33 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
CC: Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 19 Oct 2011 16:04:29 -0700
Subject: RE: [PATCH 2/2] pinctrl: add a generic control interface
Thread-Topic: [PATCH 2/2] pinctrl: add a generic control interface
Thread-Index: AcyOezSTJHWgaOiSQWO3N6qgpM2OjgANXIuQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173D51C039@HQMAIL01.nvidia.com>
References: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Wednesday, October 19, 2011 10:21 AM:
> This add per-pin and per-group pin control interfaces for biasing,
> driving and other such electronic properties. The intention is
> clearly to enumerate all things you can do with pins, hoping that
> these are enumerable.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

> diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h

> +/**
> + * enum pin_config_param - possible pin configuration parameters
> + * @PIN_CONFIG_BIAS_UNKNOWN: this bias mode is not known to us

I'm not sure what use that would be; shouldn't we remove that, and add
new PIN_CONFIG_BIAS_* values as/when they're needed?

> + * @PIN_CONFIG_BIAS_FLOAT: no specific bias, the pin will float or state
> + *	is not controlled by software

"float" and "not controlled by SW" are very different things. How is float
different to high impedance?

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

What value should be used to disable a pull-up; 0? What value should be
used when requesting pull-up where the SoC doesn't have a configurable
pull-up resistor; anything non-zero? Tegra has separate configurations for
pull-up/down strength (0..31) and pull-up/down enable (up/down/none), though
I suppose we could map 0 to off, 1..32 to on with strength 0..31, although
that'd prevent a driver from toggling the enable bit on/off without knowing
what the strength code should be programmed to...

Tegra's pull-up/down strengths aren't documented in terms of ohms, but
rather a "drive strength code" on scale 0..31. I'm not sure what that
truly maps to in hardware.

> + * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with high
> + *	impedance to GROUND), if the controller supports specifying a certain
> + *	pull-down resistance, this is given as an argument (in Ohms) when
> + *	setting this parameter
> + * @PIN_CONFIG_BIAS_HIGH: the pin will be wired high, connected to VDD
> + * @PIN_CONFIG_BIAS_GROUND: the pin will be grounded, connected to GROUND

At least some of these options appear mutually exclusive; I wonder if we
shouldn't have a PIN_CONFIG_BIAS parameter, and have the legal values be
HIGH/GROUND/NONE. Pull up/down are probably separate. HIGH_IMPEDANCE seems
more like a PIN_CONFIG_DRIVE value than a PIN_CONFIG_BIAS value.

> + * @PIN_CONFIG_DRIVE_UNKNOWN: we don't know the drive mode of this pin, for
> + *	example since it is controlled by hardware or the information is not
> + *	accessible but we need a meaningful enumerator in e.g. initialization
> + *	code

Again, I'm not sure this is useful; if this is not a configurable parameter,
surely initialization code would simply skip attempting to set this param?

> + * @PIN_CONFIG_DRIVE_PUSH_PULL: the pin will be driven actively high and
> + *	low, this is the most typical case and is typically achieved with two
> + *	active transistors on the output. If the pin can support different
> + *	drive strengths for push/pull, the strength is given on a custom format
> + *	as argument when setting pins to this mode
> + * @PIN_CONFIG_DRIVE_OPEN_DRAIN: the pin will be driven with open drain (open
> + *	collector) which means it is usually wired with other output ports
> + *	which are then pulled up with an external resistor. If the pin can
> + *	support different drive strengths for the open drain pin, the strength
> + *	is given on a custom format as argument when setting pins to this mode
> + * @PIN_CONFIG_DRIVE_OPEN_SOURCE: the pin will be driven with open drain
> + *	(open emitter) which is the same as open drain mutatis mutandis but
> + *	pulled to ground. If the pin can support different drive strengths for
> + *	the open drain pin, the strength is given on a custom format as
> + *	argument when setting pins to this mode
> + * @PIN_CONFIG_DRIVE_OFF: the pin is set to inactive drive mode, off

These seem like mutually exclusive values for a PIN_CONFIG_DRIVE param.

> + * @PIN_CONFIG_INPUT_SCHMITT: this will configure an input pin to run in
> + *	schmitt-trigger mode. If the schmitt-trigger has adjustable hysteresis,
> + *	the threshold value is given on a custom format as argument when
> + *	setting pins to this mode
> + * @PIN_CONFIG_SLEW_RATE_RISING: this will configure the slew rate for rising
> + *	signals on the pin. The argument gives the rise time in nanoseconds
> + * @PIN_CONFIG_SLEW_RATE_FALLING: this will configure the slew rate for falling
> + *	signals on the pin. The argument gives the fall time in nanoseconds
> + * @PIN_CONFIG_LOAD_CAPACITANCE: some pins have inductive characteristics and
> + *	will deform waveforms when signals are transmitted on them, by
> + *	applying a load capacitance, the waveform can be rectified. The
> + *	argument gives the load capacitance in picofarad (pF)
> + * @PIN_CONFIG_WAKEUP_ENABLE: this will configure an input pin such that if a
> + *	signal transition arrives at the pin when the pin controller/system
> + *	is sleeping, it will wake up the system
> + * @PIN_CONFIG_END: this is the last enumerator for pin configurations, if
> + *	you need to pass in custom configurations to the pin controller, use
> + *	PIN_CONFIG_END+1 as the base offset

Tegra needs at least some more:

PIN_CONFIG_HIGH_SPEED_MODE (0..1) [tegra_drive_pingroup_config.hsm]
PIN_CONFIG_LOW_POWER_MODE (0..3)  [tegra_drive_pingroup_config.drive]

> @@ -77,6 +160,14 @@ struct pinctrl_ops {
...
> +	int (*pin_config) (struct pinctrl_dev *pctldev,
> +			   unsigned pin,
> +			   enum pin_config_param param,
> +			   unsigned long data);
> +	int (*pin_config_group) (struct pinctrl_dev *pctldev,
> +				 unsigned selector,
> +				 enum pin_config_param param,
> +				 unsigned long data);

That looks good.

> @@ -113,6 +204,10 @@ extern struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
...
> +extern int pin_config(struct pinctrl_dev *pctldev, int pin,
> +		      enum pin_config_param param, unsigned long data);
> +extern int pin_config_group(struct pinctrl_dev *pctldev, const char *pin_group,
> +			    enum pin_config_param param, unsigned long data);

Hmmm. Do we really want to expose these as public APIs? I suppose it
will allow us to start configuring all these parameters ASAP, but all
previous discussion has been aimed at having the pinctrl core set up an
initial set of values at boot-time using a board-supplied table (so no
external API), and then we were still talking about how to manipulate
the values at run-time. Do we really want to encode all this information
into drivers calling these APIs?

-- 
nvpublic

