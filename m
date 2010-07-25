Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab0GYWgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 18:36:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:24938 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab0GYWgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 18:36:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,259,1278313200"; 
   d="scan'208";a="538640791"
Date: Mon, 26 Jul 2010 00:35:59 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: l.fu@pengutronix.de, rabin.vincent@stericsson.com,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] mfd-stmpe: add auto sleep feature
Message-ID: <20100725223558.GE2613@sortiz-mobl>
References: <1279692667-13993-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279692667-13993-1-git-send-email-sundar.iyer@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sundar,

On Wed, Jul 21, 2010 at 11:41:07AM +0530, Sundar Iyer wrote:
> From: Sundar R Iyer <sundar.iyer@stericsson.com>
> 
> Some STMPE devices support entering sleep mode automatically on a
> specified timeout of inactivity on the I2C bus with the host system.
Patch applied, thanks.

Cheers,
Samuel.


> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> Acked-by: Rabin Vincent <rabin.vincent@stericsson.com>
> Signed-off-by: Sundar R Iyer <sundar.iyer@stericsson.com>
> ---
>  drivers/mfd/stmpe.c       |   70 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/stmpe.h       |    7 ++++
>  include/linux/mfd/stmpe.h |    4 ++
>  3 files changed, 81 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
> index a7f3099..0754c5e 100644
> --- a/drivers/mfd/stmpe.c
> +++ b/drivers/mfd/stmpe.c
> @@ -455,6 +455,67 @@ static struct stmpe_variant_block stmpe1601_blocks[] = {
>  	},
>  };
>  
> +/* supported autosleep timeout delay (in msecs) */
> +static const int stmpe_autosleep_delay[] = {
> +	4, 16, 32, 64, 128, 256, 512, 1024,
> +};
> +
> +static int stmpe_round_timeout(int timeout)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(stmpe_autosleep_delay); i++) {
> +		if (stmpe_autosleep_delay[i] >= timeout)
> +			return i;
> +	}
> +
> +	/*
> +	 * requests for delays longer than supported should not return the
> +	 * longest supported delay
> +	 */
> +	return -EINVAL;
> +}
> +
> +static int stmpe_autosleep(struct stmpe *stmpe, int autosleep_timeout)
> +{
> +	int ret;
> +
> +	if (!stmpe->variant->enable_autosleep)
> +		return -ENOSYS;
> +
> +	mutex_lock(&stmpe->lock);
> +	ret = stmpe->variant->enable_autosleep(stmpe, autosleep_timeout);
> +	mutex_unlock(&stmpe->lock);
> +
> +	return ret;
> +}
> +
> +/*
> + * Both stmpe 1601/2403 support same layout for autosleep
> + */
> +static int stmpe1601_autosleep(struct stmpe *stmpe,
> +		int autosleep_timeout)
> +{
> +	int ret, timeout;
> +
> +	/* choose the best available timeout */
> +	timeout = stmpe_round_timeout(autosleep_timeout);
> +	if (timeout < 0) {
> +		dev_err(stmpe->dev, "invalid timeout\n");
> +		return timeout;
> +	}
> +
> +	ret = __stmpe_set_bits(stmpe, STMPE1601_REG_SYS_CTRL2,
> +			STMPE1601_AUTOSLEEP_TIMEOUT_MASK,
> +			timeout);
> +	if (ret < 0)
> +		return ret;
> +
> +	return __stmpe_set_bits(stmpe, STMPE1601_REG_SYS_CTRL2,
> +			STPME1601_AUTOSLEEP_ENABLE,
> +			STPME1601_AUTOSLEEP_ENABLE);
> +}
> +
>  static int stmpe1601_enable(struct stmpe *stmpe, unsigned int blocks,
>  			    bool enable)
>  {
> @@ -497,6 +558,7 @@ static struct stmpe_variant_info stmpe1601 = {
>  	.num_irqs	= STMPE1601_NR_INTERNAL_IRQS,
>  	.enable		= stmpe1601_enable,
>  	.get_altfunc	= stmpe1601_get_altfunc,
> +	.enable_autosleep	= stmpe1601_autosleep,
>  };
>  
>  /*
> @@ -589,6 +651,7 @@ static struct stmpe_variant_info stmpe2403 = {
>  	.num_irqs	= STMPE24XX_NR_INTERNAL_IRQS,
>  	.enable		= stmpe24xx_enable,
>  	.get_altfunc	= stmpe24xx_get_altfunc,
> +	.enable_autosleep	= stmpe1601_autosleep, /* same as stmpe1601 */
>  };
>  
>  static struct stmpe_variant_info *stmpe_variant_info[] = {
> @@ -731,6 +794,7 @@ static void stmpe_irq_remove(struct stmpe *stmpe)
>  static int __devinit stmpe_chip_init(struct stmpe *stmpe)
>  {
>  	unsigned int irq_trigger = stmpe->pdata->irq_trigger;
> +	int autosleep_timeout = stmpe->pdata->autosleep_timeout;
>  	struct stmpe_variant_info *variant = stmpe->variant;
>  	u8 icr = STMPE_ICR_LSB_GIM;
>  	unsigned int id;
> @@ -766,6 +830,12 @@ static int __devinit stmpe_chip_init(struct stmpe *stmpe)
>  	if (stmpe->pdata->irq_invert_polarity)
>  		icr ^= STMPE_ICR_LSB_HIGH;
>  
> +	if (stmpe->pdata->autosleep) {
> +		ret = stmpe_autosleep(stmpe, autosleep_timeout);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	return stmpe_reg_write(stmpe, stmpe->regs[STMPE_IDX_ICR_LSB], icr);
>  }
>  
> diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
> index 991f0ec..0dbdc4e 100644
> --- a/drivers/mfd/stmpe.h
> +++ b/drivers/mfd/stmpe.h
> @@ -49,6 +49,7 @@ struct stmpe_variant_block {
>   *		Called with the I/O lock held.
>   * @get_altfunc: callback to get the alternate function number for the
>   *		 specific block
> + * @enable_autosleep: callback to configure autosleep with specified timeout
>   */
>  struct stmpe_variant_info {
>  	const char *name;
> @@ -62,6 +63,7 @@ struct stmpe_variant_info {
>  	int num_irqs;
>  	int (*enable)(struct stmpe *stmpe, unsigned int blocks, bool enable);
>  	int (*get_altfunc)(struct stmpe *stmpe, enum stmpe_block block);
> +	int (*enable_autosleep)(struct stmpe *stmpe, int autosleep_timeout);
>  };
>  
>  #define STMPE_ICR_LSB_HIGH	(1 << 2)
> @@ -118,6 +120,7 @@ struct stmpe_variant_info {
>  #define STMPE1601_NR_INTERNAL_IRQS	9
>  
>  #define STMPE1601_REG_SYS_CTRL			0x02
> +#define STMPE1601_REG_SYS_CTRL2			0x03
>  #define STMPE1601_REG_ICR_LSB			0x11
>  #define STMPE1601_REG_IER_LSB			0x13
>  #define STMPE1601_REG_ISR_MSB			0x14
> @@ -137,6 +140,10 @@ struct stmpe_variant_info {
>  #define STMPE1601_SYS_CTRL_ENABLE_KPC		(1 << 1)
>  #define STMPE1601_SYSCON_ENABLE_SPWM		(1 << 0)
>  
> +/* The 1601/2403 share the same masks */
> +#define STMPE1601_AUTOSLEEP_TIMEOUT_MASK	(0x7)
> +#define STPME1601_AUTOSLEEP_ENABLE		(1 << 3)
> +
>  /*
>   * STMPE24xx
>   */
> diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
> index 90faa98..39ca758 100644
> --- a/include/linux/mfd/stmpe.h
> +++ b/include/linux/mfd/stmpe.h
> @@ -170,6 +170,8 @@ struct stmpe_ts_platform_data {
>   * @blocks: bitmask of blocks to enable (use STMPE_BLOCK_*)
>   * @irq_trigger: IRQ trigger to use for the interrupt to the host
>   * @irq_invert_polarity: IRQ line is connected with reversed polarity
> + * @autosleep: bool to enable/disable stmpe autosleep
> + * @autosleep_timeout: inactivity timeout in milliseconds for autosleep
>   * @irq_base: base IRQ number.  %STMPE_NR_IRQS irqs will be used, or
>   *	      %STMPE_NR_INTERNAL_IRQS if the GPIO driver is not used.
>   * @gpio: GPIO-specific platform data
> @@ -182,6 +184,8 @@ struct stmpe_platform_data {
>  	int irq_base;
>  	unsigned int irq_trigger;
>  	bool irq_invert_polarity;
> +	bool autosleep;
> +	int autosleep_timeout;
>  
>  	struct stmpe_gpio_platform_data *gpio;
>  	struct stmpe_keypad_platform_data *keypad;
> -- 
> 1.7.0
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
