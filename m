Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab1D0CW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 22:22:27 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:17689 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756656Ab1D0CWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 22:22:25 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH v4 1/2] spi_topcliff_pch: support new device ML7213 IOH
Date: Wed, 27 Apr 2011 11:23:29 +0900
Message-Id: <1303871010-8319-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

***Modify Grant's comments.
   - Delete unrelated whitespace
   - Prevent device driver from accessing platform data
   - Add __devinit and __devexit
   - Save pdev->dev to pd_dev->dev.parent
   - Have own suspend/resume processing in platform_driver.
   - Care returned value in pch_spi_init
   - Change unregister order

Support ML7213 device of OKI SEMICONDUCTOR.
ML7213 is companion chip of Intel Atom E6xx series for IVI(In-Vehicle Infotainment).
ML7213 is compatible for Intel EG20T PCH.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/spi/Kconfig            |    5 +-
 drivers/spi/spi_topcliff_pch.c |  599 +++++++++++++++++++++-------------------
 2 files changed, 317 insertions(+), 287 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index fc14b8d..ed6134b 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -380,12 +380,15 @@ config SPI_TI_SSP
 	  module will be called ti-ssp-spi.
 
 config SPI_TOPCLIFF_PCH
-	tristate "Topcliff PCH SPI Controller"
+	tristate "Intel EG20T PCH/OKI SEMICONDUCTOR ML7213 IOH SPI controller"
 	depends on PCI
 	help
 	  SPI driver for the Topcliff PCH (Platform Controller Hub) SPI bus
 	  used in some x86 embedded processors.
 
+	  This driver also supports the ML7213, a companion chip for the
+	  Atom E6xx series and compatible with the Intel EG20T PCH.
+
 config SPI_TXX9
 	tristate "Toshiba TXx9 SPI controller"
 	depends on GENERIC_GPIO && CPU_TX49XX
diff --git a/drivers/spi/spi_topcliff_pch.c b/drivers/spi/spi_topcliff_pch.c
index 79e48d4..88bd472 100644
--- a/drivers/spi/spi_topcliff_pch.c
+++ b/drivers/spi/spi_topcliff_pch.c
@@ -26,6 +26,7 @@
 #include <linux/spi/spidev.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/platform_device.h>
 
 /* Register offsets */
 #define PCH_SPCR		0x00	/* SPI control register */
@@ -35,6 +36,7 @@
 #define PCH_SPDRR		0x10	/* SPI read data register */
 #define PCH_SSNXCR		0x18	/* SSN Expand Control Register */
 #define PCH_SRST		0x1C	/* SPI reset register */
+#define PCH_SPI_ADDRESS_SIZE	0x20
 
 #define PCH_SPSR_TFD		0x000007C0
 #define PCH_SPSR_RFD		0x0000F800
@@ -75,7 +77,8 @@
 #define SPSR_FI_BIT		(1 << 2)
 #define SPBRR_SIZE_BIT		(1 << 10)
 
-#define PCH_ALL			(SPCR_TFIE_BIT|SPCR_RFIE_BIT|SPCR_FIE_BIT|SPCR_ORIE_BIT|SPCR_MDFIE_BIT)
+#define PCH_ALL			(SPCR_TFIE_BIT|SPCR_RFIE_BIT|SPCR_FIE_BIT|\
+				SPCR_ORIE_BIT|SPCR_MDFIE_BIT)
 
 #define SPCR_RFIC_FIELD		20
 #define SPCR_TFIC_FIELD		16
@@ -88,6 +91,16 @@
 #define PCH_CLOCK_HZ		50000000
 #define PCH_MAX_SPBR		1023
 
