Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993047Ab2KOELw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:11:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:49329 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993029Ab2KOELs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mike Kazantsev <mk.fraggod@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 47/66] net: fix secpath kmemleak
Date: Wed, 14 Nov 2012 20:10:52 -0800
Message-Id: <20121115040942.526241268@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3d861f661006606bf159fd6bd973e83dbf21d0f9 ]

Mike Kazantsev found 3.5 kernels and beyond were leaking memory,
and tracked the faulty commit to a1c7fff7e18f59e ("net:
netdev_alloc_skb() use build_skb()")

While this commit seems fine, it uncovered a bug introduced
in commit bad43ca8325 ("net: introduce skb_try_coalesce()), in function
kfree_skb_partial()"):

If head is stolen, we free the sk_buff,
without removing references on secpath (skb->sp).

So IPsec + IP defrag/reassembly (using skb coalescing), or
TCP coalescing could leak secpath objects.

Fix this bug by calling skb_release_head_state(skb) to properly
release all possible references to linked objects.

Reported-by: Mike Kazantsev <mk.fraggod@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Bisected-by: Mike Kazantsev <mk.fraggod@gmail.com>
Tested-by: Mike Kazantsev <mk.fraggod@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3384,10 +3384,12 @@ EXPORT_SYMBOL(__skb_warn_lro_forwarding)
 
 void kfree_skb_partial(struct sk_buff *skb, bool head_stolen)
 {
-	if (head_stolen)
+	if (head_stolen) {
+		skb_release_head_state(skb);
 		kmem_cache_free(skbuff_head_cache, skb);
-	else
+	} else {
 		__kfree_skb(skb);
+	}
 }
 EXPORT_SYMBOL(kfree_skb_partial);
 


