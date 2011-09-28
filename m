Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab1I1XEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:04:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084Ab1I1WrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:47:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:44 2011
Message-Id: <20110928220144.426309780@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julian Anastasov <ja@ssi.bg>, "David S. Miller" <davem@davemloft.net>
Subject: [181/244] netfilter: TCP and raw fix for ip_route_me_harder
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 797fd3913abf2f7036003ab8d3d019cbea41affd ]

TCP in some cases uses different global (raw) socket
to send RST and ACK. The transparent flag is not set there.
Currently, it is a problem for rerouting after the previous
change.

	Fix it by simplifying the checks in ip_route_me_harder
and use FLOWI_FLAG_ANYSRC even for sockets. It looks safe
because the initial routing allowed this source address to
be used and now we just have to make sure the packet is rerouted.

	As a side effect this also allows rerouting for normal
raw sockets that use spoofed source addresses which was not possible
even before we eliminated the ip_route_input call.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/netfilter.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -18,17 +18,15 @@ int ip_route_me_harder(struct sk_buff *s
 	struct rtable *rt;
 	struct flowi4 fl4 = {};
 	__be32 saddr = iph->saddr;
-	__u8 flags = 0;
+	__u8 flags = skb->sk ? inet_sk_flowi_flags(skb->sk) : 0;
 	unsigned int hh_len;
 
-	if (!skb->sk && addr_type != RTN_LOCAL) {
-		if (addr_type == RTN_UNSPEC)
-			addr_type = inet_addr_type(net, saddr);
-		if (addr_type == RTN_LOCAL || addr_type == RTN_UNICAST)
-			flags |= FLOWI_FLAG_ANYSRC;
-		else
-			saddr = 0;
-	}
+	if (addr_type == RTN_UNSPEC)
+		addr_type = inet_addr_type(net, saddr);
+	if (addr_type == RTN_LOCAL || addr_type == RTN_UNICAST)
+		flags |= FLOWI_FLAG_ANYSRC;
+	else
+		saddr = 0;
 
 	/* some non-standard hacks like ipt_REJECT.c:send_reset() can cause
 	 * packets with foreign saddr to appear on the NF_INET_LOCAL_OUT hook.
@@ -38,7 +36,7 @@ int ip_route_me_harder(struct sk_buff *s
 	fl4.flowi4_tos = RT_TOS(iph->tos);
 	fl4.flowi4_oif = skb->sk ? skb->sk->sk_bound_dev_if : 0;
 	fl4.flowi4_mark = skb->mark;
-	fl4.flowi4_flags = skb->sk ? inet_sk_flowi_flags(skb->sk) : flags;
+	fl4.flowi4_flags = flags;
 	rt = ip_route_output_key(net, &fl4);
 	if (IS_ERR(rt))
 		return -1;


