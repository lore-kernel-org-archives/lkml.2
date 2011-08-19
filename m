Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1HSN2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:28:12 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:12775 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab1HSN2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:28:00 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732181"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 05/75] net: xfrm: convert to SKB frag APIs
Date: Fri, 19 Aug 2011 14:26:37 +0100
Message-ID: <1313760467-8598-5-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 net/xfrm/xfrm_ipcomp.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index fc91ad7..f781b9a 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -70,26 +70,29 @@ static int ipcomp_decompress(struct xfrm_state *x, struct sk_buff *skb)
 
 	while ((scratch += len, dlen -= len) > 0) {
 		skb_frag_t *frag;
+		struct page *page;
 
 		err = -EMSGSIZE;
 		if (WARN_ON(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS))
 			goto out;
 
 		frag = skb_shinfo(skb)->frags + skb_shinfo(skb)->nr_frags;
-		frag->page = alloc_page(GFP_ATOMIC);
+		page = alloc_page(GFP_ATOMIC);
 
 		err = -ENOMEM;
-		if (!frag->page)
+		if (!page)
 			goto out;
 
+		__skb_frag_set_page(frag, page);
+
 		len = PAGE_SIZE;
 		if (dlen < len)
 			len = dlen;
 
-		memcpy(page_address(frag->page), scratch, len);
-
 		frag->page_offset = 0;
 		frag->size = len;
+		memcpy(skb_frag_address(frag), scratch, len);
+
 		skb->truesize += len;
 		skb->data_len += len;
 		skb->len += len;
-- 
1.7.2.5

