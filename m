Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab1HFNin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 09:38:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34910 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755654Ab1HFNim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 09:38:42 -0400
Date: Sat, 6 Aug 2011 22:38:31 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: sameo@openedhand.com, linux-kernel@vger.kernel.org,
        Dajun <dajun.chen@diasemi.com>, linaro-dev@lists.linaro.org
Subject: Re: [PATCH v3 01/11] MFD: DA9052 MFD core module
Message-ID: <20110806133829.GA28267@opensource.wolfsonmicro.com>
References: <1312552424.5572.145.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312552424.5572.145.camel@L-0532.kpit.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 07:23:44PM +0530, ashishj3 wrote:

Patch v3 seems a little low, we've had *slightly* more versions than
that...

> +choice
> +	prompt "Chip Type"
> +	depends on MFD_DA9053_SPI || MFD_DA9053_I2C
> +config PMIC_DA9053AA
> +	bool "Support Dialog Semiconductor DA9053 AA PMIC"
> +	help
> +	  Support for Dialog semiconductor DA9053 AA PMIC.
> +	  This driver provides common support for accessing  the device,
> +	  additional drivers must be enabled in order to use the
> +	  functionality of the device.
> +config PMIC_DA9053Bx

Could do with blank lines between blocks.  Though looking at the code
here I don't understand why these are compile options at all, or if they
need to be compile options for some reason why they're not independantly
selectable?

> +int da9052_reg_read(struct da9052 *da9052, unsigned char reg)
> +{
> +	int val, ret;
> +
> +	if (reg > DA9052_MAX_REG_CNT) {
> +		dev_err(da9052->dev, "invalid reg %x\n", reg);
> +		return -EINVAL;
> +	}
> +
> +	#ifdef CONFIG_MFD_DA9052_SPI
> +		reg = (reg << 1) | 1;
> +	#endif

There's several problems here:

- You shouldn't be indenting preprocessor directives.
- You shouldn't be adding extra indentation before.
- This will break I2C devices if SPI support is built into the driver.

Please, when writing code try to understand the abstractions you're
using.  For example here think about the purpose of being able to build
I2C and SPI separately and simultaneously and the goal of the regmap
API.

Looks like we need to add per device mangling for the SPI register
read/write flag.

> +static struct mfd_cell __initdata da9052_subdev_info[] = {
> +	{"da9052-onkey", .resources = &da9052_onkey_resource,
> +	 .num_resources = 1},
> +	{"da9052-rtc", .resources = &da9052_rtc_resource,
> +	 .num_resources = 1},
> +	{"da9052-gpio"},
> +	{"da9052-hwmon"},
> +	{"da9052-leds"},
> +	{"da9052-WLED1"},
> +	{"da9052-WLED2"},
> +	{"da9052-WLED3"},

Upper case in device names is *very* non-idiomatic.

> +	{"da9052-tsi", .resources = da9052_tsi_resources,
> +	 .num_resources = ARRAY_SIZE(da9052_tsi_resources)},
> +	{"da9052-bat", .resources = da9052_power_resources,
> +	 .num_resources = ARRAY_SIZE(da9052_power_resources)},
> +	{"da9052-watchdog"},
> +};

The formatting here is really odd for Linux, both in terms of the lack
of spaces and the brace placement.

> +	da9052_group_write(da9052, DA9052_EVENT_A_REG, 4, v);
> +
> +	#ifndef CONFIG_PMIC_DA9053Bx
> +	DA9052_FIXME();
> +	#endif

This should be runtime detected based on the device name, either from
the device registration or by reading back chip identification.

Formatting issues too.

> +	return 0;
> +}
> +module_init(da9052_spi_init);

I rather suspect that you'll find that in order to use this in an actual
system this needs to be subsys_initcall().

> +MODULE_ALIAS("platform:da9052_spi");

This isn't a platform driver.
