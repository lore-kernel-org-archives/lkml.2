Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab0L2Gtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 01:49:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62478 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab0L2Gtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 01:49:41 -0500
Date: Tue, 28 Dec 2010 23:49:37 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/3] spi_topcliff_pch: support new device ML7213
Message-ID: <20101229064937.GC8172@angua.secretlab.ca>
References: <1293449027-3219-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293449027-3219-1-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 08:23:45PM +0900, Tomoya MORINAGA wrote:
> Support ML7213 device of OKI SEMICONDUCTOR.
> ML7213 is companion chip of Intel Atom E6xx series for IVI(In-Vehicle Infotainment).
> ML7213 is completely compatible for Intel EG20T PCH.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/spi/spi_topcliff_pch.c |  293 +++++++++++++++++++++++-----------------

Hi Tomoya,

As previously discussed on this list, I would like to see support for
multiple bus instances implemented differently.  Rather than storing
the spi_master instances in an array in the pci device private data,
the pci device should register a separate platform_device for each spi
bus instance, and each of those bus instances should get bound to a
topcliff_spi_bus driver which doesn't need to have any special
knowledge about how many spi_master instances actually exist.

Basically, the way it is implemented in this patch isn't taking
advantage of the infrastructure and instance management provided by
the driver model.

g.

