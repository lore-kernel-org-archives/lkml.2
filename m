Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab2GTTYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 15:24:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab2GTTWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 15:22:36 -0400
Date: Fri, 20 Jul 2012 22:23:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, davem@davemloft.net
Subject: [PATCHv3 2/6] skbuff: convert to skb_orphan_frags
Message-ID: <a1f1fceab0fc4347ba577f5fb3aca8acf61de064.1342812067.git.mst@redhat.com>
References: <cover.1342812067.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1342812067.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce code duplication a bit using the new helper.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/core/skbuff.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ccfcb7d..438bbc5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -804,10 +804,8 @@ struct sk_buff *skb_clone(struct sk_buff *skb, gfp_t gfp_mask)
 {
 	struct sk_buff *n;
 
-	if (skb_shinfo(skb)->tx_flags & SKBTX_DEV_ZEROCOPY) {
-		if (skb_copy_ubufs(skb, gfp_mask))
-			return NULL;
-	}
+	if (skb_orphan_frags(skb, gfp_mask))
+		return NULL;
 
 	n = skb + 1;
 	if (skb->fclone == SKB_FCLONE_ORIG &&
@@ -927,12 +925,10 @@ struct sk_buff *__pskb_copy(struct sk_buff *skb, int headroom, gfp_t gfp_mask)
 	if (skb_shinfo(skb)->nr_frags) {
 		int i;
 
-		if (skb_shinfo(skb)->tx_flags & SKBTX_DEV_ZEROCOPY) {
-			if (skb_copy_ubufs(skb, gfp_mask)) {
-				kfree_skb(n);
-				n = NULL;
-				goto out;
-			}
+		if (skb_orphan_frags(skb, gfp_mask)) {
+			kfree_skb(n);
+			n = NULL;
+			goto out;
 		}
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			skb_shinfo(n)->frags[i] = skb_shinfo(skb)->frags[i];
@@ -1005,10 +1001,8 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	 */
 	if (skb_cloned(skb)) {
 		/* copy this zero copy skb frags */
-		if (skb_shinfo(skb)->tx_flags & SKBTX_DEV_ZEROCOPY) {
-			if (skb_copy_ubufs(skb, gfp_mask))
-				goto nofrags;
-		}
+		if (skb_orphan_frags(skb, gfp_mask))
+			goto nofrags;
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
 			skb_frag_ref(skb, i);
 
-- 
MST

