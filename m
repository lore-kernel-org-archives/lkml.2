Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab1KHWvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 17:51:04 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36803 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1KHWvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 17:51:01 -0500
Message-ID: <4EB9B24A.5040809@gmail.com>
Date: Wed, 09 Nov 2011 09:50:50 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Nikolaus Voss <n.voss@weinmann.de>
CC: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org, khali@linux-fr.org,
        nicolas.ferre@atmel.com, balbi@ti.com
Subject: Re: [PATCH V3 2/4] drivers/i2c/busses/i2c-at91.c: add new driver
References: <cover.1320753142.git.n.voss@weinmann.de> <7bdd6b456b0e055441cb25634c8cb6d483718f6c.1320753142.git.n.voss@weinmann.de>
In-Reply-To: <7bdd6b456b0e055441cb25634c8cb6d483718f6c.1320753142.git.n.voss@weinmann.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/11 21:49, Nikolaus Voss wrote:

> This driver has the following properties compared to the old driver:
> 1. Support for multiple interfaces.
> 2. Interrupt driven I/O as opposed to polling/busy waiting.
> 3. Support for _one_ repeated start (Sr) condition, which is enough
>    for most real-world applications including all SMBus transfer types.
>    (The hardware does not support issuing arbitrary Sr conditions on the
>     bus.)
> 
> Tested on Atmel G45 with BQ20Z80 battery SMBus client.


Hi Nikolaus. Few more review comments below.

~Ryan

> 
> Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
> ---
>  drivers/i2c/busses/Kconfig    |   11 +-
>  drivers/i2c/busses/i2c-at91.c |  442 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 446 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/i2c/busses/i2c-at91.c
> 
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 646068e..c4b6bdc 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -286,18 +286,15 @@ comment "I2C system bus drivers (mostly embedded / system-on-chip)"
>  
>  config I2C_AT91
>  	tristate "Atmel AT91 I2C Two-Wire interface (TWI)"
> -	depends on ARCH_AT91 && EXPERIMENTAL && BROKEN
> +	depends on ARCH_AT91 && EXPERIMENTAL
>  	help
>  	  This supports the use of the I2C interface on Atmel AT91
>  	  processors.
>  
> -	  This driver is BROKEN because the controller which it uses
> -	  will easily trigger RX overrun and TX underrun errors.  Using
> -	  low I2C clock rates may partially work around those issues
> -	  on some systems.  Another serious problem is that there is no
> -	  documented way to issue repeated START conditions, as needed
> +	  A serious problem is that there is no documented way to issue
> +	  repeated START conditions for more than two messages, as needed
>  	  to support combined I2C messages.  Use the i2c-gpio driver
> -	  unless your system can cope with those limitations.
> +	  unless your system can cope with this limitation.
>  
>  config I2C_AU1550
>  	tristate "Au1550/Au1200 SMBus interface"
> diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
> new file mode 100644
> index 0000000..e35479b
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-at91.c
> @@ -0,0 +1,442 @@
> +/*
> +
> +    i2c Support for Atmel's AT91 Two-Wire Interface (TWI)
> +
> +    Copyright (C) 2011 Nikolaus Voss <n.voss@weinmann.de>
> +
> +    Evolved from original work by:
> +    Copyright (C) 2004 Rick Bronson
> +    Converted to 2.6 by Andrew Victor <andrew@sanpeople.com>
> +
> +    Borrowed heavily from original work by:
> +    Copyright (C) 2000 Philip Edelbrock <phil@stimpy.netroedge.com>
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +*/
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/err.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/i2c.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/clk.h>
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +
> +#include <mach/at91_twi.h>


This include file looks like it only contains register definitions which
are used in this file. Would be good to either move them directly into
this driver or move the header file to this directory and make it a
local include.

> +#include <mach/board.h>
> +#include <mach/cpu.h>
> +
> +#define TWI_CLOCK		100000		/* Hz. max 400 Kbits/sec */
> +#define AT91_I2C_TIMEOUT	(HZ/100)	/* transfer timeout */


