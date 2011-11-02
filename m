Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab1KCB57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:57:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51115 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933296Ab1KCBjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:39:53 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:40 2011
Message-Id: <20111102222740.418720371@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:25:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Apollon Oikonomopoulos <apoikos@gmail.com>,
        Faidon Liambotis <paravoid@debian.org>
Subject: [008/101] ipv6: Add GSO support on forwarding path
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 0aa68271510ae2b221d4b60892103837be63afe4 upstream.

Currently we disallow GSO packets on the IPv6 forward path.
This patch fixes this.

Note that I discovered that our existing GSO MTU checks (e.g.,
IPv4 forwarding) are buggy in that they skip the check altogether,
when they really should be checking gso_size + header instead.

I have also been lazy here in that I haven't bothered to segment
the GSO packet by hand before generating an ICMP message.  Someone
should add that to be 100% correct.

Reported-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Apollon Oikonomopoulos <apoikos@gmail.com>
Signed-off-by: Faidon Liambotis <paravoid@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/ip6_output.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -509,7 +509,7 @@ int ip6_forward(struct sk_buff *skb)
 		}
 	}
 
-	if (skb->len > dst_mtu(dst)) {
+	if (skb->len > dst_mtu(dst) && !skb_is_gso(skb)) {
 		/* Again, force OUTPUT device used as source address */
 		skb->dev = dst->dev;
 		icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, dst_mtu(dst), skb->dev);


