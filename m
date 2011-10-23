Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab1JWJZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 05:25:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33009 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab1JWJYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 05:24:33 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 09/12] staging: et131x: Remove even more forward declarations
Date: Sun, 23 Oct 2011 10:22:51 +0100
Message-Id: <1319361774-3148-10-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved functions in et131x.c file to remove the forward declarations of:

et1310_in_phy_coma
et1310_phy_access_mii_bit
et131x_phy_mii_read
et131x_mii_write
et131x_rx_dma_memory_free

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |  395 +++++++++++++++++++--------------------
 1 files changed, 193 insertions(+), 202 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 208c69f..2e621aa 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -576,15 +576,6 @@ struct et131x_adapter {
 	struct net_device_stats net_stats;
 };
 
-int et1310_in_phy_coma(struct et131x_adapter *adapter);
-void et1310_phy_access_mii_bit(struct et131x_adapter *adapter,
-			       u16 action,
-			       u16 regnum, u16 bitnum, u8 *value);
-int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 addr,
-	      u8 reg, u16 *value);
-int32_t et131x_mii_write(struct et131x_adapter *adapter,
-		u8 reg, u16 value);
-void et131x_rx_dma_memory_free(struct et131x_adapter *adapter);
 void et131x_rx_dma_disable(struct et131x_adapter *adapter);
 void et131x_rx_dma_enable(struct et131x_adapter *adapter);
 void et131x_init_send(struct et131x_adapter *adapter);
@@ -1019,6 +1010,21 @@ void et1310_config_mac_regs2(struct et131x_adapter *adapter)
 	}
 }
 
+/**
+ * et1310_in_phy_coma - check if the device is in phy coma
+ * @adapter: pointer to our adapter structure
+ *
+ * Returns 0 if the device is not in phy coma, 1 if it is in phy coma
+ */
+int et1310_in_phy_coma(struct et131x_adapter *adapter)
+{
+	u32 pmcsr;
+
+	pmcsr = readl(&adapter->regs->global.pm_csr);
+
+	return ET_PM_PHY_SW_COMA & pmcsr ? 1 : 0;
+}
+
 void et1310_setup_device_for_multicast(struct et131x_adapter *adapter)
 {
 	struct rxmac_regs __iomem *rxmac = &adapter->regs->rxmac;
@@ -1318,6 +1324,184 @@ void et1310_config_macstat_regs(struct et131x_adapter *adapter)
 	writel(0xFFFE7E8B, &macstat->carry_reg2_mask);
 }
 
