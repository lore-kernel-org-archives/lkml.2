Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab1HSNdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:33:40 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:58759 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab1HSN3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:54 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732462"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 63/75] xen: netfront: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:35 +0100
Message-ID: <1313760467-8598-63-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/xen-netfront.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index d7c8a98..882a957 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -275,7 +275,7 @@ no_skb:
 			break;
 		}
 
-		skb_shinfo(skb)->frags[0].page = page;
+		skb_frag_set_page(skb, 0, page);
 		skb_shinfo(skb)->nr_frags = 1;
 		__skb_queue_tail(&np->rx_batch, skb);
 	}
@@ -309,8 +309,8 @@ no_skb:
 		BUG_ON((signed short)ref < 0);
 		np->grant_rx_ref[id] = ref;
 
-		pfn = page_to_pfn(skb_shinfo(skb)->frags[0].page);
-		vaddr = page_address(skb_shinfo(skb)->frags[0].page);
+		pfn = page_to_pfn(skb_frag_page(&skb_shinfo(skb)->frags[0]));
+		vaddr = page_address(skb_frag_page(&skb_shinfo(skb)->frags[0]));
 
 		req = RING_GET_REQUEST(&np->rx, req_prod + i);
 		gnttab_grant_foreign_access_ref(ref,
@@ -461,7 +461,7 @@ static void xennet_make_frags(struct sk_buff *skb, struct net_device *dev,
 		ref = gnttab_claim_grant_reference(&np->gref_tx_head);
 		BUG_ON((signed short)ref < 0);
 
-		mfn = pfn_to_mfn(page_to_pfn(frag->page));
+		mfn = pfn_to_mfn(page_to_pfn(skb_frag_page(frag)));
 		gnttab_grant_foreign_access_ref(ref, np->xbdev->otherend_id,
 						mfn, GNTMAP_readonly);
 
@@ -768,8 +768,9 @@ static RING_IDX xennet_fill_frags(struct netfront_info *np,
 	while ((nskb = __skb_dequeue(list))) {
 		struct xen_netif_rx_response *rx =
 			RING_GET_RESPONSE(&np->rx, ++cons);
+		skb_frag_t *nfrag = &skb_shinfo(nskb)->frags[0];
 
-		frag->page = skb_shinfo(nskb)->frags[0].page;
+		__skb_frag_set_page(frag, skb_frag_page(nfrag));
 		frag->page_offset = rx->offset;
 		frag->size = rx->status;
 
@@ -873,7 +874,7 @@ static int handle_incoming_queue(struct net_device *dev,
 		memcpy(skb->data, vaddr + offset,
 		       skb_headlen(skb));
 
-		if (page != skb_shinfo(skb)->frags[0].page)
+		if (page != skb_frag_page(&skb_shinfo(skb)->frags[0]))
 			__free_page(page);
 
 		/* Ethernet work: Delayed to here as it peeks the header. */
@@ -954,7 +955,8 @@ err:
 			}
 		}
 
-		NETFRONT_SKB_CB(skb)->page = skb_shinfo(skb)->frags[0].page;
+		NETFRONT_SKB_CB(skb)->page =
+			skb_frag_page(&skb_shinfo(skb)->frags[0]);
 		NETFRONT_SKB_CB(skb)->offset = rx->offset;
 
 		len = rx->status;
@@ -968,7 +970,7 @@ err:
 			skb_shinfo(skb)->frags[0].size = rx->status - len;
 			skb->data_len = rx->status - len;
 		} else {
-			skb_shinfo(skb)->frags[0].page = NULL;
+			skb_frag_set_page(skb, 0, NULL);
 			skb_shinfo(skb)->nr_frags = 0;
 		}
 
@@ -1143,7 +1145,8 @@ static void xennet_release_rx_bufs(struct netfront_info *np)
 
 		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
 			/* Remap the page. */
-			struct page *page = skb_shinfo(skb)->frags[0].page;
+			const struct page *page =
+				skb_frag_page(&skb_shinfo(skb)->frags[0]);
 			unsigned long pfn = page_to_pfn(page);
 			void *vaddr = page_address(page);
 
@@ -1650,6 +1653,8 @@ static int xennet_connect(struct net_device *dev)
 
 	/* Step 2: Rebuild the RX buffer freelist and the RX ring itself. */
 	for (requeue_idx = 0, i = 0; i < NET_RX_RING_SIZE; i++) {
+		skb_frag_t *frag;
+		const struct page *page;
 		if (!np->rx_skbs[i])
 			continue;
 
@@ -1657,10 +1662,11 @@ static int xennet_connect(struct net_device *dev)
 		ref = np->grant_rx_ref[requeue_idx] = xennet_get_rx_ref(np, i);
 		req = RING_GET_REQUEST(&np->rx, requeue_idx);
 
+		frag = &skb_shinfo(skb)->frags[0];
+		page = skb_frag_page(frag);
 		gnttab_grant_foreign_access_ref(
 			ref, np->xbdev->otherend_id,
-			pfn_to_mfn(page_to_pfn(skb_shinfo(skb)->
-					       frags->page)),
+			pfn_to_mfn(page_to_pfn(page)),
 			0);
 		req->gref = ref;
 		req->id   = requeue_idx;
-- 
1.7.2.5

