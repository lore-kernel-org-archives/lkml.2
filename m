Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab1BPCv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:51:29 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56366 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab1BPCvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 21:51:24 -0500
Date: Tue, 15 Feb 2011 19:47:09 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v8 resend] spi: add OpenCores tiny SPI driver
Message-ID: <20110216024709.GJ28005@angua.secretlab.ca>
References: <1297649758-11828-1-git-send-email-thomas@wytron.com.tw>
 <1297650039-12013-1-git-send-email-thomas@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297650039-12013-1-git-send-email-thomas@wytron.com.tw>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 10:20:39AM +0800, Thomas Chou wrote:
> This patch adds support of OpenCores tiny SPI driver.
> 
> http://opencores.org/project,tiny_spi
> 
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>

Applied, thanks.

g.

> ---
> v2 minor cleanup, same as Grant suggest for spi_altera.
> v3 rename driver to spi_oc_tiny as Grant suggested.
>    set version to tiny-spi-rtlsvn2 as Jonas suggested.
> v4 add dts binding doc.
> v5 use devm_* to help cleanup.
>    add of gpio support.
> v6 check len from of_get_property.
>    fix kerneldoc in header.
> v7 remove default n from Kconfig.
> v8 condition module device table export for of.
> 
> Sorry, forget to commit the last change.
> 
>  .../devicetree/bindings/spi/spi_oc_tiny.txt        |   12 +
>  drivers/spi/Kconfig                                |    7 +
>  drivers/spi/Makefile                               |    1 +
>  drivers/spi/spi_oc_tiny.c                          |  425 ++++++++++++++++++++
>  include/linux/spi/spi_oc_tiny.h                    |   20 +
>  5 files changed, 465 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/spi/spi_oc_tiny.txt
>  create mode 100644 drivers/spi/spi_oc_tiny.c
>  create mode 100644 include/linux/spi/spi_oc_tiny.h
> 
> diff --git a/Documentation/devicetree/bindings/spi/spi_oc_tiny.txt b/Documentation/devicetree/bindings/spi/spi_oc_tiny.txt
> new file mode 100644
> index 0000000..d95c0b3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/spi/spi_oc_tiny.txt
> @@ -0,0 +1,12 @@
> +OpenCores tiny SPI
> +
> +Required properties:
> +- compatible : should be "opencores,tiny-spi-rtlsvn2".
> +- gpios : should specify GPIOs used for chipselect.
> +Optional properties:
> +- clock-frequency : input clock frequency to the core.
> +- baud-width: width, in bits, of the programmable divider used to scale
> +	the input clock to SCLK.
> +
> +The clock-frequency and baud-width properties are needed only if the divider
> +is programmable. They are not needed if the divider is fixed.
> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> index bb233a9..8faa57a 100644
> --- a/drivers/spi/Kconfig
> +++ b/drivers/spi/Kconfig
> @@ -231,6 +231,13 @@ config SPI_FSL_ESPI
>  	  From MPC8536, 85xx platform uses the controller, and all P10xx,
>  	  P20xx, P30xx,P40xx, P50xx uses this controller.
>  
> +config SPI_OC_TINY
> +	tristate "OpenCores tiny SPI"
> +	depends on GENERIC_GPIO
> +	select SPI_BITBANG
> +	help
> +	  This is the driver for OpenCores tiny SPI master controller.
> +
>  config SPI_OMAP_UWIRE
>  	tristate "OMAP1 MicroWire"
>  	depends on ARCH_OMAP1
> diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
> index 86d1b5f..c7e4c23 100644
> --- a/drivers/spi/Makefile
> +++ b/drivers/spi/Makefile
> @@ -27,6 +27,7 @@ obj-$(CONFIG_SPI_IMX)			+= spi_imx.o
>  obj-$(CONFIG_SPI_LM70_LLP)		+= spi_lm70llp.o
>  obj-$(CONFIG_SPI_PXA2XX)		+= pxa2xx_spi.o
>  obj-$(CONFIG_SPI_PXA2XX_PCI)		+= pxa2xx_spi_pci.o
> +obj-$(CONFIG_SPI_OC_TINY)		+= spi_oc_tiny.o
>  obj-$(CONFIG_SPI_OMAP_UWIRE)		+= omap_uwire.o
>  obj-$(CONFIG_SPI_OMAP24XX)		+= omap2_mcspi.o
>  obj-$(CONFIG_SPI_OMAP_100K)		+= omap_spi_100k.o
> diff --git a/drivers/spi/spi_oc_tiny.c b/drivers/spi/spi_oc_tiny.c
> new file mode 100644
> index 0000000..e99e545
> --- /dev/null
> +++ b/drivers/spi/spi_oc_tiny.c
> @@ -0,0 +1,425 @@
> +/*
> + * OpenCores tiny SPI master driver
> + *
> + * http://opencores.org/project,tiny_spi
> + *
> + * Copyright (C) 2011 Thomas Chou <thomas@wytron.com.tw>
> + *
> + * Based on spi_s3c24xx.c, which is:
> + * Copyright (c) 2006 Ben Dooks
> + * Copyright (c) 2006 Simtec Electronics
> + *	Ben Dooks <ben@simtec.co.uk>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/errno.h>
> +#include <linux/platform_device.h>
> +#include <linux/spi/spi.h>
> +#include <linux/spi/spi_bitbang.h>
> +#include <linux/spi/spi_oc_tiny.h>
> +#include <linux/io.h>
> +#include <linux/gpio.h>
> +#include <linux/of.h>
> +
> +#define DRV_NAME "spi_oc_tiny"
> +
> +#define TINY_SPI_RXDATA 0
> +#define TINY_SPI_TXDATA 4
> +#define TINY_SPI_STATUS 8
> +#define TINY_SPI_CONTROL 12
> +#define TINY_SPI_BAUD 16
> +
> +#define TINY_SPI_STATUS_TXE 0x1
> +#define TINY_SPI_STATUS_TXR 0x2
> +
> +struct tiny_spi {
> +	/* bitbang has to be first */
> +	struct spi_bitbang bitbang;
> +	struct completion done;
> +
> +	void __iomem *base;
> +	int irq;
> +	unsigned int freq;
> +	unsigned int baudwidth;
> +	unsigned int baud;
> +	unsigned int speed_hz;
> +	unsigned int mode;
> +	unsigned int len;
> +	unsigned int txc, rxc;
> +	const u8 *txp;
> +	u8 *rxp;
> +	unsigned int gpio_cs_count;
> +	int *gpio_cs;
> +};
> +
> +static inline struct tiny_spi *tiny_spi_to_hw(struct spi_device *sdev)
> +{
> +	return spi_master_get_devdata(sdev->master);
> +}
> +
> +static unsigned int tiny_spi_baud(struct spi_device *spi, unsigned int hz)
> +{
> +	struct tiny_spi *hw = tiny_spi_to_hw(spi);
> +
> +	return min(DIV_ROUND_UP(hw->freq, hz * 2), (1U << hw->baudwidth)) - 1;
> +}
> +
> +static void tiny_spi_chipselect(struct spi_device *spi, int is_active)
> +{
> +	struct tiny_spi *hw = tiny_spi_to_hw(spi);
> +
> +	if (hw->gpio_cs_count) {
> +		gpio_set_value(hw->gpio_cs[spi->chip_select],
> +			(spi->mode & SPI_CS_HIGH) ? is_active : !is_active);
> +	}
> +}
> +
> +static int tiny_spi_setup_transfer(struct spi_device *spi,
> +				   struct spi_transfer *t)
> +{
> +	struct tiny_spi *hw = tiny_spi_to_hw(spi);
> +	unsigned int baud = hw->baud;
> +
> +	if (t) {
> +		if (t->speed_hz && t->speed_hz != hw->speed_hz)
> +			baud = tiny_spi_baud(spi, t->speed_hz);
> +	}
> +	writel(baud, hw->base + TINY_SPI_BAUD);
> +	writel(hw->mode, hw->base + TINY_SPI_CONTROL);
> +	return 0;
> +}
> +
> +static int tiny_spi_setup(struct spi_device *spi)
> +{
> +	struct tiny_spi *hw = tiny_spi_to_hw(spi);
> +
> +	if (spi->max_speed_hz != hw->speed_hz) {
> +		hw->speed_hz = spi->max_speed_hz;
> +		hw->baud = tiny_spi_baud(spi, hw->speed_hz);
> +	}
> +	hw->mode = spi->mode & (SPI_CPOL | SPI_CPHA);
> +	return 0;
> +}
> +
> +static inline void tiny_spi_wait_txr(struct tiny_spi *hw)
> +{
> +	while (!(readb(hw->base + TINY_SPI_STATUS) &
> +		 TINY_SPI_STATUS_TXR))
> +		cpu_relax();
> +}
> +
> +static inline void tiny_spi_wait_txe(struct tiny_spi *hw)
> +{
> +	while (!(readb(hw->base + TINY_SPI_STATUS) &
> +		 TINY_SPI_STATUS_TXE))
> +		cpu_relax();
> +}
> +
> +static int tiny_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
> +{
> +	struct tiny_spi *hw = tiny_spi_to_hw(spi);
> +	const u8 *txp = t->tx_buf;
> +	u8 *rxp = t->rx_buf;
> +	unsigned int i;
> +
> +	if (hw->irq >= 0) {
> +		/* use intrrupt driven data transfer */
> +		hw->len = t->len;
> +		hw->txp = t->tx_buf;
> +		hw->rxp = t->rx_buf;
> +		hw->txc = 0;
> +		hw->rxc = 0;
> +
> +		/* send the first byte */
> +		if (t->len > 1) {
> +			writeb(hw->txp ? *hw->txp++ : 0,
> +			       hw->base + TINY_SPI_TXDATA);
> +			hw->txc++;
> +			writeb(hw->txp ? *hw->txp++ : 0,
> +			       hw->base + TINY_SPI_TXDATA);
> +			hw->txc++;
> +			writeb(TINY_SPI_STATUS_TXR, hw->base + TINY_SPI_STATUS);
> +		} else {
> +			writeb(hw->txp ? *hw->txp++ : 0,
> +			       hw->base + TINY_SPI_TXDATA);
> +			hw->txc++;
> +			writeb(TINY_SPI_STATUS_TXE, hw->base + TINY_SPI_STATUS);
> +		}
> +
> +		wait_for_completion(&hw->done);
> +	} else if (txp && rxp) {
> +		/* we need to tighten the transfer loop */
> +		writeb(*txp++, hw->base + TINY_SPI_TXDATA);
> +		if (t->len > 1) {
> +			writeb(*txp++, hw->base + TINY_SPI_TXDATA);
> +			for (i = 2; i < t->len; i++) {
> +				u8 rx, tx = *txp++;
> +				tiny_spi_wait_txr(hw);
> +				rx = readb(hw->base + TINY_SPI_TXDATA);
> +				writeb(tx, hw->base + TINY_SPI_TXDATA);
> +				*rxp++ = rx;
> +			}
> +			tiny_spi_wait_txr(hw);
> +			*rxp++ = readb(hw->base + TINY_SPI_TXDATA);
> +		}
> +		tiny_spi_wait_txe(hw);
> +		*rxp++ = readb(hw->base + TINY_SPI_RXDATA);
> +	} else if (rxp) {
> +		writeb(0, hw->base + TINY_SPI_TXDATA);
> +		if (t->len > 1) {
> +			writeb(0,
> +			       hw->base + TINY_SPI_TXDATA);
> +			for (i = 2; i < t->len; i++) {
> +				u8 rx;
> +				tiny_spi_wait_txr(hw);
> +				rx = readb(hw->base + TINY_SPI_TXDATA);
> +				writeb(0, hw->base + TINY_SPI_TXDATA);
> +				*rxp++ = rx;
> +			}
> +			tiny_spi_wait_txr(hw);
> +			*rxp++ = readb(hw->base + TINY_SPI_TXDATA);
> +		}
> +		tiny_spi_wait_txe(hw);
> +		*rxp++ = readb(hw->base + TINY_SPI_RXDATA);
> +	} else if (txp) {
> +		writeb(*txp++, hw->base + TINY_SPI_TXDATA);
> +		if (t->len > 1) {
> +			writeb(*txp++, hw->base + TINY_SPI_TXDATA);
> +			for (i = 2; i < t->len; i++) {
> +				u8 tx = *txp++;
> +				tiny_spi_wait_txr(hw);
> +				writeb(tx, hw->base + TINY_SPI_TXDATA);
> +			}
> +		}
> +		tiny_spi_wait_txe(hw);
> +	} else {
> +		writeb(0, hw->base + TINY_SPI_TXDATA);
> +		if (t->len > 1) {
> +			writeb(0, hw->base + TINY_SPI_TXDATA);
> +			for (i = 2; i < t->len; i++) {
> +				tiny_spi_wait_txr(hw);
> +				writeb(0, hw->base + TINY_SPI_TXDATA);
> +			}
> +		}
> +		tiny_spi_wait_txe(hw);
> +	}
> +	return t->len;
> +}
> +
> +static irqreturn_t tiny_spi_irq(int irq, void *dev)
> +{
> +	struct tiny_spi *hw = dev;
> +
> +	writeb(0, hw->base + TINY_SPI_STATUS);
> +	if (hw->rxc + 1 == hw->len) {
> +		if (hw->rxp)
> +			*hw->rxp++ = readb(hw->base + TINY_SPI_RXDATA);
> +		hw->rxc++;
> +		complete(&hw->done);
> +	} else {
> +		if (hw->rxp)
> +			*hw->rxp++ = readb(hw->base + TINY_SPI_TXDATA);
> +		hw->rxc++;
> +		if (hw->txc < hw->len) {
> +			writeb(hw->txp ? *hw->txp++ : 0,
> +			       hw->base + TINY_SPI_TXDATA);
> +			hw->txc++;
> +			writeb(TINY_SPI_STATUS_TXR,
> +			       hw->base + TINY_SPI_STATUS);
> +		} else {
> +			writeb(TINY_SPI_STATUS_TXE,
> +			       hw->base + TINY_SPI_STATUS);
> +		}
> +	}
> +	return IRQ_HANDLED;
> +}
> +
> +#ifdef CONFIG_OF
> +#include <linux/of_gpio.h>
> +
> +static int __devinit tiny_spi_of_probe(struct platform_device *pdev)
> +{
> +	struct tiny_spi *hw = platform_get_drvdata(pdev);
> +	struct device_node *np = pdev->dev.of_node;
> +	unsigned int i;
> +	const __be32 *val;
> +	int len;
> +
> +	if (!np)
> +		return 0;
> +	hw->gpio_cs_count = of_gpio_count(np);
> +	if (hw->gpio_cs_count) {
> +		hw->gpio_cs = devm_kzalloc(&pdev->dev,
> +				hw->gpio_cs_count * sizeof(unsigned int),
> +				GFP_KERNEL);
> +		if (!hw->gpio_cs)
> +			return -ENOMEM;
> +	}
> +	for (i = 0; i < hw->gpio_cs_count; i++) {
> +		hw->gpio_cs[i] = of_get_gpio_flags(np, i, NULL);
> +		if (hw->gpio_cs[i] < 0)
> +			return -ENODEV;
> +	}
> +	hw->bitbang.master->dev.of_node = pdev->dev.of_node;
> +	val = of_get_property(pdev->dev.of_node,
> +			      "clock-frequency", &len);
> +	if (val && len >= sizeof(__be32))
> +		hw->freq = be32_to_cpup(val);
> +	val = of_get_property(pdev->dev.of_node, "baud-width", &len);
> +	if (val && len >= sizeof(__be32))
> +		hw->baudwidth = be32_to_cpup(val);
> +	return 0;
> +}
> +#else /* !CONFIG_OF */
> +static int __devinit tiny_spi_of_probe(struct platform_device *pdev)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_OF */
> +
> +static int __devinit tiny_spi_probe(struct platform_device *pdev)
> +{
> +	struct tiny_spi_platform_data *platp = pdev->dev.platform_data;
> +	struct tiny_spi *hw;
> +	struct spi_master *master;
> +	struct resource *res;
> +	unsigned int i;
> +	int err = -ENODEV;
> +
> +	master = spi_alloc_master(&pdev->dev, sizeof(struct tiny_spi));
> +	if (!master)
> +		return err;
> +
> +	/* setup the master state. */
> +	master->bus_num = pdev->id;
> +	master->num_chipselect = 255;
> +	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
> +	master->setup = tiny_spi_setup;
> +
> +	hw = spi_master_get_devdata(master);
> +	platform_set_drvdata(pdev, hw);
> +
> +	/* setup the state for the bitbang driver */
> +	hw->bitbang.master = spi_master_get(master);
> +	if (!hw->bitbang.master)
> +		return err;
> +	hw->bitbang.setup_transfer = tiny_spi_setup_transfer;
> +	hw->bitbang.chipselect = tiny_spi_chipselect;
> +	hw->bitbang.txrx_bufs = tiny_spi_txrx_bufs;
> +
> +	/* find and map our resources */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		goto exit_busy;
> +	if (!devm_request_mem_region(&pdev->dev, res->start, resource_size(res),
> +				     pdev->name))
> +		goto exit_busy;
> +	hw->base = devm_ioremap_nocache(&pdev->dev, res->start,
> +					resource_size(res));
> +	if (!hw->base)
> +		goto exit_busy;
> +	/* irq is optional */
> +	hw->irq = platform_get_irq(pdev, 0);
> +	if (hw->irq >= 0) {
> +		init_completion(&hw->done);
> +		err = devm_request_irq(&pdev->dev, hw->irq, tiny_spi_irq, 0,
> +				       pdev->name, hw);
> +		if (err)
> +			goto exit;
> +	}
> +	/* find platform data */
> +	if (platp) {
> +		hw->gpio_cs_count = platp->gpio_cs_count;
> +		hw->gpio_cs = platp->gpio_cs;
> +		if (platp->gpio_cs_count && !platp->gpio_cs)
> +			goto exit_busy;
> +		hw->freq = platp->freq;
> +		hw->baudwidth = platp->baudwidth;
> +	} else {
> +		err = tiny_spi_of_probe(pdev);
> +		if (err)
> +			goto exit;
> +	}
> +	for (i = 0; i < hw->gpio_cs_count; i++) {
> +		err = gpio_request(hw->gpio_cs[i], dev_name(&pdev->dev));
> +		if (err)
> +			goto exit_gpio;
> +		gpio_direction_output(hw->gpio_cs[i], 1);
> +	}
> +	hw->bitbang.master->num_chipselect = max(1U, hw->gpio_cs_count);
> +
> +	/* register our spi controller */
> +	err = spi_bitbang_start(&hw->bitbang);
> +	if (err)
> +		goto exit;
> +	dev_info(&pdev->dev, "base %p, irq %d\n", hw->base, hw->irq);
> +
> +	return 0;
> +
> +exit_gpio:
> +	while (i-- > 0)
> +		gpio_free(hw->gpio_cs[i]);
> +exit_busy:
> +	err = -EBUSY;
> +exit:
> +	platform_set_drvdata(pdev, NULL);
> +	spi_master_put(master);
> +	return err;
> +}
> +
> +static int __devexit tiny_spi_remove(struct platform_device *pdev)
> +{
> +	struct tiny_spi *hw = platform_get_drvdata(pdev);
> +	struct spi_master *master = hw->bitbang.master;
> +	unsigned int i;
> +
> +	spi_bitbang_stop(&hw->bitbang);
> +	for (i = 0; i < hw->gpio_cs_count; i++)
> +		gpio_free(hw->gpio_cs[i]);
> +	platform_set_drvdata(pdev, NULL);
> +	spi_master_put(master);
> +	return 0;
> +}
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id tiny_spi_match[] = {
> +	{ .compatible = "opencores,tiny-spi-rtlsvn2", },
> +	{},
> +}
> +MODULE_DEVICE_TABLE(of, tiny_spi_match);
> +#else /* CONFIG_OF */
> +#define tiny_spi_match NULL
> +#endif /* CONFIG_OF */
> +
> +static struct platform_driver tiny_spi_driver = {
> +	.probe = tiny_spi_probe,
> +	.remove = __devexit_p(tiny_spi_remove),
> +	.driver = {
> +		.name = DRV_NAME,
> +		.owner = THIS_MODULE,
> +		.pm = NULL,
> +		.of_match_table = tiny_spi_match,
> +	},
> +};
> +
> +static int __init tiny_spi_init(void)
> +{
> +	return platform_driver_register(&tiny_spi_driver);
> +}
> +module_init(tiny_spi_init);
> +
> +static void __exit tiny_spi_exit(void)
> +{
> +	platform_driver_unregister(&tiny_spi_driver);
> +}
> +module_exit(tiny_spi_exit);
> +
> +MODULE_DESCRIPTION("OpenCores tiny SPI driver");
> +MODULE_AUTHOR("Thomas Chou <thomas@wytron.com.tw>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:" DRV_NAME);
> diff --git a/include/linux/spi/spi_oc_tiny.h b/include/linux/spi/spi_oc_tiny.h
> new file mode 100644
> index 0000000..1ac529c
> --- /dev/null
> +++ b/include/linux/spi/spi_oc_tiny.h
> @@ -0,0 +1,20 @@
> +#ifndef _LINUX_SPI_SPI_OC_TINY_H
> +#define _LINUX_SPI_SPI_OC_TINY_H
> +
> +/**
> + * struct tiny_spi_platform_data - platform data of the OpenCores tiny SPI
> + * @freq:	input clock freq to the core.
> + * @baudwidth:	baud rate divider width of the core.
> + * @gpio_cs_count:	number of gpio pins used for chipselect.
> + * @gpio_cs:	array of gpio pins used for chipselect.
> + *
> + * freq and baudwidth are used only if the divider is programmable.
> + */
> +struct tiny_spi_platform_data {
> +	unsigned int freq;
> +	unsigned int baudwidth;
> +	unsigned int gpio_cs_count;
> +	int *gpio_cs;
> +};
> +
> +#endif /* _LINUX_SPI_SPI_OC_TINY_H */
> -- 
> 1.7.4
> 
