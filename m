Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab1KFAjh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 20:39:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:36566 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab1KFAjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 20:39:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:in-reply-to:references:organization:x-system-of-record;
	b=ngAgPi+k5HarCuIfg5na3D/f97w3xAuLH2jcAuVZQ/nBUByLCFGRXg6tf1PLw8fwd
	Rwi1/3eluLdxbuAcY2MTQ==
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net v5 5/5] forcedeth: fix a few sparse warnings (variable shadowing)
Date: Sat,  5 Nov 2011 17:38:24 -0700
Message-Id: <1dfa3c772e6e543b6a8a9436e2354262beb1d36a.1320539724.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1320539724.git.david.decotigny@google.com>
References: <cover.1320539724.git.david.decotigny@google.com>
In-Reply-To: <cover.1320539724.git.david.decotigny@google.com>
References: <cover.1320539724.git.david.decotigny@google.com>
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
index 0c10ff7..1dca570 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -2103,10 +2103,10 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
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
@@ -2145,13 +2145,13 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
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
@@ -2163,12 +2163,12 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
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
@@ -2217,10 +2217,10 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
 
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
@@ -2261,13 +2261,13 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
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
@@ -2280,12 +2280,12 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
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
@@ -2933,11 +2933,11 @@ static void nv_set_multicast(struct net_device *dev)
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

