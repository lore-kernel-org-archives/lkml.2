Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060Ab1LPC3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 21:29:17 -0500
Received: from eng.riverbed.com ([208.70.196.45]:42143 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759764Ab1LPC3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 21:29:15 -0500
From: Jiang Wang <Jiang.Wang@riverbed.com>
To: Jiang Wang <Jiang.Wang@riverbed.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Prasanna Panchamukhi <Prasanna.Panchamukhi@riverbed.com>,
        Chaitanya Lala <Chaitanya.Lala@riverbed.com>,
        "Francis St. Amant" <Francis.St.Amant@riverbed.com>,
        "miles.ito@intel.com" <miles.ito@intel.com>
Subject: RE: [PATCH 2/2] e100: power off PHY after reset when interface is
 down
Thread-Topic: [PATCH 2/2] e100: power off PHY after reset when interface is
 down
Thread-Index: AQHMupWy7Dun8/ezFEO6lmrZJjJoIZXdv5Dg
Date: Fri, 16 Dec 2011 02:29:14 +0000
Message-ID: <CEE05A0D7856E14880AD5560634EBEA82AA789DD@365EXCH-MBX-P5.nbttech.com>
References: <1323830996-16388-1-git-send-email-Jiang.Wang@riverbed.com>
 <1323830996-16388-2-git-send-email-Jiang.Wang@riverbed.com>
In-Reply-To: <1323830996-16388-2-git-send-email-Jiang.Wang@riverbed.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.205.252]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modified the patch.

>From a74d3114934a82d17a43eae7b5bb1488d2c1b6c8 Mon Sep 17 00:00:00 2001
From: Jiang Wang <Jiang.Wang@riverbed.com>
Date: Thu, 15 Dec 2011 17:44:20 -0800
Subject: [PATCH 2/2] e100: power off PHY after reset when interface is down

PHYs supported by e100 re-starts auto-negotiation after writing to
BMCR_RESET bit. This patch powers down PHY when the interface is down
and reset is issued.

Signed-off-by: Jiang Wang <Jiang.Wang@riverbed.com>
---
 drivers/net/ethernet/intel/e100.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index ca994da..2764cdd 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -589,6 +589,7 @@ struct nic {
 		multicast_all      = (1 << 2),
 		wol_magic          = (1 << 3),
 		ich_10h_workaround = (1 << 4),
+		powered_off        = (1 << 5),
 	} flags					____cacheline_aligned;
 
 	enum mac mac;
@@ -1454,6 +1455,8 @@ static int e100_phy_init(struct nic *nic)
 	phy_data &= ~BMCR_PDOWN;
 	mdio_write(nic->netdev, nic->mii.phy_id, MII_BMCR, phy_data);
 
+	nic->flags &= ~powered_off;
+
 	/* Get phy ID */
 	id_lo = mdio_read(netdev, nic->mii.phy_id, MII_PHYSID1);
 	id_hi = mdio_read(netdev, nic->mii.phy_id, MII_PHYSID2);
@@ -2273,6 +2276,7 @@ static void e100_down(struct nic *nic)
 		phy_data = mdio_read(nic->netdev, nic->mii.phy_id, MII_BMCR);
 		phy_data |= BMCR_PDOWN;
 		mdio_write(nic->netdev, nic->mii.phy_id, MII_BMCR, phy_data);
+		nic->flags |= powered_off;
 	}
 
 	free_irq(nic->pdev->irq, nic->netdev);
@@ -2383,6 +2387,13 @@ static int e100_set_settings(struct net_device *netdev, struct ethtool_cmd *cmd)
 	err = mii_ethtool_sset(&nic->mii, cmd);
 	e100_exec_cb(nic, NULL, e100_configure);
 
+	if (nic->flags & powered_off) {
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


-------------------------------------
Jiang Wang
Member of Technical Staff
Riverbed Technology
Tel: (408) 522-5109
Email: Jiang.Wang@riverbed.com
www.riverbed.com


-----Original Message-----
From: Jiang Wang [mailto:Jiang.Wang@riverbed.com] 
Sent: Tuesday, December 13, 2011 6:50 PM
To: Jeff Kirsher; Jesse Brandeburg; Bruce Allan; Carolyn Wyborny; Don Skidmore; Greg Rose; Peter P Waskiewicz Jr; Alex Duyck; John Ronciak; e1000-devel@lists.sourceforge.net; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: Prasanna Panchamukhi; Chaitanya Lala; Francis St. Amant; miles.ito@intel.com; Jiang Wang
Subject: [PATCH 2/2] e100: power off PHY after reset when interface is down

PHYs supported by e100 re-starts auto-negotiation after writing to BMCR_RESET bit. This patch powers down PHY when the interface is down and reset is issued.

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

