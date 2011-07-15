Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964917Ab1GOCyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 22:54:06 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60883 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964884Ab1GOCyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 22:54:01 -0400
Date: Thu, 14 Jul 2011 20:53:58 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mcp23s08: isolate spi specific parts
Message-ID: <20110715025358.GZ2927@ponder.secretlab.ca>
References: <1310673568-30577-1-git-send-email-jacmet@sunsite.dk>
 <1310673568-30577-3-git-send-email-jacmet@sunsite.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310673568-30577-3-git-send-email-jacmet@sunsite.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 09:59:27PM +0200, Peter Korsgaard wrote:
> Change spi member of struct mcp23s08 to be a ops-specific opaque data
> pointer, and move spi specific knowledge out of mcp23s08_probe_one().
> 
> No functional change, but is needed to add i2c support.
> 
> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
> ---
>  drivers/gpio/mcp23s08.c |   75 ++++++++++++++++++++++++++++++++--------------
>  1 files changed, 52 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/gpio/mcp23s08.c b/drivers/gpio/mcp23s08.c
> index 242a8a2..1494347 100644
> --- a/drivers/gpio/mcp23s08.c
> +++ b/drivers/gpio/mcp23s08.c
> @@ -50,7 +50,6 @@ struct mcp23s08_ops {
>  };
>  
>  struct mcp23s08 {
> -	struct spi_device	*spi;
>  	u8			addr;
>  
>  	u16			cache[11];
> @@ -60,6 +59,7 @@ struct mcp23s08 {
>  	struct gpio_chip	chip;
>  
>  	const struct mcp23s08_ops	*ops;
> +	void			*data; /* ops specific data */
>  };
>  
>  /* A given spi_device can represent up to eight mcp23sxx chips
> @@ -73,6 +73,8 @@ struct mcp23s08_driver_data {
>  	struct mcp23s08		chip[];
>  };
>  
> +#ifdef CONFIG_SPI_MASTER
> +
>  static int mcp23s08_read(struct mcp23s08 *mcp, unsigned reg)
>  {
>  	u8	tx[2], rx[1];
> @@ -80,7 +82,7 @@ static int mcp23s08_read(struct mcp23s08 *mcp, unsigned reg)
>  
>  	tx[0] = mcp->addr | 0x01;
>  	tx[1] = reg;
> -	status = spi_write_then_read(mcp->spi, tx, sizeof tx, rx, sizeof rx);
> +	status = spi_write_then_read(mcp->data, tx, sizeof tx, rx, sizeof rx);
>  	return (status < 0) ? status : rx[0];
>  }
>  
> @@ -91,7 +93,7 @@ static int mcp23s08_write(struct mcp23s08 *mcp, unsigned reg, unsigned val)
>  	tx[0] = mcp->addr;
>  	tx[1] = reg;
>  	tx[2] = val;
> -	return spi_write_then_read(mcp->spi, tx, sizeof tx, NULL, 0);
> +	return spi_write_then_read(mcp->data, tx, sizeof tx, NULL, 0);
>  }
>  
>  static int
> @@ -106,7 +108,7 @@ mcp23s08_read_regs(struct mcp23s08 *mcp, unsigned reg, u16 *vals, unsigned n)
>  	tx[1] = reg;
>  
>  	tmp = (u8 *)vals;
> -	status = spi_write_then_read(mcp->spi, tx, sizeof tx, tmp, n);
> +	status = spi_write_then_read(mcp->data, tx, sizeof tx, tmp, n);
>  	if (status >= 0) {
>  		while (n--)
>  			vals[n] = tmp[n]; /* expand to 16bit */
> @@ -121,7 +123,7 @@ static int mcp23s17_read(struct mcp23s08 *mcp, unsigned reg)
>  
>  	tx[0] = mcp->addr | 0x01;
>  	tx[1] = reg << 1;
> -	status = spi_write_then_read(mcp->spi, tx, sizeof tx, rx, sizeof rx);
> +	status = spi_write_then_read(mcp->data, tx, sizeof tx, rx, sizeof rx);
>  	return (status < 0) ? status : (rx[0] | (rx[1] << 8));
>  }
>  
> @@ -133,7 +135,7 @@ static int mcp23s17_write(struct mcp23s08 *mcp, unsigned reg, unsigned val)
>  	tx[1] = reg << 1;
>  	tx[2] = val;
>  	tx[3] = val >> 8;
> -	return spi_write_then_read(mcp->spi, tx, sizeof tx, NULL, 0);
> +	return spi_write_then_read(mcp->data, tx, sizeof tx, NULL, 0);
>  }
>  
>  static int
> @@ -147,7 +149,7 @@ mcp23s17_read_regs(struct mcp23s08 *mcp, unsigned reg, u16 *vals, unsigned n)
>  	tx[0] = mcp->addr | 0x01;
>  	tx[1] = reg << 1;
>  
> -	status = spi_write_then_read(mcp->spi, tx, sizeof tx,
> +	status = spi_write_then_read(mcp->data, tx, sizeof tx,
>  				     (u8 *)vals, n * 2);
>  	if (status >= 0) {
>  		while (n--)
> @@ -169,6 +171,7 @@ static const struct mcp23s08_ops mcp23s17_ops = {
>  	.read_regs	= mcp23s17_read_regs,
>  };
>  
> +#endif /* CONFIG_SPI_MASTER */
>  
>  /*----------------------------------------------------------------------*/
>  
> @@ -296,17 +299,16 @@ done:
>  
>  /*----------------------------------------------------------------------*/
>  
> -static int mcp23s08_probe_one(struct spi_device *spi, unsigned addr,
> +static int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
> +			      void *data, unsigned addr,
>  			      unsigned type, unsigned base, unsigned pullups)
>  {
> -	struct mcp23s08_driver_data	*data = spi_get_drvdata(spi);
> -	struct mcp23s08			*mcp = data->mcp[addr];
> -	int				status;
> +	int status;
>  
>  	mutex_init(&mcp->lock);
>  
> -	mcp->spi = spi;
> -	mcp->addr = 0x40 | (addr << 1);
> +	mcp->data = data;
> +	mcp->addr = addr;
>  
>  	mcp->chip.direction_input = mcp23s08_direction_input;
>  	mcp->chip.get = mcp23s08_get;
> @@ -314,18 +316,29 @@ static int mcp23s08_probe_one(struct spi_device *spi, unsigned addr,
>  	mcp->chip.set = mcp23s08_set;
>  	mcp->chip.dbg_show = mcp23s08_dbg_show;
>  
> -	if (type == MCP_TYPE_S17) {
> -		mcp->ops = &mcp23s17_ops;
> -		mcp->chip.ngpio = 16;
> -		mcp->chip.label = "mcp23s17";
> -	} else {
> +	switch (type) {
> +#ifdef CONFIG_SPI_MASTER
> +	case MCP_TYPE_S08:
>  		mcp->ops = &mcp23s08_ops;
>  		mcp->chip.ngpio = 8;
>  		mcp->chip.label = "mcp23s08";
> +		break;
> +
> +	case MCP_TYPE_S17:
> +		mcp->ops = &mcp23s17_ops;
> +		mcp->chip.ngpio = 16;
> +		mcp->chip.label = "mcp23s17";
> +		break;
> +#endif /* CONFIG_SPI_MASTER */
> +
> +	default:
> +		dev_err(dev, "invalid device type (%d)\n", type);
> +		return -EINVAL;
>  	}
> +
>  	mcp->chip.base = base;
>  	mcp->chip.can_sleep = 1;
> -	mcp->chip.dev = &spi->dev;
> +	mcp->chip.dev = dev;
>  	mcp->chip.owner = THIS_MODULE;
>  
>  	/* verify MCP_IOCON.SEQOP = 0, so sequential reads work,
> @@ -371,11 +384,13 @@ static int mcp23s08_probe_one(struct spi_device *spi, unsigned addr,
>  	status = gpiochip_add(&mcp->chip);
>  fail:
>  	if (status < 0)
> -		dev_dbg(&spi->dev, "can't setup chip %d, --> %d\n",
> -				addr, status);
> +		dev_dbg(dev, "can't setup chip %d, --> %d\n",
> +			addr, status);
>  	return status;
>  }
>  
> +#ifdef CONFIG_SPI_MASTER
> +
>  static int mcp23s08_probe(struct spi_device *spi)
>  {
>  	struct mcp23s08_platform_data	*pdata;
> @@ -418,7 +433,8 @@ static int mcp23s08_probe(struct spi_device *spi)
>  			continue;
>  		chips--;
>  		data->mcp[addr] = &data->chip[chips];
> -		status = mcp23s08_probe_one(spi, addr, type, base,
> +		status = mcp23s08_probe_one(data->mcp[addr], &spi->dev, spi,
> +					    0x40 | (addr << 1), type, base,
>  					    pdata->chip[addr].pullups);
>  		if (status < 0)
>  			goto fail;
> @@ -507,11 +523,21 @@ static struct spi_driver mcp23s08_driver = {
>  	},
>  };
>  
> +#endif /* CONFIG_SPI_MASTER */
> +
>  /*----------------------------------------------------------------------*/
>  
>  static int __init mcp23s08_init(void)
>  {
> -	return spi_register_driver(&mcp23s08_driver);
> +	int ret = 0;

'= 0' is redundant.

> +
> +#ifdef CONFIG_SPI_MASTER
> +	ret = spi_register_driver(&mcp23s08_driver);
> +	if (ret)
> +		return ret;
> +#endif /* CONFIG_SPI_MASTER */
> +
> +	return ret;

This change really belongs in the 3rd patch that adds the i2c
registration.

>  }
>  /* register after spi postcore initcall and before
>   * subsys initcalls that may rely on these GPIOs
> @@ -520,7 +546,10 @@ subsys_initcall(mcp23s08_init);
>  
>  static void __exit mcp23s08_exit(void)
>  {
> +#ifdef CONFIG_SPI_MASTER
>  	spi_unregister_driver(&mcp23s08_driver);
> +#endif /* CONFIG_SPI_MASTER */
> +

Extra blank line.
>  }
>  module_exit(mcp23s08_exit);
>  
> -- 
> 1.7.5.4
> 
