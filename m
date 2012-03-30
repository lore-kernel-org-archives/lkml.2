Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306Ab2C3S5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:57:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42520 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761284Ab2C3S4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:56:49 -0400
Date: Fri, 30 Mar 2012 20:56:34 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Geon Si Jeong <gshark.jeong@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Daniel Jeong <daniel.jeong@ti.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] leds: Add LED driver for lm3556 chip
Message-ID: <20120330185634.GB3384@pengutronix.de>
References: <1333089508-8501-1-git-send-email-gshark.jeong@gmail.com>
 <1333089508-8501-2-git-send-email-gshark.jeong@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oC1+HKm2/end4ao3"
Content-Disposition: inline
In-Reply-To: <1333089508-8501-2-git-send-email-gshark.jeong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oC1+HKm2/end4ao3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 30, 2012 at 03:38:28PM +0900, Geon Si Jeong wrote:
> It is a simple driver for LM3556 Chip(Texas Instruments)
> LM3556 :
> The LM3556 is a 4 MHz fixed-frequency synchronous boost
> converter plus 1.5A constant current driver for a high-current white LED.
> Datasheet: www.national.com/ds/LM/LM3556.pdf
>=20
> Tested on OMAP4430
>=20
> Signed-off-by: Geon Si Jeong <gshark.jeong@gmail.com>

Hi!

Thanks for your contribution. I found a few issues, I mentioned the first
occurence, but they may appear multiple times. Please check that.

