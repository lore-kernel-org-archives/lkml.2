Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab2L3XZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 18:25:33 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:33173 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab2L3XZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 18:25:31 -0500
Date: Sun, 30 Dec 2012 15:25:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] input: vt8500: Add power button keypad driver
Message-ID: <20121230232527.GA13899@core.coreip.homeip.net>
References: <1356904862-16417-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356904862-16417-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Mon, Dec 31, 2012 at 11:01:02AM +1300, Tony Prisk wrote:
> This patch adds support for the Power Button keypad found on
> Wondermedia netbooks/tablets.
> 
> A keymap property is exposed to allowing defining the key
> event to be generated when the power button is pressed.
> 
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
>  .../bindings/input/vt8500-power-keypad.txt         |   17 ++
>  drivers/input/keyboard/Kconfig                     |   10 ++
>  drivers/input/keyboard/Makefile                    |    1 +
>  drivers/input/keyboard/wmt_power_keypad.c          |  174 ++++++++++++++++++++
>  4 files changed, 202 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/input/vt8500-power-keypad.txt
>  create mode 100644 drivers/input/keyboard/wmt_power_keypad.c
> 
> diff --git a/Documentation/devicetree/bindings/input/vt8500-power-keypad.txt b/Documentation/devicetree/bindings/input/vt8500-power-keypad.txt
> new file mode 100644
> index 0000000..bae6228
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/vt8500-power-keypad.txt
> @@ -0,0 +1,17 @@
> +* Wondermedia Power Keypad device tree bindings
> +
> +Wondermedia SoCs have a single irq-driven power button attached to
> +the power management controller.
> +
> +Required SoC Specific Properties:
> +- compatible: should be one of the following
> +   - "wm,power-keypad": For all Wondermedia 8xxx-series SoCs.
> +- interrupts: should be the power management controller wakeup interrupt.
> +- keymap: linux keycode to generate when power button pressed.
> +
> +Example:
> +	powerkey: pwrkey@0 {
> +		compatible = "wm,power-keypad";
> +		interrupts = <22>;
> +		keymap = <116>; /* KEY_POWER */

Do we really need this in DT? I'd say just having it manageable from
userspace is enough.

> +	};
> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
> index 5a240c6..c270f27 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -595,6 +595,16 @@ config KEYBOARD_TWL4030
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called twl4030_keypad.
>  
> +config KEYBOARD_WMT_POWER_KEYPAD
> +	tristate "Wondermedia Power keypad support"
> +	depends on ARCH_VT8500

I'd feel safer if we added "depends on OF" as well.

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
> index 0000000..ce8aa9a
> --- /dev/null
> +++ b/drivers/input/keyboard/wmt_power_keypad.c
> @@ -0,0 +1,174 @@
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
> +static void __iomem *pmc_base;
> +static struct input_dev *kpad_power;
> +static spinlock_t kpad_power_lock;
> +static int power_button_pressed;
> +static struct timer_list kpad_power_timer;
> +static unsigned int kpad_power_code;

Maybe wrap it in a structure?

> +
> +static inline void kpad_power_timeout(unsigned long fcontext)

Why inline? It can't be inlined anyway since its address is used.

> +{
> +	u32 status;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&kpad_power_lock, flags);
> +
> +	status = readl(pmc_base + 0x14);
> +
> +	if (power_button_pressed) {

This check is useless, you won't ever get here if button hasn't been
pressed.

> +		input_report_key(kpad_power, kpad_power_code, 0);
> +		input_sync(kpad_power);
> +		power_button_pressed = 0;
> +	}
> +
> +	spin_unlock_irqrestore(&kpad_power_lock, flags);
> +}
> +
> +static irqreturn_t kpad_power_isr(int irq_num, void *data)
> +{
> +	u32 status;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&kpad_power_lock, flags);
> +
> +	status = readl(pmc_base + 0x14);
> +	udelay(100);
> +	writel(status, pmc_base + 0x14);
> +
> +	if (status & BIT(14)) {
> +		if (!power_button_pressed) {

No need to do this check.

> +			input_report_key(kpad_power, kpad_power_code, 1);
> +			input_sync(kpad_power);
> +
> +			power_button_pressed = 1;
> +
> +			mod_timer(&kpad_power_timer,
> +				  jiffies + msecs_to_jiffies(500));
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&kpad_power_lock, flags);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int vt8500_pwr_kpad_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np;
> +	u32 status;
> +	int err;
> +	int irq;
> +
> +	np = of_find_compatible_node(NULL, NULL, "via,vt8500-pmc");
> +	if (!np) {
> +		dev_err(&pdev->dev, "pmc node not found\n");
> +		return -EINVAL;
> +	}
> +
> +	pmc_base = of_iomap(np, 0);
> +	if (!pmc_base) {
> +		dev_err(&pdev->dev, "unable to map pmc memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	np = pdev->dev.of_node;
> +	if (!np) {
> +		dev_err(&pdev->dev, "devicenode not found\n");
> +		return -ENODEV;
> +	}
> +
> +	err = of_property_read_u32(np, "keymap", &kpad_power_code);
> +	if (err) {
> +		dev_warn(&pdev->dev, "defaulting to KEY_POWER\n");
> +		kpad_power_code = KEY_POWER;
> +	}
> +
> +	/* set power button to soft-power */
> +	status = readl(pmc_base + 0x54);
> +	writel(status | 1, pmc_base + 0x54);
> +
> +	/* clear any pending interrupts */
> +	status = readl(pmc_base + 0x14);
> +	writel(status, pmc_base + 0x14);
> +
> +	kpad_power = input_allocate_device();
> +	if (!kpad_power) {
> +		dev_err(&pdev->dev, "failed to allocate input device\n");
> +		return -ENOMEM;
> +	}
> +
> +	spin_lock_init(&kpad_power_lock);
> +	setup_timer(&kpad_power_timer, kpad_power_timeout,
> +				       (unsigned long)kpad_power);
> +
> +	irq = irq_of_parse_and_map(np, 0);
> +	err = request_irq(irq, &kpad_power_isr, 0, "pwrbtn", NULL);
> +	if (err < 0) {
> +		dev_err(&pdev->dev, "failed to request irq\n");
> +		return err;
> +	}
> +
> +	kpad_power->evbit[0] = BIT_MASK(EV_KEY);
> +	set_bit(kpad_power_code, kpad_power->keybit);
> +
> +	kpad_power->name = "wmt_power_keypad";
> +	kpad_power->phys = "wmt_power_keypad";
> +	kpad_power->keycode = &kpad_power_code;
> +	kpad_power->keycodesize = sizeof(unsigned int);
> +	kpad_power->keycodemax = 1;
> +
> +	err = input_register_device(kpad_power);
> +	if (err < 0) {
> +		dev_err(&pdev->dev, "failed to register input device\n");

You either need to use managed resources or clean up after yourself;
leaking memory and other resources is not nice. Given that you are using
timer, which needs to be canceled, and I am not sure if your device
allows enabling/disabling generating interrupts while keeping the
interrupt handler registered, manual cleanup looks like the only option
for you.

BTW, where is your remove() method?

> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct of_device_id vt8500_pwr_kpad_dt_ids[] = {
> +	{ .compatible = "wm,power-keypad" },
> +	{ /* Sentinel */ },
> +};
> +
> +static struct platform_driver vt8500_pwr_kpad_driver = {
> +	.probe		= vt8500_pwr_kpad_probe,
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

Thanks.

-- 
Dmitry
