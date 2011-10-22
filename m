Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab1JVHZq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 03:25:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59336 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1JVHZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 03:25:45 -0400
Message-ID: <1319268338.6180.20.camel@edumazet-laptop>
Subject: [PATCH] tg3: fix tigon3_dma_hwbug_workaround()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ari Savolainen <ari.m.savolainen@gmail.com>
Cc: RongQing Li <roy.qing.li@gmail.com>, David Miller <davem@davemloft.net>,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 22 Oct 2011 09:25:38 +0200
In-Reply-To: <1319265470.6180.13.camel@edumazet-laptop>
References: <CAEbykaX4UPDBxOHmNr=dodaquSPjhPr-pLCcUn5hSu4-xLZy-g@mail.gmail.com>
	 <20111020.155659.486754557434415381.davem@davemloft.net>
	 <1319141125.2854.14.camel@edumazet-laptop>
	 <20111020.161147.33259825921677777.davem@davemloft.net>
	 <1319141867.2854.19.camel@edumazet-laptop>
	 <CAEbykaWhh12pM2jRSzfGig=jeKhVWSdxfwuXHFvLTt14=BYTbA@mail.gmail.com>
	 <CAJFZqHzWUsP7szrjVwmW5+HWRND3R4qxWcnK=bqbsgL6F7XGeA@mail.gmail.com>
	 <CAEbykaVJneQ0ozUvYh2PRn-p_BowL4z4_4Y8EFCdO9mOsNX7OQ@mail.gmail.com>
	 <1319265470.6180.13.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ari got kernel panics using tg3 NIC, and bisected to 2669069aacc9 "tg3:
enable transmit time stamping."

This is because tigon3_dma_hwbug_workaround() might alloc a new skb and
free the original. We panic when skb_tx_timestamp() is called on freed
skb.

Reported-by: Ari Savolainen <ari.m.savolainen@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 drivers/net/tg3.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 4a1374d..6149dc5 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -6029,12 +6029,12 @@ static void tg3_tx_skb_unmap(struct tg3_napi *tnapi, u32 entry, int last)
 
 /* Workaround 4GB and 40-bit hardware DMA bugs. */
 static int tigon3_dma_hwbug_workaround(struct tg3_napi *tnapi,
-				       struct sk_buff *skb,
+				       struct sk_buff **pskb,
 				       u32 *entry, u32 *budget,
 				       u32 base_flags, u32 mss, u32 vlan)
 {
 	struct tg3 *tp = tnapi->tp;
-	struct sk_buff *new_skb;
+	struct sk_buff *new_skb, *skb = *pskb;
 	dma_addr_t new_addr = 0;
 	int ret = 0;
 
@@ -6076,7 +6076,7 @@ static int tigon3_dma_hwbug_workaround(struct tg3_napi *tnapi,
 	}
 
 	dev_kfree_skb(skb);
-
+	*pskb = new_skb;
 	return ret;
 }
 
@@ -6305,7 +6305,7 @@ static netdev_tx_t tg3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		 */
 		entry = tnapi->tx_prod;
 		budget = tg3_tx_avail(tnapi);
-		if (tigon3_dma_hwbug_workaround(tnapi, skb, &entry, &budget,
+		if (tigon3_dma_hwbug_workaround(tnapi, &skb, &entry, &budget,
 						base_flags, mss, vlan))
 			goto out_unlock;
 	}


