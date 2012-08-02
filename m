Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab2HBKQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:16:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60315 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753378Ab2HBKQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:16:29 -0400
Date: Thu, 2 Aug 2012 11:16:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [NEW DRIVER V1 1/7] DA9058 MFD core and ADC driver
Message-ID: <20120802101626.GE29157@opensource.wolfsonmicro.com>
References: <201208020849.q728nhpW007804@latitude.olech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208020849.q728nhpW007804@latitude.olech.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 09:48:55AM +0100, Anthony Olech wrote:

> +#if 0
> +	return regmap_bulk_read(da9058->regmap, reg, val, val_count);
> +#else
> +	int ret = regmap_bulk_read(da9058->regmap, reg, val, val_count);
> +	return ret;
> +#endif

This shouldn't be going into mainline...

> +/*
> + *  if the PMIC is in automatic ADC consersion mode we have the choice
> + *  of just getting the last (automatic) conversion or doing a manual
> + *  conversion anyway.
> + *
> + *  if the PMIC is not in automatic ADC consersion mode we have no choice
> + *  we just have to ignore the requested mode and just do a manual
> + *  ADC conversion.
> + */
> +static int da9058_automatic_adc_conversion(struct da9058 *da9058,
> +				const int channel, int *value)

This ADC stuff should be an IIO driver now.

> +	if (pdata->init_board_irq) {
> +		ret = pdata->init_board_irq();
> +		if (ret)

Why is this conditional?  With irqdomains there's no real reason to not
allocate the IRQs even if you can't usefully use them and it helps make
the code simpler.

> +			goto err4;

Named labesl are *much* better, it's vastly less painful if you need to
add new code.

> +	da9058->reg_read = da9058_register_read;
> +	da9058->reg_write = da9058_register_write;
> +	da9058->reg_raw_read = da9058_register_raw_read;
> +	da9058->reg_raw_write = da9058_register_raw_write;
> +	da9058->reg_bulk_read = da9058_register_bulk_read;
> +	da9058->reg_bulk_write = da9058_register_bulk_write;
> +	da9058->reg_update_bits = da9058_register_update_bits;

These are always the same thing.  Just have some inline functions in the
header if you find this useful, the vtable in the driver is just
replicating what regmap does and making things more complicated.

> +int da9058_to_virt_irq_num(struct da9058 *da9058, int irq)
> +{
> +	return da9058->irq_base + irq;
> +}
> +EXPORT_SYMBOL_GPL(da9058_to_virt_irq_num);

This should be calling regmap_irq_get_virq() and a static inlinne in the
header.

> +	dev_info(da9058->dev, "IRQ %d mapped to virtual array based at %d\n",
> +			da9058->chip_irq, da9058->irq_base);

This sort of log message isn't terribly useful and isn't accurate with
irq domains.
