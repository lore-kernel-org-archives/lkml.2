Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab2LLQJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:09:18 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57875 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab2LLQJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:09:16 -0500
Message-ID: <50C8ABFC.3080309@ti.com>
Date: Wed, 12 Dec 2012 10:08:28 -0600
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Erickson <marathon96@gmail.com>, <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP: add pwm driver using dmtimers.
References: <20121212192430.50cea126@notabene.brown>
In-Reply-To: <20121212192430.50cea126@notabene.brown>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.157.144.139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On 12/12/2012 02:24 AM, NeilBrown wrote:
> 
> 
> This patch is based on an earlier patch by Grant Erickson
> which provided pwm devices using the 'legacy' interface.
> 
> This driver instead uses the new framework interface.
> 
> Cc: Grant Erickson <marathon96@gmail.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index ed81720..7df573a 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -85,6 +85,15 @@ config PWM_MXS
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-mxs.
>  
> +config PWM_OMAP
> +	tristate "OMAP pwm support"
> +	depends on ARCH_OMAP

We should probably have depends on or selects OMAP_DM_TIMER here too.

> +	help
> +	  Generic PWM framework driver for OMAP
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called pwm-omap
> +
>  config PWM_PUV3
>  	tristate "PKUnity NetBook-0916 PWM support"
>  	depends on ARCH_PUV3
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index acfe482..f5d200d 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -5,6 +5,7 @@ obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
>  obj-$(CONFIG_PWM_JZ4740)	+= pwm-jz4740.o
>  obj-$(CONFIG_PWM_LPC32XX)	+= pwm-lpc32xx.o
>  obj-$(CONFIG_PWM_MXS)		+= pwm-mxs.o
> +obj-$(CONFIG_PWM_OMAP)		+= pwm-omap.o
>  obj-$(CONFIG_PWM_PUV3)		+= pwm-puv3.o
>  obj-$(CONFIG_PWM_PXA)		+= pwm-pxa.o
>  obj-$(CONFIG_PWM_SAMSUNG)	+= pwm-samsung.o
> diff --git a/drivers/pwm/pwm-omap.c b/drivers/pwm/pwm-omap.c
> new file mode 100644
> index 0000000..e3dbce3
> --- /dev/null
> +++ b/drivers/pwm/pwm-omap.c
> @@ -0,0 +1,318 @@
> +/*
> + *    Copyright (c) 2012 NeilBrown <neilb@suse.de>
> + *    Heavily based on earlier code which is:
> + *    Copyright (c) 2010 Grant Erickson <marathon96@gmail.com>
> + *
> + *    Also based on pwm-samsung.c
> + *
> + *    This program is free software; you can redistribute it and/or
> + *    modify it under the terms of the GNU General Public License
> + *    version 2 as published by the Free Software Foundation.
> + *
> + *    Description:
> + *      This file is the core OMAP2/3 support for the generic, Linux

I would drop the OMAP2/3 and just say OMAP here. Potentially this should
work for OMAP1-5.

> + *      PWM driver / controller, using the OMAP's dual-mode timers.
> + *
> + *    The 'id' number for the device encodes the number of the dm timer
> + *    to use, and the polarity of the output.
> + *    lsb is '1' of active-high, and '0' for active low
> + *    remaining bit a timer number and need to be shifted down before use.
> + */
> +
> +#define pr_fmt(fmt) "pwm-omap: " fmt
> +
> +#include <linux/export.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/pwm.h>
> +#include <linux/module.h>
> +
> +#include <plat/dmtimer.h>

This is going to be a problem for the single zImage work, because we
cannot include any plat headers in driver code any more. Therefore,
although it is not ideal, one way to handle this is pass function
pointers to the various dmtimer APIs that are needed via the platform
data. Painful I know ...

