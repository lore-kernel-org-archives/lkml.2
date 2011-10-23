Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1JWRPB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 13:15:01 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:60829 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab1JWRO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 13:14:59 -0400
Date: Sun, 23 Oct 2011 19:11:35 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH staging 3/6] et131x: fix error paths in et131x_pci_setup.
Message-ID: <20111023171135.GC28657@electric-eye.fr.zoreil.com>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com> <20111023093651.GA22285@kroah.com> <20111023094231.GA3409@msilap.einon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111023094231.GA3409@msilap.einon>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrong status code and unbalanced phy_connect.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
---
 drivers/staging/et131x/et131x.c |   99 +++++++++++++++------------------------
 1 files changed, 38 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 2ae7819..2b6ca6a 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -4402,6 +4402,7 @@ static void __devexit et131x_pci_remove(struct pci_dev *pdev)
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
 	unregister_netdev(netdev);
+	phy_disconnect(adapter->phydev);
 	mdiobus_unregister(adapter->mii_bus);
 	kfree(adapter->mii_bus->irq);
 	mdiobus_free(adapter->mii_bus);
@@ -5245,40 +5246,6 @@ static const struct net_device_ops et131x_netdev_ops = {
 };
 
 /**
- * et131x_device_alloc
- *
- * Returns pointer to the allocated and initialized net_device struct for
- * this device.
- *
- * Create instances of net_device and wl_private for the new adapter and
- * register the device's entry points in the net_device structure.
- */
-struct net_device *et131x_device_alloc(void)
-{
-	struct net_device *netdev;
-
-	/* Alloc net_device and adapter structs */
-	netdev = alloc_etherdev(sizeof(struct et131x_adapter));
-
-	if (!netdev) {
-		printk(KERN_ERR "et131x: Alloc of net_device struct failed\n");
-		return NULL;
-	}
-
-	/*
-	 * Setup the function registration table (and other data) for a
-	 * net_device
-	 */
-	netdev->watchdog_timeo = ET131X_TX_TIMEOUT;
-	netdev->netdev_ops     = &et131x_netdev_ops;
-
-	/* Poll? */
-	/* netdev->poll               = &et131x_poll; */
-	/* netdev->poll_controller    = &et131x_poll_controller; */
-	return netdev;
-}
-
-/**
  * et131x_pci_setup - Perform device initialization
  * @pdev: a pointer to the device's pci_dev structure
  * @ent: this device's entry in the pci_device_id table
@@ -5293,24 +5260,26 @@ struct net_device *et131x_device_alloc(void)
 static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 			       const struct pci_device_id *ent)
 {
-	int result;
 	struct net_device *netdev;
 	struct et131x_adapter *adapter;
+	int rc;
 	int ii;
 
-	result = pci_enable_device(pdev);
-	if (result) {
+	rc = pci_enable_device(pdev);
+	if (rc < 0) {
 		dev_err(&pdev->dev, "pci_enable_device() failed\n");
-		goto err_out;
+		goto out;
 	}
 
 	/* Perform some basic PCI checks */
 	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
 		dev_err(&pdev->dev, "Can't find PCI device's base address\n");
+		rc = -ENODEV;
 		goto err_disable;
 	}
 
