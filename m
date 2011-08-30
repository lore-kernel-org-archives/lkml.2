Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab1H3Lso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:48:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53808 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab1H3Lsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:48:42 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/3] staging: et131x: Remove xcvr_addr and et131x_xcvr_find
Date: Tue, 30 Aug 2011 12:47:23 +0100
Message-Id: <1314704844-5643-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314704844-5643-1-git-send-email-mark.einon@gmail.com>
References: <1314704844-5643-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the phy_device equivalents instead.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.c     |   72 ++++++++++++------------------
 drivers/staging/et131x/et131x.h         |   17 +++----
 drivers/staging/et131x/et131x_adapter.h |    3 -
 drivers/staging/et131x/et131x_initpci.c |   15 +------
 4 files changed, 38 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 5e21a18..9613846 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -114,7 +114,6 @@ int et131x_mdio_write(struct mii_bus *bus, int phy_addr, int reg, u16 value)
 	struct net_device *netdev = bus->priv;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
-	/* mii_write always uses the same phy_addr, xcvr_addr */
 	return et131x_mii_write(adapter, reg, value);
 }
 
@@ -128,17 +127,28 @@ int et131x_mdio_reset(struct mii_bus *bus)
 	return 0;
 }
 
+
+int et131x_mii_read(struct et131x_adapter *adapter, u8 reg, u16 *value)
+{
+	struct phy_device *phydev = adapter->phydev;
+
+	if(!phydev)
+		return -EIO;
+
+	return et131x_phy_mii_read(adapter, phydev->addr, reg, value);
+}
+
 /**
  * et131x_phy_mii_read - Read from the PHY through the MII Interface on the MAC
  * @adapter: pointer to our private adapter structure
- * @xcvr_addr: the address of the transceiver
- * @xcvr_reg: the register to read
+ * @addr: the address of the transceiver
+ * @reg: the register to read
  * @value: pointer to a 16-bit value in which the value will be stored
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
  */
-int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 xcvr_addr,
-	      u8 xcvr_reg, u16 *value)
+int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 addr,
+	      u8 reg, u16 *value)
 {
 	struct mac_regs __iomem *mac = &adapter->regs->mac;
 	int status = 0;
@@ -157,7 +167,7 @@ int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 xcvr_addr,
 	writel(0, &mac->mii_mgmt_cmd);
 
 	/* Set up the register we need to read from on the correct PHY */
-	writel(MII_ADDR(xcvr_addr, xcvr_reg), &mac->mii_mgmt_addr);
+	writel(MII_ADDR(addr, reg), &mac->mii_mgmt_addr);
 
 	writel(0x1, &mac->mii_mgmt_cmd);
 
@@ -170,7 +180,7 @@ int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 xcvr_addr,
 	/* If we hit the max delay, we could not read the register */
 	if (delay == 50) {
 		dev_warn(&adapter->pdev->dev,
-			    "xcvrReg 0x%08x could not be read\n", xcvr_reg);
+			    "reg 0x%08x could not be read\n", reg);
 		dev_warn(&adapter->pdev->dev, "status is  0x%08x\n",
 			    mii_indicator);
 
@@ -196,23 +206,29 @@ int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 xcvr_addr,
 /**
  * et131x_mii_write - Write to a PHY register through the MII interface of the MAC
  * @adapter: pointer to our private adapter structure
- * @xcvr_reg: the register to read
+ * @reg: the register to read
  * @value: 16-bit value to write
  *
  * FIXME: one caller in netdev still
  *
  * Return 0 on success, errno on failure (as defined in errno.h)
  */
-int et131x_mii_write(struct et131x_adapter *adapter, u8 xcvr_reg, u16 value)
+int et131x_mii_write(struct et131x_adapter *adapter, u8 reg, u16 value)
 {
 	struct mac_regs __iomem *mac = &adapter->regs->mac;
+	struct phy_device *phydev = adapter->phydev;
 	int status = 0;
-	u8 xcvr_addr = adapter->stats.xcvr_addr;
+	u8 addr;
 	u32 delay = 0;
 	u32 mii_addr;
 	u32 mii_cmd;
 	u32 mii_indicator;
 
+	if(!phydev)
+		return -EIO;
+
+	addr = phydev->addr;
+
 	/* Save a local copy of the registers we are dealing with so we can
 	 * set them back
 	 */
@@ -223,7 +239,7 @@ int et131x_mii_write(struct et131x_adapter *adapter, u8 xcvr_reg, u16 value)
 	writel(0, &mac->mii_mgmt_cmd);
 
 	/* Set up the register we need to write to on the correct PHY */
-	writel(MII_ADDR(xcvr_addr, xcvr_reg), &mac->mii_mgmt_addr);
+	writel(MII_ADDR(addr, reg), &mac->mii_mgmt_addr);
 
 	/* Add the value to write to the registers to the mac */
 	writel(value, &mac->mii_mgmt_ctrl);
@@ -239,13 +255,13 @@ int et131x_mii_write(struct et131x_adapter *adapter, u8 xcvr_reg, u16 value)
 		u16 tmp;
 
 		dev_warn(&adapter->pdev->dev,
-		    "xcvrReg 0x%08x could not be written", xcvr_reg);
+		    "reg 0x%08x could not be written", reg);
 		dev_warn(&adapter->pdev->dev, "status is  0x%08x\n",
 			    mii_indicator);
 		dev_warn(&adapter->pdev->dev, "command is  0x%08x\n",
 			    readl(&mac->mii_mgmt_cmd));
 
-		et131x_mii_read(adapter, xcvr_reg, &tmp);
+		et131x_mii_read(adapter, reg, &tmp);
 
 		status = -EIO;
 	}
