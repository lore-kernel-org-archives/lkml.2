Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab1JRQK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 12:10:57 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56765 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933419Ab1JRQKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 12:10:33 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 26/26] staging: et131x: Remove more forward declarations
Date: Tue, 18 Oct 2011 17:07:59 +0100
Message-Id: <1318954079-16666-27-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
References: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved functions in et131x.c file to remove the following forward
declarations:

et131x_soft_reset
et131x_isr_handler
et131x_device_alloc

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |  505 +++++++++++++++++++--------------------
 1 files changed, 251 insertions(+), 254 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 2947635..44fff21 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -576,13 +576,10 @@ struct et131x_adapter {
 	struct net_device_stats net_stats;
 };
 
-void et131x_soft_reset(struct et131x_adapter *adapter);
-void et131x_isr_handler(struct work_struct *work);
 void et1310_setup_device_for_multicast(struct et131x_adapter *adapter);
 void et1310_setup_device_for_unicast(struct et131x_adapter *adapter);
 void et131x_up(struct net_device *netdev);
 void et131x_down(struct net_device *netdev);
-struct net_device *et131x_device_alloc(void);
 void et131x_enable_txrx(struct net_device *netdev);
 void et131x_disable_txrx(struct net_device *netdev);
 int et1310_in_phy_coma(struct et131x_adapter *adapter);
