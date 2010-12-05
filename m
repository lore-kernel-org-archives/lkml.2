Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab0LESiv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 13:38:51 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63791 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0LESit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 13:38:49 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6188"; a="65570694"
Message-ID: <4CFBDC12.2030505@codeaurora.org>
Date: Mon, 06 Dec 2010 00:08:10 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Sundar Iyer <sundar.iyer@stericsson.com>
CC: linux-arm-kernel@lists.infradead.org, dmitry.torokhov@gmail.com,
        sameo@linux.intel.com, ben-linux@fluff.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/20] input/tc3589x: add tc3589x keypad support
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com> <1291388753-14662-11-git-send-email-sundar.iyer@stericsson.com>
In-Reply-To: <1291388753-14662-11-git-send-email-sundar.iyer@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sundar,

> diff --git a/drivers/input/keyboard/tc3589x-keypad.c b/drivers/input/keyboard/tc3589x-keypad.c
> new file mode 100644
> index 0000000..1bfd49a
> --- /dev/null
> +++ b/drivers/input/keyboard/tc3589x-keypad.c
> @@ -0,0 +1,440 @@
> +/*
> + * Copyright (C) ST-Ericsson SA 2010
> + *
> + * Author: Jayeeta Banerjee <jayeeta.banerjee@stericsson.com>
> + * Author: Sundar Iyer <sundar.iyer@stericsson.com>
> + *
> + * License Terms: GNU General Public License, version 2
> + *
> + * TC35893 MFD Keypad Controller driver
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/spinlock.h>

I haven't seen spinlock usage anywhere in this code.

> +#include <linux/input.h>
> +#include <linux/platform_device.h>
> +#include <linux/input/matrix_keypad.h>
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <linux/mfd/tc3589x.h>
> +
> +/* Maximum supported keypad matrix row/columns size */
> +#define TC3589x_MAX_KPROW               8
> +#define TC3589x_MAX_KPCOL               12
> +
> +/* keypad related Constants */
> +#define TC3589x_MAX_DEBOUNCE_SETTLE     0xFF
> +#define DEDICATED_KEY_VAL		0xFF
> +
> +/* Pull up/down masks */
> +#define TC3589x_NO_PULL_MASK		0x0
> +#define TC3589x_PULL_DOWN_MASK		0x1
> +#define TC3589x_PULL_UP_MASK		0x2
> +#define TC3589x_PULLUP_ALL_MASK		0xAA
> +#define TC3589x_IO_PULL_VAL(index, mask)	((mask)<<((index)%4)*2))
> +
> +/* Bit masks for IOCFG register */
> +#define IOCFG_BALLCFG		0x01
> +#define IOCFG_IG		0x08
> +
> +#define KP_EVCODE_COL_MASK	0x0F
> +#define KP_EVCODE_ROW_MASK	0x70
> +#define KP_RELEASE_EVT_MASK	0x80
> +
> +#define KP_ROW_SHIFT		4
> +
> +#define KP_NO_VALID_KEY_MASK	0x7F
> +
> +/* bit masks for RESTCTRL register */
> +#define TC3589x_KBDRST		0x2
> +#define TC3589x_IRQRST		0x10
> +#define TC3589x_RESET_ALL	0x1B
> +
> +/* KBDMFS register bit mask */
> +#define TC3589x_KBDMFS_EN	0x1
> +
> +/* CLKEN register bitmask */
> +#define KPD_CLK_EN		0x1
> +
> +/* RSTINTCLR register bit mask */
> +#define IRQ_CLEAR		0x1
> +
> +/* bit masks for keyboard interrupts*/
> +#define TC3589x_EVT_LOSS_INT	0x8
> +#define TC3589x_EVT_INT		0x4
> +#define TC3589x_KBD_LOSS_INT	0x2
> +#define TC3589x_KBD_INT		0x1
> +
> +/* bit masks for keyboard interrupt clear*/
> +#define TC3589x_EVT_INT_CLR	0x2
> +#define TC3589x_KBD_INT_CLR	0x1
> +
> +#define TC3589x_KBD_KEYMAP_SIZE     64
> +
> +/**
> + * struct tc_keypad - data structure used by keypad driver
> + * @input:      pointer to input device object
> + * @board:      keypad platform device
> + * @krow:	number of rows
> + * @kcol:	number of coloumns
> + * @keymap:     matrix scan code table for keycodes
> + */
> +struct tc_keypad {
> +	struct tc3589x *tc3589x;
> +	struct input_dev *input;
> +	const struct tc3589x_keypad_platform_data *board;
> +	unsigned int krow;
> +	unsigned int kcol;
> +	unsigned short keymap[TC3589x_KBD_KEYMAP_SIZE];
> +};


