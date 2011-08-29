Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1H2RoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:44:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57860 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab1H2RoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:44:06 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/6] staging: et131x: Further tidy up of 131x_pci_setup()
Date: Mon, 29 Aug 2011 18:42:36 +0100
Message-Id: <1314639761-4947-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Removed unused bool variable.
* Eliminated mid-function returns, used gotos instead

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x_initpci.c |   58 ++++++++++++++----------------
 drivers/staging/et131x/et131x_netdev.c  |    2 +-
 2 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 072cfb5..813a72f 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -512,10 +512,6 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 
 	struct et131x_adapter *adapter;
 
-	/* Setup the fundamental net_device and private adapter structure
-	 * elements  */
-	SET_NETDEV_DEV(netdev, &pdev->dev);
-
 	/* Allocate private adapter struct and copy in relevant information */
 	adapter = netdev_priv(netdev);
 	adapter->pdev = pci_dev_get(pdev);
@@ -579,33 +575,29 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 			       const struct pci_device_id *ent)
 {
-	int result = -EBUSY;
+	int result;
 	int pm_cap;
-	bool pci_using_dac;
 	struct net_device *netdev;
 	struct et131x_adapter *adapter;
 
 	/* Enable the device via the PCI subsystem */
-	if (pci_enable_device(pdev) != 0) {
-		dev_err(&pdev->dev,
-			"pci_enable_device() failed\n");
-		return -EIO;
+	result = pci_enable_device(pdev);
+	if (result) {
+		dev_err(&pdev->dev, "pci_enable_device() failed\n");
+		goto err_out;
 	}
 
 	/* Perform some basic PCI checks */
 	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
-		dev_err(&pdev->dev,
-			  "Can't find PCI device's base address\n");
+		dev_err(&pdev->dev, "Can't find PCI device's base address\n");
 		goto err_disable;
 	}
 
 	if (pci_request_regions(pdev, DRIVER_NAME)) {
-		dev_err(&pdev->dev,
-			"Can't get PCI resources\n");
+		dev_err(&pdev->dev, "Can't get PCI resources\n");
 		goto err_disable;
 	}
 
-	/* Enable PCI bus mastering */
 	pci_set_master(pdev);
 
 	/* Query PCI for Power Mgmt Capabilities
@@ -614,7 +606,7 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	 * needed?
 	 */
 	pm_cap = pci_find_capability(pdev, PCI_CAP_ID_PM);
-	if (pm_cap == 0) {
+	if (!pm_cap) {
 		dev_err(&pdev->dev,
 			  "Cannot find Power Management capabilities\n");
 		result = -EIO;
@@ -623,37 +615,42 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 
 	/* Check the DMA addressing support of this device */
 	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
-		pci_using_dac = true;
-
 		result = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-		if (result != 0) {
+		if (result) {
 			dev_err(&pdev->dev,
-				  "Unable to obtain 64 bit DMA for consistent allocations\n");
+			  "Unable to obtain 64 bit DMA for consistent allocations\n");
 			goto err_release_res;
 		}
 	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
-		pci_using_dac = false;
+		result = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (result) {
+			dev_err(&pdev->dev,
+			  "Unable to obtain 32 bit DMA for consistent allocations\n");
+			goto err_release_res;
+		}
 	} else {
-		dev_err(&pdev->dev,
-			"No usable DMA addressing method\n");
+		dev_err(&pdev->dev, "No usable DMA addressing method\n");
 		result = -EIO;
 		goto err_release_res;
 	}
 
 	/* Allocate netdev and private adapter structs */
 	netdev = et131x_device_alloc();
-	if (netdev == NULL) {
+	if (!netdev) {
 		dev_err(&pdev->dev, "Couldn't alloc netdev struct\n");
 		result = -ENOMEM;
 		goto err_release_res;
 	}
+
+	SET_NETDEV_DEV(netdev, &pdev->dev);
+
 	adapter = et131x_adapter_init(netdev, pdev);
 	/* Initialise the PCI setup for the device */
 	et131x_pci_init(adapter, pdev);
 
 	/* Map the bus-relative registers to system virtual memory */
 	adapter->regs = pci_ioremap_bar(pdev, 0);
-	if (adapter->regs == NULL) {
+	if (!adapter->regs) {
 		dev_err(&pdev->dev, "Cannot map device registers\n");
 		result = -ENOMEM;
 		goto err_free_dev;
@@ -670,7 +667,7 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 
 	/* Allocate DMA memory */
 	result = et131x_adapter_memory_alloc(adapter);
-	if (result != 0) {
+	if (result) {
 		dev_err(&pdev->dev, "Could not alloc adapater memory (DMA)\n");
 		goto err_iounmap;
 	}
@@ -678,9 +675,7 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	/* Init send data structures */
 	et131x_init_send(adapter);
 
-	/*
-	 * Set up the task structure for the ISR's deferred handler
-	 */
+	/* Set up the task structure for the ISR's deferred handler */
 	INIT_WORK(&adapter->task, et131x_isr_handler);
 
 	/* Copy address into the net_device struct */
@@ -699,8 +694,7 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	/* Initialize link state */
 	netif_carrier_off(adapter->netdev);
 
-	/* Initialize variable for counting how long we do not have
-							link status */
+	/* Init variable for counting how long we do not have link status */
 	adapter->boot_coma = 0;
 
 	/* We can enable interrupts now
@@ -723,6 +717,7 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	 */
 	pci_set_drvdata(pdev, netdev);
 	pci_save_state(adapter->pdev);
+
 	return result;
 
 err_mem_free:
@@ -736,6 +731,7 @@ err_release_res:
 	pci_release_regions(pdev);
 err_disable:
 	pci_disable_device(pdev);
+err_out:
 	return result;
 }
 
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 7555a24..20df145 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -687,7 +687,7 @@ struct net_device *et131x_device_alloc(void)
 	/* Alloc net_device and adapter structs */
 	netdev = alloc_etherdev(sizeof(struct et131x_adapter));
 
-	if (netdev == NULL) {
+	if (!netdev) {
 		printk(KERN_ERR "et131x: Alloc of net_device struct failed\n");
 		return NULL;
 	}
-- 
1.7.6

