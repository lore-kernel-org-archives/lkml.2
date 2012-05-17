Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399Ab2EQXwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 19:52:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60669 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2EQXwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 19:52:44 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/8 v2] mfd: tps65910: Commonize regmap access through header
To: Rhyland Klein <rklein@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rhyland Klein <rklein@nvidia.com>
In-Reply-To: <1335310570-12455-4-git-send-email-rklein@nvidia.com>
References: <1335310570-12455-1-git-send-email-rklein@nvidia.com> <1335310570-12455-4-git-send-email-rklein@nvidia.com>
Date: Thu, 17 May 2012 17:52:41 -0600
Message-Id: <20120517235241.A349E3E062C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2012 16:36:05 -0700, Rhyland Klein <rklein@nvidia.com> wrote:
> This change removes the read/write callback functions in favor of common
> regmap accessors inside the header file. This change also makes use of
> regmap_read/write for single register access which maps better onto what this
> driver actually needs.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>

for the gpio bits:

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  v2: implemented switching tps65910 drivers over to more directly accessing
>      the regmap rather than going through utility functions.
> 
>  drivers/gpio/gpio-tps65910.c           |   14 +++---
>  drivers/mfd/tps65910-irq.c             |   34 ++++++------
>  drivers/mfd/tps65910.c                 |   26 ---------
>  drivers/regulator/tps65910-regulator.c |   88 +++++++++++++++-----------------
>  include/linux/mfd/tps65910.h           |   29 +++++++++--
>  5 files changed, 91 insertions(+), 100 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-tps65910.c b/drivers/gpio/gpio-tps65910.c
> index 7eef648..bc155f2 100644
> --- a/drivers/gpio/gpio-tps65910.c
> +++ b/drivers/gpio/gpio-tps65910.c
> @@ -23,9 +23,9 @@
>  static int tps65910_gpio_get(struct gpio_chip *gc, unsigned offset)
>  {
>  	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
> -	uint8_t val;
> +	unsigned int val;
>  
> -	tps65910->read(tps65910, TPS65910_GPIO0 + offset, 1, &val);
> +	tps65910_reg_read(tps65910, TPS65910_GPIO0 + offset, &val);
>  
>  	if (val & GPIO_STS_MASK)
>  		return 1;
> @@ -39,10 +39,10 @@ static void tps65910_gpio_set(struct gpio_chip *gc, unsigned offset,
>  	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
>  
>  	if (value)
> -		tps65910_set_bits(tps65910, TPS65910_GPIO0 + offset,
> +		tps65910_reg_set_bits(tps65910, TPS65910_GPIO0 + offset,
>  						GPIO_SET_MASK);
>  	else
> -		tps65910_clear_bits(tps65910, TPS65910_GPIO0 + offset,
> +		tps65910_reg_clear_bits(tps65910, TPS65910_GPIO0 + offset,
>  						GPIO_SET_MASK);
>  }
>  
> @@ -54,7 +54,7 @@ static int tps65910_gpio_output(struct gpio_chip *gc, unsigned offset,
>  	/* Set the initial value */
>  	tps65910_gpio_set(gc, offset, value);
>  
> -	return tps65910_set_bits(tps65910, TPS65910_GPIO0 + offset,
> +	return tps65910_reg_set_bits(tps65910, TPS65910_GPIO0 + offset,
>  						GPIO_CFG_MASK);
>  }
>  
> @@ -62,7 +62,7 @@ static int tps65910_gpio_input(struct gpio_chip *gc, unsigned offset)
>  {
>  	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
>  
> -	return tps65910_clear_bits(tps65910, TPS65910_GPIO0 + offset,
> +	return tps65910_reg_clear_bits(tps65910, TPS65910_GPIO0 + offset,
>  						GPIO_CFG_MASK);
>  }
>  
> @@ -102,7 +102,7 @@ void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base)
>  		int i;
>  		for (i = 0; i < tps65910->gpio.ngpio; ++i) {
>  			if (board_data->en_gpio_sleep[i]) {
> -				ret = tps65910_set_bits(tps65910,
> +				ret = tps65910_reg_set_bits(tps65910,
>  					TPS65910_GPIO0 + i, GPIO_SLEEP_MASK);
>  				if (ret < 0)
>  					dev_warn(tps65910->dev,
> diff --git a/drivers/mfd/tps65910-irq.c b/drivers/mfd/tps65910-irq.c
> index c9ed5c0..0f1ff7f 100644
> --- a/drivers/mfd/tps65910-irq.c
> +++ b/drivers/mfd/tps65910-irq.c
> @@ -41,28 +41,28 @@ static inline int irq_to_tps65910_irq(struct tps65910 *tps65910,
>  static irqreturn_t tps65910_irq(int irq, void *irq_data)
>  {
>  	struct tps65910 *tps65910 = irq_data;
> +	unsigned int reg;
>  	u32 irq_sts;
>  	u32 irq_mask;
> -	u8 reg;
>  	int i;
>  
> -	tps65910->read(tps65910, TPS65910_INT_STS, 1, &reg);
> +	tps65910_reg_read(tps65910, TPS65910_INT_STS, &reg);
>  	irq_sts = reg;
> -	tps65910->read(tps65910, TPS65910_INT_STS2, 1, &reg);
> +	tps65910_reg_read(tps65910, TPS65910_INT_STS2, &reg);
>  	irq_sts |= reg << 8;
>  	switch (tps65910_chip_id(tps65910)) {
>  	case TPS65911:
> -		tps65910->read(tps65910, TPS65910_INT_STS3, 1, &reg);
> +		tps65910_reg_read(tps65910, TPS65910_INT_STS3, &reg);
>  		irq_sts |= reg << 16;
>  	}
>  
> -	tps65910->read(tps65910, TPS65910_INT_MSK, 1, &reg);
> +	tps65910_reg_read(tps65910, TPS65910_INT_MSK, &reg);
>  	irq_mask = reg;
> -	tps65910->read(tps65910, TPS65910_INT_MSK2, 1, &reg);
> +	tps65910_reg_read(tps65910, TPS65910_INT_MSK2, &reg);
>  	irq_mask |= reg << 8;
>  	switch (tps65910_chip_id(tps65910)) {
>  	case TPS65911:
> -		tps65910->read(tps65910, TPS65910_INT_MSK3, 1, &reg);
> +		tps65910_reg_read(tps65910, TPS65910_INT_MSK3, &reg);
>  		irq_mask |= reg << 16;
>  	}
>  
> @@ -82,13 +82,13 @@ static irqreturn_t tps65910_irq(int irq, void *irq_data)
>  	/* Write the STS register back to clear IRQs we handled */
>  	reg = irq_sts & 0xFF;
>  	irq_sts >>= 8;
> -	tps65910->write(tps65910, TPS65910_INT_STS, 1, &reg);
> +	tps65910_reg_write(tps65910, TPS65910_INT_STS, reg);
>  	reg = irq_sts & 0xFF;
> -	tps65910->write(tps65910, TPS65910_INT_STS2, 1, &reg);
> +	tps65910_reg_write(tps65910, TPS65910_INT_STS2, reg);
>  	switch (tps65910_chip_id(tps65910)) {
>  	case TPS65911:
>  		reg = irq_sts >> 8;
> -		tps65910->write(tps65910, TPS65910_INT_STS3, 1, &reg);
> +		tps65910_reg_write(tps65910, TPS65910_INT_STS3, reg);
>  	}
>  
>  	return IRQ_HANDLED;
> @@ -105,27 +105,27 @@ static void tps65910_irq_sync_unlock(struct irq_data *data)
>  {
>  	struct tps65910 *tps65910 = irq_data_get_irq_chip_data(data);
>  	u32 reg_mask;
> -	u8 reg;
> +	unsigned int reg;
>  
> -	tps65910->read(tps65910, TPS65910_INT_MSK, 1, &reg);
> +	tps65910_reg_read(tps65910, TPS65910_INT_MSK, &reg);
>  	reg_mask = reg;
> -	tps65910->read(tps65910, TPS65910_INT_MSK2, 1, &reg);
> +	tps65910_reg_read(tps65910, TPS65910_INT_MSK2, &reg);
>  	reg_mask |= reg << 8;
>  	switch (tps65910_chip_id(tps65910)) {
>  	case TPS65911:
> -		tps65910->read(tps65910, TPS65910_INT_MSK3, 1, &reg);
> +		tps65910_reg_read(tps65910, TPS65910_INT_MSK3, &reg);
>  		reg_mask |= reg << 16;
>  	}
>  
>  	if (tps65910->irq_mask != reg_mask) {
>  		reg = tps65910->irq_mask & 0xFF;
> -		tps65910->write(tps65910, TPS65910_INT_MSK, 1, &reg);
> +		tps65910_reg_write(tps65910, TPS65910_INT_MSK, reg);
>  		reg = tps65910->irq_mask >> 8 & 0xFF;
> -		tps65910->write(tps65910, TPS65910_INT_MSK2, 1, &reg);
> +		tps65910_reg_write(tps65910, TPS65910_INT_MSK2, reg);
>  		switch (tps65910_chip_id(tps65910)) {
>  		case TPS65911:
>  			reg = tps65910->irq_mask >> 16;
> -			tps65910->write(tps65910, TPS65910_INT_MSK3, 1, &reg);
> +			tps65910_reg_write(tps65910, TPS65910_INT_MSK3, reg);
>  		}
>  	}
>  	mutex_unlock(&tps65910->irq_lock);
> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> index bf2b25e..70a8079 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -37,30 +37,6 @@ static struct mfd_cell tps65910s[] = {
>  };
>  
>  
> -static int tps65910_i2c_read(struct tps65910 *tps65910, u8 reg,
> -				  int bytes, void *dest)
> -{
> -	return regmap_bulk_read(tps65910->regmap, reg, dest, bytes);
> -}
> -
> -static int tps65910_i2c_write(struct tps65910 *tps65910, u8 reg,
> -				  int bytes, void *src)
> -{
> -	return regmap_bulk_write(tps65910->regmap, reg, src, bytes);
> -}
> -
> -int tps65910_set_bits(struct tps65910 *tps65910, u8 reg, u8 mask)
> -{
> -	return regmap_update_bits(tps65910->regmap, reg, mask, mask);
> -}
> -EXPORT_SYMBOL_GPL(tps65910_set_bits);
> -
> -int tps65910_clear_bits(struct tps65910 *tps65910, u8 reg, u8 mask)
> -{
> -	return regmap_update_bits(tps65910->regmap, reg, mask, 0);
> -}
> -EXPORT_SYMBOL_GPL(tps65910_clear_bits);
> -
>  static bool is_volatile_reg(struct device *dev, unsigned int reg)
>  {
>  	struct tps65910 *tps65910 = dev_get_drvdata(dev);
> @@ -116,8 +92,6 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
>  	tps65910->dev = &i2c->dev;
>  	tps65910->i2c_client = i2c;
>  	tps65910->id = id->driver_data;
> -	tps65910->read = tps65910_i2c_read;
> -	tps65910->write = tps65910_i2c_write;
>  	mutex_init(&tps65910->io_mutex);
>  
>  	tps65910->regmap = regmap_init_i2c(i2c, &tps65910_regmap_config);
> diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
> index 747bf57..855bbec 100644
> --- a/drivers/regulator/tps65910-regulator.c
> +++ b/drivers/regulator/tps65910-regulator.c
> @@ -331,21 +331,16 @@ struct tps65910_reg {
>  
>  static inline int tps65910_read(struct tps65910_reg *pmic, u8 reg)
>  {
> -	u8 val;
> +	unsigned int val;
>  	int err;
>  
> -	err = pmic->mfd->read(pmic->mfd, reg, 1, &val);
> +	err = tps65910_reg_read(pmic->mfd, reg, &val);
>  	if (err)
>  		return err;
>  
>  	return val;
>  }
>  
> -static inline int tps65910_write(struct tps65910_reg *pmic, u8 reg, u8 val)
> -{
> -	return pmic->mfd->write(pmic->mfd, reg, 1, &val);
> -}
> -
>  static int tps65910_modify_bits(struct tps65910_reg *pmic, u8 reg,
>  					u8 set_mask, u8 clear_mask)
>  {
> @@ -362,7 +357,7 @@ static int tps65910_modify_bits(struct tps65910_reg *pmic, u8 reg,
>  
>  	data &= ~clear_mask;
>  	data |= set_mask;
> -	err = tps65910_write(pmic, reg, data);
> +	err = tps65910_reg_write(pmic->mfd, reg, data);
>  	if (err)
>  		dev_err(pmic->mfd->dev, "Write for reg 0x%x failed\n", reg);
>  
> @@ -371,7 +366,7 @@ out:
>  	return err;
>  }
>  
> -static int tps65910_reg_read(struct tps65910_reg *pmic, u8 reg)
> +static int tps65910_reg_read_locked(struct tps65910_reg *pmic, u8 reg)
>  {
>  	int data;
>  
> @@ -385,13 +380,13 @@ static int tps65910_reg_read(struct tps65910_reg *pmic, u8 reg)
>  	return data;
>  }
>  
> -static int tps65910_reg_write(struct tps65910_reg *pmic, u8 reg, u8 val)
> +static int tps65910_reg_write_locked(struct tps65910_reg *pmic, u8 reg, u8 val)
>  {
>  	int err;
>  
>  	mutex_lock(&pmic->mutex);
>  
> -	err = tps65910_write(pmic, reg, val);
> +	err = tps65910_reg_write(pmic->mfd, reg, val);
>  	if (err < 0)
>  		dev_err(pmic->mfd->dev, "Write for reg 0x%x failed\n", reg);
>  
> @@ -476,7 +471,7 @@ static int tps65910_is_enabled(struct regulator_dev *dev)
>  	if (reg < 0)
>  		return reg;
>  
> -	value = tps65910_reg_read(pmic, reg);
> +	value = tps65910_reg_read_locked(pmic, reg);
>  	if (value < 0)
>  		return value;
>  
> @@ -493,7 +488,7 @@ static int tps65910_enable(struct regulator_dev *dev)
>  	if (reg < 0)
>  		return reg;
>  
> -	return tps65910_set_bits(mfd, reg, TPS65910_SUPPLY_STATE_ENABLED);
> +	return tps65910_reg_set_bits(mfd, reg, TPS65910_SUPPLY_STATE_ENABLED);
>  }
>  
>  static int tps65910_disable(struct regulator_dev *dev)
> @@ -506,7 +501,7 @@ static int tps65910_disable(struct regulator_dev *dev)
>  	if (reg < 0)
>  		return reg;
>  
> -	return tps65910_clear_bits(mfd, reg, TPS65910_SUPPLY_STATE_ENABLED);
> +	return tps65910_reg_clear_bits(mfd, reg, TPS65910_SUPPLY_STATE_ENABLED);
>  }
>  
>  static int tps65910_enable_time(struct regulator_dev *dev)
> @@ -532,9 +527,9 @@ static int tps65910_set_mode(struct regulator_dev *dev, unsigned int mode)
>  							LDO_ST_MODE_BIT);
>  	case REGULATOR_MODE_IDLE:
>  		value = LDO_ST_ON_BIT | LDO_ST_MODE_BIT;
> -		return tps65910_set_bits(mfd, reg, value);
> +		return tps65910_reg_set_bits(mfd, reg, value);
>  	case REGULATOR_MODE_STANDBY:
> -		return tps65910_clear_bits(mfd, reg, LDO_ST_ON_BIT);
> +		return tps65910_reg_clear_bits(mfd, reg, LDO_ST_ON_BIT);
>  	}
>  
>  	return -EINVAL;
> @@ -549,7 +544,7 @@ static unsigned int tps65910_get_mode(struct regulator_dev *dev)
>  	if (reg < 0)
>  		return reg;
>  
> -	value = tps65910_reg_read(pmic, reg);
> +	value = tps65910_reg_read_locked(pmic, reg);
>  	if (value < 0)
>  		return value;
>  
> @@ -569,28 +564,28 @@ static int tps65910_get_voltage_dcdc_sel(struct regulator_dev *dev)
>  
>  	switch (id) {
>  	case TPS65910_REG_VDD1:
> -		opvsel = tps65910_reg_read(pmic, TPS65910_VDD1_OP);
> -		mult = tps65910_reg_read(pmic, TPS65910_VDD1);
> +		opvsel = tps65910_reg_read_locked(pmic, TPS65910_VDD1_OP);
> +		mult = tps65910_reg_read_locked(pmic, TPS65910_VDD1);
>  		mult = (mult & VDD1_VGAIN_SEL_MASK) >> VDD1_VGAIN_SEL_SHIFT;
> -		srvsel = tps65910_reg_read(pmic, TPS65910_VDD1_SR);
> +		srvsel = tps65910_reg_read_locked(pmic, TPS65910_VDD1_SR);
>  		sr = opvsel & VDD1_OP_CMD_MASK;
>  		opvsel &= VDD1_OP_SEL_MASK;
>  		srvsel &= VDD1_SR_SEL_MASK;
>  		vselmax = 75;
>  		break;
>  	case TPS65910_REG_VDD2:
> -		opvsel = tps65910_reg_read(pmic, TPS65910_VDD2_OP);
> -		mult = tps65910_reg_read(pmic, TPS65910_VDD2);
> +		opvsel = tps65910_reg_read_locked(pmic, TPS65910_VDD2_OP);
> +		mult = tps65910_reg_read_locked(pmic, TPS65910_VDD2);
>  		mult = (mult & VDD2_VGAIN_SEL_MASK) >> VDD2_VGAIN_SEL_SHIFT;
> -		srvsel = tps65910_reg_read(pmic, TPS65910_VDD2_SR);
> +		srvsel = tps65910_reg_read_locked(pmic, TPS65910_VDD2_SR);
>  		sr = opvsel & VDD2_OP_CMD_MASK;
>  		opvsel &= VDD2_OP_SEL_MASK;
>  		srvsel &= VDD2_SR_SEL_MASK;
>  		vselmax = 75;
>  		break;
>  	case TPS65911_REG_VDDCTRL:
> -		opvsel = tps65910_reg_read(pmic, TPS65911_VDDCTRL_OP);
> -		srvsel = tps65910_reg_read(pmic, TPS65911_VDDCTRL_SR);
> +		opvsel = tps65910_reg_read_locked(pmic, TPS65911_VDDCTRL_OP);
> +		srvsel = tps65910_reg_read_locked(pmic, TPS65911_VDDCTRL_SR);
>  		sr = opvsel & VDDCTRL_OP_CMD_MASK;
>  		opvsel &= VDDCTRL_OP_SEL_MASK;
>  		srvsel &= VDDCTRL_SR_SEL_MASK;
> @@ -630,7 +625,7 @@ static int tps65910_get_voltage(struct regulator_dev *dev)
>  	if (reg < 0)
>  		return reg;
>  
> -	value = tps65910_reg_read(pmic, reg);
> +	value = tps65910_reg_read_locked(pmic, reg);
>  	if (value < 0)
>  		return value;
>  
> @@ -669,7 +664,7 @@ static int tps65911_get_voltage(struct regulator_dev *dev)
>  
>  	reg = pmic->get_ctrl_reg(id);
>  
> -	value = tps65910_reg_read(pmic, reg);
> +	value = tps65910_reg_read_locked(pmic, reg);
>  
>  	switch (id) {
>  	case TPS65911_REG_LDO1:
> @@ -728,7 +723,7 @@ static int tps65910_set_voltage_dcdc_sel(struct regulator_dev *dev,
>  		tps65910_modify_bits(pmic, TPS65910_VDD1,
>  				(dcdc_mult << VDD1_VGAIN_SEL_SHIFT),
>  						VDD1_VGAIN_SEL_MASK);
> -		tps65910_reg_write(pmic, TPS65910_VDD1_OP, vsel);
> +		tps65910_reg_write_locked(pmic, TPS65910_VDD1_OP, vsel);
>  		break;
>  	case TPS65910_REG_VDD2:
>  		dcdc_mult = (selector / VDD1_2_NUM_VOLT_FINE) + 1;
> @@ -739,11 +734,11 @@ static int tps65910_set_voltage_dcdc_sel(struct regulator_dev *dev,
>  		tps65910_modify_bits(pmic, TPS65910_VDD2,
>  				(dcdc_mult << VDD2_VGAIN_SEL_SHIFT),
>  						VDD1_VGAIN_SEL_MASK);
> -		tps65910_reg_write(pmic, TPS65910_VDD2_OP, vsel);
> +		tps65910_reg_write_locked(pmic, TPS65910_VDD2_OP, vsel);
>  		break;
>  	case TPS65911_REG_VDDCTRL:
>  		vsel = selector + 3;
> -		tps65910_reg_write(pmic, TPS65911_VDDCTRL_OP, vsel);
> +		tps65910_reg_write_locked(pmic, TPS65911_VDDCTRL_OP, vsel);
>  	}
>  
>  	return 0;
> @@ -994,10 +989,10 @@ static int tps65910_set_ext_sleep_config(struct tps65910_reg *pmic,
>  
>  	/* External EN1 control */
>  	if (ext_sleep_config & TPS65910_SLEEP_CONTROL_EXT_INPUT_EN1)
> -		ret = tps65910_set_bits(mfd,
> +		ret = tps65910_reg_set_bits(mfd,
>  				TPS65910_EN1_LDO_ASS + regoffs, bit_pos);
>  	else
> -		ret = tps65910_clear_bits(mfd,
> +		ret = tps65910_reg_clear_bits(mfd,
>  				TPS65910_EN1_LDO_ASS + regoffs, bit_pos);
>  	if (ret < 0) {
>  		dev_err(mfd->dev,
> @@ -1007,10 +1002,10 @@ static int tps65910_set_ext_sleep_config(struct tps65910_reg *pmic,
>  
>  	/* External EN2 control */
>  	if (ext_sleep_config & TPS65910_SLEEP_CONTROL_EXT_INPUT_EN2)
> -		ret = tps65910_set_bits(mfd,
> +		ret = tps65910_reg_set_bits(mfd,
>  				TPS65910_EN2_LDO_ASS + regoffs, bit_pos);
>  	else
> -		ret = tps65910_clear_bits(mfd,
> +		ret = tps65910_reg_clear_bits(mfd,
>  				TPS65910_EN2_LDO_ASS + regoffs, bit_pos);
>  	if (ret < 0) {
>  		dev_err(mfd->dev,
> @@ -1022,10 +1017,10 @@ static int tps65910_set_ext_sleep_config(struct tps65910_reg *pmic,
>  	if ((tps65910_chip_id(mfd) == TPS65910) &&
>  			(id >= TPS65910_REG_VDIG1)) {
>  		if (ext_sleep_config & TPS65910_SLEEP_CONTROL_EXT_INPUT_EN3)
> -			ret = tps65910_set_bits(mfd,
> +			ret = tps65910_reg_set_bits(mfd,
>  				TPS65910_EN3_LDO_ASS + regoffs, bit_pos);
>  		else
> -			ret = tps65910_clear_bits(mfd,
> +			ret = tps65910_reg_clear_bits(mfd,
>  				TPS65910_EN3_LDO_ASS + regoffs, bit_pos);
>  		if (ret < 0) {
>  			dev_err(mfd->dev,
> @@ -1037,10 +1032,10 @@ static int tps65910_set_ext_sleep_config(struct tps65910_reg *pmic,
>  	/* Return if no external control is selected */
>  	if (!(ext_sleep_config & EXT_SLEEP_CONTROL)) {
>  		/* Clear all sleep controls */
> -		ret = tps65910_clear_bits(mfd,
> +		ret = tps65910_reg_clear_bits(mfd,
>  			TPS65910_SLEEP_KEEP_LDO_ON + regoffs, bit_pos);
>  		if (!ret)
> -			ret = tps65910_clear_bits(mfd,
> +			ret = tps65910_reg_clear_bits(mfd,
>  				TPS65910_SLEEP_SET_LDO_OFF + regoffs, bit_pos);
>  		if (ret < 0)
>  			dev_err(mfd->dev,
> @@ -1059,32 +1054,33 @@ static int tps65910_set_ext_sleep_config(struct tps65910_reg *pmic,
>  				(tps65910_chip_id(mfd) == TPS65911))) {
>  		int op_reg_add = pmic->get_ctrl_reg(id) + 1;
>  		int sr_reg_add = pmic->get_ctrl_reg(id) + 2;
> -		int opvsel = tps65910_reg_read(pmic, op_reg_add);
> -		int srvsel = tps65910_reg_read(pmic, sr_reg_add);
> +		int opvsel = tps65910_reg_read_locked(pmic, op_reg_add);
> +		int srvsel = tps65910_reg_read_locked(pmic, sr_reg_add);
>  		if (opvsel & VDD1_OP_CMD_MASK) {
>  			u8 reg_val = srvsel & VDD1_OP_SEL_MASK;
> -			ret = tps65910_reg_write(pmic, op_reg_add, reg_val);
> +			ret = tps65910_reg_write_locked(pmic, op_reg_add,
> +							reg_val);
>  			if (ret < 0) {
>  				dev_err(mfd->dev,
>  					"Error in configuring op register\n");
>  				return ret;
>  			}
>  		}
> -		ret = tps65910_reg_write(pmic, sr_reg_add, 0);
> +		ret = tps65910_reg_write_locked(pmic, sr_reg_add, 0);
>  		if (ret < 0) {
>  			dev_err(mfd->dev, "Error in settting sr register\n");
>  			return ret;
>  		}
>  	}
>  
> -	ret = tps65910_clear_bits(mfd,
> +	ret = tps65910_reg_clear_bits(mfd,
>  			TPS65910_SLEEP_KEEP_LDO_ON + regoffs, bit_pos);
>  	if (!ret) {
>  		if (ext_sleep_config & TPS65911_SLEEP_CONTROL_EXT_INPUT_SLEEP)
> -			ret = tps65910_set_bits(mfd,
> +			ret = tps65910_reg_set_bits(mfd,
>  				TPS65910_SLEEP_SET_LDO_OFF + regoffs, bit_pos);
>  		else
> -			ret = tps65910_clear_bits(mfd,
> +			ret = tps65910_reg_clear_bits(mfd,
>  				TPS65910_SLEEP_SET_LDO_OFF + regoffs, bit_pos);
>  	}
>  	if (ret < 0)
> @@ -1118,7 +1114,7 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
>  	platform_set_drvdata(pdev, pmic);
>  
>  	/* Give control of all register to control port */
> -	tps65910_set_bits(pmic->mfd, TPS65910_DEVCTRL,
> +	tps65910_reg_set_bits(pmic->mfd, TPS65910_DEVCTRL,
>  				DEVCTRL_SR_CTL_I2C_SEL_MASK);
>  
>  	switch(tps65910_chip_id(tps65910)) {
> diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
> index 1c6c286..e004de1 100644
> --- a/include/linux/mfd/tps65910.h
> +++ b/include/linux/mfd/tps65910.h
> @@ -18,6 +18,7 @@
>  #define __LINUX_MFD_TPS65910_H
>  
>  #include <linux/gpio.h>
> +#include <linux/regmap.h>
>  
>  /* TPS chip id list */
>  #define TPS65910			0
> @@ -809,8 +810,6 @@ struct tps65910 {
>  	struct regmap *regmap;
>  	struct mutex io_mutex;
>  	unsigned int id;
> -	int (*read)(struct tps65910 *tps65910, u8 reg, int size, void *dest);
> -	int (*write)(struct tps65910 *tps65910, u8 reg, int size, void *src);
>  
>  	/* Client devices */
>  	struct tps65910_pmic *pmic;
> @@ -833,8 +832,6 @@ struct tps65910_platform_data {
>  	int irq_base;
>  };
>  
> -int tps65910_set_bits(struct tps65910 *tps65910, u8 reg, u8 mask);
> -int tps65910_clear_bits(struct tps65910 *tps65910, u8 reg, u8 mask);
>  void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base);
>  int tps65910_irq_init(struct tps65910 *tps65910, int irq,
>  		struct tps65910_platform_data *pdata);
> @@ -845,4 +842,28 @@ static inline int tps65910_chip_id(struct tps65910 *tps65910)
>  	return tps65910->id;
>  }
>  
> +static inline int tps65910_reg_read(struct tps65910 *tps65910, u8 reg,
> +		unsigned int *val)
> +{
> +	return regmap_read(tps65910->regmap, reg, val);
> +}
> +
> +static inline int tps65910_reg_write(struct tps65910 *tps65910, u8 reg,
> +		unsigned int val)
> +{
> +	return regmap_write(tps65910->regmap, reg, val);
> +}
> +
> +static inline int tps65910_reg_set_bits(struct tps65910 *tps65910, u8 reg,
> +		u8 mask)
> +{
> +	return regmap_update_bits(tps65910->regmap, reg, mask, mask);
> +}
> +
> +static inline int tps65910_reg_clear_bits(struct tps65910 *tps65910, u8 reg,
> +		u8 mask)
> +{
> +	return regmap_update_bits(tps65910->regmap, reg, mask, 0);
> +}
> +
>  #endif /*  __LINUX_MFD_TPS65910_H */
> -- 
> 1.7.0.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
