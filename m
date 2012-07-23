Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab2GWB7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:59:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54185 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247Ab2GWBmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:52 -0400
Message-Id: <20120723010706.893460314@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Deepak Sikri <deepak.sikri@st.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 101/108] stmmac: Fix for nfs hang on multiple reboot
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepak Sikri <deepak.sikri@st.com>

commit 8e83989106562326bfd6aaf92174fe138efd026b upstream.

It was observed that during multiple reboots nfs hangs. The status of
receive descriptors shows that all the descriptors were in control of
CPU, and none were assigned to DMA.
Also the DMA status register confirmed that the Rx buffer is
unavailable.

This patch adds the fix for the same by adding the memory barriers to
ascertain that the all instructions before enabling the Rx or Tx DMA are
completed which involves the proper setting of the ownership bit in DMA
descriptors.

Signed-off-by: Deepak Sikri <deepak.sikri@st.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 51b3b68..ea3003e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1212,6 +1212,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 		priv->hw->desc->prepare_tx_desc(desc, 0, len, csum_insertion);
 		wmb();
 		priv->hw->desc->set_tx_owner(desc);
+		wmb();
 	}
 
 	/* Interrupt on completition only for the latest segment */
@@ -1227,6 +1228,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* To avoid raise condition */
 	priv->hw->desc->set_tx_owner(first);
+	wmb();
 
 	priv->cur_tx++;
 
@@ -1290,6 +1292,7 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv)
 		}
 		wmb();
 		priv->hw->desc->set_rx_owner(p + entry);
+		wmb();
 	}
 }
 


