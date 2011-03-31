Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab1CaD2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 23:28:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40364 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1CaD2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 23:28:32 -0400
Date: Wed, 30 Mar 2011 21:28:28 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] gpio: pca953x: fix error handling path in probe() call
Message-ID: <20110331032828.GA19333@ponder.secretlab.ca>
References: <1301523526-27799-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301523526-27799-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 07:18:46AM +0900, Mark Brown wrote:
> From: Ben Dooks <ben-linux@fluff.org>
> 
> If the device fails to respond, then the error path tries to remove an
> interrupt that never got registered, which causes an backtrace from the
> interrupt handling code.
> 
> Fix this by ensuring that the cleanup path has two labels and use the
> correct path as needed.
> 
> fixes the following error:
> 
> WARNING: at kernel/irq/manage.c:908 __free_irq+0x80/0x160()
> Trying to free already-free IRQ 0
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied, thanks.

g.

> ---
>  drivers/gpio/pca953x.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
> index 583e925..7630ab7 100644
> --- a/drivers/gpio/pca953x.c
> +++ b/drivers/gpio/pca953x.c
> @@ -558,7 +558,7 @@ static int __devinit pca953x_probe(struct i2c_client *client,
>  
>  	ret = gpiochip_add(&chip->gpio_chip);
>  	if (ret)
> -		goto out_failed;
> +		goto out_failed_irq;
>  
>  	if (pdata->setup) {
>  		ret = pdata->setup(client, chip->gpio_chip.base,
> @@ -570,8 +570,9 @@ static int __devinit pca953x_probe(struct i2c_client *client,
>  	i2c_set_clientdata(client, chip);
>  	return 0;
>  
> -out_failed:
> +out_failed_irq:
>  	pca953x_irq_teardown(chip);
> +out_failed:
>  	kfree(chip->dyn_pdata);
>  	kfree(chip);
>  	return ret;
> -- 
> 1.7.4.1
> 
