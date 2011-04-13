Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab1DMQTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:19:06 -0400
Received: from kroah.org ([198.145.64.141]:52979 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932932Ab1DMQNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:48 2011
Message-Id: <20110413161048.096055856@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:10:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Brandon Philips <bphilips@suse.de>
Subject: [53/71] gro: Reset dev pointer on reuse
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 66c46d741e2e60f0e8b625b80edb0ab820c46d7a upstream.

On older kernels the VLAN code may zero skb->dev before dropping
it and causing it to be reused by GRO.

Unfortunately we didn't reset skb->dev in that case which causes
the next GRO user to get a bogus skb->dev pointer.

This particular problem no longer happens with the current upstream
kernel due to changes in VLAN processing.

However, for correctness we should still reset the skb->dev pointer
in the GRO reuse function in case a future user does the same thing.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Brandon Philips <bphilips@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2746,6 +2746,7 @@ void napi_reuse_skb(struct napi_struct *
 {
 	__skb_pull(skb, skb_headlen(skb));
 	skb_reserve(skb, NET_IP_ALIGN - skb_headroom(skb));
+	skb->dev = napi->dev;
 
 	napi->skb = skb;
 }


