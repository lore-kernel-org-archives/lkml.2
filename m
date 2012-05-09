Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab2EIGGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:06:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38933 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756241Ab2EIFxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:36 -0400
Message-Id: <20120509055040.099618905@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        Vijay Subramanian <subramanian.vijay@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 074/167] [PATCH 14/26] tcp: fix tcp_trim_head()
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

[ Upstream commit 4fa48bf3c75069d636fc8830743c929a062e80dc ]

commit f07d960df3 (tcp: avoid frag allocation for small frames)
breaked assumption in tcp stack that skb is either linear (skb->data_len
== 0), or fully fragged (skb->data_len == skb->len)

tcp_trim_head() made this assumption, we must fix it.

Thanks to Vijay for providing a very detailed explanation.

Reported-by: Vijay Subramanian <subramanian.vijay@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_output.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 097e0c7..7413437 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1093,6 +1093,13 @@ static void __pskb_trim_head(struct sk_buff *skb, int len)
 {
 	int i, k, eat;
 
+	eat = min_t(int, len, skb_headlen(skb));
+	if (eat) {
+		__skb_pull(skb, eat);
+		len -= eat;
+		if (!len)
+			return;
+	}
 	eat = len;
 	k = 0;
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
@@ -1124,11 +1131,7 @@ int tcp_trim_head(struct sock *sk, struct sk_buff *skb, u32 len)
 	if (skb_cloned(skb) && pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
 		return -ENOMEM;
 
-	/* If len == headlen, we avoid __skb_pull to preserve alignment. */
-	if (unlikely(len < skb_headlen(skb)))
-		__skb_pull(skb, len);
-	else
-		__pskb_trim_head(skb, len - skb_headlen(skb));
+	__pskb_trim_head(skb, len);
 
 	TCP_SKB_CB(skb)->seq += len;
 	skb->ip_summed = CHECKSUM_PARTIAL;
-- 
1.7.10