> ---
>  drivers/leds/Kconfig        |    9 +
>  drivers/leds/Makefile       |    2 +-
>  drivers/leds/leds-lm3556.c  |  462 +++++++++++++++++++++++++++++++++++++=
++++++
>  include/linux/leds-lm3556.h |  242 ++++++++++++++++++++++
>  4 files changed, 714 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/leds/leds-lm3556.c
>  create mode 100644 include/linux/leds-lm3556.h
>=20
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 589ba02..8ebdb3f 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -401,6 +401,15 @@ config LEDS_MAX8997
>  	  This option enables support for on-chip LED drivers on
>  	  MAXIM MAX8997 PMIC.
> =20
> +config LEDS_LM3556
> +	tristate "LED Support for TI LM3556 Chip"
> +	depends on LEDS_CLASS
> +	depends on I2C
> +	help
> +	  This option enables support for LEDs connected to LM3556.
> +	  LM3556 includes Torch, Flash and Indicator functions and
> +	  controlled via I2C.
> +
>  config LEDS_OT200
>  	tristate "LED support for the Bachmann OT200"
>  	depends on LEDS_CLASS && HAS_IOMEM
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index fa0f428..8ad2a46 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -46,7 +46,7 @@ obj-$(CONFIG_LEDS_NETXBIG)		+=3D leds-netxbig.o
>  obj-$(CONFIG_LEDS_ASIC3)		+=3D leds-asic3.o
>  obj-$(CONFIG_LEDS_RENESAS_TPU)		+=3D leds-renesas-tpu.o
>  obj-$(CONFIG_LEDS_MAX8997)		+=3D leds-max8997.o
> -
> +obj-$(CONFIG_LEDS_LM3556)		+=3D leds-lm3556.o
>  # LED SPI Drivers
>  obj-$(CONFIG_LEDS_DAC124S085)		+=3D leds-dac124s085.o
> =20
> diff --git a/drivers/leds/leds-lm3556.c b/drivers/leds/leds-lm3556.c
> new file mode 100644
> index 0000000..65766c1
> --- /dev/null
> +++ b/drivers/leds/leds-lm3556.c
> @@ -0,0 +1,462 @@
> +/*
> + * Simple driver for Texas Instruments LM3556 LED Flash driver chip (Rev=
0x03)
> + * Copyright (C) 2012 Texas Instruments
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/leds.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/types.h>
> +#include <linux/ctype.h>
> +#include <linux/fs.h>
> +#include <linux/leds-lm3556.h>
> +
> +#define	REG_FILT_TIME			(0x0)
> +#define	REG_IVFM_MODE			(0x1)
> +#define	REG_NTC				(0x2)
> +#define	REG_INDIC_TIME			(0x3)
> +#define	REG_INDIC_BLINK			(0x4)
> +#define	REG_INDIC_PERIOD		(0x5)
> +#define	REG_TORCH_TIME			(0x6)
> +#define	REG_CONF			(0x7)
> +#define	REG_FLASH			(0x8)
> +#define	REG_I_CTRL			(0x9)
> +#define	REG_ENABLE			(0xA)
> +#define	REG_FLAG			(0xB)
> +#define	REG_MAX				(0xC)
> +
> +#define	IVFM_FILTER_TIME_SHIFT		(3)
> +#define	UVLO_EN_SHIFT			(7)
> +#define	HYSTERSIS_SHIFT			(5)
> +#define	IVM_D_TH_SHIFT			(2)
> +#define	IVFM_ADJ_MODE_SHIFT		(0)
> +#define	NTC_EVENT_LVL_SHIFT		(5)
> +#define	NTC_TRIP_TH_SHIFT		(2)
> +#define	NTC_BIAS_I_LVL_SHIFT		(0)
> +#define	INDIC_RAMP_UP_TIME_SHIFT	(3)
> +#define	INDIC_RAMP_DN_TIME_SHIFT	(0)
> +#define	INDIC_N_BLANK_SHIFT		(4)
> +#define	INDIC_PULSE_TIME_SHIFT		(0)
> +#define	INDIC_N_PERIOD_SHIFT		(0)
> +#define	TORCH_RAMP_UP_TIME_SHIFT	(3)
> +#define	TORCH_RAMP_DN_TIME_SHIFT	(0)
> +#define	STROBE_USUAGE_SHIFT		(7)
> +#define	STROBE_PIN_POLARITY_SHIFT	(6)
> +#define	TORCH_PIN_POLARITY_SHIFT	(5)
> +#define	TX_PIN_POLARITY_SHIFT		(4)
> +#define	TX_EVENT_LVL_SHIFT		(3)
> +#define	IVFM_EN_SHIFT			(2)
> +#define	NTC_MODE_SHIFT			(1)
> +#define	INDIC_MODE_SHIFT		(0)
> +#define	INDUCTOR_I_LIMIT_SHIFT		(6)
> +#define	FLASH_RAMP_TIME_SHIFT		(3)
> +#define	FLASH_TOUT_TIME_SHIFT		(0)
> +#define	TORCH_I_SHIFT			(4)
> +#define	FLASH_I_SHIFT			(0)
> +#define	NTC_EN_SHIFT			(7)
> +#define	TX_PIN_EN_SHIFT			(6)
> +#define	STROBE_PIN_EN_SHIFT		(5)
> +#define	TORCH_PIN_EN_SHIFT		(4)
> +#define	PRECHG_MODE_EN_SHIFT		(3)
> +#define	PASS_MODE_ONLY_EN_SHIFT		(2)
> +#define	MODE_BITS_SHIFT			(0)
> +
> +#define	IVFM_FILTER_TIME_MASK		(0x3)
> +#define	UVLO_EN_MASK			(0x1)
> +#define	HYSTERSIS_MASK			(0x3)
> +#define	IVM_D_TH_MASK			(0x7)
> +#define	IVFM_ADJ_MODE_MASK		(0x3)
> +#define	NTC_EVENT_LVL_MASK		(0x1)
> +#define	NTC_TRIP_TH_MASK		(0x7)
> +#define	NTC_BIAS_I_LVL_MASK		(0x3)
> +#define	INDIC_RAMP_UP_TIME_MASK		(0x7)
> +#define	INDIC_RAMP_DN_TIME_MASK		(0x7)
> +#define	INDIC_N_BLANK_MASK		(0x7)
> +#define	INDIC_PULSE_TIME_MASK		(0x7)
> +#define	INDIC_N_PERIOD_MASK		(0x7)
> +#define	TORCH_RAMP_UP_TIME_MASK		(0x7)
> +#define	TORCH_RAMP_DN_TIME_MASK		(0x7)
> +#define	STROBE_USUAGE_MASK		(0x1)
> +#define	STROBE_PIN_POLARITY_MASK	(0x1)
> +#define	TORCH_PIN_POLARITY_MASK		(0x1)
> +#define	TX_PIN_POLARITY_MASK		(0x1)
> +#define	TX_EVENT_LVL_MASK		(0x1)
> +#define	IVFM_EN_MASK			(0x1)
> +#define	NTC_MODE_MASK			(0x1)
> +#define	INDIC_MODE_MASK			(0x1)
> +#define	INDUCTOR_I_LIMIT_MASK		(0x3)
> +#define	FLASH_RAMP_TIME_MASK		(0x7)
> +#define	FLASH_TOUT_TIME_MASK		(0x7)
> +#define	TORCH_I_MASK			(0x7)
> +#define	FLASH_I_MASK			(0xF)
> +#define	NTC_EN_MASK			(0x1)
> +#define	TX_PIN_EN_MASK			(0x1)
> +#define	STROBE_PIN_EN_MASK		(0x1)
> +#define	TORCH_PIN_EN_MASK		(0x1)
> +#define	PRECHG_MODE_EN_MASK		(0x1)
> +#define	PASS_MODE_ONLY_EN_MASK		(0x1)
> +#define	MODE_BITS_MASK			(0x13)
> +#define EX_PIN_CONTROL_MASK		(0xF1)
> +#define EX_PIN_ENABLE_MASK		(0x70)
> +
> +
> +#define INDIC_PATTERN_SIZE 4
> +
> +struct indicator {
> +	u8 blinking;
> +	u8 period_cnt;
> +};
> +
> +struct lm3556_chip_data {
> +	struct i2c_client *client;
> +
> +	struct led_classdev cdev_flash;
> +	struct led_classdev cdev_torch;
> +	struct led_classdev cdev_indicator;
> +
> +	struct lm3556_platform_data *pdata;
> +	struct mutex lock;
> +
> +	u8 last_flag;
> +};
> +
> +/*Indicator Pattern*/
> +static struct indicator indicator_pattern[INDIC_PATTERN_SIZE] =3D {
> +	[0] =3D {(INDIC_N_BLANK_0 << INDIC_N_BLANK_SHIFT)
> +	       | PULSE_TIME_0_MS, INDIC_PERIOD_0},
> +	[1] =3D {(INDIC_N_BLANK_15 << INDIC_N_BLANK_SHIFT)
> +	       | PULSE_TIME_32_MS, INDIC_PERIOD_1},
> +	[2] =3D {(INDIC_N_BLANK_10 << INDIC_N_BLANK_SHIFT)
> +	       | PULSE_TIME_32_MS, INDIC_PERIOD_4},
> +	[3] =3D {(INDIC_N_BLANK_5 << INDIC_N_BLANK_SHIFT)
> +	       | PULSE_TIME_32_MS, INDIC_PERIOD_7},
> +};
> +
> +/* i2c access*/
> +int lm3556_read_reg(struct i2c_client *client, u8 reg, u8 * val)
> +{
> +	int ret;
> +	struct lm3556_chip_data *chip =3D i2c_get_clientdata(client);
> +
> +	mutex_lock(&chip->lock);
> +	ret =3D i2c_smbus_read_byte_data(client, reg);
> +	mutex_unlock(&chip->lock);

No need for this lock, i2c-core locks during transactions.

> +
> +	if (ret < 0) {
> +		printk(KERN_ERR "[LM3556]reading fail at 0x%02x error %d\n",
> +		       reg, ret);

dev_err()and drop LM3556

> +		return ret;
> +	}
> +	*val =3D ret & 0xff;
> +	return 0;
> +}

