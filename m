Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab1HSNnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:43:00 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:58689 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab1HSN2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:28:54 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732308"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Casey Leedom <leedom@chelsio.com>
Subject: [PATCH 24/75] cxgb4vf: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:26:56 +0100
Message-ID: <1313760467-8598-24-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Casey Leedom <leedom@chelsio.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/cxgb4vf/sge.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/cxgb4vf/sge.c b/drivers/net/cxgb4vf/sge.c
index cffb328..6d6060e 100644
--- a/drivers/net/cxgb4vf/sge.c
+++ b/drivers/net/cxgb4vf/sge.c
@@ -296,8 +296,8 @@ static int map_skb(struct device *dev, const struct sk_buff *skb,
 	si = skb_shinfo(skb);
 	end = &si->frags[si->nr_frags];
 	for (fp = si->frags; fp < end; fp++) {
-		*++addr = dma_map_page(dev, fp->page, fp->page_offset, fp->size,
-				       DMA_TO_DEVICE);
+		*++addr = skb_frag_dma_map(dev, fp, 0, fp->size,
+					   DMA_TO_DEVICE);
 		if (dma_mapping_error(dev, *addr))
 			goto unwind;
 	}
@@ -1397,7 +1397,7 @@ struct sk_buff *t4vf_pktgl_to_skb(const struct pkt_gl *gl,
 		skb_copy_to_linear_data(skb, gl->va, pull_len);
 
 		ssi = skb_shinfo(skb);
-		ssi->frags[0].page = gl->frags[0].page;
+		skb_frag_set_page(skb, 0, gl->frags[0].page);
 		ssi->frags[0].page_offset = gl->frags[0].page_offset + pull_len;
 		ssi->frags[0].size = gl->frags[0].size - pull_len;
 		if (gl->nfrags > 1)
@@ -1442,14 +1442,15 @@ void t4vf_pktgl_free(const struct pkt_gl *gl)
  *	Copy an internal packet gather list into a Linux skb_shared_info
  *	structure.
  */
-static inline void copy_frags(struct skb_shared_info *si,
+static inline void copy_frags(struct sk_buff *skb,
 			      const struct pkt_gl *gl,
 			      unsigned int offset)
 {
+	struct skb_shared_info *si = skb_shinfo(skb);
 	unsigned int n;
 
 	/* usually there's just one frag */
-	si->frags[0].page = gl->frags[0].page;
+	skb_frag_set_page(skb, 0, gl->frags[0].page);
 	si->frags[0].page_offset = gl->frags[0].page_offset + offset;
 	si->frags[0].size = gl->frags[0].size - offset;
 	si->nr_frags = gl->nfrags;
@@ -1484,7 +1485,7 @@ static void do_gro(struct sge_eth_rxq *rxq, const struct pkt_gl *gl,
 		return;
 	}
 
-	copy_frags(skb_shinfo(skb), gl, PKTSHIFT);
+	copy_frags(skb, gl, PKTSHIFT);
 	skb->len = gl->tot_len - PKTSHIFT;
 	skb->data_len = skb->len;
 	skb->truesize += skb->data_len;
-- 
1.7.2.5

