Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab1JRNO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:14:59 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:58695 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669Ab1JRNO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:14:57 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9D7BD2.8090101@cam.ac.uk>
Date: Tue, 18 Oct 2011 14:14:58 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, hemanthv@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 4/7] input/cma3000_d0x: Add CMA3000 spi support
References: <1318939596-27330-1-git-send-email-ricardo.ribalda@gmail.com> <1318939596-27330-5-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1318939596-27330-5-git-send-email-ricardo.ribalda@gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/11 13:06, Ricardo Ribalda Delgado wrote:
> Add support for SPI communication.
> 
> ---

Hi Ricardo.

Nice fast response ;)

Can you either put a clear arguement in for why those zero and one
mask checks in the cmd function make sense, or drop them and move
to the much shorter / cleaner functions I suggest below.

Jonathan
> 
> v2: Fixes suggested by Jonathan Cameron
> 	-Add filename to based on header
> 	-Rename set with write
> 	-Set spi buffers as cache aligned
> 	-Code Style
> 
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
interfaces
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
> index 0000000..1487ecf
> --- /dev/null
> +++ b/drivers/input/misc/cma3000_d0x_spi.c
> @@ -0,0 +1,178 @@
> +/*
> + * Implements SPI interface for VTI CMA300_D0x Accelerometer driver
> + *
> + * Copyright (C) 2011 Qtechnology
> + * Author: Ricardo Ribalda <ricardo.ribalda@gmail.com.com>
> + * Based on:
> + *	drivers/input/misc/cma3000_d0x_i2c.c by Hemanth V
> + *	drivers/input/mis/adxl34x-spi.c	by Michael Hennerich
mis->misc
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
no space after * before val
> +static int cma3000_spi_cmd(struct spi_device *spi, u8 reg, u8 * val, int cmd,
> +			   char *msg)
> +{
> +	int ret;
> +	unsigned char tx_buf[2] ____cacheline_aligned;
> +	unsigned char rx_buf[2] ____cacheline_aligned;
Doesn't work (at least I'm fairly sure it doesn't).
These must be dynamically assigned.

To make my point about these functions being more complex than needed
in more detail....

If this were two functions and you drop the zero and 1 mask
(which I'm not convinced make any sense. I've also killed the message.
We both agree it is the wrong way to go, so post a patch fixing the i2c
interface as well.

static int cma3000_spi_write(struct spi_device *spi, u8 reg, u8 *val, int cmd)
{
	int ret;
	u8 *tx = kmalloc(2, GFP_KERNEL);
	if (tx == NULL)
	   return -ENOMEM;
	tx[0] = (reg << 2) | 2;
	tx[1] = *val;
	ret = spi_write(spi, rx, 2);
	kfree(tx);
	return ret;
}

static int cma3000_spi_read(struct spi_device *spi, u8 reg, u8 *val, int cmd)
{
	return spi_w8r8(spi, reg, val);	
}


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
These are still cryptic to any user who sees them.  Have you ever seen this
occur?  Seems a pretty unlikely bus screw up to me...
> +
> +	if ((rx_buf[0] & 0x2) != 0x2)
> +		dev_err(&spi->dev,
> +			"%s Invalid One mask (0x%x)\n", __func__, rx_buf[0]);
Also, does this every actually happen. I am not a great fan of VTI data sheets
but I think this only occurs at power up?  Could we verify this explicitly once
then ignore?  It makes for a lot cleaner code as seen above.
> +
> +	return 0;
> +}
> +
> +static int cma3000_spi_write(struct device *dev, u8 reg, u8 val, char *msg)
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
Obviously, if I have convinced you of the advantage of splitting read and
write it would make sense to roll these into these two wrapper functions.
Handling the error message out here is also cleaner than pushing it on
down anyway.
> +
> +static const struct cma3000_bus_ops cma3000_spi_bops = {
> +	.bustype = BUS_SPI,
> +#define CMA3000_BUSSPI     (1 << 4)
> +	.ctrl_mod = CMA3000_BUSSPI,
> +	.read = cma3000_spi_read,
> +	.write = cma3000_spi_write,
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

