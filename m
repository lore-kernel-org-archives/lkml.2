Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab0LMGLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:11:09 -0500
Received: from compulab.co.il ([67.18.134.219]:55262 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab0LMGLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:11:07 -0500
Message-ID: <4D05B8F2.1050608@compulab.co.il>
Date: Mon, 13 Dec 2010 08:10:58 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20101013 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] mfd: Convert tps6586x driver to new irq_ API
References: <1292157568-23220-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1292157568-23220-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/10 14:39, Mark Brown wrote:
> The genirq core is being updated to supply struct irq_data to irq_chip
> operations rather than an irq number. Update the tps6586x driver to the
> new APIs.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Mike Rapoport <mike@compulab.co.il>

> ---
>  drivers/mfd/tps6586x.c |   28 ++++++++++++++--------------
>  1 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
> index b4931ab..fe443d7 100644
> --- a/drivers/mfd/tps6586x.c
> +++ b/drivers/mfd/tps6586x.c
> @@ -325,37 +325,37 @@ static int tps6586x_remove_subdevs(struct tps6586x *tps6586x)
>  	return device_for_each_child(tps6586x->dev, NULL, __remove_subdev);
>  }
>  
> -static void tps6586x_irq_lock(unsigned int irq)
> +static void tps6586x_irq_lock(struct irq_data *data)
>  {
> -	struct tps6586x *tps6586x = get_irq_chip_data(irq);
> +	struct tps6586x *tps6586x = irq_data_get_irq_chip_data(data);
>  
>  	mutex_lock(&tps6586x->irq_lock);
>  }
>  
> -static void tps6586x_irq_enable(unsigned int irq)
> +static void tps6586x_irq_enable(struct irq_data *irq_data)
>  {
> -	struct tps6586x *tps6586x = get_irq_chip_data(irq);
> -	unsigned int __irq = irq - tps6586x->irq_base;
> +	struct tps6586x *tps6586x = irq_data_get_irq_chip_data(irq_data);
> +	unsigned int __irq = irq_data->irq - tps6586x->irq_base;
>  	const struct tps6586x_irq_data *data = &tps6586x_irqs[__irq];
>  
>  	tps6586x->mask_reg[data->mask_reg] &= ~data->mask_mask;
>  	tps6586x->irq_en |= (1 << __irq);
>  }
>  
> -static void tps6586x_irq_disable(unsigned int irq)
> +static void tps6586x_irq_disable(struct irq_data *irq_data)
>  {
> -	struct tps6586x *tps6586x = get_irq_chip_data(irq);
> +	struct tps6586x *tps6586x = irq_data_get_irq_chip_data(irq_data);
>  
> -	unsigned int __irq = irq - tps6586x->irq_base;
> +	unsigned int __irq = irq_data->irq - tps6586x->irq_base;
>  	const struct tps6586x_irq_data *data = &tps6586x_irqs[__irq];
>  
>  	tps6586x->mask_reg[data->mask_reg] |= data->mask_mask;
>  	tps6586x->irq_en &= ~(1 << __irq);
>  }
>  
> -static void tps6586x_irq_sync_unlock(unsigned int irq)
> +static void tps6586x_irq_sync_unlock(struct irq_data *data)
>  {
> -	struct tps6586x *tps6586x = get_irq_chip_data(irq);
> +	struct tps6586x *tps6586x = irq_data_get_irq_chip_data(data);
>  	int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(tps6586x->mask_reg); i++) {
> @@ -421,10 +421,10 @@ static int __devinit tps6586x_irq_init(struct tps6586x *tps6586x, int irq,
>  	tps6586x->irq_base = irq_base;
>  
>  	tps6586x->irq_chip.name = "tps6586x";
> -	tps6586x->irq_chip.enable = tps6586x_irq_enable;
> -	tps6586x->irq_chip.disable = tps6586x_irq_disable;
> -	tps6586x->irq_chip.bus_lock = tps6586x_irq_lock;
> -	tps6586x->irq_chip.bus_sync_unlock = tps6586x_irq_sync_unlock;
> +	tps6586x->irq_chip.irq_enable = tps6586x_irq_enable;
> +	tps6586x->irq_chip.irq_disable = tps6586x_irq_disable;
> +	tps6586x->irq_chip.irq_bus_lock = tps6586x_irq_lock;
> +	tps6586x->irq_chip.irq_bus_sync_unlock = tps6586x_irq_sync_unlock;
>  
>  	for (i = 0; i < ARRAY_SIZE(tps6586x_irqs); i++) {
>  		int __irq = i + tps6586x->irq_base;


-- 
Sincerely yours,
Mike.
