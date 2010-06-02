Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab0FBQGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 12:06:09 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51674 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493Ab0FBQGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 12:06:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mBKxhElJBk3oZ9T4mwTTkI3W6fmVQrQhFrM24G7SEYBAK99RduH/g+9fPIlWsntNHf
         QAl1HUYTih547vc6B4sh/PS27rQwXj8+qFkGuryG8zOdpg6+RAJB5M8sAKLyC9rWybvs
         8urJiP097sgQnKpnQlxel9qjOlcHNbgFdu1DE=
Date: Wed, 2 Jun 2010 09:05:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rabin VINCENT <rabin.vincent@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 3/3] input: add STMPExxxx keypad driver
Message-ID: <20100602160551.GB24531@core.coreip.homeip.net>
References: <1275308236-1775-1-git-send-email-rabin.vincent@stericsson.com>
 <1275308236-1775-3-git-send-email-rabin.vincent@stericsson.com>
 <20100601221611.GB17468@core.coreip.homeip.net>
 <20100602135637.GA18513@bnru02.bnr.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602135637.GA18513@bnru02.bnr.st.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 07:26:37PM +0530, Rabin VINCENT wrote:
> > > +
> > > +static int __devexit stmpe_keypad_remove(struct platform_device *pdev)
> > > +{
> > > +     struct stmpe_keypad *keypad = platform_get_drvdata(pdev);
> > > +     int irq = platform_get_irq(pdev, 0);
> > > +
> > > +     input_unregister_device(keypad->input);
> > > +     free_irq(irq, keypad);
> > 
> > You want to free IRQ first, before unregisterin the device. Also, is
> 
> Done.  I've also changed the probe sequence to register the device
> before requesting the IRQ.
> 
> > there a way to power down keypad parts?
> 
> I've added code to do this.
> 
> > 
> > > +     platform_set_drvdata(pdev, NULL);
> > > +     kfree(keypad);
> > > +
> > > +     return 0;
> > > +}
> 
> Updated patch below.
> 

Thank you for making the changes. Please merge through MFD tree.

Acked-by: Dmitry Torokhov <dtor@mai.ru>

