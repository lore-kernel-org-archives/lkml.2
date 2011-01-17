Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab1AQIFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 03:05:00 -0500
Received: from mailout07.yourhostingaccount.com ([65.254.253.62]:34418 "EHLO
	mailout07.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526Ab1AQIE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 03:04:57 -0500
X-Greylist: delayed 2202 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jan 2011 03:04:57 EST
X-EN-OrigOutIP: 10.1.18.4
X-EN-IMPSID: wXUC1f00105G96J0000000
Message-ID: <4D33EF7C.7030005@writeme.com>
Date: Mon, 17 Jan 2011 02:27:56 -0500
From: Sinan Akman <sinan@writeme.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100324)
MIME-Version: 1.0
To: Thomas Chou <thomas@wytron.com.tw>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        nios2-dev@sopc.et.ntust.edu.tw, Mike Frysinger <vapier@gentoo.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v3] spi: New driver for Altera SPI
References: <AANLkTi=D4Rcxbei2oo+EHc6X1O-2Oo+VWHAasK_JLj5W@mail.gmail.com> <1295247869-4968-1-git-send-email-thomas@wytron.com.tw>
In-Reply-To: <1295247869-4968-1-git-send-email-thomas@wytron.com.tw>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 9579962fb128fd4edc0e15f211ef4629:b3dd9e212e2067e834de66fc17565494
X-EN-AuthUser: remote@bootbits.com
X-EN-OrigIP: 174.93.215.254
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Chou wrote:

