Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965349Ab2EQXuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 19:50:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45042 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2EQXuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 19:50:15 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] Add support for TCA6424A
To: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        linus.walleij@stericsson.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <0Mcu17-1Sjy5i0WRt-00I8s9@mrelayeu.kundenserver.de>
References: <0Mcu17-1Sjy5i0WRt-00I8s9@mrelayeu.kundenserver.de>
Date: Thu, 17 May 2012 17:50:13 -0600
Message-Id: <20120517235013.13C613E062C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012 09:46:17 +0200, Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com> wrote:
> This patch extends the PCA953x driver to support TI's TCA6424A 24 bit I2C I/O expander. The patch is based on code by Michele 
> Bevilacqua.
> 
> Changes in v2:
> - Compare ngpio against 24 in both places, not >16
> - Larger datatype now u32 instead of uint.
>   Bit fields not used for struct members since their address is taken.
> - Be precise: TCA6424A (untested for older TCA6424)
> 
> Signed-off-by: Andreas Schallenberg<Andreas.Schallenberg@3alitytechnica.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Ah, much better (after my rant 5 minutes ago on an earlier version of
the patch; I hadn't seen this one yet).  Nit: in patch descriptions I
like to see lines shorter than 70-75 columns.  Otherwise I need to
reformat when I apply.

Also, my comment about 2 transfers for a single read or write still
stands.  I'll apply this one, but if the comment is valid then I want
to see a fixup patch from you.

g.


> 
> ---
>  drivers/gpio/gpio-pca953x.c |   43 ++++++++++++++++++++++++++++++-------------
>  1 files changed, 30 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
> index d3f3e8f..bef3cb1 100644
> --- a/drivers/gpio/gpio-pca953x.c
> +++ b/drivers/gpio/gpio-pca953x.c
> @@ -28,6 +28,8 @@
>  #define PCA953X_INVERT		2
>  #define PCA953X_DIRECTION	3
>  
> +#define REG_ADDR_AI		0x80
> +
>  #define PCA957X_IN		0
>  #define PCA957X_INVRT		1
>  #define PCA957X_BKEN		2
> @@ -63,15 +65,15 @@ static const struct i2c_device_id pca953x_id[] = {
>  	{ "pca6107", 8  | PCA953X_TYPE | PCA_INT, },
>  	{ "tca6408", 8  | PCA953X_TYPE | PCA_INT, },
>  	{ "tca6416", 16 | PCA953X_TYPE | PCA_INT, },
> -	/* NYET:  { "tca6424", 24, }, */
> +	{ "tca6424", 24 | PCA953X_TYPE | PCA_INT, },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(i2c, pca953x_id);
>  
>  struct pca953x_chip {
>  	unsigned gpio_start;
> -	uint16_t reg_output;
> -	uint16_t reg_direction;
> +	u32 reg_output;
> +	u32 reg_direction;
>  	struct mutex i2c_lock;
>  
>  #ifdef CONFIG_GPIO_PCA953X_IRQ
> @@ -89,12 +91,20 @@ struct pca953x_chip {
>  	int	chip_type;
>  };
>  
> -static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint16_t val)
> +static int pca953x_write_reg(struct pca953x_chip *chip, int reg, u32 val)
>  {
>  	int ret = 0;
>  
>  	if (chip->gpio_chip.ngpio <= 8)
>  		ret = i2c_smbus_write_byte_data(chip->client, reg, val);
> +	else if (chip->gpio_chip.ngpio == 24) {
> +		ret = i2c_smbus_write_word_data(chip->client,
> +						(reg << 2) | REG_ADDR_AI,
> +						val & 0xffff);
> +		ret = i2c_smbus_write_byte_data(chip->client,
> +						(reg << 2) + 2,
> +						(val & 0xff0000) >> 16);
> +	}
>  	else {
>  		switch (chip->chip_type) {
>  		case PCA953X_TYPE:
> @@ -121,12 +131,17 @@ static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint16_t val)
>  	return 0;
>  }
>  
> -static int pca953x_read_reg(struct pca953x_chip *chip, int reg, uint16_t *val)
> +static int pca953x_read_reg(struct pca953x_chip *chip, int reg, u32 *val)
>  {
>  	int ret;
>  
>  	if (chip->gpio_chip.ngpio <= 8)
>  		ret = i2c_smbus_read_byte_data(chip->client, reg);
> +	else if (chip->gpio_chip.ngpio == 24) {
> +		ret =  i2c_smbus_read_word_data(chip->client, reg << 2);
> +		ret |= (i2c_smbus_read_byte_data(chip->client,
> +						 (reg << 2) + 2)<<16);
> +	}
>  	else
>  		ret = i2c_smbus_read_word_data(chip->client, reg << 1);
>  
> @@ -135,14 +150,14 @@ static int pca953x_read_reg(struct pca953x_chip *chip, int reg, uint16_t *val)
>  		return ret;
>  	}
>  
> -	*val = (uint16_t)ret;
> +	*val = (u32)ret;
>  	return 0;
>  }
>  
>  static int pca953x_gpio_direction_input(struct gpio_chip *gc, unsigned off)
>  {
>  	struct pca953x_chip *chip;
> -	uint16_t reg_val;
> +	uint reg_val;
>  	int ret, offset = 0;
>  
>  	chip = container_of(gc, struct pca953x_chip, gpio_chip);
> @@ -173,7 +188,7 @@ static int pca953x_gpio_direction_output(struct gpio_chip *gc,
>  		unsigned off, int val)
>  {
>  	struct pca953x_chip *chip;
> -	uint16_t reg_val;
> +	uint reg_val;
>  	int ret, offset = 0;
>  
>  	chip = container_of(gc, struct pca953x_chip, gpio_chip);
> @@ -223,7 +238,7 @@ exit:
>  static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
>  {
>  	struct pca953x_chip *chip;
> -	uint16_t reg_val;
> +	u32 reg_val;
>  	int ret, offset = 0;
>  
>  	chip = container_of(gc, struct pca953x_chip, gpio_chip);
> @@ -253,7 +268,7 @@ static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
>  static void pca953x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
>  {
>  	struct pca953x_chip *chip;
> -	uint16_t reg_val;
> +	u32 reg_val;
>  	int ret, offset = 0;
>  
>  	chip = container_of(gc, struct pca953x_chip, gpio_chip);
> @@ -386,7 +401,7 @@ static struct irq_chip pca953x_irq_chip = {
>  
>  static uint16_t pca953x_irq_pending(struct pca953x_chip *chip)
>  {
> -	uint16_t cur_stat;
> +	u32 cur_stat;
>  	uint16_t old_stat;
>  	uint16_t pending;
>  	uint16_t trigger;
> @@ -449,6 +464,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
>  {
>  	struct i2c_client *client = chip->client;
>  	int ret, offset = 0;
> +	u32 temporary;
>  
>  	if (irq_base != -1
>  			&& (id->driver_data & PCA_INT)) {
> @@ -462,7 +478,8 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
>  			offset = PCA957X_IN;
>  			break;
>  		}
> -		ret = pca953x_read_reg(chip, offset, &chip->irq_stat);
> +		ret = pca953x_read_reg(chip, offset, &temporary);
> +		chip->irq_stat = temporary;
>  		if (ret)
>  			goto out_failed;
>  
> @@ -603,7 +620,7 @@ out:
>  static int __devinit device_pca957x_init(struct pca953x_chip *chip, int invert)
>  {
>  	int ret;
> -	uint16_t val = 0;
> +	u32 val = 0;
>  
>  	/* Let every port in proper state, that could save power */
>  	pca953x_write_reg(chip, PCA957X_PUPD, 0x0);
> -- 
> 1.7.3.4 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
