Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab2BITta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 14:49:30 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:43844 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479Ab2BITt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:49:28 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        e1000-devel@lists.sourceforge.net,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 2/2] rename dev_hw_addr_random and remove redundant second
Date: Thu,  9 Feb 2012 20:48:54 +0100
Message-Id: <1328816934-11508-3-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328816934-11508-1-git-send-email-danny.kukawka@bisect.de>
References: <1328816934-11508-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328816968;53a409b9;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renamed dev_hw_addr_random to eth_hw_addr_random() to reflect that
this function only assign a random ethernet address (MAC). Removed
the second parameter (u8 *hwaddr), it's redundant since the also
given net_device already contains net_device->dev_addr.
Set it directly.

Adapt igbvf and ixgbevf to the changed function.

Small fix for ixgbevf_probe(): if ixgbevf_sw_init() fails
(which means the device got no dev_addr) handle the error and
jump to err_sw_init as already done by igbvf in similar case.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/intel/igbvf/netdev.c         |   11 +++++---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |   28 ++++++++++++--------
 include/linux/etherdevice.h                       |   13 +++++----
 3 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index a4b20c8..14d42f9 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2695,18 +2695,19 @@ static int __devinit igbvf_probe(struct pci_dev *pdev,
 		dev_info(&pdev->dev,
 			 "PF still in reset state, assigning new address."
 			 " Is the PF interface up?\n");
-		dev_hw_addr_random(adapter->netdev, hw->mac.addr);
+		eth_hw_addr_random(netdev);
+		memcpy(adapter->hw.mac.addr, netdev->dev_addr,
+			netdev->addr_len);
 	} else {
 		err = hw->mac.ops.read_mac_addr(hw);
 		if (err) {
 			dev_err(&pdev->dev, "Error reading MAC address\n");
 			goto err_hw_init;
 		}
+		memcpy(netdev->dev_addr, adapter->hw.mac.addr,
+			netdev->addr_len);
 	}
 
-	memcpy(netdev->dev_addr, adapter->hw.mac.addr, netdev->addr_len);
-	memcpy(netdev->perm_addr, adapter->hw.mac.addr, netdev->addr_len);
-
 	if (!is_valid_ether_addr(netdev->perm_addr)) {
 		dev_err(&pdev->dev, "Invalid MAC Address: %pM\n",
 		        netdev->dev_addr);
@@ -2714,6 +2715,8 @@ static int __devinit igbvf_probe(struct pci_dev *pdev,
 		goto err_hw_init;
 	}
 
+	memcpy(netdev->perm_addr, adapter->hw.mac.addr, netdev->addr_len);
+
 	setup_timer(&adapter->watchdog_timer, &igbvf_watchdog,
 	            (unsigned long) adapter);
 
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index bed411b..0daf7fd 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -2195,13 +2195,17 @@ static int __devinit ixgbevf_sw_init(struct ixgbevf_adapter *adapter)
 	if (err) {
 		dev_info(&pdev->dev,
 		         "PF still in reset state, assigning new address\n");
-		dev_hw_addr_random(adapter->netdev, hw->mac.addr);
+		eth_hw_addr_random(adapter->netdev);
+		memcpy(adapter->hw.mac.addr, adapter->netdev->dev_addr,
+			adapter->netdev->addr_len);
 	} else {
 		err = hw->mac.ops.init_hw(hw);
 		if (err) {
 			pr_err("init_shared_code failed: %d\n", err);
 			goto out;
 		}
+		memcpy(adapter->netdev->dev_addr, adapter->hw.mac.addr,
+			adapter->netdev->addr_len);
 	}
 
 	/* Enable dynamic interrupt throttling rates */
@@ -2220,6 +2224,7 @@ static int __devinit ixgbevf_sw_init(struct ixgbevf_adapter *adapter)
 	adapter->flags |= IXGBE_FLAG_RX_CSUM_ENABLED;
 
 	set_bit(__IXGBEVF_DOWN, &adapter->state);
+	return 0;
 
 out:
 	return err;
@@ -3394,6 +3399,17 @@ static int __devinit ixgbevf_probe(struct pci_dev *pdev,
 
 	/* setup the private structure */
 	err = ixgbevf_sw_init(adapter);
+	if (err)
+		goto err_sw_init;
+
+	/* The HW MAC address was set and/or determined in sw_init */
+	memcpy(netdev->perm_addr, adapter->hw.mac.addr, netdev->addr_len);
+
+	if (!is_valid_ether_addr(netdev->dev_addr)) {
+		pr_err("invalid MAC address\n");
+		err = -EIO;
+		goto err_sw_init;
+	}
 
 	netdev->hw_features = NETIF_F_SG |
 			   NETIF_F_IP_CSUM |
@@ -3418,16 +3434,6 @@ static int __devinit ixgbevf_probe(struct pci_dev *pdev,
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
-	/* The HW MAC address was set and/or determined in sw_init */
-	memcpy(netdev->dev_addr, adapter->hw.mac.addr, netdev->addr_len);
-	memcpy(netdev->perm_addr, adapter->hw.mac.addr, netdev->addr_len);
-
-	if (!is_valid_ether_addr(netdev->dev_addr)) {
-		pr_err("invalid MAC address\n");
-		err = -EIO;
-		goto err_sw_init;
-	}
-
 	init_timer(&adapter->watchdog_timer);
 	adapter->watchdog_timer.function = ixgbevf_watchdog;
 	adapter->watchdog_timer.data = (unsigned long)adapter;
diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 05955cf..8a18358 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -140,17 +140,18 @@ static inline void random_ether_addr(u8 *addr)
 }
 
 /**
- * dev_hw_addr_random - Create random MAC and set device flag
+ * eth_hw_addr_random - Generate software assigned random Ethernet and
+ * set device flag
  * @dev: pointer to net_device structure
- * @hwaddr: Pointer to a six-byte array containing the Ethernet address
  *
- * Generate random MAC to be used by a device and set addr_assign_type
- * so the state can be read by sysfs and be used by udev.
+ * Generate a random Ethernet address (MAC) to be used by a net device
+ * and set addr_assign_type so the state can be read by sysfs and be
+ * used by userspace.
  */
-static inline void dev_hw_addr_random(struct net_device *dev, u8 *hwaddr)
+static inline void eth_hw_addr_random(struct net_device *dev)
 {
 	dev->addr_assign_type |= NET_ADDR_RANDOM;
-	random_ether_addr(hwaddr);
+	random_ether_addr(dev->dev_addr);
 }
 
 /**
-- 
1.7.7.3

