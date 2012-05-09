Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab2EIGT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:19:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38977 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756347Ab2EIFxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:23 -0400
Message-Id: <20120509055039.962244801@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        Marc MERLIN <marc@merlins.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 073/167] [PATCH 13/26] net: allow pskb_expand_head() to get maximum tailroom
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 87151b8689d890dfb495081f7be9b9e257f7a2df ]

Marc Merlin reported many order-1 allocations failures in TX path on its
wireless setup, that dont make any sense with MTU=1500 network, and non
SG capable hardware.

Turns out part of the problem comes from pskb_expand_head() not using
ksize() to get exact head size given by kmalloc(). Doing the same thing
than __alloc_skb() allows more tailroom in skb and can prevent future
reallocations.

As a bonus, struct skb_shared_info becomes cache line aligned.

Reported-by: Marc MERLIN <marc@merlins.org>
Tested-by: Marc MERLIN <marc@merlins.org>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/skbuff.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 29cb392..2ec200de 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -903,9 +903,11 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 		goto adjust_others;
 	}
 
-	data = kmalloc(size + sizeof(struct skb_shared_info), gfp_mask);
+	data = kmalloc(size + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
+		       gfp_mask);
 	if (!data)
 		goto nodata;
+	size = SKB_WITH_OVERHEAD(ksize(data));
 
 	/* Copy only real data... and, alas, header. This should be
 	 * optimized for the cases when header is void.
-- 
1.7.10



