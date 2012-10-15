Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab2JOKiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 06:38:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53076 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab2JOKiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 06:38:03 -0400
Message-ID: <507BE783.30700@ti.com>
Date: Mon, 15 Oct 2012 16:07:55 +0530
From: Sourav <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Sourav Poddar <sourav.poddar@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <b-cousson@ti.com>,
        <balbi@ti.com>, <santosh.shilimkar@ti.com>
Subject: Re: [PATCHv4] Input: keypad: Add smsc ece1099 keypad driver
References: <1349421986-12467-1-git-send-email-sourav.poddar@ti.com>
In-Reply-To: <1349421986-12467-1-git-send-email-sourav.poddar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,
On Friday 05 October 2012 12:56 PM, Sourav Poddar wrote:
> From: G, Manjunath Kondaiah <manjugk@ti.com>
>
> SMSC ECE1099 is a keyboard scan or GPIO expansion device.The device
> supports a keypad scan matrix of 23*8.This driver uses this
> device as a keypad driver.
>
> Tested on omap5430 evm with 3.6-rc6 custom kernel.
>
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: G, Manjunath Kondaiah <manjugk@ti.com>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> ---
> This patch was posted as a series initially
> http://www.spinics.net/lists/linux-omap/msg78772.html
>
> But the parent mfd driver has beeen already picked by mfd maintainer.
> So this patch can now posted as an standalone patch.
>
> v3->v4:
> Fix Dmitry's comments:
>   - Error patch(input_free_device/input_unregister_device).
>   - Few cleanups.
>   - Included INPUT_MATRIXKMAP
>   drivers/input/keyboard/Kconfig               |   12 +
>   drivers/input/keyboard/Makefile              |    1 +
>   drivers/input/keyboard/smsc-ece1099-keypad.c |  303 ++++++++++++++++++++++++++
>   3 files changed, 316 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/input/keyboard/smsc-ece1099-keypad.c
>
> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
> index c50fa75..e370b03 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -593,6 +593,18 @@ config KEYBOARD_TWL4030
>   	  To compile this driver as a module, choose M here: the
>   	  module will be called twl4030_keypad.
>   
> +config KEYBOARD_SMSC
> +       tristate "SMSC ECE1099 keypad support"
> +       depends on I2C
> +       select INPUT_MATRIXKMAP
> +       help
> +         Say Y here if your board use the smsc keypad controller
> +         for omap5 defconfig. It's safe to say enable this
> +         even on boards that don't use the keypad controller.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called smsc-ece1099-keypad.
> +
>   config KEYBOARD_XTKBD
>   	tristate "XT keyboard"
>   	select SERIO
> diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
> index 44e7600..0f2aa26 100644
> --- a/drivers/input/keyboard/Makefile
> +++ b/drivers/input/keyboard/Makefile
> @@ -52,5 +52,6 @@ obj-$(CONFIG_KEYBOARD_TC3589X)		+= tc3589x-keypad.o
>   obj-$(CONFIG_KEYBOARD_TEGRA)		+= tegra-kbc.o
>   obj-$(CONFIG_KEYBOARD_TNETV107X)	+= tnetv107x-keypad.o
>   obj-$(CONFIG_KEYBOARD_TWL4030)		+= twl4030_keypad.o
> +obj-$(CONFIG_KEYBOARD_SMSC)            += smsc-ece1099-keypad.o
>   obj-$(CONFIG_KEYBOARD_XTKBD)		+= xtkbd.o
>   obj-$(CONFIG_KEYBOARD_W90P910)		+= w90p910_keypad.o
> diff --git a/drivers/input/keyboard/smsc-ece1099-keypad.c b/drivers/input/keyboard/smsc-ece1099-keypad.c
> new file mode 100644
> index 0000000..a4a0dfe
> --- /dev/null
> +++ b/drivers/input/keyboard/smsc-ece1099-keypad.c
> @@ -0,0 +1,303 @@
> +/*
> + * SMSC_ECE1099 Keypad driver
> + *
> + * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/input.h>
> +#include <linux/gpio.h>
> +#include <linux/slab.h>
> +#include <linux/jiffies.h>
> +#include <linux/input/matrix_keypad.h>
> +#include <linux/delay.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/smsc.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of.h>
> +
> +#define KEYPRESS_TIME          200
> +
> +struct smsc_keypad {
> +	struct smsc *smsc;
> +	struct matrix_keymap_data *keymap_data;
> +	unsigned int last_key_state[16];
> +	unsigned int last_col;
> +	unsigned int last_key_ms[16];
> +	unsigned short *keymap;
> +	struct i2c_client *client;
> +	struct input_dev *input;
> +	int rows, cols;
> +	int row_shift;
> +	bool no_autorepeat;
> +	unsigned        irq;
> +	struct device *dev;
> +};
> +
> +static void smsc_kp_scan(struct smsc_keypad *kp)
> +{
> +	struct input_dev *input = kp->input;
> +	int i, j;
> +	int row, col;
> +	int temp, code;
> +	unsigned int new_state[16];
> +	unsigned int bits_changed;
> +	int this_ms;
> +
> +	smsc_write(kp->dev, SMSC_KP_INT_MASK, 0x00);
> +	smsc_write(kp->dev, SMSC_KP_INT_STAT, 0xFF);
> +
> +	/* Scan for row and column */
> +	for (i = 0; i < kp->cols; i++) {
> +		smsc_write(kp->dev, SMSC_KP_OUT, SMSC_KSO_EVAL + i);
> +		/* Read Row Status */
> +		smsc_read(kp->dev, SMSC_KP_IN, &temp);
> +		if (temp == 0xFF)
> +			continue;
> +
> +		col = i;
> +		for (j = 0; j < kp->rows; j++) {
> +			if ((temp & 0x01) != 0x00) {
> +				temp = temp >> 1;
> +				continue;
> +			}
> +
> +			row = j;
> +			new_state[col] =  (1 << row);
> +			bits_changed = kp->last_key_state[col] ^ new_state[col];
> +			this_ms = jiffies_to_msecs(jiffies);
> +			if (bits_changed != 0 || (!bits_changed &&
> +					((this_ms - kp->last_key_ms[col]) >= KEYPRESS_TIME))) {
> +				code = MATRIX_SCAN_CODE(row, col, kp->row_shift);
> +				input_event(input, EV_MSC, MSC_SCAN, code);
> +				input_report_key(input, kp->keymap[code], 1);
> +				input_report_key(input, kp->keymap[code], 0);
> +				kp->last_key_state[col] = new_state[col];
> +				if (kp->last_col != col)
> +					kp->last_key_state[kp->last_col] = 0;
> +				kp->last_key_ms[col] = this_ms;
> +			}
> +			temp = temp >> 1;
> +		}
> +	}
> +	input_sync(input);
> +
> +	smsc_write(kp->dev, SMSC_KP_INT_MASK, 0xFF);
> +
> +	/* Set up Low Power Mode (Wake-up) (0xFB) */
> +	smsc_write(kp->dev, SMSC_WKUP_CTRL, SMSC_KP_SET_LOW_PWR);
> +
> +	/*Enable Keypad Scan (generate interrupt on key press) (0x40)*/
> +	smsc_write(kp->dev, SMSC_KP_OUT, SMSC_KSO_ALL_LOW);
> +}
> +
> +static irqreturn_t do_kp_irq(int irq, void *_kp)
> +{
> +	struct smsc_keypad *kp = _kp;
> +	int int_status;
> +
> +	smsc_read(kp->dev, SMSC_KP_INT_STAT, &int_status);
> +	if (int_status)
> +		smsc_kp_scan(kp);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +#ifdef CONFIG_OF
> +static int __devinit smsc_keypad_parse_dt(struct device *dev,
> +				struct smsc_keypad *kp)
> +{
> +	struct device_node *np = dev->of_node;
> +
> +	if (!np) {
> +		dev_err(dev, "missing DT data");
> +		return -EINVAL;
> +	}
> +
> +	of_property_read_u32(np, "keypad,num-rows", &kp->rows);
> +	of_property_read_u32(np, "keypad,num-columns", &kp->cols);
> +	if (!kp->rows || !kp->cols) {
> +		dev_err(dev, "number of keypad rows/columns not specified\n");
> +		return -EINVAL;
> +	}
> +
> +	if (of_property_read_bool(np, "linux,input-no-autorepeat"))
> +		kp->no_autorepeat = true;
> +
> +	return 0;
> +}
> +#else
> +static inline int smsc_keypad_parse_dt(struct device *dev,
> +				struct smsc_keypad *kp)
> +{
> +	return -ENOSYS;
> +}
> +#endif
> +
> +static int __devinit
> +smsc_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct smsc *smsc = dev_get_drvdata(pdev->dev.parent);
> +	struct input_dev *input;
> +	struct smsc_keypad *kp;
> +	int ret = 0;
> +	int i, max_keys, row_shift;
> +	int irq;
> +	int addr;
> +
> +	kp = devm_kzalloc(dev, sizeof(*kp), GFP_KERNEL);
> +
> +	input = input_allocate_device();
> +	if (!kp || !input) {
> +		ret = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	ret = smsc_keypad_parse_dt(&pdev->dev, kp);
> +	if (ret)
> +		goto err1;
> +
> +	/* Get the debug Device */
> +	kp->input = input;
> +	kp->smsc = smsc;
> +	kp->irq = platform_get_irq(pdev, 0);
> +	kp->dev = dev;
> +
> +	/* setup input device */
> +	 __set_bit(EV_KEY, input->evbit);
> +
> +	/* Enable auto repeat feature of Linux input subsystem */
> +	if (!kp->no_autorepeat)
> +		__set_bit(EV_REP, input->evbit);
> +
> +	input_set_capability(input, EV_MSC, MSC_SCAN);
> +	input->name             = "SMSC Keypad";
> +	input->phys             = "smsc_keypad/input0";
> +	input->dev.parent       = &pdev->dev;
> +	input->id.bustype       = BUS_HOST;
> +	input->id.vendor        = 0x0001;
> +	input->id.product       = 0x0001;
> +	input->id.version       = 0x0003;
> +
> +	/* Mask all GPIO interrupts (0x37-0x3B) */
> +	for (addr = SMSC_GPIO_INT_MASK_START;
> +			addr < SMSC_GPIO_INT_MASK_START + 4; addr++)
> +		smsc_write(dev, addr, 0);
> +
> +	/* Set all outputs high (0x05-0x09) */
> +	for (addr = SMSC_GPIO_DATA_OUT_START;
> +			addr < SMSC_GPIO_DATA_OUT_START + 4; addr++)
> +		smsc_write(dev, addr, 0xff);
> +
> +	/* Clear all GPIO interrupts (0x32-0x36) */
> +	for (addr = SMSC_GPIO_INT_STAT_START;
> +			addr < SMSC_GPIO_INT_STAT_START + 4; addr++)
> +		smsc_write(dev, addr, 0xff);
> +
> +	/* Configure the smsc pins as Keyboard scan Input */
> +	for (i = 0; i <= kp->rows; i++) {
> +		addr = 0x12 + i;
> +		smsc_write(dev, addr, SMSC_KP_KSI);
> +	}
> +
> +	/* Configure the smsc pins as Keyboard scan output */
> +	for (i = 0; i <= kp->cols; i++) {
> +		addr = 0x1A + i;
> +		smsc_write(dev, addr, SMSC_KP_KSO);
> +	}
> +
> +	smsc_write(dev, SMSC_KP_INT_STAT, SMSC_KP_SET_HIGH);
> +	smsc_write(dev, SMSC_WKUP_CTRL, SMSC_KP_SET_LOW_PWR);
> +	smsc_write(dev, SMSC_KP_OUT, SMSC_KSO_ALL_LOW);
> +
> +	row_shift = get_count_order(kp->cols);
> +	max_keys = kp->rows << row_shift;
> +
> +	kp->row_shift = row_shift;
> +	kp->keymap = devm_kzalloc(dev, max_keys * sizeof(kp->keymap[0]),
> +					GFP_KERNEL);
> +	if (!kp->keymap) {
> +		dev_err(&pdev->dev, "Not enough memory for keymap\n");
> +		ret = -ENOMEM;
> +	}
> +
> +	ret = matrix_keypad_build_keymap(NULL, NULL, kp->rows,
> +			kp->cols, kp->keymap, input);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to build keymap\n");
> +		goto err1;
> +	}
> +
> +	/*
> +	* This ISR will always execute in kernel thread context because of
> +	* the need to access the SMSC over the I2C bus.
> +	*/
> +	ret = devm_request_threaded_irq(dev, kp->irq, NULL, do_kp_irq,
> +			IRQF_TRIGGER_FALLING | IRQF_ONESHOT, pdev->name, kp);
> +	if (ret) {
> +		dev_dbg(&pdev->dev, "request_irq failed for irq no=%d\n",
> +			irq);
> +		goto err1;
> +	}
> +
> +	/* Enable smsc keypad interrupts */
> +	ret = smsc_write(dev, SMSC_KP_INT_MASK, 0xff);
> +	if (ret < 0)
> +		goto err2;
> +
> +	ret = input_register_device(input);
> +	if (ret) {
> +		dev_err(kp->dev,
> +			"Unable to register twl4030 keypad device\n");
> +		goto err2;
> +	}
> +
> +	return 0;
> +
> +err2:
> +	free_irq(kp->irq, kp);
> +err1:
> +	input_free_device(input);
> +	return ret;
> +}
> +
> +static int __devexit smsc_remove(struct platform_device *pdev)
> +{
> +	struct smsc_keypad *kp = platform_get_drvdata(pdev);
> +	input_unregister_device(kp->input);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id smsc_keypad_dt_match[] = {
> +	{ .compatible = "smsc,keypad" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, smsc_keypad_dt_match);
> +#endif
> +
> +static struct platform_driver smsc_driver = {
> +	.driver = {
> +		.name	= "smsc-keypad",
> +		.of_match_table = of_match_ptr(smsc_keypad_dt_match),
> +		.owner  = THIS_MODULE,
> +	},
> +	.probe		= smsc_probe,
> +	.remove		= __devexit_p(smsc_remove),
> +};
> +
> +module_platform_driver(smsc_driver);
> +
> +MODULE_AUTHOR("G Kondaiah Manjunath <manjugk@ti.com>");
> +MODULE_DESCRIPTION("SMSC ECE1099 Keypad driver");
> +MODULE_LICENSE("GPL v2");
ping on this?

~Sourav

