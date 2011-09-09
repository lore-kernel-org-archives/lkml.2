Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab1IIK7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 06:59:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933364Ab1IIK5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 06:57:36 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 09/14] netvm: Propagate page->pfmemalloc to skb
Date: Fri,  9 Sep 2011 11:57:20 +0100
Message-Id: <1315565845-16857-10-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1315565845-16857-1-git-send-email-mgorman@suse.de>
References: <1315565845-16857-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The skb->pfmemalloc flag gets set to true iff during the slab
allocation of data in __alloc_skb that the the PFMEMALLOC reserves
were used. If the packet is fragmented, it is possible that pages
will be allocated from the PFMEMALLOC reserve without propagating
this information to the skb. This patch propagates page->pfmemalloc
from pages allocated for fragments to the skb.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/skbuff.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c8cde02..2a6bd89 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1141,6 +1141,8 @@ static inline void skb_fill_page_desc(struct sk_buff *skb, int i,
 {
 	skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
+	if (page->pfmemalloc)
+		skb->pfmemalloc	  = true;
 	frag->page		  = page;
 	frag->page_offset	  = off;
 	frag->size		  = size;
-- 
1.7.3.4

