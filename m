Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933854Ab2JKC0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:26:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45929 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933397Ab2JKCMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:12:46 -0400
X-Sasl-enc: 0imZhhBJHB3bBzZqkuTfgHD32QKZ/BmZdVPrvqQUmpxI 1349921565
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 31/84] net: small bug on rxhash calculation
Date: Thu, 11 Oct 2012 11:03:15 +0900
Message-Id: <20121011015422.685723751@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Chema Gonzalez <chema@google.com>

[ Upstream commit 6862234238e84648c305526af2edd98badcad1e0 ]

In the current rxhash calculation function, while the
sorting of the ports/addrs is coherent (you get the
same rxhash for packets sharing the same 4-tuple, in
both directions), ports and addrs are sorted
independently. This implies packets from a connection
between the same addresses but crossed ports hash to
the same rxhash.

For example, traffic between A=S:l and B=L:s is hashed
(in both directions) from {L, S, {s, l}}. The same
rxhash is obtained for packets between C=S:s and D=L:l.

This patch ensures that you either swap both addrs and ports,
or you swap none. Traffic between A and B, and traffic
between C and D, get their rxhash from different sources
({L, S, {l, s}} for A<->B, and {L, S, {s, l}} for C<->D)

The patch is co-written with Eric Dumazet <edumazet@google.com>

Signed-off-by: Chema Gonzalez <chema@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2559,16 +2559,17 @@ __u32 __skb_get_rxhash(struct sk_buff *s
 	poff = proto_ports_offset(ip_proto);
 	if (poff >= 0) {
 		nhoff += ihl * 4 + poff;
-		if (pskb_may_pull(skb, nhoff + 4)) {
+		if (pskb_may_pull(skb, nhoff + 4))
 			ports.v32 = * (__force u32 *) (skb->data + nhoff);
-			if (ports.v16[1] < ports.v16[0])
-				swap(ports.v16[0], ports.v16[1]);
-		}
 	}
 
 	/* get a consistent hash (same value on both flow directions) */
-	if (addr2 < addr1)
+	if (addr2 < addr1 ||
+	    (addr2 == addr1 &&
+	     ports.v16[1] < ports.v16[0])) {
 		swap(addr1, addr2);
+		swap(ports.v16[0], ports.v16[1]);
+	}
 
 	hash = jhash_3words(addr1, addr2, ports.v32, hashrnd);
 	if (!hash)


