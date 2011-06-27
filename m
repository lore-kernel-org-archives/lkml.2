Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab1F0WZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 18:25:32 -0400
Received: from cpc7-stkp7-2-0-cust918.10-2.cable.virginmedia.com ([86.22.251.151]:49794
	"EHLO freya" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755166Ab1F0WYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 18:24:23 -0400
X-Greylist: delayed 1494 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jun 2011 18:24:23 EDT
Date: Mon, 27 Jun 2011 22:59:55 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        khali@linux-fr.org, ben-linux@fluff.org,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Subject: Re: [PATCH] i2c: add Faraday FTIIC010 I2C controller support
Message-ID: <20110627215955.GA23027@freya.fluff.org>
References: <1308032369-1615-1-git-send-email-ratbert.chuang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308032369-1615-1-git-send-email-ratbert.chuang@gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 02:19:29PM +0800, Po-Yu Chuang wrote:
> From: Po-Yu Chuang <ratbert@faraday-tech.com>
> 
> Support for Faraday FTIIC010 I2C controller. It is used on
> Faraday A320, A369 and some other ARM SoC's.
> 
> Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
> ---
>  drivers/i2c/busses/Kconfig        |    7 +
>  drivers/i2c/busses/Makefile       |    1 +
>  drivers/i2c/busses/i2c-ftiic010.c |  434 +++++++++++++++++++++++++++++++++++++
>  drivers/i2c/busses/i2c-ftiic010.h |  155 +++++++++++++
>  4 files changed, 597 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/i2c/busses/i2c-ftiic010.c
>  create mode 100644 drivers/i2c/busses/i2c-ftiic010.h
> 
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 326652f..612c2b1 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -358,6 +358,13 @@ config I2C_DESIGNWARE
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called i2c-designware.
>  
> +config I2C_FTIIC010
> +	tristate "Faraday FTIIC010 I2C controller"
> +	depends on HAVE_CLK
> +	help
> +	  Support for Faraday FTIIC010 I2C controller. It is used on
> +	  Faraday A320, A369 and some other ARM SoC's.
> +

is there a better depends line for this? is there an ARCH_xxx or some
other way of ensuring this doesn't get shown for all systems that
happen to support CLK?

>  config I2C_GPIO
>  	tristate "GPIO-based bitbanging I2C"
>  	depends on GENERIC_GPIO
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index e6cf294..c49570d 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -34,6 +34,7 @@ obj-$(CONFIG_I2C_BLACKFIN_TWI)	+= i2c-bfin-twi.o
>  obj-$(CONFIG_I2C_CPM)		+= i2c-cpm.o
>  obj-$(CONFIG_I2C_DAVINCI)	+= i2c-davinci.o
>  obj-$(CONFIG_I2C_DESIGNWARE)	+= i2c-designware.o
> +obj-$(CONFIG_I2C_FTIIC010)	+= i2c-ftiic010.o
>  obj-$(CONFIG_I2C_GPIO)		+= i2c-gpio.o
>  obj-$(CONFIG_I2C_HIGHLANDER)	+= i2c-highlander.o
>  obj-$(CONFIG_I2C_IBM_IIC)	+= i2c-ibm_iic.o
> diff --git a/drivers/i2c/busses/i2c-ftiic010.c b/drivers/i2c/busses/i2c-ftiic010.c
> new file mode 100644
> index 0000000..ed86f06
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-ftiic010.c
> @@ -0,0 +1,434 @@
> +/*
> + * Faraday FTIIC010 I2C Controller
> + *
> + * (C) Copyright 2010-2011 Faraday Technology
> + * Po-Yu Chuang <ratbert@faraday-tech.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +
> +#include "i2c-ftiic010.h"
> +
> +#define SCL_SPEED	(100 * 1000)
> +#define MAX_RETRY	1000
> +
> +#define GSR	5
> +#define TSR	5
> +
> +struct ftiic010 {
> +	struct resource *res;
> +	void __iomem *base;
> +	int irq;
> +	struct clk *clk;
> +	struct i2c_adapter adapter;
> +};
> +
> +/******************************************************************************
> + * internal functions
> + *****************************************************************************/
> +static void ftiic010_reset(struct ftiic010 *ftiic010)
> +{
> +	int cr = FTIIC010_CR_I2C_RST;
> +
> +	iowrite32(cr, ftiic010->base + FTIIC010_OFFSET_CR);
> +
> +	/* wait until reset bit cleared by hw */
> +	while (ioread32(ftiic010->base + FTIIC010_OFFSET_CR) & FTIIC010_CR_I2C_RST)
> +		;

how about calls to cpu_relax() during these loops?
also, do we ever expect timeout?

> +}


I think iowrite32/ioread32 are ok on these.


> +
> +static void ftiic010_set_clock_speed(struct ftiic010 *ftiic010, int hz)
> +{
> +	unsigned long pclk;
> +	int cdr;
> +
> +	pclk = clk_get_rate(ftiic010->clk);
> +
> +	cdr = (pclk / hz - GSR) / 2 - 2;
> +	cdr &= FTIIC010_CDR_MASK;
> +
> +	dev_dbg(&ftiic010->adapter.dev, "  [CDR] = %08x\n", cdr);
> +	iowrite32(cdr, ftiic010->base + FTIIC010_OFFSET_CDR);
> +}
> +
> +static void ftiic010_set_tgsr(struct ftiic010 *ftiic010, int tsr, int gsr)
> +{
> +	int tgsr;
> +
> +	tgsr = FTIIC010_TGSR_TSR(tsr);
> +	tgsr |= FTIIC010_TGSR_GSR(gsr);
> +
> +	dev_dbg(&ftiic010->adapter.dev, "  [TGSR] = %08x\n", tgsr);
> +	iowrite32(tgsr, ftiic010->base + FTIIC010_OFFSET_TGSR);
> +}
> +
> +static void ftiic010_hw_init(struct ftiic010 *ftiic010)
> +{
> +	ftiic010_reset(ftiic010);
> +	ftiic010_set_tgsr(ftiic010, TSR, GSR);
> +	ftiic010_set_clock_speed(ftiic010, SCL_SPEED);
> +}
> +
> +static inline void ftiic010_set_cr(struct ftiic010 *ftiic010, int start,
> +		int stop, int nak)
> +{
> +	int cr;
> +
> +	cr = FTIIC010_CR_I2C_EN
> +	   | FTIIC010_CR_SCL_EN
> +	   | FTIIC010_CR_TB_EN
> +	   | FTIIC010_CR_BERRI_EN
> +	   | FTIIC010_CR_ALI_EN;
> +
> +	if (start)
> +		cr |= FTIIC010_CR_START;
> +
> +	if (stop)
> +		cr |= FTIIC010_CR_STOP;
> +
> +	if (nak)
> +		cr |= FTIIC010_CR_NAK;
> +
> +	iowrite32(cr, ftiic010->base + FTIIC010_OFFSET_CR);
> +}
> +
> +static int ftiic010_tx_byte(struct ftiic010 *ftiic010, __u8 data, int start,
> +		int stop)
> +{
> +	struct i2c_adapter *adapter = &ftiic010->adapter;
> +	int i;
> +
> +	iowrite32(data, ftiic010->base + FTIIC010_OFFSET_DR);
> +	ftiic010_set_cr(ftiic010, start, stop, 0);
> +
> +	for (i = 0; i < MAX_RETRY; i++) {
> +		unsigned int status;
> +
> +		status = ioread32(ftiic010->base + FTIIC010_OFFSET_SR);
> +		if (status & FTIIC010_SR_DT)
> +			return 0;
> +
> +		udelay(1);
> +	}
> +
> +	dev_err(&adapter->dev, "Failed to transmit\n");
> +	ftiic010_reset(ftiic010);
> +	return -EIO;
> +}
> +
> +static int ftiic010_rx_byte(struct ftiic010 *ftiic010, int stop, int nak)
> +{
> +	struct i2c_adapter *adapter = &ftiic010->adapter;
> +	int i;
> +
> +	ftiic010_set_cr(ftiic010, 0, stop, nak);
> +
> +	for (i = 0; i < MAX_RETRY; i++) {
> +		unsigned int status;
> +
> +		status = ioread32(ftiic010->base + FTIIC010_OFFSET_SR);
> +		if (status & FTIIC010_SR_DR) {
> +			return ioread32(ftiic010->base + FTIIC010_OFFSET_DR)
> +				& FTIIC010_DR_MASK;
> +		}
> +
> +		udelay(1);
> +	}
> +
> +	dev_err(&adapter->dev, "Failed to receive\n");
> +	ftiic010_reset(ftiic010);
> +	return -EIO;
> +}
> +
> +static int ftiic010_tx_msg(struct ftiic010 *ftiic010,
> +		struct i2c_msg *msg, int last)
> +{
> +	__u8 data;
> +	int ret;
> +	int i;
> +
> +	data = (msg->addr & 0x7f) << 1;
> +	ret = ftiic010_tx_byte(ftiic010, data, 1, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	for (i = 0; i < msg->len; i++) {
> +		int stop = 0;
> +
> +		if (last && i + 1 == msg->len)
> +			stop = 1;
> +
> +		ret = ftiic010_tx_byte(ftiic010, msg->buf[i], 0, stop);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ftiic010_rx_msg(struct ftiic010 *ftiic010,
> +		struct i2c_msg *msg, int last)
> +{
> +	__u8 data;
> +	int ret;
> +	int i;
> +
> +	data = (msg->addr & 0x7f) << 1 | 1;
> +	ret = ftiic010_tx_byte(ftiic010, data, 1, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	for (i = 0; i < msg->len; i++) {
> +		int nak = 0;
> +
> +		if (i + 1 == msg->len)
> +			nak = 1;
> +
> +		ret = ftiic010_rx_byte(ftiic010, last, nak);
> +		if (ret < 0)
> +			return ret;
> +
> +		msg->buf[i] = ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ftiic010_do_msg(struct ftiic010 *ftiic010,
> +		struct i2c_msg *msg, int last)
> +{
> +	if (msg->flags & I2C_M_RD)
> +		return ftiic010_rx_msg(ftiic010, msg, last);
> +	else
> +		return ftiic010_tx_msg(ftiic010, msg, last);
> +}

maybe this could be merged into the parent.

is there any way of using the interrupt handler to do the
actual transfers, this seems to involve a lot of busy-waiting
for the hardware.

> +/******************************************************************************
> + * interrupt handler
> + *****************************************************************************/
> +static irqreturn_t ftiic010_interrupt(int irq, void *dev_id)
> +{
> +	struct ftiic010 *ftiic010 = dev_id;
> +	struct i2c_adapter *adapter = &ftiic010->adapter;
> +	int sr;
> +
> +	sr = ioread32(ftiic010->base + FTIIC010_OFFSET_SR);
> +
> +	if (sr & FTIIC010_SR_BERR) {
> +		dev_err(&adapter->dev, "NAK!\n");
> +		ftiic010_reset(ftiic010);
> +	}
> +
> +	if (sr & FTIIC010_SR_AL) {
> +		dev_err(&adapter->dev, "arbitration lost!\n");
> +		ftiic010_reset(ftiic010);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/******************************************************************************
> + * struct i2c_algorithm functions
> + *****************************************************************************/
> +static int ftiic010_master_xfer(struct i2c_adapter *adapter,
> +		struct i2c_msg *msgs, int num)
> +{
> +	struct ftiic010 *ftiic010 = i2c_get_adapdata(adapter);
> +	int i;
> +
> +	for (i = 0; i < num; i++) {
> +		int last = 0;
> +		int ret;
> +
> +		if (i == num - 1)
> +			last = 1;
> +
> +		ret = ftiic010_do_msg(ftiic010, &msgs[i], last);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return num;
> +}
> +
> +static u32 ftiic010_functionality(struct i2c_adapter *adapter)
> +{
> +	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
> +}
> +
> +static struct i2c_algorithm ftiic010_algorithm = {
> +	.master_xfer	= ftiic010_master_xfer,
> +	.functionality	= ftiic010_functionality,
> +};
> +
> +/******************************************************************************
> + * struct platform_driver functions
> + *****************************************************************************/
> +static int ftiic010_probe(struct platform_device *pdev)
> +{
> +	struct ftiic010 *ftiic010;
> +	struct resource *res;
> +	struct clk *clk;
> +	int irq;
> +	int ret;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENXIO;

error message, -ENXIO IIRC gets silently discarded by the bus
layer.

> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0)
> +		return irq;

error print would be useful.

> +	ftiic010 = kzalloc(sizeof(*ftiic010), GFP_KERNEL);
> +	if (!ftiic010) {
> +		dev_err(&pdev->dev, "Could not allocate private data\n");
> +		ret = -ENOMEM;
> +		goto err_alloc;
> +	}
> +
> +	ftiic010->res = request_mem_region(res->start, resource_size(res),
> +					   dev_name(&pdev->dev));
> +	if (!ftiic010->res) {
> +		dev_err(&pdev->dev, "Could not reserve memory region\n");
> +		ret = -ENOMEM;
> +		goto err_req_mem;
> +	}
> +
> +	ftiic010->base = ioremap(res->start, resource_size(res));
> +	if (!ftiic010->base) {
> +		dev_err(&pdev->dev, "Failed to ioremap\n");
> +		ret = -ENOMEM;
> +		goto err_ioremap;
> +	}
> +
> +	ret = request_irq(irq, ftiic010_interrupt, IRQF_SHARED, pdev->name,
> +			  ftiic010);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to request irq %d\n", irq);
> +		goto err_req_irq;
> +	}
> +
> +	ftiic010->irq = irq;
> +
> +	clk = clk_get(NULL, "pclk");
> +	if (!clk) {
> +		dev_err(&pdev->dev, "Failed to get pclk\n");
> +		goto err_clk;
> +	}

do you really need a named clock? sounds like the clk_ usage on
this platform needs some work to it.

> +	clk_enable(clk);
> +	ftiic010->clk = clk;
> +
> +	/*
> +	 * initialize i2c adapter
> +	 */
> +	ftiic010->adapter.owner		= THIS_MODULE;
> +	ftiic010->adapter.algo		= &ftiic010_algorithm;
> +	ftiic010->adapter.timeout	= 1;
> +	ftiic010->adapter.dev.parent	= &pdev->dev;
> +
> +	/*
> +	 * If "dev->id" is negative we consider it as zero.
> +	 * The reason to do so is to avoid sysfs names that only make
> +	 * sense when there are multiple adapters.
> +	 */
> +	ftiic010->adapter.nr		= pdev->id != -1 ? pdev->id : 0;
> +	strcpy(ftiic010->adapter.name, "ftiic010 adapter");
> +
> +	i2c_set_adapdata(&ftiic010->adapter, ftiic010);
> +
> +	ftiic010_hw_init(ftiic010);
> +
> +	ret = i2c_add_numbered_adapter(&ftiic010->adapter);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to add i2c adapter\n");
> +		goto err_add_adapter;
> +	}
> +
> +	platform_set_drvdata(pdev, ftiic010);
> +
> +	dev_info(&pdev->dev, "irq %d, mapped at %p\n", irq, ftiic010->base);
> +
> +	return 0;
> +
> +err_add_adapter:
> +	clk_disable(clk);
> +	clk_put(clk);
> +err_clk:
> +	free_irq(ftiic010->irq, ftiic010);
> +err_req_irq:
> +	iounmap(ftiic010->base);
> +err_ioremap:
> +	release_resource(ftiic010->res);
> +err_req_mem:
> +	kfree(ftiic010);
> +err_alloc:
> +	return ret;
> +};
> +
> +static int __devexit ftiic010_remove(struct platform_device *pdev)
> +{
> +	struct ftiic010 *ftiic010 = platform_get_drvdata(pdev);
> +
> +	platform_set_drvdata(pdev, NULL);
> +	i2c_del_adapter(&ftiic010->adapter);
> +	clk_disable(ftiic010->clk);
> +	clk_put(ftiic010->clk);
> +	free_irq(ftiic010->irq, ftiic010);
> +	iounmap(ftiic010->base);
> +	release_resource(ftiic010->res);
> +	kfree(ftiic010);
> +	return 0;
> +};
> +
> +
> +static struct platform_driver ftiic010_driver = {
> +	.probe		= ftiic010_probe,
> +	.remove		= __devexit_p(ftiic010_remove),
> +	.driver		= {
> +		.name	= "ftiic010",
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +/******************************************************************************
> + * initialization / finalization
> + *****************************************************************************/
> +static int __init ftiic010_init(void)
> +{
> +	return platform_driver_register(&ftiic010_driver);
> +}
> +
> +static void __exit ftiic010_exit(void)
> +{
> +	platform_driver_unregister(&ftiic010_driver);
> +}
> +
> +module_init(ftiic010_init);
> +module_exit(ftiic010_exit);
> +
> +MODULE_AUTHOR("Po-Yu Chuang <ratbert@faraday-tech.com>");
> +MODULE_DESCRIPTION("FTIIC010 I2C bus adapter");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/i2c/busses/i2c-ftiic010.h b/drivers/i2c/busses/i2c-ftiic010.h
> new file mode 100644
> index 0000000..c1f4752
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-ftiic010.h
> @@ -0,0 +1,155 @@
> +/*
> + * Faraday FTIIC010 I2C Controller
> + *
> + * (C) Copyright 2010-2011 Faraday Technology
> + * Po-Yu Chuang <ratbert@faraday-tech.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef __FTIIC010_H
> +#define __FTIIC010_H
> +
> +#define FTIIC010_OFFSET_CR	0x00
> +#define FTIIC010_OFFSET_SR	0x04
> +#define FTIIC010_OFFSET_CDR	0x08
> +#define FTIIC010_OFFSET_DR	0x0c
> +#define FTIIC010_OFFSET_SAR	0x10
> +#define FTIIC010_OFFSET_TGSR	0x14
> +#define FTIIC010_OFFSET_BMR	0x18
> +#define FTIIC010_OFFSET_SMCR	0x1c
> +#define FTIIC010_OFFSET_MAXTR	0x20
> +#define FTIIC010_OFFSET_MINTR	0x24
> +#define FTIIC010_OFFSET_METR	0x28
> +#define FTIIC010_OFFSET_SETR	0x2c
> +#define FTIIC010_OFFSET_REV	0x30
> +#define FTIIC010_OFFSET_FEAT	0x34
> +
> +/*
> + * Control Register
> + */
> +#define FTIIC010_CR_I2C_RST	(1 << 0)
> +#define FTIIC010_CR_I2C_EN	(1 << 1)
> +#define FTIIC010_CR_SCL_EN	(1 << 2)
> +#define FTIIC010_CR_GC_EN	(1 << 3)
> +#define FTIIC010_CR_START	(1 << 4)
> +#define FTIIC010_CR_STOP	(1 << 5)
> +#define FTIIC010_CR_NAK		(1 << 6)
> +#define FTIIC010_CR_TB_EN	(1 << 7)
> +#define FTIIC010_CR_DTI_EN	(1 << 8)
> +#define FTIIC010_CR_DRI_EN	(1 << 9)
> +#define FTIIC010_CR_BERRI_EN	(1 << 10)
> +#define FTIIC010_CR_STOPI_EN	(1 << 11)
> +#define FTIIC010_CR_SAMI_EN	(1 << 12)
> +#define FTIIC010_CR_ALI_EN	(1 << 13)	/* arbitration lost */
> +#define FTIIC010_CR_STARTI_EN	(1 << 14)
> +#define FTIIC010_CR_SCL_LOW	(1 << 15)
> +#define FTIIC010_CR_SDA_LOW	(1 << 16)
> +#define FTIIC010_CR_TESTMODE	(1 << 17)
> +
> +/*
> + * Status Register
> + */
> +#define FTIIC010_SR_RW		(1 << 0)
> +#define FTIIC010_SR_ACK		(1 << 1)
> +#define FTIIC010_SR_I2CBUSY	(1 << 2)
> +#define FTIIC010_SR_BUSBUSY	(1 << 3)
> +#define FTIIC010_SR_DT		(1 << 4)
> +#define FTIIC010_SR_DR		(1 << 5)
> +#define FTIIC010_SR_BERR	(1 << 6)
> +#define FTIIC010_SR_STOP	(1 << 7)
> +#define FTIIC010_SR_SAM		(1 << 8)
> +#define FTIIC010_SR_GC		(1 << 9)
> +#define FTIIC010_SR_AL		(1 << 10)
> +#define FTIIC010_SR_START	(1 << 11)
> +#define FTIIC010_SR_SEXT	(1 << 12)
> +#define FTIIC010_SR_MEXT	(1 << 13)
> +#define FTIIC010_SR_MINTIMEOUT	(1 << 14)
> +#define FTIIC010_SR_MAXTIMEOUT	(1 << 15)
> +#define FTIIC010_SR_ALERT	(1 << 16)
> +#define FTIIC010_SR_SUSPEND	(1 << 17)
> +#define FTIIC010_SR_RESUME	(1 << 18)
> +#define FTIIC010_SR_ARA		(1 << 19)
> +#define FTIIC010_SR_DDA		(1 << 20)
> +#define FTIIC010_SR_SAL		(1 << 21)
> +
> +/*
> + * Clock Division Register
> + */
> +#define FTIIC010_CDR_MASK	0x3ffff
> +
> +/*
> + * Data Register
> + */
> +#define FTIIC010_DR_MASK	0xff
> +
> +/*
> + * Slave Address Register
> + */
> +#define FTIIC010_SAR_MASK	0x3ff
> +#define FTIIC010_SAR_EN10	(1 << 31)
> +
> +/*
> + * Set/Hold Time Glitch Suppression Setting Register
> + */
> +#define FTIIC010_TGSR_TSR(x)	((x) & 0x3ff)	/* should not be zero */
> +#define FTIIC010_TGSR_GSR(x)	(((x) & 0x7) << 10)
> +
> +/*
> + * Bus Monitor Register
> + */
> +#define FTIIC010_BMR_SDA_IN	(1 << 0)
> +#define FTIIC010_BMR_SCL_IN	(1 << 1)
> +
> +/*
> + * SM Control Register
> + */
> +#define FTIIC010_SMCR_SEXT_EN	(1 << 0)
> +#define FTIIC010_SMCR_MEXT_EN	(1 << 1)
> +#define FTIIC010_SMCR_TOUT_EN	(1 << 2)
> +#define FTIIC010_SMCR_ALERT_EN	(1 << 3)
> +#define FTIIC010_SMCR_SUS_EN	(1 << 4)
> +#define FTIIC010_SMCR_RSM_EN	(1 << 5)
> +#define FTIIC010_SMCR_SAL_EN	(1 << 8)
> +#define FTIIC010_SMCR_ALERT_LOW	(1 << 9)
> +#define FTIIC010_SMCR_SUS_LOW	(1 << 10)
> +#define FTIIC010_SMCR_SUSOUT_EN	(1 << 11)
> +
> +/*
> + * SM Maximum Timeout Register
> + */
> +#define FTIIC010_MAXTR_MASK	0x3fffff
> +
> +/*
> + * SM Minimum Timeout Register
> + */
> +#define FTIIC010_MINTR_MASK	0x3fffff
> +
> +/*
> + * SM Master Extend Time Register
> + */
> +#define FTIIC010_METR_MASK	0xfffff
> +
> +/*
> + * SM Slave Extend Time Register
> + */
> +#define FTIIC010_SETR_MASK	0x1fffff
> +
> +/*
> + * Feature Register
> + */
> +#define FTIIC010_FEAT_SMBUS	(1 << 0)
> +
> +#endif /* __FTIIC010_H */
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
