Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab0IXQiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:38:54 -0400
Received: from kroah.org ([198.145.64.141]:37421 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932784Ab0IXQfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:51 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:49 2010
Message-Id: <20100924163349.001540531@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [56/68] gro: Fix bogus gso_size on the first fraglist entry
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 622e0ca1cd4d459f5af4f2c65f4dc0dd823cb4c3 upstream.

When GRO produces fraglist entries, and the resulting skb hits
an interface that is incapable of TSO but capable of FRAGLIST,
we end up producing a bogus packet with gso_size non-zero.

This was reported in the field with older versions of KVM that
did not set the TSO bits on tuntap.

This patch fixes that.

Reported-by: Igor Zhang <yugzhang@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/skbuff.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2730,6 +2730,7 @@ int skb_gro_receive(struct sk_buff **hea
 	*NAPI_GRO_CB(nskb) = *NAPI_GRO_CB(p);
 	skb_shinfo(nskb)->frag_list = p;
 	skb_shinfo(nskb)->gso_size = pinfo->gso_size;
+	pinfo->gso_size = 0;
 	skb_header_release(p);
 	nskb->prev = p;
 


