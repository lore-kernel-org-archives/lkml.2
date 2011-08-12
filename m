Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab1HNQY0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:24:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36592 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198Ab1HNQID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:08:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:55 2011
Message-Id: <20110812210555.888174857@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [43/90] icmp: Fix regression in nexthop resolution during replies.
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 415b3334a21aa67806c52d1acf4e72e14f7f402f ]

icmp_route_lookup() uses the wrong flow parameters if the reverse
session route lookup isn't used.

So do not commit to the re-decoded flow until we actually make a
final decision to use a real route saved in 'rt2'.

Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/icmp.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -380,6 +380,7 @@ static struct rtable *icmp_route_lookup(
 					struct icmp_bxm *param)
 {
 	struct rtable *rt, *rt2;
+	struct flowi4 fl4_dec;
 	int err;
 
 	memset(fl4, 0, sizeof(*fl4));
@@ -408,19 +409,19 @@ static struct rtable *icmp_route_lookup(
 	} else
 		return rt;
 
-	err = xfrm_decode_session_reverse(skb_in, flowi4_to_flowi(fl4), AF_INET);
+	err = xfrm_decode_session_reverse(skb_in, flowi4_to_flowi(&fl4_dec), AF_INET);
 	if (err)
 		goto relookup_failed;
 
-	if (inet_addr_type(net, fl4->saddr) == RTN_LOCAL) {
-		rt2 = __ip_route_output_key(net, fl4);
+	if (inet_addr_type(net, fl4_dec.saddr) == RTN_LOCAL) {
+		rt2 = __ip_route_output_key(net, &fl4_dec);
 		if (IS_ERR(rt2))
 			err = PTR_ERR(rt2);
 	} else {
 		struct flowi4 fl4_2 = {};
 		unsigned long orefdst;
 
-		fl4_2.daddr = fl4->saddr;
+		fl4_2.daddr = fl4_dec.saddr;
 		rt2 = ip_route_output_key(net, &fl4_2);
 		if (IS_ERR(rt2)) {
 			err = PTR_ERR(rt2);
@@ -428,7 +429,7 @@ static struct rtable *icmp_route_lookup(
 		}
 		/* Ugh! */
 		orefdst = skb_in->_skb_refdst; /* save old refdst */
-		err = ip_route_input(skb_in, fl4->daddr, fl4->saddr,
+		err = ip_route_input(skb_in, fl4_dec.daddr, fl4_dec.saddr,
 				     RT_TOS(tos), rt2->dst.dev);
 
 		dst_release(&rt2->dst);
@@ -440,10 +441,11 @@ static struct rtable *icmp_route_lookup(
 		goto relookup_failed;
 
 	rt2 = (struct rtable *) xfrm_lookup(net, &rt2->dst,
-					    flowi4_to_flowi(fl4), NULL,
+					    flowi4_to_flowi(&fl4_dec), NULL,
 					    XFRM_LOOKUP_ICMP);
 	if (!IS_ERR(rt2)) {
 		dst_release(&rt->dst);
+		memcpy(fl4, &fl4_dec, sizeof(*fl4));
 		rt = rt2;
 	} else if (PTR_ERR(rt2) == -EPERM) {
 		if (rt)


