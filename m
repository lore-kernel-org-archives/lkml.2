Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab1I1WrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:47:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933022Ab1I1Wq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:46:57 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:44 2011
Message-Id: <20110928220144.093526818@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julian Anastasov <ja@ssi.bg>, "David S. Miller" <davem@davemloft.net>
Subject: [178/244] ipv4: some rt_iif -> rt_route_iif conversions
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 97a804102021431fa6fa33c21c85df762b0f5cb9 ]

As rt_iif represents input device even for packets
coming from loopback with output route, it is not an unique
key specific to input routes. Now rt_route_iif has such role,
it was fl.iif in 2.6.38, so better to change the checks at
some places to save CPU cycles and to restore 2.6.38 semantics.

compare_keys:
	- input routes: only rt_route_iif matters, rt_iif is same
	- output routes: only rt_oif matters, rt_iif is not
		used for matching in __ip_route_output_key
	- now we are back to 2.6.38 state

ip_route_input_common:
	- matching rt_route_iif implies input route
	- compared to 2.6.38 we eliminated one rth->fl.oif check
	because it was not needed even for 2.6.38

compare_hash_inputs:
	Only the change here is not an optimization, it has
	effect only for output routes. I assume I'm restoring
	the original intention to ignore oif, it was using fl.iif
	- now we are back to 2.6.38 state

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/route.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -717,7 +717,7 @@ static inline bool compare_hash_inputs(c
 {
 	return ((((__force u32)rt1->rt_key_dst ^ (__force u32)rt2->rt_key_dst) |
 		((__force u32)rt1->rt_key_src ^ (__force u32)rt2->rt_key_src) |
-		(rt1->rt_iif ^ rt2->rt_iif)) == 0);
+		(rt1->rt_route_iif ^ rt2->rt_route_iif)) == 0);
 }
 
 static inline int compare_keys(struct rtable *rt1, struct rtable *rt2)
@@ -727,8 +727,7 @@ static inline int compare_keys(struct rt
 		(rt1->rt_mark ^ rt2->rt_mark) |
 		(rt1->rt_key_tos ^ rt2->rt_key_tos) |
 		(rt1->rt_route_iif ^ rt2->rt_route_iif) |
-		(rt1->rt_oif ^ rt2->rt_oif) |
-		(rt1->rt_iif ^ rt2->rt_iif)) == 0;
+		(rt1->rt_oif ^ rt2->rt_oif)) == 0;
 }
 
 static inline int compare_netns(struct rtable *rt1, struct rtable *rt2)
@@ -2282,9 +2281,8 @@ int ip_route_input_common(struct sk_buff
 	     rth = rcu_dereference(rth->dst.rt_next)) {
 		if ((((__force u32)rth->rt_key_dst ^ (__force u32)daddr) |
 		     ((__force u32)rth->rt_key_src ^ (__force u32)saddr) |
-		     (rth->rt_iif ^ iif) |
+		     (rth->rt_route_iif ^ iif) |
 		     (rth->rt_key_tos ^ tos)) == 0 &&
-		    rt_is_input_route(rth) &&
 		    rth->rt_mark == skb->mark &&
 		    net_eq(dev_net(rth->dst.dev), net) &&
 		    !rt_is_expired(rth)) {


