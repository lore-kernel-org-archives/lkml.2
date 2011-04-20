Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab1DTOjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 10:39:24 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50039 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1DTOjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 10:39:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:in-reply-to:mime-version:content-type:message-id
         :content-transfer-encoding:cc:from:subject:date:to:x-mailer;
        b=eJ4Y2vF5x1m6qyndxlfUeorKh6XXaP+Zsy7K4gBB0X7CibPj9MxNkD8pGdveTMHK2F
         e9ZLWgYX0td6094rtICafLJj5tKDPGnCTTXDmTvWNtysDQf21sJdjLi5gNcZL5jFhzrF
         7+waOc+FTSqinrlICqle0wlzE6BnThMldn2u4=
References: <1298893677-4406-1-git-send-email-tomoya-linux@dsn.okisemi.com> <20110331223838.GF437@ponder.secretlab.ca>
In-Reply-To: <20110331223838.GF437@ponder.secretlab.ca>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <71A08A15-E2D3-4510-841C-6D1B6856CC49@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        spi-devel-general@lists.sourceforge.net
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Subject: Re: [PATCH v3] spi_topcliff_pch: support new device ML7213 IOH
Date: Wed, 20 Apr 2011 10:39:16 -0400
To: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Sorry to add noise to this thread but I wanted the quick question to get into the right hands the first time around.

this URL: http://sourceforge.net/projects/ml7213/files/Kernel%202.6.37/Release/Ver%201.0.0/
contain a series of patches originating from OKI which seem to be ahead in terms of functionality. Specifically, the spi driver uses the DMA engine of the PCH/IOH.

I am wondering what this dev branch is and what's its relation to the mainline support of topcliff/PCH/IOH ...


On Mar 31, 2011, at 18:38, Grant Likely wrote:

