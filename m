Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1J0CS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 22:18:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10069 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab1J0CRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 22:17:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6511"; a="131112692"
From: Stephen Boyd <sboyd@codeaurora.org>
To: netdev@vger.kernel.org
Cc: Ben Dooks <ben@simtec.co.uk>, linux-kernel@vger.kernel.org,
        Sebastien Jan <s-jan@ti.com>
Subject: [PATCH 3/5] KSZ8851-SNL: Add support for EEPROM MAC address
Date: Wed, 26 Oct 2011 19:17:48 -0700
Message-Id: <1319681870-11972-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.7.1.431.g10b2a
In-Reply-To: <1319681870-11972-1-git-send-email-sboyd@codeaurora.org>
References: <1319681870-11972-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben@simtec.co.uk>

Add support for reading the MAC address from the system registers if there
is an EEPROM present. This involves caching the KS_CCR register for later
use (will also be useful for ETHTOOL support) and adding a print to say
that there is an EEPROM present.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/net/ethernet/micrel/ks8851.c |   41 ++++++++++++++++++++++++++++-----
 1 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index f56743a..d1669bc 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -367,21 +367,47 @@ static int ks8851_write_mac_addr(struct net_device *dev)
 }
 
 /**
+ * ks8851_read_mac_addr - read mac address from device registers
+ * @dev: The network device
+ *
+ * Update our copy of the KS8851 MAC address from the registers of @dev.
+*/
+static void ks8851_read_mac_addr(struct net_device *dev)
+{
+	struct ks8851_net *ks = netdev_priv(dev);
+	int i;
+
+	mutex_lock(&ks->lock);
+
+	for (i = 0; i < ETH_ALEN; i++)
+		dev->dev_addr[i] = ks8851_rdreg8(ks, KS_MAR(i));
+
+	mutex_unlock(&ks->lock);
+}
+
+/**
  * ks8851_init_mac - initialise the mac address
  * @ks: The device structure
  *
  * Get or create the initial mac address for the device and then set that
- * into the station address register. Currently we assume that the device
- * does not have a valid mac address in it, and so we use random_ether_addr()
+ * into the station address register. If there is an EEPROM present, then
+ * we try that. If no valid mac address is found we use random_ether_addr()
  * to create a new one.
- *
- * In future, the driver should check to see if the device has an EEPROM
- * attached and whether that has a valid ethernet address in it.
  */
 static void ks8851_init_mac(struct ks8851_net *ks)
 {
 	struct net_device *dev = ks->netdev;
 
+	/* first, try reading what we've got already */
+	if (ks->rc_ccr & CCR_EEPROM) {
+		ks8851_read_mac_addr(dev);
+		if (is_valid_ether_addr(dev->dev_addr))
+			return;
+
+		netdev_err(ks->netdev, "invalid mac address read %pM\n",
+				dev->dev_addr);
+	}
+
 	random_ether_addr(dev->dev_addr);
 	ks8851_write_mac_addr(dev);
 }
@@ -1674,9 +1700,10 @@ static int __devinit ks8851_probe(struct spi_device *spi)
 		goto err_netdev;
 	}
 
-	netdev_info(ndev, "revision %d, MAC %pM, IRQ %d\n",
+	netdev_info(ndev, "revision %d, MAC %pM, IRQ %d, %s EEPROM\n",
 		    CIDER_REV_GET(ks8851_rdreg16(ks, KS_CIDER)),
-		    ndev->dev_addr, ndev->irq);
+		    ndev->dev_addr, ndev->irq,
+		    ks->rc_ccr & CCR_EEPROM ? "has" : "no");
 
 	return 0;
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

