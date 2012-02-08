Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab2BHVNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:13:20 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:36614 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756907Ab2BHVNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:13:17 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Dennis Aberilla <denzzzhome@yahoo.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ben Dooks <ben@simtec.co.uk>,
        "Simtec Linux Team" <linux@simtec.co.uk>,
        Thomas Meyer <thomas@m3y3r.de>, Wan ZongShun <mcuos.com@gmail.com>
Subject: [PATCH 29/50] micrel eth: use dev_hw_addr_random() instead of random_ether_addr()
Date: Wed,  8 Feb 2012 22:10:36 +0100
Message-Id: <1328735457-29986-30-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328735597;fb308d44;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_hw_addr_random() instead of calling random_ether_addr()
to set addr_assign_type correctly to NET_ADDR_RANDOM.

Reset the state to NET_ADDR_PERM as soon as the MAC get
changed via .ndo_set_mac_address.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/micrel/ks8842.c     |    4 +++-
 drivers/net/ethernet/micrel/ks8851.c     |    7 +++++--
 drivers/net/ethernet/micrel/ks8851_mll.c |    4 +++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
index 0a85690..5bba69a 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -1081,6 +1081,8 @@ static int ks8842_set_mac(struct net_device *netdev, void *p)
 		return -EADDRNOTAVAIL;
 
 	memcpy(netdev->dev_addr, mac, netdev->addr_len);
+	if (netdev->addr_assign_type & NET_ADDR_RANDOM)
+		netdev->addr_assign_type ^= NET_ADDR_RANDOM;
 
 	ks8842_write_mac_addr(adapter, mac);
 	return 0;
@@ -1211,7 +1213,7 @@ static int __devinit ks8842_probe(struct platform_device *pdev)
 		ks8842_read_mac_addr(adapter, netdev->dev_addr);
 
 		if (!is_valid_ether_addr(netdev->dev_addr))
-			random_ether_addr(netdev->dev_addr);
+			dev_hw_addr_random(netdev, netdev->dev_addr);
 	}
 
 	id = ks8842_read16(adapter, 32, REG_SW_ID_AND_ENABLE);
diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 6b35e7d..49537d4 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -422,7 +422,7 @@ static void ks8851_read_mac_addr(struct net_device *dev)
  *
  * Get or create the initial mac address for the device and then set that
  * into the station address register. If there is an EEPROM present, then
- * we try that. If no valid mac address is found we use random_ether_addr()
+ * we try that. If no valid mac address is found we use dev_hw_addr_random()
  * to create a new one.
  */
 static void ks8851_init_mac(struct ks8851_net *ks)
@@ -439,7 +439,7 @@ static void ks8851_init_mac(struct ks8851_net *ks)
 				dev->dev_addr);
 	}
 
-	random_ether_addr(dev->dev_addr);
+	dev_hw_addr_random(dev, dev->dev_addr);
 	ks8851_write_mac_addr(dev);
 }
 
@@ -1051,6 +1051,9 @@ static int ks8851_set_mac_address(struct net_device *dev, void *addr)
 		return -EADDRNOTAVAIL;
 
 	memcpy(dev->dev_addr, sa->sa_data, ETH_ALEN);
+	if (dev->addr_assign_type & NET_ADDR_RANDOM)
+		dev->addr_assign_type ^= NET_ADDR_RANDOM;
+
 	return ks8851_write_mac_addr(dev);
 }
 
diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index e58e78e..1fa93b6 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -1242,6 +1242,8 @@ static int ks_set_mac_address(struct net_device *netdev, void *paddr)
 	u8 *da;
 
 	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	if (netdev->addr_assign_type & NET_ADDR_RANDOM)
+		netdev->addr_assign_type ^= NET_ADDR_RANDOM;
 
 	da = (u8 *)netdev->dev_addr;
 
@@ -1609,7 +1611,7 @@ static int __devinit ks8851_probe(struct platform_device *pdev)
 	 * comment out the 2 functions below.
 	 */
 
-	random_ether_addr(netdev->dev_addr);
+	dev_hw_addr_random(netdev, netdev->dev_addr);
 	ks_set_mac(ks, netdev->dev_addr);
 
 	id = ks_rdreg16(ks, KS_CIDER);
-- 
1.7.7.3

