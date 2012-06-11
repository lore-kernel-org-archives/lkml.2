Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab2FKIyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:54:01 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63185 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2FKIyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:54:00 -0400
Subject: Re: [PATCH 1/3] net: lpc_eth: Replace WARN() trace with simple
 pr_warn()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <4FD5AE1D.9030807@antcom.de>
References: <1339401793-12258-1-git-send-email-stigge@antcom.de>
	 <1339403108.6001.1697.camel@edumazet-glaptop>  <4FD5AE1D.9030807@antcom.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jun 2012 10:53:55 +0200
Message-ID: <1339404835.6001.1788.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 10:36 +0200, Roland Stigge wrote:

> I encountered cases where this happened for me on a custom board under
> heavy load.
> 
> I discussed this with Kevin Wells, the original driver author. We
> identified the case of xmit()'s TX request (from .ndo_start_xmit) with
> full TX driver buffers as valid when ethernet is busy.
> 
> But maybe this is wrong. Can you please give me a hint how the net
> subsystem makes sure that this doesn't happen under normal circumstances?

When TX ring is about to be filler, driver lpc_eth_hard_start_xmit()
calls netif_stop_queue(ndev);

So network stack should not call again lpc_eth_hard_start_xmit().

I would say the bug(s) come from __lpc_handle_xmit(), since it does :

if (netif_queue_stopped(ndev))
	netif_wake_queue(ndev);

without making sure some room is available in TX ring.

cumulative patch :

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 8d2666f..59b37c8 100644
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