@@ -1970,6 +1967,21 @@ void et131x_adapter_setup(struct et131x_adapter *adapter)
 }
 
 /**
+ * et131x_soft_reset - Issue a soft reset to the hardware, complete for ET1310
+ * @adapter: pointer to our private adapter structure
+ */
+void et131x_soft_reset(struct et131x_adapter *adapter)
+{
+	/* Disable MAC Core */
+	writel(0xc00f0000, &adapter->regs->mac.cfg1);
+
+	/* Set everything to a reset value */
+	writel(0x7F, &adapter->regs->global.sw_reset);
+	writel(0x000f0000, &adapter->regs->mac.cfg1);
+	writel(0x00000000, &adapter->regs->mac.cfg1);
+}
+
+/**
  * et1310_enable_phy_coma - called when network cable is unplugged
  * @adapter: pointer to our adapter structure
  *
@@ -4097,21 +4109,6 @@ void et131x_error_timer_handler(unsigned long data)
 }
 
 /**
- * et131x_soft_reset - Issue a soft reset to the hardware, complete for ET1310
- * @adapter: pointer to our private adapter structure
- */
-void et131x_soft_reset(struct et131x_adapter *adapter)
-{
-	/* Disable MAC Core */
-	writel(0xc00f0000, &adapter->regs->mac.cfg1);
-
-	/* Set everything to a reset value */
-	writel(0x7F, &adapter->regs->global.sw_reset);
-	writel(0x000f0000, &adapter->regs->mac.cfg1);
-	writel(0x00000000, &adapter->regs->mac.cfg1);
-}
-
-/**
  * et131x_adapter_memory_alloc
  * @adapter: pointer to our private adapter structure
  *
@@ -4365,200 +4362,6 @@ void et131x_disable_interrupts(struct et131x_adapter *adapter)
 }
 
 /**
- * et131x_pci_setup - Perform device initialization
- * @pdev: a pointer to the device's pci_dev structure
- * @ent: this device's entry in the pci_device_id table
- *
- * Returns 0 on success, errno on failure (as defined in errno.h)
- *
- * Registered in the pci_driver structure, this function is called when the
- * PCI subsystem finds a new PCI device which matches the information
- * contained in the pci_device_id table. This routine is the equivalent to
- * a device insertion routine.
- */
-static int __devinit et131x_pci_setup(struct pci_dev *pdev,
-			       const struct pci_device_id *ent)
-{
-	int result;
-	struct net_device *netdev;
-	struct et131x_adapter *adapter;
-	int ii;
-
-	result = pci_enable_device(pdev);
-	if (result) {
-		dev_err(&pdev->dev, "pci_enable_device() failed\n");
-		goto err_out;
-	}
-
-	/* Perform some basic PCI checks */
-	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
-		dev_err(&pdev->dev, "Can't find PCI device's base address\n");
-		goto err_disable;
-	}
-
-	if (pci_request_regions(pdev, DRIVER_NAME)) {
-		dev_err(&pdev->dev, "Can't get PCI resources\n");
-		goto err_disable;
-	}
-
-	pci_set_master(pdev);
-
-	/* Check the DMA addressing support of this device */
-	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
-		result = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
-		if (result) {
-			dev_err(&pdev->dev,
-			  "Unable to obtain 64 bit DMA for consistent allocations\n");
-			goto err_release_res;
-		}
-	} else if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
-		result = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
-		if (result) {
-			dev_err(&pdev->dev,
-			  "Unable to obtain 32 bit DMA for consistent allocations\n");
-			goto err_release_res;
-		}
-	} else {
-		dev_err(&pdev->dev, "No usable DMA addressing method\n");
-		result = -EIO;
-		goto err_release_res;
-	}
-
-	/* Allocate netdev and private adapter structs */
-	netdev = et131x_device_alloc();
-	if (!netdev) {
-		dev_err(&pdev->dev, "Couldn't alloc netdev struct\n");
-		result = -ENOMEM;
-		goto err_release_res;
-	}
-
-	SET_NETDEV_DEV(netdev, &pdev->dev);
-	et131x_set_ethtool_ops(netdev);
-
-	adapter = et131x_adapter_init(netdev, pdev);
-
-	/* Initialise the PCI setup for the device */
-	et131x_pci_init(adapter, pdev);
-
-	/* Map the bus-relative registers to system virtual memory */
-	adapter->regs = pci_ioremap_bar(pdev, 0);
-	if (!adapter->regs) {
-		dev_err(&pdev->dev, "Cannot map device registers\n");
-		result = -ENOMEM;
-		goto err_free_dev;
-	}
-
-	/* If Phy COMA mode was enabled when we went down, disable it here. */
-	writel(ET_PMCSR_INIT,  &adapter->regs->global.pm_csr);
-
-	/* Issue a global reset to the et1310 */
-	et131x_soft_reset(adapter);
-
-	/* Disable all interrupts (paranoid) */
-	et131x_disable_interrupts(adapter);
-
-	/* Allocate DMA memory */
-	result = et131x_adapter_memory_alloc(adapter);
-	if (result) {
-		dev_err(&pdev->dev, "Could not alloc adapater memory (DMA)\n");
-		goto err_iounmap;
-	}
-
-	/* Init send data structures */
-	et131x_init_send(adapter);
-
-	/* Set up the task structure for the ISR's deferred handler */
-	INIT_WORK(&adapter->task, et131x_isr_handler);
-
-	/* Copy address into the net_device struct */
-	memcpy(netdev->dev_addr, adapter->addr, ETH_ALEN);
-
-	/* Init variable for counting how long we do not have link status */
-	adapter->boot_coma = 0;
-	et1310_disable_phy_coma(adapter);
-
-	/* Setup the mii_bus struct */
-	adapter->mii_bus = mdiobus_alloc();
-	if (!adapter->mii_bus) {
-		dev_err(&pdev->dev, "Alloc of mii_bus struct failed\n");
-		goto err_mem_free;
-	}
-
-	adapter->mii_bus->name = "et131x_eth_mii";
-	snprintf(adapter->mii_bus->id, MII_BUS_ID_SIZE, "%x",
-		(adapter->pdev->bus->number << 8) | adapter->pdev->devfn);
-	adapter->mii_bus->priv = netdev;
-	adapter->mii_bus->read = et131x_mdio_read;
-	adapter->mii_bus->write = et131x_mdio_write;
-	adapter->mii_bus->reset = et131x_mdio_reset;
-	adapter->mii_bus->irq = kmalloc(sizeof(int)*PHY_MAX_ADDR, GFP_KERNEL);
-	if (!adapter->mii_bus->irq) {
-		dev_err(&pdev->dev, "mii_bus irq allocation failed\n");
-		goto err_mdio_free;
-	}
-
-	for (ii = 0; ii < PHY_MAX_ADDR; ii++)
-		adapter->mii_bus->irq[ii] = PHY_POLL;
-
-	if (mdiobus_register(adapter->mii_bus)) {
-		dev_err(&pdev->dev, "failed to register MII bus\n");
-		mdiobus_free(adapter->mii_bus);
-		goto err_mdio_free_irq;
-	}
-
-	if (et131x_mii_probe(netdev)) {
-		dev_err(&pdev->dev, "failed to probe MII bus\n");
-		goto err_mdio_unregister;
-	}
-
-	/* Setup et1310 as per the documentation */
-	et131x_adapter_setup(adapter);
-
-	/* We can enable interrupts now
-	 *
-	 *  NOTE - Because registration of interrupt handler is done in the
-	 *         device's open(), defer enabling device interrupts to that
-	 *         point
-	 */
-
-	/* Register the net_device struct with the Linux network layer */
-	result = register_netdev(netdev);
-	if (result != 0) {
-		dev_err(&pdev->dev, "register_netdev() failed\n");
-		goto err_mdio_unregister;
-	}
-
-	/* Register the net_device struct with the PCI subsystem. Save a copy
-	 * of the PCI config space for this device now that the device has
-	 * been initialized, just in case it needs to be quickly restored.
-	 */
-	pci_set_drvdata(pdev, netdev);
-	pci_save_state(adapter->pdev);
-
-	return result;
-
-err_mdio_unregister:
-	mdiobus_unregister(adapter->mii_bus);
-err_mdio_free_irq:
-	kfree(adapter->mii_bus->irq);
-err_mdio_free:
-	mdiobus_free(adapter->mii_bus);
-err_mem_free:
-	et131x_adapter_memory_free(adapter);
-err_iounmap:
-	iounmap(adapter->regs);
-err_free_dev:
-	pci_dev_put(pdev);
-	free_netdev(netdev);
-err_release_res:
-	pci_release_regions(pdev);
-err_disable:
-	pci_disable_device(pdev);
-err_out:
-	return result;
-}
-
-/**
  * et131x_pci_remove
  * @pdev: a pointer to the device's pci_dev structure
  *
@@ -4614,48 +4417,6 @@ static int et131x_resume(struct device *dev)
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(et131x_pm_ops, et131x_suspend, et131x_resume);
-#define ET131X_PM_OPS (&et131x_pm_ops)
-#else
-#define ET131X_PM_OPS NULL
-#endif
-
-static DEFINE_PCI_DEVICE_TABLE(et131x_pci_table) = {
-	{ PCI_VDEVICE(ATT, ET131X_PCI_DEVICE_ID_GIG), 0UL},
-	{ PCI_VDEVICE(ATT, ET131X_PCI_DEVICE_ID_FAST), 0UL},
-	{0,}
-};
-MODULE_DEVICE_TABLE(pci, et131x_pci_table);
-
-static struct pci_driver et131x_driver = {
-	.name		= DRIVER_NAME,
-	.id_table	= et131x_pci_table,
-	.probe		= et131x_pci_setup,
-	.remove		= __devexit_p(et131x_pci_remove),
-	.driver.pm	= ET131X_PM_OPS,
-};
-
-/**
- * et131x_init_module - The "main" entry point called on driver initialization
- *
- * Returns 0 on success, errno on failure (as defined in errno.h)
- */
-static int __init et131x_init_module(void)
-{
-	return pci_register_driver(&et131x_driver);
-}
-
-/**
- * et131x_cleanup_module - The entry point called on driver cleanup
- */
-static void __exit et131x_cleanup_module(void)
-{
-	pci_unregister_driver(&et131x_driver);
-}
-
-module_init(et131x_init_module);
-module_exit(et131x_cleanup_module);
-
 /* ISR functions */
 
 /**
@@ -5528,3 +5289,239 @@ struct net_device *et131x_device_alloc(void)
 	return netdev;
 }
 
+/**
+ * et131x_pci_setup - Perform device initialization
+ * @pdev: a pointer to the device's pci_dev structure
+ * @ent: this device's entry in the pci_device_id table
+ *
+ * Returns 0 on success, errno on failure (as defined in errno.h)
+ *
+ * Registered in the pci_driver structure, this function is called when the
+ * PCI subsystem finds a new PCI device which matches the information
+ * contained in the pci_device_id table. This routine is the equivalent to
+ * a device insertion routine.
+ */
+static int __devinit et131x_pci_setup(struct pci_dev *pdev,
+			       const struct pci_device_id *ent)
+{
+	int result;
+	struct net_device *netdev;
+	struct et131x_adapter *adapter;
+	int ii;
+
+	result = pci_enable_device(pdev);
+	if (result) {
+		dev_err(&pdev->dev, "pci_enable_device() failed\n");
+		goto err_out;
+	}
+
+	/* Perform some basic PCI checks */
+	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
+		dev_err(&pdev->dev, "Can't find PCI device's base address\n");
+		goto err_disable;
+	}
+
+	if (pci_request_regions(pdev, DRIVER_NAME)) {
+		dev_err(&pdev->dev, "Can't get PCI resources\n");
+		goto err_disable;
+	}
+
+	pci_set_master(pdev);
+
+	/* Check the DMA addressing support of this device */
+	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
+		result = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
+		if (result) {
+			dev_err(&pdev->dev,
+			  "Unable to obtain 64 bit DMA for consistent allocations\n");
+			goto err_release_res;
+		}
+	} else if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
+		result = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+		if (result) {
+			dev_err(&pdev->dev,
+			  "Unable to obtain 32 bit DMA for consistent allocations\n");
+			goto err_release_res;
+		}
+	} else {
+		dev_err(&pdev->dev, "No usable DMA addressing method\n");
+		result = -EIO;
+		goto err_release_res;
+	}
+
+	/* Allocate netdev and private adapter structs */
+	netdev = et131x_device_alloc();
+	if (!netdev) {
+		dev_err(&pdev->dev, "Couldn't alloc netdev struct\n");
+		result = -ENOMEM;
+		goto err_release_res;
+	}
+
+	SET_NETDEV_DEV(netdev, &pdev->dev);
+	et131x_set_ethtool_ops(netdev);
+
+	adapter = et131x_adapter_init(netdev, pdev);
+
+	/* Initialise the PCI setup for the device */
+	et131x_pci_init(adapter, pdev);
+
+	/* Map the bus-relative registers to system virtual memory */
+	adapter->regs = pci_ioremap_bar(pdev, 0);
+	if (!adapter->regs) {
+		dev_err(&pdev->dev, "Cannot map device registers\n");
+		result = -ENOMEM;
+		goto err_free_dev;
+	}
+
+	/* If Phy COMA mode was enabled when we went down, disable it here. */
+	writel(ET_PMCSR_INIT,  &adapter->regs->global.pm_csr);
+
+	/* Issue a global reset to the et1310 */
+	et131x_soft_reset(adapter);
+
+	/* Disable all interrupts (paranoid) */
+	et131x_disable_interrupts(adapter);
+
+	/* Allocate DMA memory */
+	result = et131x_adapter_memory_alloc(adapter);
+	if (result) {
+		dev_err(&pdev->dev, "Could not alloc adapater memory (DMA)\n");
+		goto err_iounmap;
+	}
+
+	/* Init send data structures */
+	et131x_init_send(adapter);
+
+	/* Set up the task structure for the ISR's deferred handler */
+	INIT_WORK(&adapter->task, et131x_isr_handler);
+
+	/* Copy address into the net_device struct */
+	memcpy(netdev->dev_addr, adapter->addr, ETH_ALEN);
+
+	/* Init variable for counting how long we do not have link status */
+	adapter->boot_coma = 0;
+	et1310_disable_phy_coma(adapter);
+
+	/* Setup the mii_bus struct */
+	adapter->mii_bus = mdiobus_alloc();
+	if (!adapter->mii_bus) {
+		dev_err(&pdev->dev, "Alloc of mii_bus struct failed\n");
+		goto err_mem_free;
+	}
+
+	adapter->mii_bus->name = "et131x_eth_mii";
+	snprintf(adapter->mii_bus->id, MII_BUS_ID_SIZE, "%x",
+		(adapter->pdev->bus->number << 8) | adapter->pdev->devfn);
+	adapter->mii_bus->priv = netdev;
+	adapter->mii_bus->read = et131x_mdio_read;
+	adapter->mii_bus->write = et131x_mdio_write;
+	adapter->mii_bus->reset = et131x_mdio_reset;
+	adapter->mii_bus->irq = kmalloc(sizeof(int)*PHY_MAX_ADDR, GFP_KERNEL);
+	if (!adapter->mii_bus->irq) {
+		dev_err(&pdev->dev, "mii_bus irq allocation failed\n");
+		goto err_mdio_free;
+	}
+
+	for (ii = 0; ii < PHY_MAX_ADDR; ii++)
+		adapter->mii_bus->irq[ii] = PHY_POLL;
+
+	if (mdiobus_register(adapter->mii_bus)) {
+		dev_err(&pdev->dev, "failed to register MII bus\n");
+		mdiobus_free(adapter->mii_bus);
+		goto err_mdio_free_irq;
+	}
+
+	if (et131x_mii_probe(netdev)) {
+		dev_err(&pdev->dev, "failed to probe MII bus\n");
+		goto err_mdio_unregister;
+	}
+
+	/* Setup et1310 as per the documentation */
+	et131x_adapter_setup(adapter);
+
+	/* We can enable interrupts now
+	 *
+	 *  NOTE - Because registration of interrupt handler is done in the
+	 *         device's open(), defer enabling device interrupts to that
+	 *         point
+	 */
+
+	/* Register the net_device struct with the Linux network layer */
+	result = register_netdev(netdev);
+	if (result != 0) {
+		dev_err(&pdev->dev, "register_netdev() failed\n");
+		goto err_mdio_unregister;
+	}
+
+	/* Register the net_device struct with the PCI subsystem. Save a copy
+	 * of the PCI config space for this device now that the device has
+	 * been initialized, just in case it needs to be quickly restored.
+	 */
+	pci_set_drvdata(pdev, netdev);
+	pci_save_state(adapter->pdev);
+
+	return result;
+
+err_mdio_unregister:
+	mdiobus_unregister(adapter->mii_bus);
+err_mdio_free_irq:
+	kfree(adapter->mii_bus->irq);
+err_mdio_free:
+	mdiobus_free(adapter->mii_bus);
+err_mem_free:
+	et131x_adapter_memory_free(adapter);
+err_iounmap:
+	iounmap(adapter->regs);
+err_free_dev:
+	pci_dev_put(pdev);
+	free_netdev(netdev);
+err_release_res:
+	pci_release_regions(pdev);
+err_disable:
+	pci_disable_device(pdev);
+err_out:
+	return result;
+}
+
+static SIMPLE_DEV_PM_OPS(et131x_pm_ops, et131x_suspend, et131x_resume);
+#define ET131X_PM_OPS (&et131x_pm_ops)
+#else
+#define ET131X_PM_OPS NULL
+#endif
+
+static DEFINE_PCI_DEVICE_TABLE(et131x_pci_table) = {
+	{ PCI_VDEVICE(ATT, ET131X_PCI_DEVICE_ID_GIG), 0UL},
+	{ PCI_VDEVICE(ATT, ET131X_PCI_DEVICE_ID_FAST), 0UL},
+	{0,}
+};
+MODULE_DEVICE_TABLE(pci, et131x_pci_table);
+
+static struct pci_driver et131x_driver = {
+	.name		= DRIVER_NAME,
+	.id_table	= et131x_pci_table,
+	.probe		= et131x_pci_setup,
+	.remove		= __devexit_p(et131x_pci_remove),
+	.driver.pm	= ET131X_PM_OPS,
+};
+
+/**
+ * et131x_init_module - The "main" entry point called on driver initialization
+ *
+ * Returns 0 on success, errno on failure (as defined in errno.h)
+ */
+static int __init et131x_init_module(void)
+{
+	return pci_register_driver(&et131x_driver);
+}
+
+/**
+ * et131x_cleanup_module - The entry point called on driver cleanup
+ */
+static void __exit et131x_cleanup_module(void)
+{
+	pci_unregister_driver(&et131x_driver);
+}
+
+module_init(et131x_init_module);
+module_exit(et131x_cleanup_module);
+
-- 
1.7.6.4

