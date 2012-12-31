Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab2LaUhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 15:37:20 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:56522 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab2LaUhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 15:37:17 -0500
Date: Mon, 31 Dec 2012 12:37:13 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v2] input: vt8500: Add power button keypad driver
Message-ID: <20121231203713.GC20317@core.coreip.homeip.net>
References: <1356919499-9654-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356919499-9654-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Mon, Dec 31, 2012 at 03:04:59PM +1300, Tony Prisk wrote:
> This patch adds support for the Power Button keypad found on
> Wondermedia netbooks/tablets.
> 
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
> v2:
> Remove devicetree binding for keycode
> Add dependency on OF in Kconfig
> Move static variables in a struct
> Remove redundant inline modifier from kpad_power_timeout()
> Remove unneccessary checks against power_button_pressed. Drop variable.
> Cleanup the fail path code and add a .remove function.
> Change the button behaviour so that a key-released event is only generated once
> the key is released, not after timeout.
> *Changes tested on WM8650 tablet.


Thank you for making the requested changes, unfortunately there is some
more...

> 
>  .../bindings/input/vt8500-power-keypad.txt         |   15 ++
>  drivers/input/keyboard/Kconfig                     |   10 +
>  drivers/input/keyboard/Makefile                    |    1 +
>  drivers/input/keyboard/wmt_power_keypad.c          |  198 ++++++++++++++++++++
>  4 files changed, 224 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/input/vt8500-power-keypad.txt
>  create mode 100644 drivers/input/keyboard/wmt_power_keypad.c
> 
> diff --git a/Documentation/devicetree/bindings/input/vt8500-power-keypad.txt b/Documentation/devicetree/bindings/input/vt8500-power-keypad.txt
> new file mode 100644
> index 0000000..63f170b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/vt8500-power-keypad.txt
> @@ -0,0 +1,15 @@
> +* Wondermedia Power Keypad device tree bindings
> +
> +Wondermedia SoCs have a single irq-driven power button attached to
> +the power management controller.
> +
> +Required SoC Specific Properties:
> +- compatible: should be one of the following
> +   - "wm,power-keypad": For all Wondermedia 8xxx-series SoCs.
> +- interrupts: should be the power management controller wakeup interrupt.
> +
> +Example:
> +	powerkey: pwrkey@0 {
> +		compatible = "wm,power-keypad";
> +		interrupts = <22>;
> +	};
> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
> index 5a240c6..bb1e04f 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -595,6 +595,16 @@ config KEYBOARD_TWL4030
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called twl4030_keypad.
>  
> +config KEYBOARD_WMT_POWER_KEYPAD
> +	tristate "Wondermedia Power keypad support"
> +	depends on (OF && ARCH_VT8500)
> +	help
> +	  Say Y here to enable support for the power button keypad
> +	  on Wondermedia 8xxx-series SoCs.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called wmt_power_keypad.
> +
>  config KEYBOARD_XTKBD
>  	tristate "XT keyboard"
>  	select SERIO
> diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
> index 44e7600..eea31af 100644
> --- a/drivers/input/keyboard/Makefile
> +++ b/drivers/input/keyboard/Makefile
> @@ -52,5 +52,6 @@ obj-$(CONFIG_KEYBOARD_TC3589X)		+= tc3589x-keypad.o
>  obj-$(CONFIG_KEYBOARD_TEGRA)		+= tegra-kbc.o
>  obj-$(CONFIG_KEYBOARD_TNETV107X)	+= tnetv107x-keypad.o
>  obj-$(CONFIG_KEYBOARD_TWL4030)		+= twl4030_keypad.o
> +obj-$(CONFIG_KEYBOARD_WMT_POWER_KEYPAD)	+= wmt_power_keypad.o
>  obj-$(CONFIG_KEYBOARD_XTKBD)		+= xtkbd.o
>  obj-$(CONFIG_KEYBOARD_W90P910)		+= w90p910_keypad.o
> diff --git a/drivers/input/keyboard/wmt_power_keypad.c b/drivers/input/keyboard/wmt_power_keypad.c
> new file mode 100644
> index 0000000..f3b24d8
> --- /dev/null
> +++ b/drivers/input/keyboard/wmt_power_keypad.c
> @@ -0,0 +1,198 @@
> +/* Wondermedia Power Keypad
> + *
> + * Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/input.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/bitops.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_device.h>
> +
> +struct kpad_pwr_data {
> +	struct input_dev	*kpad_power;
> +	void __iomem		*pmc_base;
> +	int			irq;
> +	struct timer_list	timer;
> +	spinlock_t		lock;
> +	unsigned int		keycode;
> +};
> +
> +static void kpad_power_timeout(unsigned long fcontext)
> +{
> +	struct kpad_pwr_data *data = (struct kpad_pwr_data *)fcontext;
> +	u32 status;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&data->lock, flags);
> +
> +	status = readl(data->pmc_base + 0x14);
> +	if (status & BIT(14)) {
> +		/* Button isn't release so check again in 50ms */
> +		mod_timer(&data->timer, jiffies + msecs_to_jiffies(50));

I do not think you need to do this: your ISR does "mod_timer" which
means that the timer expiration gets extended every time there is
interrupt, so as long as the button is pressed the timer will not run.
So I'd just report the button as released here and be done with it.

