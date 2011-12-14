Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab1LNTbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:31:47 -0500
Received: from eng.riverbed.com ([208.70.196.45]:50920 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab1LNTbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:31:45 -0500
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Dec 2011 14:31:45 EST
From: Jiang Wang <Jiang.Wang@riverbed.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: ppanchamukhi@riverbed.com, clala@riverbed.com,
        Francis.St.Amant@riverbed.com, miles.ito@intel.com,
        Jiang Wang <Jiang.Wang@riverbed.com>
Subject: [PATCH 1/2] e100: power down PHY if WOL is not enabled
Date: Tue, 13 Dec 2011 18:49:55 -0800
Message-Id: <1323830996-16388-1-git-send-email-Jiang.Wang@riverbed.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the interface will not be used after being put down and WOL is disabled,
just power it off.
When bring up the interface, power on the PHY.

Signed-off-by: Jiang Wang <Jiang.Wang@riverbed.com>
---
 drivers/net/ethernet/intel/e100.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 5a2fdf7..9824e0a 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -1449,6 +1449,14 @@ static int e100_phy_init(struct nic *nic)
 		netif_printk(nic, hw, KERN_DEBUG, nic->netdev,
 			     "phy_addr = %d\n", nic->mii.phy_id);
 
+	/* Make sure power to the PHY is enabled */
+	if (!(nic->flags & wol_magic)) {
+		uint16_t phy_data;
+		phy_data = mdio_read(nic->netdev, nic->mii.phy_id, MII_BMCR);
+		phy_data &= ~BMCR_PDOWN;
+		mdio_write(nic->netdev, nic->mii.phy_id, MII_BMCR, phy_data);
+	}
+
 	/* Get phy ID */
 	id_lo = mdio_read(netdev, nic->mii.phy_id, MII_PHYSID1);
 	id_hi = mdio_read(netdev, nic->mii.phy_id, MII_PHYSID2);
@@ -2261,6 +2269,15 @@ static void e100_down(struct nic *nic)
 	napi_disable(&nic->napi);
 	netif_stop_queue(nic->netdev);
 	e100_hw_reset(nic);
+
+	/* If wake on LAN is not enabled, power down the PHY */
+	if (!(nic->flags & wol_magic)) {
+		uint16_t phy_data;
+		phy_data = mdio_read(nic->netdev, nic->mii.phy_id, MII_BMCR);
+		phy_data |= BMCR_PDOWN;
+		mdio_write(nic->netdev, nic->mii.phy_id, MII_BMCR, phy_data);
+	}
+
 	free_irq(nic->pdev->irq, nic->netdev);
 	del_timer_sync(&nic->watchdog);
 	netif_carrier_off(nic->netdev);
-- 
1.7.1

