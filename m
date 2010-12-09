Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0LIO3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 09:29:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:55243 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab0LIO3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 09:29:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="685497264"
Date: Thu, 9 Dec 2010 15:29:12 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, dmitry.torokhov@gmail.com,
        ben-linux@fluff.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/20] mfd/ab8500: remove spi support
Message-ID: <20101209142912.GM8884@sortiz-mobl>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
 <1291388753-14662-2-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291388753-14662-2-git-send-email-sundar.iyer@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sundar,

On Fri, Dec 03, 2010 at 08:35:34PM +0530, Sundar Iyer wrote:
> Since the Ab8500 v1.0, the SPI support is deprecated on the HW.
I'm fine with that, but you really don't want to be able to support pre 1.0
devices ?

Cheers,
Samuel.


> Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
> ---
>  drivers/mfd/Kconfig      |    8 +-
>  drivers/mfd/Makefile     |    2 +-
>  drivers/mfd/ab8500-spi.c |  143 ----------------------------------------------
>  3 files changed, 5 insertions(+), 148 deletions(-)
>  delete mode 100644 drivers/mfd/ab8500-spi.c
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 3a7b891..c856aa7 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -496,13 +496,13 @@ config EZX_PCAP
>  
>  config AB8500_CORE
>  	bool "ST-Ericsson AB8500 Mixed Signal Power Management chip"
> -	depends on GENERIC_HARDIRQS && ABX500_CORE && SPI_MASTER && ARCH_U8500
> +	depends on GENERIC_HARDIRQS && ABX500_CORE && ARCH_U8500
>  	select MFD_CORE
>  	help
>  	  Select this option to enable access to AB8500 power management
> -	  chip. This connects to U8500 either on the SSP/SPI bus
> -	  or the I2C bus via PRCMU. It also adds the irq_chip
> -	  parts for handling the Mixed Signal chip events.
> +	  chip. This connects to U8500 either on the SSP/SPI bus (deprecated
> +	  since hardware version v1.0) or the I2C bus via PRCMU. It also adds
> +	  the irq_chip parts for handling the Mixed Signal chip events.
>  	  This chip embeds various other multimedia funtionalities as well.
>  
>  config AB8500_I2C_CORE
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 04a7226..67c8bcb 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -70,7 +70,7 @@ obj-$(CONFIG_ABX500_CORE)	+= abx500-core.o
>  obj-$(CONFIG_AB3100_CORE)	+= ab3100-core.o
>  obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
>  obj-$(CONFIG_AB3550_CORE)	+= ab3550-core.o
> -obj-$(CONFIG_AB8500_CORE)	+= ab8500-core.o ab8500-spi.o
> +obj-$(CONFIG_AB8500_CORE)	+= ab8500-core.o
>  obj-$(CONFIG_AB8500_I2C_CORE)	+= ab8500-i2c.o
>  obj-$(CONFIG_AB8500_DEBUG)	+= ab8500-debugfs.o
>  obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
> diff --git a/drivers/mfd/ab8500-spi.c b/drivers/mfd/ab8500-spi.c
> deleted file mode 100644
> index b165342..0000000
> --- a/drivers/mfd/ab8500-spi.c
> +++ /dev/null
> @@ -1,143 +0,0 @@
> -/*
> - * Copyright (C) ST-Ericsson SA 2010
> - *
> - * License Terms: GNU General Public License v2
> - * Author: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> - */
> -
> -#include <linux/kernel.h>
> -#include <linux/slab.h>
> -#include <linux/init.h>
> -#include <linux/module.h>
> -#include <linux/platform_device.h>
> -#include <linux/spi/spi.h>
> -#include <linux/mfd/ab8500.h>
> -
> -/*
> - * This funtion writes to any AB8500 registers using
> - * SPI protocol &  before it writes it packs the data
> - * in the below 24 bit frame format
> - *
> - *	 *|------------------------------------|
> - *	 *| 23|22...18|17.......10|9|8|7......0|
> - *	 *| r/w  bank       adr          data  |
> - *	 * ------------------------------------
> - *
> - * This function shouldn't be called from interrupt
> - * context
> - */
> -static int ab8500_spi_write(struct ab8500 *ab8500, u16 addr, u8 data)
> -{
> -	struct spi_device *spi = container_of(ab8500->dev, struct spi_device,
> -					      dev);
> -	unsigned long spi_data = addr << 10 | data;
> -	struct spi_transfer xfer;
> -	struct spi_message msg;
> -
> -	ab8500->tx_buf[0] = spi_data;
> -	ab8500->rx_buf[0] = 0;
> -
> -	xfer.tx_buf	= ab8500->tx_buf;
> -	xfer.rx_buf	= NULL;
> -	xfer.len	= sizeof(unsigned long);
> -
> -	spi_message_init(&msg);
> -	spi_message_add_tail(&xfer, &msg);
> -
> -	return spi_sync(spi, &msg);
> -}
> -
> -static int ab8500_spi_read(struct ab8500 *ab8500, u16 addr)
> -{
> -	struct spi_device *spi = container_of(ab8500->dev, struct spi_device,
> -					      dev);
> -	unsigned long spi_data = 1 << 23 | addr << 10;
> -	struct spi_transfer xfer;
> -	struct spi_message msg;
> -	int ret;
> -
> -	ab8500->tx_buf[0] = spi_data;
> -	ab8500->rx_buf[0] = 0;
> -
> -	xfer.tx_buf	= ab8500->tx_buf;
> -	xfer.rx_buf	= ab8500->rx_buf;
> -	xfer.len	= sizeof(unsigned long);
> -
> -	spi_message_init(&msg);
> -	spi_message_add_tail(&xfer, &msg);
> -
> -	ret = spi_sync(spi, &msg);
> -	if (!ret)
> -		/*
> -		 * Only the 8 lowermost bytes are
> -		 * defined with value, the rest may
> -		 * vary depending on chip/board noise.
> -		 */
> -		ret = ab8500->rx_buf[0] & 0xFFU;
> -
> -	return ret;
> -}
> -
> -static int __devinit ab8500_spi_probe(struct spi_device *spi)
> -{
> -	struct ab8500 *ab8500;
> -	int ret;
> -
> -	spi->bits_per_word = 24;
> -	ret = spi_setup(spi);
> -	if (ret < 0)
> -		return ret;
> -
> -	ab8500 = kzalloc(sizeof *ab8500, GFP_KERNEL);
> -	if (!ab8500)
> -		return -ENOMEM;
> -
> -	ab8500->dev = &spi->dev;
> -	ab8500->irq = spi->irq;
> -
> -	ab8500->read = ab8500_spi_read;
> -	ab8500->write = ab8500_spi_write;
> -
> -	spi_set_drvdata(spi, ab8500);
> -
> -	ret = ab8500_init(ab8500);
> -	if (ret)
> -		kfree(ab8500);
> -
> -	return ret;
> -}
> -
> -static int __devexit ab8500_spi_remove(struct spi_device *spi)
> -{
> -	struct ab8500 *ab8500 = spi_get_drvdata(spi);
> -
> -	ab8500_exit(ab8500);
> -	kfree(ab8500);
> -
> -	return 0;
> -}
> -
> -static struct spi_driver ab8500_spi_driver = {
> -	.driver = {
> -		.name = "ab8500-spi",
> -		.owner = THIS_MODULE,
> -	},
> -	.probe	= ab8500_spi_probe,
> -	.remove	= __devexit_p(ab8500_spi_remove)
> -};
> -
> -static int __init ab8500_spi_init(void)
> -{
> -	return spi_register_driver(&ab8500_spi_driver);
> -}
> -subsys_initcall(ab8500_spi_init);
> -
> -static void __exit ab8500_spi_exit(void)
> -{
> -	spi_unregister_driver(&ab8500_spi_driver);
> -}
> -module_exit(ab8500_spi_exit);
> -
> -MODULE_AUTHOR("Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com");
> -MODULE_DESCRIPTION("AB8500 SPI");
> -MODULE_LICENSE("GPL v2");
> -- 
> 1.7.2.dirty
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