> +	} else {
> +		/* Send a button released message */
> +		input_report_key(data->kpad_power, data->keycode, 0);
> +		input_sync(data->kpad_power);
> +	}
> +
> +	spin_unlock_irqrestore(&data->lock, flags);
> +}
> +
> +static irqreturn_t kpad_power_isr(int irq_num, void *priv)
> +{
> +	struct kpad_pwr_data *data = priv;
> +	u32 status;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&data->lock, flags);
> +
> +	status = readl(data->pmc_base + 0x14);
> +	writel(status, data->pmc_base + 0x14);
> +
> +	if (status & BIT(14)) {
> +		input_report_key(data->kpad_power, data->keycode, 1);
> +		input_sync(data->kpad_power);
> +		mod_timer(&data->timer, jiffies + msecs_to_jiffies(250));
> +	}
> +
> +	spin_unlock_irqrestore(&data->lock, flags);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int vt8500_pwr_kpad_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np;
> +	struct kpad_pwr_data *data;
> +	u32 status;
> +	int err;
> +
> +	np = of_find_compatible_node(NULL, NULL, "via,vt8500-pmc");
> +	if (!np) {
> +		dev_err(&pdev->dev, "pmc node not found\n");
> +		return -EINVAL;
> +	}

Hmm, why are we looking up another device? What is it is not there yet?
Can we have all resources contained in this device DT description?

> +
> +	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> +	if (!data) {
> +		dev_err(&pdev->dev, "unable to allocate private data\n");
> +		return -ENOMEM;
> +	}
> +
> +	data->keycode = KEY_POWER;
> +	spin_lock_init(&data->lock);
> +
> +	data->pmc_base = of_iomap(np, 0);
> +	if (!data->pmc_base) {
> +		dev_err(&pdev->dev, "unable to map pmc memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	np = pdev->dev.of_node;
> +	if (!np) {
> +		dev_err(&pdev->dev, "devicenode not found\n");

Your error handling is still incomplete, you need to unmap the memory
you just mapped above.

I happened to peek at other vt8500 drivers and the lack of proper error
handling and absence of remove() methods is a common theme among them.


> +		return -ENODEV;
> +	}
> +
> +	/* set power button to soft-power */
> +	status = readl(data->pmc_base + 0x54);
> +	writel(status | 1, data->pmc_base + 0x54);
> +
> +	/* clear any pending interrupts */
> +	status = readl(data->pmc_base + 0x14);
> +	writel(status, data->pmc_base + 0x14);
> +
> +	data->kpad_power = input_allocate_device();
> +	if (!data->kpad_power) {
> +		dev_err(&pdev->dev, "failed to allocate input device\n");
> +		return -ENOMEM;
> +	}
> +
> +	data->kpad_power->evbit[0] = BIT_MASK(EV_KEY);
> +	set_bit(data->keycode, data->kpad_power->keybit);

Make it:

	input_set_capability(data->kpad_power, EV_KEY, data->keycode);

> +
> +	data->kpad_power->name = "wmt_power_keypad";
> +	data->kpad_power->phys = "wmt_power_keypad";

You can have more "human" name in name field, you do not have to have
underscores. Also if you want to use phys it is common to have it in
form of "<parent device>/input0" so something like "vt8500-pmic/input0".

> +	data->kpad_power->keycode = &data->keycode;
> +	data->kpad_power->keycodesize = sizeof(unsigned int);
> +	data->kpad_power->keycodemax = 1;
> +
> +	err = input_register_device(data->kpad_power);
> +	if (err < 0) {
> +		dev_err(&pdev->dev, "failed to register input device\n");
> +		goto cleanup_input;
> +	}
> +

I'd recommend registering input device after you request irq as it
simplifies error path (it is OK for ISR to use allocated but not
registered input device).

> +	setup_timer(&data->timer, kpad_power_timeout, (unsigned long)data);
> +
> +	data->irq = irq_of_parse_and_map(np, 0);
> +	err = request_irq(data->irq, &kpad_power_isr, 0, "pwrbtn", data);
> +	if (err < 0) {
> +		dev_err(&pdev->dev, "failed to request irq\n");
> +		goto cleanup_irq;
> +	}
> +
> +	platform_set_drvdata(pdev, data);
> +
> +	return 0;
> +
> +cleanup_irq:
> +	del_timer(&data->timer);
> +cleanup_input:
> +	input_free_device(data->kpad_power);
> +
> +	return err;
> +}
> +
> +static int vt8500_pwr_kpad_remove(struct platform_device *pdev)
> +
> +{
> +	struct kpad_pwr_data *data = platform_get_drvdata(pdev);
> +
> +	free_irq(data->irq, data);
> +	del_timer(&data->timer);

This should be del_timer_sync().

> +	input_unregister_device(data->kpad_power);
> +	input_free_device(data->kpad_power);

input_free_device() after input_unregister_device() will result in
double-free. The rule is use input_free_device() if device has not been
registered, otherwise use input_unregister_device().

You also need to unmap the mapped region.

> +
> +	return 0;
> +}
> +
> +
> +static struct of_device_id vt8500_pwr_kpad_dt_ids[] = {
> +	{ .compatible = "wm,power-keypad" },
> +	{ /* Sentinel */ },
> +};
> +
> +static struct platform_driver vt8500_pwr_kpad_driver = {
> +	.probe		= vt8500_pwr_kpad_probe,
> +	.remove		= vt8500_pwr_kpad_remove,
> +	.driver		= {
> +		.name	= "wmt-power-keypad",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = vt8500_pwr_kpad_dt_ids,
> +	},
> +};
> +
> +module_platform_driver(vt8500_pwr_kpad_driver);
> +
> +MODULE_DESCRIPTION("Wondermedia Power Keypad Driver");
> +MODULE_AUTHOR("Tony Prisk <linux@prisktech.co.nz>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_DEVICE_TABLE(of, vt8500_pwr_kpad_dt_ids);
> -- 
> 1.7.9.5
> 

Thanks.

-- 
Dmitry