@@ -262,36 +278,6 @@ int et131x_mii_write(struct et131x_adapter *adapter, u8 xcvr_reg, u16 value)
 	return status;
 }
 
-/**
- * et131x_xcvr_find - Find the PHY ID
- * @adapter: pointer to our private adapter structure
- *
- * Returns 0 on success, errno on failure (as defined in errno.h)
- */
-int et131x_xcvr_find(struct et131x_adapter *adapter)
-{
-	u8 xcvr_addr;
-	u16 idr1;
-	u16 idr2;
-
-	/* We need to get xcvr id and address we just get the first one */
-	for (xcvr_addr = 0; xcvr_addr < 32; xcvr_addr++) {
-		/* Read the ID from the PHY */
-		et131x_phy_mii_read(adapter, xcvr_addr,
-			     (u8) offsetof(struct mi_regs, idr1),
-			     &idr1);
-		et131x_phy_mii_read(adapter, xcvr_addr,
-			     (u8) offsetof(struct mi_regs, idr2),
-			     &idr2);
-
-		if (idr1 != 0 && idr1 != 0xffff) {
-			adapter->stats.xcvr_addr = xcvr_addr;
-			return 0;
-		}
-	}
-	return -ENODEV;
-}
-
 void et1310_phy_reset(struct et131x_adapter *adapter)
 {
 	et131x_mii_write(adapter, PHY_CONTROL, 0x8000);
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index 9dee7bc..763396a 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -59,7 +59,7 @@ void et131x_align_allocated_memory(struct et131x_adapter *adapter,
 				   u64 *phys_addr,
 				   u64 *offset, u64 mask);
 
-int et131x_adapter_setup(struct et131x_adapter *adapter);
+void et131x_adapter_setup(struct et131x_adapter *adapter);
 int et131x_adapter_memory_alloc(struct et131x_adapter *adapter);
 void et131x_adapter_memory_free(struct et131x_adapter *adapter);
 void et131x_hwaddr_init(struct et131x_adapter *adapter);
@@ -104,16 +104,13 @@ void et131x_setphy_normal(struct et131x_adapter *adapter);
 /* static inline function does not work because et131x_adapter is not always
  * defined
  */
-int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 xcvrAddr,
-	      u8 xcvrReg, u16 *value);
-#define et131x_mii_read(adapter, xcvrReg, value) \
-	et131x_phy_mii_read((adapter), \
-			    (adapter)->stats.xcvr_addr, \
-			    (xcvrReg), (value))
-
+int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 addr,
+	      u8 reg, u16 *value);
+int32_t et131x_mii_read(struct et131x_adapter *adapter,
+		u8 reg, u16 *value);
 int32_t et131x_mii_write(struct et131x_adapter *adapter,
-		u8 xcvReg, u16 value);
-void et131x_mii_check(struct et131x_adapter *pAdapter,
+		u8 reg, u16 value);
+void et131x_mii_check(struct et131x_adapter *adapter,
 		      u16 bmsr, u16 bmsr_ints);
 
 int et131x_mdio_read(struct mii_bus *bus, int phy_addr, int reg);
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index dbb14fe..fbefd2e 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -113,9 +113,6 @@ struct ce_stats {
 	atomic_t	broadcast_pkts_xmtd;
 	u32		rcvd_pkts_dropped;
 
-	/* Transceiver state informations. */
-	u8		xcvr_addr;
-
 	/* Tx Statistics. */
 	u32		tx_underflows;
 
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index fbbef76..66cf1ce 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -328,10 +328,8 @@ void et131x_configure_global_regs(struct et131x_adapter *adapter)
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
  */
-int et131x_adapter_setup(struct et131x_adapter *adapter)
+void et131x_adapter_setup(struct et131x_adapter *adapter)
 {
-	int status;
-
 	/* Configure the JAGCore */
 	et131x_configure_global_regs(adapter);
 
@@ -349,12 +347,6 @@ int et131x_adapter_setup(struct et131x_adapter *adapter)
 
 	et1310_config_macstat_regs(adapter);
 
-	/* Move the following code to Timer function?? */
-	status = et131x_xcvr_find(adapter);
-
-	if (status)
-		dev_warn(&adapter->pdev->dev, "Could not find the xcvr\n");
-
 	/* Prepare the TRUEPHY library. */
 	et1310_phy_init(adapter);
 
@@ -377,7 +369,6 @@ int et131x_adapter_setup(struct et131x_adapter *adapter)
 	et1310_phy_power_down(adapter, 0);
 
 	et131x_setphy_normal(adapter);
-	return status;
 }
 
 /**
@@ -493,9 +484,7 @@ static void et131x_adjust_link(struct net_device *netdev)
 		et1310_disable_phy_coma(adapter);
 	}
 
-	et131x_mii_read(adapter,
-	       (uint8_t) offsetof(struct mi_regs, bmsr),
-	       &bmsr_data);
+	et131x_phy_mii_read(adapter, phydev->addr, MII_BMSR, &bmsr_data);
 
 	bmsr_ints = adapter->bmsr ^ bmsr_data;
 	adapter->bmsr = bmsr_data;
-- 
1.7.6