> +
> +
> +static irqreturn_t tc3589x_keypad_irq(int irq, void *dev)
> +{
> +	struct tc_keypad *keypad = (struct tc_keypad *)dev;

casting not required.

> +	struct tc3589x *tc3589x = keypad->tc3589x;
> +	u8 i, row_index, col_index, kbd_code, up;
> +	u8 code;
> +
> +	for (i = 0; i < (TC35893_DATA_REGS * 2); i++) {
> +		kbd_code = tc3589x_reg_read(tc3589x, TC3589x_EVTCODE_FIFO);
> +
> +		/* loop till fifo is empty and no more keys are pressed */
> +		if ((kbd_code == TC35893_KEYCODE_FIFO_EMPTY) ||
> +				(kbd_code == TC35893_KEYCODE_FIFO_CLEAR))
> +			continue;
> +
> +		/* valid key is found */
> +		col_index = kbd_code & KP_EVCODE_COL_MASK;
> +		row_index = (kbd_code & KP_EVCODE_ROW_MASK) >> KP_ROW_SHIFT;
> +		code = MATRIX_SCAN_CODE(row_index, col_index, 0x3);

0x3 needs #define.

> +		up = kbd_code & KP_RELEASE_EVT_MASK;
> +
> +		input_event(keypad->input, EV_MSC, MSC_SCAN, code);
> +		input_report_key(keypad->input, keypad->keymap[code], !up);
> +		input_sync(keypad->input);
> +	}
> +
> +	/* clear IRQ */
> +	tc3589x_set_bits(tc3589x, TC3589x_KBDIC,
> +			0x0, TC3589x_EVT_INT_CLR | TC3589x_KBD_INT_CLR);
> +	/* enable IRQ */
> +	tc3589x_set_bits(tc3589x, TC3589x_KBDMSK,
> +			0x0, TC3589x_EVT_LOSS_INT | TC3589x_EVT_INT);
> +
> +	return IRQ_HANDLED;
> +}
> +

> +
> +static int __devinit tc3589x_keypad_probe(struct platform_device *pdev)
> +{
> +	struct tc3589x *tc3589x = dev_get_drvdata(pdev->dev.parent);
> +	struct tc_keypad *keypad;
> +	struct input_dev *input;
> +	const struct tc3589x_keypad_platform_data *plat;
> +	int error, irq;
> +
> +	plat  = tc3589x->pdata->keypad;
> +	if (!plat) {
> +		dev_err(&pdev->dev, "invalid keypad platform data\n");
> +		return -EINVAL;
> +	}
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0)
> +		return irq;
> +
> +	keypad = kzalloc(sizeof(struct tc_keypad), GFP_KERNEL);
> +	input = input_allocate_device();
> +	if (!keypad || !input) {
> +		dev_err(&pdev->dev, "failed to allocate keypad memory\n");
> +		error = -ENOMEM;
> +		goto err_free_mem;
> +	}
> +
> +	keypad->board = plat;
> +	keypad->input = input;
> +	keypad->tc3589x = tc3589x;
> +
> +	/* enable the keypad module */
> +	error = tc3589x_keypad_enable(tc3589x);
> +	if (error < 0) {
> +		dev_err(&pdev->dev, "failed to enable keypad module\n");
> +		goto err_free_mem;
> +	}
> +
> +	error = tc3589x_keypad_init_key_hardware(keypad);
> +	if (error < 0) {
> +		dev_err(&pdev->dev, "failed to configure keypad module\n");
> +		goto err_free_mem;
> +	}

