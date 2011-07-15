Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965333Ab1GOJMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 05:12:30 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:50668 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964982Ab1GOJM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 05:12:28 -0400
Message-ID: <4E20047A.4080909@slimlogic.co.uk>
Date: Fri, 15 Jul 2011 10:12:26 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: avoid two assignments if failures happen in tps65910_i2c_probe
References: <alpine.LNX.2.00.1107132319020.22281@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1107132319020.22281@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2011 10:22 PM, Jesper Juhl wrote:
> In drivers/mfd/tps65910.c:tps65910_i2c_probe() there's potential for a
> tiny optimization.
>
> We assign to init_data->irq and init_data->irq_base long before we
> need them, and there are two potential exits from the function before
> they are needed.
>
> Moving the assignments below these two potential exits means we
> completely avoid doing them in these two (failure) cases.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/mfd/tps65910.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
>   - compile tested only.
>   - patch is on top of the patch in https://lkml.org/lkml/2011/7/5/503 
>     which is now in linux-next.
>
> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> index 7a3eb2d..65e9479 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -147,9 +147,6 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
>  	if (init_data == NULL)
>  		return -ENOMEM;
>  
> -	init_data->irq = pmic_plat_data->irq;
> -	init_data->irq_base = pmic_plat_data->irq;
> -
>  	tps65910 = kzalloc(sizeof(struct tps65910), GFP_KERNEL);
>  	if (tps65910 == NULL) {
>  		kfree(init_data);
> @@ -170,6 +167,9 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
>  	if (ret < 0)
>  		goto err;
>  
> +	init_data->irq = pmic_plat_data->irq;
> +	init_data->irq_base = pmic_plat_data->irq;
> +
>  	tps65910_gpio_init(tps65910, pmic_plat_data->gpio_base);
>  
>  	ret = tps65910_irq_init(tps65910, init_data->irq, init_data);
Not sure this form of micro optimisation really buys anything, but the
resulting code does look nicer so.

Acked-by: Graeme Gregory <gg@slimlogic.co.uk>