+/* Definition for ML7213 by OKI SEMICONDUCTOR */
+#define PCI_VENDOR_ID_ROHM		0x10DB
+#define PCI_DEVICE_ID_ML7213_SPI	0x802c
+
+/*
+ * Set the number of SPI instance max
+ * Intel EG20T PCH :		1ch
+ * OKI SEMICONDUCTOR ML7213 IOH :	2ch
+*/
+#define PCH_SPI_MAX_DEV			2
 
 /**
  * struct pch_spi_data - Holds the SPI channel specific details
@@ -121,6 +134,9 @@
  * @cur_trans:			The current transfer that this SPI driver is
  *				handling
  * @board_dat:			Reference to the SPI device data structure
+ * @plat_dev:			platform_device structure
+ * @ch:				SPI channel number
+ * @irq_reg_sts:		Status of IRQ registration
  */
 struct pch_spi_data {
 	void __iomem *io_remap_addr;
@@ -144,27 +160,33 @@ struct pch_spi_data {
 	struct spi_message *current_msg;
 	struct spi_transfer *cur_trans;
 	struct pch_spi_board_data *board_dat;
+	struct platform_device	*plat_dev;
+	int ch;
+	u8 irq_reg_sts;
 };
 
 /**
  * struct pch_spi_board_data - Holds the SPI device specific details
  * @pdev:		Pointer to the PCI device
- * @irq_reg_sts:	Status of IRQ registration
- * @pci_req_sts:	Status of pci_request_regions
  * @suspend_sts:	Status of suspend
- * @data:		Pointer to SPI channel data structure
+ * @num:		The number of SPI device instance
  */
 struct pch_spi_board_data {
 	struct pci_dev *pdev;
-	u8 irq_reg_sts;
-	u8 pci_req_sts;
 	u8 suspend_sts;
-	struct pch_spi_data *data;
+	int num;
+};
+
+struct pch_pd_dev_save {
+	int num;
+	struct platform_device *pd_save[PCH_SPI_MAX_DEV];
+	struct pch_spi_board_data *board_dat;
 };
 
 static struct pci_device_id pch_spi_pcidev_id[] = {
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_GE_SPI)},
-	{0,}
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_GE_SPI),    1, },
+	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_SPI), 2, },
+	{ }
 };
 
 /**
@@ -283,11 +305,11 @@ static void pch_spi_handler_sub(struct pch_spi_data *data, u32 reg_spsr_val,
 static irqreturn_t pch_spi_handler(int irq, void *dev_id)
 {
 	u32 reg_spsr_val;
-	struct pch_spi_data *data;
 	void __iomem *spsr;
 	void __iomem *io_remap_addr;
 	irqreturn_t ret = IRQ_NONE;
-	struct pch_spi_board_data *board_dat = dev_id;
+	struct pch_spi_data *data = dev_id;
+	struct pch_spi_board_data *board_dat = data->board_dat;
 
 	if (board_dat->suspend_sts) {
 		dev_dbg(&board_dat->pdev->dev,
@@ -295,10 +317,8 @@ static irqreturn_t pch_spi_handler(int irq, void *dev_id)
 		return IRQ_NONE;
 	}
 
-	data = board_dat->data;
 	io_remap_addr = data->io_remap_addr;
 	spsr = io_remap_addr + PCH_SPSR;
-
 	reg_spsr_val = ioread32(spsr);
 
 	/* Check if the interrupt is for SPI device */
@@ -412,7 +432,6 @@ static int pch_spi_setup(struct spi_device *pspi)
 
 static int pch_spi_transfer(struct spi_device *pspi, struct spi_message *pmsg)
 {
-
 	struct spi_transfer *transfer;
 	struct pch_spi_data *data = spi_master_get_devdata(pspi->master);
 	int retval;
@@ -547,7 +566,8 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw,
 
 	/* set bits per word if needed */
 	if (data->cur_trans->bits_per_word &&
-	    (data->current_msg->spi->bits_per_word != data->cur_trans->bits_per_word)) {
+	   (data->current_msg->spi->bits_per_word !=\
+	   data->cur_trans->bits_per_word)) {
 		dev_dbg(&data->master->dev, "%s:set bits per word\n", __func__);
 		pch_spi_set_bits_per_word(data->master,
 					  data->cur_trans->bits_per_word);
@@ -621,7 +641,6 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw,
 	data->transfer_active = true;
 }
 
-
 static void pch_spi_nomore_transfer(struct pch_spi_data *data,
 						struct spi_message *pmsg)
 {
@@ -697,7 +716,8 @@ static void pch_spi_set_ir(struct pch_spi_data *data)
 		"%s:invoking pch_spi_set_enable to enable SPI\n", __func__);
 
 	/* SPI set enable */
-	pch_spi_setclr_reg(data->current_chip->master, PCH_SPCR, SPCR_SPE_BIT, 0);
+	pch_spi_setclr_reg(data->current_chip->master, PCH_SPCR, SPCR_SPE_BIT,
+			   0);
 
 	/* Wait until the transfer completes; go to sleep after
 				 initiating the transfer. */
@@ -742,7 +762,6 @@ static void pch_spi_copy_rx_data(struct pch_spi_data *data, int bpw)
 	}
 }
 
