Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1HNQIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:08:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab1HNQIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:08:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:56 2011
Message-Id: <20110812210556.055971663@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julian Anastasov <ja@ssi.bg>, "David S. Miller" <davem@davemloft.net>
Subject: [45/90] ipv4: fix the reusing of routing cache entries
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit d547f727df86059104af2234804fdd538e112015 ]

	compare_keys and ip_route_input_common rely on
rt_oif for distinguishing of input and output routes
with same keys values. But sometimes the input route has
also same hash chain (keyed by iif != 0) with the output
routes (keyed by orig_oif=0). Problem visible if running
with small number of rhash_entries.

	Fix them to use rt_route_iif instead. By this way
input route can not be returned to users that request
output route.

	The patch fixes the ip_rt_bug errors that were
reported in ip_local_out context, mostly for 255.255.255.255
destinations.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/route.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -726,6 +726,7 @@ static inline int compare_keys(struct rt
 		((__force u32)rt1->rt_key_src ^ (__force u32)rt2->rt_key_src) |
 		(rt1->rt_mark ^ rt2->rt_mark) |
 		(rt1->rt_key_tos ^ rt2->rt_key_tos) |
+		(rt1->rt_route_iif ^ rt2->rt_route_iif) |
 		(rt1->rt_oif ^ rt2->rt_oif) |
 		(rt1->rt_iif ^ rt2->rt_iif)) == 0;
 }
@@ -2282,8 +2283,8 @@ int ip_route_input_common(struct sk_buff
 		if ((((__force u32)rth->rt_key_dst ^ (__force u32)daddr) |
 		     ((__force u32)rth->rt_key_src ^ (__force u32)saddr) |
 		     (rth->rt_iif ^ iif) |
-		     rth->rt_oif |
 		     (rth->rt_key_tos ^ tos)) == 0 &&
+		    rt_is_input_route(rth) &&
 		    rth->rt_mark == skb->mark &&
 		    net_eq(dev_net(rth->dst.dev), net) &&
 		    !rt_is_expired(rth)) {