If you'd return the value here, you could save the pointer to u8 as argumen=
t.

> +EXPORT_SYMBOL_GPL(lm3556_read_reg);
> +
> +int lm3556_write_reg(struct i2c_client *client, u8 reg, u8 val)
> +{
> +	int ret =3D 0;
> +	struct lm3556_chip_data *chip =3D i2c_get_clientdata(client);
> +
> +	mutex_lock(&chip->lock);
> +	ret =3D i2c_smbus_write_byte_data(client, reg, val);
> +	mutex_unlock(&chip->lock);
> +
> +	if (ret < 0)
> +		printk(KERN_ERR"[LM3556] writting fail at 0x%02x\n", reg);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(lm3556_write_reg);
> +
> +int lm3556_write_bits(struct i2c_client *client,
> +		      u8 reg, u8 val, u8 mask, u8 shift)
> +{
> +	int ret;
> +	u8 reg_val;
> +
> +	ret =3D lm3556_read_reg(client, reg, &reg_val);
> +	if (ret < 0)
> +		return ret;
> +	reg_val &=3D (~(mask << shift));
> +	reg_val |=3D ((val & mask) << shift);
> +
> +	ret =3D lm3556_write_reg(client, reg, reg_val);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(lm3556_write_bits);

Seeing all these functions it may be worth converting to REGMAP.
Then you already have regmap_update_bits and the like.

> +
> +/* chip initialize*/
> +static int lm3556_chip_init(struct lm3556_chip_data *chip)
> +{
> +	u8 reg_val;
> +	int ret =3D 0;
> +	struct i2c_client *client =3D chip->client;
> +	struct lm3556_platform_data *pdata =3D chip->pdata;
> +
> +	/*Set Config Register for external PINs depended by HW*/

Comment format /* text */


> +	ret =3D lm3556_read_reg(client, REG_CONF, &reg_val);
> +	reg_val &=3D ~EX_PIN_CONTROL_MASK;
> +	reg_val |=3D ((pdata->torch_pin_polarity & 0x01)
> +		    << TORCH_PIN_POLARITY_SHIFT);
> +	reg_val |=3D ((pdata->strobe_usuage & 0x01) << STROBE_USUAGE_SHIFT);
> +	reg_val |=3D ((pdata->strobe_pin_polarity & 0x01)
> +		    << STROBE_PIN_POLARITY_SHIFT);
> +	reg_val |=3D ((pdata->tx_pin_polarity & 0x01) << TX_PIN_POLARITY_SHIFT);
> +	reg_val |=3D ((pdata->indicator_mode & 0x01) << INDIC_MODE_SHIFT);
> +	ret |=3D lm3556_write_reg(client, REG_CONF, reg_val);
> +
> +	/*Set Enable Register for external PINs depended by HW*/
> +	ret =3D lm3556_read_reg(client, REG_ENABLE, &reg_val);

ret =3D
ret |=3D
ret =3D
=2E..

-> BROKEN

> +	reg_val &=3D ~EX_PIN_ENABLE_MASK;
> +	reg_val |=3D ((pdata->torch_pin_en & 0x01) << TORCH_PIN_EN_SHIFT);
> +	reg_val |=3D ((pdata->strobe_pin_en & 0x01) << STROBE_PIN_EN_SHIFT);
> +	reg_val |=3D ((pdata->tx_pin_en & 0x01) << TX_PIN_EN_SHIFT);
> +	ret |=3D lm3556_write_reg(client, REG_ENABLE, reg_val);
> +	return ret;
> +}
> +
> +/* chip control*/
> +static void lm3556_control(struct lm3556_chip_data *chip,
> +			   u8 brightness, enum lm3556_mode opmode)
> +{
> +	struct i2c_client *client =3D chip->client;
> +	struct lm3556_platform_data *pdata =3D chip->pdata;
> +
> +	lm3556_read_reg(client, REG_FLAG, &chip->last_flag);

no error checking?

> +	if (chip->last_flag)
> +		printk(KERN_INFO"[LM3556] Last FLAG is 0x%x\n",
> +		       chip->last_flag);
> +
> +	/*Brightness 0 means off-state*/
> +	if (!brightness)
> +		opmode =3D MODES_STASNDBY;
> +
> +	switch (opmode) {
> +	case MODES_TORCH:
> +		lm3556_write_bits(client, REG_I_CTRL,
> +				  brightness - 1, TORCH_I_MASK, TORCH_I_SHIFT);
> +
> +		if (pdata->torch_pin_en)
> +			opmode |=3D (TORCH_PIN_EN_MASK << TORCH_PIN_EN_SHIFT);
> +		break;
> +
> +	case MODES_FLASH:
> +		lm3556_write_bits(client, REG_I_CTRL,
> +				  brightness - 1, FLASH_I_MASK, FLASH_I_SHIFT);
> +
> +		if (pdata->strobe_pin_en)
> +			opmode |=3D (STROBE_PIN_EN_MASK << STROBE_PIN_EN_SHIFT);
> +		if (pdata->tx_pin_en)
> +			opmode |=3D (TX_PIN_EN_MASK << TX_PIN_EN_SHIFT);
> +		break;
> +
> +	case MODES_INDIC:
> +		lm3556_write_bits(client, REG_I_CTRL,
> +				  brightness - 1, TORCH_I_MASK, TORCH_I_SHIFT);
> +
> +		if (pdata->indicator_mode)
> +			opmode |=3D (TORCH_PIN_EN_MASK << TORCH_PIN_EN_SHIFT);
> +		break;
> +
> +	case MODES_STASNDBY:
> +		if (pdata->torch_pin_en)
> +			opmode |=3D (TORCH_PIN_EN_MASK << TORCH_PIN_EN_SHIFT);
> +		break;
> +
> +	default:
> +		return;
> +	}
> +	lm3556_write_bits(client, REG_ENABLE,
> +			  opmode, MODE_BITS_MASK, MODE_BITS_SHIFT);
> +
> +	return;
> +}
> +
> +/*torch */
> +static void lm3556_torch_brightness_set(struct led_classdev *cdev,
> +					enum led_brightness brightness)
> +{
> +	struct lm3556_chip_data *chip =3D
> +	    container_of(cdev, struct lm3556_chip_data, cdev_torch);
> +
> +	lm3556_control(chip, (u8) brightness, MODES_TORCH);

I might miss something but can't the second argument be the enum-type so we=
 can
skip the cast?

> +	return;
> +}
> +
> +/* flash */
> +static void lm3556_strobe_brightness_set(struct led_classdev *cdev,
> +					 enum led_brightness brightness)
> +{
> +	struct lm3556_chip_data *chip =3D
> +	    container_of(cdev, struct lm3556_chip_data, cdev_flash);
> +
> +	lm3556_control(chip, (u8) brightness, MODES_FLASH);
> +	return;
> +}
> +
> +/* indicator */
> +static void lm3556_indicator_brightness_set(struct led_classdev *cdev,
> +					    enum led_brightness brightness)
> +{
> +	struct lm3556_chip_data *chip =3D
> +	    container_of(cdev, struct lm3556_chip_data, cdev_indicator);
> +
> +	lm3556_control(chip, (u8) brightness, MODES_INDIC);
> +	return;
> +}
> +
> +static ssize_t lm3556_indicator_pattern_store(struct device *dev,
> +					      struct device_attribute *devAttr,
> +					      const char *buf, size_t size)
> +{
> +	char *after;
> +	ssize_t ret =3D -EINVAL;
> +	struct i2c_client *client =3D container_of(dev->parent,
> +						 struct i2c_client, dev);
> +	unsigned long state =3D simple_strtoul(buf, &after, 10);
> +	size_t count =3D after - buf;
> +
> +	if (isspace(*after))
> +		count++;
> +
> +	if (count =3D=3D size) {
> +		ret =3D count;
> +
> +		if (state > INDIC_PATTERN_SIZE - 1)
> +			state =3D INDIC_PATTERN_SIZE - 1;
> +		lm3556_write_reg(client, REG_INDIC_BLINK,
> +				 indicator_pattern[state].blinking);
> +		lm3556_write_reg(client, REG_INDIC_PERIOD,
> +				 indicator_pattern[state].period_cnt);
> +	}
> +	return ret;
> +}
> +
> +static DEVICE_ATTR(pattern, 0644, NULL, lm3556_indicator_pattern_store);

I don't know the LED subsytsem very well. Is it that specific to the chip s=
o we
need a DEVICE_ATTR? Or can this be generalized in the core?

> +
> +/* Module Initialize */
> +static int lm3556_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct lm3556_platform_data *pdata =3D client->dev.platform_data;
> +	struct lm3556_chip_data *chip;
> +
> +	int err =3D -ENODEV;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		printk(KERN_ERR"[LM3556]i2c functionality check fail.\n");
> +		return err;
> +	}

ENODEV does not fit here. Check Documentation/i2c/fault-codes.

> +
> +	if (pdata =3D=3D NULL) {
> +		printk(KERN_ERR"[LM3556] Needs Platform Data.\n");
> +		return err;
> +	}
> +
> +	chip =3D kzalloc(sizeof(struct lm3556_chip_data), GFP_KERNEL);
> +	chip->client =3D client;
> +	chip->pdata =3D pdata;
> +
> +	mutex_init(&chip->lock);
> +	i2c_set_clientdata(client, chip);
> +
> +	if (lm3556_chip_init(chip) < 0)
> +		goto err_chip_init;
> +
> +	/*flash*/
> +	chip->cdev_flash.name =3D "flash";
> +	chip->cdev_flash.max_brightness =3D 16;
> +	chip->cdev_flash.brightness_set =3D lm3556_strobe_brightness_set;
> +	if (led_classdev_register((struct device *)
> +				  &client->dev, &chip->cdev_flash) < 0)
> +		goto err_create_flash_file;
> +	/*torch*/
> +	chip->cdev_torch.name =3D "torch";
> +	chip->cdev_torch.max_brightness =3D 8;
> +	chip->cdev_torch.brightness_set =3D lm3556_torch_brightness_set;
> +	if (led_classdev_register((struct device *)
> +				  &client->dev, &chip->cdev_torch) < 0)
> +		goto err_create_torch_file;
> +	/*indicator*/
> +	chip->cdev_indicator.name =3D "indicator";
> +	chip->cdev_indicator.max_brightness =3D 8;
> +	chip->cdev_indicator.brightness_set =3D lm3556_indicator_brightness_set;
> +	if (led_classdev_register((struct device *)
> +				  &client->dev, &chip->cdev_indicator) < 0)
> +		goto err_create_indicator_file;
> +
> +	if (device_create_file(chip->cdev_indicator.dev, &dev_attr_pattern) < 0)
> +		goto err_create_pattern_file;
> +
> +	return 0;
> +
> +err_create_pattern_file:
> +	led_classdev_unregister(&chip->cdev_indicator);
> +err_create_indicator_file:
> +	led_classdev_unregister(&chip->cdev_torch);
> +err_create_torch_file:
> +	led_classdev_unregister(&chip->cdev_flash);
> +err_create_flash_file:
> +err_chip_init:
> +	i2c_set_clientdata(client, NULL);

not needed

> +	kfree(chip);
> +	printk(KERN_ERR"[LM3556] probe func. returns failed\n");

I'd suggest to drop that. The core has output for that.

> +	return -ENODEV;
> +}
> +
> +static int lm3556_remove(struct i2c_client *client)
> +{
> +	struct lm3556_chip_data *chip =3D i2c_get_clientdata(client);
> +
> +	device_remove_file(chip->cdev_indicator.dev, &dev_attr_pattern);
> +	led_classdev_unregister(&chip->cdev_indicator);
> +	led_classdev_unregister(&chip->cdev_torch);
> +	led_classdev_unregister(&chip->cdev_flash);
> +	lm3556_write_reg(client, REG_ENABLE, 0);
> +
> +	kfree(chip);
> +	printk(KERN_INFO "[LM3556] Removing is done");

Ditto.

> +	return 0;
> +}
> +
> +static const struct i2c_device_id lm3556_id[] =3D {
> +	{LM3556_NAME, 0},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, lm3556_id);
> +
> +static struct i2c_driver lm3556_i2c_driver =3D {
> +	.driver =3D {
> +		   .name =3D LM3556_NAME,
> +		   .owner =3D THIS_MODULE,
> +		   .pm =3D NULL,
> +		   },
> +	.probe =3D lm3556_probe,
> +	.remove =3D __devexit_p(lm3556_remove),
> +	.id_table =3D lm3556_id,
> +};
> +
> +static int __init lm3556_init(void)
> +{
> +	return i2c_add_driver(&lm3556_i2c_driver);
> +}
> +
> +static void __exit lm3556_exit(void)
> +{
> +	i2c_del_driver(&lm3556_i2c_driver);
> +}
> +
> +module_init(lm3556_init);
> +module_exit(lm3556_exit);