> +#define DM_TIMER_LOAD_MIN		0xFFFFFFFE
> +
> +struct omap_chip {
> +	struct platform_device	*pdev;
> +
> +	struct omap_dm_timer	*dm_timer;
> +	unsigned int		polarity;
> +	const char		*label;
> +
> +	unsigned int		duty_ns, period_ns;
> +	struct pwm_chip		chip;
> +};
> +
> +#define to_omap_chip(chip)	container_of(chip, struct omap_chip, chip)
> +
> +#define	pwm_dbg(_pwm, msg...) dev_dbg(&(_pwm)->pdev->dev, msg)
> +
> +/**
> + * pwm_calc_value - determines the counter value for a clock rate and period.
> + * @clk_rate: The clock rate, in Hz, of the PWM's clock source to compute the
> + *            counter value for.
> + * @ns: The period, in nanoseconds, to computer the counter value for.
> + *
> + * Returns the PWM counter value for the specified clock rate and period.
> + */
> +static inline int pwm_calc_value(unsigned long clk_rate, int ns)
> +{
> +	const unsigned long nanoseconds_per_second = 1000000000;
> +	int cycles;
> +	__u64 c;
> +
> +	c = (__u64)clk_rate * ns;
> +	do_div(c, nanoseconds_per_second);
> +	cycles = c;
> +
> +	return DM_TIMER_LOAD_MIN - cycles;
> +}
> +
> +static int omap_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct omap_chip *omap = to_omap_chip(chip);
> +	int status = 0;
> +
> +	/* Enable the counter--always--before attempting to write its
> +	 * registers and then set the timer to its minimum load value to
> +	 * ensure we get an overflow event right away once we start it.
> +	 */
> +
> +	omap_dm_timer_enable(omap->dm_timer);
> +	omap_dm_timer_write_counter(omap->dm_timer, DM_TIMER_LOAD_MIN);
> +	omap_dm_timer_start(omap->dm_timer);
> +	omap_dm_timer_disable(omap->dm_timer);

Why not just use omap_dm_timer_load_start() here instead of the above 4
APIs?

> +
> +	return status;
> +}
> +
> +static void omap_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct omap_chip *omap = to_omap_chip(chip);
> +
> +	omap_dm_timer_stop(omap->dm_timer);
> +}
> +
> +static int omap_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +			   int duty_ns, int period_ns)
> +{
> +	struct omap_chip *omap = to_omap_chip(chip);
> +	int status = 0;
> +	const bool enable = true;
> +	const bool autoreload = true;
> +	const bool toggle = true;
> +	const int trigger = OMAP_TIMER_TRIGGER_OVERFLOW_AND_COMPARE;
> +	int load_value, match_value;
> +	unsigned long clk_rate;
> +
> +	dev_dbg(chip->dev,
> +		"duty cycle: %d, period %d\n",
> +		duty_ns, period_ns);
> +
> +	if (omap->duty_ns == duty_ns &&
> +	    omap->period_ns == period_ns)
> +		/* No change - don't cause any transients */
> +		return 0;
> +
> +	clk_rate = clk_get_rate(omap_dm_timer_get_fclk(omap->dm_timer));
> +
> +	/* Calculate the appropriate load and match values based on the
> +	 * specified period and duty cycle. The load value determines the
> +	 * cycle time and the match value determines the duty cycle.
> +	 */
> +
> +	load_value = pwm_calc_value(clk_rate, period_ns);
> +	match_value = pwm_calc_value(clk_rate, period_ns - duty_ns);
> +
> +	/* We MUST enable yet stop the associated dual-mode timer before
> +	 * attempting to write its registers.  Hopefully it is already
> +	 * disabled, but call the (idempotent) pwm_disable just in case
> +	 */
> +
> +	pwm_disable(pwm);
> +
> +	omap_dm_timer_enable(omap->dm_timer);

Do you need to call omap_dm_timer_enable here? _set_load and _set_match
will enable the timer. So this should not be necessary.

> +	omap_dm_timer_set_load(omap->dm_timer, autoreload, load_value);
> +	omap_dm_timer_set_match(omap->dm_timer, enable, match_value);
> +
> +	dev_dbg(chip->dev,
> +			"load value: %#08x (%d), "
> +			"match value: %#08x (%d)\n",
> +			load_value, load_value,
> +			match_value, match_value);
> +
> +	omap_dm_timer_set_pwm(omap->dm_timer,
> +			      !omap->polarity,
> +			      toggle,
> +			      trigger);
> +
> +	/* Set the counter to generate an overflow event immediately. */
> +
> +	omap_dm_timer_write_counter(omap->dm_timer, DM_TIMER_LOAD_MIN);
> +
> +	/* Now that we're done configuring the dual-mode timer, disable it
> +	 * again. We'll enable and start it later, when requested.
> +	 */
> +
> +	omap_dm_timer_disable(omap->dm_timer);

Similarly the disable should not be needed here either.

> +	omap->duty_ns = duty_ns;
> +	omap->period_ns = period_ns;
> +
> +	return status;
> +}
> +
> +
> +static struct pwm_ops omap_pwm_ops = {
> +	.enable	= omap_pwm_enable,
> +	.disable= omap_pwm_disable,
> +	.config	= omap_pwm_config,
> +	.owner	= THIS_MODULE,
> +};
> +
> +/**
> + * omap_pwm_probe - check for the PWM and bind it to the driver.
> + * @pdev: A pointer to the platform device node associated with the
> + *        PWM instance to be probed for driver binding.
> + *
> + * Returns 0 if the PWM instance was successfully bound to the driver;
> + * otherwise, < 0 on error.
> + */
> +static int __devinit omap_pwm_probe(struct platform_device *pdev)

