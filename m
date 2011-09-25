Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab1IYSTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 14:19:18 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58452 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1IYSTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 14:19:17 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@linux.intel.com,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/6] staging: et131x: support register dump in ethtool ops
Date: Sun, 25 Sep 2011 19:17:52 +0100
Message-Id: <1316974677-17108-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not an exhaustive dump of the et131x registers, used while debugging a specific problem - seems a shame not to keep it around.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x_ethtool.c |  138 ++++++++++++++++++++++++++++++-
 1 files changed, 135 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/et131x/et131x_ethtool.c b/drivers/staging/et131x/et131x_ethtool.c
index b92633f..c4555b9 100644
--- a/drivers/staging/et131x/et131x_ethtool.c
+++ b/drivers/staging/et131x/et131x_ethtool.c
@@ -28,6 +28,7 @@
 #include <linux/pci.h>
 
 #include "et131x_adapter.h"
+#include "et1310_phy.h"
 #include "et131x.h"
 
 static int et131x_get_settings(struct net_device *netdev,
@@ -46,6 +47,135 @@ static int et131x_set_settings(struct net_device *netdev,
 	return phy_ethtool_sset(adapter->phydev, cmd);
 }
 
+static int et131x_get_regs_len(struct net_device *netdev)
+{
+#define ET131X_REGS_LEN 256
+	return ET131X_REGS_LEN * sizeof(u32);
+}
+
+static void et131x_get_regs(struct net_device *netdev,
+			    struct ethtool_regs *regs, void *regs_data)
+{
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+	struct address_map __iomem *aregs = adapter->regs;
+	u32 *regs_buff = regs_data;
+	u32 num = 0;
+
+	memset(regs_data, 0, et131x_get_regs_len(netdev));
+
+	regs->version = (1 << 24) | (adapter->pdev->revision << 16) |
+			adapter->pdev->device;
+
+	/* PHY regs */
+	et131x_mii_read(adapter, MII_BMCR, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, MII_BMSR, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, MII_PHYSID1, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, MII_PHYSID2, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, MII_ADVERTISE, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, MII_LPA, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, MII_EXPANSION, (u16 *)&regs_buff[num++]);
+	/* Autoneg next page transmit reg */
+	et131x_mii_read(adapter, 0x07, (u16 *)&regs_buff[num++]);
+	/* Link partner next page reg */
+	et131x_mii_read(adapter, 0x08, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, MII_CTRL1000, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, MII_STAT1000, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, MII_ESTATUS, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, PHY_INDEX_REG, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, PHY_DATA_REG, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG,
+			(u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, PHY_LOOPBACK_CONTROL,
+			(u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, PHY_LOOPBACK_CONTROL+1,
+			(u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, PHY_REGISTER_MGMT_CONTROL,
+			(u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, PHY_CONFIG, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, PHY_PHY_CONTROL, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, PHY_INTERRUPT_MASK, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, PHY_INTERRUPT_STATUS,
+			(u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, PHY_PHY_STATUS, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, PHY_LED_1, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, PHY_LED_2, (u16 *)&regs_buff[num++]);
+
+	/* Global regs */
+	regs_buff[num++] = readl(&aregs->global.txq_start_addr);
+	regs_buff[num++] = readl(&aregs->global.txq_end_addr);
+	regs_buff[num++] = readl(&aregs->global.rxq_start_addr);
+	regs_buff[num++] = readl(&aregs->global.rxq_end_addr);
+	regs_buff[num++] = readl(&aregs->global.pm_csr);
+	regs_buff[num++] = adapter->stats.interrupt_status;
+	regs_buff[num++] = readl(&aregs->global.int_mask);
+	regs_buff[num++] = readl(&aregs->global.int_alias_clr_en);
+	regs_buff[num++] = readl(&aregs->global.int_status_alias);
+	regs_buff[num++] = readl(&aregs->global.sw_reset);
+	regs_buff[num++] = readl(&aregs->global.slv_timer);
+	regs_buff[num++] = readl(&aregs->global.msi_config);
+	regs_buff[num++] = readl(&aregs->global.loopback);
+	regs_buff[num++] = readl(&aregs->global.watchdog_timer);
+
+	/* TXDMA regs */
+	regs_buff[num++] = readl(&aregs->txdma.csr);
+	regs_buff[num++] = readl(&aregs->txdma.pr_base_hi);
+	regs_buff[num++] = readl(&aregs->txdma.pr_base_lo);
+	regs_buff[num++] = readl(&aregs->txdma.pr_num_des);
+	regs_buff[num++] = readl(&aregs->txdma.txq_wr_addr);
+	regs_buff[num++] = readl(&aregs->txdma.txq_wr_addr_ext);
+	regs_buff[num++] = readl(&aregs->txdma.txq_rd_addr);
+	regs_buff[num++] = readl(&aregs->txdma.dma_wb_base_hi);
+	regs_buff[num++] = readl(&aregs->txdma.dma_wb_base_lo);
+	regs_buff[num++] = readl(&aregs->txdma.service_request);
+	regs_buff[num++] = readl(&aregs->txdma.service_complete);
+	regs_buff[num++] = readl(&aregs->txdma.cache_rd_index);
+	regs_buff[num++] = readl(&aregs->txdma.cache_wr_index);
+	regs_buff[num++] = readl(&aregs->txdma.tx_dma_error);
+	regs_buff[num++] = readl(&aregs->txdma.desc_abort_cnt);
+	regs_buff[num++] = readl(&aregs->txdma.payload_abort_cnt);
+	regs_buff[num++] = readl(&aregs->txdma.writeback_abort_cnt);
+	regs_buff[num++] = readl(&aregs->txdma.desc_timeout_cnt);
+	regs_buff[num++] = readl(&aregs->txdma.payload_timeout_cnt);
+	regs_buff[num++] = readl(&aregs->txdma.writeback_timeout_cnt);
+	regs_buff[num++] = readl(&aregs->txdma.desc_error_cnt);
+	regs_buff[num++] = readl(&aregs->txdma.payload_error_cnt);
+	regs_buff[num++] = readl(&aregs->txdma.writeback_error_cnt);
+	regs_buff[num++] = readl(&aregs->txdma.dropped_tlp_cnt);
+	regs_buff[num++] = readl(&aregs->txdma.new_service_complete);
+	regs_buff[num++] = readl(&aregs->txdma.ethernet_packet_cnt);
+
+	/* RXDMA regs */
+	regs_buff[num++] = readl(&aregs->rxdma.csr);
+	regs_buff[num++] = readl(&aregs->rxdma.dma_wb_base_hi);
+	regs_buff[num++] = readl(&aregs->rxdma.dma_wb_base_lo);
+	regs_buff[num++] = readl(&aregs->rxdma.num_pkt_done);
+	regs_buff[num++] = readl(&aregs->rxdma.max_pkt_time);
+	regs_buff[num++] = readl(&aregs->rxdma.rxq_rd_addr);
+	regs_buff[num++] = readl(&aregs->rxdma.rxq_rd_addr_ext);
+	regs_buff[num++] = readl(&aregs->rxdma.rxq_wr_addr);
+	regs_buff[num++] = readl(&aregs->rxdma.psr_base_hi);
+	regs_buff[num++] = readl(&aregs->rxdma.psr_base_lo);
+	regs_buff[num++] = readl(&aregs->rxdma.psr_num_des);
+	regs_buff[num++] = readl(&aregs->rxdma.psr_avail_offset);
+	regs_buff[num++] = readl(&aregs->rxdma.psr_full_offset);
+	regs_buff[num++] = readl(&aregs->rxdma.psr_access_index);
+	regs_buff[num++] = readl(&aregs->rxdma.psr_min_des);
+	regs_buff[num++] = readl(&aregs->rxdma.fbr0_base_lo);
+	regs_buff[num++] = readl(&aregs->rxdma.fbr0_base_hi);
+	regs_buff[num++] = readl(&aregs->rxdma.fbr0_num_des);
+	regs_buff[num++] = readl(&aregs->rxdma.fbr0_avail_offset);
+	regs_buff[num++] = readl(&aregs->rxdma.fbr0_full_offset);
+	regs_buff[num++] = readl(&aregs->rxdma.fbr0_rd_index);
+	regs_buff[num++] = readl(&aregs->rxdma.fbr0_min_des);
+	regs_buff[num++] = readl(&aregs->rxdma.fbr1_base_lo);
+	regs_buff[num++] = readl(&aregs->rxdma.fbr1_base_hi);
+	regs_buff[num++] = readl(&aregs->rxdma.fbr1_num_des);
+	regs_buff[num++] = readl(&aregs->rxdma.fbr1_avail_offset);
+	regs_buff[num++] = readl(&aregs->rxdma.fbr1_full_offset);
+	regs_buff[num++] = readl(&aregs->rxdma.fbr1_rd_index);
+	regs_buff[num++] = readl(&aregs->rxdma.fbr1_min_des);
+}
+
 #define ET131X_DRVINFO_LEN 32 /* value from ethtool.h */
 static void et131x_get_drvinfo(struct net_device *netdev,
 			       struct ethtool_drvinfo *info)
@@ -58,9 +188,11 @@ static void et131x_get_drvinfo(struct net_device *netdev,
 }
 
 static struct ethtool_ops et131x_ethtool_ops = {
-	.get_settings = et131x_get_settings,
-	.set_settings = et131x_set_settings,
-	.get_drvinfo = et131x_get_drvinfo,
+	.get_settings	= et131x_get_settings,
+	.set_settings	= et131x_set_settings,
+	.get_drvinfo	= et131x_get_drvinfo,
+	.get_regs_len	= et131x_get_regs_len,
+	.get_regs	= et131x_get_regs,
 	.get_link = ethtool_op_get_link,
 };
 
-- 
1.7.6

