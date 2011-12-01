Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab1LAV4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:56:43 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18662 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab1LAV4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:56:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 01 Dec 2011 13:56:39 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 1 Dec 2011 13:56:39 -0800
Subject: RE: [PATCH 2/2 v5] pinctrl: introduce generic pin config
Thread-Topic: [PATCH 2/2 v5] pinctrl: introduce generic pin config
Thread-Index: AcywF7ylBcDozEUiSxeMIeUlnZeFggAW1c9g
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174FDB0312@HQMAIL01.nvidia.com>
References: <1322736902-11297-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1322736902-11297-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Thursday, December 01, 2011 3:55 AM:
> This is a split-off from the earlier patch set which adds generic
> pin configuration for the pin controllers that want it. Since
> we may have a system with mixed generic and custom pin controllers,
> we pass a boolean in the pin controller ops vtable to indicate
> if it is generic.

> +void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
> +			      struct seq_file *s, unsigned pin)
...
> +		config = to_config_packed(conf_items[i].param, 0);
...
> +		/* Print unit if available */
> +		if (conf_items[i].format && config != 0)

Why the check for "config != 0"; isn't the "param" always left in config
by pin_config_get, such that it's never 0?

> +			seq_printf(s, " (%u %s)", to_config_argument(config),
> +				   conf_items[i].format);
> +	}
> +}

> +enum pin_config_param {
> +	PIN_CONFIG_BIAS_DISABLE,
> +	PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
> +	PIN_CONFIG_BIAS_PULL_UP,
> +	PIN_CONFIG_BIAS_PULL_DOWN,
> +	PIN_CONFIG_BIAS_HIGH,
> +	PIN_CONFIG_BIAS_GROUND,
> +	PIN_CONFIG_DRIVE_PUSH_PULL,
> +	PIN_CONFIG_DRIVE_OPEN_DRAIN,
> +	PIN_CONFIG_DRIVE_OPEN_SOURCE,
> +	PIN_CONFIG_DRIVE_OFF,
> +	PIN_CONFIG_INPUT_SCHMITT,
> +	PIN_CONFIG_INPUT_DEBOUNCE,
> +	PIN_CONFIG_SLEW_RATE_RISING,
> +	PIN_CONFIG_SLEW_RATE_FALLING,
> +	PIN_CONFIG_POWER_SOURCE,
> +	PIN_CONFIG_LOW_POWER_MODE,
> +	PIN_CONFIG_WAKEUP,
> +	PIN_CONFIG_END,
> +};

This enum conflates both "parameter" and "value" into a single enum space.
The patch introduces to_config_packed() and friends specifically to pack
both param and value into a single unsigned long, but then defines the
"param" to encompass "value" as well. That seems inconsistent. Instead,
shouldn't you have something more like:

enum pin_config_param {
	PIN_CONFIG_BIAS,
	PIN_CONFIG_DRIVE,
	PIN_CONFIG_INPUT_SCHMITT,
	PIN_CONFIG_INPUT_DEBOUNCE,
	PIN_CONFIG_SLEW_RATE_RISING,
	PIN_CONFIG_SLEW_RATE_FALLING,
	PIN_CONFIG_POWER_SOURCE,
	PIN_CONFIG_LOW_POWER_MODE,
	PIN_CONFIG_WAKEUP,
	PIN_CONFIG_END,
};

/* Value for PIN_CONFIG_BIAS */
enum pin_config_bias_value {
	PIN_CONFIG_BIAS_DISABLE,
	PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
	PIN_CONFIG_BIAS_PULL_UP,
	PIN_CONFIG_BIAS_PULL_DOWN,
	PIN_CONFIG_BIAS_HIGH,
	PIN_CONFIG_BIAS_GROUND,
};

/* Value for PIN_CONFIG_DRIVE */
enum pin_config_drive_value {
	PIN_CONFIG_DRIVE_PUSH_PULL,
	PIN_CONFIG_DRIVE_OPEN_DRAIN,
	PIN_CONFIG_DRIVE_OPEN_SOURCE,
	PIN_CONFIG_DRIVE_OFF,
};

/*
 * Value for:
 * PIN_CONFIG_INPUT_SCHMITT,
 * PIN_CONFIG_INPUT_DEBOUNCE,
 * PIN_CONFIG_LOW_POWER_MODE,
 * PIN_CONFIG_WAKEUP,
 * PIN_CONFIG_END,
 */
enum pin_config_bool_value {
        PIN_CONFIG_OFF,
        PIN_CONFIG_ON,
};

/*
 * Value for:
 * PIN_CONFIG_SLEW_RATE_RISING,
 * PIN_CONFIG_SLEW_RATE_FALLING,
 * PIN_CONFIG_POWER_SOURCE,
 * ... is an integer
 */

-- 
nvpublic

