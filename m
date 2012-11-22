Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab2KVWjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:39:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:49004 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab2KVSdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Torsten Luettgert <ml-netfilter@enda.eu>, Julian Anastasov <ja@ssi.bg>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 71/83] netfilter: xt_TEE: dont use destination address found in header
Date: Wed, 21 Nov 2012 16:42:33 -0800
Message-Id: <20121122004220.301768859@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit 2ad5b9e4bd314fc685086b99e90e5de3bc59e26b upstream.

Torsten Luettgert bisected TEE regression starting with commit
f8126f1d5136be1 (ipv4: Adjust semantics of rt->rt_gateway.)

The problem is that it tries to ARP-lookup the original destination
address of the forwarded packet, not the address of the gateway.

Fix this using FLOWI_FLAG_KNOWN_NH Julian added in commit
c92b96553a80c1 (ipv4: Add FLOWI_FLAG_KNOWN_NH), so that known
nexthop (info->gw.ip) has preference on resolving.

Reported-by: Torsten Luettgert <ml-netfilter@enda.eu>
Bisected-by: Torsten Luettgert <ml-netfilter@enda.eu>
Tested-by: Torsten Luettgert <ml-netfilter@enda.eu>
Cc: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/xt_TEE.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -70,6 +70,7 @@ tee_tg_route4(struct sk_buff *skb, const
 	fl4.daddr = info->gw.ip;
 	fl4.flowi4_tos = RT_TOS(iph->tos);
 	fl4.flowi4_scope = RT_SCOPE_UNIVERSE;
+	fl4.flowi4_flags = FLOWI_FLAG_KNOWN_NH;
 	rt = ip_route_output_key(net, &fl4);
 	if (IS_ERR(rt))
 		return false;


