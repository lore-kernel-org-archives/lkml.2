Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab2FKRVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 13:21:43 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43465 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2FKRVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 13:21:42 -0400
Subject: [PATCH] net: lpc_eth: fix tx completion
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1339404835.6001.1788.camel@edumazet-glaptop>
References: <1339401793-12258-1-git-send-email-stigge@antcom.de>
	 <1339403108.6001.1697.camel@edumazet-glaptop>  <4FD5AE1D.9030807@antcom.de>
	 <1339404835.6001.1788.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jun 2012 19:21:36 +0200
Message-ID: <1339435296.6001.2484.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

__lpc_handle_xmit() has two bugs :

1) It can leak skbs in case TXSTATUS_ERROR is set

2) It can wake up txqueue while no slot was freed.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Roland Stigge <stigge@antcom.de>
Tested-by: Roland Stigge <stigge@antcom.de>
Cc: Kevin Wells <kevin.wells@nxp.com>
---
 drivers/net/ethernet/nxp/lpc_eth.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 8d2666f..ff76c21 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -946,16 +946,16 @@ static void __lpc_handle_xmit(struct net_device *ndev)
 			/* Update stats */
 			ndev->stats.tx_packets++;
 			ndev->stats.tx_bytes += skb->len;
-
-			/* Free buffer */
-			dev_kfree_skb_irq(skb);
 		}
+		dev_kfree_skb_irq(skb);
 
 		txcidx = readl(LPC_ENET_TXCONSUMEINDEX(pldat->net_base));
 	}
 
-	if (netif_queue_stopped(ndev))
-		netif_wake_queue(ndev);
+	if (pldat->num_used_tx_buffs <= ENET_TX_DESC/2) {
+		if (netif_queue_stopped(ndev))
+			netif_wake_queue(ndev);
+	}
 }
 
 static int __lpc_handle_recv(struct net_device *ndev, int budget)


