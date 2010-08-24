Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933545Ab0HXXN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:13:28 -0400
Received: from kroah.org ([198.145.64.141]:41202 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933537Ab0HXXCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:52 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:07 2010
Message-Id: <20100824224507.063154747@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jarek Poplawski <jarkao2@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [067/114] net: Fix napi_gro_frags vs netpoll path
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

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
@@ -3064,7 +3064,7 @@ enum gro_result dev_gro_receive(struct n
 	int mac_len;
 	enum gro_result ret;
 
-	if (!(skb->dev->features & NETIF_F_GRO))
+	if (!(skb->dev->features & NETIF_F_GRO) || netpoll_rx_on(skb))
 		goto normal;
 
 	if (skb_is_gso(skb) || skb_has_frags(skb))
@@ -3151,9 +3151,6 @@ __napi_gro_receive(struct napi_struct *n
 {
 	struct sk_buff *p;
 
-	if (netpoll_rx_on(skb))
-		return GRO_NORMAL;
-
 	for (p = napi->gro_list; p; p = p->next) {
 		NAPI_GRO_CB(p)->same_flow =
 			(p->dev == skb->dev) &&