+/**
+ * et131x_phy_mii_read - Read from the PHY through the MII Interface on the MAC
+ * @adapter: pointer to our private adapter structure
+ * @addr: the address of the transceiver
+ * @reg: the register to read
+ * @value: pointer to a 16-bit value in which the value will be stored
+ *
+ * Returns 0 on success, errno on failure (as defined in errno.h)
+ */
+int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 addr,
+	      u8 reg, u16 *value)
+{
+	struct mac_regs __iomem *mac = &adapter->regs->mac;
+	int status = 0;
+	u32 delay = 0;
+	u32 mii_addr;
+	u32 mii_cmd;
+	u32 mii_indicator;
+
+	/* Save a local copy of the registers we are dealing with so we can
+	 * set them back
+	 */
+	mii_addr = readl(&mac->mii_mgmt_addr);
+	mii_cmd = readl(&mac->mii_mgmt_cmd);
+
+	/* Stop the current operation */
+	writel(0, &mac->mii_mgmt_cmd);
+
+	/* Set up the register we need to read from on the correct PHY */
+	writel(MII_ADDR(addr, reg), &mac->mii_mgmt_addr);
+
+	writel(0x1, &mac->mii_mgmt_cmd);
+
+	do {
+		udelay(50);
+		delay++;
+		mii_indicator = readl(&mac->mii_mgmt_indicator);
+	} while ((mii_indicator & MGMT_WAIT) && delay < 50);
+
+	/* If we hit the max delay, we could not read the register */
+	if (delay == 50) {
+		dev_warn(&adapter->pdev->dev,
+			    "reg 0x%08x could not be read\n", reg);
+		dev_warn(&adapter->pdev->dev, "status is  0x%08x\n",
+			    mii_indicator);
+
+		status = -EIO;
+	}
+
+	/* If we hit here we were able to read the register and we need to
+	 * return the value to the caller */
+	*value = readl(&mac->mii_mgmt_stat) & 0xFFFF;
+
+	/* Stop the read operation */
+	writel(0, &mac->mii_mgmt_cmd);
+
+	/* set the registers we touched back to the state at which we entered
+	 * this function
+	 */
+	writel(mii_addr, &mac->mii_mgmt_addr);
+	writel(mii_cmd, &mac->mii_mgmt_cmd);
+
+	return status;
+}
+
+int et131x_mii_read(struct et131x_adapter *adapter, u8 reg, u16 *value)
+{
+	struct phy_device *phydev = adapter->phydev;
+
+	if (!phydev)
+		return -EIO;
+
+	return et131x_phy_mii_read(adapter, phydev->addr, reg, value);
+}
+
+/**
+ * et131x_mii_write - Write to a PHY register through the MII interface of the MAC
+ * @adapter: pointer to our private adapter structure
+ * @reg: the register to read
+ * @value: 16-bit value to write
+ *
+ * FIXME: one caller in netdev still
+ *
+ * Return 0 on success, errno on failure (as defined in errno.h)
+ */
+int et131x_mii_write(struct et131x_adapter *adapter, u8 reg, u16 value)
+{
+	struct mac_regs __iomem *mac = &adapter->regs->mac;
+	struct phy_device *phydev = adapter->phydev;
+	int status = 0;
+	u8 addr;
+	u32 delay = 0;
+	u32 mii_addr;
+	u32 mii_cmd;
+	u32 mii_indicator;
+
+	if (!phydev)
+		return -EIO;
+
+	addr = phydev->addr;
+
+	/* Save a local copy of the registers we are dealing with so we can
+	 * set them back
+	 */
+	mii_addr = readl(&mac->mii_mgmt_addr);
+	mii_cmd = readl(&mac->mii_mgmt_cmd);
+
+	/* Stop the current operation */
+	writel(0, &mac->mii_mgmt_cmd);
+
+	/* Set up the register we need to write to on the correct PHY */
+	writel(MII_ADDR(addr, reg), &mac->mii_mgmt_addr);
+
+	/* Add the value to write to the registers to the mac */
+	writel(value, &mac->mii_mgmt_ctrl);
+
+	do {
+		udelay(50);
+		delay++;
+		mii_indicator = readl(&mac->mii_mgmt_indicator);
+	} while ((mii_indicator & MGMT_BUSY) && delay < 100);
+
+	/* If we hit the max delay, we could not write the register */
+	if (delay == 100) {
+		u16 tmp;
+
+		dev_warn(&adapter->pdev->dev,
+		    "reg 0x%08x could not be written", reg);
+		dev_warn(&adapter->pdev->dev, "status is  0x%08x\n",
+			    mii_indicator);
+		dev_warn(&adapter->pdev->dev, "command is  0x%08x\n",
+			    readl(&mac->mii_mgmt_cmd));
+
+		et131x_mii_read(adapter, reg, &tmp);
+
+		status = -EIO;
+	}
+	/* Stop the write operation */
+	writel(0, &mac->mii_mgmt_cmd);
+
+	/*
+	 * set the registers we touched back to the state at which we entered
+	 * this function
+	 */
+	writel(mii_addr, &mac->mii_mgmt_addr);
+	writel(mii_cmd, &mac->mii_mgmt_cmd);
+
+	return status;
+}
+
+/* Still used from _mac for BIT_READ */
+void et1310_phy_access_mii_bit(struct et131x_adapter *adapter, u16 action,
+			       u16 regnum, u16 bitnum, u8 *value)
+{
+	u16 reg;
+	u16 mask = 0x0001 << bitnum;
+
+	/* Read the requested register */
+	et131x_mii_read(adapter, regnum, &reg);
+
+	switch (action) {
+	case TRUEPHY_BIT_READ:
+		*value = (reg & mask) >> bitnum;
+		break;
+
+	case TRUEPHY_BIT_SET:
+		et131x_mii_write(adapter, regnum, reg | mask);
+		break;
+
+	case TRUEPHY_BIT_CLEAR:
+		et131x_mii_write(adapter, regnum, reg & ~mask);
+		break;
+
+	default:
+		break;
+	}
+}
+
 void et1310_config_flow_control(struct et131x_adapter *adapter)
 {
 	struct phy_device *phydev = adapter->phydev;
@@ -1476,156 +1660,6 @@ int et131x_mdio_reset(struct mii_bus *bus)
 	return 0;
 }
 
