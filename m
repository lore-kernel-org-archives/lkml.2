Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab1H2RoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:44:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48500 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab1H2RoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:44:14 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=206/6=5D=20staging=3A=20et131x=3A=20Use=20phy-device=2C=20mii=5Fbus=20and=20ethtool=5Fops?=
Date: Mon, 29 Aug 2011 18:42:41 +0100
Message-Id: <1314639761-4947-6-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314639761-4947-1-git-send-email-mark.einon@gmail.com>
References: <1314639761-4947-1-git-send-email-mark.einon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding some basic ethtool ops and supporting functionality using a phy device.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/Makefile         |    1 +
 drivers/staging/et131x/et1310_phy.c     |   45 ++++++++--
 drivers/staging/et131x/et1310_phy.h     |    4 +-
 drivers/staging/et131x/et131x.h         |    6 ++
 drivers/staging/et131x/et131x_adapter.h |    3 +-
 drivers/staging/et131x/et131x_ethtool.c |   71 +++++++++++++++
 drivers/staging/et131x/et131x_initpci.c |  147 +++++++++++++++++++++++++++----
 drivers/staging/et131x/et131x_netdev.c  |    7 +-
 8 files changed, 254 insertions(+), 30 deletions(-)
 create mode 100644 drivers/staging/et131x/et131x_ethtool.c

diff --git a/drivers/staging/et131x/Makefile b/drivers/staging/et131x/Makefile
index dfcd2bf..5ea0272 100644
--- a/drivers/staging/et131x/Makefile
+++ b/drivers/staging/et131x/Makefile
@@ -11,5 +11,6 @@ et131x-y :=	et1310_eeprom.o \
 		et1310_rx.o \
 		et1310_tx.o \
 		et131x_initpci.o \
+		et131x_ethtool.o \
 		et131x_isr.o \
 		et131x_netdev.o
diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 21e0704..5e21a18 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -1,6 +1,6 @@
 /*
  * Agere Systems Inc.
- * 10/100/1000 Base-T Ethernet Driver for the ET1301 and ET131x series MACs
+ * 10/100/1000 Base-T Ethernet Driver for the ET1310 and ET131x series MACs
  *
  * Copyright * 2005 Agere Systems Inc.
  * All rights reserved.
@@ -82,6 +82,7 @@
 #include <linux/if_arp.h>
 #include <linux/ioport.h>
 #include <linux/random.h>
+#include <linux/phy.h>
 
 #include "et1310_phy.h"
 
@@ -93,6 +94,40 @@
 
 #include "et131x.h"
 
+int et131x_mdio_read(struct mii_bus *bus, int phy_addr, int reg)
+{
+	struct net_device *netdev = bus->priv;
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+	u16 value;
+	int ret;
+
+	ret = et131x_phy_mii_read(adapter, phy_addr, reg, &value);
+
+	if (ret < 0)
+		return ret;
+	else
+		return value;
+}
+
+int et131x_mdio_write(struct mii_bus *bus, int phy_addr, int reg, u16 value)
+{
+	struct net_device *netdev = bus->priv;
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+
+	/* mii_write always uses the same phy_addr, xcvr_addr */
+	return et131x_mii_write(adapter, reg, value);
+}
+
+int et131x_mdio_reset(struct mii_bus *bus)
+{
+	struct net_device *netdev = bus->priv;
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+
+	et1310_phy_reset(adapter);
+
+	return 0;
+}
+
 /**
  * et131x_phy_mii_read - Read from the PHY through the MII Interface on the MAC
  * @adapter: pointer to our private adapter structure
@@ -107,7 +142,7 @@ int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 xcvr_addr,
 {
 	struct mac_regs __iomem *mac = &adapter->regs->mac;
 	int status = 0;
-	u32 delay;
+	u32 delay = 0;
 	u32 mii_addr;
 	u32 mii_cmd;
 	u32 mii_indicator;
@@ -124,9 +159,6 @@ int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 xcvr_addr,
 	/* Set up the register we need to read from on the correct PHY */
 	writel(MII_ADDR(xcvr_addr, xcvr_reg), &mac->mii_mgmt_addr);
 
