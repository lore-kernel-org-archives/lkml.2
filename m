Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab0ICOqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:46:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54358 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab0ICOqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:46:50 -0400
MIME-Version: 1.0
In-Reply-To: <4C80E2D5.1020104@dsn.okisemi.com>
References: <4C80E2D5.1020104@dsn.okisemi.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 3 Sep 2010 08:46:29 -0600
X-Google-Sender-Auth: mzDMD_DwcGZqzbsDbj7150yf1mw
Message-ID: <AANLkTinYypWdty1eLH1LTyOEZPt-k=cEDGu_coyWVa2t@mail.gmail.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, gregkh@suse.de,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/3 Masayuki Ohtak <masa-korg@dsn.okisemi.com>:
> SPI driver of Topcliff PCH
>
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus.
> Topcliff PCH has SPI I/F. Using this I/F, it is able to access system
> devices connected to SPI.
>
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>

Hi Ohtak-san

Comments below.  Also, please also fix the method that you're using to
post patches.  The email client you're currently using is posting the
patches in HTML format, and is mangling them.  git send-email can help
you here.

> ---
>  drivers/spi/Kconfig   |   19 +
>  drivers/spi/Makefile  |    1 +
>  drivers/spi/spi_pch.c | 1813
> +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1833 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/spi/spi_pch.c
>
> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> index 91c2f4f..2c93667 100644
> --- a/drivers/spi/Kconfig
> +++ b/drivers/spi/Kconfig
> @@ -53,6 +53,25 @@ if SPI_MASTER
>
>  comment "SPI Master Controller Drivers"
>
> +config PCH_SPI
> +#	tristate "PCH SPI Controller"
> +	boolean "PCH SPI Controller"
> +	depends on PCI
> +	help
> +	  This driver is for PCH(Platform controller Hub) SPI of Topcliff which
> +	  is an IOH(Input/Output Hub) for x86 embedded processor.
> +	  This driver can access PCH SPI bus device.
> +
> +config PCH_SPI_PLATFORM_DEVICE_COUNT
> +	int "PCH SPI Bus count"
> +	range 1 2
> +	depends on PCH_SPI
> +	help
> +	  This driver is for PCH(Platform controller Hub) SPI of Topcliff which
> +	  is an IOH(Input/Output Hub) for x86 embedded processor.
> +	  The number of SPI buses/channels supported by the PCH SPI controller.
> +	  PCH SPI of Topcliff supports only one channel.
> +

As previously discussed, PCH_SPI_PLATFORM_DEVICE_COUNT needs to be
removed (see below).

[...]

