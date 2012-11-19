Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab2KSKwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:52:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54711 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2KSKwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:52:53 -0500
Date: Mon, 19 Nov 2012 11:52:42 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Laxman Dewangan <ldewangan@nvidia.com>
cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: max8973: add regulator driver support
In-Reply-To: <1353288509-26703-1-git-send-email-ldewangan@nvidia.com>
Message-ID: <Pine.LNX.4.64.1211190900110.11024@axis700.grange>
References: <1353288509-26703-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:N0vGmW6m0it5Pmj6/xS9U0ol6f3yYaY8T7my+8DK4qX
 LR2Cezo7gArrpOHu2eXZtc3FcVFSwNYI1irdxqeBZteWJwrvBu
 aEMcY/byBqGDIEMs+5RxBhTFCRsCAoA154CV7VVoAEd1pR+2V9
 9n2jyJzl7h4t1oynY3QLmA0OMmIHUQZt6Z2gqPVOVNaYeHd8vf
 O6wazdBfQ2I6w1JOrWmf1khdZN1BaMcYWtexPEOKeBcGi4Rp0M
 mwxgONH0gMCZJCs9sCkGA4PArH1kpaqvBjiFFiP/YFDfwglye0
 NNiqp9cMnZcZkI+FFmW7jdqDwRrdl66yjl3lXsb3K54sesoJpI
 7+n4jKdsYodU9n38q7cL0QiDAoZI16a8upZLXCqaTGhLVQ+2LO
 Ljg0LxPuHP3ag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman

On Mon, 19 Nov 2012, Laxman Dewangan wrote:

> The MAXIM MAX8973 high-efficiency, three phase, DC-DC step-down
> switching regulator delievers up to 9A of output current. Each
> phase operates at a 2MHz fixed frequency with a 120 deg shift
> from the adjacent phase, allowing the use of small magnetic
> component.

Thanks for submitting this driver! The notion of DVS regulators was new to 
me, so, I checked http://www.ti.com/lit/an/sbva020/sbva020.pdf for a short 
description. After that I had a look at a couple of existing DVS regulator 
drivers in the tree. Well, I came to two conclusions so far: (1) The 
current regulator API is not very well suitable for such regulators. I 
would imagine, one would need two methods: for setting the "normal" and 
the DVS voltage. Instead of this drivers are trying to be smart at 
guessing, which voltage the user is trying to set now... (2) Drivers do 
this in different ways and at least out of the 2 drivers I looked at both 
have bugs and different ones at that. I'll send a separate email, 
describing what I found suspicious in them.

Of course, all the above was just my DVS-newbie impression, which can very 
well be absolutely wrong.