Use module_i2c_driver

> +
> +MODULE_DESCRIPTION("Texas Instruments Flash Lighting driver for LM3556");
> +MODULE_AUTHOR
> +	("Geon Si Jeong <daniel.jeong@ti.com>, Woogyom Kim <milo.kim@ti.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/leds-lm3556.h b/include/linux/leds-lm3556.h
> new file mode 100644
> index 0000000..aee7fab
> --- /dev/null
> +++ b/include/linux/leds-lm3556.h
> @@ -0,0 +1,242 @@
> +/*
> + * Simple driver for Texas Instruments LM3556 LED Flash driver chip (Rev=
0x03)
> + * Copyright (C) 2012 Texas Instruments
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#ifndef __LINUX_LM3556_H
> +#define __LINUX_LM3556_H
> +
> +#define LM3556_NAME "leds-lm3556"
> +
> +enum lm3556_ivfm_filter_time {
> +	IVFM_FILTER_TIME_HALF_CURRENT_STEP =3D 0,
> +	IVFM_FILTER_TIME_256_USEC,
> +	IVFM_FILTER_TIME_512_USEC,
> +	IVFM_FILTER_TIME_1024_USEC
> +};
> +
> +enum lm3556_ivfm_adj_mode {
> +	IVFM_ADJ_MODE_REPORT =3D 0,
> +	IVFM_ADJ_MODESTOP_HOLD,
> +	IVFM_ADJ_MODE_DOWN,
> +	IVFM_ADJ_MODE_UP_DOWN,
> +};
> +
> +enum lm3556_ivfm_down_threshold {
> +	IVFM_DN_TH_2_7_V =3D 0,
> +	IVFM_DN_TH_2_8_V,
> +	IVFM_DN_TH_2_9_V,
> +	IVFM_DN_TH_3_0_V,
> +	IVFM_DN_TH_3_1_V,
> +	IVFM_DN_TH_3_2_V,
> +	IVFM_DN_TH_3_3_V,
> +	IVFM_DN_TH_3_4_V,
> +};
> +
> +enum lm3556_ivfm_hyst {
> +	IVFM_HYST_50_MV =3D 0,
> +	IVFM_HYST_100_MV,
> +	IVFM_HYST_150_MV,
> +	IVFM_HYST_DIS
> +};
> +
> +enum lm3556_ntc_curr_lvl {
> +	NTC_CURR_LVL_25_UA =3D 0,
> +	NTC_CURR_LVL_50_UA,
> +	NTC_CURR_LVL_75_UA,
> +	NTC_CURR_LVL_100_UA
> +};
> +
> +enum lm3556_ntc_trip_threshold {
> +	NTC_TRIP_THRESHOLD_200_MV =3D 0,
> +	NTC_TRIP_THRESHOLD_300_MV,
> +	NTC_TRIP_THRESHOLD_400_MV,
> +	NTC_TRIP_THRESHOLD_500_MV,
> +	NTC_TRIP_THRESHOLD_600_MV,
> +	NTC_TRIP_THRESHOLD_700_MV,
> +	NTC_TRIP_THRESHOLD_800_MV,
> +	NTC_TRIP_THRESHOLD_900_MV
> +};
> +
> +enum lm3556_ntc_event_lvl {
> +	NTC_EVENT_LVL_STANDBY =3D 0,
> +	NTC_EVENT_LVL_REDUCE_MIN_TORCH
> +};
> +
> +enum lm3556_torch_indic_ramp_time {
> +	TORCH_INDIC_RAMP_TIME_16_MS =3D 0,
> +	TORCH_INDIC_RAMP_TIME_32_MS,
> +	TORCH_INDIC_RAMP_TIME_64_MS,
> +	TORCH_INDIC_RAMP_TIME_128_MS,
> +	TORCH_INDIC_RAMP_TIME_256_MS,
> +	TORCH_INDIC_RAMP_TIME_512_MS,
> +	TORCH_INDIC_RAMP_TIME_1024_MS,
> +	TORCH_INDIC_RAMP_TIME_2048_MS,
> +};
> +
> +enum lm3556_indic_pulse_time {
> +	PULSE_TIME_0_MS =3D 0,
> +	PULSE_TIME_32_MS,
> +	PULSE_TIME_64_MS,
> +	PULSE_TIME_92_MS,
> +	PULSE_TIME_128_MS,
> +	PULSE_TIME_160_MS,
> +	PULSE_TIME_196_MS,
> +	PULSE_TIME_224_MS,
> +	PULSE_TIME_256_MS,
> +	PULSE_TIME_288_MS,
> +	PULSE_TIME_320_MS,
> +	PULSE_TIME_352_MS,
> +	PULSE_TIME_384_MS,
> +	PULSE_TIME_416_MS,
> +	PULSE_TIME_448_MS,
> +	PULSE_TIME_480_MS,
> +};
> +
> +enum lm3556_indic_n_blank {
> +	INDIC_N_BLANK_0 =3D 0,
> +	INDIC_N_BLANK_1,
> +	INDIC_N_BLANK_2,
> +	INDIC_N_BLANK_3,
> +	INDIC_N_BLANK_4,
> +	INDIC_N_BLANK_5,
> +	INDIC_N_BLANK_6,
> +	INDIC_N_BLANK_7,
> +	INDIC_N_BLANK_8,
> +	INDIC_N_BLANK_9,
> +	INDIC_N_BLANK_10,
> +	INDIC_N_BLANK_11,
> +	INDIC_N_BLANK_12,
> +	INDIC_N_BLANK_13,
> +	INDIC_N_BLANK_14,
> +	INDIC_N_BLANK_15,
> +};
> +
> +enum lm3556_indic_period {
> +	INDIC_PERIOD_0 =3D 0,
> +	INDIC_PERIOD_1,
> +	INDIC_PERIOD_2,
> +	INDIC_PERIOD_3,
> +	INDIC_PERIOD_4,
> +	INDIC_PERIOD_5,
> +	INDIC_PERIOD_6,
> +	INDIC_PERIOD_7,
> +};
> +
> +enum lm3556_indic_mode {
> +	INDIC_MODE_INTERNAL =3D 0,
> +	INDIC_MODE_EXTERNAL,
> +};
> +
> +enum lm3556_flash_timeout {
> +	FLASH_TIMEOUT_50_MS =3D 0,
> +	FLASH_TIMEOUT_100_MS,
> +	FLASH_TIMEOUT_150_MS,
> +	FLASH_TIMEOUT_200_MS,
> +	FLASH_TIMEOUT_250_MS,
> +	FLASH_TIMEOUT_300_MS,
> +	FLASH_TIMEOUT_350_MS,
> +	FLASH_TIMEOUT_400_MS,
> +};
> +
> +enum lm3556_flash_ramp_time {
> +	FLASH_RAMP_TIME_256_US =3D 0,
> +	FLASH_RAMP_TIME_512_US,
> +	FLASH_RAMP_TIME_1024_US,
> +	FLASH_RAMP_TIME_2048_US,
> +	FLASH_RAMP_TIME_4096_US,
> +	FLASH_RAMP_TIME_8192_US,
> +	FLASH_RAMP_TIME_16384_US,
> +	FLASH_RAMP_TIME_32768_US,
> +};
> +
> +enum lm3556_indic_current_limit {
> +	INDIC_I_LIMIT_1500_MA =3D 0,
> +	INDIC_I_LIMIT_2000_MA,
> +	INDIC_I_LIMIT_2500_MA,
> +	INDIC_I_LIMIT_3000_MA
> +};
> +
> +enum lm3556_flash_current {
> +	FLASH_I_93750_UA =3D 0,
> +	FLASH_I_187500_UA,
> +	FLASH_I_281250_UA,
> +	FLASH_I_375000_UA,
> +	FLASH_I_468750_UA,
> +	FLASH_I_562500_UA,
> +	FLASH_I_656250_UA,
> +	FLASH_I_750000_UA,
> +	FLASH_I_843750_UA,
> +	FLASH_I_937500_UA,
> +	FLASH_I_1031250_UA,
> +	FLASH_I_1125000_UA,
> +	FLASH_I_1218750_UA,
> +	FLASH_I_1312500_UA,
> +	FLASH_I_1406250_UA,
> +	FLASH_I_1500000_UA,
> +
> +};
> +
> +enum lm3556_torch_current {
> +	TORCH_I_46880_UA =3D 0,
> +	TORCH_I_93750_UA,
> +	TORCH_I_1406300_UA,
> +	TORCH_I_187500_UA,
> +	TORCH_I_234380_UA,
> +	TORCH_I_281250_UA,
> +	TORCH_I_328130_UA,
> +	TORCH_I_375000_UA,
> +};
> +
> +enum lm3556_mode {
> +	MODES_STASNDBY =3D 0,
> +	MODES_INDIC,
> +	MODES_TORCH,
> +	MODES_FLASH
> +};
> +
> +enum lm3556_pass_mode {
> +	PASS_MODE_NORMAL =3D 0,
> +	PASS_MODE_PASS_ONLY
> +};
> +
> +enum lm3556_prechg_mode {
> +	PRE_CHARGE_MODE_NORMAL =3D 0,
> +	PRE_CHARGE_MODE_PRE_CHARGE
> +};
> +
> +enum lm3556_pin_polarity {
> +	PIN_LOW_ACTIVE =3D 0,
> +	PIN_HIGH_ACTIVE,
> +};
> +
> +enum lm3556_pin_enable {
> +	PIN_DISABLED =3D 0,
> +	PIN_ENABLED,
> +};
> +
> +enum lm3556_strobe_usuage {
> +	STROBE_EDGE_DETECT =3D 0,
> +	STROBE_LEVEL_DETECT,
> +};
> +
> +struct lm3556_platform_data {
> +	enum lm3556_pin_enable torch_pin_en;
> +	enum lm3556_pin_polarity torch_pin_polarity;
> +
> +	enum lm3556_strobe_usuage strobe_usuage;
> +	enum lm3556_pin_enable strobe_pin_en;
> +	enum lm3556_pin_polarity strobe_pin_polarity;
> +
> +	enum lm3556_pin_enable tx_pin_en;
> +	enum lm3556_pin_polarity tx_pin_polarity;
> +
> +	enum lm3556_indic_mode indicator_mode;
> +};
> +
> +#endif /* __LINUX_LM3556_H */
> --=20
> 1.7.5.4

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--oC1+HKm2/end4ao3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk92AeIACgkQD27XaX1/VRuucACgi9WrqGPaTJ6UP1dMXt7O9F9r
SkEAn1hdTF/GUA56/zvBLiLDPHs8XVfM
=34g3
-----END PGP SIGNATURE-----

--oC1+HKm2/end4ao3--
