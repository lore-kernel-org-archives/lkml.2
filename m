Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab2GIOi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:38:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38264 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754361Ab2GIOiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:20 -0400
Message-Id: <20120709143121.428073519@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, stephen hemminger <shemminger@vyatta.com>,
        Kirill Smelkov <kirr@mns.spb.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 33/48] sky2: fix checksum bit management on some chips
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <shemminger@vyatta.com>

[ Upstream commit 5ff0feac88ced864f44adb145142269196fa79d9 ]

The newer flavors of Yukon II use a different method for receive
checksum offload. This is indicated in the driver by the SKY2_HW_NEW_LE
flag. On these newer chips, the BMU_ENA_RX_CHKSUM should not be set.

The driver would get incorrectly toggle the bit, enabling the old
checksum logic on these chips and cause a BUG_ON() assertion. If
receive checksum was toggled via ethtool.

Reported-by: Kirill Smelkov <kirr@mns.spb.ru>
Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/marvell/sky2.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 65c51ff..11ddd838 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4361,10 +4361,12 @@ static int sky2_set_features(struct net_device *dev, u32 features)
 	struct sky2_port *sky2 = netdev_priv(dev);
 	u32 changed = dev->features ^ features;
 
-	if (changed & NETIF_F_RXCSUM) {
-		u32 on = features & NETIF_F_RXCSUM;
-		sky2_write32(sky2->hw, Q_ADDR(rxqaddr[sky2->port], Q_CSR),
-			     on ? BMU_ENA_RX_CHKSUM : BMU_DIS_RX_CHKSUM);
+	if ((changed & NETIF_F_RXCSUM) &&
+	    !(sky2->hw->flags & SKY2_HW_NEW_LE)) {
+		sky2_write32(sky2->hw,
+			     Q_ADDR(rxqaddr[sky2->port], Q_CSR),
+			     (features & NETIF_F_RXCSUM)
+			     ? BMU_ENA_RX_CHKSUM : BMU_DIS_RX_CHKSUM);
 	}
 
 	if (changed & NETIF_F_RXHASH)


