Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795Ab2CaAfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 20:35:08 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:43076 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759249Ab2CaAeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 20:34:25 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 1/2] mfd: add irq domain support for max8997 interrupts
To: Thomas Abraham <thomas.abraham@linaro.org>, linux-kernel@vger.kernel.org
Cc: k.lewandowsk@samsung.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com, kgene.kim@samsung.com,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org
In-Reply-To: <1332582590-16382-2-git-send-email-thomas.abraham@linaro.org>
References: <1332582590-16382-1-git-send-email-thomas.abraham@linaro.org> <1332582590-16382-2-git-send-email-thomas.abraham@linaro.org>
Date: Fri, 30 Mar 2012 16:06:19 -0600
Message-Id: <20120330220619.334AC3E054E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2012 15:19:49 +0530, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> Add irq domain support for max8997 interrupts. The reverse mapping method
> used is linear mapping since the sub-drivers of max8997 such as regulator
> and charger drivers can use the max8997 irq_domain to get the linux irq
> number for max8997 interrupts. All uses of irq_base in platform data and
> max8997 driver private data are removed.
> 
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  arch/arm/mach-exynos/mach-nuri.c    |    4 --
>  arch/arm/mach-exynos/mach-origen.c  |    1 -
>  drivers/mfd/max8997-irq.c           |   61 ++++++++++++++++++++--------------
>  drivers/mfd/max8997.c               |    1 -
>  include/linux/mfd/max8997-private.h |    4 ++-
>  include/linux/mfd/max8997.h         |    1 -
>  6 files changed, 39 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/mach-nuri.c b/arch/arm/mach-exynos/mach-nuri.c
> index 7ac81ce..b21d85d 100644
> --- a/arch/arm/mach-exynos/mach-nuri.c
> +++ b/arch/arm/mach-exynos/mach-nuri.c
> @@ -1077,12 +1077,8 @@ static struct platform_device nuri_max8903_device = {
>  static void __init nuri_power_init(void)
>  {
>  	int gpio;
> -	int irq_base = IRQ_GPIO_END + 1;
>  	int ta_en = 0;
>  
> -	nuri_max8997_pdata.irq_base = irq_base;
> -	irq_base += MAX8997_IRQ_NR;
> -
>  	gpio = EXYNOS4_GPX0(7);
>  	gpio_request(gpio, "AP_PMIC_IRQ");
>  	s3c_gpio_cfgpin(gpio, S3C_GPIO_SFN(0xf));
> diff --git a/arch/arm/mach-exynos/mach-origen.c b/arch/arm/mach-exynos/mach-origen.c
> index 827cb99..d3b2e9d 100644
> --- a/arch/arm/mach-exynos/mach-origen.c
> +++ b/arch/arm/mach-exynos/mach-origen.c
> @@ -424,7 +424,6 @@ static struct max8997_platform_data __initdata origen_max8997_pdata = {
>  	.buck1_gpiodvs	= false,
>  	.buck2_gpiodvs	= false,
>  	.buck5_gpiodvs	= false,
> -	.irq_base	= IRQ_GPIO_END + 1,
>  
>  	.ignore_gpiodvs_side_effect = true,
>  	.buck125_default_idx = 0x0,
> diff --git a/drivers/mfd/max8997-irq.c b/drivers/mfd/max8997-irq.c
> index 09274cf..00390a1 100644
> --- a/drivers/mfd/max8997-irq.c
> +++ b/drivers/mfd/max8997-irq.c
> @@ -142,7 +142,8 @@ static void max8997_irq_sync_unlock(struct irq_data *data)
>  static const inline struct max8997_irq_data *
>  irq_to_max8997_irq(struct max8997_dev *max8997, int irq)
>  {
> -	return &max8997_irqs[irq - max8997->irq_base];
> +	struct irq_data *data = irq_get_irq_data(irq);
> +	return &max8997_irqs[data->hwirq];
>  }

Haha, this is kind of bogus now.  There are only two users of this
function, and *both* of them already have the irq_data pointer.
Instead of this, delete this function entirely and make each caller
derefernce max8997_irqs directly:

	const struct max8997_irq_data *irq_data = &max8997_irqs[data->hwirq];

Otherwise, looks good.  After fixing you can add my:

Acked-by: Grant Likely <grant.likely@secretlab.ca>

>  
>  static void max8997_irq_mask(struct irq_data *data)
> @@ -182,7 +183,7 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
>  	u8 irq_reg[MAX8997_IRQ_GROUP_NR] = {};
>  	u8 irq_src;
>  	int ret;
> -	int i;
> +	int i, cur_irq;
>  
>  	ret = max8997_read_reg(max8997->i2c, MAX8997_REG_INTSRC, &irq_src);
>  	if (ret < 0) {
> @@ -269,8 +270,11 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
>  
>  	/* Report */
>  	for (i = 0; i < MAX8997_IRQ_NR; i++) {
> -		if (irq_reg[max8997_irqs[i].group] & max8997_irqs[i].mask)
> -			handle_nested_irq(max8997->irq_base + i);
> +		if (irq_reg[max8997_irqs[i].group] & max8997_irqs[i].mask) {
> +			cur_irq = irq_find_mapping(max8997->irq_domain, i);
> +			if (cur_irq)
> +				handle_nested_irq(cur_irq);
> +		}
>  	}
>  
>  	return IRQ_HANDLED;
> @@ -278,26 +282,40 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
>  
>  int max8997_irq_resume(struct max8997_dev *max8997)
>  {
> -	if (max8997->irq && max8997->irq_base)
> -		max8997_irq_thread(max8997->irq_base, max8997);
> +	if (max8997->irq && max8997->irq_domain)
> +		max8997_irq_thread(0, max8997);
> +	return 0;
> +}
> +
> +static int max8997_irq_domain_map(struct irq_domain *d, unsigned int irq,
> +					irq_hw_number_t hw)
> +{
> +	struct max8997_dev *max8997 = d->host_data;
> +
> +	irq_set_chip_data(irq, max8997);
> +	irq_set_chip_and_handler(irq, &max8997_irq_chip, handle_edge_irq);
> +	irq_set_nested_thread(irq, 1);
> +#ifdef CONFIG_ARM
> +	set_irq_flags(irq, IRQF_VALID);
> +#else
> +	irq_set_noprobe(irq);
> +#endif
>  	return 0;
>  }
>  
> +static struct irq_domain_ops max8997_irq_domain_ops = {
> +	.map = max8997_irq_domain_map,
> +};
> +
>  int max8997_irq_init(struct max8997_dev *max8997)
>  {
> +	struct irq_domain *domain;
>  	int i;
> -	int cur_irq;
>  	int ret;
>  	u8 val;
>  
>  	if (!max8997->irq) {
>  		dev_warn(max8997->dev, "No interrupt specified.\n");
> -		max8997->irq_base = 0;
> -		return 0;
> -	}
> -
> -	if (!max8997->irq_base) {
> -		dev_err(max8997->dev, "No interrupt base specified.\n");
>  		return 0;
>  	}
>  
> @@ -327,18 +345,11 @@ int max8997_irq_init(struct max8997_dev *max8997)
>  					true : false;
>  	}
>  
> -	/* Register with genirq */
> -	for (i = 0; i < MAX8997_IRQ_NR; i++) {
> -		cur_irq = i + max8997->irq_base;
> -		irq_set_chip_data(cur_irq, max8997);
> -		irq_set_chip_and_handler(cur_irq, &max8997_irq_chip,
> -				handle_edge_irq);
> -		irq_set_nested_thread(cur_irq, 1);
> -#ifdef CONFIG_ARM
> -		set_irq_flags(cur_irq, IRQF_VALID);
> -#else
> -		irq_set_noprobe(cur_irq);
> -#endif
> +	domain = irq_domain_add_linear(NULL, MAX8997_IRQ_NR,
> +					&max8997_irq_domain_ops, &max8997);
> +	if (!domain) {
> +		dev_err(max8997->dev, "could not create irq domain\n");
> +		return -ENODEV;
>  	}
>  
>  	ret = request_threaded_irq(max8997->irq, NULL, max8997_irq_thread,
> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
> index cb83a7a..20ecad3 100644
> --- a/drivers/mfd/max8997.c
> +++ b/drivers/mfd/max8997.c
> @@ -143,7 +143,6 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
>  	if (!pdata)
>  		goto err;
>  
> -	max8997->irq_base = pdata->irq_base;
>  	max8997->ono = pdata->ono;
>  
>  	mutex_init(&max8997->iolock);
> diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
> index 3f4deb6..830152c 100644
> --- a/include/linux/mfd/max8997-private.h
> +++ b/include/linux/mfd/max8997-private.h
> @@ -23,6 +23,8 @@
>  #define __LINUX_MFD_MAX8997_PRIV_H
>  
>  #include <linux/i2c.h>
> +#include <linux/export.h>
> +#include <linux/irqdomain.h>
>  
>  #define MAX8997_REG_INVALID	(0xff)
>  
> @@ -325,7 +327,7 @@ struct max8997_dev {
>  
>  	int irq;
>  	int ono;
> -	int irq_base;
> +	struct irq_domain *irq_domain;
>  	struct mutex irqlock;
>  	int irq_masks_cur[MAX8997_IRQ_GROUP_NR];
>  	int irq_masks_cache[MAX8997_IRQ_GROUP_NR];
> diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
> index fff5905..818486c 100644
> --- a/include/linux/mfd/max8997.h
> +++ b/include/linux/mfd/max8997.h
> @@ -155,7 +155,6 @@ struct max8997_led_platform_data {
>  
>  struct max8997_platform_data {
>  	/* IRQ */
> -	int irq_base;
>  	int ono;
>  	int wakeup;
>  
> -- 
> 1.6.6.rc2
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