> On Mon, Feb 28, 2011 at 08:47:57PM +0900, Tomoya MORINAGA wrote:
>> Support ML7213 device of OKI SEMICONDUCTOR.
>> ML7213 is companion chip of Intel Atom E6xx series for IVI(In-Vehicle Infotainment).
>> ML7213 is compatible for Intel EG20T PCH.
>> 
>> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> 
> Hi Tomoya,
> 
> I'm considerably happier with this patch.  I have some more comments
> below, but in general this is moving in the right direction.  Good
> work!
> 
> Sorry that I cannot pick it up for .39, I just didn't have the
> bandwidth to give it the attention it required before the merge
> window.  I'll try to give the next version my utmost attention with
> the hope that it can be merged early for .40
> 
>> ---
>> drivers/spi/Kconfig            |    5 +-
>> drivers/spi/spi_topcliff_pch.c |  481 ++++++++++++++++++++--------------------
>> 2 files changed, 250 insertions(+), 236 deletions(-)
>> 
>> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
>> index bb233a9..6f6fb1f 100644
>> --- a/drivers/spi/Kconfig
>> +++ b/drivers/spi/Kconfig
>> @@ -351,12 +351,15 @@ config SPI_TEGRA
>> 	  SPI driver for NVidia Tegra SoCs
>> 
>> config SPI_TOPCLIFF_PCH
>> -	tristate "Topcliff PCH SPI Controller"
>> +	tristate "Intel EG20T PCH/OKI SEMICONDUCTOR ML7213 IOH SPI controller"
>> 	depends on PCI
>> 	help
>> 	  SPI driver for the Topcliff PCH (Platform Controller Hub) SPI bus
>> 	  used in some x86 embedded processors.
>> 
>> +	  This driver also supports the ML7213, a companion chip for the
>> +	  Atom E6xx series and compatible with the Intel EG20T PCH.
>> +
>> config SPI_TXX9
>> 	tristate "Toshiba TXx9 SPI controller"
>> 	depends on GENERIC_GPIO && CPU_TX49XX
>> diff --git a/drivers/spi/spi_topcliff_pch.c b/drivers/spi/spi_topcliff_pch.c
>> index 79e48d4..93c9bce 100644
>> --- a/drivers/spi/spi_topcliff_pch.c
>> +++ b/drivers/spi/spi_topcliff_pch.c
>> @@ -26,6 +26,7 @@
>> #include <linux/spi/spidev.h>
>> #include <linux/module.h>
>> #include <linux/device.h>
>> +#include <linux/platform_device.h>
>> 
>> /* Register offsets */
>> #define PCH_SPCR		0x00	/* SPI control register */
>> @@ -35,6 +36,7 @@
>> #define PCH_SPDRR		0x10	/* SPI read data register */
>> #define PCH_SSNXCR		0x18	/* SSN Expand Control Register */
>> #define PCH_SRST		0x1C	/* SPI reset register */
>> +#define PCH_SPI_ADDRESS_SIZE	0x20
>> 
>> #define PCH_SPSR_TFD		0x000007C0
>> #define PCH_SPSR_RFD		0x0000F800
>> @@ -88,6 +90,16 @@
>> #define PCH_CLOCK_HZ		50000000
>> #define PCH_MAX_SPBR		1023
>> 
>> +/* Definition for ML7213 by OKI SEMICONDUCTOR */
>> +#define PCI_VENDOR_ID_ROHM		0x10DB
>> +#define PCI_DEVICE_ID_ML7213_SPI	0x802c
>> +
>> +/*
>> + * Set the number of SPI instance max
>> + * Intel EG20T PCH :		1ch
>> + * OKI SEMICONDUCTOR ML7213 IOH :	2ch
>> +*/
>> +#define PCH_SPI_MAX_DEV			2
>> 
>> /**
>>  * struct pch_spi_data - Holds the SPI channel specific details
>> @@ -121,6 +133,8 @@
>>  * @cur_trans:			The current transfer that this SPI driver is
>>  *				handling
>>  * @board_dat:			Reference to the SPI device data structure
>> + * @plat_dev:			platform_device structure
>> + * @ch:				SPI channel number
>>  */
>> struct pch_spi_data {
>> 	void __iomem *io_remap_addr;
>> @@ -144,6 +158,8 @@ struct pch_spi_data {
>> 	struct spi_message *current_msg;
>> 	struct spi_transfer *cur_trans;
>> 	struct pch_spi_board_data *board_dat;
>> +	struct platform_device	*plat_dev;
>> +	int ch;
>> };
>> 
>> /**
>> @@ -153,6 +169,7 @@ struct pch_spi_data {
>>  * @pci_req_sts:	Status of pci_request_regions
>>  * @suspend_sts:	Status of suspend
>>  * @data:		Pointer to SPI channel data structure
>> + * @num:		The number of SPI device instance
>>  */
>> struct pch_spi_board_data {
>> 	struct pci_dev *pdev;
>> @@ -160,11 +177,18 @@ struct pch_spi_board_data {
>> 	u8 pci_req_sts;
>> 	u8 suspend_sts;
>> 	struct pch_spi_data *data;
>> +	int num;
>> +};
>> +
>> +struct pch_pd_dev_save {
>> +	int num;
>> +	struct platform_device *pd_save[PCH_SPI_MAX_DEV];
>> };
>> 
>> static struct pci_device_id pch_spi_pcidev_id[] = {
>> -	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_GE_SPI)},
>> -	{0,}
>> +	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_GE_SPI),    1, },
>> +	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_SPI), 2, },
>> +	{ }
>> };
>> 
>> /**
>> @@ -298,7 +322,6 @@ static irqreturn_t pch_spi_handler(int irq, void *dev_id)
>> 	data = board_dat->data;
>> 	io_remap_addr = data->io_remap_addr;
>> 	spsr = io_remap_addr + PCH_SPSR;
>> -
>> 	reg_spsr_val = ioread32(spsr);
>> 
>> 	/* Check if the interrupt is for SPI device */
> 
> Unrelated whitespace change
> 
>> @@ -309,7 +332,6 @@ static irqreturn_t pch_spi_handler(int irq, void *dev_id)
>> 
>> 	dev_dbg(&board_dat->pdev->dev, "%s EXIT return value=%d\n",
>> 		__func__, ret);
>> -
>> 	return ret;
>> }
>> 
> 
> Ditto.  Lots more through the rest of the file.  Please be careful
> about this, it makes the patch hard to review.
> 
>> @@ -412,7 +434,6 @@ static int pch_spi_setup(struct spi_device *pspi)
>> 
>> static int pch_spi_transfer(struct spi_device *pspi, struct spi_message *pmsg)
>> {
>> -
>> 	struct spi_transfer *transfer;
>> 	struct pch_spi_data *data = spi_master_get_devdata(pspi->master);
>> 	int retval;
>> @@ -469,7 +490,6 @@ static int pch_spi_transfer(struct spi_device *pspi, struct spi_message *pmsg)
>> 			}
>> 		}
>> 	}
>> -
>> 	spin_lock_irqsave(&data->lock, flags);
>> 
>> 	/* We won't process any messages if we have been asked to terminate */
>> @@ -621,7 +641,6 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw,
>> 	data->transfer_active = true;
>> }
>> 
>> -
>> static void pch_spi_nomore_transfer(struct pch_spi_data *data,
>> 						struct spi_message *pmsg)
>> {
>> @@ -742,7 +761,6 @@ static void pch_spi_copy_rx_data(struct pch_spi_data *data, int bpw)
>> 	}
>> }
>> 
>> -
>> static void pch_spi_process_messages(struct work_struct *pwork)
>> {
>> 	struct spi_message *pmsg;
>> @@ -884,46 +902,26 @@ static void pch_spi_free_resources(struct pch_spi_board_data *board_dat)
>> 	/* disable interrupts & free IRQ */
>> 	if (board_dat->irq_reg_sts) {
>> 		/* disable interrupts */
>> -		pch_spi_setclr_reg(board_dat->data->master, PCH_SPCR, 0,
>> -				   PCH_ALL);
>> -
>> -		/* free IRQ */
>> -		free_irq(board_dat->pdev->irq, board_dat);
>> +		pch_spi_setclr_reg(board_dat->data->master, PCH_SPCR,
>> +				   0, PCH_ALL);
> 
> And again, it makes a 2 line change into 7
> 
>> 
>> 		dev_dbg(&board_dat->pdev->dev,
>> -			"%s free_irq invoked successfully\n", __func__);
>> +			"%s free_irq invoked successfully\n",
>> +			__func__);
> 
> Ditto
> 
>> 
>> 		board_dat->irq_reg_sts = false;
>> 	}
>> -
>> -	/* unmap PCI base address */
>> -	if (board_dat->data->io_remap_addr != 0) {
>> -		pci_iounmap(board_dat->pdev, board_dat->data->io_remap_addr);
>> -
>> -		board_dat->data->io_remap_addr = 0;
>> -
>> -		dev_dbg(&board_dat->pdev->dev,
>> -			"%s pci_iounmap invoked successfully\n", __func__);
>> -	}
>> -
>> -	/* release PCI region */
>> -	if (board_dat->pci_req_sts) {
>> -		pci_release_regions(board_dat->pdev);
>> -		dev_dbg(&board_dat->pdev->dev,
>> -			"%s pci_release_regions invoked successfully\n",
>> -			__func__);
>> -		board_dat->pci_req_sts = false;
>> -	}
>> }
>> 
>> static int pch_spi_get_resources(struct pch_spi_board_data *board_dat)
>> {
>> -	void __iomem *io_remap_addr;
>> -	int retval;
>> +	int retval = 0;
>> +
>> 	dev_dbg(&board_dat->pdev->dev, "%s ENTRY\n", __func__);
>> 
>> 	/* create workqueue */
>> 	board_dat->data->wk = create_singlethread_workqueue(KBUILD_MODNAME);
>> +
>> 	if (!board_dat->data->wk) {
>> 		dev_err(&board_dat->pdev->dev,
>> 			"%s create_singlet hread_workqueue failed\n", __func__);
>> @@ -931,46 +929,13 @@ static int pch_spi_get_resources(struct pch_spi_board_data *board_dat)
>> 		goto err_return;
>> 	}
>> 
>> -	dev_dbg(&board_dat->pdev->dev,
>> -		"%s create_singlethread_workqueue success\n", __func__);
>> -
>> -	retval = pci_request_regions(board_dat->pdev, KBUILD_MODNAME);
>> -	if (retval != 0) {
>> -		dev_err(&board_dat->pdev->dev,
>> -			"%s request_region failed\n", __func__);
>> -		goto err_return;
>> -	}
>> -
>> 	board_dat->pci_req_sts = true;
>> 
>> -	io_remap_addr = pci_iomap(board_dat->pdev, 1, 0);
>> -	if (io_remap_addr == 0) {
>> -		dev_err(&board_dat->pdev->dev,
>> -			"%s pci_iomap failed\n", __func__);
>> -		retval = -ENOMEM;
>> -		goto err_return;
>> -	}
>> -
>> -	/* calculate base address for all channels */
>> -	board_dat->data->io_remap_addr = io_remap_addr;
>> -
>> 	/* reset PCH SPI h/w */
>> 	pch_spi_reset(board_dat->data->master);
>> 	dev_dbg(&board_dat->pdev->dev,
>> 		"%s pch_spi_reset invoked successfully\n", __func__);
>> 
>> -	/* register IRQ */
>> -	retval = request_irq(board_dat->pdev->irq, pch_spi_handler,
>> -			     IRQF_SHARED, KBUILD_MODNAME, board_dat);
>> -	if (retval != 0) {
>> -		dev_err(&board_dat->pdev->dev,
>> -			"%s request_irq failed\n", __func__);
>> -		goto err_return;
>> -	}
>> -
>> -	dev_dbg(&board_dat->pdev->dev, "%s request_irq returned=%d\n",
>> -		__func__, retval);
>> -
>> 	board_dat->irq_reg_sts = true;
>> 	dev_dbg(&board_dat->pdev->dev, "%s data->irq_reg_sts=true\n", __func__);
>> 
>> @@ -986,131 +951,96 @@ err_return:
>> 	return retval;
>> }
>> 
>> -static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>> +static int __devinit pch_spi_pd_probe(struct platform_device *plat_dev)
>> {
>> -
>> +	int ret;
>> 	struct spi_master *master;
>> -
>> -	struct pch_spi_board_data *board_dat;
>> -	int retval;
>> -
>> -	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
>> -
>> -	/* allocate memory for private data */
>> -	board_dat = kzalloc(sizeof(struct pch_spi_board_data), GFP_KERNEL);
>> -	if (board_dat == NULL) {
>> -		dev_err(&pdev->dev,
>> -			" %s memory allocation for private data failed\n",
>> -			__func__);
>> -		retval = -ENOMEM;
>> -		goto err_kmalloc;
>> -	}
>> -
>> -	dev_dbg(&pdev->dev,
>> -		"%s memory allocation for private data success\n", __func__);
>> -
>> -	/* enable PCI device */
>> -	retval = pci_enable_device(pdev);
>> -	if (retval != 0) {
>> -		dev_err(&pdev->dev, "%s pci_enable_device FAILED\n", __func__);
>> -
>> -		goto err_pci_en_device;
>> +	struct pch_spi_board_data *board_dat = dev_get_platdata(&plat_dev->dev);
>> +
>> +	master = spi_alloc_master(&board_dat->pdev->dev,
>> +				  sizeof(struct pch_spi_data));
>> +	if (!master) {
>> +		dev_err(&plat_dev->dev, "spi_alloc_master[%d] failed.\n",
>> +			plat_dev->id);
>> +		return -ENOMEM;
>> 	}
>> 
>> -	dev_dbg(&pdev->dev, "%s pci_enable_device returned=%d\n",
>> -		__func__, retval);
>> -
>> -	board_dat->pdev = pdev;
>> +	board_dat->data = spi_master_get_devdata(master);
>> +	board_dat->data->master = master;
> 
> You need to be careful here.  board_dat is obtained from the platform
> data pointer; but it is a /read only/ data structure.  Device drivers
> are not allowed to modify it (even in this case where another driver
> in the same file produced it in the first place).  The reason being is
> that drivers need to support being unbound/rebound multiple times, and
> subsequent bindings may not work if the data has been changed by a
> driver.
> 
> Basically the rule is platform_data is read-only static information
> about the device.  Drivers that need to maintain their own state need
> to allocated their own private data structure and keep a pointer to it
> with platform_set_drvdata()
> 
>> 
>> -	/* alllocate memory for SPI master */
>> -	master = spi_alloc_master(&pdev->dev, sizeof(struct pch_spi_data));
>> -	if (master == NULL) {
>> -		retval = -ENOMEM;
>> -		dev_err(&pdev->dev, "%s Fail.\n", __func__);
>> -		goto err_spi_alloc_master;
>> +	/* baseaddress + 0x20(offset) */
>> +	board_dat->data->io_remap_addr = pci_iomap(board_dat->pdev, 1, 0) +
>> +						   0x20 * plat_dev->id;
>> +	if (!board_dat->data->io_remap_addr) {
>> +		dev_err(&plat_dev->dev, "%s pci_iomap failed\n", __func__);
>> +		ret = -ENOMEM;
>> +		goto err_pci_iomap;
>> 	}
>> 
>> -	dev_dbg(&pdev->dev,
>> -		"%s spi_alloc_master returned non NULL\n", __func__);
>> +	dev_dbg(&plat_dev->dev, "[ch%d] remap_addr=%p \n",
>> +		plat_dev->id, board_dat->data->io_remap_addr);
>> 
>> 	/* initialize members of SPI master */
>> -	master->bus_num = -1;
>> +	master->bus_num = plat_dev->id;
>> 	master->num_chipselect = PCH_MAX_CS;
>> 	master->setup = pch_spi_setup;
>> 	master->transfer = pch_spi_transfer;
>> -	dev_dbg(&pdev->dev,
>> -		"%s transfer member of SPI master initialized\n", __func__);
>> -
>> -	board_dat->data = spi_master_get_devdata(master);
>> 
>> -	board_dat->data->master = master;
>> +	board_dat->data->plat_dev = plat_dev;
>> 	board_dat->data->n_curnt_chip = 255;
>> -	board_dat->data->board_dat = board_dat;
>> 	board_dat->data->status = STATUS_RUNNING;
>> +	board_dat->data->board_dat = board_dat;
>> +	board_dat->data->ch = plat_dev->id;
>> 
>> 	INIT_LIST_HEAD(&board_dat->data->queue);
>> 	spin_lock_init(&board_dat->data->lock);
>> 	INIT_WORK(&board_dat->data->work, pch_spi_process_messages);
>> 	init_waitqueue_head(&board_dat->data->wait);
>> 
>> -	/* allocate resources for PCH SPI */
>> -	retval = pch_spi_get_resources(board_dat);
>> -	if (retval) {
>> -		dev_err(&pdev->dev, "%s fail(retval=%d)\n", __func__, retval);
>> +	ret = pch_spi_get_resources(board_dat);
>> +	if (ret) {
>> +		dev_err(&plat_dev->dev, "%s fail(retval=%d)\n", __func__, ret);
>> 		goto err_spi_get_resources;
>> 	}
>> 
>> -	dev_dbg(&pdev->dev, "%s pch_spi_get_resources returned=%d\n",
>> -		__func__, retval);
>> -
>> -	/* save private data in dev */
>> -	pci_set_drvdata(pdev, board_dat);
>> -	dev_dbg(&pdev->dev, "%s invoked pci_set_drvdata\n", __func__);
>> +	ret = request_irq(board_dat->pdev->irq, pch_spi_handler,
>> +			  IRQF_SHARED, KBUILD_MODNAME, board_dat);
>> +	if (ret) {
>> +		dev_err(&plat_dev->dev,
>> +			"%s request_irq failed\n", __func__);
>> +		goto err_request_irq;
>> +	}
>> 
>> -	/* set master mode */
>> 	pch_spi_set_master_mode(master);
>> -	dev_dbg(&pdev->dev,
>> -		"%s invoked pch_spi_set_master_mode\n", __func__);
>> 
>> -	/* Register the controller with the SPI core. */
>> -	retval = spi_register_master(master);
>> -	if (retval != 0) {
>> -		dev_err(&pdev->dev,
>> +	ret = spi_register_master(master);
>> +	if (ret != 0) {
>> +		dev_err(&plat_dev->dev,
>> 			"%s spi_register_master FAILED\n", __func__);
>> -		goto err_spi_reg_master;
>> +		goto err_spi_register_master;
>> 	}
>> 
>> -	dev_dbg(&pdev->dev, "%s spi_register_master returned=%d\n",
>> -		__func__, retval);
>> -
>> -
>> 	return 0;
>> 
>> -err_spi_reg_master:
>> -	spi_unregister_master(master);
>> +err_spi_register_master:
>> +	free_irq(board_dat->pdev->irq, board_dat);
>> +err_request_irq:
>> +	pch_spi_free_resources(board_dat);
>> err_spi_get_resources:
>> -err_spi_alloc_master:
>> +	pci_iounmap(board_dat->pdev, board_dat->data->io_remap_addr);
>> +err_pci_iomap:
>> 	spi_master_put(master);
>> -	pci_disable_device(pdev);
>> -err_pci_en_device:
>> -	kfree(board_dat);
>> -err_kmalloc:
>> -	return retval;
>> +
>> +	return ret;
>> }
>> 
>> -static void pch_spi_remove(struct pci_dev *pdev)
>> +static int __devexit pch_spi_pd_remove(struct platform_device *plat_dev)
>> {
>> -	struct pch_spi_board_data *board_dat = pci_get_drvdata(pdev);
>> +	struct pch_spi_board_data *board_dat = dev_get_platdata(&plat_dev->dev);
>> 	int count;
>> 
>> -	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
>> -
>> -	if (!board_dat) {
>> -		dev_err(&pdev->dev,
>> -			"%s pci_get_drvdata returned NULL\n", __func__);
>> -		return;
>> -	}
>> -
>> +	dev_dbg(&plat_dev->dev, "%s:[ch%d] irq=%d \n",
>> +		__func__, plat_dev->id, board_dat->pdev->irq);
>> 	/* check for any pending messages; no action is taken if the queue
>> 	 * is still full; but at least we tried.  Unload anyway */
>> 	count = 500;
>> @@ -1125,116 +1055,217 @@ static void pch_spi_remove(struct pci_dev *pdev)
>> 	}
>> 	spin_unlock(&board_dat->data->lock);
>> 
>> -	/* Free resources allocated for PCH SPI */
>> 	pch_spi_free_resources(board_dat);
>> -
>> +	free_irq(board_dat->pdev->irq, board_dat);
>> +	pci_iounmap(board_dat->pdev, board_dat->data->io_remap_addr);
>> 	spi_unregister_master(board_dat->data->master);
>> +	spi_master_put(board_dat->data->master);
>> +	platform_set_drvdata(plat_dev, NULL);
>> 
>> -	/* free memory for private data */
>> -	kfree(board_dat);
>> -
>> -	pci_set_drvdata(pdev, NULL);
>> -
>> -	/* disable PCI device */
>> -	pci_disable_device(pdev);
>> -
>> -	dev_dbg(&pdev->dev, "%s invoked pci_disable_device\n", __func__);
>> +	return 0;
>> }
>> 
>> -#ifdef CONFIG_PM
>> -static int pch_spi_suspend(struct pci_dev *pdev, pm_message_t state)
>> +static int pch_spi_pd_suspend(struct platform_device *pd_dev, pm_message_t state)
>> {
>> 	u8 count;
>> -	int retval;
>> -
>> -	struct pch_spi_board_data *board_dat = pci_get_drvdata(pdev);
>> +	struct pch_spi_board_data *board_dat = dev_get_platdata(&pd_dev->dev);
>> 
>> -	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
>> +	dev_dbg(&pd_dev->dev, "%s ENTRY\n", __func__);
>> 
>> 	if (!board_dat) {
>> -		dev_err(&pdev->dev,
>> +		dev_err(&pd_dev->dev,
>> 			"%s pci_get_drvdata returned NULL\n", __func__);
>> 		return -EFAULT;
>> 	}
>> 
>> -	retval = 0;
>> 	board_dat->suspend_sts = true;
>> 
>> 	/* check if the current message is processed:
>> 	   Only after thats done the transfer will be suspended */
>> 	count = 255;
>> -	while ((--count) > 0) {
>> +	while ((--count) > 0)
>> 		if (!(board_dat->data->bcurrent_msg_processing)) {
>> -			dev_dbg(&pdev->dev, "%s board_dat->data->bCurrent_"
>> -				"msg_processing = false\n", __func__);
>> 			break;
>> -		} else {
>> -			dev_dbg(&pdev->dev, "%s board_dat->data->bCurrent_msg_"
>> -				"processing = true\n", __func__);
>> -		}
>> 		msleep(PCH_SLEEP_TIME);
>> 	}
>> 
>> 	/* Free IRQ */
>> 	if (board_dat->irq_reg_sts) {
>> 		/* disable all interrupts */
>> -		pch_spi_setclr_reg(board_dat->data->master, PCH_SPCR, 0,
>> -				   PCH_ALL);
>> +		pch_spi_setclr_reg(board_dat->data->master, PCH_SPCR,
>> +					   0, PCH_ALL);
>> 		pch_spi_reset(board_dat->data->master);
>> 
>> 		free_irq(board_dat->pdev->irq, board_dat);
>> 
>> 		board_dat->irq_reg_sts = false;
>> -		dev_dbg(&pdev->dev,
>> +		dev_dbg(&pd_dev->dev,
>> 			"%s free_irq invoked successfully.\n", __func__);
>> 	}
>> 
>> +	return 0;
>> +}
>> +
>> +static int pch_spi_pd_resume(struct platform_device *pd_dev)
>> +{
>> +	struct pch_spi_board_data *board_dat = dev_get_platdata(&pd_dev->dev);
>> +	int retval;
>> +
>> +	if (!board_dat) {
>> +		dev_err(&pd_dev->dev,
>> +			"%s pci_get_drvdata returned NULL\n", __func__);
>> +		return -EFAULT;
>> +	}
>> +
>> +	if (!board_dat->irq_reg_sts) {
>> +		/* register IRQ */
>> +		retval = request_irq(board_dat->pdev->irq, pch_spi_handler,
>> +				     IRQF_SHARED, KBUILD_MODNAME, board_dat);
>> +		if (retval < 0) {
>> +			dev_err(&pd_dev->dev,
>> +				"%s request_irq failed\n", __func__);
>> +			return retval;
>> +		}
>> +		board_dat->irq_reg_sts = true;
>> +
>> +		/* reset PCH SPI h/w */
>> +		pch_spi_reset(board_dat->data->master);
>> +		pch_spi_set_master_mode(board_dat->data->master);
>> +
>> +		/* set suspend status to false */
>> +		board_dat->suspend_sts = false;
>> +
>> +	}
>> +	return 0;
>> +}
>> +
>> +static struct platform_driver pch_spi_pd_driver = {
>> +	.driver = {
>> +		.name = "pch-spi",
>> +		.owner = THIS_MODULE,
>> +	},
>> +	.probe = pch_spi_pd_probe,
>> +	.remove = __devexit_p(pch_spi_pd_remove),
>> +	.suspend = pch_spi_pd_suspend,
>> +	.resume = pch_spi_pd_resume
>> +};
>> +
>> +static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> 
> __devinit
> 
>> +{
>> +	struct pch_spi_board_data board_dat;
>> +	struct platform_device *pd_dev = NULL;
>> +	int retval;
>> +	int i;
>> +	struct pch_pd_dev_save *pd_dev_save;
>> +
>> +	pd_dev_save = kzalloc(sizeof(struct pch_pd_dev_save), GFP_KERNEL);
>> +	if (!pd_dev_save) {
>> +		return -ENOMEM;
>> +	}
>> +
>> +	retval = pci_request_regions(pdev, KBUILD_MODNAME);
>> +	if (retval) {
>> +		dev_err(&pdev->dev, "%s request_region failed\n", __func__);
>> +		return retval;
>> +	}
>> +
>> +	memset(&board_dat, 0, sizeof(board_dat));
>> +	board_dat.pdev = pdev;
>> +	board_dat.num = id->driver_data;
>> +	pd_dev_save->num = id->driver_data;
>> +
>> +	retval = pci_enable_device(pdev);
>> +	if (retval) {
>> +		dev_err(&pdev->dev, "%s pci_enable_device failed\n", __func__);
>> +		goto pci_enable_device;
>> +	}
>> +
>> +	for (i = 0; i < board_dat.num; i++) {
>> +		pd_dev = platform_device_alloc("pch-spi", i);
>> +		if (!pd_dev) {
>> +			dev_err(&pdev->dev, "platform_device_alloc failed\n");
>> +			goto err_platform_device;
>> +		}
>> +		pd_dev->dev.release = NULL;
> 
> Don't clear the release pointer.  It's there for a reason.  When
> the last reference to a platform_device is dropped, the release hook
> allows it to be freed correctly.
> 
>> +		pd_dev_save->pd_save[i] = pd_dev;
> 
> You also need:
> 		pd_dev->parent = &pdev->dev;
> 
> So that the driver model shows the correct hierarchy.
> 
>> +
>> +		retval = platform_device_add_data(pd_dev, &board_dat,
>> +						  sizeof(board_dat));
>> +		if (retval) {
>> +			dev_err(&pdev->dev,
>> +				"platform_device_add_data failed\n");
>> +			platform_device_put(pd_dev);
>> +			goto err_platform_device;
>> +		}
>> +
>> +		retval = platform_device_add(pd_dev);
>> +		if (retval) {
>> +			dev_err(&pdev->dev, "platform_device_add failed\n");
>> +			platform_device_put(pd_dev);
>> +			goto err_platform_device;
>> +		}
>> +	}
>> +
>> +	pci_set_drvdata(pdev, pd_dev_save);
>> +
>> +	return 0;
>> +
>> +err_platform_device:
>> +	pci_disable_device(pdev);
>> +pci_enable_device:
>> +	pci_release_regions(pdev);
>> +
>> +	return retval;
>> +}
>> +
>> +static void pch_spi_remove(struct pci_dev *pdev)
> 
> __devexit
> 
>> +{
>> +	int i;
>> +	struct pch_pd_dev_save *pd_dev_save = pci_get_drvdata(pdev);
>> +
>> +	dev_dbg(&pdev->dev, "%s ENTRY:pdev=%p\n", __func__, pdev);
>> +
>> +	for (i = 0; i < pd_dev_save->num; i++)
>> +		platform_device_unregister(pd_dev_save->pd_save[i]);
>> +
>> +	pci_disable_device(pdev);
>> +	pci_release_regions(pdev);
>> +	kfree(pd_dev_save);
>> +}
>> +
>> +#ifdef CONFIG_PM
>> +static int pch_spi_suspend(struct pci_dev *pdev, pm_message_t state)
>> +{
>> +	int retval;
>> +	int i;
>> +	struct pch_pd_dev_save *pd_dev_save = pci_get_drvdata(pdev);
>> +
>> +	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
>> +
>> +	for (i = 0; i < pd_dev_save->num; i++)
>> +		pch_spi_pd_driver.suspend(pd_dev_save->pd_save[i], state);
> 
> The platform_driver should be doing its own suspend/resume.  If it is
> a child of the PCI device, then the driver model should handle the
> ordering correctly.
> 
> Changing this should also further reduce this # of lines changed in the patch.
> 
>> +
>> 	/* save config space */
>> 	retval = pci_save_state(pdev);
>> -
>> 	if (retval == 0) {
>> -		dev_dbg(&pdev->dev, "%s pci_save_state returned=%d\n",
>> -			__func__, retval);
>> -		/* disable PM notifications */
>> 		pci_enable_wake(pdev, PCI_D3hot, 0);
>> -		dev_dbg(&pdev->dev,
>> -			"%s pci_enable_wake invoked successfully\n", __func__);
>> -		/* disable PCI device */
>> 		pci_disable_device(pdev);
>> -		dev_dbg(&pdev->dev,
>> -			"%s pci_disable_device invoked successfully\n",
>> -			__func__);
>> -		/* move device to D3hot  state */
>> 		pci_set_power_state(pdev, PCI_D3hot);
>> -		dev_dbg(&pdev->dev,
>> -			"%s pci_set_power_state invoked successfully\n",
>> -			__func__);
>> 	} else {
>> 		dev_err(&pdev->dev, "%s pci_save_state failed\n", __func__);
>> 	}
>> 
>> -	dev_dbg(&pdev->dev, "%s return=%d\n", __func__, retval);
>> -
>> 	return retval;
>> }
>> 
>> static int pch_spi_resume(struct pci_dev *pdev)
>> {
>> 	int retval;
>> -
>> -	struct pch_spi_board_data *board = pci_get_drvdata(pdev);
>> +	int i;
>> +	struct pch_pd_dev_save *pd_dev_save = pci_get_drvdata(pdev);
>> 	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
>> 
>> -	if (!board) {
>> -		dev_err(&pdev->dev,
>> -			"%s pci_get_drvdata returned NULL\n", __func__);
>> -		return -EFAULT;
>> -	}
>> -
>> -	/* move device to DO power state */
>> 	pci_set_power_state(pdev, PCI_D0);
>> -
>> -	/* restore state */
>> 	pci_restore_state(pdev);
>> 
>> 	retval = pci_enable_device(pdev);
>> @@ -1242,34 +1273,12 @@ static int pch_spi_resume(struct pci_dev *pdev)
>> 		dev_err(&pdev->dev,
>> 			"%s pci_enable_device failed\n", __func__);
>> 	} else {
>> -		/* disable PM notifications */
>> 		pci_enable_wake(pdev, PCI_D3hot, 0);
>> 
>> -		/* register IRQ handler */
>> -		if (!board->irq_reg_sts) {
>> -			/* register IRQ */
>> -			retval = request_irq(board->pdev->irq, pch_spi_handler,
>> -					     IRQF_SHARED, KBUILD_MODNAME,
>> -					     board);
>> -			if (retval < 0) {
>> -				dev_err(&pdev->dev,
>> -					"%s request_irq failed\n", __func__);
>> -				return retval;
>> -			}
>> -			board->irq_reg_sts = true;
>> -
>> -			/* reset PCH SPI h/w */
>> -			pch_spi_reset(board->data->master);
>> -			pch_spi_set_master_mode(board->data->master);
>> -
>> -			/* set suspend status to false */
>> -			board->suspend_sts = false;
>> -
>> -		}
>> +		for (i = 0; i < pd_dev_save->num; i++)
>> +			pch_spi_pd_driver.resume(pd_dev_save->pd_save[i]);
>> 	}
>> 
>> -	dev_dbg(&pdev->dev, "%s returning=%d\n", __func__, retval);
>> -
>> 	return retval;
>> }
>> #else
>> @@ -1289,15 +1298,17 @@ static struct pci_driver pch_spi_pcidev = {
>> 
>> static int __init pch_spi_init(void)
>> {
>> +	platform_driver_register(&pch_spi_pd_driver);
>> 	return pci_register_driver(&pch_spi_pcidev);
> 
> This doesn't handle a failure in platform_device_register().
> Personally, I'd suggest having the PCI and platform_driver portions in
> separate modules so that each module does it's own error handling, but
> I won't make a big deal about this.
> 
>> }
>> module_init(pch_spi_init);
>> 
>> static void __exit pch_spi_exit(void)
>> {
>> +	platform_driver_unregister(&pch_spi_pd_driver);
>> 	pci_unregister_driver(&pch_spi_pcidev);
> 
> Typically unregistration should be in reverse order from registration.
> 
>> }
>> module_exit(pch_spi_exit);
>> 
>> MODULE_LICENSE("GPL");
>> -MODULE_DESCRIPTION("Topcliff PCH SPI PCI Driver");
>> +MODULE_DESCRIPTION("Intel EG20T PCH/OKI SEMICONDUCTOR ML7213 IOH SPI Driver");
>> -- 
>> 1.7.4
>> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

