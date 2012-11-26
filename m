Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2KZSTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:19:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47066 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab2KZRAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:00:50 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 018/270] net: fix secpath kmemleak
Date: Mon, 26 Nov 2012 14:55:08 -0200
Message-Id: <1353949160-26803-19-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 3d861f661006606bf159fd6bd973e83dbf21d0f9 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/core/skbuff.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index d124306..015f3a7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3350,10 +3350,12 @@ EXPORT_SYMBOL(__skb_warn_lro_forwarding);
 
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
 
-- 
1.7.9.5

