Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab1JRIoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:44:39 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:54030 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab1JRIoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:44:38 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9D3C76.2010008@cam.ac.uk>
Date: Tue, 18 Oct 2011 09:44:38 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, hemanthv@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] input/cma3000_d0x: Add CMA3000 spi support
References: <1318926486-10330-1-git-send-email-ricardo.ribalda@gmail.com> <1318926486-10330-5-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1318926486-10330-5-git-send-email-ricardo.ribalda@gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/11 09:28, Ricardo Ribalda Delgado wrote:
> Add support for SPI communication.
> 
Fix that cacheline issue and some tidying up and this is fine.

> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/input/misc/Kconfig           |   14 +++-
>  drivers/input/misc/Makefile          |    1 +
>  drivers/input/misc/cma3000_d0x_spi.c |  178 ++++++++++++++++++++++++++++++++++
>  3 files changed, 191 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/input/misc/cma3000_d0x_spi.c
> 
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index c9104bb..b9f2e93 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -496,8 +496,8 @@ config INPUT_CMA3000
>  	  Say Y here if you want to use VTI CMA3000_D0x Accelerometer
>  	  driver
>  
> -	  This driver currently only supports I2C interface to the
> -	  controller. Also select the I2C method.
> +	  This driver supports I2C and SPI interface to the
> +	  controller. Also select the I2C method and/or the SPI method.
>  
>  	  If unsure, say N
>  
> @@ -514,6 +514,16 @@ config INPUT_CMA3000_I2C
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called cma3000_d0x_i2c.
>  
> +config INPUT_CMA3000_SPI
> +	tristate "Support SPI bus connection"
> +	depends on INPUT_CMA3000 && SPI
> +	help
> +	  Say Y here if you want to use VTI CMA3000_D0x Accelerometer
> +	  through SPI interface.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called cma3000_d0x_spi.
> +
>  config INPUT_XEN_KBDDEV_FRONTEND
>  	tristate "Xen virtual keyboard and mouse support"
>  	depends on XEN_FBDEV_FRONTEND
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index 299ad5e..7305f6f 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -20,6 +20,7 @@ obj-$(CONFIG_INPUT_BFIN_ROTARY)		+= bfin_rotary.o
>  obj-$(CONFIG_INPUT_CM109)		+= cm109.o
>  obj-$(CONFIG_INPUT_CMA3000)		+= cma3000_d0x.o
>  obj-$(CONFIG_INPUT_CMA3000_I2C)		+= cma3000_d0x_i2c.o
> +obj-$(CONFIG_INPUT_CMA3000_SPI)		+= cma3000_d0x_spi.o
>  obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
>  obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
>  obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
> diff --git a/drivers/input/misc/cma3000_d0x_spi.c b/drivers/input/misc/cma3000_d0x_spi.c
> new file mode 100644
> index 0000000..49ad373
> --- /dev/null
> +++ b/drivers/input/misc/cma3000_d0x_spi.c
> @@ -0,0 +1,178 @@
> +/*
> + * Implements SPI interface for VTI CMA300_D0x Accelerometer driver
> + *
> + * Copyright (C) 2011 Qtechnology
> + * Author: Ricardo Ribalda <ricardo.ribalda@gmail.com.com>
> + * Based on:
You wrote a patch based on some people?  You might want to say what
was written by these two that you used.
> + *		Hemanth V <hemanthv@ti.com>
> + *		Michael Hennerich <hennerich@blackfin.uclinux.org>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/module.h>
> +#include <linux/spi/spi.h>
> +#include <linux/input/cma3000.h>
> +#include "cma3000_d0x.h"
> +
> +enum { DO_READ = 0, DO_WRITE };
> +
Looking at this function, I'd have thought it might be simpler to review
as separate read and write functions.  This is particularly true as there
are only two call sites and they are one of each so just roll it into the
set and read functions.

Passing an error message string in is also very ugly. If you want to
report errors then do it at the call sites, not in this fucntion.
Also some incorrect spacing so another case for checkpatch.
> +static int cma3000_spi_cmd(struct spi_device *spi, u8 reg, u8 * val, int cmd,
> +			   char *msg)
> +{
> +	int ret;
> +	unsigned char tx_buf[2];
> +	unsigned char rx_buf[2];
Please look up cacheline issues with spi transfers.  These need to be
dynamically assigned.  Easiest is probably just to assign the with
kmalloc right here.  Otherwise you'll need to put these buffers in an
appropriate structure being careful about alignment.
> +	struct spi_transfer t = {
> +		.rx_buf = rx_buf,
> +		.tx_buf = tx_buf,
> +		.len = 2,
> +	};
> +	struct spi_message m;
> +
> +	if (cmd == DO_WRITE) {
> +		tx_buf[0] = (reg << 2) | 2;
> +		tx_buf[1] = *val;
> +	} else {
> +		tx_buf[0] = reg << 2;
> +		tx_buf[1] = 0;
> +	}
> +	spi_message_init(&m);
> +	spi_message_add_tail(&t, &m);
> +	ret = spi_sync(spi, &m);
> +	if (ret < 0) {
> +		dev_err(&spi->dev, "%s failed (%s, %d)\n", __func__, msg, ret);
> +		return ret;
> +	}
> +	if (cmd == DO_READ)
> +		*val = rx_buf[1];
> +
> +	if (rx_buf[0] & 0xc1)
> +		dev_err(&spi->dev,
> +			"%s Invalid Zero mask(0x%x)\n", __func__, rx_buf[0]);
That's a pretty weird and cryptic error message.  Does this meant the read
failed?  If so just say that, we really don't care how it failed!
> +
> +	if ((rx_buf[0] & 0x2) != 0x2)
> +		dev_err(&spi->dev,
> +			"%s Invalid One mask (0x%x)\n", __func__, rx_buf[0]);
> + 

> +	return 0;
> +}
> +
> +static int cma3000_spi_set(struct device *dev, u8 reg, u8 val, char *msg)
> +{
> +
> +	struct spi_device *spi = to_spi_device(dev);
> +
> +	return cma3000_spi_cmd(spi, reg, &val, DO_WRITE, msg);
> +}
> +
> +static int cma3000_spi_read(struct device *dev, u8 reg, char *msg)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +	int ret;
> +	u8 val;
> +
> +	ret = cma3000_spi_cmd(spi, reg, &val, DO_READ, msg);
> +	if (ret)
> +		return ret;
> +	return val;
> +}
> +
> +static const struct cma3000_bus_ops cma3000_spi_bops = {
> +	.bustype = BUS_SPI,
> +#define CMA3000_BUSSPI     (1 << 4)
> +	.ctrl_mod = CMA3000_BUSSPI,
> +	.read = cma3000_spi_read,
> +	.write = cma3000_spi_set,
why not just call it write and match the semantics here?
> +};
> +
> +static int __devinit cma3000_spi_probe(struct spi_device *spi)
> +{
> +	struct cma3000_accl_data *data;
> +
> +	data = cma3000_init(&spi->dev, spi->irq, &cma3000_spi_bops);
> +	if (IS_ERR(data))
> +		return PTR_ERR(data);
> +
> +	spi_set_drvdata(spi, data);
> +
> +	return 0;
> +}
> +
> +static int __devexit cma3000_spi_remove(struct spi_device *spi)
> +{
> +	struct cma3000_accl_data *data = dev_get_drvdata(&spi->dev);
> +
> +	cma3000_exit(data);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int cma3000_spi_suspend(struct device *dev)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +	struct cma3000_accl_data *data = dev_get_drvdata(&spi->dev);
> +
> +	cma3000_suspend(data);
> +
> +	return 0;
> +}
> +
> +static int cma3000_spi_resume(struct device *dev)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +	struct cma3000_accl_data *data = dev_get_drvdata(&spi->dev);
> +
> +	cma3000_resume(data);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops cma3000_spi_pm_ops = {
> +	.suspend = cma3000_spi_suspend,
> +	.resume = cma3000_spi_resume,
> +};
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(cma3000_spi_pm, cma3000_spi_suspend,
> +			 cma3000_spi_resume);
> +
> +static struct spi_driver cma3000_driver = {
> +	.driver = {
> +		   .name = "cma3000_d01",
> +		   .bus = &spi_bus_type,
> +		   .owner = THIS_MODULE,
> +		   .pm = &cma3000_spi_pm,
> +		   },
> +	.probe = cma3000_spi_probe,
> +	.remove = __devexit_p(cma3000_spi_remove),
> +};
> +
> +static int __init cma3000_spi_init(void)
> +{
> +	return spi_register_driver(&cma3000_driver);
> +}
> +
> +static void __exit cma3000_spi_exit(void)
> +{
> +	spi_unregister_driver(&cma3000_driver);
> +}
> +
> +module_init(cma3000_spi_init);
> +module_exit(cma3000_spi_exit);
> +
> +MODULE_DESCRIPTION("CMA3000-D0x Accelerometer SPI Driver");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Ricardo Ribalda <ricardo.ribalda@gmail.com>");

