Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab1LNTbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:31:50 -0500
Received: from eng.riverbed.com ([208.70.196.45]:50920 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab1LNTbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:31:46 -0500
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
Subject: [PATCH 2/2] e100: power off PHY after reset when interface is down
Date: Tue, 13 Dec 2011 18:49:56 -0800
Message-Id: <1323830996-16388-2-git-send-email-Jiang.Wang@riverbed.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1323830996-16388-1-git-send-email-Jiang.Wang@riverbed.com>
References: <1323830996-16388-1-git-send-email-Jiang.Wang@riverbed.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PHYs supported by e100 re-starts auto-negotiation after writing to
BMCR_RESET bit. This patch powers down PHY when the interface is down
and reset is issued.

Signed-off-by: Jiang Wang <Jiang.Wang@riverbed.com>
---
 drivers/net/ethernet/intel/e100.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 9824e0a..b8e4910 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2386,6 +2386,13 @@ static int e100_set_settings(struct net_device *netdev, struct ethtool_cmd *cmd)
 	err = mii_ethtool_sset(&nic->mii, cmd);
 	e100_exec_cb(nic, NULL, e100_configure);
 
+	if (!netif_running(netdev) && !(nic->flags & wol_magic)) {
+		uint16_t phy_data;
+		phy_data = mdio_read(nic->netdev, nic->mii.phy_id, MII_BMCR);
+		phy_data |= BMCR_PDOWN;
+		mdio_write(nic->netdev, nic->mii.phy_id, MII_BMCR, phy_data);
+	}
+
 	return err;
 }
 
-- 
1.7.1

