Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab2FVOlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:41:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762237Ab2FVOa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:30:58 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 10/16] netvm: Propagate page->pfmemalloc to skb
Date: Fri, 22 Jun 2012 15:30:37 +0100
Message-Id: <1340375443-22455-11-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1340375443-22455-1-git-send-email-mgorman@suse.de>
References: <1340375443-22455-1-git-send-email-mgorman@suse.de>
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
Acked-by: David S. Miller <davem@davemloft.net>
---
 include/linux/skbuff.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0336f02..b814bb8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1247,6 +1247,17 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
 {
 	skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
+	/*
+	 * Propagate page->pfmemalloc to the skb if we can. The problem is
+	 * that not all callers have unique ownership of the page. If
+	 * pfmemalloc is set, we check the mapping as a mapping implies
+	 * page->index is set (index and pfmemalloc share space).
+	 * If it's a valid mapping, we cannot use page->pfmemalloc but we
+	 * do not lose pfmemalloc information as the pages would not be
+	 * allocated using __GFP_MEMALLOC.
+	 */
+	if (page->pfmemalloc && !page->mapping)
+		skb->pfmemalloc	= true;
 	frag->page.p		  = page;
 	frag->page_offset	  = off;
 	skb_frag_size_set(frag, size);
-- 
1.7.9.2

