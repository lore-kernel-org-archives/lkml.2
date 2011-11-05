Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab1KEB4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 21:56:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8617 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1KEBxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 21:53:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:in-reply-to:references:organization:x-system-of-record;
	b=AOrQmvsgY7MrmP9kJXyz3EcpcFfWg8hTlwItW6BpSvDvynkSkMafiMyaoipFOCEy0
	F/plB0fLbT8XdYFjFoEyg==
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net v3 9/9] forcedeth: fix a few sparse warnings (variable shadowing)
Date: Fri,  4 Nov 2011 18:53:33 -0700
Message-Id: <50304d145f909f73dd7ed86335adba3ee38020d4.1320457247.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1320457247.git.david.decotigny@google.com>
References: <cover.1320457247.git.david.decotigny@google.com>
In-Reply-To: <cover.1320457247.git.david.decotigny@google.com>
References: <cover.1320457247.git.david.decotigny@google.com>
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following sparse warnings:
drivers/net/ethernet/nvidia/forcedeth.c:2113:7: warning: symbol 'size' shadows an earlier one
drivers/net/ethernet/nvidia/forcedeth.c:2102:6: originally declared here
drivers/net/ethernet/nvidia/forcedeth.c:2155:7: warning: symbol 'size' shadows an earlier one
drivers/net/ethernet/nvidia/forcedeth.c:2102:6: originally declared here
drivers/net/ethernet/nvidia/forcedeth.c:2227:7: warning: symbol 'size' shadows an earlier one
drivers/net/ethernet/nvidia/forcedeth.c:2215:6: originally declared here
drivers/net/ethernet/nvidia/forcedeth.c:2271:7: warning: symbol 'size' shadows an earlier one
drivers/net/ethernet/nvidia/forcedeth.c:2215:6: originally declared here
drivers/net/ethernet/nvidia/forcedeth.c:2986:20: warning: symbol 'addr' shadows an earlier one
drivers/net/ethernet/nvidia/forcedeth.c:2963:6: originally declared here



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c |   34 +++++++++++++++---------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 08c512b..5ca9859 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -2131,10 +2131,10 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* add fragments to entries count */
 	for (i = 0; i < fragments; i++) {
-		u32 size = skb_frag_size(&skb_shinfo(skb)->frags[i]);
+		u32 frag_size = skb_frag_size(&skb_shinfo(skb)->frags[i]);
 
-		entries += (size >> NV_TX2_TSO_MAX_SHIFT) +
-			   ((size & (NV_TX2_TSO_MAX_SIZE-1)) ? 1 : 0);
+		entries += (frag_size >> NV_TX2_TSO_MAX_SHIFT) +
+			   ((frag_size & (NV_TX2_TSO_MAX_SIZE-1)) ? 1 : 0);
 	}
 
 	spin_lock_irqsave(&np->lock, flags);
@@ -2173,13 +2173,13 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* setup the fragments */
 	for (i = 0; i < fragments; i++) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		u32 size = skb_frag_size(frag);
+		u32 frag_size = skb_frag_size(frag);
 		offset = 0;
 
 		do {
 			prev_tx = put_tx;
 			prev_tx_ctx = np->put_tx_ctx;
-			bcnt = (size > NV_TX2_TSO_MAX_SIZE) ? NV_TX2_TSO_MAX_SIZE : size;
+			bcnt = (frag_size > NV_TX2_TSO_MAX_SIZE) ? NV_TX2_TSO_MAX_SIZE : frag_size;
 			np->put_tx_ctx->dma = skb_frag_dma_map(
 							&np->pci_dev->dev,
 							frag, offset,
@@ -2191,12 +2191,12 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			put_tx->flaglen = cpu_to_le32((bcnt-1) | tx_flags);
 
 			offset += bcnt;
-			size -= bcnt;
+			frag_size -= bcnt;
 			if (unlikely(put_tx++ == np->last_tx.orig))
 				put_tx = np->first_tx.orig;
 			if (unlikely(np->put_tx_ctx++ == np->last_tx_ctx))
 				np->put_tx_ctx = np->first_tx_ctx;
-		} while (size);
+		} while (frag_size);
 	}
 
 	/* set last fragment flag  */
@@ -2245,10 +2245,10 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 
 	/* add fragments to entries count */
 	for (i = 0; i < fragments; i++) {
-		u32 size = skb_frag_size(&skb_shinfo(skb)->frags[i]);
+		u32 frag_size = skb_frag_size(&skb_shinfo(skb)->frags[i]);
 
-		entries += (size >> NV_TX2_TSO_MAX_SHIFT) +
-			   ((size & (NV_TX2_TSO_MAX_SIZE-1)) ? 1 : 0);
+		entries += (frag_size >> NV_TX2_TSO_MAX_SHIFT) +
+			   ((frag_size & (NV_TX2_TSO_MAX_SIZE-1)) ? 1 : 0);
 	}
 
 	spin_lock_irqsave(&np->lock, flags);
@@ -2289,13 +2289,13 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 	/* setup the fragments */
 	for (i = 0; i < fragments; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		u32 size = skb_frag_size(frag);
+		u32 frag_size = skb_frag_size(frag);
 		offset = 0;
 
 		do {
 			prev_tx = put_tx;
 			prev_tx_ctx = np->put_tx_ctx;
-			bcnt = (size > NV_TX2_TSO_MAX_SIZE) ? NV_TX2_TSO_MAX_SIZE : size;
+			bcnt = (frag_size > NV_TX2_TSO_MAX_SIZE) ? NV_TX2_TSO_MAX_SIZE : frag_size;
 			np->put_tx_ctx->dma = skb_frag_dma_map(
 							&np->pci_dev->dev,
 							frag, offset,
@@ -2308,12 +2308,12 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 			put_tx->flaglen = cpu_to_le32((bcnt-1) | tx_flags);
 
 			offset += bcnt;
-			size -= bcnt;
+			frag_size -= bcnt;
 			if (unlikely(put_tx++ == np->last_tx.ex))
 				put_tx = np->first_tx.ex;
 			if (unlikely(np->put_tx_ctx++ == np->last_tx_ctx))
 				np->put_tx_ctx = np->first_tx_ctx;
-		} while (size);
+		} while (frag_size);
 	}
 
 	/* set last fragment flag  */
@@ -2969,11 +2969,11 @@ static void nv_set_multicast(struct net_device *dev)
 				struct netdev_hw_addr *ha;
 
 				netdev_for_each_mc_addr(ha, dev) {
-					unsigned char *addr = ha->addr;
+					unsigned char *hw_addr = ha->addr;
 					u32 a, b;
 
-					a = le32_to_cpu(*(__le32 *) addr);
-					b = le16_to_cpu(*(__le16 *) (&addr[4]));
+					a = le32_to_cpu(*(__le32 *) hw_addr);
+					b = le16_to_cpu(*(__le16 *) (&hw_addr[4]));
 					alwaysOn[0] &= a;
 					alwaysOff[0] &= ~a;
 					alwaysOn[1] &= b;
-- 
1.7.3.1

