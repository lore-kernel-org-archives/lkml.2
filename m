Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab1HSNoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:44:38 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25060 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab1HSN2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:28:46 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732287"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Decotigny <decot@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 20/75] cassini: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:26:52 +0100
Message-ID: <1313760467-8598-20-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Decotigny <decot@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
---
 drivers/net/cassini.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
index 646c86b..de5c7590 100644
--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -2048,8 +2048,8 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 		skb->truesize += hlen - swivel;
 		skb->len      += hlen - swivel;
 
-		get_page(page->buffer);
-		frag->page = page->buffer;
+		__skb_frag_set_page(frag, page->buffer);
+		__skb_frag_ref(frag);
 		frag->page_offset = off;
 		frag->size = hlen - swivel;
 
@@ -2072,8 +2072,8 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 			skb->len      += hlen;
 			frag++;
 
-			get_page(page->buffer);
-			frag->page = page->buffer;
+			__skb_frag_set_page(frag, page->buffer);
+			__skb_frag_ref(frag);
 			frag->page_offset = 0;
 			frag->size = hlen;
 			RX_USED_ADD(page, hlen + cp->crc_size);
@@ -2830,9 +2830,8 @@ static inline int cas_xmit_tx_ringN(struct cas *cp, int ring,
 		skb_frag_t *fragp = &skb_shinfo(skb)->frags[frag];
 
 		len = fragp->size;
-		mapping = pci_map_page(cp->pdev, fragp->page,
-				       fragp->page_offset, len,
-				       PCI_DMA_TODEVICE);
+		mapping = skb_frag_dma_map(&cp->pdev->dev, fragp, 0, len,
+					   PCI_DMA_TODEVICE);
 
 		tabort = cas_calc_tabort(cp, fragp->page_offset, len);
 		if (unlikely(tabort)) {
@@ -2843,7 +2842,7 @@ static inline int cas_xmit_tx_ringN(struct cas *cp, int ring,
 				      ctrl, 0);
 			entry = TX_DESC_NEXT(ring, entry);
 
-			addr = cas_page_map(fragp->page);
+			addr = cas_page_map(skb_frag_page(fragp));
 			memcpy(tx_tiny_buf(cp, ring, entry),
 			       addr + fragp->page_offset + len - tabort,
 			       tabort);
-- 
1.7.2.5

