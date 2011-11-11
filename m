Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab1KKL04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 06:26:56 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61055 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab1KKL0y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 06:26:54 -0500
MIME-Version: 1.0
In-Reply-To: <1321000263-20000-1-git-send-email-linus.walleij@stericsson.com>
References: <1321000263-20000-1-git-send-email-linus.walleij@stericsson.com>
Date: Fri, 11 Nov 2011 16:56:53 +0530
Message-ID: <CAJuYYwRy-oy6MXxrPs+CZU=C2VcvV=-fVfju5Jfc1jJRp1ousg@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: add a generic pin config interface
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 11 November 2011 14:01, Linus Walleij <linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> This add per-pin and per-group pin config interfaces for biasing,
> driving and other such electronic properties. The intention is
> clearly to enumerate all things you can do with pins, hoping that
> these are enumerable.
>
> ChangeLog v1->v2:
> - Clear split of terminology: we now have pin controllers, and
>  those may support two interfaces using vtables: pin
>  multiplexing and pin configuration.
> - Break out pin configuration to its own C file, controllers may
>  implement only config without mux, and vice versa, so keep each
>  sub-functionality of pin controllers separate. Introduce
>  CONFIG_PINCONF in Kconfig.
> - Implement some core logic around pin configuration in the
>  pinconf.c file.
> - Remove UNKNOWN config states, these were just surplus baggage.
> - Remove FLOAT config state - HIGH_IMPEDANCE should be enough for
>  everyone.
> - PIN_CONFIG_POWER_SOURCE added to handle switching the power
>  supply for the pin logic between different sources
> - Explicit DISABLE config enums to turn schmitt-trigger,
>  wakeup etc OFF.
> - Update documentation to reflect all the recent reasoning.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  Documentation/pinctrl.txt       |   93 ++++++++++-
>  drivers/pinctrl/Kconfig         |    5 +-
>  drivers/pinctrl/Makefile        |    1 +
>  drivers/pinctrl/core.c          |   18 ++
>  drivers/pinctrl/core.h          |   10 ++
>  drivers/pinctrl/pinconf.c       |  332 +++++++++++++++++++++++++++++++++++++++
>  drivers/pinctrl/pinconf.h       |   34 ++++
>  include/linux/pinctrl/pinconf.h |  193 +++++++++++++++++++++++
>  include/linux/pinctrl/pinctrl.h |   10 +-
>  9 files changed, 685 insertions(+), 11 deletions(-)
>  create mode 100644 drivers/pinctrl/pinconf.c
>  create mode 100644 drivers/pinctrl/pinconf.h
>  create mode 100644 include/linux/pinctrl/pinconf.h
>
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> index ffef900..ad04c5e 100644
> --- a/Documentation/pinctrl.txt
> +++ b/Documentation/pinctrl.txt
> @@ -7,12 +7,9 @@ This subsystem deals with:
>

[...]

> +The pin control system supports an interface partly abstracting these
> +properties while leaving the details to the pin control driver. We assume that
> +the things a controller may want configure are enumerable, and thus the
> +parameters such as PIN_CONFIG_BIAS_PULL_UP are defined by the core, whereas
> +the arguments to the parameter may need to be on a custom format only
> +understandable by the driver. However we strive to use SI-derived entities for
> +these where applicable, which means the core may step in and do sematic
> +analysis of the passed values in select cases.
> +
> +For example, a driver can do this:
> +
> +ret = pin_config(128, PIN_CONFIG_BIAS_PULL_UP, 100000);

struct pinctrl_dev* is required as the first parameter in this example.

> +
> +To pull up a pin to VDD with a 100KOhm resistor. The driver implements
> +callbacks for changing pin configuration in the pin controller ops like this:

[...]