> 
> Add regulator driver for this device.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/regulator/Kconfig                   |   10 +
>  drivers/regulator/Makefile                  |    1 +
>  drivers/regulator/max8973-regulator.c       |  505 +++++++++++++++++++++++++++
>  include/linux/regulator/max8973-regulator.h |   72 ++++
>  4 files changed, 588 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/regulator/max8973-regulator.c
>  create mode 100644 include/linux/regulator/max8973-regulator.h
> 
> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> index cbc685d..ddd8869 100644
> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -204,6 +204,16 @@ config REGULATOR_MAX8952
>  	  via I2C bus. Maxim 8952 has one voltage output and supports 4 DVS
>  	  modes ranging from 0.77V to 1.40V by 0.01V steps.
>  
> +config REGULATOR_MAX8973
> +	tristate "Maxim MAX8973 voltage regulator "
> +	depends on I2C
> +	select REGMAP_I2C
> +	help
> +	  The MAXIM MAX8973 high-efficiency. three phase, DC-DC step-down
> +	  switching regulator delievers up to 9A of output current. Each
> +	  phase operates at a 2MHz fixed frequency with a 120 deg shift
> +	  from the adjacent phase, allowing the use of small magnetic component.
> +
>  config REGULATOR_MAX8997
>  	tristate "Maxim 8997/8966 regulator"
>  	depends on MFD_MAX8997
> diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
> index db274dc..ac093f3 100644
> --- a/drivers/regulator/Makefile
> +++ b/drivers/regulator/Makefile
> @@ -34,6 +34,7 @@ obj-$(CONFIG_REGULATOR_MAX8660) += max8660.o
>  obj-$(CONFIG_REGULATOR_MAX8907) += max8907-regulator.o
>  obj-$(CONFIG_REGULATOR_MAX8925) += max8925-regulator.o
>  obj-$(CONFIG_REGULATOR_MAX8952) += max8952.o
> +obj-$(CONFIG_REGULATOR_MAX8973) += max8973-regulator.o
>  obj-$(CONFIG_REGULATOR_MAX8997) += max8997.o
>  obj-$(CONFIG_REGULATOR_MAX8998) += max8998.o
>  obj-$(CONFIG_REGULATOR_MAX77686) += max77686.o
> diff --git a/drivers/regulator/max8973-regulator.c b/drivers/regulator/max8973-regulator.c
> new file mode 100644
> index 0000000..e6328f9
> --- /dev/null
> +++ b/drivers/regulator/max8973-regulator.c
> @@ -0,0 +1,505 @@
> +/*
> + * max8973-regulator.c -- Maxim max8973
> + *
> + * Regulator driver for MAXIM 8973 DC-DC step-down switching regulator.
> + *
> + * Copyright (c) 2012, NVIDIA Corporation.
> + *
> + * Author: Laxman Dewangan <ldewangan@nvidia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
> + * whether express or implied; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
> + * 02111-1307, USA
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/driver.h>
> +#include <linux/regulator/machine.h>
> +#include <linux/regulator/max8973-regulator.h>
> +#include <linux/gpio.h>
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <linux/regmap.h>
> +
> +/* Register definitions */
> +#define MAX8973_VOUT					0x0
> +#define MAX8973_VOUT_DVS				0x1

You're lucky, that your first voltage-set register address is 0. This is used 
multiple times in the driver and is very confusing. Repeatedly offsets and 
addresses are mixed up. So, if you had a non-0 address it would not work. 
Also the fact, that the DVS voltage set register has address == 1 is used 
implicitly... To reduce confusion you could introduce a macro, say,
#define MAX8973_VOUT_BASE 0
and use it explicitly to differentiate between addresses and offsets.

> +#define MAX8973_CONTROL1				0x2
> +#define MAX8973_CONTROL2				0x3
> +#define MAX8973_CHIPID1					0x4
> +#define MAX8973_CHIPID2					0x5
> +
> +#define MAX8973_MAX_VOUT_REG				2

MAX8973_MAX_VOUT_REG is the number of voltage-set registers

