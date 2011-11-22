Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829Ab1KVKwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:52:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43850 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1KVKwK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:52:10 -0500
MIME-Version: 1.0
In-Reply-To: <1321904871-32278-1-git-send-email-linus.walleij@stericsson.com>
References: <1321904871-32278-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 22 Nov 2011 16:22:09 +0530
Message-ID: <CAJuYYwRFGn+Efu80yjszuBof5omN1RvKjz7efh8bwK2t-MUj+A@mail.gmail.com>
Subject: Re: [PATCH 1/8 v3] pinctrl: add a generic pin config interface
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 22 November 2011 01:17, Linus Walleij <linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> This add per-pin and per-group pin config interfaces for biasing,
> driving and other such electronic properties. The intention is
> clearly to enumerate all things you can do with pins, hoping that
> these are enumerable.

[...]

> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  Documentation/pinctrl.txt       |  105 +++++++++++-
>  drivers/pinctrl/Kconfig         |    5 +-
>  drivers/pinctrl/Makefile        |    1 +
>  drivers/pinctrl/core.c          |   19 ++
>  drivers/pinctrl/core.h          |   10 +
>  drivers/pinctrl/pinconf.c       |  366 +++++++++++++++++++++++++++++++++++++++
>  drivers/pinctrl/pinconf.h       |   41 +++++
>  include/linux/pinctrl/pinconf.h |  209 ++++++++++++++++++++++
>  include/linux/pinctrl/pinctrl.h |   10 +-
>  9 files changed, 755 insertions(+), 11 deletions(-)
>  create mode 100644 drivers/pinctrl/pinconf.c
>  create mode 100644 drivers/pinctrl/pinconf.h
>  create mode 100644 include/linux/pinctrl/pinconf.h
>

[...]


> diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
> index 74dee43..4b30a28 100644
> --- a/drivers/pinctrl/core.h
> +++ b/drivers/pinctrl/core.h
> @@ -9,6 +9,10 @@
>  * License terms: GNU General Public License (GPL) version 2
>  */
>
> +#include <linux/pinctrl/pinconf.h>
> +
> +struct pinctrl_gpio_range;
> +
>  /**
>  * struct pinctrl_dev - pin control class device
>  * @node: node to include this pin controller in the global pin controller list
> @@ -52,6 +56,8 @@ struct pinctrl_dev {
>  * @mux_requested: whether the pin is already requested by pinmux or not
>  * @mux_function: a named muxing function for the pin that will be passed to
>  *     subdrivers and shown in debugfs etc
> + * @config_lock: a lock to protect the pin configuration portions
> + * @pin_configs: a list of configuration settings for this pin
>  */
>  struct pin_desc {
>        struct pinctrl_dev *pctldev;
> @@ -61,6 +67,10 @@ struct pin_desc {
>  #ifdef CONFIG_PINMUX
>        const char *mux_function;
>  #endif
> +#ifdef CONFIG_PINCONF
> +       struct mutex config_lock;
> +       struct pin_config config;


Some platforms (like exynos) can read back the current pin_config from
the hardware registers. For such platforms, 'config' would consume
additional space which will not be used. Can 'config' be made a
pointer and memory for it allocated in 'pinctrl_register_one_pin' only
if the pin-controller requires it. Maybe, 'struct pinctrl_desc' can
have a additional member to describe some of its characteristics such
as ability to read back pin configuration from registers.


> +#endif
>  };
>
>  struct pinctrl_dev *get_pinctrl_dev_from_dev(struct device *dev,
> diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
> new file mode 100644
> index 0000000..dc59c04
> --- /dev/null
> +++ b/drivers/pinctrl/pinconf.c

[...]

> +int pin_config(struct pinctrl_dev *pctldev, int pin,
> +              const struct pin_config_tuple *configs,
> +              unsigned num_configs)
> +{
> +       const struct pinconf_ops *ops = pctldev->desc->confops;
> +       struct pin_desc *desc;
> +       struct pin_config *conf;
> +       int ret;
> +
> +       desc = pin_desc_get(pctldev, pin);
> +       if (desc == NULL) {
> +               dev_err(&pctldev->dev, "tried to configure unregistered pin\n");
> +               return -EINVAL;
> +       }
> +
> +       conf = &desc->config;
> +
> +       if (!ops || !ops->pin_config) {
> +               dev_err(&pctldev->dev, "cannot configure pin, missing "
> +                       "config function in driver\n");
> +               return -EINVAL;
> +       }
> +
> +       mutex_lock(&desc->config_lock);
> +       ret = ops->pin_config(pctldev, conf, pin, configs, num_configs);
> +       if (ret) {
> +               dev_err(&pctldev->dev,
> +                       "unable to set pin configuration on pin %d\n", pin);
> +               return ret;
> +       }
> +       pinconf_update_states(conf, configs, num_configs);
> +       mutex_unlock(&desc->config_lock);
> +
> +       return 0;
> +}

EXPORT_SYMBOL(pin_config); here ?

> +
> +int pin_config_group(struct pinctrl_dev *pctldev, const char *pin_group,
> +                    const struct pin_config_tuple *configs,
> +                    unsigned num_configs)
> +{
> +       const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
> +       const struct pinconf_ops *ops = pctldev->desc->confops;
> +       int selector;
> +       const unsigned *pins;
> +       unsigned num_pins;
> +       int ret;
> +       int i;
> +
> +       if (!ops || (!ops->pin_config_group && !ops->pin_config)) {
> +               dev_err(&pctldev->dev, "cannot configure pin group, missing "
> +                       "config function in driver\n");
> +               return -EINVAL;
> +       }
> +
> +       selector = pinctrl_get_group_selector(pctldev, pin_group);
> +       if (selector < 0)
> +               return selector;
> +
> +       ret = pctlops->get_group_pins(pctldev, selector, &pins, &num_pins);
> +       if (ret) {
> +               dev_err(&pctldev->dev, "cannot configure pin group, error "
> +                       "getting pins\n");
> +               return ret;
> +       }
> +
> +       /*
> +        * If the pin controller supports handling entire groups we use that
> +        * capability.
> +        */
> +       if (ops->pin_config_group) {
> +               ret = ops->pin_config_group(pctldev, selector,
> +                                           configs, num_configs);
> +
> +               /* Success, update per-pin state */
> +               if (ret == 0) {
> +                       for (i = 0; i < num_pins; i++) {
> +                               struct pin_desc *desc;
> +
> +                               desc = pin_desc_get(pctldev, pins[i]);
> +                               if (desc == NULL) {
> +                                       dev_err(&pctldev->dev, "error updating state\n");
> +                                       return -EINVAL;
> +                               }
> +                               mutex_lock(&desc->config_lock);
> +                               pinconf_update_states(&desc->config,
> +                                                     configs, num_configs);
> +                               mutex_unlock(&desc->config_lock);
> +                       }
> +               }
> +               /*
> +                * If the pin controller prefer that a certain group be handled
> +                * pin-by-pin as well, it returns -EAGAIN.
> +                */
> +               if (ret != -EAGAIN)
> +                       return ret;
> +       }
> +
> +       /*
> +        * If the controller cannot handle entire groups, we configure each pin
> +        * individually.
> +        */
> +       for (i = 0; i < num_pins; i++) {
> +               ret = pin_config(pctldev, pins[i], configs, num_configs);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}

EXPORT_SYMBOL(pin_config_group); here ?

> +
> +int pinconf_check_ops(const struct pinconf_ops *ops)
> +{

[...]

> diff --git a/include/linux/pinctrl/pinconf.h b/include/linux/pinctrl/pinconf.h
> new file mode 100644
> index 0000000..45e424b
> --- /dev/null
> +++ b/include/linux/pinctrl/pinconf.h
> @@ -0,0 +1,209 @@
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

[...]

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
> +       PIN_CONFIG_INPUT_DEBOUNCE,
> +       PIN_CONFIG_SLEW_RATE_RISING,
> +       PIN_CONFIG_SLEW_RATE_FALLING,
> +       PIN_CONFIG_POWER_SOURCE,
> +       PIN_CONFIG_LOW_POWER_MODE,
> +       PIN_CONFIG_WAKEUP,
> +       PIN_CONFIG_END,
> +};

For all Samsung SoC's, PIN_CONFIG_BIAS_PULL_UP,
PIN_CONFIG_BIAS_PULL_DOWN and PIN_CONFIG_DRIVE_PUSH_PULL would be
sufficient. So the above list of config options is fine for all
Samsung platforms.

> +
> +/**
> + * struct pin_config_tuple - a composite parameter and argument config item
> + * @param: the parameter to configure
> + * @data: argument to the parameter, meaning depend on parameter
> + */

[...]

> +extern int pin_config(struct pinctrl_dev *pctldev, int pin,
> +                     const struct pin_config_tuple *configs,
> +                     unsigned num_configs);


Is the 'pin' number expected to be local to the pin-controller
represented by 'pctldev' ?  There can be multiple pin-controllers in a
system, so it would be easier if 'pin' parameter above is a
system-wide pin number, and the caller of 'pin_config' need not know
which pin-controller manages 'pin'. Ideally, 'pctldev' should not be
included in the parameter list.


> +extern int pin_config_group(struct pinctrl_dev *pctldev, const char *pin_group,
> +                           const struct pin_config_tuple *configs,
> +                           unsigned num_configs);
> +

[...]


Thanks for this patch.

Regards,
Thomas.
