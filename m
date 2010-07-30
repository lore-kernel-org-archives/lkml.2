Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225Ab0G3S5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:57:12 -0400
Received: from kroah.org ([198.145.64.141]:35409 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759116Ab0G3Rdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:33:49 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:03 2010
Message-Id: <20100730173103.087132502@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:29:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [003/140] gro: Fix bogus gso_size on the first fraglist entry
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 622e0ca1cd4d459f5af4f2c65f4dc0dd823cb4c3 ]

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
@@ -2729,6 +2729,7 @@ int skb_gro_receive(struct sk_buff **hea
 	*NAPI_GRO_CB(nskb) = *NAPI_GRO_CB(p);
 	skb_shinfo(nskb)->frag_list = p;
 	skb_shinfo(nskb)->gso_size = pinfo->gso_size;
+	pinfo->gso_size = 0;
 	skb_header_release(p);
 	nskb->prev = p;
 