-int et131x_mii_read(struct et131x_adapter *adapter, u8 reg, u16 *value)
-{
-	struct phy_device *phydev = adapter->phydev;
-
-	if (!phydev)
-		return -EIO;
-
-	return et131x_phy_mii_read(adapter, phydev->addr, reg, value);
-}
-
-/**
- * et131x_phy_mii_read - Read from the PHY through the MII Interface on the MAC
- * @adapter: pointer to our private adapter structure
- * @addr: the address of the transceiver
- * @reg: the register to read
- * @value: pointer to a 16-bit value in which the value will be stored
- *
- * Returns 0 on success, errno on failure (as defined in errno.h)
- */
-int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 addr,
-	      u8 reg, u16 *value)
-{
-	struct mac_regs __iomem *mac = &adapter->regs->mac;
-	int status = 0;
-	u32 delay = 0;
-	u32 mii_addr;
-	u32 mii_cmd;
-	u32 mii_indicator;
-
-	/* Save a local copy of the registers we are dealing with so we can
-	 * set them back
-	 */
-	mii_addr = readl(&mac->mii_mgmt_addr);
-	mii_cmd = readl(&mac->mii_mgmt_cmd);
-
-	/* Stop the current operation */
-	writel(0, &mac->mii_mgmt_cmd);
-
-	/* Set up the register we need to read from on the correct PHY */
-	writel(MII_ADDR(addr, reg), &mac->mii_mgmt_addr);
-
-	writel(0x1, &mac->mii_mgmt_cmd);
-
-	do {
-		udelay(50);
-		delay++;
-		mii_indicator = readl(&mac->mii_mgmt_indicator);
-	} while ((mii_indicator & MGMT_WAIT) && delay < 50);
-
-	/* If we hit the max delay, we could not read the register */
-	if (delay == 50) {
-		dev_warn(&adapter->pdev->dev,
-			    "reg 0x%08x could not be read\n", reg);
-		dev_warn(&adapter->pdev->dev, "status is  0x%08x\n",
-			    mii_indicator);
-
-		status = -EIO;
-	}
-
-	/* If we hit here we were able to read the register and we need to
-	 * return the value to the caller */
-	*value = readl(&mac->mii_mgmt_stat) & 0xFFFF;
-
-	/* Stop the read operation */
-	writel(0, &mac->mii_mgmt_cmd);
-
-	/* set the registers we touched back to the state at which we entered
-	 * this function
-	 */
-	writel(mii_addr, &mac->mii_mgmt_addr);
-	writel(mii_cmd, &mac->mii_mgmt_cmd);
-
-	return status;
-}
-
-/**
- * et131x_mii_write - Write to a PHY register through the MII interface of the MAC
- * @adapter: pointer to our private adapter structure
- * @reg: the register to read
- * @value: 16-bit value to write
- *
- * FIXME: one caller in netdev still
- *
- * Return 0 on success, errno on failure (as defined in errno.h)
- */
-int et131x_mii_write(struct et131x_adapter *adapter, u8 reg, u16 value)
-{
-	struct mac_regs __iomem *mac = &adapter->regs->mac;
-	struct phy_device *phydev = adapter->phydev;
-	int status = 0;
-	u8 addr;
-	u32 delay = 0;
-	u32 mii_addr;
-	u32 mii_cmd;
-	u32 mii_indicator;
-
-	if (!phydev)
-		return -EIO;
-
-	addr = phydev->addr;
-
-	/* Save a local copy of the registers we are dealing with so we can
-	 * set them back
-	 */
-	mii_addr = readl(&mac->mii_mgmt_addr);
-	mii_cmd = readl(&mac->mii_mgmt_cmd);
-
-	/* Stop the current operation */
-	writel(0, &mac->mii_mgmt_cmd);
-
-	/* Set up the register we need to write to on the correct PHY */
-	writel(MII_ADDR(addr, reg), &mac->mii_mgmt_addr);
-
-	/* Add the value to write to the registers to the mac */
-	writel(value, &mac->mii_mgmt_ctrl);
-
-	do {
-		udelay(50);
-		delay++;
-		mii_indicator = readl(&mac->mii_mgmt_indicator);
-	} while ((mii_indicator & MGMT_BUSY) && delay < 100);
-
-	/* If we hit the max delay, we could not write the register */
-	if (delay == 100) {
-		u16 tmp;
-
-		dev_warn(&adapter->pdev->dev,
-		    "reg 0x%08x could not be written", reg);
-		dev_warn(&adapter->pdev->dev, "status is  0x%08x\n",
-			    mii_indicator);
-		dev_warn(&adapter->pdev->dev, "command is  0x%08x\n",
-			    readl(&mac->mii_mgmt_cmd));
-
-		et131x_mii_read(adapter, reg, &tmp);
-
-		status = -EIO;
-	}
-	/* Stop the write operation */
-	writel(0, &mac->mii_mgmt_cmd);
-
-	/*
-	 * set the registers we touched back to the state at which we entered
-	 * this function
-	 */
-	writel(mii_addr, &mac->mii_mgmt_addr);
-	writel(mii_cmd, &mac->mii_mgmt_cmd);
-
-	return status;
-}
-
 /**
  *	et1310_phy_power_down	-	PHY power control
  *	@adapter: device to control
@@ -1647,34 +1681,6 @@ void et1310_phy_power_down(struct et131x_adapter *adapter, bool down)
 	et131x_mii_write(adapter, MII_BMCR, data);
 }
 
-/* Still used from _mac for BIT_READ */
-void et1310_phy_access_mii_bit(struct et131x_adapter *adapter, u16 action,
-			       u16 regnum, u16 bitnum, u8 *value)
-{
-	u16 reg;
-	u16 mask = 0x0001 << bitnum;
-
-	/* Read the requested register */
-	et131x_mii_read(adapter, regnum, &reg);
-
-	switch (action) {
-	case TRUEPHY_BIT_READ:
-		*value = (reg & mask) >> bitnum;
-		break;
-
-	case TRUEPHY_BIT_SET:
-		et131x_mii_write(adapter, regnum, reg | mask);
-		break;
-
-	case TRUEPHY_BIT_CLEAR:
-		et131x_mii_write(adapter, regnum, reg & ~mask);
-		break;
-
-	default:
-		break;
-	}
-}
-
 /**
  * et131x_xcvr_init - Init the phy if we are setting it into force mode
  * @adapter: pointer to our private adapter structure
@@ -1771,21 +1777,6 @@ void et131x_configure_global_regs(struct et131x_adapter *adapter)
 /* PM functions */
 
 /**
- * et1310_in_phy_coma - check if the device is in phy coma
- * @adapter: pointer to our adapter structure
- *
- * Returns 0 if the device is not in phy coma, 1 if it is in phy coma
- */
-int et1310_in_phy_coma(struct et131x_adapter *adapter)
-{
-	u32 pmcsr;
-
-	pmcsr = readl(&adapter->regs->global.pm_csr);
-
-	return ET_PM_PHY_SW_COMA & pmcsr ? 1 : 0;
-}
-
-/**
  * et131x_config_rx_dma_regs - Start of Rx_DMA init sequence
  * @adapter: pointer to our adapter structure
  */
-- 
1.7.6.4