> +
> +/* MAX8973_VOUT */
> +#define MAX8973_VOUT_ENABLE				BIT(7)
> +#define MAX8973_VOUT_MASK				0x7F
> +
> +/* MAX8973_VOUT_DVS */
> +#define MAX8973_DVS_VOUT_MASK				0x7F
> +
> +/* MAX8973_CONTROL1 */
> +#define MAX8973_SNS_ENABLE				BIT(7)
> +#define MAX8973_FPWM_EN_M				BIT(6)
> +#define MAX8973_NFSR_ENABLE				BIT(5)
> +#define MAX8973_AD_ENABLE				BIT(4)
> +#define MAX8973_BIAS_ENABLE				BIT(3)
> +#define MAX8973_FREQSHIFT_9PER				BIT(2)
> +
> +#define MAX8973_RAMP_12mV_PER_US			0x0
> +#define MAX8973_RAMP_25mV_PER_US			0x1
> +#define MAX8973_RAMP_50mV_PER_US			0x2
> +#define MAX8973_RAMP_200mV_PER_US			0x3
> +
> +/* MAX8973_CONTROL2 */
> +#define MAX8973_WDTMR_ENABLE				BIT(6)
> +#define MAX8973_DISCH_ENBABLE				BIT(5)
> +#define MAX8973_FT_ENABLE				BIT(4)
> +
> +#define MAX8973_CKKADV_TRIP_DISABLE			0xC
> +#define MAX8973_CKKADV_TRIP_75mV_PER_US			0x0
> +#define MAX8973_CKKADV_TRIP_150mV_PER_US		0x4
> +#define MAX8973_CKKADV_TRIP_75mV_PER_US_HIST_DIS	0x8
> +#define MAX8973_CONTROL_CLKADV_TRIP_MASK		0x00030000
> +
> +#define MAX8973_INDUCTOR_MIN_30_PER			0x0
> +#define MAX8973_INDUCTOR_NOMINAL			0x1
> +#define MAX8973_INDUCTOR_PLUS_30_PER			0x2
> +#define MAX8973_INDUCTOR_PLUS_60_PER			0x3
> +#define MAX8973_CONTROL_INDUCTOR_VALUE_MASK		0x00300000
> +
> +#define MAX8973_MIN_VOLATGE				606250
> +#define MAX8973_MAX_VOLATGE				1400000
> +#define MAX8973_VOLATGE_STEP				6250
> +#define MAX8973_BUCK_N_VOLTAGE				0x80
> +
> +/* Maxim 8973 chip information */
> +struct max8973_chip {
> +	struct device *dev;
> +	struct regulator_desc desc;
> +	struct regulator_dev *rdev;
> +	struct regmap *regmap;
> +	bool enable_external_control;
> +	int dvs_gpio;
> +	int lru_index[MAX8973_MAX_VOUT_REG];

lru_index[] is an array with voltage-set register address offsets, i.e. its 
members can take values MAX8973_VOUT - MAX8973_VOUT_BASE and
MAX8973_VOUT_DVS - MAX8973_VOUT_BASE

> +	int curr_vout_val[MAX8973_MAX_VOUT_REG];

curr_vout_val[] is an array with voltage selectors for above registers

> +	int curr_vout_reg;

The above is used both as an offset and as a register address. Let's say it 
is intended to be a register address

> +	int curr_gpio_val;

This one is confusing too. Judging by the name it seems it should mean a 
GPIO value, so, should take values "high" and "low."

> +	bool valid_dvs_gpio;
> +};
> +
> +/*
> + * find_voltage_set_register: Find new voltage configuration register (VOUT).
> + * The finding of the new VOUT register will be based on the LRU mechanism.
> + * Each VOUT register will have different voltage configured . This
> + * Function will look if any of the VOUT register have requested voltage set
> + * or not.
> + *     - If it is already there then it will make that register as most
> + *       recently used and return as found so that caller need not to set
> + *       the VOUT register but need to set the proper gpios to select this
> + *       VOUT register.
> + *     - If requested voltage is not found then it will use the least
> + *       recently mechanism to get new VOUT register for new configuration
> + *       and will return not_found so that caller need to set new VOUT
> + *       register and then gpios (both).
> + */
> +static bool find_voltage_set_register(struct max8973_chip *tps,
> +		int req_vsel, int *vout_reg, int *gpio_val)
> +{
> +	int i;
> +	bool found = false;
> +	int new_vout_reg = tps->lru_index[MAX8973_MAX_VOUT_REG - 1];

new_vout_reg is a register address offset

> +	int found_index = MAX8973_MAX_VOUT_REG - 1;
> +
> +	for (i = 0; i < MAX8973_MAX_VOUT_REG; ++i) {
> +		if (tps->curr_vout_val[tps->lru_index[i]] == req_vsel) {
> +			new_vout_reg = tps->lru_index[i];
> +			found_index = i;
> +			found = true;
> +			goto update_lru_index;

Just use "break"

> +		}
> +	}
> +
> +update_lru_index:
> +	for (i = found_index; i > 0; i--)
> +		tps->lru_index[i] = tps->lru_index[i - 1];
> +
> +	tps->lru_index[0] = new_vout_reg;
> +	*gpio_val = new_vout_reg;

Hm, what does a register address offset have to do with a GPIO value??

> +	*vout_reg = MAX8973_VOUT + new_vout_reg;
> +	return found;
> +}
> +
> +static int max8973_dcdc_get_voltage_sel(struct regulator_dev *rdev)
> +{
> +	struct max8973_chip *max = rdev_get_drvdata(rdev);
> +	unsigned int data;
> +	int ret;
> +
> +	ret = regmap_read(max->regmap, max->curr_vout_reg, &data);
> +	if (ret < 0) {
> +		dev_err(max->dev, "register %d read failed, err = %d\n",
> +			max->curr_vout_reg, ret);
> +		return ret;
> +	}
> +	return data & MAX8973_VOUT_MASK;
> +}
> +
> +static int max8973_dcdc_set_voltage_sel(struct regulator_dev *rdev,
> +	     unsigned vsel)
> +{
> +	struct max8973_chip *max = rdev_get_drvdata(rdev);
> +	int ret;
> +	bool found = false;
> +	int vout_reg = max->curr_vout_reg;
> +	int gpio_val = max->curr_gpio_val;
> +
> +	/*
> +	 * If gpios are available to select the VOUT register then least
> +	 * recently used register for new configuration.
> +	 */
> +	if (max->valid_dvs_gpio)
> +		found = find_voltage_set_register(max, vsel,
> +					&vout_reg, &gpio_val);
> +
> +	if (!found) {
> +		ret = regmap_update_bits(max->regmap, vout_reg,
> +					MAX8973_VOUT_MASK, vsel);
> +		if (ret < 0) {
> +			dev_err(max->dev, "register %d update failed, err %d\n",
> +				 vout_reg, ret);
> +			return ret;
> +		}
> +		max->curr_vout_reg = vout_reg;
> +		max->curr_vout_val[gpio_val] = vsel;

Why is the gpio_val used as an index into the curr_vout_val[] array, which 
should actually be indexed by voltage set register address offsets?

> +	}
> +
> +	/* Select proper VOUT register vio gpios */
> +	if (max->valid_dvs_gpio) {
> +		gpio_set_value_cansleep(max->dvs_gpio, gpio_val & 0x1);

What does odd / even have to do with the GPIO level selection? I think, an 
attempt of a generic approach with multiple voltage set registers and a 
generic multiplexor is confused here with its special case of just two such 
registers, in which case the multiplexor is controlled by just one GPIO. 
You can keep some parts of the code generic, although I'm not sure it's 
worth doing here, since DVS in general and this regulator specifically do 
only deal with two voltage values. So, I would probably just explicitly go 
for either voltage #1 or voltage #2, not even trying to pretend, that the 
driver can handle arbitrary mane of them.

> +		max->curr_gpio_val = gpio_val;
> +	}
> +	return 0;
> +}
> +
> +static int max8973_dcdc_set_mode(struct regulator_dev *rdev, unsigned int mode)
> +{
> +	struct max8973_chip *max = rdev_get_drvdata(rdev);
> +	int ret;
> +	int pwm;
> +
> +	/* Enable force PWM mode in FAST mode only. */
> +	switch (mode) {
> +	case REGULATOR_MODE_FAST:
> +		pwm = MAX8973_FPWM_EN_M;
> +		break;
> +
> +	case REGULATOR_MODE_NORMAL:
> +		pwm = 0;
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret = regmap_update_bits(max->regmap, MAX8973_CONTROL1,
> +				MAX8973_FPWM_EN_M, pwm);
> +	if (ret < 0)
> +		dev_err(max->dev, "register %d update failed, err %d\n",
> +				MAX8973_CONTROL1, ret);
> +	return ret;
> +}
> +
> +static unsigned int max8973_dcdc_get_mode(struct regulator_dev *rdev)
> +{
> +	struct max8973_chip *max = rdev_get_drvdata(rdev);
> +	unsigned int data;
> +	int ret;
> +
> +	ret = regmap_read(max->regmap, MAX8973_CONTROL1, &data);
> +	if (ret < 0) {
> +		dev_err(max->dev, "register %d read failed, err %d\n",
> +				MAX8973_CONTROL1, ret);
> +		return ret;
> +	}
> +	return (data & MAX8973_FPWM_EN_M) ?
> +		REGULATOR_MODE_FAST : REGULATOR_MODE_NORMAL;
> +}
> +
> +static struct regulator_ops max8973_dcdc_ops = {
> +	.get_voltage_sel	= max8973_dcdc_get_voltage_sel,
> +	.set_voltage_sel	= max8973_dcdc_set_voltage_sel,
> +	.list_voltage		= regulator_list_voltage_linear,
> +	.set_mode		= max8973_dcdc_set_mode,
> +	.get_mode		= max8973_dcdc_get_mode,
> +};
> +
> +static int __devinit max8973_init_dcdc(struct max8973_chip *max,
> +		struct max8973_regulator_platform_data *pdata)
> +{
> +	int ret;
> +	uint8_t	control1 = 0;
> +	uint8_t control2 = 0;
> +
> +	if (pdata->control_flags & MAX8973_CONTROL_REMOTE_SENSE_ENABLE)
> +		control1 |= MAX8973_SNS_ENABLE;
> +
> +	if (!(pdata->control_flags & MAX8973_CONTROL_FALLING_SLEW_RATE_ENABLE))
> +		control1 |= MAX8973_NFSR_ENABLE;
> +
> +	if (pdata->control_flags & MAX8973_CONTROL_OUTPUT_ACTIVE_DISCH_ENABLE)
> +		control1 |= MAX8973_AD_ENABLE;
> +
> +	if (pdata->control_flags & MAX8973_CONTROL_BIAS_ENABLE)
> +		control1 |= MAX8973_BIAS_ENABLE;
> +
> +	if (pdata->control_flags & MAX8973_CONTROL_FREQ_SHIFT_9PER_ENABLE)
> +		control1 |= MAX8973_FREQSHIFT_9PER;
> +
> +	/* Set ramp delay */
> +	if (pdata->reg_init_data &&
> +			pdata->reg_init_data->constraints.ramp_delay) {
> +		if (pdata->reg_init_data->constraints.ramp_delay < 25000)
> +			control1 = MAX8973_RAMP_12mV_PER_US;
> +		else if (pdata->reg_init_data->constraints.ramp_delay < 50000)
> +			control1 = MAX8973_RAMP_25mV_PER_US;
> +		else if (pdata->reg_init_data->constraints.ramp_delay < 200000)
> +			control1 = MAX8973_RAMP_50mV_PER_US;
> +		else
> +			control1 = MAX8973_RAMP_200mV_PER_US;
> +	} else {
> +		control1 = MAX8973_RAMP_12mV_PER_US;
> +		max->desc.ramp_delay = 12500;
> +	}
> +
> +	if (!(pdata->control_flags & MAX8973_CONTROL_PULL_DOWN_ENABLE))
> +		control2 |= MAX8973_DISCH_ENBABLE;
> +
> +	/*  Clock advance trip configuration */
> +	switch (pdata->control_flags & MAX8973_CONTROL_CLKADV_TRIP_MASK) {
> +	case MAX8973_CONTROL_CLKADV_TRIP_DISABLED:
> +		control2 |= MAX8973_CKKADV_TRIP_DISABLE;
> +		break;
> +
> +	case MAX8973_CONTROL_CLKADV_TRIP_75mV_PER_US:
> +		control2 |= MAX8973_CKKADV_TRIP_75mV_PER_US;
> +		break;
> +
> +	case MAX8973_CONTROL_CLKADV_TRIP_150mV_PER_US:
> +		control2 |= MAX8973_CKKADV_TRIP_150mV_PER_US;
> +		break;
> +
> +	case MAX8973_CONTROL_CLKADV_TRIP_75mV_PER_US_HIST_DIS:
> +		control2 |= MAX8973_CKKADV_TRIP_75mV_PER_US_HIST_DIS;
> +		break;
> +	}
> +
> +	/* Configure inductor value */
> +	switch (pdata->control_flags & MAX8973_CONTROL_INDUCTOR_VALUE_MASK) {
> +	case MAX8973_CONTROL_INDUCTOR_VALUE_NOMINAL:
> +		control2 |= MAX8973_INDUCTOR_NOMINAL;
> +		break;
> +
> +	case MAX8973_CONTROL_INDUCTOR_VALUE_MINUS_30_PER:
> +		control2 |= MAX8973_INDUCTOR_MIN_30_PER;
> +		break;
> +
> +	case MAX8973_CONTROL_INDUCTOR_VALUE_PLUS_30_PER:
> +		control2 |= MAX8973_INDUCTOR_PLUS_30_PER;
> +		break;
> +
> +	case MAX8973_CONTROL_INDUCTOR_VALUE_PLUS_60_PER:
> +		control2 |= MAX8973_INDUCTOR_PLUS_60_PER;
> +		break;
> +	}
> +
> +	ret = regmap_write(max->regmap, MAX8973_CONTROL1, control1);
> +	if (ret < 0) {
> +		dev_err(max->dev, "register %d write failed, err = %d",
> +				MAX8973_CONTROL1, ret);
> +		return ret;
> +	}
> +
> +	ret = regmap_write(max->regmap, MAX8973_CONTROL2, control2);
> +	if (ret < 0) {
> +		dev_err(max->dev, "register %d write failed, err = %d",
> +				MAX8973_CONTROL2, ret);
> +		return ret;
> +	}
> +
> +	/* If external control is enabled then disable EN bit */
> +	if (max->enable_external_control) {
> +		ret = regmap_update_bits(max->regmap, MAX8973_VOUT,
> +						MAX8973_VOUT_ENABLE, 0);
> +		if (ret < 0)
> +			dev_err(max->dev, "register %d update failed, err = %d",
> +				MAX8973_VOUT, ret);
> +	}
> +	return ret;
> +}
> +
> +static const struct regmap_config max8973_regmap_config = {
> +	.reg_bits		= 8,
> +	.val_bits		= 8,
> +	.max_register		= MAX8973_CHIPID2,
> +	.cache_type		= REGCACHE_RBTREE,
> +};
> +
> +static int __devinit max8973_probe(struct i2c_client *client,
> +				     const struct i2c_device_id *id)
> +{
> +	struct max8973_regulator_platform_data *pdata;
> +	struct regulator_config config = { };
> +	struct regulator_dev *rdev;
> +	struct max8973_chip *max;
> +	int ret;
> +
> +	pdata = client->dev.platform_data;
> +	if (!pdata) {
> +		dev_err(&client->dev, "No Platform data");
> +		return -EIO;
> +	}
> +
> +	max = devm_kzalloc(&client->dev, sizeof(*max), GFP_KERNEL);
> +	if (!max) {
> +		dev_err(&client->dev, "Memory allocation for max failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	max->regmap = devm_regmap_init_i2c(client, &max8973_regmap_config);
> +	if (IS_ERR(max->regmap)) {
> +		ret = PTR_ERR(max->regmap);
> +		dev_err(&client->dev, "regmap init failed, err %d\n", ret);
> +		return ret;
> +	}
> +
> +	i2c_set_clientdata(client, max);
> +	max->dev = &client->dev;
> +	max->desc.name = id->name;
> +	max->desc.id = 0;

Don't you have to be able to process multiple such devices?

> +	max->desc.ops = &max8973_dcdc_ops;
> +	max->desc.type = REGULATOR_VOLTAGE;
> +	max->desc.owner = THIS_MODULE;
> +	max->desc.min_uV = MAX8973_MIN_VOLATGE;
> +	max->desc.uV_step = MAX8973_VOLATGE_STEP;
> +	max->desc.n_voltages = MAX8973_BUCK_N_VOLTAGE;
> +
> +	if (pdata->enable_ext_control) {
> +		max->desc.enable_reg = MAX8973_VOUT;
> +		max->desc.enable_mask = MAX8973_VOUT_ENABLE;
> +		max8973_dcdc_ops.enable = regulator_is_enabled_regmap;
> +		max8973_dcdc_ops.disable = regulator_disable_regmap;
> +		max8973_dcdc_ops.is_enabled = regulator_is_enabled_regmap;
> +	}
> +
> +	max->enable_external_control = pdata->enable_ext_control;
> +	max->dvs_gpio = pdata->dvs_gpio;
> +	max->curr_gpio_val = pdata->dvs_def_state;
> +	max->curr_vout_reg = MAX8973_VOUT + pdata->dvs_def_state;
> +	max->lru_index[0] = max->curr_vout_reg;

Here you actually need an offset within your register address space, so, 
should be

+	max->lru_index[0] = pdata->dvs_def_state;

> +	max->valid_dvs_gpio = false;
> +
> +	if (gpio_is_valid(max->dvs_gpio)) {
> +		int gpio_flags;
> +		int i;
> +
> +		gpio_flags = (pdata->dvs_def_state) ?
> +				GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
> +		ret = devm_gpio_request_one(&client->dev, max->dvs_gpio,
> +				gpio_flags, "max8973-dvs");
> +		if (ret) {
> +			dev_err(&client->dev,
> +				"gpio_request for gpio %d failed, err = %d\n",
> +				max->dvs_gpio, ret);
> +			return ret;
> +		}
> +		max->valid_dvs_gpio = true;
> +
> +		/*
> +		 * Initialize the lru index with vout_reg id
> +		 * The index 0 will be most recently used and
> +		 * set with the max->curr_vout_reg */
> +		for (i = 0; i < MAX8973_MAX_VOUT_REG; ++i)
> +			max->lru_index[i] = i;
> +		max->lru_index[0] = max->curr_vout_reg;

This is already done above

> +		max->lru_index[max->curr_vout_reg] = 0;

Sorry, what does this mean? Is "current" at index 0 or is it at index, 
corresponding to curr_vout_reg? This whole Least Recently Used algorithm 
is pretty, but seems unneeded here, if you do decide to limit yourself to 
hard-coded 2 values: DVS and "normal." But that is coming back to the 
general question at the top of this mail.

> +	}
> +
> +	ret = max8973_init_dcdc(max, pdata);
> +	if (ret < 0) {
> +		dev_err(max->dev, "Max8973 Init failed, err = %d\n", ret);
> +		return ret;
> +	}
> +
> +	config.dev = &client->dev;
> +	config.init_data = pdata->reg_init_data;
> +	config.driver_data = max;
> +	config.of_node = client->dev.of_node;
> +	config.regmap = max->regmap;
> +
> +	/* Register the regulators */
> +	rdev = regulator_register(&max->desc, &config);
> +	if (IS_ERR(rdev)) {
> +		ret = PTR_ERR(rdev);
> +		dev_err(max->dev, "regulator register failed, err %d\n", ret);
> +		return ret;
> +	}
> +
> +	max->rdev = rdev;
> +	return 0;
> +}
> +
> +static int __devexit max8973_remove(struct i2c_client *client)
> +{
> +	struct max8973_chip *max = i2c_get_clientdata(client);
> +
> +	regulator_unregister(max->rdev);
> +	return 0;
> +}
> +
> +static const struct i2c_device_id max8973_id[] = {
> +	{.name = "max8973",},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, max8973_id);
> +
> +static struct i2c_driver max8973_i2c_driver = {
> +	.driver = {
> +		.name = "max8973",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = max8973_probe,
> +	.remove = __devexit_p(max8973_remove),
> +	.id_table = max8973_id,
> +};
> +
> +static int __init max8973_init(void)
> +{
> +	return i2c_add_driver(&max8973_i2c_driver);
> +}
> +subsys_initcall(max8973_init);
> +
> +static void __exit max8973_cleanup(void)
> +{
> +	i2c_del_driver(&max8973_i2c_driver);
> +}
> +module_exit(max8973_cleanup);
> +
> +MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
> +MODULE_DESCRIPTION("MAX8973 voltage regulator driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/regulator/max8973-regulator.h b/include/linux/regulator/max8973-regulator.h
> new file mode 100644
> index 0000000..f8acc05
> --- /dev/null
> +++ b/include/linux/regulator/max8973-regulator.h
> @@ -0,0 +1,72 @@
> +/*
> + * max8973-regulator.h -- MAXIM 8973 regulator
> + *
> + * Interface for regulator driver for MAXIM 8973 DC-DC step-down
> + * switching regulator.
> + *
> + * Copyright (C) 2012 NVIDIA Corporation
> +
> + * Author: Laxman Dewangan <ldewangan@nvidia.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA	02110-1301, USA.
> + *
> + */
> +
> +#ifndef __LINUX_REGULATOR_MAX8973_H
> +#define __LINUX_REGULATOR_MAX8973_H
> +
> +/*
> + * Control flags for configuration of the device.
> + * Client need to pass this information with ORed
> + */
> +#define MAX8973_CONTROL_REMOTE_SENSE_ENABLE			0x00000001
> +#define MAX8973_CONTROL_FALLING_SLEW_RATE_ENABLE		0x00000002
> +#define MAX8973_CONTROL_OUTPUT_ACTIVE_DISCH_ENABLE		0x00000004
> +#define MAX8973_CONTROL_BIAS_ENABLE				0x00000008
> +#define MAX8973_CONTROL_PULL_DOWN_ENABLE			0x00000010
> +#define MAX8973_CONTROL_FREQ_SHIFT_9PER_ENABLE			0x00000020
> +
> +#define MAX8973_CONTROL_CLKADV_TRIP_DISABLED			0x00000000
> +#define MAX8973_CONTROL_CLKADV_TRIP_75mV_PER_US			0x00010000
> +#define MAX8973_CONTROL_CLKADV_TRIP_150mV_PER_US		0x00020000
> +#define MAX8973_CONTROL_CLKADV_TRIP_75mV_PER_US_HIST_DIS	0x00030000
> +
> +#define MAX8973_CONTROL_INDUCTOR_VALUE_NOMINAL			0x00000000
> +#define MAX8973_CONTROL_INDUCTOR_VALUE_MINUS_30_PER		0x00100000
> +#define MAX8973_CONTROL_INDUCTOR_VALUE_PLUS_30_PER		0x00200000
> +#define MAX8973_CONTROL_INDUCTOR_VALUE_PLUS_60_PER		0x00300000
> +
> +/*
> + * struct max8973_regulator_platform_data - max8973 regulator platform data.
> + *
> + * @reg_init_data: The regulator init data.
> + * @control_flags: Control flags which are ORed value of above flags to
> + *		configure device.
> + * @enable_ext_control: Enable the voltage enable/disable through external
> + *		control signal from EN input pin. If it is false then
> + *		voltage output will be enabled/disabled through EN bit of
> + *		device register.
> + * @dvs_gpio: GPIO for dvs. It should be -1 if this is tied with fixed logic.
> + * @dvs_def_state: Default state of dvs. 1 if it is high else 0.
> + */
> +struct max8973_regulator_platform_data {
> +	struct regulator_init_data *reg_init_data;
> +	unsigned long control_flags;
> +	bool enable_ext_control;
> +	int dvs_gpio;
> +	unsigned dvs_def_state:1;
> +};
> +
> +#endif /* __LINUX_REGULATOR_MAX8973_H */
> -- 
> 1.7.1.1
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
