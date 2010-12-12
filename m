Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab0LLQhJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 11:37:09 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:58002 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500Ab0LLQhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 11:37:07 -0500
Message-ID: <4D04FA23.6030504@metafoo.de>
Date: Sun, 12 Dec 2010 17:36:51 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] mfd: Convert jz4740-adc to new irq_ methods
References: <4D03CE07.4050100@metafoo.de> <1292154400-15759-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1292154400-15759-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2010 12:46 PM, Mark Brown wrote:
> Convert the jz4740-adc driver to use the recently introduced IRQ API
> variants which are passed struct irq_data rather than an IRQ number.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/jz4740-adc.c |   24 ++++++++++++------------
>  1 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
> index 9dd1b33..7188c06 100644
> --- a/drivers/mfd/jz4740-adc.c
> +++ b/drivers/mfd/jz4740-adc.c
> @@ -84,31 +84,31 @@ static inline void jz4740_adc_irq_set_masked(struct jz4740_adc *adc, int irq,
>  	spin_unlock_irqrestore(&adc->lock, flags);
>  }
>  
> -static void jz4740_adc_irq_mask(unsigned int irq)
> +static void jz4740_adc_irq_mask(struct irq_data *data)
>  {
> -	struct jz4740_adc *adc = get_irq_chip_data(irq);
> -	jz4740_adc_irq_set_masked(adc, irq, true);
> +	struct jz4740_adc *adc = irq_data_get_irq_chip_data(data);
> +	jz4740_adc_irq_set_masked(adc, data->irq, true);
>  }
>  
> -static void jz4740_adc_irq_unmask(unsigned int irq)
> +static void jz4740_adc_irq_unmask(struct irq_data *data)
>  {
> -	struct jz4740_adc *adc = get_irq_chip_data(irq);
> -	jz4740_adc_irq_set_masked(adc, irq, false);
> +	struct jz4740_adc *adc = irq_data_get_irq_chip_data(data);
> +	jz4740_adc_irq_set_masked(adc, data->irq, false);
>  }
>  
> -static void jz4740_adc_irq_ack(unsigned int irq)
> +static void jz4740_adc_irq_ack(struct irq_data *data)
>  {
> -	struct jz4740_adc *adc = get_irq_chip_data(irq);
> +	struct jz4740_adc *adc = irq_data_get_irq_chip_data(data);
>  
> -	irq -= adc->irq_base;
> +	data->irq -= adc->irq_base;
data->irq is decremented now each time an irq is acked
>  	writeb(BIT(irq), adc->base + JZ_REG_ADC_STATUS);
And 'irq' is undefined.

I'll send a patch as reply which is compile and runtime tested.
>  }
>  
>  static struct irq_chip jz4740_adc_irq_chip = {
>  	.name = "jz4740-adc",
> -	.mask = jz4740_adc_irq_mask,
> -	.unmask = jz4740_adc_irq_unmask,
> -	.ack = jz4740_adc_irq_ack,
> +	.irq_mask = jz4740_adc_irq_mask,
> +	.irq_unmask = jz4740_adc_irq_unmask,
> +	.irq_ack = jz4740_adc_irq_ack,
>  };
>  
>  static void jz4740_adc_irq_demux(unsigned int irq, struct irq_desc *desc)

