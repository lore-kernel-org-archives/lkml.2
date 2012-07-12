Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162600Ab2GLXXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:23:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46543 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162516Ab2GLXD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:03:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kirill Smelkov <kirr@mns.spb.ru>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 13/68] sky2: fix checksum bit management on some chips
Date: Thu, 12 Jul 2012 16:01:47 -0700
Message-Id: <20120712175036.580197319@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/sky2.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -4206,10 +4206,12 @@ static int sky2_set_features(struct net_
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


