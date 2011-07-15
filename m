Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964887Ab1GOCyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 22:54:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64844 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964799Ab1GOCx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 22:53:58 -0400
Date: Thu, 14 Jul 2011 20:53:55 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mcp23s08: add i2c support
Message-ID: <20110715025355.GX2927@ponder.secretlab.ca>
References: <1310673568-30577-1-git-send-email-jacmet@sunsite.dk>
 <1310673568-30577-4-git-send-email-jacmet@sunsite.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310673568-30577-4-git-send-email-jacmet@sunsite.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 09:59:28PM +0200, Peter Korsgaard wrote:
> Add i2c bindings for the mcp230xx devices. This is quite a lot simpler
> than the spi ones as there's no funky sub addressing done (one struct
> i2c_client per struct gpio_chip).
> 
> The mcp23s08_platform_data structure is reused for i2c, even though
> only a single mcp23s08_chip_info structure is needed.
> 
> To make the platform data bus independent, the setup/teardown prototypes
> are slightly changed, so the bus specific struct (spi_device / i2c_client)
> is passed as a void pointer instead.
> 
> There's no in-tree users of these callbacks.

Why don't we just remove them then?  The notifier mechanism is more
generic anyway.

[...]
> @@ -537,9 +705,13 @@ static int __init mcp23s08_init(void)
>  		return ret;
>  #endif /* CONFIG_SPI_MASTER */
>  
> +#ifdef CONFIG_I2C
> +	ret = i2c_add_driver(&mcp230xx_driver);
> +#endif /* CONFIG_I2C */
> +

Need to unwind on failure to register, or put the i2c driver into a
separate module so that each module gets it's own init/exit hooks.

>  	return ret;
>  }
> -/* register after spi postcore initcall and before
> +/* register after spi/i2c postcore initcall and before
>   * subsys initcalls that may rely on these GPIOs
>   */
>  subsys_initcall(mcp23s08_init);
> @@ -550,6 +722,10 @@ static void __exit mcp23s08_exit(void)
>  	spi_unregister_driver(&mcp23s08_driver);
>  #endif /* CONFIG_SPI_MASTER */
>  
> +#ifdef CONFIG_I2C
> +	i2c_del_driver(&mcp230xx_driver);
> +#endif /* CONFIG_I2C */
> +
>  }
>  module_exit(mcp23s08_exit);
>  
> diff --git a/include/linux/spi/mcp23s08.h b/include/linux/spi/mcp23s08.h
> index c42cff8..2eb4fc1 100644
> --- a/include/linux/spi/mcp23s08.h
> +++ b/include/linux/spi/mcp23s08.h
> @@ -25,10 +25,10 @@ struct mcp23s08_platform_data {
>  
>  	void		*context;	/* param to setup/teardown */
>  
> -	int		(*setup)(struct spi_device *spi,
> +	int		(*setup)(void *data,
>  					int gpio, unsigned ngpio,
>  					void *context);
> -	int		(*teardown)(struct spi_device *spi,
> +	int		(*teardown)(void *data,
>  					int gpio, unsigned ngpio,
>  					void *context);
>  };
> -- 
> 1.7.5.4
> 