-
 static void pch_spi_process_messages(struct work_struct *pwork)
 {
 	struct spi_message *pmsg;
@@ -868,117 +887,49 @@ static void pch_spi_process_messages(struct work_struct *pwork)
 	} while (data->cur_trans != NULL);
 }
 
-static void pch_spi_free_resources(struct pch_spi_board_data *board_dat)
+static void pch_spi_free_resources(struct pch_spi_board_data *board_dat,
+				   struct pch_spi_data *data)
 {
 	dev_dbg(&board_dat->pdev->dev, "%s ENTRY\n", __func__);
 
 	/* free workqueue */
-	if (board_dat->data->wk != NULL) {
-		destroy_workqueue(board_dat->data->wk);
-		board_dat->data->wk = NULL;
+	if (data->wk != NULL) {
+		destroy_workqueue(data->wk);
+		data->wk = NULL;
 		dev_dbg(&board_dat->pdev->dev,
 			"%s destroy_workqueue invoked successfully\n",
 			__func__);
 	}
-
-	/* disable interrupts & free IRQ */
-	if (board_dat->irq_reg_sts) {
-		/* disable interrupts */
-		pch_spi_setclr_reg(board_dat->data->master, PCH_SPCR, 0,
-				   PCH_ALL);
-
-		/* free IRQ */
-		free_irq(board_dat->pdev->irq, board_dat);
-
-		dev_dbg(&board_dat->pdev->dev,
-			"%s free_irq invoked successfully\n", __func__);
-
-		board_dat->irq_reg_sts = false;
-	}
-
-	/* unmap PCI base address */
-	if (board_dat->data->io_remap_addr != 0) {
-		pci_iounmap(board_dat->pdev, board_dat->data->io_remap_addr);
-
-		board_dat->data->io_remap_addr = 0;
-
-		dev_dbg(&board_dat->pdev->dev,
-			"%s pci_iounmap invoked successfully\n", __func__);
-	}
-
-	/* release PCI region */
-	if (board_dat->pci_req_sts) {
-		pci_release_regions(board_dat->pdev);
-		dev_dbg(&board_dat->pdev->dev,
-			"%s pci_release_regions invoked successfully\n",
-			__func__);
-		board_dat->pci_req_sts = false;
-	}
 }
 
-static int pch_spi_get_resources(struct pch_spi_board_data *board_dat)
+static int pch_spi_get_resources(struct pch_spi_board_data *board_dat,
+				 struct pch_spi_data *data)
 {
-	void __iomem *io_remap_addr;
-	int retval;
+	int retval = 0;
+
 	dev_dbg(&board_dat->pdev->dev, "%s ENTRY\n", __func__);
 
 	/* create workqueue */
-	board_dat->data->wk = create_singlethread_workqueue(KBUILD_MODNAME);
-	if (!board_dat->data->wk) {
+	data->wk = create_singlethread_workqueue(KBUILD_MODNAME);
+	if (!data->wk) {
 		dev_err(&board_dat->pdev->dev,
 			"%s create_singlet hread_workqueue failed\n", __func__);
 		retval = -EBUSY;
 		goto err_return;
 	}
 
-	dev_dbg(&board_dat->pdev->dev,
-		"%s create_singlethread_workqueue success\n", __func__);
-
-	retval = pci_request_regions(board_dat->pdev, KBUILD_MODNAME);
-	if (retval != 0) {
-		dev_err(&board_dat->pdev->dev,
-			"%s request_region failed\n", __func__);
-		goto err_return;
-	}
-
-	board_dat->pci_req_sts = true;
-
-	io_remap_addr = pci_iomap(board_dat->pdev, 1, 0);
-	if (io_remap_addr == 0) {
-		dev_err(&board_dat->pdev->dev,
-			"%s pci_iomap failed\n", __func__);
-		retval = -ENOMEM;
-		goto err_return;
-	}
-
-	/* calculate base address for all channels */
-	board_dat->data->io_remap_addr = io_remap_addr;
-
 	/* reset PCH SPI h/w */
-	pch_spi_reset(board_dat->data->master);
+	pch_spi_reset(data->master);
 	dev_dbg(&board_dat->pdev->dev,
 		"%s pch_spi_reset invoked successfully\n", __func__);
 
-	/* register IRQ */
-	retval = request_irq(board_dat->pdev->irq, pch_spi_handler,
-			     IRQF_SHARED, KBUILD_MODNAME, board_dat);
-	if (retval != 0) {
-		dev_err(&board_dat->pdev->dev,
-			"%s request_irq failed\n", __func__);
-		goto err_return;
-	}
-
-	dev_dbg(&board_dat->pdev->dev, "%s request_irq returned=%d\n",
-		__func__, retval);
-
-	board_dat->irq_reg_sts = true;
 	dev_dbg(&board_dat->pdev->dev, "%s data->irq_reg_sts=true\n", __func__);
 
 err_return:
 	if (retval != 0) {
 		dev_err(&board_dat->pdev->dev,
 			"%s FAIL:invoking pch_spi_free_resources\n", __func__);
-		pch_spi_free_resources(board_dat);
+		pch_spi_free_resources(board_dat, data);
 	}
 
 	dev_dbg(&board_dat->pdev->dev, "%s Return=%d\n", __func__, retval);
@@ -986,255 +937,343 @@ err_return:
 	return retval;
 }
 
-static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int __devinit pch_spi_pd_probe(struct platform_device *plat_dev)
 {
-
+	int ret;
 	struct spi_master *master;
+	struct pch_spi_board_data *board_dat = dev_get_platdata(&plat_dev->dev);
+	struct pch_spi_data *data;
 
-	struct pch_spi_board_data *board_dat;
-	int retval;
-
-	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
-
-	/* allocate memory for private data */
-	board_dat = kzalloc(sizeof(struct pch_spi_board_data), GFP_KERNEL);
-	if (board_dat == NULL) {
-		dev_err(&pdev->dev,
-			" %s memory allocation for private data failed\n",
-			__func__);
-		retval = -ENOMEM;
-		goto err_kmalloc;
-	}
-
-	dev_dbg(&pdev->dev,
-		"%s memory allocation for private data success\n", __func__);
-
-	/* enable PCI device */
-	retval = pci_enable_device(pdev);
-	if (retval != 0) {
-		dev_err(&pdev->dev, "%s pci_enable_device FAILED\n", __func__);
-
-		goto err_pci_en_device;
+	master = spi_alloc_master(&board_dat->pdev->dev,
+				  sizeof(struct pch_spi_data));
+	if (!master) {
+		dev_err(&plat_dev->dev, "spi_alloc_master[%d] failed.\n",
+			plat_dev->id);
+		return -ENOMEM;
 	}
 
-	dev_dbg(&pdev->dev, "%s pci_enable_device returned=%d\n",
-		__func__, retval);
+	data = spi_master_get_devdata(master);
+	data->master = master;
 
-	board_dat->pdev = pdev;
+	platform_set_drvdata(plat_dev, data);
 
-	/* alllocate memory for SPI master */
-	master = spi_alloc_master(&pdev->dev, sizeof(struct pch_spi_data));
-	if (master == NULL) {
-		retval = -ENOMEM;
-		dev_err(&pdev->dev, "%s Fail.\n", __func__);
-		goto err_spi_alloc_master;
+	/* baseaddress + 0x20(offset) */
+	data->io_remap_addr = pci_iomap(board_dat->pdev, 1, 0) +
+						   0x20 * plat_dev->id;
+	if (!data->io_remap_addr) {
+		dev_err(&plat_dev->dev, "%s pci_iomap failed\n", __func__);
+		ret = -ENOMEM;
+		goto err_pci_iomap;
 	}
 
-	dev_dbg(&pdev->dev,
-		"%s spi_alloc_master returned non NULL\n", __func__);
+	dev_dbg(&plat_dev->dev, "[ch%d] remap_addr=%p\n",
+		plat_dev->id, data->io_remap_addr);
 
 	/* initialize members of SPI master */
-	master->bus_num = -1;
+	master->bus_num = plat_dev->id;
 	master->num_chipselect = PCH_MAX_CS;
 	master->setup = pch_spi_setup;
 	master->transfer = pch_spi_transfer;
-	dev_dbg(&pdev->dev,
-		"%s transfer member of SPI master initialized\n", __func__);
 
-	board_dat->data = spi_master_get_devdata(master);
+	data->board_dat = board_dat;
+	data->plat_dev = plat_dev;
+	data->n_curnt_chip = 255;
+	data->status = STATUS_RUNNING;
+	data->ch = plat_dev->id;
 
-	board_dat->data->master = master;
-	board_dat->data->n_curnt_chip = 255;
-	board_dat->data->board_dat = board_dat;
-	board_dat->data->status = STATUS_RUNNING;
+	INIT_LIST_HEAD(&data->queue);
+	spin_lock_init(&data->lock);
+	INIT_WORK(&data->work, pch_spi_process_messages);
+	init_waitqueue_head(&data->wait);
 
-	INIT_LIST_HEAD(&board_dat->data->queue);
-	spin_lock_init(&board_dat->data->lock);
-	INIT_WORK(&board_dat->data->work, pch_spi_process_messages);
-	init_waitqueue_head(&board_dat->data->wait);
-
-	/* allocate resources for PCH SPI */
-	retval = pch_spi_get_resources(board_dat);
-	if (retval) {
-		dev_err(&pdev->dev, "%s fail(retval=%d)\n", __func__, retval);
+	ret = pch_spi_get_resources(board_dat, data);
+	if (ret) {
+		dev_err(&plat_dev->dev, "%s fail(retval=%d)\n", __func__, ret);
 		goto err_spi_get_resources;
 	}
 
-	dev_dbg(&pdev->dev, "%s pch_spi_get_resources returned=%d\n",
-		__func__, retval);
-
-	/* save private data in dev */
-	pci_set_drvdata(pdev, board_dat);
-	dev_dbg(&pdev->dev, "%s invoked pci_set_drvdata\n", __func__);
+	ret = request_irq(board_dat->pdev->irq, pch_spi_handler,
+			  IRQF_SHARED, KBUILD_MODNAME, data);
+	if (ret) {
+		dev_err(&plat_dev->dev,
+			"%s request_irq failed\n", __func__);
+		goto err_request_irq;
+	}
+	data->irq_reg_sts = true;
 
-	/* set master mode */
 	pch_spi_set_master_mode(master);
-	dev_dbg(&pdev->dev,
-		"%s invoked pch_spi_set_master_mode\n", __func__);
 
-	/* Register the controller with the SPI core. */
-	retval = spi_register_master(master);
-	if (retval != 0) {
-		dev_err(&pdev->dev,
+	ret = spi_register_master(master);
+	if (ret != 0) {
+		dev_err(&plat_dev->dev,
 			"%s spi_register_master FAILED\n", __func__);
-		goto err_spi_reg_master;
+		goto err_spi_register_master;
 	}
 
-	dev_dbg(&pdev->dev, "%s spi_register_master returned=%d\n",
-		__func__, retval);
-
-
 	return 0;
 
-err_spi_reg_master:
-	spi_unregister_master(master);
+err_spi_register_master:
+	free_irq(board_dat->pdev->irq, board_dat);
+err_request_irq:
+	pch_spi_free_resources(board_dat, data);
 err_spi_get_resources:
-err_spi_alloc_master:
+	pci_iounmap(board_dat->pdev, data->io_remap_addr);
+err_pci_iomap:
 	spi_master_put(master);
-	pci_disable_device(pdev);
-err_pci_en_device:
-	kfree(board_dat);
-err_kmalloc:
-	return retval;
+
+	return ret;
 }
 
-static void pch_spi_remove(struct pci_dev *pdev)
+static int __devexit pch_spi_pd_remove(struct platform_device *plat_dev)
 {
-	struct pch_spi_board_data *board_dat = pci_get_drvdata(pdev);
+	struct pch_spi_board_data *board_dat = dev_get_platdata(&plat_dev->dev);
+	struct pch_spi_data *data = platform_get_drvdata(plat_dev);
 	int count;
 
-	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
-
-	if (!board_dat) {
-		dev_err(&pdev->dev,
-			"%s pci_get_drvdata returned NULL\n", __func__);
-		return;
-	}
-
+	dev_dbg(&plat_dev->dev, "%s:[ch%d] irq=%d\n",
+		__func__, plat_dev->id, board_dat->pdev->irq);
 	/* check for any pending messages; no action is taken if the queue
 	 * is still full; but at least we tried.  Unload anyway */
 	count = 500;
-	spin_lock(&board_dat->data->lock);
-	board_dat->data->status = STATUS_EXITING;
-	while ((list_empty(&board_dat->data->queue) == 0) && --count) {
+	spin_lock(&data->lock);
+	data->status = STATUS_EXITING;
+	while ((list_empty(&data->queue) == 0) && --count) {
 		dev_dbg(&board_dat->pdev->dev, "%s :queue not empty\n",
 			__func__);
-		spin_unlock(&board_dat->data->lock);
+		spin_unlock(&data->lock);
 		msleep(PCH_SLEEP_TIME);
-		spin_lock(&board_dat->data->lock);
+		spin_lock(&data->lock);
 	}
-	spin_unlock(&board_dat->data->lock);
-
-	/* Free resources allocated for PCH SPI */
-	pch_spi_free_resources(board_dat);
-
-	spi_unregister_master(board_dat->data->master);
-
-	/* free memory for private data */
-	kfree(board_dat);
+	spin_unlock(&data->lock);
 
-	pci_set_drvdata(pdev, NULL);
+	pch_spi_free_resources(board_dat, data);
+	/* disable interrupts & free IRQ */
+	if (data->irq_reg_sts) {
+		/* disable interrupts */
+		pch_spi_setclr_reg(data->master, PCH_SPCR, 0, PCH_ALL);
+		data->irq_reg_sts = false;
+		free_irq(board_dat->pdev->irq, data);
+	}
 
-	/* disable PCI device */
-	pci_disable_device(pdev);
+	pci_iounmap(board_dat->pdev, data->io_remap_addr);
+	spi_unregister_master(data->master);
+	spi_master_put(data->master);
+	platform_set_drvdata(plat_dev, NULL);
 
-	dev_dbg(&pdev->dev, "%s invoked pci_disable_device\n", __func__);
+	return 0;
 }
-
 #ifdef CONFIG_PM
-static int pch_spi_suspend(struct pci_dev *pdev, pm_message_t state)
+static int pch_spi_pd_suspend(struct platform_device *pd_dev,
+			      pm_message_t state)
 {
 	u8 count;
-	int retval;
-
-	struct pch_spi_board_data *board_dat = pci_get_drvdata(pdev);
+	struct pch_spi_board_data *board_dat = dev_get_platdata(&pd_dev->dev);
+	struct pch_spi_data *data = platform_get_drvdata(pd_dev);
 
-	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
+	dev_dbg(&pd_dev->dev, "%s ENTRY\n", __func__);
 
 	if (!board_dat) {
-		dev_err(&pdev->dev,
+		dev_err(&pd_dev->dev,
 			"%s pci_get_drvdata returned NULL\n", __func__);
 		return -EFAULT;
 	}
 
-	retval = 0;
-	board_dat->suspend_sts = true;
-
 	/* check if the current message is processed:
 	   Only after thats done the transfer will be suspended */
 	count = 255;
-	while ((--count) > 0) {
-		if (!(board_dat->data->bcurrent_msg_processing)) {
-			dev_dbg(&pdev->dev, "%s board_dat->data->bCurrent_"
-				"msg_processing = false\n", __func__);
+	while ((--count) > 0)
+		if (!(data->bcurrent_msg_processing)) {
 			break;
-		} else {
-			dev_dbg(&pdev->dev, "%s board_dat->data->bCurrent_msg_"
-				"processing = true\n", __func__);
-		}
 		msleep(PCH_SLEEP_TIME);
 	}
 
 	/* Free IRQ */
-	if (board_dat->irq_reg_sts) {
+	if (data->irq_reg_sts) {
 		/* disable all interrupts */
-		pch_spi_setclr_reg(board_dat->data->master, PCH_SPCR, 0,
-				   PCH_ALL);
-		pch_spi_reset(board_dat->data->master);
-
-		free_irq(board_dat->pdev->irq, board_dat);
+		pch_spi_setclr_reg(data->master, PCH_SPCR, 0, PCH_ALL);
+		pch_spi_reset(data->master);
+		free_irq(board_dat->pdev->irq, data);
 
-		board_dat->irq_reg_sts = false;
-		dev_dbg(&pdev->dev,
+		data->irq_reg_sts = false;
+		dev_dbg(&pd_dev->dev,
 			"%s free_irq invoked successfully.\n", __func__);
 	}
 
+	return 0;
+}
+
+static int pch_spi_pd_resume(struct platform_device *pd_dev)
+{
+	struct pch_spi_board_data *board_dat = dev_get_platdata(&pd_dev->dev);
+	struct pch_spi_data *data = platform_get_drvdata(pd_dev);
+	int retval;
+
+	if (!board_dat) {
+		dev_err(&pd_dev->dev,
+			"%s pci_get_drvdata returned NULL\n", __func__);
+		return -EFAULT;
+	}
+
+	if (!data->irq_reg_sts) {
+		/* register IRQ */
+		retval = request_irq(board_dat->pdev->irq, pch_spi_handler,
+				     IRQF_SHARED, KBUILD_MODNAME, data);
+		if (retval < 0) {
+			dev_err(&pd_dev->dev,
+				"%s request_irq failed\n", __func__);
+			return retval;
+		}
+
+		/* reset PCH SPI h/w */
+		pch_spi_reset(data->master);
+		pch_spi_set_master_mode(data->master);
+		data->irq_reg_sts = true;
+	}
+	return 0;
+}
+#else
+#define pch_spi_pd_suspend NULL
+#define pch_spi_pd_resume NULL
+#endif
+
+static struct platform_driver pch_spi_pd_driver = {
+	.driver = {
+		.name = "pch-spi",
+		.owner = THIS_MODULE,
+	},
+	.probe = pch_spi_pd_probe,
+	.remove = __devexit_p(pch_spi_pd_remove),
+	.suspend = pch_spi_pd_suspend,
+	.resume = pch_spi_pd_resume
+};
+
+static int __devinit pch_spi_probe(struct pci_dev *pdev,
+				   const struct pci_device_id *id)
+{
+	struct pch_spi_board_data *board_dat;
+	struct platform_device *pd_dev = NULL;
+	int retval;
+	int i;
+	struct pch_pd_dev_save *pd_dev_save;
+
+	pd_dev_save = kzalloc(sizeof(struct pch_pd_dev_save), GFP_KERNEL);
+	if (!pd_dev_save) {
+		dev_err(&pdev->dev, "%s Can't allocate pd_dev_sav\n", __func__);
+		return -ENOMEM;
+	}
+
+	board_dat = kzalloc(sizeof(struct pch_spi_board_data), GFP_KERNEL);
+	if (!board_dat) {
+		dev_err(&pdev->dev, "%s Can't allocate board_dat\n", __func__);
+		retval = -ENOMEM;
+		goto err_no_mem;
+	}
+
+	retval = pci_request_regions(pdev, KBUILD_MODNAME);
+	if (retval) {
+		dev_err(&pdev->dev, "%s request_region failed\n", __func__);
+		goto pci_request_regions;
+	}
+
+	board_dat->pdev = pdev;
+	board_dat->num = id->driver_data;
+	pd_dev_save->num = id->driver_data;
+	pd_dev_save->board_dat = board_dat;
+
+	retval = pci_enable_device(pdev);
+	if (retval) {
+		dev_err(&pdev->dev, "%s pci_enable_device failed\n", __func__);
+		goto pci_enable_device;
+	}
+
+	for (i = 0; i < board_dat->num; i++) {
+		pd_dev = platform_device_alloc("pch-spi", i);
+		if (!pd_dev) {
+			dev_err(&pdev->dev, "platform_device_alloc failed\n");
+			goto err_platform_device;
+		}
+		pd_dev_save->pd_save[i] = pd_dev;
+		pd_dev->dev.parent = &pdev->dev;
+
+		retval = platform_device_add_data(pd_dev, board_dat,
+						  sizeof(*board_dat));
+		if (retval) {
+			dev_err(&pdev->dev,
+				"platform_device_add_data failed\n");
+			platform_device_put(pd_dev);
+			goto err_platform_device;
+		}
+
+		retval = platform_device_add(pd_dev);
+		if (retval) {
+			dev_err(&pdev->dev, "platform_device_add failed\n");
+			platform_device_put(pd_dev);
+			goto err_platform_device;
+		}
+	}
+
+	pci_set_drvdata(pdev, pd_dev_save);
+
+	return 0;
+
+err_platform_device:
+	pci_disable_device(pdev);
+pci_enable_device:
+	pci_release_regions(pdev);
+pci_request_regions:
+	kfree(board_dat);
+err_no_mem:
+	kfree(pd_dev_save);
+
+	return retval;
+}
+
+static void __devexit pch_spi_remove(struct pci_dev *pdev)
+{
+	int i;
+	struct pch_pd_dev_save *pd_dev_save = pci_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "%s ENTRY:pdev=%p\n", __func__, pdev);
+
+	for (i = 0; i < pd_dev_save->num; i++)
+		platform_device_unregister(pd_dev_save->pd_save[i]);
+
+	pci_disable_device(pdev);
+	pci_release_regions(pdev);
+	kfree(pd_dev_save->board_dat);
+	kfree(pd_dev_save);
+}
+
+#ifdef CONFIG_PM
+static int pch_spi_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	int retval;
+	struct pch_pd_dev_save *pd_dev_save = pci_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
+
+	pd_dev_save->board_dat->suspend_sts = true;
+
 	/* save config space */
 	retval = pci_save_state(pdev);
-
 	if (retval == 0) {
-		dev_dbg(&pdev->dev, "%s pci_save_state returned=%d\n",
-			__func__, retval);
-		/* disable PM notifications */
 		pci_enable_wake(pdev, PCI_D3hot, 0);
-		dev_dbg(&pdev->dev,
-			"%s pci_enable_wake invoked successfully\n", __func__);
-		/* disable PCI device */
 		pci_disable_device(pdev);
-		dev_dbg(&pdev->dev,
-			"%s pci_disable_device invoked successfully\n",
-			__func__);
-		/* move device to D3hot  state */
 		pci_set_power_state(pdev, PCI_D3hot);
-		dev_dbg(&pdev->dev,
-			"%s pci_set_power_state invoked successfully\n",
-			__func__);
 	} else {
 		dev_err(&pdev->dev, "%s pci_save_state failed\n", __func__);
 	}
 
-	dev_dbg(&pdev->dev, "%s return=%d\n", __func__, retval);
-
 	return retval;
 }
 
 static int pch_spi_resume(struct pci_dev *pdev)
 {
 	int retval;
-
-	struct pch_spi_board_data *board = pci_get_drvdata(pdev);
+	struct pch_pd_dev_save *pd_dev_save = pci_get_drvdata(pdev);
 	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
 
-	if (!board) {
-		dev_err(&pdev->dev,
-			"%s pci_get_drvdata returned NULL\n", __func__);
-		return -EFAULT;
-	}
-
-	/* move device to DO power state */
 	pci_set_power_state(pdev, PCI_D0);
-
-	/* restore state */
 	pci_restore_state(pdev);
 
 	retval = pci_enable_device(pdev);
@@ -1242,34 +1281,12 @@ static int pch_spi_resume(struct pci_dev *pdev)
 		dev_err(&pdev->dev,
 			"%s pci_enable_device failed\n", __func__);
 	} else {
-		/* disable PM notifications */
 		pci_enable_wake(pdev, PCI_D3hot, 0);
 
-		/* register IRQ handler */
-		if (!board->irq_reg_sts) {
-			/* register IRQ */
-			retval = request_irq(board->pdev->irq, pch_spi_handler,
-					     IRQF_SHARED, KBUILD_MODNAME,
-					     board);
-			if (retval < 0) {
-				dev_err(&pdev->dev,
-					"%s request_irq failed\n", __func__);
-				return retval;
-			}
-			board->irq_reg_sts = true;
-
-			/* reset PCH SPI h/w */
-			pch_spi_reset(board->data->master);
-			pch_spi_set_master_mode(board->data->master);
-
-			/* set suspend status to false */
-			board->suspend_sts = false;
-
-		}
+		/* set suspend status to false */
+		pd_dev_save->board_dat->suspend_sts = false;
 	}
 
-	dev_dbg(&pdev->dev, "%s returning=%d\n", __func__, retval);
-
 	return retval;
 }
 #else
@@ -1289,15 +1306,25 @@ static struct pci_driver pch_spi_pcidev = {
 
 static int __init pch_spi_init(void)
 {
-	return pci_register_driver(&pch_spi_pcidev);
+	int ret;
+	ret = platform_driver_register(&pch_spi_pd_driver);
+	if (ret)
+		return ret;
+
+	ret = pci_register_driver(&pch_spi_pcidev);
+	if (ret)
+		return ret;
+
+	return 0;
 }
 module_init(pch_spi_init);
 
 static void __exit pch_spi_exit(void)
 {
 	pci_unregister_driver(&pch_spi_pcidev);
+	platform_driver_unregister(&pch_spi_pd_driver);
 }
 module_exit(pch_spi_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Topcliff PCH SPI PCI Driver");
+MODULE_DESCRIPTION("Intel EG20T PCH/OKI SEMICONDUCTOR ML7213 IOH SPI Driver");
-- 
1.7.4

