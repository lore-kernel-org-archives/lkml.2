Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969Ab0IXQsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:48:37 -0400
Received: from kroah.org ([198.145.64.141]:37053 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932919Ab0IXQe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:34:56 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:44 2010
Message-Id: <20100924163344.793469615@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:31:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [09/68] bridge: Clear IPCB before possible entry into IP stack
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 17762060c25590bfddd68cc1131f28ec720f405f ]

The bridge protocol lives dangerously by having incestuous relations
with the IP stack.  In this instance an abomination has been created
where a bogus IPCB area from a bridged packet leads to a crash in
the IP stack because it's interpreted as IP options.

This patch papers over the problem by clearing the IPCB area in that
particular spot.  To fix this properly we'd also need to parse any
IP options if present but I'm way too lazy for that.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bridge/br_netfilter.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -600,6 +600,9 @@ static unsigned int br_nf_pre_routing(un
 
 	pskb_trim_rcsum(skb, len);
 
+	/* BUG: Should really parse the IP options here. */
+	memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
+
 	nf_bridge_put(skb->nf_bridge);
 	if (!nf_bridge_alloc(skb))
 		return NF_DROP;


