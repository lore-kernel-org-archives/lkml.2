Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab0JDK60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:58:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:44715 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885Ab0JDK6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:58:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,277,1283756400"; 
   d="scan'208";a="560435364"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, ramesh.b.k.v@intel.com,
        yong.y.wang@linux.intel.com
Cc: Vinod Koul <vinod.koul@intel.com>
Subject: Resend: [PATCH 1/6] intel_mid_dma: Add runtime PM support
Date: Mon,  4 Oct 2010 16:12:40 +0530
Message-Id: <1286188960-6378-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds runtime PM support in this dma driver
for 4 PCI Controllers
Whenever the driver is idle (no channels grabbed), it
can go to low power state
It also adds the PCI suspend and resume support

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/dma/intel_mid_dma.c      |  123 +++++++++++++++++++++++++++++++++++--
 drivers/dma/intel_mid_dma_regs.h |   14 ++++-
 2 files changed, 129 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index c2591e8..373396c 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -25,6 +25,7 @@
  */
 #include <linux/pci.h>
 #include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
 #include <linux/intel_mid_dma.h>
 
 #define MAX_CHAN	4 /*max ch across controllers*/
@@ -247,13 +248,13 @@ static void midc_dostart(struct intel_mid_dma_chan *midc,
 	struct middma_device *mid = to_middma_device(midc->chan.device);
 
 	/*  channel is idle */
-	if (midc->in_use && test_ch_en(midc->dma_base, midc->ch_id)) {
+	if (midc->busy && test_ch_en(midc->dma_base, midc->ch_id)) {
 		/*error*/
 		pr_err("ERR_MDMA: channel is busy in start\n");
 		/* The tasklet will hopefully advance the queue... */
 		return;
 	}
-
+	midc->busy = true;
 	/*write registers and en*/
 	iowrite32(first->sar, midc->ch_regs + SAR);
 	iowrite32(first->dar, midc->ch_regs + DAR);
@@ -290,7 +291,7 @@ static void midc_descriptor_complete(struct intel_mid_dma_chan *midc,
 	param_txd = txd->callback_param;
 
 	list_move(&desc->desc_node, &midc->free_list);
-
+	midc->busy = false;
 	spin_unlock_bh(&midc->lock);
 	if (callback_txd) {
 		pr_debug("MDMA: TXD callback set ... calling\n");
@@ -434,7 +435,7 @@ static int intel_mid_dma_device_control(struct dma_chan *chan,
 		return -ENXIO;
 
 	spin_lock_bh(&midc->lock);
-	if (midc->in_use == false) {
+	if (midc->busy == false) {
 		spin_unlock_bh(&midc->lock);
 		return 0;
 	}
@@ -618,11 +619,11 @@ static void intel_mid_dma_free_chan_resources(struct dma_chan *chan)
 	struct middma_device	*mid = to_middma_device(chan->device);
 	struct intel_mid_dma_desc	*desc, *_desc;
 
-	if (true == midc->in_use) {
+	if (true == midc->busy) {
 		/*trying to free ch in use!!!!!*/
 		pr_err("ERR_MDMA: trying to free ch in use\n");
 	}
-
+	pm_runtime_put(&mid->pdev->dev);
 	spin_lock_bh(&midc->lock);
 	midc->descs_allocated = 0;
 	list_for_each_entry_safe(desc, _desc, &midc->active_list, desc_node) {
@@ -639,6 +640,7 @@ static void intel_mid_dma_free_chan_resources(struct dma_chan *chan)
 	}
 	spin_unlock_bh(&midc->lock);
 	midc->in_use = false;
+	midc->busy = false;
 	/* Disable CH interrupts */
 	iowrite32(MASK_INTR_REG(midc->ch_id), mid->dma_base + MASK_BLOCK);
 	iowrite32(MASK_INTR_REG(midc->ch_id), mid->dma_base + MASK_ERR);
@@ -659,11 +661,20 @@ static int intel_mid_dma_alloc_chan_resources(struct dma_chan *chan)
 	dma_addr_t		phys;
 	int	i = 0;
 
+	pm_runtime_get_sync(&mid->pdev->dev);
+
+	if (mid->state == SUSPENDED) {
+		if (dma_resume(mid->pdev)) {
+			pr_err("ERR_MDMA: resume failed");
+			return -EFAULT;
+		}
+	}
 
 	/* ASSERT:  channel is idle */
 	if (test_ch_en(mid->dma_base, midc->ch_id)) {
 		/*ch is not idle*/
 		pr_err("ERR_MDMA: ch not idle\n");
+		pm_runtime_put(&mid->pdev->dev);
 		return -EIO;
 	}
 	midc->completed = chan->cookie = 1;
@@ -674,6 +685,7 @@ static int intel_mid_dma_alloc_chan_resources(struct dma_chan *chan)
 		desc = pci_pool_alloc(mid->dma_pool, GFP_KERNEL, &phys);
 		if (!desc) {
 			pr_err("ERR_MDMA: desc failed\n");
+			pm_runtime_put(&mid->pdev->dev);
 			return -ENOMEM;
 			/*check*/
 		}
@@ -686,7 +698,8 @@ static int intel_mid_dma_alloc_chan_resources(struct dma_chan *chan)
 		list_add_tail(&desc->desc_node, &midc->free_list);
 	}
 	spin_unlock_bh(&midc->lock);
-	midc->in_use = false;
+	midc->in_use = true;
+	midc->busy = false;
 	pr_debug("MID_DMA: Desc alloc done ret: %d desc\n", i);
 	return i;
 }
@@ -884,6 +897,7 @@ static int mid_setup_dma(struct pci_dev *pdev)
 	pr_debug("MDMA:Adding %d channel for this controller\n", dma->max_chan);
 	/*init CH structures*/
 	dma->intr_mask = 0;
+	dma->state = RUNNING;
 	for (i = 0; i < dma->max_chan; i++) {
 		struct intel_mid_dma_chan *midch = &dma->ch[i];
 
@@ -1070,6 +1084,9 @@ static int __devinit intel_mid_dma_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_dma;
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_allow(&pdev->dev);
 	return 0;
 
 err_dma:
@@ -1104,6 +1121,85 @@ static void __devexit intel_mid_dma_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+/* Power Management */
+/*
+* dma_suspend - PCI suspend function
+*
+* @pci: PCI device structure
+* @state: PM message
+*
+* This function is called by OS when a power event occurs
+*/
+int dma_suspend(struct pci_dev *pci, pm_message_t state)
+{
+	int i;
+	struct middma_device *device = pci_get_drvdata(pci);
+	pr_debug("MDMA: dma_suspend called\n");
+
+	for (i = 0; i < device->max_chan; i++) {
+		if (device->ch[i].in_use)
+			return -EAGAIN;
+	}
+	device->state = SUSPENDED;
+	pci_set_drvdata(pci, device);
+	pci_save_state(pci);
+	pci_disable_device(pci);
+	pci_set_power_state(pci, PCI_D3hot);
+	return 0;
+}
+
+/**
+* dma_resume - PCI resume function
+*
+* @pci:	PCI device structure
+*
+* This function is called by OS when a power event occurs
+*/
+int dma_resume(struct pci_dev *pci)
+{
+	int ret;
+	struct middma_device *device = pci_get_drvdata(pci);
+
+	pr_debug("MDMA: dma_resume called\n");
+	pci_set_power_state(pci, PCI_D0);
+	pci_restore_state(pci);
+	ret = pci_enable_device(pci);
+	if (ret) {
+		pr_err("MDMA: device cant be enabled for %x\n", pci->device);
+		return ret;
+	}
+	device->state = RUNNING;
+	iowrite32(REG_BIT0, device->dma_base + DMA_CFG);
+	pci_set_drvdata(pci, device);
+	return 0;
+}
+
+static int dma_runtime_suspend(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	return dma_suspend(pci_dev, PMSG_SUSPEND);
+}
+
+static int dma_runtime_resume(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	return dma_resume(pci_dev);
+}
+
+static int dma_runtime_idle(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct middma_device *device = pci_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < device->max_chan; i++) {
+		if (device->ch[i].in_use)
+			return -EAGAIN;
+	}
+
+	return pm_schedule_suspend(dev, 0);
+}
+
 /******************************************************************************
 * PCI stuff
 */
@@ -1116,11 +1212,24 @@ static struct pci_device_id intel_mid_dma_ids[] = {
 };
 MODULE_DEVICE_TABLE(pci, intel_mid_dma_ids);
 
+static const struct dev_pm_ops intel_mid_dma_pm = {
+	.runtime_suspend = dma_runtime_suspend,
+	.runtime_resume = dma_runtime_resume,
+	.runtime_idle = dma_runtime_idle,
+};
+
 static struct pci_driver intel_mid_dma_pci = {
 	.name		=	"Intel MID DMA",
 	.id_table	=	intel_mid_dma_ids,
 	.probe		=	intel_mid_dma_probe,
 	.remove		=	__devexit_p(intel_mid_dma_remove),
+#ifdef CONFIG_PM
+	.suspend = dma_suspend,
+	.resume = dma_resume,
+	.driver = {
+		.pm = &intel_mid_dma_pm,
+	},
+#endif
 };
 
 static int __init intel_mid_dma_init(void)
diff --git a/drivers/dma/intel_mid_dma_regs.h b/drivers/dma/intel_mid_dma_regs.h
index d81aa65..a12dd25 100644
--- a/drivers/dma/intel_mid_dma_regs.h
+++ b/drivers/dma/intel_mid_dma_regs.h
@@ -29,7 +29,7 @@
 #include <linux/dmapool.h>
 #include <linux/pci_ids.h>
 
-#define INTEL_MID_DMA_DRIVER_VERSION "1.0.5"
+#define INTEL_MID_DMA_DRIVER_VERSION "1.0.6"
 
 #define	REG_BIT0		0x00000001
 #define	REG_BIT8		0x00000100
@@ -152,6 +152,7 @@ union intel_mid_dma_cfg_hi {
 	u32	cfg_hi;
 };
 
+
 /**
  * struct intel_mid_dma_chan - internal mid representation of a DMA channel
  * @chan: dma_chan strcture represetation for mid chan
@@ -166,6 +167,7 @@ union intel_mid_dma_cfg_hi {
  * @slave: dma slave struture
  * @descs_allocated: total number of decsiptors allocated
  * @dma: dma device struture pointer
+ * @busy: bool representing if ch is busy (active txn) or not
  * @in_use: bool representing if ch is in use or not
  */
 struct intel_mid_dma_chan {
@@ -181,6 +183,7 @@ struct intel_mid_dma_chan {
 	struct intel_mid_dma_slave	*slave;
 	unsigned int		descs_allocated;
 	struct middma_device	*dma;
+	bool			busy;
 	bool			in_use;
 };
 
@@ -190,6 +193,10 @@ static inline struct intel_mid_dma_chan *to_intel_mid_dma_chan(
 	return container_of(chan, struct intel_mid_dma_chan, chan);
 }
 
+enum intel_mid_dma_state {
+	RUNNING = 0,
+	SUSPENDED,
+};
 /**
  * struct middma_device - internal representation of a DMA device
  * @pdev: PCI device
@@ -205,6 +212,7 @@ static inline struct intel_mid_dma_chan *to_intel_mid_dma_chan(
  * @max_chan: max number of chs supported (from drv_data)
  * @block_size: Block size of DMA transfer supported (from drv_data)
  * @pimr_mask: MMIO register addr for periphral interrupt (from drv_data)
+ * @state: dma PM device state
  */
 struct middma_device {
 	struct pci_dev		*pdev;
@@ -220,6 +228,7 @@ struct middma_device {
 	int			max_chan;
 	int			block_size;
 	unsigned int		pimr_mask;
+	enum intel_mid_dma_state state;
 };
 
 static inline struct middma_device *to_middma_device(struct dma_device *common)
@@ -257,4 +266,7 @@ static inline struct intel_mid_dma_desc *to_intel_mid_dma_desc
 {
 	return container_of(txd, struct intel_mid_dma_desc, txd);
 }
+
+int dma_resume(struct pci_dev *pci);
+
 #endif /*__INTEL_MID_DMAC_REGS_H__*/
-- 
1.6.6.1

