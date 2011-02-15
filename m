Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1BOL2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 06:28:46 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:11139 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754459Ab1BOL2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 06:28:43 -0500
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'David Brownell'" <dbrownell@users.sourceforge.net>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Cc: <qi.wang@intel.com>, <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>,
        "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>
References: <1296029223-20328-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Subject: RE: [PATCH v2] spi_topcliff_pch: support new device ML7213 IOH
Date: Tue, 15 Feb 2011 20:28:38 +0900
Message-ID: <BCCBD2549B274B869C947648453DC9DD@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Acu9MGiHYS9NaDPATzWu9ay4IEY44wP0Q/gw
In-Reply-To: <1296029223-20328-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Grant,

Could you review my patch ?

With Best Regards,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

> -----Original Message-----
> From: Tomoya MORINAGA [mailto:tomoya-linux@dsn.okisemi.com] 
> Sent: Wednesday, January 26, 2011 5:07 PM
> To: David Brownell; Grant Likely; 
> spi-devel-general@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Cc: qi.wang@intel.com; yong.y.wang@intel.com; 
> joel.clark@intel.com; kok.howg.ewe@intel.com; Tomoya MORINAGA
> Subject: [PATCH v2] spi_topcliff_pch: support new device ML7213 IOH
> 
> Support ML7213 device of OKI SEMICONDUCTOR.
> ML7213 is companion chip of Intel Atom E6xx series for 
> IVI(In-Vehicle Infotainment).
> ML7213 is completely compatible for Intel EG20T PCH.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/spi/Kconfig            |    7 +-
>  drivers/spi/spi_topcliff_pch.c |  450 
> ++++++++++++++++++++++------------------
>  2 files changed, 250 insertions(+), 207 deletions(-)
> 
> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig index 
> bb233a9..f36631c 100644
> --- a/drivers/spi/Kconfig
> +++ b/drivers/spi/Kconfig
> @@ -351,12 +351,17 @@ config SPI_TEGRA
>  	  SPI driver for NVidia Tegra SoCs
>  
>  config SPI_TOPCLIFF_PCH
> -	tristate "Topcliff PCH SPI Controller"
> +	tristate "Intel EG20T PCH/OKI SEMICONDUCTOR ML7213 IOH 
> SPI controller"
>  	depends on PCI
>  	help
>  	  SPI driver for the Topcliff PCH (Platform Controller 
> Hub) SPI bus
>  	  used in some x86 embedded processors.
>  
> +	  This driver also can be used for OKI SEMICONDUCTOR's 
> ML7213 IOH which
> +	  is for IVI(In-Vehicle Infotainment) use.
> +	  ML7213 IOH is companion chip for Intel Atom E6xx series.
> +	  ML7213 IOH is completely compatible for Intel EG20T PCH.
> +
>  config SPI_TXX9
>  	tristate "Toshiba TXx9 SPI controller"
>  	depends on GENERIC_GPIO && CPU_TX49XX
> diff --git a/drivers/spi/spi_topcliff_pch.c 
> b/drivers/spi/spi_topcliff_pch.c index 79e48d4..81feb11 100644
> --- a/drivers/spi/spi_topcliff_pch.c
> +++ b/drivers/spi/spi_topcliff_pch.c
> @@ -26,6 +26,7 @@
>  #include <linux/spi/spidev.h>
>  #include <linux/module.h>
>  #include <linux/device.h>
> +#include <linux/platform_device.h>
>  
>  /* Register offsets */
>  #define PCH_SPCR		0x00	/* SPI control register */
> @@ -35,6 +36,7 @@
>  #define PCH_SPDRR		0x10	/* SPI read data register */
>  #define PCH_SSNXCR		0x18	/* SSN Expand Control 
> Register */
>  #define PCH_SRST		0x1C	/* SPI reset register */
> +#define PCH_SPI_ADDRESS_SIZE	0x20
>  
>  #define PCH_SPSR_TFD		0x000007C0
>  #define PCH_SPSR_RFD		0x0000F800
> @@ -88,6 +90,16 @@
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
>   * struct pch_spi_data - Holds the SPI channel specific 
> details @@ -121,6 +133,8 @@
>   * @cur_trans:			The current transfer 
> that this SPI driver is
>   *				handling
>   * @board_dat:			Reference to the SPI 
> device data structure
> + * @plat_dev:			platform_device structure
> + * @ch:				SPI channel number
>   */
>  struct pch_spi_data {
>  	void __iomem *io_remap_addr;
> @@ -144,6 +158,8 @@ struct pch_spi_data {
>  	struct spi_message *current_msg;
>  	struct spi_transfer *cur_trans;
>  	struct pch_spi_board_data *board_dat;
> +	struct platform_device	plat_dev;
> +	int ch;
>  };
>  
>  /**
> @@ -153,18 +169,21 @@ struct pch_spi_data {
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
> @@ -288,6 +307,7 @@ static irqreturn_t pch_spi_handler(int 
> irq, void *dev_id)
>  	void __iomem *io_remap_addr;
>  	irqreturn_t ret = IRQ_NONE;
>  	struct pch_spi_board_data *board_dat = dev_id;
> +	int i;
>  
>  	if (board_dat->suspend_sts) {
>  		dev_dbg(&board_dat->pdev->dev,
> @@ -295,21 +315,21 @@ static irqreturn_t pch_spi_handler(int 
> irq, void *dev_id)
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
> +		reg_spsr_val = ioread32(spsr);
>  
> -	reg_spsr_val = ioread32(spsr);
> +		/* Check if the interrupt is for SPI device */
> +		if (reg_spsr_val & (SPSR_FI_BIT | SPSR_RFI_BIT)) {
> +			pch_spi_handler_sub(data, reg_spsr_val, 
> io_remap_addr);
> +			ret = IRQ_HANDLED;
> +		}
>  
> -	/* Check if the interrupt is for SPI device */
> -	if (reg_spsr_val & (SPSR_FI_BIT | SPSR_RFI_BIT)) {
> -		pch_spi_handler_sub(data, reg_spsr_val, io_remap_addr);
> -		ret = IRQ_HANDLED;
> +		dev_dbg(&board_dat->pdev->dev, "%s EXIT return 
> value=%d\n",
> +			__func__, ret);
>  	}
> -
> -	dev_dbg(&board_dat->pdev->dev, "%s EXIT return value=%d\n",
> -		__func__, ret);
> -
>  	return ret;
>  }
>  
> @@ -870,107 +890,63 @@ static void 
> pch_spi_process_messages(struct work_struct *pwork)
>  
>  static void pch_spi_free_resources(struct pch_spi_board_data 
> *board_dat)  {
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
> +				"%s destroy_workqueue invoked 
> successfully\n",
> +				__func__);
> +		}
>  	}
>  
>  	/* disable interrupts & free IRQ */
>  	if (board_dat->irq_reg_sts) {
> -		/* disable interrupts */
> -		pch_spi_setclr_reg(board_dat->data->master, PCH_SPCR, 0,
> -				   PCH_ALL);
> -
> -		/* free IRQ */
> -		free_irq(board_dat->pdev->irq, board_dat);
> -
> -		dev_dbg(&board_dat->pdev->dev,
> -			"%s free_irq invoked successfully\n", __func__);
> -
> -		board_dat->irq_reg_sts = false;
> -	}
> -
> -	/* unmap PCI base address */
> -	if (board_dat->data->io_remap_addr != 0) {
> -		pci_iounmap(board_dat->pdev, 
> board_dat->data->io_remap_addr);
> +		for (i = 0; i < board_dat->num; i++) {
> +			/* disable interrupts */
> +			
> pch_spi_setclr_reg(board_dat->data[i]->master, PCH_SPCR,
> +					   0, PCH_ALL);
>  
> -		board_dat->data->io_remap_addr = 0;
> +			if (i == (board_dat->num - 1)) {
> +				dev_dbg(&board_dat->pdev->dev,
> +					"%s free_irq invoked 
> successfully\n",
> +					__func__);
>  
> -		dev_dbg(&board_dat->pdev->dev,
> -			"%s pci_iounmap invoked 
> successfully\n", __func__);
> -	}
> -
> -	/* release PCI region */
> -	if (board_dat->pci_req_sts) {
> -		pci_release_regions(board_dat->pdev);
> -		dev_dbg(&board_dat->pdev->dev,
> -			"%s pci_release_regions invoked successfully\n",
> -			__func__);
> -		board_dat->pci_req_sts = false;
> +				board_dat->irq_reg_sts = false;
> +			}
> +		}
>  	}
>  }
>  
> -static int pch_spi_get_resources(struct pch_spi_board_data 
> *board_dat)
> +static int pch_spi_get_resources(struct pch_spi_board_data 
> *board_dat, 
> +int num)
>  {
> -	void __iomem *io_remap_addr;
> -	int retval;
> +	int retval = 0;
> +
>  	dev_dbg(&board_dat->pdev->dev, "%s ENTRY\n", __func__);
>  
>  	/* create workqueue */
> -	board_dat->data->wk = 
> create_singlethread_workqueue(KBUILD_MODNAME);
> -	if (!board_dat->data->wk) {
> +	board_dat->data[num]->wk =
> +				  
> create_singlethread_workqueue(KBUILD_MODNAME);
> +
> +	if (!board_dat->data[num]->wk) {
>  		dev_err(&board_dat->pdev->dev,
>  			"%s create_singlet hread_workqueue 
> failed\n", __func__);
>  		retval = -EBUSY;
>  		goto err_return;
>  	}
>  
> -	dev_dbg(&board_dat->pdev->dev,
> -		"%s create_singlethread_workqueue success\n", __func__);
> -
> -	retval = pci_request_regions(board_dat->pdev, KBUILD_MODNAME);
> -	if (retval != 0) {
> -		dev_err(&board_dat->pdev->dev,
> -			"%s request_region failed\n", __func__);
> -		goto err_return;
> -	}
> -
>  	board_dat->pci_req_sts = true;
>  
> -	io_remap_addr = pci_iomap(board_dat->pdev, 1, 0);
> -	if (io_remap_addr == 0) {
> -		dev_err(&board_dat->pdev->dev,
> -			"%s pci_iomap failed\n", __func__);
> -		retval = -ENOMEM;
> -		goto err_return;
> -	}
> -
> -	/* calculate base address for all channels */
> -	board_dat->data->io_remap_addr = io_remap_addr;
> -
>  	/* reset PCH SPI h/w */
> -	pch_spi_reset(board_dat->data->master);
> +	pch_spi_reset(board_dat->data[num]->master);
>  	dev_dbg(&board_dat->pdev->dev,
>  		"%s pch_spi_reset invoked successfully\n", __func__);
>  
> -	/* register IRQ */
> -	retval = request_irq(board_dat->pdev->irq, pch_spi_handler,
> -			     IRQF_SHARED, KBUILD_MODNAME, board_dat);
> -	if (retval != 0) {
> -		dev_err(&board_dat->pdev->dev,
> -			"%s request_irq failed\n", __func__);
> -		goto err_return;
> -	}
> -
> -	dev_dbg(&board_dat->pdev->dev, "%s request_irq returned=%d\n",
> -		__func__, retval);
> -
>  	board_dat->irq_reg_sts = true;
>  	dev_dbg(&board_dat->pdev->dev, "%s 
> data->irq_reg_sts=true\n", __func__);
>  
> @@ -986,15 +962,105 @@ err_return:
>  	return retval;
>  }
>  
> -static int pch_spi_probe(struct pci_dev *pdev, const struct 
> pci_device_id *id)
> +static int __devinit pch_spi_pd_probe(struct platform_device 
> *plat_dev)
>  {
> -
> +	int ret;
>  	struct spi_master *master;
> +	struct pch_spi_data *data = platform_get_drvdata(plat_dev);
> +
> +	master = data->master;
> +
> +	/* initialize members of SPI master */
> +	master->bus_num = data->ch;
> +	master->num_chipselect = PCH_MAX_CS;
> +	master->setup = pch_spi_setup;
> +	master->transfer = pch_spi_transfer;
> +	data->master = master;
> +	data->n_curnt_chip = 255;
> +	data->status = STATUS_RUNNING;
> +	INIT_LIST_HEAD(&data->queue);
> +	spin_lock_init(&data->lock);
> +	INIT_WORK(&data->work, pch_spi_process_messages);
> +	init_waitqueue_head(&data->wait);
> +
> +	ret = pch_spi_get_resources(data->board_dat, data->ch);
> +	if (ret) {
> +		dev_err(&plat_dev->dev, "%s fail(retval=%d)\n", 
> __func__, ret);
> +		goto err_spi_get_resources;
> +	}
> +
> +	pch_spi_set_master_mode(master);
> +
> +	ret = spi_register_master(master);
> +	if (ret != 0) {
> +		dev_err(&plat_dev->dev,
> +			"%s spi_register_master FAILED\n", __func__);
> +		goto err_spi_reg_master;
> +	}
> +
> +	return 0;
> +
> +err_spi_reg_master:
> +	pch_spi_free_resources(data->board_dat);
> +err_spi_get_resources:
> +
> +	return ret;
> +}
> +
> +static int pch_spi_pd_remove(struct platform_device *plat_dev) {
> +	struct pch_spi_data *data = platform_get_drvdata(plat_dev);
> +
> +	spi_unregister_master(data->master);
> +	pch_spi_free_resources(data->board_dat);
> +	platform_set_drvdata(plat_dev, NULL);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver pch_spi_pd_driver = {
> +	.driver = {
> +		.name = "pch-spi",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = pch_spi_pd_probe,
> +	.remove = __devexit_p(pch_spi_pd_remove), };
> +
> +static void pch_spi_release_slot(struct device *dev) { } static int 
> +pch_spi_register_slot(struct pch_spi_board_data *board_dat,
> +				 unsigned io_offset, const char 
> *name, int ch) {
> +	int err;
> +
> +	board_dat->data[ch]->ch = ch;
> +	board_dat->data[ch]->plat_dev.name = name;
> +	board_dat->data[ch]->plat_dev.id = ch;
> +	board_dat->data[ch]->board_dat = board_dat;
> +	board_dat->data[ch]->plat_dev.dev.parent = 
> &board_dat->pdev->dev;
> +	board_dat->data[ch]->plat_dev.dev.release = 
> pch_spi_release_slot;
> +
> +	platform_set_drvdata(&board_dat->data[ch]->plat_dev,
> +			     board_dat->data[ch]);
> +
> +	err = platform_device_register(&board_dat->data[ch]->plat_dev);
> +	if (err) {
> +		platform_device_put(&board_dat->data[ch]->plat_dev);
> +		return err;
> +	}
> +
> +	return 0;
> +}
>  
> +static int pch_spi_probe(struct pci_dev *pdev, const struct 
> +pci_device_id *id) {
> +	struct spi_master *master[PCH_SPI_MAX_DEV];
>  	struct pch_spi_board_data *board_dat;
> +	void __iomem *io_remap_addr;
>  	int retval;
> -
> -	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
> +	int i, j;
>  
>  	/* allocate memory for private data */
>  	board_dat = kzalloc(sizeof(struct pch_spi_board_data), 
> GFP_KERNEL); @@ -1002,14 +1068,9 @@ static int 
> pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		dev_err(&pdev->dev,
>  			" %s memory allocation for private data 
> failed\n",
>  			__func__);
> -		retval = -ENOMEM;
> -		goto err_kmalloc;
> +		return -ENOMEM;
>  	}
>  
> -	dev_dbg(&pdev->dev,
> -		"%s memory allocation for private data 
> success\n", __func__);
> -
> -	/* enable PCI device */
>  	retval = pci_enable_device(pdev);
>  	if (retval != 0) {
>  		dev_err(&pdev->dev, "%s pci_enable_device 
> FAILED\n", __func__); @@ -1017,128 +1078,97 @@ static int 
> pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		goto err_pci_en_device;
>  	}
>  
> -	dev_dbg(&pdev->dev, "%s pci_enable_device returned=%d\n",
> -		__func__, retval);
> -
> +	pci_set_drvdata(pdev, board_dat);
>  	board_dat->pdev = pdev;
> +	board_dat->num = id->driver_data;
> +
> +	for (i = 0; i < board_dat->num; i++) {
> +		master[i] = spi_alloc_master(&pdev->dev,
> +					     sizeof(struct 
> pch_spi_data));
> +		if (master[i] == NULL) {
> +			dev_err(&pdev->dev, "%s spi_alloc 
> failed.\n", __func__);
> +			retval = -ENOMEM;
> +			goto err_spi_alloc;
> +		}
> +		board_dat->data[i] = spi_master_get_devdata(master[i]);
> +		board_dat->data[i]->master = master[i];
> +	}
>  
> -	/* alllocate memory for SPI master */
> -	master = spi_alloc_master(&pdev->dev, sizeof(struct 
> pch_spi_data));
> -	if (master == NULL) {
> +	io_remap_addr = pci_iomap(board_dat->pdev, 1, 0);
> +	if (!io_remap_addr) {
> +		dev_err(&board_dat->pdev->dev,
> +			"%s pci_iomap failed\n", __func__);
>  		retval = -ENOMEM;
> -		dev_err(&pdev->dev, "%s Fail.\n", __func__);
> -		goto err_spi_alloc_master;
> +		goto err_pci_iomap;
>  	}
>  
> -	dev_dbg(&pdev->dev,
> -		"%s spi_alloc_master returned non NULL\n", __func__);
> -
> -	/* initialize members of SPI master */
> -	master->bus_num = -1;
> -	master->num_chipselect = PCH_MAX_CS;
> -	master->setup = pch_spi_setup;
> -	master->transfer = pch_spi_transfer;
> -	dev_dbg(&pdev->dev,
> -		"%s transfer member of SPI master 
> initialized\n", __func__);
> -
> -	board_dat->data = spi_master_get_devdata(master);
> -
> -	board_dat->data->master = master;
> -	board_dat->data->n_curnt_chip = 255;
> -	board_dat->data->board_dat = board_dat;
> -	board_dat->data->status = STATUS_RUNNING;
> +	retval = pci_request_regions(board_dat->pdev, KBUILD_MODNAME);
> +	if (retval != 0) {
> +		dev_err(&board_dat->pdev->dev,
> +			"%s request_region failed\n", __func__);
> +		goto err_req_reg;
> +	}
>  
> -	INIT_LIST_HEAD(&board_dat->data->queue);
> -	spin_lock_init(&board_dat->data->lock);
> -	INIT_WORK(&board_dat->data->work, pch_spi_process_messages);
> -	init_waitqueue_head(&board_dat->data->wait);
> +	for (i = 0; i < board_dat->num; i++)
> +		board_dat->data[i]->io_remap_addr = io_remap_addr +
> +						    
> (PCH_SPI_ADDRESS_SIZE * i);
>  
> -	/* allocate resources for PCH SPI */
> -	retval = pch_spi_get_resources(board_dat);
> +	retval = request_irq(pdev->irq, pch_spi_handler,
> +			     IRQF_SHARED, KBUILD_MODNAME, board_dat);
>  	if (retval) {
> -		dev_err(&pdev->dev, "%s fail(retval=%d)\n", 
> __func__, retval);
> -		goto err_spi_get_resources;
> +		dev_err(&board_dat->pdev->dev,
> +			"%s request_irq failed\n", __func__);
> +		goto err_req_irq;
>  	}
>  
> -	dev_dbg(&pdev->dev, "%s pch_spi_get_resources returned=%d\n",
> -		__func__, retval);
> -
> -	/* save private data in dev */
> -	pci_set_drvdata(pdev, board_dat);
> -	dev_dbg(&pdev->dev, "%s invoked pci_set_drvdata\n", __func__);
> -
> -	/* set master mode */
> -	pch_spi_set_master_mode(master);
> -	dev_dbg(&pdev->dev,
> -		"%s invoked pch_spi_set_master_mode\n", __func__);
> +	platform_driver_register(&pch_spi_pd_driver);
>  
> -	/* Register the controller with the SPI core. */
> -	retval = spi_register_master(master);
> -	if (retval != 0) {
> -		dev_err(&pdev->dev,
> -			"%s spi_register_master FAILED\n", __func__);
> -		goto err_spi_reg_master;
> +	for (i = 0; i < board_dat->num; i++) {
> +		retval = pch_spi_register_slot(board_dat, 
> PCH_SPI_ADDRESS_SIZE,
> +					       "pch-spi", i);
> +		if (retval)
> +			goto err_spi_reg;
>  	}
>  
> -	dev_dbg(&pdev->dev, "%s spi_register_master returned=%d\n",
> -		__func__, retval);
> -
> -
>  	return 0;
>  
> -err_spi_reg_master:
> -	spi_unregister_master(master);
> -err_spi_get_resources:
> -err_spi_alloc_master:
> -	spi_master_put(master);
> +err_spi_reg:
> +	platform_driver_unregister(&pch_spi_pd_driver);
> +	free_irq(pdev->irq, board_dat);
> +err_req_irq:
> +	pci_release_regions(board_dat->pdev);
> +	board_dat->pci_req_sts = false;
> +err_req_reg:
> +	pci_iounmap(board_dat->pdev, board_dat->data[0]->io_remap_addr);
> +err_pci_iomap:
> +err_spi_alloc:
> +	for (j = 0; j < i; j++)
> +		spi_master_put(master[j]);
>  	pci_disable_device(pdev);
>  err_pci_en_device:
>  	kfree(board_dat);
> -err_kmalloc:
> +
>  	return retval;
>  }
>  
>  static void pch_spi_remove(struct pci_dev *pdev)  {
>  	struct pch_spi_board_data *board_dat = pci_get_drvdata(pdev);
> -	int count;
> +	int i;
>  
> -	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
> -
> -	if (!board_dat) {
> -		dev_err(&pdev->dev,
> -			"%s pci_get_drvdata returned NULL\n", __func__);
> -		return;
> -	}
> -
> -	/* check for any pending messages; no action is taken 
> if the queue
> -	 * is still full; but at least we tried.  Unload anyway */
> -	count = 500;
> -	spin_lock(&board_dat->data->lock);
> -	board_dat->data->status = STATUS_EXITING;
> -	while ((list_empty(&board_dat->data->queue) == 0) && --count) {
> -		dev_dbg(&board_dat->pdev->dev, "%s :queue not empty\n",
> -			__func__);
> -		spin_unlock(&board_dat->data->lock);
> -		msleep(PCH_SLEEP_TIME);
> -		spin_lock(&board_dat->data->lock);
> -	}
> -	spin_unlock(&board_dat->data->lock);
> +	for (i = 0; i < board_dat->num; i++)
> +		
> platform_device_unregister(&board_dat->data[i]->plat_dev);
>  
> -	/* Free resources allocated for PCH SPI */
> -	pch_spi_free_resources(board_dat);
> +	platform_driver_unregister(&pch_spi_pd_driver);
> +	free_irq(pdev->irq, board_dat);
> +	pci_release_regions(board_dat->pdev);
> +	pci_iounmap(board_dat->pdev, board_dat->data[0]->io_remap_addr);
>  
> -	spi_unregister_master(board_dat->data->master);
> +	for (i = 0; i < board_dat->num; i++)
> +		spi_master_put(board_dat->data[i]->master);
>  
> -	/* free memory for private data */
> -	kfree(board_dat);
> -
> -	pci_set_drvdata(pdev, NULL);
> -
> -	/* disable PCI device */
>  	pci_disable_device(pdev);
> -
> -	dev_dbg(&pdev->dev, "%s invoked pci_disable_device\n", 
> __func__);
> +	kfree(board_dat);
>  }
>  
>  #ifdef CONFIG_PM
> @@ -1146,6 +1176,7 @@ static int pch_spi_suspend(struct 
> pci_dev *pdev, pm_message_t state)  {
>  	u8 count;
>  	int retval;
> +	int i;
>  
>  	struct pch_spi_board_data *board_dat = pci_get_drvdata(pdev);
>  
> @@ -1162,25 +1193,29 @@ static int pch_spi_suspend(struct 
> pci_dev *pdev, pm_message_t state)
>  
>  	/* check if the current message is processed:
>  	   Only after thats done the transfer will be suspended */
> -	count = 255;
> -	while ((--count) > 0) {
> -		if (!(board_dat->data->bcurrent_msg_processing)) {
> -			dev_dbg(&pdev->dev, "%s 
> board_dat->data->bCurrent_"
> -				"msg_processing = false\n", __func__);
> -			break;
> -		} else {
> -			dev_dbg(&pdev->dev, "%s 
> board_dat->data->bCurrent_msg_"
> -				"processing = true\n", __func__);
> +	for (i = 0; i < board_dat->num; i++) {
> +		count = 255;
> +		while ((--count) > 0) {
> +			if 
> (!(board_dat->data[i]->bcurrent_msg_processing)) {
> +				dev_dbg(&pdev->dev, "%s 
> board_dat->data->bCurre"
> +					
> "nt_msg_processing=false\n", __func__);
> +				break;
> +			} else {
> +				dev_dbg(&pdev->dev, "%s 
> board_dat->data->bCurre"
> +					
> "nt_msg_processing=true\n", __func__);
> +			}
> +			msleep(PCH_SLEEP_TIME);
>  		}
> -		msleep(PCH_SLEEP_TIME);
>  	}
>  
>  	/* Free IRQ */
>  	if (board_dat->irq_reg_sts) {
>  		/* disable all interrupts */
> -		pch_spi_setclr_reg(board_dat->data->master, PCH_SPCR, 0,
> -				   PCH_ALL);
> -		pch_spi_reset(board_dat->data->master);
> +		for (i = 0; i < board_dat->num; i++) {
> +			
> pch_spi_setclr_reg(board_dat->data[i]->master, PCH_SPCR,
> +					   0, PCH_ALL);
> +			pch_spi_reset(board_dat->data[i]->master);
> +		}
>  
>  		free_irq(board_dat->pdev->irq, board_dat);
>  
> @@ -1221,6 +1256,7 @@ static int pch_spi_suspend(struct 
> pci_dev *pdev, pm_message_t state)  static int 
> pch_spi_resume(struct pci_dev *pdev)  {
>  	int retval;
> +	int i;
>  
>  	struct pch_spi_board_data *board = pci_get_drvdata(pdev);
>  	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__); @@ -1259,8 
> +1295,10 @@ static int pch_spi_resume(struct pci_dev *pdev)
>  			board->irq_reg_sts = true;
>  
>  			/* reset PCH SPI h/w */
> -			pch_spi_reset(board->data->master);
> -			pch_spi_set_master_mode(board->data->master);
> +			for (i = 0; i < board->num; i++) {
> +				pch_spi_reset(board->data[i]->master);
> +				
> pch_spi_set_master_mode(board->data[i]->master);
> +			}
>  
>  			/* set suspend status to false */
>  			board->suspend_sts = false;
> --
> 1.7.3.4
> 

