Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab2JGXnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:43:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38248 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211Ab2JGXWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:11 -0400
Message-Id: <20121007225848.115614156@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 08 Oct 2012 00:00:11 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 097/108] ipv4: raw: fix icmp_filter()
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ab43ed8b7490cb387782423ecf74aeee7237e591 ]

icmp_filter() should not modify its input, or else its caller
would need to recompute ip_hdr() if skb->head is reallocated.

Use skb_header_pointer() instead of pskb_may_pull() and
change the prototype to make clear both sk and skb are const.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/raw.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 007e2eb..e1d4f30 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -131,18 +131,20 @@ found:
  *	0 - deliver
  *	1 - block
  */
-static __inline__ int icmp_filter(struct sock *sk, struct sk_buff *skb)
+static int icmp_filter(const struct sock *sk, const struct sk_buff *skb)
 {
-	int type;
+	struct icmphdr _hdr;
+	const struct icmphdr *hdr;
 
-	if (!pskb_may_pull(skb, sizeof(struct icmphdr)))
+	hdr = skb_header_pointer(skb, skb_transport_offset(skb),
+				 sizeof(_hdr), &_hdr);
+	if (!hdr)
 		return 1;
 
-	type = icmp_hdr(skb)->type;
-	if (type < 32) {
+	if (hdr->type < 32) {
 		__u32 data = raw_sk(sk)->filter.data;
 
-		return ((1 << type) & data) != 0;
+		return ((1U << hdr->type) & data) != 0;
 	}
 
 	/* Do not block unknown ICMP types */


