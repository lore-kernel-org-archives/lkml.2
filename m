Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab2CSVpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 17:45:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37348 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab2CSVpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 17:45:42 -0400
Message-ID: <4F67A902.40409@wwwdotorg.org>
Date: Mon, 19 Mar 2012 15:45:38 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Thomas Abraham <thomas.abraham@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linus.walleij@linaro.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH 1/5] pinctrl: add samsung pinctrl and gpiolib driver
References: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org> <1331469965-28846-2-git-send-email-thomas.abraham@linaro.org>
In-Reply-To: <1331469965-28846-2-git-send-email-thomas.abraham@linaro.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2012 06:46 AM, Thomas Abraham wrote:
> Add a new pinctrl and gpiolib driver for Samsung SoC's. This driver provides a
> common framework for all Samsung SoC's to interface with the pinctrl and
> gpiolib subsystems.
> 
> This driver is split into two parts: the pinctrl interface and the gpiolib
> interface. The pinctrl interface registers pinctrl devices with the pinctrl
> subsystem and gpiolib interface registers gpio chips with the gpiolib
> subsystem. The information about the pins, pin groups, pin functions and
> gpio chips, which are SoC specific, are all provided to the driver using
> driver data. The driver registers all the pinctrl devices and gpio chips
> which are found in the driver data.

> diff --git a/arch/arm/plat-samsung/include/plat/pinctrl.h b/arch/arm/plat-samsung/include/plat/pinctrl.h

It'd be nice to name this samsung-pinctrl.h, or something other than
just "pinctrl.h". That way, this new header won't cause problems for a
multi-SoC kernel in the future where multiple plat-*/include/plat or
mach-*/include/mach directories are in the include path.

> diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c

> +/* check if the selector is a valid pin function selector */
> +static int samsung_pinmux_list_funcs(struct pinctrl_dev *pctldev,
> +					unsigned selector)
> +{
> +	struct samsung_pinctrl_drv_data *drvdata;
> +
> +	drvdata = pinctrl_dev_get_drvdata(pctldev);
> +	if (selector >= drvdata->nr_groups)
> +		return -EINVAL;

That test should be against something other than nr_groups; nr_functions
or similar, right?

> +static void samsung_pimux_setup(struct pinctrl_dev *pctldev, unsigned selector,

s/pimux/pinmux/

...
> +	const unsigned int *pin;
...
> +	pin = drvdata->pin_groups[group].pins;

It might be a little clearer to rename "pin" to "pins", since it's an
array...

> +
> +	/*
> +	 * for each pin in the pin group selected, program the correspoding pin
> +	 * pin function number in the config register.
> +	 */
> +	for (cnt = 0; cnt < drvdata->pin_groups[group].num_pins; cnt++, pin++) {
> +		pin_to_reg_bank(drvdata->gc, *pin - drvdata->ctrl->base,
> +				&reg, &pin_offset, &bank);

... and say pins[cnt] instead of *pin here (and remove pin++ from the
for loop statement)

But it's just a slight suggestion; your call.

> +static int samsung_pinmux_gpio_set_direction(struct pinctrl_dev *pctldev,
> +		struct pinctrl_gpio_range *range, unsigned offset, bool input)
...
> +	pin_to_reg_bank(range->gc, offset, &reg, &pin_offset, &bank);
> +	mask = (1 << bank->func_width) - 1;
> +	shift = pin_offset * bank->func_width;

It might be useful to put those 3 lines into a helper function since
they're duplicating with samsung_pimux_setup() and similar code is in
samsung_pinconf_set() too.

> +static int samsung_pinconf_group_set(struct pinctrl_dev *pctldev,
> +			unsigned group, unsigned long config)

I think you can leave out group_set(), and the pinctrl core will loop
over all pins in the group for you.

> +static void samsung_gpio_set(struct gpio_chip *gc, unsigned offset, int value)
...
> +	data = readl(reg + DAT_REG);
...
> +	__raw_writel(data, reg + DAT_REG);

Why sometimes use the __raw variants and sometimes not?

> +static int samsung_gpio_direction_output(struct gpio_chip *gc, unsigned offset,
> +							int value)
...
> +	ret = pinctrl_gpio_direction_output(gc->base + offset);
> +	if (!ret)
> +		samsung_gpio_set(gc, offset, value);

This will set the GPIO to output direction before programming the output
value, which might cause a glitch. You may want to try and swap those
two function calls.

> +static int __devinit samsung_pinctrl_probe(struct platform_device *pdev)
...
> +	res = request_mem_region(res->start, resource_size(res),
> +					pdev->name);
> +	if (!res) {
> +		dev_err(&pdev->dev, "request for mem region failed\n");
> +		return -EBUSY;
> +	}
> +
> +	drvdata->virt_base = ioremap(res->start, resource_size(res));

Perhaps replace those two function calls with
devm_request_and_ioremap(), and as a bonus you won't have to unmap or
release the region either.

> +	if (!drvdata->virt_base) {
> +		dev_err(&pdev->dev, "ioremap failed\n");

i.e. you wouldn't have to add the missing error-handling here, and below.

> +		return -EINVAL;
> +	}

> +/* driver data for various samsung soc's */
> +#ifdef CONFIG_CPU_EXYNOS4210
> +
> +#define EXYNOS4210_PCTRL_DRVDATA ((kernel_ulong_t)&exynos4210_pinctrl_drv_data)
> +#else
> +#define EXYNOS4210_PCTRL_DRVDATA ((kernel_ulong_t)NULL)
> +#endif /* CONFIG_CPU_EXYNOS4210 */

Doesn't that interact badly with samsung_pinctrl_get_driver_data()
above, which just blindly adds to the .driver_data field when an entry
is found in samsung_pinctrl_driver_ids[]?

> +static struct platform_device_id samsung_pinctrl_driver_ids[] = {
> +	{
> +		.name		= "exynos4-pinctrl",
> +		.driver_data	= EXYNOS4210_PCTRL_DRVDATA,
> +	},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(platform, samsung_pinctrl_driver_ids);