-	if (pci_request_regions(pdev, DRIVER_NAME)) {
+	rc = pci_request_regions(pdev, DRIVER_NAME);
+	if (rc < 0) {
 		dev_err(&pdev->dev, "Can't get PCI resources\n");
 		goto err_disable;
 	}
@@ -5319,46 +5288,50 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 
 	/* Check the DMA addressing support of this device */
 	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
-		result = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
-		if (result) {
+		rc = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
+		if (rc < 0) {
 			dev_err(&pdev->dev,
 			  "Unable to obtain 64 bit DMA for consistent allocations\n");
 			goto err_release_res;
 		}
 	} else if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
-		result = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
-		if (result) {
+		rc = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+		if (rc < 0) {
 			dev_err(&pdev->dev,
 			  "Unable to obtain 32 bit DMA for consistent allocations\n");
 			goto err_release_res;
 		}
 	} else {
 		dev_err(&pdev->dev, "No usable DMA addressing method\n");
-		result = -EIO;
+		rc = -EIO;
 		goto err_release_res;
 	}
 
 	/* Allocate netdev and private adapter structs */
-	netdev = et131x_device_alloc();
+	netdev = alloc_etherdev(sizeof(struct et131x_adapter));
 	if (!netdev) {
 		dev_err(&pdev->dev, "Couldn't alloc netdev struct\n");
-		result = -ENOMEM;
+		rc = -ENOMEM;
 		goto err_release_res;
 	}
 
+	netdev->watchdog_timeo = ET131X_TX_TIMEOUT;
+	netdev->netdev_ops     = &et131x_netdev_ops;
+
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 	et131x_set_ethtool_ops(netdev);
 
 	adapter = et131x_adapter_init(netdev, pdev);
 
-	/* Initialise the PCI setup for the device */
-	et131x_pci_init(adapter, pdev);
+	rc = et131x_pci_init(adapter, pdev);
+	if (rc < 0)
+		goto err_free_dev;
 
 	/* Map the bus-relative registers to system virtual memory */
 	adapter->regs = pci_ioremap_bar(pdev, 0);
 	if (!adapter->regs) {
 		dev_err(&pdev->dev, "Cannot map device registers\n");
-		result = -ENOMEM;
+		rc = -ENOMEM;
 		goto err_free_dev;
 	}
 
@@ -5372,8 +5345,8 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	et131x_disable_interrupts(adapter);
 
 	/* Allocate DMA memory */
-	result = et131x_adapter_memory_alloc(adapter);
-	if (result) {
+	rc = et131x_adapter_memory_alloc(adapter);
+	if (rc < 0) {
 		dev_err(&pdev->dev, "Could not alloc adapater memory (DMA)\n");
 		goto err_iounmap;
 	}
@@ -5391,6 +5364,8 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	adapter->boot_coma = 0;
 	et1310_disable_phy_coma(adapter);
 
+	rc = -ENOMEM;
+
 	/* Setup the mii_bus struct */
 	adapter->mii_bus = mdiobus_alloc();
 	if (!adapter->mii_bus) {
@@ -5414,13 +5389,14 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	for (ii = 0; ii < PHY_MAX_ADDR; ii++)
 		adapter->mii_bus->irq[ii] = PHY_POLL;
 
-	if (mdiobus_register(adapter->mii_bus)) {
+	rc = mdiobus_register(adapter->mii_bus);
+	if (rc < 0) {
 		dev_err(&pdev->dev, "failed to register MII bus\n");
-		mdiobus_free(adapter->mii_bus);
 		goto err_mdio_free_irq;
 	}
 
-	if (et131x_mii_probe(netdev)) {
+	rc = et131x_mii_probe(netdev);
+	if (rc < 0) {
 		dev_err(&pdev->dev, "failed to probe MII bus\n");
 		goto err_mdio_unregister;
 	}
@@ -5436,10 +5412,10 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	 */
 
 	/* Register the net_device struct with the Linux network layer */
-	result = register_netdev(netdev);
-	if (result != 0) {
+	rc = register_netdev(netdev);
+	if (rc < 0) {
 		dev_err(&pdev->dev, "register_netdev() failed\n");
-		goto err_mdio_unregister;
+		goto err_phy_disconnect;
 	}
 
 	/* Register the net_device struct with the PCI subsystem. Save a copy
@@ -5448,9 +5424,11 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	 */
 	pci_set_drvdata(pdev, netdev);
 	pci_save_state(adapter->pdev);
+out:
+	return rc;
 
-	return result;
-
+err_phy_disconnect:
+	phy_disconnect(adapter->phydev);
 err_mdio_unregister:
 	mdiobus_unregister(adapter->mii_bus);
 err_mdio_free_irq:
@@ -5468,8 +5446,7 @@ err_release_res:
 	pci_release_regions(pdev);
 err_disable:
 	pci_disable_device(pdev);
-err_out:
-	return result;
+	goto out;
 }
 
 static SIMPLE_DEV_PM_OPS(et131x_pm_ops, et131x_suspend, et131x_resume);
-- 
1.7.6.4

