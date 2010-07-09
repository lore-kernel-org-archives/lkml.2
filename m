Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab0GIRA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:00:59 -0400
Received: from llce437-z.servidoresdns.net ([82.223.199.149]:45111 "EHLO
	llce437-z.servidoresdns.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758018Ab0GIRA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:00:57 -0400
X-Greylist: delayed 1497 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jul 2010 13:00:57 EDT
Message-ID: <25524.83.175.223.254.1278693359.squirrel@mail.albentia.com>
Date: Fri, 9 Jul 2010 18:35:59 +0200 (CEST)
Subject: [PATCH 001/001] QoS and/or fair queueing: Stateless NAT BUG
From: rpartearroyo@albentia.com
To: "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: "Herbert Xu" <herbert@gondor.hengli.com.au>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Iratxo Pichel Ortiz" <ipichel@albentia.com>,
       Noelia =?iso-8859-1?Q?Mor=F3n?= <nmoron@albentia.com>,
       "netdev" <netdev@vger.kernel.org>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I have been testing Stateless NAT and found that ICMP packets with length
less than 20 bytes were not correctly NAT'ed. I have found a BUG that
makes taking into account IP header length twice, so ICMP packets smaller
than 20 bytes were being dropped.

Proposed formal patch is below, as suggested by Eric Dumazet, thanks.
It is taken from 2.6.34.1 stable version.

Signed-off-by: Rodrigo Partearroyo González <rpartearroyo@albentia.com>
---
diff -uprN a/net/sched/act_nat.c b/net/sched/act_nat.c
--- a/net/sched/act_nat.c    2010-07-09 18:25:18.000000000 +0200
+++ b/net/sched/act_nat.c 2010-07-09 18:26:16.000000000 +0200
@@ -202,7 +202,7 @@ static int tcf_nat(struct sk_buff *skb,
        {
                struct icmphdr *icmph;

-               if (!pskb_may_pull(skb, ihl + sizeof(*icmph) + sizeof(*iph)))
+               if (!pskb_may_pull(skb, ihl + sizeof(*icmph)))
                        goto drop;

                icmph = (void *)(skb_network_header(skb) + ihl);
@@ -223,7 +223,7 @@ static int tcf_nat(struct sk_buff *skb,

                if (skb_cloned(skb) &&
                    !skb_clone_writable(skb,
-                                       ihl + sizeof(*icmph) +
sizeof(*iph)) &&
+                                       ihl + sizeof(*icmph) ) &&
                    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
                        goto drop;
---

-- 
Rodrigo Partearroyo González

Albentia Systems S.A.
http://www.albentia.com

C\Margarita Salas 22
Parque Tecnológico de Leganés
Leganés (28918)
Madrid
Spain