> +static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id
> *id)
> +{
> +
> +	struct spi_master *master[PCH_MAX_DEV];
> +
> +	struct pch_spi_board_data *board_dat;
> +	int retval, i;
> +	int spi_alloc_num, master_num;
> +
> +	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
> +
> +	/* allocate memory for private data */
> +	board_dat = kzalloc(sizeof(struct pch_spi_board_data), GFP_KERNEL);
> +
> +	if (board_dat == NULL) {
> +		dev_err(&pdev->dev,
> +			" %s memory allocation for private data failed\n",
> +			__func__);
> +		retval = -ENOMEM;
> +		goto err_kmalloc;
> +	}
> +
> +	dev_dbg(&pdev->dev,
> +		"%s memory allocation for private data success\n", __func__);
> +
> +	/* enable PCI device */
> +	retval = pci_enable_device(pdev);
> +	if (retval != 0) {
> +		dev_err(&pdev->dev, "%s pci_enable_device FAILED\n", __func__);
> +
> +		goto err_pci_en_device;
> +	}
> +
> +	dev_dbg(&pdev->dev, "%s pci_enable_device returned=%d\n",
> +		__func__, retval);
> +
> +	board_dat->pdev = pdev;
> +
> +	/* alllocate memory for SPI master */
> +	for (i = 0, spi_alloc_num = 0; i < PCH_MAX_DEV; i++, spi_alloc_num++) {
> +		master[i] = spi_alloc_master(&pdev->dev,
> +					     sizeof(struct pch_spi_data));
> +
> +		if (master[i] == NULL) {
> +			retval = -ENOMEM;
> +			dev_err(&pdev->dev, "%s [ch=%d]Fail.\n", __func__, i);
> +			goto err_spi_alloc_master;
> +		}
> +	}
> +
> +	dev_dbg(&pdev->dev,
> +		"%s spi_alloc_master returned non NULL\n", __func__);
> +
> +	/* initialize members of SPI master */
> +	for (i = 0, master_num = 0; i < PCH_MAX_DEV;
> +							i++, master_num++) {
> +		master[i]->bus_num = i;

This is not okay.  The driver cannot assume that it provides the only
SPI busses in the system.  The bus number should either be set to -1
so that it gets auto-assigned, or the bus number should be passed in
by board-specific setup code.

> +		master[i]->num_chipselect = PCH_MAX_CS;
> +		master[i]->setup = pch_spi_setup;
> +		dev_dbg(&pdev->dev,
> +			"%s setup member of SPI master initialized\n",
> +			__func__);
> +		master[i]->transfer = pch_spi_transfer;
> +		dev_dbg(&pdev->dev,
> +			"%s transfer member of SPI master initialized\n",
> +			__func__);
> +
> +		board_dat->data[i] = spi_master_get_devdata(master[i]);
> +
> +		board_dat->data[i]->master = master[i];
> +		board_dat->data[i]->n_curnt_chip = 255;
> +		board_dat->data[i]->current_chip = NULL;
> +		board_dat->data[i]->transfer_complete = false;
> +		board_dat->data[i]->pkt_tx_buff = NULL;
> +		board_dat->data[i]->pkt_rx_buff = NULL;
> +		board_dat->data[i]->tx_index = 0;
> +		board_dat->data[i]->rx_index = 0;
> +		board_dat->data[i]->transfer_active = false;
> +		board_dat->data[i]->board_dat = board_dat;
> +		board_dat->suspend_sts = false;
> +
> +		mutex_init(&board_dat->data[i]->mutex);
> +	}
> +
> +
> +	/* allocate resources for PCH SPI */
> +	retval = pch_spi_get_resources(board_dat);
> +	if (retval != 0) {
> +		dev_err(&pdev->dev, "%s fail(retval=%d)\n",
> +			__func__, retval);
> +		goto err_spi_get_resources;
> +	}
> +
> +	dev_dbg(&pdev->dev, "%s pch_spi_get_resources returned=%d\n",
> +		__func__, retval);
> +
> +	/* save private data in dev */
> +	pci_set_drvdata(pdev, (void *)board_dat);
> +	dev_dbg(&pdev->dev, "%s invoked pci_set_drvdata\n", __func__);
> +
> +	/* set master mode */
> +	for (i = 0; i < PCH_MAX_DEV; i++) {
> +		pch_spi_set_master_mode(master[i]);
> +		dev_dbg(&pdev->dev,
> +			"%s invoked pch_spi_set_master_mode\n", __func__);
> +	}
> +
> +	/* Register the controller with the SPI core. */
> +	for (i = 0, master_num = 0; i < PCH_MAX_DEV; i++, master_num++) {
> +		retval = spi_register_master(master[i]);
> +		if (retval != 0) {
> +			dev_err(&pdev->dev,
> +				"%s spi_register_master FAILED\n", __func__);
> +			goto err_spi_reg_master;
> +		}
> +	}

I *finally* understand what you're trying to do here.  It looks like
you have a single PCI device that has multiple independent SPI busses.
 It also appears that this driver attempts to handle all of the
instances within a single context.

Doing it this way overcomplicates the driver because you need to have
for() loops all over the driver to deal with the multiple instances.

Instead, the majority of the code should be structured to handle one
and only one spi bus instance.  Only at the top level pci probe,
remove and PM code should there be for() loops for setting up or
tearing down each spi bus instance one at a time.

In fact, it may be better for the pci_probe() hook to simply register
one or more platform_devices; one for each instance of the SPI bus,
and then have a separate platform_driver that binds to each instance.

> +static int __init pch_spi_init(void)
> +{
> +#ifdef PCH_SPIDEV_REG_OLD
> +	int retval;
> +
> +	retval = spi_register_board_info
> +		(pch_spi_slaves, ARRAY_SIZE(pch_spi_slaves));
> +	if (retval)
> +		return retval;
> +#endif

As we discussed previously, this driver must *not* register child spi
devices with static code like this.  Remove the above lines and the
pch_spi_slaves array.

> +	return pci_register_driver(&pch_spi_pcidev);
> +}
> +
> +
> +static void __exit pch_spi_exit(void)
> +{
> +	pci_unregister_driver(&pch_spi_pcidev);
> +}
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("PCH SPI PCI Driver");
> +module_init(pch_spi_init);
> +module_exit(pch_spi_exit);

module_init() and modules_exit() should appear immediately after the
functions they register as init and exit hooks.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
