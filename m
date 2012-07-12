Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162597Ab2GLXrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:47:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415Ab2GLWhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:37:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>, Roland Stigge <stigge@antcom.de>,
        Kevin Wells <kevin.wells@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 027/187] lpc_eth: fix tx completion
Date: Thu, 12 Jul 2012 15:33:03 -0700
Message-Id: <20120712191524.774366476@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3f16da51b0e533871d22a29682f3c3969d4f7e22 ]

__lpc_handle_xmit() has two bugs :

1) It can leak skbs in case TXSTATUS_ERROR is set

2) It can wake up txqueue while no slot was freed.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Roland Stigge <stigge@antcom.de>
Tested-by: Roland Stigge <stigge@antcom.de>
Cc: Kevin Wells <kevin.wells@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/nxp/lpc_eth.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -936,16 +936,16 @@ static void __lpc_handle_xmit(struct net
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


