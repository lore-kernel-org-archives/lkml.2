Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab0HaFU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 01:20:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53861 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab0HaFUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 01:20:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=owXserQDV6lU0KnM2Agkt81PtBpL7cLGNGYh4Xg4GEJSeo71J3iYrUwyItfVX1dYsG
         fQzV8EFIAtdumZGr54XoE4NwPUfRjy7C4KPwSXD924524UcKoJUekvfrVMkw6ms0JoJJ
         cLRFYWXjISrow3V8/uHeeyxkRnixFu7q2IcAk=
Subject: Re: [PATCH net-next-2.6] net/ipv4: push IP options to CB in
 ip_fragment
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Bandan Das <bandan.das@stratus.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: David Miller <davem@davemloft.net>, NetDev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Patrick McHardy <kaber@trash.net>
In-Reply-To: <20100830232147.GB10754@stratus.com>
References: <20100830200917.GA10754@stratus.com>
	 <1283204118.2405.32.camel@edumazet-laptop>
	 <20100830232147.GB10754@stratus.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 07:20:31 +0200
Message-ID: <1283232031.2405.38.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 30 août 2010 à 19:21 -0400, Bandan Das a écrit :
> > 
> > I wonder if we want this.
> > 
> > Maybe setting skb->local_df = 1 in bridge should be enough ?
> > 
> > 
> Thanks Eric for looking at this. Indeed, setting local_df to 1 seems to be enough! I will
> respin and post a different patch.
> 

Reading this stuff again, I wonder if we should not revert commit
17762060c25590bfddd  and use a different trick

Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Mon Jul 5 21:29:28 2010 +0000

    bridge: Clear IPCB before possible entry into IP stack
    
    The bridge protocol lives dangerously by having incestuous relations
    with the IP stack.  In this instance an abomination has been created
    where a bogus IPCB area from a bridged packet leads to a crash in
    the IP stack because it's interpreted as IP options.
    
    This patch papers over the problem by clearing the IPCB area in that
    particular spot.  To fix this properly we'd also need to parse any
    IP options if present but I'm way too lazy for that.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
    Signed-off-by: David S. Miller <davem@davemloft.net>


We could have a padding in front of struct br_input_skb_cb to make sure
we dont overwrite IP (4|6) CB in bridge ?

Something like this untested patch :

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 2c911c0..9fdf1b1 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -598,9 +598,6 @@ static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff *skb,
 
 	pskb_trim_rcsum(skb, len);
 
-	/* BUG: Should really parse the IP options here. */
-	memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
-
 	nf_bridge_put(skb->nf_bridge);
 	if (!nf_bridge_alloc(skb))
 		return NF_DROP;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 75c90ed..b27163a 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -18,6 +18,7 @@
 #include <linux/netpoll.h>
 #include <linux/u64_stats_sync.h>
 #include <net/route.h>
+#include <linux/ipv6.h>
 
 #define BR_HASH_BITS 8
 #define BR_HASH_SIZE (1 << BR_HASH_BITS)
@@ -244,6 +245,8 @@ struct net_bridge
 };
 
 struct br_input_skb_cb {
+	struct inet6_skb_parm pad;
+
 	struct net_device *brdev;
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 	int igmp;