[...]
> +
> +static int altera_spi_txrx(struct spi_device *spi, struct spi_transfer *t)
> +{
> +   struct altera_spi *hw = to_hw(spi);
> +
> +   hw->tx = t->tx_buf;
> +   hw->rx = t->rx_buf;
> +   hw->count = 0;
> +   hw->bytes_per_word = (t->bits_per_word ? : spi->bits_per_word) / 8;
> +   hw->len = t->len / hw->bytes_per_word;
> +
> +   if (hw->irq >= 0) {
> +       init_completion(&hw->done);

       I think you init this twice, once in altera_spi_probe
below as well.

> +       /* enable receive interrupt */
> +       hw->imr |= ALTERA_SPI_CONTROL_IRRDY_MSK;
> +       writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
> +
> +       /* send the first byte */
> +       writel(hw_txbyte(hw, 0), hw->base + ALTERA_SPI_TXDATA);
> +
> +       wait_for_completion(&hw->done);
> +       /* disable receive interrupt */
> +       hw->imr &= ~ALTERA_SPI_CONTROL_IRRDY_MSK;
> +       writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
> +   } else {
> +       /* send the first byte */
> +       writel(hw_txbyte(hw, 0), hw->base + ALTERA_SPI_TXDATA);
> +
> +       while (1) {
> +           unsigned int rxd;
> +
> +           while (!(readl(hw->base + ALTERA_SPI_STATUS) &
> +                ALTERA_SPI_STATUS_RRDY_MSK))
> +               cpu_relax();
> +
> +           rxd = readl(hw->base + ALTERA_SPI_RXDATA);
> +           if (hw->rx) {
> +               switch (hw->bytes_per_word) {
> +               case 1:
> +                   hw->rx[hw->count] = rxd;
> +                   break;
> +               case 2:
> +                   hw->rx[hw->count * 2] = rxd;
> +                   hw->rx[hw->count * 2 + 1] = rxd >> 8;
> +                   break;
> +               }
> +           }
> +
> +           hw->count++;
> +
> +           if (hw->count < hw->len)
> +               writel(hw_txbyte(hw, hw->count),
> +                      hw->base + ALTERA_SPI_TXDATA);
> +           else
> +               break;
> +       }
> +
> +   }
> +
> +   return hw->count * hw->bytes_per_word;
> +}
> +
> +static irqreturn_t altera_spi_irq(int irq, void *dev)
> +{
> +   struct altera_spi *hw = dev;
> +   unsigned int rxd;
> +
> +   rxd = readl(hw->base + ALTERA_SPI_RXDATA);
> +   if (hw->rx) {
> +       switch (hw->bytes_per_word) {
> +       case 1:
> +           hw->rx[hw->count] = rxd;
> +           break;
> +       case 2:
> +           hw->rx[hw->count * 2] = rxd;
> +           hw->rx[hw->count * 2 + 1] = rxd >> 8;
> +           break;
> +       }
> +   }
> +
> +   hw->count++;
> +
> +   if (hw->count < hw->len)
> +       writel(hw_txbyte(hw, hw->count), hw->base + ALTERA_SPI_TXDATA);
> +   else
> +       complete(&hw->done);
> +
> +   return IRQ_HANDLED;
> +}
> +
> +#ifdef CONFIG_OF
> +static int __devinit altera_spi_of_probe(struct platform_device *pdev,
> +                      struct altera_spi *hw)
> +{
> +   const __be32 *val;
> +
> +   hw->bitbang.master->dev.of_node = pdev->dev.of_node;
> +   return 0;
> +}
> +#else
> +static int __devinit altera_spi_of_probe(struct platform_device *pdev,
> +                      struct altera_spi *hw)
> +{
> +   return 0;
> +}
> +#endif
> +
> +static int __devinit altera_spi_probe(struct platform_device *pdev)
> +{
> +   struct altera_spi_platform_data *platp = pdev->dev.platform_data;
> +   struct altera_spi *hw;
> +   struct spi_master *master;
> +   struct resource *res;
> +   int err = 0;
> +
> +   master = spi_alloc_master(&pdev->dev, sizeof(struct altera_spi));
> +   if (master == NULL) {
> +       dev_err(&pdev->dev, "No memory for spi_master\n");
> +       err = -ENOMEM;
> +       goto err_no_mem;
> +   }
> +
> +   /* setup the master state. */
> +   master->bus_num = pdev->id;
> +   master->num_chipselect = 16;
> +   master->mode_bits = SPI_CS_HIGH;
> +   master->setup = altera_spi_setup;
> +
> +   hw = spi_master_get_devdata(master);
> +   platform_set_drvdata(pdev, hw);
> +
> +   /* setup the state for the bitbang driver */
> +   hw->bitbang.master = spi_master_get(master);
> +   if (hw->bitbang.master == NULL) {
> +       dev_err(&pdev->dev, "Cannot get device\n");
> +       err = -ENODEV;
> +       goto err_no_dev;
> +   }
> +   hw->bitbang.setup_transfer = altera_spi_setupxfer;
> +   hw->bitbang.chipselect = altera_spi_chipsel;
> +   hw->bitbang.txrx_bufs = altera_spi_txrx;
> +
> +   /* find and map our resources */
> +   res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +   if (res == NULL) {
> +       dev_err(&pdev->dev, "Cannot get IORESOURCE_MEM\n");
> +       err = -ENOENT;
> +       goto err_no_iores;
> +   }
> +   hw->base = ioremap(res->start, (res->end - res->start) + 1);
> +   if (hw->base == 0) {
> +       dev_err(&pdev->dev, "Cannot map IO\n");
> +       err = -ENXIO;
> +       goto err_no_iomap;
> +   }
> +   /* program defaults into the registers */
> +   hw->imr = 0;        /* disable spi interrupts */
> +   writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
> +   writel(0, hw->base + ALTERA_SPI_STATUS);    /* clear status reg */
> +   if (readl(hw->base + ALTERA_SPI_STATUS) & ALTERA_SPI_STATUS_RRDY_MSK)
> +       readl(hw->base + ALTERA_SPI_RXDATA);    /* flush rxdata */
> +   /* irq is optional */
> +   hw->irq = platform_get_irq(pdev, 0);
> +   if (hw->irq >= 0) {
> +       init_completion(&hw->done);
> +       err = request_irq(hw->irq, altera_spi_irq, 0, pdev->name, hw);
> +       if (err) {
> +           dev_err(&pdev->dev, "Cannot claim IRQ\n");
> +           goto err_no_irq;
> +       }
> +   }
> +   /* find platform data */
> +   if (!platp) {
> +       err = altera_spi_of_probe(pdev, hw);
> +       if (err)
> +           goto err_no_of;
> +   }
> +
> +   /* register our spi controller */
> +   err = spi_bitbang_start(&hw->bitbang);
> +   if (err) {
> +       dev_err(&pdev->dev, "Failed to register SPI master\n");
> +       goto err_register;
> +   }
> +   dev_info(&pdev->dev, "base %p, irq %d\n", hw->base, hw->irq);
> +
> +   return 0;
> +
> +err_register:
> +err_no_of:
> +   if (hw->irq >= 0)
> +       free_irq(hw->irq, hw);
> +err_no_irq:
> +   iounmap((void *)hw->base);
> +err_no_iomap:
> +err_no_iores:
> +   spi_master_put(master);;
> +err_no_mem:
> +err_no_dev:
> +   return err;
> +}
> +
> +static int __devexit altera_spi_remove(struct platform_device *dev)
> +{
> +   struct altera_spi *hw = platform_get_drvdata(dev);
> +   struct spi_master *master = hw->bitbang.master;
> +
> +   spi_bitbang_stop(&hw->bitbang);
> +
> +   if (hw->irq >= 0)
> +       free_irq(hw->irq, hw);
> +   iounmap((void *)hw->base);
> +
> +   platform_set_drvdata(dev, NULL);
> +   spi_master_put(master);
> +   return 0;
> +}
> +
> +#ifdef CONFIG_OF
> +static struct of_device_id altera_spi_match[] = {
> +   {
> +       .compatible = "altera,spi_altera",
> +   },
> +   {},
> +}
> +MODULE_DEVICE_TABLE(of, altera_spi_match);
> +#endif
> +
> +static struct platform_driver altera_spidrv = {
> +   .remove = __devexit_p(altera_spi_remove),
> +   .driver = {
> +       .name = DRV_NAME,
> +       .owner = THIS_MODULE,
> +       .pm = NULL,
> +#ifdef CONFIG_OF
> +       .of_match_table = altera_spi_match,
> +#endif
> +   },
> +};
> +
> +static int __init altera_spi_init(void)
> +{
> +   return platform_driver_probe(&altera_spidrv, altera_spi_probe);
> +}
> +
> +static void __exit altera_spi_exit(void)
> +{
> +   platform_driver_unregister(&altera_spidrv);
> +}
> +
> +module_init(altera_spi_init);
> +module_exit(altera_spi_exit);
> +
> +MODULE_DESCRIPTION("Altera SPI driver");
> +MODULE_AUTHOR("Thomas Chou <thomas@wytron.com.tw>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:" DRV_NAME);

