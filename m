Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1HFAIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:08:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab1HFAIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:08:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:49 2011
Message-Id: <20110806000249.365565559@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:01:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [05/55] gro: Only reset frag0 when skb can be pulled
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 17dd759c67f21e34f2156abcf415e1f60605a188 upstream.

Currently skb_gro_header_slow unconditionally resets frag0 and
frag0_len.  However, when we can't pull on the skb this leaves
the GRO fields in an inconsistent state.

This patch fixes this by only resetting those fields after the
pskb_may_pull test.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/netdevice.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1164,9 +1164,12 @@ static inline int skb_gro_header_hard(st
 static inline void *skb_gro_header_slow(struct sk_buff *skb, unsigned int hlen,
 					unsigned int offset)
 {
+	if (!pskb_may_pull(skb, hlen))
+		return NULL;
+
 	NAPI_GRO_CB(skb)->frag0 = NULL;
 	NAPI_GRO_CB(skb)->frag0_len = 0;
-	return pskb_may_pull(skb, hlen) ? skb->data + offset : NULL;
+	return skb->data + offset;
 }
 
 static inline void *skb_gro_mac_header(struct sk_buff *skb)