> diff --git a/include/linux/pinctrl/pinconf.h b/include/linux/pinctrl/pinconf.h
> new file mode 100644
> index 0000000..6b5163d
> --- /dev/null
> +++ b/include/linux/pinctrl/pinconf.h
> @@ -0,0 +1,193 @@
> +/*
> + * Interface the pinconfig portions of the pinctrl subsystem
> + *
> + * Copyright (C) 2011 ST-Ericsson SA
> + * Written on behalf of Linaro for ST-Ericsson
> + * This interface is used in the core to keep track of pins.
> + *
> + * Author: Linus Walleij <linus.walleij@linaro.org>
> + *
> + * License terms: GNU General Public License (GPL) version 2
> + */
> +#ifndef __LINUX_PINCTRL_PINCONF_H
> +#define __LINUX_PINCTRL_PINCONF_H
> +
> +/**
> + * enum pin_config_param - possible pin configuration parameters
> + * @PIN_CONFIG_BIAS_DISABLE: disable any pin bias on the pin, a
> + *     transition from say pull-up to pull-down implies that you disable
> + *     pull-up in the process, this setting disables all biasing
> + * @PIN_CONFIG_BIAS_HIGH_IMPEDANCE: the pin will be set to a high impedance
> + *     mode, also know as "third-state" (tristate) or "high-Z" or "floating".
> + *     On output pins this effectively disconnects the pin, which is useful
> + *     if for example some other pin is going to drive the signal connected
> + *     to it for a while. Pins used for input are usually always high
> + *     impedance.
> + * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with high
> + *     impedance to VDD), if the controller supports specifying a certain
> + *     pull-up resistance, this is given as an argument (in Ohms) when
> + *     setting this parameter
> + * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with high
> + *     impedance to GROUND), if the controller supports specifying a certain
> + *     pull-down resistance, this is given as an argument (in Ohms) when
> + *     setting this parameter
> + * @PIN_CONFIG_BIAS_HIGH: the pin will be wired high, connected to VDD
> + * @PIN_CONFIG_BIAS_GROUND: the pin will be grounded, connected to GROUND
> + * @PIN_CONFIG_DRIVE_PUSH_PULL: the pin will be driven actively high and
> + *     low, this is the most typical case and is typically achieved with two
> + *     active transistors on the output. If the pin can support different
> + *     drive strengths for push/pull, the strength is given on a custom format
> + *     as argument when setting pins to this mode
> + * @PIN_CONFIG_DRIVE_OPEN_DRAIN: the pin will be driven with open drain (open
> + *     collector) which means it is usually wired with other output ports
> + *     which are then pulled up with an external resistor. If the pin can
> + *     support different drive strengths for the open drain pin, the strength
> + *     is given on a custom format as argument when setting pins to this mode
> + * @PIN_CONFIG_DRIVE_OPEN_SOURCE: the pin will be driven with open drain
> + *     (open emitter) which is the same as open drain mutatis mutandis but
> + *     pulled to ground. If the pin can support different drive strengths for
> + *     the open drain pin, the strength is given on a custom format as
> + *     argument when setting pins to this mode
> + * @PIN_CONFIG_DRIVE_OFF: the pin is set to inactive drive mode, off
> + * @PIN_CONFIG_INPUT_SCHMITT: this will configure an input pin to run in
> + *     schmitt-trigger mode. If the schmitt-trigger has adjustable hysteresis,
> + *     the threshold value is given on a custom format as argument when
> + *     setting pins to this mode
> + * @PIN_CONFIG_INPUT_SCHMITT_OFF: disables schmitt-trigger mode
> + * @PIN_CONFIG_SLEW_RATE_RISING: this will configure the slew rate for rising
> + *     signals on the pin. The argument gives the rise time in nanoseconds.
> + *     You may want to adjust slew rates so that signal edges don't get too
> + *     steep, causing disturbances in surrounding electronics for example.
> + * @PIN_CONFIG_SLEW_RATE_FALLING: this will configure the slew rate for falling
> + *     signals on the pin. The argument gives the fall time in nanoseconds
> + * @PIN_CONFIG_LOAD_CAPACITANCE: some pins have inductive characteristics and
> + *     will deform waveforms when signals are transmitted on them, by
> + *     applying a load capacitance, the waveform can be rectified. The
> + *     argument gives the load capacitance in picofarad (pF)
> + * @PIN_CONFIG_POWER_SOURCE: if the pin can select between different power
> + *     supplies, the argument to this parameter (on a custom format) tells
> + *     the driver which alternative power source to use
> + * @PIN_CONFIG_LOW_POWER_MODE: this will configure the pin for low power
> + *     operation
> + * @PIN_CONFIG_NORMAL_POWER_MODE: returns pin from low power mode
> + * @PIN_CONFIG_WAKEUP_ENABLE: this will configure an input pin such that if a
> + *     signal transition arrives at the pin when the pin controller/system
> + *     is sleeping, it will wake up the system
> + * @PIN_CONFIG_WAKEUP_DISABLE: will disable a pin from the wakeup enable state
> + *     set by the previous parameter
> + * @PIN_CONFIG_END: this is the last enumerator for pin configurations, if
> + *     you need to pass in custom configurations to the pin controller, use
> + *     PIN_CONFIG_END+1 as the base offset
> + */
> +enum pin_config_param {
> +       PIN_CONFIG_BIAS_DISABLE,
> +       PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
> +       PIN_CONFIG_BIAS_PULL_UP,
> +       PIN_CONFIG_BIAS_PULL_DOWN,
> +       PIN_CONFIG_BIAS_HIGH,
> +       PIN_CONFIG_BIAS_GROUND,
> +       PIN_CONFIG_DRIVE_PUSH_PULL,
> +       PIN_CONFIG_DRIVE_OPEN_DRAIN,
> +       PIN_CONFIG_DRIVE_OPEN_SOURCE,
> +       PIN_CONFIG_DRIVE_OFF,
> +       PIN_CONFIG_INPUT_SCHMITT,
> +       PIN_CONFIG_INPUT_SCHMITT_OFF,
> +       PIN_CONFIG_SLEW_RATE_RISING,
> +       PIN_CONFIG_SLEW_RATE_FALLING,
> +       PIN_CONFIG_LOAD_CAPACITANCE,
> +       PIN_CONFIG_POWER_SOURCE,
> +       PIN_CONFIG_LOW_POWER_MODE,
> +       PIN_CONFIG_NORMAL_POWER_MODE,
> +       PIN_CONFIG_WAKEUP_ENABLE,
> +       PIN_CONFIG_WAKEUP_DISABLE,
> +       PIN_CONFIG_END,
> +};