>  1 files changed, 172 insertions(+), 121 deletions(-)
> 
> diff --git a/drivers/spi/spi_topcliff_pch.c b/drivers/spi/spi_topcliff_pch.c
> index 58e187f..18e077b 100644
> --- a/drivers/spi/spi_topcliff_pch.c
> +++ b/drivers/spi/spi_topcliff_pch.c
> @@ -35,6 +35,7 @@
>  #define PCH_SPDRR		0x10	/* SPI read data register */
>  #define PCH_SSNXCR		0x18	/* SSN Expand Control Register */
>  #define PCH_SRST		0x1C	/* SPI reset register */
> +#define PCH_SPI_ADDRESS_SIZE	0x20
>  
>  #define PCH_SPSR_TFD		0x000007C0
>  #define PCH_SPSR_RFD		0x0000F800
> @@ -88,6 +89,16 @@
>  #define PCH_CLOCK_HZ		50000000
>  #define PCH_MAX_SPBR		1023
>  
> +/* Definition for ML7213 by OKI SEMICONDUCTOR */
> +#define PCI_VENDOR_ID_ROHM		0x10DB
> +#define PCI_DEVICE_ID_ML7213_SPI	0x802c
> +
> +/*
> +Set the number of SPI instance max
> +Intel EG20T PCH :		1ch
> +OKI SEMICONDUCTOR ML7213 IOH :	2ch
> +*/
> +#define PCH_SPI_MAX_DEV			2
>  
>  /**
>   * struct pch_spi_data - Holds the SPI channel specific details
> @@ -153,18 +164,21 @@ struct pch_spi_data {
>   * @pci_req_sts:	Status of pci_request_regions
>   * @suspend_sts:	Status of suspend
>   * @data:		Pointer to SPI channel data structure
> + * @num:		The number of SPI device instance
>   */
>  struct pch_spi_board_data {
>  	struct pci_dev *pdev;
>  	u8 irq_reg_sts;
>  	u8 pci_req_sts;
>  	u8 suspend_sts;
> -	struct pch_spi_data *data;
> +	struct pch_spi_data *data[PCH_SPI_MAX_DEV];
> +	int num;
>  };
>  
>  static struct pci_device_id pch_spi_pcidev_id[] = {
> -	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_GE_SPI)},
> -	{0,}
> +	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_GE_SPI),    1, },
> +	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_SPI), 2, },
> +	{ }
>  };
>  
>  /**
> @@ -267,7 +281,7 @@ static void pch_spi_handler_sub(struct pch_spi_data *data, u32 reg_spsr_val,
>  	if (reg_spsr_val & SPSR_FI_BIT) {
>  		/* disable FI & RFI interrupts */
>  		pch_spi_setclr_reg(data->master, PCH_SPCR, 0,
> -				   SPCR_FIE_BIT | SPCR_TFIE_BIT);
> +				   SPCR_FIE_BIT | SPCR_RFIE_BIT);
>  
>  		/* transfer is completed;inform pch_spi_process_messages */
>  		data->transfer_complete = true;
> @@ -288,6 +302,7 @@ static irqreturn_t pch_spi_handler(int irq, void *dev_id)
>  	void __iomem *io_remap_addr;
>  	irqreturn_t ret = IRQ_NONE;
>  	struct pch_spi_board_data *board_dat = dev_id;
> +	int i;
>  
>  	if (board_dat->suspend_sts) {
>  		dev_dbg(&board_dat->pdev->dev,
> @@ -295,21 +310,22 @@ static irqreturn_t pch_spi_handler(int irq, void *dev_id)
>  		return IRQ_NONE;
>  	}
>  
> -	data = board_dat->data;
> -	io_remap_addr = data->io_remap_addr;
> -	spsr = io_remap_addr + PCH_SPSR;
> +	for (i = 0; i < board_dat->num; i++) {
> +		data = board_dat->data[i];
> +		io_remap_addr = data->io_remap_addr;
> +		spsr = io_remap_addr + PCH_SPSR;
>  
> -	reg_spsr_val = ioread32(spsr);
> +		reg_spsr_val = ioread32(spsr);
>  
> -	/* Check if the interrupt is for SPI device */
> -	if (reg_spsr_val & (SPSR_FI_BIT | SPSR_RFI_BIT)) {
> -		pch_spi_handler_sub(data, reg_spsr_val, io_remap_addr);
> -		ret = IRQ_HANDLED;
> -	}
> -
> -	dev_dbg(&board_dat->pdev->dev, "%s EXIT return value=%d\n",
> -		__func__, ret);
> +		/* Check if the interrupt is for SPI device */
> +		if (reg_spsr_val & (SPSR_FI_BIT | SPSR_RFI_BIT)) {
> +			pch_spi_handler_sub(data, reg_spsr_val, io_remap_addr);
> +			ret = IRQ_HANDLED;
> +		}
>  
> +		dev_dbg(&board_dat->pdev->dev, "%s EXIT return value=%d\n",
> +			__func__, ret);
> +	}
>  	return ret;
>  }
>  
> @@ -679,11 +695,11 @@ static void pch_spi_set_ir(struct pch_spi_data *data)
>  	if ((data->bpw_len) > PCH_MAX_FIFO_DEPTH) {
>  		/* set receive threhold to PCH_RX_THOLD */
>  		pch_spi_setclr_reg(data->master, PCH_SPCR,
> -				   PCH_RX_THOLD << SPCR_TFIC_FIELD,
> -				   ~MASK_TFIC_SPCR_BITS);
> +				   PCH_RX_THOLD << SPCR_RFIC_FIELD,
> +				   ~MASK_RFIC_SPCR_BITS);
>  		/* enable FI and RFI interrupts */
>  		pch_spi_setclr_reg(data->master, PCH_SPCR,
> -				   SPCR_RFIE_BIT | SPCR_TFIE_BIT, 0);
> +				   SPCR_RFIE_BIT | SPCR_FIE_BIT, 0);
>  	} else {
>  		/* set receive threhold to maximum */
>  		pch_spi_setclr_reg(data->master, PCH_SPCR,
> @@ -870,37 +886,46 @@ static void pch_spi_process_messages(struct work_struct *pwork)
>  
>  static void pch_spi_free_resources(struct pch_spi_board_data *board_dat)
>  {
> +	int i;
> +
>  	dev_dbg(&board_dat->pdev->dev, "%s ENTRY\n", __func__);
>  
>  	/* free workqueue */
> -	if (board_dat->data->wk != NULL) {
> -		destroy_workqueue(board_dat->data->wk);
> -		board_dat->data->wk = NULL;
> -		dev_dbg(&board_dat->pdev->dev,
> -			"%s destroy_workqueue invoked successfully\n",
> -			__func__);
> +	for (i = 0; i < board_dat->num; i++) {
> +		if (board_dat->data[i]->wk != NULL) {
> +			destroy_workqueue(board_dat->data[i]->wk);
> +			board_dat->data[i]->wk = NULL;
> +			dev_dbg(&board_dat->pdev->dev,
> +				"%s destroy_workqueue invoked successfully\n",
> +				__func__);
> +		}
>  	}
>  
>  	/* disable interrupts & free IRQ */
>  	if (board_dat->irq_reg_sts) {
> -		/* disable interrupts */
> -		pch_spi_setclr_reg(board_dat->data->master, PCH_SPCR, 0,
> -				   PCH_ALL);
> +		for (i = 0; i < board_dat->num; i++) {
> +			/* disable interrupts */
> +			pch_spi_setclr_reg(board_dat->data[i]->master, PCH_SPCR, 0,
> +					   PCH_ALL);
>  
> -		/* free IRQ */
> -		free_irq(board_dat->pdev->irq, board_dat);
> +			if (i == (board_dat->num - 1)) {
> +				/* free IRQ */
> +				free_irq(board_dat->pdev->irq, board_dat);
>  
> -		dev_dbg(&board_dat->pdev->dev,
> -			"%s free_irq invoked successfully\n", __func__);
> +				dev_dbg(&board_dat->pdev->dev,
> +					"%s free_irq invoked successfully\n", __func__);
>  
> -		board_dat->irq_reg_sts = false;
> +				board_dat->irq_reg_sts = false;
> +			}
> +		}
>  	}
>  
>  	/* unmap PCI base address */
> -	if (board_dat->data->io_remap_addr != 0) {
> -		pci_iounmap(board_dat->pdev, board_dat->data->io_remap_addr);
> +	if (board_dat->data[0]->io_remap_addr != 0) {
> +		pci_iounmap(board_dat->pdev, board_dat->data[0]->io_remap_addr);
>  
> -		board_dat->data->io_remap_addr = 0;
> +		for (i = 0; i < board_dat->num; i++)
> +			board_dat->data[i]->io_remap_addr = 0;
>  
>  		dev_dbg(&board_dat->pdev->dev,
>  			"%s pci_iounmap invoked successfully\n", __func__);
> @@ -920,19 +945,23 @@ static int pch_spi_get_resources(struct pch_spi_board_data *board_dat)
>  {
>  	void __iomem *io_remap_addr;
>  	int retval;
> +	int i;
> +
>  	dev_dbg(&board_dat->pdev->dev, "%s ENTRY\n", __func__);
>  
> -	/* create workqueue */
> -	board_dat->data->wk = create_singlethread_workqueue(KBUILD_MODNAME);
> -	if (!board_dat->data->wk) {
> -		dev_err(&board_dat->pdev->dev,
> -			"%s create_singlet hread_workqueue failed\n", __func__);
> -		retval = -EBUSY;
> -		goto err_return;
> -	}
> +	for (i = 0; i < board_dat->num; i++) {
> +		/* create workqueue */
> +		board_dat->data[i]->wk = create_singlethread_workqueue(KBUILD_MODNAME);
> +		if (!board_dat->data[i]->wk) {
> +			dev_err(&board_dat->pdev->dev,
> +				"%s create_singlet hread_workqueue failed\n", __func__);
> +			retval = -EBUSY;
> +			goto err_return;
> +		}
>  
> -	dev_dbg(&board_dat->pdev->dev,
> -		"%s create_singlethread_workqueue success\n", __func__);
> +		dev_dbg(&board_dat->pdev->dev,
> +			"%s create_singlethread_workqueue success\n", __func__);
> +	}
>  
>  	retval = pci_request_regions(board_dat->pdev, KBUILD_MODNAME);
>  	if (retval != 0) {
> @@ -951,13 +980,15 @@ static int pch_spi_get_resources(struct pch_spi_board_data *board_dat)
>  		goto err_return;
>  	}
>  
> -	/* calculate base address for all channels */
> -	board_dat->data->io_remap_addr = io_remap_addr;
> +	for (i = 0; i < board_dat->num; i++) {
> +		/* calculate base address for all channels */
> +		board_dat->data[i]->io_remap_addr = io_remap_addr + (PCH_SPI_ADDRESS_SIZE * i);
>  
> -	/* reset PCH SPI h/w */
> -	pch_spi_reset(board_dat->data->master);
> -	dev_dbg(&board_dat->pdev->dev,
> -		"%s pch_spi_reset invoked successfully\n", __func__);
> +		/* reset PCH SPI h/w */
> +		pch_spi_reset(board_dat->data[i]->master);
> +		dev_dbg(&board_dat->pdev->dev,
> +			"%s pch_spi_reset invoked successfully\n", __func__);
> +	}
>  
>  	/* register IRQ */
>  	retval = request_irq(board_dat->pdev->irq, pch_spi_handler,
> @@ -989,10 +1020,11 @@ err_return:
>  static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
>  
> -	struct spi_master *master;
> +	struct spi_master *master[PCH_SPI_MAX_DEV];
>  
>  	struct pch_spi_board_data *board_dat;
>  	int retval;
> +	int i, j;
>  
>  	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
>  
> @@ -1021,37 +1053,40 @@ static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		__func__, retval);
>  
>  	board_dat->pdev = pdev;
> +	board_dat->num = id->driver_data;
> +
> +	for (i = 0; i < board_dat->num; i++) {
> +		/* alllocate memory for SPI master */
> +		master[i] = spi_alloc_master(&pdev->dev, sizeof(struct pch_spi_data));
> +		if (master[i] == NULL) {
> +			retval = -ENOMEM;
> +			dev_err(&pdev->dev, "%s Fail.\n", __func__);
> +			goto err_spi_alloc_master;
> +		}
>  
> -	/* alllocate memory for SPI master */
> -	master = spi_alloc_master(&pdev->dev, sizeof(struct pch_spi_data));
> -	if (master == NULL) {
> -		retval = -ENOMEM;
> -		dev_err(&pdev->dev, "%s Fail.\n", __func__);
> -		goto err_spi_alloc_master;
> -	}
> -
> -	dev_dbg(&pdev->dev,
> -		"%s spi_alloc_master returned non NULL\n", __func__);
> +		dev_dbg(&pdev->dev,
> +			"%s spi_alloc_master returned non NULL\n", __func__);
>  
> -	/* initialize members of SPI master */
> -	master->bus_num = -1;
> -	master->num_chipselect = PCH_MAX_CS;
> -	master->setup = pch_spi_setup;
> -	master->transfer = pch_spi_transfer;
> -	dev_dbg(&pdev->dev,
> -		"%s transfer member of SPI master initialized\n", __func__);
> +		/* initialize members of SPI master */
> +		master[i]->bus_num = -1;
> +		master[i]->num_chipselect = PCH_MAX_CS;
> +		master[i]->setup = pch_spi_setup;
> +		master[i]->transfer = pch_spi_transfer;
> +		dev_dbg(&pdev->dev,
> +			"%s transfer member of SPI master initialized\n", __func__);
>  
> -	board_dat->data = spi_master_get_devdata(master);
> +		board_dat->data[i] = spi_master_get_devdata(master[i]);
>  
> -	board_dat->data->master = master;
> -	board_dat->data->n_curnt_chip = 255;
> -	board_dat->data->board_dat = board_dat;
> -	board_dat->data->status = STATUS_RUNNING;
> +		board_dat->data[i]->master = master[i];
> +		board_dat->data[i]->n_curnt_chip = 255;
> +		board_dat->data[i]->board_dat = board_dat;
> +		board_dat->data[i]->status = STATUS_RUNNING;
>  
> -	INIT_LIST_HEAD(&board_dat->data->queue);
> -	spin_lock_init(&board_dat->data->lock);
> -	INIT_WORK(&board_dat->data->work, pch_spi_process_messages);
> -	init_waitqueue_head(&board_dat->data->wait);
> +		INIT_LIST_HEAD(&board_dat->data[i]->queue);
> +		spin_lock_init(&board_dat->data[i]->lock);
> +		INIT_WORK(&board_dat->data[i]->work, pch_spi_process_messages);
> +		init_waitqueue_head(&board_dat->data[i]->wait);
> +	}
>  
>  	/* allocate resources for PCH SPI */
>  	retval = pch_spi_get_resources(board_dat);
> @@ -1068,29 +1103,32 @@ static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	dev_dbg(&pdev->dev, "%s invoked pci_set_drvdata\n", __func__);
>  
>  	/* set master mode */
> -	pch_spi_set_master_mode(master);
> -	dev_dbg(&pdev->dev,
> -		"%s invoked pch_spi_set_master_mode\n", __func__);
> +	for (i = 0; i < board_dat->num; i++) {
> +		pch_spi_set_master_mode(master[i]);
> +		dev_dbg(&pdev->dev,
> +			"%s invoked pch_spi_set_master_mode\n", __func__);
> +
> +		/* Register the controller with the SPI core. */
> +		retval = spi_register_master(master[i]);
> +		if (retval != 0) {
> +			dev_err(&pdev->dev,
> +				"%s spi_register_master FAILED\n", __func__);
> +			goto err_spi_reg_master;
> +		}
>  
> -	/* Register the controller with the SPI core. */
> -	retval = spi_register_master(master);
> -	if (retval != 0) {
> -		dev_err(&pdev->dev,
> -			"%s spi_register_master FAILED\n", __func__);
> -		goto err_spi_reg_master;
> +		dev_dbg(&pdev->dev, "%s spi_register_master returned=%d\n",
> +			__func__, retval);
>  	}
>  
> -	dev_dbg(&pdev->dev, "%s spi_register_master returned=%d\n",
> -		__func__, retval);
> -
> -
>  	return 0;
>  
>  err_spi_reg_master:
> -	spi_unregister_master(master);
> +	for (j = 0; j < i; j++)
> +		spi_unregister_master(master[j]);
>  err_spi_get_resources:
>  err_spi_alloc_master:
> -	spi_master_put(master);
> +	for (j = 0; j < i; j++)
> +		spi_master_put(master[j]);
>  	pci_disable_device(pdev);
>  err_pci_en_device:
>  	kfree(board_dat);
> @@ -1102,6 +1140,7 @@ static void pch_spi_remove(struct pci_dev *pdev)
>  {
>  	struct pch_spi_board_data *board_dat = pci_get_drvdata(pdev);
>  	int count;
> +	int i;
>  
>  	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
>  
> @@ -1113,22 +1152,26 @@ static void pch_spi_remove(struct pci_dev *pdev)
>  
>  	/* check for any pending messages; no action is taken if the queue
>  	 * is still full; but at least we tried.  Unload anyway */
> -	count = 500;
> -	spin_lock(&board_dat->data->lock);
> -	board_dat->data->status = STATUS_EXITING;
> -	while ((list_empty(&board_dat->data->queue) == 0) && --count) {
> -		dev_dbg(&board_dat->pdev->dev, "%s :queue not empty\n",
> -			__func__);
> -		spin_unlock(&board_dat->data->lock);
> -		msleep(PCH_SLEEP_TIME);
> -		spin_lock(&board_dat->data->lock);
> +	for (i = 0; i < board_dat->num; i++) {
> +		count = 500;
> +		spin_lock(&board_dat->data[i]->lock);
> +		board_dat->data[i]->status = STATUS_EXITING;
> +		while ((list_empty(&board_dat->data[i]->queue) == 0) && --count) {
> +			dev_dbg(&board_dat->pdev->dev, "%s :queue not empty\n",
> +				__func__);
> +			spin_unlock(&board_dat->data[i]->lock);
> +			msleep(PCH_SLEEP_TIME);
> +			spin_lock(&board_dat->data[i]->lock);
> +		}
> +		spin_unlock(&board_dat->data[i]->lock);
>  	}
> -	spin_unlock(&board_dat->data->lock);
>  
>  	/* Free resources allocated for PCH SPI */
>  	pch_spi_free_resources(board_dat);
>  
> -	spi_unregister_master(board_dat->data->master);
> +	/* Unregister SPI master */
> +	for (i = 0; i < board_dat->num; i++)
> +		spi_unregister_master(board_dat->data[i]->master);
>  
>  	/* free memory for private data */
>  	kfree(board_dat);
> @@ -1146,6 +1189,7 @@ static int pch_spi_suspend(struct pci_dev *pdev, pm_message_t state)
>  {
>  	u8 count;
>  	int retval;
> +	int i;
>  
>  	struct pch_spi_board_data *board_dat = pci_get_drvdata(pdev);
>  
> @@ -1162,25 +1206,29 @@ static int pch_spi_suspend(struct pci_dev *pdev, pm_message_t state)
>  
>  	/* check if the current message is processed:
>  	   Only after thats done the transfer will be suspended */
> -	count = 255;
> -	while ((--count) > 0) {
> -		if (!(board_dat->data->bcurrent_msg_processing)) {
> -			dev_dbg(&pdev->dev, "%s board_dat->data->bCurrent_"
> -				"msg_processing = false\n", __func__);
> -			break;
> -		} else {
> -			dev_dbg(&pdev->dev, "%s board_dat->data->bCurrent_msg_"
> -				"processing = true\n", __func__);
> +	for (i = 0; i < board_dat->num; i++) {
> +		count = 255;
> +		while ((--count) > 0) {
> +			if (!(board_dat->data[i]->bcurrent_msg_processing)) {
> +				dev_dbg(&pdev->dev, "%s board_dat->data->bCurrent_"
> +					"msg_processing = false\n", __func__);
> +				break;
> +			} else {
> +				dev_dbg(&pdev->dev, "%s board_dat->data->bCurrent_msg_"
> +					"processing = true\n", __func__);
> +			}
> +			msleep(PCH_SLEEP_TIME);
>  		}
> -		msleep(PCH_SLEEP_TIME);
>  	}
>  
>  	/* Free IRQ */
>  	if (board_dat->irq_reg_sts) {
> -		/* disable all interrupts */
> -		pch_spi_setclr_reg(board_dat->data->master, PCH_SPCR, 0,
> -				   PCH_ALL);
> -		pch_spi_reset(board_dat->data->master);
> +		/* disable all interrupts */	
> +		for (i = 0; i < board_dat->num; i++) {
> +			pch_spi_setclr_reg(board_dat->data[i]->master, PCH_SPCR, 0,
> +					   PCH_ALL);
> +			pch_spi_reset(board_dat->data[i]->master);
> +		}
>  
>  		free_irq(board_dat->pdev->irq, board_dat);
>  
> @@ -1221,6 +1269,7 @@ static int pch_spi_suspend(struct pci_dev *pdev, pm_message_t state)
>  static int pch_spi_resume(struct pci_dev *pdev)
>  {
>  	int retval;
> +	int i;
>  
>  	struct pch_spi_board_data *board = pci_get_drvdata(pdev);
>  	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
> @@ -1259,8 +1308,10 @@ static int pch_spi_resume(struct pci_dev *pdev)
>  			board->irq_reg_sts = true;
>  
>  			/* reset PCH SPI h/w */
> -			pch_spi_reset(board->data->master);
> -			pch_spi_set_master_mode(board->data->master);
> +			for (i = 0; i < board->num; i++) {
> +				pch_spi_reset(board->data[i]->master);
> +				pch_spi_set_master_mode(board->data[i]->master);
> +			}
>  
>  			/* set suspend status to false */
>  			board->suspend_sts = false;
> -- 
> 1.6.0.6
> 
