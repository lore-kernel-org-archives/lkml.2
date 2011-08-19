Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab1HSNsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:48:42 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:27676 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab1HSN2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:28:11 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732210"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@voltaire.com>, Joe Perches <joe@perches.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Christoph Lameter <cl@linux.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 09/75] IPoIB: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:26:41 +0100
Message-ID: <1313760467-8598-9-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Or Gerlitz <ogerlitz@voltaire.com>
Cc: Joe Perches <joe@perches.com>
Cc: "Michał Mirosław" <mirq-linux@rere.qmqm.pl>
Cc: Christoph Lameter <cl@linux.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |    5 +++--
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 39913a0..67a477b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -169,7 +169,7 @@ static struct sk_buff *ipoib_cm_alloc_rx_skb(struct net_device *dev,
 			goto partial_error;
 		skb_fill_page_desc(skb, i, page, 0, PAGE_SIZE);
 
-		mapping[i + 1] = ib_dma_map_page(priv->ca, skb_shinfo(skb)->frags[i].page,
+		mapping[i + 1] = ib_dma_map_page(priv->ca, page,
 						 0, PAGE_SIZE, DMA_FROM_DEVICE);
 		if (unlikely(ib_dma_mapping_error(priv->ca, mapping[i + 1])))
 			goto partial_error;
@@ -537,7 +537,8 @@ static void skb_put_frags(struct sk_buff *skb, unsigned int hdr_space,
 
 		if (length == 0) {
 			/* don't need this page */
-			skb_fill_page_desc(toskb, i, frag->page, 0, PAGE_SIZE);
+			skb_fill_page_desc(toskb, i, skb_frag_page(frag),
+					   0, PAGE_SIZE);
 			--skb_shinfo(skb)->nr_frags;
 		} else {
 			size = min(length, (unsigned) PAGE_SIZE);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 81ae61d..00435be 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -182,7 +182,7 @@ static struct sk_buff *ipoib_alloc_rx_skb(struct net_device *dev, int id)
 			goto partial_error;
 		skb_fill_page_desc(skb, 0, page, 0, PAGE_SIZE);
 		mapping[1] =
-			ib_dma_map_page(priv->ca, skb_shinfo(skb)->frags[0].page,
+			ib_dma_map_page(priv->ca, page,
 					0, PAGE_SIZE, DMA_FROM_DEVICE);
 		if (unlikely(ib_dma_mapping_error(priv->ca, mapping[1])))
 			goto partial_error;
@@ -323,7 +323,8 @@ static int ipoib_dma_map_tx(struct ib_device *ca,
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; ++i) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		mapping[i + off] = ib_dma_map_page(ca, frag->page,
+		mapping[i + off] = ib_dma_map_page(ca,
+						 skb_frag_page(frag),
 						 frag->page_offset, frag->size,
 						 DMA_TO_DEVICE);
 		if (unlikely(ib_dma_mapping_error(ca, mapping[i + off])))
-- 
1.7.2.5