Samsung parts have a 'drive strength' config option for the pads. The
drive strength is represented as 1x, 2x, 4x, etc .. depending on the
SoC. The config param that can be used to represent drive strength in
this case could be PIN_CONFIG_POWER_SOURCE. Or should there be another
config param for representing drive strength? Otherwise, the above
config param options are sufficient for all existing Samsung SoC's.

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
> +       enum pin_config_param bias_param;
> +       unsigned long bias_data;
> +       enum pin_config_param drive_param;
> +       unsigned long drive_data;
> +       bool schmitt;
> +       unsigned long slewrate_rising;
> +       unsigned long slewrate_falling;
> +       unsigned long load_capacitance;
> +       unsigned long power_source;
> +       bool low_power;
> +       bool wakeup;
> +};

Most of these might remain unused since not all SoC's would have all
the possible config options. Is it required to keep pin controller
subsystem aware of individual pin config settings. Or should this be
handled by individual pinctrl drivers?

There is a API by name pin_config below. Should this struct or the API
name be changed so that they are different?

> +
> +#ifdef CONFIG_PINCONF
> +
> +struct pinctrl_dev;
> +
> +/**
> + * struct pinconf_ops - pin config operations, to be implemented by
> + * pin configuration capable drivers.
> + * @pin_get_initial_config: called to get the initial config of each pin
> + *     if you cannot read out the configuration of your pins at startup, just
> + *     leave this as NULL
> + * @pin_config: configure an individual pin
> + * @pin_config_group: configure all pins in a group
> + * @pin_config_dbg_show: optional debugfs display hook that will provide
> + *     per-device info for a certain pin in debugfs
> + */
> +struct pinconf_ops {
> +       int (*pin_get_initial_config) (struct pinctrl_dev *pctldev,
> +                                      struct pin_config *conf,
> +                                      unsigned pin);
> +       int (*pin_config) (struct pinctrl_dev *pctldev,
> +                          const struct pin_config *conf,
> +                          unsigned pin,
> +                          enum pin_config_param param,
> +                          unsigned long data);
> +       int (*pin_config_group) (struct pinctrl_dev *pctldev,
> +                                unsigned selector,
> +                                enum pin_config_param param,
> +                                unsigned long data);
> +       void (*pin_config_dbg_show) (struct pinctrl_dev *pctldev,
> +                                    struct seq_file *s,
> +                                    unsigned offset);
> +};
> +
> +
> +extern int pin_config(struct pinctrl_dev *pctldev, int pin,
> +                     enum pin_config_param param, unsigned long data);
> +extern int pin_config_group(struct pinctrl_dev *pctldev, const char *pin_group,
> +                           enum pin_config_param param, unsigned long data);
> +
> +#else
> +
> +static inline int pin_config(struct pinctrl_dev *pctldev, int pin,
> +                            enum pin_config_param param, unsigned long data)
> +{
> +       return 0;
> +}
> +
> +static inline int pin_config_group(struct pinctrl_dev *pctldev,
> +                                  const char *pin_group,
> +                                  enum pin_config_param param,
> +                                  unsigned long data)
> +{
> +       return 0;
> +}
> +
> +#endif
> +
> +#endif /* __LINUX_PINCTRL_PINCONF_H */

[...]

Thanks for this patch. I will try it on Samsung exynos along with the
pinctrl driver for exynos.

Regards,
Thomas.
