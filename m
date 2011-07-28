Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab1G1Xo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:44:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:30203 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994Ab1G1XoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33351749"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: cooldavid@cooldavid.org, chrisw@sous-sol.org, davem@davemloft.net,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [6/50] jme: Fix unmap error (Causing system freeze)
Message-Id: <20110728234410.686042403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Guo-Fu Tseng <cooldavid@cooldavid.org>

[ upstream commit 94c5b41b327e08de0ddf563237855f55080652a1 ]

This patch add the missing dma_unmap().
Which solved the critical issue of system freeze on heavy load.

Michal Miroslaw's rejected patch:
[PATCH v2 10/46] net: jme: convert to generic DMA API
Pointed out the issue also, thank you Michal.
But the fix was incorrect. It would unmap needed address
when low memory.

Got lots of feedback from End user and Gentoo Bugzilla.
https://bugs.gentoo.org/show_bug.cgi?id=373109
Thank you all. :)

Cc: stable@kernel.org
Signed-off-by: Guo-Fu Tseng <cooldavid@cooldavid.org>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/net/jme.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/jme.c
+++ linux-2.6.35.y/drivers/net/jme.c
@@ -678,20 +678,28 @@ jme_make_new_rx_buf(struct jme_adapter *
 	struct jme_ring *rxring = &(jme->rxring[0]);
 	struct jme_buffer_info *rxbi = rxring->bufinf + i;
 	struct sk_buff *skb;
+	dma_addr_t mapping;
 
 	skb = netdev_alloc_skb(jme->dev,
 		jme->dev->mtu + RX_EXTRA_LEN);
 	if (unlikely(!skb))
 		return -ENOMEM;
 
+	mapping = pci_map_page(jme->pdev, virt_to_page(skb->data),
+			       offset_in_page(skb->data), skb_tailroom(skb),
+			       PCI_DMA_FROMDEVICE);
+	if (unlikely(pci_dma_mapping_error(jme->pdev, mapping))) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	if (likely(rxbi->mapping))
+		pci_unmap_page(jme->pdev, rxbi->mapping,
+			       rxbi->len, PCI_DMA_FROMDEVICE);
+
 	rxbi->skb = skb;
 	rxbi->len = skb_tailroom(skb);
-	rxbi->mapping = pci_map_page(jme->pdev,
-					virt_to_page(skb->data),
-					offset_in_page(skb->data),
-					rxbi->len,
-					PCI_DMA_FROMDEVICE);
-
+	rxbi->mapping = mapping;
 	return 0;
 }
 