-	/* Kick the read cycle off */
-	delay = 0;
-
 	writel(0x1, &mac->mii_mgmt_cmd);
 
 	do {
@@ -176,7 +208,7 @@ int et131x_mii_write(struct et131x_adapter *adapter, u8 xcvr_reg, u16 value)
 	struct mac_regs __iomem *mac = &adapter->regs->mac;
 	int status = 0;
 	u8 xcvr_addr = adapter->stats.xcvr_addr;
-	u32 delay;
+	u32 delay = 0;
 	u32 mii_addr;
 	u32 mii_cmd;
 	u32 mii_indicator;
@@ -195,7 +227,6 @@ int et131x_mii_write(struct et131x_adapter *adapter, u8 xcvr_reg, u16 value)
 
 	/* Add the value to write to the registers to the mac */
 	writel(value, &mac->mii_mgmt_ctrl);
-	delay = 0;
 
 	do {
 		udelay(50);
diff --git a/drivers/staging/et131x/et1310_phy.h b/drivers/staging/et131x/et1310_phy.h
index 6b38a3e..8e9404e 100644
--- a/drivers/staging/et131x/et1310_phy.h
+++ b/drivers/staging/et131x/et1310_phy.h
@@ -121,8 +121,8 @@ struct mi_regs {
 	u8 imr;		/* Interrupt Mask Reg(Reg 0x18) */
 	u8 isr;		/* Interrupt Status Reg(Reg 0x19) */
 	u8 psr;		/* PHY Status Reg(Reg 0x1A) */
-	u8 lcr1;		/* LED Control 1 Reg(Reg 0x1B) */
-	u8 lcr2;		/* LED Control 2 Reg(Reg 0x1C) */
+	u8 lcr1;	/* LED Control 1 Reg(Reg 0x1B) */
+	u8 lcr2;	/* LED Control 2 Reg(Reg 0x1C) */
 	u8 mi_res4[3];	/* Future use by MI working group(Reg 0x1D - 0x1F) */
 };
 
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index 91fafc0..9dee7bc 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -116,6 +116,10 @@ int32_t et131x_mii_write(struct et131x_adapter *adapter,
 void et131x_mii_check(struct et131x_adapter *pAdapter,
 		      u16 bmsr, u16 bmsr_ints);
 
+int et131x_mdio_read(struct mii_bus *bus, int phy_addr, int reg);
+int et131x_mdio_write(struct mii_bus *bus, int phy_addr, int reg, u16 value);
+int et131x_mdio_reset(struct mii_bus *bus);
+
 /* et1310_rx.c */
 int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter);
 void et131x_rx_dma_memory_free(struct et131x_adapter *adapter);
@@ -145,3 +149,5 @@ void et131x_handle_send_interrupt(struct et131x_adapter *adapter);
 void et131x_free_busy_send_packets(struct et131x_adapter *adapter);
 int et131x_send_packets(struct sk_buff *skb, struct net_device *netdev);
 
+/* et131x_ethtool.c */
+void et131x_set_ethtool_ops(struct net_device *netdev);
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index 508cc63..dbb14fe 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -144,7 +144,8 @@ struct ce_stats {
 struct et131x_adapter {
 	struct net_device *netdev;
 	struct pci_dev *pdev;
-
+	struct mii_bus *mii_bus;
+	struct phy_device *phydev;
 	struct work_struct task;
 
 	/* Flags that indicate current state of the adapter */
diff --git a/drivers/staging/et131x/et131x_ethtool.c b/drivers/staging/et131x/et131x_ethtool.c
new file mode 100644
index 0000000..d980ad6
--- /dev/null
+++ b/drivers/staging/et131x/et131x_ethtool.c
@@ -0,0 +1,71 @@
+/*
+ *  Copyright (C) 2011 Mark Einon
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ *  Mark Einon <mark.einon@gmail.com>
+ */
+#include "et131x_version.h"
+#include "et131x_defs.h"
+
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/netdevice.h>
+#include <linux/ethtool.h>
+#include <linux/phy.h>
+#include <linux/pci.h>
+
+#include "et131x_adapter.h"
+#include "et131x.h"
+
+static int et131x_get_settings(struct net_device *netdev,
+			       struct ethtool_cmd *cmd)
+{
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+
+	return phy_ethtool_gset(adapter->phydev, cmd);
+}
+
+static int et131x_set_settings(struct net_device *netdev,
+			       struct ethtool_cmd *cmd)
+{
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+
+	return phy_ethtool_sset(adapter->phydev, cmd);
+}
+
+#define ET131X_DRVINFO_LEN 32 /* value from ethtool.h */
+static void et131x_get_drvinfo(struct net_device *netdev,
+			       struct ethtool_drvinfo *info)
+{
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+
+	strncpy(info->driver, DRIVER_NAME, ET131X_DRVINFO_LEN);
+	strncpy(info->version, DRIVER_VERSION_STRING, ET131X_DRVINFO_LEN);
+	strncpy(info->bus_info, pci_name(adapter->pdev), ET131X_DRVINFO_LEN);
+}
+
+static struct ethtool_ops et131x_ethtool_ops = {
+        .get_settings = et131x_get_settings,
+        .set_settings = et131x_set_settings,
+        .get_drvinfo = et131x_get_drvinfo,
+        .get_link = ethtool_op_get_link,
+};
+
+void et131x_set_ethtool_ops(struct net_device *netdev)
+{
+	SET_ETHTOOL_OPS(netdev, &et131x_ethtool_ops);
+}
+
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index a184ac1..fbbef76 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -80,6 +80,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/phy.h>
 #include <linux/skbuff.h>
 #include <linux/if_arp.h>
 #include <linux/ioport.h>
@@ -329,7 +330,7 @@ void et131x_configure_global_regs(struct et131x_adapter *adapter)
  */
 int et131x_adapter_setup(struct et131x_adapter *adapter)
 {
-	int status = 0;
+	int status;
 
 	/* Configure the JAGCore */
 	et131x_configure_global_regs(adapter);
@@ -351,7 +352,7 @@ int et131x_adapter_setup(struct et131x_adapter *adapter)
 	/* Move the following code to Timer function?? */
 	status = et131x_xcvr_find(adapter);
 
-	if (status != 0)
+	if (status)
 		dev_warn(&adapter->pdev->dev, "Could not find the xcvr\n");
 
 	/* Prepare the TRUEPHY library. */
@@ -471,6 +472,80 @@ void et131x_adapter_memory_free(struct et131x_adapter *adapter)
 	et131x_rx_dma_memory_free(adapter);
 }
 
+static void et131x_adjust_link(struct net_device *netdev)
+{
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+	struct  phy_device *phydev = adapter->phydev;
+	struct address_map __iomem *iomem = adapter->regs;
+
+	u32 pm_csr;
+	u16 bmsr_ints;
+	u16 bmsr_data;
+
+	/* If we are in coma mode, we need to disable it. */
+	pm_csr = readl(&iomem->global.pm_csr);
+	if (pm_csr & ET_PM_PHY_SW_COMA) {
+		/*
+		 * Check to see if we are in coma mode and if
+		 * so, disable it because we will not be able
+		 * to read PHY values until we are out.
+		 */
+		et1310_disable_phy_coma(adapter);
+	}
+
+	et131x_mii_read(adapter,
+	       (uint8_t) offsetof(struct mi_regs, bmsr),
+	       &bmsr_data);
+
+	bmsr_ints = adapter->bmsr ^ bmsr_data;
+	adapter->bmsr = bmsr_data;
+
+	/* Do all the cable in / cable out stuff */
+	et131x_mii_check(adapter, bmsr_data, bmsr_ints);
+
+	phy_print_status(phydev);
+}
+
+int et131x_mii_probe(struct net_device *netdev)
+{
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+	struct  phy_device *phydev = NULL;
+
+	phydev = phy_find_first(adapter->mii_bus);
+	if (!phydev) {
+		dev_err(&adapter->pdev->dev, "no PHY found\n");
+		return -ENODEV;
+	}
+
+	phydev = phy_connect(netdev, dev_name(&phydev->dev),
+			&et131x_adjust_link, 0, PHY_INTERFACE_MODE_MII);
+
+	if(IS_ERR(phydev)) {
+		dev_err(&adapter->pdev->dev, "Could not attach to PHY\n");
+		return PTR_ERR(phydev);
+	}
+
+	phydev->supported &= (SUPPORTED_10baseT_Half
+                                | SUPPORTED_10baseT_Full
+                                | SUPPORTED_100baseT_Half
+                                | SUPPORTED_100baseT_Full
+                                | SUPPORTED_Autoneg
+                                | SUPPORTED_MII
+                                | SUPPORTED_TP);
+
+	if (adapter->pdev->device != ET131X_PCI_DEVICE_ID_FAST)
+		phydev->supported |= SUPPORTED_1000baseT_Full;
+
+        phydev->advertising = phydev->supported;
+        adapter->phydev = phydev;
+
+        dev_info(&adapter->pdev->dev, "attached PHY driver [%s] "
+                "(mii_bus:phy_addr=%s)\n",
+                phydev->drv->name, dev_name(&phydev->dev));
+
+        return 0;
+}
+
 /**
  * et131x_adapter_init
  * @adapter: pointer to the private adapter struct
@@ -538,8 +613,8 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	int pm_cap;
 	struct net_device *netdev;
 	struct et131x_adapter *adapter;
+	int ii;
 
-	/* Enable the device via the PCI subsystem */
 	result = pci_enable_device(pdev);
 	if (result) {
 		dev_err(&pdev->dev, "pci_enable_device() failed\n");
@@ -602,8 +677,10 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	}
 
 	SET_NETDEV_DEV(netdev, &pdev->dev);
+	et131x_set_ethtool_ops(netdev);
 
 	adapter = et131x_adapter_init(netdev, pdev);
+
 	/* Initialise the PCI setup for the device */
 	et131x_pci_init(adapter, pdev);
 
@@ -650,11 +727,43 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	adapter->error_timer.function = et131x_error_timer_handler;
 	adapter->error_timer.data = (unsigned long)adapter;
 
-	/* Initialize link state */
-	netif_carrier_off(adapter->netdev);
-
 	/* Init variable for counting how long we do not have link status */
 	adapter->boot_coma = 0;
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
+        if (!adapter->mii_bus->irq) {
+                dev_err(&pdev->dev, "mii_bus irq allocation failed\n");
+		goto err_mdio_free;
+        }
+
+        for (ii = 0; ii < PHY_MAX_ADDR; ii++)
+                adapter->mii_bus->irq[ii] = PHY_POLL;
+
+        if (mdiobus_register(adapter->mii_bus)) {
+                dev_err(&pdev->dev, "failed to register MII bus\n");
+		mdiobus_free(adapter->mii_bus);
+		goto err_mdio_free_irq;
+        }
+
+	if (et131x_mii_probe(netdev)) {
+                dev_err(&pdev->dev, "failed to probe MII bus\n");
+		goto err_mdio_unregister;
+	}
 
 	/* We can enable interrupts now
 	 *
@@ -667,7 +776,7 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	result = register_netdev(netdev);
 	if (result != 0) {
 		dev_err(&pdev->dev, "register_netdev() failed\n");
-		goto err_mem_free;
+		goto err_mdio_unregister;
 	}
 
 	/* Register the net_device struct with the PCI subsystem. Save a copy
@@ -679,6 +788,12 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 
 	return result;
 
+err_mdio_unregister:
+	mdiobus_unregister(adapter->mii_bus);
+err_mdio_free_irq:
+	kfree(adapter->mii_bus->irq);
+err_mdio_free:
+	mdiobus_free(adapter->mii_bus);
 err_mem_free:
 	et131x_adapter_memory_free(adapter);
 err_iounmap:
@@ -704,20 +819,18 @@ err_out:
  */
 static void __devexit et131x_pci_remove(struct pci_dev *pdev)
 {
-	struct net_device *netdev;
-	struct et131x_adapter *adapter;
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct et131x_adapter *adapter = netdev_priv(netdev);
 
-	/* Retrieve the net_device pointer from the pci_dev struct, as well
-	 * as the private adapter struct
-	 */
-	netdev = pci_get_drvdata(pdev);
-	adapter = netdev_priv(netdev);
-
-	/* Perform device cleanup */
 	unregister_netdev(netdev);
+	mdiobus_unregister(adapter->mii_bus);
+	kfree(adapter->mii_bus->irq);
+	mdiobus_free(adapter->mii_bus);
+
 	et131x_adapter_memory_free(adapter);
 	iounmap(adapter->regs);
-	pci_dev_put(adapter->pdev);
+	pci_dev_put(pdev);
+
 	free_netdev(netdev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 20df145..ce21433 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -1,6 +1,6 @@
 /*
  * Agere Systems Inc.
- * 10/100/1000 Base-T Ethernet Driver for the ET1301 and ET131x series MACs
+ * 10/100/1000 Base-T Ethernet Driver for the ET1310 and ET131x series MACs
  *
  * Copyright © 2005 Agere Systems Inc.
  * All rights reserved.
@@ -82,6 +82,7 @@
 #include <linux/skbuff.h>
 #include <linux/if_arp.h>
 #include <linux/ioport.h>
+#include <linux/phy.h>
 
 #include "et1310_phy.h"
 #include "et1310_tx.h"
@@ -167,6 +168,8 @@ int et131x_open(struct net_device *netdev)
 
 	adapter->flags |= fMP_ADAPTER_INTERRUPT_IN_USE;
 
+	phy_start(adapter->phydev);
+
 	/* We're ready to move some data, so start the queue */
 	netif_start_queue(netdev);
 	return result;
@@ -699,8 +702,6 @@ struct net_device *et131x_device_alloc(void)
 	netdev->watchdog_timeo = ET131X_TX_TIMEOUT;
 	netdev->netdev_ops     = &et131x_netdev_ops;
 
-	/* netdev->ethtool_ops        = &et131x_ethtool_ops; */
-
 	/* Poll? */
 	/* netdev->poll               = &et131x_poll; */
 	/* netdev->poll_controller    = &et131x_poll_controller; */
-- 
1.7.6

