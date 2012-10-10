Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab2JJWzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:55:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47880 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757481Ab2JJWzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:55:15 -0400
X-Sasl-enc: emjY0yufZxtQ7UAjv1rhsujd0vmRNQAShK6VYCsd2H8o 1349909714
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 053/133] ipv6: raw: fix icmpv6_filter()
Date: Thu, 11 Oct 2012 07:51:19 +0900
Message-Id: <20121010224904.057725542@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/raw.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

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
+	struct icmp6hdr *_hdr;
+	const struct icmp6hdr *hdr;
 
-	if (pskb_may_pull(skb, sizeof(struct icmp6hdr))) {
-		__u32 *data = &rp->filter.data[0];
-		int bit_nr;
+	hdr = skb_header_pointer(skb, skb_transport_offset(skb),
+				 sizeof(_hdr), &_hdr);
+	if (hdr) {
+		const __u32 *data = &raw6_sk(sk)->filter.data[0];
+		unsigned int type = hdr->icmp6_type;
 
-		icmph = (struct icmp6hdr *) skb->data;
-		bit_nr = icmph->icmp6_type;
-
-		return (data[bit_nr >> 5] & (1 << (bit_nr & 31))) != 0;
+		return (data[type >> 5] & (1U << (type & 31))) != 0;
 	}
-	return 0;
+	return 1;
 }
 
 #if defined(CONFIG_IPV6_MIP6) || defined(CONFIG_IPV6_MIP6_MODULE)


