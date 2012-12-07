Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab2LGA0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:26:46 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:57374 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab2LGA0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:26:43 -0500
Date: Fri, 7 Dec 2012 09:26:39 +0900
From: Simon Horman <horms@verge.net.au>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Linux-SH <linux-sh@vger.kernel.org>,
        ENGELMAYER Christian <Christian.Engelmayer@frequentis.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: pcf857x: use client->irq for gpio_to_irq()
Message-ID: <20121207002630.GG18360@verge.net.au>
References: <20121203222248.298b3671@frequentis.com>
 <87y5hd80ep.wl%kuninori.morimoto.gx@renesas.com>
 <EA116A090B102B4EBF532A9EECFA1EC5795252C6@vie196nt>
 <87obi86kpp.wl%kuninori.morimoto.gx@renesas.com>
 <EA116A090B102B4EBF532A9EECFA1EC579525758@vie196nt>
 <87lidb7dhb.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lidb7dhb.wl%kuninori.morimoto.gx@renesas.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 01:10:28AM -0800, Kuninori Morimoto wrote:
> 6e20a0a429bd4dc07d6de16d9c247270e04e4aa0
> (gpio: pcf857x: enable gpio_to_irq() support)
> added gpio_to_irq() support on pcf857x driver,
> but it used pdata->irq.
> This patch modifies driver to use client->irq instead of it.
> It modifies kzm9g board platform settings,
> and device probe information too.
> This patch is tested on kzm9g board
> 
> Reported-by: ENGELMAYER Christian Christian.Engelmayer@frequentis.com
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> ---
> >> Simon
> 
> This patch modify kzm9g board settings.
> Please give your acked-by on this patch

Thanks Morimoto-san,

This seems reasonable to me and a quick boot check doesn't show up
any breakage.

Acked-by: Simon Horman <horms+renesas@verge.net.au>

