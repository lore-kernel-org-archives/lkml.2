Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936286Ab1KJEG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:06:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757091Ab1KJDpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:45:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:58 2011
Message-Id: <20111109213158.215402688@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [159/264] tg3: fix tigon3_dma_hwbug_workaround()
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit f7ff19871bb4a3451e1ca2cf660bf633018cfbec ]

Ari got kernel panics using tg3 NIC, and bisected to 2669069aacc9 "tg3:
enable transmit time stamping."

This is because tigon3_dma_hwbug_workaround() might alloc a new skb and
free the original. We panic when skb_tx_timestamp() is called on freed
skb.

Reported-by: Ari Savolainen <ari.m.savolainen@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/tg3.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -6029,12 +6029,12 @@ static void tg3_tx_skb_unmap(struct tg3_
 
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
 
@@ -6076,7 +6076,7 @@ static int tigon3_dma_hwbug_workaround(s
 	}
 
 	dev_kfree_skb(skb);
-
+	*pskb = new_skb;
 	return ret;
 }
 
@@ -6305,7 +6305,7 @@ static netdev_tx_t tg3_start_xmit(struct
 		 */
 		entry = tnapi->tx_prod;
 		budget = tg3_tx_avail(tnapi);
-		if (tigon3_dma_hwbug_workaround(tnapi, skb, &entry, &budget,
+		if (tigon3_dma_hwbug_workaround(tnapi, &skb, &entry, &budget,
 						base_flags, mss, vlan))
 			goto out_unlock;
 	}


