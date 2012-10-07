Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2JGXo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:44:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38240 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752665Ab2JGXWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:10 -0400
Message-Id: <20121007225848.257482969@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 08 Oct 2012 00:00:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 098/108] ipv6: raw: fix icmpv6_filter()
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

[ Upstream commit 1b05c4b50edbddbdde715c4a7350629819f6655e ]

icmpv6_filter() should not modify its input, or else its caller
would need to recompute ipv6_hdr() if skb->head is reallocated.

Use skb_header_pointer() instead of pskb_may_pull() and
change the prototype to make clear both sk and skb are const.

Also, if icmpv6 header cannot be found, do not deliver the packet,
as we do in IPv4.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/raw.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 361ebf3..6e6c2c4 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -107,21 +107,20 @@ found:
  *	0 - deliver
  *	1 - block
  */
-static __inline__ int icmpv6_filter(struct sock *sk, struct sk_buff *skb)
+static int icmpv6_filter(const struct sock *sk, const struct sk_buff *skb)
 {
-	struct icmp6hdr *icmph;
-	struct raw6_sock *rp = raw6_sk(sk);
-
-	if (pskb_may_pull(skb, sizeof(struct icmp6hdr))) {
-		__u32 *data = &rp->filter.data[0];
-		int bit_nr;
+	struct icmp6hdr *_hdr;
+	const struct icmp6hdr *hdr;
 
-		icmph = (struct icmp6hdr *) skb->data;
-		bit_nr = icmph->icmp6_type;
+	hdr = skb_header_pointer(skb, skb_transport_offset(skb),
+				 sizeof(_hdr), &_hdr);
+	if (hdr) {
+		const __u32 *data = &raw6_sk(sk)->filter.data[0];
+		unsigned int type = hdr->icmp6_type;
 
-		return (data[bit_nr >> 5] & (1 << (bit_nr & 31))) != 0;
+		return (data[type >> 5] & (1U << (type & 31))) != 0;
 	}
-	return 0;
+	return 1;
 }
 
 #if defined(CONFIG_IPV6_MIP6) || defined(CONFIG_IPV6_MIP6_MODULE)