I believe that __devinit is no longer required.

> +{
> +	struct device *dev = &pdev->dev;
> +	struct omap_chip *omap;
> +	int status = 0;
> +	unsigned int id = pdev->id;
> +	unsigned int timer = id >> 1; /* lsb is polarity */
> +
> +	omap = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
> +
> +	if (omap == NULL) {
> +		dev_err(dev, "Could not allocate memory.\n");
> +		status = -ENOMEM;
> +		goto done;
> +	}
> +
> +	/* Request the OMAP dual-mode timer that will be bound to and
> +	 * associated with this generic PWM.
> +	 */
> +
> +	omap->dm_timer = omap_dm_timer_request_specific(timer);

I would recommend that you use omap_dm_timer_request_by_cap() (new for
v3.8 so you should be able to use once v3.8-rc1 is out) here to request
a timer that supports the PWM output. The above function will not be
supported when booting with device-tree.

> +
> +	if (omap->dm_timer == NULL) {
> +		status = -EPROBE_DEFER;
> +		goto err_free;
> +	}
> +
> +	/* Configure the source for the dual-mode timer backing this
> +	 * generic PWM device. The clock source will ultimately determine
> +	 * how small or large the PWM frequency can be.
> +	 *
> +	 * At some point, it's probably worth revisiting moving this to
> +	 * the configure method and choosing either the slow- or
> +	 * system-clock source as appropriate for the desired PWM period.
> +	 */
> +
> +	omap_dm_timer_set_source(omap->dm_timer, OMAP_TIMER_SRC_SYS_CLK);
> +
> +	/* Cache away other miscellaneous driver-private data and state
> +	 * information and add the driver-private data to the platform
> +	 * device.
> +	 */
> +
> +	omap->chip.dev = dev;
> +	omap->chip.ops = &omap_pwm_ops;
> +	omap->chip.base = -1;
> +	omap->chip.npwm = 1;
> +	omap->polarity = id & 1;
> +
> +	status = pwmchip_add(&omap->chip);
> +	if (status < 0) {
> +		dev_err(dev, "failed to register pwm\n");
> +		omap_dm_timer_free(omap->dm_timer);
> +		goto err_free;
> +	}
> +
> +	platform_set_drvdata(pdev, omap);
> +
> +	status = 0;
> +	goto done;
> +
> + err_free:
> +	kfree(omap);
> + done:
> +	return status;
> +}
> +
> +/**
> + * omap_pwm_remove - unbind the specified PWM platform device from the driver.
> + * @pdev: A pointer to the platform device node associated with the
> + *        PWM instance to be unbound/removed.
> + *
> + * Returns 0 if the PWM was successfully removed as a platform device;
> + * otherwise, < 0 on error.
> + */
> +static int __devexit omap_pwm_remove(struct platform_device *pdev)

I believe that __devexit is no longer required.

> +{
> +	struct omap_chip *omap = platform_get_drvdata(pdev);
> +	int status = 0;
> +
> +	status = pwmchip_remove(&omap->chip);
> +	if (status < 0)
> +		goto done;
> +
> +	omap_dm_timer_free(omap->dm_timer);

Is it guaranteed that the timer will be disabled at this point?

> +
> +	kfree(omap);
> +
> + done:
> +	return status;
> +}
> +
> +#if CONFIG_PM
> +static int omap_pwm_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	struct omap_chip *omap = platform_get_drvdata(pdev);
> +	/* No one preserve these values during suspend so reset them
> +	 * Otherwise driver leaves PWM unconfigured if same values
> +	 * passed to pwm_config
> +	 */
> +	omap->period_ns = 0;
> +	omap->duty_ns = 0;


Hmmm, looks like you are trying to force a reconfiguration after suspend
if the same values are used. Is there an underlying problem here that
you are trying to workaround?

Please note that I am not familiar with the PWM sub-system to know how
suspend-resume is typically handled and if this is normal or not.

> +	return 0;
> +}
> +#else
> +#define omap_pwm_suspend	NULL
> +#endif
> +
> +static struct platform_driver omap_pwm_driver = {
> +	.driver.name	= "omap-pwm",
> +	.driver.owner	= THIS_MODULE,
> +	.probe		= omap_pwm_probe,
> +	.remove		= __devexit_p(omap_pwm_remove),

I believe that __devexit_p is no longer required.

Otherwise it looks good to me. Thanks for sending!

Cheers
Jon
