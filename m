Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab1JAKPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 06:15:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47522 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab1JAKPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 06:15:40 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@linux.intel.com,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/8] staging: et131x: Introduce et1310_in_phy_coma() call
Date: Sat,  1 Oct 2011 11:14:11 +0100
Message-Id: <1317464057-18231-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317464057-18231-1-git-send-email-mark.einon@gmail.com>
References: <1317464057-18231-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In several places in the code, the pm_csr register is read and the PHY_SW_COMA bit checked.

Move this check into its own small function to make the code more readable.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_mac.c     |    4 ++--
 drivers/staging/et131x/et1310_pm.c      |   15 +++++++++++++++
 drivers/staging/et131x/et131x.h         |    1 +
 drivers/staging/et131x/et131x_initpci.c |   28 +++++++++-------------------
 drivers/staging/et131x/et131x_isr.c     |    2 +-
 5 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index 08d7691..157462f 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -612,7 +612,7 @@ void et1310_setup_device_for_multicast(struct et131x_adapter *adapter)
 
 	/* Write out the new hash to the device */
 	pm_csr = readl(&adapter->regs->global.pm_csr);
-	if ((pm_csr & ET_PM_PHY_SW_COMA) == 0) {
+	if (!et1310_in_phy_coma(adapter)) {
 		writel(hash1, &rxmac->multi_hash1);
 		writel(hash2, &rxmac->multi_hash2);
 		writel(hash3, &rxmac->multi_hash3);
@@ -653,7 +653,7 @@ void et1310_setup_device_for_unicast(struct et131x_adapter *adapter)
 		   adapter->addr[5];
 
 	pm_csr = readl(&adapter->regs->global.pm_csr);
-	if ((pm_csr & ET_PM_PHY_SW_COMA) == 0) {
+	if (!et1310_in_phy_coma(adapter)) {
 		writel(uni_pf1, &rxmac->uni_pf_addr1);
 		writel(uni_pf2, &rxmac->uni_pf_addr2);
 		writel(uni_pf3, &rxmac->uni_pf_addr3);
diff --git a/drivers/staging/et131x/et1310_pm.c b/drivers/staging/et131x/et1310_pm.c
index b20d5d6..55f2d36 100644
--- a/drivers/staging/et131x/et1310_pm.c
+++ b/drivers/staging/et131x/et1310_pm.c
@@ -87,6 +87,21 @@
 #include "et131x.h"
 
 /**
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
+/**
  * et1310_enable_phy_coma - called when network cable is unplugged
  * @adapter: pointer to our adapter structure
  *
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index c047e6e..d967c5a1 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -87,6 +87,7 @@ void et131x_enable_txrx(struct net_device *netdev);
 void et131x_disable_txrx(struct net_device *netdev);
 
 /* et1310_pm.c */
+int et1310_in_phy_coma(struct et131x_adapter *adapter);
 void et1310_enable_phy_coma(struct et131x_adapter *adapter);
 void et1310_disable_phy_coma(struct et131x_adapter *adapter);
 
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index e9daa73..667ab80 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -239,15 +239,11 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 void et131x_error_timer_handler(unsigned long data)
 {
 	struct et131x_adapter *adapter = (struct et131x_adapter *) data;
-	u32 pm_csr;
 
-	pm_csr = readl(&adapter->regs->global.pm_csr);
-
-	if ((pm_csr & ET_PM_PHY_SW_COMA) == 0)
+	if (!et1310_in_phy_coma(adapter))
 		et1310_update_macstat_host_counters(adapter);
 	else
-		dev_err(&adapter->pdev->dev,
-		    "No interrupts, in PHY coma, pm_csr = 0x%x\n", pm_csr);
+		dev_err(&adapter->pdev->dev, "No interrupts, in PHY coma\n");
 
 	if (!(adapter->bmsr & BMSR_LSTATUS) &&
 	    adapter->boot_coma < 11) {
@@ -256,7 +252,7 @@ void et131x_error_timer_handler(unsigned long data)
 
 	if (adapter->boot_coma == 10) {
 		if (!(adapter->bmsr & BMSR_LSTATUS)) {
-			if ((pm_csr & ET_PM_PHY_SW_COMA) == 0) {
+			if (!et1310_in_phy_coma(adapter)) {
 				/* NOTE - This was originally a 'sync with
 				 *  interrupt'. How to do that under Linux?
 				 */
@@ -443,9 +439,6 @@ static void et131x_adjust_link(struct net_device *netdev)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 	struct  phy_device *phydev = adapter->phydev;
-	struct address_map __iomem *iomem = adapter->regs;
-
-	u32 pm_csr;
 
 	if (netif_carrier_ok(netdev)) {
 		adapter->boot_coma = 20;
@@ -488,16 +481,13 @@ static void et131x_adjust_link(struct net_device *netdev)
 	}
 
 	if (phydev->link != adapter->link) {
-		/* If we are in coma mode, we need to disable it. */
-		pm_csr = readl(&iomem->global.pm_csr);
-		if (pm_csr & ET_PM_PHY_SW_COMA) {
-			/*
-			 * Check to see if we are in coma mode and if
-			 * so, disable it because we will not be able
-			 * to read PHY values until we are out.
-			 */
+		/*
+		 * Check to see if we are in coma mode and if
+		 * so, disable it because we will not be able
+		 * to read PHY values until we are out.
+		 */
+		if (et1310_in_phy_coma(adapter))
 			et1310_disable_phy_coma(adapter);
-		}
 
 		if (phydev->link) {
 			adapter->boot_coma = 20;
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index 0747935..fb108d2 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -304,7 +304,7 @@ void et131x_isr_handler(struct work_struct *work)
 				 * bp xon/xoff)
 				 */
 				pm_csr = readl(&iomem->global.pm_csr);
-				if ((pm_csr & ET_PM_PHY_SW_COMA) == 0)
+				if (!et1310_in_phy_coma(adapter))
 					writel(3, &iomem->txmac.bp_ctrl);
 			}
 		}
-- 
1.7.6.4

