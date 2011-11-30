Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab1K3Tpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 14:45:47 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3232 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab1K3Tpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 14:45:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 30 Nov 2011 11:45:39 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 30 Nov 2011 11:45:37 -0800
Subject: RE: [PATCH 2/2 v4] pinctrl: introduce generic pin config
Thread-Topic: [PATCH 2/2 v4] pinctrl: introduce generic pin config
Thread-Index: Acyq2WckDlS/NVX1RZa6tlmOnOcWbAEvcvhQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174FDAFF30@HQMAIL01.nvidia.com>
References: <1322160380-27711-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1322160380-27711-1-git-send-email-linus.walleij@stericsson.com>
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
> This is a split-off from the earlier patch set which adds generic
> pin configuration for the pin controllers that want it. Since
> we may have a system with mixed generic and custom pin controllers,
> we pass a boolean in the pin controller ops vtable to indicate
> if it is generic.

> diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c

> +void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
...
> +	for(i = 0; i < ARRAY_SIZE(conf_items); i++) {
...
> +		/* We want to check out this parameter */
> +		config = (unsigned long) conf_items[i].param;

Don't you need to use to_config_packed() here?

> +		ret = pin_config_get(pctldev, pin, &config);
> +		/* These are legal errors */
> +		if (ret == -EINVAL || ret == -ENOTSUPP)
> +			continue;

Ah, I guess I see why you consider -ENOTSUPP an error that you don't want
to print to syslog. Maybe you should call _pin_config_get() here which
doesn't spew messages on -ENOTSUPP, but have the public pin_config_get()
function spew errors.

> +		if (ret) {
> +			seq_printf(s, "ERROR READING CONFIG SETTING %d ", i);
> +			continue;
> +		}
> +		/* Space between multiple configs */
> +		seq_puts(s, " ");
> +		seq_puts(s, conf_items[i].display);
> +		/* Print unit if available */
> +		if (conf_items[i].format && config != 0)
> +			seq_printf(s, " (%lu %s)", config,
> +				   conf_items[i].format);

Don't you need to use to_config_argument() here?

> diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c

> @@ -169,6 +169,8 @@ static void pinconf_dump_pin(struct pinctrl_dev *pctldev,
>  {
>  	const struct pinconf_ops *ops = pctldev->desc->confops;
> 
> +	/* no-op when not using generic pin config */
> +	pinconf_generic_dump_pin(pctldev, s, pin);
>  	if (ops && ops->pin_config_dbg_show)
>  		ops->pin_config_dbg_show(pctldev, s, pin);
>  }

This is really a comment on the previous patch, but what about config
params that only apply to groups?

> diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h

> +/*
> + * You shouldn't even be able to compile with these enums etc unless you're
> + * using generic pin config. That is why this is defined out.
> + */
> +#ifdef CONFIG_GENERIC_PINCONF

Hmm. I'd prefer to have drivers able to use both generic values and
extend them with custom values. Can't we just use the top bit of the
param value to indicate 0:standard (from the enum below) 1:custom
(something meaningful to only the individual pinctrl driver). This
could then trigger calling pinconf_generic_dump_pin() or not for
example.

> +#ifdef CONFIG_GENERIC_PINCONF
> +	bool is_generic;
> +#endif

... and get rid of that flag.

-- 
nvpublic