> 
> From c6848c5825d8cadfb22b3a6a7363d50496938293 Mon Sep 17 00:00:00 2001
> From: Rabin Vincent <rabin.vincent@stericsson.com>
> Date: Fri, 14 May 2010 13:21:12 +0530
> Subject: [PATCHv2] input: add STMPExxxx keypad driver
> 
> Add an input driver for the keypad on STMPExxxx I/O expanders.  This
> driver uses the common support provided by the STMPE MFD driver.
> 
> Cc: linux-input@vger.kernel.org
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> ---
>  drivers/input/keyboard/Kconfig        |   10 +
>  drivers/input/keyboard/Makefile       |    1 +
>  drivers/input/keyboard/stmpe-keypad.c |  387 +++++++++++++++++++++++++++++++++
>  3 files changed, 398 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/keyboard/stmpe-keypad.c
> 
> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
> index d8fa5d7..0e57fbc 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -374,6 +374,16 @@ config KEYBOARD_SH_KEYSC
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called sh_keysc.
>  
> +config KEYBOARD_STMPE
> +	tristate "STMPExxxx keypad support"
> +	depends on MFD_STMPE
> +	help
> +	  Say Y here if you want to use the keypad controller on STMPExxx I/O
> +	  expanders.
> +
> +	  To compile this driver as a module, choose M here: the module will be
> +	  called stmpe-keypad.
> +
>  config KEYBOARD_DAVINCI
>  	tristate "TI DaVinci Key Scan"
>  	depends on ARCH_DAVINCI_DM365
> diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
> index 4596d0c..af24b07 100644
> --- a/drivers/input/keyboard/Makefile
> +++ b/drivers/input/keyboard/Makefile
> @@ -33,6 +33,7 @@ obj-$(CONFIG_KEYBOARD_PXA27x)		+= pxa27x_keypad.o
>  obj-$(CONFIG_KEYBOARD_PXA930_ROTARY)	+= pxa930_rotary.o
>  obj-$(CONFIG_KEYBOARD_QT2160)		+= qt2160.o
>  obj-$(CONFIG_KEYBOARD_SH_KEYSC)		+= sh_keysc.o
> +obj-$(CONFIG_KEYBOARD_STMPE)		+= stmpe-keypad.o
>  obj-$(CONFIG_KEYBOARD_STOWAWAY)		+= stowaway.o
>  obj-$(CONFIG_KEYBOARD_SUNKBD)		+= sunkbd.o
>  obj-$(CONFIG_KEYBOARD_TWL4030)		+= twl4030_keypad.o
> diff --git a/drivers/input/keyboard/stmpe-keypad.c b/drivers/input/keyboard/stmpe-keypad.c
> new file mode 100644
> index 0000000..1ef8875
> --- /dev/null
> +++ b/drivers/input/keyboard/stmpe-keypad.c
> @@ -0,0 +1,387 @@
> +/*
> + * Copyright (C) ST-Ericsson SA 2010
> + *
> + * License Terms: GNU General Public License, version 2
> + * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/input.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/input/matrix_keypad.h>
> +#include <linux/mfd/stmpe.h>
> +
> +/* These are at the same addresses in all STMPE variants */
> +#define STMPE_KPC_COL			0x60
> +#define STMPE_KPC_ROW_MSB		0x61
> +#define STMPE_KPC_ROW_LSB		0x62
> +#define STMPE_KPC_CTRL_MSB		0x63
> +#define STMPE_KPC_CTRL_LSB		0x64
> +#define STMPE_KPC_COMBI_KEY_0		0x65
> +#define STMPE_KPC_COMBI_KEY_1		0x66
> +#define STMPE_KPC_COMBI_KEY_2		0x67
> +#define STMPE_KPC_DATA_BYTE0		0x68
> +#define STMPE_KPC_DATA_BYTE1		0x69
> +#define STMPE_KPC_DATA_BYTE2		0x6a
> +#define STMPE_KPC_DATA_BYTE3		0x6b
> +#define STMPE_KPC_DATA_BYTE4		0x6c
> +
> +#define STMPE_KPC_CTRL_LSB_SCAN		(0x1 << 0)
> +#define STMPE_KPC_CTRL_LSB_DEBOUNCE	(0x7f << 1)
> +#define STMPE_KPC_CTRL_MSB_SCAN_COUNT	(0xf << 4)
> +
> +#define STMPE_KPC_ROW_MSB_ROWS		0xff
> +
> +#define STMPE_KPC_DATA_UP		(0x1 << 7)
> +#define STMPE_KPC_DATA_ROW		(0xf << 3)
> +#define STMPE_KPC_DATA_COL		(0x7 << 0)
> +#define STMPE_KPC_DATA_NOKEY_MASK	0x78
> +
> +#define STMPE_KEYPAD_MAX_DEBOUNCE	127
> +#define STMPE_KEYPAD_MAX_SCAN_COUNT	15
> +
> +#define STMPE_KEYPAD_MAX_ROWS		8
> +#define STMPE_KEYPAD_MAX_COLS		8
> +#define STMPE_KEYPAD_ROW_SHIFT		3
> +#define STMPE_KEYPAD_KEYMAP_SIZE	\
> +	(STMPE_KEYPAD_MAX_ROWS * STMPE_KEYPAD_MAX_COLS)
> +
> +/**
> + * struct stmpe_keypad_variant - model-specific attributes
> + * @auto_increment: whether the KPC_DATA_BYTE register address
> + *		    auto-increments on multiple read
> + * @num_data: number of data bytes
> + * @num_normal_data: number of normal keys' data bytes
> + * @max_cols: maximum number of columns supported
> + * @max_rows: maximum number of rows supported
> + * @col_gpios: bitmask of gpios which can be used for columns
> + * @row_gpios: bitmask of gpios which can be used for rows
> + */
> +struct stmpe_keypad_variant {
> +	bool		auto_increment;
> +	int		num_data;
> +	int		num_normal_data;
> +	int		max_cols;
> +	int		max_rows;
> +	unsigned int	col_gpios;
> +	unsigned int	row_gpios;
> +};
> +
> +static const struct stmpe_keypad_variant stmpe_keypad_variants[] = {
> +	[STMPE1601] = {
> +		.auto_increment		= true,
> +		.num_data		= 5,
> +		.num_normal_data	= 3,
> +		.max_cols		= 8,
> +		.max_rows		= 8,
> +		.col_gpios		= 0x000ff,	/* GPIO 0 - 7 */
> +		.row_gpios		= 0x0ff00,	/* GPIO 8 - 15 */
> +	},
> +	[STMPE2401] = {
> +		.auto_increment		= false,
> +		.num_data		= 3,
> +		.num_normal_data	= 2,
> +		.max_cols		= 8,
> +		.max_rows		= 12,
> +		.col_gpios		= 0x0000ff,	/* GPIO 0 - 7*/
> +		.row_gpios		= 0x1fef00,	/* GPIO 8-14, 16-20 */
> +	},
> +	[STMPE2403] = {
> +		.auto_increment		= true,
> +		.num_data		= 5,
> +		.num_normal_data	= 3,
> +		.max_cols		= 8,
> +		.max_rows		= 12,
> +		.col_gpios		= 0x0000ff,	/* GPIO 0 - 7*/
> +		.row_gpios		= 0x1fef00,	/* GPIO 8-14, 16-20 */
> +	},
> +};
> +
> +struct stmpe_keypad {
> +	struct stmpe *stmpe;
> +	struct input_dev *input;
> +	const struct stmpe_keypad_variant *variant;
> +	const struct stmpe_keypad_platform_data *plat;
> +
> +	unsigned int rows;
> +	unsigned int cols;
> +
> +	unsigned short keymap[STMPE_KEYPAD_KEYMAP_SIZE];
> +};
> +
> +static int stmpe_keypad_read_data(struct stmpe_keypad *keypad, u8 *data)
> +{
> +	const struct stmpe_keypad_variant *variant = keypad->variant;
> +	struct stmpe *stmpe = keypad->stmpe;
> +	int ret;
> +	int i;
> +
> +	if (variant->auto_increment)
> +		return stmpe_block_read(stmpe, STMPE_KPC_DATA_BYTE0,
> +					variant->num_data, data);
> +
> +	for (i = 0; i < variant->num_data; i++) {
> +		ret = stmpe_reg_read(stmpe, STMPE_KPC_DATA_BYTE0 + i);
> +		if (ret < 0)
> +			return ret;
> +
> +		data[i] = ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static irqreturn_t stmpe_keypad_irq(int irq, void *dev)
> +{
> +	struct stmpe_keypad *keypad = dev;
> +	struct input_dev *input = keypad->input;
> +	const struct stmpe_keypad_variant *variant = keypad->variant;
> +	u8 fifo[variant->num_data];
> +	int ret;
> +	int i;
> +
> +	ret = stmpe_keypad_read_data(keypad, fifo);
> +	if (ret < 0)
> +		return IRQ_NONE;
> +
> +	for (i = 0; i < variant->num_normal_data; i++) {
> +		u8 data = fifo[i];
> +		int row = (data & STMPE_KPC_DATA_ROW) >> 3;
> +		int col = data & STMPE_KPC_DATA_COL;
> +		int code = MATRIX_SCAN_CODE(row, col, STMPE_KEYPAD_ROW_SHIFT);
> +		bool up = data & STMPE_KPC_DATA_UP;
> +
> +		if ((data & STMPE_KPC_DATA_NOKEY_MASK)
> +			== STMPE_KPC_DATA_NOKEY_MASK)
> +			continue;
> +
> +		input_event(input, EV_MSC, MSC_SCAN, code);
> +		input_report_key(input, keypad->keymap[code], !up);
> +		input_sync(input);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int __devinit stmpe_keypad_altfunc_init(struct stmpe_keypad *keypad)
> +{
> +	const struct stmpe_keypad_variant *variant = keypad->variant;
> +	unsigned int col_gpios = variant->col_gpios;
> +	unsigned int row_gpios = variant->row_gpios;
> +	struct stmpe *stmpe = keypad->stmpe;
> +	unsigned int pins = 0;
> +	int i;
> +
> +	/*
> +	 * Figure out which pins need to be set to alternate function 1.
> +	 *
> +	 * {cols,rows}_gpios are bitmasks of which pins on the chip can be used
> +	 * for the keypad.
> +	 *
> +	 * keypad->{cols,rows} are a bitmask of which pins (of the ones useable
> +	 * for the keypad) are used on the board.
> +	 */
> +
> +	for (i = 0; i < variant->max_cols; i++) {
> +		int num = __ffs(col_gpios);
> +
> +		if (keypad->cols & (1 << i))
> +			pins |= 1 << num;
> +
> +		col_gpios &= ~(1 << num);
> +	}
> +
> +	for (i = 0; i < variant->max_rows; i++) {
> +		int num = __ffs(row_gpios);
> +
> +		if (keypad->rows & (1 << i))
> +			pins |= 1 << num;
> +
> +		row_gpios &= ~(1 << num);
> +	}
> +
> +	return stmpe_set_altfunc(stmpe, pins, 1);
> +}
> +
> +static int __devinit stmpe_keypad_chip_init(struct stmpe_keypad *keypad)
> +{
> +	const struct stmpe_keypad_platform_data *plat = keypad->plat;
> +	const struct stmpe_keypad_variant *variant = keypad->variant;
> +	struct stmpe *stmpe = keypad->stmpe;
> +	int ret;
> +
> +	if (plat->debounce_ms > STMPE_KEYPAD_MAX_DEBOUNCE)
> +		return -EINVAL;
> +
> +	if (plat->scan_count > STMPE_KEYPAD_MAX_SCAN_COUNT)
> +		return -EINVAL;
> +
> +	ret = stmpe_set_bits(stmpe, STMPE_SYSCON, STMPE_SYSCON_ENABLE_KPC,
> +			     STMPE_SYSCON_ENABLE_KPC);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = stmpe_keypad_altfunc_init(keypad);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = stmpe_reg_write(stmpe, STMPE_KPC_COL, keypad->cols);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = stmpe_reg_write(stmpe, STMPE_KPC_ROW_LSB, keypad->rows);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (variant->max_rows > 8) {
> +		ret = stmpe_set_bits(stmpe, STMPE_KPC_ROW_MSB,
> +				     STMPE_KPC_ROW_MSB_ROWS,
> +				     keypad->rows >> 8);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	ret = stmpe_set_bits(stmpe, STMPE_KPC_CTRL_MSB,
> +			     STMPE_KPC_CTRL_MSB_SCAN_COUNT,
> +			     plat->scan_count << 4);
> +	if (ret < 0)
> +		return ret;
> +
> +	return stmpe_set_bits(stmpe, STMPE_KPC_CTRL_LSB,
> +			      STMPE_KPC_CTRL_LSB_SCAN |
> +			      STMPE_KPC_CTRL_LSB_DEBOUNCE,
> +			      STMPE_KPC_CTRL_LSB_SCAN |
> +			      (plat->debounce_ms << 1));
> +}
> +
> +static int __devinit stmpe_keypad_probe(struct platform_device *pdev)
> +{
> +	struct stmpe *stmpe = dev_get_drvdata(pdev->dev.parent);
> +	struct stmpe_keypad_platform_data *plat;
> +	struct stmpe_keypad *keypad;
> +	struct input_dev *input;
> +	int ret;
> +	int irq;
> +	int i;
> +
> +	plat = stmpe->pdata->keypad;
> +	if (!plat)
> +		return -ENODEV;
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0)
> +		return irq;
> +
> +	keypad = kzalloc(sizeof(struct stmpe_keypad), GFP_KERNEL);
> +	if (!keypad)
> +		return -ENOMEM;
> +
> +	input = input_allocate_device();
> +	if (!input) {
> +		ret = -ENOMEM;
> +		goto out_freekeypad;
> +	}
> +
> +	input->name = "STMPE keypad";
> +	input->id.bustype = BUS_I2C;
> +	input->dev.parent = &pdev->dev;
> +
> +	input_set_capability(input, EV_MSC, MSC_SCAN);
> +
> +	__set_bit(EV_KEY, input->evbit);
> +	if (!plat->no_autorepeat)
> +		__set_bit(EV_REP, input->evbit);
> +
> +	input->keycode = keypad->keymap;
> +	input->keycodesize = sizeof(keypad->keymap[0]);
> +	input->keycodemax = ARRAY_SIZE(keypad->keymap);
> +
> +	matrix_keypad_build_keymap(plat->keymap_data, STMPE_KEYPAD_ROW_SHIFT,
> +				   input->keycode, input->keybit);
> +
> +	for (i = 0; i < plat->keymap_data->keymap_size; i++) {
> +		unsigned int key = plat->keymap_data->keymap[i];
> +
> +		keypad->cols |= 1 << KEY_COL(key);
> +		keypad->rows |= 1 << KEY_ROW(key);
> +	}
> +
> +	keypad->stmpe = stmpe;
> +	keypad->plat = plat;
> +	keypad->input = input;
> +	keypad->variant = &stmpe_keypad_variants[stmpe->variant];
> +
> +	ret = stmpe_keypad_chip_init(keypad);
> +	if (ret < 0)
> +		goto out_freeinput;
> +
> +	ret = input_register_device(input);
> +	if (ret) {
> +		dev_err(&pdev->dev,
> +			"unable to register input device: %d\n", ret);
> +		goto out_freeinput;
> +	}
> +
> +	ret = request_threaded_irq(irq, NULL, stmpe_keypad_irq, IRQF_ONESHOT,
> +				   "stmpe-keypad", keypad);
> +	if (ret) {
> +		dev_err(&pdev->dev, "unable to get irq: %d\n", ret);
> +		goto out_unregisterinput;
> +	}
> +
> +	platform_set_drvdata(pdev, keypad);
> +
> +	return 0;
> +
> +out_unregisterinput:
> +	input_unregister_device(input);
> +	input = NULL;
> +out_freeinput:
> +	input_free_device(input);
> +out_freekeypad:
> +	kfree(keypad);
> +	return ret;
> +}
> +
> +static int __devexit stmpe_keypad_remove(struct platform_device *pdev)
> +{
> +	struct stmpe_keypad *keypad = platform_get_drvdata(pdev);
> +	struct stmpe *stmpe = keypad->stmpe;
> +	int irq = platform_get_irq(pdev, 0);
> +
> +	/* Disable the keypad module.  Ignore any errors. */
> +	stmpe_set_bits(stmpe, STMPE_SYSCON, STMPE_SYSCON_ENABLE_KPC, 0);
> +
> +	free_irq(irq, keypad);
> +	input_unregister_device(keypad->input);
> +	platform_set_drvdata(pdev, NULL);
> +	kfree(keypad);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver stmpe_keypad_driver = {
> +	.driver.name	= "stmpe-keypad",
> +	.driver.owner	= THIS_MODULE,
> +	.probe		= stmpe_keypad_probe,
> +	.remove		= __devexit_p(stmpe_keypad_remove),
> +};
> +
> +static int __init stmpe_keypad_init(void)
> +{
> +	return platform_driver_register(&stmpe_keypad_driver);
> +}
> +module_init(stmpe_keypad_init);
> +
> +static void __exit stmpe_keypad_exit(void)
> +{
> +	platform_driver_unregister(&stmpe_keypad_driver);
> +}
> +module_exit(stmpe_keypad_exit);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("STMPExxxx keypad driver");
> +MODULE_AUTHOR("Rabin Vincent <rabin.vincent@stericsson.com>");
> -- 
> 1.7.0
> 

-- 
Dmitry
