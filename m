Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab0HXXbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:31:37 -0400
Received: from kroah.org ([198.145.64.141]:40503 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932998Ab0HXW7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:59:16 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:17 2010
Message-Id: <20100824224217.049794609@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jarek Poplawski <jarkao2@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [58/91] net: Fix napi_gro_frags vs netpoll path
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Jarek Poplawski <jarkao2@gmail.com>

[ Upstream commit ce9e76c8450fc248d3e1fc16ef05e6eb50c02fa5 ]

The netpoll_rx_on() check in __napi_gro_receive() skips part of the
"common" GRO_NORMAL path, especially "pull:" in dev_gro_receive(),
where at least eth header should be copied for entirely paged skbs.

Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/dev.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2666,7 +2666,7 @@ enum gro_result dev_gro_receive(struct n
 	int mac_len;
 	enum gro_result ret;
 
-	if (!(skb->dev->features & NETIF_F_GRO))
+	if (!(skb->dev->features & NETIF_F_GRO) || netpoll_rx_on(skb))
 		goto normal;
 
 	if (skb_is_gso(skb) || skb_has_frags(skb))
@@ -2753,9 +2753,6 @@ __napi_gro_receive(struct napi_struct *n
 {
 	struct sk_buff *p;
 
-	if (netpoll_rx_on(skb))
-		return GRO_NORMAL;
-
 	for (p = napi->gro_list; p; p = p->next) {
 		NAPI_GRO_CB(p)->same_flow =
 			(p->dev == skb->dev) &&