Let's move this to open(..).

> +
> +	input->id.bustype = BUS_HOST;

BUS_I2C ?

> +	input->name = pdev->name;
> +	input->dev.parent = &pdev->dev;
> +
> +	input->keycode = keypad->keymap;
> +	input->keycodesize = sizeof(keypad->keymap[0]);
> +	input->keycodemax = ARRAY_SIZE(keypad->keymap);
> +
> +	input_set_capability(input, EV_MSC, MSC_SCAN);
> +
> +	__set_bit(EV_KEY, input->evbit);
> +	if (!plat->no_autorepeat)
> +		__set_bit(EV_REP, input->evbit);
> +
> +	matrix_keypad_build_keymap(plat->keymap_data, 0x3,
> +			input->keycode, input->keybit);
> +
> +	error = request_threaded_irq(irq, NULL,
> +			tc3589x_keypad_irq, plat->irqtype,
> +			"tc3589x-keypad", keypad);
> +	if (error < 0) {
> +		dev_err(&pdev->dev,
> +				"Could not allocate irq %d,error %d\n",
> +				irq, error);
> +		goto err_free_mem;
> +	}
> +
> +	error = input_register_device(input);
> +	if (error) {
> +		dev_err(&pdev->dev, "Could not register input device\n");
> +		goto err_free_irq;
> +	}
> +
> +	device_init_wakeup(&pdev->dev, plat->enable_wakeup);
> +	device_set_wakeup_capable(&pdev->dev, plat->enable_wakeup);

put note here for as mentioned below.

> +
> +	platform_set_drvdata(pdev, keypad);
> +
> +	return 0;
> +
> +err_free_irq:
> +	free_irq(irq, keypad);
> +err_free_mem:
> +	input_free_device(input);
> +	kfree(keypad);
> +	return error;
> +}
> +

...

> +
> +#ifdef CONFIG_PM
> +static int tc3589x_keypad_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct tc_keypad *keypad = platform_get_drvdata(pdev);
> +	struct tc3589x *tc3589x = keypad->tc3589x;
> +	int irq = platform_get_irq(pdev, 0);
> +
> +	/* disable the IRQ */
> +	if (!device_may_wakeup(&pdev->dev))
> +		tc3589x_keypad_disable(tc3589x);
> +	else
> +		enable_irq_wake(irq);

I understand what you are doing here, but let's put a note in the probe
why you are doing device_set_wakeup_capable(...).

> +
> +	return 0;
> +}
> +
> +static int tc3589x_keypad_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct tc_keypad *keypad = platform_get_drvdata(pdev);
> +	struct tc3589x *tc3589x = keypad->tc3589x;
> +	int irq = platform_get_irq(pdev, 0);
> +
> +	/* enable the IRQ */
> +	if (!device_may_wakeup(&pdev->dev))
> +		tc3589x_keypad_enable(tc3589x);
> +	else
> +		disable_irq_wake(irq);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops tc3589x_keypad_dev_pm_ops = {
> +	.suspend = tc3589x_keypad_suspend,
> +	.resume  = tc3589x_keypad_resume,
> +};
> +#endif
> +

...

> +
> +static int __init tc3589x_keypad_init(void)
> +{
> +	return platform_driver_register(&tc3589x_keypad_driver);
> +}
> +
> +static void __exit tc3589x_keypad_exit(void)
> +{
> +	return platform_driver_unregister(&tc3589x_keypad_driver);
> +}
> +
> +module_init(tc3589x_keypad_init);
> +module_exit(tc3589x_keypad_exit);

nit-pick:

module_init/exit go with related routines.

> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Jayeeta Banerjee/Sundar Iyer");
> +MODULE_DESCRIPTION("TC35893 Keypad Driver");

MODULE_ALIAS("platform:tc3589x-keypad") would be good.

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