> 
>  arch/arm/mach-shmobile/board-kzm9g.c |    2 +-
>  drivers/gpio/gpio-pcf857x.c          |   29 +++++++++++------------------
>  include/linux/i2c/pcf857x.h          |    3 ---
>  3 files changed, 12 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/arm/mach-shmobile/board-kzm9g.c b/arch/arm/mach-shmobile/board-kzm9g.c
> index f63f2ee..c02448d 100644
> --- a/arch/arm/mach-shmobile/board-kzm9g.c
> +++ b/arch/arm/mach-shmobile/board-kzm9g.c
> @@ -552,7 +552,6 @@ static struct platform_device fsi_ak4648_device = {
>  /* I2C */
>  static struct pcf857x_platform_data pcf8575_pdata = {
>  	.gpio_base	= GPIO_PCF8575_BASE,
> -	.irq		= intcs_evt2irq(0x3260), /* IRQ19 */
>  };
>  
>  static struct i2c_board_info i2c0_devices[] = {
> @@ -582,6 +581,7 @@ static struct i2c_board_info i2c1_devices[] = {
>  static struct i2c_board_info i2c3_devices[] = {
>  	{
>  		I2C_BOARD_INFO("pcf8575", 0x20),
> +		.irq		= intcs_evt2irq(0x3260), /* IRQ19 */
>  		.platform_data = &pcf8575_pdata,
>  	},
>  };
> diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
> index 16af35c..a19b745 100644
> --- a/drivers/gpio/gpio-pcf857x.c
> +++ b/drivers/gpio/gpio-pcf857x.c
> @@ -223,11 +223,11 @@ static void pcf857x_irq_domain_cleanup(struct pcf857x *gpio)
>  
>  static int pcf857x_irq_domain_init(struct pcf857x *gpio,
>  				   struct pcf857x_platform_data *pdata,
> -				   struct device *dev)
> +				   struct i2c_client *client)
>  {
>  	int status;
>  
> -	gpio->irq_domain = irq_domain_add_linear(dev->of_node,
> +	gpio->irq_domain = irq_domain_add_linear(client->dev.of_node,
>  						 gpio->chip.ngpio,
>  						 &pcf857x_irq_domain_ops,
>  						 NULL);
> @@ -235,15 +235,15 @@ static int pcf857x_irq_domain_init(struct pcf857x *gpio,
>  		goto fail;
>  
>  	/* enable real irq */
> -	status = request_irq(pdata->irq, pcf857x_irq_demux, 0,
> -			     dev_name(dev), gpio);
> +	status = request_irq(client->irq, pcf857x_irq_demux, 0,
> +			     dev_name(&client->dev), gpio);
>  	if (status)
>  		goto fail;
>  
>  	/* enable gpio_to_irq() */
>  	INIT_WORK(&gpio->work, pcf857x_irq_demux_work);
>  	gpio->chip.to_irq	= pcf857x_to_irq;
> -	gpio->irq		= pdata->irq;
> +	gpio->irq		= client->irq;
>  
>  	return 0;
>  
> @@ -285,8 +285,8 @@ static int pcf857x_probe(struct i2c_client *client,
>  	gpio->chip.ngpio		= id->driver_data;
>  
>  	/* enable gpio_to_irq() if platform has settings */
> -	if (pdata && pdata->irq) {
> -		status = pcf857x_irq_domain_init(gpio, pdata, &client->dev);
> +	if (pdata && client->irq) {
> +		status = pcf857x_irq_domain_init(gpio, pdata, client);
>  		if (status < 0) {
>  			dev_err(&client->dev, "irq_domain init failed\n");
>  			goto fail;
> @@ -368,15 +368,6 @@ static int pcf857x_probe(struct i2c_client *client,
>  	if (status < 0)
>  		goto fail;
>  
> -	/* NOTE: these chips can issue "some pin-changed" IRQs, which we
> -	 * don't yet even try to use.  Among other issues, the relevant
> -	 * genirq state isn't available to modular drivers; and most irq
> -	 * methods can't be called from sleeping contexts.
> -	 */
> -
> -	dev_info(&client->dev, "%s\n",
> -			client->irq ? " (irq ignored)" : "");
> -
>  	/* Let platform code set up the GPIOs and their users.
>  	 * Now is the first time anyone could use them.
>  	 */
> @@ -388,13 +379,15 @@ static int pcf857x_probe(struct i2c_client *client,
>  			dev_warn(&client->dev, "setup --> %d\n", status);
>  	}
>  
> +	dev_info(&client->dev, "probed\n");
> +
>  	return 0;
>  
>  fail:
>  	dev_dbg(&client->dev, "probe error %d for '%s'\n",
>  			status, client->name);
>  
> -	if (pdata && pdata->irq)
> +	if (pdata && client->irq)
>  		pcf857x_irq_domain_cleanup(gpio);
>  
>  	kfree(gpio);
> @@ -418,7 +411,7 @@ static int pcf857x_remove(struct i2c_client *client)
>  		}
>  	}
>  
> -	if (pdata && pdata->irq)
> +	if (pdata && client->irq)
>  		pcf857x_irq_domain_cleanup(gpio);
>  
>  	status = gpiochip_remove(&gpio->chip);
> diff --git a/include/linux/i2c/pcf857x.h b/include/linux/i2c/pcf857x.h
> index 781e6bd..0767a2a 100644
> --- a/include/linux/i2c/pcf857x.h
> +++ b/include/linux/i2c/pcf857x.h
> @@ -10,7 +10,6 @@
>   * @setup: optional callback issued once the GPIOs are valid
>   * @teardown: optional callback issued before the GPIOs are invalidated
>   * @context: optional parameter passed to setup() and teardown()
> - * @irq: optional interrupt number
>   *
>   * In addition to the I2C_BOARD_INFO() state appropriate to each chip,
>   * the i2c_board_info used with the pcf875x driver must provide its
> @@ -40,8 +39,6 @@ struct pcf857x_platform_data {
>  					int gpio, unsigned ngpio,
>  					void *context);
>  	void		*context;
> -
> -	int		irq;
>  };
>  
>  #endif /* __LINUX_PCF857X_H */
> -- 
> 1.7.9.5
> 