There is the msecs_to_jiffies function which can make timeouts more
clearly readable. YMMV.

> +
> +struct at91_twi_dev {
> +	struct device *dev;
> +	void __iomem *base;
> +	struct completion cmd_complete;
> +	struct clk *clk;
> +	u8 *buf;
> +	size_t buf_len;
> +	int irq;
> +	unsigned transfer_status;
> +	struct i2c_adapter adapter;
> +};


Nitpick: Tab aligning struct fields makes them a bit more readable.

> +
> +static inline unsigned at91_twi_read(struct at91_twi_dev *dev, unsigned reg)
> +{
> +	return __raw_readl(dev->base + (reg));
> +}


It probably doesn't matter here, but there is a general push to remove
inline from functions since the compiler is smart enough to inline
functions like this itself.

You also don't need the additional parens around reg now that this is a
proper function. Same in the other functions which have been converted
from macros.

> +
> +static inline void at91_twi_write(struct at91_twi_dev *dev, unsigned reg,
> +				  unsigned val)
> +{
> +	__raw_writel((val), dev->base + (reg));
> +}
> +
> +static inline void at91_disable_twi_interrupts(struct at91_twi_dev *dev)
> +{
> +	at91_twi_write(dev, AT91_TWI_IDR,
> +		       AT91_TWI_TXCOMP | AT91_TWI_RXRDY | AT91_TWI_TXRDY);
> +}
> +
> +static void at91_init_twi_bus(struct at91_twi_dev *dev)
> +{
> +	at91_disable_twi_interrupts(dev);
> +	at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_SWRST);
> +	at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_MSEN);
> +	at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_SVDIS);
> +}
> +
> +static void at91_set_twi_clock(struct at91_twi_dev *dev)
> +{
> +	unsigned long cdiv, ckdiv;
> +
> +	/* Calcuate clock dividers */
> +	cdiv = (clk_get_rate(dev->clk) / (2 * TWI_CLOCK)) - 3;
> +	cdiv = cdiv + 1;	/* round up */


	/* Calculate clock dividers - rounded up */
	cdiv = ((clk_get_rate(dev->clk) / (2 * TWI_CLOCK)) - 3) + 1;

	?

> +	ckdiv = 0;
> +	while (cdiv > 255) {
> +		ckdiv++;
> +		cdiv = cdiv >> 1;
> +	}
> +
> +	if (cpu_is_at91rm9200()) {			/* AT91RM9200 Errata #22 */
> +		if (ckdiv > 5) {


	if (cpu_is_at91rm9200() && clkdiv > 5) {

> +			printk(KERN_ERR "AT91 I2C: Invalid TWI_CLOCK value!\n");


	dev_err(dev->dev, "AT91RM9200 Errata #22: Invalid clock value - using
cldiv = 5\n");

> +			ckdiv = 5;
> +		}
> +	}
> +
> +	at91_twi_write(dev, AT91_TWI_CWGR, (ckdiv << 16) | (cdiv << 8) | cdiv);
> +}
> +
> +static void __devinit at91_twi_hwinit(struct at91_twi_dev *dev)
> +{
> +	at91_init_twi_bus(dev);
> +	at91_set_twi_clock(dev);
> +}
> +
> +static void at91_twi_write_next_byte(struct at91_twi_dev *dev)
> +{
> +	if (dev->buf_len > 0) {
> +
> +		const u8 c = *(dev->buf++);
> +
> +		at91_twi_write(dev, AT91_TWI_THR, c);
> +


Don't need all the blank lines here. Also, is there are reason to use
the temporary variable c and not put the buf dereference into the the
at91_twi_write call?

> +		/* send stop when last byte has been written */
> +		if (--dev->buf_len == 0)
> +			at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_STOP);
> +
> +		dev_dbg(dev->dev, "wrote 0x%x, to go %d\n", c, dev->buf_len);
> +	}
> +}
> +
> +static void at91_twi_read_next_byte(struct at91_twi_dev *dev)
> +{
> +	const u8 c = at91_twi_read(dev, AT91_TWI_RHR) & 0xff;
> +
> +	*(dev->buf)++ = c;


Same here, the temporary variable c should be able to be removed and
just do it in place.

> +
> +	/* send stop if second but last byte has been read */
> +	if (--dev->buf_len == 1)
> +		at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_STOP);
> +
> +	dev_dbg(dev->dev, "read 0x%x, to go %d\n", c, dev->buf_len);
> +}
> +
> +static irqreturn_t atmel_twi_interrupt(int irq, void *dev_id)
> +{
> +	struct at91_twi_dev *dev = dev_id;
> +	const unsigned status = at91_twi_read(dev, AT91_TWI_SR);
> +	const unsigned irqstatus = status & at91_twi_read(dev, AT91_TWI_IMR);
> +
> +	if (irqstatus & AT91_TWI_TXCOMP) {
> +		at91_disable_twi_interrupts(dev);
> +		dev->transfer_status = status;
> +		complete(&dev->cmd_complete);
> +	}
> +	else if (irqstatus & AT91_TWI_RXRDY) {


CodingStyle is:

	if (foo) {
		foo();
	} else if (bar) {
		bar();
	} else {
		foobar();
	}

> +		at91_twi_read_next_byte(dev);
> +	}
> +	else if (irqstatus & AT91_TWI_TXRDY) {
> +		at91_twi_write_next_byte(dev);
> +	}
> +	else {
> +		return IRQ_NONE;
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +int at91_do_twi_transfer(struct at91_twi_dev *dev, bool is_read)


static?

> +{
> +	int ret = 0;
> +
> +	INIT_COMPLETION(dev->cmd_complete);
> +
> +	if (is_read) {
> +		if (!dev->buf_len)
> +			at91_twi_write(dev, AT91_TWI_CR,
> +				       AT91_TWI_START | AT91_TWI_STOP);
> +		else
> +			at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_START);
> +
> +		at91_twi_write(dev, AT91_TWI_IER,
> +			       AT91_TWI_TXCOMP | AT91_TWI_RXRDY);
> +
> +	} else {
> +
> +		at91_twi_write_next_byte(dev);
> +
> +		at91_twi_write(dev, AT91_TWI_IER,
> +			       AT91_TWI_TXCOMP | AT91_TWI_TXRDY);


Nitpick: Too many blank lines.

> +	}
> +
> +	ret = wait_for_completion_interruptible_timeout(&dev->cmd_complete,
> +							dev->adapter.timeout);
> +	if (ret == 0) {
> +		dev_err(dev->dev, "controller timed out\n");
> +		at91_init_twi_bus(dev);
> +		return -ETIMEDOUT;
> +	}
> +
> +	if (dev->transfer_status & AT91_TWI_NACK) {
> +		dev_dbg(dev->dev, "received nack\n");
> +		return -ENODEV;
> +	}
> +
> +	if (dev->transfer_status & AT91_TWI_OVRE) {
> +		dev_err(dev->dev, "overrun while reading\n");
> +		return -EIO;
> +	}
> +
> +	dev_dbg(dev->dev, "transfer complete\n");
> +
> +	return 0;
> +}
> +
> +static int at91_twi_xfer(struct i2c_adapter *adap, struct i2c_msg *msg, int num)
> +{
> +	struct at91_twi_dev *dev = i2c_get_adapdata(adap);
> +	int ret;
> +	unsigned int_addr_flag = 0;
> +	struct i2c_msg *m_start = msg;
> +
> +	dev_dbg(&adap->dev, "at91_xfer: processing %d messages:\n", num);
> +
> +	/* the hardware can handle at most two messages concatenated by a
> +	 * repeated start via it's internal address feature.
> +	 */


Your multiline comment style is still wrong. See Documentation/CodingStyle.

> +	if (num > 2) {
> +		dev_err(dev->dev,
> +			"cannot handle more than two concatenated messages.\n");
> +		return 0;


Should these not return error codes?

> +
> +	} else if (num == 2) {
> +
> +		int internal_address = 0;
> +		int i;
> +
> +		if (msg->flags & I2C_M_RD) {
> +			dev_err(dev->dev, "first transfer must be write.\n");
> +			return 0;
> +		}
> +
> +		if (msg->len > 3) {
> +			dev_err(dev->dev, "first message size must be <= 3.\n");
> +			return 0;
> +		}
> +
> +		/* 1st msg is put into the internal address, start with 2nd */
> +		m_start = &msg[1];
> +
> +		for (i = 0; i < msg->len; ++i) {
> +			internal_address |= ((unsigned)msg->buf[i]) << (8 * i);
> +			int_addr_flag += AT91_TWI_IADRSZ_1;
> +		}
> +
> +		at91_twi_write(dev, AT91_TWI_IADR, internal_address);
> +	}
> +
> +	at91_twi_write(dev, AT91_TWI_MMR, (m_start->addr << 16) | int_addr_flag
> +		       | ((m_start->flags & I2C_M_RD) ? AT91_TWI_MREAD : 0));
> +
> +	dev->buf_len = m_start->len;
> +	dev->buf = m_start->buf;
> +
> +	ret = at91_do_twi_transfer(dev, m_start->flags & I2C_M_RD);
> +
> +	if (ret < 0)


Nitpick: Remove the blank line.

> +		return ret;
> +
> +	return num;
> +}
> +
> +static u32 at91_twi_func(struct i2c_adapter *adapter)
> +{
> +	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
> +}
> +
> +static struct i2c_algorithm at91_twi_algorithm = {
> +	.master_xfer	= at91_twi_xfer,
> +	.functionality	= at91_twi_func,
> +};
> +
> +static int __devinit at91_twi_probe(struct platform_device *pdev)
> +{
> +	struct at91_twi_dev *dev;
> +	struct resource *mem, *irq, *ioarea;
> +	int rc;
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!mem)
> +		return -ENODEV;
> +
> +	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (!irq)
> +		return -ENODEV;
> +
> +	ioarea = request_mem_region(mem->start, resource_size(mem), pdev->name);
> +	if (!ioarea)
> +		return -EBUSY;
> +
> +	dev = kzalloc(sizeof(struct at91_twi_dev), GFP_KERNEL);
> +	if (!dev) {
> +		rc = -ENOMEM;
> +		goto err_release_region;
> +	}
> +
> +	init_completion(&dev->cmd_complete);
> +
> +	dev->dev = get_device(&pdev->dev);


Is this (and the put_device(&pdev->dev) in the exit code) necessary? I
see that some other i2c drivers do this also, but I'm not familiar with
using it in other device drivers. Isn't the reference count for
pdev->dev already incremented by the fact we are probing the device?

> +	dev->irq = irq->start;
> +	platform_set_drvdata(pdev, dev);
> +
> +	dev->clk = clk_get(&pdev->dev, "twi_clk");


This didn't get answered. Can't you just do:

	dev->clk = clk_get(&pdev->dev, NULL);

and clkdev should figure out the correct clock based on the device pointer?

> +	if (IS_ERR(dev->clk)) {
> +		dev_err(&pdev->dev, "no clock defined\n");
> +		rc = -ENODEV;
> +		goto err_free_mem;
> +	}
> +	clk_enable(dev->clk);
> +
> +	dev->base = ioremap(mem->start, resource_size(mem));
> +	if (!dev->base) {
> +		rc = -EBUSY;
> +		goto err_mem_ioremap;
> +	}
> +
> +	at91_twi_hwinit(dev);
> +
> +	rc = request_irq(dev->irq, atmel_twi_interrupt, 0,
> +			 dev_name(&pdev->dev), dev);
> +	if (rc) {
> +		dev_err(&pdev->dev, "Cannot get irq %d: %d\n", dev->irq, rc);
> +		goto err_unuse_clocks;
> +	}
> +
> +	snprintf(dev->adapter.name, sizeof(dev->adapter.name), "AT91");
> +	i2c_set_adapdata(&dev->adapter, dev);
> +	dev->adapter.owner = THIS_MODULE;
> +	dev->adapter.class = I2C_CLASS_HWMON;
> +	dev->adapter.algo = &at91_twi_algorithm;
> +	dev->adapter.dev.parent = &pdev->dev;
> +	dev->adapter.nr = pdev->id;
> +	dev->adapter.timeout = AT91_I2C_TIMEOUT;
> +
> +	rc = i2c_add_numbered_adapter(&dev->adapter);
> +	if (rc) {
> +		dev_err(&pdev->dev, "Adapter %s registration failed\n",
> +			dev->adapter.name);
> +		goto err_free_irq;
> +	}
> +
> +	dev_info(&pdev->dev, "AT91 i2c bus driver.\n");
> +	return 0;
> +
> +err_free_irq:
> +	free_irq(dev->irq, dev);
> +err_unuse_clocks:
> +	iounmap(dev->base);
> +err_mem_ioremap:
> +	clk_disable(dev->clk);
> +	clk_put(dev->clk);
> +	dev->clk = NULL;


You don't need to assign dev->clk to NULL.

> +err_free_mem:
> +	platform_set_drvdata(pdev, NULL);
> +	put_device(&pdev->dev);

> +	kfree(dev);

> +err_release_region:
> +	release_mem_region(mem->start, resource_size(mem));
> +
> +	return rc;
> +}
> +
> +static int __devexit at91_twi_remove(struct platform_device *pdev)
> +{
> +	struct at91_twi_dev *dev = platform_get_drvdata(pdev);
> +	struct resource *mem;
> +	int rc;
> +
> +	platform_set_drvdata(pdev, NULL);


I don't think this is necessary.

> +	rc = i2c_del_adapter(&dev->adapter);


Most of the other i2c drivers don't check the return code for
i2c_del_adapter. If this fails then you will unload the module, but
potentially leak resources that i2c_del_adapter failed to free up. Not
sure what the correct answer is here.

> +	put_device(&pdev->dev);
> +
> +	clk_disable(dev->clk);
> +	clk_put(dev->clk);
> +	dev->clk = NULL;
> +
> +	free_irq(dev->irq, dev);
> +
> +	iounmap(dev->base);
> +	kfree(dev);
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	release_mem_region(mem->start, resource_size(mem));
> +
> +	return rc;
> +}
> +
> +#ifdef CONFIG_PM
> +
> +static int at91_twi_suspend(struct device *dev)
> +{
> +	struct at91_twi_dev *twi_dev = dev_get_drvdata(dev);
> +
> +	clk_disable(twi_dev->clk);
> +
> +	return 0;
> +}
> +
> +static int at91_twi_resume(struct device *dev)
> +{
> +	struct at91_twi_dev *twi_dev = dev_get_drvdata(dev);
> +
> +	return clk_enable(twi_dev->clk);
> +}
> +
> +static const struct dev_pm_ops at91_twi_pm = {
> +	.suspend	= at91_twi_suspend,
> +	.resume		= at91_twi_resume,
> +};
> +
> +#define at91_twi_pm_ops (&at91_twi_pm)
> +#else
> +#define at91_twi_pm_ops NULL
> +#endif
> +
> +MODULE_ALIAS("platform:at91_i2c");
> +
> +static struct platform_driver at91_twi_driver = {
> +	.probe		= at91_twi_probe,
> +	.remove		= __devexit_p(at91_twi_remove),
> +	.driver		= {
> +		.name	= "at91_i2c",
> +		.owner	= THIS_MODULE,
> +		.pm	= at91_twi_pm_ops,
> +	},
> +};
> +
> +static int __init at91_twi_init(void)
> +{
> +	return platform_driver_register(&at91_twi_driver);
> +}
> +
> +static void __exit at91_twi_exit(void)
> +{
> +	platform_driver_unregister(&at91_twi_driver);
> +}
> +
> +module_init(at91_twi_init);
> +module_exit(at91_twi_exit);
> +
> +MODULE_AUTHOR("Nikolaus Voss");
> +MODULE_DESCRIPTION("I2C (TWI) driver for Atmel AT91");
> +MODULE_LICENSE("GPL");


