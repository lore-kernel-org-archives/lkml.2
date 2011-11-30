Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab1K3TUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 14:20:07 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18176 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab1K3TUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 14:20:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 30 Nov 2011 11:20:00 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 30 Nov 2011 11:19:57 -0800
Subject: RE: [PATCH 1/2 v4] pinctrl: add a pin config interface
Thread-Topic: [PATCH 1/2 v4] pinctrl: add a pin config interface
Thread-Index: Acyq2WBORP4metMrQdGuhZKDKuuPZwEuQ0Tw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174FDAFF07@HQMAIL01.nvidia.com>
References: <1322160370-27677-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1322160370-27677-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Thursday, November 24, 2011 11:46 AM:
> This add per-pin and per-group pin config interfaces for biasing,
> driving and other such electronic properties. The details of passed
> configurations are passed in an opaque unsigned long which may be
> dereferences to integer types, structs or lists on either side
> of the configuration interface.

> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
...
> @@ -315,6 +317,7 @@ int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
>  	return -EINVAL;
>  }
> 
> +

That's probably an accident?

> diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c

> +/**
> + * pin_config_get() - get the configuration of a single pin parameter
> + * @pctldev: pin controller device for this pin
> + * @pin: pin to get the config for
> + * @config: this config tuple will be filled in with the setting for
> + *	the requested parameter, so the .param part of this setting must
> + *	me set when calling the function

I don't like muxing the param and value together in a single parameter;
it requires a bunch of bit-shifting to create them, modify the value
here, and extract values. Why not just have "param" and "value" function
parameters like the old patches?

In the description of @config, there is no ".param part of this setting"
since this isn't a struct in this version of the patch.

> +int pin_config_get(struct pinctrl_dev *pctldev, int pin,
> +			  unsigned long *config)
...
> +	ret = ops->pin_config_get(pctldev, pin, config);
> +	/*
> +	 * -EINVAL is OK, it means the setting is not active right now

That doesn't really make sense; given it's a param/value thing, a
particular param can't be "not active"; it has a particular value or
not.

There's no pin_config_group_get()?

> +	 * -ENOTSUPP just means that setting is not available and is also OK
> +	 */
> +	if (ret == -EINVAL || ret == -ENOTSUPP)
> +		return ret;
> +	if (ret) {
> +		dev_err(&pctldev->dev,
> +			"unable to get pin configuration on pin %d\n", pin);

This is always true; why make the dev_err() conditional at all? Especially
attempts to retrieve unsupported parameters should be logged.

> +int pin_config_group(struct pinctrl_dev *pctldev, const char *pin_group,
> +		     unsigned long config)
...
> +	/*
> +	 * If the controller cannot handle entire groups, we configure each pin
> +	 * individually.
> +	 */

I don't really like the automatic fallback; a particular param is either
valid for a group or a pin, and the user really should be setting it on
the appropriate one. Still, for drivers where the fallback never makes
sense, we can just never return -EAGAIN, so can disable this if we want,
so I guess it's fine.

> +int pinconf_check_ops(const struct pinconf_ops *ops)
> +{
> +	/* We must be able to read out pin status */
> +	if (!ops->pin_config_get)
> +		return -EINVAL;

What if there are no per-pin configuration parameters?

> +	/* We have to be able to config the pins in SOME way */
> +	if (!ops->pin_config_group && !ops->pin_config_set)
> +		return -EINVAL;
> +	return 0;
> +}

... [debugfs code]
> +#else
> +
> +#endif

Should there be something inside the #else? If not, perhaps just write
#endif without #else?

> diff --git a/include/linux/pinctrl/pinconf.h b/include/linux/pinctrl/pinconf.h

> +extern int pin_config_get(struct pinctrl_dev *pctldev, int pin,
> +			  unsigned long *config);
> +extern int pin_config_set(struct pinctrl_dev *pctldev, int pin,
> +			  unsigned long config);
> +extern int pin_config_group(struct pinctrl_dev *pctldev, const char *pin_group,
> +			    unsigned long config);

I don't really like exposing these as public APIs; I don't see any need
for drivers to be explicitly configuring pins, just like they don't
explicitly request a particular mux option, but rather there's a mapping
table which determines the configuration the device needs. I think pin
config options should be included in the mapping table, or a parallel
pin config table.

Still, this patch will give me what I need to implement the pin config
part of the Tegra pinctrl driver, so I won't push back too hard on this
for now, but I think eventually these APIs will just go away.

> +static inline int pin_config_get(struct pinctrl_dev *pctldev, int pin,
> +				 unsigned long *config)
> +{
> +	return 0;
> +}

Shouldn't at least pin_config_get() return an error. It seems like both
pin_config_set() and pin_config_group() don't do what they're asked, so
they should also return an error. gpiolib takes that approach; e.g.
gpio_direction_input() fails in the dummy case.

-- 
nvpublic

