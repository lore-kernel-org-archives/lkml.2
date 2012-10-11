Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865Ab2JKCPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:15:02 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43319 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964831Ab2JKCO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:14:56 -0400
X-Sasl-enc: IOiWAyBndFdBeyeLhBdXCqoQoTR9EJK8+Y14ylKer5Zm 1349921695
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 33/84] ipv4: raw: fix icmp_filter()
Date: Thu, 11 Oct 2012 11:03:17 +0900
Message-Id: <20121011015423.040075667@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ab43ed8b7490cb387782423ecf74aeee7237e591 ]

icmp_filter() should not modify its input, or else its caller
would need to recompute ip_hdr() if skb->head is reallocated.

Use skb_header_pointer() instead of pskb_may_pull() and
change the prototype to make clear both sk and skb are const.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/raw.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -130,18 +130,20 @@ found:
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


