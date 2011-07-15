Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964942Ab1GOCy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 22:54:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60883 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964801Ab1GOCxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 22:53:31 -0400
Date: Thu, 14 Jul 2011 20:53:27 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] regmap: Add SPI bus support
Message-ID: <20110715025327.GI2927@ponder.secretlab.ca>
References: <20110709044923.GB13074@opensource.wolfsonmicro.com>
 <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310187044-13269-3-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310187044-13269-3-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 09, 2011 at 01:50:43PM +0900, Mark Brown wrote:
> We initialise at postcore_initcall() so that we are available before users
> - some users such as PMICs initialise very early. We won't actually try to
> use any of the bus until a device initialises a register map.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Acked-by: Liam Girdwood <lrg@ti.com>
> ---
>  drivers/base/regmap/Makefile     |    1 +
>  drivers/base/regmap/regmap-spi.c |   75 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 76 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/base/regmap/regmap-spi.c
> 
> diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
> index 641c20a..74c6680 100644
> --- a/drivers/base/regmap/Makefile
> +++ b/drivers/base/regmap/Makefile
> @@ -1,2 +1,3 @@
>  obj-$(CONFIG_REGMAP) += regmap.o
>  obj-$(CONFIG_I2C) += regmap-i2c.o
> +obj-$(CONFIG_SPI) += regmap-spi.o

I would think this code should live with drivers/spi.c  And similar
for the i2c implementation.

> diff --git a/drivers/base/regmap/regmap-spi.c b/drivers/base/regmap/regmap-spi.c
> new file mode 100644
> index 0000000..04328c7
> --- /dev/null
> +++ b/drivers/base/regmap/regmap-spi.c
> @@ -0,0 +1,75 @@
> +/*
> + * Register map access API - SPI support
> + *
> + * Copyright 2011 Wolfson Microelectronics plc
> + *
> + * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/regmap.h>
> +#include <linux/spi/spi.h>
> +
> +static int regmap_spi_write(struct device *dev, const void *data, size_t count)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +
> +	return spi_write(spi, data, count);
> +}
> +
> +static int regmap_spi_gather_write(struct device *dev,
> +				   const void *reg, size_t reg_len,
> +				   const void *val, size_t val_len)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +	struct spi_message m;
> +	struct spi_transfer t[2];
> +
> +	spi_message_init(&m);
> +
> +	memset(&t, 0, sizeof(t));

If you do:

	struct spi_transfer t[2] = { {.tx_buf = reg, .len = reg_len},
				     {.tx_buf = val, .len = val_len}};

Then the memset() and t[0]/t[1] lines can all be culled.

> +
> +	t[0].tx_buf = reg;
> +	t[0].len = reg_len;
> +	spi_message_add_tail(&t[0], &m);
> +
> +	t[1].tx_buf = val;
> +	t[1].len = val_len;
> +	spi_message_add_tail(&t[0], &m);

t[0]?

> +
> +	return spi_sync(spi, &m);
> +}
> +
> +static int regmap_spi_read(struct device *dev,
> +			   const void *reg, size_t reg_size,
> +			   void *val, size_t val_size)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +
> +	return spi_write_then_read(spi, reg, reg_size, val, val_size);

... of course, after looking at this function, maybe it would be
better to just add a spi_write_then_write() helper.  :-)

> +}
> +
> +static struct regmap_bus regmap_spi = {
> +	.type = &spi_bus_type,
> +	.write = regmap_spi_write,
> +	.gather_write = regmap_spi_gather_write,
> +	.read = regmap_spi_read,
> +	.owner = THIS_MODULE,
> +	.read_flag_mask = 0x80,
> +};
> +
> +static int __init regmap_spi_init(void)
> +{
> +	regmap_add_bus(&regmap_spi);
> +	return 0;
> +}
> +postcore_initcall(regmap_spi_init);
> +
> +static void __exit regmap_spi_exit(void)
> +{
> +	regmap_del_bus(&regmap_spi);
> +}
> +module_exit(regmap_spi_exit);
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
