Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab2IBOoc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 10:44:32 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:64959 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753681Ab2IBOob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 10:44:31 -0400
Message-ID: <504370BF.6090702@metafoo.de>
Date: Sun, 02 Sep 2012 16:44:15 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Antony Pavlov <antonynpavlov@gmail.com>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: Re: [PATCH 3/3] pwm: Add Ingenic JZ4740 support
References: <1346579550-5990-1-git-send-email-thierry.reding@avionic-design.de> <1346579550-5990-4-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1346579550-5990-4-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2012 11:52 AM, Thierry Reding wrote:
> This commit moves the driver to drivers/pwm and converts it to the new
> PWM framework.
> 

Thanks for taking care of this, some comments inline.

[...]
> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> index 92b1782..f5acdaa 100644
> --- a/drivers/pwm/core.c
> +++ b/drivers/pwm/core.c
> @@ -371,7 +371,7 @@ EXPORT_SYMBOL_GPL(pwm_free);
>   */
>  int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
>  {
> -	if (!pwm || period_ns == 0 || duty_ns > period_ns)
> +	if (!pwm || duty_ns < 0 || period_ns <= 0 || duty_ns > period_ns)
>  		return -EINVAL;
>  

This change seems to be unrelated.

>  	return pwm->chip->ops->config(pwm->chip, pwm, duty_ns, period_ns);
> diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
> new file mode 100644
> index 0000000..db29b37
> --- /dev/null
> +++ b/drivers/pwm/pwm-jz4740.c
> @@ -0,0 +1,205 @@
> +/*
> + *  Copyright (C) 2010, Lars-Peter Clausen <lars@metafoo.de>
> + *  JZ4740 platform PWM support
> + *
> + *  This program is free software; you can redistribute it and/or modify it
> + *  under  the terms of the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the License, or (at your
> + *  option) any later version.
> + *
> + *  You should have received a copy of the GNU General Public License along
> + *  with this program; if not, write to the Free Software Foundation, Inc.,
> + *  675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/gpio.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +
> +#include <asm/mach-jz4740/gpio.h>
> +#include <timer.h>

#include <asm/mach-jz4740/timer.h>

> +
> +#define NUM_PWM 6
> +
> +static const unsigned int jz4740_pwm_gpio_list[NUM_PWM] = {

As mth said, it would be better to have JZ_GPIO_PWM0 and here as well and set
NUM_PWM to 8. Right now we are using the timers associated to PWM channel 0 and
1 as system timers. But there might be devices where this is not possible, e.g.
because the PWM is actually connected to something. Also this fixes the of by
two for the hwpwm id.

> +	JZ_GPIO_PWM2,
> +	JZ_GPIO_PWM3,
> +	JZ_GPIO_PWM4,
> +	JZ_GPIO_PWM5,
> +	JZ_GPIO_PWM6,
> +	JZ_GPIO_PWM7,
> +};
> +
> +struct jz4740_pwm_chip {
> +	struct pwm_chip chip;
> +	struct clk *clk;
> +};
> +
> +static inline struct jz4740_pwm_chip *to_jz4740(struct pwm_chip *chip)
> +{
> +	return container_of(chip, struct jz4740_pwm_chip, chip);
> +}
> +
> +static int jz4740_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	unsigned int gpio = jz4740_pwm_gpio_list[pwm->hwpwm];
> +	int ret;
> +
> +	ret = gpio_request(gpio, pwm->label);
> +
> +	if (ret) {
> +		printk(KERN_ERR "Failed to request pwm gpio: %d\n", ret);

dev_err(chip->dev, ....

> +		return ret;
> +	}
> +
> +	jz_gpio_set_function(gpio, JZ_GPIO_FUNC_PWM);
> +
> +	jz4740_timer_start(pwm->hwpwm);
> +
> +	return 0;
> +}
> +
> +static void jz4740_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	unsigned int gpio = jz4740_pwm_gpio_list[pwm->hwpwm];
> +
> +	jz4740_timer_set_ctrl(pwm->hwpwm, 0);
> +
> +	jz_gpio_set_function(gpio, JZ_GPIO_FUNC_NONE);
> +	gpio_free(gpio);
> +
> +	jz4740_timer_stop(pwm->hwpwm);
> +}
> +
> +static int jz4740_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +			     int duty_ns, int period_ns)
> +{
> +	struct jz4740_pwm_chip *jz4740 = to_jz4740(pwm->chip);
> +	unsigned long long tmp;
> +	unsigned long period, duty;
> +	unsigned int prescaler = 0;
> +	uint16_t ctrl;
> +	bool is_enabled;
> +
> +	tmp = (unsigned long long)clk_get_rate(jz4740->clk) * period_ns;
> +	do_div(tmp, 1000000000);
> +	period = tmp;
> +
> +	while (period > 0xffff && prescaler < 6) {
> +		period >>= 2;
> +		++prescaler;
> +	}
> +
> +	if (prescaler == 6)
> +		return -EINVAL;
> +
> +	tmp = (unsigned long long)period * duty_ns;
> +	do_div(tmp, period_ns);
> +	duty = period - tmp;
> +
> +	if (duty >= period)
> +		duty = period - 1;
> +
> +	is_enabled = jz4740_timer_is_enabled(pwm->hwpwm);
> +	if (is_enabled)
> +		pwm_disable(pwm);

I think this should be jz4740_pwm_disable

> +
> +	jz4740_timer_set_count(pwm->hwpwm, 0);
> +	jz4740_timer_set_duty(pwm->hwpwm, duty);
> +	jz4740_timer_set_period(pwm->hwpwm, period);
> +
> +	ctrl = JZ_TIMER_CTRL_PRESCALER(prescaler) | JZ_TIMER_CTRL_SRC_EXT |
> +		JZ_TIMER_CTRL_PWM_ABBRUPT_SHUTDOWN;
> +
> +	jz4740_timer_set_ctrl(pwm->hwpwm, ctrl);
> +
> +	if (is_enabled)
> +		pwm_enable(pwm);

and jz4740_pwm_enable here.

> +
> +	return 0;
> +}
> +

> +
> +static const struct pwm_ops jz4740_pwm_ops = {
> +	.request = jz4740_pwm_request,
> +	.free = jz4740_pwm_free,
> +	.config = jz4740_pwm_config,
> +	.enable = jz4740_pwm_enable,
> +	.disable = jz4740_pwm_disable,

.owner = THIS_MODULE,

> +};
> +
> +static int jz4740_pwm_probe(struct platform_device *pdev)
__devinit
> +{
> +	struct jz4740_pwm_chip *jz4740;
> +	int ret = 0;

The '= 0' is not really necessary since it will be overwritten anyway.

> +
> +	jz4740 = devm_kzalloc(&pdev->dev, sizeof(*jz4740), GFP_KERNEL);
> +	if (!jz4740)
> +		return -ENOMEM;
> +
> +	jz4740->clk = clk_get(NULL, "ext");
> +	if (IS_ERR(jz4740->clk))
> +		return PTR_ERR(jz4740->clk);
> +
> +	jz4740->chip.dev = &pdev->dev;
> +	jz4740->chip.ops = &jz4740_pwm_ops;
> +	jz4740->chip.npwm = NUM_PWM;
> +	jz4740->chip.base = -1;
> +
> +	ret = pwmchip_add(&jz4740->chip);
> +	if (ret < 0) {
> +		clk_put(jz4740->clk);
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, jz4740);
> +
> +	return 0;
> +}
> +
> +static int jz4740_pwm_remove(struct platform_device *pdev)
__devexit
> +{
> +	struct jz4740_pwm_chip *jz4740 = platform_get_drvdata(pdev);
> +	int ret;
> +
> +	ret = pwmchip_remove(&jz4740->chip);
> +	if (ret < 0)
> +		return ret;

remove is not really allowed to fail, the return value is never really tested
and the device is removed nevertheless. But this seems to be a problem with the
PWM API. It should be possible to remove a PWM chip even if it is currently in
use and after a PWM chip has been removed all calls to a pwm_device of that
chip it should return an error. This will require reference counting for the
pwm_device struct though. E.g. by adding a 'struct device' to it.

> +
> +	clk_put(jz4740->clk);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver jz4740_pwm_driver = {
> +	.driver = {
> +		.name = "jz4740-pwm",

.owner = THIS_MODULE,

> +	},
> +	.probe = jz4740_pwm_probe,
> +	.remove = jz4740_pwm_remove,

.remove = __devexit_p(jz4740_pwm_remove),

> +};
> +module_platform_driver(jz4740_pwm_driver);

MODULE_LICENSE(...), MODULE_AUTHOR(...), MODULE_DESCRIPTION(...), MODULE_ALIAS(...)
