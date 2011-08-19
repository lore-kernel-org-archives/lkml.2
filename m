Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab1HSNod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:44:33 -0400
Received: from smtp.citrix.com ([66.165.176.89]:10937 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab1HSN2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:28:49 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158289"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Kristoffer Glembo <kristoffer@gaisler.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 29/75] greth: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:01 +0100
Message-ID: <1313760467-8598-29-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid long lines also use phys_to_virt(page_to_phys(page)) =>
page_address(page) (since the are effectively the same thing for lowmem pages).

Also dump the frag's size instead of the headlen when dumping a frag.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Kristoffer Glembo <kristoffer@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
---
 drivers/net/greth.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/greth.c b/drivers/net/greth.c
index 16ce45c..562a251 100644
--- a/drivers/net/greth.c
+++ b/drivers/net/greth.c
@@ -113,9 +113,8 @@ static void greth_print_tx_packet(struct sk_buff *skb)
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 
 		print_hex_dump(KERN_DEBUG, "TX: ", DUMP_PREFIX_OFFSET, 16, 1,
-			       phys_to_virt(page_to_phys(skb_shinfo(skb)->frags[i].page)) +
-			       skb_shinfo(skb)->frags[i].page_offset,
-			       length, true);
+			       skb_frag_address(&skb_shinfo(skb)->frags[i]),
+			       skb_shinfo(skb)->frags[i].size, true);
 	}
 }
 
@@ -528,11 +527,8 @@ greth_start_xmit_gbit(struct sk_buff *skb, struct net_device *dev)
 
 		greth_write_bd(&bdp->stat, status);
 
-		dma_addr = dma_map_page(greth->dev,
-					frag->page,
-					frag->page_offset,
-					frag->size,
-					DMA_TO_DEVICE);
+		dma_addr = skb_frag_dma_map(greth->dev, frag, 0, frag->size,
+					    DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(greth->dev, dma_addr)))
 			goto frag_map_error;
-- 
1.7.2.5

